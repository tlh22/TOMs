#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock 2017

"""
Series of functions to deal with restrictionsInProposals. Defined as static functions to allow them to be used in forms ... (not sure if this is the best way ...)

"""
from qgis.PyQt.QtWidgets import (
    QMessageBox
)

from qgis.PyQt.QtCore import (
    QTimer
)

from qgis.core import (
    QgsExpressionContextUtils,
    QgsMessageLog,
    QgsFeature,
    QgsGeometry,
    QgsTransaction,
    QgsProject, QgsFeatureRequest
)

from qgis.gui import *
import functools

#from TOMsTableNames import TOMsTableNames

#from restrictionTypeUtils import RestrictionTypeUtils

#from core.proposalsManager import *
import time

import uuid

from . import toms_config

class ProposalTypeUtilsMixin():

    def __init__(self):
        #self.iface = iface
        pass

    def getRestrictionLayersList(self):
        return toms_config.RESTRICTION_LAYERS

    def getRestrictionLayerFromID(self, layerID):
        # return the layer given the row in "RestrictionLayers"
        # QgsMessageLog.logMessage("In getRestrictionsLayerFromID.", tag="TOMs panel")

        self.RestrictionLayers = self.tableNames.setLayer("RestrictionLayers")

        request = QgsFeatureRequest().setFilterExpression('"id"={layerID}'.format(layerID=layerID))

        for layer in self.RestrictionLayers.getFeatures(request):
            return self.tableNames.setLayer(layer.attribute("RestrictionLayerName"))

        return None

    def getRestrictionLayerIDfromLayer(self, currLayer):
        QgsMessageLog.logMessage("In getRestrictionLayerTableID.", tag="TOMs panel")
        # find the ID for the layer within the table "

        self.RestrictionLayers = self.tableNames.setLayer("RestrictionLayers")

        request = QgsFeatureRequest().setFilterExpression('"RestrictionLayerName"={layerName}'.format(layerName=currLayer.name()))

        for layer in self.RestrictionLayers.getFeatures(request):
            return self.tableNames.setLayer(layer.attribute("RestrictionLayerName"))

        return None
