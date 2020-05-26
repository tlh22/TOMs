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
    QgsProject,
    QgsApplication,
    Qgis
)

from qgis.gui import *
import functools
import time
import os

from .constants import (
    ProposalStatus,
    RestrictionAction
)

from .generateGeometryUtils import generateGeometryUtils
#from core.proposalsManager import *
from .core import (TOMsProposal, TOMsTile)
from .core.TOMsTransaction import (TOMsTransaction)

from abc import ABCMeta
import datetime
import uuid

class TOMsParams(QObject):

    TOMsParamsNotFound = pyqtSignal()
    """ signal will be emitted if there is a problem with opening TOMs - typically a layer missing """
    TOMsParamsSet = pyqtSignal()
    """ signal will be emitted if there is a problem with opening TOMs - typically a layer missing """

    def __init__(self):
        QObject.__init__(self)
        # self.iface = iface

        TOMsMessageLog.logMessage("In TOMSParams.init ...", level=Qgis.Info)
        self.TOMsParamsList = ["BayWidth",
                          "BayLength",
                          "BayOffsetFromKerb",
                          "LineOffsetFromKerb",
                          "CrossoverShapeWidth",
                          "PhotoPath",
                          "MinimumTextDisplayScale",
                          "TOMsDebugLevel"
                        ]

        self.TOMsParamsDict = {}

    def getParams(self):

        TOMsMessageLog.logMessage("In TOMsParams.getParams ...", level=Qgis.Info)
        found = True

        # Check for project being open
        currProject = QgsProject.instance()

        if len(currProject.fileName()) == 0:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Project not yet open"))
            found = False

        else:

            # TOMsMessageLog.logMessage("In TOMSLayers.getParams ... starting to get", level=Qgis.Info)

            for param in self.TOMsParamsList:
                TOMsMessageLog.logMessage("In TOMsParams.getParams ... getting " + str(param), level=Qgis.Info)

                """if QgsExpressionContextUtils.projectScope(currProject).hasVariable(param):
                    currParam = QgsExpressionContextUtils.projectScope(currProject).variable(param)"""
                currParam = None
                try:
                    currParam = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable(param)
                except None:
                    QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Property " + param + " is not present"))

                if len(str(currParam))>0:
                    self.TOMsParamsDict[param] = currParam
                    TOMsMessageLog.logMessage("In TOMsParams.getParams ... set " + str(param) + " as " + str(currParam), level=Qgis.Info)
                else:
                    QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Property " + param + " is not present"))
                    found = False
                    break

        if found == False:
            self.TOMsParamsNotFound.emit()
        else:
            self.TOMsParamsSet.emit()

            # TOMsMessageLog.logMessage("In TOMSLayers.getParams ... finished ", level=Qgis.Info)

        return found

    def setParam(self, param):
        return self.TOMsParamsDict.get(param)

class TOMsLayers(QObject):

    TOMsLayersNotFound = pyqtSignal()
    """ signal will be emitted if there is a problem with opening TOMs - typically a layer missing """
    TOMsLayersSet = pyqtSignal()
    """ signal will be emitted if everything is OK with opening TOMs """

    def __init__(self, iface):
        QObject.__init__(self)
        self.iface = iface

        TOMsMessageLog.logMessage("In TOMSLayers.init ...", level=Qgis.Info)
        #self.proposalsManager = proposalsManager

        #RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]
        self.TOMsLayerList = ["Proposals",
                         "ProposalStatusTypes",
                         "ActionOnProposalAcceptanceTypes",
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
                         "RoadCentreLine",
                         "RoadCasement",
                         "TilesInAcceptedProposals",
                         #"RestrictionTypes",
                         "BayLineTypes",
                         "SignTypes",
                         "RestrictionPolygonTypes"
                         ]
        self.TOMsLayerDict = {}

    def getLayers(self):

        TOMsMessageLog.logMessage("In TOMSLayers.getLayers ...", level=Qgis.Info)
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

        # TODO: need to deal with any errors arising ...

        if found == False:
            self.TOMsLayersNotFound.emit()
        else:
            self.TOMsLayersSet.emit()

        return

    def setLayer(self, layer):
        return self.TOMsLayerDict.get(layer)

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
        TOMsMessageLog.logMessage("In originalFeature - attributes (fid:" + str(self.savedFeature.id()) + "): " + str(self.savedFeature.attributes()),
                                 level=Qgis.Info)
        TOMsMessageLog.logMessage("In originalFeature - attributes: " + str(self.savedFeature.geometry().asWkt()),
                                 level=Qgis.Info)

