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
    QgsMessageLog, QgsFeature, QgsGeometry
)

from qgis.gui import *
import functools

from TOMs.constants import (
    PROPOSAL_STATUS_IN_PREPARATION,
    PROPOSAL_STATUS_ACCEPTED,
    PROPOSAL_STATUS_REJECTED
)

from TOMs.restrictionTypeUtils import RestrictionTypeUtils

#from TOMs.core.proposalsManager import *
import time

import uuid

class ProposalTypeUtils:

    def __init__(self, iface):
        #self.constants = TOMsConstants()
        #self.proposalsManager = proposalsManager
        pass

    @staticmethod
    def onSaveProposalFormDetails(currProposal, proposalsLayer, proposalsDialog):
        QgsMessageLog.logMessage("In onSaveProposalFormDetails.", tag="TOMs panel")

        # proposalsLayer.startEditing()

        """def onSaveProposalDetails(self):
        QgsMessageLog.logMessage("In onSaveProposalFormDetails.", tag="TOMs panel")
        self.Proposals.startEditing()
        """

        # set up field indexes
        idxProposalID = proposalsLayer.fieldNameIndex("ProposalID")
        idxProposalTitle = proposalsLayer.fieldNameIndex("ProposalTitle")
        idxProposalStatusID = proposalsLayer.fieldNameIndex("ProposalStatusID")
        idxProposalNotes = proposalsLayer.fieldNameIndex("ProposalNotes")
        idxProposalCreateDate = proposalsLayer.fieldNameIndex("ProposalCreateDate")
        idxProposalOpenDate = proposalsLayer.fieldNameIndex("ProposalOpenDate")

        if currProposal[idxProposalStatusID] == PROPOSAL_STATUS_ACCEPTED():  # 2 = accepted

            reply = QMessageBox.question(None, 'Confirm changes to Proposal',
                                         # How do you access the main window to make the popup ???
                                         'Are you you want to ACCEPT this proposal?. Accepting will make all the proposed changes permanent.',
                                         QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:
                # open the proposal - and accept any other changes to the form

                # currProposalID = currProposal[idxProposalID]
                ProposalTypeUtils.acceptProposal(currProposal[idxProposalID], currProposal[idxProposalOpenDate])
                proposalsLayer.updateFeature(currProposal)
                #proposalsDialog.save()

                # proposalAccepted.emit()

            else:
                # proposalsDialog.reject ((currProposal[idxProposalID]))
                proposalsDialog.reject()

        elif currProposal[idxProposalStatusID] == PROPOSAL_STATUS_REJECTED():

            reply = QMessageBox.question(None, 'Confirm changes to Proposal',
                                         # How do you access the main window to make the popup ???
                                         'Are you you want to REJECT this proposal?. Accepting will make all the proposed changes permanent.',
                                         QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:
                # open the proposal - and accept any other changes to the form

                # currProposalID = currProposal[idxProposalID]
                ProposalTypeUtils.rejectProposal(currProposal[idxProposalID])
                proposalsLayer.updateFeature(currProposal)
                #proposalsDialog.save()

                # proposalAccepted.emit()

            else:
                # proposalsDialog.reject ((currProposal[idxProposalID]))
                proposalsDialog.reject()


        else:

            # anything else can be saved.

            proposalsLayer.updateFeature(currProposal)
            #proposalsDialog.save()

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
        pass

        #ProposalTypeUtils.commitProposalChanges()"""

        # Make sure that the saving will not be executed immediately, but
        # only when the event loop runs into the next iteration to avoid
        # problems
        QTimer.singleShot(0, functools.partial(ProposalTypeUtils.commitProposalChanges, proposalsLayer))

        pass

    @staticmethod
    def acceptProposal(currProposalID, currProposalOpenDate):
        QgsMessageLog.logMessage("In openProposal.", tag="TOMs panel")

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
                currRestrictionLayer = RestrictionTypeUtils.getRestrictionsLayerFromID(restrictionInProposal.attribute("RestrictionTableID"))
                currRestrictionID = restrictionInProposal.attribute("RestrictionID")
                currAction = restrictionInProposal.attribute("ActionOnProposalAcceptance")

                currRestrictionLayer.startEditing()
                RestrictionTypeUtils.updateRestriction(currRestrictionLayer, currRestrictionID, currAction, currProposalOpenDate)

        pass

    @staticmethod
    def rejectProposal(currProposalID):
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
                currRestrictionLayer = RestrictionTypeUtils.getRestrictionsLayerFromID(restrictionInProposal.attribute("RestrictionTableID"))
                currRestrictionID = restrictionInProposal.attribute("RestrictionID")
                currAction = restrictionInProposal.attribute("ActionOnProposalAcceptance")

                currRestrictionLayer.startEditing()
                RestrictionTypeUtils.updateRestriction(currRestrictionLayer, currRestrictionID, currAction, None)

            pass

        pass

    @staticmethod
    def commitProposalChanges(proposalsLayer):
        # Function to save changes to current layer and to RestrictionsInProposal

        QgsMessageLog.logMessage("In commitProposalChanges: ", tag="TOMs panel")
        #QMessageBox.information(None, "Information", ("Entering commitRestrictionChanges"))

        # save changes to all layers

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fieldNameIndex("RestrictionLayerName")
        idxRestrictionsLayerID = RestrictionsLayers.fieldNameIndex("id")

        try:

            for layer in RestrictionsLayers.getFeatures():

                currRestrictionLayerName = layer[idxRestrictionsLayerName]

                restrictionLayer = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionLayerName)[0]

                if restrictionLayer.isEditable():
                    QgsMessageLog.logMessage("In commitProposalChanges. Saving: " + str(restrictionLayer.name()), tag="TOMs panel")

                    restrictionLayer.commitChanges()

            pass

            if proposalsLayer.isEditable():
                res = proposalsLayer.commitChanges()

        except:

            reply = QMessageBox.information(None, "Error",
                                            "Changes to " + restrictionLayer.name() + " failed: " + str(
                                                restrictionLayer.commitErrors()),
                                            QMessageBox.Ok)

        QgsMessageLog.logMessage("In commitProposalChanges. Finished. ", tag="TOMs panel")

        pass



        # Once the changes are successfully made to RestrictionsInProposals, a signal shouldbe triggered to update the view
