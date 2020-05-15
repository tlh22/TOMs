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
        """QgsMessageLog.logMessage(
            "In generate_display_geometry: New restriction .................................................................... ID: " + str(
                geometryID), tag="TOMs panel", level=Qgis.Info)"""

        # res = generateGeometryUtils.getRestrictionGeometry(feature)
        res = ElementGeometryFactory.getElementGeometry(feature)

    except:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'generate_display_geometry error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)

    return res

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def generateDisplayGeometry(feature, parent):
    #def generateDisplayGeometry(restGeomType, AzimuthToCenterLine, offset, bayWidth, feature, parent):

    res = None

    try:
        """QgsMessageLog.logMessage(
            "In generateDisplayGeometry: New restriction .................................................................... ID: " + str(
                geometryID), tag="TOMs panel", level=Qgis.Info)"""

        # res = generateGeometryUtils.getRestrictionGeometry(feature)
        res = ElementGeometryFactory.getElementGeometry(feature)

    except:
        QgsMessageLog.logMessage('generateDisplayGeometry', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage('generateDisplayGeometry error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))), tag="TOMs panel", level=Qgis.Info)

    return res

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getAzimuthToRoadCentreLine(feature, parent):
	# find the shortest line from this point to the road centre line layer
	# http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/ - generates "closest feature" function

	#QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper):", tag="TOMs panel", level=Qgis.Info)

    try:
        return int(generateGeometryUtils.calculateAzimuthToRoadCentreLine(feature))

    except:
        QgsMessageLog.logMessage('getAzimuthToRoadCentreLine', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getAzimuthToRoadCentreLine: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getRoadName(feature, parent):
	# Determine road name from the kerb line layer

    #QgsMessageLog.logMessage("In getRoadName(helper):", tag="TOMs panel", level=Qgis.Info)
    try:
        newStreetName, newUSRN = generateGeometryUtils.determineRoadName(feature)
    except:
        QgsMessageLog.logMessage('getRoadName', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getRoadName: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)
    return newStreetName


@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getUSRN(feature, parent):
	# Determine road name from the kerb line layer

    #QgsMessageLog.logMessage("In getUSRN(helper):", tag="TOMs panel", level=Qgis.Info)

    try:
        newStreetName, newUSRN = generateGeometryUtils.determineRoadName(feature)
    except:
        QgsMessageLog.logMessage('getUSRN', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getUSRN: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)

    return newUSRN

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def generate_ZigZag(feature, parent):
	# Determine road name from the kerb line layer

    try:
        res = generateGeometryUtils.zigzag(feature, 2, 1)
    except:
        QgsMessageLog.logMessage('generate_ZigZag', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'generate_ZigZag: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)
    return res

    return newUSRN

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getWaitingLabelLeader(feature, parent):
	# If the scale is within range (< 1250) and the label has been moved, create a line

    #QgsMessageLog.logMessage(
    #    "In getWaitingLabelLeader ", tag="TOMs panel", level=Qgis.Info)
    try:
        labelLeaderGeom = generateGeometryUtils.generateWaitingLabelLeader(feature)
    except:
        QgsMessageLog.logMessage('getWaitingLabelLeader', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getWaitingLabelLeader: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)

    return labelLeaderGeom

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getLoadingLabelLeader(feature, parent):
	# If the scale is within range (< 1250) and the label has been moved, create a line

    #QgsMessageLog.logMessage(
    #    "In getLoadingLabelLeader ", tag="TOMs panel", level=Qgis.Info)
    try:
        labelLeaderGeom = generateGeometryUtils.generateLoadingLabelLeader(feature)
    except:
        QgsMessageLog.logMessage('getLoadingLabelLeader', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getLoadingLabelLeader: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)

    return labelLeaderGeom

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getBayLabelLeader(feature, parent):
	# If the scale is within range (< 1250) and the label has been moved, create a line

    # QgsMessageLog.logMessage("In getBayLabelLeader ", tag="TOMs panel", level=Qgis.Info)
    try:
        labelLeaderGeom = generateGeometryUtils.generateBayLabelLeader(feature)
    except:
        QgsMessageLog.logMessage('getBayLabelLeader', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getBayLabelLeader: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)

    return labelLeaderGeom

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getPolygonLabelLeader(feature, parent):
	# If the scale is within range (< 1250) and the label has been moved, create a line

    #QgsMessageLog.logMessage("In getBayLabelLeader ", tag="TOMs panel", level=Qgis.Info)
    try:
        labelLeaderGeom = generateGeometryUtils.generatePolygonLabelLeader(feature)
    except:
        QgsMessageLog.logMessage('getPolygonLabelLeader', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getPolygonLabelLeader: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)
    return labelLeaderGeom

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getWaitingRestrictionLabelText(feature, parent):
	# Returns the text to label the feature

    #QgsMessageLog.logMessage("In getWaitingRestrictionLabelText:", tag="TOMs panel", level=Qgis.Info)

    try:
        waitingText, loadingText = generateGeometryUtils.getWaitingLoadingRestrictionLabelText(feature)
    except:
        QgsMessageLog.logMessage('getWaitingRestrictionLabelText', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getWaitingRestrictionLabelText: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)

    #QgsMessageLog.logMessage("In getWaitingRestrictionLabelText ****:" + " Waiting: " + str(waitingText) + " Loading: " + str(loadingText), tag="TOMs panel", level=Qgis.Info)
    # waitingText = "Test"
    if waitingText:
        labelText = "No Waiting: " + waitingText
        labelText = waitingText
        return labelText

    return None

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getLoadingRestrictionLabelText(feature, parent):
	# Returns the text to label the feature

    #QgsMessageLog.logMessage("In getLoadingRestrictionLabelText:", tag="TOMs panel", level=Qgis.Info)

    try:
        waitingText, loadingText = generateGeometryUtils.getWaitingLoadingRestrictionLabelText(feature)

    except:
        QgsMessageLog.logMessage('getLoadingRestrictionLabelText', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getLoadingRestrictionLabelText: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)

        """QgsMessageLog.logMessage(
        "In getLoadingRestrictionLabelText ****:" + " Waiting: " + str(waitingText) + " Loading: " + str(loadingText),
        tag="TOMs panel", level=Qgis.Info)"""

    if loadingText:
        #labelText = "No Loading: " + loadingText
        labelText = loadingText

        #QgsMessageLog.logMessage("In getLoadingRestrictionLabelText: passing " + str(labelText), tag="TOMs panel", level=Qgis.Info)
        return labelText

    return None

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getBayTimePeriodLabelText(feature, parent):
	# Returns the text to label the feature

    try:
        #QgsMessageLog.logMessage("In getBayTimePeriodLabelText:", tag="TOMs panel", level=Qgis.Info)

        maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)

    except:
        QgsMessageLog.logMessage('getBayTimePeriodLabelText', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getBayTimePeriodLabelText: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)

    #QgsMessageLog.logMessage("In getBayTimePeriodLabelText:" + str(timePeriodText), tag="TOMs panel", level=Qgis.Info)

    return timePeriodText

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getBayMaxStayLabelText(feature, parent):
	# Returns the text to label the feature

    try:
        #QgsMessageLog.logMessage("In getBayMaxStayLabelText:", tag="TOMs panel", level=Qgis.Info)

        maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)

    except:
        QgsMessageLog.logMessage('getBayMaxStayLabelText', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getBayMaxStayLabelText: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)

    #QgsMessageLog.logMessage("In getBayMaxStayLabelText: " + str(maxStayText), tag="TOMs panel", level=Qgis.Info)

    return maxStayText

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getBayNoReturnLabelText(feature, parent):
	# Returns the text to label the feature

    # QgsMessageLog.logMessage("In getBayNoReturnLabelText:", tag="TOMs panel", level=Qgis.Info)
    try:
        maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)
    except:
        QgsMessageLog.logMessage('getBayNoReturnLabelText', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getBayNoReturnLabelText: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)
    #QgsMessageLog.logMessage("In getBayNoReturnLabelText: " + str(noReturnText), tag="TOMs panel", level=Qgis.Info)

    return noReturnText

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getBayLabelText(feature, parent):
	# Returns the text to label the feature

    QgsMessageLog.logMessage("In getBayLabelText:", tag="TOMs panel", level=Qgis.Info)
    try:
        maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)
    except:
        QgsMessageLog.logMessage('getBayLabelText', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getBayLabelText: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)

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

    #QgsMessageLog.logMessage("In getBayLabelText: " + str(labelText), tag="TOMs panel", level=Qgis.Info)

    return labelText

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getCPZ(feature, parent):
	# Returns the CPZ for the feature - or None

    #QgsMessageLog.logMessage("In getCPZ:", tag="TOMs panel", level=Qgis.Info)

    try:
        cpzNr, cpzWaitingTimeID = generateGeometryUtils.getCurrentCPZDetails(feature)
    except:
        QgsMessageLog.logMessage('getCPZ', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getCPZ: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)
    #QgsMessageLog.logMessage("In getCPZ: CPZ " + str(cpzNr), tag="TOMs panel", level=Qgis.Info)

    return cpzNr

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getPTA(feature, parent):
	# Returns the CPZ for the feature - or None

    #QgsMessageLog.logMessage("In getPTA:", tag="TOMs panel", level=Qgis.Info)
    try:
        ptaName, ptaMaxStayID, ptaNoReturnTimeID = generateGeometryUtils.getCurrentPTADetails(feature)
    except:
        QgsMessageLog.logMessage('getPTA', tag="TOMs panel", level=Qgis.Info)
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getPTA: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel", level=Qgis.Info)

    #QgsMessageLog.logMessage("In getPTA: PTA " + str(ptaName), tag="TOMs panel", level=Qgis.Info)

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
        QgsMessageLog.logMessage("Considering function {}".format(func.name()), tag="TOMs panel", level=Qgis.Info)
        try:
            if func in toms_list:
                QgsExpression.unregisterFunction(func.name())
                #del toms_list[func.name()]
        except AttributeError:
            #qgis.toms_functions = dict()
            pass

        if QgsExpression.registerFunction(func):
            QgsMessageLog.logMessage("Registered expression function {}".format(func.name()), tag="TOMs panel", level=Qgis.Info)
            #qgis.toms_functions[func.name()] = func

    """for title in qgis.toms_functions:
        QgsMessageLog.logMessage("toms_functions function {}".format(title), tag="TOMs panel", level=Qgis.Info)

    for title2 in toms_list:
        QgsMessageLog.logMessage("toms_list function {}".format(title2.name()), tag="TOMs panel", level=Qgis.Info)"""

def unregisterFunctions():
    # Unload all the functions that we created.
    for func in functions:
        QgsExpression.unregisterFunction(func.name())
        QgsMessageLog.logMessage("Unregistered expression function {}".format(func.name()), tag="TOMs panel", level=Qgis.Info)
        #del qgis.toms_functions[func.name()]

    QgsExpression.cleanRegisteredFunctions()
