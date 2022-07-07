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

import math
import sys
import traceback
import uuid
from typing import Any

from qgis.core import (
    Qgis,
    QgsExpression,
    QgsExpressionContext,
    QgsExpressionContextUtils,
    QgsFeature,
    QgsFeatureRequest,
    QgsGeometry,
    QgsProject,
    QgsRectangle,
    QgsSnappingConfig,
    QgsTracer,
    QgsWkbTypes,
)
from qgis.gui import QgsMapTool, QgsMapToolCapture, QgsMapToolIdentify
from qgis.PyQt.QtCore import (
    QPoint,
    Qt,
    QTimer,
    pyqtSlot,
)
from qgis.PyQt.QtWidgets import (
    QAction,
    QDockWidget,
    QMenu,
    QMessageBox,
    QToolTip,
)

from .constants import RestrictionAction, RestrictionLayers
from .core.tomsMessageLog import TOMsMessageLog
from .restrictionTypeUtilsClass import RestrictionTypeUtilsMixin

#############################################################################


class MapToolMixin:
    """Mixin class that defines various helper methods for a QgsMapTool."""

    def setLayer(self, layer):
        self.layer = layer
        self.lastPlayTime = None

    def transformCoordinates(self, screenPt):
        """Convert a screen coordinate to map and layer coordinates.

        returns a (mapPt,layerPt) tuple.
        """
        return self.toMapCoordinates(screenPt)

    def calcTolerance(self, pos):
        """Calculate the "tolerance" to use for a mouse-click.

        'pos' is a QPoint object representing the clicked-on point, in
        canvas coordinates.

        The tolerance is the number of map units away from the click
        position that a vertex or geometry can be and we still consider it
        to be a click on that vertex or geometry.
        """
        pt1 = QPoint(pos.x(), pos.y())
        pt2 = QPoint(pos.x() + 10, pos.y())

        mapPt1 = self.transformCoordinates(pt1)
        mapPt2 = self.transformCoordinates(pt2)
        tolerance = mapPt2.x() - mapPt1.x()

        return tolerance

    def findVertexAt(self, feature, pos):
        """Find the vertex of the given feature close to the given position.

        'feature' is the QgsFeature to check, and 'pos' is the position to
        check, in canvas coordinates.

        We return the vertex number for the closest vertex, or None if no
        vertex is close enough to the given click position.
        """
        _, layerPt = self.transformCoordinates(pos)
        tolerance = self.calcTolerance(pos)

        (
            _,
            vertex,
            _,
            _,
            distSquared,
        ) = feature.geometry().closestVertex(layerPt)

        distance = math.sqrt(distSquared)
        if distance > tolerance:
            return None
        return vertex

    def snapToNearestVertex(self, pos, excludeFeature=None):
        """Attempt to snap the given point to the nearest vertex.

        The parameters are as follows:

            'pos'

                The click position, in canvas coordinates.

            'excludeFeature'

                If specified, this is a QgsFeature which will be excluded
                from the check for nearby vertices.  This is used to
                prevent snapping an object to itself.

        If the click position is close enough to a vertex in the track
        layer (excluding the given feature, if any), we return the
        coordinates of that vertex.  Otherwise, we return the click
        position itself in layer coordinates.  Either way, the returned
        point is in the map tool's layer's coordinates.
        """
        _, layerPt = self.transformCoordinates(pos)
        feature = self.findFeatureAt(pos, excludeFeature)

        if feature is None:
            return layerPt

        vertex = self.findVertexAt(feature, pos)
        if vertex is None:
            return layerPt

        return feature.geometry().vertexAt(vertex)


#############################################################################


#############################################################################


