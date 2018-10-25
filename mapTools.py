#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock 2017
#
""" mapTools.py

    # Taken from Erik Westra's book


    This module defines the various QgsMapTool subclasses used by the
    "ForestTrails" application.
"""

import math
#import time

from qgis.core import *
from qgis.gui import *

from PyQt4.QtCore import *
from PyQt4.QtGui import *

from core.proposalsManager import *
#from restrictionTypeUtils import RestrictionTypeUtils
from generateGeometryUtils import generateGeometryUtils
from TOMs.restrictionTypeUtilsClass import RestrictionTypeUtilsMixin
#from TOMs.CadNodeTool.TOMsNodeTool import originalFeature

from TOMs.constants import (
    ACTION_CLOSE_RESTRICTION,
    ACTION_OPEN_RESTRICTION
)

import functools

#from cmath import rect, phase
#import numpy as np
import uuid

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

        featureList = []
        layerList = []

        for layerDetails in self.RestrictionLayers.getFeatures():

            self.currLayer = RestrictionTypeUtilsMixin.getRestrictionsLayer (layerDetails)

            # Loop through all features in the layer to find the closest feature
            for f in self.currLayer.getFeatures(request):
                # Add any features that are found should be added to a list
                featureList.append(f)
                layerList.append(self.currLayer)

                dist = f.geometry().distance(QgsGeometry.fromPoint(mapPt))
                if dist < shortestDistance:
                    shortestDistance = dist
                    closestFeature = f
                    closestLayer = self.currLayer

        #QgsMessageLog.logMessage("In findNearestFeatureAt: shortestDistance: " + str(shortestDistance), tag="TOMs panel")
        QgsMessageLog.logMessage("In findNearestFeatureAt: nrFeatures: " + str(len(featureList)), tag="TOMs panel")

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


#############################################################################

