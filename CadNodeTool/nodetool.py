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

import math

from PyQt4.QtGui import *
from PyQt4.QtCore import *

from qgis.core import *
from qgis.gui import *

from geomutils import is_endpoint_at_vertex_index, vertex_at_vertex_index, adjacent_vertex_index_to_endpoint, vertex_index_to_tuple


class Vertex(object):
    def __init__(self, layer, fid, vertex_id):
        self.layer = layer
        self.fid = fid
        self.vertex_id = vertex_id

class Edge(object):
    def __init__(self, layer, fid, vertex_id, start_map_point):
        self.layer = layer
        self.fid = fid
        self.edge_vertex_0 = vertex_id   # first vertex (with lower index)
        self.start_map_point = start_map_point  # map point where edge drag started


class OneFeatureFilter(QgsPointLocator.MatchFilter):
    """ a filter to allow just one particular feature """
    def __init__(self, layer, fid):
        QgsPointLocator.MatchFilter.__init__(self)
        self.layer = layer
        self.fid = fid
    def acceptMatch(self, match):
        return match.layer() == self.layer and match.featureId() == self.fid


def _digitizing_color_width():
    settings = QSettings()
    color = QColor(
      settings.value("/qgis/digitizing/line_color_red", 255, type=int),
      settings.value("/qgis/digitizing/line_color_green", 0, type=int),
      settings.value("/qgis/digitizing/line_color_blue", 0, type=int),
      settings.value("/qgis/digitizing/line_color_alpha", 200, type=int) )
    width = settings.value("/qgis/digitizing/line_width", 1, type=int)
    return color, width


def _is_circular_vertex(geom, vertex_index):
    """Find out whether geom (QgsGeometry) has a circular vertex on the given index"""
    if geom.type() != QGis.Line and geom.type() != QGis.Polygon:
        return False
    v_id = QgsVertexId()
    res = geom.vertexIdFromVertexNr(vertex_index, v_id)

    # we need to get vertex type in this painful way because the above function
    # does not actually set "type" attribute (surprise surprise)
    g = geom.geometry()
    if isinstance(g, QgsGeometryCollectionV2):
        g = g.geometryN(v_id.part)
    if isinstance(g, QgsCurvePolygonV2):
        g = g.exteriorRing() if v_id.ring == 0 else g.interiorRing(v_id.ring - 1)
    assert isinstance(g, QgsCurveV2)
    p = QgsPointV2()
    res, v_type = g.pointAt(v_id.vertex, p)
    if not res:
        return False
    return v_type == QgsVertexId.CurveVertex





