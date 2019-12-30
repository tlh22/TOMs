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

from qgis.core import (
    QgsMessageLog, QgsFeature, QgsGeometry, QgsGeometryUtils,
    QgsFeatureRequest,
    QgsRectangle, QgsPointXY, QgsWkbTypes
)

from ..constants import (
    ProposalStatus,
    RestrictionAction,
    RestrictionLayers,
    RestrictionGeometryTypes
)

from abc import ABCMeta, abstractstaticmethod
from ..restrictionTypeUtilsClass import TOMsParams
from ..generateGeometryUtils import generateGeometryUtils

class TOMsGeometryElement(QObject):
    def __init__(self, currFeature):
        super().__init__()

        QgsMessageLog.logMessage("In TOMsGeometryElement: " + str(currFeature.attribute("GeometryID")), tag="TOMs panel")

        params = TOMsParams()
        params.getParams()

        self.currFeature = currFeature
        self.BayWidth = params.setParam("BayWidth")
        self.BayLength = params.setParam("BayLength")
        self.BayOffsetFromKerb = params.setParam("BayOffsetFromKerb")
        self.LineOffsetFromKerb = params.setParam("LineOffsetFromKerb")
        self.CrossoverShapeWidth = params.setParam("CrossoverShapeWidth")

        self.currRestGeomType = currFeature.attribute("GeomShapeID")
        self.currAzimuthToCentreLine = float(currFeature.attribute("AzimuthToRoadCentreLine"))

        self.nrBays = 0
        self.currBayOrientation = 0

        if generateGeometryUtils.checkFeatureIsBay(self.currRestGeomType) == True:
            self.nrBays = float(currFeature.attribute("NrBays"))
            self.currBayOrientation = currFeature.attribute("BayOrientation")

    def getElementGeometry(self):
        """ This is the final shape - uses functions below. It really is abstract """
        pass

    def generatePolygon(self, listGeometryPairs):
        # ... and combine the two paired geometries. NB: May be more than one pair

        outputGeometry = QgsGeometry()

        for (shape, line) in listGeometryPairs:

            QgsMessageLog.logMessage("In generatePolygon:  shape ********: " + shape.asWkt(), tag="TOMs panel")
            QgsMessageLog.logMessage("In generatePolygon:  line ********: " + line.asWkt(),
                                     tag="TOMs panel")

            newGeometry = shape.combine(line)

            if newGeometry.wkbType() == QgsWkbTypes.MultiLineString:

                linesList = newGeometry.asMultiPolyline()

                for verticesList in linesList:

                    res = outputGeometry.addPointsXY(verticesList.asPolyline(), QgsWkbTypes.PolygonGeometry)
                    if res != QgsGeometry.OperationResult.Success:
                        QgsMessageLog.logMessage(
                            "In generatePolygon: NOT able to add part  ...", tag="TOMs panel")

            else:

                res = outputGeometry.addPointsXY(newGeometry.asPolyline(), QgsWkbTypes.PolygonGeometry)

                if res != QgsGeometry.OperationResult.Success:
                    QgsMessageLog.logMessage(
                        "In generatePolygon: NOT able to add part  ...", tag="TOMs panel")

        return outputGeometry

    def generateMultiLineShape(self, listGeometries):
        # ... and combine the geometries. NB: May be more than one

        outputGeometry = QgsGeometry()

        for (shape) in listGeometries:

            res = outputGeometry.addPointsXY(shape.asPolyline(), QgsWkbTypes.LineGeometry)

            if res != QgsGeometry.OperationResult.Success:
                QgsMessageLog.logMessage(
                    "In generateMultiLineShape: NOT able to add part  ...", tag="TOMs panel")

        return outputGeometry

    def getLine(self, AzimuthToCentreLine=None):
        if AzimuthToCentreLine is None:
            AzimuthToCentreLine = self.currAzimuthToCentreLine
        return self.getShape(self.BayOffsetFromKerb, AzimuthToCentreLine)

    def getShape(self, shpExtent=None, AzimuthToCentreLine=None, offset=None):

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

        # QgsMessageLog.logMessage("In getDisplayGeometry:  nr of pts = " + str(len(line)), tag="TOMs panel")

        if len(line) == 0:
            return 0

        # Now have a valid set of points

        ptsList = []
        parallelPtsList = []
        nextAz = 0
        diffEchelonAz = 0

        # now loop through each of the vertices and process as required. New geometry points are added to ptsList

        for i in range(len(line) - 1):

            # QgsMessageLog.logMessage("In getDisplayGeometry: i = " + str(i), tag="TOMs panel")

            Az = generateGeometryUtils.checkDegrees(line[i].azimuth(line[i + 1]))

            # QgsMessageLog.logMessage("In getDisplayGeometry: geometry: " + str(line[i].x()) + " " + str(line[i+1].x()) + " " + str(Az), tag="TOMs panel")

            # if this is the first point

            if i == 0:
                # determine which way to turn towards CL
                # QgsMessageLog.logMessage("In generate_display_geometry: considering first point", tag="TOMs panel")

                Turn = generateGeometryUtils.turnToCL(Az, AzimuthToCentreLine)

                newAz = generateGeometryUtils.checkDegrees(Az + Turn)
                # QgsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), tag="TOMs panel")
                cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)

                # QgsMessageLog.logMessage("In generate_display_geometry: cosa : " + str(cosa) + " " + str(cosb), tag="TOMs panel")

                # dx = float(offset) * cosa
                # dy = float(offset) * cosb

                # QgsMessageLog.logMessage("In generate_display_geometry: dx: " + str(dx) + " dy: " + str(dy), tag="TOMs panel")

                ptsList.append(
                    QgsPointXY(line[i].x() + (float(offset) * cosa), line[i].y() + (float(offset) * cosb)))

                parallelPtsList.append(
                    QgsPointXY(line[i].x() + (float(offset) * cosa), line[i].y() + (float(offset) * cosb)))
                # QgsMessageLog.logMessage("In geomType: added point 1 ", tag="TOMs panel")

                # Now add the point at the extent. If it is an echelon bay:
                #   a. calculate the difference between the first Az and the echelon Az (??), and
                #   b. adjust the angle
                #   c. *** also need to adjust the length *** Not yet implemented

                # if restGeomType == 5 or restGeomType == 25:  # echelon
                if restGeomType in [5, 25]:  # echelon
                    QgsMessageLog.logMessage("In geomType: orientation: " + str(orientation), tag="TOMs panel")
                    diffEchelonAz = generateGeometryUtils.checkDegrees(orientation - newAz)
                    newAz = Az + Turn + diffEchelonAz
                    QgsMessageLog.logMessage("In geomType: newAz: " + str(newAz) + " diffEchelonAz: " + str(diffEchelonAz),
                                             tag="TOMs panel")
                    cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)
                    pass

                ptsList.append(
                    QgsPointXY(line[i].x() + (float(shpExtent) * cosa),
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

                # QgsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), tag="TOMs panel")

                cosa, cosb = generateGeometryUtils.cosdir_azim(newAz + diffEchelonAz)
                ptsList.append(
                    QgsPointXY(line[i].x() + (float(distWidth) * cosa), line[i].y() + (float(distWidth) * cosb)))

                parallelPtsList.append(
                    QgsPointXY(line[i].x() + (float(offset) * cosa), line[i].y() + (float(offset) * cosb)))
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
        #parallelPtsList.reverse()
        parallelLine = QgsGeometry.fromPolylineXY(parallelPtsList)

        # QgsMessageLog.logMessage("In getDisplayGeometry:  newLine ********: " + newLine.asWkt(), tag="TOMs panel")
        # QgsMessageLog.logMessage("In getDisplayGeometry:  parallelLine ********: " + parallelLine.asWkt(), tag="TOMs panel")

        return newLine, parallelLine

    def getZigZag(self, wavelength=None, shpExtent=None):

        QgsMessageLog.logMessage("In getZigZag ... ", tag="TOMs panel")

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
        interval = int(length/float(NrSegments) * 10000) / 10000

        QgsMessageLog.logMessage("In getZigZag. LengthLine: " + str(length) + " NrSegments = " + str(NrSegments) + "; interval: " + str(interval), tag="TOMs panel")

        Az = line[0].azimuth(line[1])

        # QgsMessageLog.logMessage("In getZigZag. Az = " + str(Az) + "; AzCL = " + str(self.currAzimuthToCentreLine) + "; line[0]: " + line[0].asWkt() + "; line[1]: " + line[1].asWkt(), tag="TOMs panel")

        Turn = generateGeometryUtils.turnToCL(Az, self.currAzimuthToCentreLine)

        newAz = Az + Turn
        # QgsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), tag="TOMs panel")
        cosa, cosb = generateGeometryUtils.cosdir_azim(newAz)

        # deal with two points
        ptsList.append(
            QgsPointXY(line[0].x() + (float(offset) * cosa), line[0].y() + (float(offset) * cosb)))

        ptsList.append(
            QgsPointXY(line[0].x() + (float(shpExtent) * cosa),
                     line[0].y() + (float(shpExtent) * cosb)))

        distanceAlongLine = 0.0
        countSegments = 0
        while countSegments < (NrSegments):

            countSegments = countSegments + 1

            distanceAlongLine = distanceAlongLine + interval / 2

            interpolatedPointC = self.currFeature.geometry().interpolate(distanceAlongLine).asPoint()

            QgsMessageLog.logMessage("In getZigZag. PtC = " + str(interpolatedPointC.x()) + ": " + str(interpolatedPointC.y()) + "; distanceAlongLine = " + str(distanceAlongLine), tag="TOMs panel")
            # QgsMessageLog.logMessage("In getZigZag. offset = " + str(float(offset)) + "; cosa = " + str(cosa) + "; cosb = " + str(cosb), tag="TOMs panel")

            QgsMessageLog.logMessage("In getZigZag. newC x = " + str(interpolatedPointC.x() + (float(offset) * cosa)) + "; y = " + str(interpolatedPointC.y() + (float(offset) * cosb)), tag="TOMs panel")

            ptsList.append(QgsPointXY(interpolatedPointC.x() + (float(offset) * cosa), interpolatedPointC.y() + (float(offset) * cosb)))

            distanceAlongLine = distanceAlongLine+interval/2

            interpolatedPointD = self.currFeature.geometry().interpolate(distanceAlongLine).asPoint()

            # QgsMessageLog.logMessage("In getZigZag. PtD = " + interpolatedPointD.asWkt() + "; distanceAlongLine = " + str(distanceAlongLine), tag="TOMs panel")

            ptsList.append(QgsPointXY(interpolatedPointD.x() + (float(shpExtent) * cosa),
                     interpolatedPointD.y() + (float(shpExtent) * cosb)))

        # deal with last point
        ptsList.append(
            QgsPointXY(line[len(line) - 1].x() + (float(offset) * cosa),
                     line[len(line) - 1].y() + (float(offset) * cosb)))

        newLine = QgsGeometry.fromPolylineXY(ptsList)

        return newLine


""" ***** """

class generatedGeometryBayLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryBayLineType ... ", tag="TOMs panel")

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape()
        return outputGeometry


class generatedGeometryHalfOnHalfOffLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryHalfOnHalfOffLineType ... ", tag="TOMs panel")

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.BayWidth/2)
        outputGeometry2, parallelLine2 = self.getShape(self.BayWidth/2, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        return self.generateMultiLineShape([outputGeometry1, outputGeometry2])


class generatedGeometryOnPavementLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryOnPavementLineType ... ", tag="TOMs panel")

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(self.BayWidth, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))
        return outputGeometry


class generatedGeometryPerpendicularLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryPerpendicularLineType ... ", tag="TOMs panel")

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(self.BayLength)
        return outputGeometry


class generatedGeometryEchelonLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryEchelonLineType ... ", tag="TOMs panel")

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(self.BayLength)
        return outputGeometry


class generatedGeometryPerpendicularOnPavementLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryPerpendicularOnPavementLineType ... ", tag="TOMs panel")

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getShape(self.BayLength, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))
        return outputGeometry


