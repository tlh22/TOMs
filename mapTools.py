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

        self.RestrictionLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers2")[0]

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

        QgsMessageLog.logMessage("In findNearestFeatureAt: shortestDistance: " + str(shortestDistance),
                                     tag="TOMs panel")

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

        QgsMessageLog.logMessage(("In Create - init. Curr layer is " + str(self.currLayer) + "Incoming: " + str(self.layer)), tag="TOMs panel")

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
            QgsMessageLog.logMessage("In setRoadName: nrPts = " + str(nrPts), tag="TOMs panel")

            secondPt = line[
                1]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

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
        def checkDegrees(Az):

            newAz = Az

            if Az >= float(360):
                newAz = Az - float(360)
            elif Az < float(0):
                newAz = Az + float(360)

            QgsMessageLog.logMessage("In checkDegrees: newAz: " + str(newAz), tag="TOMs panel")

            return newAz

        @staticmethod
        def setAzimuthToRoadCentreLine(feature):

            # now set the attribute
            feature.setAttribute("AzimuthToRoadCentreLine", int(RestrictionTypeUtils.calculateAzimuthToRoadCentreLine(feature)))

        @staticmethod
        def calculateAzimuthToRoadCentreLine(feature):
            # find the shortest line from this point to the road centre line layer
            # http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/ - generates "closest feature" function

            QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper):", tag="TOMs panel")

            RoadCentreLineLayer = QgsMapLayerRegistry.instance().mapLayersByName("RoadCentreLine")[0]

            # take the a point from the geometry
            line = feature.geometry().asPolyline()

            testPt = line[
                1]  # choose second point to (try to) move away from any "ends" (may be best to get midPoint ...)

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

                Az = RestrictionTypeUtils.checkDegrees(testPt.azimuth(startPt))
                QgsMessageLog.logMessage("In setAzimuthToRoadCentreLine: Az: " + str(Az), tag="TOMs panel")

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

            RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers2")[0]

            idxRestrictionsLayerName = RestrictionsLayers.fieldNameIndex("RestrictionLayerName")

            currRestrictionsTableName = currRestrictionTableRecord[idxRestrictionsLayerName]

            RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionsTableName)[0]

            return RestrictionsLayers

        @staticmethod
        def getRestrictionLayerTableID(currRestLayer):
            QgsMessageLog.logMessage("In getRestrictionLayerTableID.", tag="TOMs panel")
            # find the ID for the layer within the table "

            RestrictionsLayers2 = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers2")[0]

            layersTableID = 0

            # not sure if there is better way to search for something, .e.g., using SQL ??

            for layer in RestrictionsLayers2.getFeatures():
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

