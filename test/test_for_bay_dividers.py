-- test script for bay dividers (to be run in console)

-- for polygons

testPolygon = QgsGeometry.fromPolygonXY(
    [[QgsPointXY(0, 0), QgsPointXY(3, 0), QgsPointXY(3, 1), QgsPointXY(0, 1), QgsPointXY(0, 0)]]
)
cutList1 = [QgsPointXY(1, 0), QgsPointXY(1, 1)]
cutLine1 = QgsGeometry.fromPolylineXY(cutList1)
cutList2 = [QgsPointXY(2, 0), QgsPointXY(2, 1)]
cutLine2 = QgsGeometry.fromPolylineXY(cutList2)
cutListGeoms = []
cutListGeoms.append(cutLine1)
cutListGeoms.append(cutLine2)
# cutGeom = cutLine1.combine(cutLine2)
outputGeometries = [testPolygon]
for divider in cutListGeoms:
    # divGeometry = QgsGeometry()
    newGeomsList = []
    for outGeom in outputGeometries:
        result, extraGeometriesList, topologyTestPointsList = outGeom.splitGeometry(
            divider.asPolyline(), True)
        newGeomsList.append(outGeom)
        for geom in extraGeometriesList:
            newGeomsList.append(geom)
    outputGeometries = newGeomsList

assertEqual(outputGeometries.wkbType(), QgsWkbTypes.MultiPolygon)
assert ...

# for linestring
testLineString = QgsGeometry.fromPolylineXY(
            [QgsPointXY(0, 0), QgsPointXY(1, 0), QgsPointXY(2, 0), QgsPointXY(3, 0)]
        )
cutList1 = [QgsPointXY(1, 0), QgsPointXY(1, 1)]
cutLine1 =  QgsGeometry.fromPolylineXY(cutList1)
cutList2 =  [QgsPointXY(2, 0), QgsPointXY(2, 1)]
cutLine2 =  QgsGeometry.fromPolylineXY(cutList2)

geomList = []
geomList.append(testLineString)
geomList.append(cutLine1)
geomList.append(cutLine2)

newGeom = geomList[0]
newGeom.convertToMultiType()
print (newGeom)
for i in range(1, len(geomList)):
    geomList[i].convertToMultiType()
    newGeom = newGeom.combine(geomList[i])
    print (newGeom)

assertEqual(newGeom.wkbType(), QgsWkbTypes.MultiLineString)
assert ...