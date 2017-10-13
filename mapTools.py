""" mapTools.py

    # Taken from Erik Westra's book


    This module defines the various QgsMapTool subclasses used by the
    "ForestTrails" application.
"""
import math
import time

from qgis.core import *
from qgis.gui import *
from PyQt4.QtGui import *
from PyQt4.QtCore import *
from qgis.utils import iface
#from qgis.gui import QgsMapToolCapture
from core.restrictionmanager import *
from cmath import rect, phase
import numpy as np

#from constants import *

#############################################################################

class MapToolMixin:
    """ Mixin class that defines various helper methods for a QgsMapTool.
    """
    def setLayer(self, layer):
        self.layer        = layer
        self.lastPlayTime = None

    def transformCoordinates(self, screenPt):
        """ Convert a screen coordinate to map and layer coordinates.

            returns a (mapPt,layerPt) tuple.
        """
        return (self.toMapCoordinates(screenPt))

    def calcTolerance(self, pos):
        """ Calculate the "tolerance" to use for a mouse-click.

            'pos' is a QPoint object representing the clicked-on point, in
            canvas coordinates.

            The tolerance is the number of map units away from the click
            position that a vertex or geometry can be and we still consider it
            to be a click on that vertex or geometry.
        """
        pt1 = QPoint(pos.x(), pos.y())
        pt2 = QPoint(pos.x() + 10, pos.y())

        mapPt1 = self.transformCoordinates(pt1)
        mapPt2 = self.transformCoordinates(pt2)
        tolerance = mapPt2.x() - mapPt1.x()

        return tolerance

    def findNearestFeatureAt(self, pos):
        #  def findFeatureAt(self, pos, excludeFeature=None):
        # http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/ - generates "closest feature" function

        """ Find the feature close to the given position.

            'pos' is the position to check, in canvas coordinates.

            if 'excludeFeature' is specified, we ignore this feature when
            finding the clicked-on feature.

            If no feature is close to the given coordinate, we return None.
        """
        mapPt = self.transformCoordinates(pos)
        #tolerance = self.calcTolerance(pos)
        tolerance = 0.5
        searchRect = QgsRectangle(mapPt.x() - tolerance,
                                  mapPt.y() - tolerance,
                                  mapPt.x() + tolerance,
                                  mapPt.y() + tolerance)

        request = QgsFeatureRequest()
        request.setFilterRect(searchRect)
        request.setFlags(QgsFeatureRequest.ExactIntersect)

        '''for feature in self.layer.getFeatures(request):
            if excludeFeature != None:
                if feature.id() == excludeFeature.id():
                    continue
            return feature '''

        self.RestrictionLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        #currLayer = self.TOMslayer  # need to loop through the layers and choose closest to click point
        #iface.setActiveLayer(currLayer)

        shortestDistance = float("inf")

        for layerDetails in self.RestrictionLayers.getFeatures():

            self.currLayer = RestrictionTypeUtils.getRestrictionsLayer (layerDetails)

            # Loop through all features in the layer to find the closest feature
            for f in self.currLayer.getFeatures(request):
                dist = f.geometry().distance(QgsGeometry.fromPoint(mapPt))
                if dist < shortestDistance:
                    shortestDistance = dist
                    closestFeature = f
                    closestLayer = self.currLayer

        # QgsMessageLog.logMessage("In findNearestFeatureAt: shortestDistance: " + str(shortestDistance), tag="TOMs panel")

        if shortestDistance < float("inf"):
            return closestFeature, closestLayer
        else:
            return None, None

        pass

    def findVertexAt(self, feature, pos):
        """ Find the vertex of the given feature close to the given position.

            'feature' is the QgsFeature to check, and 'pos' is the position to
            check, in canvas coordinates.

            We return the vertex number for the closest vertex, or None if no
            vertex is close enough to the given click position.
        """
        mapPt,layerPt = self.transformCoordinates(pos)
        tolerance     = self.calcTolerance(pos)

        vertexCoord,vertex,prevVertex,nextVertex,distSquared = \
            feature.geometry().closestVertex(layerPt)

        distance = math.sqrt(distSquared)
        if distance > tolerance:
            return None
        else:
            return vertex

    def snapToNearestVertex(self, pos, trackLayer, excludeFeature=None):
        """ Attempt to snap the given point to the nearest vertex.

            The parameters are as follows:

                'pos'

                    The click position, in canvas coordinates.

                'trackLayer'

                    The QgsVectorLayer which holds our track data.

                'excludeFeature'

                    If specified, this is a QgsFeature which will be excluded
                    from the check for nearby vertices.  This is used to
                    prevent snapping an object to itself.

            If the click position is close enough to a vertex in the track
            layer (excluding the given feature, if any), we return the
            coordinates of that vertex.  Otherwise, we return the click
            position itself in layer coordinates.  Either way, the returned
            point is in the map tool's layer's coordinates.
        """
        mapPt,layerPt = self.transformCoordinates(pos)
        feature = self.findFeatureAt(pos, excludeFeature)

        if feature == None:
            return layerPt

        vertex = self.findVertexAt(feature, pos)
        if vertex == None:
            return layerPt

        return feature.geometry().vertexAt(vertex)

#############################################################################

