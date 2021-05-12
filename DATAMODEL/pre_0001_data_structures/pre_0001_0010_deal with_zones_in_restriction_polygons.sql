/**
To remove CPZs and PTAs from the list of polygon types to be displayed, we need to remove them from the relevant ..InUse tables.
This requires removing any existing records (added by mistake or as test)
**/

DELETE FROM toms."RestrictionsInProposals"
WHERE "RestrictionID" IN (
SELECT "RestrictionID"
FROM toms."RestrictionPolygons"
WHERE "RestrictionTypeID" IN (20, 22));

DELETE FROM toms."RestrictionPolygons"
WHERE "RestrictionTypeID" IN (20, 22);

DELETE FROM toms_lookups."RestrictionPolygonTypesInUse"
WHERE "Code" in (20, 22);

REFRESH MATERIALIZED VIEW "toms_lookups"."RestrictionPolygonTypesInUse_View";
