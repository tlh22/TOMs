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

from .InstantPrintTool_v3 import InstantPrintTool
from ..restrictionTypeUtilsClass import RestrictionTypeUtilsMixin, setupTableNames

class TOMsInstantPrintTool(RestrictionTypeUtilsMixin, InstantPrintTool):

    def __init__(self, iface, proposalsManager):

        self.iface = iface
        InstantPrintTool.__init__(self, iface)
        self.proposalsManager = proposalsManager

        self.proposalsManager.TOMsActivated.connect(self.setupTables)

    def setupTables(self):
        self.tableNames = setupTableNames(self.iface)
        self.tableNames.getLayers()

        """def getTilesIDsInProposal(self, currProposalID):
        # retrieve all the tiles that are affected by the currentProposal

        # get all the tiles that sit within the bounding box

        # for each restriction in the proposal, check to see if it intersects a tile(s). If so, add the tile(s) to the list

        #currProposalID = self.proposalsManager.currentProposal()
        #proposalBox = self.getProposalBoundingBox(currProposalID)

        if QgsMapLayerRegistry.instance().mapLayersByName("MapGrid"):
            self.MapGrid = \
                QgsMapLayerRegistry.instance().mapLayersByName("MapGrid")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                    ("Table MapGrid is not present"))

        tileIndex = QgsSpatialIndex()  # Spatial index
        for feat in self.MapGrid.getFeatures():
            tileIndex.insertFeature(feat)

        #tilesWithinBoundingBox = self.MapGrid

        #tileFeatureIDList = []
        tileFeatureList = []

        if currProposalID > 0:  # need to consider a proposal

            if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals"):
                self.RestrictionsInProposals = \
                QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                        ("Table RestrictionsInProposals is not present"))
                #raise LayerNotPresent

            if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers"):
                self.RestrictionLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionLayers is not present"))
                return

            # loop through all the layers that might have restrictions

            listRestrictionLayers = self.RestrictionLayers.getFeatures()
            #listRestrictionLayers2 = self.tableNames.RESTRICTIONLAYERS.getFeatures()

            firstRestriction = True

            for currLayerDetails in listRestrictionLayers:

                # get the layer from the name

                currLayerID = currLayerDetails["id"]
                currLayerName = currLayerDetails["RestrictionLayerName"]
                QgsMessageLog.logMessage(
                    "In getProposalBoundingBox. Considering layer: " + currLayerDetails["RestrictionLayerName"], tag="TOMs panel")

                if QgsMapLayerRegistry.instance().mapLayersByName(currLayerName):
                    currRestrictionLayer = QgsMapLayerRegistry.instance().mapLayersByName(currLayerName)[0]
                else:
                    QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                            ("Table " + currLayerName + " is not present"))
                    return

                #restrictionListForLayer = []
                restrictionsString = ''
                #firstRestriction = True

                # get list of restrictions to open within proposal
                # TODO: Include selection of only proposal and for the current restriction type

                listRestrictionsInProposals = self.RestrictionsInProposals.getFeatures()

                for row in listRestrictionsInProposals:

                    proposalID = row["ProposalID"]
                    restrictionTableID = row["RestrictionTableID"]

                    # check to see if the current row is for the current proposal and for the correct proposedAction

                    if proposalID == currProposalID:
                        if restrictionTableID == currLayerID:

                            currRestrictionID = str(row["RestrictionID"])

                            currRestriction = self.getRestrictionBasedOnRestrictionID(currRestrictionID,
                                                                                      currRestrictionLayer)

                            # TODO: Deal with restrictions that have been deleted, i.e., are not in the current view

                            if currRestriction:
                                tileIDsList = tileIndex.intersects(currRestriction.geometry().boundingBox())
                                self.MapGrid.selectByIds(tileIDsList)
                                currRestrictionTileFeaturesList = self.MapGrid.selectedFeatures()
                                self.MapGrid.removeSelection()

                                for tile in currRestrictionTileFeaturesList:
                                    # check if exists in tileList or not
                                    if tile not in tileFeatureList:
                                        tileFeatureList.append(tile)


                pass

        else:

            # TODO: get all current restrictions
            if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers"):
                self.RestrictionLayers = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionLayers")[0]
            else:
                QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionLayers is not present"))
                return

            # loop through all the layers that might have restrictions

            listRestrictionLayers = self.RestrictionLayers.getFeatures()
            #listRestrictionLayers2 = self.tableNames.RESTRICTIONLAYERS.getFeatures()

            firstRestriction = True

            for currLayerDetails in listRestrictionLayers:

                # get the layer from the name

                currLayerID = currLayerDetails["id"]
                currLayerName = currLayerDetails["RestrictionLayerName"]
                QgsMessageLog.logMessage(
                    "In getProposalBoundingBox. Considering layer: " + currLayerDetails["RestrictionLayerName"], tag="TOMs panel")

                if QgsMapLayerRegistry.instance().mapLayersByName(currLayerName):
                    currRestrictionLayer = QgsMapLayerRegistry.instance().mapLayersByName(currLayerName)[0]
                else:
                    QMessageBox.information(self.iface.mainWindow(), "ERROR",
                                            ("Table " + currLayerName + " is not present"))
                    return

                #restrictionListForLayer = []
                restrictionsString = ''
                #firstRestriction = True

                # get list of restrictions to open within proposal
                # TODO: Include selection of only proposal and for the current restriction type

                listRestrictions = currRestrictionLayer.getFeatures()

                for currRestriction in listRestrictions:

                    tileIDsList = tileIndex.intersects(currRestriction.geometry().boundingBox())
                    self.MapGrid.selectByIds(tileIDsList)
                    currRestrictionTileFeaturesList = self.MapGrid.selectedFeatures()
                    self.MapGrid.removeSelection()

                    for tile in currRestrictionTileFeaturesList:
                        # check if exists in tileList or not
                        if tile not in tileFeatureList:
                            tileFeatureList.append(tile)



        return tileFeatureList"""
