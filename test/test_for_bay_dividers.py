-- test script for bay dividers (to be run in console)

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

# test = []
# test = outputGeometries
# for geom in outputGeometries:
#    test.append(geom)

newGeom = QgsGeometry()
newGeom = outputGeometries[0]
for i in range(1, len(outputGeometries)):
    # newGeom.addPart(test[i].asPolygon(), QgsWkbTypes.PolygonGeometry)
    newGeom.addPartGeometry(outputGeometries[i])

for geom in newGeom.parts():
    print(geom.asWkt())