class GeometryInfoMapTool(QgsMapToolIdentify, MapToolMixin, RestrictionTypeUtilsMixin):

    # Modified from Erik Westra's book to deal specifically with restrictions

    def __init__(self, iface):
        QgsMapToolIdentify.__init__(self, iface.mapCanvas())
        self.iface = iface

        #self.featureContextMenu = FeatureContextMenu(self.iface)

        #self.proposalsManager = proposalsManager  ??? how to include ???
        #self.closestLayer = layer
        #self.onDisplayRestrictionDetails = onDisplayRestrictionDetails
        #self.setCursor(Qt.WhatsThisCursor)
        # self.setCursor(Qt.ArrowCursor)

        ### Should we pick up the change active layer signal here? and deselect from previous layer
        # Currently, it is possible to select features from more than one layer

    def canvasReleaseEvent(self, event):
        # Return point under cursor

        self.event = event

        closestFeature, closestLayer = self.findNearestFeatureAtC(event.pos())

        QgsMessageLog.logMessage(("In Info - canvasReleaseEvent."), tag="TOMs panel")

        # Remove any current selection and add the new ones (if appropriate)

        if closestLayer == None:

            if self.iface.activeLayer():
                self.iface.activeLayer().removeSelection()

        else:

            QgsMessageLog.logMessage(
                ("In Info - canvasReleaseEvent. Feature selected from layer: " + closestLayer.name() + " id: " + str(closestFeature.id())),
                tag="TOMs panel")

            if closestLayer <> self.iface.activeLayer():
                if self.iface.activeLayer():
                    self.iface.activeLayer().removeSelection()
                #closestLayer.startEditing()
                self.iface.setActiveLayer(closestLayer)

            if closestLayer.type() == QgsMapLayer.VectorLayer:
                QgsMessageLog.logMessage(("In Info - canvasReleaseEvent. layer type " + str(closestLayer.type()) ), tag="TOMs panel")

            if closestLayer.geometryType() == QGis.Point:
                QgsMessageLog.logMessage(("In Info - canvasReleaseEvent. point layer type " ), tag="TOMs panel")

            if closestLayer.geometryType() == QGis.Line:
                QgsMessageLog.logMessage(("In Info - canvasReleaseEvent. line layer type " ), tag="TOMs panel")


            # highlight the feature ...
            closestLayer.setSelectedFeatures([closestFeature.id()])

            # self.iface.openFeatureForm(self.closestLayer, self.closestFeature)
            # self.onDisplayRestrictionDetails(feature, self.layer)

        pass

    def findNearestFeatureAtC(self, pos):
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

        #shortestDistance = float("inf")

        featureList = []
        layerList = []

        for layerDetails in self.RestrictionLayers.getFeatures():

            self.currLayer = self.getRestrictionsLayer (layerDetails)

            # Loop through all features in the layer to find the closest feature
            for f in self.currLayer.getFeatures(request):
                # Add any features that are found should be added to a list
                featureList.append(f)
                layerList.append(self.currLayer)

                """dist = f.geometry().distance(QgsGeometry.fromPoint(mapPt))
                if dist < shortestDistance:
                    shortestDistance = dist
                    closestFeature = f
                    closestLayer = self.currLayer"""

        #QgsMessageLog.logMessage("In findNearestFeatureAt: shortestDistance: " + str(shortestDistance), tag="TOMs panel")
        QgsMessageLog.logMessage("In findNearestFeatureAt: nrFeatures: " + str(len(featureList)), tag="TOMs panel")

        """if shortestDistance < float("inf"):
            return closestFeature, closestLayer
        else:
            return None, None"""

        if len(featureList) == 0:
            return None, None
        elif len(featureList) == 1:
            return featureList[0], layerList[0]
        else:
            # set up a context menu
            QgsMessageLog.logMessage("In findNearestFeatureAt: multiple features: " + str(len(featureList)), tag="TOMs panel")

            feature, layer = self.getFeatureDetails(featureList, layerList)

            QgsMessageLog.logMessage("In findNearestFeatureAt: feature: " + feature.attribute('GeometryID'), tag="TOMs panel")

            return feature, layer
            # return self.getFeatureDetails(featureList, layerList)

        pass

    def getFeatureDetails(self, featureList, layerList):
        QgsMessageLog.logMessage("In getFeatureDetails", tag="TOMs panel")

        self.featureList = featureList
        self.layerList = layerList

        # Creates the context menu and returns the selected feature and layer
        QgsMessageLog.logMessage("In getFeatureDetails: nrFeatures: " + str(len(featureList)), tag="TOMs panel")

        #actions = dict()
        self.actions = []
        self.menu = QMenu(self.iface.mapCanvas())

        # for _, feature in filtered_features.iteritems():
        for feature in featureList:

            try:

                title = feature.attribute('GeometryID')
                QgsMessageLog.logMessage("In featureContextMenu: adding: " + str(title), tag="TOMs panel")

            except TypeError:

                title = " (" + feature.attribute('RestrictionID') + ")"

            action = QAction(title, self.menu)
            #self.action.triggered.connect(self.onInitProposalsPanel)
            self.actions.append(action)

            #actions[action] = point

            self.menu.addAction(action)

        QgsMessageLog.logMessage("In getFeatureDetails: showing menu?", tag="TOMs panel")

        # QgsMapToolCapture.cadCanvasReleaseEvent(self, event)

        clicked_action = self.menu.exec_(self.iface.mapCanvas().mapToGlobal(self.event.pos()))
        QgsMessageLog.logMessage(("In getFeatureDetails:clicked_action: " + str(clicked_action)), tag="TOMs panel")

        if clicked_action is not None:

            QgsMessageLog.logMessage(("In getFeatureDetails:clicked_action: " + str(clicked_action.text())),
                                     tag="TOMs panel")
            #return self.actions[clicked_action]
            idxList = self.getIdxFromGeometryID (clicked_action.text(), featureList)

            QgsMessageLog.logMessage("In getFeatureDetails: idx = " + str(idxList), tag="TOMs panel")

            if idxList >= 0:
                QgsMessageLog.logMessage("In getFeatureDetails: feat = " + str(featureList[idxList].attribute('GeometryID')), tag="TOMs panel")
                return featureList[idxList], layerList[idxList]

        QgsMessageLog.logMessage(("In getFeatureDetails. No action found."), tag="TOMs panel")

        return None, None

    def getIdxFromGeometryID(self, selectedGeometryID, featureList):
        #
        QgsMessageLog.logMessage("In getIdxFromGeometryID", tag="TOMs panel")

        idx = -1
        for feature in featureList:
            idx = idx + 1
            if feature.attribute("GeometryID") == selectedGeometryID:
                return idx

        pass

        return idx

#############################################################################