class generatedGeometryOutlineShape(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryOutlineShape ... ", tag="TOMs panel")

    def getElementGeometry(self):
        return self.currFeature.geometry()


class generatedGeometryLineType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryLineType ... ", tag="TOMs panel")

    def getElementGeometry(self):
        outputGeometry, parallelLine = self.getLine()
        return outputGeometry


class generatedGeometryZigZagType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryZigZagType ... ", tag="TOMs panel")

    def getElementGeometry(self):

        outputGeometry = self.getZigZag()

        return outputGeometry


class generatedGeometryBayPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryBayPolygonType ... ", tag="TOMs panel")

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape()
        outputGeometry1A, paralletLine1A = self.getLine()

        return self.generatePolygon([(outputGeometry1, parallelLine1)])
        #return self.generatePolygon([(outputGeometry1, outputGeometry1A)])


class generatedGeometryHalfOnHalfOffPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryHalfOnHalfOffPolygonType ... ", tag="TOMs panel")

    def getElementGeometry(self):
        # QgsMessageLog.logMessage("In generatedGeometryHalfOnHalfOffPolygonType ... BayWidth/2 = " + str((self.BayWidth)/2), tag="TOMs panel")
        outputGeometry1, parallelLine1 = self.getShape((self.BayWidth)/2)
        outputGeometry1A, paralletLine1A = self.getLine()

        outputGeometry2, parallelLine2 = self.getShape((self.BayWidth)/2, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))
        outputGeometry2A, paralletLine2A = self.getLine(generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        return self.generatePolygon([(outputGeometry1, outputGeometry1A), (outputGeometry2, outputGeometry2A)])


class generatedGeometryOnPavementPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryOnPavementPolygonType ... ", tag="TOMs panel")

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.BayWidth, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))
        outputGeometry1A, paralletLine1A = self.getLine(generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        return self.generatePolygon([(outputGeometry1, outputGeometry1A)])


class generatedGeometryPerpendicularPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryPerpendicularPolygonType ... ", tag="TOMs panel")

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.BayLength)
        outputGeometry1A, paralletLine1A = self.getLine()

        return self.generatePolygon([(outputGeometry1, outputGeometry1A)])


class generatedGeometryEchelonPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryPerpendicularPolygonType ... ", tag="TOMs panel")

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.BayLength)
        outputGeometry1A, paralletLine1A = self.getLine()

        return self.generatePolygon([(outputGeometry1, outputGeometry1A)])


class generatedGeometryPerpendicularOnPavementPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryPerpendicularPolygonType ... ", tag="TOMs panel")

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.BayLength, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))
        outputGeometry1A, paralletLine1A = self.getLine(generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        return self.generatePolygon([(outputGeometry1, outputGeometry1A)])


class generatedGeometryOutlineBayPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryOutlineBayPolygonType ... ", tag="TOMs panel")

    def getElementGeometry(self):

        return QgsGeometry.fromPolygonXY([self.currFeature.geometry().asPolyline()])


class generatedGeometryCrossoverPolygonType(TOMsGeometryElement):
    def __init__(self, currFeature):
        super().__init__(currFeature)
        QgsMessageLog.logMessage("In factory. generatedGeometryPerpendicularPolygonType ... ", tag="TOMs panel")

    def getElementGeometry(self):

        outputGeometry1, parallelLine1 = self.getShape(self.CrossoverShapeWidth, generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))
        outputGeometry1A, paralletLine1A = self.getLine(generateGeometryUtils.getReverseAzimuth(self.currAzimuthToCentreLine))

        return self.generatePolygon([(outputGeometry1, outputGeometry1A)])


