# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ---------------------------------------------------------------------
# Tim Hancock 2017

"""
Series of functions to deal with restrictionsInProposals. Defined as static functions to allow them to be used in forms ... (not sure if this is the best way ...)

"""
from qgis.PyQt.QtWidgets import (
    QMessageBox,
    QAction,
    QDialogButtonBox,
    QLabel,
    QDockWidget
)

from qgis.PyQt.QtGui import (
    QIcon,
    QPixmap
)

from qgis.PyQt.QtCore import (
    QObject,
    QTimer,
    pyqtSignal
)

from TOMs.core.TOMsMessageLog import TOMsMessageLog
from qgis.core import (
    Qgis,
    QgsExpressionContextUtils,
    QgsExpression,
    QgsFeatureRequest,
    QgsMessageLog,
    QgsFeature,
    QgsGeometry,
    QgsTransaction,
    QgsTransactionGroup,
    QgsProject
)

from qgis.gui import *
import functools
import time
import os

from ..constants import (
    ProposalStatus,
    RestrictionAction,
    singleton
)

@singleton
class TOMsTransaction(QObject):
    transactionCompleted = pyqtSignal()
    """Signal will be emitted, when the transaction is finished - either committed or rollback"""

    def __init__(self, iface, proposalsManager):

        QObject.__init__(self)

        self.iface = iface

        self.proposalsManager = proposalsManager  # included to allow call to updateMapCanvas

        # self.currTransactionGroup = None
        self.currTransactionGroup = QgsTransactionGroup()
        self.setTransactionGroup = []
        self.tableNames = self.proposalsManager.tableNames
        self.errorOccurred = False

        self.TOMsTransactionList = \
            ["Proposals",
             "RestrictionsInProposals",
             "Bays",
             "Lines",
             "Signs",
             "RestrictionPolygons",
             "MapGrid",
             "CPZs",
             "ParkingTariffAreas",
             "TilesInAcceptedProposals"
             ]

        self.prepareLayerSet()

    def prepareLayerSet(self):

        # Function to create group of layers to be in Transaction for changing proposal

        # self.tableNames = TOMSLayers(self.iface)
        # self.tableNames.getLayers()

        TOMsMessageLog.logMessage("In TOMsTransaction. prepareLayerSet: ", level=Qgis.Info)

        # idxRestrictionsLayerName = self.tableNames.RESTRICTIONLAYERS.fields().indexFromName("RestrictionLayerName")

        # self.setTransactionGroup = [self.tableNames.PROPOSALS]
        # self.setTransactionGroup.append(self.tableNames.RESTRICTIONS_IN_PROPOSALS)
        # self.setTransactionGroup.append(self.tableNames.MAP_GRID)
        # self.setTransactionGroup.append(self.tableNames.TILES_IN_ACCEPTED_PROPOSALS)

        for layer in self.TOMsTransactionList:
            # currRestrictionLayerName = layer[idxRestrictionsLayerName]

            # restrictionLayer = QgsProject.instance().mapLayersByName(currRestrictionLayerName)[0]

            self.setTransactionGroup.append(self.tableNames.setLayer(layer))
            TOMsMessageLog.logMessage("In TOMsTransaction.prepareLayerSet. Adding " + layer, level=Qgis.Info)

    def createTransactionGroup(self):

        TOMsMessageLog.logMessage("In TOMsTransaction.createTransactionGroup",
                                 level=Qgis.Info)

        """if self.currTransactionGroup:
            TOMsMessageLog.logMessage("In createTransactionGroup. Transaction ALREADY exists",
                                    level=Qgis.Info)
            return"""

        if self.currTransactionGroup:

            for layer in self.setTransactionGroup:
                self.currTransactionGroup.addLayer(layer)
                TOMsMessageLog.logMessage("In createTransactionGroup. Adding " + str(layer.name()), level=Qgis.Info)

                layer.beforeCommitChanges.connect(functools.partial(self.printMessage, layer, "beforeCommitChanges"))
                layer.layerModified.connect(functools.partial(self.printMessage, layer, "layerModified"))
                layer.editingStopped.connect(functools.partial(self.printMessage, layer, "editingStopped"))
                layer.attributeValueChanged.connect(self.printAttribChanged)
                layer.raiseError.connect(functools.partial(self.printRaiseError, layer))

                # layer.editCommandEnded.connect(functools.partial(self.printMessage, layer, "editCommandEnded"))

                # layer.editBuffer().committedAttributeValuesChanges.connect(functools.partial(self.layerCommittedAttributeValuesChanges, layer))

            # layer.startEditing() # edit layer is now active ...
            self.modified = False
            self.errorOccurred = False

            self.transactionCompleted.connect(self.proposalsManager.updateMapCanvas)

            return

    def startTransactionGroup(self):

        TOMsMessageLog.logMessage("In startTransactionGroup.", level=Qgis.Info)

        if self.currTransactionGroup.isEmpty():
            TOMsMessageLog.logMessage("In startTransactionGroup. Currently empty adding layers", level=Qgis.Info)
            self.createTransactionGroup()

        status = self.tableNames.setLayer(self.TOMsTransactionList[0]).startEditing()  # could be any table ...
        if status == False:
            TOMsMessageLog.logMessage("In startTransactionGroup. *** Error starting transaction ...", level=Qgis.Info)
        else:
            TOMsMessageLog.logMessage("In startTransactionGroup. Transaction started correctly!!! ...", level=Qgis.Info)
        return status

    def layerModified(self):
        self.modified = True

    def isTransactionGroupModified(self):
        # indicates whether or not there has been any change within the transaction
        return self.modified

    def printMessage(self, layer, message):
        TOMsMessageLog.logMessage("In printMessage. " + str(message) + " ... " + str(layer.name()),
                                 level=Qgis.Info)

    def printAttribChanged(self, fid, idx, v):
        TOMsMessageLog.logMessage("Attributes changed for feature " + str(fid),
                                 level=Qgis.Info)

    def printRaiseError(self, layer, message):
        TOMsMessageLog.logMessage("Error from " + str(layer.name()) + ": " + str(message),
                                 level=Qgis.Info)
        self.errorOccurred = True
        self.errorMessage = message

    def commitTransactionGroup(self, currRestrictionLayer):

        TOMsMessageLog.logMessage("In commitTransactionGroup",
                                 level=Qgis.Info)

        # unset map tool. I don't understand why this is required, but ... without it QGIS crashes
        currMapTool = self.iface.mapCanvas().mapTool()
        # currMapTool.deactivate()
        self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())

        if not self.currTransactionGroup:
            TOMsMessageLog.logMessage("In commitTransactionGroup. Transaction DOES NOT exist",
                                     level=Qgis.Info)
            return

        if self.errorOccurred == True:
            reply = QMessageBox.information(None, "Error",
                                            str(self.errorMessage), QMessageBox.Ok)
            self.rollBackTransactionGroup()
            return False

        # Now check to see that there has been a change in the "main" restriction layer
        """if self.currTransactionGroup.modified() == False:
            reply = QMessageBox.information(None, "Error",
                                            "Transactin group not modified", QMessageBox.Ok)
            return True"""

        """if currRestrictionLayer.editBuffer():

            if currRestrictionLayer.editBuffer().isModified() == False:
                    reply = QMessageBox.information(None, "Error",
                                                    "Problem with saving " + str(currRestrictionLayer.name()),
                                                    QMessageBox.Ok)
                    self.rollBackTransactionGroup()
                    return False"""

        """TOMsMessageLog.logMessage("In commitTransactionGroup. Committing transaction",
                                     level=Qgis.Info)"""

        # modifiedTransaction = self.currTransactionGroup.modified()

        """if self.modified == True:
            TOMsMessageLog.logMessage("In commitTransactionGroup. Transaction has been changed ...",
                                     level=Qgis.Info)
        else:
            TOMsMessageLog.logMessage("In commitTransactionGroup. Transaction has NOT been changed ...",
                                     level=Qgis.Info)"""

        # self.currTransactionGroup.commitError.connect(self.errorInTransaction)

        for layer in self.setTransactionGroup:

            TOMsMessageLog.logMessage("In commitTransactionGroup. Considering: " + layer.name(),
                                     level=Qgis.Info)

            commitStatus = layer.commitChanges()
            # commitStatus = True  # for testing ...

            """try:
                #layer.commitChanges()
                QTimer.singleShot(0, layer.commitChanges())
                commitStatus = True
            except:
                #commitErrors = layer.commitErrors()
                commitStatus = False

                TOMsMessageLog.logMessage("In commitTransactionGroup. error: " + str(layer.commitErrors()),
                                     level=Qgis.Info)"""

            if commitStatus == False:
                reply = QMessageBox.information(None, "Error",
                                                "Changes to " + layer.name() + " failed: " + str(
                                                    layer.commitErrors()), QMessageBox.Ok)
                commitErrors = layer.rollBack()

            break

        self.modified = False
        self.errorOccurred = False

        # currMapTool.activate()
        # self.iface.mapCanvas().setMapTool(currMapTool)

        # signal for redraw ...
        self.transactionCompleted.emit()

        return commitStatus

    def layersInTransaction(self):
        return self.setTransactionGroup

    def errorInTransaction(self, errorMsg):
        reply = QMessageBox.information(None, "Error",
                                        "Proposal changes failed: " + errorMsg, QMessageBox.Ok)
        TOMsMessageLog.logMessage("In errorInTransaction: " + errorMsg,
                                 level=Qgis.Info)

        # def __del__(self):
        # pass

    def deleteTransactionGroup(self):

        if self.currTransactionGroup:

            if self.currTransactionGroup.modified():
                TOMsMessageLog.logMessage("In deleteTransactionGroup. Transaction contains edits ... NOT deleting",
                                         level=Qgis.Info)
                return

            self.currTransactionGroup.commitError.disconnect(self.errorInTransaction)
            self.currTransactionGroup = None

        pass

        return

    def rollBackTransactionGroup(self):

        TOMsMessageLog.logMessage("In rollBackTransactionGroup",
                                 level=Qgis.Info)

        # unset map tool. I don't understand why this is required, but ... without it QGIS crashes
        self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())

        try:
            self.tableNames.setLayer(self.TOMsTransactionList[0]).rollBack()  # could be any table ...
            TOMsMessageLog.logMessage("In rollBackTransactionGroup. Transaction rolled back correctly ...",
                                     level=Qgis.Info)
        except:
            TOMsMessageLog.logMessage("In rollBackTransactionGroup. error: ...",
                                     level=Qgis.Info)

        # self.iface.activeLayer().stopEditing()

        self.modified = False
        self.errorOccurred = False
        self.errorMessage = None

        return
