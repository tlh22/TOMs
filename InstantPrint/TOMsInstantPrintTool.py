# -*- coding: utf-8 -*-
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    copyright            : (C) 2014-2015 by Sandro Mani / Sourcepole AG
#    email                : smani@sourcepole.ch

# T Hancock (180607) generate a subclass of Sandro's class


from PyQt5.QtCore import (
    Qt, QSettings, QPointF, QRectF, QRect, QUrl, pyqtSignal, QLocale, QMetaObject
    )
from PyQt5.QtGui import (
    QColor, QDesktopServices, QIcon)
from PyQt5.QtWidgets import (
    QDialog, QDialogButtonBox, QMessageBox, QFileDialog, QListWidgetItem, QListWidget, QCheckBox
    )
from PyQt5.QtPrintSupport import (
    QPrintDialog, QPrinter
    )
from TOMs.core.TOMsMessageLog import TOMsMessageLog
from qgis.core import (
    Qgis,
    QgsRectangle, QgsLayoutManager, QgsPointXY as QgsPoint, Qgis, QgsProject, QgsWkbTypes, QgsLayoutExporter,
    QgsPrintLayout, QgsLayoutItemRegistry, PROJECT_SCALES, QgsLayoutItemMap,
    QgsMessageLog, QgsExpression, QgsFeatureRequest
    )
from qgis.gui import (
    QgisInterface, QgsMapTool, QgsRubberBand
    )
import os
import re
import sys, traceback

from .InstantPrintTool import InstantPrintTool
from ..restrictionTypeUtilsClass import RestrictionTypeUtilsMixin, TOMsLayers
from .ui.accepted_Proposals_dialog import acceptedProposalsDialog
from .ui.printList_dialog import printListDialog

from ..constants import (
    ProposalStatus,
    RestrictionAction
)
from ..core.TOMsProposal import (TOMsProposal)

