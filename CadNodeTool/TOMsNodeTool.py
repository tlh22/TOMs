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

#from qgis.PyQt.QtGui import *
#from qgis.PyQt.QtCore import *

from qgis.PyQt.QtWidgets import (
    QDockWidget, QMessageBox
)

from qgis.PyQt.QtGui import (
    QIcon,
    QPixmap
)

from qgis.PyQt.QtCore import (
    QObject,
    QTimer,
    pyqtSignal,
    Qt
)


from TOMs.core.TOMsMessageLog import TOMsMessageLog
from qgis.core import (
    Qgis,
    QgsFeature,
    QgsGeometry,
    QgsGeometryCollection,
    QgsCurve,
    QgsCurvePolygon,
    QgsMessageLog,
    QgsMultiCurve,
    QgsPoint,
    QgsPointXY,
    QgsPointLocator,
    QgsVertexId,
    QgsVectorLayer,
    QgsRectangle,
    QgsProject,
    QgsFeatureRequest,
    QgsTolerance,
    QgsSnappingUtils,
    QgsSnappingConfig,
    QgsWkbTypes
)

from qgis.gui import (
    QgsVertexMarker,
    QgsMapToolAdvancedDigitizing,
    QgsRubberBand,
    QgsMapMouseEvent
)

import uuid
import functools

from .nodetool import NodeTool, OneFeatureFilter

from ..constants import (
    ProposalStatus,
    RestrictionAction
)

#from geomutils import is_endpoint_at_vertex_index, vertex_at_vertex_index, adjacent_vertex_index_to_endpoint, vertex_index_to_tuple

from ..mapTools import MapToolMixin
#from restrictionTypeUtils import RestrictionTypeUtils
from ..restrictionTypeUtilsClass import RestrictionTypeUtilsMixin, originalFeature
from ..core.proposalsManager import TOMsProposalsManager

# generate a subclass of Martin's class

