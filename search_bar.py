# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ---------------------------------------------------------------------
# Tim Hancock 2017

## Incorporates InstantPrintPlugin from Sandro Mani / Sourcepole AG

# -*- coding: latin1 -*-
# Import the PyQt and QGIS libraries

from qgis.PyQt.QtCore import *
from qgis.PyQt.QtGui import *
from PyQt5.QtWidgets import QDialog, QDialogButtonBox, QMessageBox, QFileDialog, QListWidgetItem, QListWidget, QCheckBox, QLineEdit, QToolButton, QAction, QCompleter
from qgis.core import *

from .InstantPrint.TOMsInstantPrintTool import TOMsInstantPrintTool

class searchBar():

    def __init__(self, iface, TOMsSearchBar, proposalsManager):

        QgsMessageLog.logMessage("In searchBar", tag="TOMs panel")
        # Save reference to the QGIS interface
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.TOMsSearchBar = TOMsSearchBar
        self.proposalsManager = proposalsManager

        self.tool = TOMsInstantPrintTool(self.iface, self.proposalsManager)

        self.initSearchBar()


        # https: // gis.stackexchange.com / questions / 244584 / adding - textbox - to - qgis - plugin - toolbar

    def initSearchBar(self):
        QgsMessageLog.logMessage("In initSearchBox:", tag="TOMs panel")

        self.initialPass = True
        self.gazetteerStringList = []

        # Create & add a textbox
        self.searchTextbox = QLineEdit(self.iface.mainWindow())
        # Set width
        self.searchTextbox.setFixedWidth(250)
        # Add textbox to toolbar
        self.txtEntry = self.TOMsSearchBar.addWidget(self.searchTextbox)
        #self.txtEntry.setToolTip(self.tr(u'Enter Street Name'))

        self.searchTextbox.textChanged.connect(self.doLookupItem)

        self.actionGoToItem = QAction(QIcon(":/plugins/TOMs/resources/magnifyingGlass.png"),
                                            QCoreApplication.translate("MyPlugin", "Start TOMs"), self.iface.mainWindow())
        self.TOMsSearchBar.addAction(self.actionGoToItem)
        self.actionGoToItem.triggered.connect(self.doGoToItem)
        self.actionGoToItem.setCheckable(True)

        # Add in details of the Instant Print plugin
        self.toolButton = QToolButton(self.iface.mainWindow())
        self.toolButton.setIcon(QIcon(":/plugins/TOMs/InstantPrint/icons/icon.png"))
        #self.toolButton.setToolTip(self.tr("Instant Print"))
        self.toolButton.setCheckable(True)
        self.printButtonAction = self.TOMsSearchBar.addWidget(self.toolButton)

        """self.actionInstantPrint = QAction(QIcon(":/plugins/TOMs/InstantPrint/icons/icon.png"),
                                          QCoreApplication.translate("Print", "Print"), self.iface.mainWindow())"""

        self.toolButton.toggled.connect(self.__enablePrintTool)
        self.iface.mapCanvas().mapToolSet.connect(self.__onPrintToolSet)

    def enableSearchBar(self):
        QgsMessageLog.logMessage("In enableSearchBar", tag="TOMs panel")

        self.actionGoToItem.setEnabled(True)
        self.toolButton.setEnabled(True)
        self.searchTextbox.textChanged.connect(self.doLookupItem)

    def disableSearchBar(self):
        QgsMessageLog.logMessage("In disableSearchBar", tag="TOMs panel")

        self.initialPass = True
        self.actionGoToItem.setEnabled(False)
        self.toolButton.setEnabled(False)
        self.searchTextbox.textChanged.disconnect(self.doLookupItem)

    def doLookupItem(self):

        QgsMessageLog.logMessage("In doLookupItem:", tag="TOMs panel")

        # TODO: Check whether or not a project has been opened

        #https: // gis.stackexchange.com / questions / 246339 / drop - down - list - qgis - plugin - based - on - keyword - search / 246347

        if self.initialPass:
            self.setupCompleter()
            self.initialPass = False

        searchText = self.searchTextbox.text()
        QgsMessageLog.logMessage("In doLookupItem: searchText " + str(searchText), tag="TOMs panel")

        #search_in = txt
        #query = "SELECT myfield1, myfield2 FROM my_table WHERE '%s' LIKE '%' || search_field || '%';" % (search_in)
        # access your db and run the query
        # run the query with while query.next() and store values in a list
        # feed list to resiver (combox.addItems(myList)

    def setupCompleter(self):
        # set up string list for completer

        QgsMessageLog.logMessage("In setupCompleter:", tag="TOMs panel")
        lookupStringSet = set()
        # https://gis.stackexchange.com/questions/155805/qstringlist-error-in-plugin-of-qgis-2-10

        self.GazetteerLayer = QgsProject.instance().mapLayersByName("StreetGazetteerRecords")[0]

        for row in self.GazetteerLayer.getFeatures():
            streetName = row.attribute("Descriptor_")
            locality = row.attribute("Locality")
            nameString = streetName
            if locality:
                nameString = nameString + ", " + locality

            if nameString:
                QgsMessageLog.logMessage("In setupCompleter: nameString: " + nameString, tag="TOMs panel")
                lookupStringSet.add(nameString)
                # self.gazetteerStringList.append((nameString))

        completer = QCompleter()
        completer.setCaseSensitivity(Qt.CaseInsensitive)
        completer.setFilterMode(Qt.MatchContains)
        self.searchTextbox.setCompleter(completer)
        model = QStringListModel()
        completer.setModel(model)
        model.setStringList(self.gazetteerStringList)
        model.setStringList(sorted(lookupStringSet))

    def doGoToItem(self):

        QgsMessageLog.logMessage("In doGoToItem:", tag="TOMs panel")

        searchText = self.searchTextbox.text()
        QgsMessageLog.logMessage("In doGoToItem: searchText " + str(searchText), tag="TOMs panel")

        # Split out the components of the text

        streetName, localityName = searchText.split(',')
        #amendedStreetName = streetName.replace("'", "\'\'")
        #amendedLocalityName = localityName.replace("'", "\'\'")
        QgsMessageLog.logMessage("In doGoToItem: streetName: " + str(streetName.replace("'", "\'\'")) + " locality: + " + str(localityName.replace("'", "\'\'")), tag="TOMs panel")

        # Now search for the street

        queryString = "\"Descriptor_\" = \'" + streetName.replace("'", "\'\'") + "\'"
        if localityName:
            queryString = queryString + " AND \"Locality\" = \'" + localityName.replace("'", "\'\'").lstrip() + "\'"

        QgsMessageLog.logMessage("In doGoToItem: queryString: " + str(queryString), tag="TOMs panel")

        it = self.GazetteerLayer.selectByExpression(queryString, QgsVectorLayer.SetSelection)

        self.canvas.zoomToSelected(self.GazetteerLayer)

        """box = layer.boundingBoxOfSelected()
        iface.mapCanvas().setExtent(box)
        iface.mapCanvas().refresh()"""

    def unload(self):
        self.tool.setEnabled(False)
        self.tool = None
        self.iface.TOMsSearchBar().removeAction(self.printButtonAction)
        self.iface.TOMsSearchBar().removeAction(self.actionGoToItem)

    def __enablePrintTool(self, active):
        self.tool.setEnabled(active)

    def __onPrintToolSet(self, tool):
        if tool != self.tool:
            self.toolButton.setChecked(False)

