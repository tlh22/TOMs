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


from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *
from qgis.gui import *

from TOMs.InstantPrint.InstantPrintTool import InstantPrintTool

class TOMsInstantPrintTool(InstantPrintTool):

    def __init__(self, iface):

        self.iface = iface
        InstantPrintTool.__init__(self, iface)

