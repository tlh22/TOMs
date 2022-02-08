import os
import sys

from PyQt5 import QtWidgets, uic

CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))

uifile_1 = os.path.join(CURRENT_DIR, "test1.ui")

print ('ui file: {}'.format(uifile_1))

class myTest2(uifile_1):
    def __init__(self):
        form_1, base_1 = uic.loadUiType(uifile_1)
        super(base_1, self).__init__()
        self.setupUi(self)

"""

import TOMs.test.promoteWidget.test_main2
ex2 = TOMs.test.promoteWidget.test_main.myTest2()
ex2.show()

"""