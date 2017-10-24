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
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *
from qgis.gui import *

# Initialize Qt resources from file resources.py
import resources

# Import the code for the dialog
from TOMs.core.proposalsManager import TOMsProposalsManager

from TOMs.expressions import registerFunctions, unregisterFunctions
from TOMs.test5_module_dialog import Test5ClassDialog

from TOMs.proposals_panel import proposalsPanel
from TOMs.manage_restriction_details import manageRestrictionDetails

import os.path
import time
import datetime

class Test5Class:
    """QGIS Plugin Implementation."""

    def __init__(self, iface):
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


        QgsMessageLog.logMessage("Finished init", tag="TOMs panel")
        #self.toolbar = self.iface.addToolBar(u'Test5Class')
        #self.toolbar.setObjectName(u'Test5Class')

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


        """def add_action(
        self,
        icon_path,
        text,
        callback,
        dlg,
        menuName,
        enabled_flag=True,
        add_to_menu=True,
        add_to_toolbar=True,
        status_tip=None,
        whats_this=None,
        parent=None):"""
        """Add a toolbar icon to the toolbar.

        :param icon_path: Path to the icon for this action. Can be a resource
            path (e.g. ':/plugins/foo/bar.png') or a normal file system path.
        :type icon_path: str

        :param text: Text that should be shown in menu items for this action.
        :type text: str

        :param callback: Function to be called when the action is triggered.
        :type callback: function

        :param enabled_flag: A flag indicating if the action should be enabled
            by default. Defaults to True.
        :type enabled_flag: bool

        :param add_to_menu: Flag indicating whether the action should also
            be added to the menu. Defaults to True.
        :type add_to_menu: bool

        :param add_to_toolbar: Flag indicating whether the action should also
            be added to the toolbar. Defaults to True.
        :type add_to_toolbar: bool

        :param status_tip: Optional text to show in a popup when mouse pointer
            hovers over the action.
        :type status_tip: str

        :param parent: Parent widget for the new action. Defaults None.
        :type parent: QWidget

        :param whats_this: Optional text to show in the status bar when the
            mouse pointer hovers over the action.

        :returns: The action that was created. Note that the action is also
            added to self.actions list.
        :rtype: QAction
        """

        # Create the dialog (after translation) and keep reference
        #QMessageBox.information(self.iface.mainWindow(), "debug", "Hello")
        """QgsMessageLog.logMessage("Start adding action:" + text, tag="TOMs panel")
        
        self.dlg = dlg

        icon = QIcon(icon_path)
        action = QAction(icon, text, parent)
        action.triggered.connect(callback)
        action.setEnabled(enabled_flag)

        if status_tip is not None:
            action.setStatusTip(status_tip)

        if whats_this is not None:
            action.setWhatsThis(whats_this)

        if add_to_toolbar:
            self.toolbar.addAction(action)

        if add_to_menu:

            # need to check whether or not menu item already exisits  ***************
            
            self.menu = self.iface.mainWindow().findChild( QMenu, menuName )

            # Add action to the menu

            self.action = QAction(text, self.iface.mainWindow())
            self.action.triggered.connect(callback)
            self.menu.addAction( self.action )

        self.actions.append(action)
        
        QgsMessageLog.logMessage("End adding action", tag="TOMs panel")

        return action"""

    def initGui(self):
        """Create the menu entries and toolbar icons inside the QGIS GUI."""
        
        QgsMessageLog.logMessage("In initGui", tag="TOMs panel")

        registerFunctions()   # Register the Expression functions that we need

        self.proposalsManager = TOMsProposalsManager()

        self.editing    = False
        self.curStartPt = None
        self.curEndPt   = None

        self.TOMsMenu = self.iface.mainWindow().findChild( QMenu, 'TOMs' )

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
        
            #QMessageBox.information(self.iface.mainWindow(), "debug", "Reinstate menu")
            QgsMessageLog.logMessage("Menu already exists", tag="TOMs panel")
            
            self.TOMsMenu.menuAction().setVisible( True )

        # set up menu. Is there a generic way to do this? from an xml file?
        
        # self.TOMsMenu.addMenu( self.PrintMenu )

        # Is there anything else that we need to do with Actions?
        QgsMessageLog.logMessage("Adding toolbar", tag="TOMs panel")

        # Add toolbar 
        self.TOMsToolbar = self.iface.addToolBar("TOMs Toolbar")
        self.TOMsToolbar.setObjectName("TOMs Toolbar")
        self.doRestrictionDetails = manageRestrictionDetails(self.iface, self.TOMsToolbar, self.proposalsManager)

        pass

    def unload(self):
        """Removes the plugin menu item and icon from QGIS GUI."""

        unregisterFunctions()  # unregister all the Expression functions used

        # Remove TOMs menu
        self.menu = self.iface.mainWindow().findChild( QMenu, 'TOMs' )
        if self.menu:
            self.menu.menuAction().setVisible( False )

        '''
        for action in self.actions:
            self.iface.removePluginMenu(
                self.tr(u'&Test5'),
                action)
            self.iface.removeToolBarIcon(action)
        '''

        # remove the toolbar
        del self.TOMsToolbar
        self.restoreMenusToolbars()

        # disconnect panel
        #self.dockwidget.closingPlugin.disconnect(self.onClosePlugin)

    def hideMenusToolbars(self):
        ''' Remove the menus and toolbars that we don't want (e.g., the Edit menu)
            There should be a more elegant way to do this by checking the collection of menu items and removing certain ones.
            This will do for the moment  !?! - See http://gis.stackexchange.com/questions/227876/finding-name-of-qgis-toolbar-in-python
        '''

        # Menus not required are Processing, Raster, Vector, Layer and Edit

        # databaseMenu = self.iface.databaseMenu()
        # databaseMenu.menuAction().setVisible( False )

        rasterMenu = self.iface.rasterMenu()
        rasterMenu.menuAction().setVisible( False )

        # Toolbars not required are Vector, Managing Layers, File, Digitizing, Attributes, 
        digitizeToolBar = self.iface.digitizeToolBar()
        digitizeToolBar.setVisible( False )

        #advancedDigitizeToolBar = self.iface.advancedDigitizeToolBar()
        #advancedDigitizeToolBar.setVisible( False )

        # Panels not required are Browser, Layer Order
		
        for x in self.iface.mainWindow().findChildren(QDockWidget): 
            QgsMessageLog.logMessage("Dockwidgets: " + str(x.objectName()), tag="TOMs panel")

        # for x in self.iface.mainWindow().findChildren(QMenu): 
        #     QgsMessageLog.logMessage("Menus: " + str(x.objectName()), tag="TOMs panel")

        # rasterMenu = self.iface.rasterMenu()
        # databaseMenu.menuAction().setVisible( False )

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

        advancedDigitizeToolBar = self.iface.advancedDigitizeToolBar()
        advancedDigitizeToolBar.setVisible( True )

        # Panels not required are Browser, Layer Order
		
        for x in self.iface.mainWindow().findChildren(QDockWidget): 
            QgsMessageLog.logMessage("Dockwidgets: " + str(x.objectName()), tag="TOMs panel")

        # for x in self.iface.mainWindow().findChildren(QMenu): 
        #     QgsMessageLog.logMessage("Menus: " + str(x.objectName()), tag="TOMs panel")

        # rasterMenu = self.iface.rasterMenu()
        # databaseMenu.menuAction().setVisible( True )

    def run(self):
        """Run method that performs all the real work"""
        
        QgsMessageLog.logMessage("In Action 1", tag="TOMs panel")

        self.dlg = Test5ClassDialog()

        # show the dialog
        self.dlg.show()
        
        # Run the dialog event loop
        result = self.dlg.exec_()
        
        # See if OK was pressed
        if result:
            # Do something useful here - delete the line containing pass and
            # substitute with your code.
            pass

    def doSelect(self):
        """Run method that performs all the real work"""
        
        QgsMessageLog.logMessage("In Select", tag="TOMs panel")

        self.dlg = Test5ClassDialog()

        # show the dialog
        self.dlg.show()
        
        # Run the dialog event loop
        result = self.dlg.exec_()
        
        # See if OK was pressed
        if result:
            # Do something useful here - delete the line containing pass and
            # substitute with your code.
            pass

    def doProposalsPanel(self):
        """Run method that loads and starts the plugin"""
        QgsMessageLog.logMessage("In doProposalsPanel - not sure what should happen here ...", tag="TOMs panel")
        pass

