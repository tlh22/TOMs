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

from qgis.core import Qgis, QgsProject
from qgis.PyQt.QtCore import QCoreApplication, QStringListModel, Qt
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtWidgets import (
    QAction,
    QCompleter,
    QLineEdit,
    QToolBar,
)
from qgis.utils import iface

from .core.tomsMessageLog import TOMsMessageLog


class SearchBar:
    def __init__(self, tomsSearchBar):

        TOMsMessageLog.logMessage("In searchBar", level=Qgis.Info)
        # Save reference to the QGIS interface
        self.canvas = iface.mapCanvas()
        self.tomsSearchBar = tomsSearchBar
        self.initialPass = True
        self.gazetteerStringList: list[str] = []
        self.gazetteerLayer = None

        # Create & add a textbox
        self.searchTextbox = QLineEdit(iface.mainWindow())
        # Set width
        self.searchTextbox.setFixedWidth(250)
        # Add textbox to toolbar
        self.txtEntry = self.tomsSearchBar.addWidget(self.searchTextbox)
        # self.txtEntry.setToolTip(self.tr(u'Enter Street Name'))

        self.searchTextbox.textChanged.connect(self.doLookupItem)

        self.actionGoToItem = QAction(
            QIcon(":/plugins/TOMs/resources/magnifyingGlass.png"),
            QCoreApplication.translate("MyPlugin", "Lookup"),
            iface.mainWindow(),
        )
        self.tomsSearchBar.addAction(self.actionGoToItem)
        self.actionGoToItem.triggered.connect(self.doGoToItem)
        self.actionGoToItem.setCheckable(True)

    def enableSearchBar(self) -> None:
        TOMsMessageLog.logMessage("In enableSearchBar", level=Qgis.Info)

        self.actionGoToItem.setEnabled(True)
        self.searchTextbox.textChanged.connect(self.doLookupItem)

    def disableSearchBar(self) -> None:
        TOMsMessageLog.logMessage("In disableSearchBar", level=Qgis.Info)

        self.initialPass = True
        self.actionGoToItem.setEnabled(False)
        try:
            self.searchTextbox.textChanged.disconnect(self.doLookupItem)
        except Exception as e:
            TOMsMessageLog.logMessage(
                f"In searchBar.disableSearchBar. Issue with disconnects {e}",
                level=Qgis.Warning,
            )

    def doLookupItem(self) -> None:
        TOMsMessageLog.logMessage("In doLookupItem:", level=Qgis.Info)

        # TODO: Check whether or not a project has been opened

        # https://gis.stackexchange.com/questions/246339/drop-down-list-qgis-plugin-based-on-keyword-search/246347

        if self.initialPass:
            self.setupCompleter()
            self.initialPass = False

        searchText = self.searchTextbox.text()
        TOMsMessageLog.logMessage(
            "In doLookupItem: searchText " + str(searchText), level=Qgis.Info
        )

    def setupCompleter(self) -> None:
        # set up string list for completer

        TOMsMessageLog.logMessage("In setupCompleter:", level=Qgis.Info)
        lookupStringSet = set()
        # https://gis.stackexchange.com/questions/155805/qstringlist-error-in-plugin-of-qgis-2-10

        self.gazetteerLayer = QgsProject.instance().mapLayersByName(
            "StreetGazetteerRecords"
        )[0]

        for row in self.gazetteerLayer.getFeatures():
            roadName = row.attribute("RoadName")
            locality = row.attribute("Locality")
            nameString = roadName
            if locality:
                nameString = nameString + ", " + locality

            if nameString:
                TOMsMessageLog.logMessage(
                    "In setupCompleter: nameString: " + nameString, level=Qgis.Info
                )
                lookupStringSet.add(nameString)

        completer = QCompleter()
        completer.setCaseSensitivity(Qt.CaseInsensitive)
        completer.setFilterMode(Qt.MatchContains)
        self.searchTextbox.setCompleter(completer)
        model = QStringListModel()
        completer.setModel(model)
        model.setStringList(self.gazetteerStringList)
        model.setStringList(sorted(lookupStringSet))

    def doGoToItem(self) -> None:

        TOMsMessageLog.logMessage("In doGoToItem:", level=Qgis.Info)

        searchText = self.searchTextbox.text()
        TOMsMessageLog.logMessage(
            "In doGoToItem: searchText " + str(searchText), level=Qgis.Info
        )

        # Split out the components of the text

        try:
            roadName, localityName = searchText.split(",")
        except Exception as e:
            TOMsMessageLog.logMessage(
                f"In doGoToItem: error spliting searchText: {e}",
                level=Qgis.Warning,
            )
            roadName = searchText
            localityName = ""

        # amendedRoadName = RoadName.replace("'", "\'\'")
        # amendedLocalityName = localityName.replace("'", "\'\'")
        TOMsMessageLog.logMessage(
            "In doGoToItem: RoadName: "
            + str(roadName.replace("'", "''"))
            + " locality: + "
            + str(localityName.replace("'", "''")),
            level=Qgis.Info,
        )

        # Now search for the street

        queryString = '"RoadName" = \'' + roadName.replace("'", "''") + "'"
        if len(localityName) > 0:
            queryString = (
                queryString
                + ' AND "Locality" = \''
                + localityName.replace("'", "''").lstrip()
                + "'"
            )

        TOMsMessageLog.logMessage(
            "In doGoToItem: queryString: " + str(queryString), level=Qgis.Info
        )

        self.canvas.zoomToSelected(self.gazetteerLayer)

    def unload(self) -> None:
        # self.tool.setEnabled(False)
        # self.tool = None
        # iface.TOMsSearchBar().removeAction(self.printButtonAction)
        iface.TOMsSearchBar().removeAction(self.actionGoToItem)
