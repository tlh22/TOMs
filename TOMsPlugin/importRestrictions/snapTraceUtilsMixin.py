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

from qgis.core import (
    QgsFeature,
    QgsFeatureRequest,
    QgsGeometry,
    QgsMessageLog,
    QgsPointXY,
    QgsRectangle,
    QgsWkbTypes,
)
from qgis.PyQt.QtCore import QDate, QObject, pyqtSignal
from qgis.PyQt.QtWidgets import QAction, QMessageBox


class SnapTraceUtilsMixin:
    def findNearestPointL(self, searchPt, lineLayer, tolerance):
        # given a point, find the nearest point (within the tolerance) within the line layer
        # returns QgsPoint
        QgsMessageLog.logMessage(
            "In findNearestPointL. Checking lineLayer: "
            + lineLayer.name()
            + "; "
            + searchPt.asWkt(),
            tag="TOMs panel",
        )
        searchRect = QgsRectangle(
            searchPt.x() - tolerance,
            searchPt.y() - tolerance,
            searchPt.x() + tolerance,
            searchPt.y() + tolerance,
        )

        request = QgsFeatureRequest()
        request.setFilterRect(searchRect)
        request.setFlags(QgsFeatureRequest.ExactIntersect)

        shortestDistance = float("inf")
        # nearestPoint = QgsFeature()

        # Loop through all features in the layer to find the closest feature
        for feat in lineLayer.getFeatures(request):
            # Add any features that are found should be added to a list

            closestPtOnFeature = feat.geometry().nearestPoint(
                QgsGeometry.fromPointXY(searchPt)
            )
            dist = feat.geometry().distance(QgsGeometry.fromPointXY(searchPt))
            if dist < shortestDistance:
                shortestDistance = dist
                closestPoint = closestPtOnFeature

        QgsMessageLog.logMessage(
            "In findNearestPointL: shortestDistance: " + str(shortestDistance),
            tag="TOMs panel",
        )

        del request
        del searchRect

        if shortestDistance < float("inf"):
            # nearestPoint = QgsFeature()
            # add the geometry to the feature,
            # nearestPoint.setGeometry(QgsGeometry(closestPtOnFeature))
            # QgsMessageLog.logMessage("findNearestPointL: nearestPoint geom type: " + str(nearestPoint.wkbType()), tag="TOMs panel")
            return closestPoint  # returns a geometry
        else:
            return None

    def nearbyLineFeature(self, currFeatureGeom, searchLineLayer, tolerance):

        QgsMessageLog.logMessage("In nearbyLineFeature - lineLayer", tag="TOMs panel")

        nearestLine = None

        for currVertexNr, currVertexPt in enumerate(currFeatureGeom.asPolyline()):

            nearestLine = self.findNearestLine(currVertexPt, searchLineLayer, tolerance)
            if nearestLine:
                break

        return nearestLine

    def findNearestLine(self, searchPt, lineLayer, tolerance):
        # given a point, find the nearest point (within the tolerance) within the line layer
        # returns QgsPoint
        QgsMessageLog.logMessage("In findNearestLine - lineLayer", tag="TOMs panel")
        searchRect = QgsRectangle(
            searchPt.x() - tolerance,
            searchPt.y() - tolerance,
            searchPt.x() + tolerance,
            searchPt.y() + tolerance,
        )

        request = QgsFeatureRequest()
        request.setFilterRect(searchRect)
        request.setFlags(QgsFeatureRequest.ExactIntersect)

        shortestDistance = float("inf")

        # Loop through all features in the layer to find the closest feature
        for feat in lineLayer.getFeatures(request):
            # Add any features that are found should be added to a list

            # closestPtOnFeature = f.geometry().nearestPoint(QgsGeometry.fromPoint(searchPt))
            dist = feat.geometry().distance(QgsGeometry.fromPointXY(searchPt))
            if dist < shortestDistance:
                shortestDistance = dist
                closestLine = feat

        QgsMessageLog.logMessage(
            "In findNearestLine: shortestDistance: " + str(shortestDistance),
            tag="TOMs panel",
        )

        del request
        del searchRect

        if shortestDistance < float("inf"):

            """QgsMessageLog.logMessage("In findNearestLine: closestLine {}".format(closestLine.exportToWkt()),
            tag="TOMs panel")"""

            return closestLine  # returns a geometry
        else:
            return None

    def azimuth(self, point1, point2):
        """azimuth between 2 shapely points (interval 0 - 360)"""
        angle = math.atan2(point2.x() - point1.x(), point2.y() - point1.y())
        return math.degrees(angle) if angle > 0 else math.degrees(angle) + 360

    def angleAtVertex(self, point, ptBefore, ptAfter):
        angle = abs(self.azimuth(point, ptAfter) - self.azimuth(point, ptBefore))

        if angle > 180.0:
            angle = 360.0 - angle

        return angle