class CreateRestrictionTool(QgsMapToolCapture, RestrictionTypeUtilsMixin):
    # helpful link - http://apprize.info/python/qgis/7.html ??
    def __init__(self, iface, layer, proposalsManager, currTransaction):

        QgsMessageLog.logMessage(("In CreateRestrictionTool - init."), tag="TOMs panel")

        QgsMapToolCapture.__init__(self, iface.mapCanvas(), iface.cadDockWidget())
        #https: // qgis.org / api / classQgsMapToolCapture.html
        canvas = iface.mapCanvas()
        self.iface = iface
        self.layer = layer
        #self.dialog = dialog
        self.currTransaction = currTransaction
        self.proposalsManager = proposalsManager

        #advancedDigitizingPanel = self.iface.AdvancedDigitizingTools()
        advancedDigitizingPanel = iface.mainWindow().findChild(QDockWidget, 'AdvancedDigitizingTools')
        if not advancedDigitizingPanel:
            QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                    ("Advanced Digitising Panel is not present"))
        # TODO: Need to do something if this is not present

        advancedDigitizingPanel.setVisible(True)
        self.setupPanelTabs(self.iface, advancedDigitizingPanel)
        #QgsMapToolAdvancedDigitizing.activate(self)
        #self.iface.cadDockWidget().enable()

        #self.QgsWkbTypes = QgsWkbTypes()

        # I guess at this point, it is possible to set things like capture mode, snapping preferences, ... (not sure of all the elements that are required)
        # capture mode (... not sure if this has already been set? - or how to set it)

        QgsMessageLog.logMessage("In CreateRestrictionTool - geometryType for " + str(self.layer.name()) + ": " + str(self.layer.geometryType()), tag="TOMs panel")

        if self.layer.geometryType() == 0: # PointGeometry:
            self.setMode(CreateRestrictionTool.CapturePoint)
        elif self.layer.geometryType() == 1: # LineGeometry:
            self.setMode(CreateRestrictionTool.CaptureLine)
        elif self.layer.geometryType() == 2: # PolygonGeometry:
            self.setMode(CreateRestrictionTool.CapturePolygon)
        else:
            QgsMessageLog.logMessage(("In CreateRestrictionTool - No geometry type found. EXITING ...."), tag="TOMs panel")
            return

        QgsMessageLog.logMessage(("In CreateRestrictionTool - mode set."), tag="TOMs panel")

        # Seems that this is important - or at least to create a point list that is used later to create Geometry
        self.sketchPoints = self.points()
        #self.setPoints(self.sketchPoints)  ... not sure when to use this ??

        # Set up rubber band. In current implementation, it is not showing feeback for "next" location

        self.rb = self.createRubberBand(QGis.Line)  # what about a polygon ??

        self.currLayer = self.currentVectorLayer()

        QgsMessageLog.logMessage(("In CreateRestrictionTool - init. Curr layer is " + str(self.currLayer.name()) + "Incoming: " + str(self.layer)), tag="TOMs panel")

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
        self.TOMsTracer = QgsTracer()
        RoadCasementLayer = QgsMapLayerRegistry.instance().mapLayersByName("RoadCasement")[0]
        traceLayersNames = [RoadCasementLayer]
        self.TOMsTracer.setLayers(traceLayersNames)

        # set an extent for the Tracer
        tracerExtent = iface.mapCanvas().extent()
        tolerance = 1000.0
        tracerExtent.setXMaximum(tracerExtent.xMaximum() + tolerance)
        tracerExtent.setYMaximum(tracerExtent.yMaximum() + tolerance)
        tracerExtent.setXMinimum(tracerExtent.xMinimum() - tolerance)
        tracerExtent.setYMinimum(tracerExtent.yMinimum() - tolerance)

        self.TOMsTracer.setExtent(tracerExtent)

        #self.TOMsTracer.setMaxFeatureCount(1000)
        self.lastPoint = None

        # set up function to be called when capture is complete
        #self.onCreateRestriction = onCreateRestriction

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

            nrPoints = self.size()
            res = None

            if not self.lastPoint:

                self.result = self.addVertex(self.currPoint)
                QgsMessageLog.logMessage("In Create - cadCanvasReleaseEvent: adding vertex 0 " + str(self.result), tag="TOMs panel")

            else:

                # check for shortest line
                resVectorList = self.TOMsTracer.findShortestPath(self.lastPoint, self.currPoint)

                QgsMessageLog.logMessage("In Create - cadCanvasReleaseEvent: traceList" + str(resVectorList), tag="TOMs panel")
                QgsMessageLog.logMessage("In Create - cadCanvasReleaseEvent: traceList" + str(resVectorList[1]), tag="TOMs panel")
                if resVectorList[1] == 0:
                    # path found, add the points to the list
                    QgsMessageLog.logMessage("In Create - cadCanvasReleaseEvent (found path) ", tag="TOMs panel")

                    #self.points.extend(resVectorList)
                    initialPoint = True
                    for point in resVectorList[0]:
                        if not initialPoint:

                            QgsMessageLog.logMessage(("In CreateRestrictionTool - cadCanvasReleaseEvent (found path) X:" + str(
                                point.x()) + " Y: " + str(point.y())), tag="TOMs panel")

                            self.result = self.addVertex(point)

                        initialPoint = False

                    QgsMessageLog.logMessage(("In Create - cadCanvasReleaseEvent (added shortest path)"),
                                             tag="TOMs panel")

                else:
                    # error encountered, add just the curr point ??

                    self.result = self.addVertex(self.currPoint)
                    QgsMessageLog.logMessage(("In CreateRestrictionTool - (adding shortest path) X:" + str(self.currPoint.x()) + " Y: " + str(self.currPoint.y())), tag="TOMs panel")

            self.lastPoint = self.currPoint

            QgsMessageLog.logMessage(("In Create - cadCanvasReleaseEvent (AddVertex/Line) Result: " + str(self.result) + " X:" + str(self.currPoint.x()) + " Y:" + str(self.currPoint.y())), tag="TOMs panel")

        elif (event.button() == Qt.RightButton):
            # Stop capture when right button or escape key is pressed
            #points = self.getCapturedPoints()
            self.getPointsCaptured()

            # Need to think about the default action here if none of these buttons/keys are pressed.

        pass

    def keyPressEvent(self, event):
        if (event.key() == Qt.Key_Backspace) or (event.key() == Qt.Key_Delete) or (event.key() == Qt.Key_Escape):
            self.undo()
            pass
        if event.key() == Qt.Key_Return or event.key() == Qt.Key_Enter:
            pass
            # Need to think about the default action here if none of these buttons/keys are pressed. 

    def getPointsCaptured(self):
        QgsMessageLog.logMessage(("In CreateRestrictionTool - getPointsCaptured"), tag="TOMs panel")

        # Check the number of points
        self.nrPoints = self.size()
        QgsMessageLog.logMessage(("In CreateRestrictionTool - getPointsCaptured; Stopping: " + str(self.nrPoints)),
                                 tag="TOMs panel")

        self.sketchPoints = self.points()

        for point in self.sketchPoints:
            QgsMessageLog.logMessage(("In CreateRestrictionTool - getPointsCaptured X:" + str(point.x()) + " Y: " + str(point.y())), tag="TOMs panel")

        # stop capture activity
        self.stopCapturing()

        if self.nrPoints > 0:

            # take points from the rubber band and copy them into the "feature"

            fields = self.layer.dataProvider().fields()
            feature = QgsFeature()
            feature.setFields(fields)

            QgsMessageLog.logMessage(("In CreateRestrictionTool. getPointsCaptured, layerType: " + str(self.layer.geometryType())), tag="TOMs panel")

            if self.layer.geometryType() == 0:  # Point
                feature.setGeometry(QgsGeometry.fromPoint(self.sketchPoints[0]))
            elif self.layer.geometryType() == 1:  # Line
                feature.setGeometry(QgsGeometry.fromPolyline(self.sketchPoints))
            elif self.layer.geometryType() == 2:  # Polygon
                feature.setGeometry(QgsGeometry.fromPolygon([self.sketchPoints]))
                #feature.setGeometry(QgsGeometry.fromPolygon(self.sketchPoints))
            else:
                QgsMessageLog.logMessage(("In CreateRestrictionTool - no geometry type found"), tag="TOMs panel")
                return

            # Currently geometry is not being created correct. Might be worth checking co-ord values ...

            #self.valid = feature.isValid()

            QgsMessageLog.logMessage(("In Create - getPointsCaptured; geometry prepared; " + str(feature.geometry().exportToWkt())),
                                     tag="TOMs panel")

            if self.layer.name() == "ConstructionLines":
                self.layer.addFeature(feature)
                pass
            else:

                # set any geometry related attributes ...

                self.setDefaultRestrictionDetails(feature, self.layer, self.proposalsManager.date())

                # is there any other tidying to do ??

                #self.layer.startEditing()
                #dialog = self.iface.getFeatureForm(self.layer, feature)

                #currForm = dialog.attributeForm()
                #currForm.disconnectButtonBox()

                QgsMessageLog.logMessage("In In CreateRestrictionTool - getPointsCaptured. currRestrictionLayer: " + str(self.layer.name()),
                                         tag="TOMs panel")

                #button_box = currForm.findChild(QDialogButtonBox, "button_box")
                #button_box.accepted.disconnect(currForm.accept)

                # Disconnect the signal that QGIS has wired up for the dialog to the button box.
                # button_box.accepted.disconnect(restrictionsDialog.accept)
                # Wire up our own signals.
                #button_box.accepted.connect(functools.partial(RestrictionTypeUtils.onSaveRestrictionDetails, feature, self.layer, currForm))
                #button_box.rejected.connect(dialog.reject)

                # To allow saving of the original feature, this function follows changes to attributes within the table and records them to the current feature
                #currForm.attributeChanged.connect(functools.partial(self.onAttributeChanged, feature))
                # Can we now implement the logic from the form code ???

                dialog = self.iface.getFeatureForm(self.layer, feature)

                self.setupRestrictionDialog(dialog, self.layer, feature, self.currTransaction)  # connects signals, etc

                dialog.show()
                #self.iface.openFeatureForm(self.layer, feature, False, False)

            pass

        #def onAttributeChanged(self, feature, fieldName, value):
        # QgsMessageLog.logMessage("In restrictionFormOpen:onAttributeChanged - layer: " + str(layer.name()) + " (" + str(feature.attribute("RestrictionID")) + "): " + fieldName + ": " + str(value), tag="TOMs panel")

        #feature.setAttribute(fieldName, value)


