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

from qgis.core import *
from qgis.gui import *
from qgis.utils import *
import math
from generateGeometryUtils import generateGeometryUtils
import sys


""" ****************************** """


@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def generate_display_geometry(geometryID, restGeomType, AzimuthToCenterLine, offset, bayWidth, feature, parent):
    try:
        """QgsMessageLog.logMessage(
            "In generate_display_geometry: New restriction .................................................................... ID: " + str(
                geometryID), tag="TOMs panel")"""

        res = generateGeometryUtils.getRestrictionGeometry(feature)
    except:
        QgsMessageLog.logMessage('generate_display_geometry error in expression function: {}'.format(sys.exc_info()[0]), tag="TOMs panel")

    return res


@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getAzimuthToRoadCentreLine(feature, parent):
	# find the shortest line from this point to the road centre line layer
	# http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/ - generates "closest feature" function

	#QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper):", tag="TOMs panel")

    return int(generateGeometryUtils.calculateAzimuthToRoadCentreLine(feature))


@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getRoadName(feature, parent):
	# Determine road name from the kerb line layer

    QgsMessageLog.logMessage("In getRoadName(helper):", tag="TOMs panel")

    newStreetName, newUSRN = generateGeometryUtils.determineRoadName(feature)

    return newStreetName


@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getUSRN(feature, parent):
	# Determine road name from the kerb line layer

    QgsMessageLog.logMessage("In getUSRN(helper):", tag="TOMs panel")

    newStreetName, newUSRN = generateGeometryUtils.determineRoadName(feature)

    return newUSRN

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def generate_ZigZag(feature, parent):
	# Determine road name from the kerb line layer

    try:
        QgsMessageLog.logMessage(
            "In generate_ZigZag: New restriction .................................................................... ID: ", tag="TOMs panel")

        res = generateGeometryUtils.zigzag(feature, 2, 1)
    except:
        QgsMessageLog.logMessage('generate_ZigZag error in expression function: {}'.format(sys.exc_info()[0]), tag="TOMs panel")

    return res


functions = [
    generate_display_geometry,
    getAzimuthToRoadCentreLine,
    getRoadName,
    getUSRN,
    generate_ZigZag
]

def registerFunctions():

    for func in functions:
        QgsMessageLog.logMessage("Considering function {}".format(func.name()), tag="TOMs panel")
        try:
            if func.name() in qgis.toms_functions:
                QgsExpression.unregisterFunction(func.name())
                del qgis.toms_functions[func.name()]
        except AttributeError:
            qgis.toms_functions = dict()

        if QgsExpression.registerFunction(func):
            QgsMessageLog.logMessage("Registered expression function {}".format(func.name()), tag="TOMs panel")
            qgis.toms_functions[func.name()] = func

def unregisterFunctions():
    # Unload all the functions that we created.
    for func in functions:
        QgsExpression.unregisterFunction(func.name())
        QgsMessageLog.logMessage("Unregistered expression function {}".format(func.name()), tag="TOMs panel")
        del qgis.toms_functions[func.name()]

    QgsExpression.cleanRegisteredFunctions()
