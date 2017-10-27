#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock 2017
'''
Constants for TOMs. Taken from Eric Westra ... and amended as appropriate
'''

from PyQt4.QtGui import (
    QMessageBox
)

from qgis.core import (
    QgsMapLayerRegistry, QgsMessageLog
)


def ACTION_CLOSE_RESTRICTION(): return 2
def ACTION_OPEN_RESTRICTION(): return 1


class TOMsConstants(object):

    def __init__(self):

        """QgsMessageLog.logMessage("In TOMsConstants. RESTRICTIONS_IN_PROPOSALS_LAYER", tag="TOMs panel")
        if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals"):
            QgsMessageLog.logMessage("In TOMsConstants. layer: " + str(QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0].name()), tag="TOMs panel")
            self.RestrictionsInProposals = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionsInProposals")[0]
        else:
            QMessageBox.information(self.iface.mainWindow(), "ERROR", ("Table RestrictionsInProposals is not present"))
            raise LayerNotPresent"""
        pass

    #def ACTION_CLOSE_RESTRICTION(self): return 2
    #def ACTION_OPEN_RESTRICTION(self): return 1

    #def RESTRICTIONS_IN_PROPOSALS_LAYER(self): return self.RestrictionsInProposals




