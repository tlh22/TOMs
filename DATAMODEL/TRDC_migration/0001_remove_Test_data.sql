-- Start with existing database
-- "C:\Program Files\PostgreSQL\12\bin\psql" -U postgres -p 5433 -d TRDC_Master -f "C:\Users\marie_000\Documents\MHTC\TRDC_210129_2.sql"

-- Add existing test database - assuming this includes current versions of all relevant lookups Time Periods, Additional Condition Types, etc

DELETE FROM toms."RestrictionsInProposals";
DELETE FROM toms."TilesInAcceptedProposals";
DELETE FROM toms."Proposals";

DELETE FROM toms."Bays";
DELETE FROM toms."Lines";
DELETE FROM toms."Signs";
DELETE FROM toms."RestrictionPolygons";
DELETE FROM toms."ControlledParkingZones";
DELETE FROM toms."ParkingTariffAreas";
DELETE FROM toms."MatchDayEventDayZones";
DELETE FROM toms."MapGrid";

-- Reset counters

SELECT pg_catalog.setval('"toms"."Proposals_id_seq"', 1, false);

SELECT pg_catalog.setval('"toms"."Bays_id_seq"', 1, false);
SELECT pg_catalog.setval('"toms"."Lines_id_seq"', 1, false);
SELECT pg_catalog.setval('"toms"."Signs_id_seq"', 1, false);
SELECT pg_catalog.setval('"toms"."RestrictionPolygons_id_seq"', 1, false);
SELECT pg_catalog.setval('"toms"."ControlledParkingZones_id_seq"', 1, false);
SELECT pg_catalog.setval('"toms"."ParkingTariffAreas_id_seq"', 1, false);
SELECT pg_catalog.setval('"toms"."MatchDayEventDayZones_id_seq"', 1, false);