#############################################################################

class TOMsSplitRestrictionTool(QgsMapToolCapture, RestrictionTypeUtilsMixin):

    def __init__(self, iface, layer, proposalsManager, restrictionTransaction):

        QgsMessageLog.logMessage(("In SplitRestrictionTool - init."), tag="TOMs panel")

        QgsMapToolCapture.__init__(self, iface.mapCanvas(), iface.cadDockWidget())
        canvas = iface.mapCanvas()
        self.iface = iface
        self.layer = layer
        #self.dialog = dialog
        self.restrictionTransaction = restrictionTransaction
        self.proposalsManager = proposalsManager

        #self.blade = QgsMapToolEdit.createRubberBand(canvas)

        QgsMessageLog.logMessage(("In TOMsSplitRestrictionTool - geometryType: " + str(self.layer.geometryType())), tag="TOMs panel")

        self.setMode(CreateRestrictionTool.CaptureLine)

        QgsMessageLog.logMessage(("In TOMsSplitRestrictionTool - mode set."), tag="TOMs panel")

        # Seems that this is important - or at least to create a point list that is used later to create Geometry
        self.sketchPoints = self.points()

        # get details of the selected feature
        self.selectedRestriction = self.iface.activeLayer().selectedFeatures()[0]
        QgsMessageLog.logMessage("In TOMsNodeTool:initialising ... saving original feature + " + self.selectedRestriction.attribute("GeometryID"), tag="TOMs panel")

        # store the current restriction
        self.origFeature = originalFeature()

        self.origFeature.setFeature(self.selectedRestriction)
        self.origLayer = self.iface.activeLayer()
        #self.origLayer.startEditing()
        self.origFeature.printFeature()

    def cadCanvasReleaseEvent(self, event):
        QgsMapToolCapture.cadCanvasReleaseEvent(self, event)
        QgsMessageLog.logMessage(("In TOMsSplitRestrictionTool - cadCanvasReleaseEvent"), tag="TOMs panel")

        if event.button() == Qt.LeftButton:
            if not self.isCapturing():
                self.startCapturing()

            self.currPoint = event.mapPoint()
            #pt1 = self.toMapCoordinates(event.pos())

            # add point to rubber band
            self.result = self.addVertex(self.currPoint)

            QgsMessageLog.logMessage("In TOMsSplitRestrictionTool - added pt: " + str(self.size()) + " X: " +str(self.currPoint.x()) + " Y: " + str(self.currPoint.y()), tag="TOMs panel")
            #QgsMapToolCapture.addVertex(self.toMapCoordinates(event.pos()))

        elif (event.button() == Qt.RightButton):
            # Stop capture when right button or escape key is pressed
            # points = self.getCapturedPoints()

            self.getPointsCaptured()

            # also need to process split

    def getPointsCaptured(self):
        # Check the number of points
        self.nrPoints = self.size()
        QgsMessageLog.logMessage(("In TOMsSplitRestrictionTool - getPointsCaptured; Stopping: " + str(self.nrPoints)),
                                 tag="TOMs panel")

        self.sketchPoints = self.points()

        for point in self.sketchPoints:
            QgsMessageLog.logMessage(("In SplitRestrictionTool - getPointsCaptured X:" + str(point.x()) + " Y: " + str(point.y())), tag="TOMs panel")

        # stop capture activity
        self.stopCapturing()

        if self.nrPoints <= 0:
            reply = QMessageBox.information(None, "Error",
                                            "No cutting line created",
                                            QMessageBox.Ok)
            return
            # take points from the rubber band and create a geometry

        QgsMessageLog.logMessage(("In SplitRestrictionTool. getPointsCaptured, layerType: " + str(self.layer.geometryType())), tag="TOMs panel")

        # now split the restriction. (NB: THis is done at layer level



        self.layer.featureAdded.connect(self.splitFeatureAdded)
        self.layer.geometryChanged.connect(self.splitFeatureChanged)

        self.idxRestrictionID = self.origLayer.fieldNameIndex("RestrictionID")
        self.idxOpenDate = self.origLayer.fieldNameIndex("OpenDate")
        self.idxGeometryID = self.origLayer.fieldNameIndex("GeometryID")

        self.proposalsManager.TOMsSplitRestrictionSaved.connect(self.notifySplitRestrictionSaved)
        self.splitRestrictionSaved = False
        self.splitRestrictionChanged = False

        result = self.layer.splitFeatures(self.sketchPoints)

        if result <> 0:
            reply = QMessageBox.information(None, "Error",
                                            "Issue splitting feature. Status: " + str(result),
                                            QMessageBox.Ok)
            return

        # if split, need to get parts and deal with appropriately
        self.splitGeometryChanged()

    def splitFeatureAdded(self, fid):
        QgsMessageLog.logMessage("In SplitRestrictionTool. splitFeatureAdded: " + str(fid), tag="TOMs panel")
        self.layer.featureAdded.disconnect(self.splitFeatureAdded)
        # Now remove "GeometryID", "Opendate" and give the restriction a new "RestrictionID" - and add it to the proposal.

        request = QgsFeatureRequest()
        request.setFilterFid(fid)

        features = self.layer.getFeatures(request)
        # can now iterate and do fun stuff:
        for newFeatureFromSplit in features:
            #feature = newFeatureFromSplit

            #newFeatureFromSplit = QgsFeature(fid)
            #newGeometry = newFeatureFromSplit.geometry()

            newRestrictionID = str(uuid.uuid4())

            status = self.layer.changeAttributeValue(fid, self.idxRestrictionID, newRestrictionID)
            QgsMessageLog.logMessage("In SplitRestrictionTool. splitFeatureAdded(RestID): " + str(self.idxRestrictionID) + "; " + str(newRestrictionID) + " status: " + str(status), tag="TOMs panel")
            status = self.layer.changeAttributeValue(fid, self.idxOpenDate, None)
            QgsMessageLog.logMessage("In SplitRestrictionTool. splitFeatureAdded(OpenDate): " + str(self.idxOpenDate) + "; " + " status: " + str(status), tag="TOMs panel")
            QgsMessageLog.logMessage(
                "In SplitRestrictionTool:splitFeatureAdded - newGeom: " + newFeatureFromSplit.geometry().exportToWkt(),
                tag="TOMs panel")

            #self.layer.changeAttributeValue(fid, self.idxGeometryID, None)

            # update attributes
            self.updateDefaultRestrictionDetails(newFeatureFromSplit, self.origLayer, self.proposalsManager.date())

            self.addRestrictionToProposal(newRestrictionID, self.getRestrictionLayerTableID(self.origLayer),
                                      self.proposalsManager.currentProposal(),
                                      ACTION_OPEN_RESTRICTION())  # close the original feature

        self.proposalsManager.TOMsSplitRestrictionSaved.emit()

    def splitFeatureChanged(self, fid, newGeom):
        QgsMessageLog.logMessage("In SplitRestrictionTool. splitFeatureChanged: " + str(fid), tag="TOMs panel")
        self.layer.geometryChanged.disconnect(self.splitFeatureChanged)

        self.changedGeometry = QgsGeometry(newGeom)

        QgsMessageLog.logMessage("In SplitRestrictionTool. changed geometry: " + str(self.changedGeometry.exportToWkt()), tag="TOMs panel")

        # Now remove "GeometryID", "Opendate" and give the restriction a new "RestrictionID" - and add it to the proposal.
        QgsMessageLog.logMessage("In SplitRestrictionTool. notified split changed ", tag="TOMs panel")
        self.splitRestrictionChanged = True

    def notifySplitRestrictionSaved(self):
        # set flag to indicate that new restriction has been saved
        QgsMessageLog.logMessage("In SplitRestrictionTool. notified split saved ", tag="TOMs panel")
        self.splitRestrictionSaved = True

    def keyPressEvent(self, event):
        if (event.key() == Qt.Key_Backspace) or (event.key() == Qt.Key_Delete) or (event.key() == Qt.Key_Escape):
            self.undo()
            pass
        if event.key() == Qt.Key_Return or event.key() == Qt.Key_Enter:
            pass

    def splitGeometryChanged(self):
        # Added by TH to deal with RestrictionsInProposals
        QgsMessageLog.logMessage(
            "In SplitRestrictionTool:splitGeometryChanged ... ",
            tag="TOMs panel")

        currRestriction = self.origFeature.getFeature()
        currLayer = self.origLayer
        idxRestrictionID = self.layer.fieldNameIndex("RestrictionID")

        QgsMessageLog.logMessage(
            "In SplitRestrictionTool:splitGeometryChanged. currProposal: " + str(self.proposalsManager.currentProposal()),
            tag="TOMs panel")
        QgsMessageLog.logMessage("In SplitRestrictionTool:splitGeometryChanged. Layer: " + str(self.layer.name()),
                                 tag="TOMs panel")
        QgsMessageLog.logMessage(
            "In SplitRestrictionTool:splitGeometryChanged. fid: " + str(currRestriction.id()) + " GeometryID: " + str(
                currRestriction.attribute("GeometryID") + "; currRestrictionID: " + str(currRestriction[idxRestrictionID])), tag="TOMs panel")

        # When a geometry is changed; we need to check whether or not the feature is part of the current proposal

        if not self.restrictionInProposal(currRestriction[idxRestrictionID],
                                          self.getRestrictionLayerTableID(currLayer),
                                          self.proposalsManager.currentProposal()):
            QgsMessageLog.logMessage("In SplitRestrictionTool:onGeometryChanged - adding details to RestrictionsInProposal",
                                     tag="TOMs panel")
            #  This one is not in the current Proposal, so now we need to:
            #  - generate a new ID and assign it to the feature for which the geometry has changed
            #  - switch the geometries arround so that the original feature has the original geometry and the new feature has the new geometry
            #  - add the details to RestrictionsInProposal

            """newFeature = QgsFeature(self.origLayer.fields())

            newFeature.setAttributes(currRestriction.attributes())
            newRestrictionID = str(uuid.uuid4())

            newFeature[idxRestrictionID] = newRestrictionID

            idxOpenDate = self.origLayer.fieldNameIndex("OpenDate")
            idxGeometryID = self.origLayer.fieldNameIndex("GeometryID")

            newFeature[idxOpenDate] = None
            newFeature[idxGeometryID] = None"""

            while self.splitRestrictionChanged == False:
                QgsMessageLog.logMessage("In SplitRestrictionTool:onGeometryChanged - waiting for change.", tag="TOMs panel")
                time.sleep(0.1)

            changedGeometry = self.changedGeometry
            updatedRestriction = self.cloneChangeGeometry(currLayer, currRestriction, changedGeometry)

            # Now reset some of the attributes
            self.updateDefaultRestrictionDetails(updatedRestriction, currLayer, self.proposalsManager.date())

            """newFeature.setGeometry(self.changedGeometry)

            QgsMessageLog.logMessage(
                "In SplitRestrictionTool:onGeometryChanged - newGeom incoming: " + self.changedGeometry.exportToWkt(),
                tag="TOMs panel")

            # currLayer.addFeature(newFeature)
            self.layer.addFeatures([newFeature])

            QgsMessageLog.logMessage(
                "In SplitRestrictionTool:onGeometryChanged - attributes: " + str(newFeature.attributes()), tag="TOMs panel")

            QgsMessageLog.logMessage(
                "In SplitRestrictionTool:onGeometryChanged - newGeom: " + newFeature.geometry().exportToWkt(),
                tag="TOMs panel")

            originalGeomBuffer = QgsGeometry(currRestriction.geometry())
            QgsMessageLog.logMessage(
                "In SplitRestrictionTool:onGeometryChanged - originalGeom: " + originalGeomBuffer.exportToWkt(),
                tag="TOMs panel")
            self.layer.changeGeometry(currRestriction.id(), originalGeomBuffer)"""

            QgsMessageLog.logMessage("In SplitRestrictionTool:onGeometryChanged - geometries switched.", tag="TOMs panel")

            self.addRestrictionToProposal(currRestriction[idxRestrictionID],
                                          self.getRestrictionLayerTableID(currLayer),
                                          self.proposalsManager.currentProposal(),
                                          ACTION_CLOSE_RESTRICTION())  # close the original feature
            QgsMessageLog.logMessage("In SplitRestrictionTool:onGeometryChanged - feature closed.", tag="TOMs panel")

            self.addRestrictionToProposal(updatedRestriction[idxRestrictionID], self.getRestrictionLayerTableID(currLayer),
                                          self.proposalsManager.currentProposal(),
                                          ACTION_OPEN_RESTRICTION())  # open the new one
            QgsMessageLog.logMessage("In SplitRestrictionTool:onGeometryChanged - feature opened.", tag="TOMs panel")

            # self.proposalsManager.updateMapCanvas()

        else:

            # assign the changed geometry to the current feature
            # currRestriction.setGeometry(newGeometry)
            pass

        QgsMessageLog.logMessage(
            "In SplitRestrictionTool:onGeometryChanged - newGeom (2): " + currRestriction.geometry().exportToWkt(),
            tag="TOMs panel")

        # Trying to unset map tool to force updates ...
        # self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())
        currMapTool = self.iface.mapCanvas().mapTool()
        currAction = currMapTool.action()

        currMapToolAction = self.iface.mapCanvas().mapTool().action().setChecked(False)

        # Now wait for the new feature to be saved

        while self.splitRestrictionSaved == False:
            QgsMessageLog.logMessage("In SplitRestrictionTool:onGeometryChanged - waiting for save.", tag="TOMs panel")
            time.sleep(0.1)

        # .. and commit ...

        self.restrictionTransaction.commitTransactionGroup(self.layer)
        # self.restrictionTransaction.deleteTransactionGroup()

        self.origLayer.deselect(self.origFeature.getFeature().id())

        self.shutDownSplitTool()

        # **** New
        return

    def cloneChangeGeometry(self, currLayer, currRestriction, changedGeometry):

        QgsMessageLog.logMessage("In cloneChangeGeometryTool .... ", tag="TOMs panel")

        idxRestrictionID = currLayer.fieldNameIndex("RestrictionID")
        idxOpenDate = currLayer.fieldNameIndex("OpenDate")
        idxGeometryID = currLayer.fieldNameIndex("GeometryID")

        newFeature = QgsFeature(currLayer.fields())

        newFeature.setAttributes(currRestriction.attributes())
        newRestrictionID = str(uuid.uuid4())

        newFeature[idxRestrictionID] = newRestrictionID
        newFeature[idxOpenDate] = None
        newFeature[idxGeometryID] = None

        changedGeometryBuffer = changedGeometry
        newFeature.setGeometry(changedGeometryBuffer)

        QgsMessageLog.logMessage(
            "In SplitRestrictionTool:onGeometryChanged - newGeom incoming: " + self.changedGeometry.exportToWkt(),
            tag="TOMs panel")

        # currLayer.addFeature(newFeature)
        self.layer.addFeatures([newFeature])

        QgsMessageLog.logMessage(
            "In SplitRestrictionTool:onGeometryChanged - attributes: " + str(newFeature.attributes()), tag="TOMs panel")

        QgsMessageLog.logMessage(
            "In SplitRestrictionTool:onGeometryChanged - newGeom: " + newFeature.geometry().exportToWkt(),
            tag="TOMs panel")

        originalGeomBuffer = QgsGeometry(currRestriction.geometry())
        QgsMessageLog.logMessage(
            "In SplitRestrictionTool:onGeometryChanged - originalGeom: " + originalGeomBuffer.exportToWkt(),
            tag="TOMs panel")
        currLayer.changeGeometry(currRestriction.id(), originalGeomBuffer)

        QgsMessageLog.logMessage("In SplitRestrictionTool:onGeometryChanged - geometries switched.", tag="TOMs panel")

        return newFeature

    def shutDownSplitTool(self):

        QgsMessageLog.logMessage("In TOMsNodeTool:shutDownSplitTool .... ", tag="TOMs panel")

        # TODO: May need to disconnect geometryChange and featureDeleted signals
        #self.origLayer.geometryChanged.disconnect(self.on_cached_geometry_changed)
        #self.origLayer.featureDeleted.disconnect(self.on_cached_geometry_deleted)

        #self.proposalsManager.TOMsToolChanged.disconnect()

        self.proposalsManager.TOMsSplitRestrictionSaved.disconnect()

        #currAction = self.iface.mapCanvas().mapTool().action()
        #currAction.setChecked(False)

        self.proposalPanel = self.iface.mainWindow().findChild(QDockWidget, 'ProposalPanelDockWidgetBase')
        self.setupPanelTabs(self.iface, self.proposalPanel)

        #NodeTool.deactivate()

