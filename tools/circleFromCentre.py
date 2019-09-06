# Rectangles Ovals Digitizing
# Copyright (C) 2011 - 2012 Pavol Kapusta
# pavol.kapusta@gmail.com

# List comprehensions in canvasMoveEvent functions are 
# adapted from Benjamin Bohard`s part of rectovaldiams plugin.

from qgis.PyQt.QtCore import *
from qgis.PyQt.QtGui import *
from qgis.core import *
from qgis.gui import *
import math

from distance_dialog import *
from ..mapTools import *

# Tool class
class CircleFromCentre(QgsMapTool):

    circleCreated = pyqtSignal(object)
  
    def __init__(self, canvas):
        QgsMapTool.__init__(self,canvas)
        self.canvas=canvas
        self.rb = None
        self.xc = None
        self.yc = None
        self.mCtrl = None
        self.points = []
       
        #our own fancy cursor
        self.cursor = QCursor(QPixmap(["16 16 3 1",
                                       "      c None",
                                       ".     c #FF0000",
                                       "+     c #800080",
                                       "                ",
                                       "       +.+      ",
                                       "      ++.++     ",
                                       "     +.....+    ",
                                       "    +.  .  .+   ",
                                       "   +.   .   .+  ",
                                       "  +.    .    .+ ",
                                       " ++.    .    .++",
                                       " ... ...+... ...",
                                       " ++.    .    .++",
                                       "  +.    .    .+ ",
                                       "   +.   .   .+  ",
                                       "   ++.  .  .+   ",
                                       "    ++.....+    ",
                                       "      ++.++     ",
                                       "       +.+      "]))
                                  
 
    def keyPressEvent(self,  event):
        if event.key() == Qt.Key_Control:
            self.mCtrl = True


    def keyReleaseEvent(self,  event):
        if event.key() == Qt.Key_Control:
            self.mCtrl = False
    
    # def canvasPressEvent(self,event):
    # Clear the rubber band
    # self.rb.reset()
        
    def canvasReleaseEvent(self,event):
        #QMessageBox.information(None, "Info", "canvasReleaseEvent 1")

        # Return point under cursor  
        # feature = self.findFeatureAt(event.pos())
        
        QgsMessageLog.logMessage(("In canvasReleaseEvent. Circle"), tag="TOMs panel")

        # if feature == None:
        #     return

        # QgsMessageLog.logMessage(("In canvasReleaseEvent. Feature selected"), tag="TOMs panel")

        layer = self.canvas.currentLayer()
        # TH: Set stroke and fill colour to improve things a bit
        fillcolor = QColor(0,0,0,0)
        strokecolor = QColor(255,0,0)
        self.rb = QgsRubberBand(self.canvas, False) # TH:True = polygon
        self.rb.setColor(strokecolor)
        self.rb.setFillColor(fillcolor)
        self.rb.setWidth(1)
        
        x = event.pos().x()
        y = event.pos().y()

        if self.mCtrl:
            startingPoint = QPoint(x,y)
            snapper = QgsMapCanvasSnapper(self.canvas)
            (retval,result) = snapper.snapToCurrentLayer (startingPoint, QgsSnapper.SnapToVertex)
            if result != []:
                point = result[0].snappedVertex
            else:
                (retval,result) = snapper.snapToBackgroundLayers(startingPoint)
                if result != []:
                    point = result[0].snappedVertex
                else:
                    point = self.toLayerCoordinates(layer,event.pos())
        else:
            point = self.toLayerCoordinates(layer,event.pos())    
            
        pointMap = self.toMapCoordinates(layer, point)
        self.xc = pointMap.x()
        self.yc = pointMap.y()

        # Now get the distance to check
        self.dlg = distanceDialog()
        # self.dlg.le_Distance.setInputMask("00.0")
        # show the dialog
        self.dlg.show()
        
        result = self.dlg.exec_()
        
        Polygon = None
        
        # See if OK was pressed
        if result:
        
            radius = float(self.dlg.le_Distance.text())
            # Now convert to map units (I think)
            QgsMessageLog.logMessage(("In canvasReleaseEvent. Radius: " + str(radius) + ": " + str(radius - 1) + " pt: "+ str(self.xc) + ": " + str(self.yc)), tag="TOMs panel")
            
            self.rb.reset(True)
            
            settings = QSettings()
            segments = settings.value("/RectOvalDigit/segments",36,type=int)  # TH: not sure what this is !!!!! ?????
            
            # See http://gis.stackexchange.com/questions/64596/how-to-draw-a-circle-of-fixed-radius-in-qgis-using-qgsmapcanvasitem
            
            # ctx = self.canvas.mapRenderer().rendererContext()
            # as mm (converted to map pixels, then to map units)
            # radius *= ctx.scaleFactor() * ctx.mapToPixel().mapUnitsPerPixel()   

            QgsMessageLog.logMessage(("In canvasReleaseEvent. Radius 2 segments: " + str(segments)), tag="TOMs panel")
            
            seg = QgsFeature()
            lastpoint = QgsPoint()
            
            self.points = []
            for i in range(segments):
                theta = i * (2 * math.pi / segments)
                p = QgsPoint(self.xc + radius * math.cos(theta),
                             self.yc + radius * math.sin(theta))

                self.points.append(p)

                self.rb.addPoint(p)

                if i > 0:
                    QgsMessageLog.logMessage(("In createCircle. i: " + str(i) + " pt: "+ str(self.points[i].x()) + ": " + str(self.points[i].y())), tag="TOMs panel")
                    seg.setGeometry(QgsGeometry.fromPolyline([lastpoint, self.points[i]]))
                    # self.rb.setToGeometry(QgsGeometry.fromPolyline([lastpoint, points[i]]), None)
                lastPoint = self.points[i]
                QgsMessageLog.logMessage(("In createCircle. Lastpt: "+ str(lastPoint.x()) + ": " + str(lastPoint.y())), tag="TOMs panel")

            # complete the shapes
            self.rb.addPoint(self.points[0])
            self.points.append(self.points[0])
            seg.setGeometry(QgsGeometry.fromPolyline([lastpoint, self.points[0]]))

            # new feature: line from line_end to newpoint
            # seg = QgsFeature()
            # seg.setGeometry(QgsGeometry.fromPolyline([line_end, newpoint]))
            
            polygon = QgsGeometry.fromPolygonXY([self.points])

            # QMessageBox.information(None, "Info", "circle created ...")

            # self.rb.setToGeometry(QgsGeometry.fromPolyline(seg), None)
            # self.rb.show()  
           
        # else:
        # return
            
        # if self.rb:return
        QgsMessageLog.logMessage(("In circleFrom. Emitting signal: "), tag="TOMs panel")
        # self.emit(SIGNAL("rbFinished(PyQt_PyObject)"), polygon)
        # self.rbFinished.emit([points])
        self.circleCreated.emit(self.points)
         
        
    def canvasMoveEvent(self,event):
        '''
        settings = QSettings()
        if not self.rb:return
        currpoint = self.toMapCoordinates(event.pos())
        currx = currpoint.x()
        curry = currpoint.y()
        r = math.sqrt(pow(abs( currx - self.xc),2) + pow(abs( curry - self.yc),2))
        self.rb.reset(True)
        segments = settings.value("/RectOvalDigit/segments",36,type=int)
        points = []
        for t in [(2*math.pi)/segments*i for i in range(segments)]:
            points.append((r*math.cos(t), r*math.sin(t)))
        polygon = [QgsPoint(i[0]+self.xc,i[1]+self.yc) for i in points]
        '''
        pass
        #delete [self.rb.addPoint( point ) for point in polygon]

        '''def canvasReleaseEvent(self,event):
            if not self.rb:return        
            if self.rb.numberOfVertices() > 2:
                geom = self.rb.asGeometry()
                self.emit(SIGNAL("rbFinished(PyQt_PyObject)"), geom)
                
            self.rb.reset(True)
            self.rb=None
            
            self.canvas.refresh()
        '''
    
    def showSettingsWarning(self):
        pass
    
    def activate(self):
        #QMessageBox.information(self.iface.mainWindow(), "Info", "Activate 1")
        #self.canvas.setCursor(self.cursor)
        pass
        
    def deactivate(self):
        #QMessageBox.information(self.iface.mainWindow(), "Info", "deActive 1")
        #self.rb.reset()
        pass

    def isZoomTool(self):
        return False
  
    def isTransient(self):
        return False
    
    def isEditTool(self):
        return True
