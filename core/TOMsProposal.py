#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock/Matthias Kuhn 2017

from qgis.PyQt.QtCore import (
    QObject,
    QDate,
    pyqtSignal
)

from qgis.PyQt.QtWidgets import (
    QMessageBox,
    QAction
)

from qgis.core import (
    QgsMessageLog, QgsFeature, QgsGeometry,
    QgsFeatureRequest,
    QgsRectangle, QgsExpression
)

from ..proposalTypeUtilsClass import ProposalTypeUtilsMixin

#from .TOMsProposalElement import *
# from ..core.TOMsTile import (TOMsTile)

from ..constants import (
    ProposalStatus,
    RestrictionAction,
    RestrictionLayers
)

class TOMsProposal(ProposalTypeUtilsMixin, QObject):
    def __init__(self, proposalsManager, proposalNr=None):
        QObject.__init__(self)
        QgsMessageLog.logMessage("In TOMsProposal:init. ... ", tag="TOMs panel")
        self.proposalsManager = proposalsManager
        self.tableNames = self.proposalsManager.tableNames

        self.setProposalsLayer()

        QgsMessageLog.logMessage("In TOMsProposal:init. ... proposals layer set ", tag="TOMs panel")

        if proposalNr is not None:
            self.setProposal(proposalNr)


    def setProposalsLayer(self):
        self.proposalsLayer = self.tableNames.setLayer("Proposals")

        if self.proposalsLayer is None:
            QgsMessageLog.logMessage("In TOMsProposal:setProposalsLayer. Proposals layer NOT set !!!", tag="TOMs panel")
            return False
        else:
            idxProposalID = self.proposalsLayer.fields().indexFromName("ProposalID")
            self.idxProposalTitle = self.proposalsLayer.fields().indexFromName("ProposalTitle")
            self.idxCreateDate = self.proposalsLayer.fields().indexFromName("ProposalCreateDate")
            self.idxOpenDate = self.proposalsLayer.fields().indexFromName("ProposalOpenDate")
            self.idxProposalStatusID = self.proposalsLayer.fields().indexFromName("ProposalStatusID")

        QgsMessageLog.logMessage("In TOMsProposal:setProposalsLayer... ", tag="TOMs panel")

    def setProposal(self, proposalID):

        self.thisProposalNr = proposalID
        self.setProposalsLayer()

        if (proposalID is not None):
            query = '\"ProposalID\" = {proposalID}'.format(proposalID=proposalID)
            request = QgsFeatureRequest().setFilterExpression(query)
            for proposal in self.proposalsLayer.getFeatures(request):
                self.thisProposal = proposal  # make assumption that only one row
                return True

        return False # either not found or 0

    def initialiseProposal(self):

        self.thisProposal = QgsFeature(self.proposalsLayer.fields())
        self.thisProposal.setGeometry(QgsGeometry())
        #self.proposalsLayer.addFeature(self.thisProposal)  # TH (added for v3)

        """self.setProposalTitle('')   #str(uuid.uuid4())
        self.setProposalOpenDate = self.proposalsManager.date()
        self.setProposalCreateDate = self.proposalsManager.date()
        self.setProposalStatusID = ProposalStatus.IN_PREPARATION"""

        self.thisProposal[self.idxProposalTitle] = ''   #str(uuid.uuid4())
        self.thisProposal[self.idxCreateDate] = self.proposalsManager.date()
        self.thisProposal[self.idxOpenDate] = self.proposalsManager.date()
        self.thisProposal[self.idxProposalStatusID] = ProposalStatus.IN_PREPARATION

        self.proposalsLayer.addFeature(self.thisProposal)  # TH (added for v3)

        QgsMessageLog.logMessage(
            "In TOMsProposal:createProposal - attributes: (fid=" + str(self.thisProposal.id()) + ") " + str(
                self.thisProposal.attributes()),
            tag="TOMs panel")

        return self

    def getProposal(self):
        return self

    def getProposalRecord(self):
        return self.thisProposal

    def getProposalNr(self):
        return self.thisProposalNr

    def getProposalTitle(self):
        return self.thisProposal.attribute("ProposalTitle")

    def setProposalTitle(self, value):
        return self.thisProposal.setAttribute("ProposalTitle", value)

    def getProposalStatusID(self):
        return self.thisProposal.attribute("ProposalStatusID")

    def setProposalStatusID(self, value):
        return self.thisProposal.setAttribute("ProposalStatusID", value)

    def getProposalOpenDate(self):
        return self.thisProposal.attribute("ProposalOpenDate")

    def setProposalOpenDate(self, value):
        return self.thisProposal.setAttribute("ProposalOpenDate", value)

    def getProposalCreateDate(self):
        return self.thisProposal.attribute("ProposalCreateDate")

    def setProposalCreateDate(self, value):
        return self.thisProposal.setAttribute("ProposalCreateDate", value)

    def createNewProposal(self):  # TODO:
        pass

    def acceptProposal(self):

        currProposalID = self.thisProposalNr
        QgsMessageLog.logMessage("In TOMsProposal.acceptProposal - " + str(self.thisProposalNr), tag="TOMs panel")

        """ Steps in acceptance are:
        1. Set new open/close dates for restrictions ( remember to clear filter )
        2. update revision numbers for tiles
        3. update Proposal details
        """

        if self.thisProposalNr > 0:  # need to consider a proposal

            for (currlayerID, currlayerName) in self.getRestrictionLayersList():
                currLayer = self.tableNames.setLayer(currlayerName)

                restrictionList = []
                restrictionList = self.__getRestrictionsInProposalForLayerForAction(currlayerID)

                # clear filter
                currFilter = self.tableNames.setLayer(currlayerName).subsetString()
                self.tableNames.setLayer(currlayerName).setSubsetString('')

                for currRestrictionID, currRestrictionInProposalDetails in restrictionList:
                    currRestrictionInProposal = TOMsProposalElement(self.proposalsManager, currlayerID, None, currRestrictionID)
                    status = currRestrictionInProposal.acceptActionOnProposalElement(currRestrictionInProposalDetails.attribute("ActionOnProposalAcceptance")) # Finding the correct action could go to ProposalElement
                    if status == False:
                        QgsMessageLog.logMessage(
                            "In TOMsProposal:acceptProposal. " + str(
                                currRestrictionID) + " error on Action",
                            tag="TOMs panel")
                        return status

            # Now update tile revision nrs
            QgsMessageLog.logMessage("In TOMsProposal:acceptProposal. Updating tile revision nrs",
                tag="TOMs panel")
            proposalTileDictionary = self.getProposalTileDictionaryForDate()

            for tileNr, tile in proposalTileDictionary.items():
                QgsMessageLog.logMessage("In TOMsProposal.acceptProposal: current tile " + str(tile["id"]) + " current RevisionNr: " + str(
                    tile["RevisionNr"]) + " RevisionDate: " + str(tile["LastRevisionDate"]), tag="TOMs panel")
                currTile = TOMsTile(self.proposalsManager, tileNr)
                status = currTile.updateTileRevisionNr(currProposalID)
                if status == False:
                    QgsMessageLog.logMessage(
                        "In TOMsProposal:acceptProposal. " + str(
                            tileNr) + " error updating tile revision details",
                        tag="TOMs panel")
                    return status

            # Now update Proposal
            status = self.setProposalStatusID(ProposalStatus.ACCEPTED)

            #self.proposalsManager.newProposalCreated.emit(0)

        pass

    def rejectProposal(self):

        QgsMessageLog.logMessage("In TOMsProposal.rejectProposal - " + str(self.thisProposalNr), tag="TOMs panel")
        status = self.setProposalStatusID(ProposalStatus.REJECTED)

        if status:
            QgsMessageLog.logMessage("In TOMsProposal.rejectProposal.  Proposal Rejected ... ", tag="TOMs panel")
            #self.proposalsManager.newProposalCreated.emit(0)

        return status

    def getRestrictionsToOpenForLayer(self, layer):
        return self.__getRestrictionsListForLayerForAction(layer, RestrictionAction.OPEN)

    def getRestrictionsToCloseForLayer(self, layer):
        return self.__getRestrictionsListForLayerForAction(layer, RestrictionAction.CLOSE)

    def __getRestrictionsListForLayerForAction(self, layer, actionOnAcceptance=None):
        restrictionList = self.__getRestrictionsInProposalForLayerForAction(layer, actionOnAcceptance)
        return ",".join("'{restrictionID}'".format(restrictionID=restrictionID) for restrictionID,_ in restrictionList)

    def __getRestrictionsInProposalForLayerForAction(self, layerID, actionOnAcceptance=None):
        # Will return a list of restrictions within a Proposal subject to actionOnAcceptance

        self.RestrictionsInProposalsLayer = self.tableNames.setLayer("RestrictionsInProposals")

        query = ("\"ProposalID\" = {proposalID} AND \"RestrictionTableID\" = {layerID}").format(proposalID= str(self.thisProposalNr), layerID=str(layerID))

        if actionOnAcceptance is not None:
            query = ("{query} AND \"ActionOnProposalAcceptance\" = {actionOnAcceptance}").format(query=query, actionOnAcceptance=str(actionOnAcceptance))

        QgsMessageLog.logMessage("In __getRestrictionsInProposalForLayerForAction. query: " + str(query), tag="TOMs panel")
        request = QgsFeatureRequest().setFilterExpression(query)

        restrictionList = []
        for restrictionInProposalDetails in self.RestrictionsInProposalsLayer.getFeatures(request):
            restrictionList.append([restrictionInProposalDetails["RestrictionID"], restrictionInProposalDetails])

        return restrictionList

    def getProposalBoundingBox(self):

        # Need to remember that filters are in operation, so need to ensure that Restriction features are available
        QgsMessageLog.logMessage("In getProposalBoundingBox.", tag="TOMs panel")
        currProposalID = self.thisProposalNr
        geometryBoundingBox = QgsRectangle()

        if currProposalID > 0:  # need to consider a proposal

            for (layerID, layerName) in self.getRestrictionLayersList():
                currLayer = self.tableNames.setLayer(layerName)
                restrictionStr = self.__getRestrictionsListForLayerForAction(layerID)
                #QgsMessageLog.logMessage("In getProposalBoundingBox. (" + layerName + ") request:" + restrictionStr, tag="TOMs panel")

                #currLayer.blockSignals(True)
                # unset filter to get geometries of closed features
                layerFilterString = currLayer.subsetString()
                QgsMessageLog.logMessage("In getProposalBoundingBox. (" + layerName + ") filter 1:" + layerFilterString, tag="TOMs panel")
                currLayer.setSubsetString(None)

                query = '"RestrictionID" IN ({restrictions})'.format(restrictions=restrictionStr)

                request = QgsFeatureRequest().setFilterExpression(query)
                for currRestriction in currLayer.getFeatures(request):
                    geometryBoundingBox.combineExtentWith(currRestriction.geometry().boundingBox())

                currLayer.setSubsetString(layerFilterString)
                #currLayer.blockSignals(False)
                QgsMessageLog.logMessage("In getProposalBoundingBox. (" + currLayer.name() + ") filter 1:" + currLayer.subsetString(), tag="TOMs panel")

        return geometryBoundingBox

    def getProposalTileDictionaryForDate(self, revisionDate=None):

        if not revisionDate:
            revisionDate = self.proposalsManager.date()

        # returns list of tiles in the proposal and their current revision numbers
        QgsMessageLog.logMessage("In TOMsProposal.getProposalTileDictionaryForDate. considering Proposal: " + str (self.getProposalNr()) + " for " + str(revisionDate), tag="TOMs panel")
        dictTilesInProposal = dict()

        # Logic is:
        #Loop through each map tile
        #    Check whether or not there are any currently open restrictions within it

        if self.getProposalNr() > 0:  # need to consider a proposal

            # loop through all the layers that might have restrictions
            for (layerID, layerName) in self.getRestrictionLayersList():

                # clear filter
                currFilter = self.tableNames.setLayer(layerName).subsetString()
                self.tableNames.setLayer(layerName).setSubsetString('')

                for (currRestrictionID, restrictionInProposalObject) in self.__getRestrictionsInProposalForLayerForAction(layerID):

                    currRestriction = ProposalElementFactory.getProposalElement(self.proposalsManager, layerID, None, currRestrictionID)
                    dictTilesInProposal.update(currRestriction.getTilesForRestriction(revisionDate))

                # reset filter
                self.tableNames.setLayer(layerName).setSubsetString(currFilter)

        else:

            """
            # *** Unfortunately, this takes too long ... best to just look at Tiles and check current versions   ***
            
            # loop through all the layers that might have restrictions

            for (layerID, layerName) in self.getRestrictionLayersList():

                # clear filter
                currFilter = self.tableNames.setLayer(layerName).subsetString()
                self.tableNames.setLayer(layerName).setSubsetString('')

                for (currRestrictionID, currRestriction) in self.proposalsManager.getCurrentRestrictionsForLayerAtDate(layerID, revisionDate):

                    currRestriction = ProposalElementFactory.getProposalElement(self.proposalsManager, layerID, None, currRestrictionID)
                    dictTilesInProposal.update(currRestriction.getTilesForRestriction(revisionDate))

                # reset filter
                self.tableNames.setLayer(layerName).setSubsetString(currFilter)"""

            currTileObject = TOMsTile(self.proposalsManager)
            for currTileRecord in self.tableNames.setLayer("MapGrid").getFeatures():

                QgsMessageLog.logMessage("In TOMsProposal.getProposalTileDictionaryForDate. Current. Tile: " + str(currTileRecord.attribute("id")), tag="TOMs panel")

                status = currTileObject.setTile(currTileRecord.attribute("id"))
                lastRevisionNr, lastProposalOpendate = currTileObject.getTileRevisionNrAtDate(revisionDate)

                if lastRevisionNr is not None:   # the assumption is that tiles without restrictions have a NULL revision number
                    dictTilesInProposal[currTileObject.thisTileNr] = currTileRecord

        for tileNr, tile in dictTilesInProposal.items():
            QgsMessageLog.logMessage("In TOMsProposal.getProposalTileDictionaryForDate: " + str(tile["id"]) + " RevisionNr: " + str(tile["RevisionNr"]) + " RevisionDate: " + str(tile["LastRevisionDate"]), tag="TOMs panel")

        return dictTilesInProposal

    def updateTileRevisionNrsInProposal(self, dictTilesInProposal):

        QgsMessageLog.logMessage("In TOMsProposal:updateTileRevisionNrsInProposal.", tag="TOMs panel")
        # Increment the relevant tile numbers

        currRevisionDate = self.getProposalOpenDate()

        MapGridLayer = self.tableNames.setLayer("MapGrid")
        TilesInAcceptedProposalsLayer = self.tableNames.setLayer("TilesInAcceptedProposals")

        # self.getProposalTileList(currProposalID, currRevisionDate)

        currTile = TOMsTile(self.proposalsManager)
        for tileNr, tile in dictTilesInProposal.items():
            status = currTile.setTile(tileNr)

            #  TODO: Create a tile object and have increment method ...

            lastRevisionNr, lastProposalOpendate = currTile.getTileRevisionNrAtDate(currRevisionDate)
            currRevisionNr = currTile["RevisionNr"]
            QgsMessageLog.logMessage("In updateTileRevisionNrs. tile" + str (tileNr) + " currRevNr: " + str(currRevisionNr), tag="TOMs panel")
            if currRevisionNr is None:
                MapGridLayer.changeAttributeValue(currTile.id(),MapGridLayer.fields().indexFromName("RevisionNr"), 1)
            else:
                MapGridLayer.changeAttributeValue(currTile.id(), MapGridLayer.fields().indexFromName("RevisionNr"), currRevisionNr + 1)

            MapGridLayer.changeAttributeValue(currTile.id(), MapGridLayer.fields().indexFromName("LastRevisionDate"), self.getProposalOpenDate())

            # Now need to add the details of this tile to "TilesWithinAcceptedProposals" (including revision numbers at time of acceptance)

            newRecord = QgsFeature(TilesInAcceptedProposalsLayer.fields())

            idxProposalID = TilesInAcceptedProposalsLayer.fields().indexFromName("ProposalID")
            idxTileNr = TilesInAcceptedProposalsLayer.fields().indexFromName("TileNr")
            idxRevisionNr = TilesInAcceptedProposalsLayer.fields().indexFromName("RevisionNr")

            newRecord[idxProposalID]= self.thisProposalNr()
            newRecord[idxTileNr]= tileNr
            newRecord[idxRevisionNr]= currRevisionNr + 1
            newRecord.setGeometry(QgsGeometry())

            status = TilesInAcceptedProposalsLayer.addFeature(newRecord)

            if not status:
                return status

            # TODO: Check return status from add
        return status

