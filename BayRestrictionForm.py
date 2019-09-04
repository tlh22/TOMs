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
from PyQt5.QtGui import (
    QMessageBox,
    QPixmap,
    QDialog,
    QDialogButtonBox,
    QLabel
)

from qgis.core import (
    QgsMessageLog,
    QgsExpressionContextUtils
)

import os

from PyQt5 import QtCore, QtGui
from qgis.core import *
from qgis.gui import *

from restrictionBayDetails_dialog import restrictionBayDetailsDialog

class RestrictionFormUtils(QtGui.QDialog):

    def __init__(self, iface, currRestrictionLayer, currRestriction):
        QtGui.QDialog.__init__(self)
        # Set up the user interface from Designer.
        self.ui = restrictionBayDetailsDialog()
        self.currRestrictionLayer = currRestrictionLayer
        self.currRestriction = currRestriction
        self.iface = iface

        self.ui.setupUi(self)

        # make new style signal/slot connection
        button_box = self.ui.findChild(QDialogButtonBox, "button_box")

        # Disconnect the signal that QGIS has wired up for the dialog to the button box.
        # button_box.accepted.disconnect(restrictionsDialog.accept)
        # Wire up our own signals.
        """button_box.accepted.connect(
            functools.partial(RestrictionTypeUtils.onSaveRestrictionDetails, currRestrictionFeature,
                              currRestrictionLayer, dialog))"""

        # To allow saving of the original feature, this function follows changes to attributes within the table and records them to the current feature
        #self.ui.attributeChanged.connect(functools.partial(onAttributeChanged, currRestrictionFeature))

        self.photoDetails()

    """def onAttributeChanged(self, feature, fieldName, value):
        #QgsMessageLog.logMessage("In restrictionFormOpen:onAttributeChanged - layer: " + str(layer.name()) + " (" + str(feature.attribute("GeometryID")) + "): " + fieldName + ": " + str(value), tag="TOMs panel")

        feature.setAttribute(fieldName,value)"""

    def photoDetails(self):

        # Function to deal with photo fields

        QgsMessageLog.logMessage("In photoDetails", tag="TOMs panel")

        FIELD1 = self.ui.findChild(QLabel, "Photo_Widget_01")
        FIELD2 = self.ui.findChild(QLabel, "Photo_Widget_02")
        FIELD3 = self.ui.findChild(QLabel, "Photo_Widget_03")

        path_absolute = QgsExpressionContextUtils.projectScope().variable('PhotoPath')
        if path_absolute == None:
            reply = QMessageBox.information(None, "Information", "Please set value for PhotoPath.", QMessageBox.Ok)
            return

        layerName = self.currRestrictionLayer.name()

        # Generate the full path to the file

        fileName1 = layerName + "_Photos_01"
        fileName2 = layerName + "_Photos_02"
        fileName3 = layerName + "_Photos_03"

        idx1 = self.currRestrictionLayer.fieldNameIndex(fileName1)
        idx2 = self.currRestrictionLayer.fieldNameIndex(fileName2)
        idx3 = self.currRestrictionLayer.fieldNameIndex(fileName3)

        QgsMessageLog.logMessage("In photoDetails. idx1: " + str(idx1) + "; " + str(idx2) + "; " + str(idx3), tag="TOMs panel")
        #if currRestrictionFeature[idx1]:
        #QgsMessageLog.logMessage("In photoDetails. photo1: " + str(currRestrictionFeature[idx1]), tag="TOMs panel")
        #QgsMessageLog.logMessage("In photoDetails. photo2: " + str(currRestrictionFeature.attribute(idx2)), tag="TOMs panel")
        #QgsMessageLog.logMessage("In photoDetails. photo3: " + str(currRestrictionFeature.attribute(idx3)), tag="TOMs panel")

        if FIELD1:
            QgsMessageLog.logMessage("In photoDetails. FIELD 1 exisits",
                                     tag="TOMs panel")
            if self.currRestriction[idx1]:
                newPhotoFileName1 = os.path.join(path_absolute, self.currRestriction[idx1])
            else:
                newPhotoFileName1 = None

            QgsMessageLog.logMessage("In photoDetails. A. Photo1: " + str(newPhotoFileName1), tag="TOMs panel")
            pixmap1 = QPixmap(newPhotoFileName1)
            if pixmap1.isNull():
                pass
                # FIELD1.setText('Picture could not be opened ({path})'.format(path=newPhotoFileName1))
            else:
                FIELD1.setPixmap(pixmap1)
                FIELD1.setScaledContents(True)
                QgsMessageLog.logMessage("In photoDetails. Photo1: " + str(newPhotoFileName1), tag="TOMs panel")

        if FIELD2:
            QgsMessageLog.logMessage("In photoDetails. FIELD 2 exisits",
                                     tag="TOMs panel")
            if self.currRestriction[idx2]:
                newPhotoFileName2 = os.path.join(path_absolute, self.currRestriction[idx2])
            else:
                newPhotoFileName2 = None

            #newPhotoFileName2 = os.path.join(path_absolute, str(currRestrictionFeature[idx2]))
            #newPhotoFileName2 = os.path.join(path_absolute, str(currRestrictionFeature.attribute(fileName2)))
            QgsMessageLog.logMessage("In photoDetails. A. Photo2: " + str(newPhotoFileName2), tag="TOMs panel")
            pixmap2 = QPixmap(newPhotoFileName2)
            if pixmap2.isNull():
                pass
                # FIELD1.setText('Picture could not be opened ({path})'.format(path=newPhotoFileName1))
            else:
                FIELD1.setPixmap(pixmap2)
                FIELD1.setScaledContents(True)
                QgsMessageLog.logMessage("In photoDetails. Photo2: " + str(newPhotoFileName2), tag="TOMs panel")

        if FIELD3:
            QgsMessageLog.logMessage("In photoDetails. FIELD 3 exisits",
                                     tag="TOMs panel")
            if self.currRestriction[idx3]:
                newPhotoFileName3 = os.path.join(path_absolute, self.currRestriction[idx3])
            else:
                newPhotoFileName3 = None

            #newPhotoFileName3 = os.path.join(path_absolute, str(currRestrictionFeature[idx3]))
            #newPhotoFileName3 = os.path.join(path_absolute,
            #                                 str(currRestrictionFeature.attribute(fileName3)))
            #newPhotoFileName3 = os.path.join(path_absolute, str(layerName + "_Photos_03"))
            pixmap3 = QPixmap(newPhotoFileName3)
            if pixmap3.isNull():
                pass
                # FIELD1.setText('Picture could not be opened ({path})'.format(path=newPhotoFileName1))
            else:
                FIELD1.setPixmap(pixmap3)
                FIELD1.setScaledContents(True)
                QgsMessageLog.logMessage("In photoDetails. Photo3: " + str(newPhotoFileName3), tag="TOMs panel")

        pass
