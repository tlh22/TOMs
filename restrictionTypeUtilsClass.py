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
    QDockWidget,
    QPushButton
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
from pathlib import Path

from .constants import (
    ProposalStatus,
    RestrictionAction
)

from .generateGeometryUtils import generateGeometryUtils
#from core.proposalsManager import *
from .core import (TOMsProposal, TOMsTile)
from .core.TOMsTransaction import (TOMsTransaction)
from TOMs.ui.TOMsCamera import (formCamera)
from abc import ABCMeta
import datetime
import uuid

try:
    import cv2
    cv2_available = True
except ImportError:
    print('cv2 not available ...')
    QgsMessageLog.logMessage("Not able to import cv2 ...", tag="TOMs panel")
    cv2_available = False

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
                          "TOMsDebugLevel",
                          "AllowZoneEditing"
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

            try:
                formPath = os.environ.get('QGIS_FIELD_FORM_PATH')
            except:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Project not yet open"))
                formPath = None

            TOMsMessageLog.logMessage("In TOMsLayers:getLayers. QGIS_FIELD_FORM_PATH: {}".format(formPath), level=Qgis.Info)

            if not formPath:
                TOMsMessageLog.logMessage("In TOMsLayers:getLayers. QGIS_FIELD_FORM_PATH not found ...", level=Qgis.Warning)

            for layer in self.TOMsLayerList:
                if QgsProject.instance().mapLayersByName(layer):
                    self.TOMsLayerDict[layer] = QgsProject.instance().mapLayersByName(layer)[0]
                    # set paths for forms
                    layerEditFormConfig = self.TOMsLayerDict[layer].editFormConfig()
                    ui_path = layerEditFormConfig.uiForm()
                    TOMsMessageLog.logMessage("In TOMsLayers:getLayers. ui_path for layer {} is {} ...".format(layer, ui_path),
                                              level=Qgis.Info)
                    if len(formPath)>0 and len(ui_path)>0:
                        # try to get basename - doesn't seem to work on Linux
                        #base_ui_path = os.path.basename(ui_path)
                        path_absolute = os.path.abspath(os.path.join(formPath, os.path.basename(ui_path)))
                        if not os.path.isfile(path_absolute):
                            TOMsMessageLog.logMessage("In TOMsLayers:getLayers.form path not found for layer {} ...".format(layer),
                                                      level=Qgis.Warning)
                        else:
                            TOMsMessageLog.logMessage("In TOMsLayers:getLayers.setting new path for form {} ...".format(path_absolute),
                                                      level=Qgis.Info)
                            layerEditFormConfig.setUiForm(path_absolute)
                            self.TOMsLayerDict[layer].setEditFormConfig(layerEditFormConfig)

                            # TODO: may need to reinstate original values here - so save them somewhere useful

                else:
                    QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table " + layer + " is not present"))
                    found = False
                    break

        # TODO: need to deal with any errors arising ...

        if found == False:
            self.TOMsLayersNotFound.emit()
            #else:
            #project = QgsProject.instance()
            #project.write()
            #self.TOMsLayersSet.emit()

        return

    def removePathFromLayerForms(self):

        TOMsMessageLog.logMessage("In TOMSLayers.removePathFromLayerForms ...", level=Qgis.Info)
        found = True

        # Check for project being open
        project = QgsProject.instance()

        if len(project.fileName()) == 0:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Project not yet open"))
            found = False

        else:

            try:
                formPath = os.environ.get('QGIS_FIELD_FORM_PATH')
            except:
                formPath = None

            for layer in self.TOMsLayerList:
                if QgsProject.instance().mapLayersByName(layer):
                    self.TOMsLayerDict[layer] = QgsProject.instance().mapLayersByName(layer)[0]
                    # set paths for forms
                    layerEditFormConfig = self.TOMsLayerDict[layer].editFormConfig()
                    ui_path = layerEditFormConfig.uiForm()
                    TOMsMessageLog.logMessage("In TOMsLayers:removePathFromLayerForms. ui_path for layer {} is {} ...".format(layer, ui_path),
                                              level=Qgis.Info)
                    if len(formPath)>0 and len(ui_path)>0:
                        # try to get basename - doesn't seem to work on Linux
                        #base_ui_path = os.path.basename(ui_path)
                        formName = os.path.basename(ui_path)
                        layerEditFormConfig.setUiForm(formName)
                        self.TOMsLayerDict[layer].setEditFormConfig(layerEditFormConfig)

                else:
                    QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table " + layer + " is not present"))
                    found = False
                    break

            #project = QgsProject.instance()
            #project.write()

            # TODO: need to deal with any errors arising ...

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

        self.cameraNr = None

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

        self.proposalPanel = self.iface.mainWindow().findChild(QDockWidget, 'ProposalPanelDockWidgetBase')

        self.setupPanelTabs(self.iface, self.proposalPanel)

    def setDefaultRestrictionDetails(self, currRestriction, currRestrictionLayer, currDate):
        TOMsMessageLog.logMessage("In setDefaultRestrictionDetails: ", level=Qgis.Info)

        generateGeometryUtils.setRoadName(currRestriction)
        if currRestrictionLayer.geometryType() == 1:  # Line or Bay
            generateGeometryUtils.setAzimuthToRoadCentreLine(currRestriction)
            #currRestriction.setAttribute("RestrictionLength", currRestriction.geometry().length())

        currentCPZ, cpzWaitingTimeID = generateGeometryUtils.getCurrentCPZDetails(currRestriction)

        if currRestrictionLayer.name() != "Signs":
            currRestriction.setAttribute("CPZ", currentCPZ)

        # TODO: get the last used values ... look at field ...

        if currRestrictionLayer.name() == "Lines":
            currRestriction.setAttribute("RestrictionTypeID", 224)  # 10 = SYL (Lines)
            currRestriction.setAttribute("GeomShapeID", 10)   # 10 = Parallel Line
            currRestriction.setAttribute("NoWaitingTimeID", cpzWaitingTimeID)
            #currRestriction.setAttribute("Lines_DateTime", currDate)

        elif currRestrictionLayer.name() == "Bays":
            currRestriction.setAttribute("RestrictionTypeID", 101)  # 28 = Permit Holders Bays (Bays)
            currRestriction.setAttribute("GeomShapeID", 21)   # 21 = Parallel Bay (Polygon)
            currRestriction.setAttribute("NrBays", -1)

            currRestriction.setAttribute("TimePeriodID", cpzWaitingTimeID)
            currRestriction.setAttribute("MatchDayTimePeriodID", cpzMatchDayTimePeriodID)

            currentPTA, ptaMaxStayID, ptaNoReturnID = generateGeometryUtils.getCurrentPTADetails(currRestriction)

            currRestriction.setAttribute("MaxStayID", ptaMaxStayID)
            currRestriction.setAttribute("NoReturnID", ptaNoReturnID)
            currRestriction.setAttribute("ParkingTariffArea", currentPTA)

        elif currRestrictionLayer.name() == "Signs":
            currRestriction.setAttribute("SignType_1", 28)  # 28 = Permit Holders Only (Signs)

        elif currRestrictionLayer.name() == "RestrictionPolygons":
            currRestriction.setAttribute("RestrictionTypeID", 4)  # 28 = Residential mews area (RestrictionPolygons)
            currRestriction.setAttribute("MatchDayTimePeriodID", cpzMatchDayTimePeriodID)

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

    def setupRestrictionDialog(self, restrictionDialog, currRestrictionLayer, currRestriction, restrictionTransaction):

        # Create a copy of the feature
        self.origFeature = originalFeature()
        self.origFeature.setFeature(currRestriction)

        if restrictionDialog is None:
            TOMsMessageLog.logMessage(
                "In setupRestrictionDialog. dialog not found",
                level=Qgis.Warning)

        button_box = restrictionDialog.findChild(QDialogButtonBox, "button_box")

        if button_box is None:
            TOMsMessageLog.logMessage(
                "In setupRestrictionDialog. button box not found",
                level=Qgis.Warning)

        button_box.accepted.connect(functools.partial(self.onSaveRestrictionDetails, currRestriction,
                                      currRestrictionLayer, restrictionDialog, restrictionTransaction))

        restrictionDialog.attributeForm().attributeChanged.connect(functools.partial(self.onAttributeChangedClass2, currRestriction, currRestrictionLayer))

        button_box.rejected.connect(functools.partial(self.onRejectRestrictionDetailsFromForm, restrictionDialog, restrictionTransaction))

        self.photoDetails(restrictionDialog, currRestrictionLayer, currRestriction)

    def onRejectRestrictionDetailsFromForm(self, restrictionDialog, restrictionTransaction):
        TOMsMessageLog.logMessage("In onRejectRestrictionDetailsFromForm", level=Qgis.Info)
        restrictionDialog.reject()
        
        restrictionTransaction.rollBackTransactionGroup()

        self.proposalPanel = self.iface.mainWindow().findChild(QDockWidget, 'ProposalPanelDockWidgetBase')

        self.setupPanelTabs(self.iface, self.proposalPanel)

    def onAttributeChangedClass2(self, currFeature, layer, fieldName, value):
        TOMsMessageLog.logMessage(
            "In FormOpen:onAttributeChangedClass 2 - layer: " + str(layer.name()) + " (" + fieldName + "): " + str(value), level=Qgis.Info)

        try:

            currFeature[layer.fields().indexFromName(fieldName)] = value

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

        # sort out path for Photos
        photoPath = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('PhotoPath')
        if photoPath == None:
            reply = QMessageBox.information(None, "Information", "Please set value for PhotoPath.", QMessageBox.Ok)
            return

        if os.path.isabs(photoPath):
            path_absolute = photoPath
        else:
            projectPath = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('project_path')
            path_absolute = os.path.abspath(os.path.join(projectPath, photoPath))

        TOMsMessageLog.logMessage("In photoDetails. path_absolute: {}".format(path_absolute), level=Qgis.Warning)
        # check that the path exists
        if not os.path.isdir(path_absolute):
            reply = QMessageBox.information(None, "Information", "Please set value for PhotoPath.", QMessageBox.Ok)
            return

        idx1 = currRestLayer.fields().indexFromName("Photos_01")
        idx2 = currRestLayer.fields().indexFromName("Photos_02")
        idx3 = currRestLayer.fields().indexFromName("Photos_03")

        TOMsMessageLog.logMessage("In photoDetails. idx1: " + str(idx1) + "; " + str(idx2) + "; " + str(idx3),
                                 level=Qgis.Info)

        if FIELD1:
            TOMsMessageLog.logMessage("In photoDetails. FIELD 1 exisits",
                                     level=Qgis.Info)
            if currRestrictionFeature[idx1]:
                newPhotoFileName1 = os.path.join(path_absolute, currRestrictionFeature[idx1])
            else:
                newPhotoFileName1 = None

            TOMsMessageLog.logMessage("In photoDetails. A. Photo1: " + str(newPhotoFileName1), level=Qgis.Warning)
            pixmap1 = QPixmap(newPhotoFileName1)
            if not pixmap1.isNull():
                FIELD1.setPixmap(pixmap1)
                FIELD1.setScaledContents(True)
                TOMsMessageLog.logMessage("In photoDetails. Photo1: " + str(newPhotoFileName1), level=Qgis.Warning)

            if cv2_available:
                try:
                    START_CAMERA_1 = dialog.findChild(QPushButton, "startCamera1")
                    TAKE_PHOTO_1 = dialog.findChild(QPushButton, "getPhoto1")
                    TAKE_PHOTO_1.setEnabled(False)

                    self.camera1 = formCamera(path_absolute, newPhotoFileName1, self.cameraNr)
                    START_CAMERA_1.clicked.connect(
                        functools.partial(self.camera1.useCamera, START_CAMERA_1, TAKE_PHOTO_1, FIELD1))
                    self.camera1.notifyPhotoTaken.connect(functools.partial(self.savePhotoTaken, idx1))
                except Exception as e:
                    TOMsMessageLog.logMessage('photoDetails: issue for photo form {}'.format(e), level=Qgis.Info)

        if FIELD2:
            TOMsMessageLog.logMessage("In photoDetails. FIELD 2 exisits",
                                     level=Qgis.Info)
            if currRestrictionFeature[idx2]:
                newPhotoFileName2 = os.path.join(path_absolute, currRestrictionFeature[idx2])
            else:
                newPhotoFileName2 = None

            TOMsMessageLog.logMessage("In photoDetails. A. Photo2: " + str(newPhotoFileName2), level=Qgis.Warning)
            pixmap2 = QPixmap(newPhotoFileName2)
            if not pixmap2.isNull():
                FIELD2.setPixmap(pixmap2)
                FIELD2.setScaledContents(True)
                TOMsMessageLog.logMessage("In photoDetails. Photo2: " + str(newPhotoFileName2), level=Qgis.Warning)

            if cv2_available:
                try:
                    START_CAMERA_2 = dialog.findChild(QPushButton, "startCamera2")
                    TAKE_PHOTO_2 = dialog.findChild(QPushButton, "getPhoto2")
                    TAKE_PHOTO_2.setEnabled(False)

                    self.camera2 = formCamera(path_absolute, newPhotoFileName2, self.cameraNr)
                    START_CAMERA_2.clicked.connect(
                        functools.partial(self.camera2.useCamera, START_CAMERA_2, TAKE_PHOTO_2, FIELD2))
                    self.camera2.notifyPhotoTaken.connect(functools.partial(self.savePhotoTaken, idx2))
                except Exception as e:
                    TOMsMessageLog.logMessage('photoDetails: issue for photo form {}'.format(e), level=Qgis.Info)

        if FIELD3:
            TOMsMessageLog.logMessage("In photoDetails. FIELD 3 exisits",
                                     level=Qgis.Info)
            if currRestrictionFeature[idx3]:
                newPhotoFileName3 = os.path.join(path_absolute, currRestrictionFeature[idx3])
            else:
                newPhotoFileName3 = None

            pixmap3 = QPixmap(newPhotoFileName3)
            if not pixmap3.isNull():
                FIELD3.setPixmap(pixmap3)
                FIELD3.setScaledContents(True)
                TOMsMessageLog.logMessage("In photoDetails. Photo3: " + str(newPhotoFileName3), level=Qgis.Warning)

            if cv2_available:
                try:
                    START_CAMERA_3 = dialog.findChild(QPushButton, "startCamera3")
                    TAKE_PHOTO_3 = dialog.findChild(QPushButton, "getPhoto3")
                    TAKE_PHOTO_3.setEnabled(False)

                    self.camera3 = formCamera(path_absolute, newPhotoFileName3, self.cameraNr)
                    START_CAMERA_3.clicked.connect(
                        functools.partial(self.camera3.useCamera, START_CAMERA_3, TAKE_PHOTO_3, FIELD3))
                    self.camera3.notifyPhotoTaken.connect(functools.partial(self.savePhotoTaken, idx3))
                except Exception as e:
                    TOMsMessageLog.logMessage('photoDetails: issue for photo form {}'.format(e), level=Qgis.Info)

    def photoDetails_camera(self, restrictionDialog, currRestrictionLayer, currRestriction):

        # if cv2 is available, check camera nr
        try:
            self.cameraNr = int(QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('CameraNr'))
        except Exception as e:
            TOMsMessageLog.logMessage("In photoDetails_camera: cameraNr issue: {}".format(e), level=Qgis.Warning)
            if cv2_available:
                self.cameraNr = QMessageBox.information(None, "Information", "Please set value for CameraNr.", QMessageBox.Ok)
            self.cameraNr = None

        TOMsMessageLog.logMessage("In photoDetails_field: cameraNr is: {}".format(self.cameraNr), level=Qgis.Info)

        self.photoDetails(restrictionDialog, currRestrictionLayer, currRestriction)

    def onSaveProposalFormDetails(self, currProposalRecord, currProposalObject, proposalsLayer, proposalsDialog, proposalTransaction):
        TOMsMessageLog.logMessage("In onSaveProposalFormDetails.", level=Qgis.Info)

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

        newProposal = False
        proposalAcceptedRejected = False

        if newProposalStatusID == ProposalStatus.ACCEPTED:  # 2 = accepted
            #if currProposal[idxProposalStatusID] == ProposalStatus.ACCEPTED:  # 2 = accepted

            reply = QMessageBox.question(None, 'Confirm changes to Proposal',
                                         # How do you access the main window to make the popup ???
                                         'Do you want to ACCEPT this proposal?. Accepting will make all the proposed changes permanent.',
                                         QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:

                currProposalObject.setProposalOpenDate(newProposalOpenDate)

                if not currProposalObject.acceptProposal():
                    proposalTransaction.rollBackTransactionGroup()
                    proposalsDialog.reject()
                    reply = QMessageBox.information(None, "Error", "Error in accepting proposal ...",
                                                    QMessageBox.Ok)
                    TOMsMessageLog.logMessage(
                        "In onSaveProposalFormDetails. Error in transaction", level=Qgis.Info)
                    return

                updateStatus = proposalsDialog.attributeForm().save()
                status = proposalsDialog.close()
                proposalAcceptedRejected = True

            else:
                proposalsDialog.reject()

        elif currProposalStatusID == ProposalStatus.REJECTED:  # 3 = rejected

            reply = QMessageBox.question(None, 'Confirm changes to Proposal',
                                         # How do you access the main window to make the popup ???
                                         'Do you want to REJECT this proposal?. This will remove it from the Proposal list (although it will remain in the system).',
                                         QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:

                if not currProposalObject.rejectProposal():
                    proposalTransaction.rollBackTransactionGroup()
                    proposalsDialog.reject()
                    TOMsMessageLog.logMessage(
                        "In onSaveProposalFormDetails. Error in transaction", level=Qgis.Info)
                    return

                updateStatus = proposalsDialog.attributeForm().save()
                status = proposalsDialog.close()
                proposalAcceptedRejected = True

            else:
                proposalsDialog.reject()

        else:

            TOMsMessageLog.logMessage(
                "In onSaveProposalFormDetails. currProposalID = " + str(currProposalID),
                level=Qgis.Info)
            updateStatus = proposalsDialog.attributeForm().save()

            # anything else can be saved.
            if currProposalID == 0:  # We should not be here if this is the current proposal ... 0 is place holder ...

                # This is a new proposal ...

                newProposal = True
                TOMsMessageLog.logMessage(
                    "In onSaveProposalFormDetails. New Proposal ... ", level=Qgis.Info)

            else:
                pass
                # self.Proposals.updateFeature(currProposalObject.getProposalRecord())  # TH (added for v3)

            proposalsDialog.reject()

            TOMsMessageLog.logMessage(
                "In onSaveProposalFormDetails. ProposalTransaction modified Status: " + str(
                    proposalTransaction.currTransactionGroup.modified()),
            level=Qgis.Info)

        TOMsMessageLog.logMessage("In onSaveProposalFormDetails. Before save. " + str(currProposalTitle) + " Status: " + str(currProposalStatusID), level=Qgis.Info)

        # Trying to unset map tool to force updates ...
        #self.iface.mapCanvas().unsetMapTool(self.iface.mapCanvas().mapTool())

        proposalTransaction.commitTransactionGroup(self.Proposals)

        status = proposalsDialog.close()

        # For some reason the committedFeaturesAdded signal for layer "Proposals" is not firing at this point and so the cbProposals is not refreshing ...

        if newProposal == True:
            TOMsMessageLog.logMessage("In onSaveProposalFormDetails. newProposalID = " + str(currProposalID), level=Qgis.Info)

            for proposal in self.Proposals.getFeatures():
                if proposal[idxProposalTitle] == currProposalTitle:
                    TOMsMessageLog.logMessage("In onSaveProposalFormDetails. newProposalID = " + str(proposal.id()),
                                             level=Qgis.Info)
                    newProposalID = proposal[idxProposalID]

            self.proposalsManager.newProposalCreated.emit(newProposalID)

        elif proposalAcceptedRejected:
            # refresh the cbProposals and set current Proposal to 0
            self.createProposalcb()
            self.proposalsManager.setCurrentProposal(0)

        else:

            self.proposalsManager.newProposalCreated.emit(currProposalID)

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

    def getLookupDescription(self, lookupLayer, code):

        #TOMsMessageLog.logMessage("In getLookupDescription", level=Qgis.Info)

        query = "\"Code\" = " + str(code)
        request = QgsFeatureRequest().setFilterExpression(query)

        #TOMsMessageLog.logMessage("In getLookupDescription. queryStatus: " + str(query), level=Qgis.Info)

        for row in lookupLayer.getFeatures(request):
            #TOMsMessageLog.logMessage("In getLookupDescription: found row " + str(row.attribute("Description")), level=Qgis.Info)
            return row.attribute("Description") # make assumption that only one row

        return None

    def getBayGeomShapeType(self, code):

        #TOMsMessageLog.logMessage("In getLookupDescription", level=Qgis.Info)

        query = "\"Code\" = " + str(code)
        request = QgsFeatureRequest().setFilterExpression(query)

        #TOMsMessageLog.logMessage("In getLookupDescription. queryStatus: " + str(query), level=Qgis.Info)

        bayTypesInUse = self.TOMsLayers.setLayer('BayTypesInUse')
        for row in bayTypesInUse.getFeatures(request):
            #TOMsMessageLog.logMessage("In getLookupDescription: found row " + str(row.attribute("Description")), level=Qgis.Info)
            return row.attribute("GeomShapeGroupType") # make assumption that only one row

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

