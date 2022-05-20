/***
 * Ensure EV bays are LineString
 ***/

SELECT "GeometryID", "GeomShapeID"
FROM toms."Bays"
WHERE "RestrictionTypeID" = 124
AND "GeomShapeID" > 10;

--

UPDATE toms."Bays"
SET "GeomShapeID" = "GeomShapeID" - 20
WHERE "RestrictionTypeID" = 124
AND "GeomShapeID" > 20;