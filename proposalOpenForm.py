# -*- coding: utf-8 -*-
"""
/***************************************************************************
 ProposalPanel
                                 A QGIS plugin
 Proposal panel
                              -------------------
        begin                : 2017-09-02
        git sha              : $Format:%H$
        copyright            : (C) 2017 by MHTC
        email                : th@mhtc.co.uk
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""
from PyQt4.QtCore import *
from PyQt4.QtGui import *
#from manage_restriction_details import manageRestrictionDetails
import uuid
from qgis.core import *
from qgis.gui import *

from TOMs.mapTools import RestrictionTypeUtils

import functools

nameField = None
myDialog = None

#proposalCreated = pyqtSignal()
"""Signal will be emitted when a proposal is created"""


# https://nathanw.net/2011/09/05/qgis-tips-custom-feature-forms-with-python-logic/

def proposalFormOpen(proposalsDialog, proposalsLayer, currProposal):
    QgsMessageLog.logMessage("In proposalFormOpen", tag="TOMs panel")
    #global restrictionsDialog
    #proposalsDialog = dialog
    #global currRestriction
    #global currRestrictionLayer
    #global currProposalID
    #global origRestriction

    # This stops changes to the form being saved (unless explicitly enacted)
    #proposalsDialog.disconnectButtonBox()

    #currRestrictionLayer = currRestLayer
    QgsMessageLog.logMessage("In proposalFormOpen. proposalsLayer: " + str(proposalsLayer.name()), tag="TOMs panel")

    # try and make a copy of the original feature
    #origRestriction = QgsFeature()
    #origRestriction = getOriginalRestriction(currRestriction, currRestrictionLayer)
    # Get the current proposal from the session variables


    #currProposalID = int(QgsExpressionContextUtils.projectScope().variable('CurrentProposal'))

    #nameField = dialog.findChild(QLineEdit, "Name")
    button_box = proposalsDialog.findChild(QDialogButtonBox, "button_box")

    # Disconnect the signal that QGIS has wired up for the dialog to the button box.
    # button_box.accepted.disconnect(restrictionsDialog.accept)

    # To allow saving of the original feature, this fucntion follows changes to attributes within the table and records them to the current feature
    #proposalsDialog.attributeChanged.connect(functools.partial(onAttributeChanged, currRestrictionFeature))

    # Wire up our own signals.
    button_box.accepted.connect(functools.partial(onSaveProposalFormDetails, currProposal, proposalsLayer, proposalsDialog))
    button_box.rejected.connect(proposalsDialog.reject)

    pass

def onSaveProposalFormDetails(currProposal, proposalsLayer, proposalsDialog):
    QgsMessageLog.logMessage("In onSaveProposalFormDetails.", tag="TOMs panel")

    #proposalsLayer.startEditing()

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

    if currProposal[idxProposalStatusID] == 2:  # 2 = accepted

        reply = QMessageBox.question(None, 'Confirm changes to Proposal',    # How do you access the main window to make the popup ???
                                     'Are you you want to accept this proposal?. Accepting will make all the proposed changes permanent.',
                                     QMessageBox.Yes, QMessageBox.No)
        if reply == QMessageBox.Yes:
            # open the proposal - and accept any other changes to the form

            #currProposalID = currProposal[idxProposalID]
            acceptProposal(currProposal[idxProposalID], currProposal[idxProposalOpenDate])
            proposalsDialog.save()

            #proposalAccepted.emit()

        else:
            #proposalsDialog.reject ((currProposal[idxProposalID]))
            proposalsDialog.reject ()

    else:

        # anything else can be saved. If it is rejected, there is not action other than to save the status

        proposalsDialog.save()

    proposalsLayer.commitChanges()  # Save details

    #proposalCreated.emit()  # would signals be useful ??

    # update the proposals list
    #proposalsDialog.ProposalStatusID.update()
    #proposalsCB = proposalsDialog.findChild(QComboBox, "ProposalStatusID")
    #proposalsCB.clear()
    #proposalsCB.update()
    #createProposalcb(proposalsLayer, proposalsDialog)

    pass

def acceptProposal (currProposalID, currProposalOpenDate):
    QgsMessageLog.logMessage("In openProposal.", tag="TOMs panel")

    # Now loop through all the items in restrictionsInProposals for this proposal and take appropriate action

    RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]
    idxProposalID = RestrictionsInProposalsLayer.fieldNameIndex("ProposalID")
    idxRestrictionTableID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionTableID")
    idxRestrictionID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionID")
    idxActionOnProposalAcceptance = RestrictionsInProposalsLayer.fieldNameIndex("ActionOnProposalAcceptance")

    #restrictionFound = False

    # not sure if there is better way to search for something, .e.g., using SQL ??

    for restrictionInProposal in RestrictionsInProposalsLayer.getFeatures():
        if restrictionInProposal.attribute("ProposalID") == currProposalID:
            currRestrictionLayer = getRestrictionLayer(restrictionInProposal[idxRestrictionTableID])
            currRestrictionID = restrictionInProposal.attribute("RestrictionID")
            currAction = restrictionInProposal.attribute("ActionOnProposalAcceptance")

            currRestrictionLayer.startEditing()
            updateRestriction (currRestrictionLayer, currRestrictionID, currAction, currProposalOpenDate)

    pass

def rejectProposal (currProposal):
    QgsMessageLog.logMessage("In closeProposal.", tag="TOMs panel")
    pass

"""def createProposalcb(proposalsLayer, proposalsDialog):
    QgsMessageLog.logMessage("In createProposalcb. ",
                             tag="TOMs panel")
    # set up a "NULL" field for "No proposals to be shown"

    proposalsCB = proposalsDialog.findChild(QComboBox, "ProposalStatusID")
    QgsMessageLog.logMessage("In createProposalcb. cb id: " + str(proposalsCB.count()),
                             tag="TOMs panel")
    proposalsCB.clear()
    #proposalsDialog.ProposalStatusID.clear()

    currProposalID = 0
    currProposalTitle = "No proposal shown"

    proposalsCB.addItem(currProposalTitle, currProposalID)

    for proposal in proposalsLayer.getFeatures():
        currProposalStatusID = proposal.attribute("ProposalStatusID")

        if currProposalStatusID == 1:  # 1 = "in preparation"
            currProposalID = proposal.attribute("ProposalID")
            currProposalTitle = proposal.attribute("ProposalTitle")
            #proposalsDialog.ProposalStatusID.addItem(currProposalTitle, currProposalID)
            proposalsCB.addItem(currProposalTitle, currProposalID)
    pass """


def getRestrictionLayer(currRestrictionTableID):
    # return the layer given the row in "RestrictionLayers"
    QgsMessageLog.logMessage("In getRestrictionLayer.", tag="TOMs panel")

    RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers2")[0]

    idxRestrictionsLayerName = RestrictionsLayers.fieldNameIndex("RestrictionLayerName")
    idxRestrictionsLayerID = RestrictionsLayers.fieldNameIndex("id")

    for layer in RestrictionsLayers.getFeatures():
        if layer[idxRestrictionsLayerID] == currRestrictionTableID:
            currRestrictionLayerName = layer[idxRestrictionsLayerName]

    restrictionLayer = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionLayerName)[0]

    return restrictionLayer

def updateRestriction (currRestrictionLayer, currRestrictionID, currAction, currProposalOpenDate):
    # update the Open/Close date for the restriction
    QgsMessageLog.logMessage("In updateRestriction. layer: " + str(currRestrictionLayer.id()) + " currRestId: " + currRestrictionID + " Opendate: " + str(currProposalOpenDate), tag="TOMs panel")

    #idxOpenDate = currRestrictionLayer.fieldNameIndex("OpenDate2")
    #idxCloseDate = currRestrictionLayer.fieldNameIndex("CloseDate2")

    # clear filter
    currRestrictionLayer.setSubsetString("")

    for currRestriction in currRestrictionLayer.getFeatures():
        QgsMessageLog.logMessage("In updateRestriction. checkRestId: " + currRestriction.attribute("GeometryID"),
            tag="TOMs panel")

        if currRestriction.attribute("GeometryID") == currRestrictionID:
            QgsMessageLog.logMessage("In updateRestriction. Action on: " + currRestrictionID + " Action: " + str(currAction), tag="TOMs panel")
            if currAction == 1:   # Open
                currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fieldNameIndex("OpenDate2"), currProposalOpenDate)
                QgsMessageLog.logMessage(
                    "In updateRestriction. " + currRestrictionID + " Opened", tag="TOMs panel")
            else:   # Close
                currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fieldNameIndex("CloseDate2"), currProposalOpenDate)
            QgsMessageLog.logMessage(
                "In updateRestriction. " + currRestrictionID + " Opened", tag="TOMs panel")

            return

    pass