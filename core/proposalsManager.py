#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock/Matthias Kuhn 2017

from qgis.PyQt.QtCore import (
    QObject,
    QDate,
    pyqtSignal, pyqtSlot
)

from qgis.PyQt.QtWidgets import (
    QMessageBox,
    QAction
)

from qgis.core import (
    QgsExpressionContextUtils,
    # QgsMapLayerRegistry,
    QgsMessageLog, QgsFeature, QgsGeometry,
    QgsFeatureRequest,
    QgsProject, QgsRectangle
)

from ..restrictionTypeUtilsClass import RestrictionTypeUtilsMixin, TOMSLayers
from ..proposalTypeUtilsClass import ProposalTypeUtilsMixin
from ..constants import (
    ProposalStatus,
    RestrictionAction
)
from ..core.TOMsProposal import (TOMsProposal)

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

    TOMsToolChanged = pyqtSignal()
    """ signal will be emitted when TOMs tool is changed """

    TOMsActivated = pyqtSignal()
    """ signal will be emitted when TOMs tools are activated"""
    #TOMsStartupFailure = pyqtSignal()
    """ signal will be emitted with there is a problem with opening TOMs - typically a layer missing """
    TOMsSplitRestrictionSaved = pyqtSignal()

    def __init__(self, iface):
        QObject.__init__(self)
        self.__date = QDate.currentDate()
        self.currProposalFeature = None

        self.iface = iface
        self.canvas = self.iface.mapCanvas()

        self.tableNames = TOMSLayers(self.iface)

        self.currProposalO = TOMsProposal(self)
        self.setTOMsActivated = False
        #self.TOMsActivated.connect(self.setProposalDetails)

    def date(self):
        """
        Get access to the current date
        """
        return self.__date

    def setDate(self, value):
        """
        Set the current date
        """
        QgsMessageLog.logMessage('Current date changed to {date}'.format(date=value.toString('dd/MM/yyyy')), tag="TOMs panel")
        self.__date = value
        self.dateChanged.emit()
        self.updateMapCanvas()

    def currentProposal(self):
        """
        Returns the current proposal
        """
        currProposal = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('CurrentProposal')
        if not currProposal:
            currProposal = 0
        return int(currProposal)

    def setCurrentProposal(self, value):
        """
        Set the current proposal
        """
        QgsMessageLog.logMessage('Current proposal changed to {proposal_id}'.format(proposal_id=value), tag="TOMs panel")
        QgsExpressionContextUtils.setProjectVariable(QgsProject.instance(), 'CurrentProposal', value)

        self.currProposalO.setProposal(self.currentProposal())

        self.proposalChanged.emit()
        self.updateMapCanvas()

        box = self.currProposalO.getProposalBoundingBox()
        if box.isNull() == False:
            self.canvas.setExtent(box)

    def updateMapCanvas(self):
        """
        Whenever the current proposal or the date changes we need to update the canvas.
        """

        QgsMessageLog.logMessage('Entering updateMapCanvas', tag="TOMs panel")

        dateString = self.__date.toString('dd-MM-yyyy')
        currProposalID = self.currentProposal()

        dateChoosenFormatted = "'{dateString}'".format(dateString=dateString)

        #filterString = '"OpenDate" <= to_date(' + dateChoosenFormatted + ", 'dd-MM-yyyy') AND ((" + '"CloseDate" > to_date(' + dateChoosenFormatted + ", 'dd-MM-yyyy')  OR " + '"CloseDate"  IS  NULL)'

        filterString = u'"OpenDate" \u003C\u003D to_date({dateChoosenFormatted}, \'dd-MM-yyyy\') AND (("CloseDate" \u003E to_date({dateChoosenFormatted}, \'dd-MM-yyyy\')  OR "CloseDate" IS NULL)'.format(dateChoosenFormatted=dateChoosenFormatted)
        # if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers"):
        #     self.RestrictionLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        for (layerID, layerName) in self.getRestrictionLayersList():
            QgsMessageLog.logMessage(
                "Considering layer: " + layerName, tag="TOMs panel")

            layerFilterString = filterString

            if currProposalID > 0:   # need to consider a proposal

                restrictionsToClose = self.currProposalO.getRestrictionsToCloseForLayer(layerID)
                if len(restrictionsToClose) > 0:
                    layerFilterString = ('{layerString} AND "RestrictionID" NOT IN ({restrictionsToClose}))').format(layerString=layerFilterString, restrictionsToClose=restrictionsToClose)

                restrictionsToOpen = self.currProposalO.getRestrictionsToOpenForLayer(layerID)
                if len(restrictionsToOpen) > 0:
                    layerFilterString = (' "RestrictionID"  IN ({restrictionsToOpen}) OR ({layerString})').format(layerString=layerFilterString, restrictionsToOpen=restrictionsToOpen)

                if len(restrictionsToClose) == 0:
                    layerFilterString = layerFilterString + ")"

            else:
                layerFilterString = layerFilterString + ")"

            QgsMessageLog.logMessage("In updateMapCanvas. Layer: " + layerName + " Date Filter: " + layerFilterString, tag="TOMs panel")
            self.tableNames.setLayer(layerName).setSubsetString(layerFilterString)

        pass

    def clearRestrictionFilters(self):
        # This is to be used at the close of the plugin to clear any filters that have been set

        for (layerID, layerName) in self.getRestrictionLayersList():
            QgsMessageLog.logMessage("Clearing filter for layer: " + layerName, tag="TOMs panel")
            self.tableNames.setLayer(layerName).setSubsetString('')

        pass

        """def getRestrictionsInProposal(self, layerID, proposalID, proposedAction):
        # Will return a (comma separated) string with the list of restrictions within a Proposal
        #QgsMessageLog.logMessage("In getRestrictionsInProposal. layerID: " + str(layerID) + " proposalID: " + str(proposalID) + " proposedAction: " + str(proposedAction), tag="TOMs panel")

        restrictionsString = ''
        firstRestriction = True


        if QgsProject.instance().mapLayersByName("RestrictionsInProposals"):
            self.RestrictionsInProposals = QgsProject.instance().mapLayersByName("RestrictionsInProposals")[0]
        else:
            QMessageBox.information(None, "ERROR", ("Table RestrictionsInProposals is not present"))
            raise LayerNotPresent

        # Hopefully can use SQL to return the rows, but now sure about process.

        listRestrictionsInProposals = self.RestrictionsInProposals.getFeatures()"""

        """QgsMessageLog.logMessage(
            "In getRestrictionsInProposal. START layerID: " + str(layerID) + " ProposalID: " + str(
                proposalID) + " proposedAction: " + str(proposedAction) + " firstRestriction: " + str(firstRestriction),
            tag="TOMs panel")"""

        """for proposedChange in listRestrictionsInProposals:

            currProposalID = proposedChange["ProposalID"]
            currRestrictionTableID = proposedChange["RestrictionTableID"]
            possAction = proposedChange["ActionOnProposalAcceptance"]

            # check to see if the current row is for the current proposal and for the correct proposedAction

            if proposalID == currProposalID:
                if layerID == currRestrictionTableID:
                    if proposedAction == possAction:"""

        """                QgsMessageLog.logMessage(
                            "In getRestrictionsInProposal. FOUND layerID: " + str(layerID) + " currProposalID: " + str(
                                currProposalID) + " possAction: " + str(possAction) + " firstRestriction: " + str(firstRestriction), tag="TOMs panel")"""

        """                if not firstRestriction:
                            restrictionsString = restrictionsString + ", '" + proposedChange["RestrictionID"] + "' """
        """                    QgsMessageLog.logMessage(
                                    "In getRestrictionsInProposal. A restrictionsString: " + restrictionsString,
                                    tag="TOMs panel")"""
        """                else:
                            restrictionsString = "'" + str(proposedChange["RestrictionID"]) + "'"
                            firstRestriction = False

            pass

        pass

        #QgsMessageLog.logMessage("In getRestrictionsInProposal. restrictionsString: " + restrictionsString, tag="TOMs panel")

        return restrictionsString """

    """def getProposalStatusID(self, currProposalID):
        # return proposal status code ??

        # QgsMessageLog.logMessage("In getLookupLabelText", tag="TOMs panel")

        query = "\"ProposalID\" = " + str(currProposalID)
        request = QgsFeatureRequest().setFilterExpression(query)

        # QgsMessageLog.logMessage("In getLookupLabelText. queryStatus: " + str(query), tag="TOMs panel")

        if QgsProject.instance().mapLayersByName("Proposals"):
            self.Proposals = \
                QgsProject.instance().mapLayersByName("Proposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                    ("Table Proposals is not present"))

        for row in self.Proposals.getFeatures(request):
            # QgsMessageLog.logMessage("In getLookupLabelText: found row " + str(row.attribute("LabelText")), tag="TOMs panel")
            return row.attribute("ProposalStatusID")  # make assumption that only one row

        return None"""

    """def getProposalOpenDate(self, currProposalID):
        # return proposal status code ??

        # QgsMessageLog.logMessage("In getLookupLabelText", tag="TOMs panel")

        query = "\"ProposalID\" = " + str(currProposalID)
        request = QgsFeatureRequest().setFilterExpression(query)

        # QgsMessageLog.logMessage("In getLookupLabelText. queryStatus: " + str(query), tag="TOMs panel")

        if QgsProject.instance().mapLayersByName("Proposals"):
            self.Proposals = \
                QgsProject.instance().mapLayersByName("Proposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                    ("Table Proposals is not present"))

        for row in self.Proposals.getFeatures(request):
            # QgsMessageLog.logMessage("In getLookupLabelText: found row " + str(row.attribute("LabelText")), tag="TOMs panel")
            return row.attribute("ProposalOpenDate")  # make assumption that only one row

        return None"""

    # @pyqtSlot()
    #def setProposalDetails(self):
    """ Needed because Proposal object can be created before layers details are set ... perhaps a sequencing issue here ... """
    """QgsMessageLog.logMessage("In proposalsManager. SetProposalDetails ... ", tag="TOMs panel")
        self.setTOMsActivated = True
        self.currProposalO.setProposalsLayer()"""

    def __getProposalsListWithStatus(self, layer, actionOnAcceptance=None):
        pass