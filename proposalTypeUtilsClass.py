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
    QMessageBox
)

from PyQt4.QtCore import (
    QTimer
)

from qgis.core import (
    QgsExpressionContextUtils,
    QgsMapLayerRegistry,
    QgsMessageLog, QgsFeature, QgsGeometry, QgsTransaction
)

from qgis.gui import *
import functools

from TOMs.constants import (
    PROPOSAL_STATUS_IN_PREPARATION,
    PROPOSAL_STATUS_ACCEPTED,
    PROPOSAL_STATUS_REJECTED
)

#from TOMs.TOMsTableNames import TOMsTableNames

#from TOMs.restrictionTypeUtils import RestrictionTypeUtils
from TOMs.restrictionTypeUtilsClass import RestrictionTypeUtilsMixin

#from TOMs.core.proposalsManager import *
import time

import uuid

class ProposalTypeUtilsMixin(RestrictionTypeUtilsMixin):

    def __init__(self, iface):
        #self.constants = TOMsConstants()
        #self.proposalsManager = proposalsManager
        self.iface = iface
        #self.tableNames = TOMsTableNames()
        pass

        """def onSaveProposalFormDetails(self, currProposal, proposalsLayer, proposalsDialog):
        QgsMessageLog.logMessage("In onSaveProposalFormDetails.", tag="TOMs panel")

        # proposalsLayer.startEditing()
        """
        """def onSaveProposalDetails(self):
        QgsMessageLog.logMessage("In onSaveProposalFormDetails.", tag="TOMs panel")
        self.Proposals.startEditing()
        """
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

        updateStatus = False
        newProposal = False

        # Set up transaction group
        #currTrans = ProposalTypeUtils.createProposalTransactionGroup(proposalsLayer)
        #transStatus = currTrans.begin()


        if updateStatus == True:
            reply = QMessageBox.information(None, "Information",
                                            "About to accept proposal",
                                            QMessageBox.Ok)
            self.acceptProposal(currProposal[idxProposalID], currProposal[idxProposalOpenDate])

        if currProposal[idxProposalStatusID] == PROPOSAL_STATUS_ACCEPTED():  # 2 = accepted

            reply = QMessageBox.question(None, 'Confirm changes to Proposal',
                                         # How do you access the main window to make the popup ???
                                         'Are you you want to ACCEPT this proposal?. Accepting will make all the proposed changes permanent.',
                                         QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:
                # open the proposal - and accept any other changes to the form

                # currProposalID = currProposal[idxProposalID]

                # TODO: Need to check that this is an authorised user

                if updateStatus == True:
                    reply = QMessageBox.information(None, "Information",
                                                    "About to accept proposal",
                                                    QMessageBox.Ok)
                    self.acceptProposal(currProposal[idxProposalID], currProposal[idxProposalOpenDate])

                updateStatus = proposalsLayer.updateFeature(currProposal)


                #proposalsDialog.save()

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
                if updateStatus == True:
                    self.rejectProposal(currProposal[idxProposalID])

                #proposalsDialog.save()

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
                currProposal.setGeometry(QgsGeometry())

            updateStatus = proposalsLayer.updateFeature(currProposal)

            QgsMessageLog.logMessage(
                "In onSaveProposalFormDetails. updateStatus = " + str(updateStatus),
                tag="TOMs panel")
            updateStatus = True

            proposalsDialog.accept()

        QgsMessageLog.logMessage("In onSaveProposalFormDetails. Before save. " + str(currProposal.attribute("ProposalTitle")) + " Status: " + str(currProposal.attribute("ProposalStatusID")), tag="TOMs panel")
        #QMessageBox.information(None, "Information", ("Just before Proposal save in onSaveProposalFormDetails"))

        reply = QMessageBox.information(None, "Information",
                                        "Before save. " + str(currProposal.attribute("ProposalTitle")) + " Status: " + str(currProposal.attribute("ProposalStatusID")),
                                        QMessageBox.Ok)
        #QgsMessageLog.logMessage("In onSaveProposalFormDetails. Saving: Proposals", tag="TOMs panel")

        # A little pause for the db to catch up
        """
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
        """
        #ProposalTypeUtils.commitProposalChanges(proposalsLayer)

        # Make sure that the saving will not be executed immediately, but
        # only when the event loop runs into the next iteration to avoid
        # problems

        if updateStatus == False:

            reply = QMessageBox.information(None, "Error",
                                            "Changes to " + proposalsLayer.name() + " failed: " + str(
                                                proposalsLayer.commitErrors()),
                                            QMessageBox.Ok)
        else:

            #QTimer.singleShot(0, functools.partial(self.commitProposalChanges, proposalsLayer))
            self.commitProposalChanges(proposalsLayer)
        pass

        # For some reason the committedFeaturesAdded signal for layer "Proposals" is not firing at this point and so the cbProposals is not refreshing ...

        if newProposal == True:
            QgsMessageLog.logMessage("In onSaveProposalFormDetails. refreshing cbProposals ???", tag="TOMs panel")
            #ProposalTypeUtils.iface.proposalChanged.emit()

    def acceptProposal(self, currProposalID, currProposalOpenDate):
        QgsMessageLog.logMessage("In acceptProposal.", tag="TOMs panel")

        reply = QMessageBox.information(None, "Information",
                                        "In accept Proposal",
                                        QMessageBox.Ok)
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

                currRestrictionLayer.startEditing()
                self.updateRestriction(currRestrictionLayer, currRestrictionID, currAction, currProposalOpenDate)

                reply = QMessageBox.information(None, "Information",
                                            "Update made to " + str(currRestrictionID) + " on " + currRestrictionLayer.name(),
                                            QMessageBox.Ok)

        reply = QMessageBox.information(None, "Information",
                                            "About to update tiles",
                                            QMessageBox.Ok)

        self.updateTileRevisionNrs(currProposalID)

        pass

    def updateTileRevisionNrs(self, currProposalID):
        QgsMessageLog.logMessage("In updateTileRevisionNrs.", tag="TOMs panel")
        # Increment the relevant tile numbers
        tileList = self.getProposalTileList(currProposalID)

        for tile in tileList:
            QgsMessageLog.logMessage("In updateTileRevisionNrs. tile" + str (tile), tag="TOMs panel")
            pass

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

                currRestrictionLayer.startEditing()
                self.updateRestriction(currRestrictionLayer, currRestrictionID, currAction, None)

            pass

        pass"""

    def commitProposalChanges(self, proposalsLayer):
        # Function to save changes to current layer and to RestrictionsInProposal

        QgsMessageLog.logMessage("In commitProposalChanges: ", tag="TOMs panel")

        # save changes to all layers

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fieldNameIndex("RestrictionLayerName")
        #idxRestrictionsLayerID = RestrictionsLayers.fieldNameIndex("id")

        status = False

        try:

            if proposalsLayer.isEditable():
                QgsMessageLog.logMessage("In commitProposalChanges. Saving Proposals Layer: " + str(proposalsLayer.name()),
                                         tag="TOMs panel")
                proposalsLayer.commitChanges()

            for layer in RestrictionsLayers.getFeatures():

                currRestrictionLayerName = layer[idxRestrictionsLayerName]

                restrictionLayer = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionLayerName)[0]

                if restrictionLayer.isEditable():
                    QgsMessageLog.logMessage("In commitProposalChanges. Saving: " + str(restrictionLayer.name()), tag="TOMs panel")

                    restrictionLayer.commitChanges()

            # Include tile layer in the transaction commit
            if self.tileLayer.isEditable():
                QgsMessageLog.logMessage("In commitProposalChanges. Saving tileLayer Layer: " + str(self.tileLayer.name()),
                                         tag="TOMs panel")
                self.tileLayer.commitChanges()

        except:

            reply = QMessageBox.information(None, "Error",
                                            "Changes to " + restrictionLayer.name() + " failed: " + str(
                                                restrictionLayer.commitErrors()) + str(
                                                    proposalsLayer.commitErrors()), QMessageBox.Ok)

            # rollback all changes
            proposalsLayer.rollback()
            restrictionLayer.rollback()

        """status = currTrans.commit()
        if status == False:
            status2 = currTrans.rollback()"""

        QgsMessageLog.logMessage("In commitProposalChanges. Finished. ", tag="TOMs panel")

        pass

        # Once the changes are successfully made to RestrictionsInProposals, a signal shouldbe triggered to update the view

    def createProposalTransactionGroup(self, proposalsLayer):
        # Function to create group of layers to be in Transaction for changing proposal

        QgsMessageLog.logMessage("In createProposalTransactionGroup: ", tag="TOMs panel")
        #QMessageBox.information(None, "Information", ("Entering commitRestrictionChanges"))

        # save changes to all layers

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        if QgsMapLayerRegistry.instance().mapLayersByName("MapGrid"):
            self.tileLayer = QgsMapLayerRegistry.instance().mapLayersByName("MapGrid")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table MapGrid is not present"))
            return

        idxRestrictionsLayerName = RestrictionsLayers.fieldNameIndex("RestrictionLayerName")
        idxRestrictionsLayerID = RestrictionsLayers.fieldNameIndex("id")

        # create transaction
        newTransaction = QgsTransaction()

        QgsMessageLog.logMessage("In createProposalTransactionGroup. Adding ProposalsLayer ", tag="TOMs panel")
        newTransaction.addLayer(proposalsLayer)

        for layer in RestrictionsLayers.getFeatures():

            currRestrictionLayerName = layer[idxRestrictionsLayerName]

            restrictionLayer = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionLayerName)[0]

            newTransaction.addLayer(restrictionLayer)
            QgsMessageLog.logMessage("In createProposalTransactionGroup. Adding " + str(restrictionLayer.name()), tag="TOMs panel")

        # Also add MapGrid to list of layers in transaction

        newTransaction.addLayer(self.tileLayer)

        return newTransaction
