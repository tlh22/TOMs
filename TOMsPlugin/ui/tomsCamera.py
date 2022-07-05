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

"""
Series of functions to deal with restrictionsInProposals. Defined as static functions
to allow them to be used in forms ... (not sure if this is the best way ...)

"""
import datetime
import functools
import os
import time

from qgis.core import Qgis, QgsMessageLog
from qgis.PyQt.QtCore import (
    QObject,
    QThread,
    pyqtSignal,
    pyqtSlot,
)
from qgis.PyQt.QtGui import QImage, QPixmap
from qgis.PyQt.QtWidgets import QApplication, QMessageBox

try:
    import cv2

    CV2_AVAILABLE = True
except ImportError:
    print("cv2 not available ...")
    QgsMessageLog.logMessage("Not able to import cv2 ...", tag="TOMs Panel")
    CV2_AVAILABLE = False

from ..core.tomsMessageLog import TOMsMessageLog


class FormCamera(QObject):
    notifyPhotoTaken = pyqtSignal(str)
    pixmapUpdated = pyqtSignal(QPixmap)

    def __init__(
        self,
        pathAbsolute,
        currFileName,
        startCameraButton,
        takePhotoButton,
        cameraNr=None,
        frameWidth=None,
        frameHeight=None,
        rotateCamera=None,
    ):
        QObject.__init__(self)
        self.pathAbsolute = pathAbsolute
        self.currFileName = currFileName
        self.camera = CvCamera()

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
        self.rotateCamera = rotateCamera
        TOMsMessageLog.logMessage(
            "In formCamera::rotate_camera: {}".format(self.rotateCamera),
            level=Qgis.Info,
        )

        self.startCameraButton = startCameraButton
        self.takePhotoButton = takePhotoButton

        self.currButtonColour = None
        self.photoTaken = False
        self.cameraAvailable = False
        self.cap = None
        self.cvRotatedImage = None
        self.cvRGBImg = None

        TOMsMessageLog.logMessage("formCamera:init completed ...", level=Qgis.Info)

    def identify(self):
        QMessageBox.information(
            None,
            "Information",
            "Hello, I am a camera path:{} photo:{} ...".format(
                self.pathAbsolute, self.currFileName
            ),
            QMessageBox.Ok,
        )

    @pyqtSlot(QPixmap)
    def displayFrame(self, pixmap):
        TOMsMessageLog.logMessage("In formCamera::displayFrame ... ", level=Qgis.Info)
        # self.FIELD.setPixmap(pixmap)
        # self.FIELD.setScaledContents(True)
        self.pixmapUpdated.emit(pixmap)
        QApplication.processEvents()

    @pyqtSlot()
    def useCamera(self):
        TOMsMessageLog.logMessage("In formCamera::useCamera ... ", level=Qgis.Info)

        self.startCameraButton.clicked.disconnect()
        self.currButtonColour = self.startCameraButton.palette().button().color()
        self.startCameraButton.setStyleSheet("QPushButton {color: red;}")
        self.startCameraButton.setText("Close Camera")
        self.startCameraButton.clicked.connect(self.endCamera)

        # Camera code

        self.camera.changePixmap.connect(self.displayFrame)
        self.camera.closeCamera.connect(self.endCamera)

        self.takePhotoButton.setEnabled(True)
        self.takePhotoButton.clicked.connect(
            functools.partial(self.camera.takePhoto, self.pathAbsolute)
        )
        self.camera.photoTaken.connect(self.checkPhotoTaken)
        self.photoTaken = False

        TOMsMessageLog.logMessage(
            "In formCamera::useCamera: starting camera ... ", level=Qgis.Info
        )

        self.camera.startCamera(
            self.cameraNr, self.frameWidth, self.frameHeight, self.rotateCamera
        )

    def endCamera(self):

        TOMsMessageLog.logMessage(
            "In formCamera::endCamera: stopping camera ... ", level=Qgis.Info
        )

        try:
            self.camera.stopCamera()
            self.camera.changePixmap.disconnect(self.displayFrame)
            self.camera.closeCamera.disconnect(self.endCamera)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "In formCamera::endCamera: problem stopping camera {}".format(e),
                level=Qgis.Warning,
            )

        # del self.camera

        if self.takePhotoButton:
            self.takePhotoButton.setEnabled(False)
            self.takePhotoButton.clicked.disconnect()

        if self.startCameraButton:
            self.startCameraButton.setChecked(False)
            self.startCameraButton.setText("Open Camera")
            self.startCameraButton.setStyleSheet("QPushButton {color: green;}")

            try:
                self.startCameraButton.clicked.disconnect()
                self.startCameraButton.clicked.connect(self.useCamera)
            except Exception as e:
                TOMsMessageLog.logMessage(
                    "In formCamera::endCamera: problem resetting connections {}".format(
                        e
                    ),
                    level=Qgis.Warning,
                )

        if not self.photoTaken:
            self.resetPhoto()

    def closeCameraForm(self):

        TOMsMessageLog.logMessage(
            "In formCamera::closeCameraForm: closing form ... ", level=Qgis.Info
        )

        try:
            self.camera.stopCamera()
            self.camera.changePixmap.disconnect(self.displayFrame)
            self.camera.closeCamera.disconnect(self.endCamera)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "In formCamera::closeCameraForm1: problem stopping camera {}".format(e),
                level=Qgis.Warning,
            )

        try:
            self.takePhotoButton.clicked.disconnect()
            self.startCameraButton.clicked.disconnect()
        except Exception as e:
            TOMsMessageLog.logMessage(
                "In formCamera::closeCameraForm1: problem disconnecting buttons {}".format(
                    e
                ),
                level=Qgis.Warning,
            )

    @pyqtSlot(str)
    def checkPhotoTaken(self, fileName):
        TOMsMessageLog.logMessage(
            "In formCamera::photoTaken: file: " + fileName, level=Qgis.Info
        )

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
                # self.FIELD.setPixmap(pixmap)
                # self.FIELD.setScaledContents(True)
                self.pixmapUpdated.emit(pixmap)