class GeometryInfoMapTool(QgsMapToolIdentify, MapToolMixin):

    # Modified from Erik Westra's book to deal specifically with restrictions

    def __init__(self, iface):
        QgsMapToolIdentify.__init__(self, iface.mapCanvas())
        self.iface = iface
        #self.restrictionManager = restrictionManager  ??? how to include ???
        #self.layer = layer
        #self.onDisplayRestrictionDetails = onDisplayRestrictionDetails
        self.setCursor(Qt.WhatsThisCursor)
        # self.setCursor(Qt.ArrowCursor)

    def canvasReleaseEvent(self, event):
        # Return point under cursor

        closestFeature, closestLayer = self.findNearestFeatureAt(event.pos())

        QgsMessageLog.logMessage(("In Info - canvasReleaseEvent."), tag="TOMs panel")

        if closestFeature == None:
            return

        QgsMessageLog.logMessage(("In Info - canvasReleaseEvent. Feature selected from layer: " + closestLayer.name()), tag="TOMs panel")

        # Need to chec
        closestLayer.startEditing()

        self.iface.openFeatureForm(closestLayer, closestFeature)
        #self.onDisplayRestrictionDetails(feature, self.layer)

#############################################################################

class CreateRestrictionTool(QgsMapToolCapture):
    # helpful link - http://apprize.info/python/qgis/7.html ??
    def __init__(self, iface, layer, onCreateRestriction):

        QgsMessageLog.logMessage(("In Create - init."), tag="TOMs panel")

        QgsMapToolCapture.__init__(self, iface.mapCanvas(), iface.cadDockWidget())
        #https: // qgis.org / api / classQgsMapToolCapture.html
        canvas = iface.mapCanvas()
        self.iface = iface

        # I guess at this point, it is possible to set things like capture mode, snapping preferences, ... (not sure of all the elements that are required)
        # capture mode (... not sure if this has already been set? - or how to set it)
        self.setMode(CreateRestrictionTool.CaptureLine)

        # Seems that this is important - or at least to create a point list that is used later to create Geometry
        self.sketchPoints = self.points()
        #self.setPoints(self.sketchPoints)  ... not sure when to use this ??

        # Set up rubber band. In current implementation, it is not showing feeback for "next" location

        self.rb = self.createRubberBand(QGis.Line)

        self.layer = layer

        self.currLayer = self.currentVectorLayer()

        QgsMessageLog.logMessage(("In Create - init. Curr layer is " + str(self.currLayer.name()) + "Incoming: " + str(self.layer)), tag="TOMs panel")

        # set up snapping configuration   *******************
        """
        TOMs_Layer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]

        ConstructionLines = QgsMapLayerRegistry.instance().mapLayersByName("ConstructionLines")[0]

        snapping_layer1 = QgsSnappingUtils.LayerConfig(TOMs_Layer, QgsPointLocator.Vertex, 0.5,
                                                       QgsTolerance.LayerUnits)
        snapping_layer2 = QgsSnappingUtils.LayerConfig(RoadCasementLayer, QgsPointLocator.Vertex and QgsPointLocator.Edge, 0.5,
                                                       QgsTolerance.LayerUnits)
        snapping_layer3 = QgsSnappingUtils.LayerConfig(ConstructionLines, QgsPointLocator.Vertex and QgsPointLocator.Edge, 0.5,
                                                       QgsTolerance.LayerUnits)
        """
        self.snappingUtils = QgsSnappingUtils()

        #self.snappingUtils.setLayers([snapping_layer1, snapping_layer2, snapping_layer3])

        self.snappingUtils.setSnapToMapMode(QgsSnappingUtils.SnapAdvanced)

        # set up tracing configuration

        RoadCasementLayer = QgsMapLayerRegistry.instance().mapLayersByName("rc_nsg_sideofstreet")[0]

        # set up function to be called when capture is complete
        self.onCreateRestriction = onCreateRestriction

    def cadCanvasReleaseEvent(self, event):
        QgsMapToolCapture.cadCanvasReleaseEvent(self, event)
        QgsMessageLog.logMessage(("In Create - cadCanvasReleaseEvent"), tag="TOMs panel")
        if event.button() == Qt.LeftButton:
            if not self.isCapturing():
                self.startCapturing()
            #self.result = self.addVertex(self.toMapCoordinates(event.pos()))
            checkSnapping = event.isSnapped
            QgsMessageLog.logMessage("In Create - cadCanvasReleaseEvent: checkSnapping = " + str(checkSnapping), tag="TOMs panel")

            """tolerance_nearby = 0.5
            tolerance = tolerance_nearby

            searchRect = QgsRectangle(self.currPoint.x() - tolerance,
                                      self.currPoint.y() - tolerance,
                                      self.currPoint.x() + tolerance,
                                      self.currPoint.y() + tolerance)"""

            #locator = self.snappingUtils.snapToMap(self.currPoint)

            # Now wanting to add point(s) to new shape. Take account of snapping and tracing
            # self.toLayerCoordinates(self.layer, event.pos())
            self.currPoint = event.snapPoint(1)    #  1 is value of QgsMapMouseEvent.SnappingMode (not sure where this is defined)
            self.lastEvent = event
            # If this is the first point, add and k
            self.result = self.addVertex(self.currPoint)

            QgsMessageLog.logMessage(("In Create - cadCanvasReleaseEvent (AddVertex) Result: " + str(self.result) + " X:" + str(self.currPoint.x()) + " Y:" + str(self.currPoint.y())), tag="TOMs panel")

        elif (event.button() == Qt.RightButton):
            # Stop capture when right button or escape key is pressed
            #points = self.getCapturedPoints()
            self.getPointsCaptured()

            # Need to think about the default action here if none of these buttons/keys are pressed.

    def keyPressEvent(self, event):
        if (event.key() == Qt.Key_Backspace) or (event.key() == Qt.Key_Delete):
            self.undo()
            pass
        if event.key() == Qt.Key_Return or event.key() == Qt.Key_Enter or (event.key() == Qt.Key_Escape):
            pass
            # Need to think about the default action here if none of these buttons/keys are pressed. 

    def getPointsCaptured(self):
        QgsMessageLog.logMessage(("In Create - getPointsCaptured"), tag="TOMs panel")

        # Check the number of points
        self.nrPoints = self.size()
        QgsMessageLog.logMessage(("In Create - getPointsCaptured; Stopping: " + str(self.nrPoints)),
                                 tag="TOMs panel")

        self.sketchPoints = self.points()

        for point in self.sketchPoints:
            QgsMessageLog.logMessage(("In Create - getPointsCaptured X:" + str(point.x()) + " Y: " + str(point.y())), tag="TOMs panel")

        # stop capture activity
        self.stopCapturing()

        if self.nrPoints > 0:

            # take points from the rubber band and copy them into the "feature"

            fields = self.layer.dataProvider().fields()
            feature = QgsFeature()
            feature.setFields(fields)

            feature.setGeometry(QgsGeometry.fromPolyline(self.sketchPoints))

            # Currently geometry is not being created correct. Might be worth checking co-ord values ...

            self.valid = feature.isValid()

            QgsMessageLog.logMessage(("In Create - getPointsCaptured; geome"
                                      "try prepared; validity" + str(self.valid)),
                                     tag="TOMs panel")

            # set any geometry related attributes ...

            RestrictionTypeUtils.setRoadName(feature)
            RestrictionTypeUtils.setAzimuthToRoadCentreLine(feature)

            # is there any other tidying to do ??

            self.layer.startEditing()
            self.iface.openFeatureForm(self.layer, feature)

