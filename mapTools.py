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
from qgis.gui import QgsMapToolCapture

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
        return (self.toMapCoordinates(screenPt),
                self.toLayerCoordinates(self.layer, screenPt))

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

        mapPt1,layerPt1 = self.transformCoordinates(pt1)
        mapPt2,layerPt2 = self.transformCoordinates(pt2)
        tolerance = layerPt2.x() - layerPt1.x()

        return tolerance

    def findFeatureAt(self, pos, excludeFeature=None):
    # def findFeatureAt(self, pos, excludeFeature=None):
        """ Find the feature close to the given position.

            'pos' is the position to check, in canvas coordinates.

            if 'excludeFeature' is specified, we ignore this feature when
            finding the clicked-on feature.

            If no feature is close to the given coordinate, we return None.
        """
        mapPt,layerPt = self.transformCoordinates(pos)
        tolerance = self.calcTolerance(pos)
        searchRect = QgsRectangle(layerPt.x() - tolerance,
                                  layerPt.y() - tolerance,
                                  layerPt.x() + tolerance,
                                  layerPt.y() + tolerance)

        request = QgsFeatureRequest()
        request.setFilterRect(searchRect)
        request.setFlags(QgsFeatureRequest.ExactIntersect)

        '''for feature in self.layer.getFeatures(request):
            if excludeFeature != None:
                if feature.id() == excludeFeature.id():
                    continue
            return feature '''

        for feature in self.layer.getFeatures(request):
            if excludeFeature != None:
                if feature.id() == excludeFeature.id():
                    continue
            return feature # Return first matching feature.

        return None

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

    def __init__(self, iface, layer, onDisplayRestrictionDetails):
        QgsMapToolIdentify.__init__(self, iface.mapCanvas())
        self.iface = iface
        self.layer = layer
        self.onDisplayRestrictionDetails = onDisplayRestrictionDetails
        self.setCursor(Qt.WhatsThisCursor)
        # self.setCursor(Qt.ArrowCursor)

    def canvasReleaseEvent(self, event):
        # Return point under cursor  
        feature = self.findFeatureAt(event.pos())

        QgsMessageLog.logMessage(("In Info - canvasReleaseEvent."), tag="TOMs panel")

        if feature == None:
            return

        QgsMessageLog.logMessage(("In Info - canvasReleaseEvent. Feature selected"), tag="TOMs panel")

        self.onDisplayRestrictionDetails(feature)

#############################################################################