class CvCamera(QThread):
    changePixmap = pyqtSignal(QPixmap)
    closeCamera = pyqtSignal()
    photoTaken = pyqtSignal(str)

    def __init__(self):
        QThread.__init__(self)
        TOMsMessageLog.logMessage("In cvCamera::init ... ", level=Qgis.Info)
        self.cameraAvailable = False
        self.rotateCamera = None
        self.cap = None
        self.cvRotatedImage = None
        self.cvRGBImg = None

    def stopCamera(self):
        TOMsMessageLog.logMessage("In cvCamera::stopCamera ... ", level=Qgis.Info)
        self.cameraAvailable = False
        try:
            self.cap.release()
        except Exception as e:
            TOMsMessageLog.logMessage(
                "In cvCamera::stopCamera: problem stopping camera {}".format(e),
                level=Qgis.Info,
            )

    def startCamera(self, cameraNr, frameWidth, frameHeight, rotateCamera):

        TOMsMessageLog.logMessage(
            "In cvCamera::startCamera: ... 1 nr: {}; rotate: {}".format(
                cameraNr, rotateCamera
            ),
            level=Qgis.Info,
        )
        self.rotateCamera = rotateCamera

        if not CV2_AVAILABLE:
            QMessageBox.information(
                None,
                "Information",
                "Camera is not available. Check cv2 status ...",
                QMessageBox.Ok,
            )
            self.closeCamera.emit()
            return False

        try:
            self.cap = cv2.VideoCapture(
                cameraNr
            )  # video capture source camera (Here webcam of laptop)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "In TOMsCamera::startCamera: problem starting camera {}".format(e),
                level=Qgis.Warning,
            )
            self.cameraAvailable = False
            return False

        self.cameraAvailable = True
        if not self.cap.isOpened():
            QMessageBox.information(
                None,
                "Information",
                "Camera {} did not open ...".format(cameraNr),
                QMessageBox.Ok,
            )
            self.cameraAvailable = False

        TOMsMessageLog.logMessage("In cvCamera::startCamera: ... 2a ", level=Qgis.Info)

        TOMsMessageLog.logMessage(
            "In cvCamera::startCamera: ... resolution: {}*{} ".format(
                frameWidth, frameHeight
            ),
            level=Qgis.Info,
        )

        self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, frameWidth)  # width=640 (1600)
        self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, frameHeight)  # height=480 (1200)

        TOMsMessageLog.logMessage("In cvCamera::startCamera: ... 2b ", level=Qgis.Info)

        while self.cameraAvailable:
            self.getFrame()
            time.sleep(0.1)

        TOMsMessageLog.logMessage(
            "In cvCamera::startCamera: camera closed ... ", level=Qgis.Info
        )
        self.closeCamera.emit()
        return True

    def getFrame(self):

        """Camera code"""

        TOMsMessageLog.logMessage("In cvCamera::getFrame ... 1", level=Qgis.Info)

        ret, frame = self.cap.read()  # return a single frame in variable `frame`

        TOMsMessageLog.logMessage("In cvCamera::getFrame ... 2 ", level=Qgis.Info)

        if ret:

            # check for rotation
            if self.rotateCamera:
                TOMsMessageLog.logMessage(
                    "In cvCamera::getFrame ... rotating ", level=Qgis.Info
                )
                self.cvRotatedImage = cv2.flip(frame, 0)
            else:
                self.cvRotatedImage = frame

            # Need to change from BRG (cv::mat) to RGB image
            self.cvRGBImg = cv2.cvtColor(self.cvRotatedImage, cv2.COLOR_BGR2RGB)
            qimg = QImage(
                self.cvRGBImg.data,
                self.cvRGBImg.shape[1],
                self.cvRGBImg.shape[0],
                QImage.Format_RGB888,
            )
            TOMsMessageLog.logMessage("In cvCamera::getFrame ... 3 ", level=Qgis.Info)

            # Now display ...
            pixmap = QPixmap.fromImage(qimg)

            self.changePixmap.emit(pixmap)

            TOMsMessageLog.logMessage("In cvCamera::getFrame ... 4 ", level=Qgis.Info)
        else:

            TOMsMessageLog.logMessage(
                "In cvCamera::useCamera: frame not returned ... ", level=Qgis.Warning
            )
            self.closeCamera.emit()

        TOMsMessageLog.logMessage("In cvCamera::getFrame ... 5", level=Qgis.Info)

    def takePhoto(self, pathAbsolute):

        TOMsMessageLog.logMessage("In cvCamera::takePhoto ... ", level=Qgis.Info)
        # Save frame to file

        fileName = "Photo_{}.png".format(
            datetime.datetime.now().strftime("%Y%m%d_%H%M%S%f")
        )
        newPhotoFileName = os.path.join(pathAbsolute, fileName)

        TOMsMessageLog.logMessage(
            "Saving photo: file: " + newPhotoFileName, level=Qgis.Info
        )
        writeStatus = cv2.imwrite(newPhotoFileName, self.cvRotatedImage)

        if writeStatus is True:
            QMessageBox.information(
                None, "Information", "Photo captured.", QMessageBox.Ok
            )
            self.photoTaken.emit(newPhotoFileName)
        else:
            QMessageBox.information(
                None, "Information", "Problem taking photo.", QMessageBox.Ok
            )
            self.photoTaken.emit()

        # Now stop camera (and display image)
        self.cap.release()

        # https://stackoverflow.com/questions/44404349/pyqt-showing-video-stream-from-opencv
