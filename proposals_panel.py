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
import functools

from TOMs.ProposalPanel_dockwidget import ProposalPanelDockWidget
#from proposal_details_dialog import proposalDetailsDialog
from TOMs.core.proposalsManager import *

from .manage_restriction_details import manageRestrictionDetails
from .search_bar import searchBar

from TOMs.restrictionTypeUtilsClass import RestrictionTypeUtilsMixin, setupTableNames, TOMsTransaction

from TOMs.constants import (
    PROPOSAL_STATUS_IN_PREPARATION,
    PROPOSAL_STATUS_ACCEPTED,
    PROPOSAL_STATUS_REJECTED
)
class proposalsPanel(RestrictionTypeUtilsMixin):
    
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

        self.newProposalRequired = False

        # Now set up the toolbar

        self.RestrictionTools = manageRestrictionDetails(self.iface, self.TOMsToolBar, self.proposalsManager)
        self.RestrictionTools.disableTOMsToolbarItems()
        self.searchBar = searchBar(self.iface, self.TOMsToolBar, self.proposalsManager)
        self.searchBar.disableSearchBar()

        pass

    def onInitProposalsPanel(self):
        """Filter main layer based on date and state options"""
        
        QgsMessageLog.logMessage("In onInitProposalsPanel", tag="TOMs panel")

        #print "** STARTING ProposalPanel"

        # dockwidget may not exist if:
        #    first run of plugin
        #    removed on close (see self.onClosePlugin method)

        self.proposalsManager.TOMsStartupFailure.connect(self.setCloseTOMsFlag)
        #self.RestrictionTypeUtilsMixin.tableNames.TOMsStartupFailure.connect(self.closeTOMsTools)

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
        self.closeTOMs = False

        # Check that tables are present
        QgsMessageLog.logMessage("In onInitProposalsPanel. Checking tables", tag="TOMs panel")
        self.proposalsManager.TOMsStartupFailure.connect(self.setCloseTOMsFlag)
        self.tableNames = setupTableNames(self.iface, self.proposalsManager)

        if self.closeTOMs:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table is missing. Unable to start TOMs ..."))
            self.actionProposalsPanel.setChecked(False)
            return

        """if QgsMapLayerRegistry.instance().mapLayersByName("Proposals"):
            self.Proposals = QgsMapLayerRegistry.instance().mapLayersByName("Proposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table Proposals is not present"))
            raise LayerNotPresent"""

        # Set up transaction group
        #self.currTransactionGroup = self.createProposalTransactionGroup(self.tableNames)

        """try:
            currProposalTrans
        except NameError:

            # the Transaction doesn't exist so create it
            currProposalTrans = self.createProposalTransactionGroup(self.Proposals)
            self.currProposalTrans = currProposalTrans

            errMessage = str()

            # Start transaction

            if self.currProposalTrans.begin() == False:
                QgsMessageLog.logMessage("In onProposalDetails. Begin transaction failed: " + self.errMessage, tag="TOMs panel")"""

        self.dock = ProposalPanelDockWidget()
        self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dock)

        # set up tabbing for Panels
        self.setupPanelTabs(self.iface, self.dock)

        #self.dock.closingPlugin.connect(self.closeTOMsTools)

        #self.proposalsManager.proposalChanged.connect(self.onProposalChanged)
        self.proposalsManager.dateChanged.connect(self.onDateChanged)

        # self.dock.filterDate.setDisplayFormat("yyyy-MM-dd")
        self.dock.filterDate.setDisplayFormat("dd-MM-yyyy")
        self.dock.filterDate.setDate(QDate.currentDate())

        self.Proposals = self.tableNames.PROPOSALS

        """if QgsMapLayerRegistry.instance().mapLayersByName("Proposals"):
            self.Proposals = QgsMapLayerRegistry.instance().mapLayersByName("Proposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table Proposals is not present"))
            raise LayerNotPresent"""

        # Set up field details for table  ** what about errors here **
        idxProposalID = self.Proposals.fieldNameIndex("ProposalID")
        idxProposalTitle = self.Proposals.fieldNameIndex("ProposalTitle")
        self.idxCreateDate = self.Proposals.fieldNameIndex("ProposalCreateDate")
        self.idxOpenDate = self.Proposals.fieldNameIndex("ProposalOpenDate")
        self.idxProposalStatusID = self.Proposals.fieldNameIndex("ProposalStatusID")

        self.createProposalcb()

        # set CurrentProposal to be 0

        #self.proposalsManager.setCurrentProposal(0)

        # set up action for when the date is changed from the user interface
        self.dock.filterDate.dateChanged.connect(lambda: self.proposalsManager.setDate(self.dock.filterDate.date()))

        # set up action for "New Proposal"
        self.dock.btn_NewProposal.clicked.connect(self.onNewProposal)

        # set up action for "View Proposal"
        self.dock.btn_ViewProposal.clicked.connect(self.onProposalDetails)

        # self.dock.setUserVisible(True)

        # set up a canvas refresh if there are any changes to the restrictions
        #self.RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]
        #self.RestrictionsInProposalsLayer.editingStopped.connect(self.proposalsManager.updateMapCanvas)
        #self.RestrictionsInProposalsLayer.committedFeaturesAdded.connect(self.proposalsManager.updateMapCanvas)
        #self.RestrictionsInProposalsLayer.committedFeaturesRemoved.connect(self.proposalsManager.updateMapCanvas)

        #self.Proposals.committedFeaturesAdded.connect(self.onNewProposalSaved)
        self.proposalsManager.newProposalCreated.connect(self.onNewProposalCreated)

        # Create a transaction object for the Proposals

        self.proposalTransaction = TOMsTransaction(self.iface, self.proposalsManager)

        self.RestrictionTools.enableTOMsToolbarItems(self.proposalTransaction)
        self.searchBar.enableSearchBar()

        # setup use of "Escape" key to deactive map tools - https://gis.stackexchange.com/questions/133228/how-to-deactivate-my-custom-tool-by-pressing-the-escape-key-using-pyqgis

        """shortcutEsc = QShortcut(QKeySequence(Qt.Key_Escape), self.iface.mainWindow())
        shortcutEsc.setContext(Qt.ApplicationShortcut)
        shortcutEsc.activated.connect(self.iface.mapCanvas().unsetMapTool(self.mapTool))"""
        self.proposalsManager.setCurrentProposal(0)

        if self.closeTOMs == True:
            self.closeTOMsTools()
        else:
            self.proposalsManager.TOMsActivated.emit()


    def setCloseTOMsFlag(self):
        self.closeTOMs = True

    def closeTOMsTools(self):
        # actions when the Proposals Panel is closed or the toolbar "start" is toggled

        QgsMessageLog.logMessage("In closeTOMsTools. Deactivating ...", tag="TOMs panel")

        # TODO: Delete any objects that are no longer needed

        self.proposalTransaction.rollBackTransactionGroup()
        del self.proposalTransaction  # There is another call to this function from the dock.close()

        # Now disable the items from the Toolbar

        self.RestrictionTools.disableTOMsToolbarItems()
        self.searchBar.disableSearchBar()

        self.actionProposalsPanel.setChecked(False)

        # Now close the proposals panel

        self.dock.close()

        # Now clear the filters

        self.proposalsManager.clearRestrictionFilters()

        pass

    def createProposalcb(self):

        QgsMessageLog.logMessage("In createProposalcb", tag="TOMs panel")
        # set up a "NULL" field for "No proposals to be shown"

        self.dock.cb_ProposalsList.currentIndexChanged.connect(self.onProposalListIndexChanged)
        self.dock.cb_ProposalsList.currentIndexChanged.disconnect(self.onProposalListIndexChanged)

        self.dock.cb_ProposalsList.clear()

        currProposalID = 0
        currProposalTitle = "0 - No proposal shown"

        # A little pause for the db to catch up
        #time.sleep(.1)

        QgsMessageLog.logMessage("In createProposalcb: Adding 0", tag="TOMs panel")

        self.dock.cb_ProposalsList.addItem(currProposalTitle, currProposalID)

        """proposalsList = self.Proposals.getFeatures()
        proposalsList.sort()

        query = "\"ProposalStatusID\" = " + str(PROPOSAL_STATUS_IN_PREPARATION())
        request = QgsFeatureRequest().setFilterExpression(query)"""

        # for proposal in proposalsList:
        for proposal in self.Proposals.getFeatures():

            currProposalStatusID = proposal.attribute("ProposalStatusID")
            """QgsMessageLog.logMessage("In createProposalcb. ID: " + str(proposal.attribute("ProposalID")) + " currProposalStatus: " + str(currProposalStatusID),
                                     tag="TOMs panel")"""
            if currProposalStatusID == PROPOSAL_STATUS_IN_PREPARATION():  # 1 = "in preparation"
                currProposalID = proposal.attribute("ProposalID")
                currProposalTitle = proposal.attribute("ProposalTitle")
                self.dock.cb_ProposalsList.addItem(currProposalTitle, currProposalID)

        pass

        # set up action for when the proposal is changed
        self.dock.cb_ProposalsList.currentIndexChanged.connect(self.onProposalListIndexChanged)

    def onChangeProposal(self):
        QgsMessageLog.logMessage("In onChangeProposal", tag="TOMs panel")

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        newProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()
        newProposalID = self.dock.cb_ProposalsList.itemData(newProposal_cbIndex)
        newProposalTitle = self.dock.cb_ProposalsList.currentText()

        self.setCurrentProposal(newProposalID)
        QgsMessageLog.logMessage("In onChangeProposal. newProposalID: " + str(newProposalID) + " newProposalTitle: " + str(newProposalTitle), tag="TOMs panel")

        # Set the project variable

        reply = QMessageBox.information(self.iface.mainWindow(), "Information", "All changes will be rolled back", QMessageBox.Ok)

    def onNewProposal(self):
        QgsMessageLog.logMessage("In onNewProposal", tag="TOMs panel")

        # set up a transaction
        self.proposalTransaction.startTransactionGroup()

        # create a new Proposal

        self.newProposal = QgsFeature(self.Proposals.fields())
        #newProposal.setGeometry(QgsGeometry())

        self.newProposal[self.idxCreateDate] = self.proposalsManager.date()
        self.newProposal[self.idxOpenDate] = self.proposalsManager.date()
        self.newProposal[self.idxProposalStatusID] = PROPOSAL_STATUS_IN_PREPARATION()
        self.newProposal.setGeometry(QgsGeometry())

        self.proposalDialog = self.iface.getFeatureForm(self.Proposals, self.newProposal)

        self.proposalDialog.attributeForm().disconnectButtonBox()
        self.button_box = self.proposalDialog.findChild(QDialogButtonBox, "button_box")

        if self.button_box is None:
            QgsMessageLog.logMessage(
                "In onNewProposal. button box not found",
                tag="TOMs panel")

        self.button_box.accepted.disconnect(self.proposalDialog.accept)
        self.button_box.accepted.connect(functools.partial(self.onSaveProposalFormDetails, self.newProposal, self.proposalDialog, self.proposalTransaction))

        self.button_box.rejected.disconnect(self.proposalDialog.reject)
        self.button_box.rejected.connect(self.onRejectProposalDetailsFromForm)

        self.proposalDialog.attributeForm().attributeChanged.connect(functools.partial(self.onAttributeChangedClass2, self.newProposal, self.Proposals))

        self.proposalDialog.show()

        #self.iface.openFeatureForm(self.Proposals, newProposal, False, True)

        #self.createProposalcb()
        pass

    def onNewProposalCreated(self, proposal):
        QgsMessageLog.logMessage("In onNewProposalSaved. New proposal = " + str(proposal), tag="TOMs panel")

        self.createProposalcb()

        # change the list to show the new proposal

        for currIndex in range(self.dock.cb_ProposalsList.count()):
            currProposalID = self.dock.cb_ProposalsList.itemData(currIndex)
            #QgsMessageLog.logMessage("In onNewProposalSaved. checking index = " + str(currIndex), tag="TOMs panel")
            if currProposalID == proposal:
                QgsMessageLog.logMessage("In onNewProposalSaved. index found as " + str(currIndex), tag="TOMs panel")
                self.dock.cb_ProposalsList.setCurrentIndex(currIndex)
                return

        return

        #def onSaveProposalDetailsFromForm(self):
        #self.onSaveProposalFormDetails(self.newProposal, self.Proposals, self.proposalDialog, self.currTransaction)

    def onRejectProposalDetailsFromForm(self):

        self.Proposals.destroyEditCommand()
        self.proposalDialog.reject()

        #self.rollbackCurrentEdits()

        self.proposalTransaction.rollBackTransactionGroup()


        pass

    def onProposalDetails(self):
        QgsMessageLog.logMessage("In onProposalDetails", tag="TOMs panel")

        # set up transaction
        self.proposalTransaction.startTransactionGroup()

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        currProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()

        if currProposal_cbIndex == 0:
            return  # there is nothing to see

        currProposalID = self.dock.cb_ProposalsList.itemData(currProposal_cbIndex)

        self.currProposal = self.getProposal(currProposalID)

        self.proposalDialog = self.iface.getFeatureForm(self.Proposals, self.currProposal)

        self.proposalDialog.attributeForm().disconnectButtonBox()
        self.button_box = self.proposalDialog.findChild(QDialogButtonBox, "button_box")

        if self.button_box is None:
            QgsMessageLog.logMessage(
                "In onNewProposal. button box not found",
                tag="TOMs panel")

        self.button_box.accepted.disconnect(self.proposalDialog.accept)
        self.button_box.accepted.connect(functools.partial(self.onSaveProposalFormDetails, self.currProposal, self.proposalDialog, self.proposalTransaction))

        self.button_box.rejected.disconnect(self.proposalDialog.reject)
        self.button_box.rejected.connect(self.onRejectProposalDetailsFromForm)

        self.proposalDialog.attributeForm().attributeChanged.connect(functools.partial(self.onAttributeChangedClass2, self.currProposal, self.Proposals))

        self.proposalDialog.show()

        pass

    def onProposalListIndexChanged(self):
        QgsMessageLog.logMessage("In onProposalListIndexChanged.", tag="TOMs panel")
        #currProposal = self.proposalsManager.currentProposal()
        #currProposalIdx = self.dock.cb_ProposalsList.findData(currProposal)
        #self.dock.cb_ProposalsList.setCurrentIndex(currProposalIdx)

        currProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()
        QgsMessageLog.logMessage("In onProposalListIndexChanged. Current Index = " + str(currProposal_cbIndex), tag="TOMs panel")
        currProposalID = self.dock.cb_ProposalsList.itemData(currProposal_cbIndex)
        self.proposalsManager.setCurrentProposal(currProposalID)

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

        """ onChangeProposalStatus(self):
        QgsMessageLog.logMessage("In onChangeProposalStatus. Proposed status: " + str(self.Proposals.fieldNameIndex("ProposalStatusID")), tag="TOMs panel")

        # check to see if the proposal is "Accepted"
        acceptProposal = False

        newProposalStatus = int(self.Proposals.fieldNameIndex("ProposalStatusID"))

        if newProposalStatus == 1:    # should be 2 but with list ...

            # if so, check to see if this was intended

            reply = QMessageBox.question(self.iface.mainWindow(), 'Confirm changes to Proposal',
                                         'Are you you want to accept this proposal?. Accepting will make all the proposed changes permanent.', QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:
                # make the changes permanent
                acceptProposal = True

        # bring the Proposals dislog back to the front

        self.dlg.activateWindow()

        return acceptProposal"""

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