class CreateRestrictionTool(QgsMapToolCapture):
     # helpful link - http://apprize.info/python/qgis/7.html ??
    def __init__(self, iface, layer, onCreateRestriction):

        QgsMessageLog.logMessage(("In Create - init."), tag="TOMs panel")

        QgsMapToolCapture.__init__(self, iface.mapCanvas(), iface.cadDockWidget())
        #https: // qgis.org / api / classQgsMapToolCapture.html
        #iface.mapCanvas() = canvas

        # I guess at this point, it is possible to set things like capture mode, snapping preferences, ... (not sure of all the elements that are required)
        # capture mode (... not sure if this has already been set? - or how to set it)
        self.setMode(CreateRestrictionTool.CaptureLine)

        # Seems that this is important - or at least to create a point list that is used later to create Geometry
        self.sketchPoints = self.points()
        #self.setPoints(self.sketchPoints)  ... not sure when to use this ??

        # Set upi rubber band. In current implementation, it is not showing feeback for "next" location

        self.rb = self.createRubberBand(QGis.Line)

        self.layer = layer
        self.currLayer = self.currentVectorLayer()
        QgsMessageLog.logMessage(("In Create - init. Curr layer is " + str(self.currLayer) + "Incoming: " + str(self.layer)), tag="TOMs panel")

        # set up function to be called when capture is complete
        self.onCreateRestriction = onCreateRestriction

    def cadCanvasReleaseEvent(self, event):
        QgsMessageLog.logMessage(("In Create - cadCanvasReleaseEvent"), tag="TOMs panel")
        if event.button() == Qt.LeftButton:
            if not self.isCapturing():
                self.startCapturing()
            #self.result = self.addVertex(self.toMapCoordinates(event.pos()))
            self.currPoint = self.toLayerCoordinates(self.layer, event.pos())
            self.result = self.addVertex(self.currPoint)
            self.currPoint.x()

            QgsMessageLog.logMessage(("In Create - cadCanvasReleaseEvent (AddVertex) Result: " + str(self.result) + " X:" + str(self.currPoint.x()) + " Y:" + str(self.currPoint.y())), tag="TOMs panel")

        elif (event.button() == Qt.RightButton):
            # Stop capture when right button or escape key is pressed
            #points = self.getCapturedPoints()
            self.getPointsCaptured()

            # Need to think about the default action here if none of these buttons/keys are pressed.

    def canvasDoubleClickEvent(self, event):
        # Include point and stop capture 
        pass

    def cadCanvasMoveEvent(self, event):
        # probably need to add something here to show movement ...
        pass

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
            # feature = QgsFeature()
            feature = RestrictionType()
            feature.setFields(fields)

            #self.newGeom = QgsGeometry.fromPolyline(self.sketchPoints)

            #feature.setGeometry(QgsGeometry.fromPolyline(self.points()))   # Not sure why this statement does not work ...
            feature.setGeometry(QgsGeometry.fromPolyline(self.sketchPoints))

            # Currently geometry is not being created correct. Might be worth checking co-ord values ...

            self.valid = feature.isValid()

            QgsMessageLog.logMessage(("In Create - getPointsCaptured; geome"
                                      "try prepared; validity" + str(self.valid)),
                                     tag="TOMs panel")

            # set any geometry related attributes ...

            feature.setRoadName()
            feature.setAzimuthToRoadCentreLine()

            """  Additions from Matthias

            feature = QgsFeature()
            
            road = RestrictionTypeWrapper(feature)

            road.setRoadName(xyz)

            layer.addFeature(road.feature)
            """

            # is there any other tidying to do ??

            self.onCreateRestriction(feature)

#############################################################################

