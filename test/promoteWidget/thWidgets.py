# -----------------------------------------------------------
# Taken from https://gis.stackexchange.com/questions/350148/qcombobox-multiple-selection-pyqt5
# -----------------------------------------------------------

from qgis.PyQt.QtWidgets import (
    QPushButton
)

"""
class Ui_thComboBox(object):
    def setupUi(self, thComboBox):
        thComboBox.setObjectName("promotedWidget")
        QtCore.QMetaObject.connectSlotsByName(thComboBox)
"""

class thPushButton(QPushButton):
    def __init__(self, *args, **kwargs):
        QPushButton.__init__(self, *args, **kwargs)
        self.setStyleSheet("background-color:red")

"""
To promote widget:
1. add placeholder widget to form, e.g., QLabel or QPushButton
2. create new class ideally using the placeholder widget as inheritance base
3. within QtDesign, right click on placeholder and "Promote"
4. Add name of new class
5. Add path to header (including file name). No need for file extensions

"""