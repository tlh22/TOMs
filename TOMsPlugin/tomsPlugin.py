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

from qgis.core import Qgis, QgsMessageLog
from qgis.utils import iface

from .core.tomsMessageLog import TOMsMessageLog

# Import the code for the dialog
from .expressions import TOMsExpressions
from .proposalsPanel import ProposalsPanel


class TOMs:
    """Main plugin class"""

    def __init__(self):

        QgsMessageLog.logMessage(
            "Starting TOMs... ", tag="TOMs Panel", level=Qgis.Warning
        )

        TOMsMessageLog.setLogFile()

        TOMsMessageLog.logMessage(
            "Registering expression functions ... ", level=Qgis.Info
        )
        self.expressionsObject = TOMsExpressions()
        self.expressionsObject.registerFunctions()  # Register the Expression functions that we need

        # Will be initialized in initGui
        self.tomsToolbar = None
        self.doProposalsPanel = None

        TOMsMessageLog.logMessage("Finished init ...", level=Qgis.Warning)

    def initGui(self) -> None:
        """Create the menu entries and toolbar icons inside the QGIS GUI."""

        # Add toolbar
        self.tomsToolbar = iface.addToolBar("TOMs Toolbar")
        self.tomsToolbar.setObjectName("TOMs Toolbar")
        self.doProposalsPanel = ProposalsPanel(self.tomsToolbar)

    def unload(self) -> None:
        """Removes the plugin menu item and icon from QGIS GUI."""
        self.expressionsObject.unregisterFunctions()  # unregister all the Expression functions used

        # TODO: Check whether or not there are any current map tools
        TOMsMessageLog.logMessage("Unload comnpleted ... ", level=Qgis.Info)
