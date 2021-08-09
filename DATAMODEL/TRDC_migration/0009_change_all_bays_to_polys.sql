/***
Change all bays to polygons
***/

-- Change details inUse

UPDATE toms_lookups."BayTypesInUse"
	SET "GeomShapeGroupType" = 'Polygon'
	WHERE "GeomShapeGroupType" = 'LineString';

-- Change details in Bays

UPDATE toms."Bays"
SET "GeomShapeID" = "GeomShapeID" + 20
WHERE "GeomShapeID" < 10;

-- Refresh view

REFRESH MATERIALIZED VIEW "toms_lookups"."BayTypesInUse_View";