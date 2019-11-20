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

