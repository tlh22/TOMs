#-----------------------------------------------------------
# Copyright (C) 2015 Martin Dobias
#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock 2017

import math

from PyQt4.QtGui import *
from PyQt4.QtCore import *

from qgis.core import *
from qgis.gui import *
from qgis.utils import iface
import uuid
import functools

from TOMs.CadNodeTool.nodetool import NodeTool

from TOMs.constants import (
    ACTION_CLOSE_RESTRICTION,
    ACTION_OPEN_RESTRICTION
)
#from geomutils import is_endpoint_at_vertex_index, vertex_at_vertex_index, adjacent_vertex_index_to_endpoint, vertex_index_to_tuple

from TOMs.mapTools import MapToolMixin
from TOMs.restrictionTypeUtils import RestrictionTypeUtils
from TOMs.core.proposalsManager import TOMsProposalsManager

class originalFeature(object):
    def __init__(self, feature=None):
        self.savedFeature = None

    def setFeature(self, feature):
        self.savedFeature = QgsFeature(feature)
        #self.printFeature()

    def getFeature(self):
        #self.printFeature()
        return self.savedFeature

    def printFeature(self):
        QgsMessageLog.logMessage("In TOMsNodeTool:originalFeature - attributes: " + str(self.savedFeature.attributes()),
                                 tag="TOMs panel")
# generate a subclass of Martin's class