#############################################################################

class RestrictionTypeUtils:
    # https://gis.stackexchange.com/questions/95528/produce-line-from-components-length-and-angle?noredirect=1&lq=1
    # direction cosines function

    @staticmethod
    def cosdir_azim(azim):
        az = math.radians(azim)
        cosa = math.sin(az)
        cosb = math.cos(az)
        return cosa, cosb

    def cosdir_azim_rad(az):
        #az = math.radians(azim)
        cosa = math.sin(az)
        cosb = math.cos(az)
        return cosa, cosb

    @staticmethod
    def turnToCL(Az1, Az2):
        # function to determine direction of turn to road centre    *** needs to be checked carefully ***
        # Az1 = Az of current line; Az2 = Az to roadCentreline
        #QgsMessageLog.logMessage("In turnToCL Az1 = " + str(Az1) + " Az2 = " + str(Az2), tag="TOMs panel")

        AzCL = Az1 - 90.0
        if AzCL < 0:
            AzCL = AzCL + 360.0

        # QgsMessageLog.logMessage("In turnToCL AzCL = " + str(AzCL), tag="TOMs panel")

        # Need to check quadrant

        if AzCL >= 0.0 and AzCL <= 90.0:
            if Az2 >= 270.0 and Az2 <= 359.999:
                AzCL = AzCL + 360
        elif Az2 >= 0 and Az2 <= 90:
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

    @staticmethod
    def calcBisector(prevAz, currAz, Turn, WidthRest):
        # function to return Az of bisector

        # QgsMessageLog.logMessage("In calcBisector", tag="TOMs panel")
        # QgsMessageLog.logMessage("In calcBisector: prevAz: " + str(prevAz) + " currAz: " + str(currAz), tag="TOMs panel")

        prevAzA = RestrictionTypeUtils.checkDegrees(prevAz + float(Turn))
        currAzA = RestrictionTypeUtils.checkDegrees(currAz + float(Turn))

        # QgsMessageLog.logMessage("In calcBisector: prevAzA: " + str(prevAzA) + " currAz: " + str(currAzA), tag="TOMs panel")

        """
        if prevAz > 180:
            revPrevAz = prevAz - float(180)
        else:
            revPrevAz = prevAz + float(180)
        """

        # QgsMessageLog.logMessage("In calcBisector: revPrevAz: " + str(revPrevAz), tag="TOMs panel")

        diffAz = RestrictionTypeUtils.checkDegrees(prevAzA - currAzA)

        # QgsMessageLog.logMessage("In calcBisector: diffAz: " + str(diffAz), tag="TOMs panel")

        diffAngle = diffAz / float(2)
        bisectAz = prevAzA - diffAngle

        diffAngle_rad = math.radians(diffAngle)
        # QgsMessageLog.logMessage("In calcBisector: diffAngle_rad: " + str(diffAngle_rad), tag="TOMs panel")
        distToPt = float(WidthRest) / math.cos(diffAngle_rad)

        # QgsMessageLog.logMessage("In generate_display_geometry: bisectAz: " + str(bisectAz) + " distToPt:" + str(distToPt), tag="TOMs panel")

        return bisectAz, distToPt

    @staticmethod
    def checkDegrees(Az):
        newAz = Az

        if Az >= float(360):
            newAz = Az - float(360)
        elif Az < float(0):
            newAz = Az + float(360)

        # QgsMessageLog.logMessage("In checkDegrees: newAz: " + str(newAz), tag="TOMs panel")

        return newAz

    @staticmethod
    def setRoadName(feature):

        newStreetName, newUSRN = RestrictionTypeUtils.determineRoadName(feature)
        # now set the attributes
        if newStreetName:
            feature.setAttribute("RoadName", newStreetName)
            feature.setAttribute("USRN", newUSRN)

        #feature.setAttribute("AzimuthToRoadCentreLine", int(RestrictionTypeUtils.calculateAzimuthToRoadCentreLine(feature)))

    @staticmethod
    def determineRoadName(feature):

        QgsMessageLog.logMessage("In setRoadName(helper):", tag="TOMs panel")

        RoadCasementLayer = QgsMapLayerRegistry.instance().mapLayersByName("rc_nsg_sideofstreet")[0]

        # take the first point from the geometry
        line = feature.geometry().asPolyline()
        nrPts = len(line)
        QgsMessageLog.logMessage("In setRoadName: {}".format(feature.geometry().exportToWkt()), tag="TOMs panel")

        secondPt = line[0]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

        QgsMessageLog.logMessage("In setRoadName: secondPt: " + str(secondPt.x()), tag="TOMs panel")

        # check for the feature within RoadCasement_NSG_StreetName layer
        tolerance_nearby = 1.0  # somehow need to have this (and layer names) as global variables

        nearestRC_feature = RestrictionTypeUtils.findFeatureAt2(feature, secondPt, RoadCasementLayer, tolerance_nearby)

        if nearestRC_feature:
            # QgsMessageLog.logMessage("In setRoadName: nearestRC_feature: " + nearestRC_feature.geometry().exportToWkt(), tag="TOMs panel")

            idx_Street_Descriptor = RoadCasementLayer.fieldNameIndex('Street_Descriptor')
            idx_USRN = RoadCasementLayer.fieldNameIndex('USRN')

            StreetName = nearestRC_feature.attributes()[idx_Street_Descriptor]
            USRN = nearestRC_feature.attributes()[idx_USRN]

            QgsMessageLog.logMessage("In setRoadName: StreetName: " + str(StreetName), tag="TOMs panel")

            return StreetName, USRN

        else:
            return None, None

        pass

    @staticmethod
    def setAzimuthToRoadCentreLine(feature):

        # now set the attribute
        feature.setAttribute("AzimuthToRoadCentreLine", int(RestrictionTypeUtils.calculateAzimuthToRoadCentreLine(feature)))

    @staticmethod
    def getLineForAz(feature):
        # gets a single "line" (array of points) from the current feature. Checks for:
        # - existence of geoemtry
        # - whether or not it is multi-part

        #QgsMessageLog.logMessage("In getLineForAz(helper):", tag="TOMs panel")

        geom = feature.geometry()
        #line = QgsGeometry()

        if geom:
            if geom.type() == QGis.Line:
                if geom.isMultipart():
                    lines = geom.asMultiPolyline()
                    nrLines = len(lines)

                    #QgsMessageLog.logMessage("In getLineForAz(helper):  geometry: " + feature.geometry().exportToWkt()  + " - NrLines = " + str(nrLines), tag="TOMs panel")

                    # take the first line as the one we are interested in
                    line = lines[0]
                    """for idxLine in range(nrLines):
                        line = lines[idxLine]"""

                else:
                    line = feature.geometry().asPolyline()

                # Now return the array
                return line

            else:
                #QgsMessageLog.logMessage("In getLineForAz(helper): Incorrect geometry found", tag="TOMs panel")
                return 0

        else:
            #QgsMessageLog.logMessage("In getLineForAz(helper): geometry not found", tag="TOMs panel")
            return 0

    @staticmethod
    def calculateAzimuthToRoadCentreLine(feature):
        # find the shortest line from this point to the road centre line layer
        # http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/ - generates "closest feature" function

        #QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper):", tag="TOMs panel")

        RoadCentreLineLayer = QgsMapLayerRegistry.instance().mapLayersByName("RoadCentreLine")[0]

        """if feature.geometry():
            geom = feature.geometry()
        else:
            QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper): geometry not found", tag="TOMs panel")
            return 0"""

        # take the a point from the geometry
        #line = feature.geometry().asPolyline()
        line = RestrictionTypeUtils.getLineForAz(feature)

        if len(line) == 0:
            return 0

        testPt = line[
            0]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

        #QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine: secondPt: " + str(testPt.x()), tag="TOMs panel")

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

        #QgsMessageLog.logMessage("In calculateAzimuthToRoadCentreLine: shortestDistance: " + str(shortestDistance), tag="TOMs panel")

        if featureFound:
            # now obtain the line between the testPt and the nearest feature
            f_lineToCL = closestFeature.geometry().shortestLine(QgsGeometry.fromPoint(testPt))

            # get the start point (we know the end point)
            startPtV2 = f_lineToCL.geometry().startPoint()
            startPt = QgsPoint()
            startPt.setX(startPtV2.x())
            startPt.setY(startPtV2.y())

            QgsMessageLog.logMessage("In calculateAzimuthToRoadCentreLine: startPoint: " + str(startPt.x()),
                                     tag="TOMs panel")

            Az = RestrictionTypeUtils.checkDegrees(testPt.azimuth(startPt))
            #QgsMessageLog.logMessage("In calculateAzimuthToRoadCentreLine: Az: " + str(Az), tag="TOMs panel")

            return Az
        else:
            return 0

    @staticmethod
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

    @staticmethod
    def getRestrictionGeometry(feature):
        # Function to control creation of geometry for any restriction
        #QgsMessageLog.logMessage("In getRestrictionGeometry", tag="TOMs panel")

        bayWidth = float(QgsExpressionContextUtils.projectScope().variable('BayWidth'))
        #QgsMessageLog.logMessage("In getRestrictionGeometry - obtained bayWidth" + str(bayWidth), tag="TOMs panel")
        bayLength = float(QgsExpressionContextUtils.projectScope().variable("BayLength"))
        bayOffsetFromKerb = float(QgsExpressionContextUtils.projectScope().variable("BayOffsetFromKerb"))
        #QgsMessageLog.logMessage("In getRestrictionGeometry - obtained variables", tag="TOMs panel")

        restGeomType = feature.attribute("GeomShapeID")

        # set up parameters for different shapes

        orientation = 0

        if restGeomType == 1:  # 1 = Parallel (bay)
            offset = bayOffsetFromKerb
            shpExtent = bayWidth
        elif restGeomType == 2: # 2 = half on/half off
            offset = 0
            shpExtent = 0
        elif restGeomType == 3: # 3 = on pavement
            offset = 0
            shpExtent = 0
        elif restGeomType == 4: # 4 = Perpendicular
            offset = bayOffsetFromKerb
            shpExtent = bayLength
        elif restGeomType == 5: # 5 = Echelon
            offset = bayOffsetFromKerb
            shpExtent = bayLength
            orientation = feature.attribute("BayOrientation")
            if not orientation:
                orientation = 0
        elif restGeomType == 6:  # 6 = Perpendicular on pavement
            offset = 0
            shpExtent = 0
        elif restGeomType == 7:  # 6 = Other
            offset = 0
            shpExtent = 0
        elif restGeomType == 10: # 10 = Parallel (line)
            offset = bayOffsetFromKerb
            shpExtent = bayOffsetFromKerb
        elif restGeomType == 11: # 11 = Parallel (line) with loading
            offset = 0
            shpExtent = 0
        elif restGeomType == 12:  # 12 = Zig-Zag
            offset = bayOffsetFromKerb
            shpExtent = 0
            wavelength = 1
            amplitude = 0.1
        else:
            offset = 0
            shpExtent = 0

        # Now get the geometry

        #QgsMessageLog.logMessage("In getRestrictionGeometry - calling display", tag="TOMs panel")

        if restGeomType == 12:   # ZigZag
            outputGeometry =  RestrictionTypeUtils.zigzag(feature, wavelength, amplitude, restGeomType, offset, shpExtent, orientation)
        else:
            outputGeometry = RestrictionTypeUtils.getDisplayGeometry(feature, restGeomType, offset, shpExtent, orientation)

        return outputGeometry

    @staticmethod
    def getDisplayGeometry(feature, restGeomType, offset, shpExtent, orientation):
        # Obtain relevant variables
        #QgsMessageLog.logMessage("In getDisplayGeometry", tag="TOMs panel")

        # Need to check why the project variable function is not working

        geometryID = feature.attribute("GeometryID")
        QgsMessageLog.logMessage("In getDisplayGeometry: New restriction .................................................................... ID: " + str(geometryID), tag = "TOMs panel")
        #restGeomType = feature.attribute("GeomShapeID")
        AzimuthToCentreLine = float(feature.attribute("AzimuthToRoadCentreLine"))
        #QgsMessageLog.logMessage("In getDisplayGeometry: Az: " + str(AzimuthToCentreLine), tag = "TOMs panel")

        # Need to check feature class. If it is a bay, obtain the number
        #nrBays = feature.attribute("nrBays")

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

        line = RestrictionTypeUtils.getLineForAz(feature)

        #QgsMessageLog.logMessage("In getDisplayGeometry:  nr of pts = " + str(len(line)), tag="TOMs panel")

        if len(line) == 0:
            return 0

        # Now have a valid set of points

        #QgsMessageLog.logMessage("In getDisplayGeometry:  Now processing line", tag="TOMs panel")

        ptsList = []
        nextAz = 0
        diffEchelonAz = 0

        # now loop through each of the vertices and process as required. New geometry points are added to ptsList

        for i in range(len(line) - 1):

            #QgsMessageLog.logMessage("In getDisplayGeometry: i = " + str(i), tag="TOMs panel")

            Az = line[i].azimuth(line[i + 1])

            #QgsMessageLog.logMessage("In getDisplayGeometry: geometry: " + str(line[i].x()) + " " + str(line[i+1].x()) + " " + str(Az), tag="TOMs panel")

            # if this is the first point

            if i == 0:
                # determine which way to turn towards CL
                #QgsMessageLog.logMessage("In generate_display_geometry: considering first point", tag="TOMs panel")

                Turn = RestrictionTypeUtils.turnToCL(Az, AzimuthToCentreLine)

                newAz = Az + Turn
                #QgsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), tag="TOMs panel")
                cosa, cosb = RestrictionTypeUtils.cosdir_azim(newAz)

                #QgsMessageLog.logMessage("In generate_display_geometry: cosa : " + str(cosa) + " " + str(cosb), tag="TOMs panel")

                # dx = float(offset) * cosa
                # dy = float(offset) * cosb

                #QgsMessageLog.logMessage("In generate_display_geometry: dx: " + str(dx) + " dy: " + str(dy), tag="TOMs panel")

                ptsList.append(
                    QgsPoint(line[i].x() + (float(offset) * cosa), line[i].y() + (float(offset) * cosb)))
                #QgsMessageLog.logMessage("In geomType: added point 1 ", tag="TOMs panel")

                # Now add the point at the extent. If it is an echelon bay:
                #   a. calculate the difference between the first Az and the echelon Az (??), and
                #   b. adjust the angle
                #   c. *** also need to adjust the length *** Not yet implemented

                if restGeomType == 5:   # echelon
                    QgsMessageLog.logMessage("In geomType: orientation: " + str(orientation), tag="TOMs panel")
                    diffEchelonAz = RestrictionTypeUtils.checkDegrees(orientation - newAz)
                    newAz = Az + Turn + diffEchelonAz
                    cosa, cosb = RestrictionTypeUtils.cosdir_azim(newAz)
                    pass

                ptsList.append(
                    QgsPoint(line[i].x() + (float(shpExtent) * cosa),
                             line[i].y() + (float(shpExtent) * cosb)))
                #QgsMessageLog.logMessage("In geomType: added point 2 ", tag="TOMs panel")

                # ptsList.append(newPoint)
                # QgsMessageLog.logMessage("In geomType: after append ", tag="TOMs panel")

                # ptsList.append(QgsPoint(line[i].x()+(float(bayWidth)*cosa), line[i].y()+(float(bayWidth)*cosb)))

            else:

                # now pass along the feature

                #QgsMessageLog.logMessage("In generate_display_geometry: considering point: " + str(i), tag="TOMs panel")

                # need to work out half of bisected angle

                # QgsMessageLog.logMessage("In generate_display_geometry: prevAz: " + str(prevAz) + " currAz: " + str(Az), tag="TOMs panel")

                newAz, distWidth = RestrictionTypeUtils.calcBisector(prevAz, Az, Turn, shpExtent)

                cosa, cosb = RestrictionTypeUtils.cosdir_azim(newAz + diffEchelonAz)
                ptsList.append(
                    QgsPoint(line[i].x() + (float(distWidth) * cosa), line[i].y() + (float(distWidth) * cosb)))

            # QgsMessageLog.logMessage("In generate_display_geometry: point appended", tag="TOMs panel")

            prevAz = Az

        # QgsMessageLog.logMessage("In generate_display_geometry: newPoint 1: " + str(ptsList[1].x()) + " " + str(ptsList[1].y()), tag="TOMs panel")

        # have reached the end of the feature. Now need to deal with last point.
        # Use Azimuth from last segment but change the points

        #QgsMessageLog.logMessage("In generate_display_geometry: feature processed. Now at last point ", tag="TOMs panel")

        # QgsMessageLog.logMessage("In generate_display_geometry: Now in geomType 1", tag="TOMs panel")
        # standard bay
        newAz = Az + Turn + diffEchelonAz
        # QgsMessageLog.logMessage("In generate_display_geometry: newAz: " + str(newAz), tag="TOMs panel")
        cosa, cosb = RestrictionTypeUtils.cosdir_azim(newAz)

        ptsList.append(QgsPoint(line[len(line) - 1].x() + (float(shpExtent) * cosa),
                                line[len(line) - 1].y() + (float(shpExtent) * cosb)))

        # add end point (without any consideration of Echelon)

        newAz = Az + Turn
        cosa, cosb = RestrictionTypeUtils.cosdir_azim(newAz)

        ptsList.append(QgsPoint(line[len(line) - 1].x() + (float(offset) * cosa),
                                line[len(line) - 1].y() + (float(offset) * cosb)))

        newLine = QgsGeometry.fromPolyline(ptsList)

        #QgsMessageLog.logMessage("In generate_display_geometry: line created", tag="TOMs panel")

        # newGeometry = newLine

        #QgsMessageLog.logMessage("In generate_display_geometry:  newGeometry ********: " + newLine.exportToWkt(), tag="TOMs panel")

        return newLine

    @staticmethod
    def zigzag(feature, wavelength, amplitude, restGeometryType, offset, shpExtent, orientation):
        """
            Taken from: https://www.google.fr/url?sa=t&rct=j&q=&esrc=s&source=web&cd=8&cad=rja&uact=8&ved=0ahUKEwi06c6nkMzWAhWCwxoKHWHMC34QFghEMAc&url=http%3A%2F%2Fwww.geoinformations.developpement-durable.gouv.fr%2Ffichier%2Fodt%2Fgenerateur_de_zigzag_v1_cle0d3366.odt%3Farg%3D177834503%26cle%3Df6f59e5a812d5c3e7a829f05497213f839936080%26file%3Dodt%252Fgenerateur_de_zigzag_v1_cle0d3366.odt&usg=AOvVaw0JoVM0llmrvSCdxOEaGCOH
            www.geoinformations.developpement-durable.gouv.fr

           transforme une geometrie lineaire en zigzag
           <h4>Syntax</h4>
           <pre>zigzag(geom, longueur, amplitude)</pre>

           <h4>Exemple</h4>
           zigzag($geometry,200,100)

        """

        QgsMessageLog.logMessage("In zigzag", tag="TOMs panel")

        line = RestrictionTypeUtils.getDisplayGeometry(feature, restGeometryType, offset, shpExtent, orientation)

        QgsMessageLog.logMessage("In zigzag - have geometry + " + line.exportToWkt(), tag="TOMs panel")

        length = line.length()
        QgsMessageLog.logMessage("In zigzag - have geometry. Length = " + str(length) + " wavelength: " + str(wavelength), tag="TOMs panel")

        segments = int(length / wavelength)
        # Find equally spaced points that approximate the line
        QgsMessageLog.logMessage("In zigzag - have geometry. segments = " + str(segments), tag="TOMs panel")

        points = []
        countSegments = 0
        while countSegments <= segments:
            #QgsMessageLog.logMessage("In zigzag - countSegment = " + str(countSegments), tag="TOMs panel")
            interpolateDistance = int(countSegments * int(wavelength))
            #QgsMessageLog.logMessage("In zigzag - interpolateDistance = " + str(interpolateDistance), tag="TOMs panel")
            points.append (line.interpolate(float(interpolateDistance)).asPoint())
            #QgsMessageLog.logMessage("In zigzag - added Point", tag="TOMs panel")
            countSegments = countSegments + 1

        QgsMessageLog.logMessage("In zigzag - have points: nrPts = " + str(len(points)), tag="TOMs panel")

        # Calculate the azimuths of the approximating line segments

        azimuths = []

        for i in range(len(points) - 1):
            #QgsMessageLog.logMessage("In zigzag - creating Az: i = " + str(i), tag="TOMs panel")
            azimuths.append( (points[i].azimuth(points[i + 1])) )

        QgsMessageLog.logMessage("In zigzag - after azimuths: i " + str(i) + " len(az): " + str(len(azimuths)), tag="TOMs panel")

        # Average consecutive azimuths and rotate 90 deg counterclockwise

        #newAz, distWidth = RestrictionTypeUtils.calcBisector(prevAz, Az, Turn, shpExtent)

        zigzagazimuths = [azimuths[0] - math.pi / 2]
        zigzagazimuths.extend([RestrictionTypeUtils.meanAngle(azimuths[i], azimuths[i - 1]) - math.pi / 2 for i in range(len(points) - 1)])
        zigzagazimuths.append(azimuths[-1] - math.pi / 2)

        QgsMessageLog.logMessage("In zigzag - about to create shape", tag="TOMs panel")

        cosa = 0.0
        cosb = 0.0

        # Offset the points along the zigzagazimuths
        zigzagpoints = []
        for i in range(len(points)-1):
            # Alternate the sign

            QgsMessageLog.logMessage("In zigzag - sign: " + str(i - 2 * math.floor(i/2)), tag="TOMs panel")

            #currX = points[i].x()
            #currY = points[i].y()

            dst = amplitude * 1 - 2 * (i - 2 * math.floor(i/2))    # b = a - m.*floor(a./m)  is the same as   b = mod( a , m )      Thus: i - 2 * math.floor(i/2)
            QgsMessageLog.logMessage("In zigzag - dst: " + str(dst) + " Az: " + str(azimuths[i]), tag="TOMs panel")

            #currAz = zigzagazimuths[i]
            cosa, cosb = RestrictionTypeUtils.cosdir_azim(azimuths[i])

            QgsMessageLog.logMessage("In zigzag - cosa: " + str(cosa), tag="TOMs panel")

            zigzagpoints.append(
                QgsPoint(points[i].x() + (float(offset) * cosa), points[i].y() + (float(offset) * cosb)))

            QgsMessageLog.logMessage("In zigzag - point added: " + str(i), tag="TOMs panel")
            #zigzagpoints.append(QgsPoint(points[i][0] + math.sin(zigzagazimuths[i]) * dst, points[i][1] + math.cos(zigzagazimuths[i]) * dst))

        # Create new feature from the list of zigzag points
        gLine = QgsGeometry.fromPolyline(zigzagpoints)

        QgsMessageLog.logMessage("In zigzag - shape created", tag="TOMs panel")

        return gLine

    @staticmethod
    def meanAngle(a1, a2):
        return phase((rect(1, a1) + rect(1, a2)) / 2.0)

    @staticmethod
    def restrictionInProposal (currRestrictionID, currRestrictionLayerID, proposalID):
        # returns True if resstriction is in Proposal
        QgsMessageLog.logMessage("In restrictionInProposal.", tag="TOMs panel")

        RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]

        restrictionFound = False

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for restrictionInProposal in RestrictionsInProposalsLayer.getFeatures():
            if restrictionInProposal.attribute("RestrictionID") == currRestrictionID:
                if restrictionInProposal.attribute("RestrictionTableID") == currRestrictionLayerID:
                    if restrictionInProposal.attribute("ProposalID") == proposalID:
                        restrictionFound = True

        QgsMessageLog.logMessage("In restrictionInProposal. restrictionFound: " + str(restrictionFound),
                                 tag="TOMs panel")

        return restrictionFound

    @staticmethod    # NB: Duplicated from restrictionOpenForm.py - need to understand scope and how to reference !!!
    def addRestrictionToProposal(restrictionID, restrictionLayerTableID, proposalID, proposedAction):
        # adds restriction to the "RestrictionsInProposals" layer
        QgsMessageLog.logMessage("In addRestrictionToProposal.", tag="TOMs panel")

        RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]

        idxProposalID = RestrictionsInProposalsLayer.fieldNameIndex("ProposalID")
        idxRestrictionID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionID")
        idxRestrictionTableID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionTableID")
        idxActionOnProposalAcceptance = RestrictionsInProposalsLayer.fieldNameIndex(
            "ActionOnProposalAcceptance")

        RestrictionsInProposalsLayer.startEditing()

        newRestrictionsInProposal = QgsFeature(RestrictionsInProposalsLayer.fields())
        newRestrictionsInProposal.setGeometry(QgsGeometry())

        newRestrictionsInProposal[idxProposalID] = proposalID
        newRestrictionsInProposal[idxRestrictionID] = restrictionID
        newRestrictionsInProposal[idxRestrictionTableID] = restrictionLayerTableID
        newRestrictionsInProposal[idxActionOnProposalAcceptance] = proposedAction

        QgsMessageLog.logMessage(
            "In addRestrictionToProposal. Before record create. RestrictionID: " + str(restrictionID),
            tag="TOMs panel")

        RestrictionsInProposalsLayer.addFeatures([newRestrictionsInProposal])

        pass

    @staticmethod
    def getRestrictionsLayer(currRestrictionTableRecord):
        # return the layer given the row in "RestrictionLayers"
        QgsMessageLog.logMessage("In getRestrictionLayer.", tag="TOMs panel")

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fieldNameIndex("RestrictionLayerName")

        currRestrictionsTableName = currRestrictionTableRecord[idxRestrictionsLayerName]

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionsTableName)[0]

        return RestrictionsLayers

    @staticmethod
    def getRestrictionLayerTableID(currRestLayer):
        QgsMessageLog.logMessage("In getRestrictionLayerTableID.", tag="TOMs panel")
        # find the ID for the layer within the table "

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        layersTableID = 0

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for layer in RestrictionsLayers.getFeatures():
            if layer.attribute("RestrictionLayerName") == str(currRestLayer.name()):
                layersTableID = layer.attribute("id")

        QgsMessageLog.logMessage("In getRestrictionLayerTableID. layersTableID: " + str(layersTableID),
                                 tag="TOMs panel")

        return layersTableID