class GeometryInfoMapTool(MapToolMixin, RestrictionTypeUtilsMixin, QgsMapToolIdentify):
    def __init__(self, iface):
        QgsMapToolIdentify.__init__(self, iface.mapCanvas())
        RestrictionTypeUtilsMixin.__init__(self, iface)

        self.canvas = self.iface.mapCanvas()
        self.timerMapTips = QTimer(self.canvas)
        self.timerMapTips.timeout.connect(self.showMapTip)

        self.restrictionTypes = QgsProject.instance().mapLayersByName("BayLineTypes")[0]
        self.signTypes = QgsProject.instance().mapLayersByName("SignTypes")[0]
        self.restrictionPolygonTypes = QgsProject.instance().mapLayersByName(
            "RestrictionPolygonTypes"
        )[0]
        self.restrictionList: list[tuple[Any, Any, Any]] = []
        self.restrictionLayers: Any = None
        self.currLayer: Any = None
        self.restrictionSelectMenu = QMenu(iface.mapCanvas())

    def canvasReleaseEvent(self, event):  # pylint: disable=unused-argument
        # Return point under cursor

        TOMsMessageLog.logMessage(("In Info - canvasReleaseEvent."), level=Qgis.Info)

        self.restrictionList = self.getRestrictionsUnderPoint(self.canvas.mouseLastXY())
        featureList = self.getFeatureList(self.restrictionList)
        self.setupFeatureMenu(featureList)

    def canvasMoveEvent(self, event):  # pylint: disable=unused-argument

        TOMsMessageLog.logMessage(("In Info - canvasMoveEvent."), level=Qgis.Info)

        # https://gis.stackexchange.com/questions/245280/display-raster-value-as-a-tooltip

        if self.canvas.underMouse():  # Only if mouse is over the map
            QToolTip.hideText()
            self.timerMapTips.start(700)  # time in milliseconds

    def showMapTip(self):
        self.timerMapTips.stop()
        if self.canvas.underMouse():

            restrictionList = self.getRestrictionsUnderPoint(self.canvas.mouseLastXY())
            featureList = self.getFeatureList(restrictionList)

            text = "\n".join(featureList)

            QToolTip.showText(
                self.canvas.mapToGlobal(self.canvas.mouseLastXY()), text, self.canvas
            )

    @pyqtSlot(QAction)
    def onRestrictionSelectMenuClicked(self, action):
        TOMsMessageLog.logMessage(
            "In onRestrictionSelectMenuClicked. Action: " + action.text(),
            level=Qgis.Info,
        )

        selectedGeometryID = action.text()[
            action.text().find("[") + 1 : action.text().find("]")
        ]

        TOMsMessageLog.logMessage(
            "In onRestrictionSelectMenuClicked. geomID: " + selectedGeometryID,
            level=Qgis.Info,
        )

        # Really should rollback (or save) any current transactions

        self.doSelectFeature(selectedGeometryID)

    def doSelectFeature(self, selectedGeometryID):

        TOMsMessageLog.logMessage("In doSelectFeature ... ", level=Qgis.Info)

        for (feature, _, layer) in self.restrictionList:

            currGeometryID = str(feature.attribute("GeometryID"))
            if currGeometryID == selectedGeometryID:
                # select the feature ...
                if self.iface.activeLayer():
                    self.iface.activeLayer().removeSelection()
                self.iface.setActiveLayer(layer)
                layer.selectByIds([feature.id()])
                TOMsMessageLog.logMessage(
                    "In Info - canvasReleaseEvent. Feature selected from layer: "
                    + layer.name()
                    + " id: "
                    + str(currGeometryID),
                    level=Qgis.Info,
                )
                break

    def getRestrictionsUnderPoint(self, pos):
        # http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/
        # generates "closest feature" function

        """Find the feature close to the given position.

        'pos' is the position to check, in canvas coordinates.

        if 'excludeFeature' is specified, we ignore this feature when
        finding the clicked-on feature.

        If no feature is close to the given coordinate, we return None.
        """
        mapPt = self.transformCoordinates(pos)
        TOMsMessageLog.logMessage(
            "In getRestrictionsUnderPoint:  mapPt ********: " + mapPt.asWkt(),
            level=Qgis.Info,
        )
        # tolerance = self.calcTolerance(pos)
        tolerance = 0.5
        searchRectA = QgsRectangle(
            mapPt.x() - tolerance,
            mapPt.y() - tolerance,
            mapPt.x() + tolerance,
            mapPt.y() + tolerance,
        )

        self.restrictionLayers = QgsProject.instance().mapLayersByName(
            "RestrictionLayers"
        )[0]

        # need to loop through the layers and choose closest to click point

        restrictionList = []

        context = QgsExpressionContext()

        for layerDetails in self.restrictionLayers.getFeatures():

            if (
                layerDetails.attribute("Code") >= 6
            ):  # CPZs, PTAs  - TODO: Need to improve
                allowZoneEditing = QgsExpressionContextUtils.projectScope(
                    QgsProject.instance()
                ).variable("AllowZoneEditing")
                if allowZoneEditing != "True":
                    continue
                TOMsMessageLog.logMessage(
                    "In getRestrictionsUnderPoint: Zone editing enabled: ",
                    level=Qgis.Info,
                )

            if layerDetails.attribute("Code") == RestrictionLayers.BAYS.value:  # Bays
                tolerance = 2.0
            else:
                tolerance = 0.5

            searchRect = QgsRectangle(
                mapPt.x() - tolerance,
                mapPt.y() - tolerance,
                mapPt.x() + tolerance,
                mapPt.y() + tolerance,
            )

            request = QgsFeatureRequest()
            request.setFilterRect(searchRect)
            request.setFlags(QgsFeatureRequest.ExactIntersect)
            self.currLayer = self.getRestrictionsLayer(layerDetails)

            context.appendScopes(
                QgsExpressionContextUtils.globalProjectLayerScopes(self.currLayer)
            )

            # Loop through all features in the layer to find the closest feature
            for feat in self.currLayer.getFeatures(request):

                if (
                    layerDetails.attribute("Code") == RestrictionLayers.BAYS.value
                    or layerDetails.attribute("Code") == RestrictionLayers.LINES.value
                ):
                    context.setFeature(feat)
                    expression1 = QgsExpression("generateDisplayGeometry()")

                    shapeGeom = expression1.evaluate(context)
                    TOMsMessageLog.logMessage(
                        "In findNearestFeatureAtC:  shapeGeom ********: "
                        + shapeGeom.asWkt(),
                        level=Qgis.Info,
                    )
                    if shapeGeom.intersects(searchRectA):
                        # Add any features that are found should be added to a list
                        restrictionList.append(
                            (feat, layerDetails.attribute("Code"), self.currLayer)
                        )
                    # layerList.append(self.currLayer)
                else:
                    restrictionList.append(
                        (feat, layerDetails.attribute("Code"), self.currLayer)
                    )

        TOMsMessageLog.logMessage(
            "In findNearestFeatureAt: nrFeatures: " + str(len(restrictionList)),
            level=Qgis.Info,
        )

        return restrictionList

    def getFeatureList(self, restrictionList):
        # Creates a formatted list of the restrictions
        TOMsMessageLog.logMessage(
            "In getFeatureList: nrFeatures: " + str(len(restrictionList)),
            level=Qgis.Info,
        )
        featureList = []

        for (feature, layerType, layer) in restrictionList:

            currGeometryID = str(feature.attribute("GeometryID"))
            if layerType == RestrictionLayers.BAYS.value:
                title = "{RestrictionDescription} [{GeometryID}]".format(
                    RestrictionDescription=str(
                        self.getLookupDescription(
                            self.restrictionTypes,
                            feature.attribute("RestrictionTypeID"),
                        )
                    ),
                    GeometryID=currGeometryID,
                )
                featureList.append(title)
            elif layerType == RestrictionLayers.LINES.value:
                title = "{RestrictionDescription} [{GeometryID}]".format(
                    RestrictionDescription=str(
                        self.getLookupDescription(
                            self.restrictionTypes,
                            feature.attribute("RestrictionTypeID"),
                        )
                    ),
                    GeometryID=currGeometryID,
                )
                featureList.append(title)
            elif layerType == RestrictionLayers.RESTRICTION_POLYGONS.value:
                title = "{RestrictionDescription} [{GeometryID}]".format(
                    RestrictionDescription=str(
                        self.getLookupDescription(
                            self.restrictionPolygonTypes,
                            feature.attribute("RestrictionTypeID"),
                        )
                    ),
                    GeometryID=currGeometryID,
                )
                featureList.append(title)
            elif layerType == RestrictionLayers.SIGNS.value:
                # Need to get each of the signs ...
                for i in range(1, 10):
                    fieldIdx = layer.fields().indexFromName(
                        "SignType_{counter}".format(counter=i)
                    )
                    if fieldIdx == -1:
                        break
                    if feature[fieldIdx]:
                        title = "Sign: {RestrictionDescription} [{GeometryID}]".format(
                            RestrictionDescription=str(
                                self.getLookupDescription(
                                    self.signTypes, feature[fieldIdx]
                                )
                            ),
                            GeometryID=currGeometryID,
                        )
                        featureList.append(title)

            else:
                title = "{RestrictionDescription} [{GeometryID}]".format(
                    RestrictionDescription=str(
                        self.getLookupDescription(
                            self.restrictionTypes,
                            feature.attribute("RestrictionTypeID"),
                        )
                    ),
                    GeometryID=currGeometryID,
                )
                featureList.append(title)

        return featureList

    def setupFeatureMenu(self, featureTitleList):
        TOMsMessageLog.logMessage("In getFeatureDetails", level=Qgis.Info)

        # Creates the context menu and returns the selected feature and layer
        TOMsMessageLog.logMessage(
            "In getFeatureDetails: nrFeatures: " + str(len(featureTitleList)),
            level=Qgis.Info,
        )

        self.restrictionSelectMenu.clear()

        for title in featureTitleList:

            TOMsMessageLog.logMessage(
                "In featureContextMenu: adding: " + str(title), level=Qgis.Info
            )
            action = QAction(title, self.restrictionSelectMenu)

            self.restrictionSelectMenu.addAction(action)
            self.restrictionSelectMenu.triggered.connect(
                self.onRestrictionSelectMenuClicked
            )

        TOMsMessageLog.logMessage(
            "In getFeatureDetails: showing menu?", level=Qgis.Info
        )

        clickedAction = self.restrictionSelectMenu.exec_(
            self.canvas.mapToGlobal(self.canvas.mouseLastXY())
        )
        TOMsMessageLog.logMessage(
            ("In getFeatureDetails:clicked_action: " + str(clickedAction)),
            level=Qgis.Info,
        )


