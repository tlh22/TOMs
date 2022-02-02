/***
 * Correct details from initial collection
 ***/

-- Deal with Mon-Fri 8.00am-6.30pm

-- Disable triggers

ALTER TABLE toms."Lines" DISABLE TRIGGER ALL;
ALTER TABLE toms."Bays" DISABLE TRIGGER ALL;

UPDATE toms."Lines" r
SET "NoWaitingTimeID" = 39 -- Mon-Sat 8.00am-6.30pm
FROM toms."ControlledParkingZones" c
WHERE r."NoWaitingTimeID" = 14 -- Mon-Fri 8.00am-6.30pm
AND c."CPZ" IN ('1' ,  '1A' ,  '2' ,  '3' , '4')
AND ST_WITHIN (r.geom, c.geom);

UPDATE toms."Lines" r
SET "NoWaitingTimeID" = 33 -- Mon-Sat 8.30am-6.30pm
FROM toms."ControlledParkingZones" c
WHERE r."NoWaitingTimeID" = 12 -- Mon-Fri 8.30am-6.30pm
AND c."CPZ" IN ('1' ,  '1A' ,  '2' ,  '3' , '4')
AND ST_WITHIN (r.geom, c.geom);

UPDATE toms."Lines" r
SET "NoWaitingTimeID" = 308 -- Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm
FROM toms."ControlledParkingZones" c
WHERE r."NoWaitingTimeID" = 313 -- Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm
AND c."CPZ" IN ('1' ,  '1A' ,  '2' ,  '3' , '4')
AND ST_WITHIN (r.geom, c.geom);

UPDATE toms."Lines" r
SET "NoWaitingTimeID" = 309 -- Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm
FROM toms."ControlledParkingZones" c
WHERE r."NoWaitingTimeID" = 311 -- Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm
AND c."CPZ" IN ('1' ,  '1A' ,  '2' ,  '3' , '4')
AND ST_WITHIN (r.geom, c.geom);

-- *** Tidy individual restrictions

-- This should be a DYL
UPDATE toms."Lines" r
SET "NoWaitingTimeID" = 1, "RestrictionTypeID" = 202
WHERE "GeometryID" = 'L_112346';

-- Change CPZ for these
UPDATE toms."Lines" r
SET "CPZ" = '8'
WHERE "GeometryID" IN ('L_ 0139342', 'L_117638', 'L_110834');

UPDATE toms."Lines" r
SET "CPZ" = '5'
WHERE "GeometryID" IN ('L_118761');

UPDATE toms."Lines" r
SET "CPZ" = '5A'
WHERE "GeometryID" IN ('L_14804');

UPDATE toms."Lines" r
SET "CPZ" = '1A'
WHERE "GeometryID" IN ('L_14802');

-- Bays

UPDATE toms."Bays" r
SET "TimePeriodID" = 33 -- Mon-Sat 8.30am-6.30pm
FROM toms."ControlledParkingZones" c
WHERE r."TimePeriodID" = 12 -- Mon-Fri 8.30am-6.30pm
AND c."CPZ" IN ('1' ,  '1A' ,  '2' ,  '3' , '4')
AND ST_WITHIN (r.geom, c.geom);

ALTER TABLE toms."Lines" ENABLE TRIGGER ALL;
ALTER TABLE toms."Bays" ENABLE TRIGGER ALL;

