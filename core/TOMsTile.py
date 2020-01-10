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

class TOMsTile(QObject):
    def __init__(self, proposalsManager, TileNr=None):
        QObject.__init__(self)

        self.proposalsManager = proposalsManager
        self.tableNames = self.proposalsManager.tableNames

        self.setTilesLayer()

        if tileNr is not None:
            self.setProposal(tileNr)
        else:
            self.thisProposalNr = 0

    def setTilesLayer(self):
        self.tilesLayer = self.tableNames.setLayer("MapGrid")
        if self.tilesLayer is None:
            QgsMessageLog.logMessage("In TOMsProposal:setTilesLayer. tilesLayer layer NOT set !!!", tag="TOMs panel")
        QgsMessageLog.logMessage("In TOMsProposal:setTilesLayer... ", tag="TOMs panel")

    def setTile(self, tileNr):

        self.thisProposalNr = tileNr
        self.setProposalsLayer()

        if (tileNr is not None):
            query = '\"tileNr\" = {tileNr}'.format(proposalID=tileNr)
            request = QgsFeatureRequest().setFilterExpression(query)
            for tile in self.tilesLayer.getFeatures(request):
                self.thisTile = tile  # make assumption that only one row
                return True

        return False # either not found or 0

    def getTile(self):
        return self

    def getTileNr(self):
        return self.thisTileNr

    def getTileRevisionNrAtDate(self, revisionDate=None):

        if not revisionDate:
            revisionDate = self.proposalsManager.date()

        pass

    def getLastRevisionDateAtDate(self, revisionDate=None):

        if not revisionDate:
            revisionDate = self.proposalsManager.date()

        pass

    def updateTileRevisionNr(self):
        pass

