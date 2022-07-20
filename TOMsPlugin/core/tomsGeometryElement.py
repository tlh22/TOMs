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

from abc import abstractmethod

from qgis.core import (
    NULL,
    Qgis,
    QgsGeometry,
    QgsPointXY,
    QgsWkbTypes,
)
from qgis.PyQt.QtCore import QObject

from ..constants import RestrictionGeometryTypes
from ..generateGeometryUtils import GenerateGeometryUtils
from ..restrictionTypeUtilsClass import TOMsConfigFile, TOMsParams
from .tomsMessageLog import TOMsMessageLog


class TOMsGeometryElement(QObject):
    def __init__(self, currFeature):
        super().__init__()

        TOMsMessageLog.logMessage(
            "In TOMsGeometryElement.init: " + str(currFeature.attribute("GeometryID")),
            level=Qgis.Info,
        )

        params = TOMsParams()
        params.getParams()

        self.configFileObject = TOMsConfigFile()
        self.configFileObject.initialiseTOMsConfigFile()
        self.currFeature = currFeature
        self.bayWidth = float(params.setParam("BayWidth"))
        self.bayLength = float(params.setParam("BayLength"))
        self.bayOffsetFromKerb = float(params.setParam("BayOffsetFromKerb"))
        self.lineOffsetFromKerb = float(params.setParam("LineOffsetFromKerb"))
        self.crossoverShapeWidth = float(params.setParam("CrossoverShapeWidth"))

        self.currRestGeomType = currFeature.attribute("GeomShapeID")

        try:
            self.currAzimuthToCentreLine = float(
                currFeature.attribute("AzimuthToRoadCentreLine")
            )
        except Exception:
            self.currAzimuthToCentreLine = 0.0

        self.nrBays = 0
        self.currBayOrientation = 0.0

        TOMsMessageLog.logMessage(
            "In TOMsGeometryElement.init: checking for bay ", level=Qgis.Info
        )

        if RestrictionGeometryTypes.isBay(self.currRestGeomType):
            # NrBays

            # TODO: Include configuration item - ShowBayDivisions

            if not self.getShowBayDivisions():
                self.nrBays = -1
            else:
                try:
                    self.nrBays = float(currFeature.attribute("NrBays"))
                except KeyError as e:
                    TOMsMessageLog.logMessage(
                        "In TOMsGeometryElement.init: NrBays not present {}".format(e),
                        level=Qgis.Warning,
                    )
                    self.nrBays = -1

            # BayOrientation
            try:
                self.currBayOrientation = currFeature.attribute("BayOrientation")
            except KeyError as e:
                TOMsMessageLog.logMessage(
                    "In TOMsGeometryElement.init: BayOrientation not present {}".format(
                        e
                    ),
                    level=Qgis.Info,
                )
                self.currBayOrientation = 0

            try:
                thisBayWidth = currFeature.attribute("BayWidth")
            except KeyError as e:
                TOMsMessageLog.logMessage(
                    "In TOMsGeometryElement.init: BayWidth not present {}".format(e),
                    level=Qgis.Info,
                )
                thisBayWidth = NULL

            if (
                thisBayWidth != NULL
            ):  # https://gis.stackexchange.com/questions/216018/importing-null-in-pyqgis
                self.bayWidth = float(thisBayWidth)
                TOMsMessageLog.logMessage(
                    "In TOMsGeometryElement.init: changing BayWidth to {}".format(
                        thisBayWidth
                    ),
                    level=Qgis.Info,
                )

        TOMsMessageLog.logMessage(
            "In TOMsGeometryElement.init: finished ", level=Qgis.Info
        )

    @abstractmethod
    def getElementGeometry(self):
        """This is the final shape - uses functions below. It really is abstract"""

    def getShowBayDivisions(self):
        value = self.configFileObject.getTOMsConfigElement(
            "TOMsLayers", "ShowBayDivisions"
        )
        if value == "True":
            return True
        return False

    def generatePolygon(self, listGeometryPairs):
        # ... and combine the two paired geometries. NB: May be more than one pair

        TOMsMessageLog.logMessage(
            "In generatePolygon ... nr pairs: {}".format(len(listGeometryPairs)),
            level=Qgis.Info,
        )

        # outputGeometry = QgsGeometry()

        for (shape, line) in listGeometryPairs:

            TOMsMessageLog.logMessage(
                "In generatePolygon:  shape ********: " + shape.asWkt(), level=Qgis.Info
            )
            TOMsMessageLog.logMessage(
                "In generatePolygon:  line ********: " + line.asWkt(), level=Qgis.Info
            )

            newGeometry = shape.combine(line)
            TOMsMessageLog.logMessage(
                "In generatePolygon:  newGeometry type: {} ".format(
                    QgsWkbTypes.displayString(newGeometry.wkbType())
                ),
                level=Qgis.Info,
            )

            if newGeometry.wkbType() == QgsWkbTypes.MultiLineString:

                # TOMsMessageLog.logMessage(
                #    "In generatePolygon: creating multi  ...", level=Qgis.Info)
                linesList = newGeometry.asMultiPolyline()

                outputGeometry = QgsGeometry.fromPolygonXY(linesList)

            else:

                outputGeometry = QgsGeometry.fromPolygonXY([newGeometry.asPolyline()])

                TOMsMessageLog.logMessage(
                    "In generatePolygon: after creating single  ...", level=Qgis.Info
                )

        # TOMsMessageLog.logMessage(
        #    "In generatePolygon:  outputGeometry ********: {}".format(outputGeometry.asWkt()),
        #    level=Qgis.Info)
        return outputGeometry

    def generateMultiLineShape(self, listGeometries):
        # ... and combine the geometries. NB: May be more than one

        TOMsMessageLog.logMessage(
            "In generateMultiLineShape ... nr pairs: {}".format(len(listGeometries)),
            level=Qgis.Info,
        )

        outputGeometry = listGeometries[0]
        outputGeometry.convertToMultiType()

        for i in range(1, len(listGeometries)):

            listGeometries[i].convertToMultiType()
            outputGeometry = outputGeometry.combine(listGeometries[i])

        return outputGeometry

    def getLine(self, azimuthToCentreLine=None):

        TOMsMessageLog.logMessage("In getLine ... ", level=Qgis.Info)

        if azimuthToCentreLine is None:
            azimuthToCentreLine = self.currAzimuthToCentreLine
        return self.getShape(
            self.lineOffsetFromKerb, azimuthToCentreLine, self.lineOffsetFromKerb
        )

    def getShape(self, shpExtent=None, azimuthToCentreLine=None, offset=None):

        TOMsMessageLog.logMessage("In getShape ... ", level=Qgis.Info)

        feature = self.currFeature
        restGeomType = self.currRestGeomType
        orientation = self.currBayOrientation

        if shpExtent is None:
            shpExtent = self.bayWidth
        if azimuthToCentreLine is None:
            azimuthToCentreLine = self.currAzimuthToCentreLine
        if offset is None:
            offset = self.bayOffsetFromKerb

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
        diffEchelonAz = 0

        # now loop through each of the vertices and process as required. New geometry points are added to ptsList

        for i in range(len(line) - 1):

            azimuth = GenerateGeometryUtils.checkDegrees(line[i].azimuth(line[i + 1]))

            # if this is the first point

            if i == 0:
                # determine which way to turn towards CL (center line)
                turn = GenerateGeometryUtils.turnToCL(azimuth, azimuthToCentreLine)

                newAz = GenerateGeometryUtils.checkDegrees(azimuth + turn)
                cosa, cosb = GenerateGeometryUtils.cosdirAzim(newAz)

                ptsList.append(
                    QgsPointXY(
                        line[i].x() + (float(offset) * cosa),
                        line[i].y() + (float(offset) * cosb),
                    )
                )

                parallelPtsList.append(
                    QgsPointXY(
                        line[i].x() + (float(offset) * cosa),
                        line[i].y() + (float(offset) * cosb),
                    )
                )

                # Now add the point at the extent. If it is an echelon bay:
                #   a. calculate the difference between the first Az and the echelon Az (??), and
                #   b. adjust the angle
                #   c. *** also need to adjust the length *** Not yet implemented

                if restGeomType in [5, 25, 9, 29]:  # echelon
                    if not self.isFloat(orientation):
                        orientation = azimuthToCentreLine

                    diffEchelonAz1 = float(orientation) - newAz
                    diffEchelonAz = GenerateGeometryUtils.checkDegrees(diffEchelonAz1)

                    newAz = GenerateGeometryUtils.checkDegrees(newAz + diffEchelonAz)
                    cosa, cosb = GenerateGeometryUtils.cosdirAzim(newAz)

                ptsList.append(
                    QgsPointXY(
                        line[i].x() + (float(shpExtent) * cosa),
                        line[i].y() + (float(shpExtent) * cosb),
                    )
                )

            else:
                newAz, distWidth = GenerateGeometryUtils.calcBisector(
                    prevAz, azimuth, turn, shpExtent
                )
                newAzOffset, distOffset = GenerateGeometryUtils.calcBisector(
                    prevAz, azimuth, turn, offset
                )

                cosa, cosb = GenerateGeometryUtils.cosdirAzim(newAz + diffEchelonAz)
                ptsList.append(
                    QgsPointXY(
                        line[i].x() + (float(distWidth) * cosa),
                        line[i].y() + (float(distWidth) * cosb),
                    )
                )
                thisOffset = distOffset
                if distWidth < 0:
                    if not GenerateGeometryUtils.sameSign(distWidth, distOffset):
                        thisOffset = GenerateGeometryUtils.changeSign(distOffset)

                parallelPtsList.append(
                    QgsPointXY(
                        line[i].x() + (float(thisOffset) * cosa),
                        line[i].y() + (float(thisOffset) * cosb),
                    )
                )

            prevAz = azimuth

        newAz = GenerateGeometryUtils.checkDegrees(azimuth + turn + diffEchelonAz)
        cosa, cosb = GenerateGeometryUtils.cosdirAzim(newAz)

        ptsList.append(
            QgsPointXY(
                line[-1].x() + (float(shpExtent) * cosa),
                line[-1].y() + (float(shpExtent) * cosb),
            )
        )

        # add end point (without any consideration of Echelon)

        newAz = azimuth + turn
        cosa, cosb = GenerateGeometryUtils.cosdirAzim(newAz)

        ptsList.append(
            QgsPointXY(
                line[len(line) - 1].x() + (float(offset) * cosa),
                line[len(line) - 1].y() + (float(offset) * cosb),
            )
        )
        parallelPtsList.append(
            QgsPointXY(
                line[len(line) - 1].x() + (float(offset) * cosa),
                line[len(line) - 1].y() + (float(offset) * cosb),
            )
        )

        newLine = QgsGeometry.fromPolylineXY(ptsList)
        if not newLine.isSimple():
            # https://gis.stackexchange.com/questions/353194/how-to-find-the-line-is-self-intersected-or-not-in-python-using-qgis
            TOMsMessageLog.logMessage(
                "In TOMsGeometryElement.getShape: newLine is self-intersecting for {}. Resolving ... ".format(
                    self.currFeature.attribute("GeometryID")
                ),
                level=Qgis.Warning,
            )
            newLine = self.resolveSelfIntersections(ptsList)

        parallelLine = QgsGeometry.fromPolylineXY(parallelPtsList)
        if not parallelLine.isSimple():
            # https://gis.stackexchange.com/questions/353194/how-to-find-the-line-is-self-intersected-or-not-in-python-using-qgis
            TOMsMessageLog.logMessage(
                "In TOMsGeometryElement.getShape: parallelLine is self-intersecting for {}. Resolving ... ".format(
                    self.currFeature.attribute("GeometryID")
                ),
                level=Qgis.Warning,
            )
            parallelLine = self.resolveSelfIntersections(parallelPtsList)

        return newLine, parallelLine

    def isFloat(self, value):
        try:
            float(value)
            return True
        except Exception:
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
        # print("Nr pts: {}".format(nrPts))
        TOMsMessageLog.logMessage(
            "In TOMsGeometryElement.resolveSelfIntersections: Nr pts: {}".format(nrPts),
            level=Qgis.Info,
        )
        currStartVertexNr = 0
        currLineStartVertex = ptsList[0]
        newPtsList = []

        newPtsList.append(QgsPointXY(currLineStartVertex))

        while True:
            currLine = QgsGeometry.fromPolylineXY(
                [currLineStartVertex, ptsList[currStartVertexNr + 1]]
            )
            intersectLineStartVertexNr = -1

            # print("Starting {} ... ".format(currStartVertexNr))
            TOMsMessageLog.logMessage(
                "In TOMsGeometryElement.resolveSelfIntersections: Starting {} ... ".format(
                    currStartVertexNr
                ),
                level=Qgis.Info,
            )

            for testVertexNr in range(currStartVertexNr + 1, nrPts - 1):
                print("StartPt {}: EndPt: {}".format(testVertexNr, testVertexNr + 1))
                testLine = QgsGeometry.fromPolylineXY(
                    [ptsList[testVertexNr], ptsList[testVertexNr + 1]]
                )
                intersectPt = currLine.intersection(testLine)
                if intersectPt:
                    # TODO: deal with situation where intersection is a line, i.e., colinear ...
                    if intersectPt.type() == QgsWkbTypes.PointGeometry:
                        intersectLineStartVertexNr = testVertexNr
                        nextPt = intersectPt

            # print("Finished line intersection check: {} ... ".format(intersectLineStartVertexNr))
            TOMsMessageLog.logMessage(
                "In TOMsGeometryElement.resolveSelfIntersections: Finished line intersection check: {} ... ".format(
                    intersectLineStartVertexNr
                ),
                level=Qgis.Info,
            )

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

            # print("Added {} ...".format(currStartVertexNr))
            TOMsMessageLog.logMessage(
                "In TOMsGeometryElement.resolveSelfIntersections: Added {} ...".format(
                    currStartVertexNr
                ),
                level=Qgis.Info,
            )

            if (
                currStartVertexNr == nrPts - 1
            ):  # check to see if the end point of the test line is the end of the line ...
                break

        # print("Finished checking ...")
        TOMsMessageLog.logMessage(
            "In TOMsGeometryElement.resolveSelfIntersections: Finished checking ...",
            level=Qgis.Info,
        )

        newGeom = QgsGeometry.fromPolylineXY(newPtsList)

        return newGeom

    def getZigZag(self, wavelength=None, shpExtent=None):

        TOMsMessageLog.logMessage("In getZigZag ... ", level=Qgis.Info)

        if not wavelength:
            wavelength = 3.0
        if not shpExtent:
            shpExtent = self.bayWidth / 2
        offset = self.bayOffsetFromKerb

        line = GenerateGeometryUtils.getLineForAz(self.currFeature)
        if len(line) == 0:
            return 0

        ptsList = []

        length = self.currFeature.geometry().length()

        nrSegments = int(length / wavelength)  # e.g., length = 33, wavelength = 4
        if nrSegments == 0:
            nrSegments = 1
            TOMsMessageLog.logMessage(
                "In getZigZag. NrSegments is 0 for geometry {}".format(
                    self.currFeature.attribute("GeometryID")
                ),
                level=Qgis.Info,
            )
        interval = int(length / float(nrSegments) * 10000) / 10000

        TOMsMessageLog.logMessage(
            "In getZigZag. LengthLine: "
            + str(length)
            + " NrSegments = "
            + str(nrSegments)
            + "; interval: "
            + str(interval),
            level=Qgis.Info,
        )

        azimuth = line[0].azimuth(line[1])

        turn = GenerateGeometryUtils.turnToCL(azimuth, self.currAzimuthToCentreLine)

        newAz = azimuth + turn
        # TOMsMessageLog.logMessage("In generateDisplayGeometry: newAz: " + str(newAz), level=Qgis.Info)
        cosa, cosb = GenerateGeometryUtils.cosdirAzim(newAz)

        # deal with two points
        ptsList.append(
            QgsPointXY(
                line[0].x() + (float(offset) * cosa),
                line[0].y() + (float(offset) * cosb),
            )
        )

        ptsList.append(
            QgsPointXY(
                line[0].x() + (float(shpExtent) * cosa),
                line[0].y() + (float(shpExtent) * cosb),
            )
        )

        distanceAlongLine = 0.0
        countSegments = 0
        while countSegments < (nrSegments):

            countSegments = countSegments + 1

            distanceAlongLine = distanceAlongLine + interval / 2

            interpolatedPointC = (
                self.currFeature.geometry().interpolate(distanceAlongLine).asPoint()
            )

            TOMsMessageLog.logMessage(
                "In getZigZag. PtC = "
                + str(interpolatedPointC.x())
                + ": "
                + str(interpolatedPointC.y())
                + "; distanceAlongLine = "
                + str(distanceAlongLine),
                level=Qgis.Info,
            )

            TOMsMessageLog.logMessage(
                "In getZigZag. newC x = "
                + str(interpolatedPointC.x() + (float(offset) * cosa))
                + "; y = "
                + str(interpolatedPointC.y() + (float(offset) * cosb)),
                level=Qgis.Info,
            )

            ptsList.append(
                QgsPointXY(
                    interpolatedPointC.x() + (float(offset) * cosa),
                    interpolatedPointC.y() + (float(offset) * cosb),
                )
            )

            distanceAlongLine = distanceAlongLine + interval / 2

            interpolatedPointD = (
                self.currFeature.geometry().interpolate(distanceAlongLine).asPoint()
            )

            ptsList.append(
                QgsPointXY(
                    interpolatedPointD.x() + (float(shpExtent) * cosa),
                    interpolatedPointD.y() + (float(shpExtent) * cosb),
                )
            )

        # deal with last point
        ptsList.append(
            QgsPointXY(
                line[len(line) - 1].x() + (float(offset) * cosa),
                line[len(line) - 1].y() + (float(offset) * cosb),
            )
        )

        newLine = QgsGeometry.fromPolylineXY(ptsList)

        return newLine

    def getBayDividers(
        self,
        bayShapeGeom,
        parallelShapeGeom,
        shpExtent=None,
        azimuthToCentreLine=None,
        offset=None,
    ):

        # returns list of bay dividing lines

        TOMsMessageLog.logMessage(
            "In getBayDividers. geometry {}".format(
                self.currFeature.attribute("GeometryID")
            ),
            level=Qgis.Info,
        )

        if shpExtent is None:
            shpExtent = self.bayWidth
        if offset is None:
            offset = self.bayOffsetFromKerb
        if azimuthToCentreLine is None:
            azimuthToCentreLine = self.currAzimuthToCentreLine

        TOMsMessageLog.logMessage(
            "In getBayDividers. AzimuthToCentreLine {}".format(azimuthToCentreLine),
            level=Qgis.Info,
        )

        # slightly extend the length of the dividers to deal with any rounding errors in the split process
        # shpExtent = shpExtent + 0.0001
        # offset = offset - 0.0001

        # get the bay shape "outside line"
        bayShapeLine = bayShapeGeom.asPolyline()
        outsideBayShapeLine = bayShapeLine[1 : len(bayShapeLine) - 1]
        outsideBayShapeLineGeom = QgsGeometry.fromPolylineXY(outsideBayShapeLine)

        TOMsMessageLog.logMessage(
            "In getBayDividers. outsideBayShapeLineGeom {}".format(
                outsideBayShapeLineGeom.asWkt()
            ),
            level=Qgis.Info,
        )

        restGeomType = self.currRestGeomType
        orientation = self.currBayOrientation

        newLines = []
        currGeom = self.currFeature.geometry()

        # line = generateGeometryUtils.getLineForAz(self.currFeature)
        line = parallelShapeGeom.asPolyline()

        if len(line) == 0:
            return None

        # get Az and calc turn to CL

        azimuth = GenerateGeometryUtils.checkDegrees(line[0].azimuth(line[1]))
        turn = GenerateGeometryUtils.turnToCL(azimuth, azimuthToCentreLine)
        # newAz = generateGeometryUtils.checkDegrees(Az + Turn)

        if restGeomType in [5, 25, 9, 29]:  # echelon
            if not self.isFloat(orientation):
                orientation = azimuthToCentreLine

        length = currGeom.length()

        nrSegments = self.nrBays

        interval = int(length / float(nrSegments) * 10000) / 10000

        TOMsMessageLog.logMessage(
            "In getBayDividers. LengthLine: "
            + str(length)
            + " NrSegments = "
            + str(nrSegments)
            + "; interval: "
            + str(interval),
            level=Qgis.Info,
        )

        distanceAlongLine = 0.0
        countSegments = 0
        while countSegments < (nrSegments - 1):

            countSegments = countSegments + 1

            distanceAlongLine = distanceAlongLine + interval

            interpolatedPointC = currGeom.interpolate(distanceAlongLine).asPoint()

            # now need to find the two vertices around this point and determine the azimuth ...

            (
                _,
                closestPt,
                vertexNrAfterPt,
                _,
            ) = currGeom.closestSegmentWithContext(interpolatedPointC)

            azimuth = GenerateGeometryUtils.checkDegrees(
                QgsPointXY(currGeom.vertexAt(vertexNrAfterPt - 1)).azimuth(
                    QgsPointXY(currGeom.vertexAt(vertexNrAfterPt))
                )
            )
            newAz = GenerateGeometryUtils.checkDegrees(azimuth + turn)

            if restGeomType in [5, 25, 9, 29]:  # echelon
                diffEchelonAz1 = float(orientation) - newAz
                diffEchelonAz = GenerateGeometryUtils.checkDegrees(diffEchelonAz1)
                newAz = GenerateGeometryUtils.checkDegrees(newAz + diffEchelonAz)

            TOMsMessageLog.logMessage(
                "In getBayDividers. newAz: {}".format(newAz), level=Qgis.Info
            )

            cosa, cosb = GenerateGeometryUtils.cosdirAzim(newAz)

            TOMsMessageLog.logMessage(
                "In getBayDividers. PtC = "
                + str(interpolatedPointC.x())
                + ": "
                + str(interpolatedPointC.y())
                + "; distanceAlongLine = "
                + str(distanceAlongLine),
                level=Qgis.Info,
            )
            TOMsMessageLog.logMessage(
                "In getBayDividers. newC x = "
                + str(interpolatedPointC.x() + (float(offset) * cosa))
                + "; y = "
                + str(interpolatedPointC.y() + (float(offset) * cosb)),
                level=Qgis.Info,
            )

            # ptsList.append(
            #    QgsPointXY(closestPt.x() + (float(offset) * cosa), closestPt.y() + (float(offset) * cosb)))
            testStartPoint = QgsPointXY(
                closestPt.x() + (float(offset) * cosa),
                closestPt.y() + (float(offset) * cosb),
            )

            testEndPoint = QgsPointXY(
                closestPt.x() + (float(shpExtent) * cosa),
                closestPt.y() + (float(shpExtent) * cosb),
            )

            TOMsMessageLog.logMessage(
                "In getBayDividers. testPt x = {}; y = {}".format(
                    testEndPoint.x(), testEndPoint.y()
                ),
                level=Qgis.Info,
            )

            testLineGeom = QgsGeometry.fromPolylineXY([testStartPoint, testEndPoint])

            # check for intersection ... on bayOutsideLines

            if parallelShapeGeom.intersects(testLineGeom):
                startPoint = testStartPoint
                TOMsMessageLog.logMessage(
                    "In getBayDividers. testLine intersects startPoint ...",
                    level=Qgis.Info,
                )
            else:
                # get point on bay shape from testPoint
                startPoint = parallelShapeGeom.nearestPoint(
                    QgsGeometry.fromPointXY(testStartPoint)
                ).asPoint()
                TOMsMessageLog.logMessage(
                    "In getBayDividers. *** new startPt x = {}; y = {}".format(
                        startPoint.x(), startPoint.y()
                    ),
                    level=Qgis.Info,
                )

            if outsideBayShapeLineGeom.intersects(testLineGeom):
                endPoint = testEndPoint
                TOMsMessageLog.logMessage(
                    "In getBayDividers. testLine intersects endPoint ...",
                    level=Qgis.Info,
                )
            else:
                # get point on bay shape from testPoint
                endPoint = outsideBayShapeLineGeom.nearestPoint(
                    QgsGeometry.fromPointXY(testEndPoint)
                ).asPoint()
                TOMsMessageLog.logMessage(
                    "In getBayDividers. *** new endPt x = {}; y = {}".format(
                        endPoint.x(), endPoint.y()
                    ),
                    level=Qgis.Info,
                )

            newLine = QgsGeometry.fromPolylineXY([startPoint, endPoint]).extendLine(
                0.0001, 0.0001
            )
            newLines.append(newLine)

        return newLines

    def addBayLineDividers(
        self,
        bayShapeGeom,
        parallelShapeGeom,
        shpExtent=None,
        azimuthToCentreLine=None,
        offset=None,
    ):
        # add "legs" to bay shape to show dividers

        bayDividers = self.getBayDividers(
            bayShapeGeom, parallelShapeGeom, shpExtent, azimuthToCentreLine, offset
        )
        outputGeometry = bayShapeGeom
        if bayDividers is not None:
            # prepare geometries list
            geomList = []
            for divider in bayDividers:
                geomList.append(divider)
            geomList.append(outputGeometry)
            return self.generateMultiLineShape(geomList)

        return None

    def addBayPolygonDividers(
        self,
        outputGeometry,
        bayShapeGeom,
        parallelShapeGeom,
        shpExtent=None,
        azimuthToCentreLine=None,
        offset=None,
    ):

        TOMsMessageLog.logMessage(
            "In factory. addBayPolygonDividers ... shpExtent: {}; Az: {} ".format(
                shpExtent, azimuthToCentreLine
            ),
            level=Qgis.Info,
        )

        # split output polygon(s) to show bay dividers
        bayDividers = self.getBayDividers(
            bayShapeGeom=bayShapeGeom,
            parallelShapeGeom=parallelShapeGeom,
            shpExtent=shpExtent,
            azimuthToCentreLine=azimuthToCentreLine,
            offset=offset,
        )
        if bayDividers is not None:
            # prepare geometries list
            outputGeometries = [outputGeometry]

            TOMsMessageLog.logMessage(
                "In factory. addBayPolygonDividers ... nr dividers: {}".format(
                    len(bayDividers)
                ),
                level=Qgis.Info,
            )
            for divider in bayDividers:
                # divGeometry = QgsGeometry()
                # res = divGeometry.addPointsXY(divider.asPolyline(), QgsWkbTypes.LineGeometry)
                TOMsMessageLog.logMessage(
                    "In factory. divider : {}".format(divider.asWkt()), level=Qgis.Info
                )

                newGeomsList = []
                for outGeom in outputGeometries:
                    (
                        _,
                        extraGeometriesList,
                        _,
                    ) = outGeom.splitGeometry(divider.asPolyline(), True)
                    newGeomsList.append(outGeom)
                    for geom in extraGeometriesList:
                        newGeomsList.append(geom)
                outputGeometries = newGeomsList
                TOMsMessageLog.logMessage(
                    "In factory. addBayPolygonDividers ... nr outputGeometries: {}".format(
                        len(outputGeometries)
                    ),
                    level=Qgis.Info,
                )

            # now combine all the output polygons
            newGeom = QgsGeometry()
            newGeom = outputGeometries[0]
            for i in range(1, len(outputGeometries)):
                newGeom.addPartGeometry(outputGeometries[i])

            outputGeometry = newGeom

            TOMsMessageLog.logMessage(
                "In addPolygonDividers ... split geom: {}".format(
                    outputGeometry.asWkt()
                ),
                level=Qgis.Info,
            )

        return outputGeometry


class GeneratedGeometryBayLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryBayLineType ... ", level=Qgis.Info
        )

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape()

        if self.nrBays > 0:
            outputGeometry = self.addBayLineDividers(outputGeometry, parallelLine)

        return outputGeometry


class GeneratedGeometryHalfOnHalfOffLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryHalfOnHalfOffLineType ... ", level=Qgis.Info
        )

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.bayWidth / 2)
        outputGeometry2, parallelLine2 = self.getShape(
            self.bayWidth / 2,
            GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
        )

        if self.nrBays > 0:
            outputGeometry1 = self.addBayLineDividers(
                outputGeometry1, parallelLine1, self.bayWidth / 2
            )
            outputGeometry2 = self.addBayLineDividers(
                outputGeometry2,
                parallelLine2,
                self.bayWidth / 2,
                GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
            )

        return self.generateMultiLineShape([outputGeometry1, outputGeometry2])


class GeneratedGeometryOnPavementLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryOnPavementLineType ... ", level=Qgis.Info
        )

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(
            self.bayWidth,
            GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
        )

        if self.nrBays > 0:
            outputGeometry = self.addBayLineDividers(
                outputGeometry,
                parallelLine,
                self.bayWidth,
                GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
            )

        return outputGeometry


class GeneratedGeometryPerpendicularLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryPerpendicularLineType ... ", level=Qgis.Info
        )

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(self.bayLength)

        if self.nrBays > 0:
            outputGeometry = self.addBayLineDividers(
                outputGeometry, parallelLine, self.bayLength
            )

        return outputGeometry


class GeneratedGeometryEchelonLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryEchelonLineType ... ", level=Qgis.Info
        )

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(self.bayLength)

        if self.nrBays > 0:
            outputGeometry = self.addBayLineDividers(
                outputGeometry, parallelLine, self.bayLength
            )

        return outputGeometry


class GeneratedGeometryPerpendicularOnPavementLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryPerpendicularOnPavementLineType ... ",
            level=Qgis.Info,
        )

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(
            self.bayLength,
            GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
        )

        if self.nrBays > 0:
            outputGeometry = self.addBayLineDividers(
                outputGeometry,
                parallelLine,
                self.bayLength,
                GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
            )

        return outputGeometry


class GeneratedGeometryOutlineShape(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryOutlineShape ... ", level=Qgis.Info
        )

    def getElementGeometry(self):
        return self.currFeature.geometry()


class GeneratedGeometryEchelonOnPavementLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryEchelonOnPavementLineType ... ",
            level=Qgis.Info,
        )

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(
            self.bayLength,
            GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
        )

        if self.nrBays > 0:
            outputGeometry = self.addBayLineDividers(
                outputGeometry,
                parallelLine,
                self.bayLength,
                GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
            )

        return outputGeometry


class GeneratedGeometryLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryLineType ... ", level=Qgis.Info
        )

    def getElementGeometry(self):
        outputGeometry, _ = self.getLine()
        return outputGeometry