class RestrictionTypeUtilsMixin():
    #def __init__(self):
    def __init__(self, iface):

        #self.constants = TOMsConstants()
        #self.proposalsManager = proposalsManager
        self.iface = iface
        #self.tableNames = TOMSLayers(self.iface)

        #self.tableNames.getLayers()
        #super().__init__()
        self.currTransaction = None
        #self.proposalTransaction = QgsTransaction()
        #self.proposalPanel = None

        pass

    def restrictionInProposal(self, currRestrictionID, currRestrictionLayerID, proposalID):
        # returns True if resstriction is in Proposal
        TOMsMessageLog.logMessage("In restrictionInProposal.", level=Qgis.Info)

        RestrictionsInProposalsLayer = QgsProject.instance().mapLayersByName("RestrictionsInProposals")[0]

        restrictionFound = False

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for restrictionInProposal in RestrictionsInProposalsLayer.getFeatures():
            if restrictionInProposal.attribute("RestrictionID") == currRestrictionID:
                if restrictionInProposal.attribute("RestrictionTableID") == currRestrictionLayerID:
                    if restrictionInProposal.attribute("ProposalID") == proposalID:
                        restrictionFound = True

        TOMsMessageLog.logMessage("In restrictionInProposal. restrictionFound: " + str(restrictionFound),
                                 level=Qgis.Info)

        return restrictionFound

    def addRestrictionToProposal(self, restrictionID, restrictionLayerTableID, proposalID, proposedAction):
        # adds restriction to the "RestrictionsInProposals" layer
        TOMsMessageLog.logMessage("In addRestrictionToProposal.", level=Qgis.Info)

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

        TOMsMessageLog.logMessage(
            "In addRestrictionToProposal. Before record create. RestrictionID: " + str(restrictionID),
            level=Qgis.Info)

        attrs = newRestrictionsInProposal.attributes()

        #QMessageBox.information(None, "Information", ("addRestrictionToProposal" + str(attrs)))

        returnStatus = RestrictionsInProposalsLayer.addFeatures([newRestrictionsInProposal])

        return returnStatus

    def getRestrictionsLayer(self, currRestrictionTableRecord):
        # return the layer given the row in "RestrictionLayers"
        TOMsMessageLog.logMessage("In getRestrictionLayer.", level=Qgis.Info)

        RestrictionsLayers = QgsProject.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fields().indexFromName("RestrictionLayerName")

        currRestrictionsTableName = currRestrictionTableRecord[idxRestrictionsLayerName]

        RestrictionLayer = QgsProject.instance().mapLayersByName(currRestrictionsTableName)[0]

        return RestrictionLayer

    def getRestrictionsLayerFromID(self, currRestrictionTableID):
        # return the layer given the row in "RestrictionLayers"
        TOMsMessageLog.logMessage("In getRestrictionsLayerFromID.", level=Qgis.Info)

        RestrictionsLayers = QgsProject.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fields().indexFromName("RestrictionLayerName")
        idxRestrictionsLayerID = RestrictionsLayers.fields().indexFromName("Code")

        for layer in RestrictionsLayers.getFeatures():
            if layer[idxRestrictionsLayerID] == currRestrictionTableID:
                currRestrictionLayerName = layer[idxRestrictionsLayerName]

        restrictionLayer = QgsProject.instance().mapLayersByName(currRestrictionLayerName)[0]

        return restrictionLayer

    def getRestrictionLayerTableID(self, currRestLayer):
        TOMsMessageLog.logMessage("In getRestrictionLayerTableID.", level=Qgis.Info)
        # find the ID for the layer within the table "

        RestrictionsLayers = QgsProject.instance().mapLayersByName("RestrictionLayers")[0]

        layersTableID = 0

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for layer in RestrictionsLayers.getFeatures():
            if layer.attribute("RestrictionLayerName") == str(currRestLayer.name()):
                layersTableID = layer.attribute("Code")

        TOMsMessageLog.logMessage("In getRestrictionLayerTableID. layersTableID: " + str(layersTableID),
                                 level=Qgis.Info)

        return layersTableID

    def getRestrictionBasedOnRestrictionID(self, currRestrictionID, currRestrictionLayer):
        # return the layer given the row in "RestrictionLayers"
        TOMsMessageLog.logMessage("In getRestriction.", level=Qgis.Info)

        #query2 = '"RestrictionID" = \'{restrictionid}\''.format(restrictionid=currRestrictionID)

        queryString = "\"RestrictionID\" = \'" + currRestrictionID + "\'"

        TOMsMessageLog.logMessage("In getRestriction: queryString: " + str(queryString), level=Qgis.Info)

        expr = QgsExpression(queryString)

        for feature in currRestrictionLayer.getFeatures(QgsFeatureRequest(expr)):
            return feature

        TOMsMessageLog.logMessage("In getRestriction: Restriction not found", level=Qgis.Info)
        return None

    def deleteRestrictionInProposal(self, currRestrictionID, currRestrictionLayerID, proposalID):
        TOMsMessageLog.logMessage("In deleteRestrictionInProposal: " + str(currRestrictionID), level=Qgis.Info)

        returnStatus = False

        RestrictionsInProposalsLayer = QgsProject.instance().mapLayersByName("RestrictionsInProposals")[0]

        #RestrictionsInProposalsLayer.startEditing()

        for restrictionInProposal in RestrictionsInProposalsLayer.getFeatures():
            if restrictionInProposal.attribute("RestrictionID") == currRestrictionID:
                if restrictionInProposal.attribute("RestrictionTableID") == currRestrictionLayerID:
                    if restrictionInProposal.attribute("ProposalID") == proposalID:
                        TOMsMessageLog.logMessage("In deleteRestrictionInProposal - deleting ",
                                                 level=Qgis.Info)

                        attrs = restrictionInProposal.attributes()

                        #QMessageBox.information(None, "Information", ("deleteRestrictionInProposal" + str(attrs)))

                        returnStatus = RestrictionsInProposalsLayer.deleteFeature(restrictionInProposal.id())
                        #returnStatus = True
                        return returnStatus

        return returnStatus

    def onSaveRestrictionDetails(self, currRestriction, currRestrictionLayer, dialog, restrictionTransaction):
        TOMsMessageLog.logMessage("In onSaveRestrictionDetails: " + str(currRestriction.attribute("GeometryID")), level=Qgis.Info)

        #currRestrictionLayer.startEditing()

        currProposalID = int(QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('CurrentProposal'))

        if currProposalID > 0:

            currRestrictionLayerTableID = self.getRestrictionLayerTableID(currRestrictionLayer)
            idxRestrictionID = currRestriction.fields().indexFromName("RestrictionID")
            idxGeometryID = currRestriction.fields().indexFromName("GeometryID")

            if self.restrictionInProposal(currRestriction[idxRestrictionID], currRestrictionLayerTableID, currProposalID):

                # restriction already is part of the current proposal
                # simply make changes to the current restriction in the current layer
                TOMsMessageLog.logMessage("In onSaveRestrictionDetails. Saving details straight from form." + str(currRestriction.attribute("GeometryID")),
                                         level=Qgis.Info)

                #res = dialog.save()
                status = currRestrictionLayer.updateFeature(currRestriction)
                status = dialog.attributeForm().save()

                """if res == True:
                    TOMsMessageLog.logMessage("In onSaveRestrictionDetails. Form saved.",
                                             level=Qgis.Info)
                else:
                    TOMsMessageLog.logMessage("In onSaveRestrictionDetails. Form NOT saved.",
                                             level=Qgis.Info)"""

            else:

                # restriction is NOT part of the current proposal

                # need to:
                #    - enter the restriction into the table RestrictionInProposals, and
                #    - make a copy of the restriction in the current layer (with the new details)

                # TOMsMessageLog.logMessage("In onSaveRestrictionDetails. Adding restriction. ID: " + str(currRestriction.id()),
                #                         level=Qgis.Info)

                # Create a new feature using the current details

                idxOpenDate = currRestriction.fields().indexFromName("OpenDate")
                newRestrictionID = str(uuid.uuid4())

                TOMsMessageLog.logMessage(
                    "In onSaveRestrictionDetails. Adding new restriction (1). ID: " + str(
                        newRestrictionID),
                    level=Qgis.Info)

                if currRestriction[idxOpenDate] is None:
                    # This is a feature that has just been created, i.e., it is not currently part of the proposal and did not previously exist

                    # Not quite sure what is happening here but think the following:
                    #  Feature does not yet exist, i.e., not saved to layer yet, so there is no id for it and can't use either feature or layer to save
                    #  So, need to continue to modify dialog value which will be eventually saved

                    dialog.attributeForm().changeAttribute("RestrictionID", newRestrictionID)

                    TOMsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Adding new restriction. ID: " + str(currRestriction[idxRestrictionID]),
                        level=Qgis.Info)

                    status = self.addRestrictionToProposal(str(currRestriction[idxRestrictionID]), currRestrictionLayerTableID,
                                             currProposalID, RestrictionAction.OPEN)  # Open = 1

                    TOMsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Transaction Status 1: " + str(
                            restrictionTransaction.currTransactionGroup.modified()),
                        level=Qgis.Info)

                    """ attributeForm saves to the layer. Has the feature been added to the layer?"""

                    status = dialog.attributeForm().save()  # this issues a commit on the transaction?
                    #dialog.accept()
                    #TOMsMessageLog.logMessage("Form accepted", level=Qgis.Info)
                    TOMsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Transaction Status 2: " + str(
                            restrictionTransaction.currTransactionGroup.modified()),
                        level=Qgis.Info)
                    #currRestrictionLayer.updateFeature(currRestriction)  # TH (added for v3)
                    currRestrictionLayer.addFeature(currRestriction)  # TH (added for v3)

                else:

                    # this feature was created before this session, we need to:
                    #  - close it in the RestrictionsInProposals table
                    #  - clone it in the current Restrictions layer (with a new GeometryID and no OpenDate)
                    #  - and then stop any changes to the original feature

                    # ************* need to discuss: seems that new has become old !!!

                    TOMsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Closing existing restriction. ID: " + str(
                            currRestriction[idxRestrictionID]),
                        level=Qgis.Info)

                    status = self.addRestrictionToProposal(currRestriction[idxRestrictionID], currRestrictionLayerTableID,
                                             currProposalID, RestrictionAction.CLOSE)  # Open = 1; Close = 2

                    newRestriction = QgsFeature(currRestriction)

                    # TODO: Rethink logic here and need to unwind changes ... without triggering rollBack ?? maybe attributeForm.setFeature()
                    #dialog.reject()

                    newRestriction[idxRestrictionID] = newRestrictionID
                    newRestriction[idxOpenDate] = None
                    newRestriction[idxGeometryID] = None

                    currRestrictionLayer.addFeature(newRestriction)

                    TOMsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Clone restriction. New ID: " + str(newRestriction[idxRestrictionID]),
                        level=Qgis.Info)

                    attrs2 = newRestriction.attributes()
                    TOMsMessageLog.logMessage("In onSaveRestrictionDetails: clone Restriction: " + str(attrs2),
                        level=Qgis.Info)
                    TOMsMessageLog.logMessage("In onSaveRestrictionDetails. Clone: {}".format(newRestriction.geometry().asWkt()),
                                             level=Qgis.Info)

                    status = self.addRestrictionToProposal(newRestriction[idxRestrictionID], currRestrictionLayerTableID,
                                             currProposalID, RestrictionAction.OPEN)  # Open = 1; Close = 2

                    TOMsMessageLog.logMessage(
                        "In onSaveRestrictionDetails. Opening clone. ID: " + str(
                            newRestriction[idxRestrictionID]),
                        level=Qgis.Info)

                    dialog.attributeForm().close()
                    currRestriction = self.origFeature.getFeature()
                    currRestrictionLayer.updateFeature(currRestriction)

                pass

            # Now commit changes and redraw

            attrs1 = currRestriction.attributes()
            TOMsMessageLog.logMessage("In onSaveRestrictionDetails: currRestriction: " + str(attrs1),
                                     level=Qgis.Info)
            TOMsMessageLog.logMessage(
                "In onSaveRestrictionDetails. curr: {}".format(currRestriction.geometry().asWkt()),
                level=Qgis.Info)

            # Make sure that the saving will not be executed immediately, but
            # only when the event loop runs into the next iteration to avoid
            # problems

            TOMsMessageLog.logMessage(
                "In onSaveRestrictionDetails. Transaction Status 3: " + str(
                    restrictionTransaction.currTransactionGroup.modified()),
                level=Qgis.Info)

            commitStatus = restrictionTransaction.commitTransactionGroup(currRestrictionLayer)
            #restrictionTransaction.deleteTransactionGroup()
            TOMsMessageLog.logMessage(
                "In onSaveRestrictionDetails. Transaction Status 4: " + str(
                    restrictionTransaction.currTransactionGroup.modified()),
                level=Qgis.Info)
            # Trying to unset map tool to force updates ...
            #self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())
            #dialog.accept()
            """TOMsMessageLog.logMessage(
                "In onSaveRestrictionDetails. Transaction Status 5: " + str(
                    restrictionTransaction.currTransactionGroup.modified()) + " commitStatus " + str(commitStatus),
                level=Qgis.Info)"""
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

        TOMsMessageLog.logMessage(
        "In onSaveRestrictionDetails. Finished",
        level=Qgis.Info)

        status = dialog.close()
        currRestrictionLayer.removeSelection()

        # reinstate Proposals Panel (if it needs it)
        #if not self.proposalPanel:
        self.proposalPanel = self.iface.mainWindow().findChild(QDockWidget, 'ProposalPanelDockWidgetBase')

        self.setupPanelTabs(self.iface, self.proposalPanel)
        #self.setupPanelTabs(self.iface, self.dock)

    def setDefaultRestrictionDetails(self, currRestriction, currRestrictionLayer, currDate):
        TOMsMessageLog.logMessage("In setDefaultRestrictionDetails: ", level=Qgis.Info)

        generateGeometryUtils.setRoadName(currRestriction)
        if currRestrictionLayer.geometryType() == 1:  # Line or Bay
            generateGeometryUtils.setAzimuthToRoadCentreLine(currRestriction)
            #currRestriction.setAttribute("RestrictionLength", currRestriction.geometry().length())

        currentCPZ, cpzWaitingTimeID = generateGeometryUtils.getCurrentCPZDetails(currRestriction)

        if currRestrictionLayer.name() != "Signs":
            currRestriction.setAttribute("CPZ", currentCPZ)

        #currDate = self.proposalsManager.date()

        if currRestrictionLayer.name() == "Lines":
            currRestriction.setAttribute("RestrictionTypeID", 201)  # 10 = SYL (Lines)
            currRestriction.setAttribute("GeomShapeID", 10)   # 10 = Parallel Line
            currRestriction.setAttribute("NoWaitingTimeID", cpzWaitingTimeID)
            #currRestriction.setAttribute("Lines_DateTime", currDate)

        elif currRestrictionLayer.name() == "Bays":
            currRestriction.setAttribute("RestrictionTypeID", 101)  # 28 = Permit Holders Bays (Bays)
            currRestriction.setAttribute("GeomShapeID", 21)   # 21 = Parallel Bay (Polygon)
            currRestriction.setAttribute("NrBays", -1)

            currRestriction.setAttribute("TimePeriodID", cpzWaitingTimeID)

            currentPTA, ptaMaxStayID, ptaNoReturnID = generateGeometryUtils.getCurrentPTADetails(currRestriction)

            currRestriction.setAttribute("MaxStayID", ptaMaxStayID)
            currRestriction.setAttribute("NoReturnID", ptaNoReturnID)
            currRestriction.setAttribute("ParkingTariffArea", currentPTA)

        elif currRestrictionLayer.name() == "Signs":
            currRestriction.setAttribute("SignType_1", 28)  # 28 = Permit Holders Only (Signs)

        elif currRestrictionLayer.name() == "RestrictionPolygons":
            currRestriction.setAttribute("RestrictionTypeID", 4)  # 28 = Residential mews area (RestrictionPolygons)

        return

    def updateDefaultRestrictionDetails(self, currRestriction, currRestrictionLayer, currDate):
        TOMsMessageLog.logMessage("In updateDefaultRestrictionDetails. currLayer: " + currRestrictionLayer.name(), level=Qgis.Info)

        generateGeometryUtils.setRoadName(currRestriction)
        if currRestrictionLayer.geometryType() == 1:  # Line or Bay
            generateGeometryUtils.setAzimuthToRoadCentreLine(currRestriction)

            currentCPZ, cpzWaitingTimeID = generateGeometryUtils.getCurrentCPZDetails(currRestriction)

            currRestrictionLayer.changeAttributeValue(currRestriction.id(),
                                                  currRestrictionLayer.fields().indexFromName("CPZ"), currentCPZ)

            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("ComplianceRoadMarkingsFaded"), None)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("ComplianceRestrictionSignIssue"), None)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Photos_01"), None)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Photos_02"), None)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("Photos_03"), None)

        if currRestrictionLayer.name() == "Bays":

            currentPTA, ptaMaxStayID, ptaNoReturnID = generateGeometryUtils.getCurrentPTADetails(currRestriction)
            currRestrictionLayer.changeAttributeValue(currRestriction.id(), currRestrictionLayer.fields().indexFromName("ParkingTariffArea"), currentPTA)


        """
        def updateRestriction(self, currRestrictionLayer, currRestrictionID, currAction, currProposalOpenDate):
        # update the Open/Close date for the restriction
        TOMsMessageLog.logMessage("In updateRestriction. layer: " + str(
            currRestrictionLayer.name()) + " currRestId: " + currRestrictionID + " Opendate: " + str(
            currProposalOpenDate), level=Qgis.Info)

        # idxOpenDate = currRestrictionLayer.fields().indexFromName("OpenDate2")
        # idxCloseDate = currRestrictionLayer.fields().indexFromName("CloseDate2")

        # clear filter
        currRestrictionLayer.setSubsetString("")

        for currRestriction in currRestrictionLayer.getFeatures():
            #TOMsMessageLog.logMessage("In updateRestriction. checkRestId: " + currRestriction.attribute("GeometryID"), level=Qgis.Info)

            if currRestriction.attribute("RestrictionID") == currRestrictionID:
                TOMsMessageLog.logMessage(
                    "In updateRestriction. Action on: " + currRestrictionID + " Action: " + str(currAction),
                    level=Qgis.Info)
                if currAction == RestrictionAction.OPEN:  # Open
                    statusUpd = currRestrictionLayer.changeAttributeValue(currRestriction.id(),
                                                              currRestrictionLayer.fields().indexFromName("OpenDate"),
                                                              currProposalOpenDate)
                    TOMsMessageLog.logMessage(
                        "In updateRestriction. " + currRestrictionID + " Opened", level=Qgis.Info)
                else:  # Close
                    statusUpd = currRestrictionLayer.changeAttributeValue(currRestriction.id(),
                                                              currRestrictionLayer.fields().indexFromName("CloseDate"),
                                                              currProposalOpenDate)
                    TOMsMessageLog.logMessage(
                        "In updateRestriction. " + currRestrictionID + " Closed", level=Qgis.Info)

                return statusUpd

        pass 
        """

    def setupRestrictionDialog(self, restrictionDialog, currRestrictionLayer, currRestriction, restrictionTransaction):

        #self.restrictionDialog = restrictionDialog
        #self.currRestrictionLayer = currRestrictionLayer
        #self.currRestriction = currRestriction
        #self.restrictionTransaction = restrictionTransaction

        # Create a copy of the feature
        self.origFeature = originalFeature()
        self.origFeature.setFeature(currRestriction)

        if restrictionDialog is None:
            TOMsMessageLog.logMessage(
                "In setupRestrictionDialog. dialog not found",
                level=Qgis.Info)

        #restrictionDialog.attributeForm().disconnectButtonBox()
        button_box = restrictionDialog.findChild(QDialogButtonBox, "button_box")
        # button_box = restrictionDialog.buttonBox()

        if button_box is None:
            TOMsMessageLog.logMessage(
                "In setupRestrictionDialog. button box not found",
                level=Qgis.Info)

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
        TOMsMessageLog.logMessage("In onSaveRestrictionDetailsFromForm", level=Qgis.Info)
        self.onSaveRestrictionDetails(self.currRestriction,
                                      self.currRestrictionLayer, self.restrictionDialog, self.restrictionTransaction)"""

    def onRejectRestrictionDetailsFromForm(self, restrictionDialog, restrictionTransaction):
        TOMsMessageLog.logMessage("In onRejectRestrictionDetailsFromForm", level=Qgis.Info)
        #self.currRestrictionLayer.destroyEditCommand()
        restrictionDialog.reject()

        #self.rollbackCurrentEdits()
        
        restrictionTransaction.rollBackTransactionGroup()
        
        # reinstate Proposals Panel (if it needs it)

        #if not self.proposalPanel:
        self.proposalPanel = self.iface.mainWindow().findChild(QDockWidget, 'ProposalPanelDockWidgetBase')

        self.setupPanelTabs(self.iface, self.proposalPanel)

    def onAttributeChangedClass2(self, currFeature, layer, fieldName, value):
        TOMsMessageLog.logMessage(
            "In FormOpen:onAttributeChangedClass 2 - layer: " + str(layer.name()) + " (" + fieldName + "): " + str(value), level=Qgis.Info)

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

        TOMsMessageLog.logMessage("In photoDetails", level=Qgis.Info)

        FIELD1 = dialog.findChild(QLabel, "Photo_Widget_01")
        FIELD2 = dialog.findChild(QLabel, "Photo_Widget_02")
        FIELD3 = dialog.findChild(QLabel, "Photo_Widget_03")

        photoPath = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('PhotoPath')
        if photoPath == None:
            reply = QMessageBox.information(None, "Information", "Please set value for PhotoPath.", QMessageBox.Ok)
            return

        projectPath = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('project_path')
        path_absolute = os.path.abspath(os.path.join(projectPath, photoPath))

        layerName = currRestLayer.name()

        # Generate the full path to the file

        """fileName1 = layerName + "_Photos_01"
        fileName2 = layerName + "_Photos_02"
        fileName3 = layerName + "_Photos_03"""""

        idx1 = currRestLayer.fields().indexFromName("Photos_01")
        idx2 = currRestLayer.fields().indexFromName("Photos_02")
        idx3 = currRestLayer.fields().indexFromName("Photos_03")

        TOMsMessageLog.logMessage("In photoDetails. idx1: " + str(idx1) + "; " + str(idx2) + "; " + str(idx3),
                                 level=Qgis.Info)
        # if currRestrictionFeature[idx1]:
        # TOMsMessageLog.logMessage("In photoDetails. photo1: " + str(currRestrictionFeature[idx1]), level=Qgis.Info)
        # TOMsMessageLog.logMessage("In photoDetails. photo2: " + str(currRestrictionFeature.attribute(idx2)), level=Qgis.Info)
        # TOMsMessageLog.logMessage("In photoDetails. photo3: " + str(currRestrictionFeature.attribute(idx3)), level=Qgis.Info)

        if FIELD1:
            TOMsMessageLog.logMessage("In photoDetails. FIELD 1 exisits",
                                     level=Qgis.Info)
            if currRestrictionFeature[idx1]:
                newPhotoFileName1 = os.path.join(path_absolute, currRestrictionFeature[idx1])
            else:
                newPhotoFileName1 = None

            TOMsMessageLog.logMessage("In photoDetails. A. Photo1: " + str(newPhotoFileName1), level=Qgis.Info)
            pixmap1 = QPixmap(newPhotoFileName1)
            if pixmap1.isNull():
                pass
                # FIELD1.setText('Picture could not be opened ({path})'.format(path=newPhotoFileName1))
            else:
                FIELD1.setPixmap(pixmap1)
                FIELD1.setScaledContents(True)
                TOMsMessageLog.logMessage("In photoDetails. Photo1: " + str(newPhotoFileName1), level=Qgis.Info)

        if FIELD2:
            TOMsMessageLog.logMessage("In photoDetails. FIELD 2 exisits",
                                     level=Qgis.Info)
            if currRestrictionFeature[idx2]:
                newPhotoFileName2 = os.path.join(path_absolute, currRestrictionFeature[idx2])
            else:
                newPhotoFileName2 = None

            # newPhotoFileName2 = os.path.join(path_absolute, str(currRestrictionFeature[idx2]))
            # newPhotoFileName2 = os.path.join(path_absolute, str(currRestrictionFeature.attribute(fileName2)))
            TOMsMessageLog.logMessage("In photoDetails. A. Photo2: " + str(newPhotoFileName2), level=Qgis.Info)
            pixmap2 = QPixmap(newPhotoFileName2)
            if pixmap2.isNull():
                pass
                # FIELD1.setText('Picture could not be opened ({path})'.format(path=newPhotoFileName1))
            else:
                FIELD2.setPixmap(pixmap2)
                FIELD2.setScaledContents(True)
                TOMsMessageLog.logMessage("In photoDetails. Photo2: " + str(newPhotoFileName2), level=Qgis.Info)

        if FIELD3:
            TOMsMessageLog.logMessage("In photoDetails. FIELD 3 exisits",
                                     level=Qgis.Info)
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
                FIELD3.setPixmap(pixmap3)
                FIELD3.setScaledContents(True)
                TOMsMessageLog.logMessage("In photoDetails. Photo3: " + str(newPhotoFileName3), level=Qgis.Info)

        pass

    def onSaveProposalFormDetails(self, currProposalRecord, currProposalObject, proposalsLayer, proposalsDialog, proposalTransaction):
        TOMsMessageLog.logMessage("In onSaveProposalFormDetails.", level=Qgis.Info)

        #proposalsLayerfromClass = TOMsTableNames.PROPOSALS()
        #TOMsMessageLog.logMessage("In onSaveProposalFormDetails. Proposals (class):" + str(proposalsLayerfromClass.name()), level=Qgis.Info)

        #self.Proposals = self.proposalsManager.tableNames.TOMsLayerDict.get("Proposals")
        self.Proposals = proposalsLayer

        # set up field indexes
        idxProposalID = self.Proposals.fields().indexFromName("ProposalID")
        idxProposalTitle = self.Proposals.fields().indexFromName("ProposalTitle")
        idxProposalStatusID = self.Proposals.fields().indexFromName("ProposalStatusID")
        idxProposalNotes = self.Proposals.fields().indexFromName("ProposalNotes")
        idxProposalCreateDate = self.Proposals.fields().indexFromName("ProposalCreateDate")
        idxProposalOpenDate = self.Proposals.fields().indexFromName("ProposalOpenDate")

        currProposalID = currProposalObject.getProposalNr()
        currProposalStatusID = currProposalObject.getProposalStatusID()
        currProposalTitle = currProposalObject.getProposalTitle()

        newProposalStatusID = currProposalRecord[idxProposalStatusID]
        newProposalOpenDate = currProposalRecord[idxProposalOpenDate]
        TOMsMessageLog.logMessage("In onSaveProposalFormDetails. currProposalStatus = " + str(currProposalStatusID), level=Qgis.Info)

        #updateStatus = False
        newProposal = False
        proposalAcceptedRejected = False

        if newProposalStatusID == ProposalStatus.ACCEPTED:  # 2 = accepted
            #if currProposal[idxProposalStatusID] == ProposalStatus.ACCEPTED:  # 2 = accepted

            reply = QMessageBox.question(None, 'Confirm changes to Proposal',
                                         # How do you access the main window to make the popup ???
                                         'Do you want to ACCEPT this proposal?. Accepting will make all the proposed changes permanent.',
                                         QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:
                # open the proposal - and accept any other changes to the form

                # currProposalID = currProposal[idxProposalID]

                # TODO: Need to check that this is an authorised user

                # Now close dialog
                #updateStatus = proposalsDialog.accept()

                #updateStatus = True

                #if updateStatus == True:
                #currProposalID = currProposalObject[idxProposalID]
                #currOpenDate = currProposalObject[idxProposalOpenDate]
                #updateStatus = self.acceptProposal(currProposalID, currOpenDate)

                # just check that we have any updates
                currProposalObject.setProposalOpenDate(newProposalOpenDate)

                updateStatus = currProposalObject.acceptProposal()

                TOMsMessageLog.logMessage(
                    "In onSaveProposalFormDetails. updateStatus = " + str(updateStatus), level=Qgis.Info)

                if updateStatus == True or updateStatus is None:
                    status = self.Proposals.updateFeature(currProposalObject.getProposalRecord())
                    updateStatus = proposalsDialog.attributeForm().save()
                    proposalAcceptedRejected = True

                else:
                    proposalsDialog.reject()

            else:
                proposalsDialog.reject()

        elif currProposalStatusID == ProposalStatus.REJECTED:  # 3 = rejected

            reply = QMessageBox.question(None, 'Confirm changes to Proposal',
                                         # How do you access the main window to make the popup ???
                                         'Do you want to REJECT this proposal?. Accepting will make all the proposed changes permanent.',
                                         QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:
                # open the proposal - and accept any other changes to the form

                # currProposalID = currProposal[idxProposalID]

                # TODO: Need to check that this is an authorised user

                updateStatus = currProposalObject.rejectProposal()

                TOMsMessageLog.logMessage(
                    "In onSaveProposalFormDetails. updateStatus = " + str(updateStatus), level=Qgis.Info)

                if updateStatus == True or updateStatus is None:
                    status = self.Proposals.updateFeature(currProposalObject.getProposalRecord())
                    updateStatus = proposalsDialog.attributeForm().save()
                    proposalAcceptedRejected = True

            else:
                # proposalsDialog.reject ((currProposal[idxProposalID]))
                proposalsDialog.reject()

        else:

            TOMsMessageLog.logMessage(
                "In onSaveProposalFormDetails. currProposalID = " + str(currProposalID),
                level=Qgis.Info)

            # self.Proposals.updateFeature(currProposalObject.getProposalRecord())  # TH (added for v3)
            updateStatus = proposalsDialog.attributeForm().save()

            # anything else can be saved.
            if currProposalID == 0:  # We should not be here if this is the current proposal ... 0 is place holder ...

                # This is a new proposal ...

                newProposal = True
                TOMsMessageLog.logMessage(
                    "In onSaveProposalFormDetails. New Proposal ... ", level=Qgis.Info)

                # add geometry
                #currProposal.setGeometry(QgsGeometry())

            else:
                pass
                # self.Proposals.updateFeature(currProposalObject.getProposalRecord())  # TH (added for v3)

            """updateStatus = proposalsLayer.updateFeature(currProposal)

            TOMsMessageLog.logMessage(
                "In onSaveProposalFormDetails. updateStatus = " + str(updateStatus),
                level=Qgis.Info)
            updateStatus = True"""

            #proposalsDialog.accept()
            proposalsDialog.reject()

            #saveStatus = proposalsDialog.attributeForm().save()
            #TOMsMessageLog.logMessage("In onSaveProposalFormDetails. saveStatus. " + str(currProposalObject.attributes()), level=Qgis.Info)

            TOMsMessageLog.logMessage(
                "In onSaveProposalFormDetails. ProposalTransaction modified Status: " + str(
                    proposalTransaction.currTransactionGroup.modified()),
            level=Qgis.Info)
        TOMsMessageLog.logMessage("In onSaveProposalFormDetails. Before save. " + str(currProposalTitle) + " Status: " + str(currProposalStatusID), level=Qgis.Info)


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
            TOMsMessageLog.logMessage("In onSaveProposalFormDetails. newProposalID = " + str(currProposalID), level=Qgis.Info)
            #self.proposalsManager.setCurrentProposal(currProposal[idxProposalID])
            #ProposalTypeUtils.iface.proposalChanged.emit()

            for proposal in self.Proposals.getFeatures():
                if proposal[idxProposalTitle] == currProposalTitle:
                    TOMsMessageLog.logMessage("In onSaveProposalFormDetails. newProposalID = " + str(proposal.id()),
                                             level=Qgis.Info)
                    newProposalID = proposal[idxProposalID]
                    #self.proposalsManager.setCurrentProposal(proposal[idxProposalID])

            self.proposalsManager.newProposalCreated.emit(newProposalID)

        elif proposalAcceptedRejected:
            # refresh the cbProposals and set current Proposal to 0
            self.createProposalcb()
            self.proposalsManager.setCurrentProposal(0)

        else:

            self.proposalsManager.newProposalCreated.emit(currProposalID)

        """
        def acceptProposal(self, currProposalID, currProposalOpenDate):
            TOMsMessageLog.logMessage("In acceptProposal.", level=Qgis.Info)
    
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
    
                    #if not currRestrictionLayer.isEditable():
                    #    currRestrictionLayer.startEditing()
    
                    statusUpd = self.updateRestriction(currRestrictionLayer, currRestrictionID, currAction, currProposalOpenDate)
    
                    if statusUpd == False:
                        reply = QMessageBox.information(None, "Error",
                                                        "Changes to " + currRestrictionLayer.name() + " failed: " + str(
                                                            currRestrictionLayer.commitErrors()), QMessageBox.Ok)
                        return statusUpd
    
    
            self.updateTileRevisionNrs(currProposalID)
    
            return statusUpd
        """

    def updateTileRevisionNrs(self, currProposalID):
        TOMsMessageLog.logMessage("In updateTileRevisionNrs.", level=Qgis.Info)
        # Increment the relevant tile numbers
        tileProposal = TOMsProposal(self.proposalsManager, currProposalID)

        # currRevisionDate = self.proposalsManager.getProposalOpenDate(currProposalID)
        currRevisionDate = tileProposal.getProposalOpenDate()

        MapGridLayer = self.tableNames.setLayer("MapGrid")
        TilesInAcceptedProposalsLayer = self.tableNames.setLayer("TilesInAcceptedProposals")

        # self.getProposalTileList(currProposalID, currRevisionDate)

        dictTilesInProposal = tileProposal.getProposalTileDictionaryForDate(currRevisionDate)
        currTile = TOMsTile(self.proposalsManager)
        for tileNr, tile in dictTilesInProposal.items():
            status = currTile.setTile(tileNr)
            tileUpdateStatus = currTile.updateTileRevisionNr()


        proposalTileListForDate = self.getProposalTileListForDate(currRevisionDate)

        for tile in proposalTileListForDate:

            #  TODO: Create a tile object and have increment method ...

            currRevisionNr = tile["RevisionNr"]
            TOMsMessageLog.logMessage("In updateTileRevisionNrs. tile" + str (tile["id"]) + " currRevNr: " + str(currRevisionNr), level=Qgis.Info)
            if currRevisionNr is None:
                MapGridLayer.changeAttributeValue(tile.id(),MapGridLayer.fields().indexFromName("RevisionNr"), 1)
            else:
                MapGridLayer.changeAttributeValue(tile.id(), MapGridLayer.fields().indexFromName("RevisionNr"), currRevisionNr + 1)
                MapGridLayer.changeAttributeValue(tile.id(), MapGridLayer.fields().indexFromName("LastRevisionDate"), currRevisionDate)

            # Now need to add the details of this tile to "TilesWithinAcceptedProposals" (including revision numbers at time of acceptance)

            newRecord = QgsFeature(TilesInAcceptedProposalsLayer.fields())

            idxProposalID = TilesInAcceptedProposalsLayer.fields().indexFromName("ProposalID")
            idxTileNr = TilesInAcceptedProposalsLayer.fields().indexFromName("TileNr")
            idxRevisionNr = TilesInAcceptedProposalsLayer.fields().indexFromName("RevisionNr")

            newRecord[idxProposalID]= currProposalID
            newRecord[idxTileNr]= tile["id"]
            newRecord[idxRevisionNr]= currRevisionNr + 1
            newRecord.setGeometry(QgsGeometry())

            status = TilesInAcceptedProposalsLayer.addFeature(newRecord)

            # TODO: Check return status from add

    def getProposalTileList(self, listProposalID, currRevisionDate):

        # returns list of tiles in the proposal and their current revision numbers
        TOMsMessageLog.logMessage("In getProposalTileList. consider Proposal: " + str (listProposalID), level=Qgis.Info)
        self.tileSet = set()

        # Logic is:
        #Loop through each map tile
        #    Check whether or not there are any currently open restrictions within it

        self.RestrictionsInProposals = self.tableNames.setLayer("RestrictionsInProposals")
        self.RestrictionLayers = self.tableNames.setLayer("RestrictionLayers")
        self.tileLayer = self.tableNames.setLayer("MapGrid")

        """if QgsProject.instance().mapLayersByName("RestrictionsInProposals"):
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
            return"""

        currProposalID = self.proposalsManager.currentProposal()

        if listProposalID > 0:  # need to consider a proposal

           # loop through all the layers that might have restrictions

            listRestrictionLayers = self.RestrictionLayers.getFeatures()
            # listRestrictionLayers2 = self.tableNames.RESTRICTIONLAYERS.getFeatures()

            firstRestriction = True

            self.proposalsManager.clearRestrictionFilters()

            for currLayerDetails in listRestrictionLayers:

                # get the layer from the name

                currLayerID = currLayerDetails["Code"]
                currLayerName = currLayerDetails["RestrictionLayerName"]
                TOMsMessageLog.logMessage(
                    "In getProposalTileList. Considering layer: " + currLayerDetails["RestrictionLayerName"],
                    level=Qgis.Info)

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
                                """TOMsMessageLog.logMessage(
                                    "In getProposalTileList. A restrictionsString: " + restrictionsString,
                                    level=Qgis.Info)"""
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

            TOMsMessageLog.logMessage("In getTileRevisionNr: queryString: " + str(queryString), level=Qgis.Info)

            expr = QgsExpression(queryString)

            for tile in self.tileLayer.getFeatures(QgsFeatureRequest(expr)):

                TOMsMessageLog.logMessage("In getProposalTileList (after fetch): " + str(tile["id"]) + " RevisionNr: " + str(
                    tile["RevisionNr"]) + " RevisionDate: " + str(tile["LastRevisionDate"]), level=Qgis.Info)

                currRevisionNr = tile["RevisionNr"]
                currLastRevisionDate = tile["LastRevisionDate"]

                currTileNr = tile.attribute("id")

                revisionNr, revisionDate = self.getTileRevisionNrAtDate(currTileNr, currRevisionDate)

                TOMsMessageLog.logMessage(
                    "In getProposalTileList (after getTileRevisionNrAtDate): " + str(tile["id"]) + " RevisionNr: " + str(
                        revisionNr) + " RevisionDate: " + str(revisionDate), level=Qgis.Info)

                if revisionNr >= 0:
                    if revisionNr != tile.attribute("RevisionNr"):
                        tile.setAttribute("RevisionNr", revisionNr)
                    if revisionDate != tile.attribute("LastRevisionDate"):
                        tile.setAttribute("LastRevisionDate", revisionDate)

                    TOMsMessageLog.logMessage("In getProposalTileList (before write): " + str(tile["id"]) + " RevisionNr: " + str(
                            tile["RevisionNr"]) + " RevisionDate: " + str(tile["LastRevisionDate"]), level=Qgis.Info)

                self.tileSet.add((tile))

        TOMsMessageLog.logMessage("In getProposalTileList: finished adding ... ", level=Qgis.Info)

        for tile in self.tileSet:
            TOMsMessageLog.logMessage("In getProposalTileList: " + str(tile["id"]) + " RevisionNr: " + str(tile["RevisionNr"]) + " RevisionDate: " + str(tile["LastRevisionDate"]), level=Qgis.Info)

        #sorted(list(set(output)))
        #return self.tileList

    """def getProposalTitle(self, proposalID):
        # return the layer given the row in "RestrictionLayers"
        TOMsMessageLog.logMessage("In getProposalTitle.", level=Qgis.Info)

        #query2 = '"RestrictionID" = \'{restrictionid}\''.format(restrictionid=currRestrictionID)
        idxProposalTitle = self.Proposals.fields().indexFromName("ProposalTitle")
        idxProposalOpenDate = self.Proposals.fields().indexFromName("ProposalOpenDate")
        queryString = "\"ProposalID\" = " + str(proposalID)

        TOMsMessageLog.logMessage("In getRestriction: queryString: " + str(queryString), level=Qgis.Info)

        expr = QgsExpression(queryString)

        for feature in self.Proposals.getFeatures(QgsFeatureRequest(expr)):
            return feature[idxProposalTitle], feature[idxProposalOpenDate]

        TOMsMessageLog.logMessage("In getProposalTitle: Proposal not found", level=Qgis.Info)
        return None, None"""

    def getTilesForRestriction(self, currRestriction, filterDate):

        # get the tile(s) for a given restriction

        TOMsMessageLog.logMessage("In getTileForRestriction. ", level=Qgis.Info)

        #a.geometry().intersects(f.geometry()):

        #queryString2 = # bounding box of restriction
        idxTileID = self.tableNames.setLayer("MapGrid").fields().indexFromName("id")

        for tile in self.tileLayer.getFeatures(QgsFeatureRequest().setFilterRect(currRestriction.geometry().boundingBox())):

            if tile.geometry().intersects(currRestriction.geometry()):
                # get revision number and add tile to list
                #currRevisionNrForTile = self.getTileRevisionNr(tile)
                TOMsMessageLog.logMessage("In getTileForRestriction. Tile: " + str(tile.attribute("id")) + "; " + str(tile.attribute("RevisionNr")) + "; " + str(tile.attribute("LastRevisionDate")), level=Qgis.Info)

                # check revision nr, etc
                currTileNr = tile.attribute("id")
                revisionNr, revisionDate = self.getTileRevisionNrAtDate(currTileNr, filterDate)

                if revisionNr:

                    if revisionNr != tile.attribute("RevisionNr"):
                        tile.setAttribute("RevisionNr", revisionNr)
                    if revisionDate != tile.attribute("LastRevisionDate"):
                        tile.setAttribute("LastRevisionDate", revisionDate)

                        """TOMsMessageLog.logMessage(
                            "In getTileForRestriction. revised details: " + str(revisionNr) + "; " + str(revisionDate),
                            level=Qgis.Info)"""

                else:

                    # if there is no RevisionNr for the tile, set it to 0. This should only be the case for proposals.

                    tile.setAttribute("RevisionNr", 0)

                #idxRevisionNr = self.tableNames.TILES_IN_ACCEPTED_PROPOSALS.fields().indexFromName("RevisionNr")

                TOMsMessageLog.logMessage(
                            "In getTileForRestriction: Tile: " + str(tile.attribute("id")) + "; " + str(
                                tile.attribute("RevisionNr")) + "; " + str(tile.attribute("LastRevisionDate")) + "; " + str(idxTileID),
                            level=Qgis.Info)

                #self.tileSet.add((tile))
                #self.addFeatureToSet(self.tileSet, tile, self.tableNames.MAP_GRID.fields().indexFromName("id"))

                if self.checkFeatureInSet(self.tileSet, tile, self.tableNames.setLayer("MapGrid").fields().indexFromName("id")) == False:
                    TOMsMessageLog.logMessage(
                        "In addFeatureToSet. Adding: " + str(currTileNr) + " ; " + str(len(self.tileSet)),
                        level=Qgis.Info)
                    self.tileSet.add((tile))

                TOMsMessageLog.logMessage(
                            "In getTileForRestriction. len tileSet: " + str(len(self.tileSet)),
                            level=Qgis.Info)

                pass

        pass

    def checkFeatureInSet(self, featureSet, currFeature, idxValue):

        """TOMsMessageLog.logMessage(
            "In checkFeatureInSet. ", level=Qgis.Info)"""

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
        TOMsMessageLog.logMessage("In getRestriction.", level=Qgis.Info)

        #query2 = '"tile" = \'{tileid}\''.format(tileid=currTile)

        queryString = "\"id\" = " + + str(currTile.attribute("id"))

        TOMsMessageLog.logMessage("In getTileRevisionNr: queryString: " + str(queryString), level=Qgis.Info)

        expr = QgsExpression(queryString)

        for feature in self.tileLayer.getFeatures(QgsFeatureRequest(expr)):
            currRevisionNr = feature["RevisionNr"]
            return currRevisionNr

        TOMsMessageLog.logMessage("In getTileRevisionNr: tile not found", level=Qgis.Info)
        return None

    def getTileRevisionNrAtDate(self, tileNr, filterDate):
        # return the revision number for the tile
        TOMsMessageLog.logMessage("In getTileRevisionNrAtDate.", level=Qgis.Info)

        #query2 = '"tile" = \'{tileid}\''.format(tileid=currTile)

        queryString = "\"TileNr\" = " + str(tileNr)

        TOMsMessageLog.logMessage("In getTileRevisionNrAtDate: queryString: " + str(queryString), level=Qgis.Info)

        expr = QgsExpression(queryString)

        """request = QgsFeatureRequest().setFlags(QgsFeatureRequest.NoGeometry)

        request.setFilterExpression(
                u"\"TileNr\" = {1}".format(str(currTile.attribute("id"))))"""

        # Grab the results from the layer
        features = self.tableNames.setLayer("TilesInAcceptedProposals").getFeatures(QgsFeatureRequest(expr))
        tileProposal = TOMsProposal(self)

        for feature in sorted(features, key=lambda f: f[2], reverse=True):
            lastProposalID = feature["ProposalID"]
            lastRevisionNr = feature["RevisionNr"]
            #return currRevisionNr
            #lastProposalTitle, lastProposalOpendate = self.getProposalTitle(lastProposalID)
            tileProposal.setProposal(lastProposalID)

            #lastProposalOpendate = self.proposalsManager.getProposalOpenDate(lastProposalID)
            lastProposalOpendate = tileProposal.getProposalOpenDate()

            TOMsMessageLog.logMessage(
                "In getTileRevisionNrAtDate: last Proposal: " + str(lastProposalID) + "; " + str(lastRevisionNr),
                level=Qgis.Info)

            TOMsMessageLog.logMessage(
                "In getTileRevisionNrAtDate: last Proposal open date: " + str(lastProposalOpendate) + "; filter date: " + str(filterDate),
                level=Qgis.Info)

            if lastProposalOpendate <= filterDate:
                TOMsMessageLog.logMessage(
                    "In getTileRevisionNrAtDate: using Proposal: " + str(lastProposalID) + "; " + str(lastRevisionNr),
                    level=Qgis.Info)
                return lastRevisionNr, lastProposalOpendate

        return None, None

    def rejectProposal(self, currProposalID):
        TOMsMessageLog.logMessage("In rejectProposal.", level=Qgis.Info)

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

    def getLookupDescription(self, lookupLayer, code):

        #TOMsMessageLog.logMessage("In getLookupDescription", level=Qgis.Info)

        query = "\"Code\" = " + str(code)
        request = QgsFeatureRequest().setFilterExpression(query)

        #TOMsMessageLog.logMessage("In getLookupDescription. queryStatus: " + str(query), level=Qgis.Info)

        for row in lookupLayer.getFeatures(request):
            #TOMsMessageLog.logMessage("In getLookupDescription: found row " + str(row.attribute("Description")), level=Qgis.Info)
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

        TOMsMessageLog.logMessage("In prepareRestrictionForEdit",
                                 level=Qgis.Info)

        # if required, clone the current restriction and enter details into "RestrictionsInProposals" table

        newFeature = currRestriction

        idxRestrictionID = currRestrictionLayer.fields().indexFromName("RestrictionID")

        if not self.restrictionInProposal(currRestriction[idxRestrictionID], self.getRestrictionLayerTableID(currRestrictionLayer), self.proposalsManager.currentProposal()):
            TOMsMessageLog.logMessage("In prepareRestrictionForEdit - adding details to RestrictionsInProposal", level=Qgis.Info)
            #  This one is not in the current Proposal, so now we need to:
            #  - generate a new ID and assign it to the feature for which the geometry has changed
            #  - switch the geometries arround so that the original feature has the original geometry and the new feature has the new geometry
            #  - add the details to RestrictionsInProposal

            newFeature = self.cloneRestriction(currRestriction, currRestrictionLayer)

            # Check to see if the feature is added
            TOMsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - feature exists in layer - " + newFeature.attribute("RestrictionID"), level=Qgis.Info)

            # Add details to "RestrictionsInProposals"

            self.addRestrictionToProposal(currRestriction[idxRestrictionID],
                                          self.getRestrictionLayerTableID(currRestrictionLayer),
                                          self.proposalsManager.currentProposal(),
                                          RestrictionAction.OPEN)  # close the original feature
            TOMsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - feature closed.", level=Qgis.Info)

            self.addRestrictionToProposal(newFeature[idxRestrictionID], self.getRestrictionLayerTableID(currRestrictionLayer),
                                          self.proposalsManager.currentProposal(),
                                          RestrictionAction.OPEN)  # open the new one
            TOMsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - feature opened.", level=Qgis.Info)


        else:

            TOMsMessageLog.logMessage("In TOMsNodeTool:init - restriction exists in RestrictionsInProposal", level=Qgis.Info)
            #newFeature = currRestriction

        # test to see if the geometry is correct
        #self.restrictionTransaction.commitTransactionGroup(self.origLayer)

        return newFeature

    def onFeatureAdded(self, fid):
        TOMsMessageLog.logMessage("In onFeatureAdded - newFid: " + str(fid),
                                 level=Qgis.Info)
        self.newFid = fid

    def cloneRestriction(self, originalFeature, restrictionLayer):

        TOMsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction",
                                 level=Qgis.Info)
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

        restrictionLayer.featureAdded.disconnect(self.onFeatureAdded)

        restrictionLayer.updateExtents()
        restrictionLayer.updateFields()

        TOMsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - addStatus: " + str(addStatus) + " featureID: " + str(self.newFid), #+ " geomStatus: " + str(geomStatus),
                                 level=Qgis.Info)

        TOMsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - attributes: (fid=" + str(newFeature.id()) + ") " + str(newFeature.attributes()),
                                 level=Qgis.Info)

        TOMsMessageLog.logMessage("In TOMsNodeTool:cloneRestriction - newGeom: " + newFeature.geometry().asWkt(),
                                 level=Qgis.Info)

        # test to see that feature has been added ...
        feat = restrictionLayer.getFeatures(
            QgsFeatureRequest().setFilterExpression('GeometryID = \'{}\''.format(newFeature['GeometryID']))).next()

        return newFeature