class originalFeature(object):
    def __init__(self, feature=None):
        self.savedFeature = None

    def setFeature(self, feature):
        self.savedFeature = QgsFeature(feature)
        #self.printFeature()

    def getFeature(self):
        #self.printFeature()
        return self.savedFeature

    def getGeometryID(self):
        return self.savedFeature.attribute("GeometryID")

    def printFeature(self):
        QgsMessageLog.logMessage("In TOMsNodeTool:originalFeature - attributes (fid:" + str(self.savedFeature.id()) + "): " + str(self.savedFeature.attributes()),
                                 tag="TOMs panel")
        QgsMessageLog.logMessage("In TOMsNodeTool:originalFeature - attributes: " + str(self.savedFeature.geometry().exportToWkt()),
                                 tag="TOMs panel")

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

    """class RemoveRestrictionTool(QgsMapTool, MapToolMixin):
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

        # Need to deal with situation where there is a dual (or more) restriction. Will need to have a dialog to decide which restriction to delete

        QgsMessageLog.logMessage(("In Remove - canvasReleaseEvent. Feature selected from layer: " + closestLayer.name()), tag="TOMs panel")

        closestLayer.startEditing()

        self.onRemoveRestriction(closestLayer, closestFeature)
        #self.onDisplayRestrictionDetails(feature, self.layer)"""


#############################################################################

    #class SelectVertexTool(QgsMapTool, MapToolMixin):
    """ Map tool to let user select a vertex.

        We use this to let the user select a starting or ending point for the
        shortest route calculator.
    """
    """def __init__(self, canvas, trackLayer, onVertexSelected):
        QgsMapTool.__init__(self, canvas)
        self.onVertexSelected = onVertexSelected
        self.setLayer(trackLayer)
        self.setCursor(Qt.CrossCursor)


    def canvasReleaseEvent(self, event):
        feature = self.findFeatureAt(event.pos())
        if feature != None:
            vertex = self.findVertexAt(feature, event.pos())
            if vertex != None:
                self.onVertexSelected(feature, vertex)"""

