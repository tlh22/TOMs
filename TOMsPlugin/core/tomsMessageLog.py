# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ---------------------------------------------------------------------
# Tim Hancock 2017
# Oslandia 2022

import datetime
import os.path
import time
from typing import Any

from qgis.core import (
    Qgis,
    QgsExpressionContextUtils,
    QgsMessageLog,
    QgsProject,
)


class TOMsMessageLog:

    filename = ""
    currLoggingLevel = Qgis.Info

    @staticmethod
    def currentLoggingLevel() -> int:
        """Get minimum logging level to be logged (default = Info)"""
        currLoggingLevel = int(Qgis.Info)
        llevel = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable(
            "TOMs_Logging_Level"
        )
        if llevel is not None:
            currLoggingLevel = int(llevel)
            QgsMessageLog.logMessage(
                "Logging level read from TOMs_Logging_Level project variable"
            )

        return currLoggingLevel

    @staticmethod
    def logMessage(*args: Any, **kwargs: Any) -> None:
        # check to see if a logging level has been set
        debugLevel = TOMsMessageLog.currLoggingLevel
        llevel = kwargs.get("level") or Qgis.Info
        messageLevel = int(llevel)

        if messageLevel >= debugLevel:
            QgsMessageLog.logMessage(*args, **kwargs, tag="TOMs Panel")
            # TOMsMessageLog.write_log_message(args[0], messageLevel, "TOMs Panel", debug_level)
            if TOMsMessageLog.filename != "":
                with open(TOMsMessageLog.filename, "a", encoding="utf8") as logfile:
                    logfile.write(
                        f'{time.strftime("%Y%m%d:%H%M%S")}[TOMs Panel]: {debugLevel} :: {args[0]}\n'
                    )

    @classmethod
    def setLogFile(cls) -> None:
        logFilePath = os.environ.get("QGIS_LOGFILE_PATH")
        if logFilePath is None:
            QgsMessageLog.logMessage(
                "Error in TOMsMessageLog. QGIS_LOGFILE_PATH not found ... ",
                tag="TOMs Panel",
            )
            return

        QgsMessageLog.logMessage(
            "LogFilePath: " + str(logFilePath), tag="TOMs Panel", level=Qgis.Info
        )

        logfile = "qgis_" + datetime.date.today().strftime("%Y%m%d") + ".log"
        TOMsMessageLog.filename = os.path.join(logFilePath, logfile)
        QgsMessageLog.logMessage(
            "Sorting out log file" + cls.filename,
            tag="TOMs Panel",
            level=Qgis.Info,
        )
