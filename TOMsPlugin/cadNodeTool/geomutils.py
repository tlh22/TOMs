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

from qgis.core import (
    QgsCurve,
    QgsCurvePolygon,
    QgsGeometry,
    QgsGeometryCollection,
    QgsMultiCurve,
    QgsPoint,
)


def isEndpointAtVertexIndex(geom, vertexIndex):
    """Find out whether vertex at the given index is an endpoint (assuming linear geometry)"""

    qgeom = geom.get()
    if isinstance(qgeom, QgsCurve):
        return vertexIndex == 0 or vertexIndex == qgeom.numPoints() - 1
    if isinstance(qgeom, QgsMultiCurve):
        for i in range(qgeom.numGeometries()):
            part = qgeom.geometryN(i)
            if vertexIndex < part.numPoints():
                return vertexIndex == 0 or vertexIndex == part.numPoints() - 1
            vertexIndex -= part.numPoints()
    else:
        raise ValueError(f"Unsupported geometry {qgeom.geometryType()}")


def vertexAtVertexIndex(geom, vertexIndex):
    """Get coordinates of the vertex at particular index"""
    qgeom = geom.get()
    point = QgsPoint()
    if isinstance(qgeom, QgsCurve):
        qgeom.pointAt(vertexIndex, point)
    elif isinstance(qgeom, QgsMultiCurve):
        for i in range(qgeom.numGeometries()):
            part = qgeom.geometryN(i)
            if vertexIndex < part.numPoints():
                part.pointAt(vertexIndex, point)
                break
            vertexIndex -= part.numPoints()
    else:
        assert False
    return QgsPoint(point.x(), point.y())


def adjacentVertexIndexToEndpoint(geom, vertexIndex):
    """Return index of vertex adjacent to the given endpoint. Assuming linear geometries."""
    qgeom = geom.get()
    if isinstance(qgeom, QgsCurve):
        return 1 if vertexIndex == 0 else qgeom.numPoints() - 2
    if isinstance(qgeom, QgsMultiCurve):
        offset = 0
        for i in range(qgeom.numGeometries()):
            part = qgeom.geometryN(i)
            if vertexIndex < part.numPoints():
                return offset + 1 if vertexIndex == 0 else offset + part.numPoints() - 2
            vertexIndex -= part.numPoints()
            offset += part.numPoints()
    else:
        assert False


def vertexIndexToTuple(geom, vertexIndex):
    """Return a tuple (part, vertex) from vertex index"""

    if isinstance(geom, QgsGeometry):
        geom = geom.get()

    if isinstance(geom, QgsGeometryCollection):
        partIndex = 0
        offset = 0
        for i in range(geom.numGeometries()):
            part = geom.geometryN(i)
            if vertexIndex < part.numPoints():
                (_, ringIndex, vertex) = vertexIndexToTuple(part, vertexIndex)
                return (partIndex, ringIndex, vertex)
            vertexIndex -= part.numPoints()
            offset += part.numPoints()
            partIndex += 1

    elif isinstance(geom, QgsCurve):
        return (0, 0, vertexIndex)

    elif isinstance(geom, QgsCurvePolygon):
        ring = geom.exteriorRing()
        if vertexIndex < ring.numPoints():
            return (0, 0, vertexIndex)
        vertexIndex -= ring.numPoints()
        ringIndex = 1
        for i in range(geom.numInteriorRings()):
            ring = geom.interiorRing(i)
            if vertexIndex < ring.numPoints():
                return (0, ringIndex, vertexIndex)
            vertexIndex -= ring.numPoints()
            ringIndex += 1


if True:  # testing
    line = QgsGeometry.fromWkt("LINESTRING(1 1, 2 1, 3 2)")
    assert isEndpointAtVertexIndex(line, 0)
    assert not isEndpointAtVertexIndex(line, 1)
    assert isEndpointAtVertexIndex(line, 2)
    assert vertexAtVertexIndex(line, 0) == QgsPoint(1, 1)
    assert vertexAtVertexIndex(line, 1) == QgsPoint(2, 1)
    assert vertexAtVertexIndex(line, 2) == QgsPoint(3, 2)
    assert adjacentVertexIndexToEndpoint(line, 0) == 1
    assert adjacentVertexIndexToEndpoint(line, 2) == 1
    assert vertexIndexToTuple(line, 0) == (0, 0, 0)
    assert vertexIndexToTuple(line, 2) == (0, 0, 2)

    mline = QgsGeometry.fromWkt("MULTILINESTRING((1 1, 2 1, 3 2), (3 3, 4 3, 4 2))")
    assert isEndpointAtVertexIndex(mline, 0)
    assert not isEndpointAtVertexIndex(mline, 1)
    assert isEndpointAtVertexIndex(mline, 2)
    assert isEndpointAtVertexIndex(mline, 3)
    assert not isEndpointAtVertexIndex(mline, 4)
    assert isEndpointAtVertexIndex(mline, 5)
    assert vertexAtVertexIndex(mline, 0) == QgsPoint(1, 1)
    assert vertexAtVertexIndex(mline, 1) == QgsPoint(2, 1)
    assert vertexAtVertexIndex(mline, 2) == QgsPoint(3, 2)
    assert vertexAtVertexIndex(mline, 3) == QgsPoint(3, 3)
    assert vertexAtVertexIndex(mline, 4) == QgsPoint(4, 3)
    assert vertexAtVertexIndex(mline, 5) == QgsPoint(4, 2)
    assert adjacentVertexIndexToEndpoint(mline, 0) == 1
    assert adjacentVertexIndexToEndpoint(mline, 2) == 1
    assert adjacentVertexIndexToEndpoint(mline, 3) == 4
    assert adjacentVertexIndexToEndpoint(mline, 5) == 4
    assert vertexIndexToTuple(mline, 0) == (0, 0, 0)
    assert vertexIndexToTuple(mline, 2) == (0, 0, 2)
    assert vertexIndexToTuple(mline, 3) == (1, 0, 0)
    assert vertexIndexToTuple(mline, 5) == (1, 0, 2)
