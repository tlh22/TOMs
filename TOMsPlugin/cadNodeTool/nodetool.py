# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# -----------------------------------------------------------
# Martin Dobias 2015
# Tim Hancock/Matthias Kuhn 2017
# Oslandia 2022

import math

from qgis.core import (
    Qgis,
    QgsCurve,
    QgsCurvePolygon,
    QgsFeatureRequest,
    QgsGeometry,
    QgsGeometryCollection,
    QgsPoint,
    QgsPointLocator,
    QgsPointXY,
    QgsProject,
    QgsRectangle,
    QgsSnappingUtils,
    QgsTolerance,
    QgsVectorLayer,
    QgsVertexId,
    QgsWkbTypes,
)
from qgis.gui import QgsMapToolAdvancedDigitizing, QgsRubberBand, QgsVertexMarker
from qgis.PyQt.QtCore import QRect, QSettings, Qt
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtWidgets import QRubberBand

from ..core.tomsMessageLog import TOMsMessageLog
from .geomutils import (
    adjacentVertexIndexToEndpoint,
    isEndpointAtVertexIndex,
    vertexAtVertexIndex,
    vertexIndexToTuple,
)


class Vertex:
    def __init__(self, layer, fid, vertexId):
        self.layer = layer
        self.fid = fid
        self.vertexId = vertexId


class Edge:
    def __init__(self, layer, fid, vertexId, startMapPoint):
        self.layer = layer
        self.fid = fid
        self.dragVertex0 = vertexId  # first vertex (with lower index)
        self.startMapPoint = startMapPoint  # map point where edge drag started


class OneFeatureFilter(QgsPointLocator.MatchFilter):
    """a filter to allow just one particular feature"""

    def __init__(self, layer, fid):
        QgsPointLocator.MatchFilter.__init__(self)
        self.layer = layer
        self.fid = fid
        TOMsMessageLog.logMessage(
            "In nodetool:OneFeatureFilter: Layer " + layer.name() + " | " + str(fid),
            level=Qgis.Info,
        )

    def acceptMatch(self, match):
        TOMsMessageLog.logMessage(
            "In nodetool:OneFeatureFilter: matchLayer "
            + match.layer().name()
            + " | "
            + str(match.featureId()),
            level=Qgis.Info,
        )
        return match.layer() == self.layer and match.featureId() == self.fid


def _digitizingColorWidth():
    settings = QSettings()
    color = QColor(
        settings.value("/qgis/digitizing/line_color_red", 255, type=int),
        settings.value("/qgis/digitizing/line_color_green", 0, type=int),
        settings.value("/qgis/digitizing/line_color_blue", 0, type=int),
        settings.value("/qgis/digitizing/line_color_alpha", 200, type=int),
    )
    width = settings.value("/qgis/digitizing/line_width", 1, type=int)
    return color, width


def _isCircularVertex(geom, vertexIndex):
    """Find out whether geom (QgsGeometry) has a circular vertex on the given index"""
    if geom is None:
        return False
    if (
        geom.type() != QgsWkbTypes.LineGeometry
        and geom.type() != QgsWkbTypes.PolygonGeometry
    ):
        return False
    vId = QgsVertexId()
    res, vId = geom.vertexIdFromVertexNr(
        vertexIndex
    )  # seems to have been a change in signature
    # v_id = geom.vertexIdFromVertexNr(vertex_index)

    # we need to get vertex type in this painful way because the above function
    # does not actually set "type" attribute (surprise surprise)
    qgeom = geom.get()
    if isinstance(qgeom, QgsGeometryCollection):
        qgeom = qgeom.geometryN(vId.part)
    if isinstance(qgeom, QgsCurvePolygon):
        qgeom = (
            qgeom.exteriorRing() if vId.ring == 0 else qgeom.interiorRing(vId.ring - 1)
        )
    assert isinstance(qgeom, QgsCurve)
    point = QgsPoint()
    res, vType = qgeom.pointAt(vId.vertex, point)
    if not res:
        return False
    return vType == QgsVertexId.CurveVertex


