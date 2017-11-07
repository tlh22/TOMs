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

from qgis.core import (
    QgsExpressionContextUtils,
    QgsMapLayerRegistry,
    QgsMessageLog, QgsFeature, QgsGeometry
)

from qgis.gui import *

from TOMs.constants import (
    ACTION_CLOSE_RESTRICTION,
    ACTION_OPEN_RESTRICTION
)
from TOMs.core.proposalsManager import *

import uuid

class RestrictionTypeUtils:

    def __init__(self, iface, proposalsManager):
        #self.constants = TOMsConstants()
        pass

    @staticmethod
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

        QgsMessageLog.logMessage("In restrictionInProposal. restrictionFound: " + str(restrictionFound),
                                 tag="TOMs panel")

        return restrictionFound

    @staticmethod
    def addRestrictionToProposal(restrictionID, restrictionLayerTableID, proposalID, proposedAction):
        # adds restriction to the "RestrictionsInProposals" layer
        QgsMessageLog.logMessage("In addRestrictionToProposal.", tag="TOMs panel")

        RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]

        idxProposalID = RestrictionsInProposalsLayer.fieldNameIndex("ProposalID")
        idxRestrictionID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionID")
        idxRestrictionTableID = RestrictionsInProposalsLayer.fieldNameIndex("RestrictionTableID")
        idxActionOnProposalAcceptance = RestrictionsInProposalsLayer.fieldNameIndex(
            "ActionOnProposalAcceptance")

        RestrictionsInProposalsLayer.startEditing()

        newRestrictionsInProposal = QgsFeature(RestrictionsInProposalsLayer.fields())
        newRestrictionsInProposal.setGeometry(QgsGeometry())

        newRestrictionsInProposal[idxProposalID] = proposalID
        newRestrictionsInProposal[idxRestrictionID] = restrictionID
        newRestrictionsInProposal[idxRestrictionTableID] = restrictionLayerTableID
        newRestrictionsInProposal[idxActionOnProposalAcceptance] = proposedAction

        QgsMessageLog.logMessage(
            "In addRestrictionToProposal. Before record create. RestrictionID: " + str(restrictionID),
            tag="TOMs panel")

        RestrictionsInProposalsLayer.addFeatures([newRestrictionsInProposal])

        pass

    @staticmethod
    def getRestrictionsLayer(currRestrictionTableRecord):
        # return the layer given the row in "RestrictionLayers"
        QgsMessageLog.logMessage("In getRestrictionLayer.", tag="TOMs panel")

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fieldNameIndex("RestrictionLayerName")

        currRestrictionsTableName = currRestrictionTableRecord[idxRestrictionsLayerName]

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionsTableName)[0]

        return RestrictionsLayers

    @staticmethod
    def getRestrictionLayerTableID(currRestLayer):
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

    @staticmethod
    def deleteRestrictionInProposal(currRestrictionID, currRestrictionLayerID, proposalID):
        QgsMessageLog.logMessage("In deleteRestrictionInProposal: " + str(currRestrictionID), tag="TOMs panel")

        returnStatus = False

        RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]

        for restrictionInProposal in RestrictionsInProposalsLayer.getFeatures():
            if restrictionInProposal.attribute("RestrictionID") == currRestrictionID:
                if restrictionInProposal.attribute("RestrictionTableID") == currRestrictionLayerID:
                    if restrictionInProposal.attribute("ProposalID") == proposalID:
                        QgsMessageLog.logMessage("In deleteRestrictionInProposal - deleting ",
                                                 tag="TOMs panel")
                        RestrictionsInProposalsLayer.deleteFeature(restrictionInProposal.id())
                        returnStatus = True
                        return returnStatus

        return returnStatus

    @staticmethod
    def onSaveRestrictionDetails(currRestriction, currRestrictionLayer, dialog):
        QgsMessageLog.logMessage("In onSaveRestrictionDetails: " + str(currRestriction.attribute("GeometryID")), tag="TOMs panel")

        currRestrictionLayer.startEditing()

        currProposalID = int(QgsExpressionContextUtils.projectScope().variable('CurrentProposal'))

        if currProposalID > 0:

            currRestrictionLayerTableID = RestrictionTypeUtils.getRestrictionLayerTableID(currRestrictionLayer)
            idxGeometryID = currRestriction.fieldNameIndex("GeometryID")

            if RestrictionTypeUtils.restrictionInProposal(currRestriction[idxGeometryID], currRestrictionLayerTableID, currProposalID):

                # restriction already is part of the current proposal
                # simply make changes to the current restriction in the current layer
                QgsMessageLog.logMessage("In onSaveRestrictionDetails. Saving details straight from form." + str(currRestriction.attribute("RestrictionTypeID")),
                                         tag="TOMs panel")

                #res = dialog.save()
                currRestrictionLayer.updateFeature(currRestriction)
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
                idxRestrictionTypeID = currRestriction.fieldNameIndex("RestrictionTypeID")
                newGeometryID = str(uuid.uuid4())

                if currRestriction[idxGeometryID] is None:
                    # This is a feature that has just been created. It exists but doesn't have a GeometryID.

                    # Not quite sure what is happening here but think the following:
                    #  Feature does not yet exist, i.e., not saved to layer yet, so there is no id for it and can't use either feature or layer to save
                    #  So, need to continue to modify dialog value which will be eventually saved

                    #currRestriction = dialog.feature()
                    #currRestriction[idxGeometryID] = newGeometryID
                    dialog.changeAttribute("GeometryID", newGeometryID)
                    #currRestriction = dialog.feature()
                    #currRestriction.setAttribute("GeometryID", newGeometryID)
                    #currRestrictionLayer.changeAttributeValue(currRestriction.id(), "GeometryID", str(currRestriction[idxGeometryID]))
                    # currRestrictionLayer.updateFeature(currRestriction)
                    dialog.save()

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Adding new restriction. ID: " + str(currRestriction[idxGeometryID]),
                        tag="TOMs panel")
                    # currRestrictionLayer.addFeatures([currRestriction])

                    RestrictionTypeUtils.addRestrictionToProposal(str(currRestriction[idxGeometryID]), currRestrictionLayerTableID,
                                             currProposalID, ACTION_OPEN_RESTRICTION())  # Open = 1

                    # Now need to save the feature ??


                else:

                    # this feature was created before this session, we need to:
                    #  - close it in the RestrictionsInProposals table
                    #  - clone it in the current Restrictions layer (with a new GeometryID and no OpenDate)
                    #  - and then stop any changes to the original feature

                    # ************* need to discuss: seems that new has become old !!!

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Closing existing restriction. ID: " + str(
                            currRestriction[idxGeometryID]) + " existing Restriction Type: " + str(
                            currRestriction[idxRestrictionTypeID]),
                        tag="TOMs panel")

                    RestrictionTypeUtils.addRestrictionToProposal(currRestriction[idxGeometryID], currRestrictionLayerTableID,
                                             currProposalID, ACTION_CLOSE_RESTRICTION())  # Open = 1; Close = 2

                    newRestriction = dialog.feature()

                    newRestriction[idxGeometryID] = newGeometryID
                    newRestriction[idxOpenDate] = None
                    currRestrictionLayer.addFeatures([newRestriction])

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Clone restriction. New ID: " + str(newRestriction[idxGeometryID]),
                        tag="TOMs panel")

                    RestrictionTypeUtils.addRestrictionToProposal(newRestriction[idxGeometryID], currRestrictionLayerTableID,
                                             currProposalID, ACTION_OPEN_RESTRICTION())  # Open = 1; Close = 2

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Opening clone. ID: " + str(
                            newRestriction[idxGeometryID]) + " new Restriction Type: " + str(
                            newRestriction[idxRestrictionTypeID]),
                        tag="TOMs panel")

        else:   # currProposal = 0, i.e., no change allowed

            """reply = QMessageBox.information(None, "Information",
                                            "Changes to current data are not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)"""
            dialog.resetValues()

        pass

        # ************* refresh the view. Might be able to set up a signal to get the proposals_panel to intervene

    @staticmethod
    def setDefaultRestrictionDetails(currRestriction, currRestrictionLayer):
        QgsMessageLog.logMessage("In setDefaultRestrictionDetails: ", tag="TOMs panel")

        if currRestrictionLayer.name() == "Lines" or currRestrictionLayer.name() == "Bays":
            currRestriction.setAttribute("RestrictionTypeID", 1)  # 1 = SYL (Lines) or Resident Permit Holders Bays (Bays)
            currRestriction.setAttribute("GeomShapeID", 6)   # 6 = Other
        pass

