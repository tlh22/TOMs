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

from qgis.core import (
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

from .constants import (
    ACTION_CLOSE_RESTRICTION,
    ACTION_OPEN_RESTRICTION,
    PROPOSAL_STATUS_IN_PREPARATION,
    PROPOSAL_STATUS_ACCEPTED,
    PROPOSAL_STATUS_REJECTED
)

from .generateGeometryUtils import generateGeometryUtils
#from core.proposalsManager import *
from .core.proposalsManager import *

from abc import ABCMeta

import uuid

class TOMsTransaction (QObject):

    transactionCompleted = pyqtSignal()
    """Signal will be emitted, when the transaction is finished - either committed or rollback"""

    def __init__(self, iface, proposalsManager):

        QObject.__init__(self)

        self.iface = iface

        self.proposalsManager = proposalsManager  # included to allow call to updateMapCanvas

        #self.currTransactionGroup = None
        self.currTransactionGroup = QgsTransactionGroup()
        self.prepareLayerSet()

        self.errorOccurred = False

    def prepareLayerSet(self):

        # Function to create group of layers to be in Transaction for changing proposal

        self.tableNames = setupTableNames(self.iface)
        self.tableNames.getLayers()

        QgsMessageLog.logMessage("In TOMsTransaction. prepareLayerSet: ", tag="TOMs panel")

        idxRestrictionsLayerName = self.tableNames.RESTRICTIONLAYERS.fields().indexFromName("RestrictionLayerName")

        self.setTransactionGroup = [self.tableNames.PROPOSALS]
        self.setTransactionGroup.append(self.tableNames.RESTRICTIONS_IN_PROPOSALS)
        self.setTransactionGroup.append(self.tableNames.MAP_GRID)
        self.setTransactionGroup.append(self.tableNames.TILES_IN_ACCEPTED_PROPOSALS)

        for layer in self.tableNames.RESTRICTIONLAYERS.getFeatures():

            currRestrictionLayerName = layer[idxRestrictionsLayerName]

            restrictionLayer = QgsProject.instance().mapLayersByName(currRestrictionLayerName)[0]

            self.setTransactionGroup.append(restrictionLayer)
            QgsMessageLog.logMessage("In TOMsTransaction.prepareLayerSet. Adding " + str(restrictionLayer.name()), tag="TOMs panel")


    def createTransactionGroup(self):

        QgsMessageLog.logMessage("In TOMsTransaction.createTransactionGroup",
                                 tag="TOMs panel")

        """if self.currTransactionGroup:
            QgsMessageLog.logMessage("In createTransactionGroup. Transaction ALREADY exists",
                                    tag="TOMs panel")
            return"""

        if self.currTransactionGroup:

            for layer in self.setTransactionGroup:
                self.currTransactionGroup.addLayer(layer)
                QgsMessageLog.logMessage("In createTransactionGroup. Adding " + str(layer.name()), tag="TOMs panel")

                layer.beforeCommitChanges.connect(functools.partial(self.printMessage, layer, "beforeCommitChanges"))
                layer.layerModified.connect(functools.partial(self.printMessage, layer, "layerModified"))
                layer.editingStopped.connect(functools.partial(self.printMessage, layer, "editingStopped"))
                layer.attributeValueChanged.connect(self.printAttribChanged)
                layer.raiseError.connect(functools.partial(self.printRaiseError, layer))

                #layer.editCommandEnded.connect(functools.partial(self.printMessage, layer, "editCommandEnded"))

                #layer.editBuffer().committedAttributeValuesChanges.connect(functools.partial(self.layerCommittedAttributeValuesChanges, layer))

            #layer.startEditing() # edit layer is now active ...
            self.modified = False
            self.errorOccurred = False

            self.transactionCompleted.connect(self.proposalsManager.updateMapCanvas)

            return

    def startTransactionGroup(self):

        QgsMessageLog.logMessage("In startTransactionGroup.", tag="TOMs panel")

        if self.currTransactionGroup.isEmpty():
            QgsMessageLog.logMessage("In startTransactionGroup. Currently empty adding layers", tag="TOMs panel")
            self.createTransactionGroup()
        """else:
            # transaction is currently open. So, close it and start another
            self.commitTransactionGroup(self.tableNames.PROPOSALS)"""

        status = self.tableNames.PROPOSALS.startEditing()  # could be any table ...
        if status == False:
            QgsMessageLog.logMessage("In startTransactionGroup. *** Error starting transaction ...", tag="TOMs panel")
        else:
            QgsMessageLog.logMessage("In startTransactionGroup. Transaction started correctly!!! ...", tag="TOMs panel")
        return status

    def layerModified(self):
        self.modified = True

    def isTransactionGroupModified(self):
        # indicates whether or not there has been any change within the transaction
        return self.modified

    def printMessage(self, layer, message):
        QgsMessageLog.logMessage("In printMessage. " + str(message) + " ... " + str(layer.name()),
                                 tag="TOMs panel")

    def printAttribChanged(self, fid, idx, v):
        QgsMessageLog.logMessage("Attributes changed for feature " + str(fid),
                                 tag="TOMs panel")

    def printRaiseError(self, layer, message):
        QgsMessageLog.logMessage("Error from " + str(layer.name()) + ": " + str(message),
                                 tag="TOMs panel")
        self.errorOccurred = True
        self.errorMessage = message

    def commitTransactionGroup(self, currRestrictionLayer):

        QgsMessageLog.logMessage("In commitTransactionGroup",
                                 tag="TOMs panel")

        # unset map tool. I don't understand why this is required, but ... without it QGIS crashes
        currMapTool = self.iface.mapCanvas().mapTool()
        #currMapTool.deactivate()
        self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())

        if not self.currTransactionGroup:
            QgsMessageLog.logMessage("In commitTransactionGroup. Transaction DOES NOT exist",
                                    tag="TOMs panel")
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

        """QgsMessageLog.logMessage("In commitTransactionGroup. Committing transaction",
                                     tag="TOMs panel")"""

        #modifiedTransaction = self.currTransactionGroup.modified()

        """if self.modified == True:
            QgsMessageLog.logMessage("In commitTransactionGroup. Transaction has been changed ...",
                                     tag="TOMs panel")
        else:
            QgsMessageLog.logMessage("In commitTransactionGroup. Transaction has NOT been changed ...",
                                     tag="TOMs panel")"""

        #self.currTransactionGroup.commitError.connect(self.errorInTransaction)

        for layer in self.setTransactionGroup:

            QgsMessageLog.logMessage("In commitTransactionGroup. Considering: " + layer.name(),
                                     tag="TOMs panel")

            commitStatus = layer.commitChanges()
            #commitStatus = True  # for testing ...

            """try:
                #layer.commitChanges()
                QTimer.singleShot(0, layer.commitChanges())
                commitStatus = True
            except:
                #commitErrors = layer.commitErrors()
                commitStatus = False

                QgsMessageLog.logMessage("In commitTransactionGroup. error: " + str(layer.commitErrors()),
                                     tag="TOMs panel")"""

            if commitStatus == False:
                reply = QMessageBox.information(None, "Error",
                                                "Changes to " + layer.name() + " failed: " + str(
                                                    layer.commitErrors()), QMessageBox.Ok)
                commitErrors = layer.rollBack()

            break

        self.modified = False
        self.errorOccurred = False

        #currMapTool.activate()
        #self.iface.mapCanvas().setMapTool(currMapTool)

        # signal for redraw ...
        self.transactionCompleted.emit()

        return commitStatus

    def layersInTransaction(self):
        return self.setTransactionGroup

    def errorInTransaction(self, errorMsg):
        reply = QMessageBox.information(None, "Error",
                                        "Proposal changes failed: " + errorMsg, QMessageBox.Ok)
        QgsMessageLog.logMessage("In errorInTransaction: " + errorMsg,
                                 tag="TOMs panel")

        #def __del__(self):
        #pass
      
    def deleteTransactionGroup(self):

        if self.currTransactionGroup:

            if self.currTransactionGroup.modified():
                QgsMessageLog.logMessage("In deleteTransactionGroup. Transaction contains edits ... NOT deleting",
                                        tag="TOMs panel")
                return

            self.currTransactionGroup.commitError.disconnect(self.errorInTransaction)
            self.currTransactionGroup = None

        pass

        return
      
    def rollBackTransactionGroup(self):

        QgsMessageLog.logMessage("In rollBackTransactionGroup",
                                 tag="TOMs panel")

        # unset map tool. I don't understand why this is required, but ... without it QGIS crashes
        self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())

        try:
            self.tableNames.PROPOSALS.rollBack()  # could be any table ...
            QgsMessageLog.logMessage("In rollBackTransactionGroup. Transaction rolled back correctly ...",
                                     tag="TOMs panel")
        except:
            QgsMessageLog.logMessage("In rollBackTransactionGroup. error: ...",
                                     tag="TOMs panel")

        #self.iface.activeLayer().stopEditing()

        self.modified = False
        self.errorOccurred = False
        self.errorMessage = None

        return

