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
from qgis.PyQt.QtWidgets import (
    QMessageBox,
    QAction,
    QDialogButtonBox, QToolButton
)

from qgis.PyQt.QtGui import (
    QIcon
)

from qgis.PyQt.QtCore import (
    QCoreApplication,
    Qt
)
# from qgis.PyQt import QtCore, QtGui, QtWidgets
# from qgis.PyQt.QtGui import *
# from qgis import core
from qgis.core import (
    Qgis,
    # QgsMapLayerRegistry,
    QgsProject
)

import functools

from TOMs.ui.ProposalPanel_dockwidget import ProposalPanelDockWidget
#from proposal_details_dialog import proposalDetailsDialog
from TOMs.core.proposalsManager import *

from TOMs.manage_restriction_details import manageRestrictionDetails
from TOMs.search_bar import searchBar
from TOMs.InstantPrint.TOMsInstantPrintTool import TOMsInstantPrintTool

from .restrictionTypeUtilsClass import RestrictionTypeUtilsMixin, TOMsLayers
from .core.TOMsTransaction import (TOMsTransaction)

from TOMs.core.TOMsMessageLog import TOMsMessageLog

from TOMs.constants import (
    ProposalStatus
)

class proposalsPanel(RestrictionTypeUtilsMixin):
    
    def __init__(self, iface, TOMsToolBar):
        #def __init__(self, iface, TOMsMenu, proposalsManager):

        # Save reference to the QGIS interface
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.TOMsToolBar = TOMsToolBar

        self.actionProposalsPanel = QAction(QIcon(":/plugins/TOMs/resources/TOMsStart.png"),
                               QCoreApplication.translate("MyPlugin", "Start TOMs"), self.iface.mainWindow())
        self.actionProposalsPanel.setCheckable(True)

        self.TOMsToolBar.addAction(self.actionProposalsPanel)

        self.actionProposalsPanel.triggered.connect(self.onInitProposalsPanel)

        self.newProposalRequired = False

        self.proposalsManager = TOMsProposalsManager(self.iface)
        self.tableNames = self.proposalsManager.tableNames

        # Now set up the toolbar

        self.RestrictionTools = manageRestrictionDetails(self.iface, self.TOMsToolBar, self.proposalsManager)

        #self.searchBar = searchBar(self.iface, self.TOMsToolBar, self.proposalsManager)
        self.searchBar = searchBar(self.iface, self.TOMsToolBar)

        # Add print to the search toolbar

        self.tool = TOMsInstantPrintTool(self.iface, self.proposalsManager)

        # Add in details of the Instant Print plugin
        self.toolButton = QToolButton(self.iface.mainWindow())
        self.toolButton.setIcon(QIcon(":/plugins/TOMs/InstantPrint/icons/icon.png"))
        self.toolButton.setCheckable(True)
        self.printButtonAction = self.TOMsToolBar.addWidget(self.toolButton)

        self.toolButton.toggled.connect(self.__enablePrintTool)
        self.iface.mapCanvas().mapToolSet.connect(self.__onPrintToolSet)

        self.searchBar.disableSearchBar()
        # print tool
        self.toolButton.setEnabled(False)
        self.RestrictionTools.disableTOMsToolbarItems()

        TOMsMessageLog.logMessage("Finished proposalsPanel init ...", level=Qgis.Warning)

    def __enablePrintTool(self, active):
        self.tool.setEnabled(active)

    def __onPrintToolSet(self, tool):
        if tool != self.tool:
            self.toolButton.setChecked(False)

    def onInitProposalsPanel(self):
        """Filter main layer based on date and state options"""
        
        TOMsMessageLog.logMessage("In onInitProposalsPanel", level=Qgis.Info)

        #print "** STARTING ProposalPanel"

        # dockwidget may not exist if:
        #    first run of plugin
        #    removed on close (see self.onClosePlugin method)

        # self.TOMSLayers.TOMsStartupFailure.connect(self.setCloseTOMsFlag)
        #self.RestrictionTypeUtilsMixin.tableNames.TOMsStartupFailure.connect(self.closeTOMsTools)

        if self.actionProposalsPanel.isChecked():

            TOMsMessageLog.logMessage("In onInitProposalsPanel. Activating ...", level=Qgis.Info)

            self.openTOMsTools()

        else:

            TOMsMessageLog.logMessage("In onInitProposalsPanel. Deactivating ...", level=Qgis.Info)

            self.closeTOMsTools()

        pass

    def openTOMsTools(self):
        # actions when the Proposals Panel is closed or the toolbar "start" is toggled

        TOMsMessageLog.logMessage("In openTOMsTools. Activating ...", level=Qgis.Info)
        self.closeTOMs = False

        # Check that tables are present
        TOMsMessageLog.logMessage("In onInitProposalsPanel. Checking tables", level=Qgis.Info)
        self.tableNames.TOMsLayersNotFound.connect(self.setCloseTOMsFlag)

        self.tableNames.getLayers()

        if self.closeTOMs:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Unable to start TOMs ..."))
            self.actionProposalsPanel.setChecked(False)
            return

            # QMessageBox.information(self.iface.mainWindow(), "ERROR", ("TOMsActivated about to emit"))
        self.proposalsManager.TOMsActivated.emit()

        self.dock = ProposalPanelDockWidget()
        self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dock)

        # set up tabbing for Panels
        self.setupPanelTabs(self.iface, self.dock)

        self.proposalsManager.dateChanged.connect(self.onDateChanged)
        self.dock.filterDate.setDisplayFormat("dd-MM-yyyy")
        self.dock.filterDate.setDate(QDate.currentDate())

        self.Proposals = self.tableNames.setLayer("Proposals")

        # Set up field details for table  ** what about errors here **
        idxProposalID = self.Proposals.fields().indexFromName("ProposalID")
        self.idxProposalTitle = self.Proposals.fields().indexFromName("ProposalTitle")
        self.idxCreateDate = self.Proposals.fields().indexFromName("ProposalCreateDate")
        self.idxOpenDate = self.Proposals.fields().indexFromName("ProposalOpenDate")
        self.idxProposalStatusID = self.Proposals.fields().indexFromName("ProposalStatusID")

        self.createProposalcb()

        # set CurrentProposal to be 0

        #self.proposalsManager.setCurrentProposal(0)

        # set up action for when the date is changed from the user interface
        self.dock.filterDate.dateChanged.connect(lambda: self.proposalsManager.setDate(self.dock.filterDate.date()))

        # set up action for "New Proposal"
        self.dock.btn_NewProposal.clicked.connect(self.onNewProposal)

        # set up action for "View Proposal"
        self.dock.btn_ViewProposal.clicked.connect(self.onProposalDetails)

        self.proposalsManager.newProposalCreated.connect(self.onNewProposalCreated)

        # Create a transaction object for the Proposals

        self.proposalTransaction = TOMsTransaction(self.iface, self.proposalsManager)

        self.RestrictionTools.enableTOMsToolbarItems(self.proposalTransaction)
        self.searchBar.enableSearchBar()
        # print tool
        self.toolButton.setEnabled(True)

        # setup use of "Escape" key to deactive map tools - https://gis.stackexchange.com/questions/133228/how-to-deactivate-my-custom-tool-by-pressing-the-escape-key-using-pyqgis

        """shortcutEsc = QShortcut(QKeySequence(Qt.Key_Escape), self.iface.mainWindow())
        shortcutEsc.setContext(Qt.ApplicationShortcut)
        shortcutEsc.activated.connect(self.iface.mapCanvas().unsetMapTool(self.mapTool))"""
        self.proposalsManager.setCurrentProposal(0)

        # TODO: Deal with the change of project ... More work required on this
        # self.TOMsProject = QgsProject.instance()
        # self.TOMsProject.cleared.connect(self.closeTOMsTools)

    def setCloseTOMsFlag(self):
        self.closeTOMs = True

    def closeTOMsTools(self):
        # actions when the Proposals Panel is closed or the toolbar "start" is toggled

        TOMsMessageLog.logMessage("In closeTOMsTools. Deactivating ...", level=Qgis.Info)

        # TODO: Delete any objects that are no longer needed

        self.proposalTransaction.rollBackTransactionGroup()
        del self.proposalTransaction  # There is another call to this function from the dock.close()

        # Now disable the items from the Toolbar

        self.RestrictionTools.disableTOMsToolbarItems()
        self.searchBar.disableSearchBar()
        # print tool
        self.toolButton.setEnabled(False)

        self.actionProposalsPanel.setChecked(False)

        # Now close the proposals panel

        self.dock.close()

        # Now clear the filters

        self.proposalsManager.clearRestrictionFilters()

        pass

    def createProposalcb(self):

        TOMsMessageLog.logMessage("In createProposalcb", level=Qgis.Info)
        # set up a "NULL" field for "No proposals to be shown"

        #self.dock.cb_ProposalsList.currentIndexChanged.connect(self.onProposalListIndexChanged)
        #self.dock.cb_ProposalsList.currentIndexChanged.disconnect(self.onProposalListIndexChanged)

        self.dock.cb_ProposalsList.clear()

        currProposalID = 0
        currProposalTitle = "0 - No proposal shown"

        TOMsMessageLog.logMessage("In createProposalcb: Adding 0", level=Qgis.Info)

        self.dock.cb_ProposalsList.addItem(currProposalTitle, currProposalID)

        for (currProposalID, currProposalTitle, currProposalStatusID, currProposalOpenDate, currProposal) in sorted(self.proposalsManager.getProposalsListWithStatus(ProposalStatus.IN_PREPARATION), key=lambda f: f[1]):
            TOMsMessageLog.logMessage("In createProposalcb: proposalID: " + str(currProposalID) + ":" + currProposalTitle, level=Qgis.Info)
            self.dock.cb_ProposalsList.addItem(currProposalTitle, currProposalID)

        # set up action for when the proposal is changed
        self.dock.cb_ProposalsList.currentIndexChanged.connect(self.onProposalListIndexChanged)

    def onChangeProposal(self):
        TOMsMessageLog.logMessage("In onChangeProposal", level=Qgis.Info)

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        newProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()
        newProposalID = self.dock.cb_ProposalsList.itemData(newProposal_cbIndex)
        newProposalTitle = self.dock.cb_ProposalsList.currentText()

        self.setCurrentProposal(newProposalID)
        TOMsMessageLog.logMessage("In onChangeProposal. newProposalID: " + str(newProposalID) + " newProposalTitle: " + str(newProposalTitle), level=Qgis.Info)

        # Set the project variable

        reply = QMessageBox.information(self.iface.mainWindow(), "Information", "All changes will be rolled back", QMessageBox.Ok)

    def onNewProposal(self):
        TOMsMessageLog.logMessage("In onNewProposal", level=Qgis.Info)

        # set up a transaction
        self.proposalTransaction.startTransactionGroup()

        # create a new Proposal

        """self.newProposal = QgsFeature(self.Proposals.fields())
        #newProposal.setGeometry(QgsGeometry())

        self.newProposal[self.idxProposalTitle] = ''   #str(uuid.uuid4())
        self.newProposal[self.idxCreateDate] = self.proposalsManager.date()
        self.newProposal[self.idxOpenDate] = self.proposalsManager.date()
        self.newProposal[self.idxProposalStatusID] = ProposalStatus.IN_PREPARATION
        self.newProposal.setGeometry(QgsGeometry())

        self.Proposals.addFeature(self.newProposal)  # TH (added for v3)"""
        self.newProposalObject = self.proposalsManager.currentProposalObject().initialiseProposal()
        self.newProposal = self.proposalsManager.currentProposalObject().getProposalRecord()

        self.proposalDialog = self.iface.getFeatureForm(self.Proposals, self.newProposal)

        #self.proposalDialog.attributeForm().disconnectButtonBox()
        self.button_box = self.proposalDialog.findChild(QDialogButtonBox, "button_box")

        if self.button_box is None:
            TOMsMessageLog.logMessage(
                "In onNewProposal. button box not found",
                level=Qgis.Info)

            #self.button_box.accepted.disconnect()
        self.button_box.accepted.connect(functools.partial(self.onSaveProposalFormDetails, self.newProposal, self.newProposalObject, self.Proposals, self.proposalDialog, self.proposalTransaction))

        #self.button_box.rejected.disconnect()
        self.button_box.rejected.connect(self.onRejectProposalDetailsFromForm)

        self.proposalDialog.attributeForm().attributeChanged.connect(functools.partial(self.onAttributeChangedClass2, self.newProposal, self.Proposals))

        self.proposalDialog.show()

        #self.iface.openFeatureForm(self.Proposals, newProposal, False, True)

        #self.createProposalcb()
        pass

    def onNewProposalCreated(self, proposal):
        TOMsMessageLog.logMessage("In onNewProposalCreated. New proposal = " + str(proposal), level=Qgis.Info)

        self.createProposalcb()

        # change the list to show the new proposal

        for currIndex in range(self.dock.cb_ProposalsList.count()):
            currProposalID = self.dock.cb_ProposalsList.itemData(currIndex)
            #TOMsMessageLog.logMessage("In onNewProposalSaved. checking index = " + str(currIndex), level=Qgis.Info)
            if currProposalID == proposal:
                TOMsMessageLog.logMessage("In onNewProposalCreated. index found as " + str(currIndex), level=Qgis.Info)
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
        TOMsMessageLog.logMessage("In onProposalDetails", level=Qgis.Info)

        # set up transaction
        self.proposalTransaction.startTransactionGroup()

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        currProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()

        if currProposal_cbIndex == 0:
            return  # there is nothing to see

        currProposalID = self.dock.cb_ProposalsList.itemData(currProposal_cbIndex)

        # self.currProposal = self.getProposal(currProposalID)
        self.currProposalObject = self.proposalsManager.currentProposalObject()
        self.currProposal = self.proposalsManager.currentProposalObject().getProposalRecord()
        self.proposalDialog = self.iface.getFeatureForm(self.Proposals, self.currProposal)

        #self.proposalDialog.attributeForm().disconnectButtonBox()
        self.button_box = self.proposalDialog.findChild(QDialogButtonBox, "button_box")

        if self.button_box is None:
            TOMsMessageLog.logMessage(
                "In onNewProposal. button box not found",
                level=Qgis.Info)

        self.button_box.accepted.disconnect()
        self.button_box.accepted.connect(functools.partial(self.onSaveProposalFormDetails, self.currProposal, self.currProposalObject, self.Proposals, self.proposalDialog, self.proposalTransaction))

        self.button_box.rejected.disconnect()
        self.button_box.rejected.connect(self.onRejectProposalDetailsFromForm)

        self.proposalDialog.attributeForm().attributeChanged.connect(functools.partial(self.onAttributeChangedClass2, self.currProposal, self.Proposals))

        self.proposalDialog.show()

        pass

    def onProposalListIndexChanged(self):
        TOMsMessageLog.logMessage("In onProposalListIndexChanged.", level=Qgis.Info)
        #currProposal = self.proposalsManager.currentProposal()
        #currProposalIdx = self.dock.cb_ProposalsList.findData(currProposal)
        #self.dock.cb_ProposalsList.setCurrentIndex(currProposalIdx)

        currProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()
        TOMsMessageLog.logMessage("In onProposalListIndexChanged. Current Index = " + str(currProposal_cbIndex), level=Qgis.Info)
        currProposalID = self.dock.cb_ProposalsList.itemData(currProposal_cbIndex)
        self.proposalsManager.setCurrentProposal(currProposalID)

        TOMsMessageLog.logMessage("In onProposalChanged. Zoom to extents", level=Qgis.Info)
        """if self.proposalsManager.getProposalBoundingBox():
            TOMsMessageLog.logMessage("In onProposalChanged. Bounding box found", level=Qgis.Info)
            self.iface.mapCanvas().setExtent(self.proposalsManager.getProposalBoundingBox())
            self.iface.mapCanvas().refresh()"""

    def updateCurrentProposal(self):
        TOMsMessageLog.logMessage("In updateCurrentProposal.", level=Qgis.Info)
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
        TOMsMessageLog.logMessage("In onDateChanged.", level=Qgis.Info)
        date = self.proposalsManager.date()
        self.dock.filterDate.setDate(date)

        """ onChangeProposalStatus(self):
        TOMsMessageLog.logMessage("In onChangeProposalStatus. Proposed status: " + str(self.Proposals.fields().indexFromName("ProposalStatusID")), level=Qgis.Info)

        # check to see if the proposal is "Accepted"
        acceptProposal = False

        newProposalStatus = int(self.Proposals.fields().indexFromName("ProposalStatusID"))

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
        TOMsMessageLog.logMessage("In getRestrictionLayerTableID.", level=Qgis.Info)
        # find the ID for the layer within the table "

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers2")[0]

        layersTableID = 0

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for layer in RestrictionsLayers.getFeatures():
            if layer.attribute("RestrictionLayerName") == str(currRestLayer.name()):
                layersTableID = layer.attribute("id")

        TOMsMessageLog.logMessage("In getRestrictionLayerTableID. layersTableID: " + str(layersTableID), level=Qgis.Info)

        return layersTableID"""

    def getProposal(self, proposalID):
        TOMsMessageLog.logMessage("In getProposal.", level=Qgis.Info)

        # proposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("Proposals")[0]  -- v2
        proposalsLayer = QgsProject.instance().mapLayersByName("Proposals")[0]

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for currProposal in proposalsLayer.getFeatures():
            if currProposal.attribute("ProposalID") == proposalID:
                return currProposal

        return None

        pass

