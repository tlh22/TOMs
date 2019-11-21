# -*- coding: utf-8 -*-
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    copyright            : (C) 2014-2015 by Sandro Mani / Sourcepole AG
#    email                : smani@sourcepole.ch

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
from qgis.core import (
    QgsRectangle, QgsLayoutManager, QgsPointXY as QgsPoint, Qgis, QgsProject, QgsWkbTypes, QgsLayoutExporter,
    QgsPrintLayout, QgsLayoutItemRegistry, PROJECT_SCALES, QgsLayoutItemMap,
    QgsMessageLog, QgsExpression, QgsFeatureRequest
    )
from qgis.gui import (
    QgisInterface, QgsMapTool, QgsRubberBand
    )
import os

from .ui.ui_printdialog import Ui_InstantPrintDialog
#from InstantPrint.ui.acceptedProposals_dialog import acceptedProposalsDialog
from .ui.accepted_Proposals_dialog import acceptedProposalsDialog
from .ui.printList_dialog import printListDialog

from ..constants import (
    PROPOSAL_STATUS_IN_PREPARATION,
    PROPOSAL_STATUS_ACCEPTED,
    PROPOSAL_STATUS_REJECTED
)

class InstantPrintDialog(QDialog):

    hidden = pyqtSignal()

    def __init__(self, parent):
        QDialog.__init__(self, parent)

    def hideEvent(self, ev):
        self.hidden.emit()

    def keyPressEvent(self, e):
        if e.key() == Qt.Key_Escape:
            self.hidden.emit()

