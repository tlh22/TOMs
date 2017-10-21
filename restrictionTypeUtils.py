
from PyQt4.QtGui import (
    QMessageBox
)

from qgis.core import (
    QgsExpressionContextUtils,
    QgsMapLayerRegistry,
    QgsMessageLog, QgsFeature, QgsGeometry
)

import uuid

class RestrictionTypeUtils:
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

    @staticmethod  # NB: Duplicated from restrictionOpenForm.py - need to understand scope and how to reference !!!
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
    def onSaveRestrictionDetails(currRestriction, currRestrictionLayer, dialog):
        QgsMessageLog.logMessage("In onSaveRestrictionDetails.", tag="TOMs panel")

        currRestrictionLayer.startEditing()

        currProposalID = int(QgsExpressionContextUtils.projectScope().variable('CurrentProposal'))

        if currProposalID > 0:

            currRestrictionLayerTableID = RestrictionTypeUtils.getRestrictionLayerTableID(currRestrictionLayer)
            idxGeometryID = currRestriction.fieldNameIndex("GeometryID")

            if RestrictionTypeUtils.restrictionInProposal(currRestriction[idxGeometryID], currRestrictionLayerTableID, currProposalID):

                # simply make changes to the current restriction in the current layer
                QgsMessageLog.logMessage("In onSaveRestrictionDetails. Saving details straight from form.",
                                         tag="TOMs panel")
                dialog.save()

            else:
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

                    currRestriction = dialog.feature()
                    currRestriction[idxGeometryID] = newGeometryID
                    dialog.changeAttribute("GeometryID", str(currRestriction[idxGeometryID]))
                    # currRestrictionLayer.updateFeature(currRestriction)

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Adding new restriction. ID: " + str(currRestriction[idxGeometryID]),
                        tag="TOMs panel")

                    # restrictionsDialog.save()  # accept all the details for the original feature
                    RestrictionTypeUtils.addRestrictionToProposal(currRestriction[idxGeometryID], currRestrictionLayerTableID,
                                             currProposalID, 1)  # Open = 1

                    # Now need to save the feature ??
                    # dialog.save()

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
                                             currProposalID, 2)  # Open = 1; Close = 2

                    newRestriction = dialog.feature()

                    # _geom_buffer = QgsGeometry(currRestriction.geometry())
                    # newRestriction.setGeometry(_geom_buffer)

                    newRestriction[idxGeometryID] = newGeometryID
                    newRestriction[idxOpenDate] = None
                    currRestrictionLayer.addFeatures([newRestriction])

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Clone restriction. New ID: " + str(newRestriction[idxGeometryID]),
                        tag="TOMs panel")

                    RestrictionTypeUtils.addRestrictionToProposal(newRestriction[idxGeometryID], currRestrictionLayerTableID,
                                             currProposalID, 1)  # Open = 1; Close = 2

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Opening clone. ID: " + str(
                            newRestriction[idxGeometryID]) + " new Restriction Type: " + str(
                            newRestriction[idxRestrictionTypeID]),
                        tag="TOMs panel")

                    # set existing restriction back to original form
                    # currRestriction = origRestriction

                    # restrictionsDialog.resetValues # remove any changes to the original feature
                    # restrictionsDialog.reject()  # return to the original feature

        else:   # currProposal = 0, i.e., no change allowed

            """reply = QMessageBox.information(None, "Information",
                                            "Changes to current data are not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)"""
            dialog.resetValues()

        pass

        # ************* refresh the view. Might be able to set up a signal to get the proposals_panel to intervene

        # qgis.utils.plugins['TOMs'].proposalsManager
        # proposalsPanel.filterView()

        """def getRestrictionLayerTableID(currRestLayer):
        QgsMessageLog.logMessage("In getRestrictionLayerTableID.", tag="TOMs panel")
        # find the ID for the layer within the table "

        RestrictionsLayers2 = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers2")[0]

        layersTableID = 0

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for layer in RestrictionsLayers2.getFeatures():
            if layer.attribute("RestrictionLayerName") == str(currRestLayer.name()):
                layersTableID = layer.attribute("id")

        QgsMessageLog.logMessage("In getRestrictionLayerTableID. layersTableID: " + str(layersTableID),
                                 tag="TOMs panel")

        return layersTableID"""

        """def restrictionInProposal(currRestrictionID, currRestrictionLayerID, proposalID):
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

        return restrictionFound """

        """def addRestrictionToProposal(restrictionID, restrictionLayerTableID, proposalID, proposedAction):
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

        QgsMessageLog.logMessage(
            "In addRestrictionToProposal. Before record create. RestrictionID: " + str(restrictionID), tag="TOMs panel")

        RestrictionsInProposalsLayer.addFeatures([newRestrictionsInProposal])

        pass """

        """def getOriginalRestriction(restriction, restrictionLayer):
        # return the restriction from the data provider?

        QgsMessageLog.logMessage("In getOriginalRestriction.", tag="TOMs panel")

        idxGeometryID = restrictionLayer.fieldNameIndex("GeometryID")
        idxRestrictionTypeID = restrictionLayer.fieldNameIndex("RestrictionTypeID")

        restrictionFID = restriction.id()

        #origFeature = restrictionLayer.getFeature(restrictionFID)

        QgsMessageLog.logMessage(
        "In onSaveRestrictionDetails. Closing existing restriction. ID: " + str(
            restrictionLayer[idxGeometryID]) + " curr Rest Type: " + str(restrictionLayer[idxRestrictionTypeID]) + " existing Restriction Type: " + str(origFeature[idxRestrictionTypeID]),
        tag="TOMs panel")

        return origFeature """

