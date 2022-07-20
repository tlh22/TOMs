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

# pylint: disable=unused-argument
# lots of 'parent' argument for expressions are not used

"""

https://github.com/NathanW2/qgsexpressionsplus/blob/master/functions.py

Extra functions for QgsExpression
register=False in order to delay registring of functions before we load the plugin

*** TH: Using this code to move Expression functions into main code body

"""

import math
import random
import sys
import traceback

from qgis.core import (
    Qgis,
    QgsExpression,
    QgsGeometry,
    QgsMessageLog,
    QgsPointXY,
)
from qgis.utils import qgsfunction

from .constants import RestrictionGeometryTypes
from .core.tomsGeometryElement import ElementGeometryFactory
from .core.tomsMessageLog import TOMsMessageLog
from .generateGeometryUtils import GenerateGeometryUtils


class TOMsExpressions:
    def __init__(self):
        QgsMessageLog.logMessage(
            "Starting expressions ... ", tag="TOMs Panel", level=Qgis.Warning
        )

        self.functions = [
            self.generateDisplayGeometry,
            self.generateDisplayGeometry,
            self.generateCrossoverGeometry,
            self.getAzimuthToRoadCentreLine,
            self.getRoadName,
            self.getUSRN,
            self.generateZigZag,
            self.getWaitingLabelLeader,
            self.getLoadingLabelLeader,
            self.getBayLabelLeader,
            self.getPolygonLabelLeader,
            self.getWaitingRestrictionLabelText,
            self.getLoadingRestrictionLabelText,
            self.getBayTimePeriodLabelText,
            self.getBayMaxStayLabelText,
            self.getBayNoReturnLabelText,
            self.getBayLabelText,
            self.getCPZ,
            self.getPTA,
            self.prepareSignLine,
            self.prepareSignIconLocation,
            self.prepareSignIcon,
            self.prepareSignOrientation,
            self.generateDemandPoints,
        ]

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def generateDisplayGeometry(feature, parent):

        res = None

        try:
            res = ElementGeometryFactory.getElementGeometry(feature)

        except Exception as e:
            TOMsMessageLog.logMessage(
                "generateDisplayGeometry: error in expression function for feature "
                f'[{feature.attribute("GeometryID")}]: {e}',
                level=Qgis.Warning,
            )

        TOMsMessageLog.logMessage(
            f'generateDisplayGeometry: {feature.attribute("GeometryID")}:{res.asWkt()}',
            level=Qgis.Info,
        )
        return res

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def generateCrossoverGeometry(feature, parent):

        res = None

        try:
            res = ElementGeometryFactory.getElementGeometry(
                feature, RestrictionGeometryTypes.CROSSOVER
            )

        except Exception as e:
            TOMsMessageLog.logMessage(
                f"generateDisplayGeometry: error in expression function for feature "
                f'[{feature.attribute("GeometryID")}]: {e}',
                level=Qgis.Warning,
            )
            TOMsMessageLog.logMessage("generateDisplayGeometry", level=Qgis.Info)
            _, _, excTraceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                "generateDisplayGeometry error in expression function: "
                + str(repr(traceback.extract_tb(excTraceback))),
                level=Qgis.Info,
            )

        return res

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def getAzimuthToRoadCentreLine(feature, parent):
        # find the shortest line from this point to the road centre line layer
        # http://www.lutraconsulting.co.uk/blog/2014/10/17/getting-started-writing-qgis-python-plugins/
        # generates "closest feature" function

        # TOMsMessageLog.logMessage("In setAzimuthToRoadCentreLine(helper):", level=Qgis.Info)

        try:
            return int(GenerateGeometryUtils.calculateAzimuthToRoadCentreLine(feature))
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getAzimuthToRoadCentreLine: error in expression function "
                f'for feature [{feature.attribute("GeometryID")}]: {e}',
                level=Qgis.Warning,
            )
        return None

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def getRoadName(feature, parent):
        # Determine road name from the kerb line layer

        # TOMsMessageLog.logMessage("In getRoadName(helper):", level=Qgis.Info)
        try:
            newRoadName, _ = GenerateGeometryUtils.determineRoadName(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                f'getRoadName: error in expression function for feature [{feature.attribute("GeometryID")}]: {e}',
                level=Qgis.Warning,
            )
            newRoadName = None

        return newRoadName

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def getUSRN(feature, parent):
        # Determine road name from the kerb line layer

        # TOMsMessageLog.logMessage("In getUSRN(helper):", level=Qgis.Info)

        try:
            _, newUSRN = GenerateGeometryUtils.determineRoadName(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getUSRN: error in expression function for feature [{}]: {}".format(
                    feature.attribute("GeometryID"), e
                ),
                level=Qgis.Warning,
            )
            newUSRN = None

        return newUSRN

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def generateZigZag(feature, parent):
        # Determine road name from the kerb line layer

        try:
            res = ElementGeometryFactory.getElementGeometry(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "generate_ZigZag: error in expression function: {}".format(e),
                level=Qgis.Warning,
            )
        return res

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def getWaitingLabelLeader(feature, parent):
        # If the scale is within range (< 1250) and the label has been moved, create a line

        # TOMsMessageLog.logMessage(
        #    "In getWaitingLabelLeader ", level=Qgis.Info)
        try:
            labelLeaderGeom = GenerateGeometryUtils.generateWaitingLabelLeader(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getWaitingLabelLeader: error in expression function: {}".format(e),
                level=Qgis.Warning,
            )

        return labelLeaderGeom

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def getLoadingLabelLeader(feature, parent):
        # If the scale is within range (< 1250) and the label has been moved, create a line

        # TOMsMessageLog.logMessage(
        #    "In getLoadingLabelLeader ", level=Qgis.Info)
        try:
            labelLeaderGeom = GenerateGeometryUtils.generateLoadingLabelLeader(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getLoadingLabelLeader: error in expression function: {}".format(e),
                level=Qgis.Warning,
            )

        return labelLeaderGeom

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def getBayLabelLeader(feature, parent):
        # If the scale is within range (< 1250) and the label has been moved, create a line

        # TOMsMessageLog.logMessage("In getBayLabelLeader ", level=Qgis.Info)
        try:
            labelLeaderGeom = GenerateGeometryUtils.generateBayLabelLeader(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getBayLabelLeader: error in expression function: {}".format(e),
                level=Qgis.Warning,
            )

        return labelLeaderGeom

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def getPolygonLabelLeader(feature, parent):
        # If the scale is within range (< 1250) and the label has been moved, create a line

        # TOMsMessageLog.logMessage("In getBayLabelLeader ", level=Qgis.Info)
        try:
            labelLeaderGeom = GenerateGeometryUtils.generatePolygonLabelLeader(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getPolygonLabelLeader: error in expression function: {}".format(e),
                level=Qgis.Warning,
            )
        return labelLeaderGeom

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=False, register=True)
    def getWaitingRestrictionLabelText(feature, parent):
        # Returns the text to label the feature

        TOMsMessageLog.logMessage(
            "In getWaitingRestrictionLabelText: Feature:{}".format(
                feature.attribute("GeometryID")
            ),
            level=Qgis.Info,
        )

        try:
            (
                waitingText,
                loadingText,
            ) = GenerateGeometryUtils.getWaitingLoadingRestrictionLabelText(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getWaitingRestrictionLabelText: error in expression function: {}".format(
                    e
                ),
                level=Qgis.Warning,
            )
            TOMsMessageLog.logMessage("getWaitingRestrictionLabelText", level=Qgis.Info)
            _, _, excTraceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                "getWaitingRestrictionLabelText: error in expression function: "
                + str(repr(traceback.extract_tb(excTraceback))),
                level=Qgis.Warning,
            )

        TOMsMessageLog.logMessage(
            "In getWaitingRestrictionLabelText ****:"
            + " Waiting: "
            + str(waitingText)
            + " Loading: "
            + str(loadingText),
            level=Qgis.Info,
        )
        # waitingText = "Test"
        if waitingText:
            # labelText = "No Waiting: " + waitingText
            labelText = waitingText
            return labelText

        return None

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=False, register=True)
    def getLoadingRestrictionLabelText(feature, parent):
        # Returns the text to label the feature

        TOMsMessageLog.logMessage(
            "In getLoadingRestrictionLabelText: Feature:{}".format(
                feature.attribute("GeometryID")
            ),
            level=Qgis.Info,
        )

        try:
            (
                waitingText,
                loadingText,
            ) = GenerateGeometryUtils.getWaitingLoadingRestrictionLabelText(feature)

            TOMsMessageLog.logMessage(
                "In getLoadingRestrictionLabelText ****:"
                + " Waiting: "
                + str(waitingText)
                + " Loading: "
                + str(loadingText),
                level=Qgis.Info,
            )

        except Exception as e:
            TOMsMessageLog.logMessage(
                "getLoadingRestrictionLabelText: error in expression function: {}".format(
                    e
                ),
                level=Qgis.Warning,
            )

        if loadingText:
            # labelText = "No Loading: " + loadingText
            labelText = loadingText

            # TOMsMessageLog.logMessage("In getLoadingRestrictionLabelText: passing " + str(labelText), level=Qgis.Info)
            return labelText

        return None

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=False, register=True)
    def getBayTimePeriodLabelText(feature, parent):
        # Returns the text to label the feature

        # TOMsMessageLog.logMessage("In getBayTimePeriodLabelText:", level=Qgis.Info)

        try:
            (
                _,
                _,
                timePeriodText,
            ) = GenerateGeometryUtils.getBayRestrictionLabelText(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getBayTimePeriodLabelText: error in expression function: {}".format(e),
                level=Qgis.Warning,
            )

        # TOMsMessageLog.logMessage("In getBayTimePeriodLabelText:" + str(timePeriodText), level=Qgis.Info)

        return timePeriodText

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=False, register=True)
    def getBayMaxStayLabelText(feature, parent):
        # Returns the text to label the feature

        try:
            # TOMsMessageLog.logMessage("In getBayMaxStayLabelText:", level=Qgis.Info)
            (
                maxStayText,
                _,
                _,
            ) = GenerateGeometryUtils.getBayRestrictionLabelText(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getBayMaxStayLabelText: error in expression function: {}".format(e),
                level=Qgis.Warning,
            )

        # TOMsMessageLog.logMessage("In getBayMaxStayLabelText: " + str(maxStayText), level=Qgis.Info)

        return maxStayText

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=False, register=True)
    def getBayNoReturnLabelText(feature, parent):
        # Returns the text to label the feature

        # TOMsMessageLog.logMessage("In getBayNoReturnLabelText:", level=Qgis.Info)
        try:
            (
                _,
                noReturnText,
                _,
            ) = GenerateGeometryUtils.getBayRestrictionLabelText(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getBayNoReturnLabelText: error in expression function: {}".format(e),
                level=Qgis.Warning,
            )

        return noReturnText

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=False, register=True)
    def getBayLabelText(feature, parent):
        # Returns the text to label the feature

        TOMsMessageLog.logMessage("In getBayLabelText:", level=Qgis.Info)
        try:
            (
                maxStayText,
                noReturnText,
                timePeriodText,
            ) = GenerateGeometryUtils.getBayRestrictionLabelText(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getBayLabelText: error in expression function: {}".format(e),
                level=Qgis.Warning,
            )
            maxStayText = None
            noReturnText = None
            timePeriodText = None

        labelText = ""

        if timePeriodText:
            labelText = "{text}".format(text=timePeriodText)

        if maxStayText:
            if timePeriodText:
                labelText = labelText + ";"
            labelText = "{origText} Max Stay: {text}".format(
                origText=labelText, text=maxStayText
            )

        if noReturnText:
            if timePeriodText or maxStayText:
                labelText = labelText + ";"
            labelText = "{origText} No Return: {text}".format(
                origText=labelText, text=noReturnText
            )

        # TOMsMessageLog.logMessage("In getBayLabelText: " + str(labelText), level=Qgis.Info)

        return labelText

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def getCPZ(feature, parent):
        # Returns the CPZ for the feature - or None
        try:
            cpzNr, _ = GenerateGeometryUtils.getCurrentCPZDetails(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "getCPZ: error in expression function: {}".format(e), level=Qgis.Warning
            )

        return cpzNr

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def getPTA(feature, parent):
        # Returns the CPZ for the feature - or None

        try:
            (
                ptaName,
                _,
                _,
            ) = GenerateGeometryUtils.getCurrentPTADetails(feature)
        except Exception:
            TOMsMessageLog.logMessage("getPTA", level=Qgis.Info)
            _, _, excTraceback = sys.exc_info()
            TOMsMessageLog.logMessage(
                "getPTA: error in expression function: "
                + str(repr(traceback.extract_tb(excTraceback))),
                level=Qgis.Info,
            )

        # TOMsMessageLog.logMessage("In getPTA: PTA " + str(ptaName), level=Qgis.Info)

        return ptaName

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def prepareSignLine(feature, parent):
        newLineGeom = None
        try:
            newLineGeom, _ = GenerateGeometryUtils.getGeneratedSignLine(feature)
        except Exception as e:
            QgsMessageLog.logMessage("prepareSignLine {}".format(e), tag="TOMs Panel")
            excType, _, excTraceback = sys.exc_info()
            QgsMessageLog.logMessage(
                "prepareSignLine: error in expression function: {}{}".format(
                    excType, str(repr(traceback.extract_tb(excTraceback)))
                ),
                tag="TOMs Panel",
            )
        # QgsMessageLog.logMessage("In getPTA: PTA " + str(ptaName), tag="TOMs Panel")
        return newLineGeom

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def prepareSignIconLocation(signNr, feature, parent):

        linePts = []
        try:
            _, linePts = GenerateGeometryUtils.getGeneratedSignLine(feature)
        except Exception as e:
            QgsMessageLog.logMessage(
                "prepareSignIconLocation {}".format(e), tag="TOMs Panel"
            )
            excType, _, excTraceback = sys.exc_info()
            QgsMessageLog.logMessage(
                "prepareSignIconLocation: error in expression function: {}{}".format(
                    excType, str(repr(traceback.extract_tb(excTraceback)))
                ),
                tag="TOMs Panel",
            )
            return None

        return linePts[signNr - 1].asWkt()

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=False, register=True)
    def prepareSignIcon(signNr, feature, parent):
        iconNames = []
        try:
            iconNames = GenerateGeometryUtils.getSignIcons(feature)
        except Exception as e:
            QgsMessageLog.logMessage("prepareSignIcon {}".format(e), tag="TOMs Panel")
            _, _, excTraceback = sys.exc_info()
            QgsMessageLog.logMessage(
                "getSignIcon: error in expression function: "
                + str(repr(traceback.extract_tb(excTraceback))),
                tag="TOMs Panel",
            )
        if len(iconNames) >= signNr:
            return iconNames[signNr - 1]
        return None

    @staticmethod
    @qgsfunction(args="auto", group="TOMs2", usesgeometry=True, register=True)
    def prepareSignOrientation(feature, parent):
        signOrientation = 0
        try:
            signOrientation = GenerateGeometryUtils.getSignOrientationList(feature)
        except Exception as e:
            QgsMessageLog.logMessage(
                "prepareSignOrientation {}".format(e), tag="TOMs Panel"
            )
            _, _, excTraceback = sys.exc_info()
            QgsMessageLog.logMessage(
                "prepareSignOrientation: error in expression function: "
                + str(repr(traceback.extract_tb(excTraceback))),
                tag="TOMs Panel",
            )
        return signOrientation

    @staticmethod
    @qgsfunction(args="auto", group="TOMsDemand", usesgeometry=False, register=True)
    def generateDemandPoints(feature, parent):
        # Returns the location of points representing demand

        TOMsMessageLog.logMessage(
            "generateDemandPoints: {}".format(feature.attribute("GeometryID")),
            level=Qgis.Info,
        )

        demand = math.ceil(float(feature.attribute("Demand")))

        TOMsMessageLog.logMessage(
            "generateDemandPoints: demand: {}".format(demand), level=Qgis.Info
        )

        if demand == 0:
            return None

        capacity = int(feature.attribute("NrBays"))

        nrSpaces = capacity - demand
        nrSpaces = max(nrSpaces, 0)

        TOMsMessageLog.logMessage(
            "generateDemandPoints: capacity: {}; nrSpaces: {}; demand: {}".format(
                capacity, nrSpaces, demand
            ),
            level=Qgis.Info,
        )

        # now get geometry for demand locations

        try:
            # geomShowingSpaces = ElementGeometryFactory.getElementGeometry(newFeature)
            # TODO: for some reason the details from newFeature are not "saved" and used
            # geomShowingSpaces = ElementGeometryFactory.getElementGeometry(feature, currGeomShapeID)
            geomShowingSpaces = ElementGeometryFactory.getElementGeometry(feature)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "generateDemandPoints: error in expression function: {}".format(e),
                level=Qgis.Warning,
            )
            return None

        random.seed(
            1234
        )  # need to ramdomise, but it needs to be repeatable?!?, i.e., when you pan, they stay in the same place
        listBaysToDelete = []
        listBaysToDelete = random.sample(range(capacity), k=math.ceil(nrSpaces))

        # deal with split geometries - half on/half off
        if feature.attribute("GeomShapeID") == 22:
            for i in range(
                capacity, (capacity * 2)
            ):  # NB: range stops one before end ...
                listBaysToDelete.append(i)

        TOMsMessageLog.logMessage(
            "generateDemandPoints: bays to delete {}".format(listBaysToDelete),
            level=Qgis.Info,
        )

        centroidGeomList = []
        counter = 0
        for polygonGeom in geomShowingSpaces.parts():
            TOMsMessageLog.logMessage(
                "generateDemandPoints: considering part {}".format(counter),
                level=Qgis.Info,
            )
            if counter not in listBaysToDelete:
                centrePt = QgsPointXY(polygonGeom.centroid())
                TOMsMessageLog.logMessage(
                    "generateDemandPoints: adding centroid for {}: {}".format(
                        counter, centrePt.asWkt()
                    ),
                    level=Qgis.Info,
                )
                try:
                    centroidGeomList.append(centrePt)
                except Exception as e:
                    TOMsMessageLog.logMessage(
                        "generateDemandPoints: error adding centroid for counter {}: {}".format(
                            counter, e
                        ),
                        level=Qgis.Warning,
                    )
            counter = counter + 1

        TOMsMessageLog.logMessage(
            "generateDemandPoints: nrDemandPoints {}".format(len(centroidGeomList)),
            level=Qgis.Info,
        )

        try:
            demandPoints = QgsGeometry.fromMultiPointXY(centroidGeomList)
        except Exception as e:
            TOMsMessageLog.logMessage(
                "generateDemandPoints: error creating final geom: {}".format(e),
                level=Qgis.Warning,
            )

        return demandPoints

    def registerFunctions(self):
        tomsList = QgsExpression.Functions()
        for func in self.functions:
            TOMsMessageLog.logMessage(
                "Considering function {}".format(func.name()), level=Qgis.Info
            )
            try:
                if func in tomsList:
                    QgsExpression.unregisterFunction(func.name())
            except AttributeError:
                pass

            if QgsExpression.registerFunction(func):
                TOMsMessageLog.logMessage(
                    "Registered expression function {}".format(func.name()),
                    level=Qgis.Info,
                )

    def unregisterFunctions(self):
        # Unload all the functions that we created.
        for func in self.functions:
            QgsExpression.unregisterFunction(func.name())
            TOMsMessageLog.logMessage(
                "Unregistered expression function {}".format(func.name()),
                level=Qgis.Info,
            )
