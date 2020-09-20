ALTER TABLE toms."Bays"
    ADD COLUMN "MatchDayTimePeriodID" integer;
ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");

ALTER TABLE toms."Lines"
    ADD COLUMN "MatchDayTimePeriodID" integer;
ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "MatchDayTimePeriodID" integer;
ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionPolygons_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "MatchDayTimePeriodID" integer;
ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "MatchDayTimePeriodID" integer;
ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");
