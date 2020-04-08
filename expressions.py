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
    QgsMessageLog,
    QgsExpression,
    QgsProject,
    QgsFeatureRequest,
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
                geometryID), tag="TOMs panel")"""

        # res = generateGeometryUtils.getRestrictionGeometry(feature)
        res = ElementGeometryFactory.getElementGeometry(feature)

    except:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'generate_display_geometry error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")

    return res

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def generateDisplayGeometry(feature, parent):
    #def generateDisplayGeometry(restGeomType, AzimuthToCenterLine, offset, bayWidth, feature, parent):

    res = None

    try:
        """QgsMessageLog.logMessage(
            "In generateDisplayGeometry: New restriction .................................................................... ID: " + str(
                geometryID), tag="TOMs panel")"""

        # res = generateGeometryUtils.getRestrictionGeometry(feature)
        res = ElementGeometryFactory.getElementGeometry(feature)

    except:
        QgsMessageLog.logMessage('generateDisplayGeometry', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage('generateDisplayGeometry error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))), tag="TOMs panel")

    return res

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getAzimuthToRoadCentreLine(feature, parent):
	# find the shortest line from this point to the road centre line layer
	# http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/ - generates "closest feature" function

	#QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper):", tag="TOMs panel")

    try:
        return int(generateGeometryUtils.calculateAzimuthToRoadCentreLine(feature))

    except:
        QgsMessageLog.logMessage('getAzimuthToRoadCentreLine', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getAzimuthToRoadCentreLine: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getRoadName(feature, parent):
	# Determine road name from the kerb line layer

    #QgsMessageLog.logMessage("In getRoadName(helper):", tag="TOMs panel")
    try:
        newStreetName, newUSRN = generateGeometryUtils.determineRoadName(feature)
    except:
        QgsMessageLog.logMessage('getRoadName', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getRoadName: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")
    return newStreetName


@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getUSRN(feature, parent):
	# Determine road name from the kerb line layer

    #QgsMessageLog.logMessage("In getUSRN(helper):", tag="TOMs panel")

    try:
        newStreetName, newUSRN = generateGeometryUtils.determineRoadName(feature)
    except:
        QgsMessageLog.logMessage('getUSRN', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getUSRN: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")

    return newUSRN

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def generate_ZigZag(feature, parent):
	# Determine road name from the kerb line layer

    try:
        res = generateGeometryUtils.zigzag(feature, 2, 1)
    except:
        QgsMessageLog.logMessage('generate_ZigZag', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'generate_ZigZag: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")
    return res

    return newUSRN

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getWaitingLabelLeader(feature, parent):
	# If the scale is within range (< 1250) and the label has been moved, create a line

    #QgsMessageLog.logMessage(
    #    "In getWaitingLabelLeader ", tag="TOMs panel")
    try:
        labelLeaderGeom = generateGeometryUtils.generateWaitingLabelLeader(feature)
    except:
        QgsMessageLog.logMessage('getWaitingLabelLeader', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getWaitingLabelLeader: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")

    return labelLeaderGeom

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getLoadingLabelLeader(feature, parent):
	# If the scale is within range (< 1250) and the label has been moved, create a line

    #QgsMessageLog.logMessage(
    #    "In getLoadingLabelLeader ", tag="TOMs panel")
    try:
        labelLeaderGeom = generateGeometryUtils.generateLoadingLabelLeader(feature)
    except:
        QgsMessageLog.logMessage('getLoadingLabelLeader', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getLoadingLabelLeader: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")

    return labelLeaderGeom

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getBayLabelLeader(feature, parent):
	# If the scale is within range (< 1250) and the label has been moved, create a line

    # QgsMessageLog.logMessage("In getBayLabelLeader ", tag="TOMs panel")
    try:
        labelLeaderGeom = generateGeometryUtils.generateBayLabelLeader(feature)
    except:
        QgsMessageLog.logMessage('getBayLabelLeader', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getBayLabelLeader: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")

    return labelLeaderGeom

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getPolygonLabelLeader(feature, parent):
	# If the scale is within range (< 1250) and the label has been moved, create a line

    #QgsMessageLog.logMessage("In getBayLabelLeader ", tag="TOMs panel")
    try:
        labelLeaderGeom = generateGeometryUtils.generatePolygonLabelLeader(feature)
    except:
        QgsMessageLog.logMessage('getPolygonLabelLeader', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getPolygonLabelLeader: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")
    return labelLeaderGeom

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getLabelText(feature, parent):
    # Returns the label text
    purpose = feature.attribute("purpose")

    def get_related_feature(layer_name, pk_field, pk):
        # get a feature from a layer
        layer = QgsProject.instance().mapLayersByName(layer_name)[0]
        if isinstance(pk, str):
            pk = "'{}'".format(pk)
        request = '"{}" = {}'.format(pk_field, pk)
        features = layer.getFeatures(QgsFeatureRequest().setFilterExpression(request))
        for f in features:
            return f # return the first feature
        return None

    # dispatch to the correct label function
    # this reimplements the logic that previously was in the QGIS file's rule based label definition
    if feature.attribute('lines_pk'):
        related_feature = get_related_feature('Lines', 'GeometryID', feature.attribute('lines_pk'))
        if purpose == 'waiting':
            if related_feature.attribute("RestrictionTypeID") in (201, 221):
                return getWaitingRestrictionLabelText.function(related_feature, parent)
        elif purpose == 'loading':
            if related_feature.attribute("RestrictionTypeID") in (201, 202, 221):
                return getLoadingRestrictionLabelText.function(related_feature, parent)

    elif feature.attribute('bays_pk'):
        # TODO : implement
        return 'Not implemented'

    elif feature.attribute('signs_pk'):
        # TODO : implement
        return 'Not implemented'

    elif feature.attribute('polys_pk'):
        # TODO : implement
        return 'Not implemented'

    elif feature.attribute('cpzs_pk'):
        # TODO : implement
        return 'Not implemented'

    elif feature.attribute('parking_pk'):
        # TODO : implement
        return 'Not implemented'

    return ''


@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getWaitingRestrictionLabelText(feature, parent):
	# Returns the text to label the feature

    #QgsMessageLog.logMessage("In getWaitingRestrictionLabelText:", tag="TOMs panel")

    try:
        waitingText, loadingText = generateGeometryUtils.getWaitingLoadingRestrictionLabelText(feature)
    except:
        QgsMessageLog.logMessage('getWaitingRestrictionLabelText', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getWaitingRestrictionLabelText: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")

    #QgsMessageLog.logMessage("In getWaitingRestrictionLabelText ****:" + " Waiting: " + str(waitingText) + " Loading: " + str(loadingText), tag="TOMs panel")
    # waitingText = "Test"
    if waitingText:
        labelText = "No Waiting: " + waitingText
        labelText = waitingText
        return labelText

    return None

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getLoadingRestrictionLabelText(feature, parent):
	# Returns the text to label the feature

    #QgsMessageLog.logMessage("In getLoadingRestrictionLabelText:", tag="TOMs panel")

    try:
        waitingText, loadingText = generateGeometryUtils.getWaitingLoadingRestrictionLabelText(feature)

    except:
        QgsMessageLog.logMessage('getLoadingRestrictionLabelText', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getLoadingRestrictionLabelText: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")

        """QgsMessageLog.logMessage(
        "In getLoadingRestrictionLabelText ****:" + " Waiting: " + str(waitingText) + " Loading: " + str(loadingText),
        tag="TOMs panel")"""

    if loadingText:
        #labelText = "No Loading: " + loadingText
        labelText = loadingText

        #QgsMessageLog.logMessage("In getLoadingRestrictionLabelText: passing " + str(labelText), tag="TOMs panel")
        return labelText

    return None

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getBayTimePeriodLabelText(feature, parent):
	# Returns the text to label the feature

    try:
        #QgsMessageLog.logMessage("In getBayTimePeriodLabelText:", tag="TOMs panel")

        maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)

    except:
        QgsMessageLog.logMessage('getBayTimePeriodLabelText', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getBayTimePeriodLabelText: error in expression function: ' + str(repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")

    #QgsMessageLog.logMessage("In getBayTimePeriodLabelText:" + str(timePeriodText), tag="TOMs panel")

    return timePeriodText

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getBayMaxStayLabelText(feature, parent):
	# Returns the text to label the feature

    try:
        #QgsMessageLog.logMessage("In getBayMaxStayLabelText:", tag="TOMs panel")

        maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)

    except:
        QgsMessageLog.logMessage('getBayMaxStayLabelText', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getBayMaxStayLabelText: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")

    #QgsMessageLog.logMessage("In getBayMaxStayLabelText: " + str(maxStayText), tag="TOMs panel")

    return maxStayText

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getBayNoReturnLabelText(feature, parent):
	# Returns the text to label the feature

    # QgsMessageLog.logMessage("In getBayNoReturnLabelText:", tag="TOMs panel")
    try:
        maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)
    except:
        QgsMessageLog.logMessage('getBayNoReturnLabelText', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getBayNoReturnLabelText: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")
    #QgsMessageLog.logMessage("In getBayNoReturnLabelText: " + str(noReturnText), tag="TOMs panel")

    return noReturnText

@qgsfunction(args='auto', group='TOMs2', usesgeometry=False, register=True)
def getBayLabelText(feature, parent):
	# Returns the text to label the feature

    QgsMessageLog.logMessage("In getBayLabelText:", tag="TOMs panel")
    try:
        maxStayText, noReturnText, timePeriodText = generateGeometryUtils.getBayRestrictionLabelText(feature)
    except:
        QgsMessageLog.logMessage('getBayLabelText', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getBayLabelText: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")

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

    #QgsMessageLog.logMessage("In getBayLabelText: " + str(labelText), tag="TOMs panel")

    return labelText

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getCPZ(feature, parent):
	# Returns the CPZ for the feature - or None

    #QgsMessageLog.logMessage("In getCPZ:", tag="TOMs panel")

    try:
        cpzNr, cpzWaitingTimeID = generateGeometryUtils.getCurrentCPZDetails(feature)
    except:
        QgsMessageLog.logMessage('getCPZ', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getCPZ: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")
    #QgsMessageLog.logMessage("In getCPZ: CPZ " + str(cpzNr), tag="TOMs panel")

    return cpzNr

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getPTA(feature, parent):
	# Returns the CPZ for the feature - or None

    #QgsMessageLog.logMessage("In getPTA:", tag="TOMs panel")
    try:
        ptaName, ptaMaxStayID, ptaNoReturnTimeID = generateGeometryUtils.getCurrentPTADetails(feature)
    except:
        QgsMessageLog.logMessage('getPTA', tag="TOMs panel")
        exc_type, exc_value, exc_traceback = sys.exc_info()
        QgsMessageLog.logMessage(
            'getPTA: error in expression function: ' + str(
                repr(traceback.extract_tb(exc_traceback))),
            tag="TOMs panel")

    #QgsMessageLog.logMessage("In getPTA: PTA " + str(ptaName), tag="TOMs panel")

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
        QgsMessageLog.logMessage("Considering function {}".format(func.name()), tag="TOMs panel")
        try:
            if func in toms_list:
                QgsExpression.unregisterFunction(func.name())
                #del toms_list[func.name()]
        except AttributeError:
            #qgis.toms_functions = dict()
            pass

        if QgsExpression.registerFunction(func):
            QgsMessageLog.logMessage("Registered expression function {}".format(func.name()), tag="TOMs panel")
            #qgis.toms_functions[func.name()] = func

    """for title in qgis.toms_functions:
        QgsMessageLog.logMessage("toms_functions function {}".format(title), tag="TOMs panel")

    for title2 in toms_list:
        QgsMessageLog.logMessage("toms_list function {}".format(title2.name()), tag="TOMs panel")"""

def unregisterFunctions():
    # Unload all the functions that we created.
    for func in functions:
        QgsExpression.unregisterFunction(func.name())
        QgsMessageLog.logMessage("Unregistered expression function {}".format(func.name()), tag="TOMs panel")
        #del qgis.toms_functions[func.name()]

    QgsExpression.cleanRegisteredFunctions()
