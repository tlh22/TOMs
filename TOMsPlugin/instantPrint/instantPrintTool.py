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

from qgis.core import PROJECT_SCALES, QgsLayoutExporter, QgsLayoutItemMap
from qgis.core import QgsPointXY as QgsPoint
from qgis.core import QgsProject, QgsRectangle, QgsWkbTypes
from qgis.gui import QgsMapTool, QgsRubberBand
from qgis.PyQt.QtCore import (
    QLocale,
    QPointF,
    QRect,
    QRectF,
    QSettings,
    Qt,
    pyqtSignal,
)
from qgis.PyQt.QtGui import QColor, QIcon
from qgis.PyQt.QtPrintSupport import QPrinter
from qgis.PyQt.QtWidgets import (
    QDialog,
    QDialogButtonBox,
    QFileDialog,
    QMessageBox,
)
from qgis.utils import iface

from .ui.uiPrintDialog import UiInstantPrintDialog


class InstantPrintDialog(QDialog):

    hidden = pyqtSignal()

    def __init__(self, parent=None):
        QDialog.__init__(self, parent)

    def hideEvent(self, _):
        self.hidden.emit()

    def keyPressEvent(self, e):
        if e.key() == Qt.Key_Escape:
            self.hidden.emit()


class InstantPrintTool(QgsMapTool, InstantPrintDialog):
    def __init__(self, populateCompositionFz=None):
        QgsMapTool.__init__(self, iface.mapCanvas())

        projectInstance = QgsProject.instance()
        self.projectLayoutManager = projectInstance.layoutManager()
        self.rubberband = None
        self.oldrubberband = None
        self.pressPos = None
        self.printer = QPrinter()
        self.mapitem = None
        self.populateCompositionFz = populateCompositionFz

        self.dialog = InstantPrintDialog(iface.mainWindow())
        self.dialogui = UiInstantPrintDialog()
        self.dialogui.setupUi(self.dialog)
        self.dialogui.addScale.setIcon(QIcon(":/images/themes/default/mActionAdd.svg"))
        self.dialogui.deleteScale.setIcon(
            QIcon(":/images/themes/default/symbologyRemove.svg")
        )
        self.dialog.hidden.connect(self.__onDialogHidden)
        self.exportButton = self.dialogui.buttonBox.addButton(
            self.tr("Export"), QDialogButtonBox.ActionRole
        )
        self.dialogui.comboBoxFileFormat.addItem(
            "PDF", self.tr("PDF Document (*.pdf);;")
        )
        # self.dialogui.comboBox_fileformat.addItem("JPG", self.tr("JPG Image (*.jpg);;"))
        # self.dialogui.comboBox_fileformat.addItem("BMP", self.tr("BMP Image (*.bmp);;"))
        self.dialogui.comboBoxFileFormat.addItem("PNG", self.tr("PNG Image (*.png);;"))
        self.dialogui.comboBoxFileFormat.addItem("SVG", self.tr("SVG Image (*.svg);;"))
        iface.layoutDesignerOpened.connect(lambda view: self.__reloadLayouts())
        iface.layoutDesignerWillBeClosed.connect(self.__reloadLayouts)
        self.dialogui.comboBoxLayouts.currentIndexChanged.connect(self.__selectLayout)
        self.dialogui.comboBoxScale.lineEdit().textChanged.connect(
            self.__changeScale
        )  # TODO: sort out what scales are available ...
        self.dialogui.comboBoxScale.scaleChanged.connect(self.__changeScale)
        self.exportButton.clicked.connect(self.__export)
        self.dialogui.buttonBox.button(QDialogButtonBox.Close).clicked.connect(
            self.dialog.hide
        )
        self.dialogui.addScale.clicked.connect(self.addNewScale)
        self.dialogui.deleteScale.clicked.connect(self.removeScale)
        self.deactivated.connect(self.__cleanup)
        self.setCursor(Qt.OpenHandCursor)

        settings = QSettings()
        if settings.value("instantprint/geometry") is not None:
            self.dialog.restoreGeometry(settings.value("instantprint/geometry"))
        if settings.value("instantprint/scales") is not None:
            for scale in settings.value("instantprint/scales").split(";"):
                if scale:
                    self.retrieveScales(scale)
        self.checkScales()
        self.layoutView = None
        self.corner = None
        self.oldrect = None

    def __onDialogHidden(self):  # pylint: disable=invalid-name
        self.setEnabled(False)
        iface.mapCanvas().unsetMapTool(self)
        QSettings().setValue("instantprint/geometry", self.dialog.saveGeometry())
        myList = []
        for i in range(self.dialogui.comboBoxScale.count()):
            myList.append(self.dialogui.comboBoxScale.itemText(i))
        QSettings().setValue("instantprint/scales", ";".join(myList))

    def retrieveScales(self, checkScale):
        if self.dialogui.comboBoxScale.findText(checkScale) == -1:
            self.dialogui.comboBoxScale.addItem(checkScale)

    def addNewScale(self):
        newLayout = self.dialogui.comboBoxScale.currentText()
        if self.dialogui.comboBoxScale.findText(newLayout) == -1:
            self.dialogui.comboBoxScale.addItem(newLayout)
        self.checkScales()

    def removeScale(self):
        layoutToDelete = self.dialogui.comboBoxScale.currentIndex()
        self.dialogui.comboBoxScale.removeItem(layoutToDelete)
        self.checkScales()

    def setEnabled(self, enabled):
        if enabled:
            self.dialog.setVisible(True)
            self.__reloadLayouts()
            iface.mapCanvas().setMapTool(self)
        else:
            self.dialog.setVisible(False)
            iface.mapCanvas().unsetMapTool(self)

    def __changeScale(self):  # pylint: disable=invalid-name
        if not self.mapitem:
            return
        newscale = self.dialogui.comboBoxScale.scale()
        if abs(newscale) < 1e-6:
            return
        extent = self.mapitem.extent()
        center = extent.center()
        newwidth = extent.width() / self.mapitem.scale() * newscale
        newheight = extent.height() / self.mapitem.scale() * newscale
        x1 = center.x() - 0.5 * newwidth  # pylint: disable=invalid-name
        y1 = center.y() - 0.5 * newheight  # pylint: disable=invalid-name
        x2 = center.x() + 0.5 * newwidth  # pylint: disable=invalid-name
        y2 = center.y() + 0.5 * newheight  # pylint: disable=invalid-name
        self.mapitem.setExtent(
            QgsRectangle(x1, y1, x2, y2)
        )  # pylint: disable=invalid-name
        self.__createRubberBand()
        self.checkScales()

    def __selectLayout(self):  # pylint: disable=invalid-name
        if not self.dialog.isVisible():
            return
        activeIndex = self.dialogui.comboBoxLayouts.currentIndex()
        if activeIndex < 0:
            return

        layoutView = self.dialogui.comboBoxLayouts.itemData(activeIndex)
        maps = []
        layoutName = self.dialogui.comboBoxLayouts.currentText()
        layout = self.projectLayoutManager.layoutByName(layoutName)
        for item in layoutView.items():
            if isinstance(item, QgsLayoutItemMap):
                maps.append(item)
        if len(maps) != 1:
            QMessageBox.warning(
                iface.mainWindow(),
                self.tr("Invalid layout"),
                self.tr("The layout must have exactly one map item."),
            )
            self.exportButton.setEnabled(False)
            iface.mapCanvas().scene().removeItem(self.rubberband)
            self.rubberband = None
            self.dialogui.comboBoxScale.setEnabled(False)
            return

        self.dialogui.comboBoxScale.setEnabled(True)
        self.exportButton.setEnabled(True)

        self.layoutView = layoutView
        self.mapitem = layout.referenceMap()
        self.dialogui.comboBoxScale.setScale(self.mapitem.scale())
        self.__createRubberBand()

    def __createRubberBand(self):  # pylint: disable=invalid-name
        self.__cleanup()
        extent = self.mapitem.extent()
        center = iface.mapCanvas().extent().center()
        self.corner = QPointF(
            center.x() - 0.5 * extent.width(), center.y() - 0.5 * extent.height()
        )
        self.rect = QRectF(
            self.corner.x(), self.corner.y(), extent.width(), extent.height()
        )
        self.mapitem.setExtent(QgsRectangle(self.rect))
        self.rubberband = QgsRubberBand(iface.mapCanvas(), QgsWkbTypes.PolygonGeometry)
        self.rubberband.setToCanvasRectangle(self.__canvasRect(self.rect))
        self.rubberband.setColor(QColor(127, 127, 255, 127))

        self.pressPos = None

    def __cleanup(self):  # pylint: disable=invalid-name
        if self.rubberband:
            iface.mapCanvas().scene().removeItem(self.rubberband)
        if self.oldrubberband:
            iface.mapCanvas().scene().removeItem(self.oldrubberband)
        self.rubberband = None
        self.oldrubberband = None
        self.pressPos = None

    def canvasPressEvent(self, e):
        if not self.rubberband:
            return
        if e.button() == Qt.LeftButton and self.__canvasRect(self.rect).contains(
            e.pos()
        ):
            self.oldrect = QRectF(self.rect)
            self.oldrubberband = QgsRubberBand(
                iface.mapCanvas(), QgsWkbTypes.PolygonGeometry
            )
            self.oldrubberband.setToCanvasRectangle(self.__canvasRect(self.oldrect))
            self.oldrubberband.setColor(QColor(127, 127, 255, 31))
            self.pressPos = (e.x(), e.y())
            iface.mapCanvas().setCursor(Qt.ClosedHandCursor)

    def canvasMoveEvent(self, e):
        if not self.pressPos:
            return
        mup = iface.mapCanvas().mapSettings().mapUnitsPerPixel()
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

        self.rect = QRectF(x, y, self.rect.width(), self.rect.height())
        self.rubberband.setToCanvasRectangle(self.__canvasRect(self.rect))

    def canvasReleaseEvent(self, e):
        if e.button() == Qt.LeftButton and self.pressPos:
            self.corner = QPointF(self.rect.x(), self.rect.y())
            self.pressPos = None
            iface.mapCanvas().setCursor(Qt.OpenHandCursor)
            iface.mapCanvas().scene().removeItem(self.oldrubberband)
            self.oldrect = None
            self.oldrubberband = None
            self.mapitem.setExtent(QgsRectangle(self.rect))

    def __canvasRect(self, rect):  # pylint: disable=invalid-name
        mtp = iface.mapCanvas().mapSettings().mapToPixel()
        point1 = mtp.transform(
            QgsPoint(rect.left(), rect.top())
        )  # pylint: disable=invalid-name
        point2 = mtp.transform(
            QgsPoint(rect.right(), rect.bottom())
        )  # pylint: disable=invalid-name
        return QRect(
            int(point1.x()),
            int(point1.y()),
            int(point2.x() - point1.x()),
            int(point2.y() - point1.y()),
        )

    def __export(self):  # pylint: disable=invalid-name
        settings = QSettings()
        myFormat = self.dialogui.comboBoxFileFormat.itemData(
            self.dialogui.comboBoxFileFormat.currentIndex()
        )
        filepath = QFileDialog.getSaveFileName(
            iface.mainWindow(),
            self.tr("Export Layout"),
            settings.value("/instantprint/lastfile", ""),
            myFormat,
        )
        if not all(filepath):
            return

        # Ensure output filename has correct extension
        filename = (
            os.path.splitext(filepath[0])[0]
            + "."
            + self.dialogui.comboBoxFileFormat.currentText().lower()
        )
        settings.setValue("/instantprint/lastfile", filepath[0])

        if self.populateCompositionFz:
            self.populateCompositionFz(self.layoutView.composition())

        success = False
        layoutName = self.dialogui.comboBoxLayouts.currentText()
        layoutItem = self.projectLayoutManager.layoutByName(layoutName)
        exporter = QgsLayoutExporter(layoutItem)
        if filename[-3:].lower() == "pdf":
            success = exporter.exportToPdf(
                filepath[0], QgsLayoutExporter.PdfExportSettings()
            )
        else:
            success = exporter.exportToImage(
                filepath[0], QgsLayoutExporter.ImageExportSettings()
            )
        if success != 0:
            QMessageBox.warning(
                iface.mainWindow(),
                self.tr("Export Failed"),
                self.tr("Failed to export the layout."),
            )

        # Added (TH 20-10-22)
        QMessageBox.information(
            iface.mainWindow(), "Information", ("Printing completed")
        )

    def __reloadLayouts(self, removed=None):  # pylint: disable=invalid-name
        if not self.dialog.isVisible():
            # Make it less likely to hit the issue
            # outlined in https://github.com/qgis/QGIS/pull/1938
            return

        self.dialogui.comboBoxLayouts.blockSignals(True)
        prev = None
        if self.dialogui.comboBoxLayouts.currentIndex() >= 0:
            prev = self.dialogui.comboBoxLayouts.currentText()
        self.dialogui.comboBoxLayouts.clear()
        active = 0
        for layout in self.projectLayoutManager.layouts():
            if layout != removed and layout.name():
                cur = layout.name()
                self.dialogui.comboBoxLayouts.addItem(cur, layout)
                if prev == cur:
                    active = self.dialogui.comboBoxLayouts.count() - 1
        self.dialogui.comboBoxLayouts.setCurrentIndex(
            -1
        )  # Ensure setCurrentIndex below actually changes an index
        self.dialogui.comboBoxLayouts.blockSignals(False)
        if self.dialogui.comboBoxLayouts.count() > 0:
            self.dialogui.comboBoxLayouts.setCurrentIndex(active)
            self.dialogui.comboBoxScale.setEnabled(True)
            self.exportButton.setEnabled(True)
        else:
            self.exportButton.setEnabled(False)
            self.dialogui.comboBoxScale.setEnabled(False)

    def scaleFromString(self, scaleText):
        locale = QLocale()
        parts = [locale.toInt(part) for part in scaleText.split(":")]
        try:
            if (
                len(parts) == 2
                and parts[0][1]
                and parts[1][1]
                and parts[0][0] != 0
                and parts[1][0] != 0
            ):
                return float(parts[0][0]) / float(parts[1][0])
            return None
        except ZeroDivisionError:
            pass
        return None

    def checkScales(self):
        predefScalesStr = QSettings().value("Map/scales", PROJECT_SCALES).split(",")
        predefScales = [
            self.scaleFromString(scaleString) for scaleString in predefScalesStr
        ]

        comboScalesStr = [
            self.dialogui.comboBoxScale.itemText(i)
            for i in range(self.dialogui.comboBoxScale.count())
        ]
        comboScales = [
            self.scaleFromString(scaleString) for scaleString in comboScalesStr
        ]

        currentScale = self.scaleFromString(self.dialogui.comboBoxScale.currentText())

        if not currentScale:
            self.dialogui.comboBoxScale.lineEdit().setStyleSheet(
                "background: #FF7777; color: #FFFFFF;"
            )
            self.dialogui.addScale.setVisible(True)
            self.dialogui.addScale.setEnabled(False)
            self.dialogui.deleteScale.setVisible(False)
        else:
            self.dialogui.comboBoxScale.lineEdit().setStyleSheet("")
            if currentScale in comboScales:
                # If entry scale is already in the list, allow removing it
                # unless it is a predefined scale
                self.dialogui.addScale.setVisible(False)
                self.dialogui.deleteScale.setVisible(True)
                self.dialogui.deleteScale.setEnabled(currentScale not in predefScales)
            else:
                # Otherwise, show button to add it
                self.dialogui.addScale.setVisible(True)
                self.dialogui.addScale.setEnabled(True)
                self.dialogui.deleteScale.setVisible(False)