class GeneratedGeometryZigZagType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryZigZagType ... ", level=Qgis.Info
        )

    def getElementGeometry(self):

        outputGeometry = self.getZigZag()

        return outputGeometry


class GeneratedGeometryBayPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryBayPolygonType ... ", level=Qgis.Info
        )

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape()
        # outputGeometry1A, paralletLine1A = self.getLine()

        outputGeometry = self.generatePolygon([(outputGeometry1, parallelLine1)])

        if self.nrBays > 0:
            outputGeometry = self.addBayPolygonDividers(
                outputGeometry, outputGeometry1, parallelLine1
            )

        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryBayPolygonType ... polygon(s): {}".format(
                outputGeometry.asWkt()
            ),
            level=Qgis.Info,
        )

        return outputGeometry
        # return self.generatePolygon([(outputGeometry1, parallelLine1)])


class GeneratedGeometryHalfOnHalfOffPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryHalfOnHalfOffPolygonType ... ",
            level=Qgis.Info,
        )

    def getElementGeometry(self):
        bayShape1, parallelLine1 = self.getShape((self.bayWidth) / 2)
        bayShape2, parallelLine2 = self.getShape(
            (self.bayWidth) / 2,
            GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
        )

        outputGeometry1 = self.generatePolygon([(bayShape1, parallelLine1)])
        outputGeometry2 = self.generatePolygon([(bayShape2, parallelLine2)])

        if self.nrBays > 0:
            TOMsMessageLog.logMessage(
                "In generatedGeometryHalfOnHalfOffPolygonType ... getting bay divisions ",
                level=Qgis.Info,
            )
            outputGeometry1 = self.addBayPolygonDividers(
                outputGeometry=outputGeometry1,
                bayShapeGeom=bayShape1,
                parallelShapeGeom=parallelLine1,
                shpExtent=self.bayWidth / 2,
            )
            outputGeometry2 = self.addBayPolygonDividers(
                outputGeometry=outputGeometry2,
                bayShapeGeom=bayShape2,
                parallelShapeGeom=parallelLine2,
                shpExtent=self.bayWidth / 2,
                azimuthToCentreLine=GenerateGeometryUtils.getReverseAzimuth(
                    self.currAzimuthToCentreLine
                ),
            )

        outputGeometry1.addPartGeometry(outputGeometry2)

        return outputGeometry1


class GeneratedGeometryOnPavementPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryOnPavementPolygonType ... ", level=Qgis.Info
        )

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(
            self.bayWidth,
            GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
        )
        outputGeometry = self.generatePolygon([(outputGeometry1, parallelLine1)])

        if self.nrBays > 0:
            outputGeometry = self.addBayPolygonDividers(
                outputGeometry,
                outputGeometry1,
                parallelLine1,
                shpExtent=self.bayWidth,
                azimuthToCentreLine=GenerateGeometryUtils.getReverseAzimuth(
                    self.currAzimuthToCentreLine
                ),
            )

        return outputGeometry


class GeneratedGeometryPerpendicularPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryPerpendicularPolygonType ... ",
            level=Qgis.Info,
        )

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.bayLength)
        # outputGeometry1A, paralletLine1A = self.getLine()

        # return self.generatePolygon([(outputGeometry1, outputGeometry1A)])
        # return self.generatePolygon([(outputGeometry1, parallelLine1)])
        outputGeometry = self.generatePolygon([(outputGeometry1, parallelLine1)])

        if self.nrBays > 0:
            outputGeometry = self.addBayPolygonDividers(
                outputGeometry, outputGeometry1, parallelLine1, self.bayLength
            )

        return outputGeometry


class GeneratedGeometryEchelonPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryEchelonPolygonType ... ", level=Qgis.Info
        )

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.bayLength)
        # outputGeometry1A, paralletLine1A = self.getLine()

        # return self.generatePolygon([(outputGeometry1, outputGeometry1A)])
        # return self.generatePolygon([(outputGeometry1, parallelLine1)])
        outputGeometry = self.generatePolygon([(outputGeometry1, parallelLine1)])

        if self.nrBays > 0:
            outputGeometry = self.addBayPolygonDividers(
                outputGeometry, outputGeometry1, parallelLine1, self.bayLength
            )

        return outputGeometry


