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
    
    def __init__(self, iface, TOMsMenu, restrictionManager):
        # Save reference to the QGIS interface
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.restrictionManager = restrictionManager

        self.actionProposalsPanel = QAction("Proposals Panel", self.iface.mainWindow())
        TOMsMenu.addAction(self.actionProposalsPanel)
        self.actionProposalsPanel.triggered.connect(self.onInitProposalsPanel)

        self.acceptProposal = False
        self.newProposalRequired = False

    def onInitProposalsPanel(self):
        """Filter main layer based on date and state options"""
        
        QgsMessageLog.logMessage("In onInitProposalsPanel", tag="TOMs panel")

        #print "** STARTING ProposalPanel"

        # dockwidget may not exist if:
        #    first run of plugin
        #    removed on close (see self.onClosePlugin method)

        self.dock = ProposalPanelDockWidget()
        self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dock)

        self.restrictionManager.proposalChanged.connect(self.onProposalChanged)
        self.restrictionManager.dateChanged.connect(self.onDateChanged)

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

        # set up action for when the date is changed from the user interface
        self.dock.filterDate.dateChanged.connect(lambda: self.restrictionManager.setDate(self.dock.filterDate.date()))

        # set up action for when the proposal is changed
        self.dock.cb_ProposalsList.currentIndexChanged.connect(self.updateCurrentProposal)

        # set up action for "New Proposal"
        self.dock.btn_NewProposal.clicked.connect(self.onNewProposal)

        # set up action for "View Proposal"
        self.dock.btn_ViewProposal.clicked.connect(self.onProposalDetails)

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


    def onChangeProposal(self):
        QgsMessageLog.logMessage("In onChangeProposal", tag="TOMs panel")

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        newProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()
        newProposalID = self.dock.cb_ProposalsList.itemData(newProposal_cbIndex)
        newProposalTitle = self.dock.cb_ProposalsList.currentText()

        QgsMessageLog.logMessage("In onChangeProposal. newProposalID: " + str(newProposalID) + " newProposalTitle: " + str(newProposalTitle), tag="TOMs panel")

        # Set the project variable

        QgsExpressionContextUtils.setProjectVariable('CurrentProposal', str(newProposalID))

        # rollback any outstanding changes
        """reply = QMessageBox.question(self.iface.mainWindow(), 'Confirm changes to Proposal',
                                     'Are you you want to accept this proposal?. Accepting will make all the proposed changes permanent.',
                                     QMessageBox.Yes, QMessageBox.No)"""

        reply = QMessageBox.information(self.iface.mainWindow(), "Information", "All changes will be rolled back", QMessageBox.Ok)

        self.iface.actionRollbackAllEdits().trigger()
        self.iface.actionCancelAllEdits().trigger()

        # reset map tools, etc
        #self.iface.mapCanvas().unsetMapTool(self.mapTool)
        #self.mapTool = None

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
        currProposal = self.restrictionManager.currentProposal()
        currProposalIdx = self.dock.cb_ProposalsList.findData(currProposal)
        self.dock.cb_ProposalsList.setCurrentIndex(currProposalIdx)

    def updateCurrentProposal(self):
        """Will be called whenever a new entry is selected in the combobox"""
        currProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()
        currProposalID = self.dock.cb_ProposalsList.itemData(currProposal_cbIndex)
        self.restrictionManager.setCurrentProposal(currProposalID)

    def onDateChanged(self):
        date = self.restrictionManager.date()
        self.dock.filterDate.setDate(date)

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

    def getRestrictionLayerTableID(currRestLayer):
        QgsMessageLog.logMessage("In getRestrictionLayerTableID.", tag="TOMs panel")
        # find the ID for the layer within the table "

        RestrictionsLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers2")[0]

        layersTableID = 0

        # not sure if there is better way to search for something, .e.g., using SQL ??

        for layer in RestrictionsLayers.getFeatures():
            if layer.attribute("RestrictionLayerName") == str(currRestLayer.name()):
                layersTableID = layer.attribute("id")

        QgsMessageLog.logMessage("In getRestrictionLayerTableID. layersTableID: " + str(layersTableID), tag="TOMs panel")

        return layersTableID
