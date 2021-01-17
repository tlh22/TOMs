-- for the moment, keep things simple. Copy CPZ table and add a new column relating to MatchDay zone into restriction tables ...

-- ** a better way might be to include all all zones include RestrictionPolygons and then amend the functions to pick up the CPZ/PTA/ED details

DROP TABLE IF EXISTS toms."MatchDayEventDayZones" CASCADE;

-- SEQUENCE: toms.MatchDayEventDayZones_id_seq

DROP SEQUENCE IF EXISTS toms."MatchDayEventDayZones_id_seq" CASCADE;

CREATE SEQUENCE toms."MatchDayEventDayZones_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE toms."MatchDayEventDayZones_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms."MatchDayEventDayZones_id_seq" TO postgres;

GRANT SELECT, USAGE ON SEQUENCE toms."MatchDayEventDayZones_id_seq" TO toms_admin;

GRANT SELECT, USAGE ON SEQUENCE toms."MatchDayEventDayZones_id_seq" TO toms_operator;

GRANT SELECT, USAGE ON SEQUENCE toms."MatchDayEventDayZones_id_seq" TO toms_public;

-- Table: toms.MatchDayEventDayZones

-- DROP TABLE toms."MatchDayEventDayZones";

CREATE TABLE toms."MatchDayEventDayZones"
(
    "RestrictionID" character varying(254) COLLATE pg_catalog."default" NOT NULL,
    "GeometryID" character varying(12) COLLATE pg_catalog."default" NOT NULL DEFAULT ('C_'::text || to_char(nextval('toms."MatchDayEventDayZones_id_seq"'::regclass), '000000000'::text)),
    geom geometry(Polygon,27700) NOT NULL,
    "RestrictionTypeID" integer NOT NULL,
    "Notes" character varying(254) COLLATE pg_catalog."default",
    "Photos_01" character varying(255) COLLATE pg_catalog."default",
    "Photos_02" character varying(255) COLLATE pg_catalog."default",
    "Photos_03" character varying(255) COLLATE pg_catalog."default",
    "label_X" double precision,
    "label_Y" double precision,
    "label_Rotation" double precision,
    "label_TextChanged" character varying(254) COLLATE pg_catalog."default",
    "OpenDate" date,
    "CloseDate" date,
    "EDZ" character varying(40) COLLATE pg_catalog."default",
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "LabelText" character varying(254) COLLATE pg_catalog."default",
    "TimePeriodID" integer,
    "ComplianceRoadMarkingsFaded" integer,
    "ComplianceRestrictionSignIssue" integer,
    "ComplianceNotes" character varying(254) COLLATE pg_catalog."default",
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254) COLLATE pg_catalog."default",
    "CreateDateTime" timestamp without time zone NOT NULL,
    "CreatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    label_pos geometry(MultiPoint,27700),
    label_ldr geometry(MultiLineString,27700),
    CONSTRAINT "MatchDayEventDayZones_pkey" PRIMARY KEY ("RestrictionID"),
    CONSTRAINT "MatchDayEventDayZones_GeometryID_key" UNIQUE ("GeometryID"),
    CONSTRAINT "MatchDayEventDayZones_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue")
        REFERENCES compliance_lookups."Restriction_SignIssueTypes" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "MatchDayEventDayZones_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded")
        REFERENCES compliance_lookups."RestrictionRoadMarkingsFadedTypes" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "MatchDayEventDayZones_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID")
        REFERENCES compliance_lookups."MHTC_CheckIssueTypes" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "MatchDayEventDayZones_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID")
        REFERENCES toms_lookups."TimePeriods" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE toms."MatchDayEventDayZones"
    OWNER to postgres;

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE toms."MatchDayEventDayZones" TO toms_admin;
GRANT SELECT ON TABLE toms."MatchDayEventDayZones" TO toms_public;
GRANT SELECT ON TABLE toms."MatchDayEventDayZones" TO toms_operator;
GRANT ALL ON TABLE toms."MatchDayEventDayZones" TO postgres;

ALTER TABLE toms."MatchDayEventDayZones"
    ALTER COLUMN "EDZ" SET NOT NULL;

