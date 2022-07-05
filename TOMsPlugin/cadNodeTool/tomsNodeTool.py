# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# -----------------------------------------------------------
# Martin Dobias 2015
# Tim Hancock 2017
# Oslandia 2022

import functools
import uuid
from typing import Any

from qgis.core import (
    Qgis,
    QgsFeature,
    QgsGeometry,
    QgsPointLocator,
    QgsProject,
    QgsSnappingConfig,
    QgsTolerance,
    QgsVectorLayer,
    QgsWkbTypes,
)
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import QDockWidget, QMessageBox, QPushButton

from ..constants import RestrictionAction
from ..core.proposalsManager import TOMsProposalsManager
from ..core.tomsMessageLog import TOMsMessageLog
from ..core.tomsTransaction import TOMsTransaction
from ..mapTools import MapToolMixin
from ..restrictionTypeUtilsClass import (
    OriginalFeature,
    RestrictionTypeUtilsMixin,
    TOMsLabelLayerNames,
)
from .nodetool import NodeTool, OneFeatureFilter


class TOMsNodeTool(MapToolMixin, RestrictionTypeUtilsMixin, NodeTool):
    """generate a subclass of Martin's class"""

    def __init__(
        self,
        iface: Any,
        proposalsManager: TOMsProposalsManager,
        restrictionTransaction: TOMsTransaction,
    ):  # pylint: disable=super-init-not-called

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
        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:initialising ... saving original feature + "
            + self.selectedRestriction.attribute("GeometryID"),
            level=Qgis.Info,
        )

        # Create a copy of the feature
        self.origFeature = OriginalFeature()
        self.origFeature.setFeature(self.selectedRestriction)
        self.origLayer = self.iface.activeLayer()
        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:initialising ... original layer + "
            + self.origLayer.name(),
            level=Qgis.Warning,
        )

        self.origFeature.printFeature()

        self.origLayer.geometryChanged.connect(self.onCachedGeometryChanged)
        self.origLayer.featureDeleted.connect(self.onCachedGeometryDeleted)

        advancedDigitizingPanel = iface.mainWindow().findChild(
            QDockWidget, "AdvancedDigitizingTools"
        )
        advancedDigitizingPanel.setVisible(True)
        self.setupPanelTabs(self.iface, advancedDigitizingPanel)

        self.setAdvancedDigitizingAllowed(True)
        self.setAutoSnapEnabled(True)

        self.finishEdit = False

        self.iface.mapCanvas().mapToolSet.connect(self.setUnCheck)
        self.proposalsManager.tomsToolChanged.connect(
            functools.partial(self.onGeometryChanged, self.origFeature.getFeature())
        )

    def setUnCheck(self):
        pass

    def deactivate(self):

        TOMsMessageLog.logMessage("In TOMsNodeTool:deactivate .... ", level=Qgis.Info)
        NodeTool.deactivate(self)

    def shutDownNodeTool(self):

        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:shutDownNodeTool .... ", level=Qgis.Info
        )

        # TODO: May need to disconnect geometryChange and featureDeleted signals
        try:
            self.origLayer.geometryChanged.disconnect(self.onCachedGeometryChanged)
            self.origLayer.featureDeleted.disconnect(self.onCachedGeometryDeleted)
            self.proposalsManager.tomsToolChanged.disconnect()
        except Exception as e:
            TOMsMessageLog.logMessage(
                "shutDownNodeTool: error: {}".format(e), level=Qgis.Warning
            )
        # TODO: catch not connected signal and ignore

        self.setHighlightedNodes([])
        self.removeTemporaryRubberBands()

        # currAction = self.iface.mapCanvas().mapTool().action()
        # currAction.setChecked(False)

        self.proposalPanel = self.iface.mainWindow().findChild(
            QDockWidget, "ProposalPanelDockWidgetBase"
        )
        self.setupPanelTabs(self.iface, self.proposalPanel)

        # self.iface.mapCanvas().unsetMapTool(self.mapTool)
        # NodeTool.deactivate()

    def onGeometryChanged(self, currRestriction):
        # Added by TH to deal with RestrictionsInProposals
        # When a geometry is changed; we need to check whether or not the feature is part of the current proposal
        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:onGeometryChanged. fid: "
            + str(currRestriction.id())
            + " GeometryID: "
            + str(currRestriction.attribute("GeometryID")),
            level=Qgis.Info,
        )

        # disconnect signal for geometryChanged
        # self.origLayer.geometryChanged.disconnect(self.on_cached_geometry_changed)
        # self.proposalsManager.TOMsToolChanged.disconnect()

        # self.currLayer = self.iface.activeLayer()
        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:onGeometryChanged. Layer: " + str(self.origLayer.name()),
            level=Qgis.Info,
        )

        # currLayer.geometryChanged.disconnect(self.onGeometryChanged)
        # TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged. geometryChange signal disconnected.", level=Qgis.Info)

        idxRestrictionID = self.origLayer.fields().indexFromName("RestrictionID")
        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:onGeometryChanged. currProposal: "
            + str(self.proposalsManager.currentProposal()),
            level=Qgis.Info,
        )

        # Now obtain the changed feature (not sure which geometry)

        # currFeature = self.THgetFeature(fid, currLayer)
        # self.origFeature.printFeature()

        # currFeature = currRestriction
        newGeometry = QgsGeometry(self.featureBan.asGeometry())
        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:onGeometryChanged - newGeom incoming: "
            + newGeometry.asWkt(),
            level=Qgis.Info,
        )

        # 10/9/21 for some reason, not creating multi type instead of single for polygons - giving postgis error
        if newGeometry.type() == QgsWkbTypes.PolygonGeometry:
            newGeometry.convertToSingleType()

        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:onGeometryChanged. currRestrictionID: "
            + str(currRestriction[idxRestrictionID]),
            level=Qgis.Info,
        )

        if not self.restrictionInProposal(
            currRestriction[idxRestrictionID],
            self.getRestrictionLayerTableID(self.getPrimaryLabelLayer(self.origLayer)),
            self.proposalsManager.currentProposal(),
        ):
            TOMsMessageLog.logMessage(
                "In TOMsNodeTool:onGeometryChanged - adding details to RestrictionsInProposal",
                level=Qgis.Info,
            )
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

            # currLayer.addFeature(newFeature)
            self.origLayer.addFeatures([newFeature])

            TOMsMessageLog.logMessage(
                "In TOMsNodeTool:onGeometryChanged - attributes: "
                + str(newFeature.attributes()),
                level=Qgis.Info,
            )

            TOMsMessageLog.logMessage(
                "In TOMsNodeTool:onGeometryChanged - newGeom: "
                + newFeature.geometry().asWkt(),
                level=Qgis.Info,
            )

            originalGeomBuffer = QgsGeometry(originalfeature.geometry())
            TOMsMessageLog.logMessage(
                "In TOMsNodeTool:onGeometryChanged - originalGeom: "
                + originalGeomBuffer.asWkt(),
                level=Qgis.Info,
            )
            self.origLayer.changeGeometry(currRestriction.id(), originalGeomBuffer)

            TOMsMessageLog.logMessage(
                "In TOMsNodeTool:onGeometryChanged - geometries switched.",
                level=Qgis.Info,
            )

            self.addRestrictionToProposal(
                currRestriction[idxRestrictionID],
                self.getRestrictionLayerTableID(
                    self.getPrimaryLabelLayer(self.origLayer)
                ),
                self.proposalsManager.currentProposal(),
                RestrictionAction.CLOSE,
            )  # close the original feature
            TOMsMessageLog.logMessage(
                "In TOMsNodeTool:onGeometryChanged - feature closed.", level=Qgis.Info
            )

            self.addRestrictionToProposal(
                newRestrictionID,
                self.getRestrictionLayerTableID(
                    self.getPrimaryLabelLayer(self.origLayer)
                ),
                self.proposalsManager.currentProposal(),
                RestrictionAction.OPEN,
            )  # open the new one
            TOMsMessageLog.logMessage(
                "In TOMsNodeTool:onGeometryChanged - feature opened.", level=Qgis.Info
            )

            # if there are label layers, update those so that new feature is available
            layerDetails = TOMsLabelLayerNames(self.origLayer)

            for labelLayerName in layerDetails.getCurrLabelLayerNames():
                labelLayer = QgsProject.instance().mapLayersByName(labelLayerName)[0]
                labelLayer.reload()

        else:

            # assign the changed geometry to the current feature
            # currRestriction.setGeometry(newGeometry)
            pass

        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:onGeometryChanged - newGeom (2): "
            + currRestriction.geometry().asWkt(),
            level=Qgis.Info,
        )

        # Trying to unset map tool to force updates ...
        # self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())
        # currMapTool = self.iface.mapCanvas().mapTool()
        # currAction = currMapTool.action()

        # currMapToolAction = self.iface.mapCanvas().mapTool().action().setChecked(False)

        # uncheck current tool

        self.restrictionTransaction.commitTransactionGroup()
        # self.restrictionTransaction.deleteTransactionGroup()

        self.origLayer.deselect(self.origFeature.getFeature().id())

        self.shutDownNodeTool()

    def cadCanvasPressEvent(self, e):

        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:cadCanvasPressEvent", level=Qgis.Info
        )

        NodeTool.cadCanvasPressEvent(self, e)

        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:cadCanvasPressEvent: after NodeTool.cadCanvasPressEvent",
            level=Qgis.Info,
        )

        # currLayer = self.iface.activeLayer()

        if e.button() == Qt.RightButton:
            TOMsMessageLog.logMessage(
                "In TOMsNodeTool:cadCanvasPressEvent: right button pressed",
                level=Qgis.Info,
            )

            self.finishEdit = True

            if self.origLayer.isModified():
                TOMsMessageLog.logMessage(
                    "In TOMsNodeTool:cadCanvasPressEvent: orig layer modified",
                    level=Qgis.Info,
                )
                self.onGeometryChanged(self.selectedRestriction)

                # RestrictionTypeUtils.commitRestrictionChanges(self.origLayer)
                # self.iface.setActiveLayer(None)  # returns bool

                pass

        return

    def cadCanvasReleaseEvent(self, e):

        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:cadCanvasReleaseEvent", level=Qgis.Info
        )

        if self.finishEdit:
            # unset Tool ??
            self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())
            return

        NodeTool.cadCanvasReleaseEvent(self, e)

    def snapToEditableLayer(self, e):
        """Temporarily override snapping config and snap to vertices and edges
        of any editable vector layer, to allow selection of node for editing
        (if snapped to edge, it would offer creation of a new vertex there).
        """
        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:snap_to_editable_layer", level=Qgis.Info
        )

        tol = QgsTolerance.vertexSearchRadius(self.canvas().mapSettings())
        snapType = QgsPointLocator.Type(QgsPointLocator.Vertex | QgsPointLocator.Edge)

        # snap_layers = []

        # TH: Amend to choose only from selected feature (and layer)

        snapUtil = self.canvas().snappingUtils()
        oldSnapUtil = snapUtil
        snapConfig = snapUtil.config()

        snapUtil.setCurrentLayer(self.origLayer)

        snapConfig.setMode(QgsSnappingConfig.ActiveLayer)
        snapConfig.setIntersectionSnapping(False)  # only snap to layers
        # m = snap_util.snapToMap(map_point)
        snapConfig.setTolerance(tol)
        snapConfig.setUnits(QgsTolerance.ProjectUnits)
        snapConfig.setType(QgsSnappingConfig.VertexAndSegment)
        snapConfig.setEnabled(True)

        """snap_config.setMode(QgsSnappingConfig.AdvancedConfiguration)

        currLayerSnapSettings = snap_config.individualLayerSettings(self.origLayer)
        currLayerSnapSettings.setTolerance(tol)
        currLayerSnapSettings.setUnits(QgsTolerance.ProjectUnits)
        currLayerSnapSettings.setType(QgsSnappingConfig.VertexAndSegment)
        currLayerSnapSettings.setEnabled(True)

        snap_config.setIndividualLayerSettings(self.origLayer, currLayerSnapSettings)"""

        # try to stay snapped to previously used feature
        # so the highlight does not jump around at nodes where features are joined
        # TH: Amend to choose only from selected feature (and layer)

        filterLast = OneFeatureFilter(
            self.origLayer, self.origFeature.getFeature().id()
        )
        # m = snap_util.snapToMap(map_point, filter_last)
        """if m_last.isValid() and m_last.distance() <= m.distance():
            m = m_last"""
        self.origFeature.printFeature()
        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:snap_to_editable_layer: origLayer "
            + self.origLayer.name(),
            level=Qgis.Info,
        )

        """ v3 try to use some other elements of snap_config
            - snapToCurrentLayer
            - setCurrentLayer

        """
        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:snap_to_editable_layer: pos "
            + str(e.pos().x())
            + "|"
            + str(e.pos().y()),
            level=Qgis.Info,
        )
        snapped = snapUtil.snapToCurrentLayer(e.pos(), snapType, filterLast)
        """self.canvas().setSnappingUtils(snap_util)
        m = snap_util.snapToMap(e.pos(), filter_last)"""

        # snap_util.setLayers(old_layers)
        # snap_config.setMode(old_mode)
        # snap_config.setIntersectionSnapping(old_intersections)
        self.canvas().setSnappingUtils(oldSnapUtil)

        # self.last_snap = m

        # TODO: Tidy up ...

        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:snap_to_editable_layer: snap point "
            + str(snapped.type())
            + ";"
            + str(snapped.isValid())
            + "; ",
            level=Qgis.Info,
        )

        return snapped

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
    """a filter to allow just one particular feature"""

    def __init__(self, layer, fid, labelLayerName):
        QgsPointLocator.MatchFilter.__init__(self)
        self.currLayer = layer
        self.primaryLayer = self.getPrimaryLabelLayer(layer)
        self.fid = fid
        self.pkFieldName = self.primaryKeyFieldName(layer)
        self.pkFieldValue = layer.getFeature(fid).attribute(self.pkFieldName)

        self.reqdLabelLayerName = labelLayerName[0]

        TOMsMessageLog.logMessage(
            "In OneFeatureLabelFilter: Layer {}:{} | {}:{}".format(
                self.currLayer.name(),
                self.primaryLayer.name(),
                str(fid),
                self.pkFieldValue,
            ),
            level=Qgis.Info,
        )

    def acceptMatch(self, match):

        """TOMsMessageLog.logMessage("In OneFeatureLabelFilter: matchLayer {} | {} with pk {}".format(match.layer().name(), match.featureId(),
                                                                          match.layer().getFeature(match.featureId()).attribute(self.pkFieldName)),
        level=Qgis.Info)"""  # fails on pk for some reason ...
        # need to check whether it is in the layer or any of the child layers
        """return self.getPrimaryLabelLayer(match.layer()) == self.primaryLayer and len(match.layer().name()) > len(self.primaryLayer.name()) \
                   and match.layer().getFeature(match.featureId()).attribute(self.pkFieldName) == self.pkFieldValue"""
        labelLayerName = "{}.label_pos".format(self.primaryLayer.name())
        loadingLabelLayerName = "{}.label_loading_pos".format(self.primaryLayer.name())
        TOMsMessageLog.logMessage(
            "In OneFeatureLabelFilter: labelLayerName: {}; loadingLabelLayerName: {}; matchname: {}".format(
                labelLayerName,
                loadingLabelLayerName,
                self.getPrimaryLabelLayer(match.layer()).name(),
            ),
            level=Qgis.Info,
        )
        if self.reqdLabelLayerName == labelLayerName:
            try:
                return (
                    match.layer().name() == labelLayerName
                ) and match.layer().getFeature(match.featureId()).attribute(
                    self.pkFieldName
                ) == self.pkFieldValue
            except Exception:
                return False
        else:
            try:
                return (
                    match.layer().name() == loadingLabelLayerName
                ) and match.layer().getFeature(match.featureId()).attribute(
                    self.pkFieldName
                ) == self.pkFieldValue
            except Exception:
                return False

    def getPrimaryLabelLayer(self, currLayer):
        # given a layer work out the primary layer

        currLayerName = currLayer.name()
        dotLocation = currLayerName.find(".")

        if dotLocation == -1:
            return currLayer
        else:
            primaryLayerName = currLayerName[:dotLocation]
            TOMsMessageLog.logMessage(
                "In getPrimaryLabelLayer: layer: {}".format(primaryLayerName),
                level=Qgis.Info,
            )
            return QgsProject.instance().mapLayersByName(primaryLayerName)[0]

    def primaryKeyFieldName(self, currLayer):
        # from Olivier Delange ...
        pkAttrsIdxs = currLayer.primaryKeyAttributes()
        assert len(pkAttrsIdxs) == 1, "We do not support composite primary keys"
        pkAttrIdx = pkAttrsIdxs[0]
        pkFieldName = currLayer.fields().names()[pkAttrIdx]

        TOMsMessageLog.logMessage(
            "In primaryKeyFieldName: layer: {}".format(pkFieldName), level=Qgis.Info
        )

        return pkFieldName


