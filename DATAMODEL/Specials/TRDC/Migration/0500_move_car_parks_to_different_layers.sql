/***
 * Move details from car parks
 ***/

INSERT INTO toms_lookups."BayLineTypes" ("Code", "Description")
SELECT DISTINCT "RestrictionTypeID" + 400, CONCAT(l."Description", ' - in car park')
FROM toms."Bays" r, toms_lookups."BayLineTypes" l
WHERE r."RestrictionTypeID" = l."Code"
AND "RoadName" LIKE '%Car Park';

INSERT INTO toms_lookups."BayTypesInUse" ("Code", "GeomShapeGroupType")
SELECT DISTINCT "RestrictionTypeID" + 400 AS "Code", 'Polygon' as "GeomShapeGroupType"
FROM toms."Bays" r, toms_lookups."BayLineTypes" l
WHERE r."RestrictionTypeID" = l."Code"
AND "RoadName" LIKE '%Car Park';

UPDATE toms."Bays"
SET "RestrictionTypeID" = "RestrictionTypeID" + 400
WHERE "RoadName" LIKE '%Car Park'