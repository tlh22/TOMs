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

from qgis.gui import QgsScaleComboBox
from qgis.PyQt import QtCore, QtGui, QtWidgets


class UiInstantPrintDialog(object):
    def setupUi(self, instantPrintDialog):
        instantPrintDialog.setObjectName("InstantPrintDialog")
        instantPrintDialog.resize(357, 157)
        icon = QtGui.QIcon.fromTheme("printer")
        instantPrintDialog.setWindowIcon(icon)
        self.gridLayout = QtWidgets.QGridLayout(instantPrintDialog)
        self.gridLayout.setObjectName("gridLayout")
        self.labelLayout = QtWidgets.QLabel(instantPrintDialog)
        self.labelLayout.setObjectName("label_layout")
        self.gridLayout.addWidget(self.labelLayout, 0, 0, 1, 1)
        self.comboBoxLayouts = QtWidgets.QComboBox(instantPrintDialog)
        self.comboBoxLayouts.setEditable(False)
        self.comboBoxLayouts.setObjectName("comboBox_layouts")
        self.gridLayout.addWidget(self.comboBoxLayouts, 0, 1, 1, 1)
        self.label = QtWidgets.QLabel(instantPrintDialog)
        self.label.setObjectName("label")
        self.gridLayout.addWidget(self.label, 1, 0, 1, 1)
        self.labelFileFormat = QtWidgets.QLabel(instantPrintDialog)
        self.labelFileFormat.setObjectName("label_fileformat")
        self.gridLayout.addWidget(self.labelFileFormat, 2, 0, 1, 1)
        self.comboBoxFileFormat = QtWidgets.QComboBox(instantPrintDialog)
        self.comboBoxFileFormat.setObjectName("comboBox_fileformat")
        self.gridLayout.addWidget(self.comboBoxFileFormat, 2, 1, 1, 1)
        self.buttonBox = QtWidgets.QDialogButtonBox(instantPrintDialog)
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.buttonBox.setStandardButtons(QtWidgets.QDialogButtonBox.Close)
        self.buttonBox.setObjectName("buttonBox")
        self.gridLayout.addWidget(self.buttonBox, 3, 0, 1, 2)
        self.widget = QtWidgets.QWidget(instantPrintDialog)
        self.widget.setObjectName("widget")
        self.horizontalLayout = QtWidgets.QHBoxLayout(self.widget)
        self.horizontalLayout.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout.setSpacing(0)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.comboBoxScale = QgsScaleComboBox(self.widget)
        sizePolicy = QtWidgets.QSizePolicy(
            QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed
        )
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(
            self.comboBoxScale.sizePolicy().hasHeightForWidth()
        )
        self.comboBoxScale.setSizePolicy(sizePolicy)
        self.comboBoxScale.setEditable(True)
        self.comboBoxScale.setObjectName("comboBox_scale")
        self.horizontalLayout.addWidget(self.comboBoxScale)
        self.deleteScale = QtWidgets.QToolButton(self.widget)
        self.deleteScale.setEnabled(False)
        self.deleteScale.setText("")
        self.deleteScale.setObjectName("deleteScale")
        self.horizontalLayout.addWidget(self.deleteScale)
        self.addScale = QtWidgets.QToolButton(self.widget)
        self.addScale.setEnabled(False)
        self.addScale.setText("")
        self.addScale.setObjectName("addScale")
        self.horizontalLayout.addWidget(self.addScale)
        self.gridLayout.addWidget(self.widget, 1, 1, 1, 1)

        self.retranslateUi(instantPrintDialog)
        self.buttonBox.accepted.connect(instantPrintDialog.accept)
        self.buttonBox.rejected.connect(instantPrintDialog.reject)
        QtCore.QMetaObject.connectSlotsByName(instantPrintDialog)

    def retranslateUi(self, instantPrintDialog):
        _translate = QtCore.QCoreApplication.translate
        instantPrintDialog.setWindowTitle(
            _translate("InstantPrintDialog", "Instant Print")
        )
        self.labelLayout.setText(_translate("InstantPrintDialog", "Layout:"))
        self.label.setText(_translate("InstantPrintDialog", "Scale:"))
        self.labelFileFormat.setText(_translate("InstantPrintDialog", "File format:"))
