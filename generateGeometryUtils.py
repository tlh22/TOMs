#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock 2017

import os.path
import sys
sys.path.append(os.path.dirname(os.path.realpath(__file__)))

from qgis.PyQt.QtWidgets import (
    QMessageBox
)

from TOMs.core.TOMsMessageLog import TOMsMessageLog
from qgis.core import (
    Qgis,
    QgsExpressionContextUtils,
    QgsMessageLog,
    QgsFeature,
    QgsGeometry, QgsGeometryUtils,
    QgsFeatureRequest,
    QgsPoint,
    QgsPointXY,
    QgsRectangle,
    QgsVectorLayer,
    QgsProject,
    QgsWkbTypes
)

# from qgis.core import *
# from qgis.gui import *
from qgis.utils import iface

#from TOMs.core.TOMsGeometryElement import ElementGeometryFactory

import math
from cmath import rect, phase

class generateGeometryUtils:
    # https://gis.stackexchange.com/questions/95528/produce-line-from-components-length-and-angle?noredirect=1&lq=1
    # direction cosines function

    @staticmethod
    def cosdir_azim(azim):
        az = math.radians(azim)
        cosa = math.sin(az)
        cosb = math.cos(az)
        return cosa, cosb

    def cosdir_azim_rad(az):
        # az = math.radians(azim)
        cosa = math.sin(az)
        cosb = math.cos(az)
        return cosa, cosb

    @staticmethod
    def turnToCL(Az1, Az2):
        # function to determine direction of turn to road centre    *** needs to be checked carefully ***
        # Az1 = Az of current line; Az2 = Az to roadCentreline
        # TOMsMessageLog.logMessage("In turnToCL Az1 = " + str(Az1) + " Az2 = " + str(Az2), level=Qgis.Info)

        AzCL = Az1 - 90.0
        if AzCL < 0:
            AzCL = AzCL + 360.0

        # TOMsMessageLog.logMessage("In turnToCL AzCL = " + str(AzCL), level=Qgis.Info)

        # Need to check quadrant

        if AzCL >= 0.0 and AzCL <= 90.0:
            if Az2 >= 270.0 and Az2 <= 359.999:
                AzCL = AzCL + 360
        elif Az2 >= 0 and Az2 <= 90:
            if AzCL >= 270.0 and AzCL <= 359.999:
                Az2 = Az2 + 360

        g = abs(float(AzCL) - float(Az2))

        # TOMsMessageLog.logMessage("In turnToCL Diff = " + str(g), level=Qgis.Info)

        if g < 90:
            Turn = -90
        else:
            Turn = 90

        # TOMsMessageLog.logMessage("In turnToCL Turn = " + str(Turn), level=Qgis.Info)

        return Turn

    @staticmethod
    def calcBisector(prevAz, currAz, Turn, WidthRest):
        # function to return Az of bisector

        # TOMsMessageLog.logMessage("In calcBisector", level=Qgis.Info)
        # TOMsMessageLog.logMessage("In calcBisector: prevAz: " + str(prevAz) + " currAz: " + str(currAz), level=Qgis.Info)

        prevAzA = generateGeometryUtils.checkDegrees(prevAz + float(Turn))
        currAzA = generateGeometryUtils.checkDegrees(currAz + float(Turn))

        # TOMsMessageLog.logMessage("In calcBisector: prevAzA: " + str(prevAzA) + " currAzA: " + str(currAzA), level=Qgis.Info)

        """
        if prevAz > 180:
            revPrevAz = prevAz - float(180)
        else:
            revPrevAz = prevAz + float(180)
        """

        # TOMsMessageLog.logMessage("In calcBisector: revPrevAz: " + str(revPrevAz), level=Qgis.Info)

        diffAz = prevAzA - currAzA

        # TOMsMessageLog.logMessage("In calcBisector: diffAz: " + str(diffAz), level=Qgis.Info)

        diffAngle = diffAz / float(2)
        bisectAz = prevAzA - diffAngle

        diffAngle_rad = math.radians(diffAngle)
        # TOMsMessageLog.logMessage("In calcBisector: diffAngle: " + str(diffAngle) + " diffAngle_rad: " + str(diffAngle_rad), level=Qgis.Info)
        distToPt = float(WidthRest) / math.cos(diffAngle_rad)

        # TOMsMessageLog.logMessage("In generate_display_geometry: bisectAz: " + str(bisectAz) + " distToPt:" + str(distToPt), level=Qgis.Info)

        return bisectAz, distToPt

    @staticmethod
    def checkDegrees(Az):
        """newAz = Az

        if Az >= float(360):
            newAz = Az - float(360)
        elif Az < float(0):
            newAz = Az + float(360)
        TOMsMessageLog.logMessage("In checkDegrees (1): newAz: " + str(newAz), level=Qgis.Info)"""

        newAz = math.degrees(QgsGeometryUtils().normalizedAngle(math.radians(Az)))

        #TOMsMessageLog.logMessage("In checkDegrees (2): newAz: " + str(newAz), level=Qgis.Info)

        return newAz

    @staticmethod
    def setRoadName(feature):

        newRoadName, newUSRN = generateGeometryUtils.determineRoadName(feature)
        # now set the attributes
        if newRoadName:
            feature.setAttribute("RoadName", newRoadName)
            feature.setAttribute("USRN", newUSRN)

            # feature.setAttribute("AzimuthToRoadCentreLine", int(generateGeometryUtils.calculateAzimuthToRoadCentreLine(feature)))

    @staticmethod
    def determineRoadName(feature):

        TOMsMessageLog.logMessage("In setRoadName(helper):", level=Qgis.Info)
        TOMsMessageLog.logMessage("In setRoadName(helper)2:", level=Qgis.Info)

        RoadCasementLayer = QgsProject.instance().mapLayersByName("RoadCasement")[0]

        # take the first point from the geometry
        TOMsMessageLog.logMessage("In setRoadName: {}".format(feature.geometry().asWkt()), level=Qgis.Info)

        """line = generateGeometryUtils.getLineForAz(feature)

        if len(line) == 0:
            return 0

        testPt = line[
            0]
        """
        geom = feature.geometry()
        # line = QgsGeometry()

        tolerance_nearby = 5.0  # somehow need to have this (and layer names) as global variables

        if geom:
            if geom.type() == QgsWkbTypes.LineGeometry:
                TOMsMessageLog.logMessage("In setRoadName(helper): considering line", level=Qgis.Info)
                line = generateGeometryUtils.getLineForAz(feature)

                if len(line) == 0:
                    return None, None

                testPt = line[0]
                #ptList = feature.geometry().asPolyline()
                #secondPt = ptList[0]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

            elif geom.type() == QgsWkbTypes.PointGeometry: # Point
                TOMsMessageLog.logMessage("In setRoadName(helper): considering point", level=Qgis.Info)
                testPt = feature.geometry().asPoint()

                #tolerance_nearby = 5.0

            elif feature.geometry().type() == QgsWkbTypes.PolygonGeometry: # Polygon
                TOMsMessageLog.logMessage("In setRoadName(helper): considering polygon", level=Qgis.Info)
                ptList = feature.geometry().asPolygon()[0]
                testPt = ptList[
                    0]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

        else:
            TOMsMessageLog.logMessage("In setRoadName: unknown geometry type", level=Qgis.Info)
            return

        #nrPts = len(ptList)
        #TOMsMessageLog.logMessage("In setRoadName: number of pts in list: " + str(nrPts), level=Qgis.Info)

        TOMsMessageLog.logMessage("In setRoadName: secondPt: " + str(testPt.x()), level=Qgis.Info)

        # check for the feature within RoadCasement_NSG_RoadName layer
        #tolerance_nearby = 1.0  # somehow need to have this (and layer names) as global variables

        nearestRC_feature = generateGeometryUtils.findFeatureAt2(feature, testPt, RoadCasementLayer,
                                                                tolerance_nearby)

        if nearestRC_feature:
            # TOMsMessageLog.logMessage("In setRoadName: nearestRC_feature: " + nearestRC_feature.geometry().asWkt(), level=Qgis.Info)

            idx_RoadName = RoadCasementLayer.fields().indexFromName('RoadName')
            idx_USRN = RoadCasementLayer.fields().indexFromName('USRN')

            RoadName = nearestRC_feature.attributes()[idx_RoadName]
            USRN = nearestRC_feature.attributes()[idx_USRN]

            TOMsMessageLog.logMessage("In setRoadName: RoadName: " + str(RoadName), level=Qgis.Info)

            return RoadName, USRN

        else:
            return None, None

        pass

    @staticmethod
    def setAzimuthToRoadCentreLine(feature):

        # now set the attribute
        feature.setAttribute("AzimuthToRoadCentreLine",
                             int(generateGeometryUtils.calculateAzimuthToRoadCentreLine(feature)))

    @staticmethod
    def getLineForAz(feature):
        # gets a single "line" (array of points) from the current feature. Checks for:
        # - existence of geoemtry
        # - whether or not it is multi-part

        #TOMsMessageLog.logMessage("In getLineForAz(helper):", level=Qgis.Info)

        geom = feature.geometry()
        # line = QgsGeometry()

        if geom:
            if geom.type() == QgsWkbTypes.LineGeometry:
                if geom.isMultipart():
                    lines = geom.asMultiPolyline()
                    nrLines = len(lines)

                    #TOMsMessageLog.logMessage("In getLineForAz(helper):  geometry: " + feature.geometry().asWkt()  + " - NrLines = " + str(nrLines), level=Qgis.Info)

                    # take the first line as the one we are interested in
                    if nrLines > 0:
                        line = lines[0]
                    else:
                        return 0
                    """for idxLine in range(nrLines):
                        line = lines[idxLine]"""

                else:
                    line = feature.geometry().asPolyline()

                # Now return the array
                return line

            else:
                TOMsMessageLog.logMessage("In getLineForAz(helper): Incorrect geometry found", level=Qgis.Info)
                return None

        else:
            TOMsMessageLog.logMessage("In getLineForAz(helper): geometry not found", level=Qgis.Info)
            return None

    @staticmethod
    def calculateAzimuthToRoadCentreLine(feature):
        # find the shortest line from this point to the road centre line layer
        # http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/ - generates "closest feature" function

        TOMsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper):", level=Qgis.Info)

        RoadCentreLineLayer = QgsProject.instance().mapLayersByName("RoadCentreLine")[0]

        """if feature.geometry():
            geom = feature.geometry()
        else:
            TOMsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper): geometry not found", level=Qgis.Info)
            return 0"""

        # take the a point from the geometry
        # line = feature.geometry().asPolyline()
        line = generateGeometryUtils.getLineForAz(feature)

        if len(line) == 0:
            return 0

        # Get the mid point of the line - https://gis.stackexchange.com/questions/58079/finding-middle-point-midpoint-of-line-in-qgis

        testPt = feature.geometry().centroid().asPoint()        #lineGeom = QgsGeometry.fromPolyline((line[::])
        #lineLength = lineGeom.length()
        #TOMsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper): lineLength: " + str(lineLength), level=Qgis.Info)
        #testPt = lineGeom.interpolate(lineLength / 2.0)
        #testPt = line[0]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

        #TOMsMessageLog.logMessage("In setAzimuthToRoadCentreLine: secondPt: " + str(testPt.x()), level=Qgis.Info)

        # Find all Road Centre Line features within a "reasonable" distance and then check each one to find the shortest distance

        tolerance_roadwidth = 25
        searchRect = QgsRectangle(testPt.x() - tolerance_roadwidth,
                                  testPt.y() - tolerance_roadwidth,
                                  testPt.x() + tolerance_roadwidth,
                                  testPt.y() + tolerance_roadwidth)

        request = QgsFeatureRequest()
        request.setFilterRect(searchRect)
        request.setFlags(QgsFeatureRequest.ExactIntersect)

        shortestDistance = float("inf")
        featureFound = False

        # Loop through all features in the layer to find the closest feature
        for f in RoadCentreLineLayer.getFeatures(request):
            dist = f.geometry().distance(QgsGeometry.fromPointXY(testPt))
            if dist < shortestDistance:
                shortestDistance = dist
                closestFeature = f
                featureFound = True

        TOMsMessageLog.logMessage("In calculateAzimuthToRoadCentreLine: shortestDistance: " + str(shortestDistance), level=Qgis.Info)

        if featureFound:
            # now obtain the line between the testPt and the nearest feature
            # f_lineToCL = closestFeature.geometry().shortestLine(QgsGeometry.fromPointXY(testPt))
            startPt = QgsPoint(QgsGeometry.asPoint(closestFeature.geometry().nearestPoint(QgsGeometry.fromPointXY(testPt))))

            # get the start point (we know the end point)
            """startPtV2 = f_lineToCL.geometry().startPoint()
            startPt = QgsPoint()
            startPt.setX(startPtV2.x())
            startPt.setY(startPtV2.y())"""

            TOMsMessageLog.logMessage("In calculateAzimuthToRoadCentreLine: startPoint: " + str(startPt.x()),
                                     level=Qgis.Info)

            Az = generateGeometryUtils.checkDegrees(QgsPoint(testPt).azimuth(startPt))

            # Az = generateGeometryUtils.checkDegrees(testPt.azimuth(startPt))
            # TOMsMessageLog.logMessage("In calculateAzimuthToRoadCentreLine: Az: " + str(Az), level=Qgis.Info)

            return Az
        else:
            return 0

    @staticmethod
    def findFeatureAt2(feature, layerPt, layer, tolerance):
        # def findFeatureAt(self, pos, excludeFeature=None):
        """ Find the feature close to the given position.

            'layerPt' is the position to check, in layer coordinates.
            'layer' is specified layer
            'tolerance' is search distance in layer units

            If no feature is close to the given coordinate, we return None.
        """

        TOMsMessageLog.logMessage("In findFeatureAt2. Incoming layer: " + str(layer) + "tol: " + str(tolerance), level=Qgis.Info)

        searchRect = QgsRectangle(layerPt.x() - tolerance,
                                  layerPt.y() - tolerance,
                                  layerPt.x() + tolerance,
                                  layerPt.y() + tolerance)

        request = QgsFeatureRequest()
        request.setFilterRect(searchRect)
        request.setFlags(QgsFeatureRequest.ExactIntersect)

        for feature in layer.getFeatures(request):
            TOMsMessageLog.logMessage("In findFeatureAt2. feature found", level=Qgis.Info)
            return feature  # Return first matching feature.

        return None

    @staticmethod
    def getReverseAzimuth(Az):
        if (Az + 180) > 360:
            AzimuthToCentreLine = Az - 180
        else:
            AzimuthToCentreLine = Az + 180
        return AzimuthToCentreLine

        """
        @staticmethod
        def checkFeatureIsBay(restGeomType):
            TOMsMessageLog.logMessage("In checkFeatureIsBay: restGeomType = " + str(restGeomType), level=Qgis.Info)
            if restGeomType < 10 or (restGeomType >=20 and restGeomType < 30):
                return True
            else:
                return False
        """

    @staticmethod
    def getDisplayGeometry(feature, restGeomType, offset, shpExtent, orientation, AzimuthToCentreLine):
        # Obtain relevant variables
        #TOMsMessageLog.logMessage("In getDisplayGeometry: restGeomType = " + str(restGeomType), level=Qgis.Info)

        # Need to check why the project variable function is not working

        restrictionID = feature.attribute("GeometryID")
        TOMsMessageLog.logMessage("In getDisplayGeometry: New restriction .................................................................... ID: " + str(restrictionID), level=Qgis.Info)
        # restGeomType = feature.attribute("GeomShapeID")
        #AzimuthToCentreLine = float(feature.attribute("AzimuthToRoadCentreLine"))
        #TOMsMessageLog.logMessage("In getDisplayGeometry: Az: " + str(AzimuthToCentreLine), tag = "TOMs panel")

        # Need to check feature class. If it is a bay, obtain the number
        # nrBays = feature.attribute("nrBays")

        """
        Within expression areas use:    generate_display_geometry(   "RestrictionTypeID" , "GeomTypeID",  "AzimuthToRoadCentreLine",  @BayOffsetFromKerb ,  @BayWidth )

        Logic is :

        For vertex 0,
            Move for defined distance (typically 0.25m) in direction "AzimuthToCentreLine" and create point 1
            Move for bay width (typically 2.0m) in direction "AzimuthToCentreLine and create point 2
            Calculate Azimuth for line between vertex 0 and vertex 1
            Calc difference in Azimuths and decide < or > 180 (to indicate which side of kerb line to generate bay)

        For each vertex (starting at 1)
            Calculate Azimuth for current vertex and previous
            Calculate perpendicular to centre of road (using knowledge of which side of kerb line generated above)
            Move for bay width (typically 2.0m) along perpendicular and create point 

        For last vertex
                Move for defined distance (typically 0.25m) along perpendicular and create last point
        """

        line = generateGeometryUtils.getLineForAz(feature)

        # TOMsMessageLog.logMessage("In getDisplayGeometry:  nr of pts = " + str(len(line)), level=Qgis.Info)

        if len(line) == 0:
            return 0

        # Now have a valid set of points

        # TOMsMessageLog.logMessage("In getDisplayGeometry:  Now processing line", level=Qgis.Info)

        ptsList = []
        parallelPtsList = []
        nextAz = 0
        diffEchelonAz = 0

        # now loop through each of the vertices and process as required. New geometry points are added to ptsList

        for i in range(len(line) - 1):

            # TOMsMessageLog.logMessage("In getDisplayGeometry: i = " + str(i), level=Qgis.Info)

            Az = line[i].azimuth(line[i + 1])

            # TOMsMessageLog.logMessage("In getDisplayGeometry: geometry: " + str(line[i].x()) + " " + str(line[i+1].x()) + " " + str(Az), level=Qgis.Info)

            # if this is the first point

            if i == 0:
                # determine which way to turn towards CL
                # TOMsMessageLog.logMessage("In generate_display_geometry: considering first point", level=Qgis.Info)

                Turn = generateGeometryUtils.turnToCL(Az, AzimuthToCentreLine)

                newAz = Az + Turn
                # TOMsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), level=Qgis.Info)
                cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)

                # TOMsMessageLog.logMessage("In generate_display_geometry: cosa : " + str(cosa) + " " + str(cosb), level=Qgis.Info)

                # dx = float(offset) * cosa
                # dy = float(offset) * cosb

                # TOMsMessageLog.logMessage("In generate_display_geometry: dx: " + str(dx) + " dy: " + str(dy), level=Qgis.Info)

                ptsList.append(
                    QgsPoint(line[i].x() + (float(offset) * cosa), line[i].y() + (float(offset) * cosb)))
                # TOMsMessageLog.logMessage("In geomType: added point 1 ", level=Qgis.Info)

                # Now add the point at the extent. If it is an echelon bay:
                #   a. calculate the difference between the first Az and the echelon Az (??), and
                #   b. adjust the angle
                #   c. *** also need to adjust the length *** Not yet implemented

                #if restGeomType == 5 or restGeomType == 25:  # echelon
                if restGeomType in [5, 25]:  # echelon
                    TOMsMessageLog.logMessage("In geomType: orientation: " + str(orientation), level=Qgis.Info)
                    diffEchelonAz = generateGeometryUtils.checkDegrees(orientation - newAz)
                    newAz = Az + Turn + diffEchelonAz
                    TOMsMessageLog.logMessage("In geomType: newAz: " + str(newAz) + " diffEchelonAz: " + str(diffEchelonAz), level=Qgis.Info)
                    cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)
                    pass

                ptsList.append(
                    QgsPoint(line[i].x() + (float(shpExtent) * cosa),
                             line[i].y() + (float(shpExtent) * cosb)))
                # TOMsMessageLog.logMessage("In geomType: added point 2 ", level=Qgis.Info)

                # ptsList.append(newPoint)
                # TOMsMessageLog.logMessage("In geomType: after append ", level=Qgis.Info)

                # ptsList.append(QgsPoint(line[i].x()+(float(bayWidth)*cosa), line[i].y()+(float(bayWidth)*cosb)))

            else:

                # now pass along the feature

                # TOMsMessageLog.logMessage("In generate_display_geometry: considering point: " + str(i), level=Qgis.Info)

                # need to work out half of bisected angle

                # TOMsMessageLog.logMessage("In generate_display_geometry: prevAz: " + str(prevAz) + " currAz: " + str(Az), level=Qgis.Info)

                newAz, distWidth = generateGeometryUtils.calcBisector(prevAz, Az, Turn, shpExtent)

                cosa, cosb = generateGeometryUtils.cosdir_azim(newAz + diffEchelonAz)
                ptsList.append(
                    QgsPoint(line[i].x() + (float(distWidth) * cosa), line[i].y() + (float(distWidth) * cosb)))

                parallelPtsList.append(
                    QgsPoint(line[i].x() + (float(distWidth) * cosa), line[i].y() + (float(distWidth) * cosb)))

            # TOMsMessageLog.logMessage("In generate_display_geometry: point appended", level=Qgis.Info)

            prevAz = Az

        # TOMsMessageLog.logMessage("In generate_display_geometry: newPoint 1: " + str(ptsList[1].x()) + " " + str(ptsList[1].y()), level=Qgis.Info)

        # have reached the end of the feature. Now need to deal with last point.
        # Use Azimuth from last segment but change the points

        # TOMsMessageLog.logMessage("In generate_display_geometry: feature processed. Now at last point ", level=Qgis.Info)

       # standard bay
        newAz = Az + Turn + diffEchelonAz
        # TOMsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), level=Qgis.Info)
        cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)

        ptsList.append(QgsPoint(line[len(line) - 1].x() + (float(shpExtent) * cosa),
                                line[len(line) - 1].y() + (float(shpExtent) * cosb)))

        # add end point (without any consideration of Echelon)

        newAz = Az + Turn
        cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)

        ptsList.append(QgsPoint(line[len(line) - 1].x() + (float(offset) * cosa),
                                line[len(line) - 1].y() + (float(offset) * cosb)))

        newLine = QgsGeometry.fromPolyline(ptsList)
        parallelLine = QgsGeometry.fromPolyline(parallelPtsList)

        #TOMsMessageLog.logMessage("In getDisplayGeometry:  newGeometry ********: " + newLine.asWkt(), level=Qgis.Info)


        return newLine, parallelPtsList

    @staticmethod
    def zigzag(feature, wavelength, amplitude, restGeometryType, offset, shpExtent, orientation, AzimuthToCentreLine):
        """
            Taken from: https://www.google.fr/url?sa=t&rct=j&q=&esrc=s&source=web&cd=8&cad=rja&uact=8&ved=0ahUKEwi06c6nkMzWAhWCwxoKHWHMC34QFghEMAc&url=http%3A%2F%2Fwww.geoinformations.developpement-durable.gouv.fr%2Ffichier%2Fodt%2Fgenerateur_de_zigzag_v1_cle0d3366.odt%3Farg%3D177834503%26cle%3Df6f59e5a812d5c3e7a829f05497213f839936080%26file%3Dodt%252Fgenerateur_de_zigzag_v1_cle0d3366.odt&usg=AOvVaw0JoVM0llmrvSCdxOEaGCOH
            www.geoinformations.developpement-durable.gouv.fr

           transforme une geometrie lineaire en zigzag
           <h4>Syntax</h4>
           <pre>zigzag(geom, longueur, amplitude)</pre>

           <h4>Exemple</h4>
           zigzag($geometry,200,100)

        """

        TOMsMessageLog.logMessage("In zigzag", level=Qgis.Info)

        line, parallelLine = generateGeometryUtils.getDisplayGeometry(feature, restGeometryType, offset, shpExtent, orientation, AzimuthToCentreLine)

        #TOMsMessageLog.logMessage("In zigzag - have geometry + " + line.asWkt(), level=Qgis.Info)

        length = line.length()
        #TOMsMessageLog.logMessage(
        #    "In zigzag - have geometry. Length = " + str(length) + " wavelength: " + str(wavelength),
        #    level=Qgis.Info)

        segments = int(length / wavelength)
        # Find equally spaced points that approximate the line
        #TOMsMessageLog.logMessage("In zigzag - have geometry. segments = " + str(segments), level=Qgis.Info)

        points = []
        countSegments = 0
        while countSegments <= segments:
            # TOMsMessageLog.logMessage("In zigzag - countSegment = " + str(countSegments), level=Qgis.Info)
            interpolateDistance = int(countSegments * int(wavelength))
            # TOMsMessageLog.logMessage("In zigzag - interpolateDistance = " + str(interpolateDistance), level=Qgis.Info)
            points.append(line.interpolate(float(interpolateDistance)).asPoint())
            # TOMsMessageLog.logMessage("In zigzag - added Point", level=Qgis.Info)
            countSegments = countSegments + 1

        #TOMsMessageLog.logMessage("In zigzag - have points: nrPts = " + str(len(points)), level=Qgis.Info)

        # Calculate the azimuths of the approximating line segments

        azimuths = []

        for i in range(len(points) - 1):
            # TOMsMessageLog.logMessage("In zigzag - creating Az: i = " + str(i), level=Qgis.Info)
            azimuths.append((points[i].azimuth(points[i + 1])))

        #TOMsMessageLog.logMessage("In zigzag - after azimuths: i " + str(i) + " len(az): " + str(len(azimuths)),
        #                         level=Qgis.Info)

        # Average consecutive azimuths and rotate 90 deg counterclockwise

        # newAz, distWidth = generateGeometryUtils.calcBisector(prevAz, Az, Turn, shpExtent)

        zigzagazimuths = [azimuths[0] - math.pi / 2]
        zigzagazimuths.extend([generateGeometryUtils.meanAngle(azimuths[i], azimuths[i - 1]) - math.pi / 2 for i in
                               range(len(points) - 1)])
        zigzagazimuths.append(azimuths[-1] - math.pi / 2)

        #TOMsMessageLog.logMessage("In zigzag - about to create shape", level=Qgis.Info)

        cosa = 0.0
        cosb = 0.0

        # Offset the points along the zigzagazimuths
        zigzagpoints = []
        for i in range(len(points) - 1):
            # Alternate the sign

            #TOMsMessageLog.logMessage("In zigzag - sign: " + str(i - 2 * math.floor(i / 2)), level=Qgis.Info)

            # currX = points[i].x()
            # currY = points[i].y()

            dst = amplitude * 1 - 2 * (i - 2 * math.floor(
                i / 2))  # b = a - m.*floor(a./m)  is the same as   b = mod( a , m )      Thus: i - 2 * math.floor(i/2)
            #TOMsMessageLog.logMessage("In zigzag - dst: " + str(dst) + " Az: " + str(azimuths[i]), level=Qgis.Info)

            # currAz = zigzagazimuths[i]
            cosa, cosb = generateGeometryUtils.cosdir_azim(azimuths[i])

            #TOMsMessageLog.logMessage("In zigzag - cosa: " + str(cosa), level=Qgis.Info)

            zigzagpoints.append(
                QgsPoint(points[i].x() + (float(offset) * cosa), points[i].y() + (float(offset) * cosb)))

            #TOMsMessageLog.logMessage("In zigzag - point added: " + str(i), level=Qgis.Info)
            # zigzagpoints.append(QgsPoint(points[i][0] + math.sin(zigzagazimuths[i]) * dst, points[i][1] + math.cos(zigzagazimuths[i]) * dst))

        # Create new feature from the list of zigzag points
        gLine = QgsGeometry.fromPolyline(zigzagpoints)

        #TOMsMessageLog.logMessage("In zigzag - shape created", level=Qgis.Info)

        return gLine

    @staticmethod
    def meanAngle(a1, a2):
        return phase((rect(1, a1) + rect(1, a2)) / 2.0)

    @staticmethod
    def generateWaitingLabelLeader(feature):

        #TOMsMessageLog.logMessage("In generateWaitingLabelLeader", level=Qgis.Info)
        # check to see scale

        minScale = float(generateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        #TOMsMessageLog.logMessage("In generateLabelLeader. Current scale: " + str(currScale) + " min scale: " + str(minScale), level=Qgis.Info)

        if currScale <= minScale:

            if feature.attribute("label_X"):
                #TOMsMessageLog.logMessage(
                #    "In generateLabelLeader. label_X set for " + str(feature.attribute("GeometryID")), level=Qgis.Info)

                # now generate line
                length = feature.geometry().length()
                return QgsGeometry.fromPolyline([QgsPoint(feature.geometry().interpolate(length/2.0).asPoint()), QgsPoint(feature.attribute("label_X"), feature.attribute("label_Y"))])

            pass

        pass

        return None

    @staticmethod
    def generateLoadingLabelLeader(feature):

        #TOMsMessageLog.logMessage("In generateLoadingLabelLeader", level=Qgis.Info)
        # check to see scale

        minScale = float(generateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        #TOMsMessageLog.logMessage("In generateLabelLeader. Current scale: " + str(currScale) + " min scale: " + str(minScale), level=Qgis.Info)

        if currScale <= minScale:

            if feature.attribute("labelLoading_X"):
                #TOMsMessageLog.logMessage(
                #    "In generateLabelLeader. label_X set for " + str(feature.attribute("GeometryID")), level=Qgis.Info)

                # now generate line
                length = feature.geometry().length()
                return QgsGeometry.fromPolyline([QgsPoint(feature.geometry().interpolate(length/2.0).asPoint()), QgsPoint(feature.attribute("labelLoading_X"), feature.attribute("labelLoading_Y"))])

            pass

        pass

        return None

    @staticmethod
    def generateBayLabelLeader(feature):

        #TOMsMessageLog.logMessage("In generateBayLabelLeader", level=Qgis.Info)
        # check to see scale

        minScale = float(generateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        TOMsMessageLog.logMessage("In generateBayLabelLeader. Current scale: " + str(currScale) + " min scale: " + str(minScale), level=Qgis.Info)

        if currScale <= minScale:

            if feature.attribute("label_X"):

                length = feature.geometry().length()
                TOMsMessageLog.logMessage(
                    "In generateBayLabelLeader. label_X set for " + str(feature.attribute("GeometryID")), level=Qgis.Info)

                return QgsGeometry.fromPolyline([QgsPoint(feature.geometry().interpolate(length/2.0).asPoint()), QgsPoint(feature.attribute("label_X"), feature.attribute("label_Y"))])

        return None

    @staticmethod
    def generatePolygonLabelLeader(feature):

        #TOMsMessageLog.logMessage("In generateBayLabelLeader", level=Qgis.Info)
        # check to see scale

        minScale = float(generateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        #TOMsMessageLog.logMessage("In generateLabelLeader. Current scale: " + str(currScale) + " min scale: " + str(minScale), level=Qgis.Info)

        if currScale <= minScale:

            if feature.attribute("label_X"):
                TOMsMessageLog.logMessage(
                    "In generatePolygonLabelLeader. label_X set for " + str(feature.attribute("GeometryID")), level=Qgis.Info)

                pt = feature.geometry().nearestPoint()

                # now generate line
                return QgsGeometry.fromPolyline([QgsPoint(feature.geometry().nearestPoint().asPoint()), QgsPoint(feature.attribute("label_X"), feature.attribute("label_Y"))])

        return None

    @staticmethod
    def getMininumScaleForDisplay():

        minScale = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('MinimumTextDisplayScale')

        TOMsMessageLog.logMessage("In getMininumScaleForDisplay. minScale(1): " + str(minScale), level=Qgis.Info)

        if minScale == None:
            minScale = 1250

        return minScale

    @staticmethod
    def getWaitingLoadingRestrictionLabelText(feature):

        TOMsMessageLog.logMessage("In getWaitingLoadingRestrictionLabelText", level=Qgis.Info)

        minScale = float(generateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        if currScale > minScale:
            return None, None

        waitingTimeID = feature.attribute("NoWaitingTimeID")
        loadingTimeID = feature.attribute("NoLoadingTimeID")
        GeometryID = feature.attribute("GeometryID")

        TimePeriodsLayer = QgsProject.instance().mapLayersByName("TimePeriods")[0]

        waitDesc = generateGeometryUtils.getLookupLabelText(TimePeriodsLayer, waitingTimeID)
        loadDesc = generateGeometryUtils.getLookupLabelText(TimePeriodsLayer, loadingTimeID)

        TOMsMessageLog.logMessage("In getWaitingLoadingRestrictionLabelText(1): waiting: " + str(waitDesc) + " loading: " + str(loadDesc), level=Qgis.Info)

        restrictionCPZ = feature.attribute("CPZ")
        CPZWaitingTimeID = generateGeometryUtils.getCPZWaitingTimeID(restrictionCPZ)

        """TOMsMessageLog.logMessage(
            "In getWaitingLoadingRestrictionLabelText (" + GeometryID + "): " + str(CPZWaitingTimeID) + "; " + str(waitingTimeID) + "; " + str(loadingTimeID),
            level=Qgis.Info)"""

        if CPZWaitingTimeID:
            #TOMsMessageLog.logMessage("In getWaitingLoadingRestrictionLabelText: " + str(CPZWaitingTimeID) + " " + str(waitingTimeID),
            #                         level=Qgis.Info)
            if CPZWaitingTimeID == waitingTimeID:
                waitDesc = None

        TOMsMessageLog.logMessage("In getWaitingLoadingRestrictionLabelText(" + GeometryID + "): waiting: " + str(waitDesc) + " loading: " + str(loadDesc), level=Qgis.Info)
        return waitDesc, loadDesc

    @staticmethod
    def getBayRestrictionLabelText(feature):

        minScale = float(generateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        if currScale > minScale:
            return None, None, None

        maxStayID = feature.attribute("MaxStayID")
        noReturnID = feature.attribute("NoReturnID")
        timePeriodID = feature.attribute("TimePeriodID")

        lengthOfTimeLayer = QgsProject.instance().mapLayersByName("LengthOfTime")[0]

        TimePeriodsLayer = QgsProject.instance().mapLayersByName("TimePeriodsInUse_View")[0]

        TOMsMessageLog.logMessage("In getBayRestrictionLabelText (2)" + feature.attribute("GeometryID"), level=Qgis.Info)

        maxStayDesc = generateGeometryUtils.getLookupLabelText(lengthOfTimeLayer, maxStayID)
        noReturnDesc = generateGeometryUtils.getLookupLabelText(lengthOfTimeLayer, noReturnID)
        timePeriodDesc = generateGeometryUtils.getLookupLabelText(TimePeriodsLayer, timePeriodID)

        TOMsMessageLog.logMessage("In getBayRestrictionLabelText. maxStay: " + str(maxStayDesc), level=Qgis.Info)

        restrictionCPZ = feature.attribute("CPZ")
        restrictionPTA = feature.attribute("ParkingTariffArea")

        CPZWaitingTimeID = generateGeometryUtils.getCPZWaitingTimeID(restrictionCPZ)
        TariffZoneTimePeriodID, TariffZoneMaxStayID, TariffZoneNoReturnID = generateGeometryUtils.getTariffZoneDetails(restrictionPTA)

        TOMsMessageLog.logMessage(
            "In getBayRestrictionLabelText (1): " + str(CPZWaitingTimeID) + " PTA hours: " + str(TariffZoneTimePeriodID),
            level=Qgis.Info)
        TOMsMessageLog.logMessage("In getBayRestrictionLabelText. bay hours: " + str(timePeriodID), level=Qgis.Info)

        if timePeriodID == 1:  # 'At Any Time'
            timePeriodDesc = None

        if CPZWaitingTimeID:
            TOMsMessageLog.logMessage("In getBayRestrictionLabelText: " + str(CPZWaitingTimeID) + " " + str(timePeriodID),
                                     level=Qgis.Info)
            if CPZWaitingTimeID == timePeriodID:
                timePeriodDesc = None

        if TariffZoneTimePeriodID == timePeriodID:
            timePeriodDesc = None

        if TariffZoneMaxStayID:
            """TOMsMessageLog.logMessage("In getBayRestrictionLabelText: " + str(TariffZoneMaxStayID) + " " + str(maxStayID),
                                     level=Qgis.Info)"""
            if TariffZoneMaxStayID == maxStayID:
                maxStayDesc = None

        if TariffZoneNoReturnID:
            """TOMsMessageLog.logMessage("In getBayRestrictionLabelText: " + str(TariffZoneNoReturnID) + " " + str(noReturnID),
                                     level=Qgis.Info)"""
            if TariffZoneNoReturnID == noReturnID:
                noReturnDesc = None

        TOMsMessageLog.logMessage("In getBayRestrictionLabelText. timePeriodDesc (2): " + str(timePeriodDesc), level=Qgis.Info)

        return maxStayDesc, noReturnDesc, timePeriodDesc

    @staticmethod
    def getLookupDescription(lookupLayer, code):

        #TOMsMessageLog.logMessage("In getLookupDescription", level=Qgis.Info)

        query = "\"Code\" = " + str(code)
        request = QgsFeatureRequest().setFilterExpression(query)

        #TOMsMessageLog.logMessage("In getLookupDescription. queryStatus: " + str(query), level=Qgis.Info)

        for row in lookupLayer.getFeatures(request):
            #TOMsMessageLog.logMessage("In getLookupDescription: found row " + str(row.attribute("Description")), level=Qgis.Info)
            return row.attribute("Description") # make assumption that only one row

        return None

    @staticmethod
    def getLookupLabelText(lookupLayer, code):

        #TOMsMessageLog.logMessage("In getLookupLabelText", level=Qgis.Info)

        query = "\"Code\" = " + str(code)
        request = QgsFeatureRequest().setFilterExpression(query)

        #TOMsMessageLog.logMessage("In getLookupLabelText. queryStatus: " + str(query), level=Qgis.Info)

        for row in lookupLayer.getFeatures(request):
            #TOMsMessageLog.logMessage("In getLookupLabelText: found row " + str(row.attribute("LabelText")), level=Qgis.Info)
            return row.attribute("LabelText") # make assumption that only one row

        return None

    @staticmethod
    def getCurrentCPZDetails(feature):

        TOMsMessageLog.logMessage("In getCurrentCPZDetails", level=Qgis.Info)
        CPZLayer = QgsProject.instance().mapLayersByName("CPZs")[0]

        restrictionID = feature.attribute("GeometryID")
        #TOMsMessageLog.logMessage("In getCurrentCPZDetails. restriction: " + str(restrictionID), level=Qgis.Info)

        geom = feature.geometry()

        currentCPZFeature = generateGeometryUtils.getPolygonForRestriction(feature, CPZLayer)

        if currentCPZFeature:

            currentCPZ = currentCPZFeature.attribute("CPZ")
            cpzWaitingTimeID = currentCPZFeature.attribute("TimePeriodID")
            TOMsMessageLog.logMessage("In getCurrentCPZDetails. CPZ found: {}: control: {}".format(currentCPZ, cpzWaitingTimeID), level=Qgis.Info)

            return currentCPZ, cpzWaitingTimeID

        return None, None

    @staticmethod
    def getCurrentPTADetails(feature):

        #TOMsMessageLog.logMessage("In getCurrentPTADetails", level=Qgis.Info)
        PTALayer = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]

        restrictionID = feature.attribute("GeometryID")
        #TOMsMessageLog.logMessage("In getCurrentPTADetails. restriction: " + str(restrictionID), level=Qgis.Info)

        geom = feature.geometry()

        currentPTAFeature = generateGeometryUtils.getPolygonForRestriction(feature, PTALayer)

        if currentPTAFeature:
            currentPTA = currentPTAFeature.attribute("ParkingTariffArea")
            ptaMaxStayID = currentPTAFeature.attribute("MaxStayID")
            ptaNoReturnID = currentPTAFeature.attribute("NoReturnID")
            ptaTimePeriodID = currentPTAFeature.attribute("TimePeriodID")

            #TOMsMessageLog.logMessage("In getCurrentPTADetails. PTA found: " + str(currentPTA), level=Qgis.Info)

            return currentPTA, ptaMaxStayID, ptaNoReturnID

        return None, None, None

    @staticmethod
    def getPolygonForRestriction(restriction, layer):
        # def findFeatureAt(self, pos, excludeFeature=None):
        """ Find the feature close to the given position.
        #def findFeatureAt2(feature, layerPt, layer, tolerance):
            'layerPt' is the position to check, in layer coordinates.
            'layer' is specified layer
            'tolerance' is search distance in layer units

            If no feature is close to the given coordinate, we return None.
        """

        #TOMsMessageLog.logMessage("In getPolygonForRestriction.", level=Qgis.Info)

        line = generateGeometryUtils.getLineForAz(restriction)

        if line:
            if len(line) == 0:
                return 0

            testPt = line[0]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)
            #TOMsMessageLog.logMessage("In getPolygonForRestriction." + str(testPt.x()), level=Qgis.Info)

            for poly in layer.getFeatures():
                if poly.geometry().contains(QgsGeometry.fromPointXY(testPt)):
                    #TOMsMessageLog.logMessage("In getPolygonForRestriction. feature found", level=Qgis.Info)
                    return poly

        return None

    @staticmethod
    def getAttributeFromLayer(layer, keyField, keyValue, attributeName):

        query = '"{}" = \'{}\''.format(keyField, keyValue)
        request = QgsFeatureRequest().setFilterExpression(query)

        for row in layer.getFeatures(request):
            TOMsMessageLog.logMessage("In getAttributeFromLayer. Returning {} with value {} from table {}".format(attributeName, row[layer.fields().indexFromName(attributeName)], layer.name()), level=Qgis.Warning)
            return row[layer.fields().indexFromName(attributeName)] # make assumption that only one row

        return None

    @staticmethod
    def getCPZWaitingTimeID(cpzNr):

        TOMsMessageLog.logMessage("In getCPZWaitingTimeID", level=Qgis.Info)

        CPZLayer = QgsProject.instance().mapLayersByName("CPZs")[0]

        for poly in CPZLayer.getFeatures():
            currentCPZ = poly.attribute("CPZ")
            if currentCPZ == cpzNr:
                TOMsMessageLog.logMessage("In getCPZWaitingTimeID. Found CPZ.", level=Qgis.Info)
                cpzWaitingTimeID = poly.attribute("TimePeriodID")
                TOMsMessageLog.logMessage("In getCPZWaitingTimeID. ID." + str(cpzWaitingTimeID), level=Qgis.Info)
                return cpzWaitingTimeID

        return None

    @staticmethod
    def getTariffZoneDetails(tpaNr):

        TOMsMessageLog.logMessage("In getTariffZoneDetails", level=Qgis.Info)

        tpaLayer = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]

        for poly in tpaLayer.getFeatures():
            currentPTA = poly.attribute("ParkingTariffArea")
            if currentPTA == tpaNr:
                TOMsMessageLog.logMessage("In getTariffZoneDetails. Found PTA.", level=Qgis.Info)
                ptaTimePeriodID = poly.attribute("TimePeriodID")
                ptaMaxStayID = poly.attribute("MaxStayID")
                ptaNoReturnID = poly.attribute("NoReturnID")
                TOMsMessageLog.logMessage("In getTariffZoneMaxStayID. ID." + str(ptaMaxStayID), level=Qgis.Info)
                return ptaTimePeriodID, ptaMaxStayID, ptaNoReturnID

        return None, None, None

    @staticmethod
    def getTariffZoneMaxStayID(tpaNr):

        #TOMsMessageLog.logMessage("In getTariffZoneMaxStayID", level=Qgis.Info)

        tpaLayer = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]

        for poly in tpaLayer.getFeatures():
            currentPTA = poly.attribute("ParkingTariffArea")
            if currentPTA == tpaNr:
                #TOMsMessageLog.logMessage("In getTariffZoneMaxStayID. Found PTA.", level=Qgis.Info)
                ptaMaxStayID = poly.attribute("MaxStayID")
                #TOMsMessageLog.logMessage("In getTariffZoneMaxStayID. ID." + str(ptaMaxStayID), level=Qgis.Info)
                return ptaMaxStayID

        return None

    @staticmethod
    def getTariffZoneNoReturnID(tpaNr):

        #TOMsMessageLog.logMessage("In getTariffZoneNoReturnID", level=Qgis.Info)

        tpaLayer = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]

        for poly in tpaLayer.getFeatures():
            currentPTA = poly.attribute("ParkingTariffArea")
            if currentPTA == tpaNr:
                #TOMsMessageLog.logMessage("In getTariffZoneNoReturnID. Found PTA.", level=Qgis.Info)
                ptaNoReturnID = poly.attribute("NoReturnID")
                #TOMsMessageLog.logMessage("In getTariffZoneNoReturnID. ID." + str(ptaNoReturnID), level=Qgis.Info)
                return ptaNoReturnID

        return None

    @staticmethod
    def getTariffZoneTimePeriodID(tpaNr):

        #TOMsMessageLog.logMessage("In getTariffZoneTimePeriodID", level=Qgis.Info)

        tpaLayer = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]

        for poly in tpaLayer.getFeatures():
            currentPTA = poly.attribute("ParkingTariffArea")
            if currentPTA == tpaNr:
                #TOMsMessageLog.logMessage("In getTariffZoneTimePeriodID. Found PTA.", level=Qgis.Info)
                ptaTimePeriodID = poly.attribute("TimePeriodID")
                #TOMsMessageLog.logMessage("In getTariffZoneTimePeriodID. ID." + str(ptaTimePeriodID), level=Qgis.Info)
                return ptaTimePeriodID

        return None

    @staticmethod
    def getAdjacentGridSquares(currGridSquare):

        #TOMsMessageLog.logMessage("In getAdjacentGridSquares", level=Qgis.Info)

        CPZLayer = QgsProject.instance().mapLayersByName("MapGrid")[0]

        for poly in CPZLayer.getFeatures():

            currentCPZ = poly.attribute("zone_no")
            if currentCPZ == cpzNr:
                #TOMsMessageLog.logMessage("In getAdjacentGridSquares. Found CPZ.", level=Qgis.Info)
                cpzWaitingTimeID = poly.attribute("WaitingTimeID")
                #TOMsMessageLog.logMessage("In getAdjacentGridSquares. ID." + str(cpzWaitingTimeID), level=Qgis.Info)
                return cpzWaitingTimeID

        return None

    def findNearestPointOnLineLayer(searchPt, lineLayer, tolerance, geometryIDs=None):
        # TODO: re-organise - currently also in TOMsSnapTrace ....
        # given a point, find the nearest point (within the tolerance) within the line layer
        # returns QgsPoint
        TOMsMessageLog.logMessage("In findNearestPointL. Checking lineLayer: {}: {}".format(lineLayer.name(), geometryIDs), level=Qgis.Info)
        searchRect = QgsRectangle(searchPt.x() - tolerance,
                                  searchPt.y() - tolerance,
                                  searchPt.x() + tolerance,
                                  searchPt.y() + tolerance)

        request = QgsFeatureRequest()
        request.setFilterRect(searchRect)
        request.setFlags(QgsFeatureRequest.ExactIntersect)

        shortestDistance = float("inf")
        #nearestPoint = QgsFeature()

        # Loop through all features in the layer to find the closest feature
        for f in lineLayer.getFeatures(request):
            TOMsMessageLog.logMessage("In findNearestPointL: {}".format(f.id()), level=Qgis.Info)
            if geometryIDs is not None:
                #print ('***** currGeometryID: {}; GeometryID: {}'.format(currGeometryID, f.attribute("GeometryID")))
                try:
                    testGeometryID = f.attribute("GeometryID")
                except KeyError:
                    return None, None  # layer does not have "GeometryID" field, i.e., not restriction layer

                if testGeometryID in geometryIDs:
                    continue
            # Add any features that are found should be added to a list
            #print ('feature found: {}'.format(f.id()))
            closestPtOnFeature = f.geometry().nearestPoint(QgsGeometry.fromPointXY(searchPt))
            dist = f.geometry().distance(QgsGeometry.fromPointXY(searchPt))
            if dist < shortestDistance:
                shortestDistance = dist
                closestPoint = closestPtOnFeature
                closestFeature = f

        TOMsMessageLog.logMessage("In findNearestPointL: shortestDistance: " + str(shortestDistance), level=Qgis.Info)

        if shortestDistance < float("inf"):
            #nearestPoint = QgsFeature()
            # add the geometry to the feature,
            #nearestPoint.setGeometry(QgsGeometry(closestPtOnFeature))
            #TOMsMessageLog.logMessage("findNearestPointL: nearestPoint geom type: " + str(nearestPoint.wkbType()), tag="TOMs panel")
            return closestPoint, closestFeature   # returns a geometry
        else:
            return None, None

    def getLineOrientationAtPoint(point, lineFeature):
        TOMsMessageLog.logMessage('getLineOrientationAtPoint ...', level=Qgis.Info)

        lineGeom = lineFeature.geometry()
        distSquared, closestPt, vertexNrAfterPt, leftOf = lineGeom.closestSegmentWithContext(point)
        orientationToFeature = point.azimuth(QgsPointXY(closestPt))
        orientationInFeatureDirection = closestPt.azimuth(QgsPointXY(lineGeom.vertexAt(vertexNrAfterPt)))
        #orientationAwayFromFeature = generateGeometryUtils.checkDegrees(orientationToFeature + 180.0)
        orientationAwayFromFeature = math.degrees(QgsGeometryUtils.normalizedAngle(math.radians(orientationToFeature + 180.0)))
        #orientationOppositeFeatureDirection = generateGeometryUtils.checkDegrees(orientationInFeatureDirection + 180)
        orientationOppositeFeatureDirection = math.degrees(QgsGeometryUtils.normalizedAngle(math.radians(orientationInFeatureDirection + 180.0)))

        #TOMsMessageLog.logMessage('getLineOrientationAtPoint 1: {toFeature}; 2: {featureDirection}; 3: {awayFromFeature}; 4: {oppFeatureDirection}'.format(toFeature=orientationToFeature, featureDirection=orientationInFeatureDirection, awayFromFeature=orientationAwayFromFeature, oppFeatureDirection=orientationOppositeFeatureDirection), level=Qgis.Info)
        #print('getLineOrientationAtPoint 1: {toFeature}; 2: {featureDirection}; 3: {awayFromFeature}; 4: {oppFeatureDirection}'.format(toFeature=orientationToFeature, featureDirection=orientationInFeatureDirection, awayFromFeature=orientationAwayFromFeature, oppFeatureDirection=orientationOppositeFeatureDirection), level=Qgis.Info)

        return orientationToFeature, orientationInFeatureDirection, orientationAwayFromFeature, orientationOppositeFeatureDirection

    def createLinewithPointAzimuthDistance(point, azimuth, distance):
        #azimuth in degrees
        otherPointGeom = QgsPointXY(point.x() + (float(distance) * math.sin(math.radians(azimuth))), point.y() + (float(distance) * math.cos(math.radians(azimuth))))
        lineGeom = QgsGeometry.fromPolylineXY([point, otherPointGeom])
        return lineGeom

    def getSignOrientation(ptFeature, lineLayer):
        TOMsMessageLog.logMessage('In getSignOrientation ...', level=Qgis.Info)
        try:
            signOrientation = ptFeature.attribute("SignOrientationTypeID")
        except KeyError as e:
            return [None, None, None, None, None]

        try:
            signOriginalGeometry = ptFeature.attribute("original_geom_wkt")
        except KeyError as e:
            TOMsMessageLog.logMessage('getSignLine - signOriginalGeometry issue', level=Qgis.Warning)
            return [None, None, None, None, None]

        TOMsMessageLog.logMessage('getSignOrientation - orientation: {}'.format(signOrientation), level=Qgis.Info)
        TOMsMessageLog.logMessage('getSignOrientation - signOriginalGeometry: {}'.format(signOriginalGeometry), level=Qgis.Info)

        lineGeom = None
        if signOrientation is None:
            return [None, None, None, None, None]

        # find closest point/feature on lineLayer

        #signPt = ptFeature.geometry().asPoint()
        signPt = QgsGeometry.fromWkt(signOriginalGeometry).asPoint()
        #print('signPt: {}'.format(signPt.asWkt()))
        #TOMsMessageLog.logMessage('getSignOrientation signPt: {}'.format(signPt.asWkt()), level=Qgis.Info)
        TOMsMessageLog.logMessage(
            'getSignOrientation lineLayer {}'.format(lineLayer.name()),
            level=Qgis.Info)
        closestPoint, closestFeature = generateGeometryUtils.findNearestPointOnLineLayer(signPt, lineLayer, 25)
        if closestPoint:
            TOMsMessageLog.logMessage('getSignLine closestPoint: {}'.format(closestPoint.asWkt()), level=Qgis.Info)

        # Now generate a line in the appropriate direction
        if closestPoint:
            # get the orientation of the line feature
            (orientationToFeature, orientationInFeatureDirection, orientationAwayFromFeature, orientationOppositeFeatureDirection) = generateGeometryUtils.getLineOrientationAtPoint(
                signPt, closestFeature)
            #TOMsMessageLog.logMessage('getSignLine orientationToFeature: {}'.format(orientationToFeature), level=Qgis.Info)
            #print('getSignLine orientationToFeature: {}'.format(orientationToFeature))

            # make it match sign orientation
            return [0.0, orientationInFeatureDirection, orientationOppositeFeatureDirection, orientationToFeature, orientationAwayFromFeature]

        return [None, None, None, None, None]

    def getSignLine(ptFeature, lineLayer, distanceForIcons):

        try:
            signOrientation = ptFeature.attribute("SignOrientationTypeID")
        except KeyError as e:
            TOMsMessageLog.logMessage('getSignLine - SignOrientationTypeID not found: {}'.format(signOrientation), level=Qgis.Warning)
            return None

        TOMsMessageLog.logMessage('getSignLine - orientation: {}'.format(signOrientation), level=Qgis.Info)

        lineGeom = None
        if signOrientation is None:
            return None

        orientationList = generateGeometryUtils.getSignOrientation(ptFeature, lineLayer)

        # Now generate a line in the appropriate direction
        if orientationList[1]:
            # work out the length of the line based on the number of plates in the sign
            platesInSign = generateGeometryUtils.getPlatesInSign(ptFeature)
            nrPlatesInSign = len(platesInSign)
            #TOMsMessageLog.logMessage('getSignLine nrPlatesInSign: {}'.format(nrPlatesInSign), level=Qgis.Info)
            lineLength = (nrPlatesInSign + 1) * distanceForIcons
            #TOMsMessageLog.logMessage('getSignLine lineLength: {}'.format(lineLength), level=Qgis.Info)
            #print('getSignLine lineLength: {}'.format(lineLength))

            signPt = ptFeature.geometry().asPoint()
            # generate lines
            if signOrientation == 1:  # "Facing in same direction as road"
                lineGeom = generateGeometryUtils.createLinewithPointAzimuthDistance(signPt, orientationList[1], lineLength)
            elif signOrientation == 2:  # "Facing in opposite direction to road"
                lineGeom = generateGeometryUtils.createLinewithPointAzimuthDistance(signPt, orientationList[2], lineLength)
            elif signOrientation == 3:  # "Facing road"
                lineGeom = generateGeometryUtils.createLinewithPointAzimuthDistance(signPt, orientationList[3], lineLength)
            elif signOrientation == 4:  # "Facing away from road"
                lineGeom = generateGeometryUtils.createLinewithPointAzimuthDistance(signPt, orientationList[4], lineLength)
            else:
                return None

        if lineGeom:
            TOMsMessageLog.logMessage('getSignLine lineGeom: {}'.format(lineGeom.asWkt()), level=Qgis.Info)

        return lineGeom

    def getPlatesInSign(feature):
        TOMsMessageLog.logMessage('getNrPlatesInSign ...', level=Qgis.Info)
        finished = False
        platesInSign = []
        nrPlatesInSign = 0
        while not finished:
            field = 'SignType_{}'.format(nrPlatesInSign+1)
            try:
                plateType = feature.attribute(field)
            except KeyError as e:
                break
            if plateType is None or str(plateType) == 'NULL':
                break
            platesInSign.append(plateType)
            nrPlatesInSign = nrPlatesInSign + 1
        return platesInSign

    def addPointsToSignLine(lineGeom, nrPts, distance):
        # add points to line at equal distance
        if lineGeom is None:
            return None
        newLinePts = []
        # add points along line for icons
        for i in (range(1, nrPts+1, 1)):
            newPt = (lineGeom.interpolate(i * distance)).asPoint()
            newLinePts.append(newPt)

        return newLinePts

    def finalSignLine(self, feature):
        return generateGeometryUtils.getGeneratedSignLine(feature)

    @staticmethod
    def getGeneratedSignLine(feature):
        TOMsMessageLog.logMessage('getGeneratedSignLine ... {}'.format(feature.attribute("GeometryID")), level=Qgis.Info)
        RoadCentreLineLayer = QgsProject.instance().mapLayersByName("RoadCentreLine")[0]
        distanceForIcons = float(QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('distanceForIcons'))
        #distanceForIcons = 10
        #iconSize = 4
        #nrPlatesInSign = generateGeometryUtils.getNrPlatesInSign(feature)
        #print ('nrPlates: {}'.format(nrPlatesInSign))
        lineGeom = generateGeometryUtils.getSignLine(feature, RoadCentreLineLayer, distanceForIcons)
        linePts = generateGeometryUtils.addPointsToSignLine(lineGeom, len(generateGeometryUtils.getPlatesInSign(feature)), distanceForIcons)
        if lineGeom:
            TOMsMessageLog.logMessage('getGeneratedSignLine: lineGeom: {}'.format(lineGeom.asWkt()), level=Qgis.Info)
        else:
            TOMsMessageLog.logMessage('getGeneratedSignLine: no geometry ...', level=Qgis.Info)

        return lineGeom, linePts

    @staticmethod
    def getSignIcons(ptFeature):
        TOMsMessageLog.logMessage('getSignIcons ... ', level=Qgis.Info)
        try:
            path_absolute = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('iconPath')
        except Exception as e:
            TOMsMessageLog.logMessage('getSignIcons: iconPath not found {}'.format(e), level=Qgis.Warning)
            return None

        platesInSign = generateGeometryUtils.getPlatesInSign(ptFeature)
        plateIconsInSign = []
        signTypesLayer = QgsProject.instance().mapLayersByName("SignTypes")[0]
        for plateType in platesInSign:
            signTypeRow = generateGeometryUtils.getLookupRow(signTypesLayer, plateType)
            if signTypeRow:
                icon = signTypeRow["Icon"]
                TOMsMessageLog.logMessage('getSignIcons: icon {}'.format(icon), level=Qgis.Info)
                if not icon:
                    continue
                path = os.path.join(path_absolute, icon)
                plateIconsInSign.append(path)
        #TOMsMessageLog.logMessage('getSignIcons ... returning ... ', level=Qgis.Info)
        return plateIconsInSign

    @staticmethod
    def getSignOrientationList(ptFeature):
        TOMsMessageLog.logMessage('getSignOrientationList ...', level=Qgis.Info)
        try:
            RoadCentreLineLayer = QgsProject.instance().mapLayersByName("RoadCentreLine")[0]
        except Exception as e:
            TOMsMessageLog.logMessage('getSignOrientationList: RoadCentreLine layer not found {}'.format(e), level=Qgis.Warning)
            return None

        orientationList = generateGeometryUtils.getSignOrientation(ptFeature, RoadCentreLineLayer)

        # This list give the orientation for the way the line is pointing. Now need to swap each through 180 to give true direction for arrows, etc
        # add extra value to match SignsOrientation values
        newOrientationList = [0,
                              orientationList[2], # "Facing in same direction as road" inverted is 2
                              orientationList[1],  # "Facing in opposite direction to road" inverted is 1
                              orientationList[4], # "Facing road" inverted is 4
                              orientationList[3]]  # "Facing away from road" inverted is 3

        try:
            featureSignOrientation = ptFeature.attribute("SignOrientationTypeID")
        except KeyError as e:
            return None
        TOMsMessageLog.logMessage('getSignOrientationList ...{}'.format(newOrientationList[featureSignOrientation]), level=Qgis.Info)
        #return orientationList
        return newOrientationList[featureSignOrientation]

    def getLookupRow(lookupLayer, code):
        query = '"Code" = \'{}\''.format(code)
        request = QgsFeatureRequest().setFilterExpression(query)
        for row in lookupLayer.getFeatures(request):
            return row # make assumption that only one row
        return None



