# -*- coding: utf-8 -*-
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    copyright            : (C) 2014-2015 by Sandro Mani / Sourcepole AG
#    email                : smani@sourcepole.ch

# T Hancock (180607) given the number of "private" functions, i.e., "__", have decided to amend this file rather than subclass

from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *
from qgis.gui import *
import os
import math

from TOMs.InstantPrint.ui.ui_printdialog import Ui_InstantPrintDialog
#from TOMs.InstantPrint.ui.acceptedProposals_dialog import acceptedProposalsDialog
from TOMs.InstantPrint.ui.accepted_Proposals_dialog2 import acceptedProposalsDialog2
#from TOMs.InstantPrint.ui.printList_dialog import printListDialog

import os.path

from TOMs.constants import (
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
        self.rubberband = None
        self.oldrubberband = None
        self.pressPos = None
        self.printer = None
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

        self.iface.composerAdded.connect(lambda view: self.__reloadComposers())
        self.iface.composerWillBeRemoved.connect(self.__reloadComposers)
        self.dialogui.comboBox_composers.currentIndexChanged.connect(self.__selectComposer)
        self.dialogui.comboBox_scale.lineEdit().textChanged.connect(self.__changeScale)
        self.dialogui.comboBox_scale.scaleChanged.connect(self.__changeScale)
        self.exportButton.clicked.connect(self.__export)
        self.printButton.clicked.connect(self.__print)
        self.helpButton.clicked.connect(self.__help)
        self.dialogui.buttonBox.button(QDialogButtonBox.Close).clicked.connect(lambda: self.dialog.hide())
        self.dialogui.addScale.clicked.connect(self.__addItems)
        self.dialogui.deleteScale.clicked.connect(self.__deleteItems)
        self.deactivated.connect(self.__cleanup)
        self.setCursor(Qt.OpenHandCursor)

        settings = QSettings()
        if settings.value("instantprint/geometry") is not None:
            self.dialog.restoreGeometry(settings.value("instantprint/geometry"))
        if settings.value("instantprint/scales") is not None:
            for scale in settings.value("instantprint/scales").split(";"):
                if scale:
                    self.addItem(scale)
        self.check_scales()

        # TH (180608) change signals to new functions
        self.dialogui.comboBox_composers.currentIndexChanged.disconnect(self.__selectComposer)
        self.dialogui.comboBox_composers.currentIndexChanged.connect(self.TOMsSelectComposer)

        self.exportButton.clicked.disconnect(self.__export)
        self.exportButton.clicked.connect(self.TOMsExport)

        self.iface.composerAdded.disconnect()
        self.iface.composerWillBeRemoved.disconnect(self.__reloadComposers)
        self.iface.composerAdded.connect(lambda view: self.TOMsReloadComposers())
        self.iface.composerWillBeRemoved.connect(self.TOMsReloadComposers)

    def __onDialogHidden(self):
        self.setEnabled(False)
        QSettings().setValue("instantprint/geometry", self.dialog.saveGeometry())
        list = []
        for i in range(self.dialogui.comboBox_scale.count()):
            list.append(self.dialogui.comboBox_scale.itemText(i))
        QSettings().setValue("instantprint/scales", ";".join(list))

    def addItem(self, checkScale):
        if self.dialogui.comboBox_scale.findText(checkScale) == -1:
            self.dialogui.comboBox_scale.addItem(checkScale)

    def __addItems(self):
        newScale = self.dialogui.comboBox_scale.currentText()
        if self.dialogui.comboBox_scale.findText(newScale) == -1:
            self.dialogui.comboBox_scale.addItem(newScale)
        self.check_scales()

    def __deleteItems(self):
        delitem = self.dialogui.comboBox_scale.currentIndex()
        self.dialogui.comboBox_scale.removeItem(delitem)
        self.check_scales()

    def setEnabled(self, enabled):
        if enabled:
            self.dialog.setVisible(True)
            self.__reloadComposers()
            self.iface.mapCanvas().setMapTool(self)
        else:
            self.dialog.setVisible(False)
            self.iface.mapCanvas().unsetMapTool(self)

    def __changeScale(self):
        if not self.mapitem:
            return
        scaledenom = self.dialogui.comboBox_scale.scale()
        if math.isinf(scaledenom) or math.isnan(scaledenom) or abs(scaledenom) < 1E-6:
            return
        newscale = 1. / scaledenom
        extent = self.mapitem.extent()
        center = extent.center()
        newwidth = extent.width() / self.mapitem.scale() * newscale
        newheight = extent.height() / self.mapitem.scale() * newscale
        x1 = center.x() - 0.5 * newwidth
        y1 = center.y() - 0.5 * newheight
        x2 = center.x() + 0.5 * newwidth
        y2 = center.y() + 0.5 * newheight
        self.mapitem.setNewExtent(QgsRectangle(x1, y1, x2, y2))
        self.__createRubberBand()
        self.check_scales()

    def __selectComposer(self):
        if not self.dialog.isVisible():
            return
        activeIndex = self.dialogui.comboBox_composers.currentIndex()
        if activeIndex < 0:
            return

        composerView = self.dialogui.comboBox_composers.itemData(activeIndex)

        try:
            maps = composerView.composition().composerMapItems()
        except Exception:
            # composerMapItems is not available with PyQt4 < 4.8.4
            maps = []
            for item in composerView.composition().items():
                if isinstance(item, QgsComposerMap):
                    maps.append(item)

        if len(maps) != 1:
            QMessageBox.warning(self.iface.mainWindow(), self.tr("Invalid composer"), self.tr("The composer must have exactly one map item."))
            self.exportButton.setEnabled(False)
            self.iface.mapCanvas().scene().removeItem(self.rubberband)
            self.rubberband = None
            self.dialogui.comboBox_scale.setEnabled(False)
            return

        self.dialogui.comboBox_scale.setEnabled(True)
        self.exportButton.setEnabled(True)

        self.composerView = composerView
        self.mapitem = maps[0]
        self.dialogui.comboBox_scale.setScale(1 / self.mapitem.scale())
        self.__createRubberBand()

    def __createRubberBand(self):
        self.__cleanup()
        extent = self.mapitem.extent()
        center = self.iface.mapCanvas().extent().center()
        self.corner = QPointF(center.x() - 0.5 * extent.width(), center.y() - 0.5 * extent.height())
        self.rect = QRectF(self.corner.x(), self.corner.y(), extent.width(), extent.height())
        self.mapitem.setNewExtent(QgsRectangle(self.rect))

        self.rubberband = QgsRubberBand(self.iface.mapCanvas(), QGis.Polygon)
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
            self.oldrubberband = QgsRubberBand(self.iface.mapCanvas(), QGis.Polygon)
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
            self.mapitem.setNewExtent(QgsRectangle(self.rect))

    def __canvasRect(self, rect):
        mtp = self.iface.mapCanvas().mapSettings().mapToPixel()
        p1 = mtp.transform(QgsPoint(rect.left(), rect.top()))
        p2 = mtp.transform(QgsPoint(rect.right(), rect.bottom()))
        return QRect(p1.x(), p1.y(), p2.x() - p1.x(), p2.y() - p1.y())

    def __export(self):
        settings = QSettings()
        format = self.dialogui.comboBox_fileformat.itemData(self.dialogui.comboBox_fileformat.currentIndex())
        filename = QFileDialog.getSaveFileName(
            self.iface.mainWindow(),
            self.tr("Print Composition"),
            settings.value("/instantprint/lastfile", ""),
            format
        )
        if not filename:
            return

        # Ensure output filename has correct extension
        filename = os.path.splitext(filename)[0] + "." + self.dialogui.comboBox_fileformat.currentText().lower()

        settings.setValue("/instantprint/lastfile", filename)

        if self.populateCompositionFz:
            self.populateCompositionFz(self.composerView.composition())

        # TH (181017) Need to add in values for items here

        success = False
        if filename[-3:].lower() == u"pdf":
            success = self.composerView.composition().exportAsPDF(filename)
        else:
            image = self.composerView.composition().printPageAsRaster(self.composerView.composition().itemPageNumber(self.mapitem))
            if not image.isNull():
                success = image.save(filename)
        if not success:
            QMessageBox.warning(self.iface.mainWindow(), self.tr("Print Failed"), self.tr("Failed to print the composition."))

    def __print(self):
        if not self.printer:
            self.printer = QPrinter()

        printdialog = QPrintDialog(self.printer)
        if printdialog.exec_() != QDialog.Accepted:
            return

        print_ = getattr(self.composerView.composition(), 'print')
        success = print_(self.printer)
        if not success:
            QMessageBox.warning(self.iface.mainWindow(), self.tr("Print Failed"), self.tr("Failed to print the composition."))

    def __reloadComposers(self, removed=None):
        if not self.dialog.isVisible():
            # Make it less likely to hit the issue outlined in https://github.com/qgis/QGIS/pull/1938
            return

        self.dialogui.comboBox_composers.blockSignals(True)
        prev = None
        if self.dialogui.comboBox_composers.currentIndex() >= 0:
            prev = self.dialogui.comboBox_composers.currentText()
        self.dialogui.comboBox_composers.clear()
        active = 0
        for composer in self.iface.activeComposers():
            if composer != removed and composer.composerWindow():
                cur = composer.composerWindow().windowTitle()
                self.dialogui.comboBox_composers.addItem(cur, composer)
                if prev == cur:
                    active = self.dialogui.comboBox_composers.count() - 1
        self.dialogui.comboBox_composers.setCurrentIndex(-1)  # Ensure setCurrentIndex below actually changes an index
        self.dialogui.comboBox_composers.blockSignals(False)
        if self.dialogui.comboBox_composers.count() > 0:
            self.dialogui.comboBox_composers.setCurrentIndex(active)
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
        # catch 0 Division
        if len(parts) == 2 and parts[0][1] and parts[1][1] and parts[0][0] != 0 and parts[1][0] != 0:
            return float(parts[0][0]) / float(parts[1][0])
        else:
            return None

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

    def TOMsSelectComposer(self):

        # TH (180608): Need to be able to accept composers with multiple maps - so over ride original

        if not self.dialog.isVisible():
            return
        activeIndex = self.dialogui.comboBox_composers.currentIndex()
        if activeIndex < 0:
            return

        composerView = self.dialogui.comboBox_composers.itemData(activeIndex)
        try:
            maps = composerView.composition().composerMapItems()
        except Exception:
            # composerMapItems is not available with PyQt4 < 4.8.4
            maps = []
            for item in composerView.composition().items():
                if isinstance(item, QgsComposerMap):
                    maps.append(item)

        # TH (180608): Assume that when no maps are within composer, that the composer is Legend ...

        if len(maps) == 0:
            #self.exportButton.setEnabled(False)
            self.iface.mapCanvas().scene().removeItem(self.rubberband)
            self.rubberband = None
            self.dialogui.comboBox_scale.setEnabled(False)
            return

        # TH (180608): Assume that when multiple maps are displayed, that composer is Atlas ...

        self.exportButton.setEnabled(True)

        self.composerView = composerView
        self.mapitem = maps[0]

        if len(maps) != 1:
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
        currComposition = self.composerView.composition()
        currAtlas = currComposition.atlasComposition()

        self.proposalForPrintingStatusText = "PROPOSED"
        self.proposalPrintTypeDetails = "Print Date"
        self.openDateForPrintProposal = self.proposalsManager.date()

        if currAtlas.enabled():

            if self.proposalsManager.currentProposal() == 0:

                # Include a dialog to check which proposal is required - or everything

                self.proposalForPrintingStatusText = "CONFIRMED"
                self.proposalPrintTypeDetails = "Effective Date"

                # set the dialog (somehow)
                self.acceptedProposalDialog = acceptedProposalsDialog2()

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

                    if proposalNrForPrinting == 0:

                        reply = QMessageBox.question(self.iface.mainWindow(), 'Print options',
                                                     'You are about to export all the map sheets containing restrictions current as at {date}?. Is this as intended?.'.format(date=self.proposalsManager.date().toString('dd-MMM-yyyy')),
                                                     QMessageBox.Yes, QMessageBox.No)
                        if reply == QMessageBox.No:
                            return

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

        #self.acceptedProposalDialog.cb_AcceptedProposalsList.currentIndexChanged.connect(self.onProposalListIndexChanged)
        #self.acceptedProposalDialog.cb_AcceptedProposalsList.currentIndexChanged.disconnect(self.onProposalListIndexChanged)

        if QgsMapLayerRegistry.instance().mapLayersByName("Proposals"):
            self.Proposals = \
                QgsMapLayerRegistry.instance().mapLayersByName("Proposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                    ("Table Proposals is not present"))


        self.acceptedProposalDialog.cb_AcceptedProposalsList.clear()

        """currProposalID = 0
        currProposalTitle = "0 - No proposal shown"

        # A little pause for the db to catch up
        #time.sleep(.1)

        QgsMessageLog.logMessage("In createAcceptedProposalcb: Adding 0", tag="TOMs panel")

        self.acceptedProposalDialog.cb_AcceptedProposalsList.addItem(currProposalTitle, currProposalID)"""

        """proposalsList = self.Proposals.getFeatures()
        proposalsList.sort()

        query = "\"ProposalStatusID\" = " + str(PROPOSAL_STATUS_IN_PREPARATION())
        request = QgsFeatureRequest().setFilterExpression(query)"""

        # for proposal in proposalsList:
        queryString = "\"ProposalStatusID\" = " + str(PROPOSAL_STATUS_ACCEPTED())

        QgsMessageLog.logMessage("In getTileRevisionNrAtDate: queryString: " + str(queryString), tag="TOMs panel")

        expr = QgsExpression(queryString)

        proposals = self.Proposals.getFeatures(QgsFeatureRequest(expr))

        for proposal in sorted(proposals, key=lambda f: f[4]):
            #for proposal in self.Proposals.getFeatures():

            #currProposalStatusID = proposal.attribute("ProposalStatusID")
            """QgsMessageLog.logMessage("In createProposalcb. ID: " + str(proposal.attribute("ProposalID")) + " currProposalStatus: " + str(currProposalStatusID),
                                     tag="TOMs panel")"""
            #if currProposalStatusID == PROPOSAL_STATUS_ACCEPTED():  # 1 = "in preparation"
            currProposalID = proposal.attribute("ProposalID")
            currProposalTitle = proposal.attribute("ProposalTitle")
            #    #currProposalOpenDate = proposal.attribute("ProposalOpenDate")
            self.acceptedProposalDialog.cb_AcceptedProposalsList.addItem(currProposalTitle, currProposalID)

        pass

        # set up action for when the proposal is changed
        #self.acceptedProposalDialog.cb_AcceptedProposalsList.currentIndexChanged.connect(self.onProposalListIndexChanged)


    def TOMsExportAtlas(self, currProposalID):

        # TH (180608): Export function to deal with atlases

        settings = QSettings()
        format = self.dialogui.comboBox_fileformat.itemData(self.dialogui.comboBox_fileformat.currentIndex())

        # TH (180608): Check to see whether or not the Composer is an Atlas
        currComposition = self.composerView.composition()
        currAtlas = currComposition.atlasComposition()

        dirName = QFileDialog.getExistingDirectory(
            self.iface.mainWindow(),
            self.tr("Export Composition"),
            settings.value("/instantprint/lastdir", ""),
            QFileDialog.ShowDirsOnly
        )
        if not dirName:
            return

        settings.setValue("/instantprint/lastdir", dirName)
        # self.TOMsExportAtlas()

        success = False

        # https://gis.stackexchange.com/questions/77848/programmatically-load-composer-from-template-and-generate-atlas-using-pyqgis?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

        self.TOMsSetAtlasValues(currComposition)

        #currProposalID = self.proposalsManager.currentProposal()
        currRevisionDate = self.proposalsManager.date()

        # get the map tiles that are affected by the Proposal
        self.getProposalTileList(currProposalID, currRevisionDate)

        # Now check which tiles to use
        #self.TOMsChooseTiles()

        tileIDList = ""
        firstTile = True
        for tile in self.tileSet:
            if firstTile:
                tileIDList = str(tile.attribute("id"))
                firstTile = False
            else:
                tileIDList = tileIDList + ',' + str(tile.attribute("id"))

        currAtlas.setFilterFeatures(True)
        currAtlas.setFeatureFilter(' "id" in ({tileList})'.format(tileList=tileIDList))

        currAtlas.beginRender()
        currComposition.setAtlasMode(QgsComposition.ExportAtlas)

        composerRevisionNr = currComposition.getComposerItemById('revisionNr')
        composerEffectiveDate = currComposition.getComposerItemById('effectiveDate')
        composerProposalStatus = currComposition.getComposerItemById('proposalStatus')
        composerPrintTypeDetails = currComposition.getComposerItemById('printTypeDetails')

        composerProposalStatus.setText(self.proposalForPrintingStatusText)
        composerPrintTypeDetails.setText(self.proposalPrintTypeDetails)

        currProposalTitle, currProposalOpenDate = self.getProposalTitle(currProposalID)
        if currProposalID == 0:
            currProposalTitle = "CurrentRestrictions"

        QgsMessageLog.logMessage("In TOMsExportAtlas. Now printing " + str(currAtlas.numFeatures()) + " items ....", tag="TOMs panel")

        for i in range(0, currAtlas.numFeatures()):

            currAtlas.prepareForFeature(i)
            currTile = currAtlas.feature()

            currAtlas.composition().refreshItems()

            currTileNr = currTile["id"]
            tileWithDetails = self.tileFromTileSet(currTileNr)

            if tileWithDetails == None:
                QgsMessageLog.logMessage("In TOMsExportAtlas. Tile with details not found ....", tag="TOMs panel")
                tileWithDetails = currTile

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

            if filename[-3:].lower() == u"pdf":
                success = currAtlas.composition().exportAsPDF(outputFile)
            else:
                image = currAtlas.composition().printPageAsRaster(0)
                if not image.isNull():
                    success = image.save(outputFile)

            if not success:
                QMessageBox.warning(self.iface.mainWindow(), self.tr("Print Failed"),
                                    self.tr("Failed to print the composition."))
                break

        currAtlas.endRender()

    def tileFromTileSet(self, tileNr):

        for tile in self.tileSet:
            if tile.attribute("id") == tileNr:
                return tile

        return None

    def TOMsReloadComposers(self, removed=None):
        if not self.dialog.isVisible():
            # Make it less likely to hit the issue outlined in https://github.com/qgis/QGIS/pull/1938
            return

        self.dialogui.comboBox_composers.blockSignals(True)
        prev = None
        if self.dialogui.comboBox_composers.currentIndex() >= 0:
            prev = self.dialogui.comboBox_composers.currentText()
        self.dialogui.comboBox_composers.clear()
        active = 0
        for composer in self.iface.activeComposers():
            if composer != removed and composer.composerWindow():
                cur = composer.composerWindow().windowTitle()
                self.dialogui.comboBox_composers.addItem(cur, composer)
                if prev == cur:
                    active = self.dialogui.comboBox_composers.count() - 1
        self.dialogui.comboBox_composers.setCurrentIndex(-1)  # Ensure setCurrentIndex below actually changes an index
        self.dialogui.comboBox_composers.blockSignals(False)
        if self.dialogui.comboBox_composers.count() > 0:
            self.dialogui.comboBox_composers.setCurrentIndex(active)

            # TH (180608): Check whether or not the active item is an Atlas
            composerView = self.dialogui.comboBox_composers.itemData(active)
            currComposition = composerView.composition()
            currAtlas = currComposition.atlasComposition()

            if currAtlas.enabled():
                self.dialogui.comboBox_scale.setEnabled(False)
            else:
                self.dialogui.comboBox_scale.setEnabled(True)

            self.exportButton.setEnabled(True)
        else:
            self.exportButton.setEnabled(False)
            self.dialogui.comboBox_scale.setEnabled(False)

    def TOMsSetAtlasValues(self, currComposition):

        # Need to set date and status

        #self.effectiveDate = self.proposalsManager.date()

        #self.openDateForPrintProposal

        composerEffectiveDate = currComposition.getComposerItemById('effectiveDate')
        #composerEffectiveDate.setText('{date}'.format(date=self.openDateForPrintProposal.toString('dd-MMM-yyyy')))

        composerProposalStatus = currComposition.getComposerItemById('proposalStatus')
        composerProposalStatus.setText(self.proposalForPrintingStatusText)

    def TOMsChooseTiles(self):
        # function to display and allow choice of tiles for printing

        # set the dialog (somehow)
        """self.tileListDialog = printListDialog()

        self.populateTileListDialog()

        self.tileListDialog.show()

        # Run the dialog event loop
        result = self.acceptedProposalDialog.exec_()
        # See if OK was pressed
        if result:

            pass"""

        # https://stackoverflow.com/questions/46057737/dynamically-changeable-qcheckbox-list
        pass

    def populateTileListDialog(self):

        pass

class nnDialog(QtGui.QDialog):
    '''Dedicated n,n relations Form Class - https://medspx.fr/blog/Qgis/ '''
    def __init__(self, parent, layer, shownField, IdField, initValues):
        '''Constructor'''
        QtGui.QDialog.__init__(self,parent)

        self.initValues = initValues
        self.shownField = shownField
        self.layer =  layer
        self.IdField = IdField
        #self.search = search
        #if self.layer is None and DEBUGMODE:
        #    QgsMessageLog.logMessage(u"nnDialog constructor: The layer {0} doesn't exists !".format(layer.name()),"nnForms", QgsMessageLog.INFO)

        # Build the GUI and populate the list with the good values
        self.setupUi()
        self.populateList()

        # Add dynamic control when list is changing
        #self.SEARCH.textChanged.connect(self.populateList)
        self.LIST.itemChanged.connect(self.changeValues)

    def setupUi(self):
        '''Builds the QDialog'''
        # Form building
        self.setObjectName(u"nnDialog")
        self.resize(550, 535)
        self.setMinimumSize(QtCore.QSize(0, 0))
        self.buttonBox = QtGui.QDialogButtonBox(self)
        self.buttonBox.setGeometry(QtCore.QRect(190, 500, 341, 32))
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.buttonBox.setStandardButtons(QtGui.QDialogButtonBox.Cancel|QtGui.QDialogButtonBox.Ok)
        self.buttonBox.setObjectName(u"buttonBox")
        self.verticalLayoutWidget = QtGui.QWidget(self)
        self.verticalLayoutWidget.setGeometry(QtCore.QRect(9, 9, 521, 491))
        self.verticalLayoutWidget.setObjectName(u"verticalLayoutWidget")
        self.verticalLayout = QtGui.QVBoxLayout(self.verticalLayoutWidget)
        self.verticalLayout.setMargin(0)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.horizontalLayout = QtGui.QHBoxLayout()
        self.horizontalLayout.setObjectName(u"horizontalLayout")
        self.label = QtGui.QLabel(self.verticalLayoutWidget)
        self.label.setObjectName(u"label")
        self.horizontalLayout.addWidget(self.label)
        #self.SEARCH = QtGui.QLineEdit(self.verticalLayoutWidget)
        #self.SEARCH.setObjectName(u"SEARCH")
        #self.horizontalLayout.addWidget(self.SEARCH)
        #self.verticalLayout.addLayout(self.horizontalLayout)
        self.horizontalLayout_2 = QtGui.QHBoxLayout()
        self.horizontalLayout_2.setObjectName(u"horizontalLayout_2")
        self.LIST = QtGui.QListWidget(self.verticalLayoutWidget)
        self.LIST.setObjectName(u"LIST")
        self.horizontalLayout_2.addWidget(self.LIST)
        self.verticalLayout.addLayout(self.horizontalLayout_2)

        self.buttonBox.accepted.connect(self.accept)
        self.buttonBox.rejected.connect(self.reject)
        QtCore.QMetaObject.connectSlotsByName(self)

    def changeValues(self, element):
        '''Whenever a checkbox is checked, modify the values'''
        # Check if we check or uncheck the value:
        if element.checkState() == Qt.Checked:
            self.initValues.append(element.data(Qt.UserRole))
        else:
            self.initValues.remove(element.data(Qt.UserRole))

    def populateList(self, txtFilter=None):
        '''Fill the QListWidget with values'''
        # Delete everything
        self.LIST.clear()

        # We need a request
        """request = QgsFeatureRequest().setFlags(QgsFeatureRequest.NoGeometry)
        if txtFilter is not None:
            fields = self.layer.dataProvider().fields()
            fieldname = fields[self.shownField].name()
            request.setFilterExpression(u"\"{0}\" LIKE '%{1}%'".format(fieldname, txtFilter))

        # Grab the results from the layer
        features = self.layer.getFeatures(request)"""

        for feature in sorted(self.initValues, key = lambda f: f[0]):
            attr = feature.attributes()
            value = attr[self.shownField]
            element = QListWidgetItem(value)
            element.setData(Qt.UserRole, attr[self.IdField])

            # initValues will be checked
            if attr[self.IdField] in self.initValues:
                element.setCheckState(Qt.Checked)
            else:
                element.setCheckState(Qt.Unchecked)
            self.LIST.addItem(element)

    def getValues(self):
        '''Return the selected values of the QListWidget'''
        return self.initValues


    class nnForm:
        '''Class to handle forms to type data'''
        def __init__(self, dialog, layerid, featureid):
            self.dialog = dialog
            self.layerid = layerid
            self.featureid = featureid
            self.nullValue = QSettings().value("qgis/nullValue" , u"NULL")
            self.search = False

        def id2listWidget(self, table, values, listWidget):
            '''Show all the selected values of a link table on a QListWidget'''
            # Find the Widget
            if listWidget is None or table is None:
                QgsMessageLog.logMessage(u"id2listWidget: We need to have a relation and a true widget !", "nnForms", QgsMessageLog.INFO)
                return False

            # Empty the list
            listWidget.clear()

            # Get the params (for the first child table)
            if self.valueRelationParams(table):
                params = self.valueRelationParams(table)[0]
            if params is None or not params:
                QgsMessageLog.logMessage(u"id2listWidget: You need to add Value Relation to layer: {0} !".format(table.name()), "nnForms", QgsMessageLog.INFO)
                return False

            # Get target layer:
            tgtLayer = params['tgtLayer']

            # Handle values: need to escape \' characters
            values = [v.replace(u"'", u"''") if isinstance(v, basestring) else v for v in values]

            ## Then, get the real values from other-side table
            if values:
                request = QgsFeatureRequest().setFlags(QgsFeatureRequest.NoGeometry)
                if params[u'tgtIdType'] in (QVariant.String, QVariant.Char):
                    query = u"{0} IN ('{1}')".format(params[u'tgtId'], u"','".join(values))
                else:
                    query = u"{0} IN ({1})".format(params[u'tgtId'], u",".join([unicode(x) for x in values]))
                request.setFilterExpression(query)

                # and display them in the QListWidget
                for feature in tgtLayer.getFeatures(request):
                    value = feature.attributes()[params[u'tgtValueIdx']]
                    if value != u"NULL":
                        element = QListWidgetItem(value)
                        element.setData(Qt.UserRole, feature.attributes()[params[u'tgtIdIdx']])
                        listWidget.addItem(element)

            return True

        def valueRelationParams(self,layer):
            '''Function that returns the configuration parameters of a valueRelation as a list of dict'''
            params = []
            if layer is not None:
                for idx, field in enumerate(layer.dataProvider().fields()):
                    if layer.editorWidgetV2(idx) == u"ValueRelation":
                        param = {}
                        param[u'srcId'] = field.name()
                        param[u'srcIdIdx'] = idx
                        if u"Layer" in layer.editorWidgetV2Config(idx):
                            tgtLayerName = layer.editorWidgetV2Config(idx)[u"Layer"]
                            tgtLayer = QgsMapLayerRegistry.instance().mapLayer(tgtLayerName)
                            if tgtLayer is None:
                                QgsMessageLog.logMessage(u"valueRelationParams: Can't find the layer {0} !".format(tgtLayerName), "nnForms", QgsMessageLog.INFO)
                                return False

                            param[u'tgtLayer'] = tgtLayer
                            param[u'tgtId'] = layer.editorWidgetV2Config(idx)[u"Key"]
                            param[u'tgtValue'] = layer.editorWidgetV2Config(idx)[u"Value"]

                            # Find index of all fields:
                            for indx, f in enumerate(tgtLayer.dataProvider().fields()):
                                if f.name() == param[u'tgtId']:
                                    param[u'tgtIdIdx'] = indx
                                    param[u'tgtIdType'] = f.type()
                                if f.name() == param[u'tgtValue']:
                                    param[u'tgtValueIdx'] = indx
                            params.append(param)

            # notification
            if not params:
                QgsMessageLog.logMessage(u"valueRelationParams: There is not Value Relation for the layer {0} !".format(layer.name()), "nnForms", QgsMessageLog.INFO)

            return params

        def manageMultiple(self):
            '''Handle specifics thesaurus form'''
            # Scan all of the QgsRelations of the project
            relations = QgsProject.instance().relationManager().relations()

            for listWidget in [f for f in self.dialog.findChildren(QListWidget) if u"REL_" in f.objectName()]:
                listName = listWidget.objectName()
                if listName not in relations.keys():
                    QgsMessageLog.logMessage(u"manageMultiple: There is no Relation for control {0} !".format(listWidget.objectName()), "nnforms", QgsMessageLog.INFO)
                    continue

                # Find what is the table to show
                relation = relations[listName]
                shownLayer = relation.referencingLayer()

                # Find other side of n,n relation
                if self.valueRelationParams(shownLayer):
                    params = self.valueRelationParams(shownLayer)[0]
                if params is None:
                    continue

                # When found, we are ready to populate the QListWidget with the good values
                values = []
                if self.featureid:
                    # Get the features to display
                    request = relation.getRelatedFeaturesRequest(self.featureid)
                    request.setFlags(QgsFeatureRequest.NoGeometry)
                    for feature in shownLayer.getFeatures(request):
                        values.append(feature.attributes()[params[u'srcIdIdx']])
                    self.id2listWidget(shownLayer, values, listWidget)

                buttonWidget = self.dialog.findChild(QPushButton, listName+u"_B")
                if buttonWidget:
                    if self.search or self.layerid.isEditable():
                        buttonWidget.clicked.connect(partial(self.openSubform, listWidget, relation, values))
                        buttonWidget.setEnabled(True)
                    else:
                        buttonWidget.setEnabled(False)
                elif DEBUGMODE:
                    QgsMessageLog.logMessage(u"manageMultiple: There is no button for control {0} !".format(listName), "nnForms", QgsMessageLog.INFO)

        def openSubform(self, widget, relation, values):
            '''Open a dedicated dialog form with values taken from a child table.'''
            table = relation.referencingLayer()
            if self.valueRelationParams(table):
                params = self.valueRelationParams(table)[0]

            if params is None or not params:
                QgsMessageLog.logMessage(u"openSubform: There is no Value Relation for layer: {0} !".format(table.name()), "nnForms", QgsMessageLog.INFO)
                return False

            if widget is None:
                QgsMessageLog.logMessage(u"openSubForm: no widgets found for field {0} !".format(field), "nnForms", QgsMessageLog.INFO)

            # Open the form with the good values
            dialog = nnDialog(self.dialog, params[u'tgtLayer'], params[u'tgtValueIdx'], params[u'tgtIdIdx'], values, self.search)

            # handle results
            if dialog.exec_():
                # Get the results:
                thevalues = dialog.getValues()

                # Modify target table if we have a featureid
                if self.featureid:
                    table.startEditing()
                    caps = table.dataProvider().capabilities()
                    ## Delete all the previous values
                    if caps & QgsVectorDataProvider.DeleteFeatures:
                        request = relation.getRelatedFeaturesRequest(self.featureid)
                        request.setFlags(QgsFeatureRequest.NoGeometry)
                        fids = [f.id() for f in table.getFeatures(request)]
                        table.dataProvider().deleteFeatures(fids)

                    ## Add the new values
                    if caps & QgsVectorDataProvider.AddFeatures:
                        for value in thevalues:
                            feat = QgsFeature()
                            feat.setAttributes([None, self.featureid.attributes()[0], value])
                            table.dataProvider().addFeatures([feat])
                    ## Commit changes
                    table.commitChanges()

                # refresh listWidget aspect
                self.id2listWidget(table, thevalues, widget)

    def opennnForm(dialog, layerid, featureid):
        '''Generic function to open a nnForm'''
        form = nnForm(dialog, layerid, featureid)
        QgsMessageLog.logMessage(u"opennnForm !", "nnforms", QgsMessageLog.INFO)
        form.manageMultiple()