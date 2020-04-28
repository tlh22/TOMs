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

from qgis.core import (
    QgsExpressionContextUtils,
    QgsExpression,
    QgsFeatureRequest,
    # QgsMapLayerRegistry,
    QgsMessageLog, QgsFeature, QgsGeometry,
    QgsTransaction, QgsTransactionGroup,
    QgsProject,
    QgsApplication
)

# Import the code for the dialog
from .core.proposalsManager import TOMsProposalsManager

from .expressions import registerFunctions, unregisterFunctions
from .restrictionTypeUtilsClass import TOMSLayers
from .proposals_panel import proposalsPanel

import os.path
import time
import datetime

class TOMs:
    """QGIS Plugin Implementation."""

    def __init__(self, iface):

        QgsMessageLog.logMessage("Starting TOMs ... ", tag="TOMs panel")

        # Monkeypatch to avoid slowdown because of logging
        # FIXME : create own logger function and replace calls to
        # QgslogMessage all over the code instead
        logMessage = QgsMessageLog.logMessage
        def mute(*args, **kwargs):
            if kwargs.get('tag') == 'TOMs panel':
                pass
            else:
                logMessage(*args, **kwargs)
        QgsMessageLog.logMessage = mute
        QgsMessageLog.logMessage("AM I MUTE ? yes i am", tag="TOMs panel")
        QgsMessageLog.logMessage("ARE OTHER MUTE ? no they arent")

        """Constructor.
        
        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        """
        # Save reference to the QGIS interface
        self.iface = iface
        # initialize plugin directory
        self.plugin_dir = os.path.dirname(__file__)
        # initialize locale
        locale = QSettings().value('locale/userLocale')[0:2]
        locale_path = os.path.join(
            self.plugin_dir,
            'i18n',
            'Test5Class_{}.qm'.format(locale))

        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)

            if qVersion() > '4.3.3':
                QCoreApplication.installTranslator(self.translator)

        # Declare instance attributes
        self.actions = []   # ?? check - assume it initialises array of actions
        
        # self.menu = self.tr(u'&Test5')
        # TODO: We are going to let the user set this up in a future iteration

        # Set up log file and collect any relevant messages
        """logFilePath = os.environ.get('QGIS_LOGFILE_PATH')

        if logFilePath:

            QgsMessageLog.logMessage("LogFilePath: " + str(logFilePath), tag="TOMs panel")

            logfile = 'qgis_' + datetime.date.today().strftime("%Y%m%d") + '.log'
            self.filename = os.path.join(logFilePath, logfile)
            QgsMessageLog.logMessage("Sorting out log file" + self.filename, tag="TOMs panel")
            QgsApplication.instance().messageLog().messageReceived.connect(self.write_log_message)


        QgsMessageLog.logMessage("Finished init", tag="TOMs panel")
        #self.toolbar = self.iface.addToolBar(u'Test5Class')
        #self.toolbar.setObjectName(u'Test5Class')
        """
    # noinspection PyMethodMayBeStatic
    def tr(self, message):
        """Get the translation for a string using Qt translation API.

        We implement this ourselves since we do not inherit QObject.

        :param message: String for translation.
        :type message: str, QString

        :returns: Translated version of message.
        :rtype: QString
        """
        # noinspection PyTypeChecker,PyArgumentList,PyCallByClass
        return QCoreApplication.translate('Test5Class', message)

    def initGui(self):
        """Create the menu entries and toolbar icons inside the QGIS GUI."""
        QgsMessageLog.logMessage("Registering expression functions ... ", tag="TOMs panel")
        registerFunctions()   # Register the Expression functions that we need

        #layerNames = TOMSLayers(self.iface)
        #self.proposalsManager = TOMsProposalsManager(self.iface, layerNames)

        #self.editing    = False
        #self.curStartPt = None
        #self.curEndPt   = None

        """self.TOMsMenu = self.iface.mainWindow().findChild( QMenu, 'TOMs' )

        # If the menu does not exist, create it!
        if not self.TOMsMenu:
            
            #QMessageBox.information(self.iface.mainWindow(), "debug", "Create new menu")
            QgsMessageLog.logMessage("Creating menu", tag="TOMs panel")

            self.TOMsMenu = QMenu( 'TOMs', self.iface.mainWindow().menuBar() )
            self.TOMsMenu.setObjectName( 'TOMs' )
            actions = self.iface.mainWindow().menuBar().actions()
            lastAction = actions[-1]
            self.iface.mainWindow().menuBar().insertMenu( lastAction, self.TOMsMenu )

            # add items to menu
            # self.setupUi()
            #self.doManageRestrictionTypes = manageRestrictionTypes(self.iface, self.TOMsMenu)
            #self.TOMsMenu.addSeparator()
            #self.doFilterOnDate = filterOnDate(self.iface, self.TOMsMenu)
            #self.TOMsMenu.addSeparator()
            self.doProposalsPanel = proposalsPanel(self.iface, self.TOMsMenu, self.proposalsManager)

        else:

            QgsMessageLog.logMessage("Menu already exists", tag="TOMs panel")
            
            self.TOMsMenu.menuAction().setVisible( True )"""

        self.hideMenusToolbars()

        # set up menu. Is there a generic way to do this? from an xml file?
        
        # self.TOMsMenu.addMenu( self.PrintMenu )

        QgsMessageLog.logMessage("Adding toolbars", tag="TOMs panel")

        # set up a search box (for street names and GeometryIDs)
        """
        self.TOMsSearchBar = self.iface.addToolBar("TOMs Search Bar")
        self.TOMsSearchBar.setObjectName("TOMs Search Bar")
        self.doSearchBar = searchBar(self.iface, self.TOMsSearchBar, self.proposalsManager)
        """
        #self.doInstantPrint = InstantPrintPlugin(self.iface, self.TOMsSearchBar)

        # Add toolbar 
        self.TOMsToolbar = self.iface.addToolBar("TOMs Toolbar")
        self.TOMsToolbar.setObjectName("TOMs Toolbar")
        #self.doRestrictionDetails = manageRestrictionDetails(self.iface, self.TOMsToolbar, self.proposalsManager)

        #self.doSearchBar = searchBar(self.iface, self.TOMsToolbar, self.proposalsManager)
        self.doProposalsPanel = proposalsPanel(self.iface, self.TOMsToolbar)

        pass

    def unload(self):
        """Removes the plugin menu item and icon from QGIS GUI."""

        unregisterFunctions()  # unregister all the Expression functions used

        # Remove TOMs menu
        """self.menu = self.iface.mainWindow().findChild( QMenu, 'TOMs' )
        if self.menu:
            self.menu.menuAction().setVisible( False )"""

        '''
        for action in self.actions:
            self.iface.removePluginMenu(
                self.tr(u'&Test5'),
                action)
            self.iface.removeToolBarIcon(action)
        '''

        # Check whether or not there are any current map tools

        # remove the toolbar
        QgsMessageLog.logMessage("Clearing toolbar ... ", tag="TOMs panel")
        self.TOMsToolbar.clear()
        QgsMessageLog.logMessage("Deleting toolbar ... ", tag="TOMs panel")
        del self.TOMsToolbar
        #self.restoreMenusToolbars()

        # disconnect panel
        #self.dockwidget.closingPlugin.disconnect(self.onClosePlugin)

        QgsMessageLog.logMessage("Unload comnpleted ... ", tag="TOMs panel")

    def hideMenusToolbars(self):
        ''' Remove the menus and toolbars that we don't want (e.g., the Edit menu)
            There should be a more elegant way to do this by checking the collection of menu items and removing certain ones.
            This will do for the moment  !?! - See http://gis.stackexchange.com/questions/227876/finding-name-of-qgis-toolbar-in-python
        '''

        # Menus not required are Processing, Raster, Vector, Layer and Edit

        # databaseMenu = self.iface.databaseMenu()
        # databaseMenu.menuAction().setVisible( False )

        #rasterMenu = self.iface.rasterMenu()
        #rasterMenu.menuAction().setVisible( False )

        # Toolbars not required are Vector, Managing Layers, File, Digitizing, Attributes, 
        #digitizeToolBar = self.iface.digitizeToolBar()
        #digitizeToolBar.setVisible( False )

        #advancedDigitizeToolBar = self.iface.advancedDigitizeToolBar()
        #advancedDigitizeToolBar.setVisible( False )

        # Panels not required are Browser, Layer Order
		
        for x in self.iface.mainWindow().findChildren(QDockWidget):
            QgsMessageLog.logMessage("Dockwidgets: " + str(x.objectName()), tag="TOMs panel")

        # for x in self.iface.mainWindow().findChildren(QMenu): 
        #     QgsMessageLog.logMessage("Menus: " + str(x.objectName()), tag="TOMs panel")

        # rasterMenu = self.iface.rasterMenu()
        # databaseMenu.menuAction().setVisible( False )
        pass


    def restoreMenusToolbars(self):
        ''' Remove the menus and toolbars that we don't want (e.g., the Edit menu)
            There should be a more elegant way to do this by checking the collection of menu items and removing certain ones.
            This will do for the moment  !?! - See http://gis.stackexchange.com/questions/227876/finding-name-of-qgis-toolbar-in-python
        '''

        # Menus not required are Processing, Raster, Vector, Layer and Edit

        databaseMenu = self.iface.databaseMenu()
        databaseMenu.menuAction().setVisible( True )

        rasterMenu = self.iface.rasterMenu()
        rasterMenu.menuAction().setVisible( True )

        # Toolbars not required are Vector, Managing Layers, File, Digitizing, Attributes, 
        digitizeToolBar = self.iface.digitizeToolBar()
        digitizeToolBar.setVisible( True )

        # advancedDigitizeToolBar = self.iface.advancedDigitizeToolBar()
        # advancedDigitizeToolBar.setVisible( True )

        # Panels not required are Browser, Layer Order
		
        for x in self.iface.mainWindow().findChildren(QDockWidget): 
            QgsMessageLog.logMessage("Dockwidgets: " + str(x.objectName()), tag="TOMs panel")

        # for x in self.iface.mainWindow().findChildren(QMenu): 
        #     QgsMessageLog.logMessage("Menus: " + str(x.objectName()), tag="TOMs panel")

        # rasterMenu = self.iface.rasterMenu()
        # databaseMenu.menuAction().setVisible( True )

        #def run(self):
        """Run method that performs all the real work"""
        
        """QgsMessageLog.logMessage("In Action 1", tag="TOMs panel")

        self.dlg = Test5ClassDialog()

        # show the dialog
        self.dlg.show()
        
        # Run the dialog event loop
        result = self.dlg.exec_()
        
        # See if OK was pressed
        if result:
            # Do something useful here - delete the line containing pass and
            # substitute with your code.
            pass"""

        #def doSelect(self):
        """Run method that performs all the real work"""
        
        """QgsMessageLog.logMessage("In Select", tag="TOMs panel")

        self.dlg = Test5ClassDialog()

        # show the dialog
        self.dlg.show()
        
        # Run the dialog event loop
        result = self.dlg.exec_()
        
        # See if OK was pressed
        if result:
            # Do something useful here - delete the line containing pass and
            # substitute with your code.
            pass"""

        #def doProposalsPanel(self):
        """Run method that loads and starts the plugin"""
        #QgsMessageLog.logMessage("In doProposalsPanel - not sure what should happen here ...", tag="TOMs panel")
        #pass