class NodeTool(QgsMapToolAdvancedDigitizing):
    def __init__(self, canvas, cadDock):
        QgsMapToolAdvancedDigitizing.__init__(self, canvas, cadDock)

        self.snapMarker = QgsVertexMarker(canvas)
        self.snapMarker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.snapMarker.setColor(Qt.magenta)
        self.snapMarker.setPenWidth(3)
        self.snapMarker.setVisible(False)

        self.edgeCenterMarker = QgsVertexMarker(canvas)
        self.edgeCenterMarker.setIconType(QgsVertexMarker.ICON_BOX)
        self.edgeCenterMarker.setColor(Qt.red)
        self.edgeCenterMarker.setPenWidth(1)
        self.edgeCenterMarker.setVisible(False)

        # used only for moving standalone points
        # (there are no adjacent vertices so self.drag_bands is empty in that case)
        self.dragPointMarke = QgsVertexMarker(canvas)
        self.dragPointMarke.setIconType(QgsVertexMarker.ICON_X)
        self.dragPointMarke.setColor(Qt.red)
        self.dragPointMarke.setPenWidth(3)
        self.dragPointMarke.setVisible(False)

        # rubber band for highlight of features on mouse over
        color, _ = _digitizingColorWidth()
        self.featureBan = QgsRubberBand(self.canvas())
        self.featureBan.setColor(color)
        self.featureBan.setWidth(3)
        self.featureBan.setVisible(False)
        self.featureBandSource = (
            None  # tuple (layer, fid) or None depending on what is being shown
        )

        self.vertexBan = QgsRubberBand(self.canvas())
        self.vertexBan.setIcon(QgsRubberBand.ICON_CIRCLE)
        self.vertexBan.setColor(color)
        self.vertexBan.setIconSize(10)
        self.vertexBan.setVisible(False)

        self.edgeBand = QgsRubberBand(self.canvas())
        color2 = QColor(color)
        color2.setAlpha(color2.alpha() / 3)
        self.edgeBand.setColor(color2)
        self.edgeBand.setWidth(5)
        self.edgeBand.setVisible(False)

        self.dragBands = []  # list of QgsRubberBand instances used when dragging
        self.dragging = (
            None  # instance of Vertex that is being currently moved or nothing
        )
        # (vertex_id when adding is a tuple (vid, adding_at_endpoint))
        self.draggingTopo = (
            []
        )  # list of Vertex instances of other vertices that are topologically
        # connected to the vertex being currently dragged
        self.draggingEdge = (
            None  # instance of Edge that is being currently moved or nothing
        )
        self.draggingEdgeBands = None  # tuple (band_0_1, bands_to_0, bands_to_1) with rubberbands when moving edge
        self.selectedNodes = []  # list of Vertex instances of nodes that are selected
        self.selectedNodesMarkers = []  # list of vertex markers

        self.draggingRectStartPos = None  # QPoint if user is dragging a selection rect
        self.selectionRect = None  # QRect in screen coordinates
        self.selectionRectItem = None  # QRubberBand to show selection_rect

        self.mouseAtEndpoint = None  # Vertex instance or None
        self.endpointMarkerCenter = (
            None  # QgsPoint or None (can't get center from QgsVertexMarker)
        )
        self.endpointMarker = QgsVertexMarker(canvas)
        self.endpointMarker.setIconType(QgsVertexMarker.ICON_BOX)
        self.endpointMarker.setColor(Qt.red)
        self.endpointMarker.setPenWidth(1)
        self.endpointMarker.setVisible(False)

        self.lastSnap = (
            None  # Match or None - to stick with previously highlighted feature
        )

        self.overrideCadPoints = None  # list of QgsPoint or None

        self.newVertexFromDoubleClick = None  # Match or None

        self.cache = {}

    def __del__(self):
        """Cleanup canvas items we have created"""
        self.canvas().scene().removeItem(self.snapMarker)
        self.canvas().scene().removeItem(self.edgeCenterMarker)
        self.canvas().scene().removeItem(self.dragPointMarke)
        self.canvas().scene().removeItem(self.featureBan)
        self.canvas().scene().removeItem(self.vertexBan)
        self.canvas().scene().removeItem(self.edgeBand)
        self.canvas().scene().removeItem(self.endpointMarker)
        self.snapMarker = None
        self.edgeCenterMarker = None
        self.dragPointMarke = None
        self.featureBan = None
        self.vertexBan = None
        self.edgeBand = None
        self.endpointMarker = None

    def deactivate(self):
        TOMsMessageLog.logMessage("In nodeTool:deactivate .... ", level=Qgis.Info)
        self.setHighlightedNodes([])
        self.removeTemporaryRubberBands()
        QgsMapToolAdvancedDigitizing.deactivate(self)

    def canUseCurrentLayer(self):

        layer = self.canvas().currentLayer()
        # layer = self.iface.activeLayer()

        TOMsMessageLog.logMessage(
            "In NodeTool:can_use_current_layer.  layer is " + str(layer.name()),
            level=Qgis.Info,
        )

        if not layer:
            TOMsMessageLog.logMessage(
                "In NodeTool:can_use_current_layer - no active layer!", level=Qgis.Info
            )
            print("no active layer!")
            return False

        if not isinstance(layer, QgsVectorLayer):
            print("not vector layer")
            return False

        if not layer.isEditable():
            print("layer not editable!")
            return False

        TOMsMessageLog.logMessage(
            "In NodeTool:can_use_current_layer - using current layer", level=Qgis.Info
        )

        return True

    def topoEditing(self):
        return QgsProject.instance().readNumEntry(
            "Digitizing", "/TopologicalEditing", 0
        )[0]

    def addDragBand(self, vertex1, vertex2):
        dragBand = QgsRubberBand(self.canvas())

        color, width = _digitizingColorWidth()

        dragBand.setColor(color)
        dragBand.setWidth(width)
        dragBand.addPoint(vertex1)
        dragBand.addPoint(vertex2)
        self.dragBands.append(dragBand)

    def clearDragBands(self):
        for band in self.dragBands:
            self.canvas().scene().removeItem(band)
        self.dragBands = []

        # for the case when standalone point geometry is being dragged
        self.dragPointMarke.setVisible(False)

    def cadCanvasPressEvent(self, e):

        TOMsMessageLog.logMessage("In NodeTool:cadCanvasPressEvent", level=Qgis.Info)

        if not self.can_use_current_layer():
            TOMsMessageLog.logMessage(
                "In NodeTool:cadCanvasPressEvent - NOT using current layer ...",
                level=Qgis.Info,
            )
            return

        TOMsMessageLog.logMessage(
            "In NodeTool:cadCanvasPressEvent - can use layer ...", level=Qgis.Info
        )

        # We now have a valid layer ...

        self.setHighlightedNodes([])  # reset selection

        if e.button() == Qt.LeftButton:

            # Ctrl+Click to highlight nodes without entering editing mode
            if e.modifiers() & Qt.ControlModifier:
                snapped = self.snapToEditableLayer(e)
                if snapped.hasVertex():
                    node = Vertex(
                        snapped.layer(), snapped.featureId(), snapped.vertexIndex()
                    )
                    self.setHighlightedNodes([node])
                return

            if not self.dragging and not self.draggingEdge:
                # the user may have started dragging a rect to select vertices
                self.draggingRectStartPos = e.pos()

    def cadCanvasReleaseEvent(self, e):

        TOMsMessageLog.logMessage("In NodeTool:cadCanvasReleaseEvent", level=Qgis.Info)

        if not self.canUseCurrentLayer():
            return

        if self.newVertexFromDoubleClick:
            vertex = self.newVertexFromDoubleClick
            self.newVertexFromDoubleClick = None

            # dragging of edges and double clicking on edges to add vertex are slightly overlapping
            # so we need to cancel edge moving before we start dragging new vertex
            self.stopDragging()
            self.startDraggingAddVertex(vertex)

        elif self.selectionRect is not None:
            # only handling of selection rect being dragged
            pt0 = self.toMapCoordinates(self.draggingRectStartPos)
            pt1 = self.toMapCoordinates(e.pos())
            mapRect = QgsRectangle(pt0, pt1)
            nodes = []

            # for each editable layer, select nodes
            for layer in self.canvas().layers():
                if not isinstance(layer, QgsVectorLayer) or not layer.isEditable():
                    continue
                layerRect = self.toLayerCoordinates(layer, mapRect)
                for feat in layer.getFeatures(QgsFeatureRequest(layerRect)):
                    geom = feat.geometry()

                    # TH (180630): Changed to deal with g = None

                    if not geom.isNull():
                        for i in range(geom.get().nCoordinates()):
                            point = geom.vertexAt(i)
                            if layerRect.contains(QgsPointXY(point)):
                                nodes.append(Vertex(layer, feat.id(), i))

            self.setHighlightedNodes(nodes)

            self.stopSelectionRect()

        # Check to see that changes have been made

        else:  # selection rect is not being dragged
            if e.button() == Qt.LeftButton:
                # accepting action
                TOMsMessageLog.logMessage(
                    "In NodeTool:cadCanvasReleaseEvent. Dragging ...", level=Qgis.Info
                )
                if self.dragging:
                    TOMsMessageLog.logMessage(
                        "In NodeTool:cadCanvasReleaseEvent. Dragging vertex ...",
                        level=Qgis.Info,
                    )
                    self.moveVertex(e.mapPoint(), e.mapPointMatch())
                elif self.draggingEdge:
                    TOMsMessageLog.logMessage(
                        "In NodeTool:cadCanvasReleaseEvent. Dragging edge ...",
                        level=Qgis.Info,
                    )
                    mapPoint = self.toMapCoordinates(
                        e.pos()
                    )  # do not use e.mapPoint() as it may be snapped
                    self.moveEdge(mapPoint)
                else:
                    TOMsMessageLog.logMessage(
                        "In NodeTool:cadCanvasReleaseEvent. Dragging something ...",
                        level=Qgis.Info,
                    )
                    self.startDragging(e)
            elif e.button() == Qt.RightButton:
                # cancelling action
                TOMsMessageLog.logMessage(
                    "In NodeTool:cadCanvasReleaseEvent. Stop dragging.", level=Qgis.Info
                )
                self.stopDragging()

        self.draggingRectStartPos = None

    def cadCanvasMoveEvent(self, e):

        if self.dragging:
            self.mouseMoveDragging(e)
        elif self.draggingEdge:
            self.mouseMoveDraggingEdge(e)
        elif self.draggingRectStartPos:
            # the user may be dragging a rect to select vertices
            if (
                self.selectionRect is None
                and (e.pos() - self.draggingRectStartPos).manhattanLength() >= 10
            ):
                self.startSelectionRect(self.draggingRectStartPos)
            if self.selectionRect is not None:
                self.updateSelectionRect(e.pos())
        else:
            self.mouseMoveNotDragging(e)

    def mouseMoveDragging(self, e):
        if e.mapPointMatch().isValid():
            self.snapMarker.setCenter(QgsPointXY(e.mapPoint()))
            self.snapMarker.setVisible(True)
        else:
            self.snapMarker.setVisible(False)

        self.edgeCenterMarker.setVisible(False)

        for band in self.drag_bands:
            band.movePoint(1, e.mapPoint())

        # in case of moving of standalone point geometry
        if self.dragPointMarke.isVisible():
            self.dragPointMarke.setCenter(QgsPointXY(e.mapPoint()))

        # make sure the temporary feature rubber band is not visible
        self.removeTemporaryRubberBands()

    def mouseMoveDraggingEdge(self, e):

        self.snapMarker.setVisible(False)
        self.edgeCenterMarker.setVisible(False)

        band01, bandsTo0, bandsTo1 = self.draggingEdgeBands
        dragLayer = self.draggingEdge.layer
        dragFid = self.draggingEdge.fid
        dragVertex0 = self.draggingEdge.dragVertex0
        dragStartPoint = self.draggingEdge.startMapPoint
        mapPoint = self.toMapCoordinates(
            e.pos()
        )  # do not use e.mapPoint() as it may be snapped
        diffX, diffY = (
            mapPoint.x() - dragStartPoint.x(),
            mapPoint.y() - dragStartPoint.y(),
        )

        geom = QgsGeometry(self.cachedGeometry(dragLayer, dragFid))
        # orig_map_point_0 = self.toMapCoordinates(drag_layer, geom.vertexAt(drag_vertex_0))
        origMapPoint0 = QgsPointXY(geom.vertexAt(dragVertex0))
        newMapPoint0 = QgsPointXY(origMapPoint0.x() + diffX, origMapPoint0.y() + diffY)
        origMapPoint1 = self.toMapCoordinates(dragLayer, geom.vertexAt(dragVertex0 + 1))
        origMapPoint1 = QgsPointXY(geom.vertexAt(dragVertex0 + 1))
        newMapPoint1 = QgsPointXY(origMapPoint1.x() + diffX, origMapPoint1.y() + diffY)

        band01.movePoint(0, newMapPoint0)
        band01.movePoint(1, newMapPoint1)

        for band in bandsTo0:
            band.movePoint(1, newMapPoint0)

        for band in bandsTo1:
            band.movePoint(1, newMapPoint1)

        # make sure the temporary feature rubber band is not visible
        self.removeTemporaryRubberBands()

    def canvasDoubleClickEvent(self, e):
        """Start addition of a new vertex on double-click"""
        snapped = self.snapToEditableLayer(e)
        if not snapped.isValid():
            return

        self.newVertexFromDoubleClick = snapped

    def removeTemporaryRubberBands(self):
        self.featureBan.setVisible(False)
        self.featureBandSource = None
        self.vertexBan.setVisible(False)
        self.edgeBand.setVisible(False)
        self.endpointMarkerCenter = None
        self.endpointMarker.setVisible(False)

    def snapToEditableLayer(self, e):
        """Temporarily override snapping config and snap to vertices and edges
        of any editable vector layer, to allow selection of node for editing
        (if snapped to edge, it would offer creation of a new vertex there).
        """

        mapPoint = self.toMapCoordinates(e.pos())
        tol = QgsTolerance.vertexSearchRadius(self.canvas().mapSettings())
        snapType = QgsPointLocator.Type(QgsPointLocator.Vertex | QgsPointLocator.Edge)

        snapLayers = []
        for layer in self.canvas().layers():
            if not isinstance(layer, QgsVectorLayer) or not layer.isEditable():
                continue
            snapLayers.append(
                QgsSnappingUtils.LayerConfig(
                    layer, snapType, tol, QgsTolerance.ProjectUnits
                )
            )

        snapUtil = self.canvas().snappingUtils()
        oldLayers = snapUtil.layers()
        oldMode = snapUtil.snapToMapMode()
        oldIntersections = snapUtil.snapOnIntersections()
        snapUtil.setLayers(snapLayers)
        snapUtil.setSnapToMapMode(QgsSnappingUtils.SnapAdvanced)
        snapUtil.setSnapOnIntersections(False)  # only snap to layers
        snapped = snapUtil.snapToMap(mapPoint)

        # try to stay snapped to previously used feature
        # so the highlight does not jump around at nodes where features are joined
        if self.lastSnap is not None:
            filterLast = OneFeatureFilter(
                self.lastSnap.layer(), self.lastSnap.featureId()
            )
            mLast = snapUtil.snapToMap(mapPoint, filterLast)
            if mLast.isValid() and mLast.distance() <= snapped.distance():
                snapped = mLast

        snapUtil.setLayers(oldLayers)
        snapUtil.setSnapToMapMode(oldMode)
        snapUtil.setSnapOnIntersections(oldIntersections)

        self.lastSnap = snapped

        return snapped

    def isNearEndpointMarker(self, mapPoint):
        """check whether we are still close to the self.endpoint_marker"""
        if self.endpointMarkerCenter is None:
            return False

        distMarker = math.sqrt(
            self.endpointMarkerCenter.sqrDist(mapPoint.x(), mapPoint.y())
        )
        tol = QgsTolerance.vertexSearchRadius(self.canvas().mapSettings())

        geom = self.cachedGeometryForVertex(self.mouseAtEndpoint)
        vertexPointV2 = vertexAtVertexIndex(geom, self.mouseAtEndpoint.vertexId)
        vertexPoint = QgsPointXY(vertexPointV2.x(), vertexPointV2.y())
        distVertex = math.sqrt(vertexPoint.sqrDist(mapPoint.x(), mapPoint.y()))

        return distMarker < tol and distMarker < distVertex

    def isMatchAtEndpoint(self, match):
        geom = self.cachedGeometry(match.layer(), match.featureId())

        if geom.type() != QgsWkbTypes.LineGeometry:
            return False

        return isEndpointAtVertexIndex(geom, match.vertexIndex())

    def positionForEndpointMarker(self, match):
        geom = self.cachedGeometry(match.layer(), match.featureId())

        pt0 = vertexAtVertexIndex(
            geom, adjacentVertexIndexToEndpoint(geom, match.vertexIndex())
        )
        pt1 = vertexAtVertexIndex(geom, match.vertexIndex())
        deltaX = pt1.x() - pt0.x()
        deltaY = pt1.y() - pt0.y()
        dist = 15 * self.canvas().mapSettings().mapUnitsPerPixel()
        angle = math.atan2(
            deltaY, deltaX
        )  # to the top: angle=0, to the right: angle=90, to the left: angle=-90
        x = pt1.x() + math.cos(angle) * dist
        y = pt1.y() + math.sin(angle) * dist
        return QgsPointXY(x, y)

    def mouseMoveNotDragging(self, e):

        TOMsMessageLog.logMessage(
            "In NodeTool:mouse_move_not_dragging", level=Qgis.Info
        )

        if self.mouseAtEndpoint is not None:
            # check if we are still at the endpoint, i.e. whether to keep showing
            # the endpoint indicator - or go back to snapping to editable layers
            mapPoint = self.toMapCoordinates(e.pos())
            if self.isNearEndpointMarker(mapPoint):
                self.endpointMarker.setColor(Qt.red)
                self.endpointMarker.update()
                # make it clear this would add endpoint, not move the vertex
                self.vertexBan.setVisible(False)
                return

        # do not use snap from mouse event, use our own with any editable layer
        snapped = self.snapToEditableLayer(e)

        TOMsMessageLog.logMessage(
            "In NodeTool:mouse_move_not_draggin: snap point "
            + str(snapped.type())
            + ";"
            + str(snapped.isValid())
            + "; "
            + self.toMapCoordinates(e.pos()).asWkt(),
            level=Qgis.Info,
        )
        TOMsMessageLog.logMessage(
            "In NodeTool:mouse_move_not_draggin: vertex "
            + str(snapped.hasVertex())
            + "; edge"
            + str(snapped.hasEdge())
            + "; area "
            + str(snapped.hasArea()),
            level=Qgis.Info,
        )

        # possibility to move a node
        if snapped.type() == QgsPointLocator.Vertex:
            TOMsMessageLog.logMessage(
                "In NodeTool:mouse_move_not_draggin: vertex ...", level=Qgis.Info
            )
            self.vertexBan.setToGeometry(QgsGeometry.fromPointXY(snapped.point()), None)
            self.vertexBan.setVisible(True)
            isCircularVertex = False
            if snapped.layer:
                geom = self.cachedGeometry(snapped.layer(), snapped.featureId())
                isCircularVertex = _isCircularVertex(geom, snapped.vertexIndex())

            self.vertexBan.setIcon(
                QgsRubberBand.ICON_FULL_BOX
                if isCircularVertex
                else QgsRubberBand.ICON_CIRCLE
            )
            # if we are at an endpoint, let's show also the endpoint indicator
            # so user can possibly add a new vertex at the end
            if self.isMatchAtEndpoint(snapped):
                self.mouseAtEndpoint = Vertex(
                    snapped.layer(), snapped.featureId(), snapped.vertexIndex()
                )
                self.endpointMarkerCenter = self.positionForEndpointMarker(snapped)
                self.endpointMarker.setCenter(self.endpointMarkerCenter)
                self.endpointMarker.setColor(Qt.gray)
                self.endpointMarker.setVisible(True)
                self.endpointMarker.update()
            else:
                self.mouseAtEndpoint = None
                self.endpointMarkerCenter = None
                self.endpointMarker.setVisible(False)
        else:
            self.vertexBan.setVisible(False)
            self.mouseAtEndpoint = None
            self.endpointMarkerCenter = None
            self.endpointMarker.setVisible(False)

        # possibility to create new node here - or to move the edge
        if snapped.type() == QgsPointLocator.Edge:
            TOMsMessageLog.logMessage(
                "In NodeTool:mouse_move_not_draggin: edge ...", level=Qgis.Info
            )
            mapPoint = self.toMapCoordinates(e.pos())
            edgeCenter, isNearCenter = self._matchEdgeCenterTest(snapped, mapPoint)
            self.edgeCenterMarker.setCenter(QgsPointXY(edgeCenter))
            self.edgeCenterMarker.setColor(Qt.red if isNearCenter else Qt.gray)
            self.edgeCenterMarker.setVisible(True)
            self.edgeCenterMarker.update()

            point0, point1 = snapped.edgePoints()
            self.edgeBand.setToGeometry(
                QgsGeometry.fromPolylineXY([point0, point1]), None
            )
            self.edgeBand.setVisible(not isNearCenter)
        else:
            self.edgeCenterMarker.setVisible(False)
            self.edgeBand.setVisible(False)

        # highlight feature
        if snapped.isValid() and snapped.layer():
            TOMsMessageLog.logMessage(
                "In NodeTool:mouse_move_not_dragging: highlighting feature ...",
                level=Qgis.Info,
            )
            if self.featureBandSource == (snapped.layer(), snapped.featureId()):
                return  # skip regeneration of rubber band if not needed
            geom = self.cachedGeometry(snapped.layer(), snapped.featureId())
            if QgsWkbTypes.isCurvedType(geom.get().wkbType()):
                geom = QgsGeometry(geom.get().segmentize())
                TOMsMessageLog.logMessage(
                    "In NodeTool:mouse_move_not_dragging: showing feature ...",
                    level=Qgis.Info,
                )
            self.featureBan.setToGeometry(geom, snapped.layer())
            self.featureBan.setVisible(True)
            self.featureBandSource = (snapped.layer(), snapped.featureId())
        else:
            self.featureBan.setVisible(False)
            self.featureBandSource = None

    def keyPressEvent(self, e):

        TOMsMessageLog.logMessage("In NodeTool:keyPressEvent", level=Qgis.Info)

        if not self.dragging and len(self.selectedNodes) == 0:
            return

        if e.key() == Qt.Key_Delete:
            e.ignore()  # Override default shortcut management
            self.deleteVertex()
        elif e.key() == Qt.Key_Escape:
            if self.dragging:
                self.stopDragging()
        elif e.key() == Qt.Key_Comma:
            self.highlightAdjacentVertex(-1)
        elif e.key() == Qt.Key_Period:
            self.highlightAdjacentVertex(+1)

    # ------------

    def cachedGeometry(self, layer, fid):
        # TH (210130) deal with fid is None
        try:

            if layer not in self.cache:
                self.cache[layer] = {}
                layer.geometryChanged.connect(self.onCachedGeometryChanged)
                layer.featureDeleted.connect(self.onCachedGeometryDeleted)

            if fid not in self.cache[layer]:
                # f = layer.getFeatures(QgsFeatureRequest(fid)).next()
                feat = layer.getFeature(fid)
                self.cache[layer][fid] = QgsGeometry(feat.geometry())

            return self.cache[layer][fid]

        except Exception:

            return None

    def cachedGeometryForVertex(self, vertex):
        return self.cachedGeometry(vertex.layer, vertex.fid)

    def onCachedGeometryChanged(self, fid, geom):
        """update geometry of our feature"""
        TOMsMessageLog.logMessage(
            "In NodeTool:on_cached_geometry_changed", level=Qgis.Info
        )
        layer = self.sender()
        assert layer in self.cache
        if fid in self.cache[layer]:
            self.cache[layer][fid] = QgsGeometry(geom)

    def onCachedGeometryDeleted(self, fid):
        layer = self.sender()
        assert layer in self.cache
        if fid in self.cache[layer]:
            del self.cache[layer][fid]

    def startDragging(self, e):

        TOMsMessageLog.logMessage("In start_dragging", level=Qgis.Info)

        mapPoint = self.toMapCoordinates(e.pos())
        if self.isNearEndpointMarker(mapPoint):
            self.startDraggingAddVertexAtEndpoint(mapPoint)
            return

        snapped = self.snapToEditableLayer(e)
        if not snapped.isValid():
            print("wrong snap!")
            return

        # activate advanced digitizing dock
        # self.setMode(self.CaptureLine)
        self.setAutoSnapEnabled(True)  # v3
        self.setAdvancedDigitizingAllowed(True)

        # adding a new vertex instead of moving a vertex
        if snapped.hasEdge():
            # only start dragging if we are near edge center
            mapPoint = self.toMapCoordinates(e.pos())
            _, isNearCenter = self._matchEdgeCenterTest(snapped, mapPoint)
            if isNearCenter:
                self.startDraggingAddVertex(snapped)
            else:
                self.startDraggingEdge(snapped, mapPoint)
        else:  # vertex
            self.startDraggingMoveVertex(e.mapPoint(), snapped)

    def startDraggingMoveVertex(self, mapPoint, snapped):

        assert snapped.hasVertex()

        TOMsMessageLog.logMessage("In start_dragging_move_vertex ...", level=Qgis.Info)

        geom = self.cachedGeometry(snapped.layer(), snapped.featureId())

        if not geom:
            return  # don't continue ...

        # start dragging of snapped point of current layer
        self.dragging = Vertex(
            snapped.layer(), snapped.featureId(), snapped.vertexIndex()
        )
        self.draggingTopo = []

        v0idx, v1idx = geom.adjacentVertices(snapped.vertexIndex())
        if v0idx != -1:
            layerPoint0 = geom.vertexAt(v0idx)
            # map_point0 = self.toMapCoordinates(m.layer(), layer_point0)
            mapPoint0 = QgsPointXY(layerPoint0)
            self.add_drag_band(mapPoint0, snapped.point())
        if v1idx != -1:
            layerPoint1 = geom.vertexAt(v1idx)
            # map_point1 = self.toMapCoordinates(m.layer(), layer_point1)
            mapPoint1 = QgsPointXY(layerPoint1)
            self.addDragBand(mapPoint1, snapped.point())

        if v0idx == -1 and v1idx == -1:
            # this is a standalone point - we need to use a marker for it
            # to give some feedback to the user
            self.dragPointMarke.setCenter(QgsPointXY(mapPoint))
            self.dragPointMarke.setVisible(True)

        self.overrideCadPoints = [snapped.point(), snapped.point()]

        if not self.topoEditing():
            return  # we are done now

        # support for topo editing - find extra features
        for layer in self.canvas().layers():
            if not isinstance(layer, QgsVectorLayer) or not layer.isEditable():
                continue

            TOMsMessageLog.logMessage(
                "In start_dragging_move_vertex. Considering " + str(layer.name()),
                level=Qgis.Info,
            )

            for otherM in self.layerVerticesSnappedToPoint(layer, mapPoint):
                TOMsMessageLog.logMessage(
                    "In start_dragging_move_vertex. Looking for match on "
                    + str(layer.name()),
                    level=Qgis.Info,
                )

                if otherM == snapped:
                    continue

                TOMsMessageLog.logMessage(
                    "In start_dragging_move_vertex. Found locator for "
                    + str(layer.name()),
                    level=Qgis.Info,
                )

                otherG = self.cachedGeometry(otherM.layer(), otherM.featureId())

                # start dragging of snapped point of current layer
                self.draggingTopo.append(
                    Vertex(otherM.layer(), otherM.featureId(), otherM.vertexIndex())
                )

                v0idx, v1idx = otherG.adjacentVertices(otherM.vertexIndex())
                if v0idx != -1:
                    otherPoint0 = otherG.vertexAt(v0idx)
                    # other_map_point0 = self.toMapCoordinates(other_m.layer(), other_point0)
                    otherMapPoint0 = QgsPointXY(otherPoint0)
                    self.add_drag_band(otherMapPoint0, otherM.point())
                if v1idx != -1:
                    otherPoint1 = otherG.vertexAt(v1idx)
                    # other_map_point1 = self.toMapCoordinates(other_m.layer(), other_point1)
                    otherMapPoint1 = QgsPointXY(otherPoint1)
                    self.add_drag_band(otherMapPoint1, otherM.point())

    def layerVerticesSnappedToPoint(self, layer, mapPoint):
        """Get list of matches of all vertices of a layer exactly snapped to a map point"""

        class MyFilter(QgsPointLocator.MatchFilter):
            """a filter just to gather all matches at the same place"""

            def __init__(self, nodetool):
                QgsPointLocator.MatchFilter.__init__(self)
                self.matches = []
                self.nodetool = nodetool

            def acceptMatch(self, match):
                if match.distance() > 0:
                    return False
                self.matches.append(match)

                # there may be multiple points at the same location, but we get only one
                # result... the locator API needs a new method verticesInRect()
                matchGeom = self.nodetool.cachedGeometry(
                    match.layer(), match.featureId()
                )
                point = QgsPoint()
                vNr = 0

                TOMsMessageLog.logMessage(
                    "In layer_vertices_snapped_to_point.acceptMatch", level=Qgis.Info
                )

                # while match_geom.get().nextVertex(vid, pt):
                geomIter = matchGeom.vertices()
                while geomIter.hasNext():

                    point = geomIter.next()
                    vindex = vNr

                    # if pt.x() == match.point().x() and pt.y() == match.point().y() and vindex != match.vertexIndex():
                    if (
                        point.x() == match.point().x()
                        and point.y() == match.point().y()
                    ):
                        extraMatch = QgsPointLocator.Match(
                            match.type(),
                            match.layer(),
                            match.featureId(),
                            0,
                            match.point(),
                            vindex,
                        )
                        self.matches.append(extraMatch)

                    vNr = vNr + 1

                return True

        TOMsMessageLog.logMessage("In layer_vertices_snapped_to_point", level=Qgis.Info)

        myfilter = MyFilter(self)
        loc = self.canvas().snappingUtils().locatorForLayer(layer)
        loc.nearestVertex(mapPoint, 0, myfilter)
        return myfilter.matches

    def startDraggingAddVertex(self, snapped):

        TOMsMessageLog.logMessage("In start_dragging_add_vertex", level=Qgis.Info)
        assert snapped.hasEdge()

        # activate advanced digitizing dock
        # self.setMode(self.CaptureLine)
        self.setAutoSnapEnabled(True)  # v3
        self.setAdvancedDigitizingAllowed(True)

        self.dragging = Vertex(
            snapped.layer(), snapped.featureId(), (snapped.vertexIndex() + 1, False)
        )
        self.draggingTopo = []

        geom = self.cachedGeometry(snapped.layer(), snapped.featureId())

        # TODO: handles rings correctly?
        vertex0 = geom.vertexAt(snapped.vertexIndex())
        vertex1 = geom.vertexAt(snapped.vertexIndex() + 1)

        # map_v0 = self.toMapCoordinates(m.layer(), v0)
        mapV0 = QgsPointXY(vertex0)
        # map_v1 = self.toMapCoordinates(m.layer(), v1)
        mapV1 = QgsPointXY(vertex1)

        if vertex0.x() != 0 or vertex0.y() != 0:
            self.add_drag_band(mapV0, snapped.point())
        if vertex1.x() != 0 or vertex1.y() != 0:
            self.add_drag_band(mapV1, snapped.point())

        self.overrideCadPoints = [snapped.point(), snapped.point()]

    def startDraggingAddVertexAtEndpoint(self, mapPoint):

        TOMsMessageLog.logMessage(
            "In start_dragging_add_vertex_at_endpoint", level=Qgis.Info
        )
        assert self.mouseAtEndpoint is not None

        # activate advanced digitizing dock
        # self.setMode(self.CaptureLine)
        self.setAutoSnapEnabled(True)  # v3
        self.setAdvancedDigitizingAllowed(True)

        self.dragging = Vertex(
            self.mouseAtEndpoint.layer,
            self.mouseAtEndpoint.fid,
            (self.mouseAtEndpoint.vertexId, True),
        )
        self.draggingTopo = []

        geom = self.cachedGeometry(self.mouseAtEndpoint.layer, self.mouseAtEndpoint.fid)
        vertex0 = geom.vertexAt(self.mouseAtEndpoint.vertexId)
        # map_v0 = self.toMapCoordinates(self.mouse_at_endpoint.layer, v0)
        mapV0 = QgsPointXY(vertex0)

        self.add_drag_band(mapV0, mapPoint)

        # setup CAD dock previous points to endpoint and the previous point
        pt0 = vertexAtVertexIndex(
            geom,
            adjacentVertexIndexToEndpoint(geom, self.mouseAtEndpoint.vertexId),
        )
        pt1 = vertexAtVertexIndex(geom, self.mouseAtEndpoint.vertexId)
        self.overrideCadPoints = [pt0, pt1]

    def startDraggingEdge(self, snapped, mapPoint):

        TOMsMessageLog.logMessage("In start_dragging_edge", level=Qgis.Info)
        assert snapped.hasEdge()

        # activate advanced digitizing
        # self.setMode(self.CaptureLine)
        self.setAutoSnapEnabled(True)  # v3
        self.setAdvancedDigitizingAllowed(True)

        self.draggingEdge = Edge(
            snapped.layer(), snapped.featureId(), snapped.vertexIndex(), mapPoint
        )
        self.draggingTopo = []

        edgeP0, edgeP1 = snapped.edgePoints()
        geom = self.cachedGeometry(snapped.layer(), snapped.featureId())

        bandsToP0, bandsToP1 = [], []

        # add drag bands
        self.add_drag_band(edgeP0, edgeP1)
        v0idx, _ = geom.adjacentVertices(snapped.vertexIndex())
        _, v1idx = geom.adjacentVertices(snapped.vertexIndex() + 1)
        if v0idx != -1:
            layerPoint0 = geom.vertexAt(v0idx)
            # map_point0 = self.toMapCoordinates(m.layer(), layer_point0)
            mapPoint0 = QgsPointXY(layerPoint0)
            self.add_drag_band(mapPoint0, edgeP0)
            bandsToP0.append(self.drag_bands[-1])
        if v1idx != -1:
            layerPoint1 = geom.vertexAt(v1idx)
            # map_point1 = self.toMapCoordinates(m.layer(), layer_point1)
            mapPoint1 = QgsPointXY(layerPoint1)
            self.add_drag_band(mapPoint1, edgeP1)
            bandsToP1.append(self.drag_bands[-1])

        self.draggingEdgeBands = (self.drag_bands[0], bandsToP0, bandsToP1)

        self.overrideCadPoints = [snapped.point(), snapped.point()]

        # TODO: add topo points

    def stopDragging(self):

        TOMsMessageLog.logMessage("In stop_dragging", level=Qgis.Info)
        # deactivate advanced digitizing
        # self.setMode(self.CaptureNone)
        self.setAutoSnapEnabled(False)  # v3
        self.setAdvancedDigitizingAllowed(False)
        # self.deactivate()

        self.cadDockWidget().disable()

        self.dragging = False
        self.draggingEdge = None
        self.draggingEdgeBands = None
        self.clear_drag_bands()

    def matchToLayerPoint(self, destLayer, mapPoint, match):

        layerPoint = None
        # try to use point coordinates in the original CRS if it is the same
        if (
            match
            and match.hasVertex()
            and match.layer()
            and match.layer().crs() == destLayer.crs()
        ):
            try:
                # f = match.layer().getFeatures(QgsFeatureRequest(match.featureId())).next()
                feat = match.layer().getFeature(match.featureId())
                layerPoint = feat.geometry().vertexAt(match.vertexIndex())
            except StopIteration:
                pass

        # fall back to reprojection of the map point to layer point if they are not the same CRS
        if layerPoint is None:
            layerPoint = self.toLayerCoordinates(destLayer, mapPoint)
        return layerPoint

    def moveEdge(self, mapPoint):
        """Finish moving of an edge"""

        dragLayer = self.draggingEdge.layer
        dragFid = self.draggingEdge.fid
        dragVertex0 = self.draggingEdge.dragVertex0
        dragStartPoint = self.draggingEdge.startMapPoint

        self.stopDragging()

        diffX, diffY = (
            mapPoint.x() - dragStartPoint.x(),
            mapPoint.y() - dragStartPoint.y(),
        )

        geom = QgsGeometry(self.cachedGeometry(dragLayer, dragFid))

        # TODO: move topo points

        dragLayer.beginEditCommand(self.tr("Moved edge"))

        # move first endpoint
        # orig_map_point_0 = self.toMapCoordinates(drag_layer, geom.vertexAt(drag_vertex_0))
        origMapPoint0 = QgsPointXY(geom.vertexAt(dragVertex0))
        newMapPoint0 = QgsPoint(origMapPoint0.x() + diffX, origMapPoint0.y() + diffY)
        self.dragging = Vertex(dragLayer, dragFid, dragVertex0)
        self.moveVertex(newMapPoint0, None)

        # move second endpoint
        # orig_map_point_1 = self.toMapCoordinates(drag_layer, geom.vertexAt(drag_vertex_0+1))
        origMapPoint1 = QgsPointXY(geom.vertexAt(dragVertex0 + 1))
        newMapPoint1 = QgsPoint(origMapPoint1.x() + diffX, origMapPoint1.y() + diffY)
        self.dragging = Vertex(dragLayer, dragFid, dragVertex0 + 1)
        self.moveVertex(newMapPoint1, None)

        dragLayer.endEditCommand()

    def moveVertex(self, mapPoint, mapPointMatch):

        # deactivate advanced digitizing
        # self.setMode(self.CaptureNone)
        self.setAutoSnapEnabled(False)  # v3
        self.setAdvancedDigitizingAllowed(False)

        dragLayer = self.dragging.layer
        dragFid = self.dragging.fid
        dragVertexId = self.dragging.vertexId
        geom = QgsGeometry(self.cachedGeometryForVertex(self.dragging))
        self.stopDragging()

        addingVertex = False
        addingAtEndpoint = False
        if isinstance(
            dragVertexId, tuple
        ):  # TH (191027): Not sure why using tuple and how "adding_at_endpoint" is set
            addingVertex = True
            dragVertexId, addingAtEndpoint = dragVertexId

        layerPoint = self.matchToLayerPoint(dragLayer, mapPoint, mapPointMatch)

        # add/move vertex
        if addingVertex:
            # ordinary geom.insertVertex does not support appending so we use geometry V2
            dragPart, dragRing, dragVertex = vertexIndexToTuple(geom, dragVertexId)
            if addingAtEndpoint and dragVertex != 0:  # appending?
                dragVertex += 1
            vid = QgsVertexId(dragPart, dragRing, dragVertex, QgsVertexId.SegmentVertex)
            geomTmp = geom.get().clone()
            if not geomTmp.insertVertex(vid, QgsPoint(layerPoint)):
                print("append vertex failed!")
                return
            geom.set(geomTmp)
        else:
            if not geom.moveVertex(layerPoint.x(), layerPoint.y(), dragVertexId):
                print("move vertex failed!")
                return

        edits = {dragLayer: {dragFid: geom}}  # dict { layer : { fid : geom } }

        # add moved vertices from other layers
        for topo in self.draggingTopo:
            if topo.layer not in edits:
                edits[topo.layer] = {}
            if topo.fid in edits[topo.layer]:
                topoGeom = QgsGeometry(edits[topo.layer][topo.fid])
            else:
                topoGeom = QgsGeometry(self.cachedGeometryForVertex(topo))

            if topo.layer.crs() == dragLayer.crs():
                point = layerPoint
            else:
                point = self.toLayerCoordinates(topo.layer, mapPoint)

            if not topoGeom.moveVertex(point.x(), point.y(), topo.vertex_id):
                print("[topo] move vertex failed!")
                continue
            edits[topo.layer][topo.fid] = topoGeom

        # TODO: add topological points: when moving vertex - if snapped to something

        # do the changes to layers
        for layer, featuresDict in edits.items():
            layer.beginEditCommand(self.tr("Moved vertex"))
            for fid, geometry in featuresDict.items():
                layer.changeGeometry(fid, geometry)
            layer.endEditCommand()
            layer.triggerRepaint()

    def deleteVertex(self):

        if len(self.selectedNodes) != 0:
            toDelete = self.selectedNodes
        else:
            addingVertex = isinstance(self.dragging.vertexId, tuple)
            toDelete = [self.dragging] + self.draggingTopo
            self.stopDragging()

            if addingVertex:
                return  # just cancel the vertex

        self.setHighlightedNodes([])  # reset selection

        # switch from a plain list to dictionary { layer: { fid: [vertexNr1, vertexNr2, ...] } }
        toDeleteGrouped = {}
        for vertex in toDelete:
            if vertex.layer not in toDeleteGrouped:
                toDeleteGrouped[vertex.layer] = {}
            if vertex.fid not in toDeleteGrouped[vertex.layer]:
                toDeleteGrouped[vertex.layer][vertex.fid] = []
            toDeleteGrouped[vertex.layer][vertex.fid].append(vertex.vertexId)

        # main for cycle to delete all selected vertices
        for layer, featuresDict in toDeleteGrouped.items():

            layer.beginEditCommand(self.tr("Deleted vertex"))
            success = True

            for fid, vertexIds in featuresDict.items():
                res = QgsVectorLayer.Success
                for vertexId in sorted(vertexIds, reverse=True):
                    if res != QgsVectorLayer.EmptyGeometry:
                        res = layer.deleteVertex(fid, vertexId)
                    if res not in [
                        QgsVectorLayer.EmptyGeometry,
                        QgsVectorLayer.Success,
                    ]:
                        print(
                            "failed to delete vertex!",
                            layer.name(),
                            fid,
                            vertexId,
                            vertexIds,
                        )
                        success = False

            if success:
                layer.endEditCommand()
                layer.triggerRepaint()
            else:
                layer.destroyEditCommand()

        # pre-select next node for deletion if we are deleting just one node
        if len(toDelete) == 1:
            vertex = toDelete[0]
            geom = QgsGeometry(self.cachedGeometryForVertex(vertex))

            # if next vertex is not available, use the previous one
            if geom.vertexAt(vertex.vertexId) == QgsPoint():
                vertex.vertex_id -= 1

            if geom.vertexAt(vertex.vertexId) != QgsPoint():
                self.setHighlightedNodes(
                    [Vertex(vertex.layer, vertex.fid, vertex.vertexId)]
                )

    def setHighlightedNodes(self, listNodes):
        for marker in self.selectedNodesMarkers:
            self.canvas().scene().removeItem(marker)
        self.selectedNodesMarkers = []

        for node in listNodes:
            geom = self.cachedGeometryForVertex(node)
            marker = QgsVertexMarker(self.canvas())
            marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
            # marker.setIconSize(5)
            # marker.setPenWidth(2)
            marker.setColor(Qt.blue)
            marker.setCenter(QgsPointXY(geom.vertexAt(node.vertexId)))
            self.selectedNodesMarkers.append(marker)
        self.selectedNodes = listNodes

    def highlightAdjacentVertex(self, offset):
        """Allow moving back and forth selected vertex within a feature"""
        if len(self.selectedNodes) == 0:
            return

        node = self.selectedNodes[0]  # simply use the first one

        geom = self.cachedGeometryForVertex(node)
        point = geom.vertexAt(node.vertexId + offset)
        if point != QgsPoint():
            node = Vertex(node.layer, node.fid, node.vertexId + offset)
        self.setHighlightedNodes([node])

    def startSelectionRect(self, point0):
        """Initialize rectangle that is being dragged to select nodes.
        Argument point0 is in screen coordinates."""
        assert self.selectionRect is None
        self.selectionRect = QRect()
        self.selectionRect.setTopLeft(point0)
        self.selectionRectItem = QRubberBand(QRubberBand.Rectangle, self.canvas())

    def updateSelectionRect(self, point1):
        """Update bottom-right corner of the existing selection rectangle.
        Argument point1 is in screen coordinates."""
        assert self.selectionRect is not None
        self.selectionRect.setBottomRight(point1)
        self.selectionRectItem.setGeometry(self.selectionRect.normalized())
        self.selectionRectItem.show()

    def stopSelectionRect(self):
        assert self.selectionRect is not None
        self.selectionRectItem.deleteLater()
        self.selectionRectItem = None
        self.selectionRect = None

    def _matchEdgeCenterTest(self, snapped, mapPoint):
        """Using a given edge match and original map point, find out
        center of the edge and whether we are close enough to the center"""
        point0, point1 = snapped.edgePoints()

        visibleExtent = self.canvas().mapSettings().visibleExtent()
        if not visibleExtent.contains(point0) or not visibleExtent.contains(point1):
            # clip line segment to the extent so the mid-point marker is always visible
            extentGeom = QgsGeometry.fromRect(visibleExtent)
            lineGeom = QgsGeometry.fromPolylineXY([point0, point1])
            lineGeom = extentGeom.intersection(lineGeom)
            point0, point1 = lineGeom.asPolyline()

        edgeCenter = QgsPoint(
            (point0.x() + point1.x()) / 2, (point0.y() + point1.y()) / 2
        )

        distFromEdgeCenter = math.sqrt(mapPoint.sqrDist(edgeCenter.x(), edgeCenter.y()))
        tol = QgsTolerance.vertexSearchRadius(self.canvas().mapSettings())
        isNearCenter = distFromEdgeCenter < tol

        return edgeCenter, isNearCenter