# class TOMsNodeTool(NodeTool, MapToolMixin, TOMsConstants):
class TOMsNodeTool(MapToolMixin, RestrictionTypeUtilsMixin, NodeTool):

    def __init__(self, iface, proposalsManager, restrictionTransaction):

        TOMsMessageLog.logMessage("In TOMsNodeTool:initialising .... ", level=Qgis.Info)

        self.iface = iface
        canvas = self.iface.mapCanvas()
        cadDock = self.iface.cadDockWidget()

        NodeTool.__init__(self, canvas, cadDock)

        self.proposalsManager = proposalsManager
        self.restrictionTransaction = restrictionTransaction
        self.labelFlag = False

        self.snappingConfig = QgsSnappingConfig()
        self.snappingConfig.setMode(QgsSnappingConfig.AdvancedConfiguration)

        # get details of the selected feature
        self.selectedRestriction = self.iface.activeLayer().selectedFeatures()[0]
        TOMsMessageLog.logMessage("In TOMsNodeTool:initialising ... saving original feature + " + self.selectedRestriction.attribute("GeometryID"), level=Qgis.Info)

        # Create a copy of the feature
        self.origFeature = originalFeature()
        self.origFeature.setFeature(self.selectedRestriction)
        self.origLayer = self.iface.activeLayer()
        TOMsMessageLog.logMessage("In TOMsNodeTool:initialising ... original layer + " + self.origLayer.name(), level=Qgis.Warning)

        self.origFeature.printFeature()

        self.origLayer.geometryChanged.connect(self.on_cached_geometry_changed)
        self.origLayer.featureDeleted.connect(self.on_cached_geometry_deleted)

        advancedDigitizingPanel = iface.mainWindow().findChild(QDockWidget, 'AdvancedDigitizingTools')
        advancedDigitizingPanel.setVisible(True)
        self.setupPanelTabs(self.iface, advancedDigitizingPanel)

        self.setAdvancedDigitizingAllowed(True)
        self. setAutoSnapEnabled(True)

        self.finishEdit = False

        self.iface.mapCanvas().mapToolSet.connect(self.setUnCheck)
        self.proposalsManager.TOMsToolChanged.connect(functools.partial(self.onGeometryChanged, self.origFeature.getFeature()))

    def setUnCheck(self):
        pass

    def deactivate(self):

        TOMsMessageLog.logMessage("In TOMsNodeTool:deactivate .... ", level=Qgis.Info)
        NodeTool.deactivate(self)

    def shutDownNodeTool(self):

        TOMsMessageLog.logMessage("In TOMsNodeTool:shutDownNodeTool .... ", level=Qgis.Info)

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

        #self.iface.mapCanvas().unsetMapTool(self.mapTool)
        #NodeTool.deactivate()

    def onGeometryChanged(self, currRestriction):
        # Added by TH to deal with RestrictionsInProposals
        # When a geometry is changed; we need to check whether or not the feature is part of the current proposal
        TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. fid: " + str(currRestriction.id()) + " GeometryID: " + str(currRestriction.attribute("GeometryID")), level=Qgis.Info)

        # disconnect signal for geometryChanged
        #self.origLayer.geometryChanged.disconnect(self.on_cached_geometry_changed)
        #self.proposalsManager.TOMsToolChanged.disconnect()

        #self.currLayer = self.iface.activeLayer()
        TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. Layer: " + str(self.origLayer.name()), level=Qgis.Info)

        #currLayer.geometryChanged.disconnect(self.onGeometryChanged)
        #TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. geometryChange signal disconnected.", level=Qgis.Info)

        idxRestrictionID = self.origLayer.fields().indexFromName("RestrictionID")
        TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. currProposal: " + str(self.proposalsManager.currentProposal()), level=Qgis.Info)

        # Now obtain the changed feature (not sure which geometry)

        #currFeature = self.THgetFeature(fid, currLayer)
        #self.origFeature.printFeature()

        #currFeature = currRestriction
        newGeometry = QgsGeometry(self.feature_band.asGeometry())

        TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - newGeom incoming: " + newGeometry.asWkt(),
                                 level=Qgis.Info)

        TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. currRestrictionID: " + str(currRestriction[idxRestrictionID]), level=Qgis.Info)

        if not self.restrictionInProposal(currRestriction[idxRestrictionID], self.getRestrictionLayerTableID(self.getPrimaryLabelLayer(self.origLayer)), self.proposalsManager.currentProposal()):
            TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - adding details to RestrictionsInProposal", level=Qgis.Info)
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

            TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - attributes: " + str(newFeature.attributes()), level=Qgis.Info)

            TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - newGeom: " + newFeature.geometry().asWkt(), level=Qgis.Info)

            originalGeomBuffer = QgsGeometry(originalfeature.geometry())
            TOMsMessageLog.logMessage(
                "In TOMsNodeTool:onGeometryChanged - originalGeom: " + originalGeomBuffer.asWkt(),
                level=Qgis.Info)
            self.origLayer.changeGeometry(currRestriction.id(), originalGeomBuffer)

            TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - geometries switched.", level=Qgis.Info)

            self.addRestrictionToProposal(currRestriction[idxRestrictionID], self.getRestrictionLayerTableID(self.getPrimaryLabelLayer(self.origLayer)), self.proposalsManager.currentProposal(), RestrictionAction.CLOSE) # close the original feature
            TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - feature closed.", level=Qgis.Info)

            self.addRestrictionToProposal(newRestrictionID, self.getRestrictionLayerTableID(self.getPrimaryLabelLayer(self.origLayer)), self.proposalsManager.currentProposal(), RestrictionAction.OPEN) # open the new one
            TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - feature opened.", level=Qgis.Info)

            #self.proposalsManager.updateMapCanvas()

        else:

            # assign the changed geometry to the current feature
            #currRestriction.setGeometry(newGeometry)
            pass


        TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - newGeom (2): " + currRestriction.geometry().asWkt(),
                                 level=Qgis.Info)

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

        TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. currRestrictionID: " + str(self.currFeature[idxRestrictionID]), level=Qgis.Info)

        self.currFeature.setGeometry(newGeometry)

        TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - attributes: " + str(self.currFeature.attributes()),
                                 level=Qgis.Info)

        TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - newGeom: " + self.currFeature.geometry().asWkt(),
                                 level=Qgis.Info)

        # Trying to unset map tool to force updates ...
        #self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())

        # change active layer
        status = self.iface.setActiveLayer(None)

        self.restrictionTransaction.commitTransactionGroup(self.currLayer)
        #self.restrictionTransaction.deleteTransactionGroup()

        #QTimer.singleShot(0, functools.partial(RestrictionTypeUtils.commitRestrictionChanges, origLayer))

        #TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - geometry saved.", level=Qgis.Info)"""

        return

    def cadCanvasPressEvent(self, e):

        TOMsMessageLog.logMessage("In TOMsNodeTool:cadCanvasPressEvent", level=Qgis.Info)

        NodeTool.cadCanvasPressEvent(self, e)

        TOMsMessageLog.logMessage("In TOMsNodeTool:cadCanvasPressEvent: after NodeTool.cadCanvasPressEvent", level=Qgis.Info)

        #currLayer = self.iface.activeLayer()

        if e.button() == Qt.RightButton:
            TOMsMessageLog.logMessage("In TOMsNodeTool:cadCanvasPressEvent: right button pressed",
                                     level=Qgis.Info)

            self.finishEdit = True

            if self.origLayer.isModified():
                TOMsMessageLog.logMessage("In TOMsNodeTool:cadCanvasPressEvent: orig layer modified",
                                         level=Qgis.Info)
                self.onGeometryChanged(self.selectedRestriction)

                #RestrictionTypeUtils.commitRestrictionChanges(self.origLayer)
                #self.iface.setActiveLayer(None)  # returns bool

                pass

        return

    def cadCanvasReleaseEvent(self, e):

        TOMsMessageLog.logMessage("In TOMsNodeTool:cadCanvasReleaseEvent", level=Qgis.Info)

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
        TOMsMessageLog.logMessage("In TOMsNodeTool:snap_to_editable_layer", level=Qgis.Info)

        map_point = self.toMapCoordinates(e.pos())
        tol = QgsTolerance.vertexSearchRadius(self.canvas().mapSettings())
        snap_type = QgsPointLocator.Type(QgsPointLocator.Vertex|QgsPointLocator.Edge)

        #snap_layers = []

        ### TH: Amend to choose only from selected feature (and layer)

        """snap_layers.append(QgsSnappingUtils.LayerConfig(
            self.origLayer, snap_type, tol, QgsTolerance.ProjectUnits))"""

        """for layer in self.canvas().layers():
            if not isinstance(layer, QgsVectorLayer) or not layer.isEditable():
                continue
            snap_layers.append(QgsSnappingUtils.LayerConfig(
                layer, snap_type, tol, QgsTolerance.ProjectUnits))"""

        snap_util = self.canvas().snappingUtils()
        old_snap_util = snap_util
        snap_config = snap_util.config()

        #snap_util = QgsSnappingUtils()
        #snap_config = snap_util.config()
        # old_layers = snap_util.layers()
        # old_mode = snap_util.mode()
        # old_intersections = old_snap_config.intersectionSnapping()

        """
        for layer in snap_config.individualLayerSettings().keys():
            snap_config.removeLayers([layer])
        """

        snap_util.setCurrentLayer(self.origLayer)

        snap_config.setMode(QgsSnappingConfig.ActiveLayer)
        snap_config.setIntersectionSnapping(False)  # only snap to layers
        #m = snap_util.snapToMap(map_point)
        snap_config.setTolerance(tol)
        snap_config.setUnits(QgsTolerance.ProjectUnits)
        snap_config.setType(QgsSnappingConfig.VertexAndSegment)
        snap_config.setEnabled(True)

        """snap_config.setMode(QgsSnappingConfig.AdvancedConfiguration)

        currLayerSnapSettings = snap_config.individualLayerSettings(self.origLayer)
        currLayerSnapSettings.setTolerance(tol)
        currLayerSnapSettings.setUnits(QgsTolerance.ProjectUnits)
        currLayerSnapSettings.setType(QgsSnappingConfig.VertexAndSegment)
        currLayerSnapSettings.setEnabled(True)

        snap_config.setIndividualLayerSettings(self.origLayer, currLayerSnapSettings)"""

        # try to stay snapped to previously used feature
        # so the highlight does not jump around at nodes where features are joined
        ### TH: Amend to choose only from selected feature (and layer)

        filter_last = OneFeatureFilter(self.origLayer, self.origFeature.getFeature().id())
        # m = snap_util.snapToMap(map_point, filter_last)
        """if m_last.isValid() and m_last.distance() <= m.distance():
            m = m_last"""
        self.origFeature.printFeature()
        TOMsMessageLog.logMessage("In TOMsNodeTool:snap_to_editable_layer: origLayer " + self.origLayer.name(), level=Qgis.Info)

        """ v3 try to use some other elements of snap_config
            - snapToCurrentLayer
            - setCurrentLayer
            
        """
        TOMsMessageLog.logMessage("In TOMsNodeTool:snap_to_editable_layer: pos " + str(e.pos().x()) + "|" + str(e.pos().y()),
                                 level=Qgis.Info)
        m = snap_util.snapToCurrentLayer(e.pos(), snap_type, filter_last)
        """self.canvas().setSnappingUtils(snap_util)
        m = snap_util.snapToMap(e.pos(), filter_last)"""

        #snap_util.setLayers(old_layers)
        #snap_config.setMode(old_mode)
        #snap_config.setIntersectionSnapping(old_intersections)
        self.canvas().setSnappingUtils(old_snap_util)

        #self.last_snap = m

        # TODO: Tidy up ...

        TOMsMessageLog.logMessage("In TOMsNodeTool:snap_to_editable_layer: snap point " + str(m.type()) +";" + str(m.isValid()) + "; ", level=Qgis.Info)

        return m

    def keyPressEvent(self, e):

        TOMsMessageLog.logMessage("In TOMsNodeTool:keyPressEvent", level=Qgis.Info)

        # want to pick up "esc" and exit tool

        if e.key() == Qt.Key_Escape:

            self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())
            self.restrictionTransaction.rollBackTransactionGroup()

            self.shutDownNodeTool()

            return

        NodeTool.keyPressEvent(self, e)

