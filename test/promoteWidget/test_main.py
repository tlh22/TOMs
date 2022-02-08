import os

from PyQt5 import uic

CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))

uifile_1 = os.path.join(CURRENT_DIR, "test.ui")
form_1, base_1 = uic.loadUiType(uifile_1)
print ('ui file: {}'.format(uifile_1))

class myTest(base_1, form_1):
    def __init__(self):
        super(base_1, self).__init__()
        self.setupUi(self)

"""

import TOMs.test.promoteWidget.test_main
ex = TOMs.test.promoteWidget.test_main.myTest()
ex.show()

"""