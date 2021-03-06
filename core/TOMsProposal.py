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

from TOMs.core.TOMsMessageLog import TOMsMessageLog
from qgis.core import (
    Qgis,
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
        TOMsMessageLog.logMessage("In TOMsProposal:init. ... ", level=Qgis.Info)
        self.proposalsManager = proposalsManager
        self.tableNames = self.proposalsManager.tableNames

        self.setProposalsLayer()

        TOMsMessageLog.logMessage("In TOMsProposal:init. ... proposals layer set ", level=Qgis.Info)

        if proposalNr is not None:
            self.setProposal(proposalNr)


    def setProposalsLayer(self):
        self.proposalsLayer = self.tableNames.setLayer("Proposals")

        if self.proposalsLayer is None:
            TOMsMessageLog.logMessage("In TOMsProposal:setProposalsLayer. Proposals layer NOT set !!!", level=Qgis.Info)
            return False
        else:
            idxProposalID = self.proposalsLayer.fields().indexFromName("ProposalID")
            self.idxProposalTitle = self.proposalsLayer.fields().indexFromName("ProposalTitle")
            self.idxCreateDate = self.proposalsLayer.fields().indexFromName("ProposalCreateDate")
            self.idxOpenDate = self.proposalsLayer.fields().indexFromName("ProposalOpenDate")
            self.idxProposalStatusID = self.proposalsLayer.fields().indexFromName("ProposalStatusID")

        TOMsMessageLog.logMessage("In TOMsProposal:setProposalsLayer... ", level=Qgis.Info)

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

        TOMsMessageLog.logMessage(
            "In TOMsProposal:createProposal - attributes: (fid=" + str(self.thisProposal.id()) + ") " + str(
                self.thisProposal.attributes()),
            level=Qgis.Info)

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
        TOMsMessageLog.logMessage("In TOMsProposal.acceptProposal - " + str(self.thisProposalNr), level=Qgis.Info)

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
                        TOMsMessageLog.logMessage(
                            "In TOMsProposal:acceptProposal. " + str(
                                currRestrictionID) + " error on Action",
                            level=Qgis.Info)
                        return status

            # Now update tile revision nrs
            TOMsMessageLog.logMessage("In TOMsProposal:acceptProposal. Updating tile revision nrs",
                level=Qgis.Info)
            proposalTileDictionary = self.getProposalTileDictionaryForDate()

            for tileNr, tile in proposalTileDictionary.items():
                TOMsMessageLog.logMessage("In TOMsProposal.acceptProposal: current tile " + str(tile["id"]) + " current RevisionNr: " + str(
                    tile["RevisionNr"]) + " RevisionDate: " + str(tile["LastRevisionDate"]), level=Qgis.Info)
                currTile = TOMsTile(self.proposalsManager, tileNr)
                status = currTile.updateTileRevisionNr(currProposalID)
                if status == False:
                    TOMsMessageLog.logMessage(
                        "In TOMsProposal:acceptProposal. " + str(
                            tileNr) + " error updating tile revision details",
                        level=Qgis.Info)
                    return status

            # Now update Proposal
            status = self.setProposalStatusID(ProposalStatus.ACCEPTED)

            #self.proposalsManager.newProposalCreated.emit(0)

        pass

    def rejectProposal(self):

        TOMsMessageLog.logMessage("In TOMsProposal.rejectProposal - " + str(self.thisProposalNr), level=Qgis.Info)
        status = self.setProposalStatusID(ProposalStatus.REJECTED)

        if status:
            TOMsMessageLog.logMessage("In TOMsProposal.rejectProposal.  Proposal Rejected ... ", level=Qgis.Info)
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

        TOMsMessageLog.logMessage("In __getRestrictionsInProposalForLayerForAction. query: " + str(query), level=Qgis.Info)
        request = QgsFeatureRequest().setFilterExpression(query)

        restrictionList = []
        for restrictionInProposalDetails in self.RestrictionsInProposalsLayer.getFeatures(request):
            restrictionList.append([restrictionInProposalDetails["RestrictionID"], restrictionInProposalDetails])

        return restrictionList

    def getProposalBoundingBox(self):

        # Need to remember that filters are in operation, so need to ensure that Restriction features are available
        TOMsMessageLog.logMessage("In getProposalBoundingBox.", level=Qgis.Info)
        currProposalID = self.thisProposalNr
        geometryBoundingBox = QgsRectangle()

        if currProposalID > 0:  # need to consider a proposal

            for (layerID, layerName) in self.getRestrictionLayersList():
                currLayer = self.tableNames.setLayer(layerName)
                restrictionStr = self.__getRestrictionsListForLayerForAction(layerID)
                #TOMsMessageLog.logMessage("In getProposalBoundingBox. (" + layerName + ") request:" + restrictionStr, level=Qgis.Info)

                #currLayer.blockSignals(True)
                # unset filter to get geometries of closed features
                layerFilterString = currLayer.subsetString()
                TOMsMessageLog.logMessage("In getProposalBoundingBox. (" + layerName + ") filter 1:" + layerFilterString, level=Qgis.Info)
                currLayer.setSubsetString(None)

                query = '"RestrictionID" IN ({restrictions})'.format(restrictions=restrictionStr)

                request = QgsFeatureRequest().setFilterExpression(query)
                for currRestriction in currLayer.getFeatures(request):
                    geometryBoundingBox.combineExtentWith(currRestriction.geometry().boundingBox())

                currLayer.setSubsetString(layerFilterString)
                #currLayer.blockSignals(False)
                TOMsMessageLog.logMessage("In getProposalBoundingBox. (" + currLayer.name() + ") filter 1:" + currLayer.subsetString(), level=Qgis.Info)

        return geometryBoundingBox

    def getProposalTileDictionaryForDate(self, revisionDate=None):

        if not revisionDate:
            revisionDate = self.proposalsManager.date()

        # returns list of tiles in the proposal and their current revision numbers
        TOMsMessageLog.logMessage("In TOMsProposal.getProposalTileDictionaryForDate. considering Proposal: " + str (self.getProposalNr()) + " for " + str(revisionDate), level=Qgis.Info)
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

                TOMsMessageLog.logMessage("In TOMsProposal.getProposalTileDictionaryForDate. Current. Tile: " + str(currTileRecord.attribute("id")), level=Qgis.Info)

                status = currTileObject.setTile(currTileRecord.attribute("id"))
                lastRevisionNr, lastProposalOpendate = currTileObject.getTileRevisionNrAtDate(revisionDate)

                if lastRevisionNr is not None:   # the assumption is that tiles without restrictions have a NULL revision number
                    dictTilesInProposal[currTileObject.thisTileNr] = currTileRecord

        for tileNr, tile in dictTilesInProposal.items():
            TOMsMessageLog.logMessage("In TOMsProposal.getProposalTileDictionaryForDate: " + str(tile["id"]) + " RevisionNr: " + str(tile["RevisionNr"]) + " RevisionDate: " + str(tile["LastRevisionDate"]), level=Qgis.Info)

        return dictTilesInProposal

    def updateTileRevisionNrsInProposal(self, dictTilesInProposal):

        TOMsMessageLog.logMessage("In TOMsProposal:updateTileRevisionNrsInProposal.", level=Qgis.Info)
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
            TOMsMessageLog.logMessage("In updateTileRevisionNrs. tile" + str (tileNr) + " currRevNr: " + str(currRevisionNr), level=Qgis.Info)
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
            TOMsMessageLog.logMessage("In TOMsProposal:setTilesLayer. tilesLayer layer NOT set !!!", level=Qgis.Info)
        else:
            self.tileLayerFields = self.tilesLayer.fields()
            self.idxTileNr = self.tilesLayer.fields().indexFromName("id")
            self.idxRevisionNr = self.tilesLayer.fields().indexFromName("RevisionNr")
            self.idxLastRevisionDate = self.tilesLayer.fields().indexFromName("LastRevisionDate")
        TOMsMessageLog.logMessage("In TOMsProposal:setTilesLayer... MapGrid ", level=Qgis.Info)

        self.tilesInAcceptedProposalsLayer = self.tableNames.setLayer("TilesInAcceptedProposals")
        if self.tilesInAcceptedProposalsLayer is None:
            TOMsMessageLog.logMessage("In TOMsProposal:setTilesLayer. tilesInAcceptedProposalsLayer layer NOT set !!!", level=Qgis.Info)
        TOMsMessageLog.logMessage("In TOMsProposal:setTilesLayer... tilesInAcceptedProposalsLayer ", level=Qgis.Info)

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
                TOMsMessageLog.logMessage("In TOMsProposal:setTile... tile found ",
                                         level=Qgis.Info)
                return True

        TOMsMessageLog.logMessage("In TOMsProposal:setTile... tile NOT found ",
                                         level=Qgis.Info)
        return False # either not found or 0

    def tile(self):
        return self

    def tileNr(self):
        return self.thisTileNr

    def revisionNr(self):
        return self.thisTile.attribute("RevisionNr")

    def setRevisionNr(self, value):
        TOMsMessageLog.logMessage("In TOMsTile:setRevisionNr newRevisionNr: " + str(value), level=Qgis.Info)
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

        TOMsMessageLog.logMessage("In TOMsTile:getTileRevisionNrAtDate.", level=Qgis.Info)

        if filterDate is None:
            filterDate = self.proposalsManager.date()

        #query2 = '"tile" = \'{tileid}\''.format(tileid=currTile)

        queryString = "\"TileNr\" = " + str(self.thisTileNr)

        TOMsMessageLog.logMessage("In getTileRevisionNrAtDate: queryString: " + str(queryString), level=Qgis.Info)

        expr = QgsExpression(queryString)

        # Grab the results from the layer
        features = self.tilesInAcceptedProposalsLayer.getFeatures(QgsFeatureRequest(expr))
        tileProposal = TOMsProposal(self, self.proposalsManager)

        for feature in sorted(features, key=lambda f: f[2], reverse=True):
            lastProposalID = feature["ProposalID"]
            lastRevisionNr = feature["RevisionNr"]

            proposalStatus = tileProposal.setProposal(lastProposalID)
            if proposalStatus == False:
                TOMsMessageLog.logMessage(
                    "In getTileRevisionNrAtDate: not able to see proposal for " + str(lastProposalID) + "; " + str(lastRevisionNr),
                    level=Qgis.Info)
                break

            #lastProposalOpendate = self.proposalsManager.getProposalOpenDate(lastProposalID)
            lastProposalOpendate = tileProposal.getProposalOpenDate()

            TOMsMessageLog.logMessage(
                "In getTileRevisionNrAtDate: last Proposal: " + str(lastProposalID) + "; " + str(lastRevisionNr),
                level=Qgis.Info)

            TOMsMessageLog.logMessage(
                "In getTileRevisionNrAtDate: last Proposal open date: " + str(lastProposalOpendate) + "; filter date: " + str(filterDate),
                level=Qgis.Info)

            if lastProposalOpendate <= filterDate:
                TOMsMessageLog.logMessage(
                    "In getTileRevisionNrAtDate: using Proposal: " + str(lastProposalID) + "; " + str(lastRevisionNr),
                    level=Qgis.Info)
                return lastRevisionNr, lastProposalOpendate

        return None, None

    def updateTileRevisionNr(self, currProposalID = None):

        # This will update the revision numberwithin "Tiles" and add a record to "TilesWithinAcceptedProposals"

        if currProposalID is None:
            currProposal = self.proposalsManager.currentProposalObject()
        else:
            currProposal = TOMsProposal(self.proposalsManager, currProposalID)

        TOMsMessageLog.logMessage(
            "In TOMsTile:updateTileRevisionNr. tile " + str(self.thisTileNr) + " currRevNr: " + str(self.revisionNr()) + " ProposalID: " + str(currProposal.getProposalNr()), level=Qgis.Info)

        # check that there are no revisions beyond this date
        if self.lastRevisionDate() > currProposal.getProposalOpenDate():
            TOMsMessageLog.logMessage(
                "In updateTileRevisionNr. tile" + str(self.thisTileNr) + " revision numbers are out of sync",
                level=Qgis.Info)
            QMessageBox.information(self.proposalsManager.iface.mainWindow(), "ERROR", ("In updateTileRevisionNr. tile" + str(self.thisTileNr) + " revision numbers are out of sync"))
            return False

        if self.revisionNr() is None or self.revisionNr() == 0:
            newRevisionNr = 1
        else:
            newRevisionNr = self.revisionNr() + 1

        TOMsMessageLog.logMessage(
            "In TOMsTile:updateTileRevisionNr. tile " + str(self.thisTileNr) + " newRevisionNr: " + str(newRevisionNr) + " revisionDate: " + str(currProposal.getProposalOpenDate()), level=Qgis.Info)

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
        TOMsMessageLog.logMessage("In TOMsProposalElement.init. Creating Proposal Element ... " + str(layerID) + ";" + str(restriction), level=Qgis.Info)
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

        TOMsMessageLog.logMessage(
        "In factory. Creating Proposal Element ... " + str(self.thisElement), level=Qgis.Info)

    def getGeometryID(self):
        return self.thisElement.attribute("GeometryID")

    def setThisLayer(self):
        self.thisLayer = self.proposalsManager.getRestrictionLayerFromID(self.layerID)
        if self.thisLayer is None:
            TOMsMessageLog.logMessage("In TOMsProposalElement:setThisLayer. layer NOT set !!! for " + str(self.layerID), level=Qgis.Info)
        TOMsMessageLog.logMessage("In TOMsProposalElement:setThisLayer ... ", level=Qgis.Info)

    def setElement(self, restrictionID):
        self.thisRestrictionID = restrictionID
        self.setThisLayer()

        if (restrictionID is not None):
            query = '\"RestrictionID\" = \'{restrictionID}\''.format(restrictionID=restrictionID)
            request = QgsFeatureRequest().setFilterExpression(query)
            for element in self.thisLayer.getFeatures(request):
                self.thisElement = element  # make assumption that only one row
                TOMsMessageLog.logMessage("In TOMsProposalElement:setElement ... " + str(self.getGeometryID()), level=Qgis.Info)
                return True

        QMessageBox.information(self.proposalsManager.iface.mainWindow(), "ERROR", ("RestrictionID: \'{restrictionID}\' not found within layer {layerName}".format(restrictionID=restrictionID, layerName=self.thisLayer.name())))
        return False # either not found or 0

    def getElement(self):
        return self

    def getTilesForRestriction(self, filterDate):
        # get the tile(s) for a given restriction

        TOMsMessageLog.logMessage("In getTilesForRestriction. ", level=Qgis.Info)

        self.tilesLayer = self.tableNames.setLayer("MapGrid")
        idxTileID = self.tableNames.setLayer("MapGrid").fields().indexFromName("id")

        dictTilesInRestriction = dict()

        TOMsMessageLog.logMessage(
            "In factory. Creating Proposal Element ... " + str(self.thisRestrictionID) + ";" + str(self.thisElement.geometry().asWkt()), level=Qgis.Info)
        TOMsMessageLog.logMessage("In getTilesForRestriction. restGeom " + self.thisElement.geometry().boundingBox().asWktPolygon(), level=Qgis.Info)

        request = QgsFeatureRequest().setFilterRect(self.thisElement.geometry().boundingBox()).setFlags(QgsFeatureRequest.ExactIntersect)

        currTile = TOMsTile(self.proposalsManager)

        for tile in self.tilesLayer.getFeatures(request):

            currTileNr = tile.attribute("id")
            # TOMsMessageLog.logMessage("In getTilesForRestriction. Tile: " + str(currTileNr), level=Qgis.Info)

            if tile.geometry().intersects(self.thisElement.geometry()):
                # get revision number and add tile to list
                # currRevisionNrForTile = self.getTileRevisionNr(tile)
                TOMsMessageLog.logMessage("In getTileForRestriction. Tile: " + str(tile.attribute("id")) + "; " + str(
                    tile.attribute("RevisionNr")) + "; " + str(tile.attribute("LastRevisionDate")), level=Qgis.Info)

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

                TOMsMessageLog.logMessage(
                    "In getTileForRestriction: Tile: " + str(tile.attribute("id")) + "; " + str(
                        tile.attribute("RevisionNr")) + "; " + str(tile.attribute("LastRevisionDate")) + "; " + str(
                        idxTileID),
                    level=Qgis.Info)"""

                dictTilesInRestriction[currTileNr] = tile

                TOMsMessageLog.logMessage(
                    "In getTileForRestriction. len tileSet: " + str(len(dictTilesInRestriction)),
                    level=Qgis.Info)

                pass

        return dictTilesInRestriction

    def clone(self):
        pass

    def acceptActionOnProposalElement(self, actionOnAcceptance):

        currProposalOpenDate = self.currProposal.getProposalOpenDate()

        # update the Open/Close date for the restriction
        TOMsMessageLog.logMessage("In updateProposalElement. layer: " + str(
            self.thisLayer.name()) + " currRestId: " + self.thisRestrictionID + " Opendate: " + str(
            currProposalOpenDate), level=Qgis.Info)

        # clear filter currRestrictionLayer.setSubsetString("")  **** need to make sure this is done ...

        if actionOnAcceptance == RestrictionAction.OPEN:  # Open
            statusUpd = self.thisLayer.changeAttributeValue(self.thisElement.id(),
                                                            self.thisLayer.fields().indexFromName(
                                                                      "OpenDate"),
                                                                  currProposalOpenDate)
            TOMsMessageLog.logMessage(
                "In updateRestriction. " + self.thisRestrictionID + " Opened", level=Qgis.Info)
        else:  # Close
            statusUpd = self.thisLayer.changeAttributeValue(self.thisElement.id(),
                                                            self.thisLayer.fields().indexFromName(
                                                                      "CloseDate"),
                                                                  currProposalOpenDate)
            TOMsMessageLog.logMessage(
                "In updateRestriction. " + self.thisRestrictionID + " Closed", level=Qgis.Info)

        return statusUpd

        pass


class TOMsRestriction(TOMsProposalElement):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating TOMsRestriction ... ", level=Qgis.Info)

    def getDisplayGeometry(self):
        pass

class Bay(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating BAY ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getDisplayGeometry(self):
        pass

class Line(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating LINE ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getDisplayGeometry(self):
        pass

class Sign(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating SIGN ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getDisplayGeometry(self):
        pass

class TOMsPolygonRestriction(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating POLYGON ... ", level=Qgis.Info)

    def getZoneType(self):
        pass

    def getDisplayGeometry(self):
        self.displayGeometry = self.featureGeometry

class PedestrianZone(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating PedestrianZone ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass


class CPZ(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating CPZ ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass

class PTA(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating PTA ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass

class TOMsLabel(TOMsProposalElement):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating Label ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

class ProposalElementFactory():

    @staticmethod
    def getProposalElement(proposalsManager, proposalElementType, restriction, RestrictionID):
        TOMsMessageLog.logMessage("In factory. getProposalElement ... " + str(proposalElementType) + ";" + str(restriction), level=Qgis.Info)
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
            TOMsMessageLog.logMessage("In ProposalElementFactory. TYPE not found or something else ... ", level=Qgis.Info)

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
            TOMsMessageLog.logMessage("In ProposalElementFactory. TYPE not found or something else ... ",
                                     level=Qgis.Info)


