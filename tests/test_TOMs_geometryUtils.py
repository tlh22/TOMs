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
    QgsFeature,
    QgsField,
    QgsGeometry,
    QgsPoint,
    QgsPointXY,
    QgsProject,
    QgsVectorLayer,
)
from qgis.PyQt.QtCore import QVariant

from TOMsPlugin import generateGeometryUtils

from .utilities import get_qgis_app

QGIS_APP = get_qgis_app()

# From https://github.com/qgis/QGIS/blob/master/tests/src/python/test_qgsvectorfilewriter.py

from qgis.testing import unittest


class DummyInterface(object):
    def __getattr__(self, *args, **kwargs):
        def dummy(*args, **kwargs):
            return self

        return dummy

    def __iter__(self):
        return self

    def next(self):
        raise StopIteration

    def layers(self):
        # simulate iface.legendInterface().layers()
        return QgsProject.instance().mapLayersByName()


iface = DummyInterface()


class test_TOMs_geometryUtils(unittest.TestCase):
    """Test dialog works."""

    def setUp(self):
        """Runs before each test."""

        self.testClass = generateGeometryUtils.GenerateGeometryUtils
        self.testClass1 = generateGeometryUtils.GenerateGeometryUtils()

    def tearDown(self):
        """Runs after each test."""
        self.dialog = None

    def test_generatedSignLine(self):

        # line layer
        testLayerA = QgsVectorLayer(
            ("LineString?crs=epsg:27700&index=yes"), "test1", "memory"
        )
        testProviderA = testLayerA.dataProvider()

        testLineString1 = QgsGeometry.fromPolylineXY(
            [QgsPointXY(0, 0), QgsPointXY(1, 0)]
        )
        testLineString2 = QgsGeometry.fromPolylineXY(
            [QgsPointXY(1, 0), QgsPointXY(2, 0)]
        )

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
        testLayerB = QgsVectorLayer(
            ("Point?crs=epsg:27700&index=yes"), "test2", "memory"
        )
        testProviderB = testLayerB.dataProvider()

        testPoint1 = QgsPoint(0, 1)

        testProviderB.addAttributes(
            [
                QgsField("GeometryID", QVariant.String),
                QgsField("SignOrientation", QVariant.Int),
                QgsField("SignType_1", QVariant.Int),
                QgsField("SignType_2", QVariant.Int),
                QgsField("SignType_3", QVariant.Int),
                QgsField("SignType_4", QVariant.Int),
                QgsField("original_geom", QVariant.Geometry),
            ]
        )
        testFieldsB = testProviderB.fields()

        testFeature2A = QgsFeature(testFieldsB)
        testFeature2A.setGeometry(testPoint1)
        testFeature2A.setAttributes(
            ["Alpha", 1, 1, None, None, None, testPoint1.asWkt()]
        )
        testFeature2B = QgsFeature(testFieldsB)
        testFeature2B.setGeometry(testPoint1)
        testFeature2B.setAttributes(["Beta", 2, 1, 1, None, None, testPoint1.asWkt()])
        testFeature2C = QgsFeature(testFieldsB)
        testFeature2C.setGeometry(testPoint1)
        testFeature2C.setAttributes(["Gamma", 3, 1, 1, 1, None, testPoint1.asWkt()])
        testProviderB.addFeatures([testFeature2A, testFeature2B, testFeature2C])
        testLayerB.reload()

        testLayerC = QgsVectorLayer(
            ("Point?crs=epsg:27700&index=yes"), "test2", "memory"
        )
        testProviderC = testLayerC.dataProvider()

        testProviderC.addAttributes([QgsField("GeometryID", QVariant.String)])
        testFieldsC = testProviderC.fields()
        testFeature3A = QgsFeature(testFieldsC)
        testFeature3A.setGeometry(testPoint1)
        testFeature3A.setAttributes(["Zulu"])
        testProviderC.addFeatures([testFeature3A])
        testLayerC.reload()

        distanceForIcons = 3

        (
            orientationToFeature,
            orientationInFeatureDirection,
            orientationAwayFromFeature,
            orientationOppositeFeatureDirection,
        ) = self.testClass.getLineOrientationAtPoint(
            QgsPointXY(testPoint1), testFeature1A
        )

        print("orientationToFeature: {}".format(orientationToFeature))
        self.assertEqual(orientationToFeature, 180.0)
        self.assertEqual(orientationInFeatureDirection, 90.0)
        self.assertEqual(orientationAwayFromFeature, 0.0)
        self.assertEqual(orientationOppositeFeatureDirection, 270.0)

        lineGeom = self.testClass.createLinewithPointAzimuthDistance(
            QgsPointXY(testPoint1), orientationToFeature, 5
        )
        self.assertEqual(lineGeom.length(), 5.0)

        # check creation of line - for feature with 1 sign
        platesInSign = self.testClass.getPlatesInSign(testFeature2A)
        nrPlatesInSign = len(platesInSign)
        self.assertEqual(nrPlatesInSign, 1)

        orientationList = self.testClass.getSignOrientation(testFeature2A, testLayerA)
        self.assertEqual(len(orientationList), 5)
        print("orientationList: {}".format(orientationList))
        self.assertEqual(orientationList[1], 90.0)  # feature direction
        self.assertEqual(orientationList[2], 270.0)  # opposite feature direction
        self.assertEqual(orientationList[3], 180.0)  # facing feature
        self.assertEqual(orientationList[4], 0.0)  # facing away from feature

        lineGeom = self.testClass.getSignLine(
            testFeature2A, testLayerA, distanceForIcons
        )
        print("lineGeom: {}".format(lineGeom.asWkt()))
        self.assertEqual(lineGeom.length(), 6)

        linePts = self.testClass.addPointsToSignLine(
            lineGeom, nrPlatesInSign, distanceForIcons
        )
        # print ('newLineGeom: {}'.format(newLineGeom.asWkt()))
        # linePts = newLineGeom.asPolyline()
        self.assertEqual(len(linePts), 1)

        # check creation of line - for feature with 3 signs
        platesInSign = self.testClass.getPlatesInSign(testFeature2C)
        nrPlatesInSign = len(platesInSign)
        self.assertEqual(nrPlatesInSign, 3)

        orientationList = self.testClass.getSignOrientation(testFeature2C, testLayerA)
        self.assertEqual(len(orientationList), 5)
        self.assertEqual(orientationList[1], 90.0)

        lineGeom = self.testClass.getSignLine(
            testFeature2C, testLayerA, distanceForIcons
        )
        print("lineGeom: {}".format(lineGeom.asWkt()))
        self.assertEqual(lineGeom.length(), 12)

        linePts = self.testClass.addPointsToSignLine(
            lineGeom, nrPlatesInSign, distanceForIcons
        )
        # print ('newLineGeom: {}'.format(newLineGeom.asWkt()))
        # linePts = newLineGeom.asPolyline()
        self.assertEqual(len(linePts), 3)

        # check creation of line - for feature without signs field
        platesInSign = self.testClass.getPlatesInSign(testFeature3A)
        nrPlatesInSign = len(platesInSign)
        self.assertEqual(nrPlatesInSign, 0)

        orientationList = self.testClass.getSignOrientation(testFeature3A, testLayerA)
        self.assertEqual(len(orientationList), 5)
        self.assertIsNone(orientationList[0])

        lineGeom = self.testClass.getSignLine(
            testFeature3A, testLayerA, distanceForIcons
        )
        self.assertIsNone(lineGeom)

        newLineGeom = self.testClass.addPointsToSignLine(
            lineGeom, nrPlatesInSign, distanceForIcons
        )
        self.assertIsNone(newLineGeom)

        # static function
        lineGeom = self.testClass1.finalSignLine(testFeature2C)


if __name__ == "__main__":
    suite = unittest.makeSuite(test_TOMs_geometryUtils)
    runner = unittest.TextTestRunner(verbosity=2)
    runner.run(suite)
