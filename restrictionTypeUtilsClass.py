#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock 2017

"""
Series of functions to deal with restrictionsInProposals. Defined as static functions to allow them to be used in forms ... (not sure if this is the best way ...)

"""
from PyQt4.QtGui import (
    QMessageBox,
    QAction,
    QIcon,
    QDialogButtonBox,
    QPixmap,
    QLabel
)
from PyQt4.QtCore import (
    QTimer
)

from qgis.core import (
    QgsExpressionContextUtils,
    QgsMapLayerRegistry,
    QgsMessageLog, QgsFeature, QgsGeometry,
    QgsTransaction, QgsTransactionGroup
)

from qgis.gui import *
import functools
import time
import os

from TOMs.constants import (
    ACTION_CLOSE_RESTRICTION,
    ACTION_OPEN_RESTRICTION,
    PROPOSAL_STATUS_IN_PREPARATION,
    PROPOSAL_STATUS_ACCEPTED,
    PROPOSAL_STATUS_REJECTED
)

#from TOMs.core.proposalsManager import *

from abc import ABCMeta

import uuid

class TOMsTransaction ():

    def __init__(self, iface):

        #QgsTransaction.__init__(self)
        self.iface = iface
        # proposalTransaction = QgsTransaction.__init__(self)
        # proposalTransaction = QgsTransaction()
        # __metaclass__ = ABCMeta
        #self.tableNames = tableNames

        # Function to create group of layers to be in Transaction for changing proposal

    def prepareLayerSet(self):

        self.tableNames = setupTableNames(self.iface)
        # Function to create group of layers to be in Transaction for changing proposal

        QgsMessageLog.logMessage("In TOMsTransaction.create: ", tag="TOMs panel")
        #QMessageBox.information(None, "Information", ("Entering commitRestrictionChanges"))

        # save changes to all layers

        #RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = self.tableNames.RESTRICTIONLAYERS.fieldNameIndex("RestrictionLayerName")
        idxRestrictionsLayerID = self.tableNames.RESTRICTIONLAYERS.fieldNameIndex("id")

        # create transaction
        #newTransaction = QgsTransaction("Test1")

        #QgsMessageLog.logMessage("In In TOMsTransaction.create. Adding ProposalsLayer ", tag="TOMs panel")
        self.setTransactionGroup = [self.tableNames.PROPOSALS.id()]
        self.setTransactionGroup2 = [self.tableNames.PROPOSALS]

        self.setTransactionGroup.append(self.tableNames.RESTRICTIONS_IN_PROPOSALS.id())
        self.setTransactionGroup2.append(self.tableNames.RESTRICTIONS_IN_PROPOSALS)
        #self.setTransactionGroup.append(self.tableNames.BAYS.id())#
        """QgsMessageLog.logMessage("In In TOMsTransaction.create. SUCCESS Adding RestrictionsInProposals Layer ",
                                 tag="TOMs panel")"""

        for layer in self.tableNames.RESTRICTIONLAYERS.getFeatures():

            currRestrictionLayerName = layer[idxRestrictionsLayerName]

            restrictionLayer = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionLayerName)[0]

            self.setTransactionGroup.append(restrictionLayer.id())
            self.setTransactionGroup2.append(restrictionLayer)
            QgsMessageLog.logMessage("In In TOMsTransaction.create. Adding " + str(restrictionLayer.name()), tag="TOMs panel")

    def create(self):

        self.prepareLayerSet()

        self.newTransaction = QgsTransaction.create(self.setTransactionGroup)

        """if not newTransaction.supportsTransaction(self.tableNames.RESTRICTIONS_IN_PROPOSALS):
            QgsMessageLog.logMessage("In createProposalTransactionGroup. ERROR Adding RestrictionsInProposals Layer ",
                                     tag="TOMs panel")
        else:
            setTransactionGroup.append(self.tableNames.RESTRICTIONS_IN_PROPOSALS.id())
            QgsMessageLog.logMessage("In createProposalTransactionGroup. SUCCESS Adding RestrictionsInProposals Layer ",
                                     tag="TOMs panel")"""

        self.newTransaction.begin()

        if self.newTransaction:

            for layerID in self.setTransactionGroup:

                #currRestrictionLayerName = layer[idxRestrictionsLayerName]

                transLayer = QgsMapLayerRegistry.instance().mapLayer(layerID)

                """caps_string = transLayer.capabilitiesString()
                QgsMessageLog.logMessage("In createProposalTransactionGroup: " + str(transLayer.name()) + ": capabilities: " + caps_string,
                         tag="TOMs panel")"""

                #statusSupp = newTransaction.supportsTransaction(transLayer)
                if not self.newTransaction.supportsTransaction(transLayer):
                    QgsMessageLog.logMessage("In createProposalTransactionGroup. ERROR Adding " + str(transLayer.name()),
                                             tag="TOMs panel")
                else:
                    QgsMessageLog.logMessage("In createProposalTransactionGroup. SUCCESS Adding " + str(transLayer.name()), tag="TOMs panel")
                    transLayer.startEditing()

        return self.newTransaction

    def createGroup(self):

        self.prepareLayerSet()

        self.newTransactionGroup = QgsTransactionGroup()
        """if not newTransaction.supportsTransaction(self.tableNames.RESTRICTIONS_IN_PROPOSALS):
            QgsMessageLog.logMessage("In createProposalTransactionGroup. ERROR Adding RestrictionsInProposals Layer ",
                                     tag="TOMs panel")
        else:
            setTransactionGroup.append(self.tableNames.RESTRICTIONS_IN_PROPOSALS.id())
            QgsMessageLog.logMessage("In createProposalTransactionGroup. SUCCESS Adding RestrictionsInProposals Layer ",
                                     tag="TOMs panel")"""

        if self.newTransactionGroup:

            for layer in self.setTransactionGroup2:

                #currRestrictionLayerName = layer[idxRestrictionsLayerName]


                self.newTransactionGroup.addLayer(layer)
                layer.startEditing()

        return self.newTransactionGroup

    def layersInTransaction(self):
        return self.setTransactionGroup

    def __del__(self):

        self.newTransaction = None
        self.newTransactionGroup = None
        del self.newTransaction
        del self.newTransactionGroup

