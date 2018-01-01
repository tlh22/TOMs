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

from date_filter_dialog import dateFilterDialog

class filterOnDate():
    
    def __init__(self, iface, TOMsMenu):
        # Save reference to the QGIS interface
        self.iface = iface
        self.canvas = self.iface.mapCanvas()

        self.actionFilterOnDate = QAction("View at Date", self.iface.mainWindow())
        TOMsMenu.addAction(self.actionFilterOnDate)
        QObject.connect(self.actionFilterOnDate, SIGNAL("triggered()"), self.filterOnDate)

    def filterOnDate(self):
        """Filter main layer based on date and state options"""
        
        QgsMessageLog.logMessage("In Filter On Date", tag="TOMs panel")

        self.dlg = dateFilterDialog()

        '''
        todaysDate = time.strftime("%Y-%m-%d")
        QMessageBox.information(self.iface.mainWindow(), "debug", todaysDate)
        '''
        
        self.dlg.filterDate.setDisplayFormat("yyyy-MM-dd")        
        # self.dlg.filterDate.setDisplayFormat("dd/MM/yyyy")        
        self.dlg.filterDate.setDate(QDate.currentDate())
        self.dlg.includeTempOrders.setChecked(False)
                
        # show the dialog
        self.dlg.show()
        
        # Run the dialog event loop
        result = self.dlg.exec_()
        
        # See if OK was pressed
        if result:
            
            # Filter the display based on the details provided

            dateChoosen = self.dlg.filterDate.text()
            QgsExpressionContextUtils.setProjectVariable('ViewAtDate',dateChoosen)
            tmpOrders = self.dlg.includeTempOrders.isChecked()

            if tmpOrders:
                #tmpOrdersText = "Yes"
                tmpOrdersFilterString = 'RestrictionStatusID IN (0, 1)'
            else:
                #tmpOrdersText = "No"
                tmpOrdersFilterString = 'RestrictionStatusID IN (0, 1, 2)'

            dateChoosenFormatted = "'" + dateChoosen + "'"

            #
            #  http://gis.stackexchange.com/questions/121148/how-to-filter-qgis-layer-from-python
            #
            # Also note use of "#" is for use with Access. Filter syntax is provider dependent
            #

            # For Access
            # filterString = '"CreateDate" <= #' + dateChoosen + '# AND ("DeleteDate" > #' + dateChoosen + '#  OR "DeleteDate"  IS  NULL)' + ' AND ' + tmpOrdersFilterString

            # For Spatialite
            filterString = '"EffectiveDate" <= ' + dateChoosenFormatted + ' AND ("RescindDate" > ' + dateChoosenFormatted + '  OR "RescindDate"  IS  NULL)' + ' AND ' + tmpOrdersFilterString
            #filterString = '"ResState" = 1'

            #QMessageBox.information(self.iface.mainWindow(), "debug", dateChoosen + " " + tmpOrdersText + " " + filterString)
            QgsMessageLog.logMessage("Filter: " + filterString, tag="TOMs panel")
            # filterString = 'date("CreateDate") <= ' + date(dateChoosenFormatted) + ' AND (date("DeleteDate") > ' + date(dateChoosenFormatted) + '  OR "DeleteDate"  IS  NULL)' + ' AND ' + tmpOrdersFilterString
            # QgsMessageLog.logMessage("Filter2: " + filterString, tag="TOMs panel")

            #
            # May need to apply filter to more than one layer. Currently just for one
            #
            
            self.TOMslayer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]
	
            #
            #  http://gis.stackexchange.com/questions/121148/how-to-filter-qgis-layer-from-python
            #

            self.TOMslayer.setSubsetString(filterString)
            
            pass

