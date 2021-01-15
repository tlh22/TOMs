-- ** not quite sure how to proceed ??

-- move CPZs and PTAs into PolygonRestrictions ??


-- create a new table called "zones" that merges details for CPZs and PTAs. Also allows for inclusion of MatchDay/EventDay zones








-- change not null for CPZ name

ALTER TABLE toms."ControlledParkingZones"
    ALTER COLUMN "CPZ" SET NOT NULL;

-- create zone types

