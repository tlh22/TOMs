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

from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *

from TOMs.InstantPrint.TOMsInstantPrintTool import TOMsInstantPrintTool

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
        self.textbox = QLineEdit(self.iface.mainWindow())
        # Set width
        self.textbox.setFixedWidth(200)
        # Add textbox to toolbar
        self.txtEntry = self.TOMsSearchBar.addWidget(self.textbox)
        #self.txtEntry.setToolTip(self.tr(u'Enter Street Name'))

        self.textbox.textChanged.connect(self.doLookupItem)

        self.actionGoToItem = QAction(QIcon(":/plugins/TOMs/resources/magnifyingGlass.png"),
                                            QCoreApplication.translate("MyPlugin", "Start TOMs"), self.iface.mainWindow())
        self.TOMsSearchBar.addAction(self.actionGoToItem)
        self.actionGoToItem.triggered.connect(self.doGoToItem)

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

    def doLookupItem(self):

        QgsMessageLog.logMessage("In doLookupItem:", tag="TOMs panel")

        # TODO: Check whether or not a project has been opened

        #https: // gis.stackexchange.com / questions / 246339 / drop - down - list - qgis - plugin - based - on - keyword - search / 246347

        if self.initialPass:
            self.setupCompleter()
            self.initialPass = False

        searchText = self.textbox.text()
        QgsMessageLog.logMessage("In doLookupItem: searchText " + str(searchText), tag="TOMs panel")

        #search_in = txt
        #query = "SELECT myfield1, myfield2 FROM my_table WHERE '%s' LIKE '%' || search_field || '%';" % (search_in)
        # access your db and run the query
        # run the query with while query.next() and store values in a list
        # feed list to resiver (combox.addItems(myList)

    def setupCompleter(self):
        # set up string list for completer

        QgsMessageLog.logMessage("In setupCompleter:", tag="TOMs panel")

        # https://gis.stackexchange.com/questions/155805/qstringlist-error-in-plugin-of-qgis-2-10

        self.GazetteerLayer = QgsMapLayerRegistry.instance().mapLayersByName("StreetGazetteerRecords")[0]

        for row in self.GazetteerLayer.getFeatures():
            streetName = row.attribute("Descriptor_")
            locality = row.attribute("Locality")
            nameString = streetName
            if locality:
                nameString = nameString + ", " + locality

            if nameString:
                QgsMessageLog.logMessage("In setupCompleter: nameString: " + nameString, tag="TOMs panel")
                self.gazetteerStringList.append((nameString))

        completer = QCompleter()
        self.textbox.setCompleter(completer)
        model = QStringListModel()
        completer.setModel(model)
        model.setStringList(self.gazetteerStringList)
        # model.setStringList(my_lst)

    def doGoToItem(self):

        QgsMessageLog.logMessage("In doGoToItem:", tag="TOMs panel")

        searchText = self.textbox.text()
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

        expr = QgsExpression(queryString)

        it = self.GazetteerLayer.getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]  # select only the features for which the expression is true
        self.GazetteerLayer.setSelectedFeatures(ids)

        # And zoom to the location
        #canvas = self.iface.mapCanvas()
        self.canvas.zoomToSelected(self.GazetteerLayer)

        """box = layer.boundingBoxOfSelected()
        iface.mapCanvas().setExtent(box)
        iface.mapCanvas().refresh()"""

    def unload(self):
        self.tool.setEnabled(False)
        self.tool = None
        self.iface.TOMsSearchBar().removeAction(self.printButtonAction)

    def __enablePrintTool(self, active):
        self.tool.setEnabled(active)

    def __onPrintToolSet(self, tool):
        if tool != self.tool:
            self.toolButton.setChecked(False)

