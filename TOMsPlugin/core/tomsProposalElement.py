# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# -----------------------------------------------------------
# Tim Hancock/Matthias Kuhn 2017
# Oslandia 2022

from typing import Any

from qgis.core import Qgis, QgsFeatureRequest
from qgis.PyQt.QtCore import QObject

from ..constants import RestrictionAction, RestrictionLayers
from .tomsMessageLog import TOMsMessageLog
from .tomsTile import TOMsTile


class TOMsProposalElement(QObject):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__()
        # restriction is restriction record ??
        TOMsMessageLog.logMessage(
            "In TOMsProposalElement ... {proposal}:{layer}:{restrictionID}".format(
                proposal=proposalsManager.currentProposal(),
                layer=layerID,
                restrictionID=restrictionID,
            ),
            level=Qgis.Info,
        )
        self.proposalsManager = proposalsManager
        self.currProposal = self.proposalsManager.currentProposalObject()
        self.tableNames = self.proposalsManager.tableNames
        self.layerID = layerID
        self.thisLayer = restrictionLayer
        self.tilesLayer: Any = None

        self.setElement(restrictionID)

    def getGeometryID(self):
        return self.thisElement["GeometryID"]

    def setThisLayer(self):
        # this is not used - see issue #305
        self.thisLayer = self.proposalsManager.getRestrictionLayerFromID(self.layerID)
        if self.thisLayer is None:
            TOMsMessageLog.logMessage(
                "In TOMsProposalElement:setThisLayer. layer NOT set !!! for "
                + str(self.layerID),
                level=Qgis.Warning,
            )
        TOMsMessageLog.logMessage(
            "In TOMsProposalElement:setThisLayer ... {}".format(self.thisLayer.name()),
            level=Qgis.Info,
        )

    def setElement(self, restrictionID):
        self.thisRestrictionID = restrictionID
        # self.setThisLayer()

        # need to save and then clear the current filter
        query = "\"RestrictionID\" = '{restrictionID}'".format(
            restrictionID=restrictionID
        )
        # context = QgsExpressionContext()
        # context.appendScopes(QgsExpressionContextUtils.globalProjectLayerScopes(self.thisLayer))

        request = QgsFeatureRequest().setFilterExpression(query)

        for element in self.thisLayer.getFeatures(request):
            # context.setFeature(element)
            self.thisElement = element  # make assumption that only one row
            TOMsMessageLog.logMessage(
                "In TOMsProposalElement:setElement ... " + str(self.getGeometryID()),
                level=Qgis.Info,
            )
            return True

        TOMsMessageLog.logMessage(
            "*** ERROR: RestrictionID: '{restrictionID}' not found within layer {layerName}".format(
                restrictionID=restrictionID, layerName=self.thisLayer.name()
            ),
            level=Qgis.Warning,
        )
        self.thisElement = None
        return False  # either not found or 0

    def getElement(self):
        if self.thisElement:
            return self
        return None

    def getTilesForRestrictionForDate(self, filterDate):
        # get the tile(s) for a given restriction

        TOMsMessageLog.logMessage("In getTilesForRestriction. ", level=Qgis.Info)

        self.tilesLayer = self.tableNames.getLayer("MapGrid")
        self.tableNames.getLayer("MapGrid").fields().indexFromName("id")

        dictTilesInRestriction = {}

        TOMsMessageLog.logMessage(
            "In factory. Creating Proposal Element ... "
            + str(self.thisRestrictionID)
            + ";"
            + str(self.thisElement.geometry().asWkt()),
            level=Qgis.Info,
        )
        TOMsMessageLog.logMessage(
            "In getTilesForRestriction. restGeom "
            + self.thisElement.geometry().boundingBox().asWktPolygon(),
            level=Qgis.Info,
        )

        request = (
            QgsFeatureRequest()
            .setFilterRect(self.thisElement.geometry().boundingBox())
            .setFlags(QgsFeatureRequest.ExactIntersect)
        )

        for tile in self.tilesLayer.getFeatures(request):

            currTileNr = tile.attribute("id")
            # TOMsMessageLog.logMessage("In getTilesForRestriction. Tile: " + str(currTileNr), level=Qgis.Info)

            if tile.geometry().intersects(self.thisElement.geometry()):
                # get revision number and add tile to list
                # currRevisionNrForTile = self.getTileRevisionNr(tile)
                TOMsMessageLog.logMessage(
                    "In getTileForRestriction. Tile: "
                    + str(tile.attribute("id"))
                    + "; "
                    + str(tile.attribute("CurrRevisionNr"))
                    + "; "
                    + str(tile.attribute("LastRevisionDate")),
                    level=Qgis.Info,
                )

                # check revision nr, etc

                # TODO: Tidy this up ... with Tile object ...
                currTile = TOMsTile(self.proposalsManager, currTileNr)

                # currTile.setTile(currTileNr)
                currRevisionNr, revisionDate = currTile.getTileRevisionNrAtDate(
                    filterDate
                )
                currTile.setRevisionNrAtDate(currRevisionNr)
                currTile.setLastRevisionDateAtDate(revisionDate)
                # tile.setAttribute("CurrRevisionNr", CurrRevisionNr)
                # tile.setAttribute("LastRevisionDate", revisionDate)
                TOMsMessageLog.logMessage(
                    "In getTileForRestriction. Tile: "
                    + str(currTile.tileNr())
                    + "; "
                    + str(currTile.getRevisionNrAtDate())
                    + "; "
                    + str(currTile.getLastRevisionDateAtDate()),
                    level=Qgis.Info,
                )

                dictTilesInRestriction[currTileNr] = currTile

        TOMsMessageLog.logMessage(
            "In getTilesForRestriction. len tileSet: "
            + str(len(dictTilesInRestriction)),
            level=Qgis.Info,
        )
        for thisTile in dictTilesInRestriction:
            TOMsMessageLog.logMessage(
                "In getTilesForRestriction. tiles returned ... {}".format(thisTile),
                level=Qgis.Info,
            )

        return dictTilesInRestriction

    def clone(self):
        pass

    def acceptActionOnProposalElement(self, actionOnAcceptance):

        currProposalOpenDate = self.currProposal.getProposalOpenDate()

        # update the Open/Close date for the restriction
        TOMsMessageLog.logMessage(
            "In TOMsProposalElement.acceptActionOnProposalElement. layer: "
            + str(self.thisLayer.name())
            + " currRestId: "
            + self.thisRestrictionID
            + " Opendate: "
            + str(currProposalOpenDate),
            level=Qgis.Info,
        )

        TOMsMessageLog.logMessage(
            "In TOMsProposalElement.acceptActionOnProposalElement. id: {}; idx: {}".format(
                self.thisElement.id(), self.thisLayer.fields().indexFromName("OpenDate")
            ),
            level=Qgis.Info,
        )

        # clear filter currRestrictionLayer.setSubsetString("")  **** need to make sure this is done ...

        if actionOnAcceptance == RestrictionAction.OPEN.value:  # Open
            statusUpd = self.thisLayer.changeAttributeValue(
                self.thisElement.id(),
                self.thisLayer.fields().indexFromName("OpenDate"),
                currProposalOpenDate,
            )
            TOMsMessageLog.logMessage(
                "In TOMsProposalElement.acceptActionOnProposalElement. {} Opened; status: {}".format(
                    self.thisRestrictionID, statusUpd
                ),
                level=Qgis.Info,
            )
        elif actionOnAcceptance == RestrictionAction.CLOSE.value:
            statusUpd = self.thisLayer.changeAttributeValue(
                self.thisElement.id(),
                self.thisLayer.fields().indexFromName("CloseDate"),
                currProposalOpenDate,
            )
            TOMsMessageLog.logMessage(
                "In TOMsProposalElement.acceptActionOnProposalElement. {} Closed; status: {}".format(
                    self.thisRestrictionID, statusUpd
                ),
                level=Qgis.Info,
            )
        else:
            raise NotImplementedError(
                f"RestrictionAction {actionOnAcceptance} not implemented"
            )

        return statusUpd


