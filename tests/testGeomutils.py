import unittest

from qgis.core import QgsGeometry, QgsPoint

from TOMsPlugin.cadNodeTool.geomutils import (
    adjacentVertexIndexToEndpoint,
    isEndpointAtVertexIndex,
    vertexAtVertexIndex,
    vertexIndexToTuple,
)


def testVertexPositions():
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
