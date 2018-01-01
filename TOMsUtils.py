from PyQt4.QtGui import *
from PyQt4.QtCore import *
from qgis.core import *
from qgis.gui import *

def setupLayers(self):
    """ Set up relevant layers.
    """
    
    if QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer"):
        TOMsLayer = QgsMapLayerRegistry.instance().mapLayersByName("TOMs_Layer")[0]
    else:
        QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table TOMs_Layer is not present"))
        raise LayerNotPresent

    if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionTypes"):
        self.RestrictionTypesLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionTypes")[0]
    else:
        QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table RestrictionTypes is not present"))
        raise LayerNotPresent

    if QgsMapLayerRegistry.instance().mapLayersByName("TimePeriods"):
        self.TimePeriodsLayer = QgsMapLayerRegistry.instance().mapLayersByName("TimePeriods")[0]
    else:
        QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table TimePeriods is not present"))
        raise LayerNotPresent

    if QgsMapLayerRegistry.instance().mapLayersByName("LengthOfTime"):
        self.LengthOfTimeLayer = QgsMapLayerRegistry.instance().mapLayersByName("LengthOfTime")[0]
    else:
        QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table LengthOfTime is not present"))
        raise LayerNotPresent

    if QgsMapLayerRegistry.instance().mapLayersByName("PaymentTypes"):
        self.PaymentTypesLayer = QgsMapLayerRegistry.instance().mapLayersByName("PaymentTypes")[0]
    else:
        QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table PaymentTypes is not present"))
        raise LayerNotPresent

    if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionGeometryTypes"):
        self.RestrictionGeometryTypesLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionGeometryTypes")[0]
    else:
        QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table RestrictionGeometryTypes is not present"))
        raise LayerNotPresent

    if QgsMapLayerRegistry.instance().mapLayersByName("RestrictionStatus"):
        self.ResStateLayer = QgsMapLayerRegistry.instance().mapLayersByName("RestrictionStatus")[0]
    else:
        QMessageBox.information(self.iface.mainWindow(),"ERROR", ("Table RestrictionStatus is not present"))
        raise LayerNotPresent

def setupTOMsLayerFields(self):
    # Set up field details for table  ** what about errors here **
    
    idxGeometryID = self.TOMsLayer.fieldNameIndex("GeometryID")
    idxOrderTypeID = self.TOMsLayer.fieldNameIndex("OrderTypeID")
    idxTimePeriodID = self.TOMsLayer.fieldNameIndex("TimePeriodID")
    idxMaxStayID = self.TOMsLayer.fieldNameIndex("MaxStayID")
    idxNoReturnID = self.TOMsLayer.fieldNameIndex("NoReturnID")
    idxPaymentTypeID = self.TOMsLayer.fieldNameIndex("PaymentTypeID")
    idxGeomTypeID = self.TOMsLayer.fieldNameIndex("GeomTypeID")
    idxRescindDate = self.TOMsLayer.fieldNameIndex("RescindDate")
    idxEffectiveDate = self.TOMsLayer.fieldNameIndex("EffectiveDate")
    idxRestrictionStatusID = self.TOMsLayer.fieldNameIndex("RestrictionStatusID")
    idxOrientation = self.TOMsLayer.fieldNameIndex("Orientation")
    idxAzimuthToRoadCentreline = self.TOMsLayer.fieldNameIndex("AzimuthToRoadCentreline")
    idxChangeNotes = self.TOMsLayer.fieldNameIndex("ChangeNotes")
    '''
    idxGeometryID = TOMsLayer.fieldNameIndex("GeometryID")
    idxOrderTypeID = TOMsLayer.fieldNameIndex("OrderTypeID")
    idxTimePeriodID = TOMsLayer.fieldNameIndex("TimePeriodID")
    idxMaxStayID = TOMsLayer.fieldNameIndex("MaxStayID")
    idxNoReturnID = TOMsLayer.fieldNameIndex("NoReturnID")
    idxPaymentTypeID = TOMsLayer.fieldNameIndex("PaymentTypeID")
    idxGeomTypeID = TOMsLayer.fieldNameIndex("GeomTypeID")
    idxRescindDate = TOMsLayer.fieldNameIndex("RescindDate")
    idxEffectiveDate = TOMsLayer.fieldNameIndex("EffectiveDate")
    idxRestrictionStatusID = TOMsLayer.fieldNameIndex("RestrictionStatusID")
    idxOrientation = TOMsLayer.fieldNameIndex("Orientation")
    idxAzimuthToRoadCentreline = TOMsLayer.fieldNameIndex("AzimuthToRoadCentreline")
    idxChangeNotes = TOMsLayer.fieldNameIndex("ChangeNotes")
    '''
    
    
 