class RestrictionType(QgsFeature, MapToolMixin):
    # This is a test to see how subtype of QgsFeature might work

    # Would be helpful to have different types of restrictions here - bays, lines, dropped kerbs, moving, ...

    # Need to create fucntions to obtain these details

    StreetName = "Test Road"
    USRN = "1234"
    AzimuthToRoadCentreLine = 90

    def setRoadName(self):

        QgsMessageLog.logMessage("In setRoadName:", tag="TOMs panel")

        self.RoadCasementLayer = QgsMapLayerRegistry.instance().mapLayersByName("rc_nsg_sideofstreet")[0]

        # take the first point from the geometry
        line = self.geometry().asPolyline()
        nrPts = len(line)
        QgsMessageLog.logMessage("In setRoadName: nrPts = " + str(nrPts), tag="TOMs panel")

        secondPt = line[1]   # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

        QgsMessageLog.logMessage("In setRoadName: secondPt: " + str(secondPt.x()), tag="TOMs panel")

        # check for the feature within RoadCasement_NSG_StreetName layer
        tolerance_nearby = 0.25  # somehow need to have this (and layer names) as global variables

        nearestRC_feature = self.findFeatureAt2(secondPt, self.RoadCasementLayer, tolerance_nearby)

        if nearestRC_feature:

            #QgsMessageLog.logMessage("In setRoadName: nearestRC_feature: " + nearestRC_feature.geometry().exportToWkt(), tag="TOMs panel")

            #fields = self.RoadCasementLayer.dataProvider().fields()
            #nearestRC_feature.setFields(fields)

            #StreetName = nearestRC_feature.attributes("Street_Descriptor")
            #USRN = nearestRC_feature.attributes("USRN")

            idx_Street_Descriptor = self.RoadCasementLayer.fieldNameIndex('Street_Descriptor')
            idx_USRN = self.RoadCasementLayer.fieldNameIndex('USRN')

            self.StreetName = nearestRC_feature.attributes()[idx_Street_Descriptor]
            self.USRN = nearestRC_feature.attributes()[idx_USRN]

            QgsMessageLog.logMessage("In setRoadName: StreetName: " + str(self.StreetName), tag="TOMs panel")

            self.setAttribute("RoadName", self.StreetName)
            self.setAttribute("USRN", int(self.USRN))

        pass

    def setAzimuthToRoadCentreLine(self):

        # find the shortest line from this point to the road centre line layer
        # http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/ - generates "closest feature" function

        QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine:", tag="TOMs panel")

        self.RoadCentreLineLayer = QgsMapLayerRegistry.instance().mapLayersByName("RoadCentreLine")[0]

        # take the first point from the geometry
        line = self.geometry().asPolyline()
        #nrPts = len(line)
        #QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine: nrPts = " + str(nrPts), tag="TOMs panel")

        testPt = line[1]   # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

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

        # Loop through all features in the layer to find the closest feature
        for f in self.RoadCentreLineLayer.getFeatures(request):
            dist = f.geometry().distance(QgsGeometry.fromPoint(testPt))
            if dist < shortestDistance:
                shortestDistance = dist
                closestFeature = f

        QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine: shortestDistance: " + str(shortestDistance), tag="TOMs panel")

        if closestFeature:
            # now obtain the line between the testPt and the nearest feature
            f_lineToCL = closestFeature.geometry().shortestLine(QgsGeometry.fromPoint(testPt))

            # get the start point (we know the end point)
            startPtV2 = f_lineToCL.geometry().startPoint()
            startPt = QgsPoint()
            startPt.setX(startPtV2.x())
            startPt.setY(startPtV2.y())

            QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine: startPoint: " + str(startPt.x()), tag="TOMs panel")

            Az = testPt.azimuth(startPt)
            QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine: Az: " + str(Az), tag="TOMs panel")

            # now set the attribute
            self.setAttribute("AzimuthToRoadCentreLine", int(Az))

        pass

    def findFeatureAt2(self, layerPt, layer, tolerance):
    # def findFeatureAt(self, pos, excludeFeature=None):
        """ Find the feature close to the given position.

            'pos' is the position to check, in canvas coordinates.

            if 'excludeFeature' is specified, we ignore this feature when
            finding the clicked-on feature.

            If no feature is close to the given coordinate, we return None.
        """

        self.layer = layer
        #self.currLayer = self.currentVectorLayer()
        QgsMessageLog.logMessage("In findFeatureAt2. Incoming layer: " + str(self.layer), tag="TOMs panel")
        #mapPt,layerPt = self.transformCoordinates(pos)
        #tolerance = self.calcTolerance(pos)
        #tolerance = 0.25  # where should we set this ??
        searchRect = QgsRectangle(layerPt.x() - tolerance,
                                  layerPt.y() - tolerance,
                                  layerPt.x() + tolerance,
                                  layerPt.y() + tolerance)

        request = QgsFeatureRequest()
        request.setFilterRect(searchRect)
        request.setFlags(QgsFeatureRequest.ExactIntersect)

        for feature in self.layer.getFeatures(request):
            QgsMessageLog.logMessage("In findFeatureAt2. feature found", tag="TOMs panel")
            return feature # Return first matching feature.

        return None

class RestrictionTypeWrapper():
    def __init__(self, feature):
        self.feature = feature

    def setRoadName(self, name):
        self.feature.setAttribute('RoadName', name)


class RestrictionTypeUtils:
    @classmethod
    def prepareRoadFeature(feature):
        feature.setAttribute()
        return feature



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
    def __init__(self, canvas, layer, onTrackDeleted):
        QgsMapTool.__init__(self, canvas)
        self.onTrackDeleted = onTrackDeleted
        self.feature        = None
        self.setLayer(layer)
        self.setCursor(Qt.CrossCursor)


    def canvasPressEvent(self, event):
        self.feature = self.findFeatureAt(event.pos())


    def canvasReleaseEvent(self, event):
        feature = self.findFeatureAt(event.pos())
        if feature != None and feature.id() == self.feature.id():
            self.layer.deleteFeature(self.feature.id())
            self.onTrackDeleted()

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

