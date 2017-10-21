# -*- coding: latin1 -*-

# Initialize Qt resources from file resources.py

from PyQt4.QtGui import (
    QMessageBox,
    QAction,
    QIcon
)

from TOMs.CadNodeTool.TOMsNodeTool import TOMsNodeTool

from mapTools import *
#from TOMsUtils import *
from constants import *

from restrictionTypeUtils import RestrictionTypeUtils

import functools

class manageRestrictionDetails():
    
    def __init__(self, iface, TOMsToolbar, proposalsManager):
        # Save reference to the QGIS interface
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.proposalsManager = proposalsManager

        # Create actions
        self.actionRestrictionDetails = QAction(QIcon(":/plugins/Test5Class/resources/mActionGetInfo.svg"),
                               QCoreApplication.translate("MyPlugin", "Select"),
                               self.iface.mainWindow())
        self.actionRestrictionDetails.setCheckable(True)

        self.actionCreateBayRestriction = QAction(QIcon(":/plugins/Test5Class/resources/mActionAddTrack.svg"),
                               QCoreApplication.translate("MyPlugin", "Create Bay"),
                               self.iface.mainWindow())
        self.actionCreateBayRestriction.setCheckable(True)

        self.actionCreateLineRestriction = QAction(QIcon(":/plugins/Test5Class/resources/mActionAddLine.svg"),
                               QCoreApplication.translate("MyPlugin", "Create Line"),
                               self.iface.mainWindow())
        self.actionCreateLineRestriction.setCheckable(True)

        self.actionRemoveRestriction = QAction(QIcon(":/plugins/Test5Class/resources/mActionDeleteTrack.svg"),
                               QCoreApplication.translate("MyPlugin", "Remove Restriction"),
                               self.iface.mainWindow())
        self.actionRemoveRestriction.setCheckable(True)

        self.actionEditRestriction = QAction(QIcon(":/plugins/Test5Class/resources/mActionEdit.svg"),
                               QCoreApplication.translate("MyPlugin", "Edit Restriction"),
                               self.iface.mainWindow())
        self.actionEditRestriction.setCheckable(True)

        # Add actions to the toolbar
        TOMsToolbar.addAction(self.actionRestrictionDetails)
        TOMsToolbar.addAction(self.actionCreateBayRestriction)
        TOMsToolbar.addAction(self.actionCreateLineRestriction)
        TOMsToolbar.addAction(self.actionRemoveRestriction)
        TOMsToolbar.addAction(self.actionEditRestriction)

        # Connect action signals to slots
        self.actionRestrictionDetails.triggered.connect(self.doRestrictionDetails)
        self.actionCreateBayRestriction.triggered.connect(self.doCreateBayRestriction)
        self.actionCreateLineRestriction.triggered.connect(self.doCreateLineRestriction)
        self.actionRemoveRestriction.triggered.connect(self.doRemoveRestriction)
        self.actionEditRestriction.triggered.connect(self.doEditRestriction)
        
        pass

    def doRestrictionDetails(self):
        """ Select point and then display details
		"""
        
        QgsMessageLog.logMessage("In doRestrictionDetails", tag="TOMs panel")

        if not self.actionRestrictionDetails.isChecked():
            self.actionRestrictionDetails.setChecked(False)
            self.iface.mapCanvas().unsetMapTool(self.mapTool)
            self.mapTool = None
            #self.actionPan.connect()
            return

        self.actionRestrictionDetails.setChecked(True)

        self.mapTool = GeometryInfoMapTool(self.iface)
        self.mapTool.setAction(self.actionRestrictionDetails)
        self.iface.mapCanvas().setMapTool(self.mapTool)

    def onDisplayRestrictionDetails(self, currRestriction, currRestrictionLayer):
        """ Called by map tool when a restriction is selected
        """
        self.currRestriction = currRestriction
        self.currRestrictionLayer = currRestrictionLayer

        QgsMessageLog.logMessage(("Start onDisplayRestrictionDetails. currLayer: " + self.currRestrictionLayer.name() + " currType: "),
                                 tag="TOMs panel")

        # Get the current proposal from the session variables
        self.currProposalID = self.proposalsManager.currentProposal()

        # Choose the dialog based on the layer
        self.dlg = restrictionDetailsDialog()

        # show the dialog
        self.dlg.show()

        QgsMessageLog.logMessage(("In onDisplayRestrictionDetails. Waiting for changes to form."),
                                 tag="TOMs panel")

        # pick up a singal that something has changed (not sure which one)
        # self.dlg.attributeChanged.connect(self.onProposalChanged)
        # https://nathanw.net/2011/09/05/qgis-tips-custom-feature-forms-with-python-logic/
        # Disconnect the signal that QGIS has wired up for the dialog to the button box.
        self.dlg.button_box.accepted.disconnect()

        # Wire up our own signals.
        #self.newProposalRequired = False
        self.dlg.button_box.accepted.connect(functools.partial(RestrictionTypeUtils.onSaveRestrictionDetails, self.currRestriction, self.currRestrictionLayer, self.dlg))

        pass

        """def onSaveRestrictionDetails(self):
        QgsMessageLog.logMessage("In onSaveRestrictionDetails.", tag="TOMs panel")

        self.currRestrictionLayer.startEditing()

        if self.proposalsManager.restrictionInProposal(self.currRestriction.id(), self.currRestrictionLayerID, self.currProposalID):
            # simply make changes to the current restriction in the current layer
            QgsMessageLog.logMessage("In onSaveRestrictionDetails. Saving details straight from form.", tag="TOMs panel")
            self.dlg.accept()

        else:
            # need to:
            #    - enter the restriction into the table RestrictionInProposals, and
            #    - make a copy of the restriction in the current layer (with the new details)
            QgsMessageLog.logMessage("In onSaveRestrictionDetails. Closing existing restriction.",
                                     tag="TOMs panel")
            self.proposalsManager.addRestrictionToProposal(self.currRestriction.id(), self.currRestrictionLayerID, self.currProposalID,
                                                          "Close")
            newRestriction = QgsFeature(self.currRestrictionLayer.fields())
            self._geom_buffer = QgsGeometry(self.currRestriction.geometry())
            newRestriction.setGeometry(QgsGeometry(self._geom_buffer))
            self.currRestrictionLayer.addFeatures([newRestriction])

            QgsMessageLog.logMessage("In onSaveRestrictionDetails. Opening existing restriction.",
                                     tag="TOMs panel")
            self.proposalsManager.addRestrictionToProposal(self.newRestriction.id(), self.currRestrictionLayerID,
                                                      self.currProposalID,
                                                      "Open")

        pass """
            
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

                self.mapTool = CreateRestrictionTool(self.iface, self.currLayer, self.onDisplayRestrictionDetails)
                self.mapTool.setAction(self.actionCreateBayRestriction)
                self.iface.mapCanvas().setMapTool(self.mapTool)

            else:

                QgsMessageLog.logMessage("In doCreateBayRestriction - tool deactivated", tag="TOMs panel")

                self.iface.mapCanvas().unsetMapTool(self.mapTool)
                self.mapTool = None
                self.actionCreateBayRestriction.setChecked(False)

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

                self.mapTool = CreateRestrictionTool(self.iface, self.currLayer, self.onDisplayRestrictionDetails)
                self.mapTool.setAction(self.actionCreateLineRestriction)
                self.iface.mapCanvas().setMapTool(self.mapTool)

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

    def onCreateRestriction(self, newRestriction):
        """ Called by map tool when a restriction is created
        """
        QgsMessageLog.logMessage("In onCreateRestriction - after shape created", tag="TOMs panel")

        #self.TOMslayer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]

        # Obtain all the details for the restriction

        
        # Create the dislay geometry ...

    def doRemoveRestriction(self):
        # pass control to MapTool and then deal with Proposals issues from there ??
        QgsMessageLog.logMessage("In doRemoveRestriction", tag="TOMs panel")

        self.mapTool = None

        # Get the current proposal from the session variables
        self.currProposalID = self.proposalsManager.currentProposal()

        if self.currProposalID > 0:

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

            else:

                QgsMessageLog.logMessage("In doRemoveRestriction - tool deactivated", tag="TOMs panel")

                self.iface.mapCanvas().unsetMapTool(self.mapTool)
                self.mapTool = None
                self.actionRemoveRestriction.setChecked(False)

            '''
            self.mapTool = GeometryInfoMapTool(self.iface, self.TOMslayer, self.onDisplayRestrictionDetails)
            self.mapTool.setAction(self.actionRestrictionDetails)
            self.iface.mapCanvas().setMapTool(self.mapTool)
            '''
        else:

            if self.actionRemoveRestriction.isChecked():
                self.actionRemoveRestriction.setChecked(False)
                if self.mapTool == None:
                    self.actionRemoveRestriction.setChecked(False)

            reply = QMessageBox.information(self.iface.mainWindow(), "Information", "Changes to current data are not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)

        pass


        pass

    def onRemoveRestriction(self, currRestrictionLayer, currRestriction):
        QgsMessageLog.logMessage("In onRemoveRestriction. currLayer: " + str(currRestrictionLayer.id()) + " CurrFeature: " + str(currRestriction.id()), tag="TOMs panel")

        #self.currRestrictionLayer = currRestrictionLayer
        #self.currRestriction = currRestriction

        currProposalID = int(QgsExpressionContextUtils.projectScope().variable('CurrentProposal'))

        currRestrictionLayer.startEditing()
        currRestrictionLayerID = RestrictionTypeUtils.getRestrictionLayerTableID(currRestrictionLayer)

        idxGeometryID = currRestriction.fieldNameIndex("GeometryID")

        if RestrictionTypeUtils.restrictionInProposal(currRestriction[idxGeometryID], currRestrictionLayerID, currProposalID):
            # remove the restriction from the RestrictionsInProposals table - and from the currLayer, i.e., it is totally removed.
            # NB: THis is the only case of a restriction being truly deleted

            QgsMessageLog.logMessage("In onRemoveRestriction. Removing from RestrictionsInProposals and currLayer.", tag="TOMs panel")
            #self.dlg.accept()

        else:
            # need to:
            #    - enter the restriction into the table RestrictionInProposals as closed, and
            #
            QgsMessageLog.logMessage("In onRemoveRestriction. Closing existing restriction.",
                                     tag="TOMs panel")

            RestrictionTypeUtils.addRestrictionToProposal(currRestriction[idxGeometryID], currRestrictionLayerID, currProposalID,
                                                          2)  # 2 = Close

        pass

    def doEditRestriction(self):

        QgsMessageLog.logMessage("In doEditRestriction - starting", tag="TOMs panel")

        self.mapTool = None

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        if currProposalID > 0:

            if self.actionEditRestriction.isChecked():

                QgsMessageLog.logMessage("In actionEditRestriction - tool activated", tag="TOMs panel")

                # Need to clear any other maptools ....   ********

                self.actionEditRestriction.setChecked(True)

                self.mapTool = TOMsNodeTool(self.iface, self.proposalsManager)    # This is where we use the Node Tool ... need canvas and panel??
                self.mapTool.setAction(self.actionEditRestriction)
                self.iface.mapCanvas().setMapTool(self.mapTool)

            else:

                QgsMessageLog.logMessage("In doEditRestriction - tool deactivated", tag="TOMs panel")

                self.actionEditRestriction.setChecked(False)
                self.iface.mapCanvas().unsetMapTool(self.mapTool)
                self.mapTool = None

        else:

            if self.actionEditRestriction.isChecked():
                self.actionEditRestriction.setChecked(False)
                if self.mapTool == None:
                    self.actionEditRestriction.setChecked(False)

            reply = QMessageBox.information(self.iface.mainWindow(), "Information",
                                            "Changes to current data are not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)

        pass

        QgsMessageLog.logMessage("In doEditRestriction - leaving", tag="TOMs panel")

        pass
