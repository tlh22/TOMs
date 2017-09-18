#-----------------------------------------------------------
# Copyright (C) 2015 Martin Dobias
#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------

from PyQt4.QtGui import *
from PyQt4.QtCore import *

from qgis.core import *
from qgis.gui import *

from nodetool import NodeTool

def classFactory(iface):
    return CadNodeToolPlugin(iface)


class CadNodeToolPlugin:
    def __init__(self, iface):
        self.iface = iface
        self.current_layer = None

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
        if isinstance(self.current_layer, QgsVectorLayer):
            self.current_layer.editingStarted.disconnect(self.onEditingStartStop)
            self.current_layer.editingStopped.disconnect(self.onEditingStartStop)
        self.action.setEnabled(self.tool.can_use_current_layer())
        self.current_layer = self.iface.mapCanvas().currentLayer()
        if isinstance(self.current_layer, QgsVectorLayer):
            self.current_layer.editingStarted.connect(self.onEditingStartStop)
            self.current_layer.editingStopped.connect(self.onEditingStartStop)

    def onEditingStartStop(self):
        self.action.setEnabled(self.tool.can_use_current_layer())