# class TOMsNodeTool(NodeTool, MapToolMixin, TOMsConstants):
class TOMsNodeTool(NodeTool, MapToolMixin):

    def __init__(self, iface, proposalsManager):

        self.iface = iface
        canvas = self.iface.mapCanvas()
        cadDock = self.iface.cadDockWidget()

        NodeTool.__init__(self, canvas, cadDock)

        self.proposalsManager = proposalsManager

        #self.constants = TOMsConstants()
        self.origFeature = originalFeature()

        # taken from mapTools.CreateRestrictionTool (not sure if they will make a difference ...)
        self.setMode(TOMsNodeTool.CaptureLine)
        self.snappingUtils = QgsSnappingUtils()
        self.snappingUtils.setSnapToMapMode(QgsSnappingUtils.SnapAdvanced)
        #RoadCasementLayer = QgsMapLayerRegistry.instance().mapLayersByName("rc_nsg_sideofstreet")[0]


        #RestInProp = self.constants.RESTRICTIONS_IN_PROPOSALS_LAYER()
        #QgsMessageLog.logMessage("In init: RestInProp: " + str(RestInProp.name()), tag="TOMs panel")

        #RestInProp.editCommandEnded.connect(self.proposalsManager.updateMapCanvas())

    """def deactivate(self):
        pass """

    def THgetFeature(self, fid, layer):
        fids = [fid]
        request = QgsFeatureRequest()
        request.setFilterFids(fids)

        features = layer.getFeatures(request)
        # can now iterate and do fun stuff:
        for feature in features:
            QgsMessageLog.logMessage("In THgetFeature: returning feature", tag="TOMs panel")
            return feature

        return None

    def onGeometryChanged(self, fid, newGeometry=None):
        # Added by TH to deal with RestrictionsInProposals
        # When a geometry is changed; we need to check whether or not the feature is part of the current proposal
        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. fid: " + str(fid), tag="TOMs panel")

        currLayer = self.iface.activeLayer()
        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. closestLayer: " + str(currLayer.name()), tag="TOMs panel")

        currLayer.geometryChanged.disconnect(self.onGeometryChanged)
        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. geometryChange signal disconnected.", tag="TOMs panel")

        idxRestrictionID = currLayer.fieldNameIndex("RestrictionID")
        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. currProposal: " + str(self.proposalsManager.currentProposal()), tag="TOMs panel")

        # Now obtain the changed feature (not sure which geometry)

        currFeature = self.THgetFeature(fid, currLayer)

        #currRestrictionRestrictionID = currFeature[idxRestrictionID]

        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. currRestrictionID: " + str(currFeature[idxRestrictionID]), tag="TOMs panel")

        if not RestrictionTypeUtils.restrictionInProposal(currFeature[idxRestrictionID], RestrictionTypeUtils.getRestrictionLayerTableID(currLayer), self.proposalsManager.currentProposal()):
            QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - adding details to RestrictionsInProposal", tag="TOMs panel")
            #  This one is not in the current Proposal, so now we need to:
            #  - generate a new ID and assign it to the feature for which the geometry has changed
            #  - switch the geometries arround so that the original feature has the original geometry and the new feature has the new geometry
            #  - add the details to RestrictionsInProposal

            newFeature = QgsFeature(currFeature)
            newFeature.setGeometry(newGeometry)
            newRestrictionID = str(uuid.uuid4())

            newFeature[idxRestrictionID] = newRestrictionID

            idxOpenDate = currLayer.fieldNameIndex("OpenDate")
            idxGeometryID = currLayer.fieldNameIndex("GeometryID")

            newFeature[idxOpenDate] = None
            newFeature[idxGeometryID] = None

            currLayer.addFeature(newFeature)

            QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - attributes: " + str(newFeature.attributes()), tag="TOMs panel")

            QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - newGeom: " + newFeature.geometry().exportToWkt(), tag="TOMs panel")

            originalfeature = self.origFeature.getFeature()

            QgsMessageLog.logMessage(
                "In TOMsNodeTool:onGeometryChanged - originalGeom: " + originalfeature.geometry().exportToWkt(),
                tag="TOMs panel")

            originalGeomBuffer = QgsGeometry(originalfeature.geometry())
            currLayer.changeGeometry(fid, originalGeomBuffer)

            QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - geometries switched.", tag="TOMs panel")

            RestrictionTypeUtils.addRestrictionToProposal(currFeature[idxRestrictionID], RestrictionTypeUtils.getRestrictionLayerTableID(currLayer), self.proposalsManager.currentProposal(), ACTION_CLOSE_RESTRICTION()) # close the original feature
            QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - feature closed.", tag="TOMs panel")

            RestrictionTypeUtils.addRestrictionToProposal(newRestrictionID, RestrictionTypeUtils.getRestrictionLayerTableID(currLayer), self.proposalsManager.currentProposal(), ACTION_OPEN_RESTRICTION()) # open the new one
            QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - feature opened.", tag="TOMs panel")


            #self.proposalsManager.updateMapCanvas()

        pass

        # RestrictionTypeUtils.commitRestrictionChanges(currLayer)
        #QTimer.singleShot(0, functools.partial(RestrictionTypeUtils.commitRestrictionChanges, currLayer))

        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - resetting geometry changed event.", tag="TOMs panel")

        currLayer.geometryChanged.connect(self.onGeometryChanged)

    def cadCanvasPressEvent(self, e):

        QgsMessageLog.logMessage("In TOMsNodeTool:cadCanvasPressEvent", tag="TOMs panel")

        # from the location, check that this is one of the restriction layers.
        # If so, set make this the current layer and turn on editing

        closestFeature, closestLayer = self.findNearestFeatureAt(e.pos())
        # QgsMessageLog.logMessage("In TOMsNodeTool:can_use_current_layer.  layer is " + str(closestLayer.name()), tag="TOMs panel")

        # Check if the closest layer is the current active layer

        if closestLayer == self.iface.activeLayer():

            #self.iface.mapCanvas().unsetMapTool(self)
            closestLayer.startEditing()
            # self.iface.setActiveLayer(closestLayer)  # returns bool
            #self.iface.mapCanvas().setMapTool(self)

            #self.iface.canvas().setCurrentLayer(closestLayer)
            # self.iface.mapCanvas().setCurrentLayer() = closestLayer  # Need to be able to set current layer
            # layer = self.canvas().currentLayer()

            QgsMessageLog.logMessage("In TOMsNodeTool:can_use_current_layer.  layer is " + str(closestLayer.name()), tag="TOMs panel")

            # **** Somehow need to be able to get a copy of closestFeature (or the geometry at least) and have it available within onGeometryChanged

            selectedRestriction = self.iface.activeLayer().selectedFeatures()[0]
            self.origFeature.setFeature(selectedRestriction)

            closestLayer.geometryChanged.connect(self.onGeometryChanged)

            QgsMessageLog.logMessage("In TOMsNodeTool:cadCanvasPressEvent: geometryChanged connected", tag="TOMs panel")

        NodeTool.cadCanvasPressEvent(self, e)

        QgsMessageLog.logMessage("In TOMsNodeTool:cadCanvasPressEvent: after NodeTool.cadCanvasPressEvent", tag="TOMs panel")

        #self.iface.setActiveLayer(None)  # returns bool
        #return None

        return
