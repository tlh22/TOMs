# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ---------------------------------------------------------------------
# Tim Hancock 2020

# https://stackoverflow.com/questions/48116698/zoom-qimage-on-qpixmap-in-qlabel
# to install - https://stackoverflow.com/questions/22528418/replace-qwidget-objects-at-runtime
# also ... https://stackoverflow.com/questions/35508711/how-to-enable-pan-and-zoom-in-a-qgraphicsview/35514531#35514531
# ... and https://stackoverflow.com/questions/20942586/controlling-the-pan-to-anchor-a-point-when-zooming-into-an-image

from PyQt5 import QtWidgets, QtCore, QtGui

from qgis.core import (
    Qgis,
    QgsMessageLog,
    QgsExpressionContextUtils
)
from TOMs.core.TOMsMessageLog import TOMsMessageLog

ZOOM_LIMIT = 5
class imageLabel(QtWidgets.QLabel):
    photoClicked = QtCore.pyqtSignal(QtCore.QPoint)

    def __init__(self):
        super(imageLabel, self).__init__()
        self._empty = True
        self.top_left_corner = QtCore.QPoint(0, 0)
        #self.screenpoint = QtCore.QPoint(0, 0)
        self._displayed_pixmap = QtGui.QPixmap()

        """self.setSizePolicy(
            QtWidgets.QSizePolicy.MinimumExpanding,
            QtWidgets.QSizePolicy.MinimumExpanding
        )"""
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.MinimumExpanding, QtWidgets.QSizePolicy.MinimumExpanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        #sizePolicy.setHeightForWidth(sizePolicy().hasHeightForWidth())
        self.setSizePolicy(sizePolicy)
        self.setAutoFillBackground(True)

    def setPixmap(self, image):
        TOMsMessageLog.logMessage("In imageLabel.setPixmap ... ", level=Qgis.Info)
        super(imageLabel, self).setPixmap(image)
        self.origImage = image
        self._zoom = 0
        if image and not image.isNull():
            self._empty = False
            self._displayed_pixmap = image

    def update_image(self, image):
        self._displayed_pixmap = image

    def hasPhoto(self):
        return not self._empty

    def wheelEvent(self, event):
        TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... new ", level=Qgis.Info)
        super(imageLabel, self).wheelEvent(event)

        modifiers = QtWidgets.QApplication.keyboardModifiers()

        if modifiers == QtCore.Qt.ControlModifier:  # need to hold down Ctl and use the wheel for the zoom to take effect

            if self.hasPhoto() and abs(self._zoom) < ZOOM_LIMIT:
                TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... acting ", level=Qgis.Info)
                if event.angleDelta().y() > 0:
                    TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... zooming in ", level=Qgis.Info)
                    factor = 1.25
                    self._zoom += 1
                else:
                    TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... zooming out ", level=Qgis.Info)
                    factor = 0.8
                    self._zoom -= 1

                if abs(self._zoom) < ZOOM_LIMIT:

                    image_size = self._displayed_pixmap.size()
                    TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... dimensions {}:{}. Resized to {}:{} ".format(image_size.width(), image_size.height(), image_size.width() * factor, image_size.height() * factor), level=Qgis.Info)
                    if (self._zoom) == 0:
                        image_size.setWidth(image_size.width())
                        image_size.setHeight(image_size.height())
                    else:
                        image_size.setWidth(image_size.width() * factor )
                        image_size.setHeight(image_size.height() * factor)

                    self.screenpoint = self.mapFromGlobal(QtGui.QCursor.pos())
                    curr_x, curr_y = self.screenpoint.x(), self.screenpoint.y()

                    TOMsMessageLog.logMessage(
                        "In imageLabel.wheelEvent ... zoom:factor {}:{}".format(self._zoom, factor),
                        level=Qgis.Info)
                    TOMsMessageLog.logMessage(
                        "In imageLabel.wheelEvent ... screenpoint {}:{}".format(curr_x, curr_y),
                        level=Qgis.Info)

                    if self._zoom == 0:
                        self.top_left_corner.setX(0)
                        self.top_left_corner.setY(0)
                    else:
                        self.top_left_corner.setX(self.top_left_corner.x() * factor + curr_x - (curr_x * factor))
                        self.top_left_corner.setY(self.top_left_corner.y() * factor `+ curr_y - (curr_y * factor))

                    TOMsMessageLog.logMessage(
                            "In imageLabel.wheelEvent ... tl new 2 {}:{}".format(self.top_left_corner.x(),
                                                                                 self.top_left_corner.y()),
                            level=Qgis.Info)

                    self.update_image(self.origImage.scaled(image_size, QtCore.Qt.KeepAspectRatio, transformMode=QtCore.Qt.SmoothTransformation))
                    self.update()  # call paintEvent()

                else:
                    if self._zoom > 0:
                        self._zoom -= 1
                    else:
                        self._zoom += 1

        """def mousePressEvent(self, event):
        self.pixMapCentre = event.pos()
        TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... pressed {}:{}. ".format(self.pixMapCentre.x(), self.pixMapCentre.y()),
                                  level=Qgis.Warning)"""

    def paintEvent(self, paint_event):
        painter = QtGui.QPainter(self)

        painter.drawPixmap(self.top_left_corner.x(), self.top_left_corner.y(), self._displayed_pixmap)