class NodeTool(QgsMapToolAdvancedDigitizing):
    def __init__(self, canvas, cadDock):
        QgsMapToolAdvancedDigitizing.__init__(self, canvas, cadDock)

        self.snap_marker = QgsVertexMarker(canvas)
        self.snap_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.snap_marker.setColor(Qt.magenta)
        self.snap_marker.setPenWidth(3)
        self.snap_marker.setVisible(False)

        self.edge_center_marker = QgsVertexMarker(canvas)
        self.edge_center_marker.setIconType(QgsVertexMarker.ICON_BOX)
        self.edge_center_marker.setColor(Qt.red)
        self.edge_center_marker.setPenWidth(1)
        self.edge_center_marker.setVisible(False)

        # used only for moving standalone points
        # (there are no adjacent vertices so self.drag_bands is empty in that case)
        self.drag_point_marker = QgsVertexMarker(canvas)
        self.drag_point_marker.setIconType(QgsVertexMarker.ICON_X)
        self.drag_point_marker.setColor(Qt.red)
        self.drag_point_marker.setPenWidth(3)
        self.drag_point_marker.setVisible(False)

        # rubber band for highlight of features on mouse over
        settings = QSettings()
        color, width = _digitizing_color_width()
        self.feature_band = QgsRubberBand(self.canvas())
        self.feature_band.setColor(color)
        self.feature_band.setWidth(5)
        self.feature_band.setVisible(False)
        self.feature_band_source = None   # tuple (layer, fid) or None depending on what is being shown

        self.vertex_band = QgsRubberBand(self.canvas())
        self.vertex_band.setIcon(QgsRubberBand.ICON_CIRCLE)
        self.vertex_band.setColor(color)
        self.vertex_band.setIconSize(15)
        self.vertex_band.setVisible(False)

        self.edge_band = QgsRubberBand(self.canvas())
        color2 = QColor(color)
        color2.setAlpha(color2.alpha()/3)
        self.edge_band.setColor(color2)
        self.edge_band.setWidth(10)
        self.edge_band.setVisible(False)

        self.drag_bands = []        # list of QgsRubberBand instances used when dragging
        self.dragging = None        # instance of Vertex that is being currently moved or nothing
                                    # (vertex_id when adding is a tuple (vid, adding_at_endpoint))
        self.dragging_topo = []     # list of Vertex instances of other vertices that are topologically
                                    # connected to the vertex being currently dragged
        self.dragging_edge = None   # instance of Edge that is being currently moved or nothing
        self.dragging_edge_bands = None  # tuple (band_0_1, bands_to_0, bands_to_1) with rubberbands when moving edge
        self.selected_nodes = []    # list of Vertex instances of nodes that are selected
        self.selected_nodes_markers = []  # list of vertex markers

        self.dragging_rect_start_pos = None    # QPoint if user is dragging a selection rect
        self.selection_rect = None       # QRect in screen coordinates
        self.selection_rect_item = None  # QRubberBand to show selection_rect

        self.mouse_at_endpoint = None   # Vertex instance or None
        self.endpoint_marker_center = None  # QgsPoint or None (can't get center from QgsVertexMarker)
        self.endpoint_marker = QgsVertexMarker(canvas)
        self.endpoint_marker.setIconType(QgsVertexMarker.ICON_BOX)
        self.endpoint_marker.setColor(Qt.red)
        self.endpoint_marker.setPenWidth(1)
        self.endpoint_marker.setVisible(False)

        self.last_snap = None   # Match or None - to stick with previously highlighted feature

        self.override_cad_points = None  # list of QgsPoint or None

        self.new_vertex_from_double_click = None  # Match or None

        self.cache = {}

    def __del__(self):
        """ Cleanup canvas items we have created """
        self.canvas().scene().removeItem(self.snap_marker)
        self.canvas().scene().removeItem(self.edge_center_marker)
        self.canvas().scene().removeItem(self.drag_point_marker)
        self.canvas().scene().removeItem(self.feature_band)
        self.canvas().scene().removeItem(self.vertex_band)
        self.canvas().scene().removeItem(self.edge_band)
        self.canvas().scene().removeItem(self.endpoint_marker)
        self.snap_marker = None
        self.edge_center_marker = None
        self.drag_point_marker = None
        self.feature_band = None
        self.vertex_band = None
        self.edge_band = None
        self.endpoint_marker = None

    def deactivate(self):
        self.set_highlighted_nodes([])
        self.remove_temporary_rubber_bands()
        QgsMapToolAdvancedDigitizing.deactivate(self)


    def can_use_current_layer(self):
        layer = self.canvas().currentLayer()
        if not layer:
            print "no active layer!"
            return False

        if not isinstance(layer, QgsVectorLayer):
            print "not vector layer"
            return False

        if not layer.isEditable():
            print "layer not editable!"
            return False

        return True

    def topo_editing(self):
        return QgsProject.instance().readNumEntry("Digitizing", "/TopologicalEditing", 0)[0]

    def add_drag_band(self, v1, v2):
        drag_band = QgsRubberBand(self.canvas())

        color, width = _digitizing_color_width()

        drag_band.setColor(color)
        drag_band.setWidth(width)
        drag_band.addPoint(v1)
        drag_band.addPoint(v2)
        self.drag_bands.append(drag_band)

    def clear_drag_bands(self):
        for band in self.drag_bands:
            self.canvas().scene().removeItem(band)
        self.drag_bands = []

        # for the case when standalone point geometry is being dragged
        self.drag_point_marker.setVisible(False)

    def cadCanvasPressEvent(self, e):

        if not self.can_use_current_layer():
            return

        self.set_highlighted_nodes([])   # reset selection

        if e.button() == Qt.LeftButton:

            # Ctrl+Click to highlight nodes without entering editing mode
            if e.modifiers() & Qt.ControlModifier:
                m = self.snap_to_editable_layer(e)
                if m.hasVertex():
                    node = Vertex(m.layer(), m.featureId(), m.vertexIndex())
                    self.set_highlighted_nodes([node])
                return

            if not self.dragging and not self.dragging_edge:
                # the user may have started dragging a rect to select vertices
                self.dragging_rect_start_pos = e.pos()

    def cadCanvasReleaseEvent(self, e):

        if not self.can_use_current_layer():
            return

        if self.new_vertex_from_double_click:
            m = self.new_vertex_from_double_click
            self.new_vertex_from_double_click = None

            # dragging of edges and double clicking on edges to add vertex are slightly overlapping
            # so we need to cancel edge moving before we start dragging new vertex
            self.stop_dragging()
            self.start_dragging_add_vertex(m)

        elif self.selection_rect is not None:
            # only handling of selection rect being dragged
            pt0 = self.toMapCoordinates(self.dragging_rect_start_pos)
            pt1 = self.toMapCoordinates(e.pos())
            map_rect = QgsRectangle(pt0, pt1)
            nodes = []

            # for each editable layer, select nodes
            for layer in self.canvas().layers():
                if not isinstance(layer, QgsVectorLayer) or not layer.isEditable():
                    continue
                layer_rect = self.toLayerCoordinates(layer, map_rect)
                for f in layer.getFeatures(QgsFeatureRequest(layer_rect)):
                    g = f.geometry()
                    for i in xrange(g.geometry().nCoordinates()):
                        pt = g.vertexAt(i)
                        if layer_rect.contains(pt):
                            nodes.append( Vertex(layer, f.id(), i) )

            self.set_highlighted_nodes(nodes)

            self.stop_selection_rect()

        else:  # selection rect is not being dragged
            if e.button() == Qt.LeftButton:
                # accepting action
                if self.dragging:
                    self.move_vertex(e.mapPoint(), e.mapPointMatch())
                elif self.dragging_edge:
                    map_point = self.toMapCoordinates(e.pos())  # do not use e.mapPoint() as it may be snapped
                    self.move_edge(map_point)
                else:
                    self.start_dragging(e)
            elif e.button() == Qt.RightButton:
                # cancelling action
                self.stop_dragging()

        self.dragging_rect_start_pos = None

        # there may be a temporary list of points (up to two) that need to be injected
        # into CAD dock widget in order to make it behave as we need
        if self.override_cad_points:
            for pt in self.override_cad_points:
                me = QgsMapMouseEvent(self.canvas(),
                                      QMouseEvent(QEvent.MouseButtonRelease,
                                                  self.toCanvasCoordinates(pt),
                                                  Qt.LeftButton, Qt.LeftButton, Qt.NoModifier))
                self.cadDockWidget().canvasReleaseEvent(me, True)
            self.override_cad_points = None

    def cadCanvasMoveEvent(self, e):

        if not isinstance(e, QgsMapMouseEvent):
            # due to a bug in QGIS, a generated fake QgsMapMouseEvent
            # by advanced digitizing dock will appear here as an invalid
            # QMouseEvent. This QGIS pull request fixes that:
            # https://github.com/qgis/QGIS/pull/3302
            # For now this is just a workaround - ignoring that event
            return

        if self.dragging:
            self.mouse_move_dragging(e)
        elif self.dragging_edge:
            self.mouse_move_dragging_edge(e)
        elif self.dragging_rect_start_pos:
            # the user may be dragging a rect to select vertices
            if self.selection_rect is None and \
                    (e.pos() - self.dragging_rect_start_pos).manhattanLength() >= 10:
                self.start_selection_rect(self.dragging_rect_start_pos)
            if self.selection_rect is not None:
                self.update_selection_rect(e.pos())
        else:
            self.mouse_move_not_dragging(e)


    def mouse_move_dragging(self, e):
        if e.mapPointMatch().isValid():
            self.snap_marker.setCenter(e.mapPoint())
            self.snap_marker.setVisible(True)
        else:
            self.snap_marker.setVisible(False)

        self.edge_center_marker.setVisible(False)

        for band in self.drag_bands:
            band.movePoint(1, e.mapPoint())

        # in case of moving of standalone point geometry
        if self.drag_point_marker.isVisible():
            self.drag_point_marker.setCenter(e.mapPoint())

        # make sure the temporary feature rubber band is not visible
        self.remove_temporary_rubber_bands()

    def mouse_move_dragging_edge(self, e):

        self.snap_marker.setVisible(False)
        self.edge_center_marker.setVisible(False)

        band_0_1, bands_to_0, bands_to_1 = self.dragging_edge_bands
        drag_layer = self.dragging_edge.layer
        drag_fid = self.dragging_edge.fid
        drag_vertex_0 = self.dragging_edge.edge_vertex_0
        drag_start_point = self.dragging_edge.start_map_point
        map_point = self.toMapCoordinates(e.pos())  # do not use e.mapPoint() as it may be snapped

        diff_x, diff_y = map_point.x() - drag_start_point.x(), map_point.y() - drag_start_point.y()

        geom = QgsGeometry(self.cached_geometry(drag_layer, drag_fid))
        orig_map_point_0 = self.toMapCoordinates(drag_layer, geom.vertexAt(drag_vertex_0))
        new_map_point_0 = QgsPoint(orig_map_point_0.x() + diff_x, orig_map_point_0.y() + diff_y)
        orig_map_point_1 = self.toMapCoordinates(drag_layer, geom.vertexAt(drag_vertex_0+1))
        new_map_point_1 = QgsPoint(orig_map_point_1.x() + diff_x, orig_map_point_1.y() + diff_y)

        band_0_1.movePoint(0, new_map_point_0)
        band_0_1.movePoint(1, new_map_point_1)

        for band in bands_to_0:
            band.movePoint(1, new_map_point_0)

        for band in bands_to_1:
            band.movePoint(1, new_map_point_1)

        # make sure the temporary feature rubber band is not visible
        self.remove_temporary_rubber_bands()

    def canvasDoubleClickEvent(self, e):
        """ Start addition of a new vertex on double-click """
        m = self.snap_to_editable_layer(e)
        if not m.isValid():
            return

        self.new_vertex_from_double_click = m

    def remove_temporary_rubber_bands(self):
        self.feature_band.setVisible(False)
        self.feature_band_source = None
        self.vertex_band.setVisible(False)
        self.edge_band.setVisible(False)
        self.endpoint_marker_center = None
        self.endpoint_marker.setVisible(False)

    def snap_to_editable_layer(self, e):
        """ Temporarily override snapping config and snap to vertices and edges
         of any editable vector layer, to allow selection of node for editing
         (if snapped to edge, it would offer creation of a new vertex there).
        """

        map_point = self.toMapCoordinates(e.pos())
        tol = QgsTolerance.vertexSearchRadius(self.canvas().mapSettings())
        snap_type = QgsPointLocator.Type(QgsPointLocator.Vertex|QgsPointLocator.Edge)

        snap_layers = []
        for layer in self.canvas().layers():
            if not isinstance(layer, QgsVectorLayer) or not layer.isEditable():
                continue
            snap_layers.append(QgsSnappingUtils.LayerConfig(
                layer, snap_type, tol, QgsTolerance.ProjectUnits))

        snap_util = self.canvas().snappingUtils()
        old_layers = snap_util.layers()
        old_mode = snap_util.snapToMapMode()
        old_intersections = snap_util.snapOnIntersections()
        snap_util.setLayers(snap_layers)
        snap_util.setSnapToMapMode(QgsSnappingUtils.SnapAdvanced)
        snap_util.setSnapOnIntersections(False)  # only snap to layers
        m = snap_util.snapToMap(map_point)

        # try to stay snapped to previously used feature
        # so the highlight does not jump around at nodes where features are joined
        if self.last_snap is not None:
            filter_last = OneFeatureFilter(self.last_snap.layer(), self.last_snap.featureId())
            m_last = snap_util.snapToMap(map_point, filter_last)
            if m_last.isValid() and m_last.distance() <= m.distance():
                m = m_last

        snap_util.setLayers(old_layers)
        snap_util.setSnapToMapMode(old_mode)
        snap_util.setSnapOnIntersections(old_intersections)

        self.last_snap = m

        return m

    def is_near_endpoint_marker(self, map_point):
        """check whether we are still close to the self.endpoint_marker"""
        if self.endpoint_marker_center is None:
            return False

        dist_marker = math.sqrt(self.endpoint_marker_center.sqrDist(map_point))
        tol = QgsTolerance.vertexSearchRadius(self.canvas().mapSettings())

        geom = self.cached_geometry_for_vertex(self.mouse_at_endpoint)
        vertex_point_v2 = vertex_at_vertex_index(geom, self.mouse_at_endpoint.vertex_id)
        vertex_point = QgsPoint(vertex_point_v2.x(), vertex_point_v2.y())
        dist_vertex = math.sqrt(vertex_point.sqrDist(map_point))

        return dist_marker < tol and dist_marker < dist_vertex

    def is_match_at_endpoint(self, match):
        geom = self.cached_geometry(match.layer(), match.featureId())

        if geom.type() != QGis.Line:
            return False

        return is_endpoint_at_vertex_index(geom, match.vertexIndex())


    def position_for_endpoint_marker(self, match):
        geom = self.cached_geometry(match.layer(), match.featureId())

        pt0 = vertex_at_vertex_index(geom, adjacent_vertex_index_to_endpoint(geom, match.vertexIndex()))
        pt1 = vertex_at_vertex_index(geom, match.vertexIndex())
        dx = pt1.x() - pt0.x()
        dy = pt1.y() - pt0.y()
        dist = 15 * self.canvas().mapSettings().mapUnitsPerPixel()
        angle = math.atan2(dy, dx)  # to the top: angle=0, to the right: angle=90, to the left: angle=-90
        x = pt1.x() + math.cos(angle)*dist
        y = pt1.y() + math.sin(angle)*dist
        return QgsPoint(x, y)

    def mouse_move_not_dragging(self, e):

        if self.mouse_at_endpoint is not None:
            # check if we are still at the endpoint, i.e. whether to keep showing
            # the endpoint indicator - or go back to snapping to editable layers
            map_point = self.toMapCoordinates(e.pos())
            if self.is_near_endpoint_marker(map_point):
                self.endpoint_marker.setColor(Qt.red)
                self.endpoint_marker.update()
                # make it clear this would add endpoint, not move the vertex
                self.vertex_band.setVisible(False)
                return

        # do not use snap from mouse event, use our own with any editable layer
        m = self.snap_to_editable_layer(e)

        # possibility to move a node
        if m.type() == QgsPointLocator.Vertex:
            self.vertex_band.setToGeometry(QgsGeometry.fromPoint(m.point()), None)
            self.vertex_band.setVisible(True)
            is_circular_vertex = False
            if m.layer:
                geom = self.cached_geometry(m.layer(), m.featureId())
                is_circular_vertex = _is_circular_vertex(geom, m.vertexIndex())

            self.vertex_band.setIcon(QgsRubberBand.ICON_FULL_BOX if is_circular_vertex else QgsRubberBand.ICON_CIRCLE)
            # if we are at an endpoint, let's show also the endpoint indicator
            # so user can possibly add a new vertex at the end
            if self.is_match_at_endpoint(m):
                self.mouse_at_endpoint = Vertex(m.layer(), m.featureId(), m.vertexIndex())
                self.endpoint_marker_center = self.position_for_endpoint_marker(m)
                self.endpoint_marker.setCenter(self.endpoint_marker_center)
                self.endpoint_marker.setColor(Qt.gray)
                self.endpoint_marker.setVisible(True)
                self.endpoint_marker.update()
            else:
                self.mouse_at_endpoint = None
                self.endpoint_marker_center = None
                self.endpoint_marker.setVisible(False)
        else:
            self.vertex_band.setVisible(False)
            self.mouse_at_endpoint = None
            self.endpoint_marker_center = None
            self.endpoint_marker.setVisible(False)

        # possibility to create new node here - or to move the edge
        if m.type() == QgsPointLocator.Edge:
            map_point = self.toMapCoordinates(e.pos())
            edge_center, is_near_center = self._match_edge_center_test(m, map_point)
            self.edge_center_marker.setCenter(edge_center)
            self.edge_center_marker.setColor(Qt.red if is_near_center else Qt.gray)
            self.edge_center_marker.setVisible(True)
            self.edge_center_marker.update()

            p0, p1 = m.edgePoints()
            self.edge_band.setToGeometry(QgsGeometry.fromPolyline([p0, p1]), None)
            self.edge_band.setVisible(not is_near_center)
        else:
            self.edge_center_marker.setVisible(False)
            self.edge_band.setVisible(False)

        # highlight feature
        if m.isValid() and m.layer():
            if self.feature_band_source == (m.layer(), m.featureId()):
                return  # skip regeneration of rubber band if not needed
            geom = self.cached_geometry(m.layer(), m.featureId())
            if QgsWKBTypes.isCurvedType(geom.geometry().wkbType()):
                geom = QgsGeometry(geom.geometry().segmentize())
            self.feature_band.setToGeometry(geom, m.layer())
            self.feature_band.setVisible(True)
            self.feature_band_source = (m.layer(), m.featureId())
        else:
            self.feature_band.setVisible(False)
            self.feature_band_source = None

    def keyPressEvent(self, e):

        if not self.dragging and len(self.selected_nodes) == 0:
            return

        if e.key() == Qt.Key_Delete:
            e.ignore()  # Override default shortcut management
            self.delete_vertex()
        elif e.key() == Qt.Key_Escape:
            if self.dragging:
                self.stop_dragging()
        elif e.key() == Qt.Key_Comma:
            self.highlight_adjacent_vertex(-1)
        elif e.key() == Qt.Key_Period:
            self.highlight_adjacent_vertex(+1)

    # ------------

    def cached_geometry(self, layer, fid):
        if layer not in self.cache:
            self.cache[layer] = {}
            layer.geometryChanged.connect(self.on_cached_geometry_changed)
            layer.featureDeleted.connect(self.on_cached_geometry_deleted)

        if fid not in self.cache[layer]:
            f = layer.getFeatures(QgsFeatureRequest(fid)).next()
            self.cache[layer][fid] = QgsGeometry(f.geometry())

        return self.cache[layer][fid]

    def cached_geometry_for_vertex(self, vertex):
        return self.cached_geometry(vertex.layer, vertex.fid)

    def on_cached_geometry_changed(self, fid, geom):
        """ update geometry of our feature """
        layer = self.sender()
        assert layer in self.cache
        if fid in self.cache[layer]:
            self.cache[layer][fid] = QgsGeometry(geom)

    def on_cached_geometry_deleted(self, fid):
        layer = self.sender()
        assert layer in self.cache
        if fid in self.cache[layer]:
            del self.cache[layer][fid]


    def start_dragging(self, e):

        map_point = self.toMapCoordinates(e.pos())
        if self.is_near_endpoint_marker(map_point):
            self.start_dragging_add_vertex_at_endpoint(map_point)
            return

        m = self.snap_to_editable_layer(e)
        if not m.isValid():
            print "wrong snap!"
            return

        # activate advanced digitizing dock
        self.setMode(self.CaptureLine)

        # adding a new vertex instead of moving a vertex
        if m.hasEdge():
            # only start dragging if we are near edge center
            map_point = self.toMapCoordinates(e.pos())
            _, is_near_center = self._match_edge_center_test(m, map_point)
            if is_near_center:
                self.start_dragging_add_vertex(m)
            else:
                self.start_dragging_edge(m, map_point)
        else:   # vertex
            self.start_dragging_move_vertex(e.mapPoint(), m)


    def start_dragging_move_vertex(self, map_point, m):

        assert m.hasVertex()

        geom = self.cached_geometry(m.layer(), m.featureId())

        # start dragging of snapped point of current layer
        self.dragging = Vertex(m.layer(), m.featureId(), m.vertexIndex())
        self.dragging_topo = []

        v0idx, v1idx = geom.adjacentVertices(m.vertexIndex())
        if v0idx != -1:
            layer_point0 = geom.vertexAt(v0idx)
            map_point0 = self.toMapCoordinates(m.layer(), layer_point0)
            self.add_drag_band(map_point0, m.point())
        if v1idx != -1:
            layer_point1 = geom.vertexAt(v1idx)
            map_point1 = self.toMapCoordinates(m.layer(), layer_point1)
            self.add_drag_band(map_point1, m.point())

        if v0idx == -1 and v1idx == -1:
            # this is a standalone point - we need to use a marker for it
            # to give some feedback to the user
            self.drag_point_marker.setCenter(map_point)
            self.drag_point_marker.setVisible(True)

        self.override_cad_points = [m.point(), m.point()]

        if not self.topo_editing():
            return  # we are done now

        # support for topo editing - find extra features
        for layer in self.canvas().layers():
            if not isinstance(layer, QgsVectorLayer) or not layer.isEditable():
                continue

            for other_m in self.layer_vertices_snapped_to_point(layer, map_point):
                if other_m == m: continue

                other_g = self.cached_geometry(other_m.layer(), other_m.featureId())

                # start dragging of snapped point of current layer
                self.dragging_topo.append( Vertex(other_m.layer(), other_m.featureId(), other_m.vertexIndex()) )

                v0idx, v1idx = other_g.adjacentVertices(other_m.vertexIndex())
                if v0idx != -1:
                    other_point0 = other_g.vertexAt(v0idx)
                    other_map_point0 = self.toMapCoordinates(other_m.layer(), other_point0)
                    self.add_drag_band(other_map_point0, other_m.point())
                if v1idx != -1:
                    other_point1 = other_g.vertexAt(v1idx)
                    other_map_point1 = self.toMapCoordinates(other_m.layer(), other_point1)
                    self.add_drag_band(other_map_point1, other_m.point())

    def layer_vertices_snapped_to_point(self, layer, map_point):
        """ Get list of matches of all vertices of a layer exactly snapped to a map point """

        class MyFilter(QgsPointLocator.MatchFilter):
            """ a filter just to gather all matches at the same place """
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
                match_geom = self.nodetool.cached_geometry(match.layer(), match.featureId())
                vid = QgsVertexId()
                pt = QgsPointV2()
                while match_geom.geometry().nextVertex(vid, pt):
                    vindex = match_geom.vertexNrFromVertexId(vid)
                    if pt.x() == match.point().x() and pt.y() == match.point().y() and vindex != match.vertexIndex():
                        extra_match = QgsPointLocator.Match(match.type(), match.layer(), match.featureId(),
                                                            0, match.point(), vindex)
                        self.matches.append(extra_match)
                return True

        myfilter = MyFilter(self)
        loc = self.canvas().snappingUtils().locatorForLayer(layer)
        loc.nearestVertex(map_point, 0, myfilter)
        return myfilter.matches

    def start_dragging_add_vertex(self, m):

        assert m.hasEdge()

        # activate advanced digitizing dock
        self.setMode(self.CaptureLine)

        self.dragging = Vertex(m.layer(), m.featureId(), (m.vertexIndex()+1, False))
        self.dragging_topo = []

        geom = self.cached_geometry(m.layer(), m.featureId())

        # TODO: handles rings correctly?
        v0 = geom.vertexAt(m.vertexIndex())
        v1 = geom.vertexAt(m.vertexIndex()+1)

        map_v0 = self.toMapCoordinates(m.layer(), v0)
        map_v1 = self.toMapCoordinates(m.layer(), v1)

        if v0.x() != 0 or v0.y() != 0:
            self.add_drag_band(map_v0, m.point())
        if v1.x() != 0 or v1.y() != 0:
            self.add_drag_band(map_v1, m.point())

        self.override_cad_points = [m.point(), m.point()]

    def start_dragging_add_vertex_at_endpoint(self, map_point):

        assert self.mouse_at_endpoint is not None

        # activate advanced digitizing dock
        self.setMode(self.CaptureLine)

        self.dragging = Vertex(self.mouse_at_endpoint.layer, self.mouse_at_endpoint.fid, (self.mouse_at_endpoint.vertex_id, True))
        self.dragging_topo = []

        geom = self.cached_geometry(self.mouse_at_endpoint.layer, self.mouse_at_endpoint.fid)
        v0 = geom.vertexAt(self.mouse_at_endpoint.vertex_id)
        map_v0 = self.toMapCoordinates(self.mouse_at_endpoint.layer, v0)

        self.add_drag_band(map_v0, map_point)

        # setup CAD dock previous points to endpoint and the previous point
        pt0 = vertex_at_vertex_index(geom, adjacent_vertex_index_to_endpoint(geom, self.mouse_at_endpoint.vertex_id))
        pt1 = vertex_at_vertex_index(geom, self.mouse_at_endpoint.vertex_id)
        self.override_cad_points = [pt0, pt1]

    def start_dragging_edge(self, m, map_point):

        assert m.hasEdge()

        # activate advanced digitizing
        self.setMode(self.CaptureLine)

        self.dragging_edge = Edge(m.layer(), m.featureId(), m.vertexIndex(), map_point)
        self.dragging_topo = []

        edge_p0, edge_p1 = m.edgePoints()
        geom = self.cached_geometry(m.layer(), m.featureId())

        bands_to_p0, bands_to_p1 = [], []

        # add drag bands
        self.add_drag_band(edge_p0, edge_p1)
        v0idx, _ = geom.adjacentVertices(m.vertexIndex())
        _, v1idx = geom.adjacentVertices(m.vertexIndex()+1)
        if v0idx != -1:
            layer_point0 = geom.vertexAt(v0idx)
            map_point0 = self.toMapCoordinates(m.layer(), layer_point0)
            self.add_drag_band(map_point0, edge_p0)
            bands_to_p0.append(self.drag_bands[-1])
        if v1idx != -1:
            layer_point1 = geom.vertexAt(v1idx)
            map_point1 = self.toMapCoordinates(m.layer(), layer_point1)
            self.add_drag_band(map_point1, edge_p1)
            bands_to_p1.append(self.drag_bands[-1])

        self.dragging_edge_bands = (self.drag_bands[0], bands_to_p0, bands_to_p1)

        self.override_cad_points = [m.point(), m.point()]

        # TODO: add topo points


    def stop_dragging(self):

        # deactivate advanced digitizing
        self.setMode(self.CaptureNone)

        # stop adv digitizing
        me = QgsMapMouseEvent(self.canvas(),
                              QMouseEvent(QEvent.MouseButtonRelease,
                                          QPoint(),
                                          Qt.RightButton, Qt.RightButton, Qt.NoModifier))
        self.cadDockWidget().canvasReleaseEvent(me, False)

        self.dragging = False
        self.dragging_edge = None
        self.dragging_edge_bands = None
        self.clear_drag_bands()

    def match_to_layer_point(self, dest_layer, map_point, match):

        layer_point = None
        # try to use point coordinates in the original CRS if it is the same
        if match and match.hasVertex() and match.layer() and match.layer().crs() == dest_layer.crs():
            try:
                f = match.layer().getFeatures(QgsFeatureRequest(match.featureId())).next()
                layer_point = f.geometry().vertexAt(match.vertexIndex())
            except StopIteration:
                pass

        # fall back to reprojection of the map point to layer point if they are not the same CRS
        if layer_point is None:
            layer_point = self.toLayerCoordinates(dest_layer, map_point)
        return layer_point

    def move_edge(self, map_point):
        """ Finish moving of an edge """

        drag_layer = self.dragging_edge.layer
        drag_fid = self.dragging_edge.fid
        drag_vertex_0 = self.dragging_edge.edge_vertex_0
        drag_start_point = self.dragging_edge.start_map_point

        self.stop_dragging()

        diff_x, diff_y = map_point.x() - drag_start_point.x(), map_point.y() - drag_start_point.y()

        geom = QgsGeometry(self.cached_geometry(drag_layer, drag_fid))

        # TODO: move topo points

        drag_layer.beginEditCommand(self.tr("Moved edge"))

        # move first endpoint
        orig_map_point_0 = self.toMapCoordinates(drag_layer, geom.vertexAt(drag_vertex_0))
        new_map_point_0 = QgsPoint(orig_map_point_0.x() + diff_x, orig_map_point_0.y() + diff_y)
        self.dragging = Vertex(drag_layer, drag_fid, drag_vertex_0)
        self.move_vertex(new_map_point_0, None)

        # move second endpoint
        orig_map_point_1 = self.toMapCoordinates(drag_layer, geom.vertexAt(drag_vertex_0+1))
        new_map_point_1 = QgsPoint(orig_map_point_1.x() + diff_x, orig_map_point_1.y() + diff_y)
        self.dragging = Vertex(drag_layer, drag_fid, drag_vertex_0+1)
        self.move_vertex(new_map_point_1, None)

        drag_layer.endEditCommand()

    def move_vertex(self, map_point, map_point_match):

        # deactivate advanced digitizing
        self.setMode(self.CaptureNone)

        drag_layer = self.dragging.layer
        drag_fid = self.dragging.fid
        drag_vertex_id = self.dragging.vertex_id
        geom = QgsGeometry(self.cached_geometry_for_vertex(self.dragging))
        self.stop_dragging()

        adding_vertex = False
        adding_at_endpoint = False
        if isinstance(drag_vertex_id, tuple):
            adding_vertex = True
            drag_vertex_id, adding_at_endpoint = drag_vertex_id

        layer_point = self.match_to_layer_point(drag_layer, map_point, map_point_match)

        # add/move vertex
        if adding_vertex:
            # ordinary geom.insertVertex does not support appending so we use geometry V2
            drag_part, drag_ring, drag_vertex = vertex_index_to_tuple(geom, drag_vertex_id)
            if adding_at_endpoint and drag_vertex != 0:  # appending?
                drag_vertex += 1
            vid = QgsVertexId(drag_part, drag_ring, drag_vertex, QgsVertexId.SegmentVertex)
            geom_tmp = geom.geometry().clone()
            if not geom_tmp.insertVertex(vid, QgsPointV2(layer_point)):
                print "append vertex failed!"
                return
            geom.setGeometry(geom_tmp)
        else:
            if not geom.moveVertex(layer_point.x(), layer_point.y(), drag_vertex_id):
                print "move vertex failed!"
                return

        edits = { drag_layer: { drag_fid: geom } }  # dict { layer : { fid : geom } }

        # add moved vertices from other layers
        for topo in self.dragging_topo:
            if topo.layer not in edits:
                edits[topo.layer] = {}
            if topo.fid in edits[topo.layer]:
                topo_geom = QgsGeometry(edits[topo.layer][topo.fid])
            else:
                topo_geom = QgsGeometry(self.cached_geometry_for_vertex(topo))

            if topo.layer.crs() == drag_layer.crs():
                point = layer_point
            else:
                point = self.toLayerCoordinates(topo.layer, map_point)

            if not topo_geom.moveVertex(point.x(), point.y(), topo.vertex_id):
                print "[topo] move vertex failed!"
                continue
            edits[topo.layer][topo.fid] = topo_geom

        # TODO: add topological points: when moving vertex - if snapped to something

        # do the changes to layers
        for layer, features_dict in edits.iteritems():
            layer.beginEditCommand( self.tr( "Moved vertex" ) )
            for fid, geometry in features_dict.iteritems():
                layer.changeGeometry(fid, geometry)
            layer.endEditCommand()
            layer.triggerRepaint()


    def delete_vertex(self):

        if len(self.selected_nodes) != 0:
            to_delete = self.selected_nodes
        else:
            adding_vertex = isinstance(self.dragging.vertex_id, tuple)
            to_delete = [self.dragging] + self.dragging_topo
            self.stop_dragging()

            if adding_vertex:
                return   # just cancel the vertex

        self.set_highlighted_nodes([])   # reset selection

        # switch from a plain list to dictionary { layer: { fid: [vertexNr1, vertexNr2, ...] } }
        to_delete_grouped = {}
        for vertex in to_delete:
            if vertex.layer not in to_delete_grouped:
                to_delete_grouped[vertex.layer] = {}
            if vertex.fid not in to_delete_grouped[vertex.layer]:
                to_delete_grouped[vertex.layer][vertex.fid] = []
            to_delete_grouped[vertex.layer][vertex.fid].append(vertex.vertex_id)

        # main for cycle to delete all selected vertices
        for layer, features_dict in to_delete_grouped.iteritems():

            layer.beginEditCommand( self.tr( "Deleted vertex" ) )
            success = True

            for fid, vertex_ids in features_dict.iteritems():
                res = QgsVectorLayer.Success
                for vertex_id in sorted(vertex_ids, reverse=True):
                    if res != QgsVectorLayer.EmptyGeometry:
                        res = layer.deleteVertexV2(fid, vertex_id)
                    if res != QgsVectorLayer.EmptyGeometry and res != QgsVectorLayer.Success:
                        print "failed to delete vertex!", layer.name(), fid, vertex_id, vertex_ids
                        success = False

            if success:
                layer.endEditCommand()
                layer.triggerRepaint()
            else:
                layer.destroyEditCommand()

        # pre-select next node for deletion if we are deleting just one node
        if len(to_delete) == 1:
            vertex = to_delete[0]
            geom = QgsGeometry(self.cached_geometry_for_vertex(vertex))

            # if next vertex is not available, use the previous one
            if geom.vertexAt(vertex.vertex_id) == QgsPoint():
                vertex.vertex_id -= 1

            if geom.vertexAt(vertex.vertex_id) != QgsPoint():
                self.set_highlighted_nodes([Vertex(vertex.layer, vertex.fid, vertex.vertex_id)])



    def set_highlighted_nodes(self, list_nodes):
        for marker in self.selected_nodes_markers:
            self.canvas().scene().removeItem(marker)
        self.selected_nodes_markers = []

        for node in list_nodes:
            geom = self.cached_geometry_for_vertex(node)
            marker = QgsVertexMarker(self.canvas())
            marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
            #marker.setIconSize(5)
            #marker.setPenWidth(2)
            marker.setColor(Qt.blue)
            marker.setCenter(geom.vertexAt(node.vertex_id))
            self.selected_nodes_markers.append(marker)
        self.selected_nodes = list_nodes

    def highlight_adjacent_vertex(self, offset):
        """Allow moving back and forth selected vertex within a feature"""
        if len(self.selected_nodes) == 0:
            return

        node = self.selected_nodes[0]  # simply use the first one

        geom = self.cached_geometry_for_vertex(node)
        pt = geom.vertexAt(node.vertex_id+offset)
        if pt != QgsPoint():
            node = Vertex(node.layer, node.fid, node.vertex_id+offset)
        self.set_highlighted_nodes([node])


    def start_selection_rect(self, point0):
        """Initialize rectangle that is being dragged to select nodes.
        Argument point0 is in screen coordinates."""
        assert self.selection_rect is None
        self.selection_rect = QRect()
        self.selection_rect.setTopLeft(point0)
        self.selection_rect_item = QRubberBand(QRubberBand.Rectangle, self.canvas())

    def update_selection_rect(self, point1):
        """Update bottom-right corner of the existing selection rectangle.
        Argument point1 is in screen coordinates."""
        assert self.selection_rect is not None
        self.selection_rect.setBottomRight(point1)
        self.selection_rect_item.setGeometry(self.selection_rect.normalized())
        self.selection_rect_item.show()

    def stop_selection_rect(self):
        assert self.selection_rect is not None
        self.selection_rect_item.deleteLater()
        self.selection_rect_item = None
        self.selection_rect = None


    def _match_edge_center_test(self, m, map_point):
        """ Using a given edge match and original map point, find out
         center of the edge and whether we are close enough to the center """
        p0, p1 = m.edgePoints()

        visible_extent = self.canvas().mapSettings().visibleExtent()
        if not visible_extent.contains(p0) or not visible_extent.contains(p1):
            # clip line segment to the extent so the mid-point marker is always visible
            extent_geom = QgsGeometry.fromRect(visible_extent)
            line_geom = QgsGeometry.fromPolyline([p0, p1])
            line_geom = extent_geom.intersection(line_geom)
            p0, p1 = line_geom.asPolyline()

        edge_center = QgsPoint((p0.x() + p1.x())/2, (p0.y() + p1.y())/2)

        dist_from_edge_center = math.sqrt(map_point.sqrDist(edge_center))
        tol = QgsTolerance.vertexSearchRadius(self.canvas().mapSettings())
        is_near_center = dist_from_edge_center < tol

        return edge_center, is_near_center
