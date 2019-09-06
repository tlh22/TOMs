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

from qgis.PyQt.QtGui import *
from qgis.PyQt.QtCore import *

from qgis.core import *
from qgis.gui import *
from qgis.utils import iface
import uuid
import functools

from .nodetool import NodeTool, OneFeatureFilter

from ..constants import (
    ACTION_CLOSE_RESTRICTION,
    ACTION_OPEN_RESTRICTION
)
#from geomutils import is_endpoint_at_vertex_index, vertex_at_vertex_index, adjacent_vertex_index_to_endpoint, vertex_index_to_tuple

from ..mapTools import MapToolMixin
#from restrictionTypeUtils import RestrictionTypeUtils
from ..restrictionTypeUtilsClass import RestrictionTypeUtilsMixin
from ..core.proposalsManager import TOMsProposalsManager

class originalFeature(object):
    def __init__(self, feature=None):
        self.savedFeature = None

    def setFeature(self, feature):
        self.savedFeature = QgsFeature(feature)
        #self.printFeature()

    def getFeature(self):
        #self.printFeature()
        return self.savedFeature

    def getGeometryID(self):
        return self.savedFeature.attribute("GeometryID")

    def printFeature(self):
        QgsMessageLog.logMessage("In TOMsNodeTool:originalFeature - attributes (fid:" + str(self.savedFeature.id()) + "): " + str(self.savedFeature.attributes()),
                                 tag="TOMs panel")
        QgsMessageLog.logMessage("In TOMsNodeTool:originalFeature - attributes: " + str(self.savedFeature.geometry().asWkt()),
                                 tag="TOMs panel")

# generate a subclass of Martin's class

