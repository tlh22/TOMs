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

import os
import re
import sys
import traceback

from qgis.core import Qgis, QgsLayoutExporter
from qgis.PyQt.QtCore import QMetaObject, QSettings, Qt
from qgis.PyQt.QtWidgets import (
    QCheckBox,
    QDialog,
    QDialogButtonBox,
    QFileDialog,
    QListWidget,
    QListWidgetItem,
    QMessageBox,
)
from qgis.utils import iface

from ..constants import ProposalStatus
from ..core.tomsMessageLog import TOMsMessageLog
from ..core.tomsProposal import TOMsProposal
from .instantPrintTool import InstantPrintTool
from .ui.acceptedProposalsDialog import AcceptedProposalsDialog
from .ui.printListDialog import PrintListDialog as printListDialogUI


class TOMsInstantPrintTool(InstantPrintTool):
    def __init__(self, proposalsManager):

        self.proposalsManager = proposalsManager
        self.tableNames = self.proposalsManager.tableNames

        InstantPrintTool.__init__(self, iface)
        self.dialog.hidden.connect(
            self._InstantPrintTool__onDialogHidden
        )  # not quite sure why this has to be included ...

        # TH (180608) change signals to new functions
        self.dialogui.comboBoxLayouts.currentIndexChanged.disconnect(
            self._InstantPrintTool__selectLayout
        )
        self.dialogui.comboBoxLayouts.currentIndexChanged.connect(self.tomsSelectLayout)

        self.exportButton.clicked.disconnect(self._InstantPrintTool__export)
        self.exportButton.clicked.connect(self.tomsExport)

        try:
            self.dialogui.comboBoxScale.scaleChanged.disconnect(
                self._InstantPrintTool__changeScale
            )
        except Exception as e:
            TOMsMessageLog.logMessage(
                "In TOMsInstantPrintTool.init. error: {}".format(e), level=Qgis.Warning
            )

        self.dialogui.comboBoxScale.scaleChanged.connect(self.tomsChangeScale)

        # try setting atlas to be the current layout - and set scale (and possible remove any others)
        self.initialisePrintdialog()

        # self.dialogui.comboBoxScale.setEnabled(False)
        self.layoutInterface = None
        self.proposalForPrintingStatusText = ""
        self.proposalPrintTypeDetails = ""
        self.acceptedProposalDialog = None
        self.openDateForPrintProposal = None
        self.tilesToPrint = None
        self.tileListDialog = None

    def initialisePrintdialog(self):
        # find the first atlas dialog and set it as current. Also amend the

        for i in range(self.dialogui.comboBoxLayouts.count()):
            currLayout = self.dialogui.comboBoxLayouts.itemData(i)
            if currLayout.atlas():
                self.dialogui.comboBoxLayouts.setCurrentIndex(i)
                # set to scale for layout
                self.mapitem = currLayout.referenceMap()
                layoutScale = self.mapitem.scale()
                self.dialogui.comboBoxScale.setScale(layoutScale)

                # TODO: somehow have to disable combobox for scaled atlas ...
                self.dialogui.comboBoxScale.setEnabled(False)

                TOMsMessageLog.logMessage(
                    "In initialisePrintdialog .. scale box notEnabled ...",
                    level=Qgis.Info,
                )

                return

    def createAcceptedProposalcb(self):
        TOMsMessageLog.logMessage("In createAcceptedProposalcb", level=Qgis.Info)
        # set up a "NULL" field for "No proposals to be shown"

        self.acceptedProposalDialog.cb_AcceptedProposalsList.clear()

        for (currProposalID, currProposalTitle, _, _, _,) in sorted(
            self.proposalsManager.getProposalsListWithStatus(ProposalStatus.ACCEPTED),
            key=lambda f: f[1],
        ):
            TOMsMessageLog.logMessage(
                "In createProposalcb: queryString: "
                + str(currProposalID)
                + ":"
                + currProposalTitle,
                level=Qgis.Info,
            )
            self.acceptedProposalDialog.cb_AcceptedProposalsList.addItem(
                currProposalTitle, currProposalID
            )

    def tomsSelectLayout(self):

        # TH (180608): Need to be able to accept composers with multiple maps - so over ride original

        if not self.dialog.isVisible():
            return
        activeIndex = self.dialogui.comboBoxLayouts.currentIndex()
        if activeIndex < 0:
            return

        layoutName = self.dialogui.comboBoxLayouts.currentText()
        self.layoutView = self.projectLayoutManager.layoutByName(layoutName)
        self.layoutInterface = self.projectLayoutManager.layoutByName(layoutName)

        layout = self.dialogui.comboBoxLayouts.itemData(activeIndex)
        self.mapitem = layout.referenceMap()
        layoutScale = self.mapitem.scale()

        self.exportButton.setEnabled(True)

        # self.layoutView = layoutView
        # self.mapitem = maps[0]

        if layout.atlas().enabled():
            TOMsMessageLog.logMessage(
                "In TOMsSelectLayout. This one has an atlas ...", level=Qgis.Info
            )

            # tidy - if required
            iface.mapCanvas().scene().removeItem(self.rubberband)
            self.rubberband = None

            # set to scale for layout
            self.dialogui.comboBoxScale.setScale(layoutScale)
            # perhaps call change
            self.tomsChangeScale()

            # somehow have to disable combobox
            self.dialogui.comboBoxScale.setEnabled(False)
            TOMsMessageLog.logMessage(
                "In TOMsSelectLayout .. scale box notEnabled ...", level=Qgis.Info
            )

            # sort out export process ...
            try:
                self.exportButton.clicked.disconnect(self._InstantPrintTool__export)
                self.exportButton.clicked.connect(self.tomsExport)
            except TypeError:
                TOMsMessageLog.logMessage(
                    "In TOMsSelectLayout. export tools already correctly connected ...",
                    level=Qgis.Warning,
                )
            else:
                _, _, excTraceback = sys.exc_info()
                TOMsMessageLog.logMessage(
                    "In TOMsSelectLayout. export tools issue {}".format(
                        repr(traceback.extract_tb(excTraceback))
                    ),
                    level=Qgis.Warning,
                )

        else:
            TOMsMessageLog.logMessage(
                "In TOMsSelectLayout. This one does NOT have an atlas ...",
                level=Qgis.Info,
            )
            self.dialogui.comboBoxScale.setEnabled(True)
            self.dialogui.comboBoxScale.setScale(layoutScale)
            # self.dialogui.comboBoxScale.setScale(1 / 500)  # composer may not have a "scale" item
            # self.__createRubberBand()

            # self.layoutView = layoutView
            # self.mapitem = layout.referenceMap()
            # self.dialogui.comboBoxScale.setScale(self.mapitem.scale())
            self._InstantPrintTool__createRubberBand()

            try:
                self.exportButton.clicked.disconnect(self.tomsExport)
                self.exportButton.clicked.connect(self._InstantPrintTool__export)
            except TypeError:
                TOMsMessageLog.logMessage(
                    "In TOMsSelectLayout. export tools already correctly connected ...",
                    level=Qgis.Warning,
                )
            else:
                _, _, excTraceback = sys.exc_info()
                TOMsMessageLog.logMessage(
                    "In TOMsSelectLayout. export tools issue {}".format(
                        repr(traceback.extract_tb(excTraceback))
                    ),
                    level=Qgis.Warning,
                )

    def tomsChangeScale(self):
        TOMsMessageLog.logMessage("In TOMsChangeScale ... ", level=Qgis.Info)

        self._InstantPrintTool__changeScale()

        TOMsMessageLog.logMessage(
            "In TOMsChangeScale. Checking for atlas ", level=Qgis.Info
        )

        layout = self.dialogui.comboBoxLayouts.itemData(
            self.dialogui.comboBoxLayouts.currentIndex()
        )
        if layout.atlas().enabled():
            if self.rubberband:
                iface.mapCanvas().scene().removeItem(self.rubberband)
            if self.oldrubberband:
                iface.mapCanvas().scene().removeItem(self.oldrubberband)
            self.rubberband = None
            TOMsMessageLog.logMessage(
                "In TOMsChangeScale .. scale box notEnabled ...", level=Qgis.Info
            )
            self.dialogui.comboBoxScale.setEnabled(False)

    def tomsExport(self):

        # TH (180608): Export function to deal with atlases

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
                self.acceptedProposalDialog = AcceptedProposalsDialog()

                self.createAcceptedProposalcb()
                self.acceptedProposalDialog.show()

                # Run the dialog event loop
                result = self.acceptedProposalDialog.exec_()
                # See if OK was pressed
                if result:

                    # Take the output from the form and set the current Proposal
                    proposalNrForPrinting = (
                        self.acceptedProposalDialog.cb_AcceptedProposalsList.currentData()
                    )

                    TOMsMessageLog.logMessage(
                        "In TOMsExport. Choosing " + str(proposalNrForPrinting),
                        level=Qgis.Info,
                    )
                    printProposal = TOMsProposal(
                        self.proposalsManager, proposalNrForPrinting
                    )
                    # self.openDateForPrintProposal = self.proposalsManager.getProposalOpenDate(proposalNrForPrinting)
                    self.openDateForPrintProposal = printProposal.getProposalOpenDate()
                    TOMsMessageLog.logMessage(
                        "In TOMsExport. Open date for printing is {}".format(
                            self.openDateForPrintProposal
                        ),
                        level=Qgis.Info,
                    )
                else:
                    return

            else:

                proposalNrForPrinting = self.proposalsManager.currentProposal()
                printProposal = self.proposalsManager.currentProposalObject()

            self.tomsExportAtlas(printProposal)

        else:

            self.__export()

    def tomsExportAtlas(self, printProposalObject):

        # TH (180608): Export function to deal with atlases

        settings = QSettings()

        # TH (180608): Check to see whether or not the Composer is an Atlas
        currPrintLayout = self.layoutView
        currLayoutAtlas = currPrintLayout.atlas()

        # https://gis.stackexchange.com/questions/77848/programmatically-load-composer-from-template-and-generate-atlas-using-pyqgis?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

        self.tomsSetAtlasValues(currPrintLayout)

        if printProposalObject.thisProposalNr == 0:
            formattedCurrProposalTitle = "CurrentRestrictions_({date})".format(
                date=self.proposalsManager.date().toString("yyyyMMMdd")
            )
            currRevisionDate = self.proposalsManager.date()
        else:
            currProposalTitle = printProposalObject.getProposalTitle()
            formattedCurrProposalTitle = re.sub(r"[^\w]", "_", currProposalTitle)
            currRevisionDate = printProposalObject.getProposalOpenDate()

        currProposalOpenDate = (
            currRevisionDate  # TODO:Need to check if this is needed ...
        )

        TOMsMessageLog.logMessage(
            "In TOMsExportAtlas. printProposal:{}|".format(
                printProposalObject.thisProposalNr
            ),
            level=Qgis.Info,
        )

        # get the map tiles that are affected by the Proposal

        proposalTileDictionaryForDate = (
            printProposalObject.getProposalTileDictionaryForDate(currRevisionDate)
        )

        if len(proposalTileDictionaryForDate) == 0:
            return
        # Now check which tiles to use
        self.tilesToPrint = self.tomsChooseTiles(proposalTileDictionaryForDate)

        TOMsMessageLog.logMessage(
            "In TOMsExportAtlas. now have "
            + str(len(self.tilesToPrint))
            + " items ....",
            level=Qgis.Info,
        )

        if len(self.tilesToPrint) == 0:
            return

        # get the output location
        dirName = QFileDialog.getExistingDirectory(
            iface.mainWindow(),
            self.tr("Export Composition"),
            settings.value("/instantprint/lastdir", ""),
            QFileDialog.ShowDirsOnly,
        )
        if not dirName:
            return

        settings.setValue("/instantprint/lastdir", dirName)

        tileIDList = ""
        firstTile = True
        for tile in self.tilesToPrint:
            if firstTile:
                tileIDList = str(tile)
                firstTile = False
            else:
                tileIDList = tileIDList + "," + str(tile)

        currLayoutAtlas.setFilterFeatures(True)
        currLayoutAtlas.setFilterExpression(
            ' "id" in ({tileList})'.format(tileList=tileIDList)
        )

        composerRevisionNr = currPrintLayout.itemById("revisionNr")
        composerEffectiveDate = currPrintLayout.itemById("effectiveDate")
        composerProposalStatus = currPrintLayout.itemById("proposalStatus")

        if composerProposalStatus is not None:
            composerProposalStatus.setText(self.proposalForPrintingStatusText)
        else:
            QMessageBox.warning(
                iface.mainWindow(),
                self.tr("Missing label in Layout"),
                self.tr("Missing label 'proposalStatus'"),
            )

        composerPrintTypeDetails = currPrintLayout.itemById("printTypeDetails")
        if composerPrintTypeDetails is not None:
            composerPrintTypeDetails.setText(self.proposalPrintTypeDetails)
        else:
            QMessageBox.warning(
                iface.mainWindow(),
                self.tr("Missing label in Layout"),
                self.tr("Missing label 'printTypeDetails'"),
            )

        TOMsMessageLog.logMessage(
            "In TOMsExportAtlas. Now printing "
            + str(currLayoutAtlas.count())
            + " items ....",
            level=Qgis.Info,
        )

        currLayoutAtlas.setEnabled(True)
        currLayoutAtlas.updateFeatures()
        currLayoutAtlas.beginRender()

        altasFeatureFound = currLayoutAtlas.first()

        while altasFeatureFound:

            currTileNr = int(
                currLayoutAtlas.nameForPage(currLayoutAtlas.currentFeatureNumber())
            )

            currLayoutAtlas.refreshCurrentFeature()

            tileWithDetails = proposalTileDictionaryForDate[currTileNr]

            if tileWithDetails is None:
                TOMsMessageLog.logMessage(
                    "In TOMsExportAtlas. Tile with details not found ....",
                    level=Qgis.Info,
                )
                QMessageBox.warning(
                    iface.mainWindow(),
                    self.tr("Print Failed"),
                    self.tr("Could not find details for " + str(currTileNr)),
                )
                break

            TOMsMessageLog.logMessage(
                "In TOMsExportAtlas. tile nr: "
                + str(currTileNr)
                + " CurrRevisionNr: "
                + str(  # str(tileWithDetails["CurrRevisionNr"]) +
                    tileWithDetails.getRevisionNrAtDate()
                )
                + " RevisionDate: "
                + str(  # str(tileWithDetails["LastRevisionDate"])  +
                    tileWithDetails.getLastRevisionDateAtDate()
                )
                + " lastUpdateDate: "
                + currProposalOpenDate.toString("dd-MMM-yyyy"),
                level=Qgis.Info,
            )

            if self.proposalForPrintingStatusText == "CONFIRMED":
                composerRevisionNr.setText(str(tileWithDetails.getRevisionNrAtDate()))
                composerEffectiveDate.setText(
                    "{date}".format(
                        date=tileWithDetails.getLastRevisionDateAtDate().toString(
                            "dd-MMM-yyyy"
                        )
                    )
                )
            else:
                try:
                    composerRevisionNr.setText(
                        str(int(tileWithDetails.getCurrentRevisionNr()) + 1)
                    )
                except Exception:
                    composerRevisionNr.setText("1")

                # For the Proposal, use the current view date
                composerEffectiveDate.setText(
                    "{date}".format(date=currProposalOpenDate.toString("dd-MMM-yyyy"))
                )

            TOMsMessageLog.logMessage(
                "In TOMsExportAtlas. status: {}; composerRevisionNr: {}; effectiveDate: {}".format(
                    self.proposalForPrintingStatusText,
                    composerRevisionNr.text(),
                    composerEffectiveDate.text(),
                ),
                level=Qgis.Info,
            )

            filename = (
                formattedCurrProposalTitle
                + "_"
                + str(currTileNr)
                + "."
                + self.dialogui.comboBoxFileFormat.currentText().lower()
            )

            outputFile = os.path.join(dirName, filename)

            exporter = QgsLayoutExporter(currLayoutAtlas.layout())

            TOMsMessageLog.logMessage(
                "In TOMsExportAtlas. outputfile: {}; type: {}".format(
                    outputFile, self.dialogui.comboBoxFileFormat.currentText().lower()
                ),
                level=Qgis.Info,
            )

            if self.dialogui.comboBoxFileFormat.currentText().lower() == "pdf":
                result = exporter.exportToPdf(
                    outputFile, QgsLayoutExporter.PdfExportSettings()
                )
            elif self.dialogui.comboBoxFileFormat.currentText().lower() == "png":
                result = exporter.exportToImage(
                    outputFile, QgsLayoutExporter.ImageExportSettings()
                )
            elif self.dialogui.comboBoxFileFormat.currentText().lower() == "svg":
                result = exporter.exportToSvg(
                    outputFile, QgsLayoutExporter.SvgExportSettings()
                )
            else:
                QMessageBox.warning(
                    iface.mainWindow(),
                    self.tr("Print Failed"),
                    self.tr("No type choosen " + exporter.errorFile()),
                )

            if result != QgsLayoutExporter.Success:
                QMessageBox.warning(
                    iface.mainWindow(),
                    self.tr("Print Failed"),
                    self.tr("Failed to print " + exporter.errorFile()),
                )
                break

            altasFeatureFound = currLayoutAtlas.next()

        currLayoutAtlas.endRender()

        QMessageBox.information(
            iface.mainWindow(), "Information", ("Printing completed")
        )

    def tomsReloadLayouts(self, removed=None):
        if not self.dialog.isVisible():
            # Make it less likely to hit the issue outlined in https://github.com/qgis/QGIS/pull/1938
            return

        self.dialogui.comboBoxLayouts.blockSignals(True)
        prev = None
        if self.dialogui.comboBoxLayouts.currentIndex() >= 0:
            prev = self.dialogui.comboBoxLayouts.currentText()
        self.dialogui.comboBoxLayouts.clear()
        active = 0
        for composer in iface.activeComposers():
            if composer != removed and composer.composerWindow():
                cur = composer.composerWindow().windowTitle()
                self.dialogui.comboBoxLayouts.addItem(cur, composer)
                if prev == cur:
                    active = self.dialogui.comboBoxLayouts.count() - 1
        self.dialogui.comboBoxLayouts.setCurrentIndex(
            -1
        )  # Ensure setCurrentIndex below actually changes an index
        self.dialogui.comboBoxLayouts.blockSignals(False)
        if self.dialogui.comboBoxLayouts.count() > 0:
            self.dialogui.comboBoxLayouts.setCurrentIndex(active)

            # TH (180608): Check whether or not the active item is an Atlas
            layoutView = self.dialogui.comboBoxLayouts.itemData(active)
            currPrintLayout = layoutView.composition()
            currLayoutAtlas = currPrintLayout.atlasComposition()

            if currLayoutAtlas.enabled():
                self.dialogui.comboBoxScale.setEnabled(False)
            else:
                self.dialogui.comboBoxScale.setEnabled(True)

            self.exportButton.setEnabled(True)
        else:
            self.exportButton.setEnabled(False)
            self.dialogui.comboBoxScale.setEnabled(False)

    def tomsSetAtlasValues(self, currPrintLayout):

        # Need to set date and status

        composerProposalStatus = currPrintLayout.itemById("proposalStatus")
        composerProposalStatus.setText(self.proposalForPrintingStatusText)

    def tomsChooseTiles(self, tileDictionary):
        # function to display and allow choice of tiles for printing

        TOMsMessageLog.logMessage("In TOMsChooseTiles ", level=Qgis.Info)

        # set the dialog (somehow)

        tilesToPrint = []
        # idxMapTileId = self.tableNames.setLayer("MapGrid").fields().indexFromName("id")

        # tileSet = set()
        for currTileNr, currTile in tileDictionary.items():
            TOMsMessageLog.logMessage(
                "In TOMsChooseTiles: "
                + str(currTileNr)
                + ":"
                + str(currTile.tileNr())
                + " CurrRevisionNr: "
                + str(currTile.getCurrentRevisionNr())
                + " RevisionDate: "
                + str(currTile.getRevisionNrAtDate()),
                level=Qgis.Info,
            )
            # tileSet.add(tile)

        self.tileListDialog = PrintListDialog(tileDictionary)

        self.tileListDialog.show()

        # Run the dialog event loop
        result = self.tileListDialog.exec_()
        # See if OK was pressed
        if result:
            TOMsMessageLog.logMessage(
                "In TOMsChooseTiles. Now printing - getValues ...", level=Qgis.Info
            )
            tilesToPrint = self.tileListDialog.getValues()

        # TODO: deal with cancel

        # https://stackoverflow.com/questions/46057737/dynamically-changeable-qcheckbox-list
        return tilesToPrint


