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

from ..constants import (
    ProposalStatus,
    RestrictionAction,
    RestrictionLayers
)

from abc import ABCMeta, abstractstaticmethod

class TOMsProposalElement(QObject):
    def __init__(self, proposalsManager, layerID, restriction, restrictionID):
        #def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__()
        QgsMessageLog.logMessage("In factory. Creating Proposal Element ... " + str(layerID) + ";" + str(restriction), tag="TOMs panel")
        self.proposalsManager = proposalsManager
        self.tableNames = self.proposalsManager.tableNames
        self.layerID = layerID

        self.setThisLayer()

        if restriction is not None:
            self.thisElement = restriction
            self.thisRestrictionID = restrictionID
            QgsMessageLog.logMessage(
                "In factory. Creating Proposal Element ... " + str(self.thisElement), tag="TOMs panel")
        elif restrictionID is not None:
            self.setElement(restrictionID)

    def getGeometryID(self):
        return self.thisElement["GeometryID"]

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

        QMessageBox.information(self.iface.mainWindow(), "ERROR", ("RestrictionID: \'{restrictionID}\' not found within layer {layerName}".format(restrictionID=restrictionID, layerName=self.thisLayer.name())))
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

        for tile in self.tilesLayer.getFeatures(request):

            currTileNr = tile.attribute("id")
            # QgsMessageLog.logMessage("In getTilesForRestriction. Tile: " + str(currTileNr), tag="TOMs panel")

            if tile.geometry().intersects(self.thisElement.geometry()):
                # get revision number and add tile to list
                # currRevisionNrForTile = self.getTileRevisionNr(tile)
                QgsMessageLog.logMessage("In getTileForRestriction. Tile: " + str(tile.attribute("id")) + "; " + str(
                    tile.attribute("RevisionNr")) + "; " + str(tile.attribute("LastRevisionDate")), tag="TOMs panel")

                # check revision nr, etc
                currTileNr = tile.attribute("id")

                """ TODO: Tidy this up ... with Tile object ..."""
                revisionNr, revisionDate = self.proposalsManager.getTileRevisionNrAtDate(currTileNr, filterDate)

                if revisionNr:

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
                    tag="TOMs panel")

                dictTilesInRestriction[currTileNr] = tile

                QgsMessageLog.logMessage(
                    "In getTileForRestriction. len tileSet: " + str(len(dictTilesInRestriction)),
                    tag="TOMs panel")

                pass

        return dictTilesInRestriction

    def clone(self):
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


"""class TOMsProposalElement(RestrictionTypeUtilsMixin, QObject):
    def __init__(self, proposalsManager, elementType= None, GeometryID=None):
        QObject.__init__(self)

        self.proposalsManager = proposalsManager
        self.tableNames = self.proposalsManager.tableNames

        # self.setProposalsLayer()

        if elementType is not None and GeometryID is not None:
            self.setElement(elementType, GeometryID)

    def setProposalsLayer(self):
        self.proposalsLayer = self.tableNames.setLayer("Proposals")
        if self.proposalsLayer is None:
            QgsMessageLog.logMessage("In TOMsProposal:setProposalsLayer. Proposals layer NOT set !!!", tag="TOMs panel")
        QgsMessageLog.logMessage("In TOMsProposal:setProposalsLayer... ", tag="TOMs panel")

    def setElement(self, GeometryID):

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

    def getGeometryID(self):
        pass # can be over-ridden ...

class TOMsRestriction(TOMsProposalElement):
    def __init__(self, proposalsManager, restrictionType=None, GeometryID=None):
        TOMsProposalElement.__init__(self)

        self.proposalsManager = proposalsManager
        self.tableNames = self.proposalsManager.tableNames


    def setProposalsLayer(self):
        self.proposalsLayer = self.tableNames.setLayer("Proposals")
        if self.proposalsLayer is None:
            QgsMessageLog.logMessage("In TOMsProposal:setProposalsLayer. Proposals layer NOT set !!!", tag="TOMs panel")
        QgsMessageLog.logMessage("In TOMsProposal:setProposalsLayer... ", tag="TOMs panel")

    def setRestriction(self, restrictionType, GeometryID):

        self.thisProposalNr = proposalID
        self.setProposalsLayer()

        if (proposalID is not None):
            query = '\"ProposalID\" = {proposalID}'.format(proposalID=proposalID)
            request = QgsFeatureRequest().setFilterExpression(query)
            for proposal in self.proposalsLayer.getFeatures(request):
                self.thisProposal = proposal  # make assumption that only one row
                return True


class TOMsBay(TOMsRestriction):
    def __init__(self, proposalsManager, restrictionType=None, GeometryID=None):
        TOMsRestriction.__init__(self)

        self.proposalsManager = proposalsManager
        self.tableNames = self.proposalsManager.tableNames


    def setProposalsLayer(self):
        self.proposalsLayer = self.tableNames.setLayer("Proposals")
        if self.proposalsLayer is None:
            QgsMessageLog.logMessage("In TOMsProposal:setProposalsLayer. Proposals layer NOT set !!!", tag="TOMs panel")
        QgsMessageLog.logMessage("In TOMsProposal:setProposalsLayer... ", tag="TOMs panel")

    def setRestriction(self, restrictionType, GeometryID):

        self.thisProposalNr = proposalID
        self.setProposalsLayer()

        if (proposalID is not None):
            query = '\"ProposalID\" = {proposalID}'.format(proposalID=proposalID)
            request = QgsFeatureRequest().setFilterExpression(query)
            for proposal in self.proposalsLayer.getFeatures(request):
                self.thisProposal = proposal  # make assumption that only one row
                return True"""