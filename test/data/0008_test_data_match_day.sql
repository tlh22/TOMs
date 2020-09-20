-- Add new time period

INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (224);

REFRESH MATERIALIZED VIEW "toms_lookups"."TimePeriodsInUse_View";

UPDATE "toms"."ControlledParkingZones"
SET "MatchDayTimePeriodID" = 224
WHERE "CPZ" = 'B';

--- TODO: Create a new restriction with the matchday time period
