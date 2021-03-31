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
import sys

from qgis.core import (
    Qgis,
    QgsExpressionContextUtils,
    QgsMessageLog,
    QgsProject,
    QgsApplication
)

class TOMsMessageLog(QgsMessageLog):

    filename = ''

    def __init__(self):
        super().__init__()

    @staticmethod
    def logMessage(*args, **kwargs):
        # check to see if a logging level has been set
        def currentLoggingLevel():
            try:
                currLoggingLevel = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('TOMs_Logging_Level')
            except Exception as e:
                QgsMessageLog.logMessage("Error in TOMsMessageLog. TOMs_logging_Level not found ... {}".format(e), tag="TOMs Panel")


            if not currLoggingLevel:
                currLoggingLevel = Qgis.Info
            return int(currLoggingLevel)

        debug_level = currentLoggingLevel()

        try:
            messageLevel = int(kwargs.get('level'))
        except Exception as e:
            QgsMessageLog.logMessage("Error in TOMsMessageLog. Level in message not found...{}".format(e), tag="TOMs Panel")
            messageLevel = Qgis.Info

        #QgsMessageLog.logMessage('{}: messageLevel: {}; debug_level: {}'.format(args[0], messageLevel, debug_level), tag="TOMs panel")

        if messageLevel >= debug_level:
            QgsMessageLog.logMessage(*args, **kwargs, tag="TOMs Panel")
            #TOMsMessageLog.write_log_message(args[0], messageLevel, "TOMs Panel", debug_level)
            with open(TOMsMessageLog.filename, 'a') as logfile:
                logfile.write(
                    '{dateDetails}[{tag}]: {level} :: {message}\n'.format(dateDetails=time.strftime("%Y%m%d:%H%M%S"),
                                                                          tag='TOMs Panel', level=debug_level, message=args[0]))

    def setLogFile(self):

        try:
            logFilePath = os.environ.get('QGIS_LOGFILE_PATH')
        except Exception as e:
            QgsMessageLog.logMessage("Error in TOMsMessageLog. QGIS_LOGFILE_PATH not found ... ", tag="TOMs Panel")

        if logFilePath:
            QgsMessageLog.logMessage("LogFilePath: " + str(logFilePath), tag="TOMs Panel", level=Qgis.Info)

            logfile = 'qgis_' + datetime.date.today().strftime("%Y%m%d") + '.log'
            TOMsMessageLog.filename = os.path.join(logFilePath, logfile)
            QgsMessageLog.logMessage("Sorting out log file" + self.filename, tag="TOMs Panel", level=Qgis.Info)
            #QgsApplication.messageLog().messageReceived.connect(self.write_log_message)

        """def write_log_message(self, *args, **kwargs):
        with open(TOMsMessageLog.filename, 'a') as logfile:
            logfile.write(
                '{dateDetails}[{tag}]: {level} :: {message}\n'.format(dateDetails=time.strftime("%Y%m%d:%H%M%S"),
                                                                      tag=tag, level=level, message=message))"""