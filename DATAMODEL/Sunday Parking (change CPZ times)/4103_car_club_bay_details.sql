/***
Car club bays to be set to Polygon
****/

ALTER TABLE toms."Bays" DISABLE TRIGGER all;

UPDATE toms_lookups."BayTypesInUse"
SET "GeomShapeGroupType" = 'Polygon'
WHERE "Code" = 108;

-- update view
REFRESH MATERIALIZED VIEW "toms_lookups"."BayTypesInUse_View";

-- Update all the geometry shapes that are LineString

UPDATE toms."Bays"
SET "GeomShapeID" = "GeomShapeID" + 20
WHERE "GeomShapeID" < 10;

ALTER TABLE toms."Bays" ENABLE TRIGGER all;