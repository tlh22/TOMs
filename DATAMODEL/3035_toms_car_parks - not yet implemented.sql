/**
Add car parks. Consider to be (zone) polygon

** not yet implemented - currently using type of restrictionPoly. Perhaps could use
**/

CREATE SEQUENCE "toms"."CarParks_id_seq"
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "toms"."CarParks_id_seq" OWNER TO "postgres";

GRANT ALL ON SEQUENCE toms."CarParks_id_seq" TO postgres;
GRANT SELECT, USAGE ON SEQUENCE toms."CarParks_id_seq" TO toms_admin;
GRANT SELECT, USAGE ON SEQUENCE toms."CarParks_id_seq" TO toms_operator;
GRANT SELECT, USAGE ON SEQUENCE toms."CarParks_id_seq" TO toms_public;

CREATE TABLE toms."CarParks"
(
    "RestrictionID" character varying(254) COLLATE pg_catalog."default" NOT NULL,
    "GeometryID" character varying(12) COLLATE pg_catalog."default" NOT NULL DEFAULT ('Q_'::text || to_char(nextval('toms."CarParks_id_seq"'::regclass), 'FM0000000'::text)),
    geom geometry(Polygon,27700) NOT NULL,
    "RestrictionTypeID" integer NOT NULL,
    "GeomShapeID" integer NOT NULL,
    "Notes" character varying(254) COLLATE pg_catalog."default",
    "Photos_01" character varying(255) COLLATE pg_catalog."default",
    "Photos_02" character varying(255) COLLATE pg_catalog."default",
    "Photos_03" character varying(255) COLLATE pg_catalog."default",
    "RoadName" character varying(254) COLLATE pg_catalog."default",
    "USRN" character varying(254) COLLATE pg_catalog."default",
    "label_Rotation" double precision,
    "label_TextChanged" character varying(254) COLLATE pg_catalog."default",
    "OpenDate" date,
    "CloseDate" date,
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "Orientation" integer,
    "LabelText" character varying(254) COLLATE pg_catalog."default",
    "NoWaitingTimeID" integer,
    "NoLoadingTimeID" integer,
    "TimePeriodID" integer,
    "AreaPermitCode" character varying(254) COLLATE pg_catalog."default",
    "CPZ" character varying(40) COLLATE pg_catalog."default",
    "ComplianceRoadMarkingsFaded" integer,
    "ComplianceRestrictionSignIssue" integer,
    "ComplianceNotes" character varying(254) COLLATE pg_catalog."default",
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254) COLLATE pg_catalog."default",
    "MatchDayTimePeriodID" integer,
    "CreateDateTime" timestamp without time zone NOT NULL,
    "CreatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "AdditionalConditionID" integer,
    label_pos geometry(MultiPoint,27700),
    label_ldr geometry(MultiLineString,27700),
    "MatchDayEventDayZone" character varying(40) COLLATE pg_catalog."default",
    "Name" character varying(254) COLLATE pg_catalog."default",
    "NrPandDBays" integer,
    "NrPermitBays" integer,
    "NrDisabledBays" integer,
    "NrSharedUseBays" integer,
    "NrUnmarkedBays" integer,
    CONSTRAINT "CarParks_pk" PRIMARY KEY ("RestrictionID"),
    CONSTRAINT "CarParks_GeometryID_key" UNIQUE ("GeometryID"),
    CONSTRAINT "CarParks_MatchDayEventDayZone_fkey" FOREIGN KEY ("MatchDayEventDayZone")
        REFERENCES toms."MatchDayEventDayZones" ("EDZ") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CarParks_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID")
        REFERENCES toms_lookups."TimePeriodsInUse" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CarParks_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue")
        REFERENCES compliance_lookups."Restriction_SignIssueTypes" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CarParks_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded")
        REFERENCES compliance_lookups."RestrictionRoadMarkingsFadedTypes" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CarParks_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID")
        REFERENCES toms_lookups."RestrictionGeomShapeTypes" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CarParks_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID")
        REFERENCES compliance_lookups."MHTC_CheckIssueTypes" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CarParks_NoLoadingTimeID_fkey" FOREIGN KEY ("NoLoadingTimeID")
        REFERENCES toms_lookups."TimePeriods" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CarParks_NoWaitingTimeID_fkey" FOREIGN KEY ("NoWaitingTimeID")
        REFERENCES toms_lookups."TimePeriods" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CarParks_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID")
        REFERENCES toms_lookups."RestrictionPolygonTypesInUse" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CarParks_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID")
        REFERENCES toms_lookups."TimePeriods" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE toms."CarParks"
    OWNER to postgres;

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE toms."CarParks" TO toms_admin;
GRANT SELECT ON TABLE toms."CarParks" TO toms_public;
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE toms."CarParks" TO toms_operator;