class TOMsRestriction(TOMsProposalElement):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage(
            "In factory. Creating TOMsRestriction ... {}".format(restrictionID),
            level=Qgis.Info,
        )

    def getDisplayGeometry(self):
        # TODO
        ...


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
        self.displayGeometry: Any = None

    def getZoneType(self):
        pass

    def getDisplayGeometry(self):
        self.displayGeometry = self.featureGeometry


class PedestrianZone(TOMsRestriction):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage(
            "In factory. Creating PedestrianZone ... ", level=Qgis.Info
        )

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


class MappingUpdate(TOMsRestriction):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage(
            "In factory. Creating Mapping_Update ... ", level=Qgis.Info
        )

    def getGeometryID(self):
        pass

    def getZoneType(self):
        pass


class MappingUpdateMask(TOMsRestriction):
    def __init__(self, proposalsManager, layerID, restrictionLayer, restrictionID):
        super().__init__(proposalsManager, layerID, restrictionLayer, restrictionID)
        TOMsMessageLog.logMessage(
            "In factory. Creating Mapping_Update_Mask ... ", level=Qgis.Info
        )

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


class ProposalElementFactory:
    @staticmethod
    def getProposalElement(
        proposalsManager, proposalElementTypeID, restrictionLayer, restrictionID
    ):
        TOMsMessageLog.logMessage(
            "In factory. getProposalElement ... "
            + str(proposalElementTypeID)
            + ";"
            + str(restrictionID),
            level=Qgis.Info,
        )
        if proposalElementTypeID == RestrictionLayers.BAYS.value:
            return Bay(
                proposalsManager,
                proposalElementTypeID,
                restrictionLayer,
                restrictionID,
            )
        if proposalElementTypeID == RestrictionLayers.LINES.value:
            return Line(
                proposalsManager,
                proposalElementTypeID,
                restrictionLayer,
                restrictionID,
            )
        if proposalElementTypeID == RestrictionLayers.SIGNS.value:
            return Sign(
                proposalsManager,
                proposalElementTypeID,
                restrictionLayer,
                restrictionID,
            )
        if proposalElementTypeID == RestrictionLayers.RESTRICTION_POLYGONS.value:
            return Sign(
                proposalsManager,
                proposalElementTypeID,
                restrictionLayer,
                restrictionID,
            )
            # return RestrictionPolygonFactory.getProposalElement(proposalElementType, restrictionLayer, RestrictionID)
        if proposalElementTypeID == RestrictionLayers.CPZS.value:
            return CPZ(
                proposalsManager,
                proposalElementTypeID,
                restrictionLayer,
                restrictionID,
            )
        if proposalElementTypeID == RestrictionLayers.PTAS.value:
            return PTA(
                proposalsManager,
                proposalElementTypeID,
                restrictionLayer,
                restrictionID,
            )
        if proposalElementTypeID == RestrictionLayers.MAPPING_UPDATES.value:
            return MappingUpdate(
                proposalsManager,
                proposalElementTypeID,
                restrictionLayer,
                restrictionID,
            )
        if proposalElementTypeID == RestrictionLayers.MAPPING_UPDATE_MASKS.value:
            return MappingUpdateMask(
                proposalsManager,
                proposalElementTypeID,
                restrictionLayer,
                restrictionID,
            )
        raise NotImplementedError(f"Restriction Type {proposalElementTypeID} NOT found")


#  class RestrictionPolygonFactory:
#      @staticmethod
#      def getProposalElement(proposalElementType, restrictionLayer, restrictionID):
#          try:
#              if proposalElementType == RestrictionLayers.BAYS:
#                  return Bay()
#              elif proposalElementType == RestrictionLayers.LINES:
#                  return Line()
#              elif proposalElementType == RestrictionLayers.SIGNS:
#                  return Sign()
#              elif proposalElementType == RestrictionLayers.RESTRICTION_POLYGONS:
#                  return RestrictionPolygonFactory()
#              raise AssertionError("Proposal Type NOT found")
#          except AssertionError:
#              TOMsMessageLog.logMessage(
#                  "In ProposalElementFactory. TYPE not found or something else ... ",
#                  level=Qgis.Info,
#              )