class OneFeatureLabelFilter(QgsPointLocator.MatchFilter):
    """ a filter to allow just one particular feature """
    def __init__(self, layer, fid):
        QgsPointLocator.MatchFilter.__init__(self)
        self.currLayer = layer
        self.primaryLayer = self.getPrimaryLabelLayer(layer)
        self.fid = fid
        self.pkFieldName = self.primaryKeyFieldName(layer)
        self.pkFieldValue = layer.getFeature(fid).attribute(self.pkFieldName)

        TOMsMessageLog.logMessage("In OneFeatureLabelFilter: Layer {}:{} | {}:{}".format(self.currLayer.name(), self.primaryLayer.name(), str(fid), self.pkFieldValue),
                                 level=Qgis.Warning)
    def acceptMatch(self, match):
        try:
            TOMsMessageLog.logMessage("In OneFeatureLabelFilter: matchLayer {} | {} with pk {}".format(match.layer().name(), match.featureId(),
                                                                                                       match.layer().getFeature(match.featureId()).attribute(self.pkFieldName)),
                                     level=Qgis.Warning)
            # need to check whether it is in the layer or any of the child layers

            return self.getPrimaryLabelLayer(match.layer()) == self.primaryLayer and len(match.layer().name()) > len(self.primaryLayer.name()) \
                       and match.layer().getFeature(match.featureId()).attribute(self.pkFieldName) == self.pkFieldValue
        except:
            return False

    def getPrimaryLabelLayer(self, currLayer):
        # given a layer work out the primary layer

        currLayerName = currLayer.name()
        dotLocation = currLayerName.find (".")

        if dotLocation == -1:
            return currLayer
        else:
            primaryLayerName = currLayerName[:dotLocation]
            TOMsMessageLog.logMessage(
                "In getPrimaryLabelLayer: layer: {}".format(primaryLayerName),
                level=Qgis.Warning)
            return QgsProject.instance().mapLayersByName(primaryLayerName)[0]

    def getPrimaryLabelLayer(self, currLayer):
        # given a layer work out the primary layer

        currLayerName = currLayer.name()
        pointLocation = currLayerName.find (".")

        if pointLocation == -1:
            return currLayer
        else:
            primaryLayerName = currLayerName[:pointLocation]
            TOMsMessageLog.logMessage(
                "In getPrimaryLabelLayer: layer: {}".format(primaryLayerName),
                level=Qgis.Warning)
            return QgsProject.instance().mapLayersByName(primaryLayerName)[0]

    def primaryKeyFieldName(self, currLayer):
        # from Olivier Delange ...
        pk_attrs_idxs = currLayer.primaryKeyAttributes()
        assert len(pk_attrs_idxs) == 1, 'We do not support composite primary keys'
        pk_attr_idx = pk_attrs_idxs[0]
        pkFieldName = currLayer.fields().names()[pk_attr_idx]

        TOMsMessageLog.logMessage(
            "In primaryKeyFieldName: layer: {}".format(pkFieldName),
            level=Qgis.Warning)

        return pkFieldName

