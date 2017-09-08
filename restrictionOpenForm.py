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

nameField = None
myDialog = None

# https://nathanw.net/2011/09/05/qgis-tips-custom-feature-forms-with-python-logic/

def restrictionFormOpen(dialog, currRestLayer, currRestrictionFeature):
    QgsMessageLog.logMessage("In restrictionFormOpen", tag="TOMs panel")
    global restrictionsDialog
    restrictionsDialog = dialog
    global currRestriction
    global currRestrictionLayer
    global currProposalID

    currRestrictionLayer = currRestLayer
    QgsMessageLog.logMessage("In restrictionFormOpen. currRestrictionLayer: " + str(currRestrictionLayer.name()), tag="TOMs panel")

    currRestriction = currRestrictionFeature

    # Get the current proposal from the session variables
    currProposalID = int(QgsExpressionContextUtils.projectScope().variable('CurrentProposal'))

    #nameField = dialog.findChild(QLineEdit, "Name")
    button_box = restrictionsDialog.findChild(QDialogButtonBox, "button_box")

    # Disconnect the signal that QGIS has wired up for the dialog to the button box.
    button_box.accepted.disconnect(restrictionsDialog.accept)

    # Wire up our own signals.
    button_box.accepted.connect(onSaveRestrictionDetails)
    button_box.rejected.connect(restrictionsDialog.reject)

    pass


def onSaveRestrictionDetails():
    QgsMessageLog.logMessage("In onSaveRestrictionDetails.", tag="TOMs panel")

    currRestrictionLayer.startEditing()

    currRestrictionLayerTableID = getRestrictionLayerTableID(currRestrictionLayer)

    if restrictionInProposal(currRestriction.id(), currRestrictionLayerTableID, currProposalID):

        # simply make changes to the current restriction in the current layer
        QgsMessageLog.logMessage("In onSaveRestrictionDetails. Saving details straight from form.", tag="TOMs panel")
        restrictionsDialog.accept()

    else:
        # need to:
        #    - enter the restriction into the table RestrictionInProposals, and
        #    - make a copy of the restriction in the current layer (with the new details)

        QgsMessageLog.logMessage("In onSaveRestrictionDetails. Adding existing restriction. ID: " + str(currRestriction.id()),
                                 tag="TOMs panel")

        # Create a new feature
        newRestriction = QgsFeature(currRestrictionLayer.fields())
        _geom_buffer = QgsGeometry(currRestriction.geometry())
        newRestriction.setGeometry(QgsGeometry(_geom_buffer))

        idxGeometryID = newRestriction.fieldNameIndex("GeometryID")
        newRestriction[idxGeometryID] = str(uuid.uuid4())

        # add any calculated attributes here - Road Name, Az to CL

        currRestrictionLayer.addFeatures([newRestriction])

        addRestrictionToProposal(newRestriction[idxGeometryID], currRestrictionLayerTableID,
                                                  currProposalID, 1)  # Open = 1
        if currRestriction.id() > 0:
            # the feature already exists. We need to close the original
            addRestrictionToProposal(currRestriction[idxGeometryID], currRestrictionLayerTableID,
                                                      currProposalID, 2)  # Close = 2

    pass


def getRestrictionLayerTableID(currRestLayer):
    QgsMessageLog.logMessage("In getRestrictionLayerTableID.", tag="TOMs panel")
    # find the ID for the layer within the table "

    RestrictionsLayers2 = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers2")[0]

    layersTableID = 0

    # not sure if there is better way to search for something, .e.g., using SQL ??

    for layer in RestrictionsLayers2.getFeatures():
        if layer.attribute("RestrictionLayerName") == str(currRestLayer.name()):
            layersTableID = layer.attribute("id")

    QgsMessageLog.logMessage("In getRestrictionLayerTableID. layersTableID: " + str(layersTableID), tag="TOMs panel")

    return layersTableID


def restrictionInProposal(currRestrictionID, currRestrictionLayerID, proposalID):
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

    QgsMessageLog.logMessage("In restrictionInProposal. restrictionFound: " + str(restrictionFound), tag="TOMs panel")

    return restrictionFound


def addRestrictionToProposal(restrictionID, restrictionLayerTableID, proposalID, proposedAction):
    # adds restriction to the "RestrictionsInProposals" layer
    QgsMessageLog.logMessage("In addRestrictionToProposal.", tag="TOMs panel")

    RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]

    idxProposalID = RestrictionsInProposalsLayer.fieldNameIndex("ProposalID")
    idxRestrictionID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionID")
    idxRestrictionTableID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionTableID")
    idxActionOnProposalAcceptance = RestrictionsInProposalsLayer.fieldNameIndex("ActionOnProposalAcceptance")

    RestrictionsInProposalsLayer.startEditing()

    newRestrictionsInProposal = QgsFeature(RestrictionsInProposalsLayer.fields())
    newRestrictionsInProposal.setGeometry(QgsGeometry())

    newRestrictionsInProposal[idxProposalID] = proposalID
    newRestrictionsInProposal[idxRestrictionID] = restrictionID
    newRestrictionsInProposal[idxRestrictionTableID] = restrictionLayerTableID
    newRestrictionsInProposal[idxActionOnProposalAcceptance] = proposedAction

    QgsMessageLog.logMessage("In addRestrictionToProposal. Before record create. RestrictionID: " + str(restrictionID), tag="TOMs panel")

    RestrictionsInProposalsLayer.addFeatures([newRestrictionsInProposal])

    pass