#############################################################################


class CreateRestrictionTool(RestrictionTypeUtilsMixin, QgsMapToolCapture):
    # helpful link - http://apprize.info/python/qgis/7.html ??
    def __init__(self, iface, layer, proposalsManager, currTransaction):

        TOMsMessageLog.logMessage(("In CreateRestrictionTool - init."), level=Qgis.Info)

        if layer.geometryType() == 0:  # PointGeometry:
            captureMode = CreateRestrictionTool.CapturePoint
        elif layer.geometryType() == 1:  # LineGeometry:
            captureMode = CreateRestrictionTool.CaptureLine
        elif layer.geometryType() == 2:  # PolygonGeometry:
            captureMode = CreateRestrictionTool.CapturePolygon
        else:
            TOMsMessageLog.logMessage(
                ("In CreateRestrictionTool - No geometry type found. EXITING ...."),
                level=Qgis.Info,
            )
            return

        QgsMapToolCapture.__init__(
            self, iface.mapCanvas(), iface.cadDockWidget(), captureMode
        )
        RestrictionTypeUtilsMixin.__init__(self, iface)

        # https: // qgis.org / api / classQgsMapToolCapture.html
        canvas = iface.mapCanvas()
        self.iface = iface
        self.layer = layer

        # self.dialog = dialog
        self.currTransaction = currTransaction
        self.proposalsManager = proposalsManager

        # advancedDigitizingPanel = self.iface.AdvancedDigitizingTools()
        self.setAdvancedDigitizingAllowed(True)
        self.setAutoSnapEnabled(True)

        advancedDigitizingPanel = iface.mainWindow().findChild(
            QDockWidget, "AdvancedDigitizingTools"
        )
        if not advancedDigitizingPanel:
            QMessageBox.information(
                self.iface.mainWindow(),
                "ERROR",
                ("Advanced Digitising Panel is not present"),
            )
        # TODO: Need to do something if this is not present

        advancedDigitizingPanel.setVisible(True)
        self.setupPanelTabs(self.iface, advancedDigitizingPanel)
        # QgsMapToolAdvancedDigitizing.activate(self)
        # self.iface.cadDockWidget().enable()

        # self.QgsWkbTypes = QgsWkbTypes()

        # I guess at this point, it is possible to set things like capture mode,
        # snapping preferences, ... (not sure of all the elements that are required)
        # capture mode (... not sure if this has already been set? - or how to set it)

        TOMsMessageLog.logMessage(
            "In CreateRestrictionTool - geometryType for "
            + str(self.layer.name())
            + ": "
            + str(self.layer.geometryType()),
            level=Qgis.Info,
        )

        TOMsMessageLog.logMessage(
            ("In CreateRestrictionTool - mode set."), level=Qgis.Info
        )

        # Seems that this is important - or at least to create a point list that is used later to create Geometry
        self.sketchPoints = self.points()
        # self.setPoints(self.sketchPoints)  ... not sure when to use this ??

        # Set up rubber band. In current implementation, it is not showing feeback for "next" location

        self.rubberBand = self.createRubberBand(
            QgsWkbTypes.LineGeometry
        )  # what about a polygon ??

        self.currLayer = self.currentVectorLayer()

        TOMsMessageLog.logMessage(
            (
                "In CreateRestrictionTool - init. Curr layer is "
                + str(self.currLayer.name())
                + "Incoming: "
                + str(self.layer)
            ),
            level=Qgis.Info,
        )

        # set up snapping configuration   *******************
        self.snapper = canvas.snappingUtils()
        self.snappingConfig = QgsSnappingConfig(QgsProject.instance())

        self.snappingConfig.setMode(QgsSnappingConfig.AdvancedConfiguration)

        # set up tracing configuration
        self.tomsTracer = QgsTracer()
        roadCasementLayer = QgsProject.instance().mapLayersByName("RoadCasement")[0]
        traceLayersNames = [roadCasementLayer]
        self.tomsTracer.setLayers(traceLayersNames)

        # set an extent for the Tracer
        tracerExtent = iface.mapCanvas().extent()
        tolerance = 1000.0
        tracerExtent.setXMaximum(tracerExtent.xMaximum() + tolerance)
        tracerExtent.setYMaximum(tracerExtent.yMaximum() + tolerance)
        tracerExtent.setXMinimum(tracerExtent.xMinimum() - tolerance)
        tracerExtent.setYMinimum(tracerExtent.yMinimum() - tolerance)

        self.tomsTracer.setExtent(tracerExtent)

        # self.TOMsTracer.setMaxFeatureCount(1000)
        self.lastPoint = None
        self.currPoint = None

        # set up function to be called when capture is complete
        # self.onCreateRestriction = onCreateRestriction

        TOMsMessageLog.logMessage(
            ("In CreateRestrictionTool. Finished init."), level=Qgis.Info
        )
        self.lastEvent = None
        self.result = None
        self.nrPoints = None

    def cadCanvasReleaseEvent(self, event):
        QgsMapToolCapture.cadCanvasReleaseEvent(self, event)
        TOMsMessageLog.logMessage(
            ("In Create - cadCanvasReleaseEvent"), level=Qgis.Info
        )

        if event.button() == Qt.LeftButton:
            if not self.isCapturing():
                self.startCapturing()
            # self.result = self.addVertex(self.toMapCoordinates(event.pos()))
            checkSnapping = event.isSnapped
            TOMsMessageLog.logMessage(
                "In Create - cadCanvasReleaseEvent: checkSnapping = "
                + str(checkSnapping),
                level=Qgis.Info,
            )

            # Now wanting to add point(s) to new shape. Take account of snapping and tracing
            self.currPoint = event.snapPoint()
            self.lastEvent = event
            # If this is the first point, add and k

            if not self.lastPoint:

                self.result = self.addVertex(self.currPoint)
                TOMsMessageLog.logMessage(
                    "In Create - cadCanvasReleaseEvent: adding vertex 0 "
                    + str(self.result),
                    level=Qgis.Info,
                )

            else:

                # check for shortest line
                resVectorList = self.tomsTracer.findShortestPath(
                    self.lastPoint, self.currPoint
                )

                TOMsMessageLog.logMessage(
                    "In Create - cadCanvasReleaseEvent: traceList" + str(resVectorList),
                    level=Qgis.Info,
                )
                TOMsMessageLog.logMessage(
                    "In Create - cadCanvasReleaseEvent: traceList"
                    + str(resVectorList[1]),
                    level=Qgis.Info,
                )
                if resVectorList[1] == 0:
                    # path found, add the points to the list
                    TOMsMessageLog.logMessage(
                        "In Create - cadCanvasReleaseEvent (found path) ",
                        level=Qgis.Info,
                    )

                    # self.points.extend(resVectorList)
                    initialPoint = True
                    for point in resVectorList[0]:
                        if not initialPoint:

                            TOMsMessageLog.logMessage(
                                (
                                    "In CreateRestrictionTool - cadCanvasReleaseEvent (found path) X:"
                                    + str(point.x())
                                    + " Y: "
                                    + str(point.y())
                                ),
                                level=Qgis.Info,
                            )

                            self.result = self.addVertex(point)

                        initialPoint = False

                    TOMsMessageLog.logMessage(
                        ("In Create - cadCanvasReleaseEvent (added shortest path)"),
                        level=Qgis.Info,
                    )

                else:
                    # error encountered, add just the curr point ??

                    self.result = self.addVertex(self.currPoint)
                    TOMsMessageLog.logMessage(
                        (
                            "In CreateRestrictionTool - (adding shortest path) X:"
                            + str(self.currPoint.x())
                            + " Y: "
                            + str(self.currPoint.y())
                        ),
                        level=Qgis.Info,
                    )

            self.lastPoint = self.currPoint

            TOMsMessageLog.logMessage(
                (
                    "In Create - cadCanvasReleaseEvent (AddVertex/Line) Result: "
                    + str(self.result)
                    + " X:"
                    + str(self.currPoint.x())
                    + " Y:"
                    + str(self.currPoint.y())
                ),
                level=Qgis.Info,
            )

        elif event.button() == Qt.RightButton:
            # Stop capture when right button or escape key is pressed
            # points = self.getCapturedPoints()
            self.getPointsCaptured()

            # Need to think about the default action here if none of these buttons/keys are pressed.

    def keyPressEvent(self, event):
        if (
            (event.key() == Qt.Key_Backspace)
            or (event.key() == Qt.Key_Delete)
            or (event.key() == Qt.Key_Escape)
        ):
            self.undo()
        if event.key() == Qt.Key_Return or event.key() == Qt.Key_Enter:
            # TODO: Need to think about the default action here if none of these buttons/keys are pressed.
            pass

    def getPointsCaptured(self):
        TOMsMessageLog.logMessage(
            ("In CreateRestrictionTool - getPointsCaptured"), level=Qgis.Info
        )

        # Check the number of points
        self.nrPoints = self.size()
        TOMsMessageLog.logMessage(
            (
                "In CreateRestrictionTool - getPointsCaptured; Stopping: "
                + str(self.nrPoints)
            ),
            level=Qgis.Info,
        )

        self.sketchPoints = self.points()

        for point in self.sketchPoints:
            TOMsMessageLog.logMessage(
                (
                    "In CreateRestrictionTool - getPointsCaptured X:"
                    + str(point.x())
                    + " Y: "
                    + str(point.y())
                ),
                level=Qgis.Info,
            )

        # stop capture activity
        self.stopCapturing()

        if self.nrPoints > 0:

            # take points from the rubber band and copy them into the "feature"

            fields = self.layer.dataProvider().fields()
            feature = QgsFeature()
            feature.setFields(fields)

            TOMsMessageLog.logMessage(
                (
                    "In CreateRestrictionTool. getPointsCaptured, layerType: "
                    + str(self.layer.geometryType())
                ),
                level=Qgis.Info,
            )

            if self.layer.geometryType() == 0:  # Point
                feature.setGeometry(QgsGeometry.fromPointXY(self.sketchPoints[0]))
            elif self.layer.geometryType() == 1:  # Line
                feature.setGeometry(QgsGeometry.fromPolylineXY(self.sketchPoints))
            elif self.layer.geometryType() == 2:  # Polygon
                feature.setGeometry(QgsGeometry.fromPolygonXY([self.sketchPoints]))
                # feature.setGeometry(QgsGeometry.fromPolygonXY(self.sketchPoints))
            else:
                TOMsMessageLog.logMessage(
                    ("In CreateRestrictionTool - no geometry type found"),
                    level=Qgis.Info,
                )
                return

            # Currently geometry is not being created correct. Might be worth checking co-ord values ...

            # self.valid = feature.isValid()

            TOMsMessageLog.logMessage(
                (
                    "In Create - getPointsCaptured; geometry prepared; "
                    + str(feature.geometry().asWkt())
                ),
                level=Qgis.Info,
            )

            if self.layer.name() == "ConstructionLines":
                self.layer.addFeature(feature)
            else:

                # set any geometry related attributes ...

                self.setDefaultRestrictionDetails(feature, self.layer)

                # is there any other tidying to do ??

                # self.layer.startEditing()
                # dialog = self.iface.getFeatureForm(self.layer, feature)

                # currForm = dialog.attributeForm()
                # currForm.disconnectButtonBox()

                TOMsMessageLog.logMessage(
                    "In CreateRestrictionTool - getPointsCaptured. currRestrictionLayer: "
                    + str(self.layer.name()),
                    level=Qgis.Info,
                )

                newRestrictionID = str(uuid.uuid4())
                feature[
                    self.layer.fields().indexFromName("RestrictionID")
                ] = newRestrictionID
                # self.layer.addFeature(feature)  # TH (added for v3)

                dialog = self.iface.getFeatureForm(self.layer, feature)

                self.setupRestrictionDialog(
                    dialog, self.layer, feature, self.currTransaction
                )  # connects signals, etc

                dialog.show()
                # self.iface.openFeatureForm(self.layer, feature, False, False)


