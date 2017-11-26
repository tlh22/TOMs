# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ---------------------------------------------------------------------
# Tim Hancock 2017

# -*- coding: latin1 -*-
# Import the PyQt and QGIS libraries
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *

import time

from TOMs.ProposalPanel_dockwidget import ProposalPanelDockWidget
#from proposal_details_dialog import proposalDetailsDialog
from TOMs.core.proposalsManager import *
from .manage_restriction_details import manageRestrictionDetails

from TOMs.constants import (
    PROPOSAL_STATUS_IN_PREPARATION,
    PROPOSAL_STATUS_ACCEPTED,
    PROPOSAL_STATUS_REJECTED
)
class proposalsPanel():
    
    def __init__(self, iface, TOMsToolBar, proposalsManager):
        #def __init__(self, iface, TOMsMenu, proposalsManager):

        # Save reference to the QGIS interface
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.TOMsToolBar = TOMsToolBar
        self.proposalsManager = proposalsManager

        self.actionProposalsPanel = QAction(QIcon(":/plugins/TOMs/resources/TOMsStart.png"),
                               QCoreApplication.translate("MyPlugin", "Start TOMs"), self.iface.mainWindow())
        self.actionProposalsPanel.setCheckable(True)

        self.TOMsToolBar.addAction(self.actionProposalsPanel)

        self.actionProposalsPanel.triggered.connect(self.onInitProposalsPanel)

        self.acceptProposal = False
        self.newProposalRequired = False

        # Now set up the toolbar

        self.RestrictionTools = manageRestrictionDetails(self.iface, self.TOMsToolBar, self.proposalsManager)
        self.RestrictionTools.disableTOMsToolbarItems()

        pass

    def onInitProposalsPanel(self):
        """Filter main layer based on date and state options"""
        
        QgsMessageLog.logMessage("In onInitProposalsPanel", tag="TOMs panel")

        #print "** STARTING ProposalPanel"

        # dockwidget may not exist if:
        #    first run of plugin
        #    removed on close (see self.onClosePlugin method)

        if self.actionProposalsPanel.isChecked():

            QgsMessageLog.logMessage("In onInitProposalsPanel. Activating ...", tag="TOMs panel")

            self.openTOMsTools()

        else:

            QgsMessageLog.logMessage("In onInitProposalsPanel. Deactivating ...", tag="TOMs panel")

            self.closeTOMsTools()

        pass

    def openTOMsTools(self):
        # actions when the Proposals Panel is closed or the toolbar "start" is toggled

        QgsMessageLog.logMessage("In openTOMsTools. Activating ...", tag="TOMs panel")

        self.dock = ProposalPanelDockWidget()
        self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dock)
        self.dock.closingPlugin.connect(self.closeTOMsTools)

        self.proposalsManager.proposalChanged.connect(self.onProposalChanged)
        self.proposalsManager.dateChanged.connect(self.onDateChanged)

        # self.dock.filterDate.setDisplayFormat("yyyy-MM-dd")
        self.dock.filterDate.setDisplayFormat("dd-MM-yyyy")
        self.dock.filterDate.setDate(QDate.currentDate())

        if QgsMapLayerRegistry.instance().mapLayersByName("Proposals"):
            self.Proposals = QgsMapLayerRegistry.instance().mapLayersByName("Proposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table Proposals is not present"))
            raise LayerNotPresent

        # Set up field details for table  ** what about errors here **
        idxProposalID = self.Proposals.fieldNameIndex("ProposalID")
        idxProposalTitle = self.Proposals.fieldNameIndex("ProposalTitle")
        self.idxCreateDate = self.Proposals.fieldNameIndex("ProposalCreateDate")
        self.idxOpenDate = self.Proposals.fieldNameIndex("ProposalOpenDate")
        self.idxProposalStatusID = self.Proposals.fieldNameIndex("ProposalStatusID")

        self.createProposalcb()

        # set CurrentProposal to be 0

        self.proposalsManager.setCurrentProposal(0)

        # set up action for when the date is changed from the user interface
        self.dock.filterDate.dateChanged.connect(lambda: self.proposalsManager.setDate(self.dock.filterDate.date()))

        # set up action for when the proposal is changed
        self.dock.cb_ProposalsList.currentIndexChanged.connect(self.updateCurrentProposal)

        # set up action for "New Proposal"
        self.dock.btn_NewProposal.clicked.connect(self.onNewProposal)

        # set up action for "View Proposal"
        self.dock.btn_ViewProposal.clicked.connect(self.onProposalDetails)

        # set up action for when new proposal is created
        self.Proposals.editingStopped.connect(self.createProposalcb)

        # self.dock.setUserVisible(True)

        # set up a canvas refresh if there are any changes to the restrictions
        self.RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]
        # self.RestrictionsInProposalsLayer.editingStopped.connect(self.proposalsManager.updateMapCanvas)
        self.RestrictionsInProposalsLayer.committedFeaturesAdded.connect(self.proposalsManager.updateMapCanvas)
        self.RestrictionsInProposalsLayer.committedFeaturesRemoved.connect(self.proposalsManager.updateMapCanvas)

        self.RestrictionTools.enableTOMsToolbarItems()

        pass

    def closeTOMsTools(self):
        # actions when the Proposals Panel is closed or the toolbar "start" is toggled

        QgsMessageLog.logMessage("In closeTOMsTools. Deactivating ...", tag="TOMs panel")

        self.actionProposalsPanel.setChecked(False)

        # Now close the proposals panel

        self.dock.close()

        # Now disable the items from the Toolbar

        self.RestrictionTools.disableTOMsToolbarItems()

        pass

    def createProposalcb(self):

        QgsMessageLog.logMessage("In createProposalcb", tag="TOMs panel")
        # set up a "NULL" field for "No proposals to be shown"

        self.dock.cb_ProposalsList.clear()

        currProposalID = 0
        currProposalTitle = "No proposal shown"

        # A little pause for the db to catch up
        time.sleep(.1)

        QgsMessageLog.logMessage("In createProposalcb: Adding 0", tag="TOMs panel")

        self.dock.cb_ProposalsList.addItem(currProposalTitle, currProposalID)


        for proposal in self.Proposals.getFeatures():
            currProposalStatusID = proposal.attribute("ProposalStatusID")
            QgsMessageLog.logMessage("In createProposalcb. ID: " + str(proposal.attribute("ProposalID")) + " currProposalStatus: " + str(currProposalStatusID),
                                     tag="TOMs panel")
            if currProposalStatusID == PROPOSAL_STATUS_IN_PREPARATION():  # 1 = "in preparation"
                currProposalID = proposal.attribute("ProposalID")
                currProposalTitle = proposal.attribute("ProposalTitle")
                self.dock.cb_ProposalsList.addItem(currProposalTitle, currProposalID)

        pass


    def onChangeProposal(self):
        QgsMessageLog.logMessage("In onChangeProposal", tag="TOMs panel")

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        newProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()
        newProposalID = self.dock.cb_ProposalsList.itemData(newProposal_cbIndex)
        newProposalTitle = self.dock.cb_ProposalsList.currentText()

        QgsMessageLog.logMessage("In onChangeProposal. newProposalID: " + str(newProposalID) + " newProposalTitle: " + str(newProposalTitle), tag="TOMs panel")

        # Set the project variable

        reply = QMessageBox.information(self.iface.mainWindow(), "Information", "All changes will be rolled back", QMessageBox.Ok)

        if reply:

            QgsExpressionContextUtils.setProjectVariable('CurrentProposal', str(newProposalID))

            self.iface.actionRollbackAllEdits().trigger()
            self.iface.actionCancelAllEdits().trigger()

            # Now revise the view based on proposal choosen

            #self.filterView()

            QgsMessageLog.logMessage("In onChangeProposal. Zoom to extents", tag="TOMs panel")
            self.iface.mapCanvas().setExtent(self.proposalsManager.getProposalBoundingBox())
            self.iface.mapCanvas().refresh()

        pass

    def onNewProposal(self):
        QgsMessageLog.logMessage("In onNewProposal", tag="TOMs panel")

        # create a new Proposal

        newProposal = QgsFeature(self.Proposals.fields())
        #newProposal.setGeometry(QgsGeometry())

        newProposal[self.idxCreateDate] = self.proposalsManager.date()
        newProposal[self.idxOpenDate] = self.proposalsManager.date()
        newProposal[self.idxProposalStatusID] = PROPOSAL_STATUS_IN_PREPARATION()

        self.Proposals.startEditing()

        self.iface.openFeatureForm(self.Proposals, newProposal, False, False)

        pass

    def onSaveProposalDetails(self):
        QgsMessageLog.logMessage("In onSaveProposalDetails.", tag="TOMs panel")

        # set up field indexes
        idxProposalID = self.Proposals.fieldNameIndex("ProposalID")
        idxProposalTitle = self.Proposals.fieldNameIndex("ProposalTitle")
        idxProposalStatusID = self.Proposals.fieldNameIndex("ProposalStatusID")
        idxProposalNotes = self.Proposals.fieldNameIndex("ProposalNotes")
        idxProposalCreateDate = self.Proposals.fieldNameIndex("ProposalCreateDate")

        self.Proposals.startEditing()

        if self.newProposalRequired == True:

            # create a new Proposal

            currProposal = QgsFeature(self.Proposals.fields())
            currProposal.setGeometry(QgsGeometry())
            #self.Proposals.addFeatures([currProposal])

            QgsMessageLog.logMessage("In onSaveProposalDetails. Creating new Proposal.", tag="TOMs panel")

        else:

            # get the existing proposal ?? is there a better way ??

            currProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()
            currProposalID = self.dock.cb_ProposalsList.itemData(currProposal_cbIndex)
            currProposalTitle = self.dock.cb_ProposalsList.currentText()

            QgsMessageLog.logMessage(
                "In onSaveProposalDetails. ProposalID: " + str(currProposalID) + " ProposalTitle: " + str(
                    currProposalTitle), tag="TOMs panel")

            # use the ID to retrieve the row
            # https://gis.stackexchange.com/questions/54057/how-to-read-the-attribute-values-using-pyqgis/138027

            iterator = self.Proposals.getFeatures(QgsFeatureRequest().setFilterFid(currProposalID))
            currProposal = next(iterator)

        QgsMessageLog.logMessage("In onSaveProposalDetails. Saving Proposal. id: " + str(currProposal.id()),
                                 tag="TOMs panel")

        # Now save the details

        try:

            # Update the existing feature

            # idxProposalID = self.Proposals.fieldNameIndex("ProposalID")
            QgsMessageLog.logMessage(
                ("In onSaveProposalDetails. Attempting save. ID: " + str(currProposal.id()) + " Title: " + self.dlg.ProposalTitle.text() + " CreateDate: " + str(
                    self.dlg.ProposalCreateDate.text()) +
                 " ProposalStatusID: " + str(
                    self.dlg.ProposalStatusID.currentIndex() + 1) + " ProposalNotes: " + self.dlg.ProposalNotes.toPlainText()),
                tag="TOMs panel")

            if self.newProposalRequired == True:

                #currProposal[idxProposalID] = currProposal.id()
                currProposal[idxProposalTitle] = self.dlg.ProposalTitle.text()
                currProposal[idxProposalStatusID] = self.dlg.ProposalStatusID.currentIndex() + 1

                if self.dlg.ProposalNotes is not None:
                    currProposal[idxProposalNotes] = self.dlg.ProposalNotes.toPlainText()

                currProposal[idxProposalCreateDate] = self.dlg.ProposalCreateDate.date()

                self.Proposals.addFeatures([currProposal])

                QgsMessageLog.logMessage("In onSaveProposalDetails. Creating new Proposal.", tag="TOMs panel")

            else:

                # the Proposal already exists - so update it

                self.Proposals.changeAttributeValue(currProposal.id(), self.Proposals.fieldNameIndex("ProposalTitle"),
                                                    self.dlg.ProposalTitle.text())

                #  There is a problem with the format of the date passed here - and it is not saving correctly. Need to investigate further.
                self.Proposals.changeAttributeValue(currProposal.id(),
                                                    self.Proposals.fieldNameIndex("ProposalCreateDate"),
                                                    self.dlg.ProposalCreateDate.date())

                self.Proposals.changeAttributeValue(currProposal.id(),
                                                    self.Proposals.fieldNameIndex("ProposalStatusID"),
                                                    self.dlg.ProposalStatusID.currentIndex() + 1)

                self.Proposals.changeAttributeValue(currProposal.id(), self.Proposals.fieldNameIndex("ProposalNotes"),
                                                    str(self.dlg.ProposalNotes.toPlainText()))

                QgsMessageLog.logMessage("In onSaveProposalDetails. Saving existing Proposal. id: " + str(currProposal.id()), tag="TOMs panel")

            self.Proposals.commitChanges()  # Save details

        except:
            # errorList = self.TOMslayer.commitErrors()
            for item in list(self.Proposals.commitErrors()):
                QgsMessageLog.logMessage(("In onSaveProposalDetails. Unexpected error: " + str(item)),
                                         tag="TOMs panel")

            # self.TOMslayer.rollBack()
            raise

        QgsMessageLog.logMessage(("In onSaveProposalDetails. Successful save."), tag="TOMs panel")

        # Update the lsit of Proposals
        self.createProposalcb()

        self.dlg.accept()   # exit in the normal way

    def onProposalDetails(self):
        QgsMessageLog.logMessage("In onProposalDetails", tag="TOMs panel")

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        currProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()

        if currProposal_cbIndex == 0:
            return  # there is nothing to see

        currProposalID = self.dock.cb_ProposalsList.itemData(currProposal_cbIndex)

        currProposal = self.getProposal(currProposalID)

        self.Proposals.startEditing()

        self.iface.openFeatureForm(self.Proposals, currProposal, False)

        pass

    def onProposalChanged(self):
        QgsMessageLog.logMessage("In onProposalChanged.", tag="TOMs panel")
        currProposal = self.proposalsManager.currentProposal()
        currProposalIdx = self.dock.cb_ProposalsList.findData(currProposal)
        self.dock.cb_ProposalsList.setCurrentIndex(currProposalIdx)

        QgsMessageLog.logMessage("In onProposalChanged. Zoom to extents", tag="TOMs panel")
        """if self.proposalsManager.getProposalBoundingBox():
            QgsMessageLog.logMessage("In onProposalChanged. Bounding box found", tag="TOMs panel")
            self.iface.mapCanvas().setExtent(self.proposalsManager.getProposalBoundingBox())
            self.iface.mapCanvas().refresh()"""

    def updateCurrentProposal(self):
        QgsMessageLog.logMessage("In updateCurrentProposal.", tag="TOMs panel")
        """Will be called whenever a new entry is selected in the combobox"""

        # Can we check to see if there are any outstanding edits?!!

        """reply = QMessageBox.information(self.iface.mainWindow(), "Information", "All changes will be rolled back",
                                        QMessageBox.Ok)

        if reply:

            self.iface.actionRollbackAllEdits().trigger()
            self.iface.actionCancelAllEdits().trigger()

        pass"""

        currProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()
        currProposalID = self.dock.cb_ProposalsList.itemData(currProposal_cbIndex)
        self.proposalsManager.setCurrentProposal(currProposalID)

    def onDateChanged(self):
        QgsMessageLog.logMessage("In onDateChanged.", tag="TOMs panel")
        date = self.proposalsManager.date()
        self.dock.filterDate.setDate(date)

    def onChangeProposalStatus(self):
        QgsMessageLog.logMessage("In onChangeProposalStatus. Proposed status: " + str(self.Proposals.fieldNameIndex("ProposalStatusID")), tag="TOMs panel")

        # check to see if the proposal is "Accepted"

        self.acceptProposal = False

        newProposalStatus = int(self.Proposals.fieldNameIndex("ProposalStatusID"))

        if newProposalStatus == 1:    # should be 2 but with list ...

            # if so, check to see if this was intended

            reply = QMessageBox.question(self.iface.mainWindow(), 'Confirm changes to Proposal',
                                         'Are you you want to accept this proposal?. Accepting will make all the proposed changes permanent.', QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:
                # make the changes permanent
                self.acceptProposal = True

        # bring the Proposals dislog back to the front

        self.dlg.activateWindow()

        return self.acceptProposal

        """def getRestrictionLayerTableID(self, currRestLayer):
        QgsMessageLog.logMessage("In getRestrictionLayerTableID.", tag="TOMs panel")
        # find the ID for the layer within the table "

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers2")[0]

        layersTableID = 0

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for layer in RestrictionsLayers.getFeatures():
            if layer.attribute("RestrictionLayerName") == str(currRestLayer.name()):
                layersTableID = layer.attribute("id")

        QgsMessageLog.logMessage("In getRestrictionLayerTableID. layersTableID: " + str(layersTableID), tag="TOMs panel")

        return layersTableID"""

    def getProposal(self, proposalID):
        QgsMessageLog.logMessage("In getProposal.", tag="TOMs panel")

        proposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("Proposals")[0]

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for currProposal in proposalsLayer.getFeatures():
            if currProposal.attribute("ProposalID") == proposalID:
                return currProposal

        return None

        pass