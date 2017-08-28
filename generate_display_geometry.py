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
def generate_display_geometry(restTypeID, geomTypeID, AzimuthToCenterLine, offset, bayWidth, feature, parent):

	QgsMessageLog.logMessage("In generate_display_geometry: New restriction ....................................................................", tag="TOMs panel")

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

	lineList = [48, 49]
	bayList = [1, 2]

	#QgsMessageLog.logMessage("In generate_display_geometry: geomTypeID = " + str(geomTypeID) + " lineList_len = " + str(len(lineList)), tag="TOMs panel")
	#QgsMessageLog.logMessage("In generate_display_geometry: geomTypeID = " + str(geomTypeID) + " bayList_len = " + str(len(bayList)), tag="TOMs panel")

	# decide what type of feature we are dealing with - based on restTypeId and geomTypeID

	if restTypeID in lineList:
		restGeomType = 10
	elif restTypeID in bayList:
		restGeomType = geomTypeID
	else:
		pass
		# there will be more types to deal with, e.g., dropped kerbs, areas and (perhaps) cycle lanes
	QgsMessageLog.logMessage("In generate_display_geometry: geomTypeID = " + str(geomTypeID) + " restGeomType = " + str(restGeomType), tag="TOMs panel")

	# get access to the vertices. NB: lines/bays are multiPolyline

	geom = feature.geometry()

	if geom.type() == QGis.Line:

		lines = feature.geometry().asMultiPolyline()
		nrLines = len(lines)

		QgsMessageLog.logMessage("In generate_display_geometry: geomTypeID = " + str(geomTypeID) + " AzToCL: " + str(AzimuthToCenterLine) + "; geometry: " + feature.geometry().exportToWkt()  + " - NrLines = " + str(nrLines), tag="TOMs panel")

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

					QgsMessageLog.logMessage("In generate_display_geometry: A geomType = " + str(geomTypeID), tag="TOMs panel")

					# create start point(s)
					if restGeomType == 0:
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

			if restGeomType == 0:
				QgsMessageLog.logMessage("In generate_display_geometry: Now in geomType 0", tag="TOMs panel")
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

			else:
				QgsMessageLog.logMessage("In generate_display_geometry: No geomType choosen", tag="TOMs panel")

			# 	QgsMessageLog.logMessage("In generate_display_geometry: Turn: " + str(Turn), tag="TOMs panel")

				#Az = line[i].
				#QgsMessageLog.logMessage("In generate_display_geometry: Az = " + str(line[i].azimuth(line[i+1]), tag="TOMs panel")

				#for some reason, the len function is not returning the number of vertices

			QgsMessageLog.logMessage("In generate_display_geometry: idxLine = " + str(idxLine) + " len: " + str(len(ptsList)), tag="TOMs panel")

		QgsMessageLog.logMessage("In generate_display_geometry: end = " + str(nrLines), tag="TOMs panel")

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