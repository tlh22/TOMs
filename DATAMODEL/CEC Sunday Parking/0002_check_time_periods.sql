/*
Check CPZ times
*/

SELECT "CPZ", r."TimePeriodID", t."Description", r."OpenDate"
FROM toms."ControlledParkingZones" r, toms_lookups."TimePeriods" t
WHERE r."TimePeriodID" = t."Code"
AND "OpenDate" IS NOT NULL
AND "CloseDate" IS NULL
ORDER BY "CPZ";

/*
Check timeperiods
*/

SELECT c."Code", t1."Description", c."ChangedTo", t2."Description"
FROM
(
SELECT "Code",
CASE
         WHEN "Code" = 12 THEN 311
         WHEN "Code" = 14 THEN 313
         WHEN "Code" = 33 THEN 309
         WHEN "Code" = 39 THEN 308
         WHEN "Code" = 97 THEN 315
         WHEN "Code" = 98 THEN 314
         WHEN "Code" = 99 THEN 316
         WHEN "Code" = 120 THEN 317
         WHEN "Code" = 121 THEN 312
         WHEN "Code" = 155 THEN 307
         WHEN "Code" = 159 THEN 317
         WHEN "Code" = 213 THEN 306
         WHEN "Code" = 217 THEN 310
END AS "ChangedTo"
FROM toms_lookups."TimePeriods" t
WHERE "Code" IN (12, 14, 33, 39, 97, 98, 99, 120, 121, 155, 159, 213, 217)
) As c,
toms_lookups."TimePeriods" t1, toms_lookups."TimePeriods" t2
WHERE c."Code" = t1."Code"
AND c."ChangedTo" = t2."Code"
AND t1."Description" LIKE '%Sat%';

/*
Find bays after Sunday parking details
*/

SELECT r."GeometryID", r."CPZ", r."TimePeriodID", t."Description", r."OpenDate"
FROM toms."Bays" r, toms_lookups."TimePeriods" t
WHERE r."TimePeriodID" = t."Code"
AND "OpenDate" IS NOT NULL
AND "CloseDate" IS NULL
AND "CPZ" IN ('1', '1A', '2', '3', '4')
AND "OpenDate" > '2020-11-09'
--ORDER BY "CPZ";

UNION

SELECT r."GeometryID", r."CPZ", r."NoWaitingTimeID", t."Description", r."OpenDate"
FROM toms."Lines" r, toms_lookups."TimePeriods" t
WHERE r."NoWaitingTimeID" = t."Code"
AND "OpenDate" IS NOT NULL
AND "CloseDate" IS NULL
AND "CPZ" IN ('1', '1A', '2', '3', '4')
AND "OpenDate" > '2020-11-09'
--ORDER BY "CPZ";

UNION

SELECT r."GeometryID", r."CPZ", r."TimePeriodID", t."Description", r."OpenDate"
FROM toms."RestrictionPolygons" r, toms_lookups."TimePeriods" t
WHERE r."TimePeriodID" = t."Code"
AND "OpenDate" IS NOT NULL
AND "CloseDate" IS NULL
AND "CPZ" IN ('1', '1A', '2', '3', '4')
AND "OpenDate" > '2020-11-09'
--ORDER BY "CPZ";


ORDER BY "CPZ";

-- Signs ?? need to use CPZ polygons

SELECT r."GeometryID", '', '', t."Description", r."OpenDate"
FROM toms."Signs" r, toms_lookups."SignTypes" t, toms."ControlledParkingZones" c
WHERE r."OpenDate" IS NOT NULL
AND r."CloseDate" IS NULL
AND t."Code" = r."SignType_1"
AND ST_Within (r.geom, c.geom)
AND r."OpenDate" > '2020-11-09'


-- Check map grids

SELECT *
FROM toms."MapGrids" m, toms."Bays" r
WHERE ST_Within(r.geom, m.geom)
AND r."OpenDate" IS NOT NULL
AND r."CloseDate" IS NULL
AND r."CPZ" IN ('1', '1A', '2', '3', '4')
AND r."OpenDate" > '2020-11-09'
--ORDER BY "CPZ";

UNION

SELECT r."GeometryID", r.geom
FROM toms."Lines" r, toms_lookups."TimePeriods" t
WHERE r."NoWaitingTimeID" = t."Code"
AND "OpenDate" IS NOT NULL
AND "CloseDate" IS NULL
AND "CPZ" IN ('1', '1A', '2', '3', '4')
AND "OpenDate" > '2020-11-09'
--ORDER BY "CPZ";

UNION

SELECT r."GeometryID", r.geom
FROM toms."RestrictionPolygons" r, toms_lookups."TimePeriods" t
WHERE r."TimePeriodID" = t."Code"
AND "OpenDate" IS NOT NULL
AND "CloseDate" IS NULL
AND "CPZ" IN ('1', '1A', '2', '3', '4')
AND "OpenDate" > '2020-11-09'
--ORDER BY "CPZ";




-- get restrictions that should have been changed

SELECT r."GeometryID", c."Code", t1."Description", c."ChangedTo", t2."Description"
FROM
(
SELECT "Code",
CASE
         WHEN "Code" = 12 THEN 311
         WHEN "Code" = 14 THEN 313
         WHEN "Code" = 33 THEN 309
         WHEN "Code" = 39 THEN 308
         WHEN "Code" = 97 THEN 315
         WHEN "Code" = 98 THEN 314
         WHEN "Code" = 99 THEN 316
         WHEN "Code" = 120 THEN 317
         WHEN "Code" = 121 THEN 312
         WHEN "Code" = 155 THEN 307
         WHEN "Code" = 159 THEN 317
         WHEN "Code" = 213 THEN 306
         WHEN "Code" = 217 THEN 310
END AS "ChangedTo"
FROM toms_lookups."TimePeriods" t
WHERE "Code" IN (12, 14, 33, 39, 97, 98, 99, 120, 121, 155, 159, 213, 217)
) As c,
toms_lookups."TimePeriods" t1, toms_lookups."TimePeriods" t2, toms."Bays" r
WHERE c."Code" = t1."Code"
AND c."ChangedTo" = t2."Code"
AND t1."Description" LIKE '%Sat%'
AND r."OpenDate" IS NOT NULL
AND r."CloseDate" IS NULL
AND r."CPZ" IN ('1', '1A', '2', '3', '4')
AND r."OpenDate" < '2020-11-09'
AND r."TimePeriodID" = c."Code"
;

/**
Process is:
a. add these to Proposal (??) as closed restrictions
b. set the close date to the date of Proposal (??)
c. clone these with the new time period and set open date to the date of Proposal (??)
d. add cloned details to RiP as open restrictions

**/