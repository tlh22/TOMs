# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ---------------------------------------------------------------------
# Tim Hancock 2017

"""
Series of functions to deal with restrictionsInProposals. Defined as static functions to allow them to be used in forms ... (not sure if this is the best way ...)

"""
from qgis.PyQt.QtWidgets import (
    QMessageBox,
    QAction,
    QDialogButtonBox,
    QLabel,
    QDockWidget,
    QPushButton,
    QApplication
)

from qgis.PyQt.QtGui import (
    QIcon,
    QPixmap,
    QImage
)

from qgis.PyQt.QtCore import (
    QObject,
    QTimer,
    pyqtSignal, pyqtSlot,
    QThread
)


from qgis.core import (
    Qgis,
    QgsMessageLog,
    QgsExpressionContextUtils
)

import sys, os, ntpath
import numpy as np
#import cv2
import functools
import datetime
import time

try:
    import cv2
except ImportError:
    print('cv2 not available ...')
    QgsMessageLog.logMessage("cv2 not available ...")


from TOMs.core.TOMsMessageLog import TOMsMessageLog

class formCamera(QObject):
    notifyPhotoTaken = pyqtSignal(str)

    def __init__(self, path_absolute, currFileName):
        QObject.__init__(self)
        self.path_absolute = path_absolute
        self.currFileName = currFileName
        self.camera = cvCamera()

    @pyqtSlot(QPixmap)
    def displayFrame(self, pixmap):
        # TOMsMessageLog.logMessage("In formCamera::displayFrame ... ", level=Qgis.Info)
        self.FIELD.setPixmap(pixmap)
        self.FIELD.setScaledContents(True)
        QApplication.processEvents()  # processes the event queue - https://stackoverflow.com/questions/43094589/opencv-imshow-prevents-qt-python-crashing

    def useCamera(self, START_CAMERA_BUTTON, TAKE_PHOTO_BUTTON, FIELD):
        TOMsMessageLog.logMessage("In formCamera::useCamera ... ", level=Qgis.Info)
        self.START_CAMERA_BUTTON = START_CAMERA_BUTTON
        self.TAKE_PHOTO_BUTTON = TAKE_PHOTO_BUTTON
        self.FIELD = FIELD

        # self.blockSignals(True)
        self.START_CAMERA_BUTTON.clicked.disconnect()
        self.START_CAMERA_BUTTON.clicked.connect(self.endCamera)

        """ Camera code  """

        self.camera.changePixmap.connect(self.displayFrame)
        self.camera.closeCamera.connect(self.endCamera)

        self.TAKE_PHOTO_BUTTON.setEnabled(True)
        self.TAKE_PHOTO_BUTTON.clicked.connect(functools.partial(self.camera.takePhoto, self.path_absolute))
        self.camera.photoTaken.connect(self.checkPhotoTaken)
        self.photoTaken = False

        TOMsMessageLog.logMessage("In formCamera::useCamera: starting camera ... ", level=Qgis.Info)

        self.camera.startCamera()

    def endCamera(self):

        TOMsMessageLog.logMessage("In formCamera::endCamera: stopping camera ... ", level=Qgis.Info)

        self.camera.stopCamera()
        self.camera.changePixmap.disconnect(self.displayFrame)
        self.camera.closeCamera.disconnect(self.endCamera)

        # del self.camera

        self.TAKE_PHOTO_BUTTON.setEnabled(False)
        self.START_CAMERA_BUTTON.setChecked(False)
        self.TAKE_PHOTO_BUTTON.clicked.disconnect()

        self.START_CAMERA_BUTTON.clicked.disconnect()
        self.START_CAMERA_BUTTON.clicked.connect(
            functools.partial(self.useCamera, self.START_CAMERA_BUTTON, self.TAKE_PHOTO_BUTTON, self.FIELD))

        if self.photoTaken == False:
            self.resetPhoto()

    @pyqtSlot(str)
    def checkPhotoTaken(self, fileName):
        TOMsMessageLog.logMessage("In formCamera::photoTaken: file: " + fileName, level=Qgis.Info)

        if len(fileName) > 0:
            self.photoTaken = True
            self.notifyPhotoTaken.emit(fileName)
        else:
            self.resetPhoto()
            self.photoTaken = False

    def resetPhoto(self):
        TOMsMessageLog.logMessage("In formCamera::resetPhoto ... ", level=Qgis.Info)

        pixmap = QPixmap(self.currFileName)
        if pixmap.isNull():
            pass
        else:
            self.FIELD.setPixmap(pixmap)
            self.FIELD.setScaledContents(True)


