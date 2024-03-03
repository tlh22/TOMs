#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock/Matthias Kuhn 2017

from qgis.PyQt.QtCore import (
    QObject,
    QDate,
    pyqtSignal
)

from qgis.PyQt.QtWidgets import (
    QMessageBox,
    QAction
)

from TOMs.core.TOMsMessageLog import TOMsMessageLog
from qgis.core import (
    Qgis,
    QgsMessageLog, QgsFeature, QgsGeometry, QgsGeometryUtils,
    QgsFeatureRequest,
    QgsRectangle, QgsPointXY, QgsWkbTypes, NULL
)

from ..constants import (
    ProposalStatus,
    RestrictionAction,
    RestrictionLayers,
    RestrictionGeometryTypes
)

from abc import ABCMeta, abstractstaticmethod, abstractmethod
from TOMs.restrictionTypeUtilsClass import TOMsParams, TOMsConfigFile
from TOMs.generateGeometryUtils import generateGeometryUtils

class TOMsGeometryElement(QObject):
    def __init__(self, currFeature):
        super().__init__()

        TOMsMessageLog.logMessage("In TOMsGeometryElement.init: " + str(currFeature.attribute("GeometryID")), level=Qgis.Info)

        params = TOMsParams()
        params.getParams()

        self.configFileObject = TOMsConfigFile()
        self.configFileObject.initialiseTOMsConfigFile()

        self.currFeature = currFeature
        self.BayWidth = float(params.setParam("BayWidth"))
        self.BayLength = float(params.setParam("BayLength"))
        self.BayOffsetFromKerb = float(params.setParam("BayOffsetFromKerb"))
        self.LineOffsetFromKerb = float(params.setParam("LineOffsetFromKerb"))
        self.CrossoverShapeWidth = float(params.setParam("CrossoverShapeWidth"))
        self.CarriagewayOffset = float(params.setParam("CarriagewayOffset"))

        self.currRestGeomType = currFeature.attribute("GeomShapeID")
        
        # check for offset type
        if self.currRestGeomType > 100:
            self.BayOffsetFromKerb = self.BayOffsetFromKerb + self.CarriagewayOffset
            self.LineOffsetFromKerb = self.LineOffsetFromKerb + self.CarriagewayOffset
            self.BayWidth = self.BayWidth + self.CarriagewayOffset
            
        try:
            self.currAzimuthToCentreLine = float(currFeature.attribute("AzimuthToRoadCentreLine"))
        except Exception as e:
            self.currAzimuthToCentreLine = 0.0

        self.nrBays = 0
        self.currBayOrientation = 0.0

        TOMsMessageLog.logMessage("In TOMsGeometryElement.init: checking for bay ", level=Qgis.Info)

        if self.checkFeatureIsBay(self.currRestGeomType) == True:
            # NrBays

            # TODO: Include configuration item - ShowBayDivisions

            if self.getShowBayDivisions() == False:
                self.nrBays = -1
            else:
                try:
                    self.nrBays = float(currFeature.attribute("NrBays"))
                except KeyError as e:
                    TOMsMessageLog.logMessage("In TOMsGeometryElement.init: NrBays not present {}".format(e),
                                              level=Qgis.Warning)
                    self.nrBays = -1

            # BayOrientation
            try:
                self.currBayOrientation = currFeature.attribute("BayOrientation")
            except KeyError as e:
                TOMsMessageLog.logMessage("In TOMsGeometryElement.init: BayOrientation not present {}".format(e),
                                      level=Qgis.Info)
                self.currBayOrientation = 0

            try:
                thisBayWidth = currFeature.attribute("BayWidth")
            except KeyError as e:
                TOMsMessageLog.logMessage("In TOMsGeometryElement.init: BayWidth not present {}".format(e),
                                      level=Qgis.Info)
                thisBayWidth = NULL

            if thisBayWidth != NULL:  # https://gis.stackexchange.com/questions/216018/importing-null-in-pyqgis
                self.BayWidth = float(thisBayWidth)
                TOMsMessageLog.logMessage("In TOMsGeometryElement.init: changing BayWidth to {}".format(thisBayWidth),
                                          level=Qgis.Info)

        TOMsMessageLog.logMessage("In TOMsGeometryElement.init: finished ", level=Qgis.Info)

    @abstractmethod
    def getElementGeometry(self):
        """ This is the final shape - uses functions below. It really is abstract """

    def getShowBayDivisions(self):
        value = self.configFileObject.getTOMsConfigElement('TOMsLayers', 'ShowBayDivisions')
        if value == 'True':
            return True
        return False

    def checkFeatureIsBay(self, restGeomType):   # possibly put at Element level ...
        #TOMsMessageLog.logMessage("In TOMsGeometryElement.checkFeatureIsBay: restGeomType = " + str(restGeomType), level=Qgis.Info)
        if restGeomType < 10 or (restGeomType >=20 and restGeomType < 30) or (restGeomType == 101 or restGeomType == 121):
            return True
        else:
            return False

    def generatePolygon(self, listGeometryPairs):
        # ... and combine the two paired geometries. NB: May be more than one pair

        TOMsMessageLog.logMessage("In generatePolygon ... nr pairs: {}".format(len(listGeometryPairs)), level=Qgis.Info)

        #outputGeometry = QgsGeometry()

        for (shape, line) in listGeometryPairs:

            TOMsMessageLog.logMessage("In generatePolygon:  shape ********: " + shape.asWkt(), level=Qgis.Info)
            TOMsMessageLog.logMessage("In generatePolygon:  line ********: " + line.asWkt(),
                                     level=Qgis.Info)

            newGeometry = shape.combine(line)
            TOMsMessageLog.logMessage("In generatePolygon:  newGeometry type: {} ".format(QgsWkbTypes.displayString(newGeometry.wkbType())),
                                     level=Qgis.Info)

            #TOMsMessageLog.logMessage("In generatePolygon:  new geom type ********: {}: {}".format(newGeometry.wkbType(), newGeometry.asWkt()),
            #                         level=Qgis.Info)

            if newGeometry.wkbType() == QgsWkbTypes.MultiLineString:

                #TOMsMessageLog.logMessage(
                #    "In generatePolygon: creating multi  ...", level=Qgis.Info)
                linesList = newGeometry.asMultiPolyline()

                outputGeometry = QgsGeometry.fromPolygonXY(linesList)
                """for verticesList in linesList:

                    res = outputGeometry.addPointsXY(verticesList.asPolyline(), QgsWkbTypes.PolygonGeometry)
                    if res != QgsGeometry.OperationResult.Success:
                        TOMsMessageLog.logMessage(
                            "In generatePolygon: NOT able to add part  ...", level=Qgis.Info)"""

            else:

                #TOMsMessageLog.logMessage(
                #    "In generatePolygon: creating single?  ...", level=Qgis.Info)

                # It seems that .addPointsXY has been removed from the API. To get around this, convert to multi type and ...
                #newGeometry.convertToMultiType ()
                #linesList = newGeometry.asMultiPolyline()
                #TOMsMessageLog.logMessage(
                #    "In generatePolygon: creating single 2?  ...: {}".format(linesList), level=Qgis.Info)
                #outputGeometry = QgsGeometry.fromPolygonXY(linesList)

                #res = outputGeometry.addPartGeometry(newGeometry.asPolyline())
                #res = outputGeometry.addPartGeometry(newGeometry)

                outputGeometry = QgsGeometry.fromPolygonXY([newGeometry.asPolyline()])
                
                """
                res = outputGeometry.addPointsXY(newGeometry.asPolyline(), QgsWkbTypes.PolygonGeometry)

                if res != QgsGeometry.OperationResult.Success:
                    TOMsMessageLog.logMessage(
                        "In generatePolygon: NOT able to add part  ...", level=Qgis.Info)
                """
                TOMsMessageLog.logMessage(
                    "In generatePolygon: after creating single  ...", level=Qgis.Info)

        #TOMsMessageLog.logMessage(
        #    "In generatePolygon:  outputGeometry ********: {}".format(outputGeometry.asWkt()),
        #    level=Qgis.Info)
        return outputGeometry

    def generateMultiLineShape(self, listGeometries):
        # ... and combine the geometries. NB: May be more than one

        TOMsMessageLog.logMessage("In generateMultiLineShape ... nr pairs: {}".format(len(listGeometries)), level=Qgis.Info)

        outputGeometry = listGeometries[0]
        outputGeometry.convertToMultiType()

        for i in range(1, len(listGeometries)):

            listGeometries[i].convertToMultiType()
            outputGeometry = outputGeometry.combine(listGeometries[i])

        return outputGeometry

    def getLine(self, AzimuthToCentreLine=None):

        TOMsMessageLog.logMessage("In getLine ... ", level=Qgis.Info)

        if AzimuthToCentreLine is None:
            AzimuthToCentreLine = self.currAzimuthToCentreLine
        return self.getShape(self.LineOffsetFromKerb, AzimuthToCentreLine, self.LineOffsetFromKerb)

    def getShape(self, shpExtent=None, AzimuthToCentreLine=None, offset=None):

        TOMsMessageLog.logMessage("In getShape ... ", level=Qgis.Info)

        feature = self.currFeature
        restGeomType = self.currRestGeomType
        orientation = self.currBayOrientation

        if shpExtent is None:
            shpExtent = self.BayWidth
        if AzimuthToCentreLine is None:
            AzimuthToCentreLine = self.currAzimuthToCentreLine
        if offset is None:
            offset = self.BayOffsetFromKerb
        """
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

        ptsList = []
        parallelPtsList = []
        nextAz = 0
        diffEchelonAz = 0

        # now loop through each of the vertices and process as required. New geometry points are added to ptsList

        for i in range(len(line) - 1):

            # TOMsMessageLog.logMessage("In getDisplayGeometry: i = " + str(i), level=Qgis.Info)
            Az = generateGeometryUtils.checkDegrees(line[i].azimuth(line[i + 1]))
            # TOMsMessageLog.logMessage("In getShape: geometry: " + str(line[i].x()) + ":" + str(line[i].y()) + " " + str(line[i+1].x()) + ":" + str(line[i+1].y()) + " " + str(Az), level=Qgis.Info)

            # if this is the first point

            if i == 0:
                # determine which way to turn towards CL
                #TOMsMessageLog.logMessage("In generate_display_geometry: considering first point", level=Qgis.Info)

                Turn = generateGeometryUtils.turnToCL(Az, AzimuthToCentreLine)

                newAz = generateGeometryUtils.checkDegrees(Az + Turn)
                #TOMsMessageLog.logMessage("In getShape: newAz: " + str(newAz) + "; turn is " + str(Turn), level=Qgis.Info)
                cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)

                initial_cosa = cosa
                initial_cosb = cosb

                # TOMsMessageLog.logMessage("In generate_display_geometry: cosa : " + str(cosa) + " " + str(cosb), level=Qgis.Info)

                # dx = float(offset) * cosa
                # dy = float(offset) * cosb

                # TOMsMessageLog.logMessage("In generate_display_geometry: dx: " + str(dx) + " dy: " + str(dy), level=Qgis.Info)

                ptsList.append(
                    QgsPointXY(line[i].x() + (float(offset) * cosa), line[i].y() + (float(offset) * cosb)))

                parallelPtsList.append(
                    QgsPointXY(line[i].x() + (float(offset) * cosa), line[i].y() + (float(offset) * cosb)))
                # TOMsMessageLog.logMessage("In geomType: added point 1 ", level=Qgis.Info)

                # Now add the point at the extent. If it is an echelon bay:
                #   a. calculate the difference between the first Az and the echelon Az (??), and
                #   b. adjust the angle
                #   c. *** also need to adjust the length *** Not yet implemented

                # if restGeomType == 5 or restGeomType == 25:  # echelon
                if restGeomType in [5, 25, 9, 29]:  # echelon
                    # TOMsMessageLog.logMessage("In getShape: orientation: " + str(orientation), level=Qgis.Info)
                    if self.is_float(orientation) == False:
                        orientation = AzimuthToCentreLine

                    # TOMsMessageLog.logMessage("In getShape: orientation: " + str(float(orientation)), level=Qgis.Info)

                    diffEchelonAz1 = float(orientation) - newAz
                    # TOMsMessageLog.logMessage("In getShape: diffEchelonAz1: " + str(diffEchelonAz1), level=Qgis.Info)

                    diffEchelonAz = generateGeometryUtils.checkDegrees(diffEchelonAz1)
                    #TOMsMessageLog.logMessage("In getShape: newAz: " + str(newAz) + " diffEchelonAz1: " + str(diffEchelonAz1) + " diffEchelonAz: " + str(diffEchelonAz),
                    #                         level=Qgis.Info)

                    newAz = generateGeometryUtils.checkDegrees(newAz + diffEchelonAz)
                    #TOMsMessageLog.logMessage("In getShape: newAz: " + str(newAz) + " diffEchelonAz: " + str(diffEchelonAz),
                    #                         level=Qgis.Info)
                    cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)

                ptsList.append(
                    QgsPointXY(line[i].x() + (float(shpExtent) * cosa),
                             line[i].y() + (float(shpExtent) * cosb)))
                # TOMsMessageLog.logMessage("In geomType: added point 2 ", level=Qgis.Info)

                # ptsList.append(newPoint)
                # TOMsMessageLog.logMessage("In geomType: after append ", level=Qgis.Info)

                # ptsList.append(QgsPoint(line[i].x()+(float(bayWidth)*cosa), line[i].y()+(float(bayWidth)*cosb)))

            else:

                # now pass along the feature

                # TOMsMessageLog.logMessage("In generate_display_geometry: considering point: " + str(i), level=Qgis.Info)

                # need to work out half of bisected angle

                #TOMsMessageLog.logMessage("In generate_display_geometry: prevAz: " + str(prevAz) + " currAz: " + str(Az), level=Qgis.Info)

                newAz, distWidth = generateGeometryUtils.calcBisector(prevAz, Az, Turn, shpExtent)
                newAzOffset, distOffset = generateGeometryUtils.calcBisector(prevAz, Az, Turn, offset)
                # TOMsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), level=Qgis.Info)

                cosa, cosb = generateGeometryUtils.cosdir_azim(newAz + diffEchelonAz)
                ptsList.append(
                    QgsPointXY(line[i].x() + (float(distWidth) * cosa), line[i].y() + (float(distWidth) * cosb)))

                # issue when kerbline is horizontal causing difference in signs between distWidth and offset ...
                #TOMsMessageLog.logMessage("In generate_display_geometry: line[{}]: x: {}; y: {}; dist {}; offset {}".format(i, line[i].x(), line[i].y(), distWidth, distOffset), level=Qgis.Warning)
                #TOMsMessageLog.logMessage("In generate_display_geometry: newAz: {}; diffEchelonAz; {}; cosa: {}; cosb: {} ".format(newAz, diffEchelonAz, cosa, cosb), level=Qgis.Warning)
                #TOMsMessageLog.logMessage("In generate_display_geometry: different signs for cos: {}".format(generateGeometryUtils.same_sign(cosa, initial_cosa)), level=Qgis.Warning)

                this_offset = distOffset
                if distWidth < 0.0:
                    if not generateGeometryUtils.same_sign(distWidth, distOffset):
                        this_offset = generateGeometryUtils.change_sign(distOffset)

                parallelPtsList.append(
                    QgsPointXY(line[i].x() + (float(this_offset) * cosa), line[i].y() + (float(this_offset) * cosb)))
            # TOMsMessageLog.logMessage("In generate_display_geometry: point appended", level=Qgis.Info)

            prevAz = Az

            #TOMsMessageLog.logMessage("In generate_display_geometry: newPoint 1: " + str(ptsList[1].x()) + " " + str(ptsList[1].y()), level=Qgis.Warning)

            # have reached the end of the feature. Now need to deal with last point.
            # Use Azimuth from last segment but change the points

            # TOMsMessageLog.logMessage("In generate_display_geometry: feature processed. Now at last point ", level=Qgis.Info)

            # standard bay
        newAz = generateGeometryUtils.checkDegrees(Az + Turn + diffEchelonAz)
        # TOMsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), level=Qgis.Info)
        cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)

        ptsList.append(QgsPointXY(line[len(line) - 1].x() + (float(shpExtent) * cosa),
                                line[len(line) - 1].y() + (float(shpExtent) * cosb)))

        # add end point (without any consideration of Echelon)

        newAz = Az + Turn
        cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)

        ptsList.append(QgsPointXY(line[len(line) - 1].x() + (float(offset) * cosa),
                                line[len(line) - 1].y() + (float(offset) * cosb)))
        parallelPtsList.append(QgsPointXY(line[len(line) - 1].x() + (float(offset) * cosa),
                                line[len(line) - 1].y() + (float(offset) * cosb)))

        newLine = QgsGeometry.fromPolylineXY(ptsList)
        if not newLine.isSimple():    # https://gis.stackexchange.com/questions/353194/how-to-find-the-line-is-self-intersected-or-not-in-python-using-qgis
            TOMsMessageLog.logMessage("In TOMsGeometryElement.getShape: newLine is self-intersecting for {}. Resolving ... ".format(self.currFeature.attribute("GeometryID")), level=Qgis.Warning)
            newLine = self.resolveSelfIntersections(ptsList)

        #parallelPtsList.reverse()
        parallelLine = QgsGeometry.fromPolylineXY(parallelPtsList)
        if not parallelLine.isSimple():    # https://gis.stackexchange.com/questions/353194/how-to-find-the-line-is-self-intersected-or-not-in-python-using-qgis
            TOMsMessageLog.logMessage("In TOMsGeometryElement.getShape: parallelLine is self-intersecting for {}. Resolving ... ".format(self.currFeature.attribute("GeometryID")),
                                      level=Qgis.Warning)
            parallelLine = self.resolveSelfIntersections(parallelPtsList)

        # TOMsMessageLog.logMessage("In getDisplayGeometry:  newLine ********: " + newLine.asWkt(), level=Qgis.Info)
        # TOMsMessageLog.logMessage("In getDisplayGeometry:  parallelLine ********: " + parallelLine.asWkt(), level=Qgis.Info)

        return newLine, parallelLine

    def is_float(self, value):
        try:
            float(value)
            return True
        except:
            return False

    def resolveSelfIntersections(self, ptsList):
        """
        Deal with any self-intersecting lines. Process is:
        Loop through all line segments
            get last intersection in list
            add last intersection point to list and ignore all points from startVertex to here.
            new line is intersection point to end vertex of intersected line
        """
        nrPts = len(ptsList)
        #print("Nr pts: {}".format(nrPts))
        TOMsMessageLog.logMessage("In TOMsGeometryElement.resolveSelfIntersections: Nr pts: {}".format(nrPts),
                                  level=Qgis.Info)
        currStartVertexNr = 0
        currLineStartVertex = ptsList[0]
        newPtsList = []

        newPtsList.append(QgsPointXY(currLineStartVertex))

        while True:
            currLine = QgsGeometry.fromPolylineXY([currLineStartVertex, ptsList[currStartVertexNr + 1]])
            intersectLineStartVertexNr = -1

            #print("Starting {} ... ".format(currStartVertexNr))
            TOMsMessageLog.logMessage("In TOMsGeometryElement.resolveSelfIntersections: Starting {} ... ".format(currStartVertexNr),
                                      level=Qgis.Info)

            for testVertexNr in range(currStartVertexNr + 1, nrPts - 1):
                print("StartPt {}: EndPt: {}".format(testVertexNr, testVertexNr + 1))
                testLine = QgsGeometry.fromPolylineXY([ptsList[testVertexNr], ptsList[testVertexNr + 1]])
                intersectPt = currLine.intersection(testLine)
                if intersectPt:
                    # TODO: deal with situation where intersection is a line, i.e., colinear ...
                    if intersectPt.type() == QgsWkbTypes.PointGeometry:
                        intersectLineStartVertexNr = testVertexNr
                        nextPt = intersectPt

            #print("Finished line intersection check: {} ... ".format(intersectLineStartVertexNr))
            TOMsMessageLog.logMessage("In TOMsGeometryElement.resolveSelfIntersections: Finished line intersection check: {} ... ".format(intersectLineStartVertexNr),
                                      level=Qgis.Info)

            if intersectLineStartVertexNr > 0:
                # intersect was found
                newPt = nextPt.asPoint()
                newPtsList.append(newPt)
                currLineStartVertex = newPt
                currStartVertexNr = intersectLineStartVertexNr
            else:
                newPtsList.append(ptsList[currStartVertexNr + 1])
                currStartVertexNr = currStartVertexNr + 1
                currLineStartVertex = ptsList[currStartVertexNr]

            #print("Added {} ...".format(currStartVertexNr))
            TOMsMessageLog.logMessage("In TOMsGeometryElement.resolveSelfIntersections: Added {} ...".format(currStartVertexNr),
                                      level=Qgis.Info)

            if currStartVertexNr == nrPts - 1:  # check to see if the end point of the test line is the end of the line ...
                break

        #print("Finished checking ...")
        TOMsMessageLog.logMessage(
            "In TOMsGeometryElement.resolveSelfIntersections: Finished checking ...",
            level=Qgis.Info)

        newGeom = QgsGeometry.fromPolylineXY(newPtsList)

        return newGeom

    def getZigZag(self, wavelength=None, shpExtent=None):

        TOMsMessageLog.logMessage("In getZigZag ... ", level=Qgis.Info)

        if not wavelength:
            wavelength = 3.0
        if not shpExtent:
            shpExtent = self.BayWidth / 2
        offset = self.BayOffsetFromKerb

        line = generateGeometryUtils.getLineForAz(self.currFeature)
        if len(line) == 0:
            return 0

        ptsList = []

        length = self.currFeature.geometry().length()

        NrSegments = int(length / wavelength)    # e.g., length = 33, wavelength = 4
        if NrSegments == 0:
            NrSegments = 1
            TOMsMessageLog.logMessage(
                "In getZigZag. NrSegments is 0 for geometry {}".format(self.currFeature.attribute("GeometryID")), level=Qgis.Info)
        interval = int(length/float(NrSegments) * 10000) / 10000

        TOMsMessageLog.logMessage("In getZigZag. LengthLine: " + str(length) + " NrSegments = " + str(NrSegments) + "; interval: " + str(interval), level=Qgis.Info)

        Az = line[0].azimuth(line[1])

        # TOMsMessageLog.logMessage("In getZigZag. Az = " + str(Az) + "; AzCL = " + str(self.currAzimuthToCentreLine) + "; line[0]: " + line[0].asWkt() + "; line[1]: " + line[1].asWkt(), level=Qgis.Info)

        Turn = generateGeometryUtils.turnToCL(Az, self.currAzimuthToCentreLine)

        newAz = Az + Turn
        # TOMsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), level=Qgis.Info)
        cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)

        # deal with two points
        ptsList.append(
            QgsPointXY(line[0].x() + (float(offset) * cosa), line[0].y() + (float(offset) * cosb)))

        ptsList.append(
            QgsPointXY(line[0].x() + ((float(shpExtent)+float(offset)) * cosa),
                     line[0].y() + ((float(shpExtent)+float(offset)) * cosb)))

        distanceAlongLine = 0.0
        countSegments = 0
        while countSegments < (NrSegments):

            countSegments = countSegments + 1

            distanceAlongLine = distanceAlongLine + interval / 2

            interpolatedPointC = self.currFeature.geometry().interpolate(distanceAlongLine).asPoint()

            TOMsMessageLog.logMessage("In getZigZag. PtC = " + str(interpolatedPointC.x()) + ": " + str(interpolatedPointC.y()) + "; distanceAlongLine = " + str(distanceAlongLine), level=Qgis.Info)
            # TOMsMessageLog.logMessage("In getZigZag. offset = " + str(float(offset)) + "; cosa = " + str(cosa) + "; cosb = " + str(cosb), level=Qgis.Info)

            TOMsMessageLog.logMessage("In getZigZag. newC x = " + str(interpolatedPointC.x() + (float(offset) * cosa)) + "; y = " + str(interpolatedPointC.y() + (float(offset) * cosb)), level=Qgis.Info)

            ptsList.append(QgsPointXY(interpolatedPointC.x() + (float(offset) * cosa), interpolatedPointC.y() + (float(offset) * cosb)))

            distanceAlongLine = distanceAlongLine+interval/2

            interpolatedPointD = self.currFeature.geometry().interpolate(distanceAlongLine).asPoint()

            # TOMsMessageLog.logMessage("In getZigZag. PtD = " + interpolatedPointD.asWkt() + "; distanceAlongLine = " + str(distanceAlongLine), level=Qgis.Info)

            ptsList.append(QgsPointXY(interpolatedPointD.x() + ((float(shpExtent)+float(offset)) * cosa),
                     interpolatedPointD.y() + ((float(shpExtent)+float(offset)) * cosb)))

        # deal with last point
        ptsList.append(
            QgsPointXY(line[len(line) - 1].x() + (float(offset) * cosa),
                     line[len(line) - 1].y() + (float(offset) * cosb)))

        newLine = QgsGeometry.fromPolylineXY(ptsList)

        return newLine


    def getBayDividers(self, bayShapeGeom, parallelShapeGeom, shpExtent=None, AzimuthToCentreLine=None, offset=None):

        # returns list of bay dividing lines

        TOMsMessageLog.logMessage(
                "In getBayDividers. geometry {}".format(self.currFeature.attribute("GeometryID")), level=Qgis.Info)

        if shpExtent is None:
            shpExtent = self.BayWidth
        if offset is None:
            offset = self.BayOffsetFromKerb
        if AzimuthToCentreLine is None:
            AzimuthToCentreLine = self.currAzimuthToCentreLine

        TOMsMessageLog.logMessage(
                "In getBayDividers. AzimuthToCentreLine {}".format(AzimuthToCentreLine), level=Qgis.Info)

        # slightly extend the length of the dividers to deal with any rounding errors in the split process
        #shpExtent = shpExtent + 0.0001
        #offset = offset - 0.0001

        # get the bay shape "outside line"
        bayShapeLine = bayShapeGeom.asPolyline()
        outsideBayShapeLine = bayShapeLine[1:len(bayShapeLine) - 1]
        outsideBayShapeLineGeom = QgsGeometry.fromPolylineXY(outsideBayShapeLine)

        TOMsMessageLog.logMessage(
                "In getBayDividers. outsideBayShapeLineGeom {}".format(outsideBayShapeLineGeom.asWkt()), level=Qgis.Info)

        feature = self.currFeature
        restGeomType = self.currRestGeomType
        orientation = self.currBayOrientation

        newLines = []
        currGeom = self.currFeature.geometry()

        #line = generateGeometryUtils.getLineForAz(self.currFeature)
        line = parallelShapeGeom.asPolyline()

        if len(line) == 0:
            return None

        # get Az and calc turn to CL

        Az = generateGeometryUtils.checkDegrees(line[0].azimuth(line[1]))
        Turn = generateGeometryUtils.turnToCL(Az, AzimuthToCentreLine)
        #newAz = generateGeometryUtils.checkDegrees(Az + Turn)

        if restGeomType in [5, 25, 9, 29]:  # echelon
            if self.is_float(orientation) == False:
                orientation = AzimuthToCentreLine

        length = currGeom.length()

        NrSegments = self.nrBays

        interval = int(length/float(NrSegments) * 10000) / 10000

        TOMsMessageLog.logMessage("In getBayDividers. LengthLine: " + str(length) + " NrSegments = " + str(NrSegments) + "; interval: " + str(interval), level=Qgis.Info)

        distanceAlongLine = 0.0
        countSegments = 0
        while countSegments < (NrSegments-1):

            ptsList = []
            countSegments = countSegments + 1

            distanceAlongLine = distanceAlongLine + interval

            interpolatedPointC = currGeom.interpolate(distanceAlongLine).asPoint()

            # now need to find the two vertices around this point and determine the azimuth ...

            distSquared, closestPt, vertexNrAfterPt, leftOf = currGeom.closestSegmentWithContext(interpolatedPointC)

            Az = generateGeometryUtils.checkDegrees(QgsPointXY(currGeom.vertexAt(vertexNrAfterPt-1)).azimuth(QgsPointXY(currGeom.vertexAt(vertexNrAfterPt))))
            newAz = generateGeometryUtils.checkDegrees(Az + Turn)

            if restGeomType in [5, 25, 9, 29]:  # echelon
                diffEchelonAz1 = float(orientation) - newAz
                diffEchelonAz = generateGeometryUtils.checkDegrees(diffEchelonAz1)
                newAz = generateGeometryUtils.checkDegrees(newAz + diffEchelonAz)

            TOMsMessageLog.logMessage("In getBayDividers. newAz: {}".format(newAz), level=Qgis.Info)

            cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)

            TOMsMessageLog.logMessage("In getBayDividers. PtC = " + str(interpolatedPointC.x()) + ": " + str(interpolatedPointC.y()) + "; distanceAlongLine = " + str(distanceAlongLine), level=Qgis.Info)
            TOMsMessageLog.logMessage("In getBayDividers. newC x = " + str(interpolatedPointC.x() + (float(offset) * cosa)) + "; y = " + str(interpolatedPointC.y() + (float(offset) * cosb)), level=Qgis.Info)

            #ptsList.append(
            #    QgsPointXY(closestPt.x() + (float(offset) * cosa), closestPt.y() + (float(offset) * cosb)))
            testStartPoint = QgsPointXY(closestPt.x() + (float(offset) * cosa), closestPt.y() + (float(offset) * cosb))
            """ptsList.append(
                QgsPointXY(closestPt.x() + (float(shpExtent) * cosa),
                         closestPt.y() + (float(shpExtent) * cosb)))"""

            testEndPoint = QgsPointXY(closestPt.x() + (float(shpExtent) * cosa),
                         closestPt.y() + (float(shpExtent) * cosb))

            testPointGeom = QgsGeometry.fromPointXY(testEndPoint)
            TOMsMessageLog.logMessage("In getBayDividers. testPt x = {}; y = {}".format(testEndPoint.x(), testEndPoint.y()), level=Qgis.Info)

            testLineGeom = QgsGeometry.fromPolylineXY([testStartPoint, testEndPoint])

            # check for intersection ... on bayOutsideLines

            if parallelShapeGeom.intersects(testLineGeom):
                startPoint = testStartPoint
                TOMsMessageLog.logMessage("In getBayDividers. testLine intersects startPoint ...", level=Qgis.Info)
            else:
                # get point on bay shape from testPoint
                startPoint = parallelShapeGeom.nearestPoint(QgsGeometry.fromPointXY(testStartPoint)).asPoint()
                TOMsMessageLog.logMessage(
                    "In getBayDividers. *** new startPt x = {}; y = {}".format(startPoint.x(), startPoint.y()), level=Qgis.Info)

            if outsideBayShapeLineGeom.intersects(testLineGeom):
                endPoint = testEndPoint
                TOMsMessageLog.logMessage("In getBayDividers. testLine intersects endPoint ...", level=Qgis.Info)
            else:
                # get point on bay shape from testPoint
                endPoint = outsideBayShapeLineGeom.nearestPoint(QgsGeometry.fromPointXY(testEndPoint)).asPoint()
                TOMsMessageLog.logMessage(
                    "In getBayDividers. *** new endPt x = {}; y = {}".format(endPoint.x(), endPoint.y()), level=Qgis.Info)

            newLine = QgsGeometry.fromPolylineXY([startPoint, endPoint]).extendLine(0.0001, 0.0001)
            newLines.append(newLine)

        return newLines

    def addBayLineDividers(self, bayShapeGeom, parallelShapeGeom, shpExtent=None, AzimuthToCentreLine=None, offset=None):
        # add "legs" to bay shape to show dividers

        bayDividers = self.getBayDividers(bayShapeGeom, parallelShapeGeom, shpExtent, AzimuthToCentreLine, offset)
        outputGeometry = bayShapeGeom
        if bayDividers is not None:
            # prepare geometries list
            geomList = []
            for divider in bayDividers:
                geomList.append(divider)
            geomList.append(outputGeometry)
            return self.generateMultiLineShape(geomList)

    def addBayPolygonDividers(self, outputGeometry, bayShapeGeom, parallelShapeGeom, shpExtent=None, AzimuthToCentreLine=None, offset=None):

        TOMsMessageLog.logMessage(
            "In factory. addBayPolygonDividers ... shpExtent: {}; Az: {} ".format(shpExtent, AzimuthToCentreLine),
            level=Qgis.Info)

        # split output polygon(s) to show bay dividers
        bayDividers = self.getBayDividers(bayShapeGeom=bayShapeGeom, parallelShapeGeom=parallelShapeGeom, shpExtent=shpExtent, AzimuthToCentreLine=AzimuthToCentreLine, offset=offset)
        if bayDividers is not None:
            # prepare geometries list
            outputGeometries = [outputGeometry]

            TOMsMessageLog.logMessage(
                "In factory. addBayPolygonDividers ... nr dividers: {}".format(len(bayDividers)),
                level=Qgis.Info)
            for divider in bayDividers:
                # divGeometry = QgsGeometry()
                # res = divGeometry.addPointsXY(divider.asPolyline(), QgsWkbTypes.LineGeometry)
                TOMsMessageLog.logMessage(
                    "In factory. divider : {}".format(divider.asWkt()),
                    level=Qgis.Info)

                newGeomsList = []
                for outGeom in outputGeometries:
                    result, extraGeometriesList, topologyTestPointsList = outGeom.splitGeometry(
                        divider.asPolyline(), True)
                    newGeomsList.append(outGeom)
                    for geom in extraGeometriesList:
                        newGeomsList.append(geom)
                outputGeometries = newGeomsList
                TOMsMessageLog.logMessage(
                    "In factory. addBayPolygonDividers ... nr outputGeometries: {}".format(
                        len(outputGeometries)),
                    level=Qgis.Info)

            # now combine all the output polygons
            newGeom = QgsGeometry()
            newGeom = outputGeometries[0]
            for i in range(1, len(outputGeometries)):
                newGeom.addPartGeometry(outputGeometries[i])

            outputGeometry = newGeom

            TOMsMessageLog.logMessage(
                "In addPolygonDividers ... split geom: {}".format(outputGeometry.asWkt()),
                level=Qgis.Info)

        return outputGeometry

""" ***** """

class generatedGeometryBayLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryBayLineType ... ", level=Qgis.Info)

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape()

        if self.nrBays > 0:
            outputGeometry = self.addBayLineDividers(outputGeometry, parallelLine)

        return outputGeometry


class generatedGeometryHalfOnHalfOffLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryHalfOnHalfOffLineType ... ", level=Qgis.Info)

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.BayWidth/2)
        outputGeometry2, parallelLine2 = self.getShape(self.BayWidth/2, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        if self.nrBays > 0:
            outputGeometry1 = self.addBayLineDividers(outputGeometry1, parallelLine1, self.BayWidth/2)
            outputGeometry2 = self.addBayLineDividers(outputGeometry2, parallelLine2, self.BayWidth/2,
                                                      generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))
        
        return self.generateMultiLineShape([outputGeometry1, outputGeometry2])


class generatedGeometryOnPavementLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryOnPavementLineType ... ", level=Qgis.Info)

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(self.BayWidth, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        if self.nrBays > 0:
            outputGeometry = self.addBayLineDividers(outputGeometry, parallelLine,
                                                     self.BayWidth, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        return outputGeometry


class generatedGeometryPerpendicularLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryPerpendicularLineType ... ", level=Qgis.Info)

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(self.BayLength)

        if self.nrBays > 0:
            outputGeometry = self.addBayLineDividers(outputGeometry, parallelLine, self.BayLength)

        return outputGeometry


class generatedGeometryEchelonLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryEchelonLineType ... ", level=Qgis.Info)

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(self.BayLength)

        if self.nrBays > 0:
            outputGeometry = self.addBayLineDividers(outputGeometry, parallelLine, self.BayLength)

        return outputGeometry


class generatedGeometryPerpendicularOnPavementLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryPerpendicularOnPavementLineType ... ", level=Qgis.Info)

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(self.BayLength, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        if self.nrBays > 0:
            outputGeometry = self.addBayLineDividers(outputGeometry, parallelLine, self.BayLength, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        return outputGeometry


class generatedGeometryOutlineShape(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryOutlineShape ... ", level=Qgis.Info)

    def getElementGeometry(self):
        return self.currFeature.geometry()


class generatedGeometryEchelonOnPavementLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryEchelonOnPavementLineType ... ", level=Qgis.Info)

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(self.BayLength, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        if self.nrBays > 0:
            outputGeometry = self.addBayLineDividers(outputGeometry, parallelLine,
                                                     self.BayLength, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        return outputGeometry


class generatedGeometryLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryLineType ... ", level=Qgis.Info)

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getLine()
        return outputGeometry


class generatedGeometryZigZagType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryZigZagType ... ", level=Qgis.Info)

    def getElementGeometry(self):

        outputGeometry = self.getZigZag()

        return outputGeometry


class generatedGeometryBayPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryBayPolygonType ... ", level=Qgis.Info)

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape()
        #outputGeometry1A, paralletLine1A = self.getLine()

        outputGeometry = self.generatePolygon([(outputGeometry1, parallelLine1)])

        if self.nrBays > 0:
            outputGeometry = self.addBayPolygonDividers(outputGeometry, outputGeometry1, parallelLine1)

        TOMsMessageLog.logMessage("In factory. generatedGeometryBayPolygonType ... polygon(s): {}".format(outputGeometry.asWkt()), level=Qgis.Info)

        return outputGeometry
        #return self.generatePolygon([(outputGeometry1, parallelLine1)])


class generatedGeometryHalfOnHalfOffPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryHalfOnHalfOffPolygonType ... ", level=Qgis.Info)

    def getElementGeometry(self):
        bayShape1, parallelLine1 = self.getShape((self.BayWidth)/2)
        bayShape2, parallelLine2 = self.getShape((self.BayWidth)/2, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        outputGeometry1 = self.generatePolygon([(bayShape1, parallelLine1)])
        outputGeometry2 = self.generatePolygon([(bayShape2, parallelLine2)])

        if self.nrBays > 0:
            TOMsMessageLog.logMessage("In generatedGeometryHalfOnHalfOffPolygonType ... getting bay divisions ", level=Qgis.Info)
            outputGeometry1 = self.addBayPolygonDividers(outputGeometry=outputGeometry1, bayShapeGeom=bayShape1, parallelShapeGeom=parallelLine1, shpExtent=self.BayWidth/2)
            outputGeometry2 = self.addBayPolygonDividers(outputGeometry=outputGeometry2, bayShapeGeom=bayShape2, parallelShapeGeom=parallelLine2, shpExtent=self.BayWidth/2,
                              AzimuthToCentreLine=generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        outputGeometry1.addPartGeometry(outputGeometry2)

        return outputGeometry1


class generatedGeometryOnPavementPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryOnPavementPolygonType ... ", level=Qgis.Info)

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.BayWidth, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))
        #outputGeometry1A, paralletLine1A = self.getLine(generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        #return self.generatePolygon([(outputGeometry1, outputGeometry1A)])
        #return self.generatePolygon([(outputGeometry1, parallelLine1)])
        outputGeometry = self.generatePolygon([(outputGeometry1, parallelLine1)])

        if self.nrBays > 0:
            outputGeometry = self.addBayPolygonDividers(outputGeometry, outputGeometry1, parallelLine1, shpExtent=self.BayWidth,
                                                        AzimuthToCentreLine=generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        return outputGeometry


class generatedGeometryPerpendicularPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryPerpendicularPolygonType ... ", level=Qgis.Info)

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.BayLength)
        #outputGeometry1A, paralletLine1A = self.getLine()

        #return self.generatePolygon([(outputGeometry1, outputGeometry1A)])
        #return self.generatePolygon([(outputGeometry1, parallelLine1)])
        outputGeometry = self.generatePolygon([(outputGeometry1, parallelLine1)])

        if self.nrBays > 0:
            outputGeometry = self.addBayPolygonDividers(outputGeometry, outputGeometry1, parallelLine1, self.BayLength)

        return outputGeometry


class generatedGeometryEchelonPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryEchelonPolygonType ... ", level=Qgis.Info)

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.BayLength)
        #outputGeometry1A, paralletLine1A = self.getLine()

        #return self.generatePolygon([(outputGeometry1, outputGeometry1A)])
        #return self.generatePolygon([(outputGeometry1, parallelLine1)])
        outputGeometry = self.generatePolygon([(outputGeometry1, parallelLine1)])

        if self.nrBays > 0:
            outputGeometry = self.addBayPolygonDividers(outputGeometry, outputGeometry1, parallelLine1, self.BayLength)

        return outputGeometry


class generatedGeometryPerpendicularOnPavementPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryPerpendicularOnPavementPolygonType ... ", level=Qgis.Info)

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.BayLength, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        #return self.generatePolygon([(outputGeometry1, parallelLine1)])
        outputGeometry = self.generatePolygon([(outputGeometry1, parallelLine1)])

        TOMsMessageLog.logMessage("In factory. generatedGeometryPerpendicularOnPavementPolygonType ... Az: {}".format(self.currAzimuthToCentreLine),
                                  level=Qgis.Info)

        if self.nrBays > 0:
            outputGeometry = self.addBayPolygonDividers(outputGeometry, outputGeometry1, parallelLine1, self.BayLength,
                                                        generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        TOMsMessageLog.logMessage("In factory. generatedGeometryPerpendicularOnPavementPolygonType ... polygon(s): {}".format(outputGeometry.asWkt()), level=Qgis.Info)

        return outputGeometry


class generatedGeometryOutlineBayPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryOutlineBayPolygonType ... ", level=Qgis.Info)

    def getElementGeometry(self):

        return QgsGeometry.fromPolygonXY([self.currFeature.geometry().asPolyline()])

class generatedGeometryEchelonOnPavementPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryEchelonOnPavementPolygonType ... ", level=Qgis.Info)

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.BayLength, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))
        #outputGeometry1A, paralletLine1A = self.getLine()

        #return self.generatePolygon([(outputGeometry1, outputGeometry1A)])
        #return self.generatePolygon([(outputGeometry1, parallelLine1)])
        outputGeometry = self.generatePolygon([(outputGeometry1, parallelLine1)])

        if self.nrBays > 0:
            outputGeometry = self.addBayPolygonDividers(outputGeometry, outputGeometry1, parallelLine1, self.BayLength,
                                                        generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        return outputGeometry


class generatedGeometryCrossoverPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage("In factory. generatedGeometryCrossoverPolygonType ... ", level=Qgis.Info)

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.CrossoverShapeWidth, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))
        #outputGeometry1A, paralletLine1A = self.getLine(generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        #return self.generatePolygon([(outputGeometry1, outputGeometry1A)])
        return self.generatePolygon([(outputGeometry1, parallelLine1)])

""" ***** SIGNS  ***** """
"""
class generatedGeometrySignType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometrySignType ... ", tag="TOMs panel")

        try:
            self.signOrientation = self.currFeature.attribute("SignOrientation")
        except KeyError as e:
            self.signOrientation = None

    def getElementGeometry(self):

        if not self.signOrientation:
            return None

        QgsMessageLog.logMessage('getSignLine - orientation: {}'.format(self.signOrientation), tag="TOMs2 panel")

        lineGeom = None
        if self.signOrientation is None:
            return None

        orientationList = generateGeometryUtils.getSignOrientation(self.currFeature, lineLayer)

        # Now generate a line in the appropriate direction
        if orientationList[1]:
            # work out the length of the line based on the number of plates in the sign
            platesInSign = generateGeometryUtils.getPlatesInSign(self.currFeature)
            nrPlatesInSign = len(platesInSign)
            #QgsMessageLog.logMessage('getSignLine nrPlatesInSign: {}'.format(nrPlatesInSign), tag="TOMs2 panel")
            lineLength = (nrPlatesInSign + 1) * distanceForIcons
            #QgsMessageLog.logMessage('getSignLine lineLength: {}'.format(lineLength), tag="TOMs2 panel")
            print('getSignLine lineLength: {}'.format(lineLength))

            signPt = self.currFeature.geometry().asPoint()
            # generate lines
            if self.signOrientation == 1:  # "Facing in same direction as road"
                lineGeom = generateGeometryUtils.createLinewithPointAzimuthDistance(signPt, orientationList[1], lineLength)
            elif self.signOrientation == 2:  # "Facing in opposite direction to road"
                lineGeom = generateGeometryUtils.createLinewithPointAzimuthDistance(signPt, orientationList[2], lineLength)
            elif self.signOrientation == 3:  # "Facing road"
                lineGeom = generateGeometryUtils.createLinewithPointAzimuthDistance(signPt, orientationList[3], lineLength)
            elif self.signOrientation == 4:  # "Facing away from road"
                lineGeom = generateGeometryUtils.createLinewithPointAzimuthDistance(signPt, orientationList[4], lineLength)
            else:
                return None

        #QgsMessageLog.logMessage('getSignLine lineGeom: {}'.format(lineGeom.asWkt()), tag="TOMs2 panel")
        return lineGeom

    def getSignOrientation(ptFeature, lineLayer):

        try:
            signOrientation = ptFeature.attribute("SignOrientation")
        except KeyError as e:
            return [None, None, None, None, None]

        #QgsMessageLog.logMessage('getSignLine - orientation: {}'.format(signOrientation), tag="TOMs2 panel")

        lineGeom = None
        if signOrientation is None:
            return [None, None, None, None, None]

        # find closest point/feature on lineLayer

        signPt = ptFeature.geometry().asPoint()
        #print('signPt: {}'.format(signPt.asWkt()))
        QgsMessageLog.logMessage('getSignLine signid: {}; signPt: {}'.format(ptFeature.attribute("fid"), signPt.asWkt()), tag="TOMs2 panel")
        closestPoint, closestFeature = generateGeometryUtils.findNearestPointOnLineLayer(signPt, lineLayer, 25)
        #QgsMessageLog.logMessage('getSignLine cloestPoint: {}'.format(closestPoint.asWkt()), tag="TOMs2 panel")

        # Now generate a line in the appropriate direction
        if closestPoint:
            # get the orientation of the line feature
            (orientationToFeature, orientationInFeatureDirection, orientationAwayFromFeature, orientationOppositeFeatureDirection) = generateGeometryUtils.getLineOrientationAtPoint(
                signPt, closestFeature)
            #QgsMessageLog.logMessage('getSignLine orientationToFeature: {}'.format(orientationToFeature), tag="TOMs2 panel")
            #print('getSignLine orientationToFeature: {}'.format(orientationToFeature))

            # make it match sign orientation
            return [0.0, orientationInFeatureDirection, orientationOppositeFeatureDirection, orientationToFeature, orientationAwayFromFeature]

        return [None, None, None, None, None]

    def getSignLine(ptFeature, lineLayer, distanceForIcons):
