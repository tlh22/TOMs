import os
import unittest
from qgis.core import (
    Qgis,
    QgsProviderRegistry,
    QgsCoordinateReferenceSystem,
    QgsRasterLayer)

from TOMsPlugin import TOMsLoggingUtils

from utilities import get_qgis_app
QgsApplication, CANVAS, iface, PARENT = get_qgis_app()


class TOMsLogger(unittest.TestCase):

    def setUp(self):
        """Runs before each test."""
        #self.dialog = TOMsSnapTraceDialog(None)
        #QgsApplication, CANVAS, iface, PARENT = get_qgis_app()
        #iface = DummyInterface()

        self.testClass = TOMsLoggingUtils(iface)

    def tearDown(self):
        """Runs after each test."""
        #self.dialog = None
        pass

    def test_TOMsLog(self):

        self.signalReceived = False

        def check_signal(self, message, tag, level):
            self.signalReceived = True

        # way to check is whether or not signal is received - need to
        #QgsApplication.messageLog().messageReceived.connect(self.check_signal)

        loggingUtils = TOMsLoggingUtils(self.iface)
        TOMsMessage = loggingUtils.TOMsLogger()

        TOMsMessage("Info - Check ...", level=Qgis.Info)
        self.assertEqual(self.signalReceived, False)

        #TODO: test setting of project variable - TOMs_Logging_Level (not sure how to get to project ...)
        TOMsMessage("Warning - Check ...", level=Qgis.Warning)
        self.assertEqual(self.signalReceived, True)

"""if __name__ == '__main__':
    unittest.main()"""

if __name__ == "__main__":
    suite = unittest.makeSuite(TOMsLoggingUtils)
    runner = unittest.TextTestRunner(verbosity=2)
    runner.run(suite)