#############################################################################

class EditRestrictionTool(QgsMapTool, MapToolMixin):
    def __init__(self, canvas, layer, onTrackEdited):
        QgsMapTool.__init__(self, canvas)
        self.onTrackEdited = onTrackEdited
        self.dragging      = False
        self.feature       = None
        self.vertex        = None
        self.setLayer(layer)
        self.setCursor(Qt.CrossCursor)


    def canvasPressEvent(self, event):
        """ Respond to the mouse button being pressed.
        """
        feature = self.findFeatureAt(event.pos())
        if feature == None:
            return

        vertex = self.findVertexAt(feature, event.pos())
        if vertex == None: return

        if event.button() == Qt.LeftButton:
            # Left click -> move vertex.
            self.dragging = True
            self.feature  = feature
            self.vertex   = vertex
            self.moveVertexTo(event.pos())
            self.canvas().refresh()
        elif event.button() == Qt.RightButton:
            # Right click -> delete vertex.
            self.deleteVertex(feature, vertex)
            self.canvas().refresh()


    def canvasMoveEvent(self, event):
        if self.dragging:
            self.moveVertexTo(event.pos())
            self.canvas().refresh()


    def canvasReleaseEvent(self, event):
        if self.dragging:
            self.moveVertexTo(event.pos())
            self.layer.updateExtents()
            self.canvas().refresh()
            self.dragging = False
            self.feature  = None
            self.vertex   = None


    def canvasDoubleClickEvent(self, event):
        feature = self.findFeatureAt(event.pos())
        if feature == None:
            return

        mapPt,layerPt = self.transformCoordinates(event.pos())
        geometry      = feature.geometry()

        distSquared,closestPt,beforeVertex = \
            geometry.closestSegmentWithContext(layerPt)

        distance = math.sqrt(distSquared)
        tolerance = self.calcTolerance(event.pos())
        if distance > tolerance: return

        geometry.insertVertex(closestPt.x(), closestPt.y(), beforeVertex)
        self.layer.changeGeometry(feature.id(), geometry)
        self.onTrackEdited()
        self.canvas().refresh()


    def moveVertexTo(self, pos):
        """ Move the edited vertex to the given position.

            'pos' is in canvas coordinates.
        """
        snappedPt = self.snapToNearestVertex(pos, self.layer, self.feature)

        geometry = self.feature.geometry()
        layerPt = self.toLayerCoordinates(self.layer, pos)
        geometry.moveVertex(snappedPt.x(), snappedPt.y(), self.vertex)
        self.layer.changeGeometry(self.feature.id(), geometry)
        self.onTrackEdited()


    def deleteVertex(self, feature, vertex):
        """ Delete the given vertex from the given feature's geometry.
        """
        geometry = feature.geometry()

        lineString = geometry.asPolyline()
        if len(lineString) <= 2:
            return

        if geometry.deleteVertex(vertex):
            self.layer.changeGeometry(feature.id(), geometry)
            self.onTrackEdited()

