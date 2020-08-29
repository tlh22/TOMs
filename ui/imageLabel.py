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

class imageLabel(QtWidgets.QLabel):
    photoClicked = QtCore.pyqtSignal(QtCore.QPoint)

    def __init__(self):
        super(imageLabel, self).__init__()
        self._empty = True
        self.top_left_corner =  [1, 1]
        self.centre = [320, 240]

        """self.setSizePolicy(
            QtWidgets.QSizePolicy.MinimumExpanding,
            QtWidgets.QSizePolicy.MinimumExpanding
        )
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.Photo_Widget_01.sizePolicy().hasHeightForWidth())
        self.setSizePolicy(sizePolicy)"""

    def set_image(self, image):
        self.origImage = image
        self.origImageRect = self.origImage.rect()
        self.pixMapCentre = self.origImageRect.center()
        TOMsMessageLog.logMessage("In imageLabel.imageRect ... {}".format(self.origImageRect.size()), level=Qgis.Warning)
        self._zoom = 0
        if image and not image.isNull():
            self._empty = False
            self._displayed_pixmap = image
            # scale image to fit label
            #self._displayed_pixmap.scaled(self.width(), self.height(), QtCore.Qt.KeepAspectRatio)
            #self.setScaledContents(True)
            #self.setMinimumSize(640, 480)

    def update_image(self, image):
        self._displayed_pixmap = image
        self.setScaledContents(True)

    def hasPhoto(self):
        return not self._empty

    def wheelEvent(self, event):
        TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... ", level=Qgis.Warning)
        super(imageLabel, self).wheelEvent(event)
        #TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... 2", level=Qgis.Warning)
        modifiers = QtWidgets.QApplication.keyboardModifiers()
        if modifiers == QtCore.Qt.ControlModifier:
            #self.zoom_image(event.angleDelta().y())
            TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... checking photo", level=Qgis.Warning)
            if self.hasPhoto():
                TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... 3 ", level=Qgis.Warning)
                if event.angleDelta().y() > 0:
                    TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... zooming in ", level=Qgis.Warning)
                    factor = 1.25
                    self._zoom += 1
                else:
                    TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... zooming out ", level=Qgis.Warning)
                    factor = 0.8
                    self._zoom -= 1
                #TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... zoom {} ".format(self._zoom), level=Qgis.Warning)
                if abs(self._zoom) < 5:

                    image_size = self._displayed_pixmap.size()
                    TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... dimensions {}:{}. Resized to {}:{} ".format(image_size.width(), image_size.height(), image_size.width() * factor, image_size.height() * factor), level=Qgis.Warning)
                    image_size.setWidth(image_size.width() * factor * abs(self._zoom))
                    image_size.setHeight(image_size.height() * factor * abs(self._zoom))

                    self.screenpoint = self.mapFromGlobal(QtGui.QCursor.pos())
                    curr_x, curr_y = self.screenpoint.x(), self.screenpoint.y()
                    self.pixMapCentre = self.screenpoint


                    dx = curr_x - self.centre[0]
                    dy = curr_y - self.centre[1]
                    TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... screen point {}:{}. ".format(dx, dy), level=Qgis.Warning)
                    self.centre[0] = curr_x
                    self.centre[1] = curr_y

                    self.top_left_corner[0] = self.top_left_corner[0] - dx
                    self.top_left_corner[1] = self.top_left_corner[1] - dy
                    TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... top left corner {}:{}. ".format(self.top_left_corner[0], self.top_left_corner[1]), level=Qgis.Warning)

                    """"#oldpoint = (screenpoint.x() + self.position[0], screenpoint.y() + self.position[1])
                    TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... old point {}:{}. ".format(oldpoint[0], oldpoint[1]), level=Qgis.Warning)

                    newpoint = (oldpoint[0] * (factor),
                                oldpoint[1] * (factor ))
                    TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... newpoint     {}:{}. ".format(newpoint[0], newpoint[1]), level=Qgis.Warning)

                    self.position = (newpoint[0] - dx, newpoint[1] - dy)
                    TOMsMessageLog.logMessage("In imageLabel.wheelEvent ... position {}:{}. ".format(self.position[0], self.position[1]), level=Qgis.Warning)"""

                    self.update_image(self.origImage.scaled(image_size, QtCore.Qt.KeepAspectRatio, transformMode=QtCore.Qt.SmoothTransformation))
                    self.update()  # call paintEvent()

                    # TODO: Need some control over amount of zoom ??

        """def mousePressEvent(self, event):
        if self._displayed_pixmap.isUnderMouse():
            self.photoClicked.emit(self.mapToScene(event.pos()).toPoint())
        super(imageLabel, self).mousePressEvent(event)"""

    def mousePressEvent(self, event):
        self.pressed = event.pos()
        self.anchor = self.position

    def mouseReleaseEvent(self, event):
        self.pressed = None

    def mouseMoveEvent(self, event):
        if (self.pressed):
            dx, dy = event.x() - self.pressed.x(), event.y() - self.pressed.y()
            self.position = (self.anchor[0] - dx, self.anchor[1] - dy)
        self.repaint()

    def paintEvent(self, paint_event):
        painter = QtGui.QPainter(self)
        self.origImageRect.moveCenter(self.pixMapCentre)

        painter.drawPixmap(self.origImageRect, self._displayed_pixmap)
        #painter.drawPixmap(self.top_left_corner[0], self.top_left_corner[1] , self._displayed_pixmap)