class setupTableNames(QObject):

    TOMsLayersNotFound = pyqtSignal()
    """ signal will be emitted with there is a problem with opening TOMs - typically a layer missing """

    def __init__(self, iface):
        QObject.__init__(self)
        self.iface = iface

        QgsMessageLog.logMessage("In setupTableNames.init ...", tag="TOMs panel")
        #self.proposalsManager = proposalsManager

        #RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]
        self.TOMsLayerList = ["Proposals",
                         "ProposalStatusTypes",
                         "RestrictionLayers",
                         "RestrictionsInProposals",
                         "Bays",
                         "Lines",
                         "Signs",
                         "RestrictionPolygons",
                         "ConstructionLines",
                         "MapGrid",
                         "CPZs",
                         "ParkingTariffAreas",
                         "StreetGazetteerRecords",
                         "RoadCasement",
                         "TilesInAcceptedProposals"
                         ]
        self.TOMsLayerDict = {}

    def getLayers(self):

        QgsMessageLog.logMessage("In setupTableNames.getLayers ...", tag="TOMs panel")
        found = True

        # Check for project being open
        project = QgsProject.instance()

        if len(project.fileName()) == 0:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Project not yet open"))
            found = False

        else:

            for layer in self.TOMsLayerList:
                if QgsProject.instance().mapLayersByName(layer):
                    self.TOMsLayerDict[layer] = QgsProject.instance().mapLayersByName(layer)[0]
                else:
                    QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table " + layer + " is not present"))
                    found = False
                    break

            if QgsProject.instance().mapLayersByName("Proposals"):
                self.PROPOSALS = QgsProject.instance().mapLayersByName("Proposals")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table Proposals is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("ProposalStatusTypes"):
                self.PROPOSAL_STATUS_TYPES = QgsProject.instance().mapLayersByName("ProposalStatusTypes")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table ProposalStatusTypes is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("RestrictionLayers"):
                self.RESTRICTIONLAYERS = QgsProject.instance().mapLayersByName("RestrictionLayers")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionLayers is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("RestrictionsInProposals"):
                self.RESTRICTIONS_IN_PROPOSALS = QgsProject.instance().mapLayersByName("RestrictionsInProposals")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionsInProposals is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("Bays"):
                self.BAYS = QgsProject.instance().mapLayersByName("Bays")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table Bays is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("Lines"):
                self.LINES = QgsProject.instance().mapLayersByName("Lines")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table Lines is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("Signs"):
                self.SIGNS = QgsProject.instance().mapLayersByName("Signs")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table Signs is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("RestrictionPolygons"):
                self.RESTRICTION_POLYGONS = QgsProject.instance().mapLayersByName("RestrictionPolygons")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionPolygons is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("ConstructionLines"):
                self.CONSTRUCTION_LINES = QgsProject.instance().mapLayersByName("ConstructionLines")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table ConstructionLines is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("MapGrid"):
                self.MAP_GRID = QgsProject.instance().mapLayersByName("MapGrid")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table MapGrid is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("CPZs"):
                self.CPZs = QgsProject.instance().mapLayersByName("CPZs")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table CPZs is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("ParkingTariffAreas"):
                self.PARKING_TARIFF_AREAS = QgsProject.instance().mapLayersByName("ParkingTariffAreas")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table ParkingTariffAreas is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("StreetGazetteerRecords"):
                self.GAZETTEER = QgsProject.instance().mapLayersByName("StreetGazetteerRecords")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table StreetGazetteerRecords is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("RoadCentreLine"):
                self.GAZETTEER = QgsProject.instance().mapLayersByName("RoadCentreLine")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RoadCentreLine is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("RoadCasement"):
                self.ROAD_CASEMENT = QgsProject.instance().mapLayersByName("RoadCasement")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RoadCasement is not present"))
                found = False

            if QgsProject.instance().mapLayersByName("TilesInAcceptedProposals"):
                self.TILES_IN_ACCEPTED_PROPOSALS = QgsProject.instance().mapLayersByName("TilesInAcceptedProposals")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table TilesInAcceptedProposals is not present"))
                found = False


        # TODO: need to deal with any errors arising ...

        if found == False:
            self.TOMsLayersNotFound.emit()

        return

class originalFeature(object):
    def __init__(self, feature=None):
        self.savedFeature = None

    def setFeature(self, feature):
        self.savedFeature = QgsFeature(feature)
        #self.printFeature()

    def getFeature(self):
        #self.printFeature()
        return self.savedFeature

    def getGeometryID(self):
        return self.savedFeature.attribute("GeometryID")

    def printFeature(self):
        QgsMessageLog.logMessage("In TOMsNodeTool:originalFeature - attributes (fid:" + str(self.savedFeature.id()) + "): " + str(self.savedFeature.attributes()),
                                 tag="TOMs panel")
        QgsMessageLog.logMessage("In TOMsNodeTool:originalFeature - attributes: " + str(self.savedFeature.geometry().asWkt()),
                                 tag="TOMs panel")

