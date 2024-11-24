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
    QgsRectangle,
    QgsExpressionContext,
    QgsExpressionContextUtils,

)

from ..constants import (
    ProposalStatus,
    RestrictionAction,
    RestrictionLayers
)

from abc import ABCMeta, abstractstaticmethod
from TOMs.core.TOMsTile import (TOMsTile)

class TOMsProposalElement(QObject):
    #def __init__(self, proposalsManager, layerID, restriction, restrictionID):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__()
        # restriction is restriction record ??
        TOMsMessageLog.logMessage("In TOMsProposalElement ... {proposal}:{layer}:{restrictionID}".format(proposal=proposalsManager.currentProposal(), layer=layerID, restrictionID=restrictionID), level=Qgis.Info)
        self.proposalsManager = proposalsManager
        self.currProposal = self.proposalsManager.currentProposalObject()
        self.tableNames = self.proposalsManager.tableNames
        self.layerID = layerID
        self.thisLayer = restrictionLayer

        status = self.setElement(restrictionID)

    def getGeometryID(self):
        return self.thisElement["GeometryID"]

    def setThisLayer(self):
        # this is not used - see issue #305
        self.thisLayer = self.proposalsManager.getRestrictionLayerFromID(self.layerID)
        if self.thisLayer is None:
            TOMsMessageLog.logMessage("In TOMsProposalElement:setThisLayer. layer NOT set !!! for " + str(self.layerID), level=Qgis.Warning)
        TOMsMessageLog.logMessage("In TOMsProposalElement:setThisLayer ... {}".format(self.thisLayer.name()), level=Qgis.Info)

    def setElement(self, restrictionID):
        self.thisRestrictionID = restrictionID

        # need to save and then clear the current filter

        query = '\"RestrictionID\" = \'{restrictionID}\''.format(restrictionID=restrictionID)

        request = QgsFeatureRequest().setFilterExpression(query)

        for element in self.thisLayer.getFeatures(request):
            self.thisElement = element  # make assumption that only one row
            TOMsMessageLog.logMessage("In TOMsProposalElement:setElement ... " + str(self.getGeometryID()), level=Qgis.Info)
            return True

        TOMsMessageLog.logMessage("*** ERROR: RestrictionID: \'{restrictionID}\' not found within layer {layerName}".format(restrictionID=restrictionID, layerName=self.thisLayer.name()), level=Qgis.Warning)
        self.thisElement = None
        return False # either not found or 0

    def getElement(self):
        if self.thisElement:
            return self
        return None

    def getTilesForRestrictionForDate(self, filterDate):
        # get the tile(s) for a given restriction

        TOMsMessageLog.logMessage("In getTilesForRestriction. ", level=Qgis.Info)

        self.tilesLayer = self.tableNames.setLayer("MapGrid")
        idxTileID = self.tableNames.setLayer("MapGrid").fields().indexFromName("id")

        dictTilesInRestriction = dict()

        TOMsMessageLog.logMessage(
            "In factory. Creating Proposal Element ... " + str(self.thisRestrictionID) + ";" + str(self.thisElement.geometry().asWkt()), level=Qgis.Info)
        TOMsMessageLog.logMessage("In getTilesForRestriction. restGeom " + self.thisElement.geometry().boundingBox().asWktPolygon(), level=Qgis.Info)

        request = QgsFeatureRequest().setFilterRect(self.thisElement.geometry().boundingBox()).setFlags(QgsFeatureRequest.ExactIntersect)

        for tile in self.tilesLayer.getFeatures(request):

            currTileNr = tile.attribute("id")
            # TOMsMessageLog.logMessage("In getTilesForRestriction. Tile: " + str(currTileNr), level=Qgis.Info)

            if tile.geometry().intersects(self.thisElement.geometry()):
                # get revision number and add tile to list
                # currRevisionNrForTile = self.getTileRevisionNr(tile)
                TOMsMessageLog.logMessage("In getTileForRestriction. Tile: " + str(tile.attribute("id")) + "; " + str(
                    tile.attribute("CurrRevisionNr")) + "; " + str(tile.attribute("LastRevisionDate")), level=Qgis.Info)

                # check revision nr, etc

                """ TODO: Tidy this up ... with Tile object ..."""
                currTile = TOMsTile(self.proposalsManager, currTileNr)

                #currTile.setTile(currTileNr)
                currRevisionNr, revisionDate = currTile.getTileRevisionNrAtDate(filterDate)
                currTile.setRevisionNr_AtDate(currRevisionNr)
                currTile.setLastRevisionDate_AtDate(revisionDate)
                #tile.setAttribute("CurrRevisionNr", CurrRevisionNr)
                #tile.setAttribute("LastRevisionDate", revisionDate)
                TOMsMessageLog.logMessage("In getTileForRestriction. Tile: " + str(currTile.tileNr()) + "; " + str(
                    currTile.getRevisionNr_AtDate()) + "; " + str(currTile.getLastRevisionDate_AtDate()), level=Qgis.Info)

                dictTilesInRestriction[currTileNr] = currTile

        TOMsMessageLog.logMessage(
                    "In getTilesForRestriction. len tileSet: " + str(len(dictTilesInRestriction)),
                    level=Qgis.Info)
        for thisTile in dictTilesInRestriction:
            TOMsMessageLog.logMessage('In getTilesForRestriction. tiles returned ... {}'.format(thisTile), level=Qgis.Info)

        return dictTilesInRestriction

    def clone(self):
        pass

    def acceptActionOnProposalElement(self, actionOnAcceptance):

        currProposalOpenDate = self.currProposal.getProposalOpenDate()

        # update the Open/Close date for the restriction
        TOMsMessageLog.logMessage("In TOMsProposalElement.acceptActionOnProposalElement. layer: " + str(
            self.thisLayer.name()) + " currRestId: " + self.thisRestrictionID + " Opendate: " + str(
            currProposalOpenDate), level=Qgis.Info)

        TOMsMessageLog.logMessage("In TOMsProposalElement.acceptActionOnProposalElement. id: {}; idx: {}".format(self.thisElement.id(), self.thisLayer.fields().indexFromName("OpenDate")), level=Qgis.Info)

        # clear filter currRestrictionLayer.setSubsetString("")  **** need to make sure this is done ...

        if actionOnAcceptance == RestrictionAction.OPEN:  # Open
            statusUpd = self.thisLayer.changeAttributeValue(self.thisElement.id(),
                                                            self.thisLayer.fields().indexFromName(
                                                                      "OpenDate"),
                                                                  currProposalOpenDate)
            TOMsMessageLog.logMessage(
                "In TOMsProposalElement.acceptActionOnProposalElement. {} Opened; status: {}".format(self.thisRestrictionID, statusUpd), level=Qgis.Info)
        else:  # Close
            statusUpd = self.thisLayer.changeAttributeValue(self.thisElement.id(),
                                                            self.thisLayer.fields().indexFromName(
                                                                      "CloseDate"),
                                                                  currProposalOpenDate)
            TOMsMessageLog.logMessage(
                "In TOMsProposalElement.acceptActionOnProposalElement. {} Closed; status: {}".format(self.thisRestrictionID, statusUpd), level=Qgis.Info)

        return statusUpd


