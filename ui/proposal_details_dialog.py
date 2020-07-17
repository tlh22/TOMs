# -*- coding: utf-8 -*-
"""
/***************************************************************************
proposalDetailsDialog
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

import os

from PyQt5 import QtGui, uic, QtWidgets

FORM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'proposal_details_dialog_base_qt5.ui'))


class proposalDetailsDialog(QtWidgets.QDialog, FORM_CLASS):
    def __init__(self, parent=None):
        """Constructor."""
        super(proposalDetailsDialog, self).__init__(parent)
        # Set up the user interface from Designer.
        # After setupUI you can access any designer object by doing
        # self.<objectname>, and you can use autoconnect slots - see
        # http://qt-project.org/doc/qt-4.8/designer-using-a-ui-file.html
        # #widgets-and-dialogs-with-auto-connect
        self.setupUi(self)

    """class Example(QtWidgets.QMainWindow, mainwindow.Ui_MainWindow):
    def __init__(self, parent=None):
        super(Example, self).__init__(parent)
        self.setupUi(self)
        self.shortcut.activated.connect(self.addTabs)


    def Resolution(self):
        app = QtWidgets.QApplication([])
        resolution = app.desktop().screenGeometry()
        width, height = resolution.width(), resolution.height()
        self.setMaximumSize(QtCore.QSize(width, height))

    def addTabs(self):
        self.DataSets.setUpdatesEnabled(True)

        self.tab = QtWidgets.QWidget()
        self.tab.setAutoFillBackground(False)
        self.tab.setObjectName("userAdded")

        pages = self.count()"""
