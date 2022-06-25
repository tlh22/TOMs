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
    cv2_available = True
except ImportError:
    print('cv2 not available ...')
    QgsMessageLog.logMessage("Not able to import cv2 ...", tag="TOMs panel")
    cv2_available = False

from TOMs.core.TOMsMessageLog import TOMsMessageLog

class formCamera(QObject):
    notifyPhotoTaken = pyqtSignal(str)
    pixmapUpdated = pyqtSignal(QPixmap)

    def __init__(self, path_absolute, currFileName, START_CAMERA_BUTTON, TAKE_PHOTO_BUTTON, cameraNr=None, frameWidth=None, frameHeight=None, rotate_camera=None):
        QObject.__init__(self)
        self.path_absolute = path_absolute
        self.currFileName = currFileName
        self.camera = cvCamera()

        self.cameraNr = cameraNr
        if self.cameraNr is None:
            self.cameraNr = 1

        self.frameWidth = frameWidth
        if self.frameWidth is None:
            self.frameWidth = 640

        self.frameHeight = frameHeight
        if self.frameHeight is None:
            self.frameHeight = 480

        # indicate whether or not to flip image
        self.rotate_camera = rotate_camera
        TOMsMessageLog.logMessage("In formCamera::rotate_camera: {}".format(self.rotate_camera), level=Qgis.Info)

        self.START_CAMERA_BUTTON = START_CAMERA_BUTTON
        self.TAKE_PHOTO_BUTTON = TAKE_PHOTO_BUTTON

        TOMsMessageLog.logMessage("formCamera:init completed ...", level=Qgis.Info)

    def identify(self):
        reply = QMessageBox.information(None, "Information",
                                        "Hello, I am a camera path:{} photo:{} ...".format(self.path_absolute, self.currFileName),
                                        QMessageBox.Ok)

    @pyqtSlot(QPixmap)
    def displayFrame(self, pixmap):
        TOMsMessageLog.logMessage("In formCamera::displayFrame ... ", level=Qgis.Info)
        #self.FIELD.setPixmap(pixmap)
        #self.FIELD.setScaledContents(True)
        self.pixmapUpdated.emit(pixmap)
        QApplication.processEvents()  # processes the event queue - https://stackoverflow.com/questions/43094589/opencv-imshow-prevents-qt-python-crashing

    @pyqtSlot()
    def useCamera(self):
        TOMsMessageLog.logMessage("In formCamera::useCamera ... ", level=Qgis.Info)

        self.START_CAMERA_BUTTON.clicked.disconnect()
        self.currButtonColour = self.START_CAMERA_BUTTON.palette().button().color()
        self.START_CAMERA_BUTTON.setStyleSheet('QPushButton {color: red;}')
        self.START_CAMERA_BUTTON.setText('Close Camera')
        self.START_CAMERA_BUTTON.clicked.connect(self.endCamera)

        """ Camera code  """

        self.camera.changePixmap.connect(self.displayFrame)
        self.camera.closeCamera.connect(self.endCamera)

        self.TAKE_PHOTO_BUTTON.setEnabled(True)
        self.TAKE_PHOTO_BUTTON.clicked.connect(functools.partial(self.camera.takePhoto, self.path_absolute))
        self.camera.photoTaken.connect(self.checkPhotoTaken)
        self.photoTaken = False

        TOMsMessageLog.logMessage("In formCamera::useCamera: starting camera ... ", level=Qgis.Info)

        self.camera.startCamera(self.cameraNr, self.frameWidth, self.frameHeight, self.rotate_camera)

    def endCamera(self):

        TOMsMessageLog.logMessage("In formCamera::endCamera: stopping camera ... ", level=Qgis.Info)

        try:
            self.camera.stopCamera()
            self.camera.changePixmap.disconnect(self.displayFrame)
            self.camera.closeCamera.disconnect(self.endCamera)
        except Exception as e:
            TOMsMessageLog.logMessage("In formCamera::endCamera: problem stopping camera {}".format(e), level=Qgis.Warning)

        # del self.camera

        if self.TAKE_PHOTO_BUTTON:
            self.TAKE_PHOTO_BUTTON.setEnabled(False)
            self.TAKE_PHOTO_BUTTON.clicked.disconnect()

        if self.START_CAMERA_BUTTON:
            self.START_CAMERA_BUTTON.setChecked(False)
            self.START_CAMERA_BUTTON.setText('Open Camera')
            self.START_CAMERA_BUTTON.setStyleSheet('QPushButton {color: green;}')

            try:
                self.START_CAMERA_BUTTON.clicked.disconnect()
                self.START_CAMERA_BUTTON.clicked.connect(self.useCamera)
            except Exception as e:
                TOMsMessageLog.logMessage("In formCamera::endCamera: problem resetting connections {}".format(e),
                                          level=Qgis.Warning)

        if self.photoTaken == False:
            self.resetPhoto()

    def closeCameraForm(self):

        TOMsMessageLog.logMessage("In formCamera::closeCameraForm: closing form ... ", level=Qgis.Info)

        try:
            self.camera.stopCamera()
            self.camera.changePixmap.disconnect(self.displayFrame)
            self.camera.closeCamera.disconnect(self.endCamera)
        except Exception as e:
            TOMsMessageLog.logMessage("In formCamera::closeCameraForm1: problem stopping camera {}".format(e), level=Qgis.Warning)

        try:
            self.TAKE_PHOTO_BUTTON.clicked.disconnect()
            self.START_CAMERA_BUTTON.clicked.disconnect()
        except Exception as e:
            TOMsMessageLog.logMessage("In formCamera::closeCameraForm1: problem disconnecting buttons {}".format(e), level=Qgis.Warning)

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

        if len(self.currFileName) > 0:
            pixmap = QPixmap(self.currFileName)
            if pixmap.isNull():
                pass
            else:
                #self.FIELD.setPixmap(pixmap)
                #self.FIELD.setScaledContents(True)
                self.pixmapUpdated.emit(pixmap)

        return

