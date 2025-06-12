#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock/Matthias Kuhn 2017
#
"""

https://github.com/NathanW2/qgsexpressionsplus/blob/master/functions.py

Extra functions for QgsExpression
register=False in order to delay registring of functions before we load the plugin

*** TH: Using this code to move Expression functions into main code body

"""

#from qgis.utils import qgsfunction

import qgis

#from qgis.core import *
from qgis.gui import *
from qgis.utils import *
from TOMs.core.TOMsMessageLog import TOMsMessageLog
from qgis.core import (
    Qgis,
    QgsMessageLog,
    QgsExpression, QgsGeometry, QgsPointXY, QgsMultiPolygon, QgsPolygon, QgsGeometryCollection,
    QgsFeature, QgsWkbTypes
)
import math
import random
from .generateGeometryUtils import generateGeometryUtils
from .core.TOMsGeometryElement import ElementGeometryFactory

from TOMs.constants import (
    ProposalStatus,
    RestrictionAction,
    RestrictionLayers,
    RestrictionGeometryTypes
)

import sys, traceback


""" ****************************** """

class TOMsExpressions():

    def __init__(self):
        QgsMessageLog.logMessage("Starting expressions ... ", tag='TOMs Panel', level=Qgis.Warning)

        self.functions = [
            self.generate_display_geometry,
            self.generateDisplayGeometry,
            self.generateCrossoverGeometry,
            self.getAzimuthToRoadCentreLine,
            self.getRoadName,
            self.getUSRN,
            self.generate_ZigZag,
            self.getWaitingLabelLeader,
            self.getLoadingLabelLeader,
            self.getBayLabelLeader,
            self.getPolygonLabelLeader,
            self.getWaitingRestrictionLabelText,
            self.getLoadingRestrictionLabelText,
            self.getBayTimePeriodLabelText,
            self.getBayMaxStayLabelText,
            self.getBayNoReturnLabelText,
            self.getBayLabelText,
            self.getCPZ,
            self.getPTA, self.prepareSignLine,
            self.prepareSignIconLocation,
            self.prepareSignIcon, self.prepareSignOrientation,
            self.generateDemandPoints,
            self.generateDemandShapes,
            self.generateAvailableSpacesShapes
        ]

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def generate_display_geometry(geometryID, restGeomType, AzimuthToCenterLine, offset, bayWidth, feature, parent):
        try:
            """TOMsMessageLog.logMessage(
                "In generate_display_geometry: New restriction .................................................................... ID: " + str(
                    geometryID), level=Qgis.Info)"""
            # res = generateGeometryUtils.getRestrictionGeometry(feature)
            res = ElementGeometryFactory.getElementGeometry(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('generate_display_geometry: error in expression function: {}'.format(e),
                              level=Qgis.Warning)
            """exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'generate_display_geometry error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""

        return res

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def generateDisplayGeometry(feature, parent):
        #def generateDisplayGeometry(restGeomType, AzimuthToCenterLine, offset, bayWidth, feature, parent):

        res = None

        try:
            """TOMsMessageLog.logMessage(
                "In generateDisplayGeometry: New restriction .................................................................... ID: " + str(
                    geometryID), level=Qgis.Info)"""

            # res = generateGeometryUtils.getRestrictionGeometry(feature)
            res = ElementGeometryFactory.getElementGeometry(feature)

        except Exception as e:
            TOMsMessageLog.logMessage('generateDisplayGeometry: error in expression function for feature [{}]: {}'.format(feature.attribute("GeometryID"), e),
                              level=Qgis.Warning)
            """TOMsMessageLog.logMessage('generateDisplayGeometry', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage('generateDisplayGeometry error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))), level=Qgis.Info)"""

        TOMsMessageLog.logMessage('generateDisplayGeometry: {}:{}'.format(feature.attribute("GeometryID"), res.asWkt()),
                              level=Qgis.Info)
        return res

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def generateCrossoverGeometry(feature, parent):

        res = None

        try:
            res = ElementGeometryFactory.getElementGeometry(feature, RestrictionGeometryTypes.CROSSOVER)

        except Exception as e:
            TOMsMessageLog.logMessage('generateDisplayGeometry: error in expression function for feature [{}]: {}'.format(feature.attribute("GeometryID"), e),
                              level=Qgis.Warning)
            TOMsMessageLog.logMessage('generateDisplayGeometry', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage('generateDisplayGeometry error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))), level=Qgis.Info)

        return res

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def getAzimuthToRoadCentreLine(feature, parent):
        # find the shortest line from this point to the road centre line layer
        # http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/ - generates "closest feature" function

        #TOMsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper):", level=Qgis.Info)

        try:
            return int(generateGeometryUtils.calculateAzimuthToRoadCentreLine(feature))
        except Exception as e:
            TOMsMessageLog.logMessage('getAzimuthToRoadCentreLine: error in expression function for feature [{}]: {}'.format(feature.attribute("GeometryID"), e),
                                      level=Qgis.Warning)
            """TOMsMessageLog.logMessage('getAzimuthToRoadCentreLine', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getAzimuthToRoadCentreLine: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def getRoadName(feature, parent):
        # Determine road name from the kerb line layer

        #TOMsMessageLog.logMessage("In getRoadName(helper):", level=Qgis.Info)
        try:
            newRoadName, newUSRN = generateGeometryUtils.determineRoadName(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getRoadName: error in expression function for feature [{}]: {}'.format(feature.attribute("GeometryID"), e),
                                      level=Qgis.Warning)
            newRoadName = None

            """TOMsMessageLog.logMessage('getRoadName', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getRoadName: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""
        return newRoadName


    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def getUSRN(feature, parent):
        # Determine road name from the kerb line layer

        #TOMsMessageLog.logMessage("In getUSRN(helper):", level=Qgis.Info)

        try:
            newRoadName, newUSRN = generateGeometryUtils.determineRoadName(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getUSRN: error in expression function for feature [{}]: {}'.format(feature.attribute("GeometryID"), e),
                                      level=Qgis.Warning)
            newUSRN = None
            """TOMsMessageLog.logMessage('getUSRN', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getUSRN: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""

        return newUSRN

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def generate_ZigZag(feature, parent):
        # Determine road name from the kerb line layer

        try:
            #res = generateGeometryUtils.zigzag(feature, 2, 1)
            res = ElementGeometryFactory.getElementGeometry(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('generate_ZigZag: error in expression function: {}'.format(e),
                                      level=Qgis.Warning)
            """TOMsMessageLog.logMessage('generate_ZigZag', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'generate_ZigZag: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""
        return res

        return newUSRN

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def getWaitingLabelLeader(feature, parent):
        # If the scale is within range (< 1250) and the label has been moved, create a line

        #TOMsMessageLog.logMessage(
        #    "In getWaitingLabelLeader ", level=Qgis.Info)
        try:
            labelLeaderGeom = generateGeometryUtils.generateWaitingLabelLeader(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getWaitingLabelLeader: error in expression function: {}'.format(e),
                                      level=Qgis.Warning)
            """TOMsMessageLog.logMessage('getWaitingLabelLeader', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getWaitingLabelLeader: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""

        return labelLeaderGeom

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def getLoadingLabelLeader(feature, parent):
        # If the scale is within range (< 1250) and the label has been moved, create a line

        #TOMsMessageLog.logMessage(
        #    "In getLoadingLabelLeader ", level=Qgis.Info)
        try:
            labelLeaderGeom = generateGeometryUtils.generateLoadingLabelLeader(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getLoadingLabelLeader: error in expression function: {}'.format(e),
                                      level=Qgis.Warning)
            """TOMsMessageLog.logMessage('getLoadingLabelLeader', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getLoadingLabelLeader: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""

        return labelLeaderGeom

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def getBayLabelLeader(feature, parent):
        # If the scale is within range (< 1250) and the label has been moved, create a line

        # TOMsMessageLog.logMessage("In getBayLabelLeader ", level=Qgis.Info)
        try:
            labelLeaderGeom = generateGeometryUtils.generateBayLabelLeader(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getBayLabelLeader: error in expression function: {}'.format(e),
                                      level=Qgis.Warning)
            """TOMsMessageLog.logMessage('getBayLabelLeader', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getBayLabelLeader: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""

        return labelLeaderGeom

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def getPolygonLabelLeader(feature, parent):
        # If the scale is within range (< 1250) and the label has been moved, create a line

        #TOMsMessageLog.logMessage("In getBayLabelLeader ", level=Qgis.Info)
        try:
            labelLeaderGeom = generateGeometryUtils.generatePolygonLabelLeader(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getPolygonLabelLeader: error in expression function: {}'.format(e),
                                      level=Qgis.Warning)
            """TOMsMessageLog.logMessage('getPolygonLabelLeader', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getPolygonLabelLeader: error in expression function: ' + str(
                    repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""
        return labelLeaderGeom

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
    def getWaitingRestrictionLabelText(feature, parent):
        # Returns the text to label the feature

        TOMsMessageLog.logMessage("In getWaitingRestrictionLabelText: Feature:{}".format(feature.attribute("GeometryID")), level=Qgis.Info)

        try:
            waitingText, loadingText = generateGeometryUtils.getWaitingLoadingRestrictionLabelText(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getWaitingRestrictionLabelText: error in expression function: {}'.format(e),
                                      level=Qgis.Warning)
            TOMsMessageLog.logMessage('getWaitingRestrictionLabelText', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getWaitingRestrictionLabelText: error in expression function: ' + str(
                    repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Warning)

        TOMsMessageLog.logMessage("In getWaitingRestrictionLabelText ****:" + " Waiting: " + str(waitingText) + " Loading: " + str(loadingText), level=Qgis.Info)
        # waitingText = "Test"
        if waitingText:
            #labelText = "No Waiting: " + waitingText
            labelText = waitingText
            return labelText

        return None

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
    def getLoadingRestrictionLabelText(feature, parent):
        # Returns the text to label the feature

        TOMsMessageLog.logMessage("In getLoadingRestrictionLabelText: Feature:{}".format(feature.attribute("GeometryID")), level=Qgis.Info)

        try:
            waitingText, loadingText = generateGeometryUtils.getWaitingLoadingRestrictionLabelText(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getLoadingRestrictionLabelText: error in expression function: {}'.format(e), level=Qgis.Warning)
            """TOMsMessageLog.logMessage('getLoadingRestrictionLabelText', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getLoadingRestrictionLabelText: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""

            TOMsMessageLog.logMessage(
            "In getLoadingRestrictionLabelText ****:" + " Waiting: " + str(waitingText) + " Loading: " + str(loadingText),
            level=Qgis.Info)

        if loadingText:
            #labelText = "No Loading: " + loadingText
            labelText = loadingText

            TOMsMessageLog.logMessage("In getLoadingRestrictionLabelText: passing " + str(labelText), level=Qgis.Info)
            return labelText

        return None

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
    def getBayTimePeriodLabelText(feature, parent):
        # Returns the text to label the feature

        #TOMsMessageLog.logMessage("In getBayTimePeriodLabelText:", level=Qgis.Info)

        try:
            maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getBayTimePeriodLabelText: error in expression function: {}'.format(e), level=Qgis.Warning)

        #TOMsMessageLog.logMessage("In getBayTimePeriodLabelText:" + str(timePeriodText), level=Qgis.Info)

        return timePeriodText

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
    def getBayMaxStayLabelText(feature, parent):
        # Returns the text to label the feature

        try:
            #TOMsMessageLog.logMessage("In getBayMaxStayLabelText:", level=Qgis.Info)
            maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getBayMaxStayLabelText: error in expression function: {}'.format(e), level=Qgis.Warning)
            """TOMsMessageLog.logMessage('getBayMaxStayLabelText', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getBayMaxStayLabelText: error in expression function: ' + str(
                    repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""

        #TOMsMessageLog.logMessage("In getBayMaxStayLabelText: " + str(maxStayText), level=Qgis.Info)

        return maxStayText

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
    def getBayNoReturnLabelText(feature, parent):
        # Returns the text to label the feature

        # TOMsMessageLog.logMessage("In getBayNoReturnLabelText:", level=Qgis.Info)
        try:
            maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getBayNoReturnLabelText: error in expression function: {}'.format(e), level=Qgis.Warning)
            """TOMsMessageLog.logMessage('getBayNoReturnLabelText', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getBayNoReturnLabelText: error in expression function: ' + str(
                    repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""
        #TOMsMessageLog.logMessage("In getBayNoReturnLabelText: " + str(noReturnText), level=Qgis.Info)

        return noReturnText

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
    def getBayLabelText(feature, parent):
        # Returns the text to label the feature

        TOMsMessageLog.logMessage("In getBayLabelText: {}".format(feature.attribute("GeometryID")), level=Qgis.Info)
        try:
            maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getBayLabelText: error in expression function: {}'.format(e), level=Qgis.Warning)
            """TOMsMessageLog.logMessage('getBayLabelText', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getBayLabelText: error in expression function: ' + str(
                    repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""
            maxStayText = None
            noReturnText = None
            timePeriodText = None

        labelText = ''

        if timePeriodText:
            labelText = '{text}'.format(text=timePeriodText)

        if maxStayText:
            if timePeriodText:
                labelText = labelText + ';'
            labelText = '{origText}Max Stay: {text}'.format(origText=labelText, text=maxStayText)

        if noReturnText:
            if timePeriodText or maxStayText:
                labelText = labelText + ';'
            labelText = '{origText}No Return: {text}'.format(origText=labelText, text=noReturnText)

        TOMsMessageLog.logMessage("In getBayLabelText: {}. text: {}".format(feature.attribute("GeometryID"), labelText), level=Qgis.Info)

        return labelText

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def getCPZ(feature, parent):
        # Returns the CPZ for the feature - or None
        try:
            cpzNr, cpzWaitingTimeID = generateGeometryUtils.getCurrentCPZDetails(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('getCPZ: error in expression function: {}'.format(e), level=Qgis.Warning)
            """TOMsMessageLog.logMessage('getCPZ', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getCPZ: error in expression function: ' + str(
                    repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)"""
        #TOMsMessageLog.logMessage("In getCPZ: CPZ " + str(cpzNr), level=Qgis.Info)

        return cpzNr

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def getPTA(feature, parent):
        # Returns the CPZ for the feature - or None

        try:
            ptaName, ptaMaxStayID, ptaNoReturnID = generateGeometryUtils.getCurrentPTADetails(feature)
        except Exception:
            TOMsMessageLog.logMessage('getPTA', level=Qgis.Info)
            exc_type, exc_value, exc_traceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                'getPTA: error in expression function: ' + str(
                    repr(traceback.extract_tb(exc_traceback))),
                level=Qgis.Info)

        #TOMsMessageLog.logMessage("In getPTA: PTA " + str(ptaName), level=Qgis.Info)

        return ptaName

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def prepareSignLine(feature, parent):
        newLineGeom = None
        try:
            newLineGeom, linePts = generateGeometryUtils.getGeneratedSignLine(feature)
        except Exception as e:
            QgsMessageLog.logMessage('prepareSignLine {}'.format(e), tag="TOMs Panel")
            exc_type, exc_value, exc_traceback = sys.exc_info()
            QgsMessageLog.logMessage(
                'prepareSignLine: error in expression function: {}{}'.format(exc_type, str(
                    repr(traceback.extract_tb(exc_traceback)))),
                tag="TOMs Panel")
        #QgsMessageLog.logMessage("In getPTA: PTA " + str(ptaName), tag="TOMs Panel")
        return newLineGeom

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def prepareSignIconLocation(signNr, feature, parent):

        newLineGeom = None
        linePts = []
        try:
            newLineGeom, linePts = generateGeometryUtils.getGeneratedSignLine(feature)
        except Exception as e:
            QgsMessageLog.logMessage('prepareSignIconLocation {}'.format(e), tag="TOMs Panel")
            exc_type, exc_value, exc_traceback = sys.exc_info()
            QgsMessageLog.logMessage(
                'prepareSignIconLocation: error in expression function: {}{}'.format(exc_type, str(
                    repr(traceback.extract_tb(exc_traceback)))),
                tag="TOMs Panel")
            return None

        return linePts[signNr-1].asWkt()

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
    def prepareSignIcon(signNr, feature, parent):
        iconNames = []
        try:
            iconNames = generateGeometryUtils.getSignIcons(feature)
        except Exception as e:
            QgsMessageLog.logMessage('prepareSignIcon {}'.format(e), tag="TOMs Panel")
            exc_type, exc_value, exc_traceback = sys.exc_info()
            QgsMessageLog.logMessage(
                'getSignIcon: error in expression function: ' + str(
                    repr(traceback.extract_tb(exc_traceback))),
                tag="TOMs Panel")
        if len(iconNames) >= signNr:
            return iconNames[signNr-1]
        else:
            return None

    @qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
    def prepareSignOrientation(feature, parent):
        signOrientation = 0
        try:
            signOrientation = generateGeometryUtils.getSignOrientationList(feature)
        except Exception as e:
            QgsMessageLog.logMessage('prepareSignOrientation {}'.format(e), tag="TOMs Panel")
            exc_type, exc_value, exc_traceback = sys.exc_info()
            QgsMessageLog.logMessage(
                'prepareSignOrientation: error in expression function: ' + str(
                    repr(traceback.extract_tb(exc_traceback))),
                tag="TOMs Panel")
        return signOrientation

    @qgsfunction(args='auto', group='TOMsDemand', usesgeometry=False, register=True)
    def generateDemandPoints(feature, parent):
        # Returns the location of points representing demand

        TOMsMessageLog.logMessage('generateDemandPoints: {}'.format(feature.attribute("GeometryID")),
                                  level=Qgis.Info)

        demand = math.ceil(float(feature.attribute("Demand")))

        TOMsMessageLog.logMessage(
            'generateDemandPoints: demand: {}'.format(demand),
            level=Qgis.Info)

        if demand == 0:
            return None

        capacity = int(feature.attribute("NrBays"))

        nrSpaces = capacity - demand
        if nrSpaces < 0:
            nrSpaces = 0

        TOMsMessageLog.logMessage('generateDemandPoints: capacity: {}; nrSpaces: {}; demand: {}'.format(capacity, nrSpaces, demand),
                                  level=Qgis.Info)

        # now get geometry for demand locations

        """
        #newFeature = QgsFeature(feature)
        currGeomShapeID = feature.attribute("GeomShapeID")
        if currGeomShapeID < 10:
            currGeomShapeID = currGeomShapeID + 20
        if currGeomShapeID >= 10 and currGeomShapeID < 20:
            currGeomShapeID = 21

        #newFeature.setAttribute("GeomShapeID", currGeomShapeID)"""

        try:
            #geomShowingSpaces = ElementGeometryFactory.getElementGeometry(newFeature)  # TODO: for some reason the details from newFeature are not "saved" and used
            #geomShowingSpaces = ElementGeometryFactory.getElementGeometry(feature, currGeomShapeID)
            geomShowingSpaces = ElementGeometryFactory.getElementGeometry(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('generateDemandPoints: error in expression function: {}'.format(e),
                              level=Qgis.Warning)
            return None

        random.seed(1234)  # need to ramdomise, but it needs to be repeatable?!?, i.e., when you pan, they stay in the same place
        listBaysToDelete = []
        listBaysToDelete = random.sample(range(capacity), k=math.ceil(nrSpaces))

        # deal with split geometries - half on/half off
        if feature.attribute("GeomShapeID") == 22:
            for i in range(capacity, (capacity*2)):  # NB: range stops one before end ...
                listBaysToDelete.append(i)

        TOMsMessageLog.logMessage('generateDemandPoints: bays to delete {}'.format(listBaysToDelete),
                                  level=Qgis.Info)

        centroidGeomList = []
        counter = 0
        for polygonGeom in geomShowingSpaces.parts():
            TOMsMessageLog.logMessage('generateDemandPoints: considering part {}'.format(counter),
                                      level=Qgis.Info)
            if not counter in listBaysToDelete:
                centrePt = QgsPointXY(polygonGeom.centroid())
                TOMsMessageLog.logMessage(
                    'generateDemandPoints: adding centroid for {}: {}'.format(counter, centrePt.asWkt()),
                    level=Qgis.Info)
                try:
                    centroidGeomList.append(centrePt)
                except Exception as e:
                    TOMsMessageLog.logMessage('generateDemandPoints: error adding centroid for counter {}: {}'.format(counter, e),
                                              level=Qgis.Warning)
            counter = counter + 1

        TOMsMessageLog.logMessage('generateDemandPoints: nrDemandPoints {}'.format(len(centroidGeomList)),
                                  level=Qgis.Info)

        try:
            demandPoints = QgsGeometry.fromMultiPointXY(centroidGeomList)
        except Exception as e:
            TOMsMessageLog.logMessage('generateDemandPoints: error creating final geom: {}'.format(e),
                                      level=Qgis.Warning)

        return demandPoints
    @qgsfunction(args='auto', group='TOMsDemand', usesgeometry=False, register=True)
    def generateDemandShapes(feature, parent):
        # Returns the location of points representing demand

        TOMsMessageLog.logMessage('generateDemandShapes: {}'.format(feature.attribute("GeometryID")),
                                  level=Qgis.Info)

        demand = math.ceil(float(feature.attribute("Demand")))

        TOMsMessageLog.logMessage(
            'generateDemandShapes: demand: {}'.format(demand),
            level=Qgis.Info)

        if demand == 0:
            return None

        capacity = int(feature.attribute("NrBays"))

        nrSpaces = capacity - demand
        if nrSpaces < 0:
            nrSpaces = 0

        TOMsMessageLog.logMessage(
            'generateDemandShapes: capacity: {}; nrSpaces: {}; demand: {}'.format(capacity, nrSpaces, demand),
            level=Qgis.Info)

        # now get geometry for demand locations
        try:
            geomShowingSpaces = ElementGeometryFactory.getElementGeometry(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('generateDemandShapes: error in expression function: {}'.format(e),
                                      level=Qgis.Warning)
            return None

        random.seed(
            1234)  # need to ramdomise, but it needs to be repeatable?!?, i.e., when you pan, they stay in the same place
        listBaysToDelete = []
        listBaysToDelete = random.sample(range(capacity), k=math.ceil(nrSpaces))

        # deal with split geometries - half on/half off
        if feature.attribute("GeomShapeID") == 22:
            for i in range(capacity, (capacity * 2)):  # NB: range stops one before end ...
                bayCheck = capacity * 2 - 1 - i
                if bayCheck in listBaysToDelete:
                    listBaysToDelete.append(i)

        TOMsMessageLog.logMessage('generateDemandShapes: bays to delete {}'.format(listBaysToDelete),
                                  level=Qgis.Info)

        counter = 0

        TOMsMessageLog.logMessage('generateDemandShapes: type: {} geomShowingSpaces {}'.format(QgsWkbTypes.displayString(geomShowingSpaces.wkbType()), geomShowingSpaces.asWkt()),
                                  level=Qgis.Info)

        multiPolyGeom = QgsGeometryCollection()
        for polygonGeom in geomShowingSpaces.parts():

            if not counter in listBaysToDelete:
                TOMsMessageLog.logMessage('generateDemandShapes: considering part {} {}'.format(counter, polygonGeom.asWkt()),
                                          level=Qgis.Info)
                try:
                    test = multiPolyGeom.addGeometry(polygonGeom.clone())
                except Exception as e:
                    TOMsMessageLog.logMessage(
                        'generateDemandShapes: error adding {}: {}'.format(counter, e),
                        level=Qgis.Warning)
            counter = counter + 1

        TOMsMessageLog.logMessage('generateDemandShapes: poly list {}'.format(multiPolyGeom),
                                  level=Qgis.Info)

        return QgsGeometry(multiPolyGeom)

    @qgsfunction(args='auto', group='TOMsDemand', usesgeometry=False, register=True)
    def generateAvailableSpacesShapes(feature, parent):
        # Returns the location of points representing demand

        TOMsMessageLog.logMessage('generateAvailableSpacesShapes: {}'.format(feature.attribute("GeometryID")),
                                  level=Qgis.Info)

        capacity = int(feature.attribute("Capacity"))

        if capacity == 0:
            return None

        demand = math.ceil(float(feature.attribute("Demand")))
        nrBays = int(feature.attribute("NrBays"))

        nrSpaces = nrBays - demand
        if nrSpaces < 0:
            nrSpaces = 0

        if nrSpaces == 0:
            return None

        TOMsMessageLog.logMessage(
            'generateAvailableSpacesShapes: nrSpaces: {}'.format(nrSpaces),
            level=Qgis.Info)

        TOMsMessageLog.logMessage(
            'generateAvailableSpacesShapes: nrBays: {}; nrSpaces: {}; demand: {}'.format(nrBays, nrSpaces, demand),
            level=Qgis.Info)

        # now get geometry for demand locations
        try:
            geomShowingSpaces = ElementGeometryFactory.getElementGeometry(feature)
        except Exception as e:
            TOMsMessageLog.logMessage('generateAvailableSpacesShapes: error in expression function: {}'.format(e),
                                      level=Qgis.Warning)
            return None

        random.seed(
            1234)  # need to ramdomise, but it needs to be repeatable?!?, i.e., when you pan, they stay in the same place
        listBaysToDelete = []
        listBaysToDelete = random.sample(range(nrBays), k=math.ceil(nrSpaces))

        # deal with split geometries - half on/half off
        if feature.attribute("GeomShapeID") == 22:
            for i in range(nrBays, (nrBays * 2)):  # NB: range stops one before end ...
                bayCheck = nrBays * 2 - 1 - i
                if bayCheck in listBaysToDelete:
                    listBaysToDelete.append(i)

        TOMsMessageLog.logMessage('generateAvailableSpacesShapes: bays to delete {}'.format(listBaysToDelete),
                                  level=Qgis.Info)

        counter = 0
                                  
        TOMsMessageLog.logMessage('generateAvailableSpacesShapes: type: {} geomShowingSpaces {}'.format(QgsWkbTypes.displayString(geomShowingSpaces.wkbType()), geomShowingSpaces.asWkt()),
                                  level=Qgis.Info)

        multiPolyGeom = QgsGeometryCollection()

        #TOMsMessageLog.logMessage('generateAvailableSpacesShapes: check {} {}'.format(feature.attribute("GeometryID"), counter),
        #                          level=Qgis.Info)

        for polygonGeom in geomShowingSpaces.parts():

            if counter in listBaysToDelete:
                TOMsMessageLog.logMessage('generateAvailableSpacesShapes: considering part {} {}'.format(counter, polygonGeom.asWkt()),
                                          level=Qgis.Info)
                try:
                    test = multiPolyGeom.addGeometry(polygonGeom.clone())
                except Exception as e:
                    TOMsMessageLog.logMessage(
                        'generateAvailableSpacesShapes: error adding {}: {}'.format(counter, e),
                        level=Qgis.Warning)
            counter = counter + 1

        #TOMsMessageLog.logMessage('generateAvailableSpacesShapes: check2 {} {}'.format(feature.attribute("GeometryID"), counter),
        #                          level=Qgis.Info)

        TOMsMessageLog.logMessage('generateAvailableSpacesShapes: poly list {}'.format(multiPolyGeom),
                                  level=Qgis.Info)

        return QgsGeometry(multiPolyGeom)

    def registerFunctions(self):

        toms_list = QgsExpression.Functions()

        for func in self.functions:
            TOMsMessageLog.logMessage("Considering function {}".format(func.name()), level=Qgis.Info)
            try:
                if func in toms_list:
                    QgsExpression.unregisterFunction(func.name())
            except AttributeError:
                pass

            if QgsExpression.registerFunction(func):
                TOMsMessageLog.logMessage("Registered expression function {}".format(func.name()), level=Qgis.Info)

    def unregisterFunctions(self):
        # Unload all the functions that we created.
        for func in self.functions:
            QgsExpression.unregisterFunction(func.name())
            TOMsMessageLog.logMessage("Unregistered expression function {}".format(func.name()), level=Qgis.Info)

        #QgsExpression.cleanRegisteredFunctions()  # this seems to crash the reload ...
