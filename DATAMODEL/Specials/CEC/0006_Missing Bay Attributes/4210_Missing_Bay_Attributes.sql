/****
 * deal with bays with missing attributes:
 * - RoadNames/USRN
 * - control times
 ***/

UPDATE toms."Bays" AS c
SET "RoadName" = closest."RoadName", "USRN" = closest."USRN"
FROM (SELECT DISTINCT ON (s."GeometryID") s."GeometryID" AS id, cl."RoadName" AS "RoadName", cl."USRN" AS "USRN",
      --ST_ClosestPoint(cl.geom, ST_LineInterpolatePoint(s.geom, 0.5)) AS geom,
      ST_Distance(cl.geom, ST_LineInterpolatePoint(s.geom, 0.5)) AS length
      FROM local_authority."StreetGazetteerRecords" cl, toms."Bays" s
      ORDER BY s."GeometryID", length) AS closest
WHERE c."RoadName" IS NULL
AND c."GeometryID" = closest.id


-- Check "B_ 0078760". This is in the middle of a field

/***
 108 = Car CLub Bay
 110 = Disabled Blue Badge
 111 = Disabled Bay - personalised
 112 = Diplomatic Only Bay
 119 = On-carriageway Bicycle Bay
 120 = Police Bay
 124 = Electric Vehicle Charging Place
 126 = Limited Waiting
 168 = RNLI Permit Holders Only
***/

UPDATE toms."Bays" AS r
SET "TimePeriodID" = 1
WHERE "TimePeriodID" = 0
AND "RestrictionTypeID" IN (108, 110, 111, 112, 119, 120, 124, 126, 168);

/***
 -- Deal with these individually
 101 = Resident Permit Holders (B_57058, B_57059) - are these really res bays
 114 = Loading Bay (B_56200)
 131 = Permit Holder Bay
 134 = Shared Use (Permit Holders)
***/

UPDATE toms."Bays"
SET "CPZ" = 'S1'
WHERE "GeometryID" = 'B_58255';

UPDATE toms."Bays"
SET "CPZ" = 'S4'
WHERE "GeometryID" = 'B_58546';

UPDATE toms."Bays" AS r
SET "CPZ" = c."CPZ"
FROM toms."ControlledParkingZones" c
WHERE ST_Within(r.geom, c.geom)
AND c."CPZ" IS NULL
AND r."OpenDate" IS NOT NULL;

UPDATE toms."Bays" AS r
SET "TimePeriodID" = c."TimePeriodID"
FROM toms."ControlledParkingZones" c
WHERE r."CPZ" = c."CPZ"
AND r."RestrictionTypeID" IN (131, 134)
AND r."TimePeriodID" IS NULL;

/***
 * CPZ hours:
   - S6 ()
***/