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
    QgsExpression
)
import math
from .generateGeometryUtils import generateGeometryUtils
from .core.TOMsGeometryElement import ElementGeometryFactory

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

    except:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'generate_display_geometry error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)

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

    except:
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

    except:
        TOMsMessageLog.logMessage('getAzimuthToRoadCentreLine', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getAzimuthToRoadCentreLine: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getRoadName(feature, parent):
	# Determine road name from the kerb line layer

    #TOMsMessageLog.logMessage("In getRoadName(helper):", level=Qgis.Info)
    try:
        newStreetName, newUSRN = generateGeometryUtils.determineRoadName(feature)
    except:
        TOMsMessageLog.logMessage('getRoadName', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getRoadName: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)
    return newStreetName


@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getUSRN(feature, parent):
	# Determine road name from the kerb line layer

    #TOMsMessageLog.logMessage("In getUSRN(helper):", level=Qgis.Info)

    try:
        newStreetName, newUSRN = generateGeometryUtils.determineRoadName(feature)
    except:
        TOMsMessageLog.logMessage('getUSRN', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getUSRN: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)

    return newUSRN

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def generate_ZigZag(feature, parent):
	# Determine road name from the kerb line layer

    try:
        res = generateGeometryUtils.zigzag(feature, 2, 1)
    except:
        TOMsMessageLog.logMessage('generate_ZigZag', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'generate_ZigZag: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)
    return res

    return newUSRN

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getWaitingLabelLeader(feature, parent):
	# If the scale is within range (< 1250) and the label has been moved, create a line

    #TOMsMessageLog.logMessage(
    #    "In getWaitingLabelLeader ", level=Qgis.Info)
    try:
        labelLeaderGeom = generateGeometryUtils.generateWaitingLabelLeader(feature)
    except:
        TOMsMessageLog.logMessage('getWaitingLabelLeader', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getWaitingLabelLeader: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)

    return labelLeaderGeom

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getLoadingLabelLeader(feature, parent):
	# If the scale is within range (< 1250) and the label has been moved, create a line

    #TOMsMessageLog.logMessage(
    #    "In getLoadingLabelLeader ", level=Qgis.Info)
    try:
        labelLeaderGeom = generateGeometryUtils.generateLoadingLabelLeader(feature)
    except:
        TOMsMessageLog.logMessage('getLoadingLabelLeader', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getLoadingLabelLeader: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)

    return labelLeaderGeom

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getBayLabelLeader(feature, parent):
	# If the scale is within range (< 1250) and the label has been moved, create a line

    # TOMsMessageLog.logMessage("In getBayLabelLeader ", level=Qgis.Info)
    try:
        labelLeaderGeom = generateGeometryUtils.generateBayLabelLeader(feature)
    except:
        TOMsMessageLog.logMessage('getBayLabelLeader', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getBayLabelLeader: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)

    return labelLeaderGeom

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getPolygonLabelLeader(feature, parent):
	# If the scale is within range (< 1250) and the label has been moved, create a line

    #TOMsMessageLog.logMessage("In getBayLabelLeader ", level=Qgis.Info)
    try:
        labelLeaderGeom = generateGeometryUtils.generatePolygonLabelLeader(feature)
    except:
        TOMsMessageLog.logMessage('getPolygonLabelLeader', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getPolygonLabelLeader: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)
    return labelLeaderGeom

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getWaitingRestrictionLabelText(feature, parent):
	# Returns the text to label the feature

    #TOMsMessageLog.logMessage("In getWaitingRestrictionLabelText:", level=Qgis.Info)

    try:
        waitingText, loadingText = generateGeometryUtils.getWaitingLoadingRestrictionLabelText(feature)
    except:
        TOMsMessageLog.logMessage('getWaitingRestrictionLabelText', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getWaitingRestrictionLabelText: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)

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

    #TOMsMessageLog.logMessage("In getLoadingRestrictionLabelText:", level=Qgis.Info)

    try:
        waitingText, loadingText = generateGeometryUtils.getWaitingLoadingRestrictionLabelText(feature)

    except:
        TOMsMessageLog.logMessage('getLoadingRestrictionLabelText', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getLoadingRestrictionLabelText: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)

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

    try:
        #TOMsMessageLog.logMessage("In getBayTimePeriodLabelText:", level=Qgis.Info)

        maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)

    except:
        TOMsMessageLog.logMessage('getBayTimePeriodLabelText', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getBayTimePeriodLabelText: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)

    #TOMsMessageLog.logMessage("In getBayTimePeriodLabelText:" + str(timePeriodText), level=Qgis.Info)

    return timePeriodText

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getBayMaxStayLabelText(feature, parent):
	# Returns the text to label the feature

    try:
        #TOMsMessageLog.logMessage("In getBayMaxStayLabelText:", level=Qgis.Info)

        maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)

    except:
        TOMsMessageLog.logMessage('getBayMaxStayLabelText', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getBayMaxStayLabelText: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)

    #TOMsMessageLog.logMessage("In getBayMaxStayLabelText: " + str(maxStayText), level=Qgis.Info)

    return maxStayText

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getBayNoReturnLabelText(feature, parent):
	# Returns the text to label the feature

    # TOMsMessageLog.logMessage("In getBayNoReturnLabelText:", level=Qgis.Info)
    try:
        maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)
    except:
        TOMsMessageLog.logMessage('getBayNoReturnLabelText', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getBayNoReturnLabelText: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)
    #TOMsMessageLog.logMessage("In getBayNoReturnLabelText: " + str(noReturnText), level=Qgis.Info)

    return noReturnText

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getBayLabelText(feature, parent):
	# Returns the text to label the feature

    TOMsMessageLog.logMessage("In getBayLabelText:", level=Qgis.Info)
    try:
        maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)
    except:
        TOMsMessageLog.logMessage('getBayLabelText', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getBayLabelText: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)

    labelText = ''

    if timePeriodText:
        labelText = '{text}'.format(text=timePeriodText)

    if maxStayText:
        if timePeriodText:
            labelText = labelText + ';'
        labelText = '{origText} Max Stay: {text}'.format(origText=labelText, text=maxStayText)

    if noReturnText:
        if timePeriodText or noReturnText:
            labelText = labelText + ';'
        labelText = '{origText} No Return: {text}'.format(origText=labelText, text=noReturnText)

    #TOMsMessageLog.logMessage("In getBayLabelText: " + str(labelText), level=Qgis.Info)

    return labelText

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getCPZ(feature, parent):
	# Returns the CPZ for the feature - or None

    #TOMsMessageLog.logMessage("In getCPZ:", level=Qgis.Info)

    try:
        cpzNr, cpzWaitingTimeID = generateGeometryUtils.getCurrentCPZDetails(feature)
    except:
        TOMsMessageLog.logMessage('getCPZ', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getCPZ: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)
    #TOMsMessageLog.logMessage("In getCPZ: CPZ " + str(cpzNr), level=Qgis.Info)

    return cpzNr

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getPTA(feature, parent):
	# Returns the CPZ for the feature - or None

    #TOMsMessageLog.logMessage("In getPTA:", level=Qgis.Info)
    try:
        ptaName, ptaMaxStayID, ptaNoReturnTimeID = generateGeometryUtils.getCurrentPTADetails(feature)
    except:
        TOMsMessageLog.logMessage('getPTA', level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        TOMsMessageLog.logMessage(
            'getPTA: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            level=Qgis.Info)

    #TOMsMessageLog.logMessage("In getPTA: PTA " + str(ptaName), level=Qgis.Info)

    return ptaName

functions = [
    generate_display_geometry,
    generateDisplayGeometry,
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
    getPTA
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
