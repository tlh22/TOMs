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
    QgsExpression, QgsGeometry, QgsPointXY
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
        TOMsMessageLog.logMessage('generateDisplayGeometry: error in expression function: {}'.format(e),
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
        TOMsMessageLog.logMessage('generateDisplayGeometry: error in expression function: {}'.format(e),
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
        TOMsMessageLog.logMessage('getAzimuthToRoadCentreLine: error in expression function: {}'.format(e),
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
        TOMsMessageLog.logMessage('getRoadName: error in expression function: {}'.format(e),
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
        TOMsMessageLog.logMessage('getUSRN: error in expression function: {}'.format(e),
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

    #TOMsMessageLog.logMessage("In getWaitingRestrictionLabelText:", level=Qgis.Info)

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

    #TOMsMessageLog.logMessage("In getWaitingRestrictionLabelText ****:" + " Waiting: " + str(waitingText) + " Loading: " + str(loadingText), level=Qgis.Info)
    # waitingText = "Test"
    if waitingText:
        labelText = "No Waiting: " + waitingText
        labelText = waitingText
        return labelText

    return None

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getLoadingRestrictionLabelText(feature, parent):
	# Returns the text to label the feature

    try:
        waitingText, loadingText = generateGeometryUtils.getWaitingLoadingRestrictionLabelText(feature)
    except Exception as e:
        TOMsMessageLog.logMessage('getLoadingRestrictionLabelText: error in expression function: {}'.format(e), level=Qgis.Warning)
        """TOMsMessageLog.logMessage('getLoadingRestrictionLabelText', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getLoadingRestrictionLabelText: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)"""

        """TOMsMessageLog.logMessage(
        "In getLoadingRestrictionLabelText ****:" + " Waiting: " + str(waitingText) + " Loading: " + str(loadingText),
        level=Qgis.Info)"""

    if loadingText:
        #labelText = "No Loading: " + loadingText
        labelText = loadingText

        #TOMsMessageLog.logMessage("In getLoadingRestrictionLabelText: passing " + str(labelText), level=Qgis.Info)
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

    TOMsMessageLog.logMessage("In getBayLabelText:", level=Qgis.Info)
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
        labelText = '{origText} Max Stay: {text}'.format(origText=labelText, text=maxStayText)

    if noReturnText:
        if timePeriodText or maxStayText:
            labelText = labelText + ';'
        labelText = '{origText} No Return: {text}'.format(origText=labelText, text=noReturnText)

    #TOMsMessageLog.logMessage("In getBayLabelText: " + str(labelText), level=Qgis.Info)

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
    # Returns the text to label the feature

    res = None

    try:
        geomShowingSpaces = ElementGeometryFactory.getElementGeometry(feature)
    except Exception as e:
        TOMsMessageLog.logMessage('generateDemandPoints: error in expression function: {}'.format(e),
                          level=Qgis.Warning)
        return None

    TOMsMessageLog.logMessage('generateDemandPoints: {}'.format(feature.attribute("GeometryID")),
                          level=Qgis.Info)

    # generate "template" indicating how to populute
    # know capacity - "NrBays" - and "Demand" - "Demand"

    demand = feature.attribute("Demand_Demand")  # Need better naming ...
    if demand == 0:
        return None

    nrBays = feature.attribute("NrBays")

    try:
        nrSpaces = int(feature.attribute("Demand_nspaces"))
    except Exception as e:
        TOMsMessageLog.logMessage('generateDemandPoints: error converting spaces: {}'.format(e),
                          level=Qgis.Warning)
        nrSpaces = 0

    TOMsMessageLog.logMessage('generateDemandPoints: {}; {}; {}'.format(nrBays, nrSpaces, demand),
                              level=Qgis.Info)

    nrSpaces = nrBays - demand
    if nrSpaces < 0:
        nrSpaces = 0

    TOMsMessageLog.logMessage('generateDemandPoints 3: {}; {}'.format(nrBays, nrSpaces),
                              level=Qgis.Info)

    random.seed(1234)  # need to ramdomise, but it needs to be repeatable?!?, i.e., when you pan, they stay in the same place
    listBaysToDelete = []
    listBaysToDelete = random.sample(range(nrBays), k=math.ceil(nrSpaces))

    TOMsMessageLog.logMessage('generateDemandPoints: {}'.format(listBaysToDelete),
                              level=Qgis.Info)

    centroidGeomList = []
    counter = 0
    for polygonGeom in geomShowingSpaces.parts():
        TOMsMessageLog.logMessage('generateDemandPoints: adding a part {}'.format(polygonGeom.asWkt()),
                                  level=Qgis.Info)
        if not counter in listBaysToDelete:
            try:
                centrePt = QgsPointXY(polygonGeom.centroid())
                TOMsMessageLog.logMessage('generateDemandPoints: centroid {}'.format(centrePt.asWkt()),
                                          level=Qgis.Info)
                centroidGeomList.append(centrePt)
            except Exception as e:
                TOMsMessageLog.logMessage('generateDemandPoints: error add centroids: {}'.format(e),
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

functions = [
    generate_display_geometry,
    generateDisplayGeometry,
    generateCrossoverGeometry,
    getAzimuthToRoadCentreLine,
    getRoadName,
    getUSRN,
    generate_ZigZag,
    getWaitingLabelLeader,
    getLoadingLabelLeader,
    getBayLabelLeader,
    getPolygonLabelLeader,
    getWaitingRestrictionLabelText,
    getLoadingRestrictionLabelText,
    getBayTimePeriodLabelText,
    getBayMaxStayLabelText,
    getBayNoReturnLabelText,
    getBayLabelText,
    getCPZ,
    getPTA, prepareSignLine,
    prepareSignIconLocation,
    prepareSignIcon, prepareSignOrientation,
    generateDemandPoints
]

def registerFunctions():

    toms_list = QgsExpression.Functions()

    for func in functions:
        TOMsMessageLog.logMessage("Considering function {}".format(func.name()), level=Qgis.Info)
        try:
            if func in toms_list:
                QgsExpression.unregisterFunction(func.name())
                #del toms_list[func.name()]
        except AttributeError:
            #qgis.toms_functions = dict()
            pass

        if QgsExpression.registerFunction(func):
            TOMsMessageLog.logMessage("Registered expression function {}".format(func.name()), level=Qgis.Info)
            #qgis.toms_functions[func.name()] = func

    """for title in qgis.toms_functions:
        TOMsMessageLog.logMessage("toms_functions function {}".format(title), level=Qgis.Info)

    for title2 in toms_list:
        TOMsMessageLog.logMessage("toms_list function {}".format(title2.name()), level=Qgis.Info)"""

def unregisterFunctions():
    # Unload all the functions that we created.
    for func in functions:
        QgsExpression.unregisterFunction(func.name())
        TOMsMessageLog.logMessage("Unregistered expression function {}".format(func.name()), level=Qgis.Info)
        #del qgis.toms_functions[func.name()]

    QgsExpression.cleanRegisteredFunctions()
