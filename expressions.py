"""

https://github.com/NathanW2/qgsexpressionsplus/blob/master/functions.py

Extra functions for QgsExpression
register=False in order to delay registring of functions before we load the plugin

*** TH: Using this code to move Expression functions into main code body

"""

#from qgis.utils import qgsfunction

from qgis.core import *
from qgis.gui import *
from qgis.utils import *
import math
from mapTools import RestrictionTypeUtils
import sys


""" ****************************** """


@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def generate_display_geometry(geometryID, restGeomType, AzimuthToCenterLine, offset, bayWidth, feature, parent):
    try:
        """QgsMessageLog.logMessage(
            "In generate_display_geometry: New restriction .................................................................... ID: " + str(
                geometryID), tag="TOMs panel")"""

        res = RestrictionTypeUtils.getRestrictionGeometry(feature)
    except:
        QgsMessageLog.logMessage('generate_display_geometry error in expression function: {}'.format(sys.exc_info()[0]), tag="TOMs panel")

    return res


@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getAzimuthToRoadCentreLine(feature, parent):
	# find the shortest line from this point to the road centre line layer
	# http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/ - generates "closest feature" function

	#QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper):", tag="TOMs panel")

    return int(RestrictionTypeUtils.calculateAzimuthToRoadCentreLine(feature))


@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getRoadName(feature, parent):
	# Determine road name from the kerb line layer

    QgsMessageLog.logMessage("In getRoadName(helper):", tag="TOMs panel")

    newStreetName, newUSRN = RestrictionTypeUtils.determineRoadName(feature)

    return newStreetName


@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def getUSRN(feature, parent):
	# Determine road name from the kerb line layer

    QgsMessageLog.logMessage("In getUSRN(helper):", tag="TOMs panel")

    newStreetName, newUSRN = RestrictionTypeUtils.determineRoadName(feature)

    return newUSRN

@qgsfunction(args='auto', group='TOMs2', usesgeometry=True, register=True)
def generate_ZigZag(feature, parent):
	# Determine road name from the kerb line layer

    try:
        QgsMessageLog.logMessage(
            "In generate_ZigZag: New restriction .................................................................... ID: ", tag="TOMs panel")

        res = RestrictionTypeUtils.zigzag(feature, 2, 1)
    except:
        QgsMessageLog.logMessage('generate_ZigZag error in expression function: {}'.format(sys.exc_info()[0]), tag="TOMs panel")

    return res


functions = [
    getUSRN,
    getRoadName,
    getAzimuthToRoadCentreLine,
    generate_display_geometry
]

def registerFunctions():
    for func in functions:
        if QgsExpression.registerFunction(func):
            yield func.name()

def unregisterFunctions():
    # Unload all the functions that we created.
    for func in functions:
        QgsExpression.unregisterFunction(func.name())