class RestrictionTypeUtilsMixin():
    #def __init__(self):
    def __init__(self, iface):

        #self.constants = TOMsConstants()
        #self.proposalsManager = proposalsManager
        self.iface = iface
        #self.tableNames = setupTableNames(self.iface)

        #self.tableNames.getLayers()
        #super().__init__()
        self.currTransaction = None
        #self.proposalTransaction = QgsTransaction()
        #self.proposalPanel = None

        pass

    def restrictionInProposal(self, currRestrictionID, currRestrictionLayerID, proposalID):
        # returns True if resstriction is in Proposal
        QgsMessageLog.logMessage("In restrictionInProposal.", tag="TOMs panel")

        RestrictionsInProposalsLayer = QgsProject.instance().mapLayersByName("RestrictionsInProposals")[0]

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

        RestrictionsInProposalsLayer = QgsProject.instance().mapLayersByName("RestrictionsInProposals")[0]

        #RestrictionsInProposalsLayer.startEditing()

        idxProposalID = RestrictionsInProposalsLayer.fields().indexFromName("ProposalID")
        idxRestrictionID = RestrictionsInProposalsLayer.fields().indexFromName("RestrictionID")
        idxRestrictionTableID = RestrictionsInProposalsLayer.fields().indexFromName("RestrictionTableID")
        idxActionOnProposalAcceptance = RestrictionsInProposalsLayer.fields().indexFromName(
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

        returnStatus = RestrictionsInProposalsLayer.addFeatures([newRestrictionsInProposal])

        return returnStatus

    def getRestrictionsLayer(self, currRestrictionTableRecord):
        # return the layer given the row in "RestrictionLayers"
        QgsMessageLog.logMessage("In getRestrictionLayer.", tag="TOMs panel")

        RestrictionsLayers = QgsProject.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fields().indexFromName("RestrictionLayerName")

        currRestrictionsTableName = currRestrictionTableRecord[idxRestrictionsLayerName]

        RestrictionLayer = QgsProject.instance().mapLayersByName(currRestrictionsTableName)[0]

        return RestrictionLayer

    def getRestrictionsLayerFromID(self, currRestrictionTableID):
        # return the layer given the row in "RestrictionLayers"
        QgsMessageLog.logMessage("In getRestrictionsLayerFromID.", tag="TOMs panel")

        RestrictionsLayers = QgsProject.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fields().indexFromName("RestrictionLayerName")
        idxRestrictionsLayerID = RestrictionsLayers.fields().indexFromName("id")

        for layer in RestrictionsLayers.getFeatures():
            if layer[idxRestrictionsLayerID] == currRestrictionTableID:
                currRestrictionLayerName = layer[idxRestrictionsLayerName]

        restrictionLayer = QgsProject.instance().mapLayersByName(currRestrictionLayerName)[0]

        return restrictionLayer

    def getRestrictionLayerTableID(self, currRestLayer):
        QgsMessageLog.logMessage("In getRestrictionLayerTableID.", tag="TOMs panel")
        # find the ID for the layer within the table "

        RestrictionsLayers = QgsProject.instance().mapLayersByName("RestrictionLayers")[0]

        layersTableID = 0

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for layer in RestrictionsLayers.getFeatures():
            if layer.attribute("RestrictionLayerName") == str(currRestLayer.name()):
                layersTableID = layer.attribute("id")

        QgsMessageLog.logMessage("In getRestrictionLayerTableID. layersTableID: " + str(layersTableID),
                                 tag="TOMs panel")

        return layersTableID

    def getRestrictionBasedOnRestrictionID(self, currRestrictionID, currRestrictionLayer):
        # return the layer given the row in "RestrictionLayers"
        QgsMessageLog.logMessage("In getRestriction.", tag="TOMs panel")

        #query2 = '"RestrictionID" = \'{restrictionid}\''.format(restrictionid=currRestrictionID)

        queryString = "\"RestrictionID\" = \'" + currRestrictionID + "\'"

        QgsMessageLog.logMessage("In getRestriction: queryString: " + str(queryString), tag="TOMs panel")

        expr = QgsExpression(queryString)

        for feature in currRestrictionLayer.getFeatures(QgsFeatureRequest(expr)):
            return feature

        QgsMessageLog.logMessage("In getRestriction: Restriction not found", tag="TOMs panel")
        return None


    def deleteRestrictionInProposal(self, currRestrictionID, currRestrictionLayerID, proposalID):
        QgsMessageLog.logMessage("In deleteRestrictionInProposal: " + str(currRestrictionID), tag="TOMs panel")

        returnStatus = False

        RestrictionsInProposalsLayer = QgsProject.instance().mapLayersByName("RestrictionsInProposals")[0]

        #RestrictionsInProposalsLayer.startEditing()

        for restrictionInProposal in RestrictionsInProposalsLayer.getFeatures():
            if restrictionInProposal.attribute("RestrictionID") == currRestrictionID:
                if restrictionInProposal.attribute("RestrictionTableID") == currRestrictionLayerID:
                    if restrictionInProposal.attribute("ProposalID") == proposalID:
                        QgsMessageLog.logMessage("In deleteRestrictionInProposal - deleting ",
                                                 tag="TOMs panel")

                        attrs = restrictionInProposal.attributes()

                        #QMessageBox.information(None, "Information", ("deleteRestrictionInProposal" + str(attrs)))

                        returnStatus = RestrictionsInProposalsLayer.deleteFeature(restrictionInProposal.id())
                        #returnStatus = True
                        return returnStatus

        return returnStatus

    def onSaveRestrictionDetails(self, currRestriction, currRestrictionLayer, dialog, restrictionTransaction):
        QgsMessageLog.logMessage("In onSaveRestrictionDetails: " + str(currRestriction.attribute("GeometryID")), tag="TOMs panel")

        #currRestrictionLayer.startEditing()

        currProposalID = int(QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('CurrentProposal'))

        if currProposalID > 0:

            currRestrictionLayerTableID = self.getRestrictionLayerTableID(currRestrictionLayer)
            idxRestrictionID = currRestriction.fields().indexFromName("RestrictionID")
            idxGeometryID = currRestriction.fields().indexFromName("GeometryID")

            if self.restrictionInProposal(currRestriction[idxRestrictionID], currRestrictionLayerTableID, currProposalID):

                # restriction already is part of the current proposal
                # simply make changes to the current restriction in the current layer
                QgsMessageLog.logMessage("In onSaveRestrictionDetails. Saving details straight from form." + str(currRestriction.attribute("GeometryID")),
                                         tag="TOMs panel")

                #res = dialog.save()
                status = currRestrictionLayer.updateFeature(currRestriction)
                status = dialog.attributeForm().save()

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

                idxOpenDate = currRestriction.fields().indexFromName("OpenDate")
                newRestrictionID = str(uuid.uuid4())

                QgsMessageLog.logMessage(
                    "In onSaveRestrictionDetails. Adding new restriction (1). ID: " + str(
                        newRestrictionID),
                    tag="TOMs panel")

                if currRestriction[idxRestrictionID] is None:
                    # This is a feature that has just been created.

                    # Not quite sure what is happening here but think the following:
                    #  Feature does not yet exist, i.e., not saved to layer yet, so there is no id for it and can't use either feature or layer to save
                    #  So, need to continue to modify dialog value which will be eventually saved

                    dialog.attributeForm().changeAttribute("RestrictionID", newRestrictionID)

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Adding new restriction. ID: " + str(currRestriction[idxRestrictionID]),
                        tag="TOMs panel")

                    status = self.addRestrictionToProposal(str(currRestriction[idxRestrictionID]), currRestrictionLayerTableID,
                                             currProposalID, ACTION_OPEN_RESTRICTION())  # Open = 1

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Transaction Status 1: " + str(
                            restrictionTransaction.currTransactionGroup.modified()),
                        tag="TOMs panel")

                    """ attributeForm saves to the layer. Has the feature been added to the layer?"""

                    status = dialog.attributeForm().save()  # this issues a commit on the transaction?
                    #dialog.accept()
                    #QgsMessageLog.logMessage("Form accepted", tag="TOMs panel")
                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Transaction Status 2: " + str(
                            restrictionTransaction.currTransactionGroup.modified()),
                        tag="TOMs panel")
                    currRestrictionLayer.addFeature(currRestriction)  # TH (added for v3)

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

                    status = self.addRestrictionToProposal(currRestriction[idxRestrictionID], currRestrictionLayerTableID,
                                             currProposalID, ACTION_CLOSE_RESTRICTION())  # Open = 1; Close = 2

                    newRestriction = QgsFeature(currRestriction)

                    # TODO: Rethink logic here and need to unwind changes ... without triggering rollBack ?? maybe attributeForm.setFeature()
                    #dialog.reject()

                    newRestriction[idxRestrictionID] = newRestrictionID
                    newRestriction[idxOpenDate] = None
                    newRestriction[idxGeometryID] = None

                    currRestrictionLayer.addFeature(newRestriction)

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Clone restriction. New ID: " + str(newRestriction[idxRestrictionID]),
                        tag="TOMs panel")

                    attrs2 = newRestriction.attributes()
                    QgsMessageLog.logMessage("In onSaveRestrictionDetails: clone Restriction: " + str(attrs2),
                        tag="TOMs panel")
                    QgsMessageLog.logMessage("In onSaveRestrictionDetails. Clone: {}".format(newRestriction.geometry().asWkt()),
                                             tag="TOMs panel")

                    status = self.addRestrictionToProposal(newRestriction[idxRestrictionID], currRestrictionLayerTableID,
                                             currProposalID, ACTION_OPEN_RESTRICTION())  # Open = 1; Close = 2

                    QgsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Opening clone. ID: " + str(
                            newRestriction[idxRestrictionID]),
                        tag="TOMs panel")

                    dialog.attributeForm().close()
                    currRestriction = self.origFeature.getFeature()
                    currRestrictionLayer.updateFeature(currRestriction)

                pass

            # Now commit changes and redraw

            attrs1 = currRestriction.attributes()
            QgsMessageLog.logMessage("In onSaveRestrictionDetails: currRestriction: " + str(attrs1),
                                     tag="TOMs panel")
            QgsMessageLog.logMessage(
                "In onSaveRestrictionDetails. curr: {}".format(currRestriction.geometry().asWkt()),
                tag="TOMs panel")

            # Make sure that the saving will not be executed immediately, but
            # only when the event loop runs into the next iteration to avoid
            # problems

            QgsMessageLog.logMessage(
                "In onSaveRestrictionDetails. Transaction Status 3: " + str(
                    restrictionTransaction.currTransactionGroup.modified()),
                tag="TOMs panel")

            commitStatus = restrictionTransaction.commitTransactionGroup(currRestrictionLayer)
            #restrictionTransaction.deleteTransactionGroup()
            QgsMessageLog.logMessage(
                "In onSaveRestrictionDetails. Transaction Status 4: " + str(
                    restrictionTransaction.currTransactionGroup.modified()),
                tag="TOMs panel")
            # Trying to unset map tool to force updates ...
            #self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())
            #dialog.accept()
            """QgsMessageLog.logMessage(
                "In onSaveRestrictionDetails. Transaction Status 5: " + str(
                    restrictionTransaction.currTransactionGroup.modified()) + " commitStatus " + str(commitStatus),
                tag="TOMs panel")"""
            #status = dialog.attributeForm().close()
            #dialog.accept()
            #QTimer.singleShot(0, functools.partial(RestrictionTypeUtils.commitRestrictionChanges, currRestrictionLayer))

            status = dialog.reject()

        else:   # currProposal = 0, i.e., no change allowed

            """reply = QMessageBox.information(None, "Information",
                                            "Changes to current data are not allowed. Changes are made via Proposals",
                                            QMessageBox.Ok)"""
            status = dialog.reject()

        pass

        # ************* refresh the view. Might be able to set up a signal to get the proposals_panel to intervene

        QgsMessageLog.logMessage(
        "In onSaveRestrictionDetails. Finished",
        tag="TOMs panel")

        status = dialog.close()
        currRestrictionLayer.removeSelection()

        # reinstate Proposals Panel (if it needs it)
        #if not self.proposalPanel:
        self.proposalPanel = self.iface.mainWindow().findChild(QDockWidget, 'ProposalPanelDockWidgetBase')

        self.setupPanelTabs(self.iface, self.proposalPanel)
        #self.setupPanelTabs(self.iface, self.dock)

    def setDefaultRestrictionDetails(self, currRestriction, currRestrictionLayer, currDate):
        QgsMessageLog.logMessage("In setDefaultRestrictionDetails: ", tag="TOMs panel")

        generateGeometryUtils.setRoadName(currRestriction)
        if currRestrictionLayer.geometryType() == 1:  # Line or Bay
            generateGeometryUtils.setAzimuthToRoadCentreLine(currRestriction)
            currRestriction.setAttribute("Length", currRestriction.geometry().length())

        currentCPZ, cpzWaitingTimeID = generateGeometryUtils.getCurrentCPZDetails(currRestriction)

        currRestriction.setAttribute("CPZ", currentCPZ)

        #currDate = self.proposalsManager.date()

        if currRestrictionLayer.name() == "Lines":
            currRestriction.setAttribute("RestrictionTypeID", 10)  # 10 = SYL (Lines)
            currRestriction.setAttribute("GeomShapeID", 10)   # 10 = Parallel Line

            currRestriction.setAttribute("NoWaitingTimeID", cpzWaitingTimeID)
            currRestriction.setAttribute("Lines_DateTime", currDate)

        elif currRestrictionLayer.name() == "Bays":
            currRestriction.setAttribute("RestrictionTypeID", 28)  # 28 = Permit Holders Bays (Bays)
            currRestriction.setAttribute("GeomShapeID", 21)   # 21 = Parallel Bay (Polygon)
            currRestriction.setAttribute("NrBays", -1)

            currRestriction.setAttribute("TimePeriodID", cpzWaitingTimeID)

            currentPTA, ptaMaxStayID, ptaNoReturnTimeID = generateGeometryUtils.getCurrentPTADetails(currRestriction)

            currRestriction.setAttribute("MaxStayID", ptaMaxStayID)
            currRestriction.setAttribute("NoReturnID", ptaNoReturnTimeID)
            currRestriction.setAttribute("ParkingTariffArea", currentPTA)

            currRestriction.setAttribute("Bays_DateTime", currDate)

        elif currRestrictionLayer.name() == "Signs":
            currRestriction.setAttribute("SignType_1", 28)  # 28 = Permit Holders Only (Signs)

        elif currRestrictionLayer.name() == "RestrictionPolygons":
            currRestriction.setAttribute("RestrictionTypeID", 4)  # 28 = Residential mews area (RestrictionPolygons)

        pass

    def updateDefaultRestrictionDetails(self, currRestriction, currRestrictionLayer, currDate):
        QgsMessageLog.logMessage("In updateDefaultRestrictionDetails. currLayer: " + currRestrictionLayer.name(), tag="TOMs panel")

        generateGeometryUtils.setRoadName(currRestriction)
        if currRestrictionLayer.geometryType() == 1:  # Line or Bay
            generateGeometryUtils.setAzimuthToRoadCentreLine(currRestriction)
            currRestriction.setAttribute("Length", currRestriction.geometry().length())
            currRestrictionLayer.changeAttributeValue(currRestriction.id(),
                                                      currRestrictionLayer.fields().indexFromName("Length"), currRestriction.geometry().length())

        currentCPZ, cpzWaitingTimeID = generateGeometryUtils.getCurrentCPZDetails(currRestriction)

        currRestrictionLayer.changeAttributeValue(currRestriction.id(),
                                                  currRestrictionLayer.fields().indexFromName("CPZ"), currentCPZ)

        # Now need to clear some details

        #currDate = self.proposalsManager.date()

        if currRestrictionLayer.name() == "Lines":

            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Lines_DateTime"), currDate)
            currRestriction.setAttribute("Lines_DateTime", currDate)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Surveyor"), None)
            currRestriction.setAttribute("Surveyor", None)

            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Lines_PhotoTaken"), None)

            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Compl_Lines_Faded"), None)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Compl_Lines_SignIssue"), None)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Lines_Photos_01"), None)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Lines_Photos_02"), None)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Lines_Photos_03"), None)

        elif currRestrictionLayer.name() == "Bays":

            currentPTA, ptaMaxStayID, ptaNoReturnTimeID = generateGeometryUtils.getCurrentPTADetails(currRestriction)

            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("ParkingTariffArea"), currentPTA)

            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Bays_DateTime"), currDate)
            currRestriction.setAttribute("Bays_DateTime", currDate)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Surveyor"), None)
            currRestriction.setAttribute("Surveyor", None)

            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Bays_PhotoTaken"), None)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Compl_Bays_Faded"), None)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Compl_Bays_SignIssue"), None)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Bays_Photos_01"), None)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Bays_Photos_02"), None)

        pass

    def updateRestriction(self, currRestrictionLayer, currRestrictionID, currAction, currProposalOpenDate):
        # update the Open/Close date for the restriction
        QgsMessageLog.logMessage("In updateRestriction. layer: " + str(
            currRestrictionLayer.name()) + " currRestId: " + currRestrictionID + " Opendate: " + str(
            currProposalOpenDate), tag="TOMs panel")

        # idxOpenDate = currRestrictionLayer.fields().indexFromName("OpenDate2")
        # idxCloseDate = currRestrictionLayer.fields().indexFromName("CloseDate2")

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
                                                              currRestrictionLayer.fields().indexFromName("OpenDate"),
                                                              currProposalOpenDate)
                    QgsMessageLog.logMessage(
                        "In updateRestriction. " + currRestrictionID + " Opened", tag="TOMs panel")
                else:  # Close
                    statusUpd = currRestrictionLayer.changeAttributeValue(currRestriction.id(),
                                                              currRestrictionLayer.fields().indexFromName("CloseDate"),
                                                              currProposalOpenDate)
                    QgsMessageLog.logMessage(
                        "In updateRestriction. " + currRestrictionID + " Closed", tag="TOMs panel")

                return statusUpd

        pass

    def setupRestrictionDialog(self, restrictionDialog, currRestrictionLayer, currRestriction, restrictionTransaction):

        #self.restrictionDialog = restrictionDialog
        #self.currRestrictionLayer = currRestrictionLayer
        #self.currRestriction = currRestriction
        #self.restrictionTransaction = restrictionTransaction

        # Create a copy of the feature
        self.origFeature = originalFeature()
        self.origFeature.setFeature(currRestriction)

        if restrictionDialog is None:
            QgsMessageLog.logMessage(
                "In setupRestrictionDialog. dialog not found",
                tag="TOMs panel")

        #restrictionDialog.attributeForm().disconnectButtonBox()
        button_box = restrictionDialog.findChild(QDialogButtonBox, "button_box")
        # button_box = restrictionDialog.buttonBox()

        if button_box is None:
            QgsMessageLog.logMessage(
                "In setupRestrictionDialog. button box not found",
                tag="TOMs panel")

        #button_box.accepted.disconnect(restrictionDialog.accept)
        #button_box.accepted.disconnect()
        button_box.accepted.connect(functools.partial(self.onSaveRestrictionDetails, currRestriction,
                                      currRestrictionLayer, restrictionDialog, restrictionTransaction))

        restrictionDialog.attributeForm().attributeChanged.connect(functools.partial(self.onAttributeChangedClass2, currRestriction, currRestrictionLayer))

        #button_box.rejected.disconnect(restrictionDialog.reject)
        #button_box.rejected.disconnect()
        button_box.rejected.connect(functools.partial(self.onRejectRestrictionDetailsFromForm, restrictionDialog, restrictionTransaction))

        self.photoDetails(restrictionDialog, currRestrictionLayer, currRestriction)

        """def onSaveRestrictionDetailsFromForm(self):
        QgsMessageLog.logMessage("In onSaveRestrictionDetailsFromForm", tag="TOMs panel")
        self.onSaveRestrictionDetails(self.currRestriction,
                                      self.currRestrictionLayer, self.restrictionDialog, self.restrictionTransaction)"""

    def onRejectRestrictionDetailsFromForm(self, restrictionDialog, restrictionTransaction):
        QgsMessageLog.logMessage("In onRejectRestrictionDetailsFromForm", tag="TOMs panel")
        #self.currRestrictionLayer.destroyEditCommand()
        restrictionDialog.reject()

        #self.rollbackCurrentEdits()
        
        restrictionTransaction.rollBackTransactionGroup()
        
        # reinstate Proposals Panel (if it needs it)

        #if not self.proposalPanel:
        self.proposalPanel = self.iface.mainWindow().findChild(QDockWidget, 'ProposalPanelDockWidgetBase')

        self.setupPanelTabs(self.iface, self.proposalPanel)

    def onAttributeChangedClass2(self, currFeature, layer, fieldName, value):
        QgsMessageLog.logMessage(
            "In FormOpen:onAttributeChangedClass 2 - layer: " + str(layer.name()) + " (" + fieldName + "): " + str(value), tag="TOMs panel")

        # self.currRestriction.setAttribute(fieldName, value)
        try:

            currFeature[layer.fields().indexFromName(fieldName)] = value
            #currFeature.setAttribute(layer.fields().indexFromName(fieldName), value)

        except:

            reply = QMessageBox.information(None, "Error",
                                                "onAttributeChangedClass2. Update failed for: " + str(layer.name()) + " (" + fieldName + "): " + str(value),
                                                QMessageBox.Ok)  # rollback all changes
        return

    def photoDetails(self, dialog, currRestLayer, currRestrictionFeature):

        # Function to deal with photo fields

        QgsMessageLog.logMessage("In photoDetails", tag="TOMs panel")

        FIELD1 = dialog.findChild(QLabel, "Photo_Widget_01")
        FIELD2 = dialog.findChild(QLabel, "Photo_Widget_02")
        FIELD3 = dialog.findChild(QLabel, "Photo_Widget_03")

        path_absolute = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('PhotoPath')
        if path_absolute == None:
            reply = QMessageBox.information(None, "Information", "Please set value for PhotoPath.", QMessageBox.Ok)
            return

        layerName = currRestLayer.name()

        # Generate the full path to the file

        fileName1 = layerName + "_Photos_01"
        fileName2 = layerName + "_Photos_02"
        fileName3 = layerName + "_Photos_03"

        idx1 = currRestLayer.fields().indexFromName(fileName1)
        idx2 = currRestLayer.fields().indexFromName(fileName2)
        idx3 = currRestLayer.fields().indexFromName(fileName3)

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

    def onSaveProposalFormDetails(self, currProposal, proposalsLayer, proposalsDialog, proposalTransaction):
        QgsMessageLog.logMessage("In onSaveProposalFormDetails.", tag="TOMs panel")

        # proposalsLayer.startEditing()

        """def onSaveProposalDetails(self):
        QgsMessageLog.logMessage("In onSaveProposalFormDetails.", tag="TOMs panel")
        self.Proposals.startEditing()
        """

        #proposalsLayerfromClass = TOMsTableNames.PROPOSALS()
        #QgsMessageLog.logMessage("In onSaveProposalFormDetails. Proposals (class):" + str(proposalsLayerfromClass.name()), tag="TOMs panel")

        #self.Proposals = self.proposalsManager.tableNames.TOMsLayerDict.get("Proposals")
        self.Proposals = proposalsLayer

        # set up field indexes
        idxProposalID = self.Proposals.fields().indexFromName("ProposalID")
        idxProposalTitle = self.Proposals.fields().indexFromName("ProposalTitle")
        idxProposalStatusID = self.Proposals.fields().indexFromName("ProposalStatusID")
        idxProposalNotes = self.Proposals.fields().indexFromName("ProposalNotes")
        idxProposalCreateDate = self.Proposals.fields().indexFromName("ProposalCreateDate")
        idxProposalOpenDate = self.Proposals.fields().indexFromName("ProposalOpenDate")

        QgsMessageLog.logMessage("In onSaveProposalFormDetails. currProposalStatus = " + str(currProposal[idxProposalStatusID]), tag="TOMs panel")

        #updateStatus = False
        newProposal = False
        proposalAcceptedRejected = False

        if currProposal[idxProposalStatusID] == PROPOSAL_STATUS_ACCEPTED():  # 2 = accepted

            reply = QMessageBox.question(None, 'Confirm changes to Proposal',
                                         # How do you access the main window to make the popup ???
                                         'Are you you want to ACCEPT this proposal?. Accepting will make all the proposed changes permanent.',
                                         QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:
                # open the proposal - and accept any other changes to the form

                # currProposalID = currProposal[idxProposalID]

                # TODO: Need to check that this is an authorised user

                # Now close dialog
                #updateStatus = proposalsDialog.accept()

                #updateStatus = True

                #if updateStatus == True:
                currProposalID = currProposal[idxProposalID]
                currOpenDate = currProposal[idxProposalOpenDate]
                updateStatus = self.acceptProposal(currProposalID, currOpenDate)

                QgsMessageLog.logMessage(
                    "In onSaveProposalFormDetails. updateStatus = " + str(updateStatus), tag="TOMs panel")

                if updateStatus == True:
                    status = self.Proposals.updateFeature(currProposal)
                    updateStatus = proposalsDialog.attributeForm().save()
                    proposalAcceptedRejected = True

                else:
                    proposalsDialog.reject()

            else:
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

                updateStatus = self.Proposals.updateFeature(currProposal)
                updateStatus = True

                if updateStatus == True:
                    updateStatus = proposalsDialog.attributeForm().save()
                    proposalAcceptedRejected = True

                else:
                    proposalsDialog.reject()

            else:
                # proposalsDialog.reject ((currProposal[idxProposalID]))
                proposalsDialog.reject()

        else:

            QgsMessageLog.logMessage(
                "In onSaveProposalFormDetails. currProposalID = " + str(currProposal[idxProposalID]),
                tag="TOMs panel")

            updateStatus = proposalsDialog.attributeForm().save()
            self.Proposals.updateFeature(currProposal)  # TH (added for v3)

            # anything else can be saved.
            if currProposal[idxProposalID] == None:

                # This is a new proposal ...

                newProposal = True

                # add geometry
                #currProposal.setGeometry(QgsGeometry())

            else:

                self.Proposals.updateFeature(currProposal)  # TH (added for v3)

            """updateStatus = proposalsLayer.updateFeature(currProposal)

            QgsMessageLog.logMessage(
                "In onSaveProposalFormDetails. updateStatus = " + str(updateStatus),
                tag="TOMs panel")
            updateStatus = True"""

            #proposalsDialog.accept()
            proposalsDialog.reject()

            #saveStatus = proposalsDialog.attributeForm().save()
            QgsMessageLog.logMessage("In onSaveProposalFormDetails. saveStatus. " + str(currProposal.attributes()), tag="TOMs panel")

            QgsMessageLog.logMessage(
                "In onSaveProposalFormDetails. ProposalTransaction modified Status: " + str(
                    proposalTransaction.currTransactionGroup.modified()),
            tag="TOMs panel")
        QgsMessageLog.logMessage("In onSaveProposalFormDetails. Before save. " + str(currProposal.attribute("ProposalTitle")) + " Status: " + str(currProposal.attribute("ProposalStatusID")), tag="TOMs panel")


        # Make sure that the saving will not be executed immediately, but
        # only when the event loop runs into the next iteration to avoid
        # problems

        # Trying to unset map tool to force updates ...
        self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())

        #self.commitProposalChanges()
        proposalTransaction.commitTransactionGroup(self.Proposals)
        #proposalTransaction.commitTransactionGroup(None)
        #proposalTransaction.deleteTransactionGroup()
        status = proposalsDialog.close()

        #self.rollbackCurrentEdits()

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

        elif proposalAcceptedRejected:
            # refresh the cbProposals and set current Proposal to 0
            self.createProposalcb()
            self.proposalsManager.setCurrentProposal(0)

        else:

            self.proposalsManager.newProposalCreated.emit(currProposal[idxProposalID])


    def acceptProposal(self, currProposalID, currProposalOpenDate):
        QgsMessageLog.logMessage("In acceptProposal.", tag="TOMs panel")

        # Now loop through all the items in restrictionsInProposals for this proposal and take appropriate action

        RestrictionsInProposalsLayer = QgsProject.instance().mapLayersByName("RestrictionsInProposals")[0]
        idxProposalID = RestrictionsInProposalsLayer.fields().indexFromName("ProposalID")
        idxRestrictionTableID = RestrictionsInProposalsLayer.fields().indexFromName("RestrictionTableID")
        idxRestrictionID = RestrictionsInProposalsLayer.fields().indexFromName("RestrictionID")
        idxActionOnProposalAcceptance = RestrictionsInProposalsLayer.fields().indexFromName("ActionOnProposalAcceptance")

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

                if statusUpd == False:
                    reply = QMessageBox.information(None, "Error",
                                                    "Changes to " + currRestrictionLayer.name() + " failed: " + str(
                                                        currRestrictionLayer.commitErrors()), QMessageBox.Ok)
                    return statusUpd


        self.updateTileRevisionNrs(currProposalID)

        return statusUpd

    def updateTileRevisionNrs(self, currProposalID):
        QgsMessageLog.logMessage("In updateTileRevisionNrs.", tag="TOMs panel")
        # Increment the relevant tile numbers

        currRevisionDate = self.proposalsManager.getProposalOpenDate(currProposalID)

        self.getProposalTileList(currProposalID, currRevisionDate)

        for tile in self.tileSet:
            currRevisionNr = tile["RevisionNr"]
            QgsMessageLog.logMessage("In updateTileRevisionNrs. tile" + str (tile["id"]) + " currRevNr: " + str(currRevisionNr), tag="TOMs panel")
            if currRevisionNr is None:
                self.tableNames.MAP_GRID.changeAttributeValue(tile.id(),self.tableNames.MAP_GRID.fields().indexFromName("RevisionNr"), 1)
            else:
                self.tableNames.MAP_GRID.changeAttributeValue(tile.id(), self.tableNames.MAP_GRID.fields().indexFromName("RevisionNr"), currRevisionNr + 1)
            self.tableNames.MAP_GRID.changeAttributeValue(tile.id(), self.tableNames.MAP_GRID.fields().indexFromName("LastRevisionDate"), currRevisionDate)

            # Now need to add the details of this tile to "TilesWithinAcceptedProposals" (including revision numbers at time of acceptance)

            newRecord = QgsFeature(self.tableNames.TILES_IN_ACCEPTED_PROPOSALS.fields())

            idxProposalID = self.tableNames.TILES_IN_ACCEPTED_PROPOSALS.fields().indexFromName("ProposalID")
            idxTileNr = self.tableNames.TILES_IN_ACCEPTED_PROPOSALS.fields().indexFromName("TileNr")
            idxRevisionNr = self.tableNames.TILES_IN_ACCEPTED_PROPOSALS.fields().indexFromName("RevisionNr")

            newRecord[idxProposalID]= currProposalID
            newRecord[idxTileNr]= tile["id"]
            newRecord[idxRevisionNr]= currRevisionNr + 1
            newRecord.setGeometry(QgsGeometry())

            status = self.tableNames.TILES_IN_ACCEPTED_PROPOSALS.addFeature(newRecord)

            # TODO: Check return status from add

    def getProposalTileList(self, listProposalID, currRevisionDate):

        # returns list of tiles in the proposal and their current revision numbers
        QgsMessageLog.logMessage("In getProposalTileList. consider Proposal: " + str (listProposalID), tag="TOMs panel")
        self.tileSet = set()

        # Logic is:
        #Loop through each map tile
        #    Check whether or not there are any currently open restrictions within it

        if QgsProject.instance().mapLayersByName("RestrictionsInProposals"):
            self.RestrictionsInProposals = \
                QgsProject.instance().mapLayersByName("RestrictionsInProposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                    ("Table RestrictionsInProposals is not present"))
            # raise LayerNotPresent

        if QgsProject.instance().mapLayersByName("RestrictionLayers"):
            self.RestrictionLayers = QgsProject.instance().mapLayersByName("RestrictionLayers")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionLayers is not present"))
            return

        if QgsProject.instance().mapLayersByName("MapGrid"):
            self.tileLayer = QgsProject.instance().mapLayersByName("MapGrid")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table MapGrid is not present"))
            return

        currProposalID = self.proposalsManager.currentProposal()

        if listProposalID > 0:  # need to consider a proposal

           # loop through all the layers that might have restrictions

            listRestrictionLayers = self.RestrictionLayers.getFeatures()
            # listRestrictionLayers2 = self.tableNames.RESTRICTIONLAYERS.getFeatures()

            firstRestriction = True

            self.proposalsManager.clearRestrictionFilters()

            for currLayerDetails in listRestrictionLayers:

                # get the layer from the name

                currLayerID = currLayerDetails["id"]
                currLayerName = currLayerDetails["RestrictionLayerName"]
                QgsMessageLog.logMessage(
                    "In getProposalTileList. Considering layer: " + currLayerDetails["RestrictionLayerName"],
                    tag="TOMs panel")

                if QgsProject.instance().mapLayersByName(currLayerName):
                    currRestrictionLayer = QgsProject.instance().mapLayersByName(currLayerName)[0]
                else:
                    QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                            ("Table " + currLayerName + " is not present"))
                    return

                # restrictionListForLayer = []
                restrictionsString = ''
                # firstRestriction = True

                # get list of restrictions to open within proposal
                # TODO: Include selection of only proposal and for the current restriction type

                listRestrictionsInProposals = self.RestrictionsInProposals.getFeatures()

                for row in listRestrictionsInProposals:

                    proposalID = row["ProposalID"]
                    restrictionTableID = row["RestrictionTableID"]

                    # check to see if the current row is for the current proposal and for the correct proposedAction

                    if proposalID == listProposalID:
                        if restrictionTableID == currLayerID:

                            currRestrictionID = str(row["RestrictionID"])

                            if not firstRestriction:
                                # restrictionsString = restrictionsString + ", '" + row["RestrictionID"] + "'"
                                """QgsMessageLog.logMessage(
                                    "In getProposalTileList. A restrictionsString: " + restrictionsString,
                                    tag="TOMs panel")"""
                                currRestriction = self.getRestrictionBasedOnRestrictionID(currRestrictionID,
                                                                                          currRestrictionLayer)
                                if currRestriction:
                                    # Now find the tile for the restriction
                                    self.getTilesForRestriction(currRestriction, currRevisionDate)

                                    # geometryBoundingBox.combineExtentWith(currRestriction.geometry().boundingBox())

                            else:

                                # restrictionsString = "'" + str(row["RestrictionID"]) + "'"

                                currRestriction = self.getRestrictionBasedOnRestrictionID(currRestrictionID,
                                                                                          currRestrictionLayer)
                                if currRestriction:
                                    # Now find the tile for the restriction
                                    # geometryBoundingBox = currRestriction.geometry().boundingBox()
                                    self.getTilesForRestriction(currRestriction, currRevisionDate)

                                    firstRestriction = False

                            pass

                pass

            self.proposalsManager.setCurrentProposal(currProposalID)

        else:

            # Deal with proposal 0, i.e., print of all current restrictions (for the current display date)

            #tileList = self.tableNames.MapGrid().getFeatures
            # Setup a request
            queryString = "\"RevisionNr\" IS NOT NULL "

            QgsMessageLog.logMessage("In getTileRevisionNr: queryString: " + str(queryString), tag="TOMs panel")

            expr = QgsExpression(queryString)

            for tile in self.tileLayer.getFeatures(QgsFeatureRequest(expr)):

                QgsMessageLog.logMessage("In getProposalTileList (after fetch): " + str(tile["id"]) + " RevisionNr: " + str(
                    tile["RevisionNr"]) + " RevisionDate: " + str(tile["LastRevisionDate"]), tag="TOMs panel")

                currRevisionNr = tile["RevisionNr"]
                currLastRevisionDate = tile["LastRevisionDate"]

                currTileNr = tile.attribute("id")

                revisionNr, revisionDate = self.getTileRevisionNrAtDate(currTileNr, currRevisionDate)

                QgsMessageLog.logMessage(
                    "In getProposalTileList (after getTileRevisionNrAtDate): " + str(tile["id"]) + " RevisionNr: " + str(
                        revisionNr) + " RevisionDate: " + str(revisionDate), tag="TOMs panel")

                if revisionNr >= 0:
                    if revisionNr != tile.attribute("RevisionNr"):
                        tile.setAttribute("RevisionNr", revisionNr)
                    if revisionDate != tile.attribute("LastRevisionDate"):
                        tile.setAttribute("LastRevisionDate", revisionDate)

                    QgsMessageLog.logMessage("In getProposalTileList (before write): " + str(tile["id"]) + " RevisionNr: " + str(
                            tile["RevisionNr"]) + " RevisionDate: " + str(tile["LastRevisionDate"]), tag="TOMs panel")

                self.tileSet.add((tile))

        QgsMessageLog.logMessage("In getProposalTileList: finished adding ... ", tag="TOMs panel")

        for tile in self.tileSet:
            QgsMessageLog.logMessage("In getProposalTileList: " + str(tile["id"]) + " RevisionNr: " + str(tile["RevisionNr"]) + " RevisionDate: " + str(tile["LastRevisionDate"]), tag="TOMs panel")

        #sorted(list(set(output)))
        #return self.tileList

    def getProposalTitle(self, proposalID):
        # return the layer given the row in "RestrictionLayers"
        QgsMessageLog.logMessage("In getProposalTitle.", tag="TOMs panel")

        #query2 = '"RestrictionID" = \'{restrictionid}\''.format(restrictionid=currRestrictionID)
        idxProposalTitle = self.Proposals.fields().indexFromName("ProposalTitle")
        idxProposalOpenDate = self.Proposals.fields().indexFromName("ProposalOpenDate")
        queryString = "\"ProposalID\" = " + str(proposalID)

        QgsMessageLog.logMessage("In getRestriction: queryString: " + str(queryString), tag="TOMs panel")

        expr = QgsExpression(queryString)

        for feature in self.Proposals.getFeatures(QgsFeatureRequest(expr)):
            return feature[idxProposalTitle], feature[idxProposalOpenDate]

        QgsMessageLog.logMessage("In getProposalTitle: Proposal not found", tag="TOMs panel")
        return None, None

    def getTilesForRestriction(self, currRestriction, filterDate):

        # get the tile(s) for a given restriction

        QgsMessageLog.logMessage("In getTileForRestriction. ", tag="TOMs panel")

        #a.geometry().intersects(f.geometry()):

        #queryString2 = # bounding box of restriction
        idxTileID = self.tableNames.MAP_GRID.fields().indexFromName("id")

        for tile in self.tileLayer.getFeatures(QgsFeatureRequest().setFilterRect(currRestriction.geometry().boundingBox())):

            if tile.geometry().intersects(currRestriction.geometry()):
                # get revision number and add tile to list
                #currRevisionNrForTile = self.getTileRevisionNr(tile)
                QgsMessageLog.logMessage("In getTileForRestriction. Tile: " + str(tile.attribute("id")) + "; " + str(tile.attribute("RevisionNr")) + "; " + str(tile.attribute("LastRevisionDate")), tag="TOMs panel")

                # check revision nr, etc
                currTileNr = tile.attribute("id")
                revisionNr, revisionDate = self.getTileRevisionNrAtDate(currTileNr, filterDate)

                if revisionNr:

                    if revisionNr != tile.attribute("RevisionNr"):
                        tile.setAttribute("RevisionNr", revisionNr)
                    if revisionDate != tile.attribute("LastRevisionDate"):
                        tile.setAttribute("LastRevisionDate", revisionDate)

                        """QgsMessageLog.logMessage(
                            "In getTileForRestriction. revised details: " + str(revisionNr) + "; " + str(revisionDate),
                            tag="TOMs panel")"""

                else:

                    # if there is no RevisionNr for the tile, set it to 0. This should only be the case for proposals.

                    tile.setAttribute("RevisionNr", 0)

                #idxRevisionNr = self.tableNames.TILES_IN_ACCEPTED_PROPOSALS.fields().indexFromName("RevisionNr")

                QgsMessageLog.logMessage(
                            "In getTileForRestriction: Tile: " + str(tile.attribute("id")) + "; " + str(
                                tile.attribute("RevisionNr")) + "; " + str(tile.attribute("LastRevisionDate")) + "; " + str(idxTileID),
                            tag="TOMs panel")

                #self.tileSet.add((tile))
                #self.addFeatureToSet(self.tileSet, tile, self.tableNames.MAP_GRID.fields().indexFromName("id"))

                if self.checkFeatureInSet(self.tileSet, tile, self.tableNames.MAP_GRID.fields().indexFromName("id")) == False:
                    QgsMessageLog.logMessage(
                        "In addFeatureToSet. Adding: " + str(currTileNr) + " ; " + str(len(self.tileSet)),
                        tag="TOMs panel")
                    self.tileSet.add((tile))

                QgsMessageLog.logMessage(
                            "In getTileForRestriction. len tileSet: " + str(len(self.tileSet)),
                            tag="TOMs panel")

                pass

        pass

    def checkFeatureInSet(self, featureSet, currFeature, idxValue):

        """QgsMessageLog.logMessage(
            "In checkFeatureInSet. ", tag="TOMs panel")"""

        found = False
        currFeatureID = currFeature[idxValue]

        for feature in sorted(featureSet, key=lambda f: f[idxValue]):
            attr = feature.attributes()
            currValue = attr[idxValue]

            if currFeatureID == currValue:
                found = True
                return found

        return found

    def getTileRevisionNr(self, currTile):
        # return the revision number for the tile
        QgsMessageLog.logMessage("In getRestriction.", tag="TOMs panel")

        #query2 = '"tile" = \'{tileid}\''.format(tileid=currTile)

        queryString = "\"id\" = " + + str(currTile.attribute("id"))

        QgsMessageLog.logMessage("In getTileRevisionNr: queryString: " + str(queryString), tag="TOMs panel")

        expr = QgsExpression(queryString)

        for feature in self.tileLayer.getFeatures(QgsFeatureRequest(expr)):
            currRevisionNr = feature["RevisionNr"]
            return currRevisionNr

        QgsMessageLog.logMessage("In getTileRevisionNr: tile not found", tag="TOMs panel")
        return None

    def getTileRevisionNrAtDate(self, tileNr, filterDate):
        # return the revision number for the tile
        QgsMessageLog.logMessage("In getTileRevisionNrAtDate.", tag="TOMs panel")

        #query2 = '"tile" = \'{tileid}\''.format(tileid=currTile)

        queryString = "\"TileNr\" = " + str(tileNr)

        QgsMessageLog.logMessage("In getTileRevisionNrAtDate: queryString: " + str(queryString), tag="TOMs panel")

        expr = QgsExpression(queryString)

        """request = QgsFeatureRequest().setFlags(QgsFeatureRequest.NoGeometry)

        request.setFilterExpression(
                u"\"TileNr\" = {1}".format(str(currTile.attribute("id"))))"""

        # Grab the results from the layer
        features = self.tableNames.TILES_IN_ACCEPTED_PROPOSALS.getFeatures(QgsFeatureRequest(expr))

        for feature in sorted(features, key=lambda f: f[2], reverse=True):
            lastProposalID = feature["ProposalID"]
            lastRevisionNr = feature["RevisionNr"]
            #return currRevisionNr
            #lastProposalTitle, lastProposalOpendate = self.getProposalTitle(lastProposalID)

            lastProposalOpendate = self.proposalsManager.getProposalOpenDate(lastProposalID)

            QgsMessageLog.logMessage(
                "In getTileRevisionNrAtDate: last Proposal: " + str(lastProposalID) + "; " + str(lastRevisionNr),
                tag="TOMs panel")

            QgsMessageLog.logMessage(
                "In getTileRevisionNrAtDate: last Proposal open date: " + str(lastProposalOpendate) + "; filter date: " + str(filterDate),
                tag="TOMs panel")

            if lastProposalOpendate <= filterDate:
                QgsMessageLog.logMessage(
                    "In getTileRevisionNrAtDate: using Proposal: " + str(lastProposalID) + "; " + str(lastRevisionNr),
                    tag="TOMs panel")
                return lastRevisionNr, lastProposalOpendate

        return None, None

    def rejectProposal(self, currProposalID):
        QgsMessageLog.logMessage("In rejectProposal.", tag="TOMs panel")

        # This is a "reset" so change all open/close dates back to null. **** Need to be careful if a restriction is in more than one proposal

        # Now loop through all the items in restrictionsInProposals for this proposal and take appropriate action

        RestrictionsInProposalsLayer = QgsProject.instance().mapLayersByName("RestrictionsInProposals")[0]
        idxProposalID = RestrictionsInProposalsLayer.fields().indexFromName("ProposalID")
        idxRestrictionTableID = RestrictionsInProposalsLayer.fields().indexFromName("RestrictionTableID")
        idxRestrictionID = RestrictionsInProposalsLayer.fields().indexFromName("RestrictionID")
        idxActionOnProposalAcceptance = RestrictionsInProposalsLayer.fields().indexFromName("ActionOnProposalAcceptance")

        # restrictionFound = False

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for restrictionInProposal in RestrictionsInProposalsLayer.getFeatures():
            if restrictionInProposal.attribute("ProposalID") == currProposalID:
                currRestrictionLayer = self.getRestrictionsLayerFromID(restrictionInProposal.attribute("RestrictionTableID"))
                currRestrictionID = restrictionInProposal.attribute("RestrictionID")
                currAction = restrictionInProposal.attribute("ActionOnProposalAcceptance")

                #currRestrictionLayer.startEditing()
                """if not currRestrictionLayer.isEditable():
                    currRestrictionLayer.startEditing()"""

                statusUpd = self.updateRestriction(currRestrictionLayer, currRestrictionID, currAction, None)

            pass

        pass

        #def commitProposalChanges(self):
        # Function to save changes to current layer and to RestrictionsInProposal
        #pass

        """QgsMessageLog.logMessage("In commitProposalChanges: ", tag="TOMs panel")

        # save changes to all layers

        localTrans = TOMsTransaction(self.iface)

        localTrans.prepareLayerSet()
        setLayers = localTrans.layersInTransaction()

        modifiedTransaction = self.currTransaction.modified()

        for layerID in setLayers:

            transLayer = QgsMapLayerRegistry.instance().mapLayer(layerID)
            QgsMessageLog.logMessage("In commitProposalChanges. Considering: " + transLayer.name(), tag="TOMs panel")

            commitStatus = transLayer.commitChanges()
            commitErrors = transLayer.commitErrors()

            if commitErrors:
                reply = QMessageBox.information(None, "Error",
                                            "Changes to " + transLayer.name() + " failed: " + str(
                                                transLayer.commitErrors()), QMessageBox.Ok)
            break

        statusTrans = False
        errMessage = str()

        # setup signal catch
        #currTransaction.commitError.disconnect()
        self.currTransaction.commitError.connect(self.showTransactionErrorMessage)

        #try:

        #statusTrans = proposalsLayer.commitChanges()
        #commitErrors = proposalsLayer.commitErrors()


        self.currTransaction.commitError.disconnect()
        self.currTransaction = None
        self.rollbackCurrentEdits()

        # TODO: deal with errors in Transaction

        return"""

        """except:

            reply = QMessageBox.information(None, "Error",
                                                "Proposal changes failed: " + str(errMessage),
                                                QMessageBox.Ok)  # rollback all changes

            if currTransaction.rollback(errMessage) == False:
                reply = QMessageBox.information(None, "Error",
                                                "Proposal rollback failed: " + str(errMessage),
                                                QMessageBox.Ok)  # rollback all changes"""

        """def createProposalTransactionGroup(self, tableNames):

        self.tableNames = tableNames
        # Function to create group of layers to be in Transaction for changing proposal

        QgsMessageLog.logMessage("In createProposalTransactionGroup: ", tag="TOMs panel")
        #QMessageBox.information(None, "Information", ("Entering commitRestrictionChanges"))

        # save changes to all layers

        #RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = self.tableNames.RESTRICTIONLAYERS.fields().indexFromName("RestrictionLayerName")
        idxRestrictionsLayerID = self.tableNames.RESTRICTIONLAYERS.fields().indexFromName("id")

        # create transaction
        #newTransaction = QgsTransaction("Test1")

        #QgsMessageLog.logMessage("In createProposalTransactionGroup. Adding ProposalsLayer ", tag="TOMs panel")
        self.setTransactionGroup = [self.Proposals.id()]

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

        proposalsLayer = QgsProject.instance().mapLayersByName("Proposals")[0]
        RestrictionsInProposalLayer = QgsProject.instance().mapLayersByName("RestrictionsInProposals")[0]
        RestrictionsLayers = QgsProject.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fields().indexFromName("RestrictionLayerName")
        idxRestrictionsLayerID = RestrictionsLayers.fields().indexFromName("id")

        # create transaction
        #newTransaction = QgsTransaction("Test1")

        QgsMessageLog.logMessage("In rollbackCurrentEdits. ProposalsLayer ", tag="TOMs panel")

        if proposalsLayer.editBuffer():
            statusRollback = proposalsLayer.rollBack()

        if RestrictionsInProposalLayer.editBuffer():
            statusRollback = RestrictionsInProposalLayer.rollBack()

        for layer in RestrictionsLayers.getFeatures():

            currRestrictionLayerName = layer[idxRestrictionsLayerName]

            restrictionLayer = QgsProject.instance().mapLayersByName(currRestrictionLayerName)[0]

            QgsMessageLog.logMessage("In rollbackCurrentEdits. " + str(restrictionLayer.name()), tag="TOMs panel")
            if restrictionLayer.editBuffer():
                statusRollback = restrictionLayer.rollBack()

        return

    def getLookupDescription(self, lookupLayer, code):

        #QgsMessageLog.logMessage("In getLookupDescription", tag="TOMs panel")

        query = "\"Code\" = " + str(code)
        request = QgsFeatureRequest().setFilterExpression(query)

        #QgsMessageLog.logMessage("In getLookupDescription. queryStatus: " + str(query), tag="TOMs panel")

        for row in lookupLayer.getFeatures(request):
            #QgsMessageLog.logMessage("In getLookupDescription: found row " + str(row.attribute("Description")), tag="TOMs panel")
            return row.attribute("Description") # make assumption that only one row

        return None

    def setupPanelTabs(self, iface, parent):

        # https: // gis.stackexchange.com / questions / 257603 / activate - a - panel - in -tabbed - panels?utm_medium = organic & utm_source = google_rich_qa & utm_campaign = google_rich_qa

        dws = iface.mainWindow().findChildren(QDockWidget)
        #parent = iface.mainWindow().findChild(QDockWidget, 'ProposalPanel')
        dockstate = iface.mainWindow().dockWidgetArea(parent)
        for d in dws:
            if d is not parent:
                if iface.mainWindow().dockWidgetArea(d) == dockstate and d.isHidden() == False:
                    iface.mainWindow().tabifyDockWidget(parent, d)
        parent.raise_()

    def prepareRestrictionForEdit(self, currRestriction, currRestrictionLayer):

        QgsMessageLog.logMessage("In prepareRestrictionForEdit",
                                 tag="TOMs panel")

        # if required, clone the current restriction and enter details into "RestrictionsInProposals" table

        newFeature = currRestriction

        idxRestrictionID = currRestrictionLayer.fields().indexFromName("RestrictionID")

        if not self.restrictionInProposal(currRestriction[idxRestrictionID], self.getRestrictionLayerTableID(currRestrictionLayer), self.proposalsManager.currentProposal()):
            QgsMessageLog.logMessage("In prepareRestrictionForEdit - adding details to RestrictionsInProposal", tag="TOMs panel")
            #  This one is not in the current Proposal, so now we need to:
            #  - generate a new ID and assign it to the feature for which the geometry has changed
            #  - switch the geometries arround so that the original feature has the original geometry and the new feature has the new geometry
            #  - add the details to RestrictionsInProposal

            newFeature = self.cloneRestriction(currRestriction, currRestrictionLayer)

            # Check to see if the feature is added
            QgsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - feature exists in layer - " + newFeature.attribute("RestrictionID"), tag="TOMs panel")

            # Add details to "RestrictionsInProposals"

            self.addRestrictionToProposal(currRestriction[idxRestrictionID],
                                          self.getRestrictionLayerTableID(currRestrictionLayer),
                                          self.proposalsManager.currentProposal(),
                                          ACTION_CLOSE_RESTRICTION())  # close the original feature
            QgsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - feature closed.", tag="TOMs panel")

            self.addRestrictionToProposal(newFeature[idxRestrictionID], self.getRestrictionLayerTableID(currRestrictionLayer),
                                          self.proposalsManager.currentProposal(),
                                          ACTION_OPEN_RESTRICTION())  # open the new one
            QgsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - feature opened.", tag="TOMs panel")


        else:

            QgsMessageLog.logMessage("In TOMsNodeTool:init - restriction exists in RestrictionsInProposal", tag="TOMs panel")
            #newFeature = currRestriction

        # test to see if the geometry is correct
        #self.restrictionTransaction.commitTransactionGroup(self.origLayer)

        return newFeature

    def onFeatureAdded(self, fid):
        QgsMessageLog.logMessage("In onFeatureAdded - newFid: " + str(fid),
                                 tag="TOMs panel")
        self.newFid = fid

    def cloneRestriction(self, originalFeature, restrictionLayer):

        QgsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction",
                                 tag="TOMs panel")
        #  This one is not in the current Proposal, so now we need to:
        #  - generate a new ID and assign it to the feature for which the geometry has changed
        #  - switch the geometries arround so that the original feature has the original geometry and the new feature has the new geometry
        #  - add the details to RestrictionsInProposal

        #originalFeature = self.origFeature.getFeature()

        newFeature = QgsFeature(originalFeature)

        #newFeature.setAttributes(originalFeature.attributes())

        newRestrictionID = str(uuid.uuid4())

        idxRestrictionID = restrictionLayer.fields().indexFromName("RestrictionID")
        idxOpenDate = restrictionLayer.fields().indexFromName("OpenDate")
        idxGeometryID = restrictionLayer.fields().indexFromName("GeometryID")

        newFeature[idxRestrictionID] = newRestrictionID
        newFeature[idxOpenDate] = None
        newFeature[idxGeometryID] = None

        #abstractGeometry = originalFeature.geometry().geometry().clone()  # make a deep copy of the geometry ... https://gis.stackexchange.com/questions/232056/how-to-deep-copy-a-qgis-memory-layer

        #newFeature.setGeometry(QgsGeometry(originalFeature.geometry()))
        #geomStatus = restrictionLayer.changeGeometry(newFeature.id(), QgsGeometry(abstractGeometry))

        # if a new feature has been added to the layer, the featureAdded signal is emitted by the layer ... and the fid is obtained
        # self.newFid = None
        restrictionLayer.featureAdded.connect(self.onFeatureAdded)

        addStatus = restrictionLayer.addFeature(newFeature, True)
        #addStatus = restrictionLayer.addFeatures([newFeature], True)

        restrictionLayer.featureAdded.disconnect(self.onFeatureAdded)

        restrictionLayer.updateExtents()
        restrictionLayer.updateFields()

        QgsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - addStatus: " + str(addStatus) + " featureID: " + str(self.newFid), #+ " geomStatus: " + str(geomStatus),
                                 tag="TOMs panel")

        QgsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - attributes: (fid=" + str(newFeature.id()) + ") " + str(newFeature.attributes()),
                                 tag="TOMs panel")

        QgsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - newGeom: " + newFeature.geometry().asWkt(),
                                 tag="TOMs panel")

        # test to see that feature has been added ...
        #feat = restrictionLayer.getFeatures(QgsFeatureRequest(newFeature.id())).next()
        feat = restrictionLayer.getFeatures(
            QgsFeatureRequest().setFilterExpression('GeometryID = \'{}\''.format(newFeature['GeometryID']))).next()

        """originalGeomBuffer = QgsGeometry(originalfeature.geometry())
        QgsMessageLog.logMessage(
            "In TOMsNodeTool:cloneRestriction - originalGeom: " + originalGeomBuffer.asWkt(),
            tag="TOMs panel")
        self.origLayer.changeGeometry(currRestriction.id(), originalGeomBuffer)

        QgsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - geometries switched.", tag="TOMs panel")"""

        return newFeature

