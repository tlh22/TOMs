--- Restrictions that should always be "At Any Time"
-- Cycle hangars (147), cycle hire bay (116), diplomat (112), car club (108), disabled personalised (111), Keep Clear area (146), MCL (117, 118)

UPDATE toms."Bays"
SET "TimePeriodID" = 1
WHERE "RestrictionTypeID" IN (147, 116, 112, 108, 111, 146, 117, 118);

-- DYL (202), Crossings (209-214), DRL (218), Private Road (219)
UPDATE toms."Lines"
SET "NoWaitingTimeID" = 1
WHERE "RestrictionTypeID" IN (202, 209, 210, 211, 212, 213, 214, 218, 219);


-- Restrictions that if not set, should take CPZ times
-- Disabled Blue Badge (110), P&D (103)

-- UPDATE toms."Bays" AS r  -- not really sure here
SET "TimePeriodID" = c."TimePeriodID"
FROM toms."ControlledParkingZones"
WHERE "RestrictionTypeID" IN (110, 103)
AND ST_Within(r.geom, c.geom)
AND "TimePeriodID" IS NULL;