class TOMsInstantPrintTool(InstantPrintTool):

    def __init__(self, iface, proposalsManager):

        self.iface = iface
        self.proposalsManager = proposalsManager
        self.tableNames = self.proposalsManager.tableNames

        InstantPrintTool.__init__(self, iface)
        self.dialog.hidden.connect(self._InstantPrintTool__onDialogHidden)  # not quite sure why this has to be included ...

        # TH (180608) change signals to new functions
        self.dialogui.comboBox_layouts.currentIndexChanged.disconnect(self._InstantPrintTool__selectLayout)
        self.dialogui.comboBox_layouts.currentIndexChanged.connect(self.TOMsSelectLayout)

        self.exportButton.clicked.disconnect(self._InstantPrintTool__export)
        self.exportButton.clicked.connect(self.TOMsExport)

        try:
            self.dialogui.comboBox_scale.scaleChanged.disconnect(self._InstantPrintTool__changeScale)
        except Exception as e:
            TOMsMessageLog.logMessage("In TOMsInstantPrintTool.init. error: {}".format(e), level=Qgis.Warning)

        self.dialogui.comboBox_scale.scaleChanged.connect(self.TOMsChangeScale)

        # try setting atlas to be the current layout - and set scale (and possible remove any others)
        self.initialisePrintdialog()

        #self.dialogui.comboBox_scale.setEnabled(False)

    def initialisePrintdialog(self):
        # find the first atlas dialog and set it as current. Also amend the

        for i in range(self.dialogui.comboBox_layouts.count()):
            currLayout = self.dialogui.comboBox_layouts.itemData(i)
            if currLayout.atlas():
                self.dialogui.comboBox_layouts.setCurrentIndex(i)
                # set to scale for layout
                self.mapitem = currLayout.referenceMap()
                layoutScale = self.mapitem.scale()
                self.dialogui.comboBox_scale.setScale(layoutScale)

                # TODO: somehow have to disable combobox for scaled atlas ...
                self.dialogui.comboBox_scale.setEnabled(False)

                TOMsMessageLog.logMessage("In initialisePrintdialog .. scale box notEnabled ...", level=Qgis.Info)

                return

    def createAcceptedProposalcb(self):
        TOMsMessageLog.logMessage("In createAcceptedProposalcb", level=Qgis.Info)
        # set up a "NULL" field for "No proposals to be shown"

        self.acceptedProposalDialog.cb_AcceptedProposalsList.clear()

        for (currProposalID, currProposalTitle, currProposalStatusID, currProposalOpenDate, currProposal) in sorted(
                self.proposalsManager.getProposalsListWithStatus(ProposalStatus.ACCEPTED), key=lambda f: f[1]):
            TOMsMessageLog.logMessage(
                "In createProposalcb: queryString: " + str(currProposalID) + ":" + currProposalTitle, level=Qgis.Info)
            self.acceptedProposalDialog.cb_AcceptedProposalsList.addItem(currProposalTitle, currProposalID)

    def TOMsSelectLayout(self):

        # TH (180608): Need to be able to accept composers with multiple maps - so over ride original

        if not self.dialog.isVisible():
            return
        activeIndex = self.dialogui.comboBox_layouts.currentIndex()
        if activeIndex < 0:
            return

        layout_name = self.dialogui.comboBox_layouts.currentText()
        self.layoutView = self.projectLayoutManager.layoutByName(layout_name)
        self.layoutInterface = self.projectLayoutManager.layoutByName(layout_name)

        layout = self.dialogui.comboBox_layouts.itemData(activeIndex)
        self.mapitem = layout.referenceMap()
        layoutScale = self.mapitem.scale()

        self.exportButton.setEnabled(True)

        # self.layoutView = layoutView
        # self.mapitem = maps[0]

        if layout.atlas().enabled():
            TOMsMessageLog.logMessage("In TOMsSelectLayout. This one has an atlas ...", level=Qgis.Info)

            # tidy - if required
            self.iface.mapCanvas().scene().removeItem(self.rubberband)
            self.rubberband = None

            # set to scale for layout
            self.dialogui.comboBox_scale.setScale(layoutScale)
            # perhaps call change
            self.TOMsChangeScale()

            # somehow have to disable combobox
            self.dialogui.comboBox_scale.setEnabled(False)
            TOMsMessageLog.logMessage("In TOMsSelectLayout .. scale box notEnabled ...", level=Qgis.Info)

            # sort out export process ...
            try:
                self.exportButton.clicked.disconnect(self._InstantPrintTool__export)
                self.exportButton.clicked.connect(self.TOMsExport)
            except TypeError:
                TOMsMessageLog.logMessage("In TOMsSelectLayout. export tools already correctly connected ...",
                                          level=Qgis.Warning)
            else:
                exc_type, exc_value, exc_traceback = sys.exc_info()
                TOMsMessageLog.logMessage(
                    'In TOMsSelectLayout. export tools issue {}'.format(
                        repr(traceback.extract_tb(exc_traceback))),
                    level=Qgis.Warning)

        else:
            TOMsMessageLog.logMessage("In TOMsSelectLayout. This one does NOT have an atlas ...", level=Qgis.Info)
            self.dialogui.comboBox_scale.setEnabled(True)
            self.dialogui.comboBox_scale.setScale(layoutScale)
            #self.dialogui.comboBox_scale.setScale(1 / 500)  # composer may not have a "scale" item
            #self.__createRubberBand()

            #self.layoutView = layoutView
            #self.mapitem = layout.referenceMap()
            #self.dialogui.comboBox_scale.setScale(self.mapitem.scale())
            self._InstantPrintTool__createRubberBand()

            try:
                self.exportButton.clicked.disconnect(self.TOMsExport)
                self.exportButton.clicked.connect(self._InstantPrintTool__export)
            except TypeError:
                TOMsMessageLog.logMessage("In TOMsSelectLayout. export tools already correctly connected ...",
                                          level=Qgis.Warning)
            else:
                exc_type, exc_value, exc_traceback = sys.exc_info()
                TOMsMessageLog.logMessage(
                    'In TOMsSelectLayout. export tools issue {}'.format(
                        repr(traceback.extract_tb(exc_traceback))),
                    level=Qgis.Warning)

    def TOMsChangeScale(self):
        TOMsMessageLog.logMessage("In TOMsChangeScale ... ", level=Qgis.Info)

        self._InstantPrintTool__changeScale()

        TOMsMessageLog.logMessage("In TOMsChangeScale. Checking for atlas ", level=Qgis.Info)

        layout = self.dialogui.comboBox_layouts.itemData(self.dialogui.comboBox_layouts.currentIndex())
        if layout.atlas().enabled():
            if self.rubberband:
                self.iface.mapCanvas().scene().removeItem(self.rubberband)
            if self.oldrubberband:
                self.iface.mapCanvas().scene().removeItem(self.oldrubberband)
            self.rubberband = None
            TOMsMessageLog.logMessage("In TOMsChangeScale .. scale box notEnabled ...", level=Qgis.Info)
            self.dialogui.comboBox_scale.setEnabled(False)

    def TOMsExport(self):

        # TH (180608): Export function to deal with atlases

        settings = QSettings()
        format = self.dialogui.comboBox_fileformat.itemData(self.dialogui.comboBox_fileformat.currentIndex())

        # TH (180608): Check to see whether or not the Composer is an Atlas
        currPrintLayout = self.layoutView
        # currLayoutAtlas = currPrintLayout.atlasComposition()

        self.proposalForPrintingStatusText = "PROPOSED"
        self.proposalPrintTypeDetails = "Print Date"
        self.openDateForPrintProposal = self.proposalsManager.date()

        # self.Proposals = self.tableNames.setLayer("Proposals")

        if currPrintLayout.atlas():

            if self.proposalsManager.currentProposal() == 0:

                # Include a dialog to check which proposal is required - or everything

                self.proposalForPrintingStatusText = "CONFIRMED"
                self.proposalPrintTypeDetails = "Effective Date"

                # set the dialog (somehow)
                self.acceptedProposalDialog = acceptedProposalsDialog()

                self.createAcceptedProposalcb()
                self.acceptedProposalDialog.show()

                # Run the dialog event loop
                result = self.acceptedProposalDialog.exec_()
                # See if OK was pressed
                if result:

                    # Take the output from the form and set the current Proposal
                    indexProposal = self.acceptedProposalDialog.cb_AcceptedProposalsList.currentIndex()
                    proposalNrForPrinting = self.acceptedProposalDialog.cb_AcceptedProposalsList.itemData(indexProposal)
                    TOMsMessageLog.logMessage("In TOMsExport. Choosing " + str(proposalNrForPrinting), level=Qgis.Info)
                    printProposal = TOMsProposal(self.proposalsManager, proposalNrForPrinting)
                    # self.openDateForPrintProposal = self.proposalsManager.getProposalOpenDate(proposalNrForPrinting)
                    self.openDateForPrintProposal = printProposal.getProposalOpenDate()
                    TOMsMessageLog.logMessage("In TOMsExport. Open date for printing is {}".format(self.openDateForPrintProposal), level=Qgis.Info)
                else:
                    return

            else:

                proposalNrForPrinting = self.proposalsManager.currentProposal()
                printProposal = self.proposalsManager.currentProposalObject()

            self.TOMsExportAtlas(printProposal)

        else:

            self.__export()

    def TOMsExportAtlas(self, printProposalObject):

        # TH (180608): Export function to deal with atlases

        settings = QSettings()
        format = self.dialogui.comboBox_fileformat.itemData(self.dialogui.comboBox_fileformat.currentIndex())

        # TH (180608): Check to see whether or not the Composer is an Atlas
        currPrintLayout = self.layoutView
        currLayoutAtlas = currPrintLayout.atlas()

        success = False

        # https://gis.stackexchange.com/questions/77848/programmatically-load-composer-from-template-and-generate-atlas-using-pyqgis?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

        self.TOMsSetAtlasValues(currPrintLayout)

        if printProposalObject.thisProposalNr == 0:
            formatted_currProposalTitle = "CurrentRestrictions_({date})".format(
                date=self.proposalsManager.date().toString('yyyyMMMdd'))
            currRevisionDate = self.proposalsManager.date()
        else:
            currProposalTitle = printProposalObject.getProposalTitle()
            formatted_currProposalTitle = re.sub(r'[^\w]', '_', currProposalTitle)
            currRevisionDate = printProposalObject.getProposalOpenDate()

        currProposalOpenDate = currRevisionDate  # TODO:Need to check if this is needed ...

        TOMsMessageLog.logMessage("In TOMsExportAtlas. printProposal:{}|".format(printProposalObject.thisProposalNr),
                                  level=Qgis.Info)

        # get the map tiles that are affected by the Proposal

        proposalTileDictionaryForDate = printProposalObject.getProposalTileDictionaryForDate(currRevisionDate)

        if len(proposalTileDictionaryForDate) == 0:
            return
        # Now check which tiles to use
        self.tilesToPrint = self.TOMsChooseTiles(proposalTileDictionaryForDate)

        TOMsMessageLog.logMessage("In TOMsExportAtlas. now have " + str(len(self.tilesToPrint)) + " items ....",
                                  level=Qgis.Info)

        if len(self.tilesToPrint) == 0:
            return

        # get the output location
        dirName = QFileDialog.getExistingDirectory(
            self.iface.mainWindow(),
            self.tr("Export Composition"),
            settings.value("/instantprint/lastdir", ""),
            QFileDialog.ShowDirsOnly
        )
        if not dirName:
            return

        settings.setValue("/instantprint/lastdir", dirName)

        # TODO: What happens if mapsheetname is not set
        
        tileIDList = ""
        firstTile = True
        for tileNr, tile in self.tilesToPrint.items():
            if firstTile:
                tileIDList = '\'' + str(tile.getMapSheetName()) + '\''
                firstTile = False
            else:
                tileIDList = tileIDList + ',\'' + str(tile.getMapSheetName()) + '\''

        currLayoutAtlas.setFilterFeatures(True)
        currLayoutAtlas.setFilterExpression(' "mapsheetname" in ({tileList})'.format(tileList=tileIDList))

        composerRevisionNr = currPrintLayout.itemById('revisionNr')
        composerEffectiveDate = currPrintLayout.itemById('effectiveDate')
        composerProposalStatus = currPrintLayout.itemById('proposalStatus')

        if composerProposalStatus is not None:
            composerProposalStatus.setText(self.proposalForPrintingStatusText)
        else:
            QMessageBox.warning(self.iface.mainWindow(), self.tr("Missing label in Layout"),
                                self.tr("Missing label 'proposalStatus'"))

        composerPrintTypeDetails = currPrintLayout.itemById('printTypeDetails')
        if composerPrintTypeDetails is not None:
            composerPrintTypeDetails.setText(self.proposalPrintTypeDetails)
        else:
            QMessageBox.warning(self.iface.mainWindow(), self.tr("Missing label in Layout"),
                                self.tr("Missing label 'printTypeDetails'"))


        TOMsMessageLog.logMessage("In TOMsExportAtlas. Now printing " + str(currLayoutAtlas.count()) + " items ....",
                                 level=Qgis.Info)

        currLayoutAtlas.setEnabled(True)
        currLayoutAtlas.updateFeatures()
        currLayoutAtlas.beginRender()

        altasFeatureFound = currLayoutAtlas.first()

        while altasFeatureFound:

            currTileNr = currLayoutAtlas.nameForPage(currLayoutAtlas.currentFeatureNumber())

            currLayoutAtlas.refreshCurrentFeature()
            tileWithDetails = None
            for tileNr, tile in self.tilesToPrint.items():
                if int(tileNr) == int(currTileNr):
                    tileWithDetails = tile

            if tileWithDetails == None:
                TOMsMessageLog.logMessage("In TOMsExportAtlas. Tile with details not found ....", level=Qgis.Info)
                QMessageBox.warning(self.iface.mainWindow(), self.tr("Print Failed"),
                                    self.tr("Could not find details for " + str(currTileNr)))
                break

            currMapSheetName = tileWithDetails.getMapSheetName()
            TOMsMessageLog.logMessage("In TOMsExportAtlas. tile nr: " + str(tileWithDetails.tileNr()) + ":" + currMapSheetName +
                                      " CurrRevisionNr: " + #str(tileWithDetails["CurrRevisionNr"]) +
                                            str(tileWithDetails.getRevisionNr_AtDate()) +
                                      " RevisionDate: " + #str(tileWithDetails["LastRevisionDate"])  +
                                            str(tileWithDetails.getLastRevisionDate_AtDate())  +
                                      " lastUpdateDate: " + currProposalOpenDate.toString('dd-MMM-yyyy'),
                                     level=Qgis.Info)

            if self.proposalForPrintingStatusText == "CONFIRMED":
                composerRevisionNr.setText(str(tileWithDetails.getRevisionNr_AtDate()))
                composerEffectiveDate.setText(
                    '{date}'.format(date=tileWithDetails.getLastRevisionDate_AtDate().toString('dd-MMM-yyyy')))
            else:
                try:
                    composerRevisionNr.setText(str(int(tileWithDetails.getCurrentRevisionNr()) + 1))
                except Exception as e:
                    composerRevisionNr.setText('1')

                # For the Proposal, use the current view date
                composerEffectiveDate.setText(
                    '{date}'.format(date=currProposalOpenDate.toString('dd-MMM-yyyy')))

            TOMsMessageLog.logMessage("In TOMsExportAtlas. status: {}; composerRevisionNr: {}; effectiveDate: {}".format(self.proposalForPrintingStatusText, composerRevisionNr.text(), composerEffectiveDate.text()),
                                     level=Qgis.Info)


            filename = formatted_currProposalTitle + "_" + currMapSheetName + "." + self.dialogui.comboBox_fileformat.currentText().lower()

            outputFile = os.path.join(dirName, filename)

            exporter = QgsLayoutExporter(currLayoutAtlas.layout())

            TOMsMessageLog.logMessage(
                "In TOMsExportAtlas. outputfile: {}; type: {}".format(
                    outputFile, self.dialogui.comboBox_fileformat.currentText().lower()),
                level=Qgis.Info)

            if self.dialogui.comboBox_fileformat.currentText().lower() == u"pdf":
                result = exporter.exportToPdf(outputFile, QgsLayoutExporter.PdfExportSettings())
            elif self.dialogui.comboBox_fileformat.currentText().lower() == u"png":
                result = exporter.exportToImage(outputFile, QgsLayoutExporter.ImageExportSettings())
            elif self.dialogui.comboBox_fileformat.currentText().lower() == u"svg":
                result = exporter.exportToSvg(outputFile, QgsLayoutExporter.SvgExportSettings())
            else:
                QMessageBox.warning(self.iface.mainWindow(), self.tr("Print Failed"),
                                    self.tr("No type choosen " + exporter.errorFile()))

            if result != QgsLayoutExporter.Success:
                QMessageBox.warning(self.iface.mainWindow(), self.tr("Print Failed"),
                                    self.tr("Failed to print " + exporter.errorFile()))
                break

            altasFeatureFound = currLayoutAtlas.next()

        currLayoutAtlas.endRender()

        QMessageBox.information(self.iface.mainWindow(), "Information",
                                ("Printing completed"))

    def TOMsReloadLayouts(self, removed=None):
        if not self.dialog.isVisible():
            # Make it less likely to hit the issue outlined in https://github.com/qgis/QGIS/pull/1938
            return

        self.dialogui.comboBox_layouts.blockSignals(True)
        prev = None
        if self.dialogui.comboBox_layouts.currentIndex() >= 0:
            prev = self.dialogui.comboBox_layouts.currentText()
        self.dialogui.comboBox_layouts.clear()
        active = 0
        for composer in self.iface.activeComposers():
            if composer != removed and composer.composerWindow():
                cur = composer.composerWindow().windowTitle()
                self.dialogui.comboBox_layouts.addItem(cur, composer)
                if prev == cur:
                    active = self.dialogui.comboBox_layouts.count() - 1
        self.dialogui.comboBox_layouts.setCurrentIndex(-1)  # Ensure setCurrentIndex below actually changes an index
        self.dialogui.comboBox_layouts.blockSignals(False)
        if self.dialogui.comboBox_layouts.count() > 0:
            self.dialogui.comboBox_layouts.setCurrentIndex(active)

            # TH (180608): Check whether or not the active item is an Atlas
            layoutView = self.dialogui.comboBox_layouts.itemData(active)
            currPrintLayout = layoutView.composition()
            currLayoutAtlas = currPrintLayout.atlasComposition()

            if currLayoutAtlas.enabled():
                self.dialogui.comboBox_scale.setEnabled(False)
            else:
                self.dialogui.comboBox_scale.setEnabled(True)

            self.exportButton.setEnabled(True)
        else:
            self.exportButton.setEnabled(False)
            self.dialogui.comboBox_scale.setEnabled(False)

    def TOMsSetAtlasValues(self, currPrintLayout):

        # Need to set date and status

        composerEffectiveDate = currPrintLayout.itemById('effectiveDate')

        composerProposalStatus = currPrintLayout.itemById('proposalStatus')
        composerProposalStatus.setText(self.proposalForPrintingStatusText)

    def TOMsChooseTiles(self, tileDictionary):
        # function to display and allow choice of tiles for printing

        TOMsMessageLog.logMessage("In TOMsChooseTiles ", level=Qgis.Info)

        # set the dialog (somehow)

        tilesToPrint = []
        #idxMapTileId = self.tableNames.setLayer("MapGrid").fields().indexFromName("id")

        #tileSet = set()
        for currTileNr, currTile in tileDictionary.items():
            TOMsMessageLog.logMessage("In TOMsChooseTiles: " + str(currTileNr) + ":" +str(currTile.tileNr()) + " mapsheet: " + currTile.getMapSheetName() + " CurrRevisionNr: " + str(currTile.getCurrentRevisionNr()) + " RevisionNrAtDate: " + str(currTile.getRevisionNr_AtDate()), level=Qgis.Info)
            #tileSet.add(tile)

        self.tileListDialog = printListDialog(tileDictionary)

        self.tileListDialog.show()

        # Run the dialog event loop
        result = self.tileListDialog.exec_()
        # See if OK was pressed
        if result:
            TOMsMessageLog.logMessage("In TOMsChooseTiles. Now printing - getValues ...",
                                     level=Qgis.Info)
            tilesToPrint = self.tileListDialog.getValues()

        # ToDo: deal with cancel

        # https://stackoverflow.com/questions/46057737/dynamically-changeable-qcheckbox-list
        return tilesToPrint


