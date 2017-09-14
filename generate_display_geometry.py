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
	QgsMessageLog.logMessage("In calcBisector: prevAz: " + str(prevAz) + " currAz: " + str(currAz), tag="TOMs panel")

	prevAzA = checkDegrees(prevAz + float(Turn))
	currAzA = checkDegrees(currAz + float(Turn))

	QgsMessageLog.logMessage("In calcBisector: prevAzA: " + str(prevAzA) + " currAz: " + str(currAzA), tag="TOMs panel")

	"""
	if prevAz > 180:
		revPrevAz = prevAz - float(180)
	else:
		revPrevAz = prevAz + float(180)
	"""

	#QgsMessageLog.logMessage("In calcBisector: revPrevAz: " + str(revPrevAz), tag="TOMs panel")

	diffAz = checkDegrees(prevAzA - currAzA)

	QgsMessageLog.logMessage("In calcBisector: diffAz: " + str(diffAz), tag="TOMs panel")

	diffAngle = diffAz / float(2)
	bisectAz = prevAzA - diffAngle

	diffAngle_rad = math.radians(diffAngle)
	QgsMessageLog.logMessage("In calcBisector: diffAngle_rad: " + str(diffAngle_rad), tag="TOMs panel")
	distToPt = float(WidthRest) / math.cos(diffAngle_rad)

	QgsMessageLog.logMessage("In generate_display_geometry: bisectAz: " + str(bisectAz) + " distToPt:" + str(distToPt), tag="TOMs panel")

	return bisectAz, distToPt

def checkDegrees(Az):

	newAz = Az

	if Az >= float(360):
		newAz = Az - float(360)
	elif Az < float(0):
		newAz = Az + float(360)

	QgsMessageLog.logMessage("In checkDegrees: newAz: " + str(newAz), tag="TOMs panel")

	return newAz

""" ****************************** """