class PrintListDialog(printListDialogUI, QDialog):
    def __init__(self, initValuesDict, parent=None):
        QDialog.__init__(self, parent)

        # initValues is set of features (in this case MapTile features); idxValue is the index to the set
        # Set up the user interface from Designer.
        self.setupUi(self)

        TOMsMessageLog.logMessage("In printListDialog. Initiating ...", level=Qgis.Info)

        self.initValuesDict = initValuesDict  # set

        # self.idxValue = idxValue
        self.tilesToPrint = self.initValuesDict.copy()

        self.titleList = self.findChild(QListWidget, "tileList")
        self.cbToggleTiles = self.findChild(QCheckBox, "cb_ToggleTiles")
        self.buttonBox = self.findChild(QDialogButtonBox, "buttonBox")
        self.cbToggleTiles.setCheckState(Qt.Checked)

        QMetaObject.connectSlotsByName(self)

        self.populateTileListDialog()

        self.titleList.itemChanged.connect(self.changeValues)
        self.cbToggleTiles.stateChanged.connect(self.toggleValues)

    def changeValues(self, element):
        # Whenever a checkbox is checked, modify the values
        # Check if we check or uncheck the value:

        if element.checkState() == Qt.Checked:
            # self.tilesToPrint.append(element.data(Qt.DisplayRole))
            self.addFeatureToSet(element.data(Qt.DisplayRole))
        else:
            self.removedFeatureFromSet(element.data(Qt.DisplayRole))

    def addFeatureToSet(self, valueToAdd):

        for feature in sorted(self.initValuesDict):
            if int(feature) == int(valueToAdd):
                self.tilesToPrint[feature] = self.initValuesDict[feature]
                TOMsMessageLog.logMessage(
                    "In TOMsTileListDialog. Adding: "
                    + str(feature)
                    + " ; "
                    + str(len(self.tilesToPrint)),
                    level=Qgis.Info,
                )
                return

    def removedFeatureFromSet(self, valueToRemove):

        for feature in sorted(self.initValuesDict):
            if int(feature) == int(valueToRemove):
                del self.tilesToPrint[feature]
                TOMsMessageLog.logMessage(
                    "In TOMsTileListDialog. Removing: "
                    + str(feature)
                    + " ; "
                    + str(len(self.tilesToPrint)),
                    level=Qgis.Info,
                )
                return

    def toggleValues(self):
        """Whenever a checkbox is checked, modify the values"""
        # Check if we check or uncheck the value:

        TOMsMessageLog.logMessage(
            "In TOMsTileListDialog. In toggleValues. toggleState: "
            + str(self.cbToggleTiles.checkState()),
            level=Qgis.Info,
        )

        if self.cbToggleTiles.checkState() == Qt.Checked:
            for i in range(self.titleList.count()):
                # attr = feature.attributes()
                self.titleList.item(i).setCheckState(Qt.Checked)

        else:

            for i in range(self.titleList.count()):
                # attr = feature.attributes()
                self.titleList.item(i).setCheckState(Qt.Unchecked)

    def populateTileListDialog(self):
        """Fill the QListWidget with values"""
        # Delete everything
        TOMsMessageLog.logMessage(
            "In TOMsTileListDialog. In populateList", level=Qgis.Info
        )

        self.titleList.clear()
        # for feature in sorted(self.initValues, key=lambda f: f[self.idxValue]):

        for feature in sorted(self.initValuesDict):
            element = QListWidgetItem(str(feature))
            element.setData(Qt.UserRole, str(feature))

            # self.tilesToPrint.add(feature)
            element.setCheckState(Qt.Checked)

            self.titleList.addItem(element)

    def getValues(self):
        """Return the selected values of the QListWidget"""

        TOMsMessageLog.logMessage(
            "In TOMsTileListDialog. In getValues. Len List = "
            + str(len(self.tilesToPrint)),
            level=Qgis.Info,
        )

        for feature in sorted(self.tilesToPrint):
            TOMsMessageLog.logMessage(
                "In Choose tiles form ... Returning " + str(feature), level=Qgis.Info
            )

        return self.tilesToPrint
