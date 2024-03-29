# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ---------------------------------------------------------------------
# Tim Hancock 2022

import os
#from pathlib import Path
#from typing import ChainMap
#import uuid
import datetime
import time
import functools
#from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5.QtMultimedia import QCamera, QCameraImageCapture, QCameraInfo, QImageEncoderSettings, QCameraViewfinderSettings
from PyQt5.QtMultimediaWidgets import QCameraViewfinder

from qgis.PyQt.QtGui import QPixmap

from qgis.PyQt.QtCore import QSize, pyqtSignal, pyqtSlot
from qgis.PyQt.QtWidgets import (
    QMessageBox,
    QAction,
    QDialogButtonBox,
    QLabel,
    QDockWidget,
    QPushButton,
    QApplication,
QGridLayout, QWidget, QToolBar, QComboBox, QErrorMessage, QStatusBar,
QStackedLayout, QStackedWidget
)

from qgis.core import (
    Qgis,
    QgsProject,
    QgsMessageLog,
    QgsExpressionContextUtils
)

from TOMs.core.TOMsMessageLog import TOMsMessageLog
from TOMs.restrictionTypeUtilsClass import (TOMsConfigFile)

from restrictionsWithGNSS.ui.imageLabel import (imageLabel)

class TOMsCameraWidget(QWidget):
    photoTaken = pyqtSignal(str)

    def __init__(self, parent=None):
        super(TOMsCameraWidget, self).__init__(parent)
        TOMsMessageLog.logMessage("In TOMsCameraWidget:init ... ", level=Qgis.Info)

        # getting available cameras
        self.available_cameras = QCameraInfo.availableCameras()

        # if no camera found
        if not self.available_cameras:
            # exit the code
            TOMsMessageLog.logMessage("In TOMsCameraWidget:init. No cameras found. Exiting ", level=Qgis.Info)
            return

        try:
            self.cameraNr = int(QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('CameraNr'))
        except Exception as e:
            TOMsMessageLog.logMessage("In photoDetails_camera: cameraNr issue: {}".format(e), level=Qgis.Warning)
            QMessageBox.information(None, "Information", "No value for CameraNr.", QMessageBox.Ok)
            #self.cameraNr = QMessageBox.information(None, "Information", "Please set value for CameraNr.", QMessageBox.Ok)
            return
            
        self.path_absolute = self.getPhotoPath()
        if self.path_absolute is None:
            TOMsMessageLog.logMessage("In TOMsCameraWidget:init. Path not found. Exiting ", level=Qgis.Info)
            return

    def setupWidget(self, imageFile=None):
        TOMsMessageLog.logMessage("In TOMsCameraWidget:setupWidget ...", level=Qgis.Warning)
        
        # setting geometry
        self.setGeometry(100, 100,
                         800, 600)

        # setting style sheet
        self.setStyleSheet("background : lightgrey;")

        '''
        Set up a stacked widget - one to view images and the other to take photos
        '''

        mainLayout = QGridLayout()
        self.switchWidget = QStackedWidget()

        ### Camera widget
        #cameraLayout = QGridLayout()

        self.viewfinder = QCameraViewfinder()
        #cameraLayout.addWidget(self.viewfinder, 0, 0)
        self.switchWidget.addWidget(self.viewfinder)
        self.cameraIndex = self.switchWidget.indexOf(self.viewfinder)
        
        
        ### image viewer
        #imageLayout = QGridLayout()
        imageLabelWidget = QLabel()
        photoWidget = imageLabel(imageLabelWidget)

        if imageFile:
            self.photoFileName = os.path.join(self.path_absolute, imageFile)
            TOMsMessageLog.logMessage("In TOMsCameraWidget:setupWidget. photo {}".format(self.photoFileName), level=Qgis.Warning)
            thisPixmap = QPixmap(self.photoFileName)
            photoWidget.set_Pixmap(thisPixmap)
            photoWidget.pixmapUpdated.connect(functools.partial(self.displayPixmapUpdated, photoWidget))

        else:

            TOMsMessageLog.logMessage("In TOMsCameraWidget:setupWidget. No photo provided", level=Qgis.Warning)

        self.switchWidget.addWidget(photoWidget)
        self.photoIndex = self.switchWidget.indexOf(photoWidget)
        
        TOMsMessageLog.logMessage("In TOMsCameraWidget:setupWidget. cameraIndex: {}; photoIndex: {}".format(self.cameraIndex, self.photoIndex), level=Qgis.Warning)
        
        mainLayout.addWidget(self.switchWidget, 0, 0)

        cameraToolbar = self.setupCameraToolbar()

        # adding tool bar to main window
        mainLayout.addWidget(cameraToolbar, 1, 0)

        self.setLayout(mainLayout)
        
        if imageFile:
            self.switchWidget.setCurrentIndex(self.photoIndex)
            TOMsMessageLog.logMessage("In TOMsCameraWidget:setupWidget. Photo found. Displaying ...", level=Qgis.Warning)
        else:
            self.switchWidget.setCurrentIndex(self.cameraIndex)
            TOMsMessageLog.logMessage("In TOMsCameraWidget:setupWidget. No photo. Going to camera ...", level=Qgis.Warning)
        
        #if len(self.available_cameras) > 0:
        self.select_camera(self.cameraNr)

        #QMessageBox.information(None, "Information", "In setupWidget. Current stack {}.".format(self.switchWidget.currentIndex()), QMessageBox.Ok)
        
        # showing the main window
        self.show()

    def setupCameraToolbar(self):
        # https://www.geeksforgeeks.org/creating-a-camera-application-using-pyqt5/
        # creating a tool bar
        toolbar = QToolBar("Camera Tool Bar")

        #### Open camerea button
        # creating a photo action to take photo
        open_action = QAction("Open camera", self)

        # adding status tip to the photo action
        open_action.setStatusTip("This will start the camera")

        # adding tool tip
        open_action.setToolTip("Open camera")
        #open_action.setToolTipDuration(2500)

        # adding action to it
        # calling take_photo method
        open_action.triggered.connect(self.open_camera)

        # adding this to the tool bar
        toolbar.addAction(open_action)

        #### Capture button
        # creating a photo action to take photo
        click_action = QAction("Take photo", self)

        # adding status tip to the photo action
        click_action.setStatusTip("This will capture picture")

        # adding tool tip
        click_action.setToolTip("Capture picture")
        #click_action.setToolTipDuration(2500)

        # adding action to it
        # calling take_photo method
        click_action.triggered.connect(self.click_photo)

        # adding this to the tool bar
        toolbar.addAction(click_action)

        #### Close camera button
        # creating a photo action to take photo
        close_action = QAction("Close camera", self)

        # adding status tip to the photo action
        close_action.setStatusTip("This will close the camera")

        # adding tool tip
        close_action.setToolTip("Close camera")
        #open_action.setToolTipDuration(2500)

        # adding action to it
        # calling take_photo method
        close_action.triggered.connect(self.close_camera)

        # adding this to the tool bar
        toolbar.addAction(close_action)

        '''
        ### Select camera
        # creating a combo box for selecting camera
        camera_selector = QComboBox()

        # adding status tip to it
        camera_selector.setStatusTip("Choose camera to take pictures")

        # adding tool tip to it
        camera_selector.setToolTip("Select Camera")
        camera_selector.setToolTipDuration(2500)

        # adding items to the combo box
        camera_selector.addItems([camera.description()
                                  for camera in self.available_cameras])
        # adding action to the combo box
        # calling the select camera method
        camera_selector.currentIndexChanged.connect(self.select_camera)

        # adding this to tool bar
        toolbar.addWidget(camera_selector)
        '''

        # setting tool bar stylesheet
        toolbar.setStyleSheet("background : white;")

        return toolbar


    # method to select camera
    def select_camera(self, i):
        TOMsMessageLog.logMessage("In TOMsCameraWidget:select_camera ...{}".format(i), level=Qgis.Warning)
        
        # getting the selected camera
        self.camera = QCamera(self.available_cameras[i])

        # getting current camera name
        self.current_camera_name = self.available_cameras[i].description()
        
        # setting view finder to the camera
        self.camera.setViewfinder(self.viewfinder)

        # setting capture mode to the camera
        self.camera.setCaptureMode(QCamera.CaptureStillImage)

        # if any error occur show the alert
        self.camera.error.connect(lambda: self.alert(self.camera.errorString()))

        # start the camera
        #self.open_camera()

        # creating a QCameraImageCapture object
        self.capture = QCameraImageCapture(self.camera)
        TOMsMessageLog.logMessage(
            "In TOMsCameraWidget: capacities: {}".format(self.capture.imageCodecDescription), level=Qgis.Warning)

        # showing alert if error occur
        self.capture.error.connect(lambda error_msg, error,
                                          msg: self.alert(msg))

        # when image captured showing message
        self.capture.imageCaptured.connect(lambda d, i: QMessageBox.information(None, "Information", "Photo captured.", QMessageBox.Ok))


    # open current camera
    def open_camera(self):
        TOMsMessageLog.logMessage("In TOMsCameraWidget:open_camera ...", level=Qgis.Warning)
        # change to camera widget
        self.switchWidget.setCurrentIndex(self.cameraIndex)
        # start the camera
        self.camera.start()
        
        self.show()

    # open current camera
    def close_camera(self):
        TOMsMessageLog.logMessage("In TOMsCameraWidget:close_camera ...", level=Qgis.Warning)
        # start the camera
        self.camera.stop()
        # change back to image widget
        self.switchWidget.setCurrentIndex(self.photoIndex)
        
        self.show()

    # method to take photo
    def click_photo(self):
        TOMsMessageLog.logMessage("In TOMsCameraWidget:click_photo ...", level=Qgis.Warning)
        # time stamp

        fileName = 'Photo_{}.jpg'.format(datetime.datetime.now().strftime('%Y%m%d_%H%M%S%f'))
        newPhotoFileName = os.path.join(self.path_absolute, fileName)

        TOMsMessageLog.logMessage("Saving photo: file: " + newPhotoFileName, level=Qgis.Info)

        imageSettings = self.capture.encodingSettings()
        imageSettings.setCodec("image/png")

        # get image resolution
        frameWidth, frameHeight = self.getCameraResolution()
        if frameWidth is None:
            frameWidth = 640
            frameHeight = 480

        TOMsMessageLog.logMessage(
            "In TOMsCameraWidget: resolution: {}*{} ".format(frameWidth, frameHeight), level=Qgis.Warning)

        imageSettings.setResolution(QSize(100, 100))
        #self.capture.setEncodingSettings(imageSettings)

        # capture the image and save it on the save path
        self.capture.capture(newPhotoFileName)

        #reply = QMessageBox.information(None, "Information", "Photo captured.", QMessageBox.Ok)
        self.photoTaken.emit(newPhotoFileName)

    # method for alerts
    def alert(self, msg):
        # error message
        error = QErrorMessage(self)
        TOMsMessageLog.logMessage("TOMsCameraWidget:alert: {}".format(msg), level=Qgis.Warning)
        
        # setting text to the error message
        error.showMessage(msg)

    ## TODO: remove and include with Utils
    def getPhotoPath(self):
        """ check that photo path exists """
        TOMsMessageLog.logMessage("In getPhotoPath", level=Qgis.Info)

        photoPath = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('PhotoPath')

        projectFolder = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('project_home')

        path_absolute = os.path.join(projectFolder, photoPath)

        if path_absolute == None:
            reply = QMessageBox.information(None, "Information", "Please set value for PhotoPath.", QMessageBox.Ok)
            return None

        # Check path exists ...
        if os.path.isdir(path_absolute) == False:
            reply = QMessageBox.information(None, "Information", "PhotoPath folder " + str(
                path_absolute) + " does not exist. Please check value.", QMessageBox.Ok)
            return None

        TOMsMessageLog.logMessage("In getPhotoPath. Returning {}".format(path_absolute), level=Qgis.Info)
        return path_absolute

    def getCameraResolution(self):
        TOMsConfigFileObject = TOMsConfigFile()
        TOMsConfigFileObject.initialiseTOMsConfigFile()
        frameWidth = TOMsConfigFileObject.getTOMsConfigElement('Camera', 'Width')
        frameHeight = TOMsConfigFileObject.getTOMsConfigElement('Camera', 'Height')
        if frameWidth is None or frameHeight is None:
            res = QMessageBox.information(None, "Information", "Please set value for camera resolution.", QMessageBox.Ok)
            return 0, 0
        return int(frameWidth), int(frameHeight)

    @pyqtSlot(QPixmap)
    def displayPixmapUpdated(self, FIELD, pixmap):
        TOMsMessageLog.logMessage("In utils::displayPixmapUpdated ... ", level=Qgis.Info)
        FIELD.setPixmap(pixmap)
        FIELD.setScaledContents(True)
        QApplication.processEvents()  # processes the event queue - https://stackoverflow.com/questions/43094589/opencv-imshow-prevents-qt-python-crashing

    def displayImage(self, FIELD, pixmap):
        TOMsMessageLog.logMessage("In utils::displayImage ... ", level=Qgis.Info)

        try:
            FIELD.update_image(pixmap.scaled(FIELD.width(), FIELD.height(), QtCore.Qt.KeepAspectRatio,
                                                transformMode=QtCore.Qt.SmoothTransformation))
        except Exception as e:
            TOMsMessageLog.logMessage('displayImage: error {}'.format(e),
                                      level=Qgis.Warning)

        QApplication.processEvents()  # processes the event queue - https://stackoverflow.com/questions/43094589/opencv-imshow-prevents-qt-python-crashing


