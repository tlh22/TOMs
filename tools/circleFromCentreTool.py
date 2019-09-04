# -*- coding: latin1 -*-
# Import the PyQt and QGIS libraries
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from qgis.core import *
from qgis.gui import *

# Initialize Qt resources from file resources.py
from cadtools import resources

#Import own classes and tools
from segmentfindertool import SegmentFinderTool
from lineintersection import LineIntersection
import cadutils

from circleFromCentre import CircleFromCentre

class circleFromCentreTool():
    
        def __init__(self, iface,  toolBar):
            # Save reference to the QGIS interface
            self.iface = iface
            self.canvas = self.iface.mapCanvas()
            
            # for holding the returned circle
            self.points = []
          
            # Create actions 
            self.actionCircleFromCenter = QAction(QIcon(":/plugins/rectovalDigit/icons/circlefromcenter.png"),  QCoreApplication.translate("ctools", "Circle from center"),  self.iface.mainWindow())
            self.actionCircleFromCenter.setCheckable(True)
            self.actionIntersectCircleKerb = QAction(QIcon(":/plugins/Test5Class/resources/arcintersectionpoint.png"),  QCoreApplication.translate("ctools", "Point at distance on kerb"),  self.iface.mainWindow())
            self.actionCircleFromCenter.setCheckable(True)
            
            # Connect to signals for button behaviour
            # QObject.connect(self.actionCircleFromCenter,  SIGNAL("activated()"),  self.circlefromcenterdigit)
            self.actionCircleFromCenter.activated.connect(self.circlefromcenterdigit)
            self.actionIntersectCircleKerb.activated.connect(self.doCircleIntersectKerb)
            
            # Add actions to the toolbar
            toolBar.addSeparator()
            toolBar.addAction(self.actionCircleFromCenter)
            toolBar.addAction(self.actionIntersectCircleKerb)
            #toolBar.addSeparator()
            
            # Get the tool
            self.tool = CircleFromCentre(self.canvas)
         
        def circlefromcenterdigit(self):
            mc = self.canvas
            mc.setMapTool(self.tool)
            # self.canvas.setMapTool(self.CircleFromCentre)
            self.actionCircleFromCenter.setChecked(True)
         
            # QObject.connect(self.actionCircleFromCenter, SIGNAL("rbFinished(PyQt_PyObject)"), self.createFeature)
            self.tool.circleCreated.connect(self.storeCirclePoints)

            # QgsMessageLog.logMessage(("In circleTool. signal emmitted: "), tag="TOMs panel")
            
        def storeCirclePoints(self, result):
            self.points = []
            
            i = 0
            for point in result:
                i = i + 1
                
            QgsMessageLog.logMessage(("Circle returned with : " + str(i)), tag="TOMs panel")
           
            i = 0
            for point in result:
                QgsMessageLog.logMessage(("Circle: " + str(i)), tag="TOMs panel")
                self.points.append(point)
                i = i + 1
                
            QgsMessageLog.logMessage(("Circle stored with : " + str(i)), tag="TOMs panel")
        
        def createFeature(self, result):
            # settings = QSettings()
            mc = self.canvas
            # layer = mc.currentLayer()
            
            QgsMessageLog.logMessage(("In circleTool. adding to cad layer: "), tag="TOMs panel")

            # polygon = result
            
            mc.unsetMapTool(self.tool)    
            
            self.actionCircleFromCenter.setChecked(False)
            polygon = QgsGeometry.fromPolygon([self.points])

            cadutils.addGeometryToCadLayer(polygon)

            self.unsetTool()
            self.deactivate()
            
            '''
            renderer = mc.mapRenderer()
            layerCRSSrsid = layer.crs().srsid()
            projectCRSSrsid = renderer.destinationCrs().srsid()
            provider = layer.dataProvider()
            f = QgsFeature()
            
            
            #On the Fly reprojection.
            if layerCRSSrsid != projectCRSSrsid:
                geom.transform(QgsCoordinateTransform(projectCRSSrsid, layerCRSSrsid))
                                        
            f.setGeometry(geom)
            
            # add attribute fields to feature
            fields = layer.pendingFields()

            # vector api change update

            f.initAttributes(fields.count())
            for i in range(fields.count()):
                f.setAttribute(i,provider.defaultValue(i))

            if not (settings.value("/qgis/digitizing/disable_enter_attribute_values_dialog")):
                self.iface.openFeatureForm( layer, f, False)
            
            layer.beginEditCommand("Feature added")       
            layer.addFeature(f)
            layer.endEditCommand()
            '''

        def unsetTool(self):
            mc = self.canvas
            mc.unsetMapTool(self.tool)                                                                    
            self.actionCircleFromCenter.setChecked(False)
            
        def deactivate(self):
            # self.p11 = None
            # self.p12 = None
            # self.p21 = None
            # self.p22 = None
            
            #uncheck the button/menu and get rid off the SFtool signal
            self.actionCircleFromCenter.setChecked(False)
            '''
            try:
                self.tool.segmentsFound.disconnect(self.storeSegmentPoints)
            except TypeError:
                pass
            '''
            
        def doCircleIntersectKerb (self):
            mc = self.canvas
            self.tool = intersectCircleKerb(self.canvas)
            mc.setMapTool(self.tool)
            # self.canvas.setMapTool(self.CircleFromCentre)
            self.actionIntersectCircleKerb.setChecked(True)
         
            # QObject.connect(self.actionCircleFromCenter, SIGNAL("rbFinished(PyQt_PyObject)"), self.createFeature)
            self.tool.circleCreated.connect(self.createFeature)

            QgsMessageLog.logMessage(("In circleTool. signal emmitted: "), tag="TOMs panel")
            
