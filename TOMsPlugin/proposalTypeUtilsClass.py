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

from qgis.core import Qgis, QgsFeatureRequest

from .core.tomsMessageLog import TOMsMessageLog


class ProposalTypeUtilsMixin:
    def getRestrictionLayersList(self):

        self.restrictionLayers = self.tableNames.getLayer("RestrictionLayers")

        layerTypeList = []
        for layerType in self.restrictionLayers.getFeatures():

            layerID = layerType["Code"]
            layerName = layerType["RestrictionLayerName"]

            layerTypeList.append([layerID, layerName])

        # Add the labels layers...
        layerTypeList.append([2, "Bays.label_pos"])
        layerTypeList.append([3, "Lines.label_pos"])
        layerTypeList.append([3, "Lines.label_loading_pos"])
        # layerTypeList.append([5, 'Signs.label_pos'])
        layerTypeList.append([4, "RestrictionPolygons.label_pos"])
        layerTypeList.append([6, "CPZs.label_pos"])
        layerTypeList.append([7, "ParkingTariffAreas.label_pos"])

        layerTypeList.append([2, "Bays.label_ldr"])
        layerTypeList.append([3, "Lines.label_ldr"])
        layerTypeList.append([3, "Lines.label_loading_ldr"])
        # layerTypeList.append([5, 'Signs.label_ldr'])
        layerTypeList.append([4, "RestrictionPolygons.label_ldr"])
        layerTypeList.append([6, "CPZs.label_ldr"])
        layerTypeList.append([7, "ParkingTariffAreas.label_ldr"])

        return layerTypeList

    def getRestrictionLayerFromID(self, layerID):
        # return the layer given the row in "RestrictionLayers"
        # TOMsMessageLog.logMessage("In getRestrictionsLayerFromID.", level=Qgis.Info)

        self.restrictionLayers = self.tableNames.getLayer("RestrictionLayers")

        request = QgsFeatureRequest().setFilterExpression(f'"Code"={layerID}')

        for layer in self.restrictionLayers.getFeatures(request):
            return self.tableNames.getLayer(layer.attribute("RestrictionLayerName"))

        return None

    def getRestrictionLayerIDfromLayer(self, currLayer):
        TOMsMessageLog.logMessage("In getRestrictionLayerTableID.", level=Qgis.Info)
        # find the ID for the layer within the table "

        self.restrictionLayers = self.tableNames.getLayer("RestrictionLayers")

        request = QgsFeatureRequest().setFilterExpression(
            f'"RestrictionLayerName"={currLayer.name()}'
        )

        for layer in self.restrictionLayers.getFeatures(request):
            return self.tableNames.getLayer(layer.attribute("RestrictionLayerName"))

        return None
