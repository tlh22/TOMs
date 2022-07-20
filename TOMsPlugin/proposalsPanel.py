# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# -----------------------------------------------------------
# Tim Hancock/Matthias Kuhn 2017
# Oslandia 2022

import functools
import re

from qgis.core import Qgis, QgsProject  # QgsMapLayerRegistry,
from qgis.PyQt.QtCore import QCoreApplication, QDate, Qt
from qgis.PyQt.QtGui import QIcon

# Import the PyQt and QGIS libraries
from qgis.PyQt.QtWidgets import (
    QAction,
    QDialogButtonBox,
    QMessageBox,
    QToolButton,
)
from qgis.utils import iface

from .constants import ProposalStatus
from .core.proposalsManager import TOMsProposalsManager
from .core.tomsMessageLog import TOMsMessageLog
from .core.tomsTransaction import TOMsTransaction
from .instantPrint.tomsInstantPrintTool import TOMsInstantPrintTool
from .manageRestrictionDetails import ManageRestrictionDetails
from .restrictionTypeUtilsClass import RestrictionTypeUtilsMixin, TOMsConfigFile
from .searchBar import SearchBar
from .ui.proposalPanelDockwidget import ProposalPanelDockWidget


class ProposalsPanel(RestrictionTypeUtilsMixin):
    def __init__(self, tomsToolbar):

        RestrictionTypeUtilsMixin.__init__(self)

        # Save reference to the QGIS interface
        self.canvas = iface.mapCanvas()
        self.tomsToolbar = tomsToolbar

        self.actionProposalsPanel = QAction(
            QIcon(":/plugins/TOMs/resources/TOMsStart.png"),
            QCoreApplication.translate("MyPlugin", "Start TOMs"),
            iface.mainWindow(),
        )
        self.actionProposalsPanel.setCheckable(True)

        self.tomsToolbar.addAction(self.actionProposalsPanel)

        self.actionProposalsPanel.triggered.connect(self.onInitProposalsPanel)

        self.newProposalRequired = False

        self.proposalsManager = TOMsProposalsManager()
        self.tableNames = self.proposalsManager.tableNames

        # Now set up the toolbar

        self.restrictionTools = ManageRestrictionDetails(
            self.tomsToolbar, self.proposalsManager
        )

        self.searchBar = SearchBar(self.tomsToolbar)

        # Add print to the search toolbar

        self.tool = TOMsInstantPrintTool(self.proposalsManager)

        # Add in details of the Instant Print plugin
        self.toolButton = QToolButton(iface.mainWindow())
        self.toolButton.setIcon(QIcon(":/plugins/TOMs/InstantPrint/icons/icon.png"))
        self.toolButton.setCheckable(True)
        self.toolButton.setToolTip("Print")
        self.printButtonAction = self.tomsToolbar.addWidget(self.toolButton)

        self.toolButton.toggled.connect(self.__enablePrintTool)
        iface.mapCanvas().mapToolSet.connect(self.__onPrintToolSet)

        self.searchBar.disableSearchBar()
        # print tool
        self.toolButton.setEnabled(False)
        self.restrictionTools.disableTOMsToolbarItems()

        self.closeTOMs = False
        self.tomsConfigFileObject = None
        self.dock = None
        self.proposals = None
        self.idxProposalTitle = None
        self.idxCreateDate = None
        self.idxOpenDate = None
        self.idxProposalStatusID = None
        self.proposalTransaction = None
        self.newProposalObject = None
        self.newProposal = None
        self.proposalDialog = None
        self.buttonBox = None
        self.currProposalObject = None
        self.currProposal = None

        TOMsMessageLog.logMessage(
            "Finished proposalsPanel init ...", level=Qgis.Warning
        )

    def __enablePrintTool(self, active):  # pylint: disable=invalid-name
        self.tool.setEnabled(active)

    def __onPrintToolSet(self, tool):  # pylint: disable=invalid-name
        if tool != self.tool:
            self.toolButton.setChecked(False)

    def onInitProposalsPanel(self):
        """Filter main layer based on date and state options"""

        TOMsMessageLog.logMessage("In onInitProposalsPanel", level=Qgis.Info)

        # dockwidget may not exist if:
        #    first run of plugin
        #    removed on close (see self.onClosePlugin method)

        # self.TOMSLayers.TOMsStartupFailure.connect(self.setCloseTOMsFlag)
        # self.RestrictionTypeUtilsMixin.tableNames.TOMsStartupFailure.connect(self.closeTOMsTools)

        if self.actionProposalsPanel.isChecked():

            TOMsMessageLog.logMessage(
                "In onInitProposalsPanel. Activating ...", level=Qgis.Info
            )

            self.openTOMsTools()

        else:

            TOMsMessageLog.logMessage(
                "In onInitProposalsPanel. Deactivating ...", level=Qgis.Info
            )

            self.closeTOMsTools()

    def openTOMsTools(self):
        # actions when the Proposals Panel is closed or the toolbar "start" is toggled

        TOMsMessageLog.logMessage("In openTOMsTools. Activating ...", level=Qgis.Info)
        self.closeTOMs = False

        # Check that tables are present
        TOMsMessageLog.logMessage(
            "In onInitProposalsPanel. Checking tables", level=Qgis.Info
        )
        self.tableNames.tomsLayersNotFound.connect(self.setCloseTOMsFlag)

        self.tomsConfigFileObject = TOMsConfigFile()
        self.tomsConfigFileObject.tomsConfigFileNotFound.connect(self.setCloseTOMsFlag)
        self.tomsConfigFileObject.initialiseTOMsConfigFile()

        self.tableNames.setLayers(self.tomsConfigFileObject)

        if self.closeTOMs:
            QMessageBox.information(
                iface.mainWindow(), "ERROR", ("Unable to start TOMs ...")
            )
            self.actionProposalsPanel.setChecked(False)
            return

        self.proposalsManager.tomsActivated.emit()

        self.dock = ProposalPanelDockWidget()
        iface.addDockWidget(Qt.LeftDockWidgetArea, self.dock)

        # set up tabbing for Panels
        self.setupPanelTabs(self.dock)

        self.proposalsManager.dateChanged.connect(self.onDateChanged)
        self.dock.filterDate.setDisplayFormat("dd-MM-yyyy")
        self.dock.filterDate.setDate(QDate.currentDate())

        self.proposals = self.tableNames.getLayer("Proposals")

        # Set up field details for table  ** what about errors here **
        self.idxProposalTitle = self.proposals.fields().indexFromName("ProposalTitle")
        self.idxCreateDate = self.proposals.fields().indexFromName("ProposalCreateDate")
        self.idxOpenDate = self.proposals.fields().indexFromName("ProposalOpenDate")
        self.idxProposalStatusID = self.proposals.fields().indexFromName(
            "ProposalStatusID"
        )

        self.createProposalcb()

        # set CurrentProposal to be 0

        # self.proposalsManager.setCurrentProposal(0)

        # set up action for when the date is changed from the user interface
        self.dock.filterDate.dateChanged.connect(
            lambda: self.proposalsManager.setDate(self.dock.filterDate.date())
        )

        # set up action for "New Proposal"
        self.dock.btn_NewProposal.clicked.connect(self.onNewProposal)

        # set up action for "View Proposal"
        self.dock.btn_ViewProposal.clicked.connect(self.onProposalDetails)

        self.proposalsManager.newProposalCreated.connect(self.onNewProposalCreated)

        # Create a transaction object for the Proposals

        self.proposalTransaction = TOMsTransaction(self.proposalsManager)

        self.restrictionTools.enableTOMsToolbarItems(self.proposalTransaction)
        self.searchBar.enableSearchBar()
        # print tool
        self.toolButton.setEnabled(True)
        self.setLabelUpdateTriggers()

        # setup use of "Escape" key to deactive map tools
        # https://gis.stackexchange.com/questions/133228/how-to-deactivate-my-custom-tool-by-pressing-the-escape-key-using-pyqgis

        self.proposalsManager.setCurrentProposal(0)

        # TODO: Deal with the change of project ... More work required on this
        # self.TOMsProject = QgsProject.instance()
        # self.TOMsProject.cleared.connect(self.closeTOMsTools)

    def setCloseTOMsFlag(self):
        self.closeTOMs = True

    def closeTOMsTools(self):
        # actions when the Proposals Panel is closed or the toolbar "start" is toggled

        TOMsMessageLog.logMessage(
            "In closeTOMsTools. Deactivating ...", level=Qgis.Info
        )

        # TODO: Delete any objects that are no longer needed

        try:
            self.proposalTransaction.rollBackTransactionGroup()
            del (
                self.proposalTransaction
            )  # There is another call to this function from the dock.close()
        except Exception as e:
            TOMsMessageLog.logMessage(
                "closeTOMsTools: issue with transactions {}".format(e), level=Qgis.Info
            )

        # Now disable the items from the Toolbar

        self.restrictionTools.disableTOMsToolbarItems()
        self.searchBar.disableSearchBar()
        # print tool
        self.toolButton.setEnabled(False)

        self.actionProposalsPanel.setChecked(False)

        self.unsetLabelUpdateTriggers()

        # Now close the proposals panel

        self.dock.close()

        # Now clear the filters

        self.proposalsManager.clearRestrictionFilters()

        # reset path names
        self.tableNames.removePathFromLayerForms()

    def createProposalcb(self):

        TOMsMessageLog.logMessage("In createProposalcb", level=Qgis.Info)
        # set up a "NULL" field for "No proposals to be shown"

        self.dock.cb_ProposalsList.clear()

        currProposalID = 0
        currProposalTitle = "0 - No proposal shown"

        TOMsMessageLog.logMessage("In createProposalcb: Adding 0", level=Qgis.Info)

        self.dock.cb_ProposalsList.addItem(currProposalTitle, currProposalID)

        for (currProposalID, currProposalTitle, _, _, _,) in sorted(
            self.proposalsManager.getProposalsListWithStatus(
                ProposalStatus.IN_PREPARATION
            ),
            key=lambda f: f[1],
        ):
            TOMsMessageLog.logMessage(
                "In createProposalcb: proposalID: "
                + str(currProposalID)
                + ":"
                + currProposalTitle,
                level=Qgis.Info,
            )
            self.dock.cb_ProposalsList.addItem(currProposalTitle, currProposalID)

        # set up action for when the proposal is changed
        self.dock.cb_ProposalsList.currentIndexChanged.connect(
            self.onProposalListIndexChanged
        )

    def onChangeProposal(self):
        TOMsMessageLog.logMessage("In onChangeProposal", level=Qgis.Info)

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        newProposalID = self.dock.cb_ProposalsList.currentData()
        newProposalTitle = self.dock.cb_ProposalsList.currentText()

        self.proposalsManager.setCurrentProposal(newProposalID)
        TOMsMessageLog.logMessage(
            "In onChangeProposal. newProposalID: "
            + str(newProposalID)
            + " newProposalTitle: "
            + str(newProposalTitle),
            level=Qgis.Info,
        )

        # Set the project variable

        QMessageBox.information(
            iface.mainWindow(),
            "Information",
            "All changes will be rolled back",
            QMessageBox.Ok,
        )

    def onNewProposal(self):
        TOMsMessageLog.logMessage("In onNewProposal", level=Qgis.Info)

        # set up a transaction
        self.proposalTransaction.startTransactionGroup()

        # create a new Proposal

        self.newProposalObject = (
            self.proposalsManager.currentProposalObject().initialiseProposal()
        )
        self.newProposal = (
            self.proposalsManager.currentProposalObject().getProposalRecord()
        )

        self.proposalDialog = iface.getFeatureForm(self.proposals, self.newProposal)

        # self.proposalDialog.attributeForm().disconnectButtonBox()
        self.buttonBox = self.proposalDialog.findChild(QDialogButtonBox, "button_box")

        if self.buttonBox is None:
            TOMsMessageLog.logMessage(
                "In onNewProposal. button box not found", level=Qgis.Info
            )

            # self.button_box.accepted.disconnect()
        self.buttonBox.accepted.connect(
            functools.partial(
                self.onSaveProposalFormDetails,
                self.newProposal,
                self.newProposalObject,
                self.proposals,
                self.proposalDialog,
                self.proposalTransaction,
            )
        )

        self.buttonBox.rejected.connect(self.onRejectProposalDetailsFromForm)

        self.proposalDialog.attributeForm().attributeChanged.connect(
            functools.partial(
                self.onAttributeChangedClass2, self.newProposal, self.proposals
            )
        )

        self.proposalDialog.show()

    def onNewProposalCreated(self, proposal):
        TOMsMessageLog.logMessage(
            "In onNewProposalCreated. New proposal = " + str(proposal), level=Qgis.Info
        )

        self.createProposalcb()

        # change the list to show the new proposal

        for currIndex in range(self.dock.cb_ProposalsList.count()):
            currProposalID = self.dock.cb_ProposalsList.itemData(currIndex)
            if currProposalID == proposal:
                TOMsMessageLog.logMessage(
                    "In onNewProposalCreated. index found as " + str(currIndex),
                    level=Qgis.Info,
                )
                self.dock.cb_ProposalsList.setCurrentIndex(currIndex)
                return

        return

    def onRejectProposalDetailsFromForm(self):

        self.proposals.destroyEditCommand()
        self.proposalDialog.reject()

        # self.rollbackCurrentEdits()

        self.proposalTransaction.rollBackTransactionGroup()

    def onProposalDetails(self):
        TOMsMessageLog.logMessage("In onProposalDetails", level=Qgis.Info)

        # set up transaction
        self.proposalTransaction.startTransactionGroup()

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        currProposalCbIndex = self.dock.cb_ProposalsList.currentIndex()

        if currProposalCbIndex == 0:
            return  # there is nothing to see

        # self.currProposal = self.getProposal(currProposalID)
        self.currProposalObject = self.proposalsManager.currentProposalObject()
        self.currProposal = (
            self.proposalsManager.currentProposalObject().getProposalRecord()
        )
        self.proposalDialog = iface.getFeatureForm(self.proposals, self.currProposal)

        self.buttonBox = self.proposalDialog.findChild(QDialogButtonBox, "button_box")

        if self.buttonBox is None:
            TOMsMessageLog.logMessage(
                "In onNewProposal. button box not found", level=Qgis.Info
            )

        self.buttonBox.accepted.disconnect()
        self.buttonBox.accepted.connect(
            functools.partial(
                self.onSaveProposalFormDetails,
                self.currProposal,
                self.currProposalObject,
                self.proposals,
                self.proposalDialog,
                self.proposalTransaction,
            )
        )

        self.buttonBox.rejected.disconnect()
        self.buttonBox.rejected.connect(self.onRejectProposalDetailsFromForm)

        self.proposalDialog.attributeForm().attributeChanged.connect(
            functools.partial(
                self.onAttributeChangedClass2, self.currProposal, self.proposals
            )
        )

        self.proposalDialog.show()

    def onProposalListIndexChanged(self):
        TOMsMessageLog.logMessage("In onProposalListIndexChanged.", level=Qgis.Info)

        currProposalCbIndex = self.dock.cb_ProposalsList.currentIndex()
        TOMsMessageLog.logMessage(
            "In onProposalListIndexChanged. Current Index = "
            + str(currProposalCbIndex),
            level=Qgis.Info,
        )
        currProposalID = self.dock.cb_ProposalsList.currentData()
        self.proposalsManager.setCurrentProposal(currProposalID)

        TOMsMessageLog.logMessage(
            "In onProposalChanged. Zoom to extents", level=Qgis.Info
        )

    def updateCurrentProposal(self):
        TOMsMessageLog.logMessage("In updateCurrentProposal.", level=Qgis.Info)
        # Will be called whenever a new entry is selected in the combobox

        # Can we check to see if there are any outstanding edits?!!

        self.proposalsManager.setCurrentProposal(
            self.dock.cb_ProposalsList.currentData()
        )

    def onDateChanged(self):
        TOMsMessageLog.logMessage("In onDateChanged.", level=Qgis.Info)
        date = self.proposalsManager.date()
        self.dock.filterDate.setDate(date)

    def getProposal(self, proposalID):
        TOMsMessageLog.logMessage("In getProposal.", level=Qgis.Info)

        # proposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("Proposals")[0]  -- v2
        proposalsLayer = QgsProject.instance().mapLayersByName("Proposals")[0]

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for currProposal in proposalsLayer.getFeatures():
            if currProposal.attribute("ProposalID") == proposalID:
                return currProposal

        return None

    def setLabelUpdateTriggers(self):
        TOMsMessageLog.logMessage("In setLabelUpdateTriggers ...", level=Qgis.Info)

        # find any layers with the name "%.label%"
        # https://gis.stackexchange.com/questions/312040/stuck-on-how-to-list-loaded-layers-in-qgis-3-via-python

        layerList = QgsProject.instance().layerTreeRoot().findLayers()

        for layer in layerList:
            if re.findall(".label", layer.name()):
                try:
                    layer.layer().setRefreshOnNotifyEnabled(True)
                except Exception as e:
                    TOMsMessageLog.logMessage(
                        "Error in setLabelUpdateTriggers ...{}".format(e),
                        level=Qgis.Warning,
                    )

    def unsetLabelUpdateTriggers(self):
        TOMsMessageLog.logMessage("In setLabelUpdateTriggers ...", level=Qgis.Info)

        # find any layers with the name "%.label%"
        # https://gis.stackexchange.com/questions/312040/stuck-on-how-to-list-loaded-layers-in-qgis-3-via-python

        layerList = QgsProject.instance().layerTreeRoot().findLayers()

        for layer in layerList:
            if re.findall(".label", layer.name()):
                try:
                    layer.layer().setRefreshOnNotifyEnabled(False)
                except Exception as e:
                    TOMsMessageLog.logMessage(
                        "Error in setLabelUpdateTriggers ...{}".format(e),
                        level=Qgis.Warning,
                    )
