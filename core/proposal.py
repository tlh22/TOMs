#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock 2017

from qgis.PyQt.QtCore import (
    QObject,
    QDate,
    pyqtSignal
)

from qgis.PyQt.QtWidgets import (
    QMessageBox,
    QAction
)

from qgis.core import (
    QgsExpressionContextUtils,
    # QgsMapLayerRegistry,
    QgsMessageLog, QgsFeature, QgsGeometry,
    QgsFeatureRequest,
    QgsProject
)

from ..restrictionTypeUtilsClass import setupTableNames

from ..constants import (
    ProposalStatus,
    RestrictionAction
)

class TOMsProposal(QObject):
    """
    creates a Proposal object

    """

    # TH: orig code has reference to iface. Need to include ***

    dateChanged = pyqtSignal()
    """Signal will be emitted, when the current date is changed"""
    proposalChanged = pyqtSignal()
    """Signal will be emitted when the current proposal is changed"""
    proposal = newProposalCreated = pyqtSignal(int)
    """Signal will be emitted when the current proposal is changed"""

    TOMsToolChanged = pyqtSignal()
    """ signal will be emitted when TOMs tool is changed """

    TOMsActivated = pyqtSignal()
    """ signal will be emitted when TOMs tools are activated"""
    #TOMsStartupFailure = pyqtSignal()
    """ signal will be emitted with there is a problem with opening TOMs - typically a layer missing """
    TOMsSplitRestrictionSaved = pyqtSignal()

    def __init__(self, proposalsLayer, proposal=None):
        QObject.__init__(self)
        #self.constants = TOMsConstants()

        self.proposalsLayer = proposalsLayer
        self.currProposal = None

    def set(self, proposalID):
        pass

    def get(self, proposalID):
        pass

class TOMsProposalsObjectManager(QObject):
    """
    creates a Proposal manager object to provide linkage to other classes - restrictions, ...

    """

class originalFeature(object):
    def __init__(self, feature=None):
        self.savedFeature = None

    def setFeature(self, feature):
        self.savedFeature = QgsFeature(feature)
        #self.printFeature()

    def getFeature(self):
        #self.printFeature()
        return self.savedFeature

    def getGeometryID(self):
        return self.savedFeature.attribute("GeometryID")

    def printFeature(self):
        QgsMessageLog.logMessage("In TOMsNodeTool:originalFeature - attributes (fid:" + str(self.savedFeature.id()) + "): " + str(self.savedFeature.attributes()),
                                 tag="TOMs panel")
        QgsMessageLog.logMessage("In TOMsNodeTool:originalFeature - attributes: " + str(self.savedFeature.geometry().asWkt()),
                                 tag="TOMs panel")