"""


""" ***** """

class ElementGeometryFactory():

    @staticmethod
    def getElementGeometry(currFeature, restGeomType=None):

        if restGeomType:
            currRestGeomType = restGeomType
        else:
            currRestGeomType = currFeature.attribute("GeomShapeID")
        TOMsMessageLog.logMessage("In factory. getElementGeometry " + str(currFeature.attribute("GeometryID")) + ":" + str(currRestGeomType), level=Qgis.Info)

        try:
            if currRestGeomType == RestrictionGeometryTypes.PARALLEL_BAY:
                return generatedGeometryBayLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.HALF_ON_HALF_OFF:
                return generatedGeometryHalfOnHalfOffLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.ON_PAVEMENT:
                return generatedGeometryOnPavementLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.PERPENDICULAR:
                return generatedGeometryPerpendicularLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.ECHELON:
                return generatedGeometryEchelonLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.PERPENDICULAR_ON_PAVEMENT:
                return generatedGeometryPerpendicularOnPavementLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.OTHER:
                return generatedGeometryOutlineShape(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.CENTRAL_PARKING:
                return generatedGeometryOutlineShape(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.ECHELON_ON_PAVEMENT:
                return generatedGeometryEchelonOnPavementLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.PARALLEL_LINE:
                return generatedGeometryLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.ZIG_ZAG:
                return generatedGeometryZigZagType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.PARALLEL_BAY_POLYGON:
                return generatedGeometryBayPolygonType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.HALF_ON_HALF_OFF_POLYGON:
                return generatedGeometryHalfOnHalfOffPolygonType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.ON_PAVEMENT_POLYGON:
                return generatedGeometryOnPavementPolygonType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.PERPENDICULAR_POLYGON:
                return generatedGeometryPerpendicularPolygonType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.ECHELON_POLYGON:
                return generatedGeometryEchelonPolygonType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.PERPENDICULAR_ON_PAVEMENT_POLYGON:
                return generatedGeometryPerpendicularOnPavementPolygonType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.OUTLINE_BAY_POLYGON:
                return generatedGeometryOutlineBayPolygonType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.ECHELON_ON_PAVEMENT_POLYGON:
                return generatedGeometryEchelonOnPavementPolygonType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.CROSSOVER:
                return generatedGeometryCrossoverPolygonType(currFeature).getElementGeometry()

            # Offsets
            
            elif currRestGeomType == RestrictionGeometryTypes.PARALLEL_BAY_OFFSET:
                return generatedGeometryBayLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.PARALLEL_BAY_POLYGON_OFFSET:
                return generatedGeometryBayPolygonType(currFeature).getElementGeometry()
                
            elif currRestGeomType == RestrictionGeometryTypes.PARALLEL_LINE_OFFSET:
                return generatedGeometryLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.ZIG_ZAG_OFFSET:
                return generatedGeometryZigZagType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.CROSSOVER_OFFSET:
                return generatedGeometryCrossoverPolygonType(currFeature).getElementGeometry()
                
            raise AssertionError("Restriction Geometry Type NOT found")

        except AssertionError as _e:
            TOMsMessageLog.logMessage("In ElementGeometryFactory. TYPE not found or something else ... ", level=Qgis.Info)
