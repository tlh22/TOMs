/***
 * Applying from 0032 ...
 ***/

-- To allow using 0032_adjust_inUse_constraints.sql, change over time period 5. (Not sure how it is present ...)

UPDATE toms."Lines"
SET "NoWaitingTimeID" = 12
WHERE "GeometryID" = 'L_0003956';

DELETE FROM toms_lookups."TimePeriodsInUse"
WHERE "Code" = 5;

-- Move crossovers to separate layer

SELECT setval('highway_assets."CrossingPoints_id_seq"', 1, true);

INSERT INTO highway_assets."CrossingPoints"(
	"RestrictionID", "RoadName", "USRN", "AssetConditionTypeID", "CreateDateTime", "CreatePerson", geom,
	"CrossingPointTypeID")
SELECT gen_random_uuid(), "RoadName", "USRN", 1, "CreateDateTime", "CreatePerson", geom,
    CASE "UnacceptableTypeID"
        WHEN 1 THEN 3
        WHEN 4 THEN 1
        WHEN 11 THEN 4
	END CASE
	FROM toms."Lines"
	WHERE "UnacceptableTypeID"  IN (1, 4, 11)
	AND  "RestrictionTypeID" IN (225);

-- TODO: need to join unmarked lines so that they are continuous. Currently broken for crossovers. Also consider crossovers on SYLs