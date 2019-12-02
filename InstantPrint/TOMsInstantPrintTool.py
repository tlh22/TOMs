# -*- coding: utf-8 -*-
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    copyright            : (C) 2014-2015 by Sandro Mani / Sourcepole AG
#    email                : smani@sourcepole.ch

# T Hancock (180607) generate a subclass of Sandro's class


from qgis.PyQt.QtCore import *
from qgis.PyQt.QtGui import *
from qgis.core import *
from qgis.gui import *

from .InstantPrintTool import InstantPrintTool
from ..restrictionTypeUtilsClass import RestrictionTypeUtilsMixin, TOMSLayers

from ..constants import (
    ProposalStatus,
    RestrictionAction
)

class TOMsInstantPrintTool(RestrictionTypeUtilsMixin, InstantPrintTool):

    def __init__(self, iface, proposalsManager):

        self.iface = iface
        InstantPrintTool.__init__(self, iface)
        self.proposalsManager = proposalsManager
        self.tableNames = self.proposalsManager.tableNames

    def createAcceptedProposalcb(self):
        QgsMessageLog.logMessage("In createAcceptedProposalcb", tag="TOMs panel")
        # set up a "NULL" field for "No proposals to be shown"

        self.acceptedProposalDialog.cb_AcceptedProposalsList.clear()

        for (currProposalID, currProposalTitle, currProposalStatusID, currProposalOpenDate, currProposal) in sorted(
                self.proposalsManager.getProposalsListWithStatus(ProposalStatus.ACCEPTED), key=lambda f: f[1]):
            QgsMessageLog.logMessage(
                "In createProposalcb: queryString: " + str(currProposalID) + ":" + currProposalTitle, tag="TOMs panel")
            self.acceptedProposalDialog.cb_AcceptedProposalsList.addItem(currProposalTitle, currProposalID)

        """"# for proposal in proposalsList:
        queryString = "\"ProposalStatusID\" = " + str(ProposalStatus.ACCEPTED)

        QgsMessageLog.logMessage("In getTileRevisionNrAtDate: queryString: " + str(queryString), tag="TOMs panel")

        expr = QgsExpression(queryString)

        proposals = self.Proposals.getFeatures(QgsFeatureRequest(expr))


        for proposal in sorted(proposals, key=lambda f: f[4]):

            # QgsMessageLog.logMessage("In createProposalcb. ID: " + str(proposal.attribute("ProposalID")) + " currProposalStatus: " + str(currProposalStatusID),
            #                          tag="TOMs panel")
            currProposalID = proposal.attribute("ProposalID")
            currProposalTitle = proposal.attribute("ProposalTitle")

            self.acceptedProposalDialog.cb_AcceptedProposalsList.addItem(currProposalTitle, currProposalID)

        pass"""