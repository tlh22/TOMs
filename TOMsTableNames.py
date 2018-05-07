#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock/Matthias Kuhn 2017

from PyQt4.QtCore import (
    QObject,
    QDate,
    pyqtSignal
)

from PyQt4.QtGui import (
    QMessageBox,
    QAction
)

from qgis.core import (
    QgsExpressionContextUtils,
    QgsMapLayerRegistry,
    QgsMessageLog, QgsFeature, QgsGeometry,
    QgsFeatureRequest
)

from TOMs.restrictionTypeUtils import RestrictionTypeUtils
from TOMs.constants import (
    ACTION_CLOSE_RESTRICTION,
    ACTION_OPEN_RESTRICTION
)

class TOMsTableNames(QObject):

    def __init__(self):
        QObject.__init__(self)
        self.setupProposalsTable()
        #self.iface = iface

    def setupTOMsTableNames(self):
        pass

    def setupProposalsTable(self):
        QgsMessageLog.logMessage("In setupProposalsTable", tag="TOMs panel")
        self.Proposals = None
        if QgsMapLayerRegistry.instance().mapLayersByName("Proposals"):
            self.Proposals = QgsMapLayerRegistry.instance().mapLayersByName("Proposals")[0]
        else:
            QMessageBox.information(None, "ERROR", ("Table Proposals is not present"))
            #raise LayerNotPresent

    def PROPOSALS(self):
        return self.Proposals