class cvCamera(QThread):
    changePixmap = pyqtSignal(QPixmap)
    closeCamera = pyqtSignal()
    photoTaken = pyqtSignal(str)

    def __init__(self):
        QThread.__init__(self)

    def stopCamera(self):
        TOMsMessageLog.logMessage("In cvCamera::stopCamera ... ", level=Qgis.Info)
        self.cap.release()

    def startCamera(self):

        TOMsMessageLog.logMessage("In cvCamera::startCamera: ... ", level=Qgis.Info)

        self.cap = cv2.VideoCapture(0)  # video capture source camera (Here webcam of laptop)

        self.cap.set(3, 640)  # width=640
        self.cap.set(4, 480)  # height=480

        while self.cap.isOpened():
            self.getFrame()
            # cv2.imshow('img1',self.frame) #display the captured image
            # cv2.waitKey(1)
            time.sleep(0.1)  # QTimer::singleShot()
        else:
            TOMsMessageLog.logMessage("In cvCamera::startCamera: camera closed ... ", level=Qgis.Info)
            self.closeCamera.emit()

    def getFrame(self):

        """ Camera code  """

        # TOMsMessageLog.logMessage("In cvCamera::getFrame ... ", level=Qgis.Info)

        ret, self.frame = self.cap.read()  # return a single frame in variable `frame`

        if ret == True:
            # Need to change from BRG (cv::mat) to RGB image
            cvRGBImg = cv2.cvtColor(self.frame, cv2.COLOR_BGR2RGB)
            qimg = QImage(cvRGBImg.data, cvRGBImg.shape[1], cvRGBImg.shape[0], QImage.Format_RGB888)

            # Now display ...
            pixmap = QPixmap.fromImage(qimg)

            self.changePixmap.emit(pixmap)

        else:

            TOMsMessageLog.logMessage("In cvCamera::useCamera: frame not returned ... ", level=Qgis.Info)
            self.closeCamera.emit()

    def takePhoto(self, path_absolute):

        TOMsMessageLog.logMessage("In cvCamera::takePhoto ... ", level=Qgis.Info)
        # Save frame to file

        fileName = 'Photo_{}.png'.format(datetime.datetime.now().strftime('%Y%m%d_%H%M%S%z'))
        newPhotoFileName = os.path.join(path_absolute, fileName)

        TOMsMessageLog.logMessage("Saving photo: file: " + newPhotoFileName, level=Qgis.Info)
        writeStatus = cv2.imwrite(newPhotoFileName, self.frame)

        if writeStatus is True:
            reply = QMessageBox.information(None, "Information", "Photo captured.", QMessageBox.Ok)
            self.photoTaken.emit(newPhotoFileName)
        else:
            reply = QMessageBox.information(None, "Information", "Problem taking photo.", QMessageBox.Ok)
            self.photoTaken.emit()

        # Now stop camera (and display image)

        self.cap.release()

        """def fps(self):
            fps = int(cv.GetCaptureProperty(self._cameraDevice, cv.CV_CAP_PROP_FPS))
            if not fps > 0:
                fps = self._DEFAULT_FPS
            return fps"""
        # https://stackoverflow.com/questions/44404349/pyqt-showing-video-stream-from-opencv