ALTER TABLE toms."MatchDayEventDayZones"
    ADD CONSTRAINT "EDZ" UNIQUE ("EDZ");

-- Index: controlledparkingzones_geom_idx

-- DROP INDEX toms.controlledparkingzones_geom_idx;

CREATE INDEX MatchDayEventDayZones_geom_idx
    ON toms."MatchDayEventDayZones" USING gist
    (geom)
    TABLESPACE pg_default;

-- add to GeometryID function

CREATE OR REPLACE FUNCTION "public"."create_geometryid"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	 nextSeqVal varchar := '';
BEGIN

	CASE TG_TABLE_NAME
	WHEN 'Bays' THEN
			SELECT concat('B_', to_char(nextval('toms."Bays_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'Lines' THEN
		   SELECT concat('L_', to_char(nextval('toms."Lines_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'Signs' THEN
		   SELECT concat('S_', to_char(nextval('toms."Signs_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'RestrictionPolygons' THEN
		   SELECT concat('P_', to_char(nextval('toms."RestrictionPolygons_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'ControlledParkingZones' THEN
		   SELECT concat('C_', to_char(nextval('toms."ControlledParkingZones_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'ParkingTariffAreas' THEN
		   SELECT concat('T_', to_char(nextval('toms."ParkingTariffAreas_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'MatchDayEventDayZones' THEN
		   SELECT concat('E_', to_char(nextval('toms."MatchDayEventDayZones_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	ELSE
	    nextSeqVal = 'U';
	END CASE;

    NEW."GeometryID" := nextSeqVal;
	RETURN NEW;

END;
$$;

-- Trigger: create_geometryid_bays

-- DROP TRIGGER create_geometryid_bays ON toms."MatchDayEventDayZones";

CREATE TRIGGER create_geometryid_bays
    BEFORE INSERT
    ON toms."MatchDayEventDayZones"
    FOR EACH ROW
    EXECUTE PROCEDURE public.create_geometryid();

-- Trigger: insert_mngmt

-- DROP TRIGGER insert_mngmt ON toms."MatchDayEventDayZones";

CREATE TRIGGER insert_mngmt
    BEFORE INSERT OR UPDATE
    ON toms."MatchDayEventDayZones"
    FOR EACH ROW
    EXECUTE PROCEDURE toms.labelling_for_restrictions();

-- Trigger: set_create_details_MatchDayEventDayZones

-- DROP TRIGGER "set_create_details_MatchDayEventDayZones" ON toms."MatchDayEventDayZones";

CREATE TRIGGER "set_create_details_MatchDayEventDayZones"
    BEFORE INSERT
    ON toms."MatchDayEventDayZones"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_create_details();

-- Trigger: set_last_update_details_MatchDayEventDayZones

-- DROP TRIGGER "set_last_update_details_MatchDayEventDayZones" ON toms."MatchDayEventDayZones";

CREATE TRIGGER "set_last_update_details_MatchDayEventDayZones"
    BEFORE INSERT OR UPDATE
    ON toms."MatchDayEventDayZones"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_last_update_details();

ALTER TABLE toms."Bays"
    ADD COLUMN "MatchDayEventDayZone" character varying(40) COLLATE pg_catalog."default";
ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_MatchDayEventDayZone_fkey" FOREIGN KEY ("MatchDayEventDayZone") REFERENCES "toms"."MatchDayEventDayZones"("EDZ");

ALTER TABLE toms."Lines"
    ADD COLUMN "MatchDayEventDayZone" character varying(40) COLLATE pg_catalog."default";
ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_MatchDayEventDayZone_fkey" FOREIGN KEY ("MatchDayEventDayZone") REFERENCES "toms"."MatchDayEventDayZones"("EDZ");

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "MatchDayEventDayZone" character varying(40) COLLATE pg_catalog."default";
ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionPolygons_MatchDayEventDayZone_fkey" FOREIGN KEY ("MatchDayEventDayZone") REFERENCES "toms"."MatchDayEventDayZones"("EDZ");

-- ** Could also add to TOMs