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

from TOMs.core.TOMsMessageLog import (TOMsMessageLog)
#from TOMs.core.TOMsProposal import (TOMsProposal)
from qgis.core import (
    Qgis,
    QgsMessageLog, QgsFeature, QgsGeometry,
    QgsFeatureRequest,
    QgsRectangle, QgsExpression, NULL
)

from ..proposalTypeUtilsClass import ProposalTypeUtilsMixin

#from .TOMsProposalElement import *
#from ..core.TOMsProposal import (TOMsProposal)

from ..constants import (
    ProposalStatus,
    RestrictionAction
)

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
            self.idxRevisionNr = self.tilesLayer.fields().indexFromName("CurrRevisionNr")
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
        return self.thisTile.attribute("CurrRevisionNr")

    def setRevisionNr(self, value):
        TOMsMessageLog.logMessage("In TOMsTile:setRevisionNr newRevisionNr: " + str(value), level=Qgis.Info)
        #self.thisTile[self.idxRevisionNr] = value
        status = self.tilesLayer.changeAttributeValue(self.thisTile.id(), self.idxRevisionNr, value)
        return status
        #return self.thisTile.setAttribute("RevisionNr", value)

    def getRevisionNr_AtDate(self):
        return self.revisionNr_AtDate

    def setRevisionNr_AtDate(self, value):
        self.revisionNr_AtDate = value

    def lastRevisionDate(self):
        return self.thisTile[self.idxLastRevisionDate]

    def getLastRevisionDate_AtDate(self):
        return self.lastRevisionDate_AtDate

    def setLastRevisionDate_AtDate(self, value):
        self.lastRevisionDate_AtDate = value

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
        tileProposal = self.proposalsManager.currentProposalObject()

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

    def updateTileDetailsOnProposalAcceptance(self, currProposalID):

        TOMsMessageLog.logMessage("In TOMsTile:updateTileDetailsOnProposalAcceptance...", level=Qgis.Info)
        if currProposalID is None:
            return False

        currProposal = self.proposalsManager.currentProposalObject()

        if not self.updateTileRevisionNr(currProposal):
            return False

        if not self.addRecordToTilesInAcceptedProposal(currProposal):
            return False


    def updateTileRevisionNr(self, currProposal):

        TOMsMessageLog.logMessage("In TOMsTile:updateTileRevisionNr...", level=Qgis.Info)

        # This will update the revision number within "Tiles" and add a record to "TilesWithinAcceptedProposals"

        TOMsMessageLog.logMessage(
            "In TOMsTile:updateTileRevisionNr. tile " + str(self.thisTileNr) + " currRevNr: " + str(self.revisionNr()) + " ProposalID: " + str(currProposal.getProposalNr()), level=Qgis.Info)

        # check that there are no revisions beyond this date
        if self.lastRevisionDate() > currProposal.getProposalOpenDate():
            TOMsMessageLog.logMessage(
                "In updateTileRevisionNr. tile" + str(self.thisTileNr) + " revision numbers are out of sync",
                level=Qgis.Info)
            QMessageBox.information(self.proposalsManager.iface.mainWindow(), "ERROR", ("In updateTileRevisionNr. tile" + str(self.thisTileNr) + " revision numbers are out of sync"))
            return False
        #lastRevisionNr, lastProposalOpendate = self.getTileRevisionNrAtDate(self.currProposal.getProposalOpenDate())

        if self.revisionNr() is None or self.revisionNr() == NULL or self.revisionNr() == 0:
            self.revisionNrForProposal = 1
        else:
            self.revisionNrForProposal = self.revisionNr() + 1

        TOMsMessageLog.logMessage(
            "In TOMsTile:updateTileRevisionNr. tile " + str(self.thisTileNr) + " newRevisionNr: " + str(self.revisionNrForProposal) + " revisionDate: " + str(currProposal.getProposalOpenDate()), level=Qgis.Info)

        if not self.setRevisionNr(self.revisionNrForProposal):
            return False
        if not self.setLastRevisionDate(currProposal.getProposalOpenDate()):
            return False

        return True

    def addRecordToTilesInAcceptedProposal(self, currProposal):
        # Now need to add the details of this tile to "TilesWithinAcceptedProposals" (including revision numbers at time of acceptance)

        newRecord = QgsFeature(self.tilesInAcceptedProposalsLayer.fields())

        idxProposalID = self.tilesInAcceptedProposalsLayer.fields().indexFromName("ProposalID")
        idxTileNr = self.tilesInAcceptedProposalsLayer.fields().indexFromName("TileNr")
        idxRevisionNr = self.tilesInAcceptedProposalsLayer.fields().indexFromName("RevisionNr")

        newRecord[idxProposalID] = currProposal.getProposalNr()
        newRecord[idxTileNr] = self.thisTileNr
        newRecord[idxRevisionNr] = self.revisionNrForProposal
        # newRecord.setGeometry(QgsGeometry())

        if not self.tilesInAcceptedProposalsLayer.addFeature(newRecord):
            return False

        return True
