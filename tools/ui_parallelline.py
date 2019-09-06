# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file './tools/parallelline.ui'
#
# Created: Wed Sep 18 17:02:25 2013
#      by: PyQt5 UI code generator 4.10
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s

try:
    _encoding = QtGui.QApplication.UnicodeUTF8
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)

class Ui_ParallelLine(object):
    def setupUi(self, ParallelLine):
        ParallelLine.setObjectName(_fromUtf8("ParallelLine"))
        ParallelLine.resize(382, 180)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(ParallelLine.sizePolicy().hasHeightForWidth())
        ParallelLine.setSizePolicy(sizePolicy)
        self.gridLayout = QtWidgets.QGridLayout(ParallelLine)
        self.gridLayout.setObjectName(_fromUtf8("gridLayout"))
        self.buttonBox = QtWidgets.QDialogButtonBox(ParallelLine)
        self.buttonBox.setEnabled(False)
        self.buttonBox.setStandardButtons(QtWidgets.QDialogButtonBox.Cancel|QtWidgets.QDialogButtonBox.Ok)
        self.buttonBox.setObjectName(_fromUtf8("buttonBox"))
        self.gridLayout.addWidget(self.buttonBox, 4, 0, 1, 1)
        self.groupBox = QtGui.QGroupBox(ParallelLine)
        self.groupBox.setObjectName(_fromUtf8("groupBox"))
        self.gridLayout_2 = QtWidgets.QGridLayout(self.groupBox)
        self.gridLayout_2.setObjectName(_fromUtf8("gridLayout_2"))
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setObjectName(_fromUtf8("horizontalLayout"))
        self.radioFixed = QtGui.QRadioButton(self.groupBox)
        self.radioFixed.setChecked(True)
        self.radioFixed.setObjectName(_fromUtf8("radioFixed"))
        self.horizontalLayout.addWidget(self.radioFixed)
        spacerItem = QtGui.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem)
        self.spinBoxDistance = QtGui.QDoubleSpinBox(self.groupBox)
        self.spinBoxDistance.setEnabled(True)
        self.spinBoxDistance.setDecimals(3)
        self.spinBoxDistance.setMaximum(99.99)
        self.spinBoxDistance.setObjectName(_fromUtf8("spinBoxDistance"))
        self.horizontalLayout.addWidget(self.spinBoxDistance)
        self.gridLayout_2.addLayout(self.horizontalLayout, 0, 0, 1, 1)
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_2.setObjectName(_fromUtf8("horizontalLayout_2"))
        self.radioVertex = QtGui.QRadioButton(self.groupBox)
        self.radioVertex.setObjectName(_fromUtf8("radioVertex"))
        self.horizontalLayout_2.addWidget(self.radioVertex)
        spacerItem1 = QtGui.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_2.addItem(spacerItem1)
        self.btnSelectVertex = QtGui.QPushButton(self.groupBox)
        self.btnSelectVertex.setObjectName(_fromUtf8("btnSelectVertex"))
        self.horizontalLayout_2.addWidget(self.btnSelectVertex)
        self.gridLayout_2.addLayout(self.horizontalLayout_2, 1, 0, 1, 1)
        self.gridLayout.addWidget(self.groupBox, 3, 0, 1, 1)

        self.retranslateUi(ParallelLine)
        QtCore.QObject.connect(self.buttonBox, QtCore.SIGNAL(_fromUtf8("rejected()")), ParallelLine.reject)
        QtCore.QObject.connect(self.buttonBox, QtCore.SIGNAL(_fromUtf8("accepted()")), ParallelLine.accept)
        QtCore.QMetaObject.connectSlotsByName(ParallelLine)

    def retranslateUi(self, ParallelLine):
        ParallelLine.setWindowTitle(_translate("ParallelLine", "Parallel Line", None))
        self.groupBox.setTitle(_translate("ParallelLine", "Parallel line", None))
        self.radioFixed.setText(_translate("ParallelLine", "Fixed length", None))
        self.radioVertex.setText(_translate("ParallelLine", "Snap to vertex", None))
        self.btnSelectVertex.setText(_translate("ParallelLine", "Select Vertex", None))

