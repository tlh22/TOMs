/***

***/

CREATE TABLE IF NOT EXISTS toms."StaticRestrictions"
(
    "RestrictionID" character varying(254) COLLATE pg_catalog."default" NOT NULL,
    "GeometryID" character varying(12) COLLATE pg_catalog."default" NOT NULL DEFAULT ('B_'::text || to_char(nextval('toms."Bays_id_seq"'::regclass), 'FM0000000'::text)),
    "RestrictionTypeID" integer NOT NULL,

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
    "CreateDateTime" timestamp without time zone NOT NULL,
    "CreatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "AdditionalConditionID" integer,

    "ComplianceRoadMarkingsFaded" integer,
    "ComplianceRestrictionSignIssue" integer,
    "ComplianceNotes" character varying(254) COLLATE pg_catalog."default",
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254) COLLATE pg_catalog."default",

    CONSTRAINT "StaticRestrictions_pkey" PRIMARY KEY ("RestrictionID"),
    CONSTRAINT "StaticRestrictions_AdditionalConditionID_fkey" FOREIGN KEY ("AdditionalConditionID")
        REFERENCES toms_lookups."AdditionalConditionTypes" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "StaticRestrictions_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID")
        REFERENCES toms_lookups."BayTypesInUse" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS toms."StaticRestrictions"
    OWNER to postgres;

REVOKE ALL ON TABLE toms."StaticRestrictions" FROM toms_admin;
REVOKE ALL ON TABLE toms."StaticRestrictions" FROM toms_operator;
REVOKE ALL ON TABLE toms."StaticRestrictions" FROM toms_public;

GRANT ALL ON TABLE toms."StaticRestrictions" TO postgres;

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE toms."StaticRestrictions" TO toms_admin;

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE toms."StaticRestrictions" TO toms_operator;

GRANT SELECT ON TABLE toms."StaticRestrictions" TO toms_public;

CREATE OR REPLACE TRIGGER create_geometryid_bays
    BEFORE INSERT
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE FUNCTION public.create_geometryid();

-- Trigger: set_last_update_details_bays

-- DROP TRIGGER IF EXISTS set_last_update_details_bays ON toms."Bays";

CREATE OR REPLACE TRIGGER set_last_update_details_bays
    BEFORE INSERT OR UPDATE
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE FUNCTION public.set_last_update_details();

--

CREATE TABLE "toms"."StaticRestrictions_Bays" (
    "GeometryID" --character varying(12) DEFAULT ('A_'::"text" || "to_char"("nextval"('"moving_traffic"."AccessRestrictions_id_seq"'::"regclass"), 'FM0000000'::"text")),
    geom geometry(LineString,27700) NOT NULL,

    "restriction" "moving_traffic_lookups"."accessRestrictionValue" NOT NULL,
    "timeInterval" integer,
    "trafficSigns" character varying(255),
    "exemption" integer,
    "inclusion" integer,
    "mt_capture_geom" "public"."geometry"(Point,27700)
)
INHERITS ("moving_traffic"."Restrictions");


    "RestrictionID" character varying(254) COLLATE pg_catalog."default" NOT NULL,
    "GeometryID" character varying(12) COLLATE pg_catalog."default" NOT NULL DEFAULT ('B_'::text || to_char(nextval('toms."Bays_id_seq"'::regclass), 'FM0000000'::text)),
    geom geometry(LineString,27700) NOT NULL,
    "RestrictionLength" double precision NOT NULL,
    "RestrictionTypeID" integer NOT NULL,
    "GeomShapeID" integer NOT NULL,
    "AzimuthToRoadCentreLine" double precision,
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
    "CPZ" character varying(40) COLLATE pg_catalog."default",
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "BayOrientation" double precision,
    "NrBays" integer NOT NULL DEFAULT '-1'::integer,
    "TimePeriodID" integer NOT NULL,
    "PayTypeID" integer,
    "MaxStayID" integer,
    "NoReturnID" integer,
    "ParkingTariffArea" character varying(10) COLLATE pg_catalog."default",
    "AdditionalConditionID" integer,
    "ComplianceRoadMarkingsFaded" integer,
    "ComplianceRestrictionSignIssue" integer,
    "ComplianceNotes" character varying(254) COLLATE pg_catalog."default",
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254) COLLATE pg_catalog."default",
    "PermitCode" character varying(255) COLLATE pg_catalog."default",
    "MatchDayTimePeriodID" integer,
    "PayParkingAreaID" integer,
    "CreateDateTime" timestamp without time zone NOT NULL,
    "CreatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "Capacity" integer,
    label_pos geometry(MultiPoint,27700),
    label_ldr geometry(MultiLineString,27700),
    "MatchDayEventDayZone" character varying(40) COLLATE pg_catalog."default",
    "BayWidth" double precision,
    "DisplayLabel" boolean NOT NULL DEFAULT true,
