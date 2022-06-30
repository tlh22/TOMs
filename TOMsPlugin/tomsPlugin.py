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

from typing import Any

from qgis.core import Qgis, QgsMessageLog

from .core.tomsMessageLog import TOMsMessageLog

# Import the code for the dialog
from .expressions import TOMsExpressions
from .proposalsPanel import ProposalsPanel


class TOMs:
    """Main plugin class"""

    def __init__(self, iface: Any):

        QgsMessageLog.logMessage(
            "Starting TOMs... ", tag="TOMs Panel", level=Qgis.Warning
        )

        self.iface = iface

        # Set up local logging
        loggingUtils = TOMsMessageLog()
        loggingUtils.setLogFile()

        TOMsMessageLog.logMessage("Finished init ...", level=Qgis.Warning)
        # Set up local logging
        # Set up log file and collect any relevant messages
        """logFilePath = os.environ.get('QGIS_LOGFILE_PATH')

        if logFilePath:

            QgsMessageLog.logMessage("LogFilePath: " + str(logFilePath), tag="TOMs panel")

            logfile = 'qgis_' + datetime.date.today().strftime("%Y%m%d") + '.log'
            self.filename = os.path.join(logFilePath, logfile)
            QgsMessageLog.logMessage("Sorting out log file" + self.filename, tag="TOMs panel")
            #QgsApplication.instance().messageLog().messageReceived.connect(self.write_log_message)  # Not quite sure why this fails ...moved to TOMsMessageLog ..."""

        # TOMsMessageLog.logMessage("Finished init", level=Qgis.Warning)

    def initGui(self):
        """Create the menu entries and toolbar icons inside the QGIS GUI."""
        TOMsMessageLog.logMessage(
            "Registering expression functions ... ", level=Qgis.Info
        )
        self.expressionsObject = TOMsExpressions()
        self.expressionsObject.registerFunctions()  # Register the Expression functions that we need

        # Add toolbar
        self.tomsToolbar = self.iface.addToolBar("TOMs Toolbar")
        self.tomsToolbar.setObjectName("TOMs Toolbar")
        self.doProposalsPanel = ProposalsPanel(self.iface, self.tomsToolbar)

    def unload(self):
        """Removes the plugin menu item and icon from QGIS GUI."""
        self.expressionsObject.unregisterFunctions()  # unregister all the Expression functions used

        # TODO: Check whether or not there are any current map tools
        TOMsMessageLog.logMessage("Unload comnpleted ... ", level=Qgis.Info)
