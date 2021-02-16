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
from .resources import *

from qgis.PyQt.QtCore import (
    QObject,
    QDate,
    pyqtSignal,
    QCoreApplication
)

from qgis.PyQt.QtGui import (
    QIcon,
    QPixmap
)

from qgis.PyQt.QtWidgets import (
    QMessageBox,
    QAction,
    QDialogButtonBox,
    QLabel,
    QDockWidget
)

from TOMs.core.TOMsMessageLog import TOMsMessageLog
from qgis.core import (
    Qgis,
    QgsExpressionContextUtils,
    QgsProject,
    QgsMessageLog,
    QgsFeature,
    QgsGeometry
)
from qgis.gui import QgsMapToolPan

import os

#from qgis.gui import *

from TOMs.CadNodeTool.TOMsNodeTool import TOMsNodeTool, TOMsLabelTool

from .mapTools import *
from .constants import (
    ProposalStatus,
    RestrictionAction
)

from .restrictionTypeUtilsClass import RestrictionTypeUtilsMixin, TOMsLayers
from .core.TOMsTransaction import (TOMsTransaction)

import functools



class manageRestrictionDetails(RestrictionTypeUtilsMixin):

    def __init__(self, iface, TOMsToolbar, proposalsManager):

        TOMsMessageLog.logMessage("In manageRestrictionDetails::init", level=Qgis.Info)
        RestrictionTypeUtilsMixin.__init__(self, iface)

        # Save reference to the QGIS interface
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.proposalsManager = proposalsManager
        self.TOMsToolbar = TOMsToolbar

        #self.constants = TOMsConstants()

        #self.restrictionTypeUtils = RestrictionTypeUtilsClass(self.iface)

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

        self.actionSplitRestriction = QAction(QIcon(":/plugins/TOMs/resources/scissors.png"),
                               QCoreApplication.translate("MyPlugin", "Split Restriction"),
                               self.iface.mainWindow())
        self.actionSplitRestriction.setCheckable(True)

        self.actionEditLabels = QAction(QIcon(""),
                               QCoreApplication.translate("MyPlugin", "Manage Labels"),
                               self.iface.mainWindow())
        self.actionEditLabels.setCheckable(True)

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
        self.TOMsToolbar.addAction(self.actionSplitRestriction)
        self.TOMsToolbar.addAction(self.actionEditLabels)
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
        self.actionSplitRestriction.triggered.connect(self.doSplitRestriction)
        self.actionEditLabels.triggered.connect(self.doEditLabels)
        self.actionCreateConstructionLine.triggered.connect(self.doCreateConstructionLine)

        # deal with saving label changes ...
        self.labelMapToolSet = False

    def enableTOMsToolbarItems(self, restrictionTransaction):

        TOMsMessageLog.logMessage("In enableTOMsToolbarItems", level=Qgis.Info)

        self.actionSelectRestriction.setEnabled(True)
        self.actionRestrictionDetails.setEnabled(True)
        self.actionCreateBayRestriction.setEnabled(True)
        self.actionCreateLineRestriction.setEnabled(True)
        self.actionCreatePolygonRestriction.setEnabled(True)
        self.actionCreateSignRestriction.setEnabled(True)
        self.actionRemoveRestriction.setEnabled(True)
        self.actionEditRestriction.setEnabled(True)
        self.actionSplitRestriction.setEnabled(True)
        self.actionEditLabels.setEnabled(True)
        self.actionCreateConstructionLine.setEnabled(True)

        # print tool
        #self.toolButton.setEnabled(True)

        # set up a Transaction object
        # self.tableNames = TOMSLayers(self.iface)
        # self.tableNames.getLayers()
        self.restrictionTransaction = restrictionTransaction
        """self.proposalsManager.TOMsToolChanged.connect(
            functools.partial(self.restrictionTransaction.commitTransactionGroup, self.tableNames.PROPOSALS))"""

        #self.iface.mapCanvas().mapToolSet.connect(self.unCheckNodeTool)

        pass

    def unCheckNodeTool(self):
        self.actionEditRestriction.setChecked(False)

    def disableTOMsToolbarItems(self):

        TOMsMessageLog.logMessage("In disableTOMsToolbarItems", level=Qgis.Info)

        self.actionSelectRestriction.setEnabled(False)
        self.actionRestrictionDetails.setEnabled(False)
        self.actionCreateBayRestriction.setEnabled(False)
        self.actionCreateLineRestriction.setEnabled(False)
        self.actionCreatePolygonRestriction.setEnabled(False)
        self.actionCreateSignRestriction.setEnabled(False)
        self.actionRemoveRestriction.setEnabled(False)
        self.actionEditRestriction.setEnabled(False)
        self.actionSplitRestriction.setEnabled(False)
        self.actionEditLabels.setEnabled(False)
        self.actionCreateConstructionLine.setEnabled(False)

        # print tool
        #self.toolButton.setEnabled(False)

        pass

    def doSelectRestriction(self):
        """ Select point and then display details
        """

        TOMsMessageLog.logMessage("In doSelectRestriction", level=Qgis.Info)

        #self.proposalsManager.TOMsToolChanged.emit()

        if not self.actionSelectRestriction.isChecked():
            self.actionSelectRestriction.setChecked(False)
            self.iface.mapCanvas().unsetMapTool(self.mapTool)
            self.mapTool = None
            # self.actionPan.connect()
            # deal with labelling tool. Allow to continue to select ...
            if self.labelMapToolSet == False:
                return
            self.labelMapToolSet = False

        self.actionSelectRestriction.setChecked(True)

        self.mapTool = GeometryInfoMapTool(self.iface)
        self.mapTool.setAction(self.actionSelectRestriction)
        self.iface.mapCanvas().setMapTool(self.mapTool)

    def doRestrictionDetails(self):
        """ Select point and then display details
        """
        TOMsMessageLog.logMessage("In doRestrictionDetails", level=Qgis.Info)

        #self.proposalsManager.TOMsToolChanged.emit()

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        currRestrictionLayer = self.iface.activeLayer()

        if currRestrictionLayer:

            TOMsMessageLog.logMessage("In doRestrictionDetails. currLayer: " + str(currRestrictionLayer.name() + " Nr feats: " + str(currRestrictionLayer.selectedFeatureCount())), level=Qgis.Info)

            if currRestrictionLayer.selectedFeatureCount() > 0:

                if currProposalID == 0:
                    # Ensure that no updates can occur for Proposal = 0
                    self.restrictionTransaction.rollBackTransactionGroup() # stop any editing
                else:
                    self.restrictionTransaction.startTransactionGroup()  # start editing

                selectedRestrictions = currRestrictionLayer.selectedFeatures()
                for currRestriction in selectedRestrictions:
                    #self.restrictionForm = BayRestrictionForm(currRestrictionLayer, currRestriction)
                    #self.restrictionForm.show()

                    TOMsMessageLog.logMessage(
                        "In restrictionFormOpen. currRestrictionLayer: " + str(currRestrictionLayer.name()), level=Qgis.Info)

                    dialog = self.iface.getFeatureForm(currRestrictionLayer, currRestriction)

                    self.setupRestrictionDialog(dialog, currRestrictionLayer, currRestriction, self.restrictionTransaction)  # connects signals

                    dialog.show()

                    #self.iface.openFeatureForm(self.currRestrictionLayer, self.currRestriction)

                    # Disconnect the signal that QGIS has wired up for the dialog to the button box.
                    # button_box.accepted.disconnect(restrictionsDialog.accept)
                    # Wire up our own signals.

                    #button_box.accepted.connect(self.restrictionTypeUtils.onSaveRestrictionDetails, currRestriction,
                    #                            currRestrictionLayer, self.dialog))

            else:

                reply = QMessageBox.information(self.iface.mainWindow(), "Information",
                                                "Select restriction first and then choose information button",
                                                QMessageBox.Ok)

            pass

            #currRestrictionLayer.deselect(currRestriction.id())

        else:

            reply = QMessageBox.information(self.iface.mainWindow(), "Information",
                                            "Select restriction first and then choose information button",
                                            QMessageBox.Ok)

        pass


    def doCreateBayRestriction(self):

        TOMsMessageLog.logMessage("In doCreateBayRestriction", level=Qgis.Info)

        #self.proposalsManager.TOMsToolChanged.emit()

        self.mapTool = None

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        if currProposalID > 0:

            if self.actionCreateBayRestriction.isChecked():
                # self.iface.mapCanvas().setMapTool(CreateRestrictionTool)
                # self.actionCreateRestiction.setChecked(True)

                # set TOMs layer as active layer (for editing)...

                TOMsMessageLog.logMessage("In doCreateBayRestriction - tool activated", level=Qgis.Info)

                # self.restrictionTransaction.startTransactionGroup()  # start editing

                #self.currLayer = QgsMapLayerRegistry.instance().mapLayersByName("Bays")[0]
                #currLayer = self.tableNames.BAYS
                currLayer = self.proposalsManager.tableNames.TOMsLayerDict.get("Bays")
                self.iface.setActiveLayer(currLayer)

                self.restrictionTransaction.startTransactionGroup()  # start editing

                self.mapTool = CreateRestrictionTool(self.iface, currLayer, self.proposalsManager, self.restrictionTransaction)

                self.mapTool.setAction(self.actionCreateBayRestriction)
                self.iface.mapCanvas().setMapTool(self.mapTool)

                #self.currLayer.featureAdded.connect(self.proposalsManager.updateMapCanvas)

                #self.currLayer.editingStopped.connect (self.proposalsManager.updateMapCanvas)

            else:

                TOMsMessageLog.logMessage("In doCreateBayRestriction - tool deactivated", level=Qgis.Info)

                self.iface.mapCanvas().unsetMapTool(self.mapTool)
                self.mapTool = None
                self.actionCreateBayRestriction.setChecked(False)

                #self.currLayer.featureAdded.disconnect(self.proposalsManager.updateMapCanvas)

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

        TOMsMessageLog.logMessage("In doCreateLineRestriction", level=Qgis.Info)

        #self.proposalsManager.TOMsToolChanged.emit()

        self.mapTool = None

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        if currProposalID > 0:

            if self.actionCreateLineRestriction.isChecked():
                # self.iface.mapCanvas().setMapTool(CreateRestrictionTool)
                # self.actionCreateRestiction.setChecked(True)

                # set TOMs layer as active layer (for editing)...

                TOMsMessageLog.logMessage("In doCreateLineRestriction - tool activated", level=Qgis.Info)

                # self.restrictionTransaction.startTransactionGroup()  # start editing

                #self.currLayer = QgsMapLayerRegistry.instance().mapLayersByName("Lines")[0]
                #currLayer = self.tableNames.LINES
                currLayer = self.proposalsManager.tableNames.TOMsLayerDict.get("Lines")
                self.iface.setActiveLayer(currLayer)

                self.restrictionTransaction.startTransactionGroup()  # start editing

                self.mapTool = CreateRestrictionTool(self.iface, currLayer, self.proposalsManager, self.restrictionTransaction)

                self.mapTool.setAction(self.actionCreateLineRestriction)
                self.iface.mapCanvas().setMapTool(self.mapTool)

                #self.currLayer.editingStopped.connect (self.proposalsManager.updateMapCanvas)

            else:

                TOMsMessageLog.logMessage("In doCreateLineRestriction - tool deactivated", level=Qgis.Info)

                self.iface.mapCanvas().setMapTool(QgsMapToolPan(self.iface.mapCanvas()))
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

        TOMsMessageLog.logMessage("In doCreatePolygonRestriction", level=Qgis.Info)

        #self.proposalsManager.TOMsToolChanged.emit()

        self.mapTool = None

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        if currProposalID > 0:

            if self.actionCreatePolygonRestriction.isChecked():
                # self.iface.mapCanvas().setMapTool(CreateRestrictionTool)
                # self.actionCreateRestiction.setChecked(True)

                # set TOMs layer as active layer (for editing)...

                TOMsMessageLog.logMessage("In doCreatePolygonRestriction - tool activated", level=Qgis.Info)

                #self.currLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionPolygons")[0]
                #currLayer = self.tableNames.RESTRICTION_POLYGONS
                currLayer = self.proposalsManager.tableNames.TOMsLayerDict.get("RestrictionPolygons")
                self.iface.setActiveLayer(currLayer)
                self.restrictionTransaction.startTransactionGroup()

                self.mapTool = CreateRestrictionTool(self.iface, currLayer, self.proposalsManager, self.restrictionTransaction)

                self.mapTool.setAction(self.actionCreatePolygonRestriction)
                self.iface.mapCanvas().setMapTool(self.mapTool)

                #self.currLayer.editingStopped.connect (self.proposalsManager.updateMapCanvas)

            else:

                TOMsMessageLog.logMessage("In doCreatePolygonRestriction - tool deactivated", level=Qgis.Info)

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

        TOMsMessageLog.logMessage("In doCreateSignRestriction", level=Qgis.Info)

        #self.proposalsManager.TOMsToolChanged.emit()

        self.mapTool = None

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        if currProposalID > 0:

            if self.actionCreateSignRestriction.isChecked():
                # self.iface.mapCanvas().setMapTool(CreateRestrictionTool)
                # self.actionCreateRestiction.setChecked(True)

                # set TOMs layer as active layer (for editing)...

                TOMsMessageLog.logMessage("In doCreateSignRestriction - tool activated", level=Qgis.Info)

                # self.restrictionTransaction.startTransactionGroup()

                #self.currLayer = QgsMapLayerRegistry.instance().mapLayersByName("Signs")[0]
                #currLayer = self.tableNames.SIGNS
                currLayer = self.proposalsManager.tableNames.TOMsLayerDict.get("Signs")
                self.iface.setActiveLayer(currLayer)

                self.restrictionTransaction.startTransactionGroup()

                self.mapTool = CreateRestrictionTool(self.iface, currLayer, self.proposalsManager, self.restrictionTransaction)

                self.mapTool.setAction(self.actionCreateSignRestriction)
                self.iface.mapCanvas().setMapTool(self.mapTool)

                #self.currLayer.editingStopped.connect (self.proposalsManager.updateMapCanvas)

            else:

                TOMsMessageLog.logMessage("In doCreateSignRestriction - tool deactivated", level=Qgis.Info)

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

        TOMsMessageLog.logMessage("In doCreateConstructionLine", level=Qgis.Info)

        #self.proposalsManager.TOMsToolChanged.emit()

        self.mapTool = None

        if self.actionCreateConstructionLine.isChecked():
            # self.iface.mapCanvas().setMapTool(CreateRestrictionTool)
            # self.actionCreateRestiction.setChecked(True)

            # set TOMs layer as active layer (for editing)...

            TOMsMessageLog.logMessage("In doCreateConstructionLine - tool activated", level=Qgis.Info)

            self.currLayer = QgsProject.instance().mapLayersByName("ConstructionLines")[0]
            self.iface.setActiveLayer(self.currLayer)

            self.currLayer.startEditing()

            self.mapTool = CreateRestrictionTool(self.iface, self.currLayer, self.proposalsManager, self.restrictionTransaction)
            self.mapTool.setAction(self.actionCreateConstructionLine)
            self.iface.mapCanvas().setMapTool(self.mapTool)

            #self.currLayer.editingStopped.connect (self.proposalsManager.updateMapCanvas)

        else:

            TOMsMessageLog.logMessage("In doCreateConstructionLine - tool deactivated", level=Qgis.Info)

            self.iface.mapCanvas().unsetMapTool(self.mapTool)
            self.mapTool = None
            self.actionCreateConstructionLine.setChecked(False)

            #self.currLayer.editingStopped ()

        pass

    def doRemoveRestriction(self):
        # pass control to MapTool and then deal with Proposals issues from there ??
        TOMsMessageLog.logMessage("In doRemoveRestriction", level=Qgis.Info)

        #self.proposalsManager.TOMsToolChanged.emit()

        #self.mapTool = None

        # Get the current proposal from the session variables
        self.currProposalID = self.proposalsManager.currentProposal()

        if self.currProposalID > 0:

            currRestrictionLayer = self.iface.activeLayer()

            if currRestrictionLayer:

                TOMsMessageLog.logMessage("In doRemoveRestriction. currLayer: " + str(currRestrictionLayer.name()), level=Qgis.Info)

                if currRestrictionLayer.selectedFeatureCount() > 0:

                    selectedRestrictions = currRestrictionLayer.selectedFeatures()

                    self.restrictionTransaction.startTransactionGroup()

                    for currRestriction in selectedRestrictions:
                        if not self.onRemoveRestriction(currRestrictionLayer, currRestriction):
                            QMessageBox.information(None, "ERROR", ("Error deleting restriction ..."))
                            self.restrictionTransaction.rollBackTransactionGroup()
                            break

                    self.restrictionTransaction.commitTransactionGroup(None)

                else:

                    reply = QMessageBox.information(self.iface.mainWindow(), "Information",
                                                    "Select restriction for delete",
                                                    QMessageBox.Ok)

        else:

            reply = QMessageBox.information(self.iface.mainWindow(), "Information", "Changes to current data are not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)


    def onRemoveRestriction(self, currRestrictionLayer, currRestriction):
        TOMsMessageLog.logMessage("In onRemoveRestriction. currLayer: " + str(currRestrictionLayer.id()) + " CurrFeature: " + str(currRestriction.id()), level=Qgis.Info)

        currProposalID = self.proposalsManager.currentProposal()

        currRestrictionLayerID = self.getRestrictionLayerTableID(currRestrictionLayer)

        idxRestrictionID = currRestriction.fields().indexFromName("RestrictionID")

        if self.restrictionInProposal(currRestriction[idxRestrictionID], currRestrictionLayerID, currProposalID):
            # check to see whether or not the restriction has an OpenDate. If so, this should not be deleted.
            if currRestriction[currRestriction.fields().indexFromName("OpenDate")]:
                QMessageBox.information(None, "ERROR", ("Something happened that shouldn't ... Error trying to delete restriction"))
                return False
            # remove the restriction from the RestrictionsInProposals table - and from the currLayer, i.e., it is totally removed.
            # NB: This is the only case of a restriction being truly deleted

            TOMsMessageLog.logMessage("In onRemoveRestriction. Removing from RestrictionsInProposals and currLayer.", level=Qgis.Info)

            # Delete from RestrictionsInProposals
            if not self.deleteRestrictionInProposal(currRestriction[idxRestrictionID], currRestrictionLayerID, currProposalID):
                return False

            TOMsMessageLog.logMessage("In onRemoveRestriction. Deleting restriction id: " + str(currRestriction.id()),
                                     level=Qgis.Info)
            if not currRestrictionLayer.deleteFeature(currRestriction.id()):
                return False

        else:
            # need to:
            #    - enter the restriction into the table RestrictionInProposals as closed, and
            #
            TOMsMessageLog.logMessage("In onRemoveRestriction. Closing existing restriction.",
                                     level=Qgis.Info)

            if not self.addRestrictionToProposal(currRestriction[idxRestrictionID], currRestrictionLayerID, currProposalID,
                                                          RestrictionAction.CLOSE):
                return False

        return True

    def doEditRestriction(self):

        TOMsMessageLog.logMessage("In doEditRestriction - starting", level=Qgis.Info)

        #self.proposalsManager.TOMsToolChanged.emit()

        self.mapTool = None

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        if currProposalID > 0:

            if self.actionEditRestriction.isChecked():

                TOMsMessageLog.logMessage("In actionEditRestriction - tool being activated", level=Qgis.Info)

                # Need to clear any other maptools ....   ********

                currRestrictionLayer = self.iface.activeLayer()

                if currRestrictionLayer:

                    TOMsMessageLog.logMessage("In doEditRestriction. currLayer: " + str(currRestrictionLayer.name()), level=Qgis.Info)

                    if currRestrictionLayer.selectedFeatureCount() > 0:

                        self.restrictionTransaction.startTransactionGroup()

                        """currRestriction = currRestrictionLayer.selectedFeatures()[0]
                        restrictionForEdit = self.prepareRestrictionForEdit (currRestriction, currRestrictionLayer)
                        currRestrictionLayer.deselect(currRestriction.id())
                        currRestrictionLayer.select(restrictionForEdit.id())
                        #currRestrictionLayer.selectByIds([editFeature.id()])"""

                        #self.actionEditRestriction.setChecked(True)
                        self.mapTool = TOMsNodeTool(self.iface,
                                                    self.proposalsManager, self.restrictionTransaction)  # This is where we use the Node Tool ... need canvas and panel??
                        """self.mapTool = TOMsNodeTool(self.iface,
                                                    self.proposalsManager, self.restrictionTransaction, restrictionForEdit, currRestrictionLayer)  # This is where we use the Node Tool ... need canvas and panel??"""
                        self.mapTool.setAction(self.actionEditRestriction)
                        self.iface.mapCanvas().setMapTool(self.mapTool)

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

                TOMsMessageLog.logMessage("In doEditRestriction - tool deactivated", level=Qgis.Info)

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

        TOMsMessageLog.logMessage("In doEditRestriction - leaving", level=Qgis.Info)

        pass


    def doEditLabels(self):

        TOMsMessageLog.logMessage("In doEditLabels ... ", level=Qgis.Warning)

        def alert_box(text):
            QMessageBox.information( self.iface.mainWindow(), "Information", text, QMessageBox.Ok )

        if self.actionEditLabels.isChecked():

            # We start by unsetting all tools
            if hasattr(self, 'mapTool'):  # FIXME: not in __init__ ?!
                self.iface.mapCanvas().unsetMapTool(self.mapTool)
            self.mapTool = None
            self.actionEditLabels.setChecked(False)

            self._currently_editted_label_layers = []

            # Get the current proposal from the session variables
            currProposalID = self.proposalsManager.currentProposal()

            # Get the active layer
            currRestrictionLayer = self.iface.activeLayer()

            if not (currProposalID > 0):
                alert_box("Changes to current data are not allowed. Changes are made via Proposals")
                return

            if not currRestrictionLayer or currRestrictionLayer.selectedFeatureCount() == 0:
                alert_box("Select restriction for edit")
                return

            self.restrictionTransaction.startTransactionGroup()

            # get the corresponding label layer
            if currRestrictionLayer.name() == 'Bays':
                label_layers_names = ['Bays.label_pos', 'Bays.label_ldr']
            if currRestrictionLayer.name() == 'Lines':
                label_layers_names = ['Lines.label_pos', 'Lines.label_loading_pos', 'Lines.label_ldr', 'Lines.label_loading_ldr']
            if currRestrictionLayer.name() == 'Signs':
                label_layers_names = []
            if currRestrictionLayer.name() == 'RestrictionPolygons':
                label_layers_names = ['RestrictionPolygons.label_pos', 'RestrictionPolygons.label_ldr']
            if currRestrictionLayer.name() == 'CPZs':
                label_layers_names = ['CPZs.label_pos', 'CPZs.label_ldr']
            if currRestrictionLayer.name() == 'ParkingTariffAreas':
                label_layers_names = ['ParkingTariffAreas.label_pos', 'ParkingTariffAreas.label_ldr']

            if len(label_layers_names) == 0:
                alert_box("No labels for this restriction type")
                return

            # get the selected features on the restriction layer
            # unfortunately, ids of two layers reprenseting the same tables do not seem to be identical
            # so we need to do this little dance...
            pk_attrs_idxs = currRestrictionLayer.primaryKeyAttributes()
            assert len(pk_attrs_idxs) == 1, 'We do not support composite primary keys {}'.format(pk_attrs_idxs)
            pk_attr_idx = pk_attrs_idxs[0]
            pk_attr = currRestrictionLayer.fields().names()[pk_attr_idx]
            selected_pks = ','.join(["'"+f[pk_attr_idx]+"'" for f in currRestrictionLayer.selectedFeatures()])
            selected_expression = '"{}" IN ({})'.format(pk_attr, selected_pks)

            # we keep the bouding box for zooming
            box = currRestrictionLayer.boundingBoxOfSelected()
            self.labelGeometryIsChanged = False

            for label_layers_name in label_layers_names:

                # get the label layer
                label_layer = QgsProject.instance().mapLayersByName(label_layers_name)[0]

                # keep track of the layer to commit changes when vertex tool disabled
                self._currently_editted_label_layers.append(label_layer)

                # reselect the same feature on the label layer
                label_layer.selectByExpression(selected_expression)

                # add the selection to the boudingbox (for zooming)
                box.combineExtentWith(label_layer.boundingBoxOfSelected())

                # toggle edit mode
                #label_layer.startEditing()  # already started with transaction
                #label_layer.geometryChanged.connect(self.labelGeometryChanged)
                TOMsMessageLog.logMessage("In doEditLabels - layer: {}".format(label_layers_name), level=Qgis.Info)

            TOMsMessageLog.logMessage(
                "In doEditLabels - _currently_editted_label_layers: {}".format(len(self._currently_editted_label_layers)),
                level=Qgis.Info)
            # enable the vertex tool
            #self.iface.actionVertexTool().trigger()
            #self.mapTool = self.iface.mapCanvas().mapTool()

            self.mapTool = TOMsLabelTool(self.iface,
                                        self.proposalsManager, self.restrictionTransaction)
            self.mapTool.setAction(self.actionEditLabels)
            self.iface.mapCanvas().setMapTool(self.mapTool)
            self.canvas.mapToolSet.connect(self.saveLabelChanges)
            self.labelMapToolSet = True
            #self.mapTool.deactivated.connect(self.stopEditLabels)
            self.actionEditLabels.setChecked(True)

            # TODO: Need to set a filter so that node tool can only pick up label/leader layers

            # zoom to the bounding box
            box.scale(1.5)
            self.iface.mapCanvas().setExtent(box)
            self.iface.mapCanvas().refresh()

        else:

            TOMsMessageLog.logMessage("In doEditLabels - should now be finished", level=Qgis.Info)

    def saveLabelChanges(self, newTool, oldTool):
        TOMsMessageLog.logMessage("In saveLabelChanges ...", level=Qgis.Warning)

        if self.labelMapToolSet:
            try: # this signal is not connected for situations where right click is used - as tool is already unset within commit process TODO: improve!!
                self.canvas.mapToolSet.disconnect(self.saveLabelChanges)
                oldTool.onFinishEditing()
            except Exception as e:
                TOMsMessageLog.logMessage('In saveLabelChanges: error in with signal disconnect: {}'.format(e),
                                          level=Qgis.Warning)

            #self.labelMapToolSet = False

        """def labelGeometryChanged(self):
        TOMsMessageLog.logMessage("In labelGeometryChanged ... ", level=Qgis.Warning)
        self.labelGeometryIsChanged = True

    def stopEditLabels(self):
        # commit and cleanup after vertex tool stopped
        #for layer in self._currently_editted_label_layers:
        #    layer.commitChanges()   # use commitTransactionGroup

        TOMsMessageLog.logMessage("In stopEditLabels - _currently_editted_label_layers: {}".format(len(self._currently_editted_label_layers)), level=Qgis.Warning)
        for layer in self._currently_editted_label_layers:
            TOMsMessageLog.logMessage("In stopEditLabels - layer: {}".format(layer.name()), level=Qgis.Warning)

            try:   # TODO: for some reason stopEditLabels is called twice. Need to find out why, but in short term, this stops error
                layer.geometryChanged.disconnect(self.labelGeometryChanged)
            except Exception as e:
                None

        try:
            self.mapTool.deactivated.disconnect(self.stopEditLabels)
        except TypeError:
            pass
        else:   # still seems to be trying to disconnect when not connected ...
            pass

        if self.mapTool:
            self.iface.mapCanvas().unsetMapTool(self.mapTool)
            self.mapTool = None

        # check to see of there has been any change
        if self.labelGeometryIsChanged:
            self.restrictionTransaction.commitTransactionGroup(self._currently_editted_label_layers[0])
        else:
            self.restrictionTransaction.rollBackTransactionGroup()

        self._currently_editted_label_layers = []
        self.actionEditLabels.setChecked(False)"""


    def doSplitRestriction(self):

        TOMsMessageLog.logMessage("In doSplitRestriction - starting", level=Qgis.Info)

        #self.proposalsManager.TOMsToolChanged.emit()

        self.mapTool = None

        # Get the current proposal from the session variables
        currProposalID = self.proposalsManager.currentProposal()

        if currProposalID > 0:

            if self.actionSplitRestriction.isChecked():

                TOMsMessageLog.logMessage("In doSplitRestriction - tool being activated", level=Qgis.Info)

                # Need to clear any other maptools ....   ********

                currRestrictionLayer = self.iface.activeLayer()

                if currRestrictionLayer:

                    TOMsMessageLog.logMessage("In doSplitRestriction. currLayer: " + str(currRestrictionLayer.name()), level=Qgis.Info)

                    if currRestrictionLayer.selectedFeatureCount() > 0:

                        self.restrictionTransaction.startTransactionGroup()

                        """currRestriction = currRestrictionLayer.selectedFeatures()[0]
                        restrictionForEdit = self.prepareRestrictionForEdit (currRestriction, currRestrictionLayer)
                        currRestrictionLayer.deselect(currRestriction.id())
                        currRestrictionLayer.select(restrictionForEdit.id())
                        #currRestrictionLayer.selectByIds([editFeature.id()])"""

                        #self.actionEditRestriction.setChecked(True)
                        self.mapTool = TOMsSplitRestrictionTool(self.iface, currRestrictionLayer,
                                                    self.proposalsManager, self.restrictionTransaction)  # This is where we use the Node Tool ... need canvas and panel??
                        """self.mapTool = TOMsNodeTool(self.iface,
                                                    self.proposalsManager, self.restrictionTransaction, restrictionForEdit, currRestrictionLayer)  # This is where we use the Node Tool ... need canvas and panel??"""
                        self.mapTool.setAction(self.actionSplitRestriction)
                        self.iface.mapCanvas().setMapTool(self.mapTool)

                        #currRestrictionLayer.editingStopped.connect(self.proposalsManager.updateMapCanvas)

                    else:

                        reply = QMessageBox.information(self.iface.mainWindow(), "Information",
                                                        "Select restriction for edit",
                                                        QMessageBox.Ok)

                        self.actionSplitRestriction.setChecked(False)
                        self.iface.mapCanvas().unsetMapTool(self.mapTool)
                        self.mapTool = None

                else:

                    reply = QMessageBox.information(self.iface.mainWindow(), "Information",
                                                    "Select restriction for edit",
                                                    QMessageBox.Ok)
                    self.actionSplitRestriction.setChecked(False)
                    self.iface.mapCanvas().unsetMapTool(self.mapTool)
                    self.mapTool = None

            else:

                TOMsMessageLog.logMessage("In doSplitRestriction - tool deactivated", level=Qgis.Info)

                self.actionSplitRestriction.setChecked(False)
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
            self.actionSplitRestriction.setChecked(False)
            self.iface.mapCanvas().unsetMapTool(self.mapTool)
            self.mapTool = None

        pass

        TOMsMessageLog.logMessage("In doSplitRestriction - leaving", level=Qgis.Info)

        pass

