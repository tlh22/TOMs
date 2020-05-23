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
import time, datetime
import functools
import os.path

from qgis.core import (
    Qgis,
    QgsExpressionContextUtils,
    QgsMessageLog,
    QgsProject,
    QgsApplication
)

class TOMsMessageLog(QgsMessageLog):

    def __init__(self):
        super().__init__()

    def logMessage(*args, **kwargs):
        # check to see if a logging level has been set
        def currentLoggingLevel():
            """
            Returns the current proposal
            """
            currLoggingLevel = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('TOMsDebugLevel')
            if not currLoggingLevel:
                currLoggingLevel = Qgis.Warning
            return int(currLoggingLevel)

        debug_level = currentLoggingLevel()

        messageLevel = kwargs.get('level')

        #QgsMessageLog.logMessage('{}: messageLevel: {}; debug_level: {}'.format(args[0], messageLevel, debug_level), tag="TOMs panel")

        if not messageLevel:
            messageLevel = Qgis.Info

        if messageLevel >= debug_level:
            QgsMessageLog.logMessage(*args, **kwargs, tag="TOMs Panel")

    def write_log_message(self, message, tag, level):
        TOMsMessageLog.logMessage("In write_log_message ... " + self.filename, level=Qgis.Info)
        with open(self.filename, 'a') as logfile:
            logfile.write(
                '{dateDetails}[{tag}]: {level} :: {message}\n'.format(dateDetails=time.strftime("%Y%m%d:%H%M%S"),
                                                                      tag=tag, level=level, message=message))

    def setLogFile(self):

        logFilePath = os.environ.get('QGIS_LOGFILE_PATH')

        if logFilePath:
            QgsMessageLog.logMessage("LogFilePath: " + str(logFilePath), tag="TOMs Panel", level=Qgis.Info)
            logfile = 'qgis_' + datetime.date.today().strftime("%Y%m%d") + '.log'
            filename = os.path.join(logFilePath, logfile)
            QgsMessageLog.logMessage("Sorting out log file " + filename, tag="TOMs Panel", level=Qgis.Info)
            return filename
