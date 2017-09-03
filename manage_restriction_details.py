# -*- coding: latin1 -*-
# Import the PyQt and QGIS libraries
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *
from qgis.gui import *

# Initialize Qt resources from file resources.py
# from cadtools import resources

#Import own classes and tools
# from segmentfindertool import SegmentFinderTool
# from lineintersection import LineIntersection
# import cadutils
# Import the code for the dialog

import time
import datetime

from restrictionDetails_dialog import restrictionDetailsDialog
from mapTools import *
from TOMsUtils import *
from constants import *

class manageRestrictionDetails():
    
    def __init__(self, iface, TOMsToolbar):
        # Save reference to the QGIS interface
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        '''
        self.actionFilterOnDate = QAction("View at Date", self.iface.mainWindow())
        TOMsMenu.addAction(self.actionFilterOnDate)
        QObject.connect(self.actionFilterOnDate, SIGNAL("triggered()"), self.filterOnDate)
        '''
        # Create actions 
        self.actionRestrictionDetails = QAction(QIcon(":/plugins/Test5Class/resources/mActionGetInfo.svg"),
                               QCoreApplication.translate("MyPlugin", "Select"),
                               self.iface.mainWindow())
        self.actionRestrictionDetails.setCheckable(True)

        self.actionCreateRestriction = QAction(QIcon(":/plugins/Test5Class/resources/mActionAddTrack.svg"),
                               QCoreApplication.translate("MyPlugin", "Create"),
                               self.iface.mainWindow())
        self.actionCreateRestriction.setCheckable(True)

        self.actionRemoveRestriction = QAction(QIcon(":/plugins/Test5Class/resources/mActionDeleteTrack.svg"),
                               QCoreApplication.translate("MyPlugin", "Remove"),
                               self.iface.mainWindow())
        self.actionRemoveRestriction.setCheckable(True)

        self.actionEditRestriction = QAction(QIcon(":/plugins/Test5Class/resources/mActionEdit.svg"),
                               QCoreApplication.translate("MyPlugin", "Edit"),
                               self.iface.mainWindow())
        self.actionEditRestriction.setCheckable(True)

        # Add actions to the toolbar
        TOMsToolbar.addAction(self.actionRestrictionDetails)
        TOMsToolbar.addAction(self.actionCreateRestriction)
        TOMsToolbar.addAction(self.actionRemoveRestriction)
        TOMsToolbar.addAction(self.actionEditRestriction)

        # Connect action signals to slots
        self.actionRestrictionDetails.triggered.connect(self.doRestrictionDetails)
        self.actionCreateRestriction.triggered.connect(self.doCreateRestriction)
        self.actionRemoveRestriction.triggered.connect(self.doRemoveRestriction)
        self.actionEditRestriction.triggered.connect(self.doEditRestriction)
        
        # Not sure how to organise scope for layer names ... this seems to work
        # setupLayers(self)
        # setupTOMsLayerFields(self)
        
    def setupRenderers(self):
        """ Create our map renderers.
        """
        # Create a renderer to show the restrictions.

        root_rule = QgsRuleBasedRendererV2.Rule(None)

        symbol = QgsLineSymbolV2.createSimple({'color' : "black"})
        rule = QgsRuleBasedRendererV2.Rule(symbol, elseRule=True)
        root_rule.appendChild(rule)

        renderer = QgsRuleBasedRendererV2(root_rule)

        self.trackLayer.setRendererV2(renderer)

        # Create a renderer to show the start point.

        symbol = QgsMarkerSymbolV2.createSimple({'color' : "green"})
        symbol.setSize(POINT_SIZE)
        symbol.setOutputUnit(QgsSymbolV2.MapUnit)
        renderer = QgsSingleSymbolRendererV2(symbol)
        self.startPointLayer.setRendererV2(renderer)

        # Create a renderer to show the end point.

        symbol = QgsMarkerSymbolV2.createSimple({'color' : "red"})
        symbol.setSize(POINT_SIZE)
        symbol.setOutputUnit(QgsSymbolV2.MapUnit)
        renderer = QgsSingleSymbolRendererV2(symbol)
        self.endPointLayer.setRendererV2(renderer)


    def setupMapTools(self):
        self.CreateRestrictionTool = CreateRestrictionTool(self.mapCanvas,
                                         self.trackLayer,
                                         self.onRestrictionAdded)
        self.CreateRestrictionTool.setAction(self.actionCreateRestiction)

        self.EditRestrictionTool = EditRestrictionTool(self.mapCanvas,
                                           self.trackLayer,
                                           self.onRestrictionEdited)
        self.EditRestrictionTool.setAction(self.actionEditRestriction)

        self.RemoveRestrictionTool = RemoveRestrictionTool(self.mapCanvas,
                                               self.trackLayer,
                                               self.onRestrictionRemoved)
        self.RemoveRestrictionTool.setAction(self.actionRemoveRestriction)

        '''
        self.mapTool = GeometryInfoMapTool(self.iface, self.TOMslayer, self.onDisplayRestrictionDetails)
        self.mapTool.setAction(self.actionRestrictionDetails)
        self.iface.mapCanvas().setMapTool(self.mapTool)
        '''

        '''
        self.getInfoTool = GetInfoTool(self.mapCanvas,
                                       self.trackLayer,
                                       self.onGetInfo)
        self.getInfoTool.setAction(self.actionGetInfo)

        self.selectStartPointTool = SelectVertexTool(self.mapCanvas,
                                                     self.trackLayer,
                                                     self.onStartPointSelected)

        self.selectEndPointTool = SelectVertexTool(self.mapCanvas,
                                                   self.trackLayer,
                                                   self.onEndPointSelected)

        '''

    def doRestrictionDetails(self):
        """ Select point and then display details
		"""
        
        QgsMessageLog.logMessage("In doRestrictionDetails", tag="TOMs panel")
        
        if not self.actionRestrictionDetails.isChecked():
            self.iface.mapCanvas().unsetMapTool(self.mapTool)
            self.mapTool = None
            return

        self.actionRestrictionDetails.setChecked(True)

		# Define the layer as a QgsVectorLayer (rather than a dataProvider layer). This means that need to use transactions rather than auto commit
        TOMslayer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]

        self.mapTool = GeometryInfoMapTool(self.iface, self.TOMslayer, self.onDisplayRestrictionDetails)
        self.mapTool.setAction(self.actionRestrictionDetails)
        self.iface.mapCanvas().setMapTool(self.mapTool)

    def onDisplayRestrictionDetails(self, selectedFeature):
        """ Called by map tool when a restriction is selected
        """

        # May need to know the layer that the feature is on

        if QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer"):
            TOMsLayer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table TOMs_Layer is not present"))
            raise LayerNotPresent

        if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionTypes"):
            self.RestrictionTypesLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionTypes")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table RestrictionTypes is not present"))
            raise LayerNotPresent

        if QgsMapLayerRegistry.instance().mapLayersByName("TimePeriods"):
            self.TimePeriodsLayer = QgsMapLayerRegistry.instance().mapLayersByName("TimePeriods")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table TimePeriods is not present"))
            raise LayerNotPresent

        if QgsMapLayerRegistry.instance().mapLayersByName("LengthOfTime"):
            self.LengthOfTimeLayer = QgsMapLayerRegistry.instance().mapLayersByName("LengthOfTime")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table LengthOfTime is not present"))
            raise LayerNotPresent

        if QgsMapLayerRegistry.instance().mapLayersByName("PaymentTypes"):
            self.PaymentTypesLayer = QgsMapLayerRegistry.instance().mapLayersByName("PaymentTypes")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table PaymentTypes is not present"))
            raise LayerNotPresent

        if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionGeometryTypes"):
            self.RestrictionGeometryTypesLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionGeometryTypes")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table RestrictionGeometryTypes is not present"))
            raise LayerNotPresent

        if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionStatus"):
            self.ResStateLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionStatus")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table RestrictionStatus is not present"))
            raise LayerNotPresent
        
        # Set up field details for table  ** what about errors here **
        idxGeometryID = TOMsLayer.fieldNameIndex("GeometryID")
        idxRestrictionTypeID = TOMsLayer.fieldNameIndex("RestrictionTypeID")
        idxTimePeriodID = TOMsLayer.fieldNameIndex("TimePeriodID")
        idxMaxStayID = TOMsLayer.fieldNameIndex("MaxStayID")
        idxNoReturnID = TOMsLayer.fieldNameIndex("NoReturnID")
        idxPaymentTypeID = TOMsLayer.fieldNameIndex("PayTypeID")

        idxRescindDate = TOMsLayer.fieldNameIndex("RescindDate")
        idxEffectiveDate = TOMsLayer.fieldNameIndex("EffectiveDate")
        idxRestrictionStatusID = TOMsLayer.fieldNameIndex("RestrictionStatusID")

        idxRoadName = TOMsLayer.fieldNameIndex("RoadName")
        idxUSRN = TOMsLayer.fieldNameIndex("USRN")
        idxGeomTypeID = TOMsLayer.fieldNameIndex("GeomTypeID")
        idxOrientation = TOMsLayer.fieldNameIndex("Orientation")
        idxAzimuthToRoadCentreline = TOMsLayer.fieldNameIndex("AzimuthToRoadCentreline")

        idxChangeNotes = TOMsLayer.fieldNameIndex("ChangeNotes")
        idxChangeDate = TOMsLayer.fieldNameIndex("ChangeDate")
        
        # Now find the GeometryID
        # idx_GeometryID = self.TOMslayer.fieldNameIndex('GeometryID')
        featureGeometryID = selectedFeature.attributes()[idxGeometryID]
        if featureGeometryID == NULL:
            currGeometryID = ""
            currLength = 0  # Will need to check how to calculate from geometry ... ******
        else:
            currGeometryID = featureGeometryID

        # QMessageBox.information(self.iface.mainWindow(),
        #                             "Geometry Info",
        #                             "GeometryID: " + GeometryID)
		
        QgsMessageLog.logMessage(("Start onDisplayRestrictionDetails. currGeometryID: " + currGeometryID), tag="TOMs panel")            
		
        self.dlg = restrictionDetailsDialog()
		
        # set up any details for the form title
        #viewAtDate = QgsExpressionContextUtils.projectScope().variable('ViewAtDate')
        #currDate = datetime.datetime.now().strftime("%Y-%m-%d")

        # show the dialog
        self.dlg.show()

        #self.dlg.l_ViewAtDate.setText(viewAtDate)

        # Prepare the comboBoxes. Probably a better way .... but this will do for the moment

        for type in self.RestrictionTypesLayer.getFeatures():
            nextType = type.attribute("Description")
            self.dlg.cb_restrictionTypes.addItem( nextType )

        for type in self.TimePeriodsLayer.getFeatures():
            nextType = type.attribute("Description")
            self.dlg.cb_timePeriods.addItem( nextType )

        for type in self.LengthOfTimeLayer.getFeatures():
            nextType = type.attribute("Description")
            self.dlg.cb_maxStayPeriod.addItem( nextType )
            self.dlg.cb_noReturnPeriod.addItem( nextType )

        for type in self.PaymentTypesLayer.getFeatures():
            nextType = type.attribute("Description")
            self.dlg.cb_paymentType.addItem( nextType )

        for type in self.RestrictionGeometryTypesLayer.getFeatures():
            nextType = type.attribute("Description")
            self.dlg.cb_geometryType.addItem( nextType )

        for type in self.ResStateLayer.getFeatures():
            nextType = type.attribute("Description")
            self.dlg.cb_restrictionStatus.addItem( nextType )

        # Populate the form. Assume that the details rquired are contained in the current view - and that there is only one record for a geometry

        '''
        for restriction in self.TOMslayer.getFeatures():
            GeometryID = restriction.attribute("GeometryID")

            if GeometryID == currGeometryID:
        '''
        # Keep track of the current record
        currRestrictionID = selectedFeature.id()
        self._geom_buffer = QgsGeometry(selectedFeature.geometry())

        featureChanged = False

        # Prepare variables for form
        
        if featureGeometryID == NULL:
        
            currRestrictionTypeID = -1
            currTimePeriodID = -1
            currMaxStayID = -1
            currNoReturnID = -1
            currPaymentTypeID = -1
            currRestrictionStatusID = -1

            currEffectiveDate = currDate
            currRescindDate = NULL

            currRoadName = selectedFeature.attribute("RoadName")
            currUSRN = selectedFeature.attribute("USRN")
            currRestrictionGeometryTypeID = -1
            currOrientation = NULL
            currAzimuthToRoadCentreLine = selectedFeature.attribute("AzimuthToRoadCentreLine")

            featureChanged = True
            
        else:

            currLength = selectedFeature.attribute("Length")
            currRestrictionTypeID = selectedFeature.attribute("RestrictionTypeID")
            currTimePeriodID = selectedFeature.attribute("TimePeriodID")
            currMaxStayID = selectedFeature.attribute("MaxStayID")
            currNoReturnID = selectedFeature.attribute("NoReturnID")
            currPaymentTypeID = selectedFeature.attribute("PayTypeID")
            currRestrictionStatusID = selectedFeature.attribute("RestrictionStatusID")

            currEffectiveDate = selectedFeature.attribute("EffectiveDate")
            currRescindDate = selectedFeature.attribute("RescindDate")

            currRoadName = selectedFeature.attribute("RoadName")
            currUSRN = selectedFeature.attribute("USRN")
            currRestrictionGeometryTypeID = selectedFeature.attribute("GeomTypeID")
            currOrientation = selectedFeature.attribute("Orientation")
            currAzimuthToRoadCentreLine = selectedFeature.attribute("AzimuthToRoadCentreLine")

        # Populate the form using the existing features - or else set to blank - and then write to string for inclusion in history
        
        self.dlg.GeometryID.setText(currGeometryID)
        self.dlg.Length.setText(str(currLength))

        self.dlg.cb_restrictionTypes.setCurrentIndex(currRestrictionTypeID)
        self.dlg.cb_timePeriods.setCurrentIndex(currTimePeriodID)
        self.dlg.cb_maxStayPeriod.setCurrentIndex(currMaxStayID)
        self.dlg.cb_noReturnPeriod.setCurrentIndex(currNoReturnID)
        self.dlg.cb_paymentType.setCurrentIndex(currPaymentTypeID)
        self.dlg.cb_restrictionStatus.setCurrentIndex(currRestrictionStatusID)

        self.dlg.effectiveDate.setDisplayFormat("yyyy-MM-dd")
        self.dlg.effectiveDate.setDate(datetime.datetime.strptime(str(currEffectiveDate), '%Y-%m-%d'))
        self.dlg.rescindDate.setDisplayFormat("yyyy-MM-dd")        
        if currRescindDate != NULL:
            self.dlg.rescindDate.setDate(datetime.datetime.strptime(str(currRescindDate), '%Y-%m-%d'))

        self.dlg.txt_RoadName.setText(str(currRoadName))
        self.dlg.txt_USRN.setText(str(currUSRN))

        self.dlg.cb_geometryType.setCurrentIndex(currRestrictionGeometryTypeID)
        self.dlg.txt_Orientation.setText(str(currOrientation))
        self.dlg.txt_AzimuthToRoadCentreLine.setText(str(currAzimuthToRoadCentreLine))

        # If there is an existing record, generate a string with the details for inclusion in history  

        if featureGeometryID != NULL:
            strHistory = "GeometryID: " + currGeometryID
            self.generateHistoryString(strHistory, "Restriction type", str(self.dlg.cb_restrictionTypes.currentText()))
            self.generateHistoryString(strHistory, "Time Period", str(self.dlg.cb_timePeriods.currentText()))
            self.generateHistoryString(strHistory, "Max Stay", str(self.dlg.cb_maxStayPeriod.currentText()))
            self.generateHistoryString(strHistory, "No Return", str(self.dlg.cb_noReturnPeriod.currentText()))
            self.generateHistoryString(strHistory, "Payment type", str(self.dlg.cb_paymentType.currentText()))

            self.generateHistoryString(strHistory, "Effective Date", str(self.dlg.effectiveDate.text()))
            self.generateHistoryString(strHistory, "Rescind Date", str(self.dlg.rescindDate.text()))
            self.generateHistoryString(strHistory, "Restriction status", str(self.dlg.cb_restrictionStatus.currentText()))

            self.generateHistoryString(strHistory, "Geometry type", str(self.dlg.cb_geometryType.currentText()))
            self.generateHistoryString(strHistory, "Orientation", str(self.dlg.txt_Orientation.text()))
            self.generateHistoryString(strHistory, "Azimuth to Road Centre Line",
                                       str(self.dlg.txt_AzimuthToRoadCentreLine.text()))

        else:
            strHistory = "Initial creation."
                        
        QgsMessageLog.logMessage(("In onDisplayRestrictionDetails. Waiting for changes to form:" + strHistory), tag="TOMs panel")

        # Would be useful to check the restriction type and set fields to read only as appropriate. Perhaps set up a signal to see if it changes ...
        self.dlg.cb_restrictionTypes.currentIndexChanged.connect(self.checkRestrictionType)        
        
        result = self.dlg.exec_()
        
        # See if OK was pressed
        if result:

            QgsMessageLog.logMessage(("In onDisplayRestrictionDetails. OK Pressed. "), tag="TOMs panel")
            # Check to see if any changes have been made. Should be possible to use signals that indicate when index is changed
            newRestrictionTypeID = self.dlg.cb_restrictionTypes.currentIndex()
            if currRestrictionTypeID != newRestrictionTypeID:
                featureChanged = True
                #strHistory = strHistory + " Restriction type: " + str(self.dlg.cb_restrictionTypes.currentText())
                
            newTimePeriodID = self.dlg.cb_timePeriods.currentIndex()
            if currTimePeriodID != newTimePeriodID:
                featureChanged = True
                #strHistory = strHistory + " New time period: " + str(self.dlg.cb_timePeriods.currentText())
                
            newMaxStayID = self.dlg.cb_maxStayPeriod.currentIndex()
            if currMaxStayID != newMaxStayID:
                featureChanged = True
                #strHistory = strHistory + " Max stay period: " + str(self.dlg.cb_maxStayPeriod.currentText())
                
            newNoReturnID = self.dlg.cb_noReturnPeriod.currentIndex()
            if currNoReturnID != newNoReturnID:
                featureChanged = True
                #strHistory = strHistory + " No Return period: " + str(self.dlg.cb_noReturnPeriod.currentText())
               
            newPaymentTypeID = self.dlg.cb_paymentType.currentIndex()
            if currPaymentTypeID != newPaymentTypeID:
                featureChanged = True
                #strHistory = strHistory + " Payment type: " + str(self.dlg.cb_paymentType.currentText())

            # will need to check this as Road Name and USRN are already set ...

            newRoadName = self.dlg.txt_RoadName.text()
            if currRoadName != newRoadName:
                featureChanged = True
                #strHistory = strHistory + " Road Name: " + str(self.dlg.txt_RoadName.text())

            newUSRN = self.dlg.txt_USRN.text()
            if currUSRN != newUSRN:
                featureChanged = True
                #strHistory = strHistory + " USRN: " + str(self.dlg.txt_USRN.text())

            newRestrictionGeometryTypeID = self.dlg.cb_geometryType.currentIndex()
            if currRestrictionGeometryTypeID != newRestrictionGeometryTypeID:
                featureChanged = True
                #strHistory = strHistory + " Restriction Geometry type: " + str(self.dlg.cb_geometryType.currentText())

            newOrientation = str(self.dlg.txt_Orientation.text())
            if currOrientation != newOrientation:
                featureChanged = True
                #strHistory = strHistory + " Orientation: " + str(self.dlg.txt_Orientation.text())
               
            newAzimuthToRoadCentreLine = str(self.dlg.txt_AzimuthToRoadCentreLine.text())
            if currAzimuthToRoadCentreLine != newAzimuthToRoadCentreLine:
                featureChanged = True
                #strHistory = strHistory + " Azimuth to CL: " + str(self.dlg.txt_AzimuthToRoadCentreLine.text())
                
            """newEffectiveDate = str(self.dlg.effectiveDate.text())
            if currEffectiveDate != newEffectiveDate:
                featureChanged = True
                strHistory = strHistory + " Effective date: " + str(self.dlg.effectiveDate.text())

            newRescindDate = str(self.dlg.rescindDate.text())
            if currRescindDate != newRescindDate:
                featureChanged = True
                strHistory = strHistory + " Rescind date: " + str(self.dlg.rescindDate.text())

            newRestrictionStatusID = self.dlg.cb_restrictionStatus.currentIndex()
            if currRestrictionStatusID != newRestrictionStatusID:
                featureChanged = True
                strHistory = strHistory + " Restriction Status: " + str(self.dlg.cb_restrictionStatus.currentText())"""

            # Store the new details  ** need to sort out error handling **
            QgsMessageLog.logMessage(("In onDisplayRestrictionDetails. OK Pressed. " + strHistory), tag="TOMs panel")

            if featureChanged == True:
                #QMessageBox.information(self.iface.mainWindow(), "debug", dateChoosen + " " + tmpOrdersText + " " + filterString)
                #reply = QMessageBox.question(self.iface.mainWindow(), "Confirm", "Save changes to layer?",
                #QMessageBox.Yes | QMessageBox.No, QMessageBox.Yes)
                
                #if reply == QMessageBox.Yes:
                
                # Need to check whether or not the restriction already exists within the table RestrictionsInProposals

                """if restrictionInCurrentProposal(currRestrictionID, currLayerID, currProposalID):
                    # simply make changes to the current restriction in the current layer
                else:
                    # need to:
                    #    - enter the restriction into the table RestrictionInProposals, and 
                    #    - make a copy of the restriction in the current layer (with the new details)
                """
                
                if featureGeometryID != NULL:
                    newRestriction = QgsFeature(self.TOMslayer.fields())
                    self._geom_buffer = QgsGeometry(selectedFeature.geometry())
                    newRestriction.setGeometry(QgsGeometry(self._geom_buffer))
                else:
                    newRestriction = selectedFeature

                # Ensure that default values are placed into fields    default status is proposed (rather than -1)

                if newTimePeriodID < 0:
                    newTimePeriodID = -1
                if newMaxStayID < 0:
                    newMaxStayID = -1
                if newNoReturnID < 0:
                    newNoReturnID = -1

                if newRestrictionStatusID < 0:
                    newRestrictionStatusID = 0

                newRestriction[idxGeometryID] = currGeometryID
                newRestriction[idxRestrictionTypeID] = newRestrictionTypeID
                newRestriction[idxTimePeriodID] = newTimePeriodID
                newRestriction[idxMaxStayID] = newMaxStayID
                newRestriction[idxNoReturnID] = newNoReturnID
                newRestriction[idxPaymentTypeID] = newPaymentTypeID

                newRestriction[idxRestrictionStatusID] = newRestrictionStatusID
                newRestriction[idxEffectiveDate] = newEffectiveDate
                newRestriction[idxRescindDate] = newRescindDate


                newRestriction[idxRoadName] = newRoadName
                newRestriction[idxUSRN] = newUSRN
                newRestriction[idxGeomTypeID] = newRestrictionGeometryTypeID
                newRestriction[idxOrientation] = newOrientation
                newRestriction[idxAzimuthToRoadCentreline] = newAzimuthToRoadCentreLine

                newRestriction[idxChangeNotes] = strHistory
                newRestriction[idxChangeDate] = currDate

                # Also need to think about some geometry related fields - feature length, shape length

                try:

                    self.TOMslayer.startEditing()

                    if featureGeometryID != NULL:
                        # Update the existing feature
                        self.TOMslayer.changeAttributeValue(currRestrictionID, idxRescindDate, currDate)
                        self.TOMslayer.changeAttributeValue(currRestrictionID, idxChangeDate, currDate)
                        # self.TOMslayer.changeAttributeValue(currRestrictionID, idxChangeNotes, "Add details of change here ... ")
                    QgsMessageLog.logMessage(("In onDisplayRestrictionDetails. Attempting save. currDate: " + currDate + " Changes: " + strHistory), tag="TOMs panel")

                    # Add a new row with the revised details
                    self.TOMslayer.addFeatures([newRestriction])

                    # QMessageBox.information(self.iface.mainWindow(),("Message", 'At this point we should set delete date for current record and add a new record to layer - with new create date and details'))
                    # QMessageBox.information(self.iface.mainWindow(),"Message",'newID: ')
                    # self.TOMslayer.rollBack()
                    #self.TOMslayer.commitChanges()

                except:
                    # errorList = self.TOMslayer.commitErrors()
                    for item in list(self.TOMslayer.commitErrors()):
                        QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Unexpected error: " + item))
                    #self.TOMslayer.rollBack()
                    raise

            #else:
            #    QMessageBox.information(self.iface.mainWindow(), "Information", "No changes were made")

            # Now need to refresh to join details and display the results ...

            self.TOMslayer.updateExtents()
            self.TOMslayer.reload()
            self.TOMslayer.triggerRepaint()

            pass
        else:
            pass
        
    def checkRestrictionType(self):
        '''
        Check the restriction ID and set the relevant fields to read only
        '''
        
        # See if the restriction is a line type
        # if self.dlg.cb_restrictionTypes.currentIndex() >= LINETYPES 
        QgsMessageLog.logMessage("In checkRestrictionFields", tag="TOMs panel")
        pass
            
    def generateHistoryString(self, str, fieldName, strValue):
        str = str + "; " + fieldName + ": " + strValue
            
    def doCreateRestriction(self):

        if self.actionCreateRestriction.isChecked():
            # self.iface.mapCanvas().setMapTool(CreateRestrictionTool)
            # self.actionCreateRestiction.setChecked(True)

            # set TOMs layer as active layer (for editing)...

            QgsMessageLog.logMessage("In doCreateRestriction - tool activated", tag="TOMs panel")

            self.TOMslayer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]
            iface.setActiveLayer(self.TOMslayer)

            self.mapTool = CreateRestrictionTool(self.iface, self.TOMslayer, self.onDisplayRestrictionDetails)
            self.mapTool.setAction(self.actionCreateRestriction)
            self.iface.mapCanvas().setMapTool(self.mapTool)
 
        else:

            QgsMessageLog.logMessage("In doCreateRestriction - tool deactivated", tag="TOMs panel")

            self.iface.mapCanvas().unsetMapTool(self.mapTool)
            self.mapTool = None
            self.actionRestrictionDetails.setChecked(False)

        '''
        self.mapTool = GeometryInfoMapTool(self.iface, self.TOMslayer, self.onDisplayRestrictionDetails)
        self.mapTool.setAction(self.actionRestrictionDetails)
        self.iface.mapCanvas().setMapTool(self.mapTool)
        '''

    def onCreateRestriction(self, newRestriction):
        """ Called by map tool when a restriction is created
        """
        QgsMessageLog.logMessage("In onCreateRestriction - after shape created", tag="TOMs panel")

        self.TOMslayer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]

        # Obtain all the details for the restriction

        
        # Create the dislay geometry ...

    def doRemoveRestriction(self):
        pass

    def doEditRestriction(self):

        QgsMessageLog.logMessage("In doEditRestriction - starting", tag="TOMs panel")

        if self.actionEditRestriction.isChecked():

            # set TOMs layer as active layer (for editing)...

            self.TOMslayer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]
            iface.setActiveLayer(self.TOMslayer)

            # now set NodeTools to be active

            iface.actionNodeTool().trigger()

            QgsMessageLog.logMessage("In doEditRestriction - tool activated", tag="TOMs panel")

            # now need to record details

            self.TOMslayer.startEditing()

            #self.mapTool = CreateRestrictionTool(self.iface, self.TOMslayer, self.onDisplayRestrictionDetails)
            #self.mapTool.setAction(self.actionCreateRestriction)
            #self.iface.mapCanvas().setMapTool(self.mapTool)

        else:

            QgsMessageLog.logMessage("In doCreateRestriction - tool deactivated", tag="TOMs panel")

            #self.iface.mapCanvas().unsetMapTool(self.mapTool)
            #self.mapTool = None

            # Need to uncheck NodeTool
            iface.actionPan().trigger()

            self.actionEditRestriction.setChecked(False)
            iface.mapCanvas().refresh()
            # need to deselect the nodes ...

            """
            layer.committedGeometriesChanges.connect(onGeometryChanged)
layer.committedGeometriesChanges.disconnect(onGeometryChanged)
def onGeometryChanged(layer_id, geometry_map):
	for geometry_change in geometry_map.iteritems():
		print(str(geometry_change))
layer.committedGeometriesChanges.disconnect(onGeometryChanged)
Traceback (most recent call last):
  File "<input>", line 1, in <module>
TypeError: 'function' object is not connected
layer.committedGeometriesChanges.connect(onGeometryChanged)
(28L, <qgis._core.QgsGeometry object at 0x234574E0>)

            """
        QgsMessageLog.logMessage("In doEditRestriction - leaving", tag="TOMs panel")

        pass
