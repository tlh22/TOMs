/***
 * report to show all restriction by CPZ
 ***/

SELECT
a."GeometryID", a."RestrictionTypeID",
"BayLineTypes"."Description" AS "RestrictionDescription",
"GeomShapeID", COALESCE("RestrictionGeomShapeTypes"."Description", '') AS "Restriction Shape Description",
a."RoadName",
       CASE WHEN (a."RestrictionTypeID" < 200 OR a."RestrictionTypeID" IN (227, 228, 229, 231)) THEN COALESCE("TimePeriods1"."Description", '')
            --ELSE COALESCE("TimePeriods2"."Description", '')
            END  AS "DetailsOfControl",
       "RestrictionLength" AS "KerblineLength",
       "NrBays" AS "MarkedBays", "Capacity" AS "TheoreticalBays",
       CASE WHEN a."RestrictionTypeID" IN (122, 162, 107, 161, 202, 218, 220, 221, 222, 209, 210, 211, 212, 213, 214, 215) THEN 0
            --WHEN "RestrictionTypeID" IN (201, 217) THEN
                --CASE WHEN "Allowable" IS NULL THEN "Capacity"
                     --ELSE 0
                     --END
            ELSE
                "Capacity"
            END AS "ParkingAvailableDuringSurveyHours", c."CPZ"

FROM
     ((((
     (SELECT *
        FROM toms."Bays"
        WHERE "OpenDate" IS NOT NULL
        AND "CloseDate" IS NULL) AS a
     LEFT JOIN "toms_lookups"."BayLineTypes" AS "BayLineTypes" ON a."RestrictionTypeID" is not distinct from "BayLineTypes"."Code")
     LEFT JOIN "toms_lookups"."RestrictionGeomShapeTypes" AS "RestrictionGeomShapeTypes" ON a."GeomShapeID" is not distinct from "RestrictionGeomShapeTypes"."Code")
     LEFT JOIN "toms_lookups"."TimePeriods" AS "TimePeriods1" ON a."TimePeriodID" is not distinct from "TimePeriods1"."Code")
     LEFT JOIN toms."ControlledParkingZones" AS c ON ST_Within(a.geom, c.geom) )

UNION

SELECT
a."GeometryID", a."RestrictionTypeID",
"BayLineTypes"."Description" AS "RestrictionDescription",
"GeomShapeID", COALESCE("RestrictionGeomShapeTypes"."Description", '') AS "Restriction Shape Description",
a."RoadName",
       CASE WHEN (a."RestrictionTypeID" < 200 OR a."RestrictionTypeID" IN (227, 228, 229, 231)) THEN COALESCE("TimePeriods1"."Description", '')
            --ELSE COALESCE("TimePeriods2"."Description", '')
            END  AS "DetailsOfControl",
       "RestrictionLength" AS "KerblineLength",
       0 AS "MarkedBays", "Capacity" AS "TheoreticalBays",
       CASE WHEN a."RestrictionTypeID" IN (122, 162, 107, 161, 202, 218, 220, 221, 222, 209, 210, 211, 212, 213, 214, 215) THEN 0
            --WHEN "RestrictionTypeID" IN (201, 217) THEN
                --CASE WHEN "Allowable" IS NULL THEN "Capacity"
                     --ELSE 0
                     --END
            ELSE
                "Capacity"
            END AS "ParkingAvailableDuringSurveyHours", c."CPZ"

FROM
     ((((
     (SELECT *
        FROM toms."Lines"
        WHERE "OpenDate" IS NOT NULL
        AND "CloseDate" IS NULL) AS a
     LEFT JOIN "toms_lookups"."BayLineTypes" AS "BayLineTypes" ON a."RestrictionTypeID" is not distinct from "BayLineTypes"."Code")
     LEFT JOIN "toms_lookups"."RestrictionGeomShapeTypes" AS "RestrictionGeomShapeTypes" ON a."GeomShapeID" is not distinct from "RestrictionGeomShapeTypes"."Code")
     LEFT JOIN "toms_lookups"."TimePeriods" AS "TimePeriods1" ON a."NoWaitingTimeID" is not distinct from "TimePeriods1"."Code")
     LEFT JOIN toms."ControlledParkingZones" AS c ON ST_Within(a.geom, c.geom) )


ORDER BY "RestrictionTypeID", "GeometryID"

