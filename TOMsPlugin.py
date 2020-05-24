# -*- coding: utf-8 -*-
"""
/***************************************************************************
 Test5Class
                                 A QGIS plugin
 Start of TOMs
                              -------------------
        begin                : 2017-01-01
        git sha              : $Format:%H$
        copyright            : (C) 2017 by TH
        email                : th@mhtc.co.uk
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""
import time, datetime
import functools
import os.path

from qgis.PyQt.QtWidgets import (
    QMessageBox,
    QAction,
    QDialogButtonBox,
    QLabel,
    QDockWidget
)

from qgis.PyQt.QtGui import (
    QIcon,
    QPixmap
)

from qgis.PyQt.QtCore import (
    QObject, QTimer, pyqtSignal,
    QTranslator,
    QSettings,
    QCoreApplication,
    qVersion
)

from TOMs.core.TOMsMessageLog import TOMsMessageLog
from qgis.core import (
    Qgis,
    QgsMessageLog,
    QgsProject,
    QgsApplication
)

# Import the code for the dialog
from TOMs.expressions import registerFunctions, unregisterFunctions
from TOMs.proposals_panel import proposalsPanel

class TOMs:
    """QGIS Plugin Implementation."""

    def __init__(self, iface):

        QgsMessageLog.logMessage("Starting TOMs ... ", tag='TOMs Panel', level=Qgis.Warning)

        """Constructor.
        
        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        """
        # Save reference to the QGIS interface
        self.iface = iface
        # initialize plugin directory
        #self.plugin_dir = os.path.dirname(__file__)

        # Declare instance attributes
        self.actions = []   # ?? check - assume it initialises array of actions

        # Set up local logging
        # Set up log file and collect any relevant messages
        """logFilePath = os.environ.get('QGIS_LOGFILE_PATH')

        if logFilePath:

            QgsMessageLog.logMessage("LogFilePath: " + str(logFilePath), tag="TOMs panel")

            logfile = 'qgis_' + datetime.date.today().strftime("%Y%m%d") + '.log'
            self.filename = os.path.join(logFilePath, logfile)
            QgsMessageLog.logMessage("Sorting out log file" + self.filename, tag="TOMs panel")
            #QgsApplication.instance().messageLog().messageReceived.connect(self.write_log_message)  # Not quite sure why this fails ...moved to TOMsMessageLog ..."""

        TOMsMessageLog.logMessage("Finished init", level=Qgis.Warning)

    def write_log_message(self, message, tag, level):
        TOMsMessageLog.logMessage("In write_log_message ... " + self.filename, level=Qgis.Info)
        with open(self.filename, 'a') as logfile:
            logfile.write(
                '{dateDetails}[{tag}]: {level} :: {message}\n'.format(dateDetails=time.strftime("%Y%m%d:%H%M%S"),
                                                                      tag=tag, level=level, message=message))

    def initGui(self):
        """Create the menu entries and toolbar icons inside the QGIS GUI."""
        TOMsMessageLog.logMessage("Registering expression functions ... ", level=Qgis.Info)
        registerFunctions()   # Register the Expression functions that we need

        # Add toolbar 
        self.TOMsToolbar = self.iface.addToolBar("TOMs Toolbar")
        self.TOMsToolbar.setObjectName("TOMs Toolbar")
        self.doProposalsPanel = proposalsPanel(self.iface, self.TOMsToolbar)

    def unload(self):
        """Removes the plugin menu item and icon from QGIS GUI."""
        unregisterFunctions()  # unregister all the Expression functions used

        # TODO: Check whether or not there are any current map tools
        TOMsMessageLog.logMessage("Unload comnpleted ... ", level=Qgis.Info)
