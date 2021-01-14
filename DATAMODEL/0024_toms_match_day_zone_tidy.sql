-- remove columns from CPZ and PTAs

ALTER TABLE toms."ControlledParkingZones"
    DROP COLUMN "MatchDayTimePeriodID";
--ALTER TABLE ONLY "toms"."ControlledParkingZones"
--    ADD CONSTRAINT "ControlledParkingZones_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");

ALTER TABLE toms."ParkingTariffAreas"
    DROP COLUMN "MatchDayTimePeriodID";
--ALTER TABLE ONLY "toms"."ParkingTariffAreas"
--    ADD CONSTRAINT "ParkingTariffAreas_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");

