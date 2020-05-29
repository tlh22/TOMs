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

import os

#from qgis.gui import *

from .CadNodeTool.TOMsNodeTool import TOMsNodeTool

from .mapTools import *
from .constants import (
    ProposalStatus,
    RestrictionAction
)

from .restrictionTypeUtilsClass import RestrictionTypeUtilsMixin, TOMSLayers
from .core.TOMsTransaction import (TOMsTransaction)

import functools

class manageRestrictionDetails(RestrictionTypeUtilsMixin):

    def __init__(self, iface, TOMsToolbar, proposalsManager):

        TOMsMessageLog.logMessage("In manageRestrictionDetails::init", level=Qgis.Info)

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
        self.actionCreateConstructionLine.triggered.connect(self.doCreateConstructionLine)

        pass

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
        self.actionCreateConstructionLine.setEnabled(True)

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
        self.actionCreateConstructionLine.setEnabled(False)

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
            return

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

