# -*- coding: latin1 -*-
# Import the PyQt and QGIS libraries
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *

# Initialize Qt resources from file resources.py
# from cadtools import resources

#Import own classes and tools
# from segmentfindertool import SegmentFinderTool
# from lineintersection import LineIntersection
# import cadutils
# Import the code for the dialog

from test5_module_dialog import Test5ClassDialog

class manageRestrictionTypes():
    
        def __init__(self, iface, TOMsMenu):
            # Save reference to the QGIS interface
            self.iface = iface
            self.canvas = self.iface.mapCanvas()

            self.actionManageRestrictions = QAction("Manage Restrictions", self.iface.mainWindow())
            TOMsMenu.addAction(self.actionManageRestrictions)
            self.actionManageRestrictions.triggered.connect(self.run)
            '''          
            # Create actions 
            self.act_intersection= QAction(QIcon(":/plugins/cadtools/icons/pointandline.png"),  QCoreApplication.translate("ctools", "Intersection Point"),  self.iface.mainWindow())
            self.act_s2s= QAction(QIcon(":/plugins/cadtools/icons/select2lines.png"),  QCoreApplication.translate("ctools", "Select 2 Line Segments"),  self.iface.mainWindow())
            self.act_s2s.setCheckable(True)            
            
            # Connect to signals for button behaviour
            self.act_s2s.triggered.connect(self.s2s)
            self.act_intersection.triggered.connect(self.intersection)
            self.canvas.mapToolSet.connect(self.deactivate)
            
            # Add actions to the toolbar
            toolBar.addAction(self.act_s2s)
            toolBar.addAction(self.act_intersection)
            #toolBar.addSeparator()
            
            # Get the tool
            self.tool = SegmentFinderTool(self.canvas)
            '''

        def run(self):
            """Run method that performs all the real work"""
        
            QgsMessageLog.logMessage("In Action 1", tag="TOMs panel")

            self.dlg = Test5ClassDialog()

            # show the dialog
            self.dlg.show()
        
            # Run the dialog event loop
            result = self.dlg.exec_()
        
            # See if OK was pressed
            if result:
                # Do something useful here - delete the line containing pass and
                # substitute with your code.
                pass
