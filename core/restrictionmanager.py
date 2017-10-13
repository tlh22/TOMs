
from PyQt4.QtCore import (
    QObject,
    QDate,
    pyqtSignal
)

from PyQt4.QtGui import (
    QMessageBox
)

from qgis.core import (
    QgsExpressionContextUtils,
    QgsMapLayerRegistry,
    QgsMessageLog, QgsFeature, QgsGeometry
)

from TOMs.constants import TOMsConstants

class TOMsRestrictionManager(QObject):
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

    def __init__(self):
        QObject.__init__(self)
        self.__date = QDate.currentDate()
        self.constants = TOMsConstants()

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
        currProposal = QgsExpressionContextUtils.projectScope().variable('CurrentProposal')
        if not currProposal:
            currProposal = 0
        return int(currProposal)

    def currentProposalName(self):
        """
        Returns the current proposal
        """
        currProposal = QgsExpressionContextUtils.projectScope().variable('CurrentProposal')
        if not currProposal:
            currProposal = 0
        return int(currProposal)

    def setCurrentProposal(self, value):
        """
        Set the current proposal
        """
        QgsMessageLog.logMessage('Current proposal changed to {proposal_id}'.format(proposal_id=value), tag="TOMs panel")
        QgsExpressionContextUtils.setProjectVariable('CurrentProposal', value)
        self.proposalChanged.emit()
        self.updateMapCanvas()

    def updateMapCanvas(self):
        """
        Whenever the current proposal or the date changes we need to update the canvas.
        """

        dateString = self.__date.toString('dd-MM-yyyy')
        currProposalID = self.currentProposal()

        dateChoosenFormatted = "'" + dateString + "'"

        #
        #  http://gis.stackexchange.com/questions/121148/how-to-filter-qgis-layer-from-python
        #
        # Also note use of "#" is for use with Access. Filter syntax is provider dependent
        #

        # For Access
        # filterString = '"CreateDate" <= #' + dateChoosen + '# AND ("DeleteDate" > #' + dateChoosen + '#  OR "DeleteDate"  IS  NULL)' + ' AND ' + tmpOrdersFilterString

        # For Spatialite
        #filterString = '"EffectiveDate" <= ' + dateChoosenFormatted + ' AND ("RescindDate" > ' + dateChoosenFormatted + '  OR "RescindDate"  IS  NULL)' + ' AND ' + tmpOrdersFilterString
        # filterString = '"ResState" = 1'

        # For PostGIS - "OpenDate2" <= '02-09-2017' AND ("CloseDate2" > '02-09-2017' OR "CloseDate2"  IS NULL)
        filterString = '"OpenDate2" <= to_date(' + dateChoosenFormatted + ", 'dd-MM-yyyy') AND ((" + '"CloseDate2" > to_date(' + dateChoosenFormatted + ", 'dd-MM-yyyy')  OR " + '"CloseDate2"  IS  NULL)'

        if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers"):
            self.RestrictionLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionLayers is not present"))
            return

        # loop through all the layers that might have restrictions

        listRestrictionLayers = self.RestrictionLayers.getFeatures()

        for currLayerDetails in listRestrictionLayers:

            # get the layer from the name

            currLayerID = currLayerDetails["id"]
            currLayerName = currLayerDetails["RestrictionLayerName"]
            QgsMessageLog.logMessage(
                "In filterMapOnDate. Considering layer: " + currLayerDetails["RestrictionLayerName"], tag="TOMs panel")

            if QgsMapLayerRegistry.instance().mapLayersByName(currLayerName):
                currRestrictionLayer = QgsMapLayerRegistry.instance().mapLayersByName(currLayerName)[0]                # **** should we use self.currRestrictionLayer ??
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                        ("Table " + currLayerName + " is not present"))
                return

            layerFilterString = filterString

            if currProposalID > 0:   # need to consider a proposal
                # get list of restrictions to open within proposal

                restrictionsToClose = self.getRestrictionsInProposal(currLayerID, currProposalID, self.constants.ACTION_CLOSE_RESTRICTION())   # Close is 2  ... need to get better looping ...
                QgsMessageLog.logMessage("In filterMapOnDate. restrictionsToClose: " + str(restrictionsToClose), tag="TOMs panel")

                # **** Assumption that there are some details in proposal ??
                if len(restrictionsToClose) > 0:
                    layerFilterString = layerFilterString + ' AND "GeometryID" NOT IN ( ' + restrictionsToClose + " ))"

                # get list of restrictions to close within proposal
                restrictionsToOpen = self.getRestrictionsInProposal(currLayerID, currProposalID, self.constants.ACTION_OPEN_RESTRICTION())   # Open is 1

                if len(restrictionsToOpen) > 0:
                    layerFilterString = ' "GeometryID"  IN ( ' + restrictionsToOpen + " ) OR ( " + layerFilterString + ")"

                if len(restrictionsToClose) == 0:
                    layerFilterString = layerFilterString + ")"

            else:
                layerFilterString = layerFilterString + ")"

            # Now apply filter to the layer
            QgsMessageLog.logMessage("In filterMapOnDate. Layer: " + currLayerName + " Date Filter: " + layerFilterString, tag="TOMs panel")
            currRestrictionLayer.setSubsetString(layerFilterString)

        # QMessageBox.information(self.iface.mainWindow(), "debug", dateChoosen + " " + tmpOrdersText + " " + filterString)
        #QgsMessageLog.logMessage("In filterMapOnDate. Date Filter: " + filterString, tag="TOMs panel")
        # filterString = 'date("CreateDate") <= ' + date(dateChoosenFormatted) + ' AND (date("DeleteDate") > ' + date(dateChoosenFormatted) + '  OR "DeleteDate"  IS  NULL)' + ' AND ' + tmpOrdersFilterString
        # QgsMessageLog.logMessage("Filter2: " + filterString, tag="TOMs panel")

        #
        # May need to apply filter to more than one layer. Currently just for one
        #

        #self.TOMslayer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]

        #
        #  http://gis.stackexchange.com/questions/121148/how-to-filter-qgis-layer-from-python
        #

        #self.TOMslayer.setSubsetString(filterString)

    def getRestrictionsInProposal(self, layerID, proposalID, proposedAction):
        # Will return a (comma separated) string with the list of restrictions within a Proposal
        #QgsMessageLog.logMessage("In getRestrictionsInProposal. layerID: " + str(layerID) + " proposalID: " + str(proposalID) + " proposedAction: " + str(proposedAction), tag="TOMs panel")

        restrictionsString = ''
        firstRestriction = True

        if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals"):
            self.RestrictionsInProposals = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionsInProposals is not present"))
            raise LayerNotPresent

        # Hopefully can use SQL to return the rows, but now sure about process.

        listRestrictionsInProposals = self.RestrictionsInProposals.getFeatures()

        """QgsMessageLog.logMessage(
            "In getRestrictionsInProposal. START layerID: " + str(layerID) + " ProposalID: " + str(
                proposalID) + " proposedAction: " + str(proposedAction) + " firstRestriction: " + str(firstRestriction),
            tag="TOMs panel")"""

        for proposedChange in listRestrictionsInProposals:

            currProposalID = proposedChange["ProposalID"]
            currRestrictionTableID = proposedChange["RestrictionTableID"]
            possAction = proposedChange["ActionOnProposalAcceptance"]

            # check to see if the current row is for the current proposal and for the correct proposedAction

            if proposalID == currProposalID:
                if layerID == currRestrictionTableID:
                    if proposedAction == possAction:

                        """QgsMessageLog.logMessage(
                            "In getRestrictionsInProposal. FOUND layerID: " + str(layerID) + " currProposalID: " + str(
                                currProposalID) + " possAction: " + str(possAction) + " firstRestriction: " + str(firstRestriction), tag="TOMs panel")"""

                        if not firstRestriction:
                            restrictionsString = restrictionsString + ", '" + proposedChange["RestrictionID"] + "'"
                            """QgsMessageLog.logMessage(
                                "In getRestrictionsInProposal. A restrictionsString: " + restrictionsString,
                                tag="TOMs panel")"""
                        else:
                            restrictionsString = "'" + str(proposedChange["RestrictionID"]) + "'"
                            firstRestriction = False

            pass

        #QgsMessageLog.logMessage("In getRestrictionsInProposal. restrictionsString: " + restrictionsString, tag="TOMs panel")

        return restrictionsString

    def restrictionInProposal (self, currRestrictionID, currRestrictionLayerID, proposalID):
        # returns True if restriction is in Proposal
        #QgsMessageLog.logMessage("In restrictionInProposal.", tag="TOMs panel")

        RestrictionsInProposalsLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]

        restrictionFound = False

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for restrictionInProposal in RestrictionsInProposalsLayer.getFeatures():
            if restrictionInProposal.attribute("RestrictionID") == currRestrictionID:
                if restrictionInProposal.attribute("RestrictionTableID") == currRestrictionLayerID:
                    if restrictionInProposal.attribute("ProposalID") == proposalID:
                        restrictionFound = True

        """QgsMessageLog.logMessage("In restrictionInProposal. restrictionFound: " + str(restrictionFound),
                                 tag="TOMs panel")"""

        return restrictionFound

    #@staticmethod    # NB: Duplicated from restrictionOpenForm.py - need to understand scope and how to reference !!!
    def addRestrictionToProposal(self, restrictionID, restrictionLayerTableID, proposalID, proposedAction):
        # adds restriction to the "RestrictionsInProposals" layer
        #QgsMessageLog.logMessage("In addRestrictionToProposal.", tag="TOMs panel")

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

        """QgsMessageLog.logMessage(
            "In addRestrictionToProposal. Before record create. RestrictionID: " + str(restrictionID),
            tag="TOMs panel")"""

        RestrictionsInProposalsLayer.addFeatures([newRestrictionsInProposal])

        pass

    def getRestrictionsLayer(self, currRestrictionTableRecord):
        # return the layer given the row in "RestrictionLayers"
        #QgsMessageLog.logMessage("In getRestrictionLayer.", tag="TOMs panel")

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        idxRestrictionsLayerName = RestrictionsLayers.fieldNameIndex("RestrictionLayerName")

        currRestrictionsTableName = currRestrictionTableRecord[idxRestrictionsLayerName]

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName(currRestrictionsTableName)[0]

        return RestrictionsLayers

    def getRestrictionLayerTableID(self, currRestLayer):
        #QgsMessageLog.logMessage("In getRestrictionLayerTableID.", tag="TOMs panel")
        # find the ID for the layer within the table "

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]

        layersTableID = 0

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for layer in RestrictionsLayers.getFeatures():
            if layer.attribute("RestrictionLayerName") == str(currRestLayer.name()):
                layersTableID = layer.attribute("id")

        """QgsMessageLog.logMessage("In getRestrictionLayerTableID. layersTableID: " + str(layersTableID),
                                 tag="TOMs panel")"""

        return layersTableID
