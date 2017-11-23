# -*- coding: utf-8 -*-
"""
/***************************************************************************
 ProposalPanel
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
import uuid
from qgis.core import *
from qgis.gui import *

from TOMs.mapTools import RestrictionTypeUtils
from TOMs.proposalTypeUtils import ProposalTypeUtils

import functools

nameField = None
myDialog = None

#proposalCreated = pyqtSignal()
"""Signal will be emitted when a proposal is created"""


# https://nathanw.net/2011/09/05/qgis-tips-custom-feature-forms-with-python-logic/

def onAttributeChanged(feature, fieldName, value):
    QgsMessageLog.logMessage("In proposalFormOpen:onAttributeChanged - (" + str(feature.attribute("ProposalTitle")) + "): " + fieldName + ": " + str(value), tag="TOMs panel")
    feature.setAttribute(fieldName,value)

def proposalFormOpen(proposalsDialog, proposalsLayer, currProposal):
    QgsMessageLog.logMessage("In proposalFormOpen", tag="TOMs panel")
    #global restrictionsDialog
    #proposalsDialog = dialog
    #global currRestriction
    #global currRestrictionLayer
    #global currProposalID
    #global origRestriction

    # This stops changes to the form being saved (unless explicitly enacted)
    #proposalsDialog.disconnectButtonBox()

    #currRestrictionLayer = currRestLayer
    QgsMessageLog.logMessage("In proposalFormOpen. proposalsLayer: " + str(proposalsLayer.name()), tag="TOMs panel")

    # try and make a copy of the original feature
    #origRestriction = QgsFeature()
    #origRestriction = getOriginalRestriction(currRestriction, currRestrictionLayer)
    # Get the current proposal from the session variables


    #currProposalID = int(QgsExpressionContextUtils.projectScope().variable('CurrentProposal'))

    #nameField = dialog.findChild(QLineEdit, "Name")
    button_box = proposalsDialog.findChild(QDialogButtonBox, "button_box")

    # Disconnect the signal that QGIS has wired up for the dialog to the button box.
    # button_box.accepted.disconnect(restrictionsDialog.accept)

    # To allow saving of the original feature, this fucntion follows changes to attributes within the table and records them to the current feature
    #proposalsDialog.attributeChanged.connect(functools.partial(onAttributeChanged, currRestrictionFeature))

    # Wire up our own signals.
    button_box.accepted.connect(functools.partial(ProposalTypeUtils.onSaveProposalFormDetails, currProposal, proposalsLayer, proposalsDialog))
    button_box.rejected.connect(proposalsDialog.reject)

    # To allow saving of the original feature, this function follows changes to attributes within the table and records them to the current feature
    proposalsDialog.attributeChanged.connect(functools.partial(onAttributeChanged, currProposal))

    pass

