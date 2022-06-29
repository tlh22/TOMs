from qgis.core import (
    QgsCurve,
    QgsCurvePolygon,
    QgsGeometry,
    QgsGeometryCollection,
    QgsMultiCurve,
    QgsPoint,
)


def is_endpoint_at_vertex_index(geom, vertex_index):
    """Find out whether vertex at the given index is an endpoint (assuming linear geometry)"""

    g = geom.get()
    if isinstance(g, QgsCurve):
        return vertex_index == 0 or vertex_index == g.numPoints() - 1
    if isinstance(g, QgsMultiCurve):
        for i in range(g.numGeometries()):
            part = g.geometryN(i)
            if vertex_index < part.numPoints():
                return vertex_index == 0 or vertex_index == part.numPoints() - 1
            vertex_index -= part.numPoints()
    else:
        raise ValueError(f"Unsupported geometry {g.__class__}")


def vertex_at_vertex_index(geom, vertex_index):
    """Get coordinates of the vertex at particular index"""
    g = geom.get()
    p = QgsPoint()
    if isinstance(g, QgsCurve):
        g.pointAt(vertex_index, p)
    elif isinstance(g, QgsMultiCurve):
        for i in range(g.numGeometries()):
            part = g.geometryN(i)
            if vertex_index < part.numPoints():
                part.pointAt(vertex_index, p)
                break
            vertex_index -= part.numPoints()
    else:
        assert False
    return QgsPoint(p.x(), p.y())


def adjacent_vertex_index_to_endpoint(geom, vertex_index):
    """Return index of vertex adjacent to the given endpoint. Assuming linear geometries."""
    g = geom.get()
    if isinstance(g, QgsCurve):
        return 1 if vertex_index == 0 else g.numPoints() - 2
    if isinstance(g, QgsMultiCurve):
        offset = 0
        for i in range(g.numGeometries()):
            part = g.geometryN(i)
            if vertex_index < part.numPoints():
                return (
                    offset + 1 if vertex_index == 0 else offset + part.numPoints() - 2
                )
            vertex_index -= part.numPoints()
            offset += part.numPoints()
    else:
        assert False


def vertex_index_to_tuple(g, vertex_index):
    """Return a tuple (part, vertex) from vertex index"""

    if isinstance(g, QgsGeometry):
        g = g.get()

    if isinstance(g, QgsGeometryCollection):
        part_index = 0
        offset = 0
        for i in range(g.numGeometries()):
            part = g.geometryN(i)
            if vertex_index < part.numPoints():
                (_, ring_index, vertex) = vertex_index_to_tuple(part, vertex_index)
                return (part_index, ring_index, vertex)
            vertex_index -= part.numPoints()
            offset += part.numPoints()
            part_index += 1

    elif isinstance(g, QgsCurve):
        return (0, 0, vertex_index)

    elif isinstance(g, QgsCurvePolygon):
        ring = g.exteriorRing()
        if vertex_index < ring.numPoints():
            return (0, 0, vertex_index)
        vertex_index -= ring.numPoints()
        ring_index = 1
        for i in range(g.numInteriorRings()):
            ring = g.interiorRing(i)
            if vertex_index < ring.numPoints():
                return (0, ring_index, vertex_index)
            vertex_index -= ring.numPoints()
            ring_index += 1


if True:  # testing
    line = QgsGeometry.fromWkt("LINESTRING(1 1, 2 1, 3 2)")
    assert is_endpoint_at_vertex_index(line, 0)
    assert not is_endpoint_at_vertex_index(line, 1)
    assert is_endpoint_at_vertex_index(line, 2)
    assert vertex_at_vertex_index(line, 0) == QgsPoint(1, 1)
    assert vertex_at_vertex_index(line, 1) == QgsPoint(2, 1)
    assert vertex_at_vertex_index(line, 2) == QgsPoint(3, 2)
    assert adjacent_vertex_index_to_endpoint(line, 0) == 1
    assert adjacent_vertex_index_to_endpoint(line, 2) == 1
    assert vertex_index_to_tuple(line, 0) == (0, 0, 0)
    assert vertex_index_to_tuple(line, 2) == (0, 0, 2)

    mline = QgsGeometry.fromWkt("MULTILINESTRING((1 1, 2 1, 3 2), (3 3, 4 3, 4 2))")
    assert is_endpoint_at_vertex_index(mline, 0)
    assert not is_endpoint_at_vertex_index(mline, 1)
    assert is_endpoint_at_vertex_index(mline, 2)
    assert is_endpoint_at_vertex_index(mline, 3)
    assert not is_endpoint_at_vertex_index(mline, 4)
    assert is_endpoint_at_vertex_index(mline, 5)
    assert vertex_at_vertex_index(mline, 0) == QgsPoint(1, 1)
    assert vertex_at_vertex_index(mline, 1) == QgsPoint(2, 1)
    assert vertex_at_vertex_index(mline, 2) == QgsPoint(3, 2)
    assert vertex_at_vertex_index(mline, 3) == QgsPoint(3, 3)
    assert vertex_at_vertex_index(mline, 4) == QgsPoint(4, 3)
    assert vertex_at_vertex_index(mline, 5) == QgsPoint(4, 2)
    assert adjacent_vertex_index_to_endpoint(mline, 0) == 1
    assert adjacent_vertex_index_to_endpoint(mline, 2) == 1
    assert adjacent_vertex_index_to_endpoint(mline, 3) == 4
    assert adjacent_vertex_index_to_endpoint(mline, 5) == 4
    assert vertex_index_to_tuple(mline, 0) == (0, 0, 0)
    assert vertex_index_to_tuple(mline, 2) == (0, 0, 2)
    assert vertex_index_to_tuple(mline, 3) == (1, 0, 0)
    assert vertex_index_to_tuple(mline, 5) == (1, 0, 2)