class TOMsLabelTool(TOMsNodeTool):

    def __init__(self, iface, proposalsManager, restrictionTransaction):

        #def __init__(self, iface, proposalsManager, restrictionTransaction, currFeature, currLayer):

        TOMsMessageLog.logMessage("In TOMsLabelTool:initialising .... ", level=Qgis.Info)

        TOMsNodeTool.__init__(self, iface, proposalsManager, restrictionTransaction)

        TOMsMessageLog.logMessage("In TOMsLabelTool: origLayer: {}".format(self.origLayer), level=Qgis.Warning)

        """labelLayer, labelFeature = self.getOrigFeatureInLabelLayer(self.origLayer,
                                                                   self.origFeature)  # TH: could this be part of origFeature

        TOMsMessageLog.logMessage("In TOMsLabelTool: origLayer: {}; labelLayer: {}".format(self.origLayer.name(), labelLayer.name()), level=Qgis.Warning)

        #self.origFeature = originalFeature()
        self.origFeature.setFeature(labelFeature)
        self.origLayer = labelLayer
        self.labelFlag = True

        self.selectedRestriction = labelFeature

        TOMsMessageLog.logMessage("In TOMsLabelTool:initialising ... original layer + " + self.origLayer.name(), level=Qgis.Info)"""

        """def getOrigFeatureInLabelLayer(self, currRestrictionLayer, feature):
        # given a feature on a layer, return the feature on the associated label layer

        currRestrictionLabelLayerName = self.getCurrLabelLayer(currRestrictionLayer)[0]
        currRestrictionLabelLayer = QgsProject.instance().mapLayersByName(currRestrictionLabelLayerName)[0]

        TOMsMessageLog.logMessage("In getOrigFeatureInLabelLayer: layer: {}".format(currRestrictionLabelLayer.name()),
                                  level=Qgis.Warning)

        # assume that the feature has been selected on this layer at an earlier time

        return currRestrictionLabelLayer, currRestrictionLabelLayer.selectedFeatures()[0]"""

    def getCurrLabelLayerNames(self, currRestrictionLayer):
        # given a layer return the associated layer with label geometry
        # get the corresponding label layer

        def alert_box(text):
            QMessageBox.information( self.iface.mainWindow(), "Information", text, QMessageBox.Ok )

        if currRestrictionLayer.name() == 'Bays':
            label_layers_names = ['Bays.label_pos', 'Bays.label_ldr']
        if currRestrictionLayer.name() == 'Lines':
            label_layers_names = ['Lines.label_pos', 'Lines.label_loading_pos', 'Lines.label_ldr',
                                  'Lines.label_loading_ldr']
        if currRestrictionLayer.name() == 'Signs':
            label_layers_names = []
        if currRestrictionLayer.name() == 'RestrictionPolygons':
            label_layers_names = ['RestrictionPolygons.label_pos', 'RestrictionPolygons.label_ldr']
        if currRestrictionLayer.name() == 'CPZs':
            label_layers_names = ['CPZs.label_pos', 'CPZs.label_ldr']
        if currRestrictionLayer.name() == 'ParkingTariffAreas':
            label_layers_names = ['ParkingTariffAreas.label_pos', 'ParkingTariffAreas.label_ldr']

        if len(label_layers_names) == 0:
            alert_box("No labels for this restriction type")
            return

        return label_layers_names

    def snap_to_editable_layer(self, e):
        """ Temporarily override snapping config and snap to vertices and edges
         of any editable vector layer, to allow selection of node for editing
         (if snapped to edge, it would offer creation of a new vertex there).
        """
        TOMsMessageLog.logMessage("In TOMsLabelTool:snap_to_editable_layer", level=Qgis.Info)

        def alert_box(text):
            QMessageBox.information( self.iface.mainWindow(), "Information", text, QMessageBox.Ok )

        map_point = self.toMapCoordinates(e.pos())
        tol = QgsTolerance.vertexSearchRadius(self.canvas().mapSettings())
        snap_type = QgsPointLocator.Type(QgsPointLocator.Vertex | QgsPointLocator.Edge)

        snap_util = self.canvas().snappingUtils()
        old_snap_util = snap_util
        snap_config = snap_util.config()

        # snap_config.clearIndividualLayerSettings() # not yet available ...
        layerList = []
        for layer in self.canvas().layers():
            if isinstance(layer, QgsVectorLayer):
                layerList.append(layer)
        snap_config.removeLayers(layerList)

        snap_layers = []

        ### TH: Amend to choose only from selected feature and label layers

        for label_layers_name in self.getCurrLabelLayerNames(self.origLayer):

            snap_layers.append(QgsProject.instance().mapLayersByName(label_layers_name)[0])

        snap_config.addLayers(snap_layers)
        snap_util.setCurrentLayer(self.origLayer)

        snap_config.setMode(QgsSnappingConfig.AdvancedConfiguration)
        snap_config.setIntersectionSnapping(False)  # only snap to layers
        # m = snap_util.snapToMap(map_point)
        snap_config.setTolerance(tol)
        snap_config.setUnits(QgsTolerance.ProjectUnits)
        snap_config.setType(QgsSnappingConfig.VertexAndSegment)
        snap_config.setEnabled(True)

        # try to stay snapped to previously used feature
        # so the highlight does not jump around at nodes where features are joined
        ### TH: Amend to choose only from selected feature (and layer)

        filter_last = OneFeatureLabelFilter(self.origLayer, self.origFeature.getFeature().id())
        # m = snap_util.snapToMap(map_point, filter_last)
        """if m_last.isValid() and m_last.distance() <= m.distance():
            m = m_last"""

        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:snap_to_editable_layer: pos " + str(e.pos().x()) + "|" + str(e.pos().y()),
            level=Qgis.Warning)
        # m = snap_util.snapToCurrentLayer(e.pos(), snap_type, filter_last)
        m = snap_util.snapToMap(e.pos(), filter_last)

        self.canvas().setSnappingUtils(old_snap_util)

        # TODO: Tidy up ...

        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:snap_to_editable_layer: snap point " + str(m.type()) + ";" + str(m.isValid()) + "; ",
            level=Qgis.Warning)

        return m