#############################################################################


class TOMsSplitRestrictionTool(RestrictionTypeUtilsMixin, QgsMapToolCapture):
    def __init__(self, iface, layer, proposalsManager, restrictionTransaction):

        TOMsMessageLog.logMessage(("In SplitRestrictionTool - init."), level=Qgis.Info)
        RestrictionTypeUtilsMixin.__init__(self, iface)

        if layer.geometryType() == 0:  # PointGeometry:
            captureMode = CreateRestrictionTool.CapturePoint
        elif layer.geometryType() == 1:  # LineGeometry:
            captureMode = CreateRestrictionTool.CaptureLine
        elif layer.geometryType() == 2:  # PolygonGeometry:
            captureMode = CreateRestrictionTool.CapturePolygon
        else:
            TOMsMessageLog.logMessage(
                ("In CreateRestrictionTool - No geometry type found. EXITING ...."),
                level=Qgis.Info,
            )
            return

        QgsMapToolCapture.__init__(
            self, iface.mapCanvas(), iface.cadDockWidget(), captureMode
        )
        self.iface = iface
        self.layer = layer
        # self.dialog = dialog
        self.restrictionTransaction = restrictionTransaction
        self.proposalsManager = proposalsManager

        # self.blade = QgsMapToolEdit.createRubberBand(canvas)

        TOMsMessageLog.logMessage(
            (
                "In TOMsSplitRestrictionTool - geometryType: "
                + str(self.layer.geometryType())
            ),
            level=Qgis.Info,
        )

        # self.setMode(CreateRestrictionTool.CaptureLine)
        self.setAdvancedDigitizingAllowed(True)
        self.setAutoSnapEnabled(True)

        TOMsMessageLog.logMessage(
            ("In TOMsSplitRestrictionTool - mode set."), level=Qgis.Info
        )

        # Seems that this is important - or at least to create a point list that is used later to create Geometry
        self.sketchPoints = self.points()

        # get details of the selected feature
        self.selectedRestriction = self.iface.activeLayer().selectedFeatures()[0]
        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:initialising ... saving original feature + "
            + self.selectedRestriction.attribute("GeometryID"),
            level=Qgis.Info,
        )

        # store the current restriction
        self.origFeature = OriginalReature()

        self.origFeature.setFeature(self.selectedRestriction)
        self.origLayer = self.iface.activeLayer()
        # self.origLayer.startEditing()
        self.origFeature.printFeature()
        self.currPoint = None
        self.result = None
        self.nrPoints = None
        self.proposalPanel = None

    def cadCanvasReleaseEvent(self, event):
        QgsMapToolCapture.cadCanvasReleaseEvent(self, event)
        TOMsMessageLog.logMessage(
            ("In TOMsSplitRestrictionTool - cadCanvasReleaseEvent"), level=Qgis.Info
        )

        if event.button() == Qt.LeftButton:
            if not self.isCapturing():
                self.startCapturing()

            self.currPoint = event.mapPoint()
            # pt1 = self.toMapCoordinates(event.pos())

            # add point to rubber band
            self.result = self.addVertex(self.currPoint)

            TOMsMessageLog.logMessage(
                "In TOMsSplitRestrictionTool - added pt: "
                + str(self.size())
                + " X: "
                + str(self.currPoint.x())
                + " Y: "
                + str(self.currPoint.y()),
                level=Qgis.Info,
            )
            # QgsMapToolCapture.addVertex(self.toMapCoordinates(event.pos()))

        elif event.button() == Qt.RightButton:
            # Stop capture when right button or escape key is pressed
            # points = self.getCapturedPoints()

            self.getPointsCaptured()

            # also need to process split

    def getPointsCaptured(self):
        # Check the number of points
        self.nrPoints = self.size()
        TOMsMessageLog.logMessage(
            (
                "In TOMsSplitRestrictionTool - getPointsCaptured; Stopping: "
                + str(self.nrPoints)
            ),
            level=Qgis.Info,
        )

        self.sketchPoints = self.points()

        for point in self.sketchPoints:
            TOMsMessageLog.logMessage(
                (
                    "In SplitRestrictionTool - getPointsCaptured X:"
                    + str(point.x())
                    + " Y: "
                    + str(point.y())
                ),
                level=Qgis.Info,
            )

        # stop capture activity
        self.stopCapturing()

        if self.nrPoints <= 0:
            QMessageBox.information(
                None, "Error", "No cutting line created", QMessageBox.Ok
            )
            return
            # take points from the rubber band and create a geometry

        self.doSplitFeature(self.selectedRestriction, self.sketchPoints)

    def doSplitFeature(self, currRestriction, cutPointsList):

        TOMsMessageLog.logMessage(
            "In SplitRestrictionTool. doSplitFeature ...", level=Qgis.Info
        )

        # now split the restriction.
        originalGeometry = currRestriction.geometry()  # this will be amended ...
        (result, extraGeometriesList, _,) = originalGeometry.splitGeometry(
            QgsGeometry.fromPolylineXY(cutPointsList).asPolyline(), True
        )

        if result != QgsGeometry.OperationResult.Success:
            QMessageBox.information(
                None,
                "Error",
                "Issue splitting feature. Status: " + str(result),
                QMessageBox.Ok,
            )
            return

        extraGeometriesList.append(originalGeometry)
        # if split, need to get parts and deal with appropriately
        for newGeometry in extraGeometriesList:
            newRestriction = self.createNewSplitRestriction(
                currRestriction, newGeometry
            )
            if newRestriction is None:
                self.restrictionTransaction.rollBackTransactionGroup()
                return

        result = self.updateOriginalSplitRestriction(
            currRestriction
        )  # now deal with the original feature
        if result is False:
            self.restrictionTransaction.rollBackTransactionGroup()
            return

        self.restrictionTransaction.commitTransactionGroup()
        # self.restrictionTransaction.deleteTransactionGroup()

        self.origLayer.deselect(self.origFeature.getFeature().id())

        self.shutDownSplitTool()

        # Trying to unset map tool to force updates ...
        # self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())
        # currMapTool = self.iface.mapCanvas().mapTool()
        # currAction = currMapTool.action()

        # currMapToolAction = self.iface.mapCanvas().mapTool().action().setChecked(False)

    def createNewSplitRestriction(self, currRestriction, newGeometry):

        TOMsMessageLog.logMessage(
            "In SplitRestrictionTool. addNewSplitfeature ... ", level=Qgis.Info
        )

        # Now remove "GeometryID", "Opendate" and give the restriction a new "RestrictionID"
        # and add it to the proposal.
        keyFields = [
            "RestrictionID",
            "GeometryID",
            "OpenDate",
            "CloseDate",
        ]  # TODO: can we put this somewhere else
        currFields = currRestriction.fields()
        newRestriction = QgsFeature(currFields)

        # set the attributes
        for field in currFields:
            if field.name() not in keyFields:
                TOMsMessageLog.logMessage(
                    "In SplitRestrictionTool. addNewSplitfeature ... field: {}".format(
                        field.name()
                    ),
                    level=Qgis.Info,
                )
                try:
                    result = newRestriction.setAttribute(
                        field.name(), currRestriction.attribute(field.name())
                    )
                    if result is False:
                        TOMsMessageLog.logMessage(
                            "In SplitRestrictionTool:createNewSplitRestriction: problem setting value for {}".format(
                                field
                            ),
                            level=Qgis.Warning,
                        )
                        return None
                except Exception:
                    _, _, excTraceback = sys.exc_info()
                    QMessageBox.information(
                        None,
                        "Error",
                        "SplitRestrictionTool:createNewSplitRestriction: "
                        "Issue creating new feature after split. Status: "
                        + str(repr(traceback.extract_tb(excTraceback))),
                        QMessageBox.Ok,
                    )
                    return None

        newRestrictionID = str(uuid.uuid4())
        newRestriction.setAttribute(
            "RestrictionID", newRestrictionID
        )  # TODO: Understand why the trigger is not able to generate this !!!!!?????
        # set the geometry
        result = newRestriction.setGeometry(newGeometry)

        result = self.origLayer.addFeature(newRestriction)
        if result is False:
            self.restrictionTransaction.rollBackTransactionGroup()
            return None

        self.addRestrictionToProposal(
            newRestriction.attribute("RestrictionID"),
            self.getRestrictionLayerTableID(self.origLayer),
            self.proposalsManager.currentProposal(),
            RestrictionAction.OPEN,
        )  # close the original feature

        return newRestriction

    def updateOriginalSplitRestriction(self, changedRestriction):

        TOMsMessageLog.logMessage(
            "In SplitRestrictionTool:updateOriginalSplitRestriction ... ",
            level=Qgis.Info,
        )

        TOMsMessageLog.logMessage(
            "In SplitRestrictionTool:updateOriginalSplitRestriction. currProposal: "
            + str(self.proposalsManager.currentProposal()),
            level=Qgis.Info,
        )

        # When a geometry is changed; we need to check whether or not the feature is part of the current proposal

        if not self.restrictionInProposal(
            changedRestriction.attribute("RestrictionID"),
            self.getRestrictionLayerTableID(self.origLayer),
            self.proposalsManager.currentProposal(),
        ):
            TOMsMessageLog.logMessage(
                "In SplitRestrictionTool:onGeometryChanged - adding details to RestrictionsInProposal",
                level=Qgis.Info,
            )
            #  This one is not in the current Proposal, so now we need to:
            #  - add the original details to RestrictionsInProposal

            result = self.addRestrictionToProposal(
                changedRestriction.attribute("RestrictionID"),
                self.getRestrictionLayerTableID(self.origLayer),
                self.proposalsManager.currentProposal(),
                RestrictionAction.CLOSE,
            )  # close the original feature
            TOMsMessageLog.logMessage(
                "In SplitRestrictionTool:onGeometryChanged - orignal feature CLOSED. {}".format(
                    changedRestriction.attribute("RestrictionID")
                ),
                level=Qgis.Info,
            )

        else:
            result = self.deleteRestrictionInProposal(
                changedRestriction.attribute("RestrictionID"),
                self.getRestrictionLayerTableID(self.origLayer),
                self.proposalsManager.currentProposal(),
            )

            TOMsMessageLog.logMessage(
                "In SplitRestrictionTool:onGeometryChanged - changed feature already "
                "in RestrictionsInProposal. Now removed {}".format(
                    changedRestriction.attribute("RestrictionID")
                ),
                level=Qgis.Info,
            )

        return result

    def keyPressEvent(self, event):
        if (
            (event.key() == Qt.Key_Backspace)
            or (event.key() == Qt.Key_Delete)
            or (event.key() == Qt.Key_Escape)
        ):
            self.undo()
        if event.key() == Qt.Key_Return or event.key() == Qt.Key_Enter:
            pass

    def shutDownSplitTool(self):

        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:shutDownSplitTool .... ", level=Qgis.Info
        )

        # TODO: May need to disconnect geometryChange and featureDeleted signals
        # self.origLayer.geometryChanged.disconnect(self.on_cached_geometry_changed)
        # self.origLayer.featureDeleted.disconnect(self.on_cached_geometry_deleted)

        self.proposalPanel = self.iface.mainWindow().findChild(
            QDockWidget, "ProposalPanelDockWidgetBase"
        )
        self.setupPanelTabs(self.iface, self.proposalPanel)


