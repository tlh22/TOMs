/**
setup FKs for zones
 and set permissions

**/

ALTER TABLE toms_lookups."ZoneTypesInUse"
    ADD CONSTRAINT "ZoneTypesInUse_ZoneTypes_fkey" FOREIGN KEY ("Code") REFERENCES toms_lookups."ZoneTypes" ("Code") MATCH SIMPLE;

CREATE MATERIALIZED VIEW "toms_lookups"."ZoneTypesInUse_View" AS
 SELECT "ZoneTypesInUse"."Code",
    "ZoneTypes"."Description"
   FROM "toms_lookups"."ZoneTypesInUse",
    "toms_lookups"."ZoneTypes"
  WHERE ("ZoneTypesInUse"."Code" = "ZoneTypes"."Code")
  WITH NO DATA;

ALTER TABLE "toms_lookups"."ZoneTypesInUse_View" OWNER TO "postgres";

CREATE UNIQUE INDEX "ZoneTypesInUse_View_key"
    ON toms_lookups."ZoneTypesInUse_View" USING btree
    ("Code")
    TABLESPACE pg_default;

-- set up FKs
ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."ZoneTypesInUse"("Code");

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."ZoneTypesInUse"("Code");

ALTER TABLE ONLY "toms"."MatchDayEventDayZones"
    ADD CONSTRAINT "MatchDayEventDayZones_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."ZoneTypesInUse"("Code");

-- Permissions
REVOKE ALL ON ALL TABLES IN SCHEMA toms_lookups FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;