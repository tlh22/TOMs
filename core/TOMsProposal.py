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
    QgsRectangle
)

from ..proposalTypeUtilsClass import ProposalTypeUtilsMixin

from .TOMsProposalElement import *

from ..constants import (
    ProposalStatus,
    RestrictionAction
)

class TOMsProposal(ProposalTypeUtilsMixin, QObject):
    def __init__(self, proposalsManager, proposalNr=None):
        QObject.__init__(self)

        self.proposalsManager = proposalsManager
        self.tableNames = self.proposalsManager.tableNames

        self.setProposalsLayer()

        if proposalNr is not None:
            self.setProposal(proposalNr)
        else:
            self.thisProposalNr = 0

    def setProposalsLayer(self):
        self.proposalsLayer = self.tableNames.setLayer("Proposals")
        if self.proposalsLayer is None:
            QgsMessageLog.logMessage("In TOMsProposal:setProposalsLayer. Proposals layer NOT set !!!", tag="TOMs panel")
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

    def getProposal(self):
        return self

    def getProposalNr(self):
        return self.thisProposalNr

    def getProposalTitle(self):
        return self.thisProposal.attribute("ProposalTitle")

    def getProposalStatusID(self):
        return self.thisProposal.attribute("ProposalStatusID")

    def getProposalOpenDate(self):
        return self.thisProposal.attribute("ProposalOpenDate")

    def acceptProposal(self):
        pass

    def rejectProposal(self):
        pass

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
        QgsMessageLog.logMessage("In getProposalTileList. considering Proposal: " + str (self.getProposalNr()) + " for " + str(revisionDate), tag="TOMs panel")
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

            # loop through all the layers that might have restrictions
            for (layerID, layerName) in self.getRestrictionLayersList():

                for (currRestrictionID, restrictionInProposalDetails) in self.__getCurrentRestrictionsForLayer(layerID, revisionDate):

                    currRestriction = ProposalElementFactory.getProposalElement(self.proposalsManager, layerID, self.tableNames.setLayer(layerName), currRestrictionID)
                    dictTilesInProposal.update(currRestriction.getTilesForRestriction(revisionDate))

        for tileNr, tile in dictTilesInProposal.items():
            QgsMessageLog.logMessage("In getProposalTileList: " + str(tile["id"]) + " RevisionNr: " + str(tile["RevisionNr"]) + " RevisionDate: " + str(tile["LastRevisionDate"]), tag="TOMs panel")

        return dictTilesInProposal

