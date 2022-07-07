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

from qgis.core import Qgis, QgsTransactionGroup
from qgis.PyQt.QtCore import QObject
from qgis.PyQt.QtWidgets import QMessageBox

from ..constants import singleton
from .tomsMessageLog import TOMsMessageLog


@singleton
class TOMsTransaction(QObject):
    """
    Series of functions to deal with restrictionsInProposals.
    Defined as static functions to allow them to be used in forms ...
    NOT SURE IF THIS IS THE BEST WAY ...
    """

    def __init__(self, iface, proposalsManager):

        QObject.__init__(self)

        self.iface = iface

        self.proposalsManager = (
            proposalsManager  # included to allow call to updateMapCanvas
        )

        # self.currTransactionGroup = None
        self.currTransactionGroup = QgsTransactionGroup()
        self.setTransactionGroup = []
        self.tableNames = self.proposalsManager.tableNames
        self.errorOccurred = False
        self.modified = False
        self.errorMessage = ""

        self.tomsTransactionList = [
            "Proposals",
            "RestrictionsInProposals",
            "Bays",
            "Lines",
            "Signs",
            "RestrictionPolygons",
            "MapGrid",
            "CPZs",
            "ParkingTariffAreas",
            "TilesInAcceptedProposals",
            # for labels
            "Bays.label_pos",
            "Lines.label_pos",
            "Lines.label_loading_pos",
            "RestrictionPolygons.label_pos",
            "CPZs.label_pos",
            "ParkingTariffAreas.label_pos",
            "Bays.label_ldr",
            "Lines.label_ldr",
            "Lines.label_loading_ldr",
            "RestrictionPolygons.label_ldr",
            "CPZs.label_ldr",
            "ParkingTariffAreas.label_ldr",
            # for mapping updates
            "MappingUpdates",
            "MappingUpdateMasks",
        ]

        self.prepareLayerSet()

    def prepareLayerSet(self):

        # Function to create group of layers to be in Transaction for changing proposal

        TOMsMessageLog.logMessage(
            "In TOMsTransaction. prepareLayerSet: ", level=Qgis.Warning
        )

        for layer in self.tomsTransactionList:
            # currRestrictionLayerName = layer[idxRestrictionsLayerName]

            # restrictionLayer = QgsProject.instance().mapLayersByName(currRestrictionLayerName)[0]

            self.setTransactionGroup.append(self.tableNames.setLayer(layer))
            TOMsMessageLog.logMessage(
                "In TOMsTransaction.prepareLayerSet. Adding " + layer, level=Qgis.Info
            )

    def createTransactionGroup(self):

        TOMsMessageLog.logMessage(
            "In TOMsTransaction.createTransactionGroup", level=Qgis.Warning
        )

        if self.currTransactionGroup:

            for layer in self.setTransactionGroup:

                try:
                    self.currTransactionGroup.addLayer(layer)
                except Exception as e:
                    TOMsMessageLog.logMessage(
                        "In TOMsTransaction:createTransactionGroup: adding {}. error: {}".format(
                            layer, e
                        ),
                        level=Qgis.Warning,
                    )

                TOMsMessageLog.logMessage(
                    "In TOMsTransaction:createTransactionGroup. Adding "
                    + str(layer.name()),
                    level=Qgis.Info,
                )

                # layer.beforeCommitChanges.connect(functools.partial(self.printMessage, layer, "beforeCommitChanges"))
                # layer.layerModified.connect(functools.partial(self.printMessage, layer, "layerModified"))
                # layer.editingStopped.connect(functools.partial(self.printMessage, layer, "editingStopped"))
                # layer.attributeValueChanged.connect(self.printAttribChanged)
                layer.raiseError.connect(functools.partial(self.printRaiseError, layer))
                # layer.editCommandEnded.connect(functools.partial(self.printMessage, layer, "editCommandEnded"))

            self.modified = False
            self.errorOccurred = False

            # self.transactionCompleted.connect(self.proposalsManager.updateMapCanvas)

            return

    def startTransactionGroup(self):

        TOMsMessageLog.logMessage(
            "In TOMsTransaction:startTransactionGroup.", level=Qgis.Warning
        )

        if self.currTransactionGroup.isEmpty():
            TOMsMessageLog.logMessage(
                "In TOMsTransaction:startTransactionGroup. Currently empty adding layers",
                level=Qgis.Info,
            )
            self.createTransactionGroup()

        status = self.tableNames.setLayer(
            self.tomsTransactionList[0]
        ).startEditing()  # could be any table ...
        if not status:
            TOMsMessageLog.logMessage(
                "In TOMsTransaction:startTransactionGroup. *** Error starting transaction ...",
                level=Qgis.Info,
            )
        else:
            TOMsMessageLog.logMessage(
                "In TOMsTransaction:startTransactionGroup. Transaction started correctly!!! ...",
                level=Qgis.Info,
            )
        return status

    def layerModified(self):
        self.modified = True

    def isTransactionGroupModified(self):
        # indicates whether or not there has been any change within the transaction
        return self.modified

    def printMessage(self, layer, message):
        TOMsMessageLog.logMessage(
            "In TOMsTransaction:printMessage. "
            + str(message)
            + " ... "
            + str(layer.name()),
            level=Qgis.Info,
        )

    def printRaiseError(self, layer, message):
        TOMsMessageLog.logMessage(
            "TOMsTransaction: Error from " + str(layer.name()) + ": " + str(message),
            level=Qgis.Info,
        )
        self.errorOccurred = True
        self.errorMessage = message

    def commitTransactionGroup(self):

        TOMsMessageLog.logMessage(
            "In TOMsTransaction:commitTransactionGroup", level=Qgis.Warning
        )

        # unset map tool. I don't understand why this is required, but ... without it QGIS crashes
        # currMapTool = self.iface.mapCanvas().mapTool()
        # currMapTool.deactivate()
        self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())
        # self.mapTool = None

        if not self.currTransactionGroup:
            TOMsMessageLog.logMessage(
                "In TOMsTransaction:commitTransactionGroup. Transaction DOES NOT exist",
                level=Qgis.Warning,
            )
            return False

        if self.errorOccurred:
            QMessageBox.information(
                None, "Error", str(self.errorMessage), QMessageBox.Ok
            )
            self.rollBackTransactionGroup()
            return False

        for layer in self.setTransactionGroup:

            TOMsMessageLog.logMessage(
                "In TOMsTransaction:commitTransactionGroup. Considering: "
                + layer.name(),
                level=Qgis.Warning,
            )

            commitStatus = layer.commitChanges()

            if not commitStatus:
                QMessageBox.information(
                    None,
                    "Error",
                    "Changes to "
                    + layer.name()
                    + " failed: "
                    + str(layer.commitErrors()),
                    QMessageBox.Ok,
                )
                TOMsMessageLog.logMessage(
                    "In TOMsTransaction:commitTransactionGroup. Changes to "
                    + layer.name()
                    + " failed: "
                    + str(layer.commitErrors()),
                    level=Qgis.Critical,
                )
                layer.rollBack()

            break

        self.modified = False
        self.errorOccurred = False

        # signal for redraw ...
        # self.transactionCompleted.emit()

        try:
            self.proposalsManager.updateMapCanvas()
        except Exception:
            TOMsMessageLog.logMessage(
                "In TOMsTransaction:commitTransactionGroup. Issue updating map canvas *** ...",
                level=Qgis.Warning,
            )

        return commitStatus

    def layersInTransaction(self):
        return self.setTransactionGroup

    def errorInTransaction(self, errorMsg):
        QMessageBox.information(
            None,
            "Error",
            "TOMsTransaction:Proposal changes failed: " + errorMsg,
            QMessageBox.Ok,
        )
        TOMsMessageLog.logMessage("In errorInTransaction: " + errorMsg, level=Qgis.Info)

    def deleteTransactionGroup(self):

        if self.currTransactionGroup:

            if self.currTransactionGroup.modified():
                TOMsMessageLog.logMessage(
                    "In TOMsTransaction:deleteTransactionGroup. Transaction contains edits ... NOT deleting",
                    level=Qgis.Info,
                )
                return

            self.currTransactionGroup.commitError.disconnect(self.errorInTransaction)
            self.currTransactionGroup = None

    def rollBackTransactionGroup(self):

        TOMsMessageLog.logMessage(
            "In TOMsTransaction:rollBackTransactionGroup", level=Qgis.Info
        )

        # unset map tool. I don't understand why this is required, but ... without it QGIS crashes
        self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())

        try:
            self.tableNames.setLayer(
                self.tomsTransactionList[0]
            ).rollBack()  # could be any table ...
            TOMsMessageLog.logMessage(
                "In TOMsTransaction:rollBackTransactionGroup. Transaction rolled back correctly ...",
                level=Qgis.Warning,
            )
        except Exception as e:
            TOMsMessageLog.logMessage(
                "In TOMsTransaction:rollBackTransactionGroup. rollback error {}".format(
                    e
                ),
                level=Qgis.Warning,
            )

        self.modified = False
        self.errorOccurred = False
        self.errorMessage = None

        try:
            self.proposalsManager.updateMapCanvas()
        except Exception:
            TOMsMessageLog.logMessage(
                "In TOMsTransaction:rollBackTransactionGroup. Issue updating map canvas *** ...",
                level=Qgis.Warning,
            )