class GeneratedGeometryPerpendicularOnPavementPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryPerpendicularOnPavementPolygonType ... ",
            level=Qgis.Info,
        )

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(
            self.bayLength,
            GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
        )

        # return self.generatePolygon([(outputGeometry1, parallelLine1)])
        outputGeometry = self.generatePolygon([(outputGeometry1, parallelLine1)])

        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryPerpendicularOnPavementPolygonType ... Az: {}".format(
                self.currAzimuthToCentreLine
            ),
            level=Qgis.Info,
        )

        if self.nrBays > 0:
            outputGeometry = self.addBayPolygonDividers(
                outputGeometry,
                outputGeometry1,
                parallelLine1,
                self.bayLength,
                GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
            )

        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryPerpendicularOnPavementPolygonType ... polygon(s): {}".format(
                outputGeometry.asWkt()
            ),
            level=Qgis.Info,
        )

        return outputGeometry


class GeneratedGeometryOutlineBayPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryOutlineBayPolygonType ... ", level=Qgis.Info
        )

    def getElementGeometry(self):

        return QgsGeometry.fromPolygonXY([self.currFeature.geometry().asPolyline()])


class GeneratedGeometryEchelonOnPavementPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryEchelonOnPavementPolygonType ... ",
            level=Qgis.Info,
        )

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(
            self.bayLength,
            GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
        )
        # outputGeometry1A, paralletLine1A = self.getLine()

        # return self.generatePolygon([(outputGeometry1, outputGeometry1A)])
        # return self.generatePolygon([(outputGeometry1, parallelLine1)])
        outputGeometry = self.generatePolygon([(outputGeometry1, parallelLine1)])

        if self.nrBays > 0:
            outputGeometry = self.addBayPolygonDividers(
                outputGeometry,
                outputGeometry1,
                parallelLine1,
                self.bayLength,
                GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
            )

        return outputGeometry


class GeneratedGeometryCrossoverPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        TOMsMessageLog.logMessage(
            "In factory. generatedGeometryCrossoverPolygonType ... ", level=Qgis.Info
        )

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(
            self.crossoverShapeWidth,
            GenerateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine),
        )
        return self.generatePolygon([(outputGeometry1, parallelLine1)])


class ElementGeometryFactory:
    @staticmethod
    def getElementGeometry(currFeature, restGeomType=None):
        if restGeomType:
            currRestGeomType = restGeomType
        else:
            currRestGeomType = RestrictionGeometryTypes(
                currFeature.attribute("GeomShapeID")
            )

        TOMsMessageLog.logMessage(
            "In factory. getElementGeometry "
            + str(currFeature.attribute("GeometryID"))
            + ":"
            + str(currRestGeomType),
            level=Qgis.Info,
        )

        res = None
        if currRestGeomType == RestrictionGeometryTypes.PARALLEL_BAY:
            res = GeneratedGeometryBayLineType(currFeature).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.HALF_ON_HALF_OFF:
            res = GeneratedGeometryHalfOnHalfOffLineType(
                currFeature
            ).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.ON_PAVEMENT:
            res = GeneratedGeometryOnPavementLineType(currFeature).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.PERPENDICULAR:
            res = GeneratedGeometryPerpendicularLineType(
                currFeature
            ).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.ECHELON:
            res = GeneratedGeometryEchelonLineType(currFeature).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.PERPENDICULAR_ON_PAVEMENT:
            res = GeneratedGeometryPerpendicularOnPavementLineType(
                currFeature
            ).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.OTHER:
            res = GeneratedGeometryOutlineShape(currFeature).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.CENTRAL_PARKING:
            res = GeneratedGeometryOutlineShape(currFeature).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.ECHELON_ON_PAVEMENT:
            res = GeneratedGeometryEchelonOnPavementLineType(
                currFeature
            ).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.PARALLEL_LINE:
            res = GeneratedGeometryLineType(currFeature).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.ZIG_ZAG:
            res = GeneratedGeometryZigZagType(currFeature).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.PARALLEL_BAY_POLYGON:
            res = GeneratedGeometryBayPolygonType(currFeature).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.HALF_ON_HALF_OFF_POLYGON:
            res = GeneratedGeometryHalfOnHalfOffPolygonType(
                currFeature
            ).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.ON_PAVEMENT_POLYGON:
            res = GeneratedGeometryOnPavementPolygonType(
                currFeature
            ).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.PERPENDICULAR_POLYGON:
            res = GeneratedGeometryPerpendicularPolygonType(
                currFeature
            ).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.ECHELON_POLYGON:
            res = GeneratedGeometryEchelonPolygonType(currFeature).getElementGeometry()

        if (
            currRestGeomType
            == RestrictionGeometryTypes.PERPENDICULAR_ON_PAVEMENT_POLYGON
        ):
            res = GeneratedGeometryPerpendicularOnPavementPolygonType(
                currFeature
            ).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.OUTLINE_BAY_POLYGON:
            res = GeneratedGeometryOutlineBayPolygonType(
                currFeature
            ).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.ECHELON_ON_PAVEMENT_POLYGON:
            res = GeneratedGeometryEchelonOnPavementPolygonType(
                currFeature
            ).getElementGeometry()

        if currRestGeomType == RestrictionGeometryTypes.CROSSOVER:
            res = GeneratedGeometryCrossoverPolygonType(
                currFeature
            ).getElementGeometry()

        if res is None:
            raise NotImplementedError("Restriction Geometry Type NOT found")
        return res
