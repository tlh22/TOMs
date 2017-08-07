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
    #class CreateRestrictionTool(QgsMapTool, MapToolMixin):
    # helpful link - http://apprize.info/python/qgis/7.html
    def __init__(self, iface, layer, onCreateRestriction):

        QgsMessageLog.logMessage(("In Create - init."), tag="TOMs panel")

        QgsMapToolCapture.__init__(self, iface.mapCanvas(), iface.cadDockWidget())
        #https: // qgis.org / api / classQgsMapToolCapture.html
        #iface.mapCanvas() = canvas

        # I guess at this point, it is possible to set things like capture mode, snapping preferences, ... (not sure of all the elements that are required)
        # capture mode (... not sure if this has already been set? - or how to set it)
        #self.setMode()

        self.capturing = False

        #self.iface = iface

        self.layer = layer

        # set up function to be called when capture is complete
        self.onCreateRestriction = onCreateRestriction

        #self.setLayer(layer)

    def activate(self):
        QgsMessageLog.logMessage(("In Create - activate"), tag="TOMs panel")
        # Not sure what should happen here. I guess that this should enable the panel.

        pass

    def cadCanvasReleaseEvent(self, event):
        QgsMessageLog.logMessage(("In Create - cadCanvasReleaseEvent"), tag="TOMs panel")
        if event.button() == Qt.LeftButton:
            if not self.capturing:
                self.startCapturing()
            self.addVertex(self.toMapCoordinates(event.pos()))
        elif (event.button() == Qt.RightButton):
            # Stop capture when right button or escape key is pressed
            points = self.getCapturedPoints()
            self.stopCapturing()
            if points != None:
                self.pointsCaptured(self.sketchPoints)
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

    def startCapturing(self):
        QgsMessageLog.logMessage(("In Create - startCapturing"), tag="TOMs panel")
        # Not clear what is to be set up here

        # I guess activate
        self.activate()

        # I guess set up rubber band

        self.rb = self.createRubberBand(QGis.Line)

        # set up shape storage
        self.sketchPoints = self.points()
        self.setPoints(self.sketchPoints)

        self.capturing = True

    def stopCapturing(self):
        QgsMessageLog.logMessage(("In Create - stopCapturing"), tag="TOMs panel")
        if self.rubberBand:
            self.iface.mapCanvas().scene().removeItem(self.rubberBand)
            self.rubberBand = None
        if self.tempRubberBand:
            self.iface.mapCanvas().scene().removeItem(self.tempRubberBand)
            self.tempRubberBand = None
        self.capturing = False
        self.capturedPoints = []
        self.iface.mapCanvas().refresh()

    def setPoints(self, list_of_QgsPoint):
        # should we assign a list of points to something here???
        pass

    def pointsCaptured(self, points):
        print "in pointsCaptured"
        fields = self.layer.dataProvider().fields()

        feature = QgsFeature()
        feature.setFields(fields)

        feature.setGeometry(QgsGeometry.fromPolyline(points))

        '''
        feature.setAttribute("type",      TRACK_TYPE_ROAD)
        feature.setAttribute("status",    TRACK_STATUS_OPEN)
        feature.setAttribute("direction", TRACK_DIRECTION_BOTH)

        self.layer.addFeature(feature)

        self.layer.updateExtents()
        '''    
        self.onCreateRestriction(feature)

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