class TOMsTile(QObject):
    def __init__(self, proposalsManager, tileNr=None):
        QObject.__init__(self)

        self.proposalsManager = proposalsManager
        self.tableNames = self.proposalsManager.tableNames

        self.setTilesLayer()

        if tileNr is not None:
            self.setTile(tileNr)

    def setTilesLayer(self):
        self.tilesLayer = self.tableNames.setLayer("MapGrid")
        if self.tilesLayer is None:
            QgsMessageLog.logMessage("In TOMsProposal:setTilesLayer. tilesLayer layer NOT set !!!", tag="TOMs panel")
        else:
            self.tileLayerFields = self.tilesLayer.fields()
            self.idxTileNr = self.tilesLayer.fields().indexFromName("id")
            self.idxRevisionNr = self.tilesLayer.fields().indexFromName("RevisionNr")
            self.idxLastRevisionDate = self.tilesLayer.fields().indexFromName("LastRevisionDate")
        QgsMessageLog.logMessage("In TOMsProposal:setTilesLayer... MapGrid ", tag="TOMs panel")

        self.tilesInAcceptedProposalsLayer = self.tableNames.setLayer("TilesInAcceptedProposals")
        if self.tilesInAcceptedProposalsLayer is None:
            QgsMessageLog.logMessage("In TOMsProposal:setTilesLayer. tilesInAcceptedProposalsLayer layer NOT set !!!", tag="TOMs panel")
        QgsMessageLog.logMessage("In TOMsProposal:setTilesLayer... tilesInAcceptedProposalsLayer ", tag="TOMs panel")

    def setTile(self, tileNr):

        self.thisTileNr = tileNr

        if self.tilesLayer is None:
            self.setTilesLayer()

        if (tileNr is not None):
            query = '\"id\" = {tileNr}'.format(tileNr=tileNr)
            request = QgsFeatureRequest().setFilterExpression(query)
            for tile in self.tilesLayer.getFeatures(request):
                self.thisTile = tile  # make assumption that only one row
                #self.thisTile.setFields(self.tileLayerFields)
                QgsMessageLog.logMessage("In TOMsProposal:setTile... tile found ",
                                         tag="TOMs panel")
                return True

        QgsMessageLog.logMessage("In TOMsProposal:setTile... tile NOT found ",
                                         tag="TOMs panel")
        return False # either not found or 0

    def tile(self):
        return self

    def tileNr(self):
        return self.thisTileNr

    def revisionNr(self):
        return self.thisTile.attribute("RevisionNr")

    def setRevisionNr(self, value):
        QgsMessageLog.logMessage("In TOMsTile:setRevisionNr newRevisionNr: " + str(value), tag="TOMs panel")
        #self.thisTile[self.idxRevisionNr] = value
        self.tilesLayer.changeAttributeValue(self.thisTile.id(), self.idxRevisionNr, value)
        #return self.thisTile.setAttribute("RevisionNr", value)

    def lastRevisionDate(self):
        return self.thisTile[self.idxLastRevisionDate]

    def setLastRevisionDate(self, value):
        #self.thisTile[self.idxLastRevisionDate] = value
        self.tilesLayer.changeAttributeValue(self.thisTile.id(), self.idxLastRevisionDate, value)
        #return self.thisTile.setAttribute("LastRevisionDate", value)

    def getTileRevisionNrAtDate(self, filterDate=None):

        QgsMessageLog.logMessage("In TOMsTile:getTileRevisionNrAtDate.", tag="TOMs panel")

        if filterDate is None:
            filterDate = self.proposalsManager.date()

        #query2 = '"tile" = \'{tileid}\''.format(tileid=currTile)

        queryString = "\"TileNr\" = " + str(self.thisTileNr)

        QgsMessageLog.logMessage("In getTileRevisionNrAtDate: queryString: " + str(queryString), tag="TOMs panel")

        expr = QgsExpression(queryString)

        # Grab the results from the layer
        features = self.tilesInAcceptedProposalsLayer.getFeatures(QgsFeatureRequest(expr))
        tileProposal = TOMsProposal(self, self.proposalsManager)

        for feature in sorted(features, key=lambda f: f[2], reverse=True):
            lastProposalID = feature["ProposalID"]
            lastRevisionNr = feature["RevisionNr"]

            proposalStatus = tileProposal.setProposal(lastProposalID)
            if proposalStatus == False:
                QgsMessageLog.logMessage(
                    "In getTileRevisionNrAtDate: not able to see proposal for " + str(lastProposalID) + "; " + str(lastRevisionNr),
                    tag="TOMs panel")
                break

            #lastProposalOpendate = self.proposalsManager.getProposalOpenDate(lastProposalID)
            lastProposalOpendate = tileProposal.getProposalOpenDate()

            QgsMessageLog.logMessage(
                "In getTileRevisionNrAtDate: last Proposal: " + str(lastProposalID) + "; " + str(lastRevisionNr),
                tag="TOMs panel")

            QgsMessageLog.logMessage(
                "In getTileRevisionNrAtDate: last Proposal open date: " + str(lastProposalOpendate) + "; filter date: " + str(filterDate),
                tag="TOMs panel")

            if lastProposalOpendate <= filterDate:
                QgsMessageLog.logMessage(
                    "In getTileRevisionNrAtDate: using Proposal: " + str(lastProposalID) + "; " + str(lastRevisionNr),
                    tag="TOMs panel")
                return lastRevisionNr, lastProposalOpendate

        return None, None

    def updateTileRevisionNr(self, currProposalID = None):

        # This will update the revision numberwithin "Tiles" and add a record to "TilesWithinAcceptedProposals"

        if currProposalID is None:
            currProposal = self.proposalsManager.currentProposalObject()
        else:
            currProposal = TOMsProposal(self.proposalsManager, currProposalID)

        QgsMessageLog.logMessage(
            "In TOMsTile:updateTileRevisionNr. tile " + str(self.thisTileNr) + " currRevNr: " + str(self.revisionNr()) + " ProposalID: " + str(currProposal.getProposalNr()), tag="TOMs panel")

        # check that there are no revisions beyond this date
        if self.lastRevisionDate() > currProposal.getProposalOpenDate():
            QgsMessageLog.logMessage(
                "In updateTileRevisionNr. tile" + str(self.thisTileNr) + " revision numbers are out of sync",
                tag="TOMs panel")
            QMessageBox.information(self.proposalsManager.iface.mainWindow(), "ERROR", ("In updateTileRevisionNr. tile" + str(self.thisTileNr) + " revision numbers are out of sync"))
            return False

        if self.revisionNr() is None or self.revisionNr() == 0:
            newRevisionNr = 1
        else:
            newRevisionNr = self.revisionNr() + 1

        QgsMessageLog.logMessage(
            "In TOMsTile:updateTileRevisionNr. tile " + str(self.thisTileNr) + " newRevisionNr: " + str(newRevisionNr) + " revisionDate: " + str(currProposal.getProposalOpenDate()), tag="TOMs panel")

        updateStatus = self.setRevisionNr(newRevisionNr)
        self.setLastRevisionDate(currProposal.getProposalOpenDate())

        # Now need to add the details of this tile to "TilesWithinAcceptedProposals" (including revision numbers at time of acceptance)

        newRecord = QgsFeature(self.tilesInAcceptedProposalsLayer.fields())

        idxProposalID = self.tilesInAcceptedProposalsLayer.fields().indexFromName("ProposalID")
        idxTileNr = self.tilesInAcceptedProposalsLayer.fields().indexFromName("TileNr")
        idxRevisionNr = self.tilesInAcceptedProposalsLayer.fields().indexFromName("RevisionNr")

        newRecord[idxProposalID] = currProposal.getProposalNr()
        newRecord[idxTileNr] = self.thisTileNr
        newRecord[idxRevisionNr] = newRevisionNr
        newRecord.setGeometry(QgsGeometry())

        status = self.tilesInAcceptedProposalsLayer.addFeature(newRecord)

        return status