""" ***** """

class ElementGeometryFactory():

    @staticmethod
    def getElementGeometry(currFeature):

        currRestGeomType = currFeature.attribute("GeomShapeID")
        QgsMessageLog.logMessage("In factory. getElementGeometry " + str(currFeature.attribute("GeometryID")) + ":" + str(currRestGeomType), tag="TOMs panel")

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
                return generatedGeometryPerpendicularLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.PERPENDICULAR_ON_PAVEMENT:
                return generatedGeometryPerpendicularOnPavementLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.OTHER:
                return generatedGeometryOutlineShape(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.CENTRAL_PARKING:
                return generatedGeometryOutlineShape(currFeature).getElementGeometry()

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
                return generatedGeometryPerpendicularPolygonType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.PERPENDICULAR_ON_PAVEMENT_POLYGON:
                return generatedGeometryBayLineType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.OUTLINE_BAY_POLYGON:
                return generatedGeometryOutlineBayPolygonType(currFeature).getElementGeometry()

            elif currRestGeomType == RestrictionGeometryTypes.CROSSOVER:
                return generatedGeometryBayLineType(currFeature).getElementGeometry()

            raise AssertionError("Restriction Geometry Type NOT found")

        except AssertionError as _e:
            QgsMessageLog.logMessage("In ElementGeometryFactory. TYPE not found or something else ... ", tag="TOMs panel")