class TOMsRestriction(TOMsProposalElement):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating TOMsRestriction ... {}".format(restrictionID), level=Qgis.Info)

    def getDisplayGeometry(self):
        # TODO: ...
        pass

class Bay(TOMsRestriction):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage("Creating BAY ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getDisplayGeometry(self):
        pass

class Line(TOMsRestriction):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating LINE ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getDisplayGeometry(self):
        pass

class Sign(TOMsRestriction):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating SIGN ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getDisplayGeometry(self):
        pass

class TOMsPolygonRestriction(TOMsRestriction):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating POLYGON ... ", level=Qgis.Info)

    def getZoneType(self):
        pass

    def getDisplayGeometry(self):
        self.displayGeometry = self.featureGeometry

class PedestrianZone(TOMsRestriction):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating PedestrianZone ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass


class CPZ(TOMsRestriction):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating CPZ ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass

class PTA(TOMsRestriction):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating PTA ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass

class MAPPING_UPDATE(TOMsRestriction):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating Mapping_Update ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass

class MAPPING_UPDATE_MASK(TOMsRestriction):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating Mapping_Update_Mask ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass

class TOMsLabel(TOMsProposalElement):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage("In factory. Creating Label ... ", level=Qgis.Info)

    def getGeometryID(self):
        pass

class ProposalElementFactory():

    @staticmethod
    def getProposalElement(proposalsManager, proposalElementType, restrictionLayer, RestrictionID):
        TOMsMessageLog.logMessage("In factory. getProposalElement ... " + str(proposalElementType) + ";" + str(RestrictionID), level=Qgis.Info)
        try:
            if proposalElementType == RestrictionLayers.BAYS:
                return Bay(proposalsManager, proposalElementType, restrictionLayer, RestrictionID)
            elif proposalElementType == RestrictionLayers.LINES:
                return Line(proposalsManager, proposalElementType, restrictionLayer, RestrictionID)
            elif proposalElementType == RestrictionLayers.SIGNS:
                return Sign(proposalsManager, proposalElementType,  restrictionLayer, RestrictionID)
            elif proposalElementType == RestrictionLayers.RESTRICTION_POLYGONS:
                return Sign(proposalsManager, proposalElementType, restrictionLayer, RestrictionID)
                # return RestrictionPolygonFactory.getProposalElement(proposalElementType, restrictionLayer, RestrictionID)
            elif proposalElementType == RestrictionLayers.CPZS:
                return CPZ(proposalsManager, proposalElementType, restrictionLayer, RestrictionID)
            elif proposalElementType == RestrictionLayers.PTAS:
                return PTA(proposalsManager, proposalElementType, restrictionLayer, RestrictionID)
            elif proposalElementType == RestrictionLayers.MAPPING_UPDATES:
                return MAPPING_UPDATE(proposalsManager, proposalElementType, restrictionLayer, RestrictionID)
            elif proposalElementType == RestrictionLayers.MAPPING_UPDATE_MASKS:
                return MAPPING_UPDATE_MASK(proposalsManager, proposalElementType, restrictionLayer, RestrictionID)
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