class OriginalReature:  # TODO: duplicated ...
    def __init__(self):
        self.savedFeature = None

    def setFeature(self, feature):
        self.savedFeature = QgsFeature(feature)

    def getFeature(self):
        return self.savedFeature

    def getGeometryID(self):
        return self.savedFeature.attribute("GeometryID")

    def printFeature(self):
        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:originalFeature - attributes (fid:"
            + str(self.savedFeature.id())
            + "): "
            + str(self.savedFeature.attributes()),
            level=Qgis.Info,
        )
        TOMsMessageLog.logMessage(
            "In TOMsNodeTool:originalFeature - attributes: "
            + str(self.savedFeature.geometry().asWkt()),
            level=Qgis.Info,
        )


class EditRestrictionTool(QgsMapTool, MapToolMixin):
    def __init__(self, canvas, layer, onTrackEdited):
        QgsMapTool.__init__(self, canvas)
        self.onTrackEdited = onTrackEdited
        self.dragging = False
        self.feature = None
        self.vertex = None
        self.setLayer(layer)
        self.setCursor(Qt.CrossCursor)

    def canvasPressEvent(self, event):
        """Respond to the mouse button being pressed."""
        feature = self.findFeatureAt(event.pos())
        if feature is None:
            return

        vertex = self.findVertexAt(feature, event.pos())
        if vertex is None:
            return

        if event.button() == Qt.LeftButton:
            # Left click -> move vertex.
            self.dragging = True
            self.feature = feature
            self.vertex = vertex
            self.moveVertexTo(event.pos())
            self.canvas().refresh()
        elif event.button() == Qt.RightButton:
            # Right click -> delete vertex.
            self.deleteVertex(feature, vertex)
            self.canvas().refresh()

    def canvasMoveEvent(self, event):
        if self.dragging:
            self.moveVertexTo(event.pos())
            self.canvas().refresh()

    def canvasReleaseEvent(self, event):
        if self.dragging:
            self.moveVertexTo(event.pos())
            self.layer.updateExtents()
            self.canvas().refresh()
            self.dragging = False
            self.feature = None
            self.vertex = None

    def canvasDoubleClickEvent(self, event):
        feature = self.findFeatureAt(event.pos())
        if feature is None:
            return

        _, layerPt = self.transformCoordinates(event.pos())
        geometry = feature.geometry()

        distSquared, closestPt, beforeVertex = geometry.closestSegmentWithContext(
            layerPt
        )

        distance = math.sqrt(distSquared)
        tolerance = self.calcTolerance(event.pos())
        if distance > tolerance:
            return

        geometry.insertVertex(closestPt.x(), closestPt.y(), beforeVertex)
        self.layer.changeGeometry(feature.id(), geometry)
        self.onTrackEdited()
        self.canvas().refresh()

    def moveVertexTo(self, pos):
        """Move the edited vertex to the given position.

        'pos' is in canvas coordinates.
        """
        snappedPt = self.snapToNearestVertex(pos, self.feature)

        geometry = self.feature.geometry()
        geometry.moveVertex(snappedPt.x(), snappedPt.y(), self.vertex)
        self.layer.changeGeometry(self.feature.id(), geometry)
        self.onTrackEdited()

    def deleteVertex(self, feature, vertex):
        """Delete the given vertex from the given feature's geometry."""
        geometry = feature.geometry()

        lineString = geometry.asPolyline()
        if len(lineString) <= 2:
            return

        if geometry.deleteVertex(vertex):
            self.layer.changeGeometry(feature.id(), geometry)
            self.onTrackEdited()
