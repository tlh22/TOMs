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

import logging

from qgis.core import (
    Qgis,
    QgsFeature,
    QgsField,
    QgsGeometry,
    QgsPoint,
    QgsPointXY,
    QgsVectorLayer,
)
from qgis.PyQt.QtCore import QVariant

from TOMsPlugin import generateGeometryUtils
from TOMsPlugin.core.tomsMessageLog import TOMsMessageLog


def testGeneratedSignLine():
    """Test sign line. Retrieve and rework from TH job"""

    testClass = generateGeometryUtils.GenerateGeometryUtils

    # line layer
    testLayerA = QgsVectorLayer(
        ("LineString?crs=epsg:27700&index=yes"), "test1", "memory"
    )
    testProviderA = testLayerA.dataProvider()

    testLineString1 = QgsGeometry.fromPolylineXY([QgsPointXY(0, 0), QgsPointXY(1, 0)])
    testLineString2 = QgsGeometry.fromPolylineXY([QgsPointXY(1, 0), QgsPointXY(2, 0)])

    testProviderA.addAttributes([QgsField("GeometryID", QVariant.String)])
    testFieldsA = testProviderA.fields()
    testFeature1A = QgsFeature(testFieldsA)
    testFeature1A.setGeometry(testLineString1)
    testFeature1A.setAttributes(["Smith"])
    testFeature2A = QgsFeature(testFieldsA)
    testFeature2A.setGeometry(testLineString2)
    testFeature2A.setAttributes(["Jones"])
    testProviderA.addFeatures([testFeature1A, testFeature2A])
    testLayerA.reload()

    # point layer
    testLayerB = QgsVectorLayer(("Point?crs=epsg:27700&index=yes"), "test2", "memory")
    testProviderB = testLayerB.dataProvider()

    testPoint1 = QgsPoint(0, 1)

    testProviderB.addAttributes(
        [
            QgsField("GeometryID", QVariant.String),
            QgsField("SignOrientationTypeID", QVariant.Int),
            QgsField("SignType_1", QVariant.Int),
            QgsField("SignType_2", QVariant.Int),
            QgsField("SignType_3", QVariant.Int),
            QgsField("SignType_4", QVariant.Int),
            QgsField("original_geom_wkt", QVariant.String),
        ]
    )
    testFieldsB = testProviderB.fields()

    testFeature2A = QgsFeature(testFieldsB)
    testFeature2A.setGeometry(testPoint1.clone())
    testFeature2A.setAttributes(["Alpha", 1, 1, None, None, None, testPoint1.asWkt()])
    testFeature2B = QgsFeature(testFieldsB)
    testFeature2B.setGeometry(testPoint1.clone())
    testFeature2B.setAttributes(["Beta", 2, 1, 1, None, None, testPoint1.asWkt()])
    testFeature2C = QgsFeature(testFieldsB)
    testFeature2C.setGeometry(testPoint1.clone())
    testFeature2C.setAttributes(["Gamma", 3, 1, 1, 1, None, testPoint1.asWkt()])
    testProviderB.addFeatures([testFeature2A, testFeature2B, testFeature2C])
    testLayerB.reload()
    testLayerC = QgsVectorLayer(("Point?crs=epsg:27700&index=yes"), "test2", "memory")
    testProviderC = testLayerC.dataProvider()

    testProviderC.addAttributes([QgsField("GeometryID", QVariant.String)])
    testFieldsC = testProviderC.fields()
    testFeature3A = QgsFeature(testFieldsC)
    testFeature3A.setGeometry(testPoint1.clone())
    testFeature3A.setAttributes(["Zulu"])
    testProviderC.addFeatures([testFeature3A])
    testLayerC.reload()

    distanceForIcons = 3

    (
        orientationToFeature,
        orientationInFeatureDirection,
        orientationAwayFromFeature,
        orientationOppositeFeatureDirection,
        _,
        _,
    ) = testClass.getLineOrientationAtPoint(QgsPointXY(testPoint1), testFeature1A)

    TOMsMessageLog.logMessage(
        "orientationToFeature: {}".format(orientationToFeature), level=logging.DEBUG
    )
    assert orientationToFeature == 180.0
    assert orientationInFeatureDirection == 90.0
    assert orientationAwayFromFeature == 0.0
    assert orientationOppositeFeatureDirection == 270.0

    lineGeom = testClass.createLinewithPointAzimuthDistance(
        QgsPointXY(testPoint1), orientationToFeature, 5
    )
    assert lineGeom.length() == 5.0

    # check creation of line - for feature with 1 sign
    platesInSign = testClass.getPlatesInSign(testFeature2A)
    nrPlatesInSign = len(platesInSign)
    assert nrPlatesInSign == 1

    orientationList = testClass.getSignOrientation(testFeature2A, testLayerA)
    TOMsMessageLog.logMessage(
        "orientationList: {}".format(orientationList), level=logging.DEBUG
    )
    assert orientationList[1] == 90.0  # feature direction
    assert orientationList[2] == 270.0  # opposite feature direction
    assert orientationList[3] == 180.0  # facing feature
    assert orientationList[4] == 0.0  # facing away from feature

    lineGeom = testClass.getSignLine(testFeature2A, testLayerA, distanceForIcons)
    TOMsMessageLog.logMessage(
        "lineGeom: {}".format(lineGeom.asWkt()), level=logging.DEBUG
    )
    assert lineGeom.length() == 6

    linePts = testClass.addPointsToSignLine(lineGeom, nrPlatesInSign, distanceForIcons)
    # TOMsMessageLog.logMessage ('newLineGeom: {}'.format(newLineGeom.asWkt()))
    # linePts = newLineGeom.asPolyline()
    assert len(linePts) == 1

    # check creation of line - for feature with 3 signs
    platesInSign = testClass.getPlatesInSign(testFeature2C)
    nrPlatesInSign = len(platesInSign)
    assert nrPlatesInSign == 3

    orientationList = testClass.getSignOrientation(testFeature2C, testLayerA)
    assert len(orientationList) == 7
    assert orientationList[1] == 90.0

    lineGeom = testClass.getSignLine(testFeature2C, testLayerA, distanceForIcons)
    TOMsMessageLog.logMessage(
        "lineGeom: {}".format(lineGeom.asWkt()), level=logging.DEBUG
    )
    assert lineGeom.length() == 12

    linePts = testClass.addPointsToSignLine(lineGeom, nrPlatesInSign, distanceForIcons)
    # TOMsMessageLog.logMessage ('newLineGeom: {}'.format(newLineGeom.asWkt()))
    # linePts = newLineGeom.asPolyline()
    assert len(linePts) == 3

    # check creation of line - for feature without signs field
    platesInSign = testClass.getPlatesInSign(testFeature3A)
    nrPlatesInSign = len(platesInSign)
    assert nrPlatesInSign == 0

    orientationList = testClass.getSignOrientation(testFeature3A, testLayerA)
    assert len(orientationList) == 7
    assert orientationList[0] is None  # TODO: And this is normal?

    lineGeom = testClass.getSignLine(testFeature3A, testLayerA, distanceForIcons)
    assert lineGeom is None  # TODO: And this is normal?

    newLineGeom = testClass.addPointsToSignLine(
        lineGeom, nrPlatesInSign, distanceForIcons
    )
    assert newLineGeom is None  # TODO: And this is normal?