class setupTableNames():
    def __init__(self, iface):

        self.iface = iface
        found = True

        #RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        if QgsMapLayerRegistry.instance().mapLayersByName("Proposals"):
            self.PROPOSALS = QgsMapLayerRegistry.instance().mapLayersByName("Proposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table Proposals is not present"))
            found = False

        if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers"):
            self.RESTRICTIONLAYERS = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionLayers is not present"))
            found = False

        if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals"):
            self.RESTRICTIONS_IN_PROPOSALS = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionsInProposals is not present"))
            found = False

        if QgsMapLayerRegistry.instance().mapLayersByName("Bays"):
            self.BAYS = QgsMapLayerRegistry.instance().mapLayersByName("Bays")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table Bays is not present"))
            found = False

        if QgsMapLayerRegistry.instance().mapLayersByName("Lines"):
            self.LINES = QgsMapLayerRegistry.instance().mapLayersByName("Lines")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table Lines is not present"))
            found = False

        if QgsMapLayerRegistry.instance().mapLayersByName("Signs"):
            self.SIGNS = QgsMapLayerRegistry.instance().mapLayersByName("Signs")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table Signs is not present"))
            found = False

        # TODO: need to deal with any errors arising ...

class RestrictionTypeUtilsMixin():

    def __init__(self, iface):
        #self.constants = TOMsConstants()
        #self.proposalsManager = proposalsManager
        self.iface = iface
        self.tableNames = setupTableNames(self.iface)
        #super().__init__()

        #self.proposalTransaction = QgsTransaction()

        pass

    def restrictionInProposal(self, currRestrictionID, currRestrictionLayerID, proposalID):
        # returns True if resstriction is in Proposal
        QgsMessageLog.logMessage("In restrictionInProposal.", tag="TOMs panel")

        RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]

        restrictionFound = False

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for restrictionInProposal in RestrictionsInProposalsLayer.getFeatures():
            if restrictionInProposal.attribute("RestrictionID") == currRestrictionID:
                if restrictionInProposal.attribute("RestrictionTableID") == currRestrictionLayerID:
                    if restrictionInProposal.attribute("ProposalID") == proposalID:
                        restrictionFound = True

        QgsMessageLog.logMessage("In restrictionInProposal. restrictionFound: " + str(restrictionFound),
                                 tag="TOMs panel")

        return restrictionFound

    def addRestrictionToProposal(self, restrictionID, restrictionLayerTableID, proposalID, proposedAction):
        # adds restriction to the "RestrictionsInProposals" layer
        QgsMessageLog.logMessage("In addRestrictionToProposal.", tag="TOMs panel")

        RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]

        RestrictionsInProposalsLayer.startEditing()

        idxProposalID = RestrictionsInProposalsLayer.fieldNameIndex("ProposalID")
        idxRestrictionID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionID")
        idxRestrictionTableID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionTableID")
        idxActionOnProposalAcceptance = RestrictionsInProposalsLayer.fieldNameIndex(
            "ActionOnProposalAcceptance")

        newRestrictionsInProposal = QgsFeature(RestrictionsInProposalsLayer.fields())
        newRestrictionsInProposal.setGeometry(QgsGeometry())

        newRestrictionsInProposal[idxProposalID] = proposalID
        newRestrictionsInProposal[idxRestrictionID] = restrictionID
        newRestrictionsInProposal[idxRestrictionTableID] = restrictionLayerTableID
        newRestrictionsInProposal[idxActionOnProposalAcceptance] = proposedAction

        QgsMessageLog.logMessage(
            "In addRestrictionToProposal. Before record create. RestrictionID: " + str(restrictionID),
            tag="TOMs panel")

        attrs = newRestrictionsInProposal.attributes()

        #QMessageBox.information(None, "Information", ("addRestrictionToProposal" + str(attrs)))

        RestrictionsInProposalsLayer.addFeatures([newRestrictionsInProposal])

        pass

    def getRestrictionsLayer(self, currRestrictionTableRecord):
        # return the layer given the row in "RestrictionLayers"
        QgsMessageLog.logMessage("In getRestrictionLayer.", tag="TOMs panel")

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fieldNameIndex("RestrictionLayerName")

        currRestrictionsTableName = currRestrictionTableRecord[idxRestrictionsLayerName]

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionsTableName)[0]

        return RestrictionsLayers

    def getRestrictionsLayerFromID(self, currRestrictionTableID):
        # return the layer given the row in "RestrictionLayers"
        QgsMessageLog.logMessage("In getRestrictionsLayerFromID.", tag="TOMs panel")

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fieldNameIndex("RestrictionLayerName")
        idxRestrictionsLayerID = RestrictionsLayers.fieldNameIndex("id")

        for layer in RestrictionsLayers.getFeatures():
            if layer[idxRestrictionsLayerID] == currRestrictionTableID:
                currRestrictionLayerName = layer[idxRestrictionsLayerName]

        restrictionLayer = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionLayerName)[0]

        return restrictionLayer

    def getRestrictionLayerTableID(self, currRestLayer):
        QgsMessageLog.logMessage("In getRestrictionLayerTableID.", tag="TOMs panel")
        # find the ID for the layer within the table "

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        layersTableID = 0

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for layer in RestrictionsLayers.getFeatures():
            if layer.attribute("RestrictionLayerName") == str(currRestLayer.name()):
                layersTableID = layer.attribute("id")

        QgsMessageLog.logMessage("In getRestrictionLayerTableID. layersTableID: " + str(layersTableID),
                                 tag="TOMs panel")

        return layersTableID

    def deleteRestrictionInProposal(self, currRestrictionID, currRestrictionLayerID, proposalID):
        QgsMessageLog.logMessage("In deleteRestrictionInProposal: " + str(currRestrictionID), tag="TOMs panel")

        returnStatus = False

        RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]

        RestrictionsInProposalsLayer.startEditing()

        for restrictionInProposal in RestrictionsInProposalsLayer.getFeatures():
            if restrictionInProposal.attribute("RestrictionID") == currRestrictionID:
                if restrictionInProposal.attribute("RestrictionTableID") == currRestrictionLayerID:
                    if restrictionInProposal.attribute("ProposalID") == proposalID:
                        QgsMessageLog.logMessage("In deleteRestrictionInProposal - deleting ",
                                                 tag="TOMs panel")

                        attrs = restrictionInProposal.attributes()

                        #QMessageBox.information(None, "Information", ("deleteRestrictionInProposal" + str(attrs)))

                        RestrictionsInProposalsLayer.deleteFeature(restrictionInProposal.id())
                        returnStatus = True
                        return returnStatus

        return returnStatus

    def onSaveRestrictionDetails(self, currRestriction, currRestrictionLayer, dialog, currTransaction):
        QgsMessageLog.logMessage("In onSaveRestrictionDetails: " + str(currRestriction.attribute("GeometryID")), tag="TOMs panel")

        #currRestrictionLayer.startEditing()

        currProposalID = int(QgsExpressionContextUtils.projectScope().variable('CurrentProposal'))

        if currProposalID > 0:

            currRestrictionLayerTableID = self.getRestrictionLayerTableID(currRestrictionLayer)
            idxRestrictionID = currRestriction.fieldNameIndex("RestrictionID")
            idxGeometryID = currRestriction.fieldNameIndex("GeometryID")

            if self.restrictionInProposal(currRestriction[idxRestrictionID], currRestrictionLayerTableID, currProposalID):

                # restriction already is part of the current proposal
                # simply make changes to the current restriction in the current layer
                QgsMessageLog.logMessage("In onSaveRestrictionDetails. Saving details straight from form." + str(currRestriction.attribute("RestrictionTypeID")),
                                         tag="TOMs panel")

                #res = dialog.save()
                currRestrictionLayer.updateFeature(currRestriction)
                dialog.attributeForm().save()

                """if res == True:
                    QgsMessageLog.logMessage("In onSaveRestrictionDetails. Form saved.",
                                             tag="TOMs panel")
                else:
                    QgsMessageLog.logMessage("In onSaveRestrictionDetails. Form NOT saved.",
                                             tag="TOMs panel")"""

            else:

                # restriction is NOT part of the current proposal

                # need to:
                #    - enter the restriction into the table RestrictionInProposals, and
                #    - make a copy of the restriction in the current layer (with the new details)

                # QgsMessageLog.logMessage("In onSaveRestrictionDetails. Adding restriction. ID: " + str(currRestriction.id()),
                #                         tag="TOMs panel")

                # Create a new feature using the current details

                idxOpenDate = currRestriction.fieldNameIndex("OpenDate")
                #idxRestrictionTypeID = currRestriction.fieldNameIndex("RestrictionTypeID")
                newRestrictionID = str(uuid.uuid4())

                if currRestriction[idxRestrictionID] is None:
                    # This is a feature that has just been created. It exists but doesn't have a GeometryID.

                    # Not quite sure what is happening here but think the following:
                    #  Feature does not yet exist, i.e., not saved to layer yet, so there is no id for it and can't use either feature or layer to save
                    #  So, need to continue to modify dialog value which will be eventually saved

                    #currRestriction = dialog.feature()
                    #currRestriction[idxRestrictionID] = newRestrictionID

                    #dialog.changeAttribute("RestrictionID", newRestrictionID)

                    currRestriction.setAttribute(idxRestrictionID, newRestrictionID)
                    dialog.attributeForm().changeAttribute("RestrictionID", newRestrictionID)
                    #currRestriction = dialog.feature()
                    #currRestriction.setAttribute("RestrictionID", newRestrictionID)
                    #currRestrictionLayer.changeAttributeValue(currRestriction.id(), "RestrictionID", str(currRestriction[idxRestrictionID]))
                    # currRestrictionLayer.updateFeature(currRestriction)
                    #dialog.accept()

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Adding new restriction. ID: " + str(currRestriction[idxRestrictionID]),
                        tag="TOMs panel")
                    # currRestrictionLayer.addFeatures([currRestriction])

                    self.addRestrictionToProposal(str(currRestriction[idxRestrictionID]), currRestrictionLayerTableID,
                                             currProposalID, ACTION_OPEN_RESTRICTION())  # Open = 1

                    dialog.attributeForm().save()

                else:

                    # this feature was created before this session, we need to:
                    #  - close it in the RestrictionsInProposals table
                    #  - clone it in the current Restrictions layer (with a new GeometryID and no OpenDate)
                    #  - and then stop any changes to the original feature

                    # ************* need to discuss: seems that new has become old !!!

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Closing existing restriction. ID: " + str(
                            currRestriction[idxRestrictionID]),
                        tag="TOMs panel")

                    self.addRestrictionToProposal(currRestriction[idxRestrictionID], currRestrictionLayerTableID,
                                             currProposalID, ACTION_CLOSE_RESTRICTION())  # Open = 1; Close = 2

                    newRestriction = QgsFeature(currRestriction)

                    dialog.reject()

                    newRestriction[idxRestrictionID] = newRestrictionID
                    newRestriction[idxOpenDate] = None
                    newRestriction[idxGeometryID] = None
                    currRestrictionLayer.addFeatures([newRestriction])

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Clone restriction. New ID: " + str(newRestriction[idxRestrictionID]),
                        tag="TOMs panel")

                    attrs2 = newRestriction.attributes()
                    QgsMessageLog.logMessage("In onSaveRestrictionDetails: clone Restriction: " + str(attrs2),
                        tag="TOMs panel")
                    QgsMessageLog.logMessage("In onSaveRestrictionDetails. Clone: {}".format(newRestriction.geometry().exportToWkt()),
                                             tag="TOMs panel")

                    self.addRestrictionToProposal(newRestriction[idxRestrictionID], currRestrictionLayerTableID,
                                             currProposalID, ACTION_OPEN_RESTRICTION())  # Open = 1; Close = 2

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Opening clone. ID: " + str(
                            newRestriction[idxRestrictionID]),
                        tag="TOMs panel")

                pass

            # Now commit changes and redraw

            attrs1 = currRestriction.attributes()
            QgsMessageLog.logMessage("In onSaveRestrictionDetails: currRestriction: " + str(attrs1),
                                     tag="TOMs panel")
            QgsMessageLog.logMessage(
                "In onSaveRestrictionDetails. curr: {}".format(currRestriction.geometry().exportToWkt()),
                tag="TOMs panel")

            # Make sure that the saving will not be executed immediately, but
            # only when the event loop runs into the next iteration to avoid
            # problems

            self.commitRestrictionChanges (currRestrictionLayer, currTransaction)
            #QTimer.singleShot(0, functools.partial(RestrictionTypeUtils.commitRestrictionChanges, currRestrictionLayer))

        else:   # currProposal = 0, i.e., no change allowed

            """reply = QMessageBox.information(None, "Information",
                                            "Changes to current data are not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)"""
            dialog.resetValues()

        pass

        # ************* refresh the view. Might be able to set up a signal to get the proposals_panel to intervene

        QgsMessageLog.logMessage(
        "In onSaveRestrictionDetails. Finished",
        tag="TOMs panel")

        dialog.close()
        currRestrictionLayer.removeSelection()

    def setDefaultRestrictionDetails(self, currRestriction, currRestrictionLayer):
        QgsMessageLog.logMessage("In setDefaultRestrictionDetails: ", tag="TOMs panel")

        if currRestrictionLayer.name() == "Lines":
            currRestriction.setAttribute("RestrictionTypeID", 10)  # 10 = SYL (Lines) or Resident Permit Holders Bays (Bays)
            currRestriction.setAttribute("GeomShapeID", 10)   # 10 = Parallel Line
        elif currRestrictionLayer.name() == "Bays":
            currRestriction.setAttribute("RestrictionTypeID", 28)  # 28 = Permit Holders Bays (Bays)
            currRestriction.setAttribute("GeomShapeID", 21)   # 21 = Parallel Bay (Polygon)
        pass

    def commitRestrictionChanges(self, currRestrictionLayer, currTransaction):
        # Function to save changes to current layer and to RestrictionsInProposal

        QgsMessageLog.logMessage("In commitRestrictionChanges: currLayer: " + str(currRestrictionLayer.name()), tag="TOMs panel")
        #QMessageBox.information(None, "Information", ("Entering commitRestrictionChanges"))

        # Trying to unset map tool to force updates ...
        #qgis.utils.iface.mapCanvas().unsetMapTool(qgis.utils.iface.mapCanvas().mapTool())
        self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())

        # Added to stop save actions
        #return

        # save changes to currRestrictionLayer

        errMessage = str()

        if currTransaction.commit() == False:

            reply = QMessageBox.information(None, "Error",
                                                "Proposal changes failed: " + str(errMessage),
                                                QMessageBox.Ok)  # rollback all changes

            if currTransaction.rollback() == False:
                reply = QMessageBox.information(None, "Error",
                                                "Proposal rollback failed: " + str(errMessage),
                                                QMessageBox.Ok)  # rollback all changes

        del currTransaction
        self.rollbackCurrentEdits()

        """res = True
        res = currRestrictionLayer.commitChanges()

        QgsMessageLog.logMessage("In commitRestrictionChanges: res ...", tag="TOMs panel")
        if res == False:
            # save the active layer

            reply = QMessageBox.information(None, "Error",
                                            "Changes to " + currRestrictionLayer.name() + " failed: " + str(
                                                currRestrictionLayer.commitErrors()),
                                            QMessageBox.Ok)

            # Should we rollback?

        else:

            # save changes to RestrictionsInProposal
            RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]

            QgsMessageLog.logMessage("Committing to RestrictionsInProposalsLayer ... ", tag="TOMs panel")

            if RestrictionsInProposalsLayer.isEditable():
                #time.sleep(.300)
                res2 = True
                res2 = RestrictionsInProposalsLayer.commitChanges()

                if res2 == False:

                    reply = QMessageBox.information(None, "Error",
                                                    "Changes to RestrictionsInProposal failed: " + str(
                                                        RestrictionsInProposalsLayer.commitErrors()),
                                                    QMessageBox.Ok)

                pass
            pass
        pass"""



        # Once the changes are successfully made to RestrictionsInProposals, a signal shouldbe triggered to update the view

    def updateRestriction(self, currRestrictionLayer, currRestrictionID, currAction, currProposalOpenDate):
        # update the Open/Close date for the restriction
        QgsMessageLog.logMessage("In updateRestriction. layer: " + str(
            currRestrictionLayer.name()) + " currRestId: " + currRestrictionID + " Opendate: " + str(
            currProposalOpenDate), tag="TOMs panel")

        # idxOpenDate = currRestrictionLayer.fieldNameIndex("OpenDate2")
        # idxCloseDate = currRestrictionLayer.fieldNameIndex("CloseDate2")

        # clear filter
        currRestrictionLayer.setSubsetString("")

        for currRestriction in currRestrictionLayer.getFeatures():
            #QgsMessageLog.logMessage("In updateRestriction. checkRestId: " + currRestriction.attribute("GeometryID"), tag="TOMs panel")

            if currRestriction.attribute("RestrictionID") == currRestrictionID:
                QgsMessageLog.logMessage(
                    "In updateRestriction. Action on: " + currRestrictionID + " Action: " + str(currAction),
                    tag="TOMs panel")
                if currAction == ACTION_OPEN_RESTRICTION():  # Open
                    statusUpd = currRestrictionLayer.changeAttributeValue(currRestriction.id(),
                                                              currRestrictionLayer.fieldNameIndex("OpenDate"),
                                                              currProposalOpenDate)
                    QgsMessageLog.logMessage(
                        "In updateRestriction. " + currRestrictionID + " Opened", tag="TOMs panel")
                else:  # Close
                    statusUpd = currRestrictionLayer.changeAttributeValue(currRestriction.id(),
                                                              currRestrictionLayer.fieldNameIndex("CloseDate"),
                                                              currProposalOpenDate)
                    QgsMessageLog.logMessage(
                        "In updateRestriction. " + currRestrictionID + " Closed", tag="TOMs panel")

                return statusUpd

        pass

    def setupRestrictionDialog(self, restrictionDialog, currRestrictionLayer, currRestriction, currTransaction):

        self.restrictionDialog = restrictionDialog
        self.currRestrictionLayer = currRestrictionLayer
        self.currRestriction = currRestriction
        self.currTransaction = currTransaction

        if self.restrictionDialog is None:
            QgsMessageLog.logMessage(
                "In restrictionFormOpen. dialog not found",
                tag="TOMs panel")

        self.restrictionDialog.attributeForm().disconnectButtonBox()
        self.button_box = self.restrictionDialog.findChild(QDialogButtonBox, "button_box")

        if self.button_box is None:
            QgsMessageLog.logMessage(
                "In restrictionFormOpen. button box not found",
                tag="TOMs panel")

        self.button_box.accepted.disconnect(self.restrictionDialog.accept)
        self.button_box.accepted.connect(self.onSaveRestrictionDetailsFromForm)

        self.restrictionDialog.attributeForm().attributeChanged.connect(functools.partial(self.onAttributeChangedClass2, currRestriction, self.currRestrictionLayer))

        self.button_box.rejected.disconnect(self.restrictionDialog.reject)
        self.button_box.rejected.connect(self.onRejectRestrictionDetailsFromForm)

        self.photoDetails(self.restrictionDialog, self.currRestrictionLayer, self.currRestriction)

    def onSaveRestrictionDetailsFromForm(self):
        QgsMessageLog.logMessage("In onSaveRestrictionDetailsFromForm", tag="TOMs panel")
        self.onSaveRestrictionDetails(self.currRestriction,
                                      self.currRestrictionLayer, self.restrictionDialog, self.currTransaction)

    def onRejectRestrictionDetailsFromForm(self):
        QgsMessageLog.logMessage("In onRejectRestrictionDetailsFromForm", tag="TOMs panel")
        self.currRestrictionLayer.destroyEditCommand()
        self.restrictionDialog.reject()
        del self.currTransaction
        self.rollbackCurrentEdits()

    def onAttributeChangedClass(self, fieldName, value):
        QgsMessageLog.logMessage(
            "In restrictionFormOpen:onAttributeChanged - layer: " + str(self.currRestrictionLayer.name()) + " (" + str(
                self.currRestriction.attribute("GeometryID")) + "): " + fieldName + ": " + str(value), tag="TOMs panel")

        # self.currRestriction.setAttribute(fieldName, value)
        self.currRestriction.setAttribute(self.currRestrictionLayer.fieldNameIndex(fieldName), value)
        # self.currRestrictionLayer.changeAttributeValue(self.currRestriction, self.currRestrictionLayer.fieldNameIndex(fieldName), value)

    def onAttributeChangedClass2(self, currFeature, layer, fieldName, value):
        QgsMessageLog.logMessage(
            "In FormOpen:onAttributeChanged - layer: " + str(layer.name()) + " (" + fieldName + "): " + str(value), tag="TOMs panel")

        # self.currRestriction.setAttribute(fieldName, value)
        currFeature.setAttribute(layer.fieldNameIndex(fieldName), value)

        # self.currRestrictionLayer.changeAttributeValue(self.currRestriction, self.currRestrictionLayer.fieldNameIndex(fieldName), value)

    def photoDetails(self, dialog, currRestLayer, currRestrictionFeature):

        # Function to deal with photo fields

        QgsMessageLog.logMessage("In photoDetails", tag="TOMs panel")

        FIELD1 = dialog.findChild(QLabel, "Photo_Widget_01")
        FIELD2 = dialog.findChild(QLabel, "Photo_Widget_02")
        FIELD3 = dialog.findChild(QLabel, "Photo_Widget_03")

        path_absolute = QgsExpressionContextUtils.projectScope().variable('PhotoPath')
        if path_absolute == None:
            reply = QMessageBox.information(None, "Information", "Please set value for PhotoPath.", QMessageBox.Ok)
            return

        layerName = currRestLayer.name()

        # Generate the full path to the file

        fileName1 = layerName + "_Photos_01"
        fileName2 = layerName + "_Photos_02"
        fileName3 = layerName + "_Photos_03"

        idx1 = currRestLayer.fieldNameIndex(fileName1)
        idx2 = currRestLayer.fieldNameIndex(fileName2)
        idx3 = currRestLayer.fieldNameIndex(fileName3)

        QgsMessageLog.logMessage("In photoDetails. idx1: " + str(idx1) + "; " + str(idx2) + "; " + str(idx3),
                                 tag="TOMs panel")
        # if currRestrictionFeature[idx1]:
        # QgsMessageLog.logMessage("In photoDetails. photo1: " + str(currRestrictionFeature[idx1]), tag="TOMs panel")
        # QgsMessageLog.logMessage("In photoDetails. photo2: " + str(currRestrictionFeature.attribute(idx2)), tag="TOMs panel")
        # QgsMessageLog.logMessage("In photoDetails. photo3: " + str(currRestrictionFeature.attribute(idx3)), tag="TOMs panel")

        if FIELD1:
            QgsMessageLog.logMessage("In photoDetails. FIELD 1 exisits",
                                     tag="TOMs panel")
            if currRestrictionFeature[idx1]:
                newPhotoFileName1 = os.path.join(path_absolute, currRestrictionFeature[idx1])
            else:
                newPhotoFileName1 = None

            QgsMessageLog.logMessage("In photoDetails. A. Photo1: " + str(newPhotoFileName1), tag="TOMs panel")
            pixmap1 = QPixmap(newPhotoFileName1)
            if pixmap1.isNull():
                pass
                # FIELD1.setText('Picture could not be opened ({path})'.format(path=newPhotoFileName1))
            else:
                FIELD1.setPixmap(pixmap1)
                FIELD1.setScaledContents(True)
                QgsMessageLog.logMessage("In photoDetails. Photo1: " + str(newPhotoFileName1), tag="TOMs panel")

        if FIELD2:
            QgsMessageLog.logMessage("In photoDetails. FIELD 2 exisits",
                                     tag="TOMs panel")
            if currRestrictionFeature[idx2]:
                newPhotoFileName2 = os.path.join(path_absolute, currRestrictionFeature[idx2])
            else:
                newPhotoFileName2 = None

            # newPhotoFileName2 = os.path.join(path_absolute, str(currRestrictionFeature[idx2]))
            # newPhotoFileName2 = os.path.join(path_absolute, str(currRestrictionFeature.attribute(fileName2)))
            QgsMessageLog.logMessage("In photoDetails. A. Photo2: " + str(newPhotoFileName2), tag="TOMs panel")
            pixmap2 = QPixmap(newPhotoFileName2)
            if pixmap2.isNull():
                pass
                # FIELD1.setText('Picture could not be opened ({path})'.format(path=newPhotoFileName1))
            else:
                FIELD1.setPixmap(pixmap2)
                FIELD1.setScaledContents(True)
                QgsMessageLog.logMessage("In photoDetails. Photo2: " + str(newPhotoFileName2), tag="TOMs panel")

        if FIELD3:
            QgsMessageLog.logMessage("In photoDetails. FIELD 3 exisits",
                                     tag="TOMs panel")
            if currRestrictionFeature[idx3]:
                newPhotoFileName3 = os.path.join(path_absolute, currRestrictionFeature[idx3])
            else:
                newPhotoFileName3 = None

            # newPhotoFileName3 = os.path.join(path_absolute, str(currRestrictionFeature[idx3]))
            # newPhotoFileName3 = os.path.join(path_absolute,
            #                                 str(currRestrictionFeature.attribute(fileName3)))
            # newPhotoFileName3 = os.path.join(path_absolute, str(layerName + "_Photos_03"))
            pixmap3 = QPixmap(newPhotoFileName3)
            if pixmap3.isNull():
                pass
                # FIELD1.setText('Picture could not be opened ({path})'.format(path=newPhotoFileName1))
            else:
                FIELD1.setPixmap(pixmap3)
                FIELD1.setScaledContents(True)
                QgsMessageLog.logMessage("In photoDetails. Photo3: " + str(newPhotoFileName3), tag="TOMs panel")

        pass

    def onSaveProposalFormDetails(self, currProposal, proposalsLayer, proposalsDialog, currTransaction):
        QgsMessageLog.logMessage("In onSaveProposalFormDetails.", tag="TOMs panel")

        # proposalsLayer.startEditing()

        """def onSaveProposalDetails(self):
        QgsMessageLog.logMessage("In onSaveProposalFormDetails.", tag="TOMs panel")
        self.Proposals.startEditing()
        """

        #proposalsLayerfromClass = TOMsTableNames.PROPOSALS()
        #QgsMessageLog.logMessage("In onSaveProposalFormDetails. Proposals (class):" + str(proposalsLayerfromClass.name()), tag="TOMs panel")

        # set up field indexes
        idxProposalID = proposalsLayer.fieldNameIndex("ProposalID")
        idxProposalTitle = proposalsLayer.fieldNameIndex("ProposalTitle")
        idxProposalStatusID = proposalsLayer.fieldNameIndex("ProposalStatusID")
        idxProposalNotes = proposalsLayer.fieldNameIndex("ProposalNotes")
        idxProposalCreateDate = proposalsLayer.fieldNameIndex("ProposalCreateDate")
        idxProposalOpenDate = proposalsLayer.fieldNameIndex("ProposalOpenDate")

        QgsMessageLog.logMessage("In onSaveProposalFormDetails. currProposalStatus = " + str(currProposal[idxProposalStatusID]), tag="TOMs panel")

        #updateStatus = False
        newProposal = False

        if currProposal[idxProposalStatusID] == PROPOSAL_STATUS_ACCEPTED():  # 2 = accepted

            reply = QMessageBox.question(None, 'Confirm changes to Proposal',
                                         # How do you access the main window to make the popup ???
                                         'Are you you want to ACCEPT this proposal?. Accepting will make all the proposed changes permanent.',
                                         QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:
                # open the proposal - and accept any other changes to the form

                # currProposalID = currProposal[idxProposalID]

                # TODO: Need to check that this is an authorised user


                updateStatus = True

                if updateStatus == True:
                    currProposalID = currProposal[idxProposalID]
                    currOpenDate = currProposal[idxProposalOpenDate]
                    self.acceptProposal(currProposalID, currOpenDate)

                # Now close dialog
                proposalsDialog.accept()

                #updateStatus = proposalsLayer.updateFeature(currProposal)

                proposalsDialog.close()

                # proposalAccepted.emit()

            else:
                # proposalsDialog.reject ((currProposal[idxProposalID]))
                proposalsDialog.reject()

        elif currProposal[idxProposalStatusID] == PROPOSAL_STATUS_REJECTED():  # 3 = rejected

            reply = QMessageBox.question(None, 'Confirm changes to Proposal',
                                         # How do you access the main window to make the popup ???
                                         'Are you you want to REJECT this proposal?. Accepting will make all the proposed changes permanent.',
                                         QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:
                # open the proposal - and accept any other changes to the form

                # currProposalID = currProposal[idxProposalID]

                # TODO: Need to check that this is an authorised user

                updateStatus = proposalsLayer.updateFeature(currProposal)
                updateStatus = True

                if updateStatus == True:
                    self.rejectProposal(currProposal[idxProposalID])

                #proposalsDialog.accept()
                proposalsDialog.close()
                # proposalAccepted.emit()

            else:
                # proposalsDialog.reject ((currProposal[idxProposalID]))
                proposalsDialog.reject()

        else:

            QgsMessageLog.logMessage(
                "In onSaveProposalFormDetails. currProposalID = " + str(currProposal[idxProposalID]),
                tag="TOMs panel")

            # anything else can be saved.
            if currProposal[idxProposalID] == None:

                # This is a new proposal ...

                newProposal = True

                # add geometry
                #currProposal.setGeometry(QgsGeometry())

            """updateStatus = proposalsLayer.updateFeature(currProposal)

            QgsMessageLog.logMessage(
                "In onSaveProposalFormDetails. updateStatus = " + str(updateStatus),
                tag="TOMs panel")
            updateStatus = True"""

            proposalsDialog.accept()
            #proposalsDialog.close()
            #proposalsDialog.attributeForm().save()

        QgsMessageLog.logMessage("In onSaveProposalFormDetails. Before save. " + str(currProposal.attribute("ProposalTitle")) + " Status: " + str(currProposal.attribute("ProposalStatusID")), tag="TOMs panel")
        #QMessageBox.information(None, "Information", ("Just before Proposal save in onSaveProposalFormDetails"))

        #QgsMessageLog.logMessage("In onSaveProposalFormDetails. Saving: Proposals", tag="TOMs panel")

        # A little pause for the db to catch up
        """time.sleep(.1)

        res = proposalsLayer.commitChanges()
        QgsMessageLog.logMessage("In onSaveProposalFormDetails. Saving: Proposals. res: " + str(res), tag="TOMs panel")

        if res <> True:
            # save the active layer

            reply = QMessageBox.information(None, "Error",
                                            "Changes to " + proposalsLayer.name() + " failed: " + str(
                                                proposalsLayer.commitErrors()),
                                            QMessageBox.Ok)
        pass"""

        #ProposalTypeUtils.commitProposalChanges(proposalsLayer)

        # Make sure that the saving will not be executed immediately, but
        # only when the event loop runs into the next iteration to avoid
        # problems

        #self.Proposals.editCommandEnded.connect(self.proposalsManager.setCurrentProposal)

        # QTimer.singleShot(0, functools.partial(self.commitProposalChanges, proposalsLayer))
        self.commitProposalChanges(proposalsLayer, currTransaction)

        """if updateStatus == False:

            reply = QMessageBox.information(None, "Error",
                                            "Changes to " + proposalsLayer.name() + " failed: " + str(
                                                proposalsLayer.commitErrors()),
                                            QMessageBox.Ok)
        else:

            # set up action for when new proposal is created
            # self.Proposals.editingStopped.connect(self.createProposalcb)
            # self.Proposals.featureAdded.connect(self.proposalsManager.setCurrentProposal)
            self.Proposals.editCommandEnded.connect(self.proposalsManager.setCurrentProposal)

            #QTimer.singleShot(0, functools.partial(self.commitProposalChanges, proposalsLayer))
            self.commitProposalChanges(proposalsLayer)
        pass"""

        # For some reason the committedFeaturesAdded signal for layer "Proposals" is not firing at this point and so the cbProposals is not refreshing ...

        if newProposal == True:
            QgsMessageLog.logMessage("In onSaveProposalFormDetails. newProposalID = " + str(currProposal.id()), tag="TOMs panel")
            #self.proposalsManager.setCurrentProposal(currProposal[idxProposalID])
            #ProposalTypeUtils.iface.proposalChanged.emit()

            for proposal in self.Proposals.getFeatures():
                if proposal[idxProposalTitle] == currProposal[idxProposalTitle]:
                    QgsMessageLog.logMessage("In onSaveProposalFormDetails. newProposalID = " + str(proposal.id()),
                                             tag="TOMs panel")
                    newProposalID = proposal[idxProposalID]
                    #self.proposalsManager.setCurrentProposal(proposal[idxProposalID])

            self.proposalsManager.newProposalCreated.emit(newProposalID)

    def acceptProposal(self, currProposalID, currProposalOpenDate):
        QgsMessageLog.logMessage("In acceptProposal.", tag="TOMs panel")

        # Now loop through all the items in restrictionsInProposals for this proposal and take appropriate action

        RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]
        idxProposalID = RestrictionsInProposalsLayer.fieldNameIndex("ProposalID")
        idxRestrictionTableID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionTableID")
        idxRestrictionID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionID")
        idxActionOnProposalAcceptance = RestrictionsInProposalsLayer.fieldNameIndex("ActionOnProposalAcceptance")

        # restrictionFound = False

        # not sure if there is better way to search for something, .e.g., using SQL ??

        statusUpd = True

        for restrictionInProposal in RestrictionsInProposalsLayer.getFeatures():
            if restrictionInProposal.attribute("ProposalID") == currProposalID:
                currRestrictionLayer = self.getRestrictionsLayerFromID(restrictionInProposal.attribute("RestrictionTableID"))
                currRestrictionID = restrictionInProposal.attribute("RestrictionID")
                currAction = restrictionInProposal.attribute("ActionOnProposalAcceptance")

                #currRestrictionLayer.startEditing()

                """if not currRestrictionLayer.isEditable():
                    currRestrictionLayer.startEditing()"""

                statusUpd = self.updateRestriction(currRestrictionLayer, currRestrictionID, currAction, currProposalOpenDate)

                """if statusUpd == False:
                    reply = QMessageBox.information(None, "Error",
                                                    "Changes to " + currRestrictionLayer.name() + " failed: " + str(
                                                        currRestrictionLayer.commitErrors()), QMessageBox.Ok)
                    return statusUpd"""

        return statusUpd

    def rejectProposal(self, currProposalID):
        QgsMessageLog.logMessage("In rejectProposal.", tag="TOMs panel")

        # This is a "reset" so change all open/close dates back to null. **** Need to be careful if a restriction is in more than one proposal

        # Now loop through all the items in restrictionsInProposals for this proposal and take appropriate action

        RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]
        idxProposalID = RestrictionsInProposalsLayer.fieldNameIndex("ProposalID")
        idxRestrictionTableID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionTableID")
        idxRestrictionID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionID")
        idxActionOnProposalAcceptance = RestrictionsInProposalsLayer.fieldNameIndex("ActionOnProposalAcceptance")

        # restrictionFound = False

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for restrictionInProposal in RestrictionsInProposalsLayer.getFeatures():
            if restrictionInProposal.attribute("ProposalID") == currProposalID:
                currRestrictionLayer = self.getRestrictionsLayerFromID(restrictionInProposal.attribute("RestrictionTableID"))
                currRestrictionID = restrictionInProposal.attribute("RestrictionID")
                currAction = restrictionInProposal.attribute("ActionOnProposalAcceptance")

                #currRestrictionLayer.startEditing()
                if not currRestrictionLayer.isEditable():
                    currRestrictionLayer.startEditing()

                statusUpd = self.updateRestriction(currRestrictionLayer, currRestrictionID, currAction, None)

            pass

        pass

    def commitProposalChanges(self, proposalsLayer, currTransaction):
        # Function to save changes to current layer and to RestrictionsInProposal

        QgsMessageLog.logMessage("In commitProposalChanges: ", tag="TOMs panel")

        # save changes to all layers

        #localTrans = TOMsTransaction(self.iface)

        #localTrans.prepareLayerSet()
        #setLayers = localTrans.layersInTransaction()

        """for layerID in setLayers:

            transLayer = QgsMapLayerRegistry.instance().mapLayer(layerID)
            QgsMessageLog.logMessage("In commitProposalChanges. Considering: " + transLayer.name(), tag="TOMs panel")

            commitStatus = transLayer.commitChanges()
            commitErrors = transLayer.commitErrors()

            if commitErrors:
                reply = QMessageBox.information(None, "Error",
                                            "Changes to " + transLayer.name() + " failed: " + str(
                                                transLayer.commitErrors()) + str(
                                                    proposalsLayer.commitErrors()), QMessageBox.Ok)"""

        statusTrans = False
        errMessage = str()

        # setup signal catch
        #currTransaction.commitError.disconnect()
        currTransaction.commitError.connect(self.showTransactionErrorMessage)

        #try:
        modifiedTransaction = currTransaction.modified()
        statusTrans = proposalsLayer.commitChanges()
        commitErrors = proposalsLayer.commitErrors()
        """except:

            reply = QMessageBox.information(None, "Error",
                                                "Proposal changes failed: " + str(errMessage),
                                                QMessageBox.Ok)  # rollback all changes

            if currTransaction.rollback(errMessage) == False:
                reply = QMessageBox.information(None, "Error",
                                                "Proposal rollback failed: " + str(errMessage),
                                                QMessageBox.Ok)  # rollback all changes"""

        currTransaction.commitError.disconnect()
        del currTransaction
        self.rollbackCurrentEdits()

        # TODO: deal with errors in Transaction

        return

        """def createProposalTransactionGroup(self, tableNames):

        self.tableNames = tableNames
        # Function to create group of layers to be in Transaction for changing proposal

        QgsMessageLog.logMessage("In createProposalTransactionGroup: ", tag="TOMs panel")
        #QMessageBox.information(None, "Information", ("Entering commitRestrictionChanges"))

        # save changes to all layers

        #RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = self.tableNames.RESTRICTIONLAYERS.fieldNameIndex("RestrictionLayerName")
        idxRestrictionsLayerID = self.tableNames.RESTRICTIONLAYERS.fieldNameIndex("id")

        # create transaction
        #newTransaction = QgsTransaction("Test1")

        #QgsMessageLog.logMessage("In createProposalTransactionGroup. Adding ProposalsLayer ", tag="TOMs panel")
        self.setTransactionGroup = [self.tableNames.PROPOSALS.id()]

        self.setTransactionGroup.append(self.tableNames.RESTRICTIONS_IN_PROPOSALS.id())
        self.setTransactionGroup.append(self.tableNames.BAYS.id())
        QgsMessageLog.logMessage("In createProposalTransactionGroup. SUCCESS Adding RestrictionsInProposals Layer ",
                                 tag="TOMs panel")

        for layer in self.tableNames.RESTRICTIONLAYERS.getFeatures():

            currRestrictionLayerName = layer[idxRestrictionsLayerName]

            restrictionLayer = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionLayerName)[0]

            self.setTransactionGroup.append(restrictionLayer.id())
            QgsMessageLog.logMessage("In createProposalTransactionGroup. SUCCESS Adding " + str(restrictionLayer.name()), tag="TOMs panel")


        newTransaction = QgsTransaction.create(self.setTransactionGroup)


        if not newTransaction.supportsTransaction(self.tableNames.RESTRICTIONS_IN_PROPOSALS):
            QgsMessageLog.logMessage("In createProposalTransactionGroup. ERROR Adding RestrictionsInProposals Layer ",
                                     tag="TOMs panel")
        else:
            setTransactionGroup.append(self.tableNames.RESTRICTIONS_IN_PROPOSALS.id())
            QgsMessageLog.logMessage("In createProposalTransactionGroup. SUCCESS Adding RestrictionsInProposals Layer ",
                                     tag="TOMs panel")

        for layerID in self.setTransactionGroup:

            #currRestrictionLayerName = layer[idxRestrictionsLayerName]

            transLayer = QgsMapLayerRegistry.instance().mapLayer(layerID)


            caps_string = transLayer.capabilitiesString()
            QgsMessageLog.logMessage("In createProposalTransactionGroup: " + str(transLayer.name()) + ": capabilities: " + caps_string,
                                     tag="TOMs panel")

            statusSupp = newTransaction.supportsTransaction(transLayer)
            if not newTransaction.supportsTransaction(transLayer):
                QgsMessageLog.logMessage("In createProposalTransactionGroup. ERROR Adding " + str(transLayer.name()),
                                         tag="TOMs panel")
            else:
                QgsMessageLog.logMessage("In createProposalTransactionGroup. SUCCESS Adding " + str(transLayer.name()), tag="TOMs panel")


        return newTransaction"""

    def showTransactionErrorMessage(self):

        QgsMessageLog.logMessage("In showTransactionErrorMessage: ", tag="TOMs panel")

        """reply = QMessageBox.information(None, "Error",
                                        "Proposal changes failed: " + str(errMsg),
                                        QMessageBox.Ok)  # rollback all changes"""

    def rollbackCurrentEdits(self):
        # Function to rollback any changes to the tables that might have changes

        QgsMessageLog.logMessage("In rollbackCurrentEdits: ", tag="TOMs panel")

        # rollback changes to all layers

        proposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("Proposals")[0]
        RestrictionsInProposalLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]
        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fieldNameIndex("RestrictionLayerName")
        idxRestrictionsLayerID = RestrictionsLayers.fieldNameIndex("id")

        # create transaction
        #newTransaction = QgsTransaction("Test1")

        QgsMessageLog.logMessage("In rollbackCurrentEdits. ProposalsLayer ", tag="TOMs panel")

        if proposalsLayer.editBuffer():
            statusRollback = proposalsLayer.rollBack()

        if RestrictionsInProposalLayer.editBuffer():
            statusRollback = RestrictionsInProposalLayer.rollBack()

        for layer in RestrictionsLayers.getFeatures():

            currRestrictionLayerName = layer[idxRestrictionsLayerName]

            restrictionLayer = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionLayerName)[0]

            QgsMessageLog.logMessage("In rollbackCurrentEdits. " + str(restrictionLayer.name()), tag="TOMs panel")
            if restrictionLayer.editBuffer():
                statusRollback = restrictionLayer.rollBack()

        return