class InstantPrintTool(QgsMapTool, InstantPrintDialog):

    def __init__(self, iface, populateCompositionFz=None):
        QgsMapTool.__init__(self, iface.mapCanvas())

        self.iface = iface

        projectInstance = QgsProject.instance()
        self.projectLayoutManager = projectInstance.layoutManager()
        self.rubberband = None
        self.oldrubberband = None
        self.pressPos = None
        self.printer = QPrinter()
        self.mapitem = None
        self.populateCompositionFz = populateCompositionFz

        self.dialog = InstantPrintDialog(self.iface.mainWindow())
        self.dialogui = Ui_InstantPrintDialog()
        self.dialogui.setupUi(self.dialog)
        self.dialogui.addScale.setIcon(QIcon(":/images/themes/default/mActionAdd.svg"))
        self.dialogui.deleteScale.setIcon(QIcon(":/images/themes/default/symbologyRemove.svg"))
        self.dialog.hidden.connect(self.__onDialogHidden)
        self.exportButton = self.dialogui.buttonBox.addButton(self.tr("Export"), QDialogButtonBox.ActionRole)
        self.printButton = self.dialogui.buttonBox.addButton(self.tr("Print"), QDialogButtonBox.ActionRole)
        self.helpButton = self.dialogui.buttonBox.addButton(self.tr("Help"), QDialogButtonBox.HelpRole)
        self.dialogui.comboBox_fileformat.addItem("PDF", self.tr("PDF Document (*.pdf);;"))
        self.dialogui.comboBox_fileformat.addItem("JPG", self.tr("JPG Image (*.jpg);;"))
        self.dialogui.comboBox_fileformat.addItem("BMP", self.tr("BMP Image (*.bmp);;"))
        self.dialogui.comboBox_fileformat.addItem("PNG", self.tr("PNG Image (*.png);;"))
        self.iface.layoutDesignerOpened.connect(lambda view: self.__reloadLayouts())
        self.iface.layoutDesignerWillBeClosed.connect(self.__reloadLayouts)
        self.dialogui.comboBox_layouts.currentIndexChanged.connect(self.__selectLayout)
        self.dialogui.comboBox_scale.lineEdit().textChanged.connect(self.__changeScale)
        self.dialogui.comboBox_scale.scaleChanged.connect(self.__changeScale)
        self.exportButton.clicked.connect(self.__export)
        self.printButton.clicked.connect(self.__print)
        self.helpButton.clicked.connect(self.__help)
        self.dialogui.buttonBox.button(QDialogButtonBox.Close).clicked.connect(lambda: self.dialog.hide())
        self.dialogui.addScale.clicked.connect(self.add_new_scale)
        self.dialogui.deleteScale.clicked.connect(self.remove_scale)
        self.deactivated.connect(self.__cleanup)
        self.setCursor(Qt.OpenHandCursor)

        settings = QSettings()
        if settings.value("instantprint/geometry") is not None:
            self.dialog.restoreGeometry(settings.value("instantprint/geometry"))
        if settings.value("instantprint/scales") is not None:
            for scale in settings.value("instantprint/scales").split(";"):
                if scale:
                    self.retrieve_scales(scale)
        self.check_scales()

        # TH (180608) change signals to new functions
        self.dialogui.comboBox_layouts.currentIndexChanged.disconnect(self.__selectLayout)
        self.dialogui.comboBox_layouts.currentIndexChanged.connect(self.TOMsSelectLayout)

        self.exportButton.clicked.disconnect(self.__export)
        self.exportButton.clicked.connect(self.TOMsExport)

        # self.iface.composerAdded.disconnect()
        # self.iface.composerWillBeRemoved.disconnect(self.__reloadLayouts)
        # self.iface.composerAdded.connect(lambda view: self.TOMsReloadLayouts())
        # self.iface.composerWillBeRemoved.connect(self.TOMsReloadLayouts)

    def __onDialogHidden(self):
        self.setEnabled(False)
        self.iface.mapCanvas().unsetMapTool(self)
        QSettings().setValue("instantprint/geometry", self.dialog.saveGeometry())
        list = []
        for i in range(self.dialogui.comboBox_scale.count()):
            list.append(self.dialogui.comboBox_scale.itemText(i))
        QSettings().setValue("instantprint/scales", ";".join(list))

    def retrieve_scales(self, checkScale):
        if self.dialogui.comboBox_scale.findText(checkScale) == -1:
            self.dialogui.comboBox_scale.addItem(checkScale)

    def add_new_scale(self):
        new_layout = self.dialogui.comboBox_scale.currentText()
        if self.dialogui.comboBox_scale.findText(new_layout) == -1:
            self.dialogui.comboBox_scale.addItem(new_layout)
        self.check_scales()

    def remove_scale(self):
        layout_to_delete = self.dialogui.comboBox_scale.currentIndex()
        self.dialogui.comboBox_scale.removeItem(layout_to_delete)
        self.check_scales()

    def setEnabled(self, enabled):
        if enabled:
            self.dialog.setVisible(True)
            self.__reloadLayouts()
            self.iface.mapCanvas().setMapTool(self)
        else:
            self.dialog.setVisible(False)
            self.iface.mapCanvas().unsetMapTool(self)

    def __changeScale(self):
        if not self.mapitem:
            return
        newscale = self.dialogui.comboBox_scale.scale()
        if abs(newscale) < 1E-6:
            return
        extent = self.mapitem.extent()
        center = extent.center()
        newwidth = extent.width() / self.mapitem.scale() * newscale
        newheight = extent.height() / self.mapitem.scale() * newscale
        x1 = center.x() - 0.5 * newwidth
        y1 = center.y() - 0.5 * newheight
        x2 = center.x() + 0.5 * newwidth
        y2 = center.y() + 0.5 * newheight
        self.mapitem.setExtent(QgsRectangle(x1, y1, x2, y2))
        self.__createRubberBand()
        self.check_scales()

    def __selectLayout(self):
        if not self.dialog.isVisible():
            return
        activeIndex = self.dialogui.comboBox_layouts.currentIndex()
        if activeIndex < 0:
            return

        layoutView = self.dialogui.comboBox_layouts.itemData(activeIndex)
        maps = []
        layout_name = self.dialogui.comboBox_layouts.currentText()
        layout = self.projectLayoutManager.layoutByName(layout_name)
        for item in layoutView.items():
            if isinstance(item, QgsLayoutItemMap):
                maps.append(item)
        if len(maps) != 1:
            QMessageBox.warning(self.iface.mainWindow(), self.tr("Invalid layout"), self.tr("The layout must have exactly one map item."))
            self.exportButton.setEnabled(False)
            self.iface.mapCanvas().scene().removeItem(self.rubberband)
            self.rubberband = None
            self.dialogui.comboBox_scale.setEnabled(False)
            return

        self.dialogui.comboBox_scale.setEnabled(True)
        self.exportButton.setEnabled(True)

        self.layoutView = layoutView
        self.mapitem = layout.referenceMap()
        self.dialogui.comboBox_scale.setScale(self.mapitem.scale())
        self.__createRubberBand()

    def __createRubberBand(self):
        self.__cleanup()
        extent = self.mapitem.extent()
        center = self.iface.mapCanvas().extent().center()
        self.corner = QPointF(center.x() - 0.5 * extent.width(), center.y() - 0.5 * extent.height())
        self.rect = QRectF(self.corner.x(), self.corner.y(), extent.width(), extent.height())
        self.mapitem.setExtent(QgsRectangle(self.rect))
        self.rubberband = QgsRubberBand(self.iface.mapCanvas(), QgsWkbTypes.PolygonGeometry)
        self.rubberband.setToCanvasRectangle(self.__canvasRect(self.rect))
        self.rubberband.setColor(QColor(127, 127, 255, 127))

        self.pressPos = None

    def __cleanup(self):
        if self.rubberband:
            self.iface.mapCanvas().scene().removeItem(self.rubberband)
        if self.oldrubberband:
            self.iface.mapCanvas().scene().removeItem(self.oldrubberband)
        self.rubberband = None
        self.oldrubberband = None
        self.pressPos = None

    def canvasPressEvent(self, e):
        if not self.rubberband:
            return
        r = self.__canvasRect(self.rect)
        if e.button() == Qt.LeftButton and self.__canvasRect(self.rect).contains(e.pos()):
            self.oldrect = QRectF(self.rect)
            self.oldrubberband = QgsRubberBand(self.iface.mapCanvas(), QgsWkbTypes.PolygonGeometry)
            self.oldrubberband.setToCanvasRectangle(self.__canvasRect(self.oldrect))
            self.oldrubberband.setColor(QColor(127, 127, 255, 31))
            self.pressPos = (e.x(), e.y())
            self.iface.mapCanvas().setCursor(Qt.ClosedHandCursor)

    def canvasMoveEvent(self, e):
        if not self.pressPos:
            return
        mup = self.iface.mapCanvas().mapSettings().mapUnitsPerPixel()
        x = self.corner.x() + (e.x() - self.pressPos[0]) * mup
        y = self.corner.y() + (self.pressPos[1] - e.y()) * mup

        snaptol = 10 * mup
        # Left edge matches with old right
        if abs(x - (self.oldrect.x() + self.oldrect.width())) < snaptol:
            x = self.oldrect.x() + self.oldrect.width()
        # Right edge matches with old left
        elif abs(x + self.rect.width() - self.oldrect.x()) < snaptol:
            x = self.oldrect.x() - self.rect.width()
        # Left edge matches with old left
        elif abs(x - self.oldrect.x()) < snaptol:
            x = self.oldrect.x()
        # Bottom edge matches with old top
        if abs(y - (self.oldrect.y() + self.oldrect.height())) < snaptol:
            y = self.oldrect.y() + self.oldrect.height()
        # Top edge matches with old bottom
        elif abs(y + self.rect.height() - self.oldrect.y()) < snaptol:
            y = self.oldrect.y() - self.rect.height()
        # Bottom edge matches with old bottom
        elif abs(y - self.oldrect.y()) < snaptol:
            y = self.oldrect.y()

        self.rect = QRectF(
            x,
            y,
            self.rect.width(),
            self.rect.height()
        )
        self.rubberband.setToCanvasRectangle(self.__canvasRect(self.rect))

    def canvasReleaseEvent(self, e):
        if e.button() == Qt.LeftButton and self.pressPos:
            self.corner = QPointF(self.rect.x(), self.rect.y())
            self.pressPos = None
            self.iface.mapCanvas().setCursor(Qt.OpenHandCursor)
            self.iface.mapCanvas().scene().removeItem(self.oldrubberband)
            self.oldrect = None
            self.oldrubberband = None
            self.mapitem.setExtent(QgsRectangle(self.rect))

    def __canvasRect(self, rect):
        mtp = self.iface.mapCanvas().mapSettings().mapToPixel()
        p1 = mtp.transform(QgsPoint(rect.left(), rect.top()))
        p2 = mtp.transform(QgsPoint(rect.right(), rect.bottom()))
        return QRect(p1.x(), p1.y(), p2.x() - p1.x(), p2.y() - p1.y())

    def __export(self):
        settings = QSettings()
        format = self.dialogui.comboBox_fileformat.itemData(self.dialogui.comboBox_fileformat.currentIndex())
        filepath = QFileDialog.getSaveFileName(
            self.iface.mainWindow(),
            self.tr("Export Layout"),
            settings.value("/instantprint/lastfile", ""),
            format
        )
        if not all(filepath):
            return

        # Ensure output filename has correct extension
        filename = os.path.splitext(filepath[0])[0] + "." + self.dialogui.comboBox_fileformat.currentText().lower()
        settings.setValue("/instantprint/lastfile", filepath[0])

        if self.populateCompositionFz:
            self.populateCompositionFz(self.layoutView.composition())

        success = False
        layout_name = self.dialogui.comboBox_layouts.currentText()
        layout_item = self.projectLayoutManager.layoutByName(layout_name)
        exporter = QgsLayoutExporter(layout_item)
        if filename[-3:].lower() == u"pdf":
            success = exporter.exportToPdf(filepath[0], QgsLayoutExporter.PdfExportSettings())
        else:
            success = exporter.exportToImage(filepath[0], QgsLayoutExporter.ImageExportSettings())
        if success != 0:
            QMessageBox.warning(self.iface.mainWindow(), self.tr("Export Failed"), self.tr("Failed to export the layout."))

    def __print(self):
        layout_name = self.dialogui.comboBox_layouts.currentText()
        layout_item = self.projectLayoutManager.layoutByName(layout_name)
        actual_printer = QgsLayoutExporter(layout_item)

        printdialog = QPrintDialog(self.printer)
        if printdialog.exec_() != QDialog.Accepted:
            return

        success = actual_printer.print(self.printer, QgsLayoutExporter.PrintExportSettings())

        if success != 0:
            QMessageBox.warning(self.iface.mainWindow(), self.tr("Print Failed"), self.tr("Failed to print the layout."))

    def __reloadLayouts(self, removed=None):
        if not self.dialog.isVisible():
            # Make it less likely to hit the issue outlined in https://github.com/qgis/QGIS/pull/1938
            return

        self.dialogui.comboBox_layouts.blockSignals(True)
        prev = None
        if self.dialogui.comboBox_layouts.currentIndex() >= 0:
            prev = self.dialogui.comboBox_layouts.currentText()
        self.dialogui.comboBox_layouts.clear()
        active = 0
        for layout in self.projectLayoutManager.layouts():
            if layout != removed and layout.name():
                cur = layout.name()
                self.dialogui.comboBox_layouts.addItem(cur, layout)
                if prev == cur:
                    active = self.dialogui.comboBox_layouts.count() - 1
        self.dialogui.comboBox_layouts.setCurrentIndex(-1)  # Ensure setCurrentIndex below actually changes an index
        self.dialogui.comboBox_layouts.blockSignals(False)
        if self.dialogui.comboBox_layouts.count() > 0:
            self.dialogui.comboBox_layouts.setCurrentIndex(active)
            self.dialogui.comboBox_scale.setEnabled(True)
            self.exportButton.setEnabled(True)
        else:
            self.exportButton.setEnabled(False)
            self.dialogui.comboBox_scale.setEnabled(False)

    def __help(self):
        manualPath = os.path.join(os.path.dirname(__file__), "help", "documentation.pdf")
        QDesktopServices.openUrl(QUrl.fromLocalFile(manualPath))

    def scaleFromString(self, scaleText):
        locale = QLocale()
        parts = [locale.toInt(part) for part in scaleText.split(":")]
        try:
            if len(parts) == 2 and parts[0][1] and parts[1][1] and parts[0][0] != 0 and parts[1][0] != 0:
                return float(parts[0][0]) / float(parts[1][0])
            else:
                return None
        except ZeroDivisionError:
            return

    def check_scales(self):
        predefScalesStr = QSettings().value("Map/scales", PROJECT_SCALES).split(",")
        predefScales = [self.scaleFromString(scaleString) for scaleString in predefScalesStr]

        comboScalesStr = [self.dialogui.comboBox_scale.itemText(i) for i in range(self.dialogui.comboBox_scale.count())]
        comboScales = [self.scaleFromString(scaleString) for scaleString in comboScalesStr]

        currentScale = self.scaleFromString(self.dialogui.comboBox_scale.currentText())

        if not currentScale:
            self.dialogui.comboBox_scale.lineEdit().setStyleSheet("background: #FF7777; color: #FFFFFF;")
            self.dialogui.addScale.setVisible(True)
            self.dialogui.addScale.setEnabled(False)
            self.dialogui.deleteScale.setVisible(False)
        else:
            self.dialogui.comboBox_scale.lineEdit().setStyleSheet("")
            if currentScale in comboScales:
                # If entry scale is already in the list, allow removing it unless it is a predefined scale
                self.dialogui.addScale.setVisible(False)
                self.dialogui.deleteScale.setVisible(True)
                self.dialogui.deleteScale.setEnabled(currentScale not in predefScales)
            else:
                # Otherwise, show button to add it
                self.dialogui.addScale.setVisible(True)
                self.dialogui.addScale.setEnabled(True)
                self.dialogui.deleteScale.setVisible(False)

    def TOMsSelectLayout(self):

        # TH (180608): Need to be able to accept composers with multiple maps - so over ride original

        if not self.dialog.isVisible():
            return
        activeIndex = self.dialogui.comboBox_layouts.currentIndex()
        if activeIndex < 0:
            return

        layout_name = self.dialogui.comboBox_layouts.currentText()
        self.layoutView = self.projectLayoutManager.layoutByName(layout_name)

        layoutView = self.dialogui.comboBox_layouts.itemData(activeIndex)

        self.exportButton.setEnabled(True)

        #self.layoutView = layoutView
        #self.mapitem = maps[0]

        if self.layoutView.atlas():
            #if len(maps) != 1:
            #QMessageBox.warning(self.iface.mainWindow(), self.tr("Invalid composer"), self.tr("The composer must have exactly one map item."))
            #self.exportButton.setEnabled(False)
            self.iface.mapCanvas().scene().removeItem(self.rubberband)
            self.rubberband = None
            self.dialogui.comboBox_scale.setEnabled(False)
        else:
            self.dialogui.comboBox_scale.setEnabled(True)
            #self.dialogui.comboBox_scale.setScale(1 / self.mapitem.scale())
            self.dialogui.comboBox_scale.setScale(1 / 500)  # composer may not have a "scale" item
            self.__createRubberBand()

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
                    self.openDateForPrintProposal = self.proposalsManager.getProposalOpenDate(proposalNrForPrinting)

                else:
                    return

            else:

                proposalNrForPrinting = self.proposalsManager.currentProposal()

            self.TOMsExportAtlas(proposalNrForPrinting)

        else:

            self.__export()

    def createAcceptedProposalcb(self):

        QgsMessageLog.logMessage("In createAcceptedProposalcb", tag="TOMs panel")
        # set up a "NULL" field for "No proposals to be shown"

        if QgsProject.instance().mapLayersByName("Proposals"):
            self.Proposals = \
                QgsProject.instance().mapLayersByName("Proposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                    ("Table Proposals is not present"))

        self.acceptedProposalDialog.cb_AcceptedProposalsList.clear()

        # for proposal in proposalsList:
        queryString = "\"ProposalStatusID\" = " + str(PROPOSAL_STATUS_ACCEPTED())

        QgsMessageLog.logMessage("In getTileRevisionNrAtDate: queryString: " + str(queryString), tag="TOMs panel")

        expr = QgsExpression(queryString)

        proposals = self.Proposals.getFeatures(QgsFeatureRequest(expr))

        for proposal in sorted(proposals, key=lambda f: f[4]):

            """QgsMessageLog.logMessage("In createProposalcb. ID: " + str(proposal.attribute("ProposalID")) + " currProposalStatus: " + str(currProposalStatusID),
                                     tag="TOMs panel")"""
            currProposalID = proposal.attribute("ProposalID")
            currProposalTitle = proposal.attribute("ProposalTitle")

            self.acceptedProposalDialog.cb_AcceptedProposalsList.addItem(currProposalTitle, currProposalID)

        pass

    def TOMsExportAtlas(self, currProposalID):

        # TH (180608): Export function to deal with atlases

        settings = QSettings()
        format = self.dialogui.comboBox_fileformat.itemData(self.dialogui.comboBox_fileformat.currentIndex())

        # TH (180608): Check to see whether or not the Composer is an Atlas
        currPrintLayout = self.layoutView
        currLayoutAtlas = currPrintLayout.atlas()

        success = False

        # https://gis.stackexchange.com/questions/77848/programmatically-load-composer-from-template-and-generate-atlas-using-pyqgis?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

        self.TOMsSetAtlasValues(currPrintLayout)
        
        currRevisionDate = self.proposalsManager.date()

        # get the map tiles that are affected by the Proposal
        self.getProposalTileList(currProposalID, currRevisionDate)

        # Now check which tiles to use
        self.TOMsChooseTiles()

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

        tileIDList = ""
        firstTile = True
        for tile in self.tilesToPrint:
            if firstTile:
                tileIDList = str(tile.attribute("id"))
                firstTile = False
            else:
                tileIDList = tileIDList + ',' + str(tile.attribute("id"))

        currLayoutAtlas.setFilterFeatures(True)
        currLayoutAtlas.setFilterExpression(' "id" in ({tileList})'.format(tileList=tileIDList))

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

        currProposalTitle, currProposalOpenDate = self.getProposalTitle(currProposalID)
        if currProposalID == 0:
            currProposalTitle = "CurrentRestrictions_({date})".format(date=self.proposalsManager.date().toString('yyyyMMMdd'))

        QgsMessageLog.logMessage("In TOMsExportAtlas. Now printing " + str(currLayoutAtlas.count()) + " items ....", tag="TOMs panel")

        currLayoutAtlas.setEnabled(True)
        currLayoutAtlas.updateFeatures()
        currLayoutAtlas.beginRender()

        altasFeatureFound = currLayoutAtlas.first()

        while altasFeatureFound:

            currTileNr = int(currLayoutAtlas.nameForPage(currLayoutAtlas.currentFeatureNumber()))

            currLayoutAtlas.refreshCurrentFeature()

            tileWithDetails = self.tileFromTileSet(currTileNr)

            if tileWithDetails == None:
                QgsMessageLog.logMessage("In TOMsExportAtlas. Tile with details not found ....", tag="TOMs panel")
                QMessageBox.warning(self.iface.mainWindow(), self.tr("Print Failed"),
                                    self.tr("Could not find details for " + str(currTileNr)))
                break

            QgsMessageLog.logMessage("In TOMsExportAtlas. tile nr: " + str(currTileNr) + " RevisionNr: " + str(tileWithDetails["RevisionNr"]) + " RevisionDate: " + str(tileWithDetails["LastRevisionDate"]), tag="TOMs panel")

            if self.proposalForPrintingStatusText == "CONFIRMED":
                composerRevisionNr.setText(str(tileWithDetails["RevisionNr"]))
                composerEffectiveDate.setText(
                    '{date}'.format(date=tileWithDetails["LastRevisionDate"].toString('dd-MMM-yyyy')))
            else:
                composerRevisionNr.setText(str(tileWithDetails["RevisionNr"]+1))
                # For the Proposal, use the current view date
                composerEffectiveDate.setText(
                    '{date}'.format(date=self.openDateForPrintProposal.toString('dd-MMM-yyyy')))

            filename = currProposalTitle + "_" + str(currTileNr) + "." + self.dialogui.comboBox_fileformat.currentText().lower()
            outputFile = os.path.join(dirName, filename)

            exporter = QgsLayoutExporter(currLayoutAtlas.layout())

            if self.dialogui.comboBox_fileformat.currentText().lower() == u"pdf":
                result = exporter.exportToPdf (outputFile, QgsLayoutExporter.PdfExportSettings())
                # success = currLayoutAtlas.composition().exportAsPDF(outputFile)
            else:
                result = exporter.exportToImage(outputFile, 'png', QgsLayoutExporter.ImageExportSettings())
                """image = currLayoutAtlas.composition().printPageAsRaster(0)
                if not image.isNull():
                    success = image.save(outputFile)"""

            if result != QgsLayoutExporter.Success:
                QMessageBox.warning(self.iface.mainWindow(), self.tr("Print Failed"),
                                    self.tr("Failed to print " + exporter.errorFile()))
                break

            altasFeatureFound = currLayoutAtlas.next()

        currLayoutAtlas.endRender()

        QMessageBox.information(self.iface.mainWindow(), "Information",
                                ("Printing completed"))

    def tileFromTileSet(self, tileNr):

        for tile in self.tileSet:
            if tile.attribute("id") == tileNr:
                return tile

        return None

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

    def TOMsChooseTiles(self):
        # function to display and allow choice of tiles for printing

        QgsMessageLog.logMessage("In TOMsChooseTiles ", tag="TOMs panel")

        # set the dialog (somehow)

        self.tilesToPrint = []
        idxMapTileId = self.tableNames.MAP_GRID.fields().indexFromName("id")

        self.tileListDialog = printListDialog(self.tileSet, idxMapTileId)

        self.tileListDialog.show()

        # Run the dialog event loop
        result = self.tileListDialog.exec_()
        # See if OK was pressed
        if result:
            QgsMessageLog.logMessage("In TOMsChooseTiles. Now printing - getValues ...",
                                     tag="TOMs panel")
            self.tilesToPrint = self.tileListDialog.getValues()

        # ToDo: deal with cancel

        # https://stackoverflow.com/questions/46057737/dynamically-changeable-qcheckbox-list
        pass

class printListDialog(printListDialog, QDialog):
    def __init__(self, initValues, idxValue, parent=None):
        QDialog.__init__(self, parent)

        # initValues is set of features (in this case MapTile features); idxValue is the index to the set
        # Set up the user interface from Designer.
        self.setupUi(self)

        QgsMessageLog.logMessage("In printListDialog. Initiating ...",             tag="TOMs panel")

        self.initValues = initValues
        self.idxValue = idxValue
        self.tilesToPrint = self.initValues.copy()

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
        """QgsMessageLog.logMessage(
            "In printListDialog. In changeValues for: " + str(element.data(Qt.DisplayRole)),
            tag="TOMs panel")"""

        if element.checkState() == Qt.Checked:
            #self.tilesToPrint.append(element.data(Qt.DisplayRole))
            self.addFeatureToSet(element.data(Qt.DisplayRole))
        else:
            self.removedFeatureFromSet(element.data(Qt.DisplayRole))

    def addFeatureToSet(self, valueToAdd):

        for feature in sorted(self.initValues, key=lambda f: f[self.idxValue]):
            attr = feature.attributes()
            currValue = attr[self.idxValue]

            if int(currValue) == int(valueToAdd):
                self.tilesToPrint.add(feature)
                QgsMessageLog.logMessage(
                    "In TOMsTileListDialog. Adding: " + str(currValue) + " ; " + str(len(self.tilesToPrint)),
                    tag="TOMs panel")
                return

    def removedFeatureFromSet(self, valueToRemove):

        for feature in sorted(self.initValues, key=lambda f: f[self.idxValue]):
            attr = feature.attributes()
            currValue = attr[self.idxValue]

            if int(currValue) == int(valueToRemove):
                self.tilesToPrint.remove(feature)
                QgsMessageLog.logMessage(
                    "In TOMsTileListDialog. Removing: " + str(currValue) + " ; " + str(len(self.tilesToPrint)) ,
                    tag="TOMs panel")
                return

    def toggleValues(self):
        '''Whenever a checkbox is checked, modify the values'''
        # Check if we check or uncheck the value:

        QgsMessageLog.logMessage(
            "In TOMsTileListDialog. In toggleValues. toggleState: " + str(self.cbToggleTiles.checkState()),
            tag="TOMs panel")

        if self.cbToggleTiles.checkState() == Qt.Checked:
            for i in range(self.LIST.count()):
                # attr = feature.attributes()
                element = QListWidgetItem(self.LIST.item(i).text())
                self.LIST.item(i).setCheckState(Qt.Checked)
                """QgsMessageLog.logMessage(
                    "In TOMsTileListDialog. In toggleValues. setting: " + str(self.LIST.item(i).text()),
                    tag="TOMs panel")"""

        else:

            for i in range(self.LIST.count()):
                # attr = feature.attributes()
                element = QListWidgetItem(self.LIST.item(i).text())
                self.LIST.item(i).setCheckState(Qt.Unchecked)

    def populateTileListDialog(self, txtFilter=None):
        '''Fill the QListWidget with values'''
        # Delete everything
        QgsMessageLog.logMessage("In TOMsTileListDialog. In populateList",
                                 tag="TOMs panel")

        self.LIST.clear()

        for feature in sorted(self.initValues, key=lambda f: f[self.idxValue]):
            attr = feature.attributes()
            value = attr[self.idxValue]
            element = QListWidgetItem(str(value))
            element.setData(Qt.UserRole, attr[self.idxValue])

            """QgsMessageLog.logMessage("In populateTileListDialog. Set State for " + str(attr[self.idxValue]),
                                     tag="TOMs panel")"""

            self.tilesToPrint.add(feature)
            element.setCheckState(Qt.Checked)

            self.LIST.addItem(element)

    def getValues(self):
        '''Return the selected values of the QListWidget'''

        QgsMessageLog.logMessage("In TOMsTileListDialog. In getValues. Len List = " + str(len(self.tilesToPrint)),
                                 tag="TOMs panel")

        for feature in sorted(self.tilesToPrint, key=lambda f: f[self.idxValue]):
            attr = feature.attributes()
            currValue = attr[self.idxValue]
            QgsMessageLog.logMessage("In Choose tiles form ... Returning " + str(attr[self.idxValue]),
                                     tag="TOMs panel")

        return self.tilesToPrint