class cvCamera(QThread):
    changePixmap = pyqtSignal(QPixmap)
    closeCamera = pyqtSignal()
    photoTaken = pyqtSignal(str)

    def __init__(self):
        QThread.__init__(self)
        TOMsMessageLog.logMessage("In cvCamera::init ... ", level=Qgis.Info)

    def stopCamera(self):
        TOMsMessageLog.logMessage("In cvCamera::stopCamera ... ", level=Qgis.Info)
        self.cameraAvailable = False
        try:
            self.cap.release()
        except Exception as e:
            TOMsMessageLog.logMessage("In cvCamera::stopCamera: problem stopping camera {}".format(e), level=Qgis.Info)

    def startCamera(self, cameraNr, frameWidth, frameHeight, rotate_camera):

        TOMsMessageLog.logMessage("In cvCamera::startCamera: ... 1 nr: {}; rotate: {}".format(cameraNr, rotate_camera), level=Qgis.Info)
        self.rotate_camera = rotate_camera

        """if acapture_available:
            self.cap = acapture.open(cameraNr)  # /dev/video0
        else:"""
        if not cv2_available:
            reply = QMessageBox.information(None, "Information", "Camera is not available. Check cv2 status ...", QMessageBox.Ok)
            self.closeCamera.emit()
            return False

        try:
            self.cap = cv2.VideoCapture(cameraNr)  # video capture source camera (Here webcam of laptop)
        except Exception as e:
            TOMsMessageLog.logMessage("In TOMsCamera::startCamera: problem starting camera {}".format(e), level=Qgis.Warning)
            self.cameraAvailable = False
            return

        self.cameraAvailable = True
        if not self.cap.isOpened():
            reply = QMessageBox.information(None, "Information", "Camera {} did not open ...".format(cameraNr), QMessageBox.Ok)
            self.cameraAvailable = False

        TOMsMessageLog.logMessage("In cvCamera::startCamera: ... 2a ", level=Qgis.Info)

        TOMsMessageLog.logMessage("In cvCamera::startCamera: ... resolution: {}*{} ".format(frameWidth, frameHeight), level=Qgis.Info)

        self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, frameWidth)  # width=640 (1600)
        self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, frameHeight)  # height=480 (1200)

        TOMsMessageLog.logMessage("In cvCamera::startCamera: ... 2b ", level=Qgis.Info)

        while self.cameraAvailable:
            #while True:
            self.getFrame()
            # cv2.imshow('img1',self.frame) #display the captured image
            # cv2.waitKey(1)
            time.sleep(0.1)
        else:
            TOMsMessageLog.logMessage("In cvCamera::startCamera: camera closed ... ", level=Qgis.Info)
            self.closeCamera.emit()

    def getFrame(self):

        """ Camera code  """

        TOMsMessageLog.logMessage("In cvCamera::getFrame ... 1", level=Qgis.Info)

        ret, frame = self.cap.read()  # return a single frame in variable `frame`

        TOMsMessageLog.logMessage("In cvCamera::getFrame ... 2 ", level=Qgis.Info)

        if ret == True:

            # check for rotation
            if self.rotate_camera:
                TOMsMessageLog.logMessage("In cvCamera::getFrame ... rotating ", level=Qgis.Info)
                self.cvRotatedImage = cv2.flip(frame, 0)
            else:
                self.cvRotatedImage = frame

            # Need to change from BRG (cv::mat) to RGB image
            self.cvRGBImg = cv2.cvtColor(self.cvRotatedImage, cv2.COLOR_BGR2RGB)
            qimg = QImage(self.cvRGBImg.data, self.cvRGBImg.shape[1], self.cvRGBImg.shape[0], QImage.Format_RGB888)
            TOMsMessageLog.logMessage("In cvCamera::getFrame ... 3 ", level=Qgis.Info)

            # Now display ...
            pixmap = QPixmap.fromImage(qimg)

            self.changePixmap.emit(pixmap)

            TOMsMessageLog.logMessage("In cvCamera::getFrame ... 4 ", level=Qgis.Info)
        else:

            TOMsMessageLog.logMessage("In cvCamera::useCamera: frame not returned ... ", level=Qgis.Warning)
            self.closeCamera.emit()

        TOMsMessageLog.logMessage("In cvCamera::getFrame ... 5", level=Qgis.Info)

    def takePhoto(self, path_absolute):

        TOMsMessageLog.logMessage("In cvCamera::takePhoto ... ", level=Qgis.Info)
        # Save frame to file

        fileName = 'Photo_{}.png'.format(datetime.datetime.now().strftime('%Y%m%d_%H%M%S%f'))
        newPhotoFileName = os.path.join(path_absolute, fileName)

        TOMsMessageLog.logMessage("Saving photo: file: " + newPhotoFileName, level=Qgis.Info)
        writeStatus = cv2.imwrite(newPhotoFileName, self.cvRotatedImage)

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
