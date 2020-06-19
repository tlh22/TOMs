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
from TOMs.core.TOMsTile import TOMsTile
from TOMs.core.TOMsProposalElement import (TOMsProposalElement, ProposalElementFactory)

from qgis.core import (
    Qgis,
    QgsMessageLog, QgsFeature, QgsGeometry,
    QgsFeatureRequest,
    QgsRectangle, QgsExpression, NULL
)

from ..proposalTypeUtilsClass import ProposalTypeUtilsMixin

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
        #result = self.thisProposal.setAttribute("ProposalStatusID", value)   # this does not update. TODO: Understand why
        result = self.proposalsLayer.changeAttributeValue(self.thisProposal.id(), self.idxProposalStatusID, value)   # this does update ??
        return result

    def getProposalOpenDate(self):
        return self.thisProposal.attribute("ProposalOpenDate")

    def setProposalOpenDate(self, value):
        return self.thisProposal.setAttribute("ProposalOpenDate", value)

    def getProposalCreateDate(self):
        return self.thisProposal.attribute("ProposalCreateDate")

    def setProposalCreateDate(self, value):
        return self.thisProposal.setAttribute("ProposalCreateDate", value)

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
                TOMsMessageLog.logMessage("In getProposalBoundingBox. (" + layerName + ") filter:" + layerFilterString, level=Qgis.Info)
                if not currLayer.dataProvider().setSubsetString(None):
                    TOMsMessageLog.logMessage(
                        "In TOMsProposal:getProposalBoundingBox. (" + layerName + ") filter error ....", level=Qgis.Info)

                query = '"RestrictionID" IN ({restrictions})'.format(restrictions=restrictionStr)

                request = QgsFeatureRequest().setFilterExpression(query)
                for currRestriction in currLayer.getFeatures(request):
                    geometryBoundingBox.combineExtentWith(currRestriction.geometry().boundingBox())

                currLayer.dataProvider().setSubsetString(layerFilterString)
                #currLayer.blockSignals(False)
                TOMsMessageLog.logMessage("In In TOMsProposal:getProposalBoundingBox. (" + currLayer.name() + ") filter 1:" + currLayer.subsetString(), level=Qgis.Info)

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
                self.tableNames.setLayer(layerName).dataProvider().setSubsetString('')

                for (currRestrictionID, restrictionInProposalObject) in self.__getRestrictionsInProposalForLayerForAction(layerID):

                    currRestriction = ProposalElementFactory.getProposalElement(self.proposalsManager, layerID, currRestrictionID)
                    dictTilesInProposal.update(currRestriction.getTilesForRestrictionForDate(revisionDate))

                # reset filter
                self.tableNames.setLayer(layerName).dataProvider().setSubsetString(currFilter)

        else:

            for currTileRecord in self.tableNames.setLayer("MapGrid").getFeatures():

                TOMsMessageLog.logMessage("In TOMsProposal.getProposalTileDictionaryForDate. Current. Tile: " + str(currTileRecord.attribute("id")), level=Qgis.Info)

                currTileObject = TOMsTile(self.proposalsManager)
                if not currTileObject.setTile(currTileRecord.attribute("id")):
                    return None
                lastRevisionNr, lastProposalOpendate = currTileObject.getTileRevisionNrAtDate(revisionDate)
                currTileObject.setRevisionNr_AtDate(lastRevisionNr)
                currTileObject.setLastRevisionDate_AtDate(lastProposalOpendate)

                if lastRevisionNr is not None:   # the assumption is that tiles without restrictions have a NULL revision number
                    dictTilesInProposal[currTileObject.tileNr()] = currTileObject

        for thisTileNr, thisTile in dictTilesInProposal.items():
            TOMsMessageLog.logMessage("In TOMsProposal.getProposalTileDictionaryForDate: " + str(thisTileNr) + " RevisionNr: " + str(thisTile.getRevisionNr_AtDate()) + " RevisionDate: " + str(thisTile.getLastRevisionDate_AtDate()), level=Qgis.Info)

        return dictTilesInProposal

    def acceptProposal(self):

        currProposalID = self.thisProposalNr
        TOMsMessageLog.logMessage("In TOMsProposal.acceptProposal - " + str(self.thisProposalNr), level=Qgis.Info)

        """ Steps in acceptance are:
        1. Set new open/close dates for restrictions ( remember to clear filter )
        2. update revision numbers for tiles (including add details to TilesInAcceptedProposals)
        3. update Proposal details
        """

        if self.thisProposalNr > 0:  # need to consider a proposal

            # set Open/Close date for restrictions in Proposal
            for (currlayerID, currlayerName) in self.getRestrictionLayersList():
                currLayer = self.tableNames.setLayer(currlayerName)
                if not currLayer.dataProvider().setSubsetString(''):   # need to use data provider ??
                    TOMsMessageLog.logMessage("In TOMsProposal.acceptProposal - problem clearing filter for layer {}:{}:{}".format(currlayerName, currLayer.name(), currLayer),
                                              level=Qgis.Info)
                    return False

                TOMsMessageLog.logMessage(
                    "In TOMsProposal:acceptProposal. Considering layer: {}".format(currlayerName),
                    level=Qgis.Info)

                restrictionList = []
                restrictionList = self.__getRestrictionsInProposalForLayerForAction(currlayerID)

                for currRestrictionID, currRestrictionInProposalDetails in restrictionList:
                    currRestrictionInProposal = TOMsProposalElement(self.proposalsManager, currlayerID, currRestrictionID)
                    if currRestrictionInProposal is None:
                        return False
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

            for tileNr, currTile in proposalTileDictionary.items():
                TOMsMessageLog.logMessage("In TOMsProposal.acceptProposal: current tile " + str(currTile.tileNr()) + " current RevisionNr: " + str(
                    currTile.getRevisionNr_AtDate()) + " RevisionDate: " + str(currTile.getLastRevisionDate_AtDate()), level=Qgis.Info)
                #currTile = TOMsTile(self.proposalsManager, tileNr)

                if not currTile.updateTileDetailsOnProposalAcceptance(self.proposalsManager):
                    TOMsMessageLog.logMessage(
                        "In TOMsProposal:acceptProposal. " + str(
                            tileNr) + " error updating tile revision details",
                        level=Qgis.Info)
                    return status

            # Now update Proposal
            if not self.setProposalStatusID(ProposalStatus.ACCEPTED):
                return False

            return True

    def rejectProposal(self):

        TOMsMessageLog.logMessage("In TOMsProposal.rejectProposal - " + str(self.thisProposalNr), level=Qgis.Info)
        status = self.setProposalStatusID(ProposalStatus.REJECTED)

        if status:
            TOMsMessageLog.logMessage("In TOMsProposal.rejectProposal.  Proposal Rejected ... ", level=Qgis.Info)
            #self.proposalsManager.newProposalCreated.emit(0)

        return status