class printListDialog(printListDialog, QDialog):
    def __init__(self, initValuesDict, parent=None):
        QDialog.__init__(self, parent)

        # initValues is set of features (in this case MapTile features); idxValue is the index to the set
        # Set up the user interface from Designer.
        self.setupUi(self)

        TOMsMessageLog.logMessage("In printListDialog. Initiating ...",             level=Qgis.Info)

        self.initValuesDict = initValuesDict # set

        #self.idxValue = idxValue
        self.tilesToPrint = self.initValuesDict.copy()

        self.LIST = self.findChild(QListWidget, "tileList")
        self.cbToggleTiles = self.findChild(QCheckBox, "cb_ToggleTiles")
        self.buttonBox = self.findChild(QDialogButtonBox, "buttonBox")
        self.cbToggleTiles.setCheckState(Qt.Checked)

        QMetaObject.connectSlotsByName(self)

        self.populateTileListDialog()

        self.LIST.itemChanged.connect(self.changeValues)
        self.cbToggleTiles.stateChanged.connect(self.toggleValues)

    def changeValues(self, element):
        '''Whenever a checkbox is checked, modify the values'''
        # Check if we check or uncheck the value:
        """TOMsMessageLog.logMessage(
            "In printListDialog. In changeValues for: " + str(element.data(Qt.DisplayRole)),
            level=Qgis.Info)"""

        if element.checkState() == Qt.Checked:
            #self.tilesToPrint.append(element.data(Qt.DisplayRole))
            self.addFeatureToSet(element.data(Qt.DisplayRole))
        else:
            self.removedFeatureFromSet(element.data(Qt.DisplayRole))

    def addFeatureToSet(self, valueToAdd):

        for featureNr, feature in sorted(self.initValuesDict.items()):
            if feature.getMapSheetName() == valueToAdd:
                self.tilesToPrint[feature.tileNr()] = feature
                TOMsMessageLog.logMessage(
                    "In TOMsTileListDialog. Adding: " + feature.getMapSheetName() + " ; " + str(len(self.tilesToPrint)),
                    level=Qgis.Info)
                return

    def removedFeatureFromSet(self, valueToRemove):

        for featureNr, feature in sorted(self.initValuesDict.items()):
            if feature.getMapSheetName() == valueToRemove:
                del self.tilesToPrint[feature.tileNr()]
                TOMsMessageLog.logMessage(
                    "In TOMsTileListDialog. Removing: " + feature.getMapSheetName() + " ; " + str(len(self.tilesToPrint)) ,
                    level=Qgis.Info)
                return

    def toggleValues(self):
        '''Whenever a checkbox is checked, modify the values'''
        # Check if we check or uncheck the value:

        TOMsMessageLog.logMessage(
            "In TOMsTileListDialog. In toggleValues. toggleState: " + str(self.cbToggleTiles.checkState()),
            level=Qgis.Info)

        if self.cbToggleTiles.checkState() == Qt.Checked:
            for i in range(self.LIST.count()):
                # attr = feature.attributes()
                element = QListWidgetItem(self.LIST.item(i).text())
                self.LIST.item(i).setCheckState(Qt.Checked)

        else:

            for i in range(self.LIST.count()):
                # attr = feature.attributes()
                element = QListWidgetItem(self.LIST.item(i).text())
                self.LIST.item(i).setCheckState(Qt.Unchecked)

    def populateTileListDialog(self, txtFilter=None):
        '''Fill the QListWidget with values'''
        # Delete everything
        TOMsMessageLog.logMessage("In TOMsTileListDialog. In populateList",
                                 level=Qgis.Info)

        self.LIST.clear()
        #for feature in sorted(self.initValues, key=lambda f: f[self.idxValue]):

        for featureNr, feature in sorted(self.initValuesDict.items()):
            element = QListWidgetItem(str(feature.tileNr()))
            element.setData(Qt.UserRole, feature)
            element.setText(str(feature.getMapSheetName()))

            #self.tilesToPrint.add(feature)
            element.setCheckState(Qt.Checked)

            self.LIST.addItem(element)

    def getValues(self):
        '''Return the selected values of the QListWidget'''

        TOMsMessageLog.logMessage("In TOMsTileListDialog. In getValues. Len List = " + str(len(self.tilesToPrint)),
                                 level=Qgis.Info)

        for featureNr, feature in sorted(self.tilesToPrint.items()):
            TOMsMessageLog.logMessage("In Choose tiles form ... Returning " + str(feature.getMapSheetName()),
                                     level=Qgis.Info)

        return self.tilesToPrint
