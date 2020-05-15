# -*- coding: utf-8 -*-
"""
/***************************************************************************
 TOMsMessageLog

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

from qgis.core import (
    Qgis,
    QgsExpressionContextUtils,
    QgsMessageLog,
    QgsProject,
    QgsApplication
)

import os.path
import time, datetime

class TOMsMessageLog():

    def __init__(self, iface):
        self.iface = iface

    def logMessage(*args, **kwargs):
        # check to see if a logging level has been set
        try:
            debug_level = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('TOMs_Logging_Level')
        except None:
            debug_level = Qgis.Warning
        if not debug_level:
            debug_level = Qgis.Warning

        currLevel = kwargs.get('level')

        if not currLevel:
            currLevel = Qgis.Info

        if currLevel >= debug_level:
            QgsMessageLog.logMessage(*args, **kwargs, tag="TOMs panel")

    def setLogFile(self):

        logFilePath = os.environ.get('QGIS_LOGFILE_PATH')

        if logFilePath:
            QgsMessageLog.logMessage("LogFilePath: " + str(logFilePath), tag="TOMs panel", level=Qgis.Info)

            logfile = 'qgis_' + datetime.date.today().strftime("%Y%m%d") + '.log'
            self.filename = os.path.join(logFilePath, logfile)
            QgsMessageLog.logMessage("Sorting out log file" + self.filename, tag="TOMs panel", level=Qgis.Info)
            QgsApplication.messageLog().messageReceived.connect(self.write_log_message)

    def write_log_message(self, message, tag, level):
        with open(self.filename, 'a') as logfile:
            logfile.write(
                '{dateDetails}[{tag}]: {level} :: {message}\n'.format(dateDetails=time.strftime("%Y%m%d:%H%M%S"),
                                                                      tag=tag, level=level, message=message))