#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock 2017

from qgis.PyQt.QtWidgets import (
    QMessageBox
)

from qgis.core import (
    QgsExpressionContextUtils,
    QgsMessageLog,
    QgsFeature,
    QgsGeometry,
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
        # QgsMessageLog.logMessage("In turnToCL Az1 = " + str(Az1) + " Az2 = " + str(Az2), tag="TOMs panel")

        AzCL = Az1 - 90.0
        if AzCL < 0:
            AzCL = AzCL + 360.0

        # QgsMessageLog.logMessage("In turnToCL AzCL = " + str(AzCL), tag="TOMs panel")

        # Need to check quadrant

        if AzCL >= 0.0 and AzCL <= 90.0:
            if Az2 >= 270.0 and Az2 <= 359.999:
                AzCL = AzCL + 360
        elif Az2 >= 0 and Az2 <= 90:
            if AzCL >= 270.0 and AzCL <= 359.999:
                Az2 = Az2 + 360

        g = abs(float(AzCL) - float(Az2))

        # QgsMessageLog.logMessage("In turnToCL Diff = " + str(g), tag="TOMs panel")

        if g < 90:
            Turn = -90
        else:
            Turn = 90

        # QgsMessageLog.logMessage("In turnToCL Turn = " + str(Turn), tag="TOMs panel")

        return Turn

    @staticmethod
    def calcBisector(prevAz, currAz, Turn, WidthRest):
        # function to return Az of bisector

        # QgsMessageLog.logMessage("In calcBisector", tag="TOMs panel")
        # QgsMessageLog.logMessage("In calcBisector: prevAz: " + str(prevAz) + " currAz: " + str(currAz), tag="TOMs panel")

        prevAzA = generateGeometryUtils.checkDegrees(prevAz + float(Turn))
        currAzA = generateGeometryUtils.checkDegrees(currAz + float(Turn))

        # QgsMessageLog.logMessage("In calcBisector: prevAzA: " + str(prevAzA) + " currAzA: " + str(currAzA), tag="TOMs panel")

        """
        if prevAz > 180:
            revPrevAz = prevAz - float(180)
        else:
            revPrevAz = prevAz + float(180)
        """

        # QgsMessageLog.logMessage("In calcBisector: revPrevAz: " + str(revPrevAz), tag="TOMs panel")

        diffAz = prevAzA - currAzA

        # QgsMessageLog.logMessage("In calcBisector: diffAz: " + str(diffAz), tag="TOMs panel")

        diffAngle = diffAz / float(2)
        bisectAz = prevAzA - diffAngle

        diffAngle_rad = math.radians(diffAngle)
        # QgsMessageLog.logMessage("In calcBisector: diffAngle: " + str(diffAngle) + " diffAngle_rad: " + str(diffAngle_rad), tag="TOMs panel")
        distToPt = float(WidthRest) / math.cos(diffAngle_rad)

        # QgsMessageLog.logMessage("In generate_display_geometry: bisectAz: " + str(bisectAz) + " distToPt:" + str(distToPt), tag="TOMs panel")

        return bisectAz, distToPt

    @staticmethod
    def checkDegrees(Az):
        newAz = Az

        if Az >= float(360):
            newAz = Az - float(360)
        elif Az < float(0):
            newAz = Az + float(360)

        # QgsMessageLog.logMessage("In checkDegrees: newAz: " + str(newAz), tag="TOMs panel")

        return newAz

    @staticmethod
    def setRoadName(feature):

        newStreetName, newUSRN = generateGeometryUtils.determineRoadName(feature)
        # now set the attributes
        if newStreetName:
            feature.setAttribute("RoadName", newStreetName)
            feature.setAttribute("USRN", newUSRN)

            # feature.setAttribute("AzimuthToRoadCentreLine", int(generateGeometryUtils.calculateAzimuthToRoadCentreLine(feature)))

    @staticmethod
    def determineRoadName(feature):

        QgsMessageLog.logMessage("In setRoadName(helper):", tag="TOMs panel")
        QgsMessageLog.logMessage("In setRoadName(helper)2:", tag="TOMs panel")

        RoadCasementLayer = QgsProject.instance().mapLayersByName("RoadCasement")[0]

        # take the first point from the geometry
        QgsMessageLog.logMessage("In setRoadName: {}".format(feature.geometry().asWkt()), tag="TOMs panel")

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
                QgsMessageLog.logMessage("In setRoadName(helper): considering line", tag="TOMs panel")
                line = generateGeometryUtils.getLineForAz(feature)

                if len(line) == 0:
                    return None, None

                testPt = line[0]
                #ptList = feature.geometry().asPolyline()
                #secondPt = ptList[0]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

            elif geom.type() == QgsWkbTypes.PointGeometry: # Point
                QgsMessageLog.logMessage("In setRoadName(helper): considering point", tag="TOMs panel")
                testPt = feature.geometry().asPoint()

                #tolerance_nearby = 5.0

            elif feature.geometry().type() == QgsWkbTypes.PolygonGeometry: # Polygon
                QgsMessageLog.logMessage("In setRoadName(helper): considering polygon", tag="TOMs panel")
                ptList = feature.geometry().asPolygon()[0]
                testPt = ptList[
                    0]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

        else:
            QgsMessageLog.logMessage("In setRoadName: unknown geometry type", tag="TOMs panel")
            return

        #nrPts = len(ptList)
        #QgsMessageLog.logMessage("In setRoadName: number of pts in list: " + str(nrPts), tag="TOMs panel")

        QgsMessageLog.logMessage("In setRoadName: secondPt: " + str(testPt.x()), tag="TOMs panel")

        # check for the feature within RoadCasement_NSG_StreetName layer
        #tolerance_nearby = 1.0  # somehow need to have this (and layer names) as global variables

        nearestRC_feature = generateGeometryUtils.findFeatureAt2(feature, testPt, RoadCasementLayer,
                                                                tolerance_nearby)

        if nearestRC_feature:
            # QgsMessageLog.logMessage("In setRoadName: nearestRC_feature: " + nearestRC_feature.geometry().asWkt(), tag="TOMs panel")

            idx_StreetName = RoadCasementLayer.fields().indexFromName('StreetName')
            idx_USRN = RoadCasementLayer.fields().indexFromName('USRN')

            StreetName = nearestRC_feature.attributes()[idx_StreetName]
            USRN = nearestRC_feature.attributes()[idx_USRN]

            QgsMessageLog.logMessage("In setRoadName: StreetName: " + str(StreetName), tag="TOMs panel")

            return StreetName, USRN

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

        #QgsMessageLog.logMessage("In getLineForAz(helper):", tag="TOMs panel")

        geom = feature.geometry()
        # line = QgsGeometry()

        if geom:
            if geom.type() == QgsWkbTypes.LineGeometry:
                if geom.isMultipart():
                    lines = geom.asMultiPolyline()
                    nrLines = len(lines)

                    #QgsMessageLog.logMessage("In getLineForAz(helper):  geometry: " + feature.geometry().asWkt()  + " - NrLines = " + str(nrLines), tag="TOMs panel")

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
                QgsMessageLog.logMessage("In getLineForAz(helper): Incorrect geometry found", tag="TOMs panel")
                return None

        else:
            QgsMessageLog.logMessage("In getLineForAz(helper): geometry not found", tag="TOMs panel")
            return None

    @staticmethod
    def calculateAzimuthToRoadCentreLine(feature):
        # find the shortest line from this point to the road centre line layer
        # http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/ - generates "closest feature" function

        # QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper):", tag="TOMs panel")

        RoadCentreLineLayer = QgsProject.instance().mapLayersByName("RoadCentreLine")[0]

        """if feature.geometry():
            geom = feature.geometry()
        else:
            QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper): geometry not found", tag="TOMs panel")
            return 0"""

        # take the a point from the geometry
        # line = feature.geometry().asPolyline()
        line = generateGeometryUtils.getLineForAz(feature)

        if len(line) == 0:
            return 0

        # Get the mid point of the line - https://gis.stackexchange.com/questions/58079/finding-middle-point-midpoint-of-line-in-qgis

        testPt = feature.geometry().centroid().asPoint()        #lineGeom = QgsGeometry.fromPolyline((line[::])
        #lineLength = lineGeom.length()
        #QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper): lineLength: " + str(lineLength), tag="TOMs panel")
        #testPt = lineGeom.interpolate(lineLength / 2.0)
        #testPt = line[0]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

        # QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine: secondPt: " + str(testPt.x()), tag="TOMs panel")

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

        # QgsMessageLog.logMessage("In calculateAzimuthToRoadCentreLine: shortestDistance: " + str(shortestDistance), tag="TOMs panel")

        if featureFound:
            # now obtain the line between the testPt and the nearest feature
            # f_lineToCL = closestFeature.geometry().shortestLine(QgsGeometry.fromPointXY(testPt))
            startPt = QgsPoint(QgsGeometry.asPoint(closestFeature.geometry().nearestPoint(QgsGeometry.fromPointXY(testPt))))

            # get the start point (we know the end point)
            """startPtV2 = f_lineToCL.geometry().startPoint()
            startPt = QgsPoint()
            startPt.setX(startPtV2.x())
            startPt.setY(startPtV2.y())"""

            QgsMessageLog.logMessage("In calculateAzimuthToRoadCentreLine: startPoint: " + str(startPt.x()),
                                     tag="TOMs panel")

            Az = QgsPoint(testPt).azimuth(startPt)
            # Az = generateGeometryUtils.checkDegrees(testPt.azimuth(startPt))
            # QgsMessageLog.logMessage("In calculateAzimuthToRoadCentreLine: Az: " + str(Az), tag="TOMs panel")

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

        QgsMessageLog.logMessage("In findFeatureAt2. Incoming layer: " + str(layer) + "tol: " + str(tolerance), tag="TOMs panel")

        searchRect = QgsRectangle(layerPt.x() - tolerance,
                                  layerPt.y() - tolerance,
                                  layerPt.x() + tolerance,
                                  layerPt.y() + tolerance)

        request = QgsFeatureRequest()
        request.setFilterRect(searchRect)
        request.setFlags(QgsFeatureRequest.ExactIntersect)

        for feature in layer.getFeatures(request):
            QgsMessageLog.logMessage("In findFeatureAt2. feature found", tag="TOMs panel")
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
            QgsMessageLog.logMessage("In checkFeatureIsBay: restGeomType = " + str(restGeomType), tag="TOMs panel")
            if restGeomType < 10 or (restGeomType >=20 and restGeomType < 30):
                return True
            else:
                return False
        """

    @staticmethod
    def getDisplayGeometry(feature, restGeomType, offset, shpExtent, orientation, AzimuthToCentreLine):
        # Obtain relevant variables
        #QgsMessageLog.logMessage("In getDisplayGeometry: restGeomType = " + str(restGeomType), tag="TOMs panel")

        # Need to check why the project variable function is not working

        restrictionID = feature.attribute("GeometryID")
        QgsMessageLog.logMessage("In getDisplayGeometry: New restriction .................................................................... ID: " + str(restrictionID), tag="TOMs panel")
        # restGeomType = feature.attribute("GeomShapeID")
        #AzimuthToCentreLine = float(feature.attribute("AzimuthToRoadCentreLine"))
        #QgsMessageLog.logMessage("In getDisplayGeometry: Az: " + str(AzimuthToCentreLine), tag = "TOMs panel")

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

        # QgsMessageLog.logMessage("In getDisplayGeometry:  nr of pts = " + str(len(line)), tag="TOMs panel")

        if len(line) == 0:
            return 0

        # Now have a valid set of points

        # QgsMessageLog.logMessage("In getDisplayGeometry:  Now processing line", tag="TOMs panel")

        ptsList = []
        parallelPtsList = []
        nextAz = 0
        diffEchelonAz = 0

        # now loop through each of the vertices and process as required. New geometry points are added to ptsList

        for i in range(len(line) - 1):

            # QgsMessageLog.logMessage("In getDisplayGeometry: i = " + str(i), tag="TOMs panel")

            Az = line[i].azimuth(line[i + 1])

            # QgsMessageLog.logMessage("In getDisplayGeometry: geometry: " + str(line[i].x()) + " " + str(line[i+1].x()) + " " + str(Az), tag="TOMs panel")

            # if this is the first point

            if i == 0:
                # determine which way to turn towards CL
                # QgsMessageLog.logMessage("In generate_display_geometry: considering first point", tag="TOMs panel")

                Turn = generateGeometryUtils.turnToCL(Az, AzimuthToCentreLine)

                newAz = Az + Turn
                # QgsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), tag="TOMs panel")
                cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)

                # QgsMessageLog.logMessage("In generate_display_geometry: cosa : " + str(cosa) + " " + str(cosb), tag="TOMs panel")

                # dx = float(offset) * cosa
                # dy = float(offset) * cosb

                # QgsMessageLog.logMessage("In generate_display_geometry: dx: " + str(dx) + " dy: " + str(dy), tag="TOMs panel")

                ptsList.append(
                    QgsPoint(line[i].x() + (float(offset) * cosa), line[i].y() + (float(offset) * cosb)))
                # QgsMessageLog.logMessage("In geomType: added point 1 ", tag="TOMs panel")

                # Now add the point at the extent. If it is an echelon bay:
                #   a. calculate the difference between the first Az and the echelon Az (??), and
                #   b. adjust the angle
                #   c. *** also need to adjust the length *** Not yet implemented

                #if restGeomType == 5 or restGeomType == 25:  # echelon
                if restGeomType in [5, 25]:  # echelon
                    QgsMessageLog.logMessage("In geomType: orientation: " + str(orientation), tag="TOMs panel")
                    diffEchelonAz = generateGeometryUtils.checkDegrees(orientation - newAz)
                    newAz = Az + Turn + diffEchelonAz
                    QgsMessageLog.logMessage("In geomType: newAz: " + str(newAz) + " diffEchelonAz: " + str(diffEchelonAz), tag="TOMs panel")
                    cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)
                    pass

                ptsList.append(
                    QgsPoint(line[i].x() + (float(shpExtent) * cosa),
                             line[i].y() + (float(shpExtent) * cosb)))
                # QgsMessageLog.logMessage("In geomType: added point 2 ", tag="TOMs panel")

                # ptsList.append(newPoint)
                # QgsMessageLog.logMessage("In geomType: after append ", tag="TOMs panel")

                # ptsList.append(QgsPoint(line[i].x()+(float(bayWidth)*cosa), line[i].y()+(float(bayWidth)*cosb)))

            else:

                # now pass along the feature

                # QgsMessageLog.logMessage("In generate_display_geometry: considering point: " + str(i), tag="TOMs panel")

                # need to work out half of bisected angle

                # QgsMessageLog.logMessage("In generate_display_geometry: prevAz: " + str(prevAz) + " currAz: " + str(Az), tag="TOMs panel")

                newAz, distWidth = generateGeometryUtils.calcBisector(prevAz, Az, Turn, shpExtent)

                cosa, cosb = generateGeometryUtils.cosdir_azim(newAz + diffEchelonAz)
                ptsList.append(
                    QgsPoint(line[i].x() + (float(distWidth) * cosa), line[i].y() + (float(distWidth) * cosb)))

                parallelPtsList.append(
                    QgsPoint(line[i].x() + (float(distWidth) * cosa), line[i].y() + (float(distWidth) * cosb)))

            # QgsMessageLog.logMessage("In generate_display_geometry: point appended", tag="TOMs panel")

            prevAz = Az

        # QgsMessageLog.logMessage("In generate_display_geometry: newPoint 1: " + str(ptsList[1].x()) + " " + str(ptsList[1].y()), tag="TOMs panel")

        # have reached the end of the feature. Now need to deal with last point.
        # Use Azimuth from last segment but change the points

        # QgsMessageLog.logMessage("In generate_display_geometry: feature processed. Now at last point ", tag="TOMs panel")

       # standard bay
        newAz = Az + Turn + diffEchelonAz
        # QgsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), tag="TOMs panel")
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

        #QgsMessageLog.logMessage("In getDisplayGeometry:  newGeometry ********: " + newLine.asWkt(), tag="TOMs panel")


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

        QgsMessageLog.logMessage("In zigzag", tag="TOMs panel")

        line, parallelLine = generateGeometryUtils.getDisplayGeometry(feature, restGeometryType, offset, shpExtent, orientation, AzimuthToCentreLine)

        #QgsMessageLog.logMessage("In zigzag - have geometry + " + line.asWkt(), tag="TOMs panel")

        length = line.length()
        #QgsMessageLog.logMessage(
        #    "In zigzag - have geometry. Length = " + str(length) + " wavelength: " + str(wavelength),
        #    tag="TOMs panel")

        segments = int(length / wavelength)
        # Find equally spaced points that approximate the line
        #QgsMessageLog.logMessage("In zigzag - have geometry. segments = " + str(segments), tag="TOMs panel")

        points = []
        countSegments = 0
        while countSegments <= segments:
            # QgsMessageLog.logMessage("In zigzag - countSegment = " + str(countSegments), tag="TOMs panel")
            interpolateDistance = int(countSegments * int(wavelength))
            # QgsMessageLog.logMessage("In zigzag - interpolateDistance = " + str(interpolateDistance), tag="TOMs panel")
            points.append(line.interpolate(float(interpolateDistance)).asPoint())
            # QgsMessageLog.logMessage("In zigzag - added Point", tag="TOMs panel")
            countSegments = countSegments + 1

        #QgsMessageLog.logMessage("In zigzag - have points: nrPts = " + str(len(points)), tag="TOMs panel")

        # Calculate the azimuths of the approximating line segments

        azimuths = []

        for i in range(len(points) - 1):
            # QgsMessageLog.logMessage("In zigzag - creating Az: i = " + str(i), tag="TOMs panel")
            azimuths.append((points[i].azimuth(points[i + 1])))

        #QgsMessageLog.logMessage("In zigzag - after azimuths: i " + str(i) + " len(az): " + str(len(azimuths)),
        #                         tag="TOMs panel")

        # Average consecutive azimuths and rotate 90 deg counterclockwise

        # newAz, distWidth = generateGeometryUtils.calcBisector(prevAz, Az, Turn, shpExtent)

        zigzagazimuths = [azimuths[0] - math.pi / 2]
        zigzagazimuths.extend([generateGeometryUtils.meanAngle(azimuths[i], azimuths[i - 1]) - math.pi / 2 for i in
                               range(len(points) - 1)])
        zigzagazimuths.append(azimuths[-1] - math.pi / 2)

        #QgsMessageLog.logMessage("In zigzag - about to create shape", tag="TOMs panel")

        cosa = 0.0
        cosb = 0.0

        # Offset the points along the zigzagazimuths
        zigzagpoints = []
        for i in range(len(points) - 1):
            # Alternate the sign

            #QgsMessageLog.logMessage("In zigzag - sign: " + str(i - 2 * math.floor(i / 2)), tag="TOMs panel")

            # currX = points[i].x()
            # currY = points[i].y()

            dst = amplitude * 1 - 2 * (i - 2 * math.floor(
                i / 2))  # b = a - m.*floor(a./m)  is the same as   b = mod( a , m )      Thus: i - 2 * math.floor(i/2)
            #QgsMessageLog.logMessage("In zigzag - dst: " + str(dst) + " Az: " + str(azimuths[i]), tag="TOMs panel")

            # currAz = zigzagazimuths[i]
            cosa, cosb = generateGeometryUtils.cosdir_azim(azimuths[i])

            #QgsMessageLog.logMessage("In zigzag - cosa: " + str(cosa), tag="TOMs panel")

            zigzagpoints.append(
                QgsPoint(points[i].x() + (float(offset) * cosa), points[i].y() + (float(offset) * cosb)))

            #QgsMessageLog.logMessage("In zigzag - point added: " + str(i), tag="TOMs panel")
            # zigzagpoints.append(QgsPoint(points[i][0] + math.sin(zigzagazimuths[i]) * dst, points[i][1] + math.cos(zigzagazimuths[i]) * dst))

        # Create new feature from the list of zigzag points
        gLine = QgsGeometry.fromPolyline(zigzagpoints)

        #QgsMessageLog.logMessage("In zigzag - shape created", tag="TOMs panel")

        return gLine

    @staticmethod
    def meanAngle(a1, a2):
        return phase((rect(1, a1) + rect(1, a2)) / 2.0)

    @staticmethod
    def generateWaitingLabelLeader(feature):

        #QgsMessageLog.logMessage("In generateWaitingLabelLeader", tag="TOMs panel")
        # check to see scale

        minScale = float(generateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        #QgsMessageLog.logMessage("In generateLabelLeader. Current scale: " + str(currScale) + " min scale: " + str(minScale), tag="TOMs panel")

        if currScale <= minScale:

            if feature.attribute("labelX"):
                #QgsMessageLog.logMessage(
                #    "In generateLabelLeader. labelX set for " + str(feature.attribute("GeometryID")), tag="TOMs panel")

                # now generate line
                length = feature.geometry().length()
                return QgsGeometry.fromPolyline([QgsPoint(feature.geometry().interpolate(length/2.0).asPoint()), QgsPoint(feature.attribute("labelX"), feature.attribute("labelY"))])

            pass

        pass

        return None

    @staticmethod
    def generateLoadingLabelLeader(feature):

        #QgsMessageLog.logMessage("In generateLoadingLabelLeader", tag="TOMs panel")
        # check to see scale

        minScale = float(generateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        #QgsMessageLog.logMessage("In generateLabelLeader. Current scale: " + str(currScale) + " min scale: " + str(minScale), tag="TOMs panel")

        if currScale <= minScale:

            if feature.attribute("labelLoadingX"):
                #QgsMessageLog.logMessage(
                #    "In generateLabelLeader. labelX set for " + str(feature.attribute("GeometryID")), tag="TOMs panel")

                # now generate line
                length = feature.geometry().length()
                return QgsGeometry.fromPolyline([QgsPoint(feature.geometry().interpolate(length/2.0).asPoint()), QgsPoint(feature.attribute("labelLoadingX"), feature.attribute("labelLoadingY"))])

            pass

        pass

        return None

    @staticmethod
    def generateBayLabelLeader(feature):

        #QgsMessageLog.logMessage("In generateBayLabelLeader", tag="TOMs panel")
        # check to see scale

        minScale = float(generateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        QgsMessageLog.logMessage("In generateBayLabelLeader. Current scale: " + str(currScale) + " min scale: " + str(minScale), tag="TOMs panel")

        if currScale <= minScale:

            if feature.attribute("label_X"):

                length = feature.geometry().length()
                QgsMessageLog.logMessage(
                    "In generateBayLabelLeader. labelX set for " + str(feature.attribute("GeometryID")), tag="TOMs panel")

                """
                # now generate line
                points = []
                pt1 = QgsPoint(feature.geometry().interpolate(length/2.0).asPoint())
                points.append(pt1)
                pt2 = QgsPoint(feature.attribute("label_X"), feature.attribute("label_Y"))
                points.append(pt2)

                for i, pt in enumerate(points):
                    QgsMessageLog.logMessage(
                        "In generateBayLabelLeader. pt: " + str(i) + "; " + pt.asWkt(), tag="TOMs panel")
                    # + ":" + QgsWkbTypes.displayString(pt.wkbType())

                lineGeom = QgsGeometry.fromPolyline(points)

                QgsMessageLog.logMessage(
                    "In generateBayLabelLeader. line: " + lineGeom.asWkt() ,
                    tag="TOMs panel")
                
                return lineGeom
                """
                return QgsGeometry.fromPolyline([QgsPoint(feature.geometry().interpolate(length/2.0).asPoint()), QgsPoint(feature.attribute("label_X"), feature.attribute("label_Y"))])

            pass

        pass

        return None

    @staticmethod
    def generatePolygonLabelLeader(feature):

        #QgsMessageLog.logMessage("In generateBayLabelLeader", tag="TOMs panel")
        # check to see scale

        minScale = float(generateGeometryUtils.getMininumScaleForDisplay())
        currScale = float(iface.mapCanvas().scale())

        #QgsMessageLog.logMessage("In generateLabelLeader. Current scale: " + str(currScale) + " min scale: " + str(minScale), tag="TOMs panel")

        if currScale <= minScale:

            if feature.attribute("labelX"):
                QgsMessageLog.logMessage(
                    "In generatePolygonLabelLeader. labelX set for " + str(feature.attribute("GeometryID")), tag="TOMs panel")

                pt = feature.geometry().nearestPoint()

                # now generate line
                return QgsGeometry.fromPolyline([QgsPoint(feature.geometry().nearestPoint().asPoint()), QgsPoint(feature.attribute("labelX"), feature.attribute("labelY"))])

            pass

        pass

        return None

    @staticmethod
    def getMininumScaleForDisplay():
        #QgsMessageLog.logMessage("In getMininumScaleForDisplay", tag="TOMs panel")

        minScale = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('MinimumTextDisplayScale')

        #QgsMessageLog.logMessage("In getMininumScaleForDisplay. minScale(1): " + str(minScale), tag="TOMs panel")

        if minScale == None:
            minScale = 1250
        #QgsMessageLog.logMessage("In getMininumScaleForDisplay. minScale: " + str(minScale), tag="TOMs panel")

        return minScale

    @staticmethod
    def getWaitingLoadingRestrictionLabelText(feature):

        QgsMessageLog.logMessage("In getWaitingLoadingRestrictionLabelText", tag="TOMs panel")

        waitingTimeID = feature.attribute("NoWaitingTimeID")
        loadingTimeID = feature.attribute("NoLoadingTimeID")
        GeometryID = feature.attribute("GeometryID")

        TimePeriodsLayer = QgsProject.instance().mapLayersByName("TimePeriods")[0]

        waitDesc = generateGeometryUtils.getLookupLabelText(TimePeriodsLayer, waitingTimeID)
        loadDesc = generateGeometryUtils.getLookupLabelText(TimePeriodsLayer, loadingTimeID)

        QgsMessageLog.logMessage("In getWaitingLoadingRestrictionLabelText(1): waiting: " + str(waitDesc) + " loading: " + str(loadDesc), tag="TOMs panel")

        restrictionCPZ = feature.attribute("CPZ")
        CPZWaitingTimeID = generateGeometryUtils.getCPZWaitingTimeID(restrictionCPZ)

        """QgsMessageLog.logMessage(
            "In getWaitingLoadingRestrictionLabelText (" + GeometryID + "): " + str(CPZWaitingTimeID) + "; " + str(waitingTimeID) + "; " + str(loadingTimeID),
            tag="TOMs panel")"""

        if CPZWaitingTimeID:
            #QgsMessageLog.logMessage("In getWaitingLoadingRestrictionLabelText: " + str(CPZWaitingTimeID) + " " + str(waitingTimeID),
            #                         tag="TOMs panel")
            if CPZWaitingTimeID == waitingTimeID:
                waitDesc = None

        """if waitingTimeID == 1:  # 'At Any Time'
            waitDesc = None

        if loadingTimeID == 1:  # 'At Any Time'
            loadDesc = None """

        QgsMessageLog.logMessage("In getWaitingLoadingRestrictionLabelText(" + str(GeometryID) + "): waiting: " + str(waitDesc) + " loading: " + str(loadDesc), tag="TOMs panel")
        return waitDesc, loadDesc

    @staticmethod
    def getBayRestrictionLabelText(feature):

        #QgsMessageLog.logMessage("In getBayRestrictionLabelText", tag="TOMs panel")

        maxStayID = feature.attribute("MaxStayID")
        noReturnID = feature.attribute("NoReturnID")
        timePeriodID = feature.attribute("TimePeriodID")

        lengthOfTimeLayer = QgsProject.instance().mapLayersByName("LengthOfTime")[0]

        TimePeriodsLayer = QgsProject.instance().mapLayersByName("TimePeriods")[0]

        #QgsMessageLog.logMessage("In getBayRestrictionLabelText (2)", tag="TOMs panel")

        maxStayDesc = generateGeometryUtils.getLookupLabelText(lengthOfTimeLayer, maxStayID)
        noReturnDesc = generateGeometryUtils.getLookupLabelText(lengthOfTimeLayer, noReturnID)
        timePeriodDesc = generateGeometryUtils.getLookupLabelText(TimePeriodsLayer, timePeriodID)

        #QgsMessageLog.logMessage("In getBayRestrictionLabelText. maxStay: " + str(maxStayDesc), tag="TOMs panel")

        restrictionCPZ = feature.attribute("CPZ")
        restrictionPTA = feature.attribute("ParkingTariffArea")

        CPZWaitingTimeID = generateGeometryUtils.getCPZWaitingTimeID(restrictionCPZ)
        TariffZoneTimePeriodID, TariffZoneMaxStayID, TariffZoneNoReturnID = generateGeometryUtils.getTariffZoneDetails(restrictionPTA)
        #TariffZoneMaxStayID = generateGeometryUtils.getTariffZoneMaxStayID(restrictionPTA)
        #TariffZoneNoReturnID = generateGeometryUtils.getTariffZoneNoReturnID(restrictionPTA)
        #TariffZoneTimePeriodID = generateGeometryUtils.getTariffZoneTimePeriodID(restrictionPTA)

        QgsMessageLog.logMessage(
            "In getBayRestrictionLabelText (1): " + str(CPZWaitingTimeID) + " PTA hours: " + str(TariffZoneTimePeriodID),
            tag="TOMs panel")
        QgsMessageLog.logMessage("In getBayRestrictionLabelText. bay hours: " + str(timePeriodID), tag="TOMs panel")

        if timePeriodID == 1:  # 'At Any Time'
            timePeriodDesc = None

        if CPZWaitingTimeID:
            QgsMessageLog.logMessage("In getBayRestrictionLabelText: " + str(CPZWaitingTimeID) + " " + str(timePeriodID),
                                     tag="TOMs panel")
            if CPZWaitingTimeID == timePeriodID:
                timePeriodDesc = None

        if TariffZoneTimePeriodID == timePeriodID:
            timePeriodDesc = None

        if TariffZoneMaxStayID:
            """QgsMessageLog.logMessage("In getBayRestrictionLabelText: " + str(TariffZoneMaxStayID) + " " + str(maxStayID),
                                     tag="TOMs panel")"""
            if TariffZoneMaxStayID == maxStayID:
                maxStayDesc = None

        if TariffZoneNoReturnID:
            """QgsMessageLog.logMessage("In getBayRestrictionLabelText: " + str(TariffZoneNoReturnID) + " " + str(noReturnID),
                                     tag="TOMs panel")"""
            if TariffZoneNoReturnID == noReturnID:
                noReturnDesc = None

        QgsMessageLog.logMessage("In getBayRestrictionLabelText. timePeriodDesc (2): " + str(timePeriodDesc), tag="TOMs panel")

        return maxStayDesc, noReturnDesc, timePeriodDesc

    @staticmethod
    def getLookupDescription(lookupLayer, code):

        #QgsMessageLog.logMessage("In getLookupDescription", tag="TOMs panel")

        query = "\"Code\" = " + str(code)
        request = QgsFeatureRequest().setFilterExpression(query)

        #QgsMessageLog.logMessage("In getLookupDescription. queryStatus: " + str(query), tag="TOMs panel")

        for row in lookupLayer.getFeatures(request):
            #QgsMessageLog.logMessage("In getLookupDescription: found row " + str(row.attribute("Description")), tag="TOMs panel")
            return row.attribute("Description") # make assumption that only one row

        return None

    @staticmethod
    def getLookupLabelText(lookupLayer, code):

        #QgsMessageLog.logMessage("In getLookupLabelText", tag="TOMs panel")

        query = "\"Code\" = " + str(code)
        request = QgsFeatureRequest().setFilterExpression(query)

        #QgsMessageLog.logMessage("In getLookupLabelText. queryStatus: " + str(query), tag="TOMs panel")

        for row in lookupLayer.getFeatures(request):
            #QgsMessageLog.logMessage("In getLookupLabelText: found row " + str(row.attribute("LabelText")), tag="TOMs panel")
            return row.attribute("LabelText") # make assumption that only one row

        return None

    @staticmethod
    def getCurrentCPZDetails(feature):

        QgsMessageLog.logMessage("In getCurrentCPZDetails", tag="TOMs panel")
        CPZLayer = QgsProject.instance().mapLayersByName("CPZs")[0]

        restrictionID = feature.attribute("GeometryID")
        #QgsMessageLog.logMessage("In getCurrentCPZDetails. restriction: " + str(restrictionID), tag="TOMs panel")

        geom = feature.geometry()

        currentCPZFeature = generateGeometryUtils.getPolygonForRestriction(feature, CPZLayer)

        if currentCPZFeature:

            currentCPZ = currentCPZFeature.attribute("CPZ")
            cpzWaitingTimeID = currentCPZFeature.attribute("WaitingTimeID")
            #QgsMessageLog.logMessage("In getCurrentCPZDetails. CPZ found: " + str(currentCPZ), tag="TOMs panel")

            return currentCPZ, cpzWaitingTimeID

        return None, None

    @staticmethod
    def getCurrentPTADetails(feature):

        #QgsMessageLog.logMessage("In getCurrentPTADetails", tag="TOMs panel")
        PTALayer = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]

        restrictionID = feature.attribute("GeometryID")
        #QgsMessageLog.logMessage("In getCurrentPTADetails. restriction: " + str(restrictionID), tag="TOMs panel")

        geom = feature.geometry()

        currentPTAFeature = generateGeometryUtils.getPolygonForRestriction(feature, PTALayer)

        if currentPTAFeature:

            currentPTA = currentPTAFeature.attribute("Name")
            ptaMaxStayID = currentPTAFeature.attribute("MaxStayID")
            ptaNoReturnTimeID = currentPTAFeature.attribute("NoReturnTimeID")
            ptaTimePeriodID = currentPTAFeature.attribute("TimePeriodID")

            #QgsMessageLog.logMessage("In getCurrentPTADetails. PTA found: " + str(currentPTA), tag="TOMs panel")

            return currentPTA, ptaMaxStayID, ptaNoReturnTimeID

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

        #QgsMessageLog.logMessage("In getPolygonForRestriction.", tag="TOMs panel")

        line = generateGeometryUtils.getLineForAz(restriction)

        if line:
            if len(line) == 0:
                return 0

            testPt = line[0]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)
            #QgsMessageLog.logMessage("In getPolygonForRestriction." + str(testPt.x()), tag="TOMs panel")

            for poly in layer.getFeatures():
                if poly.geometry().contains(QgsGeometry.fromPointXY(testPt)):
                    #QgsMessageLog.logMessage("In getPolygonForRestriction. feature found", tag="TOMs panel")
                    return poly

        return None

    @staticmethod
    def getCPZWaitingTimeID(cpzNr):

        #QgsMessageLog.logMessage("In getCPZWaitingTimeID", tag="TOMs panel")

        CPZLayer = QgsProject.instance().mapLayersByName("CPZs")[0]

        for poly in CPZLayer.getFeatures():

            currentCPZ = poly.attribute("CPZ")
            if currentCPZ == cpzNr:
                #QgsMessageLog.logMessage("In getCPZWaitingTimeID. Found CPZ.", tag="TOMs panel")
                cpzWaitingTimeID = poly.attribute("WaitingTimeID")
                #QgsMessageLog.logMessage("In getCPZWaitingTimeID. ID." + str(cpzWaitingTimeID), tag="TOMs panel")
                return cpzWaitingTimeID

        return None

    @staticmethod
    def getTariffZoneDetails(tpaNr):

        #QgsMessageLog.logMessage("In getTariffZoneDetails", tag="TOMs panel")

        tpaLayer = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]

        for poly in tpaLayer.getFeatures():

            currentPTA = poly.attribute("Name")
            if currentPTA == tpaNr:
                #QgsMessageLog.logMessage("In getTariffZoneDetails. Found PTA.", tag="TOMs panel")
                ptaTimePeriodID = poly.attribute("TimePeriodID")
                ptaMaxStayID = poly.attribute("MaxStayID")
                ptaNoReturnTimeID = poly.attribute("NoReturnTimeID")
                #QgsMessageLog.logMessage("In getTariffZoneMaxStayID. ID." + str(ptaMaxStayID), tag="TOMs panel")
                return ptaTimePeriodID, ptaMaxStayID, ptaNoReturnTimeID

        return None, None, None

    @staticmethod
    def getTariffZoneMaxStayID(tpaNr):

        #QgsMessageLog.logMessage("In getTariffZoneMaxStayID", tag="TOMs panel")

        tpaLayer = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]

        for poly in tpaLayer.getFeatures():

            currentPTA = poly.attribute("Name")
            if currentPTA == tpaNr:
                #QgsMessageLog.logMessage("In getTariffZoneMaxStayID. Found PTA.", tag="TOMs panel")
                ptaMaxStayID = poly.attribute("MaxStayID")
                #QgsMessageLog.logMessage("In getTariffZoneMaxStayID. ID." + str(ptaMaxStayID), tag="TOMs panel")
                return ptaMaxStayID

        return None

    @staticmethod
    def getTariffZoneNoReturnID(tpaNr):

        #QgsMessageLog.logMessage("In getTariffZoneNoReturnID", tag="TOMs panel")

        tpaLayer = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]

        for poly in tpaLayer.getFeatures():

            currentPTA = poly.attribute("Name")
            if currentPTA == tpaNr:
                #QgsMessageLog.logMessage("In getTariffZoneNoReturnID. Found PTA.", tag="TOMs panel")
                ptaNoReturnID = poly.attribute("NoReturnTimeID")
                #QgsMessageLog.logMessage("In getTariffZoneNoReturnID. ID." + str(ptaNoReturnID), tag="TOMs panel")
                return ptaNoReturnID

        return None

    @staticmethod
    def getTariffZoneTimePeriodID(tpaNr):

        #QgsMessageLog.logMessage("In getTariffZoneTimePeriodID", tag="TOMs panel")

        tpaLayer = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]

        for poly in tpaLayer.getFeatures():

            currentPTA = poly.attribute("Name")
            if currentPTA == tpaNr:
                #QgsMessageLog.logMessage("In getTariffZoneTimePeriodID. Found PTA.", tag="TOMs panel")
                ptaTimePeriodID = poly.attribute("TimePeriodID")
                #QgsMessageLog.logMessage("In getTariffZoneTimePeriodID. ID." + str(ptaTimePeriodID), tag="TOMs panel")
                return ptaTimePeriodID

        return None

    @staticmethod
    def getAdjacentGridSquares(currGridSquare):

        #QgsMessageLog.logMessage("In getAdjacentGridSquares", tag="TOMs panel")

        CPZLayer = QgsProject.instance().mapLayersByName("MapGrid")[0]

        for poly in CPZLayer.getFeatures():

            currentCPZ = poly.attribute("zone_no")
            if currentCPZ == cpzNr:
                #QgsMessageLog.logMessage("In getAdjacentGridSquares. Found CPZ.", tag="TOMs panel")
                cpzWaitingTimeID = poly.attribute("WaitingTimeID")
                #QgsMessageLog.logMessage("In getAdjacentGridSquares. ID." + str(cpzWaitingTimeID), tag="TOMs panel")
                return cpzWaitingTimeID

        return None
