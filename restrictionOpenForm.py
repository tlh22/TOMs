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
from PyQt4.QtCore import *
from PyQt4.QtGui import *
#from manage_restriction_details import manageRestrictionDetails

from qgis.core import (
    QgsExpressionContextUtils,
    QgsMapLayerRegistry,
    QgsMessageLog, QgsFeature, QgsGeometry
)

#from qgis.core import *
from qgis.gui import QgsAttributeForm

from TOMs.restrictionTypeUtils import RestrictionTypeUtils

import functools

#nameField = None
#myDialog = None

# https://nathanw.net/2011/09/05/qgis-tips-custom-feature-forms-with-python-logic/

def onAttributeChanged(feature, layer, fieldName, value):
    #QgsMessageLog.logMessage("In restrictionFormOpen:onAttributeChanged - layer: " + str(layer.name()) + " (" + str(feature.attribute("GeometryID")) + "): " + fieldName + ": " + str(value), tag="TOMs panel")

    idxField = feature.fieldNameIndex(fieldName)

    # need to operate on the layer and not the dialog
    res = layer.changeAttributeValue(feature.id(), idxField, value)

    if not res:
        QgsMessageLog.logMessage("In restrictionFormOpen:onAttributeChanged: ERROR setting attribute value: " + fieldName + ": " + str(feature[idxField]),
                                 tag="TOMs panel")


def restrictionFormOpen(dialog, currRestLayer, currRestrictionFeature):
    QgsMessageLog.logMessage("In restrictionFormOpen", tag="TOMs panel")

    #restrictionsDialog = dialog

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
    button_box.accepted.connect(functools.partial(onSaveDetails, currRestrictionFeature, currRestLayer, dialog))
    button_box.rejected.connect(dialog.reject)

    # To allow saving of the original feature, this function follows changes to attributes within the table and records them to the current feature
    dialog.attributeChanged.connect(functools.partial(onAttributeChanged, currRestrictionFeature, currRestLayer))

    pass


def onSaveDetails(currRestriction, currRestrictionLayer, dialog):
    QgsMessageLog.logMessage("In restrictionFormOpen:onSaveDetails", tag="TOMs panel")
    dialog.save()
    RestrictionTypeUtils.onSaveRestrictionDetails (currRestriction, currRestrictionLayer, dialog)