"""
Define new functions using @qgsfunction. feature and parent must always be the
last args. Use args=-1 to pass a list of values as arguments
"""

from qgis.core import *
from qgis.gui import *
from qgis.utils import *

@qgsfunction(args='auto', group='Custom')
def generate_display_geometry(restrictionTypeID, AzimuthToCenterLine, feature, parent):

	geom = feature.geometry()

	"""
	Within expression areas use:  generate_display_geometry(  "RestrictionTypeID",  "AzimuthToRoadCentreLine")
		
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

	if geom.type() == QGis.Line:

		line = feature.geometry().asPolyline()
		n = len(line)

		QgsMessageLog.logMessage("In generate_display_geometry: restrictionType = " + str(restrictionTypeID) + " - vertices = " + str(n), tag="TOMs panel")

		""" for some reason, the len function is not returning the number of vertices """

	if restrictionTypeID == 'Bus Stand':
		pass

	""" loop through each point and calc the bearing from the previous one
	"""

	newGeometry = geom

	return newGeometry