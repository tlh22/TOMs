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

from qgis.core import Qgis, QgsVectorLayer
from qgis.PyQt.QtWidgets import QAction

from ..core.tomsMessageLog import TOMsMessageLog
from .nodetool import NodeTool


def classFactory(iface):
    return CadNodeToolPlugin(iface)


class CadNodeToolPlugin:
    def __init__(self, iface):
        self.iface = iface
        self.currentLayer = None

    def initGui(self):
        self.action = QAction("NODE", self.iface.mainWindow())
        self.action.setCheckable(True)
        self.action.triggered.connect(self.run)
        self.iface.addToolBarIcon(self.action)

        self.iface.currentLayerChanged.connect(self.onCurrentLayerChanged)

        self.tool = NodeTool(self.iface.mapCanvas(), self.iface.cadDockWidget())
        self.tool.setAction(self.action)

        self.onCurrentLayerChanged()

    def unload(self):
        self.iface.removeToolBarIcon(self.action)
        self.iface.mapCanvas().unsetMapTool(self.tool)
        del self.action
        del self.tool

    def run(self):
        self.iface.mapCanvas().setMapTool(self.tool)

    def onCurrentLayerChanged(self):

        TOMsMessageLog.logMessage("In NodeTool:onCurrentLayerChanged", level=Qgis.Info)

        if isinstance(self.currentLayer, QgsVectorLayer):
            self.currentLayer.editingStarted.disconnect(self.onEditingStartStop)
            self.currentLayer.editingStopped.disconnect(self.onEditingStartStop)
        self.action.setEnabled(self.tool.can_use_current_layer())
        self.currentLayer = self.iface.mapCanvas().currentLayer()
        if isinstance(self.currentLayer, QgsVectorLayer):
            self.currentLayer.editingStarted.connect(self.onEditingStartStop)
            self.currentLayer.editingStopped.connect(self.onEditingStartStop)

    def onEditingStartStop(self):

        TOMsMessageLog.logMessage("In NodeTool:onEditingStartStop", level=Qgis.Info)

        self.action.setEnabled(self.tool.can_use_current_layer())