class TOMsProposalElement(QObject):
    def __init__(self, proposalsManager, layerID, restriction, restrictionID):
        #def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__()
        QgsMessageLog.logMessage("In TOMsProposalElement.init. Creating Proposal Element ... " + str(layerID) + ";" + str(restriction), tag="TOMs panel")
        self.proposalsManager = proposalsManager
        self.currProposal = self.proposalsManager.currentProposalObject()
        self.tableNames = self.proposalsManager.tableNames
        self.layerID = layerID

        self.setThisLayer()

        if restriction is not None:
            self.thisElement = restriction
            self.thisRestrictionID = restrictionID

        elif restrictionID is not None:
            self.setElement(restrictionID)

        QgsMessageLog.logMessage(
        "In factory. Creating Proposal Element ... " + str(self.thisElement), tag="TOMs panel")

    def getGeometryID(self):
        return self.thisElement.attribute("GeometryID")

    def setThisLayer(self):
        self.thisLayer = self.proposalsManager.getRestrictionLayerFromID(self.layerID)
        if self.thisLayer is None:
            QgsMessageLog.logMessage("In TOMsProposalElement:setThisLayer. layer NOT set !!! for " + str(self.layerID), tag="TOMs panel")
        QgsMessageLog.logMessage("In TOMsProposalElement:setThisLayer ... ", tag="TOMs panel")

    def setElement(self, restrictionID):
        self.thisRestrictionID = restrictionID
        self.setThisLayer()

        if (restrictionID is not None):
            query = '\"RestrictionID\" = \'{restrictionID}\''.format(restrictionID=restrictionID)
            request = QgsFeatureRequest().setFilterExpression(query)
            for element in self.thisLayer.getFeatures(request):
                self.thisElement = element  # make assumption that only one row
                QgsMessageLog.logMessage("In TOMsProposalElement:setElement ... " + str(self.getGeometryID()), tag="TOMs panel")
                return True

        QMessageBox.information(self.proposalsManager.iface.mainWindow(), "ERROR", ("RestrictionID: \'{restrictionID}\' not found within layer {layerName}".format(restrictionID=restrictionID, layerName=self.thisLayer.name())))
        return False # either not found or 0

    def getElement(self):
        return self

    def getTilesForRestriction(self, filterDate):
        # get the tile(s) for a given restriction

        QgsMessageLog.logMessage("In getTilesForRestriction. ", tag="TOMs panel")

        self.tilesLayer = self.tableNames.setLayer("MapGrid")
        idxTileID = self.tableNames.setLayer("MapGrid").fields().indexFromName("id")

        dictTilesInRestriction = dict()

        QgsMessageLog.logMessage(
            "In factory. Creating Proposal Element ... " + str(self.thisRestrictionID) + ";" + str(self.thisElement.geometry().asWkt()), tag="TOMs panel")
        QgsMessageLog.logMessage("In getTilesForRestriction. restGeom " + self.thisElement.geometry().boundingBox().asWktPolygon(), tag="TOMs panel")

        request = QgsFeatureRequest().setFilterRect(self.thisElement.geometry().boundingBox()).setFlags(QgsFeatureRequest.ExactIntersect)

        currTile = TOMsTile(self.proposalsManager)

        for tile in self.tilesLayer.getFeatures(request):

            currTileNr = tile.attribute("id")
            # QgsMessageLog.logMessage("In getTilesForRestriction. Tile: " + str(currTileNr), tag="TOMs panel")

            if tile.geometry().intersects(self.thisElement.geometry()):
                # get revision number and add tile to list
                # currRevisionNrForTile = self.getTileRevisionNr(tile)
                QgsMessageLog.logMessage("In getTileForRestriction. Tile: " + str(tile.attribute("id")) + "; " + str(
                    tile.attribute("RevisionNr")) + "; " + str(tile.attribute("LastRevisionDate")), tag="TOMs panel")

                # check revision nr, etc

                """ TODO: Tidy this up ... with Tile object ..."""
                currTile.setTile(currTileNr)
                revisionNr, revisionDate = currTile.getTileRevisionNrAtDate(filterDate)
                tile.setAttribute("RevisionNr", revisionNr)
                tile.setAttribute("LastRevisionDate", revisionDate)

                """if revisionNr:

                    if revisionNr != tile.attribute("RevisionNr"):
                        tile.setAttribute("RevisionNr", revisionNr)
                    if revisionDate != tile.attribute("LastRevisionDate"):
                        tile.setAttribute("LastRevisionDate", revisionDate)

                else:

                    # if there is no RevisionNr for the tile, set it to 0. This should only be the case for proposals.

                    tile.setAttribute("RevisionNr", 0)

                QgsMessageLog.logMessage(
                    "In getTileForRestriction: Tile: " + str(tile.attribute("id")) + "; " + str(
                        tile.attribute("RevisionNr")) + "; " + str(tile.attribute("LastRevisionDate")) + "; " + str(
                        idxTileID),
                    tag="TOMs panel")"""

                dictTilesInRestriction[currTileNr] = tile

                QgsMessageLog.logMessage(
                    "In getTileForRestriction. len tileSet: " + str(len(dictTilesInRestriction)),
                    tag="TOMs panel")

                pass

        return dictTilesInRestriction

    def clone(self):
        pass

    def acceptActionOnProposalElement(self, actionOnAcceptance):

        currProposalOpenDate = self.currProposal.getProposalOpenDate()

        # update the Open/Close date for the restriction
        QgsMessageLog.logMessage("In updateProposalElement. layer: " + str(
            self.thisLayer.name()) + " currRestId: " + self.thisRestrictionID + " Opendate: " + str(
            currProposalOpenDate), tag="TOMs panel")

        # clear filter currRestrictionLayer.setSubsetString("")  **** need to make sure this is done ...

        if actionOnAcceptance == RestrictionAction.OPEN:  # Open
            statusUpd = self.thisLayer.changeAttributeValue(self.thisElement.id(),
                                                            self.thisLayer.fields().indexFromName(
                                                                      "OpenDate"),
                                                                  currProposalOpenDate)
            QgsMessageLog.logMessage(
                "In updateRestriction. " + self.thisRestrictionID + " Opened", tag="TOMs panel")
        else:  # Close
            statusUpd = self.thisLayer.changeAttributeValue(self.thisElement.id(),
                                                            self.thisLayer.fields().indexFromName(
                                                                      "CloseDate"),
                                                                  currProposalOpenDate)
            QgsMessageLog.logMessage(
                "In updateRestriction. " + self.thisRestrictionID + " Closed", tag="TOMs panel")

        return statusUpd

        pass


