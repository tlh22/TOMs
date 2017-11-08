# -*- coding: utf-8 -*-
"""
/***************************************************************************
 RestrictionFromOpen
                                 A QGIS plugin
 Proposal panel
                              -------------------
        begin                : 2017-09-02
        git sha              : $Format:%H$
        copyright            : (C) 2017 by MHTC
        email                : th@mhtc.co.uk
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""
from PyQt4.QtGui import (
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

#from manage_restriction_details import manageRestrictionDetails

#from qgis.core import *
from qgis.gui import QgsAttributeForm

from TOMs.restrictionTypeUtils import RestrictionTypeUtils

import functools

#nameField = None
#myDialog = None

# https://nathanw.net/2011/09/05/qgis-tips-custom-feature-forms-with-python-logic/

#def onAttributeChanged(feature, layer, fieldName, value):
def onAttributeChanged(feature, fieldName, value):
    #QgsMessageLog.logMessage("In restrictionFormOpen:onAttributeChanged - layer: " + str(layer.name()) + " (" + str(feature.attribute("GeometryID")) + "): " + fieldName + ": " + str(value), tag="TOMs panel")

    feature.setAttribute(fieldName,value)

    """    
    idxField = feature.fieldNameIndex(fieldName)

    # need to operate on the layer and not the dialog
    res = layer.changeAttributeValue(feature.id(), idxField, value)

    if not res:
        QgsMessageLog.logMessage("In restrictionFormOpen:onAttributeChanged: ERROR setting attribute value: " + fieldName + ": " + str(feature[idxField]),
                                 tag="TOMs panel") 
    """


def restrictionFormOpen(dialog, currRestLayer, currRestrictionFeature):
    QgsMessageLog.logMessage("In restrictionFormOpen", tag="TOMs panel")

    #restrictionsDialog = dialog

    photoDetails(dialog, currRestLayer, currRestrictionFeature)

    # This stops changes to the form being saved (unless explicitly enacted)
    dialog.disconnectButtonBox()

    #dialog.setMode(QgsAttributeForm.SingleEditMode)

    #currRestrictionLayer = currRestLayer
    QgsMessageLog.logMessage("In restrictionFormOpen. currRestrictionLayer: " + str(currRestLayer.name()), tag="TOMs panel")

    #currRestriction = currRestrictionFeature

    # try and make a copy of the original feature
    #origRestriction = QgsFeature()
    #origRestriction = getOriginalRestriction(currRestriction, currRestrictionLayer)
    # Get the current proposal from the session variables
    #currProposalID = int(QgsExpressionContextUtils.projectScope().variable('CurrentProposal'))

    #nameField = dialog.findChild(QLineEdit, "Name")
    button_box = dialog.findChild(QDialogButtonBox, "button_box")

    # Disconnect the signal that QGIS has wired up for the dialog to the button box.
    # button_box.accepted.disconnect(restrictionsDialog.accept)
    # Wire up our own signals.
    button_box.accepted.connect(functools.partial(RestrictionTypeUtils.onSaveRestrictionDetails, currRestrictionFeature, currRestLayer, dialog))
    button_box.rejected.connect(dialog.reject)

    # To allow saving of the original feature, this function follows changes to attributes within the table and records them to the current feature
    dialog.attributeChanged.connect(functools.partial(onAttributeChanged, currRestrictionFeature))
    #dialog.attributeChanged.connect(functools.partial(onAttributeChanged, currRestrictionFeature, currRestLayer))

    pass

def photoDetails(dialog, currRestLayer, currRestrictionFeature):

    # Function to deal with photo fields

    QgsMessageLog.logMessage("In photoDetails", tag="TOMs panel")

    FIELD1 = dialog.findChild(QLabel, "Photo_Widget_01")
    FIELD2 = dialog.findChild(QLabel, "Photo_Widget_02")
    FIELD3 = dialog.findChild(QLabel, "Photo_Widget_03")

    path_absolute = QgsExpressionContextUtils.projectScope().variable('PhotoPath')
    if path_absolute == None:
        reply = QMessageBox.information(None, "Information", "Please set value for PhotoPath.", QMessageBox.Ok)
        return

    layerName = currRestLayer.name()

    if FIELD1:
        newPhotoFileName1 = os.path.join(path_absolute, str(currRestrictionFeature.attribute(layerName + "_Photos_01")))
        pixmap1 = QPixmap(newPhotoFileName1)
        if pixmap1.isNull():
            pass
            # FIELD1.setText('Picture could not be opened ({path})'.format(path=newPhotoFileName1))
        else:
            FIELD1.setPixmap(pixmap1)
            FIELD1.setScaledContents(True)
            QgsMessageLog.logMessage("In photoDetails. Photo1: " + str(newPhotoFileName1), tag="TOMs panel")

    if FIELD2:
        newPhotoFileName2 = os.path.join(path_absolute, str(currRestrictionFeature.attribute(layerName + "_Photos_02")))
        pixmap2 = QPixmap(newPhotoFileName2)
        if pixmap2.isNull():
            pass
            # FIELD1.setText('Picture could not be opened ({path})'.format(path=newPhotoFileName1))
        else:
            FIELD1.setPixmap(pixmap2)
            FIELD1.setScaledContents(True)
            QgsMessageLog.logMessage("In photoDetails. Photo2: " + str(newPhotoFileName2), tag="TOMs panel")

    if FIELD3:
        newPhotoFileName3 = os.path.join(path_absolute,
                                         str(currRestrictionFeature.attribute(layerName + "_Photos_03")))
        pixmap3 = QPixmap(newPhotoFileName3)
        if pixmap3.isNull():
            pass
            # FIELD1.setText('Picture could not be opened ({path})'.format(path=newPhotoFileName1))
        else:
            FIELD1.setPixmap(pixmap3)
            FIELD1.setScaledContents(True)
            QgsMessageLog.logMessage("In photoDetails. Photo3: " + str(newPhotoFileName3), tag="TOMs panel")

    pass
