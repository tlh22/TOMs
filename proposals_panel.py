# -*- coding: latin1 -*-
# Import the PyQt and QGIS libraries
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *

# Initialize Qt resources from file resources.py
# from cadtools import resources

#Import own classes and tools
# from segmentfindertool import SegmentFinderTool
# from lineintersection import LineIntersection
# import cadutils
# Import the code for the dialog

from ProposalPanel_dockwidget import ProposalPanelDockWidget
from proposal_details_dialog import proposalDetailsDialog

class proposalsPanel():
    
    def __init__(self, iface, TOMsMenu):
        # Save reference to the QGIS interface
        self.iface = iface
        self.canvas = self.iface.mapCanvas()

        self.actionProposalsPanel = QAction("Proposals Panel", self.iface.mainWindow())
        TOMsMenu.addAction(self.actionProposalsPanel)
        QObject.connect(self.actionProposalsPanel, SIGNAL("triggered()"), self.onInitProposalsPanel)

        self.acceptProposal = False
        self.newProposalRequired = False

        QgsExpressionContextUtils.setProjectVariable('CurrentProposal', "0")

    def onInitProposalsPanel(self):
        """Filter main layer based on date and state options"""
        
        QgsMessageLog.logMessage("In onInitProposalsPanel", tag="TOMs panel")

        #print "** STARTING ProposalPanel"

        # dockwidget may not exist if:
        #    first run of plugin
        #    removed on close (see self.onClosePlugin method)

        self.dock = ProposalPanelDockWidget()
        self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dock)

        #self.dock.filterDate.setDisplayFormat("yyyy-MM-dd")
        self.dock.filterDate.setDisplayFormat("dd/MM/yyyy")
        self.dock.filterDate.setDate(QDate.currentDate())

        # Now obtain all the current proposals,i.e., those with status of "In preparation"

        # Set up the "add proposal" button
        """if self.dockwidget == None:
            # Create the dockwidget (after translation) and keep reference
            self.dockwidget = ProposalPanelDockWidget()"""

        # connect to provide cleanup on closing of dockwidget
        #self.dockwidget.closingPlugin.connect(self.onClosePlugin)

        # show the dockwidget
        # TODO: fix to allow choice of dock location
        #self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dockwidget)
        #self.dockwidget.show()

        if QgsMapLayerRegistry.instance().mapLayersByName("Proposals"):
            self.Proposals = QgsMapLayerRegistry.instance().mapLayersByName("Proposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table Proposals is not present"))
            raise LayerNotPresent

        # Set up field details for table  ** what about errors here **
        idxProposalID = self.Proposals.fieldNameIndex("ProposalID")
        idxProposalTitle = self.Proposals.fieldNameIndex("ProposalTitle")

        self.createProposalcb()

        # set up a "NULL" field for "No proposals to be shown"

        """currProposalID = 0
        currProposalTitle = "No proposal shown"
        self.dock.cb_ProposalsList.addItem(currProposalTitle, currProposalID)

        for proposal in self.Proposals.getFeatures():
            currProposalStatusID = proposal.attribute("ProposalStatusID")
            QgsMessageLog.logMessage("In onInitProposalsPanel. currProposalStatus: " + str(currProposalStatusID), tag="TOMs panel")
            if currProposalStatusID == 1:   # 1 = "in preparation"
                currProposalID = proposal.attribute("ProposalID")
                currProposalTitle = proposal.attribute("ProposalTitle")
                self.dock.cb_ProposalsList.addItem( currProposalTitle, currProposalID )"""

        # set up action for when the date is changed
        self.dock.filterDate.dateChanged.connect(self.onChangeDate)

        # set up action for when the proposal is changed
        self.dock.cb_ProposalsList.currentIndexChanged.connect(self.onChangeProposal)

        # set up action for "New Proposal"
        self.dock.btn_NewProposal.clicked.connect(self.onNewProposal)

        # set up action for "View Proposal"
        self.dock.btn_ViewProposal.clicked.connect(self.onProposalDetails)

        # Set up filter for viewing at current date

        self.filterView()

        pass

    def createProposalcb(self):

        # set up a "NULL" field for "No proposals to be shown"

        self.dock.cb_ProposalsList.clear()

        currProposalID = 0
        currProposalTitle = "No proposal shown"

        self.dock.cb_ProposalsList.addItem(currProposalTitle, currProposalID)

        for proposal in self.Proposals.getFeatures():
            currProposalStatusID = proposal.attribute("ProposalStatusID")
            QgsMessageLog.logMessage("In onInitProposalsPanel. currProposalStatus: " + str(currProposalStatusID),
                                     tag="TOMs panel")
            if currProposalStatusID == 1:  # 1 = "in preparation"
                currProposalID = proposal.attribute("ProposalID")
                currProposalTitle = proposal.attribute("ProposalTitle")
                self.dock.cb_ProposalsList.addItem(currProposalTitle, currProposalID)

        pass

    def onChangeDate(self):
        QgsMessageLog.logMessage("In onChangeDate", tag="TOMs panel")

        # Refresh based on the date provided

        self.filterView()

        pass

    def onChangeProposal(self):
        QgsMessageLog.logMessage("In onChangeProposal", tag="TOMs panel")

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        newProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()
        newProposalID = self.dock.cb_ProposalsList.itemData(newProposal_cbIndex)
        newProposalTitle = self.dock.cb_ProposalsList.currentText()

        QgsMessageLog.logMessage("In onChangeProposal. newProposalID: " + str(newProposalID) + " newProposalTitle: " + str(newProposalTitle), tag="TOMs panel")

        # Set the project variable

        QgsExpressionContextUtils.setProjectVariable('CurrentProposal', str(newProposalID))

        # Now revise the view based on proposal choosen

        self.filterView()

        pass

    def onNewProposal(self):
        QgsMessageLog.logMessage("In onNewProposal", tag="TOMs panel")

        # display the dialog for proposals

        self.dlg = proposalDetailsDialog()

        # set up the combo box for Proposal Status

        if QgsMapLayerRegistry.instance().mapLayersByName("ProposalStatusTypes"):
            self.ProposalStatusTypesLayer = \
            QgsMapLayerRegistry.instance().mapLayersByName("ProposalStatusTypes")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table ProposalStatusTypes is not present"))
            raise LayerNotPresent

        for type in self.ProposalStatusTypesLayer.getFeatures():
            currID = type.attribute("id")
            currType = type.attribute("Description")
            self.dlg.ProposalStatusID.addItem( currType, currID )

        # add the values

        self.dlg.ProposalStatusID.setCurrentIndex(1 - 1)  # remove one as index starts at 1
        self.dlg.ProposalCreateDate.setDate(QDate.currentDate())

        QgsMessageLog.logMessage("In onNewProposal. New Proposal created.", tag="TOMs panel")

        self.dlg.show()

        # https://nathanw.net/2011/09/05/qgis-tips-custom-feature-forms-with-python-logic/
        # Disconnect the signal that QGIS has wired up for the dialog to the button box.
        self.dlg.button_box.accepted.disconnect()

        # Wire up our own signals.
        self.newProposalRequired = True
        self.dlg.button_box.accepted.connect(self.onSaveProposalDetails)   # would like to pass details here - not sure how ??

        pass

    def onSaveProposalDetails(self):
        QgsMessageLog.logMessage("In onSaveProposalDetails.", tag="TOMs panel")

        # set up field indexes
        idxProposalID = self.Proposals.fieldNameIndex("ProposalID")
        idxProposalTitle = self.Proposals.fieldNameIndex("ProposalTitle")
        idxProposalStatusID = self.Proposals.fieldNameIndex("ProposalStatusID")
        idxProposalNotes = self.Proposals.fieldNameIndex("ProposalNotes")
        idxProposalCreateDate = self.Proposals.fieldNameIndex("ProposalCreateDate")

        self.Proposals.startEditing()

        if self.newProposalRequired == True:

            # create a new Proposal

            currProposal = QgsFeature(self.Proposals.fields())
            currProposal.setGeometry(QgsGeometry())
            #self.Proposals.addFeatures([currProposal])

            QgsMessageLog.logMessage("In onSaveProposalDetails. Creating new Proposal.", tag="TOMs panel")

        else:

            # get the existing proposal ?? is there a better way ??

            currProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()
            currProposalID = self.dock.cb_ProposalsList.itemData(currProposal_cbIndex)
            currProposalTitle = self.dock.cb_ProposalsList.currentText()

            QgsMessageLog.logMessage(
                "In onSaveProposalDetails. ProposalID: " + str(currProposalID) + " ProposalTitle: " + str(
                    currProposalTitle), tag="TOMs panel")

            # use the ID to retrieve the row
            # https://gis.stackexchange.com/questions/54057/how-to-read-the-attribute-values-using-pyqgis/138027

            iterator = self.Proposals.getFeatures(QgsFeatureRequest().setFilterFid(currProposalID))
            currProposal = next(iterator)

        QgsMessageLog.logMessage("In onSaveProposalDetails. Saving Proposal. id: " + str(currProposal.id()),
                                 tag="TOMs panel")

        # Now save the details

        try:

            # Update the existing feature

            # idxProposalID = self.Proposals.fieldNameIndex("ProposalID")
            QgsMessageLog.logMessage(
                ("In onSaveProposalDetails. Attempting save. ID: " + str(currProposal.id()) + " Title: " + self.dlg.ProposalTitle.text() + " CreateDate: " + str(
                    self.dlg.ProposalCreateDate.text()) +
                 " ProposalStatusID: " + str(
                    self.dlg.ProposalStatusID.currentIndex() + 1) + " ProposalNotes: " + self.dlg.ProposalNotes.toPlainText()),
                tag="TOMs panel")

            if self.newProposalRequired == True:

                #currProposal[idxProposalID] = currProposal.id()
                currProposal[idxProposalTitle] = self.dlg.ProposalTitle.text()
                currProposal[idxProposalStatusID] = self.dlg.ProposalStatusID.currentIndex() + 1

                if self.dlg.ProposalNotes is not None:
                    currProposal[idxProposalNotes] = self.dlg.ProposalNotes.toPlainText()

                currProposal[idxProposalCreateDate] = self.dlg.ProposalCreateDate.date()

                self.Proposals.addFeatures([currProposal])

                QgsMessageLog.logMessage("In onSaveProposalDetails. Creating new Proposal.", tag="TOMs panel")

            else:

                # the Proposal already exists - so update it

                self.Proposals.changeAttributeValue(currProposal.id(), self.Proposals.fieldNameIndex("ProposalTitle"),
                                                    self.dlg.ProposalTitle.text())

                #  There is a problem with the format of the date passed here - and it is not saving correctly. Need to investigate further.
                self.Proposals.changeAttributeValue(currProposal.id(),
                                                    self.Proposals.fieldNameIndex("ProposalCreateDate"),
                                                    self.dlg.ProposalCreateDate.date())

                self.Proposals.changeAttributeValue(currProposal.id(),
                                                    self.Proposals.fieldNameIndex("ProposalStatusID"),
                                                    self.dlg.ProposalStatusID.currentIndex() + 1)

                self.Proposals.changeAttributeValue(currProposal.id(), self.Proposals.fieldNameIndex("ProposalNotes"),
                                                    str(self.dlg.ProposalNotes.toPlainText()))

                QgsMessageLog.logMessage("In onSaveProposalDetails. Saving existing Proposal. id: " + str(currProposal.id()), tag="TOMs panel")

            self.Proposals.commitChanges()  # Save details

        except:
            # errorList = self.TOMslayer.commitErrors()
            for item in list(self.Proposals.commitErrors()):
                QgsMessageLog.logMessage(("In onSaveProposalDetails. Unexpected error: " + str(item)),
                                         tag="TOMs panel")

            # self.TOMslayer.rollBack()
            raise

        QgsMessageLog.logMessage(("In onSaveProposalDetails. Successful save."), tag="TOMs panel")

        # Update the lsit of Proposals
        self.createProposalcb()

        self.dlg.accept()   # exit in the normal way

    def onProposalDetails(self):
        QgsMessageLog.logMessage("In onProposalDetails", tag="TOMs panel")

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        currProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()

        if currProposal_cbIndex == 0:
            return  # there is nothing to see

        currProposalID = self.dock.cb_ProposalsList.itemData(currProposal_cbIndex)
        currProposalTitle = self.dock.cb_ProposalsList.currentText()

        QgsMessageLog.logMessage("In onProposalDetails. newProposalID: " + str(currProposalID) + " newProposalTitle: " + str(currProposalTitle), tag="TOMs panel")

        # use the ID to retrieve the row
        # https://gis.stackexchange.com/questions/54057/how-to-read-the-attribute-values-using-pyqgis/138027

        iterator = self.Proposals.getFeatures(QgsFeatureRequest().setFilterFid(currProposalID))
        currProposal = next(iterator)

        currProposalStatusID = currProposal.attribute("ProposalStatusID")
        currProposalCreateDate = QDate(currProposal.attribute("ProposalCreateDate"))
        currProposalNotes = currProposal.attribute("ProposalNotes")

        # display the dialog for proposals

        self.dlg = proposalDetailsDialog()

        # set up the combo box for Proposal Status

        if QgsMapLayerRegistry.instance().mapLayersByName("ProposalStatusTypes"):
            self.ProposalStatusTypesLayer = \
            QgsMapLayerRegistry.instance().mapLayersByName("ProposalStatusTypes")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table ProposalStatusTypes is not present"))
            raise LayerNotPresent

        for type in self.ProposalStatusTypesLayer.getFeatures():
            currID = type.attribute("id")
            currType = type.attribute("Description")
            self.dlg.ProposalStatusID.addItem( currType, currID )

        # add the values

        self.dlg.ProposalTitle.setText(currProposalTitle)
        self.dlg.ProposalStatusID.setCurrentIndex(currProposalStatusID - 1)  # remove one as index starts at 1
        self.dlg.ProposalCreateDate.setDate(currProposalCreateDate)

        if currProposalNotes:
            self.dlg.ProposalNotes.setPlainText(currProposalNotes)

        # check for changes to proposal status
        self.dlg.ProposalStatusID.currentIndexChanged.connect(self.onChangeProposalStatus)

        self.dlg.show()

        QgsMessageLog.logMessage(("In onProposalDetails. Waiting for changes to form."),
                                 tag="TOMs panel")

        # pick up a singal that something has changed (not sure which one)
        # self.dlg.attributeChanged.connect(self.onProposalChanged)
        # https://nathanw.net/2011/09/05/qgis-tips-custom-feature-forms-with-python-logic/
        # Disconnect the signal that QGIS has wired up for the dialog to the button box.
        self.dlg.button_box.accepted.disconnect()

        # Wire up our own signals.
        self.newProposalRequired = False
        self.dlg.button_box.accepted.connect(self.onSaveProposalDetails)   # would like to pass details here - not sure how ??

        pass

    def onProposalChanged(self):
        QgsMessageLog.logMessage("In onProposalChanged", tag="TOMs panel")


        pass

    def onChangeProposalStatus(self):
        QgsMessageLog.logMessage("In onChangeProposalStatus. Proposed status: " + str(self.Proposals.fieldNameIndex("ProposalStatusID")), tag="TOMs panel")

        # check to see if the proposal is "Accepted"

        self.acceptProposal = False

        newProposalStatus = int(self.Proposals.fieldNameIndex("ProposalStatusID"))

        if newProposalStatus == 1:    # should be 2 but with list ...

            # if so, check to see if this was intended

            reply = QMessageBox.question(self.iface.mainWindow(), 'Confirm changes to Proposal',
                                         'Are you you want to accept this proposal?. Accepting will make all the proposed changes permanent.', QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:
                # make the changes permanent
                self.acceptProposal = True

        # bring the Proposals dislog back to the front

        self.dlg.activateWindow()

        return self.acceptProposal

    def filterView(self):
        """Filter main layer based on date and state options"""

        QgsMessageLog.logMessage("In filterView", tag="TOMs panel")

        displayDate = self.dock.filterDate.date()

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        currProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()

        if currProposal_cbIndex == 0:
            currProposalID = 0
        else:
            currProposalID = self.dock.cb_ProposalsList.itemData(currProposal_cbIndex)
            currProposalTitle = self.dock.cb_ProposalsList.currentText()

        dateChoosen = displayDate.toString ("dd-MM-yyyy")

        QgsMessageLog.logMessage("In filterView. filterDate: " + dateChoosen + " ProposalID: " + str(currProposalID), tag="TOMs panel")

        # Filter the display based on the details provided

        QgsExpressionContextUtils.setProjectVariable('ViewAtDate', dateChoosen)

        dateChoosenFormatted = "'" + dateChoosen + "'"

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
        filterString = '"OpenDate2" <= ' + dateChoosenFormatted + ' AND ("CloseDate2" > ' + dateChoosenFormatted + '  OR "CloseDate2"  IS  NULL)'

        if currProposalID > 0:   # need to consider a proposal

            # Set Proposal as project variable

            self.currProposalID = QgsExpressionContextUtils.projectScope().variable('currentProposal')

            # get list of restrictions to open within proposal

            if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers2"):
                self.RestrictionLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers2")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionLayers2 is not present"))
                raise LayerNotPresent

            # loop through all the layers that might have restrictions

            listRestrictionLayers = self.RestrictionLayers.getFeatures()

            for currLayerDetails in listRestrictionLayers:

                # get the layer from the name

                currLayerID = currLayerDetails["id"]
                currLayerName = currLayerDetails["RestrictionLayerName"]
                QgsMessageLog.logMessage("In filterMapOnDate. Considering layer: " + currLayerDetails["RestrictionLayerName"], tag="TOMs panel")

                if QgsMapLayerRegistry.instance().mapLayersByName(currLayerName):
                    currRestrictionLayer = QgsMapLayerRegistry.instance().mapLayersByName(currLayerName)[0]
                else:
                    QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                            ("Table " + currLayerName + " is not present"))
                    raise LayerNotPresent

                restrictionsToClose = self.getRestrictionsInProposal(currLayerID, currProposalID, 2)   # Close is 2  ... need to get better looping ...
                QgsMessageLog.logMessage("In filterMapOnDate. restrictionsToClose: " + str(restrictionsToClose), tag="TOMs panel")

                # **** Assumption that there are some details in proposal ??
                if len(restrictionsToClose) > 0:
                    filterString = filterString + ' AND "GeometryID" NOT IN ( ' + restrictionsToClose + " ))"

                # get list of restrictions to close within proposal
                restrictionsToOpen = self.getRestrictionsInProposal(currLayerID, currProposalID, 1)   # Open is 1

                if len(restrictionsToOpen) > 0:
                    filterString = ' "GeometryID"  IN ( ' + restrictionsToOpen + " ) OR ( " + filterString

                    if len(restrictionsToClose) == 0:
                        filterString = filterString + " ) "

            pass

        # QMessageBox.information(self.iface.mainWindow(), "debug", dateChoosen + " " + tmpOrdersText + " " + filterString)
        QgsMessageLog.logMessage("In filterMapOnDate. Date Filter: " + filterString, tag="TOMs panel")
        # filterString = 'date("CreateDate") <= ' + date(dateChoosenFormatted) + ' AND (date("DeleteDate") > ' + date(dateChoosenFormatted) + '  OR "DeleteDate"  IS  NULL)' + ' AND ' + tmpOrdersFilterString
        # QgsMessageLog.logMessage("Filter2: " + filterString, tag="TOMs panel")

        #
        # May need to apply filter to more than one layer. Currently just for one
        #

        self.TOMslayer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]

        #
        #  http://gis.stackexchange.com/questions/121148/how-to-filter-qgis-layer-from-python
        #

        self.TOMslayer.setSubsetString(filterString)

        pass

    def getRestrictionsInProposal(self, layerID, proposalID, proposedAction):
        # Will return a (comma separated) string with the list of restrictions within a Proposal
        QgsMessageLog.logMessage("In getRestrictionsInProposal. layerID: " + str(layerID) + " proposalID: " + str(proposalID) + " proposedAction: " + str(proposedAction), tag="TOMs panel")

        restrictionsString = ''
        firstRestriction = True

        if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals"):
            self.RestrictionsInProposals = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionsInProposals is not present"))
            raise LayerNotPresent

        # Hopefully can use SQL to return the rows, but now sure about process.

        listRestrictionsInProposals = self.RestrictionsInProposals.getFeatures()

        QgsMessageLog.logMessage(
            "In getRestrictionsInProposal. START layerID: " + str(layerID) + " ProposalID: " + str(
                proposalID) + " proposedAction: " + str(proposedAction) + " firstRestriction: " + str(firstRestriction),
            tag="TOMs panel")

        for proposedChange in listRestrictionsInProposals:

            currProposalID = proposedChange["ProposalID"]
            currRestrictionTableID = proposedChange["RestrictionTableID"]
            possAction = proposedChange["ActionOnProposalAcceptance"]

            # check to see if the current row is for the current proposal and for the correct proposedAction

            if proposalID == currProposalID:
                if layerID == currRestrictionTableID:
                    if proposedAction == possAction:

                        QgsMessageLog.logMessage(
                            "In getRestrictionsInProposal. FOUND layerID: " + str(layerID) + " currProposalID: " + str(
                                currProposalID) + " possAction: " + str(possAction) + " firstRestriction: " + str(firstRestriction), tag="TOMs panel")

                        if not firstRestriction:
                            restrictionsString = restrictionsString + ", '" + proposedChange["RestrictionID"] + "'"
                            QgsMessageLog.logMessage(
                                "In getRestrictionsInProposal. A restrictionsString: " + restrictionsString,
                                tag="TOMs panel")
                        else:
                            restrictionsString = "'" + str(proposedChange["RestrictionID"]) + "'"
                            firstRestriction = False

            pass

        QgsMessageLog.logMessage("In getRestrictionsInProposal. restrictionsString: " + restrictionsString, tag="TOMs panel")

        return restrictionsString
