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
    Qgis,
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
from ..core.TOMsProposal import (TOMsTile)

class TOMsProposalElement(QObject):
    def __init__(self, proposalsManager, layerID, restriction, restrictionID):
        #def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__()
        QgsMessageLog.logMessage("In factory. Creating Proposal Element ... " + str(layerID) + ";" + str(restriction), tag="TOMs panel", level=Qgis.Info)
        self.proposalsManager = proposalsManager
        self.currProposal = self.proposalsManager.currentProposalObject()
        self.tableNames = self.proposalsManager.tableNames
        self.layerID = layerID

        self.setThisLayer()

        if restriction is not None:
            self.thisElement = restriction
            self.thisRestrictionID = restrictionID
            QgsMessageLog.logMessage(
                "In factory. Creating Proposal Element ... " + str(self.thisElement), tag="TOMs panel", level=Qgis.Info)
        elif restrictionID is not None:
            self.setElement(restrictionID)

    def getGeometryID(self):
        return self.thisElement["GeometryID"]

    def setThisLayer(self):
        self.thisLayer = self.proposalsManager.getRestrictionLayerFromID(self.layerID)
        if self.thisLayer is None:
            QgsMessageLog.logMessage("In TOMsProposalElement:setThisLayer. layer NOT set !!! for " + str(self.layerID), tag="TOMs panel", level=Qgis.Info)
        QgsMessageLog.logMessage("In TOMsProposalElement:setThisLayer ... ", tag="TOMs panel", level=Qgis.Info)

    def setElement(self, restrictionID):
        self.thisRestrictionID = restrictionID
        self.setThisLayer()

        if (restrictionID is not None):
            query = '\"RestrictionID\" = \'{restrictionID}\''.format(restrictionID=restrictionID)
            request = QgsFeatureRequest().setFilterExpression(query)
            for element in self.thisLayer.getFeatures(request):
                self.thisElement = element  # make assumption that only one row
                QgsMessageLog.logMessage("In TOMsProposalElement:setElement ... " + str(self.getGeometryID()), tag="TOMs panel", level=Qgis.Info)
                return True

        QMessageBox.information(self.iface.mainWindow(), "ERROR", ("RestrictionID: \'{restrictionID}\' not found within layer {layerName}".format(restrictionID=restrictionID, layerName=self.thisLayer.name())))
        return False # either not found or 0

    def getElement(self):
        return self

    def getTilesForRestriction(self, filterDate):
        # get the tile(s) for a given restriction

        QgsMessageLog.logMessage("In getTilesForRestriction. ", tag="TOMs panel", level=Qgis.Info)

        self.tilesLayer = self.tableNames.setLayer("MapGrid")
        idxTileID = self.tableNames.setLayer("MapGrid").fields().indexFromName("id")

        dictTilesInRestriction = dict()

        QgsMessageLog.logMessage(
            "In factory. Creating Proposal Element ... " + str(self.thisRestrictionID) + ";" + str(self.thisElement.geometry().asWkt()), tag="TOMs panel", level=Qgis.Info)
        QgsMessageLog.logMessage("In getTilesForRestriction. restGeom " + self.thisElement.geometry().boundingBox().asWktPolygon(), tag="TOMs panel", level=Qgis.Info)

        request = QgsFeatureRequest().setFilterRect(self.thisElement.geometry().boundingBox()).setFlags(QgsFeatureRequest.ExactIntersect)

        currTile = TOMsTile(self.proposalsManager)

        for tile in self.tilesLayer.getFeatures(request):

            currTileNr = tile.attribute("id")
            # QgsMessageLog.logMessage("In getTilesForRestriction. Tile: " + str(currTileNr), tag="TOMs panel", level=Qgis.Info)

            if tile.geometry().intersects(self.thisElement.geometry()):
                # get revision number and add tile to list
                # currRevisionNrForTile = self.getTileRevisionNr(tile)
                QgsMessageLog.logMessage("In getTileForRestriction. Tile: " + str(tile.attribute("id")) + "; " + str(
                    tile.attribute("RevisionNr")) + "; " + str(tile.attribute("LastRevisionDate")), tag="TOMs panel", level=Qgis.Info)

                # check revision nr, etc

                """ TODO: Tidy this up ... with Tile object ..."""
                currTile.setTile(currTileNr)
                revisionNr, revisionDate = self.currTile.getTileRevisionNrAtDate(filterDate)
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
                    tag="TOMs panel", level=Qgis.Info)"""

                dictTilesInRestriction[currTileNr] = tile

                QgsMessageLog.logMessage(
                    "In getTileForRestriction. len tileSet: " + str(len(dictTilesInRestriction)),
                    tag="TOMs panel", level=Qgis.Info)

                pass

        return dictTilesInRestriction

    def clone(self):
        pass

    def acceptActionOnProposalElement(self, actionOnAcceptance):

        currProposalOpenDate = self.currProposal.getProposalOpenDate()

        # update the Open/Close date for the restriction
        QgsMessageLog.logMessage("In updateProposalElement. layer: " + str(
            self.thisLayer.name()) + " currRestId: " + self.thisRestrictionID + " Opendate: " + str(
            currProposalOpenDate), tag="TOMs panel", level=Qgis.Info)

        # clear filter currRestrictionLayer.setSubsetString("")  **** need to make sure this is done ...

        if actionOnAcceptance == RestrictionAction.OPEN:  # Open
            statusUpd = self.thisLayer.changeAttributeValue(self.thisRestrictionID,
                                                            self.thisLayer.fields().indexFromName(
                                                                      "OpenDate"),
                                                                  currProposalOpenDate)
            QgsMessageLog.logMessage(
                "In updateRestriction. " + self.thisRestrictionID + " Opened", tag="TOMs panel", level=Qgis.Info)
        else:  # Close
            statusUpd = self.thisLayer.changeAttributeValue(self.thisRestrictionID,
                                                            self.thisLayer.fields().indexFromName(
                                                                      "CloseDate"),
                                                                  currProposalOpenDate)
            QgsMessageLog.logMessage(
                "In updateRestriction. " + self.thisRestrictionID + " Closed", tag="TOMs panel", level=Qgis.Info)

        return statusUpd

        pass


class TOMsRestriction(TOMsProposalElement):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating TOMsRestriction ... ", tag="TOMs panel", level=Qgis.Info)

    def getDisplayGeometry(self):
        pass

class Bay(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating BAY ... ", tag="TOMs panel", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getDisplayGeometry(self):
        pass

class Line(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating LINE ... ", tag="TOMs panel", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getDisplayGeometry(self):
        pass

class Sign(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating SIGN ... ", tag="TOMs panel", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getDisplayGeometry(self):
        pass

class TOMsPolygonRestriction(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating POLYGON ... ", tag="TOMs panel", level=Qgis.Info)

    def getZoneType(self):
        pass

    def getDisplayGeometry(self):
        self.displayGeometry = self.featureGeometry

class PedestrianZone(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating PedestrianZone ... ", tag="TOMs panel", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass


class CPZ(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating CPZ ... ", tag="TOMs panel", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass

class PTA(TOMsRestriction):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating PTA ... ", tag="TOMs panel", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass

class TOMsLabel(TOMsProposalElement):
    def __init__(self, proposalsManager, layerID=None, restriction=None, restrictionID=None):
        super().__init__(proposalsManager, layerID, restriction, restrictionID)
        QgsMessageLog.logMessage("In factory. Creating Label ... ", tag="TOMs panel", level=Qgis.Info)

    def getGeometryID(self):
        pass

class ProposalElementFactory():

    @staticmethod
    def getProposalElement(proposalsManager, proposalElementType, restriction, RestrictionID):
        QgsMessageLog.logMessage("In factory. getProposalElement ... " + str(proposalElementType) + ";" + str(restriction), tag="TOMs panel", level=Qgis.Info)
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
            QgsMessageLog.logMessage("In ProposalElementFactory. TYPE not found or something else ... ", tag="TOMs panel", level=Qgis.Info)

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
                                     tag="TOMs panel", level=Qgis.Info)

