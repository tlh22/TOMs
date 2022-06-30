# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# -----------------------------------------------------------
# Tim Hancock/Matthias Kuhn 2017
# Oslandia 2022

from qgis.core import (
    Qgis,
    QgsExpressionContextUtils,
    QgsFeatureRequest,
    QgsProject,
)
from qgis.PyQt.QtCore import QDate, QObject, pyqtSignal

from ..proposalTypeUtilsClass import ProposalTypeUtilsMixin
from ..restrictionTypeUtilsClass import RestrictionTypeUtilsMixin, TOMsLayers
from .tomsMessageLog import TOMsMessageLog
from .tomsProposal import TOMsProposal
from .tomsProposalElement import ProposalElementFactory


class TOMsProposalsManager(RestrictionTypeUtilsMixin, ProposalTypeUtilsMixin, QObject):
    """
    Manages what is currently shown to the user.

     - Current date
     - Current proposal
    """

    # TH: orig code has reference to iface. Need to include ***

    dateChanged = pyqtSignal()
    """Signal will be emitted, when the current date is changed"""
    proposalChanged = pyqtSignal()
    """Signal will be emitted when the current proposal is changed"""
    proposal = newProposalCreated = pyqtSignal(int)
    """Signal will be emitted when the current proposal is changed"""

    tomsToolChanged = pyqtSignal()
    """ signal will be emitted when TOMs tool is changed """

    tomsActivated = pyqtSignal()
    """ signal will be emitted when TOMs tools are activated"""
    # TOMsStartupFailure = pyqtSignal()
    """ signal will be emitted with there is a problem with opening TOMs - typically a layer missing """
    # TOMsSplitRestrictionSaved = pyqtSignal()

    def __init__(self, iface):

        QObject.__init__(self)
        # ProposalTypeUtilsMixin.__init__(self)

        self.iface = iface
        self.tableNames = TOMsLayers(self.iface)
        # self.tableNames.TOMsLayersSet.connect(self.setRestrictionLayers)

        self.__date = QDate.currentDate()  # pylint: disable=invalid-name
        self.currProposalFeature = None

        self.canvas = self.iface.mapCanvas()

        self.currProposalObject = TOMsProposal(self)

        self.setTOMsActivated: int = False

    def date(self):
        """
        Get access to the current date
        """
        return self.__date

    def setDate(self, value):
        """
        Set the current date
        """
        TOMsMessageLog.logMessage(
            "Current date changed to {date}".format(date=value.toString("dd/MM/yyyy")),
            level=Qgis.Info,
        )
        self.__date = value
        self.dateChanged.emit()
        self.updateMapCanvas()

    def currentProposal(self):
        """
        Returns the current proposal
        """
        currProposal = QgsExpressionContextUtils.projectScope(
            QgsProject.instance()
        ).variable("CurrentProposal")
        if not currProposal:
            currProposal = 0
        return int(currProposal)

    def currentProposalObject(self):
        """
        Returns the current proposal object
        """
        return self.currProposalObject

    def cloneCurrentProposal(self):
        """
        Returns clone of current proposal object
        """
        return TOMsProposal(self, self.currentProposal)

    def setCurrentProposal(self, value):
        """
        Set the current proposal
        """
        TOMsMessageLog.logMessage(
            "Current proposal changed to {proposal_id}".format(proposal_id=value),
            level=Qgis.Info,
        )
        QgsExpressionContextUtils.setProjectVariable(
            QgsProject.instance(), "CurrentProposal", value
        )

        self.currProposalObject.setProposal(self.currentProposal())

        self.proposalChanged.emit()
        self.updateMapCanvas()

        box = self.currProposalObject.getProposalBoundingBox()
        if not box.isNull():
            self.canvas.setExtent(box)

    def __queryStringForCurrentRestrictions(
        self, filterDate=None
    ):  # pylint: disable=invalid-name

        if filterDate is None:
            filterDate = self.__date()

        dateString = filterDate.toString("dd-MM-yyyy")
        # currProposalID = self.currentProposal()

        dateChoosenFormatted = "'{dateString}'".format(dateString=dateString)

        # filterString = '"OpenDate" <= to_date(' + dateChoosenFormatted + ", 'dd-MM-yyyy') AND ((" + '"CloseDate" > to_date(' + dateChoosenFormatted + ", 'dd-MM-yyyy')  OR " + '"CloseDate"  IS  NULL)'

        filterString = '"OpenDate" \u003C\u003D to_date({dateChoosenFormatted}, \'dd-MM-yyyy\') AND (("CloseDate" \u003E to_date({dateChoosenFormatted}, \'dd-MM-yyyy\')  OR "CloseDate" IS NULL)'.format(
            dateChoosenFormatted=dateChoosenFormatted
        )

        return filterString

    def updateMapCanvas(self):
        """
        Whenever the current proposal or the date changes we need to update the canvas.
        """

        TOMsMessageLog.logMessage("Entering updateMapCanvas ... ", level=Qgis.Warning)

        dateString = self.__date.toString("dd-MM-yyyy")
        currProposalID = self.currentProposal()

        dateChoosenFormatted = "'{dateString}'".format(dateString=dateString)

        # filterString = '"OpenDate" <= to_date(' + dateChoosenFormatted + ", 'dd-MM-yyyy') AND ((" + '"CloseDate" > to_date(' + dateChoosenFormatted + ", 'dd-MM-yyyy')  OR " + '"CloseDate"  IS  NULL)'

        filterString = '"OpenDate" \u003C\u003D to_date({dateChoosenFormatted}, \'dd-MM-yyyy\') AND (("CloseDate" \u003E to_date({dateChoosenFormatted}, \'dd-MM-yyyy\')  OR "CloseDate" IS NULL)'.format(
            dateChoosenFormatted=dateChoosenFormatted
        )
        # if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers"):
        #     self.RestrictionLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        for (layerID, layerName) in self.getRestrictionLayersList():
            TOMsMessageLog.logMessage(
                "updateMapCanvas: Considering layer: {}".format(layerName),
                level=Qgis.Info,
            )

            layerFilterString = filterString

            if currProposalID > 0:  # need to consider a proposal

                restrictionsToClose = (
                    self.currProposalObject.getRestrictionsToCloseForLayer(layerID)
                )
                if len(restrictionsToClose) > 0:
                    layerFilterString = (
                        '{layerString} AND "RestrictionID" NOT IN ({restrictionsToClose}))'
                    ).format(
                        layerString=layerFilterString,
                        restrictionsToClose=restrictionsToClose,
                    )

                restrictionsToOpen = (
                    self.currProposalObject.getRestrictionsToOpenForLayer(layerID)
                )
                if len(restrictionsToOpen) > 0:
                    layerFilterString = (
                        ' "RestrictionID"  IN ({restrictionsToOpen}) OR ({layerString})'
                    ).format(
                        layerString=layerFilterString,
                        restrictionsToOpen=restrictionsToOpen,
                    )

                if len(restrictionsToClose) == 0:
                    layerFilterString = layerFilterString + ")"

            else:
                layerFilterString = layerFilterString + ")"

            TOMsMessageLog.logMessage(
                "In updateMapCanvas. Layer: {} Date Filter: {}".format(
                    layerName, layerFilterString
                ),
                level=Qgis.Info,
            )
            try:
                self.tableNames.setLayer(layerName).dataProvider().setSubsetString(
                    layerFilterString
                )
            except Exception as e:
                TOMsMessageLog.logMessage(
                    "updateMapCanvas: error in layer {}: {}".format(layerName, e),
                    level=Qgis.Warning,
                )
                return False

            # *** deal with labels ...
            # get the corresponding label layers
            if layerName == "Bays":
                labelLayersNames = ["Bays.label_pos", "Bays.label_ldr"]
            if layerName == "Lines":
                labelLayersNames = [
                    "Lines.label_pos",
                    "Lines.label_ldr",
                    "Lines.label_loading_pos",
                    "Lines.label_loading_ldr",
                ]
            if layerName == "RestrictionPolygons":
                labelLayersNames = [
                    "RestrictionPolygons.label_pos",
                    "RestrictionPolygons.label_ldr",
                ]
            if layerName == "CPZs":
                labelLayersNames = ["CPZs.label_pos", "CPZs.label_ldr"]
            if layerName == "ParkingTariffAreas":
                labelLayersNames = [
                    "ParkingTariffAreas.label_pos",
                    "ParkingTariffAreas.label_ldr",
                ]

            # now apply the filter to the labels ...

            for labelLayersName in labelLayersNames:
                # get the label layer
                TOMsMessageLog.logMessage(
                    "updateMapCanvas: Considering layer: {}".format(labelLayersName),
                    level=Qgis.Info,
                )
                try:
                    QgsProject.instance().mapLayersByName(labelLayersName)[
                        0
                    ].dataProvider().setSubsetString(layerFilterString)
                except Exception as e:
                    TOMsMessageLog.logMessage(
                        "updateMapCanvas: error in layer {}: {}".format(
                            labelLayersName, e
                        ),
                        level=Qgis.Warning,
                    )
                    return False

        TOMsMessageLog.logMessage("Finished updateMapCanvas ... ", level=Qgis.Warning)

        return True

    def clearRestrictionFilters(self):
        # This is to be used at the close of the plugin to clear any filters that have been set

        TOMsMessageLog.logMessage(
            "Entering clearRestrictionFilters ... ", level=Qgis.Info
        )

        for (layerID, layerName) in self.getRestrictionLayersList():
            TOMsMessageLog.logMessage(
                "Clearing filter for layer: {}".format(layerName), level=Qgis.Info
            )
            try:
                self.tableNames.setLayer(layerName).dataProvider().setSubsetString(None)
            except Exception as e:
                TOMsMessageLog.logMessage(
                    "clearRestrictionFilters: error in layer {}: {}".format(
                        layerName, e
                    ),
                    level=Qgis.Warning,
                )
                return False

            # *** deal with labels ...
            # get the corresponding label layers
            if layerName == "Bays":
                labelLayersNames = ["Bays.label_pos", "Bays.label_ldr"]
            if layerName == "Lines":
                labelLayersNames = [
                    "Lines.label_pos",
                    "Lines.label_ldr",
                    "Lines.label_loading_pos",
                    "Lines.label_loading_ldr",
                ]
            if layerName == "RestrictionPolygons":
                labelLayersNames = [
                    "RestrictionPolygons.label_pos",
                    "RestrictionPolygons.label_ldr",
                ]
            if layerName == "CPZs":
                labelLayersNames = ["CPZs.label_pos", "CPZs.label_ldr"]
            if layerName == "ParkingTariffAreas":
                labelLayersNames = [
                    "ParkingTariffAreas.label_pos",
                    "ParkingTariffAreas.label_ldr",
                ]

            # now apply the filter to the labels ...

            for labelLayersName in labelLayersNames:
                # get the label layer
                TOMsMessageLog.logMessage(
                    "clearRestrictionFilters: Clearing filter for layer: {}".format(
                        labelLayersName
                    ),
                    level=Qgis.Info,
                )
                try:
                    QgsProject.instance().mapLayersByName(labelLayersName)[
                        0
                    ].dataProvider().setSubsetString(None)
                except Exception as e:
                    TOMsMessageLog.logMessage(
                        "clearRestrictionFilters: error in layer {}: {}".format(
                            labelLayersName, e
                        ),
                        level=Qgis.Warning,
                    )
                    return False

        return True

    def getCurrentRestrictionsForLayerAtDate(
        self, layerID, dateString=None
    ):  # TODO: possibly better with Proposal

        if not dateString:
            dateString = self.date()

        dateString = self.__date.toString("yyyy-MM-dd")
        dateChoosenFormatted = "'{dateString}'".format(dateString=dateString)

        filterString = '"OpenDate" \u003C\u003D to_date({dateChoosenFormatted}) AND (("CloseDate" \u003E to_date({dateChoosenFormatted})  OR "CloseDate" IS NULL))'.format(
            dateChoosenFormatted=dateChoosenFormatted
        )

        thisLayer = self.getRestrictionLayerFromID(layerID)

        request = QgsFeatureRequest().setFilterExpression(filterString)

        TOMsMessageLog.logMessage(
            "In ProposalsManager:getCurrentRestrictionsForLayerAtDate. Layer: "
            + thisLayer.name()
            + " Filter: "
            + filterString,
            level=Qgis.Info,
        )
        restrictionList = []
        for currentRestrictionDetails in thisLayer.getFeatures(request):
            TOMsMessageLog.logMessage(
                "In ProposalsManager:getCurrentRestrictionsForLayerAtDate. Layer: "
                + thisLayer.name()
                + " restrictionID: "
                + str(currentRestrictionDetails["RestrictionID"]),
                level=Qgis.Info,
            )
            currRestriction = ProposalElementFactory.getProposalElement(
                self, layerID, thisLayer, currentRestrictionDetails["RestrictionID"]
            )
            restrictionList.append(
                [currentRestrictionDetails["RestrictionID"], currRestriction]
            )

        return restrictionList

    def getProposalsListWithStatus(self, proposalStatus=None):

        self.proposalsLayer = self.tableNames.setLayer("Proposals")

        query = ""

        if proposalStatus is not None:
            query = ('"ProposalStatusID" = {proposalStatus}').format(
                proposalStatus=str(proposalStatus)
            )

        TOMsMessageLog.logMessage(
            "In __getProposalsListWithStatus. query: " + str(query), level=Qgis.Info
        )
        request = QgsFeatureRequest().setFilterExpression(query)

        proposalsList = []
        for proposalDetails in self.proposalsLayer.getFeatures(request):
            proposalsList.append(
                [
                    proposalDetails["ProposalID"],
                    proposalDetails["ProposalTitle"],
                    proposalDetails["ProposalStatusID"],
                    proposalDetails["ProposalOpenDate"],
                    proposalDetails,
                ]
            )

        return proposalsList