class TOMsLabelTool(TOMsNodeTool):
    def __init__(self, iface, proposalsManager, restrictionTransaction):

        # def __init__(self, iface, proposalsManager, restrictionTransaction, currFeature, currLayer):

        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:initialising .... ", level=Qgis.Info
        )

        TOMsNodeTool.__init__(self, iface, proposalsManager, restrictionTransaction)

        TOMsMessageLog.logMessage(
            "In TOMsLabelTool: origLayer: {}".format(self.origLayer), level=Qgis.Warning
        )

        # can we choose Lines layer label here ??

        self.labelLayersNames = self.setCurrLabelLayerNames(self.origLayer)
        self.labelLeaderLayersNames = self.setCurrLabelLeaderLayerNames(self.origLayer)

    def setCurrLabelLayerNames(self, currRestrictionLayer):
        # given a layer return the associated layer with label geometry
        # get the corresponding label layer

        def alertBox(text):
            QMessageBox.information(
                self.iface.mainWindow(), "Information", text, QMessageBox.Ok
            )

        if currRestrictionLayer.name() == "Bays":
            labelLayersNames = ["Bays.label_pos"]
            self.linesLabelLayer = "Bays.label_pos"
        if currRestrictionLayer.name() == "Lines":
            labelLayersNames = ["Lines.label_pos", "Lines.label_loading_pos"]

            msgBox = QMessageBox()
            msgBox.setWindowTitle("Query")
            msgBox.setText("Which labels do you want edit?")
            waitingBtn = msgBox.addButton(QPushButton("Waiting"), QMessageBox.YesRole)
            loadingBtn = msgBox.addButton(QPushButton("Loading"), QMessageBox.NoRole)
            btnClicked = msgBox.exec_()

            TOMsMessageLog.logMessage(
                "In doEditLabels - possibilities: {}. {}".format(
                    waitingBtn, loadingBtn
                ),
                level=Qgis.Warning,
            )
            TOMsMessageLog.logMessage(
                "In doEditLabels - result: {}. {}".format(
                    msgBox.clickedButton().text(), btnClicked
                ),
                level=Qgis.Warning,
            )

            if msgBox.clickedButton().text() == "Waiting":
                self.linesLabelLayer = "Lines.label_pos"
            else:  # msgBox.clickedButton().text() == "Loading":
                self.linesLabelLayer = "Lines.label_loading_pos"

            labelLayersNames = [self.linesLabelLayer]

        if currRestrictionLayer.name() == "Signs":
            labelLayersNames = []
            self.linesLabelLayer = ""
        if currRestrictionLayer.name() == "RestrictionPolygons":
            labelLayersNames = ["RestrictionPolygons.label_pos"]
            self.linesLabelLayer = "RestrictionPolygons.label_pos"
        if currRestrictionLayer.name() == "CPZs":
            labelLayersNames = ["CPZs.label_pos"]
            self.linesLabelLayer = "CPZs.label_pos"
        if currRestrictionLayer.name() == "ParkingTariffAreas":
            labelLayersNames = ["ParkingTariffAreas.label_pos"]
            self.linesLabelLayer = "ParkingTariffAreas.label_pos"

        if len(labelLayersNames) == 0:
            alertBox("No labels for this restriction type")
            return

        return labelLayersNames

    def getCurrLabelLayerNames(self, currRestrictionLayer):
        # given a layer return the associated layer with label geometry
        # get the corresponding label layer

        return self.labelLayersNames

    def setCurrLabelLeaderLayerNames(self, currRestrictionLayer):
        # given a layer return the associated layer with label geometry
        # get the corresponding label layer

        def alertBox(text):
            QMessageBox.information(
                self.iface.mainWindow(), "Information", text, QMessageBox.Ok
            )

        if currRestrictionLayer.name() == "Bays":
            labelLeaderLayersNames = ["Bays.label_ldr"]
        if currRestrictionLayer.name() == "Lines":
            labelLeaderLayersNames = ["Lines.label_ldr", "Lines.label_loading_ldr"]
        if currRestrictionLayer.name() == "Signs":
            labelLeaderLayersNames = []
        if currRestrictionLayer.name() == "RestrictionPolygons":
            labelLeaderLayersNames = ["RestrictionPolygons.label_ldr"]
        if currRestrictionLayer.name() == "CPZs":
            labelLeaderLayersNames = ["CPZs.label_ldr"]
        if currRestrictionLayer.name() == "ParkingTariffAreas":
            labelLeaderLayersNames = ["ParkingTariffAreas.label_ldr"]

        if len(labelLeaderLayersNames) == 0:
            alertBox("No labels for this restriction type")
            return

        return labelLeaderLayersNames

    def getCurrLabelLeaderLayerNames(self, currRestrictionLayer):
        return self.labelLeaderLayersNames

    def snapToEditableLayer(self, e):
        """Temporarily override snapping config and snap to vertices and edges
        of any editable vector layer, to allow selection of node for editing
        (if snapped to edge, it would offer creation of a new vertex there).
        """
        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:snap_to_editable_layer", level=Qgis.Info
        )

        def alertBox(text):
            QMessageBox.information(
                self.iface.mainWindow(), "Information", text, QMessageBox.Ok
            )

        tol = QgsTolerance.vertexSearchRadius(self.canvas().mapSettings())

        snapUtil = self.canvas().snappingUtils()
        oldSnapUtil = snapUtil
        snapConfig = snapUtil.config()

        # snap_config.clearIndividualLayerSettings() # not yet available ...
        layerList = []
        for layer in self.canvas().layers():
            if isinstance(layer, QgsVectorLayer):
                layerList.append(layer)
        snapConfig.removeLayers(layerList)

        snapLayers = []

        # TH: Amend to choose only from selected feature and label layers

        for labelLayersName in self.getCurrLabelLayerNames(self.origLayer):
            snapLayers.append(QgsProject.instance().mapLayersByName(labelLayersName)[0])
            # add signal here
            # QgsProject.instance().mapLayersByName(label_layers_name)[0].geometryChanged.connect(functools.partial(self.onGeometryChanged, self.origFeature.getFeature()))

        snapConfig.addLayers(snapLayers)
        snapUtil.setCurrentLayer(self.origLayer)

        snapConfig.setMode(QgsSnappingConfig.AdvancedConfiguration)
        snapConfig.setIntersectionSnapping(False)  # only snap to layers
        # m = snap_util.snapToMap(map_point)
        snapConfig.setTolerance(tol)
        snapConfig.setUnits(QgsTolerance.ProjectUnits)
        snapConfig.setType(QgsSnappingConfig.VertexAndSegment)
        snapConfig.setEnabled(True)

        # try to stay snapped to previously used feature
        # so the highlight does not jump around at nodes where features are joined
        # TH: Amend to choose only from selected feature (and layer)

        filterLast = OneFeatureLabelFilter(
            self.origLayer, self.origFeature.getFeature().id(), self.labelLayersNames
        )
        # m = snap_util.snapToMap(map_point, filter_last)
        """if m_last.isValid() and m_last.distance() <= m.distance():
            m = m_last"""

        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:snap_to_editable_layer: pos "
            + str(e.pos().x())
            + "|"
            + str(e.pos().y()),
            level=Qgis.Info,
        )
        # m = snap_util.snapToCurrentLayer(e.pos(), snap_type, filter_last)
        snapped = snapUtil.snapToMap(e.pos(), filterLast)

        self.canvas().setSnappingUtils(oldSnapUtil)

        # TODO: Tidy up ...

        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:snap_to_editable_layer: snap point "
            + str(snapped.type())
            + ";"
            + str(snapped.isValid())
            + "; ",
            level=Qgis.Info,
        )

        return snapped

    def cadCanvasPressEvent(self, e):

        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:cadCanvasPressEvent", level=Qgis.Info
        )

        NodeTool.cadCanvasPressEvent(self, e)

        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:cadCanvasPressEvent: after NodeTool.cadCanvasPressEvent",
            level=Qgis.Info,
        )

        # currLayer = self.iface.activeLayer()

        if e.button() == Qt.RightButton:
            TOMsMessageLog.logMessage(
                "In TOMsLabelTool:cadCanvasPressEvent: right button pressed",
                level=Qgis.Warning,
            )

            self.onFinishEditing()

        return

    def isMatchAtEndpoint(self, match):
        # inherited to check for geom not found
        geom = self.cachedGeometry(match.layer(), match.featureId())
        if not geom:  # TH: check that geom is found ...
            return False
        if geom.type() != QgsWkbTypes.LineGeometry:
            return False

        return NodeTool.is_endpoint_at_vertex_index(geom, match.vertexIndex())

    def onFinishEditing(self):

        self.finishEdit = True

        # now need to check whether the label layers have had any change
        labelModified = False
        for labelLayerName in self.getCurrLabelLayerNames(self.origLayer):
            if QgsProject.instance().mapLayersByName(labelLayerName)[0].isModified():
                TOMsMessageLog.logMessage(
                    "In TOMsLabelTool:cadCanvasPressEvent: {} modified".format(
                        labelLayerName
                    ),
                    level=Qgis.Warning,
                )
                labelModified = True

        if labelModified:
            TOMsMessageLog.logMessage(
                "In TOMsLabelTool:cadCanvasPressEvent: label layer modified",
                level=Qgis.Warning,
            )
            self.onGeometryChanged(self.selectedRestriction)

        return

    def onGeometryChanged(self, currRestriction):
        # Added by TH to deal with RestrictionsInProposals
        # When a geometry is changed; we need to check whether or not the feature is part of the current proposal
        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:onGeometryChanged. fid: "
            + str(currRestriction.id())
            + " GeometryID: "
            + str(currRestriction.attribute("GeometryID")),
            level=Qgis.Warning,
        )

        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:onGeometryChanged. Layer: " + str(self.origLayer.name()),
            level=Qgis.Warning,
        )

        idxRestrictionID = self.origLayer.fields().indexFromName("RestrictionID")

        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:onGeometryChanged. currProposal: "
            + str(self.proposalsManager.currentProposal()),
            level=Qgis.Info,
        )

        # newGeometry = QgsGeometry(self.feature_band.asGeometry())

        # TOMsMessageLog.logMessage("In TOMsNodeTool:onGeometryChanged - newGeom incoming: " + newGeometry.asWkt(),
        #                         level=Qgis.Info)

        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:onGeometryChanged. currRestrictionID: "
            + str(currRestriction[idxRestrictionID]),
            level=Qgis.Info,
        )

        if not self.restrictionInProposal(
            currRestriction[idxRestrictionID],
            self.getRestrictionLayerTableID(self.getPrimaryLabelLayer(self.origLayer)),
            self.proposalsManager.currentProposal(),
        ):
            TOMsMessageLog.logMessage(
                "In TOMsLabelTool:onGeometryChanged - adding details to RestrictionsInProposal",
                level=Qgis.Info,
            )
            #  This one is not in the current Proposal, so now we need to:
            #  - generate a new ID and assign it to the feature for which the geometry has changed
            #  - switch the geometries arround so that the original feature has the original geometry and the new feature has the new geometry
            #  - add the details to RestrictionsInProposal

            originalfeature = self.origFeature.getFeature()

            newFeature = QgsFeature(self.origLayer.fields())
            newFeature.setAttributes(currRestriction.attributes())
            newFeature.setGeometry(QgsGeometry(originalfeature.geometry()))

            # changes are to label geometry (and possibly to leader geometry??)
            for labelLayerName in self.getCurrLabelLayerNames(self.origLayer):
                labelLayer = QgsProject.instance().mapLayersByName(labelLayerName)[0]
                labelFieldName = self.getLabelFieldName(labelLayer)

                # get label layer feature
                labelLayerFeature = self.getLabelLayerFeature(
                    currRestriction, labelLayer
                )
                labelLayerFeatureGeometry = QgsGeometry(labelLayerFeature.geometry())

                originalLabelGeometry = QgsGeometry().fromWkt(
                    self.removeSridFromWkt(originalfeature.attribute(labelFieldName))
                )

                TOMsMessageLog.logMessage(
                    "In TOMsLabelTool:onGeometryChanged - orig label geom {}: {}".format(
                        originalfeature.attribute(labelFieldName), originalLabelGeometry
                    ),
                    level=Qgis.Warning,
                )

                labelLayerFeatureGeometryAsWktWithSRID = self.asWktWithSRID(
                    labelLayerFeatureGeometry, labelLayer
                )

                TOMsMessageLog.logMessage(
                    "In TOMsLabelTool:onGeometryChanged - new details for {} in {}: {}".format(
                        labelFieldName,
                        labelLayerName,
                        labelLayerFeatureGeometryAsWktWithSRID,
                    ),
                    level=Qgis.Warning,
                )

                TOMsMessageLog.logMessage(
                    "In TOMsLabelTool:onGeometryChanged - resetting orig feature to: {}".format(
                        originalLabelGeometry.asWkt()
                    ),
                    level=Qgis.Warning,
                )

                newFeature.setAttribute(
                    labelFieldName, labelLayerFeatureGeometryAsWktWithSRID
                )
                # labelLayerFeature.setGeometry(originalLabelGeometry)  # for some reason, this doesn't work ...
                labelLayer.changeGeometry(labelLayerFeature.id(), originalLabelGeometry)

                # result = labelLayerFeature.setAttribute(labelFieldName, originalfeature.attribute(labelFieldName)) # change back

            # assume only one restriction being considered ?? use asset ??

            """for details in self.cache:
                TOMsMessageLog.logMessage(
                    "In TOMsLabelTool:onGeometryChanged - details: {}".format(details),
                    level=Qgis.Warning)
                labelFieldName = self.getLabelFieldName(details)
                for fid in self.cache[details]:
                    newLabelGeom = self.cache[details][fid]
                    TOMsMessageLog.logMessage(
                        "In TOMsLabelTool:onGeometryChanged - adding details to {}: {}".format(labelFieldName, newLabelGeom.asWkt()), level=Qgis.Warning)
                    result = newFeature.setAttribute(labelFieldName, newLabelGeom)
                    TOMsMessageLog.logMessage(
                        "In TOMsLabelTool:onGeometryChanged - result {}: {}".format(result, newFeature.attribute(labelFieldName).asWkt()), level=Qgis.Warning)
            """

            newRestrictionID = str(uuid.uuid4())
            newFeature[idxRestrictionID] = newRestrictionID

            idxOpenDate = self.origLayer.fields().indexFromName("OpenDate")
            idxGeometryID = self.origLayer.fields().indexFromName("GeometryID")

            newFeature[idxOpenDate] = None
            newFeature[idxGeometryID] = None

            self.origLayer.addFeatures([newFeature])

            TOMsMessageLog.logMessage(
                "In TOMsLabelTool:onGeometryChanged - attributes: "
                + str(newFeature.attributes()),
                level=Qgis.Warning,
            )

            # TOMsMessageLog.logMessage("In TOMsLabelTool:onGeometryChanged - newGeom: " + newFeature.geometry().asWkt(), level=Qgis.Info)

            """
            originalGeomBuffer = QgsGeometry(originalfeature.geometry())
            TOMsMessageLog.logMessage(
                "In TOMsLabelTool:onGeometryChanged - originalGeom: " + originalGeomBuffer.asWkt(),
                level=Qgis.Info)
            self.origLayer.changeGeometry(currRestriction.id(), originalGeomBuffer)
            """

            # TOMsMessageLog.logMessage("In TOMsLabelTool:onGeometryChanged - geometries switched.", level=Qgis.Info)

            self.addRestrictionToProposal(
                currRestriction[idxRestrictionID],
                self.getRestrictionLayerTableID(
                    self.getPrimaryLabelLayer(self.origLayer)
                ),
                self.proposalsManager.currentProposal(),
                RestrictionAction.CLOSE,
            )  # close the original feature
            TOMsMessageLog.logMessage(
                "In TOMsLabelTool:onGeometryChanged - feature closed.", level=Qgis.Info
            )

            self.addRestrictionToProposal(
                newRestrictionID,
                self.getRestrictionLayerTableID(
                    self.getPrimaryLabelLayer(self.origLayer)
                ),
                self.proposalsManager.currentProposal(),
                RestrictionAction.OPEN,
            )  # open the new one
            TOMsMessageLog.logMessage(
                "In TOMsLabelTool:onGeometryChanged - feature opened.", level=Qgis.Info
            )

        TOMsMessageLog.logMessage(
            "In TOMsLabelTool:onGeometryChanged - newGeom (2): "
            + currRestriction.geometry().asWkt(),
            level=Qgis.Info,
        )

        self.restrictionTransaction.commitTransactionGroup()

        self.origLayer.deselect(self.origFeature.getFeature().id())

        # also deselect any label layers
        for labelLayerName in self.getCurrLabelLayerNames(self.origLayer):
            labelLayer = QgsProject.instance().mapLayersByName(labelLayerName)[0]
            TOMsMessageLog.logMessage(
                "In TOMsLabelTool:onGeometryChanged. deselecting from layer {}".format(
                    labelLayer.name()
                ),
                level=Qgis.Warning,
            )
            labelLayerFeature = self.getLabelLayerFeature(currRestriction, labelLayer)

            if labelLayerFeature:
                TOMsMessageLog.logMessage(
                    "In TOMsLabelTool:onGeometryChanged. deselecting fid: {}; layer {}".format(
                        labelLayerFeature.id(), labelLayer.name()
                    ),
                    level=Qgis.Info,
                )
                labelLayer.deselect(labelLayerFeature.id())

        for labelLayerName in self.getCurrLabelLeaderLayerNames(self.origLayer):
            labelLayer = QgsProject.instance().mapLayersByName(labelLayerName)[0]
            labelLayerFeature = self.getLabelLayerFeature(currRestriction, labelLayer)

            if labelLayerFeature:
                TOMsMessageLog.logMessage(
                    "In TOMsLabelTool:onGeometryChanged. deselecting fid: {}; layer {}".format(
                        labelLayerFeature.id(), labelLayer.name()
                    ),
                    level=Qgis.Info,
                )
                labelLayer.deselect(labelLayerFeature.id())

        self.shutDownNodeTool()

        return

    def getPrimaryLabelLayer(self, currLayer):
        # given a layer work out the primary layer

        currLayerName = currLayer.name()
        dotLocation = currLayerName.find(".")

        if dotLocation == -1:
            return currLayer
        else:
            primaryLayerName = currLayerName[:dotLocation]
            TOMsMessageLog.logMessage(
                "In getPrimaryLabelLayer: layer: {}".format(primaryLayerName),
                level=Qgis.Warning,
            )
            return QgsProject.instance().mapLayersByName(primaryLayerName)[0]

    def getLabelFieldName(self, currLayer):
        # given a layer work out the primary layer

        currLayerName = currLayer.name()
        dotLocation = currLayerName.find(".")

        if dotLocation == -1:
            return None
        else:
            labelFieldName = currLayerName[dotLocation + 1 :]
            TOMsMessageLog.logMessage(
                "In getLabelFieldName: layer: {}".format(labelFieldName),
                level=Qgis.Warning,
            )
            return labelFieldName

    def primaryKeyFieldName(self, currLayer):
        # from Olivier Delange ...
        pkAttrsIdxs = currLayer.primaryKeyAttributes()
        assert len(pkAttrsIdxs) == 1, "We do not support composite primary keys"
        pkAttrIdx = pkAttrsIdxs[0]
        pkFieldName = currLayer.fields().names()[pkAttrIdx]

        TOMsMessageLog.logMessage(
            "In primaryKeyFieldName: layer: {}".format(pkFieldName), level=Qgis.Warning
        )

        return pkFieldName

    def getLabelLayerFeature(self, currRestriction, labelLayer):
        # given restriction (on primary layer) and labelLayer, get restriction on LabelLayer

        pkFieldName = self.primaryKeyFieldName(self.origLayer)

        pkFieldValue = currRestriction.attribute(pkFieldName)

        expression = "\"{}\" = '{}'".format(pkFieldName, pkFieldValue)
        TOMsMessageLog.logMessage(
            "In getLabelLayerFeature: expression: {}".format(expression),
            level=Qgis.Info,
        )

        featureIterator = labelLayer.getFeatures(expression)
        try:
            return next(featureIterator)
        except Exception:
            TOMsMessageLog.logMessage(
                "In getLabelLayerFeature: no details found", level=Qgis.Warning
            )
            return None

    def asWktWithSRID(self, geom, layer):
        # add layer srid to geom

        refSys = layer.sourceCrs().authid()

        colonLocation = refSys.find(":")

        if colonLocation == -1:
            return None
        else:
            crsDetails = refSys[colonLocation + 1 :]

        asWktWithSRID = "SRID={};{}".format(crsDetails, geom.asWkt())

        TOMsMessageLog.logMessage(
            "In asWktWithSRID: wkt: {}".format(asWktWithSRID), level=Qgis.Warning
        )

        return asWktWithSRID

    def removeSridFromWkt(self, strWkt):
        # remove srid from geom str

        semicolonLocation = strWkt.find(";")

        if semicolonLocation == -1:
            return strWkt
        else:
            TOMsMessageLog.logMessage(
                "In asWktWithSRID: wkt: {}".format(strWkt[semicolonLocation + 1 :]),
                level=Qgis.Warning,
            )
            return strWkt[semicolonLocation + 1 :]