GRANT ALL ON TABLE toms."CarParks" TO postgres;
-- Index: sidx_CarParks_geom

-- DROP INDEX toms."sidx_CarParks_geom";

CREATE INDEX "sidx_CarParks_geom"
    ON toms."CarParks" USING gist
    (geom)
    TABLESPACE pg_default;

-- Trigger: create_geometryid_car_parks

-- DROP TRIGGER create_geometryid_car_parks ON toms."CarParks";

CREATE TRIGGER create_geometryid_car_parks
    BEFORE INSERT
    ON toms."CarParks"
    FOR EACH ROW
    EXECUTE PROCEDURE public.create_geometryid();

-- Trigger: insert_mngmt

-- DROP TRIGGER insert_mngmt ON toms."CarParks";

CREATE TRIGGER insert_mngmt
    BEFORE INSERT OR UPDATE
    ON toms."CarParks"
    FOR EACH ROW
    EXECUTE PROCEDURE toms.labelling_for_restrictions();

-- Trigger: notify_qgis_edit

-- DROP TRIGGER notify_qgis_edit ON toms."CarParks";

CREATE TRIGGER notify_qgis_edit
    AFTER INSERT OR DELETE OR TRUNCATE OR UPDATE
    ON toms."CarParks"
    FOR EACH STATEMENT
    EXECUTE PROCEDURE public.notify_qgis();

-- Trigger: set_create_details_CarParks

-- DROP TRIGGER "set_create_details_CarParks" ON toms."CarParks";

CREATE TRIGGER "set_create_details_CarParks"
    BEFORE INSERT
    ON toms."CarParks"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_create_details();

-- Trigger: set_last_update_details_CarParks

-- DROP TRIGGER "set_last_update_details_CarParks" ON toms."CarParks";

CREATE TRIGGER "set_last_update_details_CarParks"
    BEFORE INSERT OR UPDATE
    ON toms."CarParks"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_last_update_details();

-- include car parks into create_geometryid function

-- add to GeometryID function

CREATE OR REPLACE FUNCTION public.create_geometryid()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	 nextSeqVal varchar := '';
BEGIN

	CASE TG_TABLE_NAME
	WHEN 'Bays' THEN
			SELECT concat('B_', to_char(nextval('toms."Bays_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'Lines' THEN
		   SELECT concat('L_', to_char(nextval('toms."Lines_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'Signs' THEN
		   SELECT concat('S_', to_char(nextval('toms."Signs_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'RestrictionPolygons' THEN
		   SELECT concat('P_', to_char(nextval('toms."RestrictionPolygons_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'ControlledParkingZones' THEN
		   SELECT concat('C_', to_char(nextval('toms."ControlledParkingZones_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'ParkingTariffAreas' THEN
		   SELECT concat('T_', to_char(nextval('toms."ParkingTariffAreas_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'AccessRestrictions' THEN
		   SELECT concat('A_', to_char(nextval('moving_traffic."AccessRestrictions_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'HighwayDedications' THEN
		   SELECT concat('H_', to_char(nextval('moving_traffic."HighwayDedications_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'RestrictionsForVehicles' THEN
		   SELECT concat('R_', to_char(nextval('moving_traffic."RestrictionsForVehicles_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'SpecialDesignations' THEN
		   SELECT concat('D_', to_char(nextval('moving_traffic."SpecialDesignations_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'TurnRestrictions' THEN
		   SELECT concat('V_', to_char(nextval('moving_traffic."TurnRestrictions_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'CarriagewayMarkings' THEN
		   SELECT concat('M_', to_char(nextval('moving_traffic."CarriagewayMarkings_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'MHTC_RoadLinks' THEN
		   SELECT concat('L_', to_char(nextval('highways_network."MHTC_RoadLinks_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'MHTC_Kerblines' THEN
		   SELECT concat('K_', to_char(nextval('mhtc_operations."MHTC_Kerbline_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'MatchDayEventDayZones' THEN
		   SELECT concat('E_', to_char(nextval('toms."MatchDayEventDayZones_id_seq"'::regclass), 'FM0000000'::text)) INTO nextSeqVal;
	WHEN 'CarParks' THEN
		   SELECT concat('Q_', to_char(nextval('toms."CarParks_id_seq"'::regclass), 'FM0000000'::text)) INTO nextSeqVal;
	ELSE
	    nextSeqVal = 'U';
	END CASE;

    NEW."GeometryID" := nextSeqVal;
	RETURN NEW;

END;
$BODY$;
