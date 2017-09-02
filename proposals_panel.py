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

        # set up a "NULL" field for "No proposals to be shown"

        currProposalID = 0
        currProposalTitle = "No proposal shown"
        self.dock.cb_ProposalsList.addItem(currProposalTitle, currProposalID)

        for proposal in self.Proposals.getFeatures():
            currProposalStatusID = proposal.attribute("ProposalStatusID")
            QgsMessageLog.logMessage("In onInitProposalsPanel. currProposalStatus: " + str(currProposalStatusID), tag="TOMs panel")
            if currProposalStatusID == 1:   # 1 = "in preparation"
                currProposalID = proposal.attribute("ProposalID")
                currProposalTitle = proposal.attribute("ProposalTitle")
                self.dock.cb_ProposalsList.addItem( currProposalTitle, currProposalID )

        # set up action for when the proposal is changed
        self.dock.cb_ProposalsList.currentIndexChanged.connect(self.onChangeProposal)

        # set up action for "New Proposal"
        self.dock.btn_NewProposal.clicked.connect(self.onNewProposal)

        # set up action for "View Proposal"

        self.dock.btn_ViewProposal.clicked.connect(self.onProposalDetails)

        # Set up filter for viewing at current date

        pass

    def onChangeProposal(self):
        QgsMessageLog.logMessage("In onChangeProposal", tag="TOMs panel")

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        newProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()
        newProposalID = self.dock.cb_ProposalsList.itemData(newProposal_cbIndex)
        newProposalTitle = self.dock.cb_ProposalsList.currentText()

        QgsMessageLog.logMessage("In onChangeProposal. newProposalID: " + str(newProposalID) + " newProposalTitle: " + str(newProposalTitle), tag="TOMs panel")

        # Now revise the view based on proposal choosen

        pass

    def onNewProposal(self):
        QgsMessageLog.logMessage("In onNewProposal", tag="TOMs panel")

        # display the dialog for proposals

        # check to see if "OK" was selected. If so, save

        pass

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
        self.dlg.ProposalStatusID.setCurrentIndex(currProposalStatusID - 1)  # add one as index starts at 1
        self.dlg.ProposalCreateDate.setDate(currProposalCreateDate)
        self.dlg.ProposalNotes.setPlainText(currProposalNotes)

        self.dlg.show()

        QgsMessageLog.logMessage(("In onProposalDetails. Waiting for changes to form."),
                                 tag="TOMs panel")
        result = self.dlg.exec_()

        # pick up a singal that something has changed (not sure which one)
        # self.dlg.attributeChanged.connect(self.onProposalChanged)

        # See if OK was pressed
        if result:

            try:

                self.Proposals.startEditing()

                # Update the existing feature

                #idxProposalID = self.Proposals.fieldNameIndex("ProposalID")
                QgsMessageLog.logMessage(
                    ("In onProposalDetails. Attempting save. ID: " + str(currProposal.id()) + " CreateDate: " + str(self.dlg.ProposalCreateDate.text()) +
                     " ProposalStatusID: " + str(self.dlg.ProposalStatusID.currentIndex()+1) + " ProposalNotes: " + self.dlg.ProposalNotes.toPlainText()), tag="TOMs panel")

                self.Proposals.changeAttributeValue(currProposal.id(), self.Proposals.fieldNameIndex("ProposalID"), currProposal.id())

                #  There is a problem with the format of the date passed here - and it is not saving correctly. Need to investigate further.
                # self.Proposals.changeAttributeValue(currProposal.id(), self.Proposals.fieldNameIndex("ProposalCreateDate"),
                #                                    str(self.dlg.ProposalCreateDate.text()))

                self.Proposals.changeAttributeValue(currProposal.id(), self.Proposals.fieldNameIndex("ProposalStatusID"),
                                                    self.dlg.ProposalStatusID.currentIndex()+1)

                self.Proposals.changeAttributeValue(currProposal.id(), self.Proposals.fieldNameIndex("ProposalNotes"),
                                                    str(self.dlg.ProposalNotes.toPlainText()))

                #self.Proposals.changeAttributeValue(currRestrictionID, idxChangeDate, currDate)


            except:
                # errorList = self.TOMslayer.commitErrors()
                for item in list(self.Proposals.commitErrors()):
                    QgsMessageLog.logMessage(("In onProposalDetails. Unexpected error: " + str(item)),
                                             tag="TOMs panel")

                # self.TOMslayer.rollBack()
                raise

            QgsMessageLog.logMessage(
                    ("In onProposalDetails. Successful save."), tag="TOMs panel")

        pass

    def onProposalChanged(self):
        QgsMessageLog.logMessage("In onProposalChanged", tag="TOMs panel")

        # display the dialog for proposals

        # check to see if "OK" was selected. If so, save

        pass

    def filterMapOnDate(self):
        """Filter main layer based on date and state options"""

        QgsMessageLog.logMessage("In filterMapOnDate", tag="TOMs panel")

        displayDate = self.dock.filterDate

        # https://gis.stackexchange.com/questions/94135/how-to-populate-a-combobox-with-layers-in-toc
        currProposal_cbIndex = self.dock.cb_ProposalsList.currentIndex()

        if currProposal_cbIndex == 0:
            currProposalID = 0
        else:
            currProposalID = self.dock.cb_ProposalsList.itemData(currProposal_cbIndex)
            currProposalTitle = self.dock.cb_ProposalsList.currentText()

        QgsMessageLog.logMessage("In filterMapOnDate. filterDateL: " + displayDate.toString() + " ProposalID: " + str(currProposalID), tag="TOMs panel")

        # Filter the display based on the details provided

        dateChoosen = self.dlg.filterDate.text()
        QgsExpressionContextUtils.setProjectVariable('ViewAtDate', dateChoosen)

        tmpOrders = self.dlg.cb_ProposalsList

        if currProposalID > 0:
            pass

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
        filterString = '"OpenDate2" <= ' + dateChoosenFormatted + ' AND ("CloseDate1" > ' + dateChoosenFormatted + '  OR "CloseDate2"  IS  NULL)' + ' AND ' + tmpOrdersFilterString

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