@qgsfunction(args='auto', group='Custom')
def generate_display_geometry(geometryID, restGeomType, AzimuthToCenterLine, offset, bayWidth, feature, parent):

	QgsMessageLog.logMessage("In generate_display_geometry: New restriction .................................................................... ID: " + str(geometryID), tag="TOMs panel")

	"""
	Within expression areas use:    generate_display_geometry(   "RestrictionTypeID" , "GeomTypeID",  "AzimuthToRoadCentreLine",  @BayOffsetFromKerb ,  @BayWidth )
		
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

	# set up lists containing different restriction types

	# decide what type of feature we are dealing with - based on restTypeId and geomTypeID

		# there will be more types to deal with, e.g., dropped kerbs, areas and (perhaps) cycle lanes
	QgsMessageLog.logMessage("In generate_display_geometry:  restGeomType = " + str(restGeomType), tag="TOMs panel")

	# get access to the vertices. NB: lines/bays are multiPolyline

	geom = feature.geometry()

	if geom.type() == QGis.Line:

		lines = feature.geometry().asMultiPolyline()
		nrLines = len(lines)

		QgsMessageLog.logMessage("In generate_display_geometry: restGeomType = " + str(restGeomType) + " AzToCL: " + str(AzimuthToCenterLine) + "; geometry: " + feature.geometry().exportToWkt()  + " - NrLines = " + str(nrLines), tag="TOMs panel")

		for idxLine in range(nrLines):
			line = lines[idxLine]
			QgsMessageLog.logMessage("In generate_display_geometry: idxLine = " + str(idxLine) + " len: " + str(len(line)), tag="TOMs panel")

			ptsList = []
			nextAz = 0

			# now loop through each of the vertices and process as required. New geometry points are added to ptsList

			for i in range(len(line)-1):

				QgsMessageLog.logMessage("In generate_display_geometry: i = " + str(i), tag="TOMs panel")

				Az = line[i].azimuth(line[i+1])

				QgsMessageLog.logMessage("In generate_display_geometry: geometry: " + str(line[i].x()) + " " + str(line[i+1].x()) + " " + str(Az), tag="TOMs panel")

				# if this is the first point

				if i == 0:
					# determine which way to turn towards CL
					QgsMessageLog.logMessage("In generate_display_geometry: considering first point", tag="TOMs panel")

					Turn = turnToCL(Az, AzimuthToCenterLine)

					QgsMessageLog.logMessage("In generate_display_geometry: A geomType = " + str(restGeomType), tag="TOMs panel")

					# create start point(s)
					if restGeomType == 1:   # 1 = Parallel (bay)
						QgsMessageLog.logMessage("In generate_display_geometry: Now in geomType 0", tag="TOMs panel")
						# standard bay
						newAz = Az + Turn
						QgsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), tag="TOMs panel")
						cosa, cosb = cosdir_azim(newAz)

						#QgsMessageLog.logMessage("In generate_display_geometry: cosa : " + str(cosa) + " " + str(cosb), tag="TOMs panel")

						#dx = float(offset) * cosa
						#dy = float(offset) * cosb

						#QgsMessageLog.logMessage("In generate_display_geometry: dx: " + str(dx) + " dy: " + str(dy), tag="TOMs panel")

						ptsList.append(QgsPoint(line[i].x()+(float(offset)*cosa), line[i].y()+(float(offset)*cosb)))
						QgsMessageLog.logMessage("In geomType: added point 1 ", tag="TOMs panel")

						# set "extent of shape". In this case, it is the bay width
						shpExtent = bayWidth

						ptsList.append(QgsPoint(line[i].x() + (float(shpExtent) * cosa), line[i].y() + (float(shpExtent) * cosb)))
						QgsMessageLog.logMessage("In geomType: added point 2 ", tag="TOMs panel")

						#ptsList.append(newPoint)
						#QgsMessageLog.logMessage("In geomType: after append ", tag="TOMs panel")

						#ptsList.append(QgsPoint(line[i].x()+(float(bayWidth)*cosa), line[i].y()+(float(bayWidth)*cosb)))

					elif restGeomType == 2:
						pass
					elif restGeomType == 3:
						pass
					elif restGeomType == 4:
						pass
					elif restGeomType == 10:

						# standard line
						newAz = Az + Turn
						QgsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), tag="TOMs panel")
						cosa, cosb = cosdir_azim(newAz)

						#QgsMessageLog.logMessage("In generate_display_geometry: cosa : " + str(cosa) + " " + str(cosb), tag="TOMs panel")

						#dx = float(offset) * cosa
						#dy = float(offset) * cosb

						#QgsMessageLog.logMessage("In generate_display_geometry: dx: " + str(dx) + " dy: " + str(dy), tag="TOMs panel")

						ptsList.append(QgsPoint(line[i].x()+(float(offset)*cosa), line[i].y()+(float(offset)*cosb)))
						QgsMessageLog.logMessage("In geomType: added point 1 ", tag="TOMs panel")

						# set "extent of shape". In this case, it is the offset
						shpExtent = offset

					elif restGeomType == 11:
						pass

					else:
						QgsMessageLog.logMessage("In generate_display_geometry: No geomType choosen", tag="TOMs panel")

				else:

					# now pass along the feature

					QgsMessageLog.logMessage("In generate_display_geometry: considering point: " + str(i), tag="TOMs panel")

					# need to work out half of bisected angle

					QgsMessageLog.logMessage("In generate_display_geometry: prevAz: " + str(prevAz) + " currAz: " + str(Az), tag="TOMs panel")

					newAz, distWidth = calcBisector(prevAz, Az, Turn, shpExtent)

					cosa, cosb = cosdir_azim(newAz)
					ptsList.append(QgsPoint(line[i].x() + (float(distWidth) * cosa), line[i].y() + (float(distWidth) * cosb)))

					QgsMessageLog.logMessage("In generate_display_geometry: point appended", tag="TOMs panel")

				prevAz = Az

				#QgsMessageLog.logMessage("In generate_display_geometry: newPoint 1: " + str(ptsList[1].x()) + " " + str(ptsList[1].y()), tag="TOMs panel")

			# have reached the end of the feature. Now need to deal with last point.
			# Use Azimuth from last segment but change the points

			QgsMessageLog.logMessage("In generate_display_geometry: feature processed. Now at last point ", tag="TOMs panel")

			if restGeomType == 1:
				QgsMessageLog.logMessage("In generate_display_geometry: Now in geomType 1", tag="TOMs panel")
				# standard bay
				newAz = Az + Turn
				QgsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), tag="TOMs panel")
				cosa, cosb = cosdir_azim(newAz)

				ptsList.append(QgsPoint(line[len(line)-1].x() + (float(shpExtent) * cosa), line[len(line)-1].y() + (float(shpExtent) * cosb)))

				# add end point
				ptsList.append(QgsPoint(line[len(line)-1].x() + (float(offset) * cosa), line[len(line)-1].y() + (float(offset) * cosb)))

			elif restGeomType == 2:
				pass
			elif restGeomType == 3:
				pass
			elif restGeomType == 4:
				pass
			elif restGeomType == 10:

				QgsMessageLog.logMessage("In generate_display_geometry: Now in geomType 10", tag="TOMs panel")
				# standard line
				newAz = Az + Turn
				QgsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), tag="TOMs panel")
				cosa, cosb = cosdir_azim(newAz)
				# add end point
				ptsList.append(QgsPoint(line[len(line)-1].x() + (float(offset) * cosa), line[len(line)-1].y() + (float(offset) * cosb)))

			elif restGeomType == 11:
				pass

			else:
				QgsMessageLog.logMessage("In generate_display_geometry: No geomType choosen", tag="TOMs panel")

			# 	QgsMessageLog.logMessage("In generate_display_geometry: Turn: " + str(Turn), tag="TOMs panel")

				#Az = line[i].
				#QgsMessageLog.logMessage("In generate_display_geometry: Az = " + str(line[i].azimuth(line[i+1]), tag="TOMs panel")

				#for some reason, the len function is not returning the number of vertices

			QgsMessageLog.logMessage("In generate_display_geometry: idxLine = " + str(idxLine) + " len: " + str(len(ptsList)), tag="TOMs panel")

		QgsMessageLog.logMessage("In generate_display_geometry: end = " + str(nrLines), tag="TOMs panel")

	else:
		QgsMessageLog.logMessage("In generate_display_geometry: Not line type", tag="TOMs panel")
	"""
	if restrictionTypeID == 'Bus Stand':
		pass
	"""

	""" loop through each point and calc the bearing from the previous one
	"""

	newLine = QgsGeometry.fromPolyline(ptsList)

	QgsMessageLog.logMessage("In generate_display_geometry: line created", tag="TOMs panel")

	# newGeometry = newLine

	QgsMessageLog.logMessage("In generate_display_geometry:  newGeometry ********: " + newLine.exportToWkt(), tag="TOMs panel")

	return newLine


def getNextLineFromPolyline(feature, lineNr):
	# function to obtain line from multiPolyline feature
	geom = feature.geometry()

	if geom.type() == QGis.Line:

		lines = feature.geometry().asMultiPolyline()
		nrLines = len(lines)

		QgsMessageLog.logMessage("In generate_display_geometry: geomTypeID = " + str(restGeomType) + " AzToCL: " + str(
			AzimuthToCenterLine) + "; geometry: " + feature.geometry().exportToWkt() + " - NrLines = " + str(nrLines),
								 tag="TOMs panel")

		for idxLine in range(nrLines):
			if idxLines == lineNr:
				line = lines[idxLine]
				QgsMessageLog.logMessage(
				"In generate_display_geometry: idxLine = " + str(idxLine) + " len: " + str(len(line)), tag="TOMs panel")
				return line

	pass

@qgsfunction(args='auto', group='Custom', usesgeometry=True)
def getAzimuthToRoadCentreLine(feature, parent):
	# find the shortest line from this point to the road centre line layer
	# http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/ - generates "closest feature" function

	QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper):", tag="TOMs panel")

	RoadCentreLineLayer = QgsMapLayerRegistry.instance().mapLayersByName("RoadCentreLine")[0]

	QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper): Layer defined", tag="TOMs panel")

	if feature.geometry():
		geom = feature.geometry()
	else:
		QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper): geometry not found", tag="TOMs panel")
		return 0

	if geom.type() == QGis.Line:

		QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper): considering line", tag="TOMs panel")

		lines = feature.geometry().asMultiPolyline()
		nrLines = len(lines)

		QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper):  geometry: " + feature.geometry().exportToWkt()  + " - NrLines = " + str(nrLines), tag="TOMs panel")

		for idxLine in range(nrLines):
			line = lines[idxLine]
			QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper): idxLine = " + str(idxLine) + " len: " + str(len(line)), tag="TOMs panel")

			# take the a point from the geometry
			#line = feature.geometry().asPolyline()

			testPt = line[1]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

			QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine: secondPt: " + str(testPt.x()), tag="TOMs panel")

			# Find all Road Centre Line features within a "reasonable" distance and then check each one to find the shortest distance

			tolerance_roadwidth = 25
			searchRect = QgsRectangle(testPt.x() - tolerance_roadwidth,
							   testPt.y() - tolerance_roadwidth,
							   testPt.x() + tolerance_roadwidth,
							   testPt.y() + tolerance_roadwidth)

			request = QgsFeatureRequest()
			request.setFilterRect(searchRect)
			request.setFlags(QgsFeatureRequest.ExactIntersect)

			shortestDistance = float("inf")
			featureFound = False

			# Loop through all features in the layer to find the closest feature
			for f in RoadCentreLineLayer.getFeatures(request):
			  dist = f.geometry().distance(QgsGeometry.fromPoint(testPt))
			  if dist < shortestDistance:
				 shortestDistance = dist
				 closestFeature = f
				 featureFound = True

			QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine: shortestDistance: " + str(shortestDistance),
							  tag="TOMs panel")

			if featureFound:
			  # now obtain the line between the testPt and the nearest feature
			  f_lineToCL = closestFeature.geometry().shortestLine(QgsGeometry.fromPoint(testPt))

			  # get the start point (we know the end point)
			  startPtV2 = f_lineToCL.geometry().startPoint()
			  startPt = QgsPoint()
			  startPt.setX(startPtV2.x())
			  startPt.setY(startPtV2.y())

			  QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine: startPoint: " + str(startPt.x()),
								 tag="TOMs panel")

			  Az = checkDegrees(testPt.azimuth(startPt))
			  QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine: Az: " + str(Az), tag="TOMs panel")

			  # now set the attribute
			  # feature.setAttribute("AzimuthToR", int(Az))
			  return Az
			else:
				return 0
	else:
		QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine: No line geometry found",
							  tag="TOMs panel")
		return 0
	pass

@qgsfunction(args='auto', group='Custom')
def getAzimuthTest(feature, parent):
	QgsMessageLog.logMessage("In getAzimuthTest(helper):", tag="TOMs panel")
	return 180

@qgsfunction(args='auto', group='Custom', usesgeometry=True)
def determineRoadName(feature, parent):
	# Determine road name from the kerb line layer

	QgsMessageLog.logMessage("In determineRoadName(helper):", tag="TOMs panel")

	RoadCasementLayer = QgsMapLayerRegistry.instance().mapLayersByName("rc_nsg_sideofstreet")[0]

	if feature.geometry():
		QgsMessageLog.logMessage("In determineRoadName(helper): geometry FOUND", tag="TOMs panel")
		geom = feature.geometry()
	else:
		QgsMessageLog.logMessage("In determineRoadName(helper): geometry not found", tag="TOMs panel")
		return None

	if geom.type() == QGis.Line:

		QgsMessageLog.logMessage("In determineRoadName(helper): considering line", tag="TOMs panel")

		lines = feature.geometry().asMultiPolyline()
		nrLines = len(lines)

		QgsMessageLog.logMessage("In determineRoadName(helper):  geometry: " + feature.geometry().exportToWkt()  + " - NrLines = " + str(nrLines), tag="TOMs panel")

		for idxLine in range(nrLines):

			line = lines[idxLine]
			QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper): idxLine = " + str(idxLine) + " len: " + str(len(line)), tag="TOMs panel")

			# take the first point from the geometry
			#line = feature.geometry().asPolyline()
			nrPts = len(line)
			QgsMessageLog.logMessage("In setRoadName: nrPts = " + str(nrPts), tag="TOMs panel")

			secondPt = line[1] # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

			QgsMessageLog.logMessage("In setRoadName: secondPt: " + str(secondPt.x()), tag="TOMs panel")

			# check for the feature within RoadCasement_NSG_StreetName layer
			tolerance_nearby = 1.0  # somehow need to have this (and layer names) as global variables

			nearestRC_feature = findFeatureAt2(feature, secondPt, RoadCasementLayer, tolerance_nearby)

			if nearestRC_feature:
				# QgsMessageLog.logMessage("In setRoadName: nearestRC_feature: " + nearestRC_feature.geometry().exportToWkt(), tag="TOMs panel")

				idx_Street_Descriptor = RoadCasementLayer.fieldNameIndex('Street_Descriptor')
				idx_USRN = RoadCasementLayer.fieldNameIndex('USRN')

				StreetName = nearestRC_feature.attributes()[idx_Street_Descriptor]
				USRN = nearestRC_feature.attributes()[idx_USRN]

				QgsMessageLog.logMessage("In setRoadName: StreetName: " + str(StreetName), tag="TOMs panel")

				return StreetName

			else:
				QgsMessageLog.logMessage("In setRoadName: No kerb nearby ", tag="TOMs panel")
				return None

	else:
		QgsMessageLog.logMessage("In determineRoadName: No line geometry found",
							  tag="TOMs panel")
		return None
	pass

@qgsfunction(args='auto', group='Custom', usesgeometry=True)
def determineUSRN(feature, parent):
	# Determine road name from the kerb line layer

	QgsMessageLog.logMessage("In determineRoadName(helper):", tag="TOMs panel")

	RoadCasementLayer = QgsMapLayerRegistry.instance().mapLayersByName("rc_nsg_sideofstreet")[0]

	if feature.geometry():
		QgsMessageLog.logMessage("In determineRoadName(helper): geometry FOUND", tag="TOMs panel")
		geom = feature.geometry()
	else:
		QgsMessageLog.logMessage("In determineRoadName(helper): geometry not found", tag="TOMs panel")
		return None

	if geom.type() == QGis.Line:

		QgsMessageLog.logMessage("In determineRoadName(helper): considering line", tag="TOMs panel")

		lines = feature.geometry().asMultiPolyline()
		nrLines = len(lines)

		QgsMessageLog.logMessage("In determineRoadName(helper):  geometry: " + feature.geometry().exportToWkt()  + " - NrLines = " + str(nrLines), tag="TOMs panel")

		for idxLine in range(nrLines):

			line = lines[idxLine]
			QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper): idxLine = " + str(idxLine) + " len: " + str(len(line)), tag="TOMs panel")

			# take the first point from the geometry
			#line = feature.geometry().asPolyline()
			nrPts = len(line)
			QgsMessageLog.logMessage("In setRoadName: nrPts = " + str(nrPts), tag="TOMs panel")

			secondPt = line[1] # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

			QgsMessageLog.logMessage("In setRoadName: secondPt: " + str(secondPt.x()), tag="TOMs panel")

			# check for the feature within RoadCasement_NSG_StreetName layer
			tolerance_nearby = 1.0  # somehow need to have this (and layer names) as global variables

			nearestRC_feature = findFeatureAt2(feature, secondPt, RoadCasementLayer, tolerance_nearby)

			if nearestRC_feature:
				# QgsMessageLog.logMessage("In setRoadName: nearestRC_feature: " + nearestRC_feature.geometry().exportToWkt(), tag="TOMs panel")

				idx_Street_Descriptor = RoadCasementLayer.fieldNameIndex('Street_Descriptor')
				idx_USRN = RoadCasementLayer.fieldNameIndex('USRN')

				StreetName = nearestRC_feature.attributes()[idx_Street_Descriptor]
				USRN = nearestRC_feature.attributes()[idx_USRN]

				QgsMessageLog.logMessage("In setRoadName: StreetName: " + str(StreetName), tag="TOMs panel")

				return USRN

			else:
				QgsMessageLog.logMessage("In setRoadName: No kerb nearby ", tag="TOMs panel")
				return None

	else:
		QgsMessageLog.logMessage("In determineRoadName: No line geometry found",
							  tag="TOMs panel")
		return None
	pass


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

	pass