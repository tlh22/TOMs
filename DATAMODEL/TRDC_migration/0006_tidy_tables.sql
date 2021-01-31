-- deal with CPZs

ALTER TABLE toms."Bays" DISABLE TRIGGER all;
ALTER TABLE toms."Lines" DISABLE TRIGGER all;

UPDATE toms."Bays" As r
SET "CPZ" = c."CPZ"
FROM toms."ControlledParkingZones" c
WHERE ST_Within(r.geom, c.geom)
AND c."CPZ" = 'RG'
AND r."CPZ" is NULL
AND r."RestrictionTypeID" IN (101, 102, 103, 105, 110, 111, 131, 133, 134, 135);

UPDATE toms."Lines" As r
SET "CPZ" = c."CPZ"
FROM toms."ControlledParkingZones" c
WHERE ST_Within(r.geom, c.geom)
AND c."CPZ" = 'RG'
AND r."CPZ" is NULL
AND r."RestrictionTypeID" IN (225);

--
UPDATE toms."Bays"
SET "GeomShapeID" = "GeomShapeID" + 20
WHERE "RestrictionTypeID" IN (131, 133, 134, 145)
AND "GeomShapeID" < 20;

--
ALTER TABLE topography.os_mastermap_topography_polygons
    RENAME "DESCRIPT1" TO "DescGroup";

ALTER TABLE topography.os_mastermap_topography_polygons
    RENAME descterm TO "DescTerm";

ALTER TABLE topography.os_mastermap_topography_polygons
    RENAME make TO "MAKE";

ALTER TABLE toms."Bays" ENABLE TRIGGER all;
ALTER TABLE toms."Lines" ENABLE TRIGGER all;