#############################################################################

class RemoveRestrictionTool(QgsMapTool, MapToolMixin):
    def __init__(self, iface, onRemoveRestriction):
        QgsMapTool.__init__(self, iface.mapCanvas())
        self.iface = iface
        #self.layer = layer
        #self.onTrackDeleted = onTrackDeleted
        self.feature        = None
        #self.setLayer(layer)
        self.setCursor(Qt.CrossCursor)
        # set up function to be called when capture is complete
        self.onRemoveRestriction = onRemoveRestriction

    def canvasReleaseEvent(self, event):
        # Return point under cursor
        closestFeature, closestLayer = self.findNearestFeatureAt(event.pos())

        QgsMessageLog.logMessage(("In Remove - canvasReleaseEvent."), tag="TOMs panel")

        if closestFeature == None:
            return

        QgsMessageLog.logMessage(("In Remove - canvasReleaseEvent. Feature selected from layer: " + closestLayer.name()), tag="TOMs panel")

        closestLayer.startEditing()

        self.onRemoveRestriction(closestLayer, closestFeature)
        #self.onDisplayRestrictionDetails(feature, self.layer)


#############################################################################

class SelectVertexTool(QgsMapTool, MapToolMixin):
    """ Map tool to let user select a vertex.

        We use this to let the user select a starting or ending point for the
        shortest route calculator.
    """
    def __init__(self, canvas, trackLayer, onVertexSelected):
        QgsMapTool.__init__(self, canvas)
        self.onVertexSelected = onVertexSelected
        self.setLayer(trackLayer)
        self.setCursor(Qt.CrossCursor)


    def canvasReleaseEvent(self, event):
        feature = self.findFeatureAt(event.pos())
        if feature != None:
            vertex = self.findVertexAt(feature, event.pos())
            if vertex != None:
                self.onVertexSelected(feature, vertex)

