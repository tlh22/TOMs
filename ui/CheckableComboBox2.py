# -----------------------------------------------------------
# Taken from https://gis.stackexchange.com/questions/350148/qcombobox-multiple-selection-pyqt5
# -----------------------------------------------------------

from qgis.PyQt.QtWidgets import (
    QComboBox,
    QPushButton
)

class thComboBox(QComboBox):
    def __init__(self, *args, **kwargs):
        QComboBox.__init__(self, *args, **kwargs)
        self.setStyleSheet("background-color:red")

class thPushButton(QPushButton):
    def __init__(self, *args, **kwargs):
        QPushButton.__init__(self, *args, **kwargs)
        self.setStyleSheet("background-color:red")