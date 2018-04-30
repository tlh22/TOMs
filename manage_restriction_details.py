# -*- coding: latin1 -*-
#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock 2017

# Initialize Qt resources from file resources.py

from PyQt4.QtCore import (
    QObject,
    QDate,
    pyqtSignal,
    QCoreApplication
)

from PyQt4.QtGui import (
    QMessageBox,
    QAction,
    QIcon
)

from qgis.core import (
    QgsExpressionContextUtils,
    QgsMapLayerRegistry,
    QgsMessageLog, QgsFeature, QgsGeometry
)

from TOMs.CadNodeTool.TOMsNodeTool import TOMsNodeTool

from TOMs.mapTools import *
#from TOMsUtils import *
from TOMs.constants import (
    ACTION_CLOSE_RESTRICTION,
    ACTION_OPEN_RESTRICTION
)

from TOMs.restrictionTypeUtils import RestrictionTypeUtils

import functools

class manageRestrictionDetails():
    
    def __init__(self, iface, TOMsToolbar, proposalsManager):

        QgsMessageLog.logMessage("In manageRestrictionDetails::init", tag="TOMs panel")

        # Save reference to the QGIS interface
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.proposalsManager = proposalsManager
        self.TOMsToolbar = TOMsToolbar
        #self.constants = TOMsConstants()

        # This will set up the items on the toolbar
        # Create actions
        self.actionSelectRestriction = QAction(QIcon(":/plugins/TOMs/resources/mActionSelect.png"),
                               QCoreApplication.translate("MyPlugin", "Select"),
                               self.iface.mainWindow())
        self.actionSelectRestriction.setCheckable(True)

        self.actionRestrictionDetails = QAction(QIcon(":/plugins/TOMs/resources/mActionGetInfo.svg"),
                               QCoreApplication.translate("MyPlugin", "Get Details"),
                               self.iface.mainWindow())
        #self.actionRestrictionDetails.setCheckable(True)

        self.actionCreateBayRestriction = QAction(QIcon(":/plugins/TOMs/resources/mActionAddTrack.svg"),
                               QCoreApplication.translate("MyPlugin", "Create Bay"),
                               self.iface.mainWindow())
        self.actionCreateBayRestriction.setCheckable(True)

        self.actionCreateLineRestriction = QAction(QIcon(":/plugins/TOMs/resources/mActionAddLine.svg"),
                               QCoreApplication.translate("MyPlugin", "Create Line"),
                               self.iface.mainWindow())
        self.actionCreateLineRestriction.setCheckable(True)

        self.actionCreatePolygonRestriction = QAction(QIcon(":/plugins/TOMs/resources/rpolygonBy2Corners.svg"),
                               QCoreApplication.translate("MyPlugin", "Create Polygon"),
                               self.iface.mainWindow())
        self.actionCreatePolygonRestriction.setCheckable(True)

        self.actionCreateSignRestriction = QAction(QIcon(":/plugins/TOMs/resources/mActionSetEndPoint.svg"),
                               QCoreApplication.translate("MyPlugin", "Create Sign"),
                               self.iface.mainWindow())
        self.actionCreateSignRestriction.setCheckable(True)

        self.actionRemoveRestriction = QAction(QIcon(":/plugins/TOMs/resources/mActionDeleteTrack.svg"),
                               QCoreApplication.translate("MyPlugin", "Remove Restriction"),
                               self.iface.mainWindow())
        #self.actionRemoveRestriction.setCheckable(True)

        self.actionEditRestriction = QAction(QIcon(":/plugins/TOMs/resources/mActionEdit.svg"),
                               QCoreApplication.translate("MyPlugin", "Edit Restriction"),
                               self.iface.mainWindow())
        self.actionEditRestriction.setCheckable(True)

        self.actionCreateConstructionLine = QAction(QIcon(":/plugins/TOMs/resources/CreateConstructionLine.svg"),
                               QCoreApplication.translate("MyPlugin", "Create construction line"),
                               self.iface.mainWindow())
        self.actionCreateConstructionLine.setCheckable(True)


        # Add actions to the toolbar
        self.TOMsToolbar.addAction(self.actionSelectRestriction)
        self.TOMsToolbar.addAction(self.actionRestrictionDetails)
        self.TOMsToolbar.addAction(self.actionCreateBayRestriction)
        self.TOMsToolbar.addAction(self.actionCreateLineRestriction)
        self.TOMsToolbar.addAction(self.actionCreatePolygonRestriction)
        self.TOMsToolbar.addAction(self.actionCreateSignRestriction)
        self.TOMsToolbar.addAction(self.actionRemoveRestriction)
        self.TOMsToolbar.addAction(self.actionEditRestriction)
        self.TOMsToolbar.addAction(self.actionCreateConstructionLine)

        # Connect action signals to slots
        self.actionSelectRestriction.triggered.connect(self.doSelectRestriction)
        self.actionRestrictionDetails.triggered.connect(self.doRestrictionDetails)
        self.actionCreateBayRestriction.triggered.connect(self.doCreateBayRestriction)
        self.actionCreateLineRestriction.triggered.connect(self.doCreateLineRestriction)
        self.actionCreatePolygonRestriction.triggered.connect(self.doCreatePolygonRestriction)
        self.actionCreateSignRestriction.triggered.connect(self.doCreateSignRestriction)
        self.actionRemoveRestriction.triggered.connect(self.doRemoveRestriction)
        self.actionEditRestriction.triggered.connect(self.doEditRestriction)
        self.actionCreateConstructionLine.triggered.connect(self.doCreateConstructionLine)

        pass

    def enableTOMsToolbarItems(self):

        QgsMessageLog.logMessage("In enableTOMsToolbarItems", tag="TOMs panel")

        self.actionSelectRestriction.setEnabled(True)
        self.actionRestrictionDetails.setEnabled(True)
        self.actionCreateBayRestriction.setEnabled(True)
        self.actionCreateLineRestriction.setEnabled(True)
        self.actionCreatePolygonRestriction.setEnabled(True)
        self.actionCreateSignRestriction.setEnabled(True)
        self.actionRemoveRestriction.setEnabled(True)
        self.actionEditRestriction.setEnabled(True)
        self.actionCreateConstructionLine.setEnabled(True)

        pass


    def disableTOMsToolbarItems(self):

        QgsMessageLog.logMessage("In disableTOMsToolbarItems", tag="TOMs panel")

        self.actionSelectRestriction.setEnabled(False)
        self.actionRestrictionDetails.setEnabled(False)
        self.actionCreateBayRestriction.setEnabled(False)
        self.actionCreateLineRestriction.setEnabled(False)
        self.actionCreatePolygonRestriction.setEnabled(False)
        self.actionCreateSignRestriction.setEnabled(False)
        self.actionRemoveRestriction.setEnabled(False)
        self.actionEditRestriction.setEnabled(False)
        self.actionCreateConstructionLine.setEnabled(False)

        pass

    def doSelectRestriction(self):
        """ Select point and then display details
        """

        QgsMessageLog.logMessage("In doSelectRestriction", tag="TOMs panel")

        if not self.actionSelectRestriction.isChecked():
            self.actionSelectRestriction.setChecked(False)
            self.iface.mapCanvas().unsetMapTool(self.mapTool)
            self.mapTool = None
            # self.actionPan.connect()
            return

        self.actionSelectRestriction.setChecked(True)

        self.mapTool = GeometryInfoMapTool(self.iface)
        self.mapTool.setAction(self.actionSelectRestriction)
        self.iface.mapCanvas().setMapTool(self.mapTool)

    def doRestrictionDetails(self):
        """ Select point and then display details
        """
        QgsMessageLog.logMessage("In doRestrictionDetails", tag="TOMs panel")

        """if not self.actionRestrictionDetails.isChecked():
            self.actionRestrictionDetails.setChecked(False)
            self.iface.mapCanvas().unsetMapTool(self.mapTool)
            self.mapTool = None
            # self.actionPan.connect()
            return

        self.actionRestrictionDetails.setChecked(True)

        self.mapTool = GeometryInfoMapTool(self.iface)
        self.mapTool.setAction(self.actionRestrictionDetails)
        self.iface.mapCanvas().setMapTool(self.mapTool)"""

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        currRestrictionLayer = self.iface.activeLayer()

        #currRestrictionLayer.editingStopped.connect(self.proposalsManager.updateMapCanvas)

        if currRestrictionLayer:

            QgsMessageLog.logMessage("In doRestrictionDetails. currLayer: " + str(currRestrictionLayer.name() + " Nr feats: " + str(currRestrictionLayer.selectedFeatureCount())), tag="TOMs panel")

            if currRestrictionLayer.selectedFeatureCount() > 0:

                if currProposalID > 0:
                    currRestrictionLayer.startEditing()
                selectedRestrictions = currRestrictionLayer.selectedFeatures()
                for currRestriction in selectedRestrictions:
                    self.iface.openFeatureForm(currRestrictionLayer, currRestriction)

            pass

        pass

        #def onDisplayRestrictionDetails(self, currRestriction, currRestrictionLayer):
        """ Called by map tool when a restriction is selected

        self.currRestriction = currRestriction
        self.currRestrictionLayer = currRestrictionLayer

        QgsMessageLog.logMessage(("Start onDisplayRestrictionDetails. currLayer: " + self.currRestrictionLayer.name() + " currType: "),
                                 tag="TOMs panel")

        # Get the current proposal from the session variables
        self.currProposalID = self.proposalsManager.currentProposal()

        # Choose the dialog based on the layer
        #self.dlg = restrictionDetailsDialog()

        # show the dialog
        #self.dlg.show()

        QgsMessageLog.logMessage(("In onDisplayRestrictionDetails. Waiting for changes to form."),
                                 tag="TOMs panel")

        # pick up a singal that something has changed (not sure which one)
        # self.dlg.attributeChanged.connect(self.onProposalChanged)
        # https://nathanw.net/2011/09/05/qgis-tips-custom-feature-forms-with-python-logic/
        # Disconnect the signal that QGIS has wired up for the dialog to the button box.
        #self.dlg.button_box.accepted.disconnect()

        # Wire up our own signals.
        #self.newProposalRequired = False

        #self.dlg.button_box.accepted.connect(functools.partial(RestrictionTypeUtils.onSaveRestrictionDetails, self.currRestriction, self.currRestrictionLayer, self.dlg))

        pass        """

    def doCreateBayRestriction(self):

        QgsMessageLog.logMessage("In doCreateBayRestriction", tag="TOMs panel")

        self.mapTool = None

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        if currProposalID > 0:

            if self.actionCreateBayRestriction.isChecked():
                # self.iface.mapCanvas().setMapTool(CreateRestrictionTool)
                # self.actionCreateRestiction.setChecked(True)

                # set TOMs layer as active layer (for editing)...

                QgsMessageLog.logMessage("In doCreateBayRestriction - tool activated", tag="TOMs panel")

                self.currLayer = QgsMapLayerRegistry.instance().mapLayersByName("Bays")[0]
                self.iface.setActiveLayer(self.currLayer)

                self.currLayer.startEditing()

                self.mapTool = CreateRestrictionTool(self.iface, self.currLayer)
                self.mapTool.setAction(self.actionCreateBayRestriction)
                self.iface.mapCanvas().setMapTool(self.mapTool)

                #self.currLayer.editingStopped.connect (self.proposalsManager.updateMapCanvas)

            else:

                QgsMessageLog.logMessage("In doCreateBayRestriction - tool deactivated", tag="TOMs panel")

                self.iface.mapCanvas().unsetMapTool(self.mapTool)
                self.mapTool = None
                self.actionCreateBayRestriction.setChecked(False)

                #self.currLayer.editingStopped()

        else:

            if self.actionCreateBayRestriction.isChecked():
                self.actionCreateBayRestriction.setChecked(False)
                if self.mapTool == None:
                    self.actionCreateBayRestriction.setChecked(False)

            reply = QMessageBox.information(self.iface.mainWindow(), "Information", "Changes to current data is not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)

        pass

    def doCreateLineRestriction(self):

        QgsMessageLog.logMessage("In doCreateLineRestriction", tag="TOMs panel")

        self.mapTool = None

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        if currProposalID > 0:

            if self.actionCreateLineRestriction.isChecked():
                # self.iface.mapCanvas().setMapTool(CreateRestrictionTool)
                # self.actionCreateRestiction.setChecked(True)

                # set TOMs layer as active layer (for editing)...

                QgsMessageLog.logMessage("In doCreateLineRestriction - tool activated", tag="TOMs panel")

                self.currLayer = QgsMapLayerRegistry.instance().mapLayersByName("Lines")[0]
                self.iface.setActiveLayer(self.currLayer)

                self.currLayer.startEditing()

                self.mapTool = CreateRestrictionTool(self.iface, self.currLayer)
                self.mapTool.setAction(self.actionCreateLineRestriction)
                self.iface.mapCanvas().setMapTool(self.mapTool)

                #self.currLayer.editingStopped.connect (self.proposalsManager.updateMapCanvas)

            else:

                QgsMessageLog.logMessage("In doCreateLineRestriction - tool deactivated", tag="TOMs panel")

                self.iface.mapCanvas().unsetMapTool(self.mapTool)
                self.mapTool = None
                self.actionCreateLineRestriction.setChecked(False)

        else:

            if self.actionCreateLineRestriction.isChecked():
                self.actionCreateLineRestriction.setChecked(False)
                if self.mapTool == None:
                    self.actionCreateLineRestriction.setChecked(False)

            reply = QMessageBox.information(self.iface.mainWindow(), "Information", "Changes to current data is not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)

        pass

    def doCreatePolygonRestriction(self):

        QgsMessageLog.logMessage("In doCreatePolygonRestriction", tag="TOMs panel")

        self.mapTool = None

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        if currProposalID > 0:

            if self.actionCreatePolygonRestriction.isChecked():
                # self.iface.mapCanvas().setMapTool(CreateRestrictionTool)
                # self.actionCreateRestiction.setChecked(True)

                # set TOMs layer as active layer (for editing)...

                QgsMessageLog.logMessage("In doCreatePolygonRestriction - tool activated", tag="TOMs panel")

                self.currLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionPolygons")[0]
                self.iface.setActiveLayer(self.currLayer)

                self.currLayer.startEditing()

                self.mapTool = CreateRestrictionTool(self.iface, self.currLayer)
                self.mapTool.setAction(self.actionCreatePolygonRestriction)
                self.iface.mapCanvas().setMapTool(self.mapTool)

                #self.currLayer.editingStopped.connect (self.proposalsManager.updateMapCanvas)

            else:

                QgsMessageLog.logMessage("In doCreatePolygonRestriction - tool deactivated", tag="TOMs panel")

                self.iface.mapCanvas().unsetMapTool(self.mapTool)
                self.mapTool = None
                self.actionCreatePolygonRestriction.setChecked(False)

        else:

            if self.actionCreatePolygonRestriction.isChecked():
                self.actionCreatePolygonRestriction.setChecked(False)
                if self.mapTool == None:
                    self.actionCreatePolygonRestriction.setChecked(False)

            reply = QMessageBox.information(self.iface.mainWindow(), "Information", "Changes to current data is not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)

        pass

    def doCreateSignRestriction(self):

        QgsMessageLog.logMessage("In doCreateSignRestriction", tag="TOMs panel")

        self.mapTool = None

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        if currProposalID > 0:

            if self.actionCreateSignRestriction.isChecked():
                # self.iface.mapCanvas().setMapTool(CreateRestrictionTool)
                # self.actionCreateRestiction.setChecked(True)

                # set TOMs layer as active layer (for editing)...

                QgsMessageLog.logMessage("In doCreateSignRestriction - tool activated", tag="TOMs panel")

                self.currLayer = QgsMapLayerRegistry.instance().mapLayersByName("Signs")[0]
                self.iface.setActiveLayer(self.currLayer)

                self.currLayer.startEditing()

                self.mapTool = CreateRestrictionTool(self.iface, self.currLayer)
                self.mapTool.setAction(self.actionCreateSignRestriction)
                self.iface.mapCanvas().setMapTool(self.mapTool)

                #self.currLayer.editingStopped.connect (self.proposalsManager.updateMapCanvas)

            else:

                QgsMessageLog.logMessage("In doCreateSignRestriction - tool deactivated", tag="TOMs panel")

                self.iface.mapCanvas().unsetMapTool(self.mapTool)
                self.mapTool = None
                self.actionCreateSignRestriction.setChecked(False)

                #self.currLayer.editingStopped()

        else:

            if self.actionCreateSignRestriction.isChecked():
                self.actionCreateSignRestriction.setChecked(False)
                if self.mapTool == None:
                    self.actionCreateSignRestriction.setChecked(False)

            reply = QMessageBox.information(self.iface.mainWindow(), "Information", "Changes to current data is not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)

        pass

    def doCreateConstructionLine(self):

        QgsMessageLog.logMessage("In doCreateConstructionLine", tag="TOMs panel")

        self.mapTool = None

        if self.actionCreateConstructionLine.isChecked():
            # self.iface.mapCanvas().setMapTool(CreateRestrictionTool)
            # self.actionCreateRestiction.setChecked(True)

            # set TOMs layer as active layer (for editing)...

            QgsMessageLog.logMessage("In doCreateConstructionLine - tool activated", tag="TOMs panel")

            self.currLayer = QgsMapLayerRegistry.instance().mapLayersByName("ConstructionLines")[0]
            self.iface.setActiveLayer(self.currLayer)

            self.currLayer.startEditing()

            self.mapTool = CreateRestrictionTool(self.iface, self.currLayer)
            self.mapTool.setAction(self.actionCreateConstructionLine)
            self.iface.mapCanvas().setMapTool(self.mapTool)

            #self.currLayer.editingStopped.connect (self.proposalsManager.updateMapCanvas)

        else:

            QgsMessageLog.logMessage("In doCreateConstructionLine - tool deactivated", tag="TOMs panel")

            self.iface.mapCanvas().unsetMapTool(self.mapTool)
            self.mapTool = None
            self.actionCreateConstructionLine.setChecked(False)

            #self.currLayer.editingStopped ()

        pass

        #def onCreateRestriction(self, newRestriction):
        """ Called by map tool when a restriction is created
        """
        #QgsMessageLog.logMessage("In onCreateRestriction - after shape created", tag="TOMs panel")

        #self.TOMslayer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]

        # Obtain all the details for the restriction

        
        # Create the dislay geometry ...

    def doRemoveRestriction(self):
        # pass control to MapTool and then deal with Proposals issues from there ??
        QgsMessageLog.logMessage("In doRemoveRestriction", tag="TOMs panel")

        #self.mapTool = None

        # Get the current proposal from the session variables
        self.currProposalID = self.proposalsManager.currentProposal()

        if self.currProposalID > 0:

            '''
            if self.actionRemoveRestriction.isChecked():
                # self.iface.mapCanvas().setMapTool(CreateRestrictionTool)
                # self.actionCreateRestiction.setChecked(True)

                # set TOMs layer as active layer (for editing)...

                QgsMessageLog.logMessage("In doRemoveRestriction - tool activated", tag="TOMs panel")

                #self.TOMslayer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]
                #iface.setActiveLayer(self.TOMslayer)

                self.mapTool = RemoveRestrictionTool(self.iface, self.onRemoveRestriction)
                self.mapTool.setAction(self.actionRemoveRestriction)
                self.iface.mapCanvas().setMapTool(self.mapTool)

                # self.currLayer.editingStopped.connect (self.proposalsManager.updateMapCanvas)

            else:

                QgsMessageLog.logMessage("In doRemoveRestriction - tool deactivated", tag="TOMs panel")

                self.iface.mapCanvas().unsetMapTool(self.mapTool)
                self.mapTool = None
                self.actionRemoveRestriction.setChecked(False)
            '''


            currRestrictionLayer = self.iface.activeLayer()

            #currRestrictionLayer.editingStopped.connect(self.proposalsManager.updateMapCanvas)

            if currRestrictionLayer:

                QgsMessageLog.logMessage("In doRemoveRestriction. currLayer: " + str(currRestrictionLayer.name()), tag="TOMs panel")

                currRestrictionLayer.startEditing()

                if currRestrictionLayer.selectedFeatureCount() > 0:

                    selectedRestrictions = currRestrictionLayer.selectedFeatures()
                    for currRestriction in selectedRestrictions:
                        self.onRemoveRestriction(currRestrictionLayer, currRestriction)

                else:

                    reply = QMessageBox.information(self.iface.mainWindow(), "Information",
                                                    "Select restriction for delete",
                                                    QMessageBox.Ok)

            pass

        else:

            """if self.actionRemoveRestriction.isChecked():
                self.actionRemoveRestriction.setChecked(False)
                if self.mapTool == None:
                    self.actionRemoveRestriction.setChecked(False)"""

            reply = QMessageBox.information(self.iface.mainWindow(), "Information", "Changes to current data are not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)

        pass


    def onRemoveRestriction(self, currRestrictionLayer, currRestriction):
        QgsMessageLog.logMessage("In onRemoveRestriction. currLayer: " + str(currRestrictionLayer.id()) + " CurrFeature: " + str(currRestriction.id()), tag="TOMs panel")

        #self.currRestrictionLayer = currRestrictionLayer
        #self.currRestriction = currRestriction

        currProposalID = self.proposalsManager.currentProposal()

        currRestrictionLayer.startEditing()
        currRestrictionLayerID = RestrictionTypeUtils.getRestrictionLayerTableID(currRestrictionLayer)

        idxRestrictionID = currRestriction.fieldNameIndex("RestrictionID")

        if RestrictionTypeUtils.restrictionInProposal(currRestriction[idxRestrictionID], currRestrictionLayerID, currProposalID):
            # remove the restriction from the RestrictionsInProposals table - and from the currLayer, i.e., it is totally removed.
            # NB: This is the only case of a restriction being truly deleted

            QgsMessageLog.logMessage("In onRemoveRestriction. Removing from RestrictionsInProposals and currLayer.", tag="TOMs panel")
            #self.dlg.accept()

            # ***** IMPLEMENTATION REQUIRED  *****

            # Delete from RestrictionsInProposals
            result = RestrictionTypeUtils.deleteRestrictionInProposal(currRestriction[idxRestrictionID], currRestrictionLayerID, currProposalID)

            if result:
                QgsMessageLog.logMessage("In onRemoveRestriction. Deleting restriction.",
                                         tag="TOMs panel")
                currRestrictionLayer.deleteFeature(currRestriction.id())
            else:
                QMessageBox.information(None, "ERROR", ("Error deleting restriction ..."))

        else:
            # need to:
            #    - enter the restriction into the table RestrictionInProposals as closed, and
            #
            QgsMessageLog.logMessage("In onRemoveRestriction. Closing existing restriction.",
                                     tag="TOMs panel")

            RestrictionTypeUtils.addRestrictionToProposal(currRestriction[idxRestrictionID], currRestrictionLayerID, currProposalID,
                                                          ACTION_CLOSE_RESTRICTION())  # 2 = Close

        # Now save all changes

        #RestrictionTypeUtils.commitRestrictionChanges(currRestrictionLayer)
        #currRestrictionLayer.triggerRepaint()  # This shouldn't be required ...



    def doEditRestriction(self):

        QgsMessageLog.logMessage("In doEditRestriction - starting", tag="TOMs panel")

        self.mapTool = None

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        if currProposalID > 0:

            if self.actionEditRestriction.isChecked():

                QgsMessageLog.logMessage("In actionEditRestriction - tool being activated", tag="TOMs panel")

                # Need to clear any other maptools ....   ********

                currRestrictionLayer = self.iface.activeLayer()

                if currRestrictionLayer:

                    QgsMessageLog.logMessage("In doEditRestriction. currLayer: " + str(currRestrictionLayer.name()), tag="TOMs panel")

                    if currRestrictionLayer.selectedFeatureCount() > 0:

                        # save the current feature

                        #self.actionEditRestriction.setChecked(True)
                        self.mapTool = TOMsNodeTool(self.iface,
                                                    self.proposalsManager)  # This is where we use the Node Tool ... need canvas and panel??
                        self.mapTool.setAction(self.actionEditRestriction)
                        self.iface.mapCanvas().setMapTool(self.mapTool)


                        currRestrictionLayer.startEditing()
                        #currRestrictionLayer.editingStopped.connect(self.proposalsManager.updateMapCanvas)

                    else:

                        reply = QMessageBox.information(self.iface.mainWindow(), "Information",
                                                        "Select restriction for edit",
                                                        QMessageBox.Ok)

                        self.actionEditRestriction.setChecked(False)
                        self.iface.mapCanvas().unsetMapTool(self.mapTool)
                        self.mapTool = None

                else:

                    reply = QMessageBox.information(self.iface.mainWindow(), "Information",
                                                    "Select restriction for edit",
                                                    QMessageBox.Ok)
                    self.actionEditRestriction.setChecked(False)
                    self.iface.mapCanvas().unsetMapTool(self.mapTool)
                    self.mapTool = None

            else:

                QgsMessageLog.logMessage("In doEditRestriction - tool deactivated", tag="TOMs panel")

                self.actionEditRestriction.setChecked(False)
                self.iface.mapCanvas().unsetMapTool(self.mapTool)
                self.mapTool = None

            pass

        else:

            """if self.actionEditRestriction.isChecked():
                self.actionEditRestriction.setChecked(False)
                if self.mapTool == None:
                    self.actionEditRestriction.setChecked(False)"""

            reply = QMessageBox.information(self.iface.mainWindow(), "Information",
                                            "Changes to current data are not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)
            self.actionEditRestriction.setChecked(False)
            self.iface.mapCanvas().unsetMapTool(self.mapTool)
            self.mapTool = None

        pass

        QgsMessageLog.logMessage("In doEditRestriction - leaving", tag="TOMs panel")

        pass

