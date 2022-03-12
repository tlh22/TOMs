/***
 * Lists of time periods associated with Sunday Parking
 ***/

SELECT "TimePeriodID", "TimePeriods1"."Description" AS "Description", 'Bays' AS "RestrictionType", "Nr"
FROM
    (SELECT (r."TimePeriodID"), COUNT (*) AS "Nr"
    FROM toms."Bays" r, toms."ControlledParkingZones" c
    WHERE ST_Intersects(r.geom, c.geom)
    AND r."OpenDate" IS NOT NULL
    AND r."CloseDate" IS NULL
    AND c."CPZ" IN ('1', '1A', '2', '3', '4')
	GROUP BY r."TimePeriodID") as a
    LEFT JOIN "toms_lookups"."TimePeriods" AS "TimePeriods1" ON a."TimePeriodID" is not distinct from "TimePeriods1"."Code"
UNION
SELECT "TimePeriodID", "TimePeriods1"."Description" AS "TimePeriodID", 'Lines' AS "RestrictionType", "Nr"
FROM
    (SELECT DISTINCT (r."NoWaitingTimeID") AS "TimePeriodID", COUNT (*) AS "Nr"
    FROM toms."Lines" r, toms."ControlledParkingZones" c
    WHERE ST_Intersects(r.geom, c.geom)
    AND r."OpenDate" IS NOT NULL
    AND r."CloseDate" IS NULL
    AND c."CPZ" IN ('1', '1A', '2', '3', '4')
	GROUP BY r."NoWaitingTimeID") as a
    LEFT JOIN "toms_lookups"."TimePeriods" AS "TimePeriods1" ON a."TimePeriodID" is not distinct from "TimePeriods1"."Code"
ORDER BY "TimePeriodID", "RestrictionType"

/*******/

SELECT "TimePeriodID", "TimePeriods1"."Description" AS "Description", 'Bays' AS "RestrictionType", "Nr"
FROM
    (SELECT (r."TimePeriodID"), COUNT (*) AS "Nr"
    FROM public."Bays" r, public."ControlledParkingZones" c
    WHERE ST_Intersects(r.geom, c.geom)
    AND r."OpenDate" IS NOT NULL
    AND r."CloseDate" IS NULL
    AND c."CPZ" IN ('1', '1A', '2', '3', '4')
	GROUP BY r."TimePeriodID") as a
    LEFT JOIN "public"."TimePeriods" AS "TimePeriods1" ON a."TimePeriodID" is not distinct from "TimePeriods1"."Code"
UNION
SELECT "TimePeriodID", "TimePeriods1"."Description" AS "TimePeriodID", 'Lines' AS "RestrictionType", "Nr"
FROM
    (SELECT DISTINCT (r."NoWaitingTimeID") AS "TimePeriodID", COUNT (*) AS "Nr"
    FROM public."Lines" r, public."ControlledParkingZones" c
    WHERE ST_Intersects(r.geom, c.geom)
    AND r."OpenDate" IS NOT NULL
    AND r."CloseDate" IS NULL
    AND c."CPZ" IN ('1', '1A', '2', '3', '4')
	GROUP BY r."NoWaitingTimeID") as a
    LEFT JOIN "public"."TimePeriods" AS "TimePeriods1" ON a."TimePeriodID" is not distinct from "TimePeriods1"."Code"
ORDER BY "TimePeriodID", "RestrictionType"