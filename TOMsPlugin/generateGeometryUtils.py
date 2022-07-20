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
import math
import os.path
from cmath import phase, rect

from qgis.core import (
    Qgis,
    QgsExpressionContextUtils,
    QgsFeatureRequest,
    QgsGeometry,
    QgsGeometryUtils,
    QgsPoint,
    QgsPointXY,
    QgsProject,
    QgsRectangle,
    QgsWkbTypes,
)
from qgis.PyQt.QtCore import QObject
from qgis.utils import iface

from .core.tomsMessageLog import TOMsMessageLog


class GenerateGeometryUtils(QObject):
    # https://gis.stackexchange.com/questions/95528/produce-line-from-components-length-and-angle?noredirect=1&lq=1
    # direction cosines function

    @staticmethod
    def cosdirAzim(azim):
        azRad = math.radians(azim)
        cosa = math.sin(azRad)
        cosb = math.cos(azRad)
        return cosa, cosb

    @staticmethod
    def cosdirAzimRad(azim):
        # az = math.radians(azim)
        cosa = math.sin(azim)
        cosb = math.cos(azim)
        return cosa, cosb

    @staticmethod
    def sameSign(x, y):
        # https://stackoverflow.com/questions/45950285/python-challenge-comparing-signs-of-2-numbers-without-using-or
        return abs(x) + abs(y) == abs(x + y)

    @staticmethod
    def changeSign(x):
        return -x

    @staticmethod
    def turnToCL(az1, az2):
        """
        function to determine direction of turn to road centre    *** needs to be checked carefully ***
        Az1 = Az of current line; Az2 = Az to roadCentreline
        """
        # TOMsMessageLog.logMessage("In turnToCL Az1 = " + str(Az1) + " Az2 = " + str(Az2), level=logging.DEBUG)

        azCL = az1 - 90.0
        if azCL < 0:
            azCL += 360.0

        # Need to check quadrant

        if 0 <= azCL <= 90.0:
            if 270.0 <= az2 <= 359.999:
                azCL = azCL + 360
        elif 0 <= az2 <= 90:
            if 270.0 <= azCL <= 359.999:
                az2 = az2 + 360

        direction = abs(float(azCL) - float(az2))

        if direction < 90:
            turn = -90
        else:
            turn = 90

        return turn

    @staticmethod
    def calcBisector(prevAz, currAz, turn, widthRest):
        # function to return Az of bisector

        prevAzA = GenerateGeometryUtils.checkDegrees(prevAz + float(turn))
        currAzA = GenerateGeometryUtils.checkDegrees(currAz + float(turn))

        diffAz = prevAzA - currAzA

        diffAngle = diffAz / float(2)
        bisectAz = prevAzA - diffAngle

        diffAngleRad = math.radians(diffAngle)
        distToPt = float(widthRest) / math.cos(diffAngleRad)

        return bisectAz, distToPt

    @staticmethod
    def calcInteriorBisectAzimuth(az1, az2):
        # function to return Az of bisector

        diffAz = GenerateGeometryUtils.checkDegrees(
            az1
        ) - GenerateGeometryUtils.checkDegrees(az2)

        diffAz2 = diffAz
        if diffAz > 180.0:
            diffAz2 = diffAz - 360.0
        if diffAz < -180.0:
            diffAz2 = diffAz + 360.0

        diffAngle = diffAz2 / float(2)
        bisectAz = GenerateGeometryUtils.checkDegrees(az1 - diffAngle)

        # TOMsMessageLog.logMessage("In generateDisplayGeometry: bisectAz: " + str(bisectAz), level=logging.DEBUG)

        return bisectAz

    @staticmethod
    def checkDegrees(azim):
        """newAz = Az

        if Az >= float(360):
            newAz = Az - float(360)
        elif Az < float(0):
            newAz = Az + float(360)
        TOMsMessageLog.logMessage("In checkDegrees (1): newAz: " + str(newAz), level=logging.DEBUG)"""

        newAz = math.degrees(QgsGeometryUtils().normalizedAngle(math.radians(azim)))

        # TOMsMessageLog.logMessage("In checkDegrees (2): newAz: " + str(newAz), level=logging.DEBUG)

        return newAz

    @staticmethod
    def setRoadName(feature):

        newRoadName, newUSRN = GenerateGeometryUtils.determineRoadName(feature)
        # now set the attributes
        try:
            if newRoadName:
                feature.setAttribute("RoadName", newRoadName)
                feature.setAttribute("USRN", newUSRN)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "setRoadName: error in expression function: {}".format(e),
                level=Qgis.Warning,
            )

    @staticmethod
    def determineRoadName(feature):

        TOMsMessageLog.logMessage("In determineRoadName(helper):", level=logging.DEBUG)

        roadCasementLayer = QgsProject.instance().mapLayersByName("RoadCasement")[0]

        # take the first point from the geometry
        TOMsMessageLog.logMessage(
            "In determineRoadName: {}".format(feature.geometry().asWkt()),
            level=logging.DEBUG,
        )

        geom = feature.geometry()

        toleranceNearby = (
            10.0  # somehow need to have this (and layer names) as global variables
        )

        TOMsMessageLog.logMessage(
            "In determineRoadName: GeometryID: {}".format(
                feature.attribute("GeometryID")
            ),
            level=logging.DEBUG,
        )
        if geom:
            if geom.type() == QgsWkbTypes.LineGeometry:
                TOMsMessageLog.logMessage(
                    "In determineRoadName(helper): considering line",
                    level=logging.DEBUG,
                )
                line = GenerateGeometryUtils.getLineForAz(feature)

                if len(line) == 0:
                    return None, None

                # testPt = line[0]
                length = geom.length()
                testPtGeom = geom.interpolate(length / 2.0)
                testPt = testPtGeom.asPoint()
                TOMsMessageLog.logMessage(
                    "In determineRoadName: GeometryID: {}. Length: {}. {}".format(
                        feature.attribute("GeometryID"), length, length / 2.0
                    ),
                    level=logging.DEBUG,
                )

            elif geom.type() == QgsWkbTypes.PointGeometry:  # Point
                TOMsMessageLog.logMessage(
                    "In determineRoadName(helper): considering point",
                    level=logging.DEBUG,
                )
                testPt = feature.geometry().asPoint()

                # tolerance_nearby = 5.0

            elif feature.geometry().type() == QgsWkbTypes.PolygonGeometry:  # Polygon
                TOMsMessageLog.logMessage(
                    "In determineRoadName(helper): considering polygon",
                    level=logging.DEBUG,
                )
                ptList = feature.geometry().asPolygon()[0]
                testPt = ptList[
                    0
                ]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

        else:
            TOMsMessageLog.logMessage(
                "In determineRoadName: unknown geometry type", level=Qgis.Warning
            )
            return None, None

        # nrPts = len(ptList)
        # TOMsMessageLog.logMessage("In determineRoadName: number of pts in list: " + str(nrPts), level=logging.DEBUG)

        TOMsMessageLog.logMessage(
            "In determineRoadName: GeometryID: {}; testPt: {}:{}".format(
                feature.attribute("GeometryID"), testPt.x(), testPt.y()
            ),
            level=logging.DEBUG,
        )

        # check for the feature within RoadCasement_NSG_RoadName layer
        # tolerance_nearby = 1.0  # somehow need to have this (and layer names) as global variables

        # nearestRC_feature = generateGeometryUtils.findFeatureAt2(feature, testPt, RoadCasementLayer,
        #                                                        tolerance_nearby)

        (_, nearestRCFeature,) = GenerateGeometryUtils.findNearestPointOnLineLayer(
            testPt, roadCasementLayer, toleranceNearby
        )

        if nearestRCFeature:

            idxRoadName = roadCasementLayer.fields().indexFromName("RoadName")
            idxUSRN = roadCasementLayer.fields().indexFromName("USRN")

            roadName = nearestRCFeature.attributes()[idxRoadName]
            usrn = nearestRCFeature.attributes()[idxUSRN]

            TOMsMessageLog.logMessage(
                "In determineRoadName: RoadName: " + str(roadName), level=Qgis.Info
            )

            return roadName, usrn

        return None, None

    @staticmethod
    def setAzimuthToRoadCentreLine(feature):

        # now set the attribute
        feature.setAttribute(
            "AzimuthToRoadCentreLine",
            int(GenerateGeometryUtils.calculateAzimuthToRoadCentreLine(feature)),
        )

    @staticmethod
    def getLineForAz(feature):
        # gets a single "line" (array of points) from the current feature. Checks for:
        # - existence of geoemtry
        # - whether or not it is multi-part

        geom = feature.geometry()
        # line = QgsGeometry()

        if geom:
            if geom.type() == QgsWkbTypes.LineGeometry:
                if geom.isMultipart():
                    lines = geom.asMultiPolyline()
                    nrLines = len(lines)

                    # take the first line as the one we are interested in
                    if nrLines > 0:
                        line = lines[0]
                    else:
                        return 0

                else:
                    line = feature.geometry().asPolyline()

                # Now return the array
                return line

            TOMsMessageLog.logMessage(
                "In getLineForAz(helper): Incorrect geometry found", level=Qgis.Warning
            )
            return None

        TOMsMessageLog.logMessage(
            "In getLineForAz(helper): geometry not found", level=Qgis.Warning
        )
        return None

    @staticmethod
    def calculateAzimuthToRoadCentreLine(feature):
        # find the shortest line from this point to the road centre line layer
        # http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/
        # generates "closest feature" function

        TOMsMessageLog.logMessage(
            "In calculateAzimuthToRoadCentreLine(helper):", level=logging.DEBUG
        )

        roadCentreLineLayer = QgsProject.instance().mapLayersByName("RoadCentreLine")[0]

        # take the a point from the geometry
        # line = feature.geometry().asPolyline()
        line = GenerateGeometryUtils.getLineForAz(feature)

        if len(line) == 0:
            return 0

        # Get the mid point of the line
        # https://gis.stackexchange.com/questions/58079/finding-middle-point-midpoint-of-line-in-qgis

        testPt = feature.geometry().centroid().asPoint()

        # Find all Road Centre Line features within a "reasonable" distance
        # and then check each one to find the shortest distance

        toleranceRoadwidth = 25
        searchRect = QgsRectangle(
            testPt.x() - toleranceRoadwidth,
            testPt.y() - toleranceRoadwidth,
            testPt.x() + toleranceRoadwidth,
            testPt.y() + toleranceRoadwidth,
        )

        request = QgsFeatureRequest()
        request.setFilterRect(searchRect)
        request.setFlags(QgsFeatureRequest.ExactIntersect)

        shortestDistance = float("inf")
        featureFound = False

        # Loop through all features in the layer to find the closest feature
        for feat in roadCentreLineLayer.getFeatures(request):
            dist = feat.geometry().distance(QgsGeometry.fromPointXY(testPt))
            if dist < shortestDistance:
                shortestDistance = dist
                closestFeature = feat
                featureFound = True

        TOMsMessageLog.logMessage(
            "In calculateAzimuthToRoadCentreLine: shortestDistance: "
            + str(shortestDistance),
            level=logging.DEBUG,
        )

        if featureFound:
            # now obtain the line between the testPt and the nearest feature
            startPt = QgsPoint(
                QgsGeometry.asPoint(
                    closestFeature.geometry().nearestPoint(
                        QgsGeometry.fromPointXY(testPt)
                    )
                )
            )

            TOMsMessageLog.logMessage(
                "In calculateAzimuthToRoadCentreLine: startPoint: " + str(startPt.x()),
                level=logging.DEBUG,
            )

            azim = GenerateGeometryUtils.checkDegrees(QgsPoint(testPt).azimuth(startPt))

            return azim

        return 0

    @staticmethod
    def getReverseAzimuth(azim):
        return azim % 360

    @staticmethod
    def getDisplayGeometry(
        feature, restGeomType, offset, shpExtent, orientation, azimuthToCentreLine
    ):
        # Obtain relevant variables

        # Need to check why the project variable function is not working

        restrictionID = feature.attribute("GeometryID")
        TOMsMessageLog.logMessage(
            "In getDisplayGeometry: New restriction ............................"
            "........................................ ID: " + str(restrictionID),
            level=Qgis.Info,
        )

        #  Within expression areas use:
        #  generateDisplayGeometry(   "RestrictionTypeID" , "GeomTypeID",
        #                             "AzimuthToRoadCentreLine",  @BayOffsetFromKerb ,  @BayWidth )
        #
        #  Logic is :
        #
        #  For vertex 0,
        #      Move for defined distance (typically 0.25m) in direction "AzimuthToCentreLine" and create point 1
        #      Move for bay width (typically 2.0m) in direction "AzimuthToCentreLine and create point 2
        #      Calculate Azimuth for line between vertex 0 and vertex 1
        #      Calc difference in Azimuths and decide < or > 180 (to indicate which side of kerb line to generate bay)
        #
        #  For each vertex (starting at 1)
        #      Calculate Azimuth for current vertex and previous
        #      Calculate perpendicular to centre of road (using knowledge of which side of kerb line generated above)
        #      Move for bay width (typically 2.0m) along perpendicular and create point
        #
        #  For last vertex
        #          Move for defined distance (typically 0.25m) along perpendicular and create last point

        line = GenerateGeometryUtils.getLineForAz(feature)

        if len(line) == 0:
            return 0

        # Now have a valid set of points

        ptsList = []
        parallelPtsList = []
        prevAz = 0
        diffEchelonAz = 0

        # now loop through each of the vertices and process as required. New geometry points are added to ptsList

        for i in range(len(line) - 1):

            azim = line[i].azimuth(line[i + 1])

            # if this is the first point

            if i == 0:
                # determine which way to turn towards CL

                turn = GenerateGeometryUtils.turnToCL(azim, azimuthToCentreLine)

                newAz = azim + turn
                cosa, cosb = GenerateGeometryUtils.cosdirAzim(newAz)

                ptsList.append(
                    QgsPoint(
                        line[i].x() + (float(offset) * cosa),
                        line[i].y() + (float(offset) * cosb),
                    )
                )

                # Now add the point at the extent. If it is an echelon bay:
                #   a. calculate the difference between the first Az and the echelon Az (??), and
                #   b. adjust the angle
                #   c. *** also need to adjust the length *** Not yet implemented

                # if restGeomType == 5 or restGeomType == 25:  # echelon
                if restGeomType in [5, 25]:  # echelon
                    TOMsMessageLog.logMessage(
                        "In getDisplayGeometry: orientation: " + str(orientation),
                        level=logging.DEBUG,
                    )
                    diffEchelonAz = GenerateGeometryUtils.checkDegrees(
                        orientation - newAz
                    )
                    newAz = azim + turn + diffEchelonAz
                    TOMsMessageLog.logMessage(
                        "In getDisplayGeometry: newAz: "
                        + str(newAz)
                        + " diffEchelonAz: "
                        + str(diffEchelonAz),
                        level=logging.DEBUG,
                    )
                    cosa, cosb = GenerateGeometryUtils.cosdirAzim(newAz)

                ptsList.append(
                    QgsPoint(
                        line[i].x() + (float(shpExtent) * cosa),
                        line[i].y() + (float(shpExtent) * cosb),
                    )
                )

            else:

                # now pass along the feature

                # need to work out half of bisected angle

                newAz, distWidth = GenerateGeometryUtils.calcBisector(
                    prevAz, azim, turn, shpExtent
                )

                cosa, cosb = GenerateGeometryUtils.cosdirAzim(newAz + diffEchelonAz)
                ptsList.append(
                    QgsPoint(
                        line[i].x() + (float(distWidth) * cosa),
                        line[i].y() + (float(distWidth) * cosb),
                    )
                )

                parallelPtsList.append(
                    QgsPoint(
                        line[i].x() + (float(distWidth) * cosa),
                        line[i].y() + (float(distWidth) * cosb),
                    )
                )

            prevAz = azim

        # have reached the end of the feature. Now need to deal with last point.
        # Use Azimuth from last segment but change the points

        # standard bay
        newAz = azim + turn + diffEchelonAz
        # TOMsMessageLog.logMessage("In generateDisplayGeometry: newAz: " + str(newAz), level=logging.DEBUG)
        cosa, cosb = GenerateGeometryUtils.cosdirAzim(newAz)

        ptsList.append(
            QgsPoint(
                line[len(line) - 1].x() + (float(shpExtent) * cosa),
                line[len(line) - 1].y() + (float(shpExtent) * cosb),
            )
        )

        # add end point (without any consideration of Echelon)

        newAz = azim + turn
        cosa, cosb = GenerateGeometryUtils.cosdirAzim(newAz)

        ptsList.append(
            QgsPoint(
                line[len(line) - 1].x() + (float(offset) * cosa),
                line[len(line) - 1].y() + (float(offset) * cosb),
            )
        )

        newLine = QgsGeometry.fromPolyline(ptsList)

        return newLine, parallelPtsList

    @staticmethod
    def meanAngle(angle1, angle2):
        return phase((rect(1, angle1) + rect(1, angle2)) / 2.0)

    @staticmethod
    def generateMultiLabelLeaders(feature):
        """This generates leaders for labels as multipoints"""

        minScale = float(GenerateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        if currScale <= minScale:

            # we're accessing the labels layer, meaning that feature.geometry() is the label's position (multipoint)
            labelGeometry = feature.geometry().asMultiPoint()

            # we need to get the main geometry too
            # unfortunately, the attribute returns an eWKT instead of a QgsGeometry (see post on qgis-dev 22/04/2020)
            mainEwkt = feature.attribute("geom")
            mainWkt = mainEwkt[mainEwkt.index(";") + 1 :]
            mainGeom = QgsGeometry.fromWkt(mainWkt)

            # we build a collection for the leaders
            leaders = []
            for labelPos in labelGeometry:
                nearestPoint = mainGeom.nearestPoint(
                    QgsGeometry.fromPointXY(labelPos)
                ).asPoint()
                leaders.append([nearestPoint, labelPos])

            return QgsGeometry.fromMultiPolylineXY(leaders)

        return None

    @staticmethod
    def generateBayLabelLeader(feature):

        # TOMsMessageLog.logMessage("In generateBayLabelLeader", level=logging.DEBUG)
        # check to see scale

        minScale = float(GenerateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        TOMsMessageLog.logMessage(
            "In generateBayLabelLeader. Current scale: "
            + str(currScale)
            + " min scale: "
            + str(minScale),
            level=logging.DEBUG,
        )

        if currScale <= minScale:

            if feature.attribute("label_X"):

                length = feature.geometry().length()
                TOMsMessageLog.logMessage(
                    "In generateBayLabelLeader. label_X set for "
                    + str(feature.attribute("GeometryID")),
                    level=logging.DEBUG,
                )

                return QgsGeometry.fromPolyline(
                    [
                        QgsPoint(
                            feature.geometry().interpolate(length / 2.0).asPoint()
                        ),
                        QgsPoint(
                            feature.attribute("label_X"), feature.attribute("label_Y")
                        ),
                    ]
                )

        return None

    @staticmethod
    def generatePolygonLabelLeader(feature):

        # TOMsMessageLog.logMessage("In generateBayLabelLeader", level=logging.DEBUG)
        # check to see scale

        minScale = float(GenerateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        if currScale <= minScale:

            if feature.attribute("label_X"):
                TOMsMessageLog.logMessage(
                    "In generatePolygonLabelLeader. label_X set for "
                    + str(feature.attribute("GeometryID")),
                    level=logging.DEBUG,
                )

                # now generate line
                return QgsGeometry.fromPolyline(
                    [
                        QgsPoint(feature.geometry().nearestPoint().asPoint()),
                        QgsPoint(
                            feature.attribute("label_X"), feature.attribute("label_Y")
                        ),
                    ]
                )

        return None

    @staticmethod
    def getMininumScaleForDisplay():

        minScale = QgsExpressionContextUtils.projectScope(
            QgsProject.instance()
        ).variable("MinimumTextDisplayScale")

        TOMsMessageLog.logMessage(
            "In getMininumScaleForDisplay. minScale(1): " + str(minScale),
            level=logging.DEBUG,
        )

        if minScale is None:
            minScale = 1250

        return minScale

    @staticmethod
    def getWaitingLoadingRestrictionLabelText(feature):

        TOMsMessageLog.logMessage(
            "In getWaitingLoadingRestrictionLabelText", level=logging.DEBUG
        )

        minScale = float(GenerateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        if currScale > minScale:
            return None, None

        TOMsMessageLog.logMessage(
            "In getWaitingLoadingRestrictionLabelText(1): get details ...",
            level=logging.DEBUG,
        )

        try:
            waitingTimeID = feature.attribute("NoWaitingTimeID")
            loadingTimeID = feature.attribute("NoLoadingTimeID")
            matchDayTimePeriodID = feature.attribute("MatchDayTimePeriodID")
            additionalConditionID = feature.attribute("AdditionalConditionID")
            geometryID = feature.attribute("GeometryID")
        except Exception:
            return None, None

        TOMsMessageLog.logMessage(
            "In getWaitingLoadingRestrictionLabelText(1): details found ... [{}]".format(
                geometryID
            ),
            level=logging.DEBUG,
        )

        timePeriodsLayer = QgsProject.instance().mapLayersByName(
            "TimePeriodsInUse_View"
        )[0]

        TOMsMessageLog.logMessage(
            "In getWaitingLoadingRestrictionLabelText(1): getting lookup values ... [{}]".format(
                geometryID
            ),
            level=logging.DEBUG,
        )

        waitDesc = GenerateGeometryUtils.getLookupLabelText(
            timePeriodsLayer, waitingTimeID
        )
        loadDesc = GenerateGeometryUtils.getLookupLabelText(
            timePeriodsLayer, loadingTimeID
        )

        TOMsMessageLog.logMessage(
            "In getWaitingLoadingRestrictionLabelText(1): waiting: "
            + str(waitDesc)
            + " loading: "
            + str(loadDesc),
            level=logging.DEBUG,
        )

        restrictionCPZ = feature.attribute("CPZ")
        restrictionEDZ = feature.attribute("MatchDayEventDayZone")
        cpzWaitingTimeID = GenerateGeometryUtils.getCPZWaitingTimeID(restrictionCPZ)

        TOMsMessageLog.logMessage(
            "In getWaitingLoadingRestrictionLabelText ({}): wait_cpz: {}; wait_res: {}; load: {}; ed: {}".format(
                geometryID,
                cpzWaitingTimeID,
                waitingTimeID,
                loadingTimeID,
                matchDayTimePeriodID,
            ),
            level=logging.DEBUG,
        )

        if cpzWaitingTimeID:
            if cpzWaitingTimeID == waitingTimeID:
                waitDesc = None

        if matchDayTimePeriodID:
            cpzMatchDayTimePeriodID = GenerateGeometryUtils.getEDWaitingTimeID(
                restrictionEDZ
            )
            TOMsMessageLog.logMessage(
                "In getWaitingLoadingRestrictionLabelText: ED: {}; restriction: {}".format(
                    cpzMatchDayTimePeriodID, matchDayTimePeriodID
                ),
                level=logging.DEBUG,
            )
            if cpzMatchDayTimePeriodID != matchDayTimePeriodID:
                matchDayTimePeriodDesc = GenerateGeometryUtils.getLookupLabelText(
                    timePeriodsLayer, matchDayTimePeriodID
                )
                if waitDesc:
                    waitDesc = "{};Match Day: {}".format(
                        waitDesc, matchDayTimePeriodDesc
                    )
                else:
                    waitDesc = "Match Day: {}".format(matchDayTimePeriodDesc)

        if additionalConditionID:
            additionalConditionTypesLayer = QgsProject.instance().mapLayersByName(
                "AdditionalConditionTypes"
            )[0]
            additionalConditionDesc = GenerateGeometryUtils.getLookupDescription(
                additionalConditionTypesLayer, additionalConditionID
            )
            if waitDesc:
                waitDesc = "{};{}".format(waitDesc, additionalConditionDesc)
            else:
                waitDesc = "{}".format(additionalConditionDesc)

        TOMsMessageLog.logMessage(
            "In getWaitingLoadingRestrictionLabelText({}); waiting: {}; loading: {}".format(
                geometryID, waitDesc, loadDesc
            ),
            level=logging.DEBUG,
        )
        return waitDesc, loadDesc

    @staticmethod
    def getBayRestrictionLabelText(feature):

        TOMsMessageLog.logMessage(
            "In getBayRestrictionLabelText ..", level=logging.DEBUG
        )

        minScale = float(GenerateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        if currScale > minScale:
            return None, None, None

        maxStayID = feature.attribute("MaxStayID")
        noReturnID = feature.attribute("NoReturnID")
        timePeriodID = feature.attribute("TimePeriodID")
        matchDayTimePeriodID = feature.attribute("MatchDayTimePeriodID")
        additionalConditionID = feature.attribute("AdditionalConditionID")
        permitCode = feature.attribute("PermitCode")

        lengthOfTimeLayer = QgsProject.instance().mapLayersByName("LengthOfTime")[0]
        timePeriodsLayer = QgsProject.instance().mapLayersByName(
            "TimePeriodsInUse_View"
        )[0]

        if feature.attribute("GeometryID"):
            TOMsMessageLog.logMessage(
                "In getBayRestrictionLabelText: GeometryID: "
                + feature.attribute("GeometryID"),
                level=logging.DEBUG,
            )

        maxStayDesc = GenerateGeometryUtils.getLookupLabelText(
            lengthOfTimeLayer, maxStayID
        )
        noReturnDesc = GenerateGeometryUtils.getLookupLabelText(
            lengthOfTimeLayer, noReturnID
        )
        timePeriodDesc = GenerateGeometryUtils.getLookupLabelText(
            timePeriodsLayer, timePeriodID
        )

        TOMsMessageLog.logMessage(
            "In getBayRestrictionLabelText (2) ..", level=logging.DEBUG
        )

        restrictionCPZ = feature.attribute("CPZ")
        restrictionEDZ = feature.attribute("MatchDayEventDayZone")
        restrictionPTA = feature.attribute("ParkingTariffArea")

        cpzWaitingTimeID = GenerateGeometryUtils.getCPZWaitingTimeID(restrictionCPZ)
        (
            tariffZoneTimePeriodID,
            tariffZoneMaxStayID,
            tariffZoneNoReturnID,
        ) = GenerateGeometryUtils.getTariffZoneDetails(restrictionPTA)

        TOMsMessageLog.logMessage(
            "In getBayRestrictionLabelText (1): "
            + str(cpzWaitingTimeID)
            + " PTA hours: "
            + str(tariffZoneTimePeriodID),
            level=logging.DEBUG,
        )
        TOMsMessageLog.logMessage(
            "In getBayRestrictionLabelText. bay hours: " + str(timePeriodID),
            level=logging.DEBUG,
        )

        if timePeriodID == 1:  # 'At Any Time'
            timePeriodDesc = None

        if cpzWaitingTimeID:
            TOMsMessageLog.logMessage(
                "In getBayRestrictionLabelText: "
                + str(cpzWaitingTimeID)
                + " "
                + str(timePeriodID),
                level=logging.DEBUG,
            )
            if cpzWaitingTimeID == timePeriodID:
                timePeriodDesc = None

        if tariffZoneTimePeriodID:
            if tariffZoneTimePeriodID == timePeriodID:
                timePeriodDesc = None

            if tariffZoneMaxStayID:
                if tariffZoneMaxStayID == maxStayID:
                    maxStayDesc = None

            if tariffZoneNoReturnID:
                if tariffZoneNoReturnID == noReturnID:
                    noReturnDesc = None

        if matchDayTimePeriodID:
            cpzMatchDayTimePeriodID = GenerateGeometryUtils.getEDWaitingTimeID(
                restrictionEDZ
            )
            TOMsMessageLog.logMessage(
                "In getBayRestrictionLabelText: ED: {}; restriction: {}".format(
                    cpzMatchDayTimePeriodID, matchDayTimePeriodID
                ),
                level=logging.DEBUG,
            )
            if cpzMatchDayTimePeriodID != matchDayTimePeriodID:
                matchDayTimePeriodDesc = GenerateGeometryUtils.getLookupLabelText(
                    timePeriodsLayer, matchDayTimePeriodID
                )
                if timePeriodDesc:
                    timePeriodDesc = "{};Match Day: {}".format(
                        timePeriodDesc, matchDayTimePeriodDesc
                    )
                else:
                    timePeriodDesc = "Match Day: {}".format(matchDayTimePeriodDesc)

        if permitCode:
            if timePeriodDesc:
                timePeriodDesc = "{};Permit: {}".format(timePeriodDesc, permitCode)
            else:
                timePeriodDesc = "Permit: {}".format(permitCode)

        if additionalConditionID:
            additionalConditionTypesLayer = QgsProject.instance().mapLayersByName(
                "AdditionalConditionTypes"
            )[0]
            additionalConditionDesc = GenerateGeometryUtils.getLookupDescription(
                additionalConditionTypesLayer, additionalConditionID
            )
            if timePeriodDesc:
                timePeriodDesc = "{};{}".format(timePeriodDesc, additionalConditionDesc)
            else:
                timePeriodDesc = "{}".format(additionalConditionDesc)

        TOMsMessageLog.logMessage(
            "In getBayRestrictionLabelText. timePeriodDesc (2): " + str(timePeriodDesc),
            level=logging.DEBUG,
        )

        return maxStayDesc, noReturnDesc, timePeriodDesc

    @staticmethod
    def getLookupDescription(lookupLayer, code):

        # TOMsMessageLog.logMessage("In getLookupDescription", level=logging.DEBUG)

        if code:
            query = '"Code" = ' + str(code)
            request = QgsFeatureRequest().setFilterExpression(query)

            # TOMsMessageLog.logMessage("In getLookupDescription. queryStatus: " + str(query), level=logging.DEBUG)

            for row in lookupLayer.getFeatures(request):
                return row.attribute("Description")  # make assumption that only one row

        return None

    @staticmethod
    def getLookupLabelText(lookupLayer, code):

        # TOMsMessageLog.logMessage("In getLookupLabelText", level=logging.DEBUG)

        if code:
            query = '"Code" = ' + str(code)
            request = QgsFeatureRequest().setFilterExpression(query)

            try:
                row = next(lookupLayer.getFeatures(request))
                return row["LabelText"]  # make assumption that only one row
            except Exception as e:
                TOMsMessageLog.logMessage(
                    "getLookupLabelText: error in expression function: {}".format(e),
                    level=Qgis.Warning,
                )

        # TOMsMessageLog.logMessage("In getLookupLabelText. returning without value ...", level=logging.DEBUG)

        return None

    @staticmethod
    def getCurrentCPZDetails(feature):

        TOMsMessageLog.logMessage("In getCurrentCPZDetails", level=logging.DEBUG)
        try:
            cpzLayer = QgsProject.instance().mapLayersByName("CPZs")[0]
        except Exception:
            cpzLayer = None

        if cpzLayer:
            restrictionID = feature.attribute("GeometryID")
            TOMsMessageLog.logMessage(
                "In getCurrentCPZDetails. restriction: " + str(restrictionID),
                level=logging.DEBUG,
            )

            # geom = feature.geometry()

            currentCPZFeature = GenerateGeometryUtils.getPolygonForRestriction(
                feature, cpzLayer
            )

            if currentCPZFeature:

                currentCPZ = currentCPZFeature.attribute("CPZ")
                cpzWaitingTimeID = currentCPZFeature.attribute("TimePeriodID")
                # cpzMatchDayTimePeriodID = currentCPZFeature.attribute("MatchDayTimePeriodID")
                TOMsMessageLog.logMessage(
                    "In getCurrentCPZDetails. CPZ found: {}: control: {}".format(
                        currentCPZ, cpzWaitingTimeID
                    ),
                    level=logging.DEBUG,
                )

                return currentCPZ, cpzWaitingTimeID

        return None, None

    @staticmethod
    def getCurrentEventDayDetails(feature):

        TOMsMessageLog.logMessage("In getCurrentEventDayDetails", level=logging.DEBUG)
        try:
            edLayer = QgsProject.instance().mapLayersByName("MatchDayEventDayZones")[0]
        except Exception:
            edLayer = None

        if edLayer:
            restrictionID = feature.attribute("GeometryID")
            TOMsMessageLog.logMessage(
                "In getCurrentEventDayDetails. restriction: " + str(restrictionID),
                level=logging.DEBUG,
            )

            # geom = feature.geometry()

            currentEDZFeature = GenerateGeometryUtils.getPolygonForRestriction(
                feature, edLayer
            )

            if currentEDZFeature:

                currentEDZ = currentEDZFeature.attribute("EDZ")
                edzWaitingTimeID = currentEDZFeature.attribute("TimePeriodID")
                # cpzMatchDayTimePeriodID = currentCPZFeature.attribute("MatchDayTimePeriodID")
                TOMsMessageLog.logMessage(
                    "In getCurrentEventDayDetails. CPZ found: {}: control: {}".format(
                        currentEDZ, edzWaitingTimeID
                    ),
                    level=logging.DEBUG,
                )

                return currentEDZ, edzWaitingTimeID

        return None, None

    @staticmethod
    def getCurrentPTADetails(feature):

        TOMsMessageLog.logMessage("In getCurrentPTADetails", level=logging.DEBUG)
        try:
            ptaLayer = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]
        except Exception:
            ptaLayer = None

        if ptaLayer:
            restrictionID = feature.attribute("GeometryID")
            TOMsMessageLog.logMessage(
                "In getCurrentPTADetails. restriction: " + str(restrictionID),
                level=logging.DEBUG,
            )

            # geom = feature.geometry()

            currentPTAFeature = GenerateGeometryUtils.getPolygonForRestriction(
                feature, ptaLayer
            )

            if currentPTAFeature:
                currentPTA = currentPTAFeature.attribute("ParkingTariffArea")
                ptaMaxStayID = currentPTAFeature.attribute("MaxStayID")
                ptaNoReturnID = currentPTAFeature.attribute("NoReturnID")

                # TOMsMessageLog.logMessage("In getCurrentPTADetails. PTA found: " + str(currentPTA), level=logging.DEBUG)

                return currentPTA, ptaMaxStayID, ptaNoReturnID

        return None, None, None

    @staticmethod
    def getPolygonForRestriction(restriction, layer):
        # def findFeatureAt(self, pos, excludeFeature=None):
        """Find the feature close to the given position.
        #def findFeatureAt2(feature, layerPt, layer, tolerance):
            'layerPt' is the position to check, in layer coordinates.
            'layer' is specified layer
            'tolerance' is search distance in layer units

            If no feature is close to the given coordinate, we return None.
        """

        # TOMsMessageLog.logMessage("In getPolygonForRestriction.", level=logging.DEBUG)

        line = GenerateGeometryUtils.getLineForAz(restriction)

        if line:
            if len(line) == 0:
                return 0

            testPt = line[
                0
            ]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)
            # TOMsMessageLog.logMessage("In getPolygonForRestriction." + str(testPt.x()), level=logging.DEBUG)

            for poly in layer.getFeatures():
                if poly.geometry().contains(QgsGeometry.fromPointXY(testPt)):
                    # TOMsMessageLog.logMessage("In getPolygonForRestriction. feature found", level=logging.DEBUG)
                    return poly

        return None

    @staticmethod
    def getAttributeFromLayer(layer, keyField, keyValue, attributeName):

        query = "\"{}\" = '{}'".format(keyField, keyValue)
        request = QgsFeatureRequest().setFilterExpression(query)

        try:
            for row in layer.getFeatures(request):
                TOMsMessageLog.logMessage(
                    "In getAttributeFromLayer. Returning {} with value {} from table {}".format(
                        attributeName,
                        row[layer.fields().indexFromName(attributeName)],
                        layer.name(),
                    ),
                    level=logging.DEBUG,
                )
                return row[
                    layer.fields().indexFromName(attributeName)
                ]  # make assumption that only one row
        except Exception:
            pass

        return None

    @staticmethod
    def getCPZWaitingTimeID(cpzNr):

        TOMsMessageLog.logMessage(
            "In getCPZWaitingTimeID. Looking for {}.".format(cpzNr), level=logging.DEBUG
        )

        try:
            cpzLayer = QgsProject.instance().mapLayersByName("CPZs")[0]
        except Exception:
            return None

        if cpzNr:

            query = "\"CPZ\" = '{}'".format(cpzNr)

            TOMsMessageLog.logMessage(
                "In getCPZWaitingTimeID. table: {}; query: {}".format(
                    cpzLayer.name(), str(query)
                ),
                level=logging.DEBUG,
            )

            try:
                row = next(cpzLayer.getFeatures(query))
            except Exception:
                return None

            TOMsMessageLog.logMessage(
                "In getCPZWaitingTimeID. Found CPZ.", level=logging.DEBUG
            )

            return row["TimePeriodID"]

        return None

    @staticmethod
    def getEDWaitingTimeID(edzNr):

        TOMsMessageLog.logMessage("In getEDWaitingTimeID", level=logging.DEBUG)

        try:
            edzLayer = QgsProject.instance().mapLayersByName("MatchDayEventDayZones")[0]
        except Exception:
            edzLayer = None

        if edzLayer:
            for poly in edzLayer.getFeatures():
                currentEDZ = poly.attribute("EDZ")

                if currentEDZ == edzNr:
                    TOMsMessageLog.logMessage(
                        "In getEDWaitingTimeID. Found EDZ.", level=logging.DEBUG
                    )
                    edzWaitingTimeID = poly.attribute("TimePeriodID")
                    # cpzMatchDayTimeID = poly.attribute("MatchDayTimePeriodID")
                    # return cpzWaitingTimeID, cpzMatchDayTimeID
                    TOMsMessageLog.logMessage(
                        "In getEDWaitingTimeID. ID. {}".format(edzWaitingTimeID),
                        level=logging.DEBUG,
                    )
                    return edzWaitingTimeID

        return None

    @staticmethod
    def getTariffZoneDetails(tpaNr):

        TOMsMessageLog.logMessage("In getTariffZoneDetails", level=logging.DEBUG)

        try:
            tpaLayer = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]
        except Exception:
            tpaLayer = None

        if tpaLayer:
            for poly in tpaLayer.getFeatures():
                currentPTA = poly.attribute("ParkingTariffArea")

                if currentPTA == tpaNr:
                    TOMsMessageLog.logMessage(
                        "In getTariffZoneDetails. Found PTA.", level=logging.DEBUG
                    )
                    ptaTimePeriodID = poly.attribute("TimePeriodID")
                    ptaMaxStayID = poly.attribute("MaxStayID")
                    ptaNoReturnID = poly.attribute("NoReturnID")
                    TOMsMessageLog.logMessage(
                        "In getTariffZoneMaxStayID. ID." + str(ptaMaxStayID),
                        level=logging.DEBUG,
                    )
                    return ptaTimePeriodID, ptaMaxStayID, ptaNoReturnID

        return None, None, None

    @staticmethod
    def findNearestPointOnLineLayer(searchPt, lineLayer, tolerance, geometryIDs=None):
        # TODO: re-organise - currently also in TOMsSnapTrace ....
        # given a point, find the nearest point (within the tolerance) within the line layer
        # returns QgsPoint
        TOMsMessageLog.logMessage(
            "In findNearestPointOnLineLayer. Checking lineLayer: {}: {}".format(
                lineLayer.name(), geometryIDs
            ),
            level=logging.DEBUG,
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
            TOMsMessageLog.logMessage(
                "In findNearestPointOnLineLayer: {}".format(feat.id()),
                level=logging.DEBUG,
            )
            if geometryIDs is not None:
                # print ('***** currGeometryID: {}; GeometryID: {}'.format(currGeometryID, f.attribute("GeometryID")))
                try:
                    testGeometryID = feat.attribute("GeometryID")
                except KeyError:
                    return (
                        None,
                        None,
                    )  # layer does not have "GeometryID" field, i.e., not restriction layer

                if testGeometryID in geometryIDs:
                    continue
            # Add any features that are found should be added to a list
            # print ('feature found: {}'.format(f.id()))
            closestPtOnFeature = feat.geometry().nearestPoint(
                QgsGeometry.fromPointXY(searchPt)
            )
            dist = feat.geometry().distance(QgsGeometry.fromPointXY(searchPt))
            if dist < shortestDistance:
                shortestDistance = dist
                closestPoint = closestPtOnFeature
                closestFeature = feat

        TOMsMessageLog.logMessage(
            "In findNearestPointOnLineLayer: shortestDistance: "
            + str(shortestDistance),
            level=logging.DEBUG,
        )

        if shortestDistance < float("inf"):
            # nearestPoint = QgsFeature()
            # add the geometry to the feature,
            # nearestPoint.setGeometry(QgsGeometry(closestPtOnFeature))
            return closestPoint, closestFeature  # returns a geometry
        return None, None

    @staticmethod
    def getLineOrientationAtPoint(point, lineFeature):
        TOMsMessageLog.logMessage("getLineOrientationAtPoint ...", level=logging.DEBUG)

        lineGeom = lineFeature.geometry()
        (
            _,
            closestPt,
            vertexNrAfterPt,
            _,
        ) = lineGeom.closestSegmentWithContext(point)
        orientationToFeature = GenerateGeometryUtils.checkDegrees(
            point.azimuth(QgsPointXY(closestPt))
        )
        orientationInFeatureDirection = GenerateGeometryUtils.checkDegrees(
            closestPt.azimuth(QgsPointXY(lineGeom.vertexAt(vertexNrAfterPt)))
        )
        # orientationAwayFromFeature = generateGeometryUtils.checkDegrees(orientationToFeature + 180.0)
        orientationAwayFromFeature = GenerateGeometryUtils.checkDegrees(
            orientationToFeature + 180.0
        )
        # orientationOppositeFeatureDirection = generateGeometryUtils.checkDegrees(orientationInFeatureDirection + 180)
        orientationOppositeFeatureDirection = GenerateGeometryUtils.checkDegrees(
            orientationInFeatureDirection + 180.0
        )

        # TODO: Include type 5 - defined Az

        orientationObliqueInFeatureDirection = (
            GenerateGeometryUtils.calcInteriorBisectAzimuth(
                orientationToFeature, orientationInFeatureDirection
            )
        )
        orientationObliqueOppositeFeatureDirection = (
            GenerateGeometryUtils.calcInteriorBisectAzimuth(
                orientationToFeature, orientationOppositeFeatureDirection
            )
        )

        TOMsMessageLog.logMessage(
            f"getLineOrientationAtPoint 1: {orientationToFeature}; 2: {orientationInFeatureDirection}; 3: "
            f"{orientationAwayFromFeature}; 4: {orientationOppositeFeatureDirection}",
            level=logging.DEBUG,
        )
        TOMsMessageLog.logMessage(
            f"getLineOrientationAtPoint 6: {orientationObliqueInFeatureDirection}; "
            f"7: {orientationObliqueOppositeFeatureDirection}",
            level=logging.DEBUG,
        )

        return (
            orientationToFeature,
            orientationInFeatureDirection,
            orientationAwayFromFeature,
            orientationOppositeFeatureDirection,
            orientationObliqueInFeatureDirection,
            orientationObliqueOppositeFeatureDirection,
        )

    @staticmethod
    def createLinewithPointAzimuthDistance(point, azimuth, distance):
        # azimuth in degrees
        otherPointGeom = QgsPointXY(
            point.x() + (float(distance) * math.sin(math.radians(azimuth))),
            point.y() + (float(distance) * math.cos(math.radians(azimuth))),
        )
        lineGeom = QgsGeometry.fromPolylineXY([point, otherPointGeom])
        return lineGeom

    @staticmethod
    def getSignOrientation(ptFeature, lineLayer):
        TOMsMessageLog.logMessage("In getSignOrientation ...", level=logging.DEBUG)
        try:
            signOrientation = ptFeature.attribute("SignOrientationTypeID")
        except KeyError:
            TOMsMessageLog.logMessage(
                "Attribute 'SignOrientationTypeID' not found", level=Qgis.Warning
            )
            return [None, None, None, None, None, None, None]

        try:
            signOriginalGeometry = ptFeature.attribute("original_geom_wkt")
        except KeyError:
            TOMsMessageLog.logMessage(
                "Attribute 'original_geom_wkt' not found", level=Qgis.Warning
            )
            return [None, None, None, None, None, None, None]

        TOMsMessageLog.logMessage(
            "In getSignOrientation - orientation: {}".format(signOrientation),
            level=logging.DEBUG,
        )
        TOMsMessageLog.logMessage(
            "In getSignOrientation - signOriginalGeometry: {}".format(
                signOriginalGeometry
            ),
            level=logging.DEBUG,
        )

        if signOrientation is None:
            TOMsMessageLog.logMessage("signOrientation is None", level=Qgis.Warning)
            return [None, None, None, None, None, None, None]

        # find closest point/feature on lineLayer

        # signPt = ptFeature.geometry().asPoint()
        signPt = QgsGeometry.fromWkt(signOriginalGeometry).asPoint()
        # print('signPt: {}'.format(signPt.asWkt()))
        # TOMsMessageLog.logMessage('getSignOrientation signPt: {}'.format(signPt.asWkt()), level=logging.DEBUG)
        TOMsMessageLog.logMessage(
            "In getSignOrientation lineLayer {}".format(lineLayer.name()),
            level=logging.DEBUG,
        )
        (
            closestPoint,
            closestFeature,
        ) = GenerateGeometryUtils.findNearestPointOnLineLayer(signPt, lineLayer, 25)

        # Now generate a line in the appropriate direction
        if closestPoint:
            TOMsMessageLog.logMessage(
                "In getSignOrientation closestPoint: {}".format(closestPoint.asWkt()),
                level=logging.DEBUG,
            )
            # get the orientation of the line feature
            (
                orientationToFeature,
                orientationInFeatureDirection,
                orientationAwayFromFeature,
                orientationOppositeFeatureDirection,
                orientationObliqueInFeatureDirection,
                orientationObliqueOppositeFeatureDirection,
            ) = GenerateGeometryUtils.getLineOrientationAtPoint(signPt, closestFeature)

            # make it match sign orientation
            return [
                0.0,
                orientationInFeatureDirection,
                orientationOppositeFeatureDirection,
                orientationToFeature,
                orientationAwayFromFeature,
                orientationObliqueInFeatureDirection,
                orientationObliqueOppositeFeatureDirection,
            ]

        TOMsMessageLog.logMessage("closestPoint not defined", level=Qgis.Warning)
        return [None, None, None, None, None, None, None]

    @staticmethod
    def getSignLine(ptFeature, lineLayer, distanceForIcons):

        try:
            signOrientation = ptFeature.attribute("SignOrientationTypeID")
        except KeyError:
            TOMsMessageLog.logMessage(
                "getSignLine - SignOrientationTypeID not found.",
                level=Qgis.Warning,
            )
            return None

        TOMsMessageLog.logMessage(
            "getSignLine - orientation: {}".format(signOrientation), level=logging.DEBUG
        )

        lineGeom = None
        if signOrientation is None:
            return None

        orientationList = GenerateGeometryUtils.getSignOrientation(ptFeature, lineLayer)

        # Now generate a line in the appropriate direction
        if orientationList[1]:
            # work out the length of the line based on the number of plates in the sign
            platesInSign = GenerateGeometryUtils.getPlatesInSign(ptFeature)
            nrPlatesInSign = len(platesInSign)
            TOMsMessageLog.logMessage(
                "getSignLine nrPlatesInSign: {}".format(nrPlatesInSign),
                level=logging.DEBUG,
            )
            # TODO work out scaling required for sign here
            lineLength = (nrPlatesInSign + 1) * distanceForIcons
            TOMsMessageLog.logMessage(
                "getSignLine lineLength: {}".format(lineLength), level=logging.DEBUG
            )
            # print('getSignLine lineLength: {}'.format(lineLength))

            signPt = ptFeature.geometry().asPoint()
            # generate lines
            if signOrientation == 1:  # "Facing in same direction as road"
                lineGeom = GenerateGeometryUtils.createLinewithPointAzimuthDistance(
                    signPt, orientationList[1], lineLength
                )
            elif signOrientation == 2:  # "Facing in opposite direction to road"
                lineGeom = GenerateGeometryUtils.createLinewithPointAzimuthDistance(
                    signPt, orientationList[2], lineLength
                )
            elif signOrientation == 3:  # "Facing road"
                lineGeom = GenerateGeometryUtils.createLinewithPointAzimuthDistance(
                    signPt, orientationList[3], lineLength
                )
            elif signOrientation == 4:  # "Facing away from road"
                lineGeom = GenerateGeometryUtils.createLinewithPointAzimuthDistance(
                    signPt, orientationList[4], lineLength
                )
                # TODO: Include type 5 - defined angle
            elif signOrientation == 6:  # "Facing oblique in same direction as road"
                lineGeom = GenerateGeometryUtils.createLinewithPointAzimuthDistance(
                    signPt, orientationList[5], lineLength
                )
            elif signOrientation == 7:  # "Facing oblique in opposite direction to road"
                lineGeom = GenerateGeometryUtils.createLinewithPointAzimuthDistance(
                    signPt, orientationList[6], lineLength
                )
            else:
                return None

        if lineGeom:
            TOMsMessageLog.logMessage(
                "getSignLine lineGeom: {}".format(lineGeom.asWkt()), level=logging.DEBUG
            )

        return lineGeom

    @staticmethod
    def getPlatesInSign(feature):
        TOMsMessageLog.logMessage("getNrPlatesInSign ...", level=logging.DEBUG)
        finished = False
        platesInSign = []
        nrPlatesInSign = 0
        while not finished:
            field = "SignType_{}".format(nrPlatesInSign + 1)
            try:
                plateType = feature.attribute(field)
            except KeyError:
                break
            if plateType is None or str(plateType) == "NULL":
                break
            platesInSign.append(plateType)
            nrPlatesInSign = nrPlatesInSign + 1
        return platesInSign

    @staticmethod
    def addPointsToSignLine(lineGeom, nrPts, distance):
        # add points to line at equal distance
        if lineGeom is None:
            return None
        newLinePts = []
        # add points along line for icons
        for i in range(1, nrPts + 1, 1):
            newPt = (lineGeom.interpolate(i * distance)).asPoint()
            newLinePts.append(newPt)

        return newLinePts

    @staticmethod
    def finalSignLine(feature):
        return GenerateGeometryUtils.getGeneratedSignLine(feature)

    @staticmethod
    def getGeneratedSignLine(feature):
        TOMsMessageLog.logMessage(
            "getGeneratedSignLine ... {}".format(feature.attribute("GeometryID")),
            level=logging.DEBUG,
        )
        roadCentreLineLayer = QgsProject.instance().mapLayersByName("RoadCentreLine")[0]
        try:
            distanceForIcons = float(
                QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable(
                    "distanceForIcons"
                )
            )
        except Exception:
            return None, None

        # distanceForIcons = 10
        # iconSize = 4
        # nrPlatesInSign = generateGeometryUtils.getNrPlatesInSign(feature)
        # print ('nrPlates: {}'.format(nrPlatesInSign))
        lineGeom = GenerateGeometryUtils.getSignLine(
            feature, roadCentreLineLayer, distanceForIcons
        )
        linePts = GenerateGeometryUtils.addPointsToSignLine(
            lineGeom,
            len(GenerateGeometryUtils.getPlatesInSign(feature)),
            distanceForIcons,
        )
        if lineGeom:
            TOMsMessageLog.logMessage(
                "getGeneratedSignLine: lineGeom: {}".format(lineGeom.asWkt()),
                level=logging.DEBUG,
            )
        else:
            TOMsMessageLog.logMessage(
                "getGeneratedSignLine: no geometry ...", level=logging.DEBUG
            )

        return lineGeom, linePts

    @staticmethod
    def getSignIcons(ptFeature):
        TOMsMessageLog.logMessage("getSignIcons ... ", level=logging.DEBUG)
        try:
            pathAbsolute = QgsExpressionContextUtils.projectScope(
                QgsProject.instance()
            ).variable("iconPath")
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getSignIcons: iconPath not found {}".format(e), level=Qgis.Warning
            )
            return None

        platesInSign = GenerateGeometryUtils.getPlatesInSign(ptFeature)
        plateIconsInSign = []
        signTypesLayer = QgsProject.instance().mapLayersByName("SignTypes")[0]
        for plateType in platesInSign:
            signTypeRow = GenerateGeometryUtils.getLookupRow(signTypesLayer, plateType)
            if signTypeRow:
                icon = signTypeRow["Icon"]
                TOMsMessageLog.logMessage(
                    "getSignIcons: icon {}".format(icon), level=logging.DEBUG
                )
                if not icon:
                    continue
                path = os.path.join(pathAbsolute, icon)
                plateIconsInSign.append(path)
        # TOMsMessageLog.logMessage('getSignIcons ... returning ... ', level=logging.DEBUG)
        return plateIconsInSign

    @staticmethod
    def getSignOrientationList(ptFeature):
        TOMsMessageLog.logMessage("getSignOrientationList ...", level=logging.DEBUG)
        try:
            roadCentreLineLayer = QgsProject.instance().mapLayersByName(
                "RoadCentreLine"
            )[0]
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getSignOrientationList: RoadCentreLine layer not found {}".format(e),
                level=Qgis.Warning,
            )
            return None

        orientationList = GenerateGeometryUtils.getSignOrientation(
            ptFeature, roadCentreLineLayer
        )

        if orientationList[1]:  # check that valid values have been returned
            # This list give the orientation for the way the line is pointing.
            # Now need to swap each through 180 to give true direction for arrows, etc
            # add extra value to match SignsOrientation values
            newOrientationList = [
                0,
                orientationList[2],  # "Facing in same direction as road" inverted is 2
                orientationList[
                    1
                ],  # "Facing in opposite direction to road" inverted is 1
                orientationList[4],  # "Facing road" inverted is 4
                orientationList[3],  # "Facing away from road" inverted is 3
                0,  # defined azimuth ...
                GenerateGeometryUtils.checkDegrees(
                    orientationList[5] + 180.0
                ),  # oblique in road direction
                GenerateGeometryUtils.checkDegrees(
                    orientationList[6] + 180.0
                ),  # oblique opposite road direction
            ]

            try:
                featureSignOrientation = ptFeature.attribute("SignOrientationTypeID")
            except KeyError:
                return None
            TOMsMessageLog.logMessage(
                "getSignOrientationList ...{}".format(
                    newOrientationList[featureSignOrientation]
                ),
                level=logging.DEBUG,
            )
            # return orientationList
            return newOrientationList[featureSignOrientation]

        return 0

    @staticmethod
    def getLookupRow(lookupLayer, code):
        query = "\"Code\" = '{}'".format(code)
        request = QgsFeatureRequest().setFilterExpression(query)
        for row in lookupLayer.getFeatures(request):
            return row  # make assumption that only one row
        return None
