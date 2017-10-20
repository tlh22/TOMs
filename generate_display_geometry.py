"""
Define new functions using @qgsfunction. feature and parent must always be the
last args. Use args=-1 to pass a list of values as arguments
"""

from qgis.core import *
from qgis.gui import *
from qgis.utils import *
import math

# https://gis.stackexchange.com/questions/95528/produce-line-from-components-length-and-angle?noredirect=1&lq=1
# direction cosines function

def cosdir_azim(azim):
	az = math.radians(azim)
	cosa = math.sin(az)
	cosb = math.cos(az)
	return cosa,cosb

def turnToCL (Az1, Az2):
	# function to determine direction of turn to road centre    *** need to be checked carefully ***
	# Az1 = Az of current line; Az2 = Az to roadCentreline
	#QgsMessageLog.logMessage("In turnToCL Az1 = " + str(Az1) + " Az2 = " + str(Az2), tag="TOMs panel")

	AzCL = Az1 - 90.0
	if AzCL < 0:
		AzCL = AzCL + 360.0

	#QgsMessageLog.logMessage("In turnToCL AzCL = " + str(AzCL), tag="TOMs panel")

	# Need to check quadrant

	if AzCL >= 0.0 and AzCL <= 90.0:
		if Az2 >= 270.0 and Az2 <= 359.999:
			AzCL = AzCL + 360
	elif Az2 >=0 and Az2 <= 90:
		if AzCL >= 270.0 and AzCL <= 359.999:
			Az2 = Az2 + 360

	g = abs(float(AzCL) - float(Az2))

	#QgsMessageLog.logMessage("In turnToCL Diff = " + str(g), tag="TOMs panel")

	if g < 90:
	    Turn = -90
	else:
		Turn = 90

	#QgsMessageLog.logMessage("In turnToCL Turn = " + str(Turn), tag="TOMs panel")

	return Turn

def calcBisector(prevAz, currAz, Turn, WidthRest):
	# function to return Az of bisector

	#QgsMessageLog.logMessage("In calcBisector", tag="TOMs panel")
	#QgsMessageLog.logMessage("In calcBisector: prevAz: " + str(prevAz) + " currAz: " + str(currAz), tag="TOMs panel")

	prevAzA = checkDegrees(prevAz + float(Turn))
	currAzA = checkDegrees(currAz + float(Turn))

	#QgsMessageLog.logMessage("In calcBisector: prevAzA: " + str(prevAzA) + " currAz: " + str(currAzA), tag="TOMs panel")

	"""
	if prevAz > 180:
		revPrevAz = prevAz - float(180)
	else:
		revPrevAz = prevAz + float(180)
	"""

	#QgsMessageLog.logMessage("In calcBisector: revPrevAz: " + str(revPrevAz), tag="TOMs panel")

	diffAz = checkDegrees(prevAzA - currAzA)

	#QgsMessageLog.logMessage("In calcBisector: diffAz: " + str(diffAz), tag="TOMs panel")

	diffAngle = diffAz / float(2)
	bisectAz = prevAzA - diffAngle

	diffAngle_rad = math.radians(diffAngle)
	#QgsMessageLog.logMessage("In calcBisector: diffAngle_rad: " + str(diffAngle_rad), tag="TOMs panel")
	distToPt = float(WidthRest) / math.cos(diffAngle_rad)

	#QgsMessageLog.logMessage("In generate_display_geometry: bisectAz: " + str(bisectAz) + " distToPt:" + str(distToPt), tag="TOMs panel")

	return bisectAz, distToPt

def checkDegrees(Az):

	newAz = Az

	if Az >= float(360):
		newAz = Az - float(360)
	elif Az < float(0):
		newAz = Az + float(360)

	#QgsMessageLog.logMessage("In checkDegrees: newAz: " + str(newAz), tag="TOMs panel")

	return newAz

def findFeatureAt2(feature, layerPt, layer, tolerance):
    # def findFeatureAt(self, pos, excludeFeature=None):
    """ Find the feature close to the given position.

        'layerPt' is the position to check, in layer coordinates.
        'layer' is specified layer
        'tolerance' is search distance in layer units

        If no feature is close to the given coordinate, we return None.
    """

    QgsMessageLog.logMessage("In findFeatureAt2. Incoming layer: " + str(layer), tag="TOMs panel")

    searchRect = QgsRectangle(layerPt.x() - tolerance,
                              layerPt.y() - tolerance,
                              layerPt.x() + tolerance,
                              layerPt.y() + tolerance)

    request = QgsFeatureRequest()
    request.setFilterRect(searchRect)
    request.setFlags(QgsFeatureRequest.ExactIntersect)

    for feature in layer.getFeatures(request):
        QgsMessageLog.logMessage("In findFeatureAt2. feature found", tag="TOMs panel")
        return feature  # Return first matching feature.

    return None

