"""
Test scripts for console

"""


from qgis.PyQt.QtWidgets import (
    QMessageBox,
    QAction,
    QDialogButtonBox,
    QLabel,
    QDockWidget, QDialog
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
    qVersion, QVariant
)

from qgis.core import (
    QgsExpressionContextUtils,
    QgsExpression,
    QgsFeatureRequest,
    # QgsMapLayerRegistry,
    QgsMessageLog, QgsFeature, QgsGeometry,
    QgsTransaction, QgsTransactionGroup,
    QgsProject, QgsWkbTypes,
    QgsApplication, QgsRectangle, QgsPoint, QgsPointXY, QgsVectorLayer, QgsField
)

# https://gis.stackexchange.com/questions/54057/reading-attribute-values-using-pyqgis

currLayer = QgsProject.instance().mapLayersByName('Lines')[0]
fid = 1 # the second feature (zero based indexing!)
iterator = currLayer.getFeatures(QgsFeatureRequest().setFilterFid(fid))
currRestriction = next(iterator)
print('Curr feature: {}'.format(currRestriction["GeometryID"]))

####

layerEditFormConfig = currLayer.editFormConfig()
ui_path = layerEditFormConfig.uiForm()
init_path = layerEditFormConfig.initFilePath()

print('Form path: {}; {}'.format(ui_path, init_path))

widget_config = layerEditFormConfig.widgetConfig('AdditionalConditionID')
print('widget_config: {}'.format(widget_config))

data_details = layerEditFormConfig.dataDefinedFieldProperties('AdditionalConditionID').count()
print('data_details: {}'.format(data_details))

###

layerEditFormConfig.setUiForm('')
#layerEditFormConfig.setLayout(0)
currLayer.setEditFormConfig(layerEditFormConfig)  # To make changes, need to rest the editConfig ...
print('layout: {}'.format(currLayer.editFormConfig().layout()))

newForm = 'C:\\Users\\marie_000\\AppData\\Roaming\\QGIS\\QGIS3\\profiles\\default\\python\\plugins\\TOMs\\test\\promoteWidget\\test.ui'
layerEditFormConfig.setUiForm(newForm)
currLayer.setEditFormConfig(layerEditFormConfig)
print('layout: {}; path: {}'.format(currLayer.editFormConfig().layout(), currLayer.editFormConfig().uiForm()))

""" At this point, the form is still not loading with the custom widget """
###

iface.preloadForm(newForm)

###

idxAdditionalConditionID = currLayer.fields().indexFromName("AdditionalConditionID")
widget_setup = currLayer.editorWidgetSetup(idxAdditionalConditionID)
print('widget type: {}'.format(widget_setup.type()))

### now deal with the dialog

import TOMs.test.promoteWidget.thWidgets

restrictionDialog = iface.getFeatureForm(currLayer, currRestriction)

restrictionDialog.findChildren(QPushButton)
restrictionDialog.findChildren(QgsCheckableComboBox)
restrictionDialog.findChildren(TOMs.test.promoteWidget.thWidgets.thPushButton)

restrictionDialog.findChild(QgsCheckableComboBox, "AdditionalConditionID")
restrictionDialog.findChild(TOMs.test.promoteWidget.thWidgets.thPushButton, "pushButton")

for widget in restrictionDialog.findChildren(QComboBox):
    print ('Widget: {}:'.format(widget.objectName()))

for widget in restrictionDialog.findChildren(TOMs.test.promoteWidget.thWidgets.thPushButton):
    print ('Widget: {}: {}'.format(widget.objectName(), widget.text()))

for widget in restrictionDialog.findChildren(QgsCheckableComboBox):
    print ('Widget: {}: {}'.format(widget.objectName(), widget.text()))

#####
Next steps are:
 - create a customised plug
raise issue in QGIS forums