# class TOMsNodeTool(NodeTool, MapToolMixin, TOMsConstants):
class TOMsNodeTool(NodeTool, MapToolMixin, RestrictionTypeUtilsMixin):

    def __init__(self, iface, proposalsManager, restrictionTransaction):

        #def __init__(self, iface, proposalsManager, restrictionTransaction, currFeature, currLayer):

        QgsMessageLog.logMessage("In TOMsNodeTool:initialising .... ", tag="TOMs panel")

        self.iface = iface
        canvas = self.iface.mapCanvas()
        cadDock = self.iface.cadDockWidget()

        NodeTool.__init__(self, canvas, cadDock)

        # set current layer to active layer to avoid any issues in NodeTools cadCanvasReleaseEvent
        #canvas.setCurrentLayer(self.iface.activeLayer())

        self.proposalsManager = proposalsManager
        self.restrictionTransaction = restrictionTransaction

        #self.constants = TOMsConstants()
        self.origFeature = originalFeature()

        # taken from mapTools.CreateRestrictionTool (not sure if they will make a difference ...)
        self.setMode(TOMsNodeTool.CaptureLine)
        self.snappingUtils = QgsSnappingUtils()
        self.snappingUtils.setSnapToMapMode(QgsSnappingUtils.SnapAdvanced)
        #RoadCasementLayer = QgsProject.instance().mapLayersByName("rc_nsg_sideofstreet")[0]

        # get details of the selected feature
        self.selectedRestriction = self.iface.activeLayer().selectedFeatures()[0]
        QgsMessageLog.logMessage("In TOMsNodeTool:initialising ... saving original feature + " + self.selectedRestriction.attribute("GeometryID"), tag="TOMs panel")

        self.origFeature.setFeature(self.selectedRestriction)
        self.origLayer = self.iface.activeLayer()
        #self.origLayer.startEditing()
        self.origFeature.printFeature()

        self.origLayer.geometryChanged.connect(self.on_cached_geometry_changed)
        self.origLayer.featureDeleted.connect(self.on_cached_geometry_deleted)

        #*** New

        #RestInProp = self.constants.RESTRICTIONS_IN_PROPOSALS_LAYER()
        #QgsMessageLog.logMessage("In init: RestInProp: " + str(RestInProp.name()), tag="TOMs panel")

        #RestInProp.editCommandEnded.connect(self.proposalsManager.updateMapCanvas())

        advancedDigitizingPanel = iface.mainWindow().findChild(QDockWidget, 'AdvancedDigitizingTools')
        advancedDigitizingPanel.setVisible(True)
        self.setupPanelTabs(self.iface, advancedDigitizingPanel)

        QgsMapToolAdvancedDigitizing.deactivate(self)
        QgsMapToolAdvancedDigitizing.activate(self)

        #self.newFeature = None
        self.finishEdit = False

        self.iface.mapCanvas().mapToolSet.connect(self.setUnCheck)
        self.proposalsManager.TOMsToolChanged.connect(functools.partial(self.onGeometryChanged, self.origFeature.getFeature()))

        # get details of the selected feature
        #self.selectedRestriction = self.iface.activeLayer().selectedFeatures()[0]
        #QgsMessageLog.logMessage("In TOMsNodeTool:initialising ... saving original feature + " + self.selectedRestriction.attribute("GeometryID"), tag="TOMs panel")

        #self.origFeature.setFeature(self.selectedRestriction)
        #self.currFeature = currFeature
        #self.currLayer = currLayer
        #self.origLayer = self.iface.activeLayer()
        #self.origLayer.startEditing()
        #self.origFeature.printFeature()

        #cache = self.cached_geometry(self.currLayer, self.currFeature.id())

        #newFeature = self.prepareRestrictionForEdit(self.selectedRestriction, self.origLayer)

        #QgsMessageLog.logMessage("In TOMsNodeTool:init - fid: " + str(self.newFid), tag="TOMs panel")
        #self.origLayer.selectByIds([self.newFid])
        #self.origLayer.selectByIds([self.newFid])

    def setUnCheck(self):
        pass

    def deactivate(self):

        QgsMessageLog.logMessage("In TOMsNodeTool:deactivate .... ", tag="TOMs panel")

        #NodeTool.deactivate()

    def shutDownNodeTool(self):

        QgsMessageLog.logMessage("In TOMsNodeTool:shutDownNodeTool .... ", tag="TOMs panel")

        # TODO: May need to disconnect geometryChange and featureDeleted signals
        self.origLayer.geometryChanged.disconnect(self.on_cached_geometry_changed)
        self.origLayer.featureDeleted.disconnect(self.on_cached_geometry_deleted)

        self.proposalsManager.TOMsToolChanged.disconnect()

        self.set_highlighted_nodes([])
        self.remove_temporary_rubber_bands()

        #currAction = self.iface.mapCanvas().mapTool().action()
        #currAction.setChecked(False)

        self.proposalPanel = self.iface.mainWindow().findChild(QDockWidget, 'ProposalPanelDockWidgetBase')
        self.setupPanelTabs(self.iface, self.proposalPanel)

        #NodeTool.deactivate()

    def onGeometryChanged(self, currRestriction):
        # Added by TH to deal with RestrictionsInProposals
        # When a geometry is changed; we need to check whether or not the feature is part of the current proposal
        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. fid: " + str(currRestriction.id()) + " GeometryID: " + str(currRestriction.attribute("GeometryID")), tag="TOMs panel")

        # disconnect signal for geometryChanged
        #self.origLayer.geometryChanged.disconnect(self.on_cached_geometry_changed)
        #self.proposalsManager.TOMsToolChanged.disconnect()

        #self.currLayer = self.iface.activeLayer()
        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. Layer: " + str(self.origLayer.name()), tag="TOMs panel")

        #currLayer.geometryChanged.disconnect(self.onGeometryChanged)
        #QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. geometryChange signal disconnected.", tag="TOMs panel")

        idxRestrictionID = self.origLayer.fields().indexFromName("RestrictionID")
        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. currProposal: " + str(self.proposalsManager.currentProposal()), tag="TOMs panel")

        # Now obtain the changed feature (not sure which geometry)

        #currFeature = self.THgetFeature(fid, currLayer)
        #self.origFeature.printFeature()

        #currFeature = currRestriction
        newGeometry = QgsGeometry(self.feature_band.asGeometry())

        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - newGeom incoming: " + newGeometry.asWkt(),
                                 tag="TOMs panel")

        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. currRestrictionID: " + str(currRestriction[idxRestrictionID]), tag="TOMs panel")

        if not self.restrictionInProposal(currRestriction[idxRestrictionID], self.getRestrictionLayerTableID(self.origLayer), self.proposalsManager.currentProposal()):
            QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - adding details to RestrictionsInProposal", tag="TOMs panel")
            #  This one is not in the current Proposal, so now we need to:
            #  - generate a new ID and assign it to the feature for which the geometry has changed
            #  - switch the geometries arround so that the original feature has the original geometry and the new feature has the new geometry
            #  - add the details to RestrictionsInProposal

            originalfeature = self.origFeature.getFeature()

            newFeature = QgsFeature(self.origLayer.fields())

            newFeature.setAttributes(currRestriction.attributes())
            newFeature.setGeometry(newGeometry)
            newRestrictionID = str(uuid.uuid4())

            newFeature[idxRestrictionID] = newRestrictionID

            idxOpenDate = self.origLayer.fields().indexFromName("OpenDate")
            idxGeometryID = self.origLayer.fields().indexFromName("GeometryID")

            newFeature[idxOpenDate] = None
            newFeature[idxGeometryID] = None

            #currLayer.addFeature(newFeature)
            self.origLayer.addFeatures([newFeature])

            QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - attributes: " + str(newFeature.attributes()), tag="TOMs panel")

            QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - newGeom: " + newFeature.geometry().asWkt(), tag="TOMs panel")

            originalGeomBuffer = QgsGeometry(originalfeature.geometry())
            QgsMessageLog.logMessage(
                "In TOMsNodeTool:onGeometryChanged - originalGeom: " + originalGeomBuffer.asWkt(),
                tag="TOMs panel")
            self.origLayer.changeGeometry(currRestriction.id(), originalGeomBuffer)

            QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - geometries switched.", tag="TOMs panel")

            self.addRestrictionToProposal(currRestriction[idxRestrictionID], self.getRestrictionLayerTableID(self.origLayer), self.proposalsManager.currentProposal(), ACTION_CLOSE_RESTRICTION()) # close the original feature
            QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - feature closed.", tag="TOMs panel")

            self.addRestrictionToProposal(newRestrictionID, self.getRestrictionLayerTableID(self.origLayer), self.proposalsManager.currentProposal(), ACTION_OPEN_RESTRICTION()) # open the new one
            QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - feature opened.", tag="TOMs panel")

            #self.proposalsManager.updateMapCanvas()

        else:

            # assign the changed geometry to the current feature
            #currRestriction.setGeometry(newGeometry)
            pass


        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - newGeom (2): " + currRestriction.geometry().asWkt(),
                                 tag="TOMs panel")

        # Trying to unset map tool to force updates ...
        #self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())
        #currMapTool = self.iface.mapCanvas().mapTool()
        #currAction = currMapTool.action()

        #currMapToolAction = self.iface.mapCanvas().mapTool().action().setChecked(False)

        # uncheck current tool


        self.restrictionTransaction.commitTransactionGroup(self.origLayer)
        #self.restrictionTransaction.deleteTransactionGroup()

        self.origLayer.deselect(self.origFeature.getFeature().id())

        self.shutDownNodeTool()

        # **** New
        """"#currRestrictionRestrictionID = currFeature[idxRestrictionID]

        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. currRestrictionID: " + str(self.currFeature[idxRestrictionID]), tag="TOMs panel")

        self.currFeature.setGeometry(newGeometry)

        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - attributes: " + str(self.currFeature.attributes()),
                                 tag="TOMs panel")

        QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - newGeom: " + self.currFeature.geometry().asWkt(),
                                 tag="TOMs panel")

        # Trying to unset map tool to force updates ...
        #self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())

        # change active layer
        status = self.iface.setActiveLayer(None)

        self.restrictionTransaction.commitTransactionGroup(self.currLayer)
        #self.restrictionTransaction.deleteTransactionGroup()

        #QTimer.singleShot(0, functools.partial(RestrictionTypeUtils.commitRestrictionChanges, origLayer))

        #QgsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - geometry saved.", tag="TOMs panel")"""

        return

    def cadCanvasPressEvent(self, e):

        QgsMessageLog.logMessage("In TOMsNodeTool:cadCanvasPressEvent", tag="TOMs panel")

        NodeTool.cadCanvasPressEvent(self, e)

        QgsMessageLog.logMessage("In TOMsNodeTool:cadCanvasPressEvent: after NodeTool.cadCanvasPressEvent", tag="TOMs panel")

        #currLayer = self.iface.activeLayer()

        if e.button() == Qt.RightButton:
            QgsMessageLog.logMessage("In TOMsNodeTool:cadCanvasPressEvent: right button pressed",
                                     tag="TOMs panel")

            self.finishEdit = True

            if self.origLayer.isModified():
                QgsMessageLog.logMessage("In TOMsNodeTool:cadCanvasPressEvent: orig layer modified",
                                         tag="TOMs panel")
                self.onGeometryChanged(self.selectedRestriction)

                #RestrictionTypeUtils.commitRestrictionChanges(self.origLayer)
                #self.iface.setActiveLayer(None)  # returns bool

                pass

        return

    def cadCanvasReleaseEvent(self, e):

        QgsMessageLog.logMessage("In TOMsNodeTool:cadCanvasReleaseEvent", tag="TOMs panel")

        if self.finishEdit == True:
            # unset Tool ??
            self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())
            return

        NodeTool.cadCanvasReleaseEvent(self, e)

    def snap_to_editable_layer(self, e):
        """ Temporarily override snapping config and snap to vertices and edges
         of any editable vector layer, to allow selection of node for editing
         (if snapped to edge, it would offer creation of a new vertex there).
        """
        #QgsMessageLog.logMessage("In TOMsNodeTool:snap_to_editable_layer", tag="TOMs panel")

        map_point = self.toMapCoordinates(e.pos())
        tol = QgsTolerance.vertexSearchRadius(self.canvas().mapSettings())
        snap_type = QgsPointLocator.Type(QgsPointLocator.Vertex|QgsPointLocator.Edge)

        snap_layers = []

        ### TH: Amend to choose only from selected feature (and layer)

        snap_layers.append(QgsSnappingUtils.LayerConfig(
            self.origLayer, snap_type, tol, QgsTolerance.ProjectUnits))

        """for layer in self.canvas().layers():
            if not isinstance(layer, QgsVectorLayer) or not layer.isEditable():
                continue
            snap_layers.append(QgsSnappingUtils.LayerConfig(
                layer, snap_type, tol, QgsTolerance.ProjectUnits))"""


        snap_util = self.canvas().snappingUtils()
        old_layers = snap_util.layers()
        old_mode = snap_util.snapToMapMode()
        old_intersections = snap_util.snapOnIntersections()
        snap_util.setLayers(snap_layers)
        snap_util.setSnapToMapMode(QgsSnappingUtils.SnapAdvanced)
        snap_util.setSnapOnIntersections(False)  # only snap to layers
        #m = snap_util.snapToMap(map_point)

        # try to stay snapped to previously used feature
        # so the highlight does not jump around at nodes where features are joined

        ### TH: Amend to choose only from selected feature (and layer)

        filter_last = OneFeatureFilter(self.origLayer, self.origFeature.savedFeature.id())
        m = snap_util.snapToMap(map_point, filter_last)
        """if m_last.isValid() and m_last.distance() <= m.distance():
            m = m_last"""

        snap_util.setLayers(old_layers)
        snap_util.setSnapToMapMode(old_mode)
        snap_util.setSnapOnIntersections(old_intersections)

        #self.last_snap = m

        return m

    def keyPressEvent(self, e):

        QgsMessageLog.logMessage("In TOMsNodeTool:keyPressEvent", tag="TOMs panel")

        # want to pick up "esc" and exit tool

        if e.key() == Qt.Key_Escape:

            self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())
            self.restrictionTransaction.rollBackTransactionGroup()

            self.shutDownNodeTool()

            return

        NodeTool.keyPressEvent(self, e)