class TOMsRestriction(TOMsProposalElement):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating TOMsRestriction ... ", tag="TOMs panel")

    def getDisplayGeometry(self):
        pass

class Bay(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating BAY ... ", tag="TOMs panel")

    def getGeometryID(self):
        pass

    def getDisplayGeometry(self):
        pass

class Line(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating LINE ... ", tag="TOMs panel")

    def getGeometryID(self):
        pass

    def getDisplayGeometry(self):
        pass

class Sign(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating SIGN ... ", tag="TOMs panel")

    def getGeometryID(self):
        pass

    def getDisplayGeometry(self):
        pass

class TOMsPolygonRestriction(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating POLYGON ... ", tag="TOMs panel")

    def getZoneType(self):
        pass

    def getDisplayGeometry(self):
        self.displayGeometry = self.featureGeometry

class PedestrianZone(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating PedestrianZone ... ", tag="TOMs panel")

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass


class CPZ(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating CPZ ... ", tag="TOMs panel")

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass

class PTA(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating PTA ... ", tag="TOMs panel")

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass

class TOMsLabel(TOMsProposalElement):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating Label ... ", tag="TOMs panel")

    def getGeometryID(self):
        pass

class ProposalElementFactory():

    @staticmethod
    def getProposalElement(proposalsManager, proposalElementType, restriction, RestrictionID):
        QgsMessageLog.logMessage("In factory. getProposalElement ... " + str(proposalElementType) + ";" + str(restriction), tag="TOMs panel")
        try:
            if proposalElementType == RestrictionLayers.BAYS:
                return Bay(proposalsManager, proposalElementType, restriction, RestrictionID)
            elif proposalElementType == RestrictionLayers.LINES:
                return Line(proposalsManager, proposalElementType, restriction, RestrictionID)
            elif proposalElementType == RestrictionLayers.SIGNS:
                return Sign(proposalsManager, proposalElementType, restriction, RestrictionID)
            elif proposalElementType == RestrictionLayers.RESTRICTION_POLYGONS:
                return Sign(proposalsManager, proposalElementType, restriction, RestrictionID)
                # return RestrictionPolygonFactory.getProposalElement(proposalElementType, restrictionLayer, RestrictionID)
            elif proposalElementType == RestrictionLayers.CPZS:
                return CPZ(proposalsManager, proposalElementType, restriction, RestrictionID)
            elif proposalElementType == RestrictionLayers.PTAS:
                return PTA(proposalsManager, proposalElementType, restriction, RestrictionID)
            raise AssertionError("Restriction Type NOT found")
        except AssertionError as _e:
            QgsMessageLog.logMessage("In ProposalElementFactory. TYPE not found or something else ... ", tag="TOMs panel")

class RestrictionPolygonFactory():

    @staticmethod
    def getProposalElement(proposalElementType, restrictionLayer, RestrictionID):
        try:
            if proposalElementType == RestrictionLayers.BAYS:
                return Bay()
            elif proposalElementType == RestrictionLayers.LINES:
                return Line()
            elif proposalElementType == RestrictionLayers.SIGNS:
                return Sign()
            elif proposalElementType == RestrictionLayers.RESTRICTION_POLYGONS:
                return RestrictionPolygonFactory()
            raise AssertionError("Proposal Type NOT found")
        except AssertionError as _e:
            QgsMessageLog.logMessage("In ProposalElementFactory. TYPE not found or something else ... ",
                                     tag="TOMs panel")


