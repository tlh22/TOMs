--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.17
-- Dumped by pg_dump version 9.6.17

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ActionOnProposalAcceptanceTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ActionOnProposalAcceptanceTypes" (
    id integer NOT NULL,
    "Description" character varying
);


ALTER TABLE public."ActionOnProposalAcceptanceTypes" OWNER TO postgres;

--
-- Name: ActionOnProposalAcceptanceTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ActionOnProposalAcceptanceTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ActionOnProposalAcceptanceTypes_id_seq" OWNER TO postgres;

--
-- Name: ActionOnProposalAcceptanceTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ActionOnProposalAcceptanceTypes_id_seq" OWNED BY public."ActionOnProposalAcceptanceTypes".id;


--
-- Name: BayLineTypesInUse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BayLineTypesInUse" (
    gid integer NOT NULL,
    "Code" integer
);


ALTER TABLE public."BayLineTypesInUse" OWNER TO postgres;

--
-- Name: BayLineTypes; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public."BayLineTypes" AS
 SELECT "BayLineTypes"."Code",
    "BayLineTypes"."Description"
   FROM ( SELECT "BayLineTypes_1"."Code",
            "BayLineTypes_1"."Description"
            -- YOU MAY NEED TO ADAPT THIS
           FROM public.dblink('dbname=MasterLookups options=-csearch_path='::text, 'SELECT "Code", "Description" FROM public."BayLineTypes"'::text) "BayLineTypes_1"("Code" integer, "Description" text)) "BayLineTypes",
    public."BayLineTypesInUse" u
  WHERE ("BayLineTypes"."Code" = u."Code")
  WITH NO DATA;


ALTER TABLE public."BayLineTypes" OWNER TO postgres;

--
-- Name: BayLineTypesInUse_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."BayLineTypesInUse_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."BayLineTypesInUse_gid_seq" OWNER TO postgres;

--
-- Name: BayLineTypesInUse_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."BayLineTypesInUse_gid_seq" OWNED BY public."BayLineTypesInUse".gid;


--
-- Name: BayLinesFadedTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BayLinesFadedTypes" (
    id integer NOT NULL,
    "Code" character varying,
    "Description" character varying,
    "Comment" character varying
);


ALTER TABLE public."BayLinesFadedTypes" OWNER TO postgres;

--
-- Name: BayLinesFadedTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."BayLinesFadedTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."BayLinesFadedTypes_id_seq" OWNER TO postgres;

--
-- Name: BayLinesFadedTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."BayLinesFadedTypes_id_seq" OWNED BY public."BayLinesFadedTypes".id;


--
-- Name: BayTypes; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE TABLE public."BayTypes"
(
    "Code" integer,
    "Description" text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE public."BayTypes"
    OWNER to postgres;
-- Index: BayTypes_key

-- DROP INDEX public."BayTypes_key";

CREATE UNIQUE INDEX "BayTypes_key"
    ON public."BayTypes" USING btree
    ("Code" ASC NULLS LAST)
    TABLESPACE pg_default;

--
-- Name: Bays2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Bays2_id_seq"
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Bays2_id_seq" OWNER TO postgres;

--
-- Name: Bays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Bays" (
    id integer,
    geom public.geometry(LineString,27700) NOT NULL,
    "Length" double precision,
    "RestrictionTypeID" integer,
    "NrBays" integer,
    "TimePeriodID" integer,
    "PayTypeID" integer,
    "MaxStayID" integer,
    "NoReturnID" integer,
    "Notes" character varying(254),
    "GeometryID" character varying(10) DEFAULT ('B_'::text || to_char(nextval('public."Bays2_id_seq"'::regclass), '0000000'::text)) NOT NULL,
    "Bays_DateTime" timestamp without time zone,
    "BaysWordingID" integer,
    "Surveyor" character varying(50),
    "BaysGeometry" integer,
    "Bays_PhotoTaken" integer,
    "Compl_Bays_Faded" integer,
    "Compl_Bays_SignIssue" integer,
    "Bays_Photos_01" character varying(255),
    "Bays_Photos_02" character varying(255),
    "GeomShapeID" integer,
    "RoadName" character varying(254),
    "USRN" character varying(254),
    "AzimuthToRoadCentreLine" double precision,
    "label_X" double precision,
    "label_Y" double precision,
    "label_Rotation" double precision,
    "label_TextChanged" character varying(254),
    "BayOrientation" double precision,
    "OpenDate" date,
    "CloseDate" date,
    "CPZ" character varying(40),
    "ParkingTariffArea" character varying(10),
    "OriginalGeomShapeID" integer,
    "GeometryID_181017" character varying(254),
    "RestrictionID" character varying(254) NOT NULL
);


ALTER TABLE public."Bays" OWNER TO postgres;

--
-- Name: BaysLines_SignIssueTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BaysLines_SignIssueTypes" (
    id integer NOT NULL,
    "Code" character varying,
    "Description" character varying,
    "Comment" character varying
);


ALTER TABLE public."BaysLines_SignIssueTypes" OWNER TO postgres;

--
-- Name: BaysLines_SignIssueTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."BaysLines_SignIssueTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."BaysLines_SignIssueTypes_id_seq" OWNER TO postgres;

--
-- Name: BaysLines_SignIssueTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."BaysLines_SignIssueTypes_id_seq" OWNED BY public."BaysLines_SignIssueTypes".id;


--
-- Name: CECStatusTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CECStatusTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."CECStatusTypes_id_seq" OWNER TO postgres;

--
-- Name: CPZs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CPZs" (
    gid integer NOT NULL,
    geom public.geometry(MultiPolygon,27700),
    cacz_ref_n character varying(2),
    date_last_ character varying(10),
    no_osp_spa double precision,
    no_pnr_spa double precision,
    no_pub_spa double precision,
    no_res_spa double precision,
    zone_no character varying(40),
    type character varying(40),
    "WaitingTimeID" integer
);


ALTER TABLE public."CPZs" OWNER TO postgres;

--
-- Name: ControlledParkingZones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ControlledParkingZones" (
    gid integer NOT NULL,
    cacz_ref_n character varying(6),
    date_last_ character varying(10),
    no_osp_spa numeric(10,0),
    no_pnr_spa numeric(10,0),
    no_pub_spa numeric(10,0),
    no_res_spa numeric(10,0),
    zone_no character varying(40),
    type character varying(40),
    geom public.geometry(Polygon,27700),
    "WaitingTimeID" integer,
    "CPZ" character varying(6),
    "OpenDate" date,
    "CloseDate" date,
    "RestrictionID" character varying(254),
    "GeometryID" character varying(15)
);


ALTER TABLE public."ControlledParkingZones" OWNER TO postgres;

--
-- Name: Signs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Signs" (
    id integer,
    geom public.geometry(Point,27700),
    "Signs_Notes" character varying(255),
    "Signs_Photos_01" character varying(255),
    "GeometryID" character varying(100) NOT NULL,
    "SignType_1" integer,
    "SignType_2" integer,
    "SignType_3" integer,
    "Signs_DateTime" timestamp without time zone,
    "PhotoTaken" integer,
    "Signs_Photos_02" character varying(255),
    "Signs_Mount" integer,
    "Surveyor" character varying(50),
    "TicketMachine_Nr" character varying(10),
    "Signs_Attachment" integer,
    "Compl_Signs_Faded" integer,
    "Compl_Signs_Obscured" integer,
    "Compl_Signs_Direction" integer,
    "Compl_Signs_Obsolete" integer,
    "Compl_Signs_OtherOptions" integer,
    "Compl_Signs_TicketMachines" integer,
    "RoadName" character varying(254),
    "USRN" character varying(254),
    "RingoPresent" integer,
    "OpenDate" date,
    "CloseDate" date,
    "Signs_Photos_03" character varying(255),
    "GeometryID_181017" character varying(12),
    "RestrictionID" character varying(254) NOT NULL,
    "CPZ" character varying(40),
    "ParkingTariffArea" character varying(10)
);


ALTER TABLE public."Signs" OWNER TO postgres;

--
-- Name: EDI01_Signs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."EDI01_Signs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."EDI01_Signs_id_seq" OWNER TO postgres;

--
-- Name: EDI01_Signs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."EDI01_Signs_id_seq" OWNED BY public."Signs".id;


--
-- Name: EDI_RoadCasement_Polyline; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE public."EDI_RoadCasement_Polyline" (
    id integer NOT NULL,
    geom public.geometry(LineString,27700),
    "OBJECTID_1" integer,
    "MidPt_ID" integer,
    "ESUID" double precision,
    "USRN" integer,
    "StreetName" character varying(254),
    "Locality" character varying(255),
    "Town" character varying(255),
    "Shape_Length" double precision
);


ALTER TABLE public."EDI_RoadCasement_Polyline" OWNER TO edi_operator;

--
-- Name: EDI_Sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."EDI_Sections" (
    id integer NOT NULL,
    geom public.geometry(Polygon,27700),
    objectid_1 bigint,
    objectid bigint,
    name character varying(100),
    shape_leng double precision,
    newname character varying(100),
    area integer,
    comment character varying(254),
    shape_le_1 double precision,
    shape_area double precision
);


ALTER TABLE public."EDI_Sections" OWNER TO postgres;

--
-- Name: LengthOfTime; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."LengthOfTime" (
    id integer NOT NULL,
    "Code" bigint,
    "Description" character varying,
    "LabelText" character varying(255)
);


ALTER TABLE public."LengthOfTime" OWNER TO postgres;

--
-- Name: LengthOfTime_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."LengthOfTime_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."LengthOfTime_id_seq" OWNER TO postgres;

--
-- Name: LengthOfTime_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."LengthOfTime_id_seq" OWNED BY public."LengthOfTime".id;


--
-- Name: LineTypes; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE TABLE public."LineTypes"
(
    "Code" integer,
    "Description" text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE public."LineTypes"
    OWNER to postgres;
-- Index: LineTypes_key

-- DROP INDEX public."LineTypes_key";

CREATE UNIQUE INDEX "LineTypes_key"
    ON public."LineTypes" USING btree
    ("Code" ASC NULLS LAST)
    TABLESPACE pg_default;

--
-- Name: Lines2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Lines2_id_seq"
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Lines2_id_seq" OWNER TO postgres;

--
-- Name: Lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Lines" (
    id integer,
    geom public.geometry(LineString,27700) NOT NULL,
    "Length" double precision,
    "RestrictionTypeID" integer,
    "NoWaitingTimeID" integer,
    "NoLoadingTimeID" integer,
    "Notes" character varying(254),
    "GeometryID" character varying(20) DEFAULT ('L_'::text || to_char(nextval('public."Lines2_id_seq"'::regclass), '0000000'::text)) NOT NULL,
    "Lines_DateTime" timestamp without time zone,
    "Surveyor" character varying(100),
    "Lines_PhotoTaken" integer,
    "Lines_Photos_01" character varying(255),
    "Compl_Lines_Faded" integer,
    "Compl_NoL_Faded" integer,
    "Lines_Photos_02" character varying(255),
    "Compl_Lines_SignIssue" integer,
    "RoadName" character varying(254),
    "USRN" character varying(254),
    "AzimuthToRoadCentreLine" double precision,
    "GeomShapeID" integer,
    "labelX" double precision,
    "labelY" double precision,
    "labelRotation" double precision,
    "Lines_Photos_03" character varying(255),
    "Unacceptability" integer,
    "OpenDate" date,
    "CloseDate" date,
    "CPZ" character varying(40),
    "ParkingTariffArea" character varying(10),
    "labelLoadingX" double precision,
    "labelLoadingY" double precision,
    "labelLoadingRotation" double precision,
    "TRO_Status_180409" integer,
    "GeometryID_181017" character varying(254),
    "RestrictionID" character varying(254) NOT NULL
);


ALTER TABLE public."Lines" OWNER TO postgres;

--
-- Name: LookupCodeTransfers_Bays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."LookupCodeTransfers_Bays" (
    id integer NOT NULL,
    "Aug2018_Description" character varying,
    "Aug2018_Code" character varying,
    "CurrCode" character varying
);


ALTER TABLE public."LookupCodeTransfers_Bays" OWNER TO postgres;

--
-- Name: LookupCodeTransfers_Lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."LookupCodeTransfers_Lines" (
    id integer NOT NULL,
    "Aug2018_Description" character varying,
    "Aug2018_Code" character varying,
    "CurrCode" character varying
);


ALTER TABLE public."LookupCodeTransfers_Lines" OWNER TO postgres;

--
-- Name: MapGrid; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE public."MapGrid" (
    id bigint NOT NULL,
    geom public.geometry(MultiPolygon,27700),
    x_min double precision,
    x_max double precision,
    y_min double precision,
    y_max double precision,
    "RevisionNr" integer,
    "Edge" character varying(5),
    "CPZ tile" integer,
    "ContainsRes" integer,
    "LastRevisionDate" date
);


ALTER TABLE public."MapGrid" OWNER TO edi_operator;

--
-- Name: ParkingTariffAreas; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE public."ParkingTariffAreas" (
    id integer NOT NULL,
    geom public.geometry(Polygon,27700),
    gid integer,
    fid_parkin integer,
    tro_ref numeric,
    charge character varying(255),
    cost character varying(255),
    hours character varying(255),
    "Name" character varying(255),
    "NoReturnTimeID" integer,
    "MaxStayID" integer,
    "TimePeriodID" integer,
    "OBJECTID" integer,
    name_orig character varying(255),
    "Shape_Leng" numeric,
    "Shape_Area" numeric,
    "OpenDate" date,
    "CloseDate" date,
    "RestrictionID" character varying(254),
    "GeometryID" character varying(15)
);


ALTER TABLE public."ParkingTariffAreas" OWNER TO edi_operator;

--
-- Name: PTAs_180725_merged_10_id_seq; Type: SEQUENCE; Schema: public; Owner: edi_operator
--

CREATE SEQUENCE public."PTAs_180725_merged_10_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PTAs_180725_merged_10_id_seq" OWNER TO edi_operator;

--
-- Name: PTAs_180725_merged_10_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: edi_operator
--

ALTER SEQUENCE public."PTAs_180725_merged_10_id_seq" OWNED BY public."ParkingTariffAreas".id;


--
-- Name: PaymentTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PaymentTypes" (
    id integer NOT NULL,
    "Code" bigint,
    "Description" character varying
);


ALTER TABLE public."PaymentTypes" OWNER TO postgres;

--
-- Name: PaymentTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PaymentTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PaymentTypes_id_seq" OWNER TO postgres;

--
-- Name: PaymentTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PaymentTypes_id_seq" OWNED BY public."PaymentTypes".id;


--
-- Name: ProposalStatusTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ProposalStatusTypes" (
    id integer NOT NULL,
    "Description" character varying,
    "Code" integer
);


ALTER TABLE public."ProposalStatusTypes" OWNER TO postgres;

--
-- Name: ProposalStatusTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ProposalStatusTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ProposalStatusTypes_id_seq" OWNER TO postgres;

--
-- Name: ProposalStatusTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ProposalStatusTypes_id_seq" OWNED BY public."ProposalStatusTypes".id;


--
-- Name: Proposals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Proposals_id_seq"
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Proposals_id_seq" OWNER TO postgres;

--
-- Name: Proposals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Proposals" (
    "ProposalID" integer DEFAULT nextval('public."Proposals_id_seq"'::regclass) NOT NULL,
    "ProposalStatusID" integer,
    "ProposalCreateDate" date,
    "ProposalNotes" character varying,
    "ProposalTitle" character varying(255) NOT NULL,
    "ProposalOpenDate" date
);


ALTER TABLE public."Proposals" OWNER TO postgres;

--
-- Name: Proposals_withGeom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Proposals_withGeom" (
    "ProposalID" integer,
    "ProposalStatusID" integer,
    "ProposalCreateDate" date,
    "ProposalNotes" character varying,
    "ProposalTitle" character varying(255) NOT NULL,
    "ProposalOpenDate" date
);


ALTER TABLE public."Proposals_withGeom" OWNER TO postgres;

--
-- Name: RestrictionTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RestrictionTypes" (
    id integer NOT NULL,
    "PK_UID" bigint,
    "Description" character varying,
    "OrigOrderCode" double precision
);


ALTER TABLE public."RestrictionTypes" OWNER TO postgres;

--
-- Name: RestrictionsInProposals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RestrictionsInProposals" (
    "ProposalID" integer NOT NULL,
    "RestrictionTableID" integer NOT NULL,
    "ActionOnProposalAcceptance" integer,
    "RestrictionID" character varying(255) NOT NULL
);


ALTER TABLE public."RestrictionsInProposals" OWNER TO postgres;

--
-- Name: TimePeriods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."TimePeriods_id_seq"
    START WITH 300
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."TimePeriods_id_seq" OWNER TO postgres;

--
-- Name: TimePeriods_orig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TimePeriods_orig" (
    id integer DEFAULT nextval('public."TimePeriods_id_seq"'::regclass) NOT NULL,
    "Code" integer,
    "Description" character varying,
    "LabelText" character varying(255)
);


ALTER TABLE public."TimePeriods_orig" OWNER TO postgres;

--
-- Name: Proposed Order Items; Type: VIEW; Schema: public; Owner: edi_admin
--

CREATE VIEW public."Proposed Order Items" AS
 SELECT "Proposals"."ProposalTitle" AS "order",
    "Bays"."GeometryID" AS id,
    "Bays"."RoadName" AS road,
    "RestrictionTypes"."Description" AS restriction,
    "TimePeriods_orig"."Description" AS times
   FROM ((((public."Bays"
     LEFT JOIN public."RestrictionsInProposals" ON ((("Bays"."RestrictionID")::text = ("RestrictionsInProposals"."RestrictionID")::text)))
     LEFT JOIN public."Proposals" ON (("RestrictionsInProposals"."ProposalID" = "Proposals"."ProposalID")))
     LEFT JOIN public."RestrictionTypes" ON (("Bays"."RestrictionTypeID" = "RestrictionTypes".id)))
     LEFT JOIN public."TimePeriods_orig" ON (("Bays"."TimePeriodID" = "TimePeriods_orig"."Code")))
  WHERE (("Bays"."RestrictionTypeID" = ANY (ARRAY[228, 231, 240, 33, 34, 35, 233, 234, 235, 4, 204, 6, 206, 29, 25, 9, 10, 209, 210, 28, 31, 40])) AND ("Bays"."OpenDate" IS NULL) AND (("Proposals"."ProposalTitle")::text = 'TRO-18-79'::text))
UNION
 SELECT "Proposals"."ProposalTitle" AS "order",
    "Lines"."GeometryID" AS id,
    "Lines"."RoadName" AS road,
    "RestrictionTypes"."Description" AS restriction,
    "TimePeriods_orig"."Description" AS times
   FROM ((((public."Lines"
     LEFT JOIN public."RestrictionTypes" ON (("Lines"."RestrictionTypeID" = "RestrictionTypes".id)))
     LEFT JOIN public."RestrictionsInProposals" ON ((("Lines"."RestrictionID")::text = ("RestrictionsInProposals"."RestrictionID")::text)))
     LEFT JOIN public."Proposals" ON (("RestrictionsInProposals"."ProposalID" = "Proposals"."ProposalID")))
     LEFT JOIN public."TimePeriods_orig" ON (("Lines"."NoWaitingTimeID" = "TimePeriods_orig"."Code")))
  WHERE (("Lines"."RestrictionTypeID" = ANY (ARRAY[228, 231, 240, 33, 34, 35, 233, 234, 235, 4, 204, 6, 206, 29, 25, 9, 10, 209, 210, 28, 31, 40])) AND ("Lines"."OpenDate" IS NULL) AND (("Proposals"."ProposalTitle")::text = 'TRO-18-79'::text));


ALTER TABLE public."Proposed Order Items" OWNER TO edi_admin;

--
-- Name: Proposed Order Restrictions List; Type: VIEW; Schema: public; Owner: edi_admin
--

CREATE VIEW public."Proposed Order Restrictions List" AS
 SELECT "Proposals"."ProposalTitle" AS "order",
    "Bays"."GeometryID" AS id,
    "Bays"."RoadName" AS road,
    "RestrictionTypes"."Description" AS restriction,
    "TimePeriods_orig"."Description" AS times,
    "Bays".geom
   FROM ((((public."Bays"
     LEFT JOIN public."RestrictionsInProposals" ON ((("Bays"."RestrictionID")::text = ("RestrictionsInProposals"."RestrictionID")::text)))
     LEFT JOIN public."Proposals" ON (("RestrictionsInProposals"."ProposalID" = "Proposals"."ProposalID")))
     LEFT JOIN public."RestrictionTypes" ON (("Bays"."RestrictionTypeID" = "RestrictionTypes".id)))
     LEFT JOIN public."TimePeriods_orig" ON (("Bays"."TimePeriodID" = "TimePeriods_orig"."Code")))
  WHERE (("Bays"."RestrictionTypeID" = ANY (ARRAY[228, 231, 240, 33, 34, 35, 233, 234, 235, 4, 204, 6, 206, 29, 25, 9, 10, 209, 210, 28, 31, 40])) AND ("Bays"."OpenDate" IS NULL))
UNION
 SELECT "Proposals"."ProposalTitle" AS "order",
    "Lines"."GeometryID" AS id,
    "Lines"."RoadName" AS road,
    "RestrictionTypes"."Description" AS restriction,
    "TimePeriods_orig"."Description" AS times,
    "Lines".geom
   FROM ((((public."Lines"
     LEFT JOIN public."RestrictionTypes" ON (("Lines"."RestrictionTypeID" = "RestrictionTypes".id)))
     LEFT JOIN public."RestrictionsInProposals" ON ((("Lines"."RestrictionID")::text = ("RestrictionsInProposals"."RestrictionID")::text)))
     LEFT JOIN public."Proposals" ON (("RestrictionsInProposals"."ProposalID" = "Proposals"."ProposalID")))
     LEFT JOIN public."TimePeriods_orig" ON (("Lines"."NoWaitingTimeID" = "TimePeriods_orig"."Code")))
  WHERE (("Lines"."RestrictionTypeID" = ANY (ARRAY[228, 231, 240, 33, 34, 35, 233, 234, 235, 4, 204, 6, 206, 29, 25, 9, 10, 209, 210, 28, 31, 40])) AND ("Lines"."OpenDate" IS NULL));


ALTER TABLE public."Proposed Order Restrictions List" OWNER TO edi_admin;

--
-- Name: RestrictionShapeTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RestrictionShapeTypes" (
    id integer NOT NULL,
    "Code" bigint,
    "Description" character varying
);


ALTER TABLE public."RestrictionShapeTypes" OWNER TO postgres;

--
-- Name: RestrictionGeometryTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."RestrictionGeometryTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."RestrictionGeometryTypes_id_seq" OWNER TO postgres;

--
-- Name: RestrictionGeometryTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."RestrictionGeometryTypes_id_seq" OWNED BY public."RestrictionShapeTypes".id;


--
-- Name: RestrictionLayers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RestrictionLayers" (
    id integer NOT NULL,
    "RestrictionLayerName" character varying(255) NOT NULL
);


ALTER TABLE public."RestrictionLayers" OWNER TO postgres;

--
-- Name: RestrictionLayers2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."RestrictionLayers2_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."RestrictionLayers2_id_seq" OWNER TO postgres;

--
-- Name: RestrictionLayers2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."RestrictionLayers2_id_seq" OWNED BY public."RestrictionLayers".id;


--
-- Name: RestrictionPolygonTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."RestrictionPolygonTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."RestrictionPolygonTypes_id_seq" OWNER TO postgres;

--
-- Name: RestrictionPolygonTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RestrictionPolygonTypes" (
    id integer DEFAULT nextval('public."RestrictionPolygonTypes_id_seq"'::regclass) NOT NULL,
    "Code" integer,
    "Description" character varying
);


ALTER TABLE public."RestrictionPolygonTypes" OWNER TO postgres;

--
-- Name: restrictionPolygons_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."restrictionPolygons_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."restrictionPolygons_seq" OWNER TO postgres;

--
-- Name: RestrictionPolygons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RestrictionPolygons" (
    id integer,
    geom public.geometry(Polygon,27700) NOT NULL,
    "RestrictionTypeID" integer,
    "GeomShapeID" integer,
    "OpenDate" date,
    "CloseDate" date,
    "USRN" character varying(254),
    "Orientation" integer,
    "RoadName" character varying(254),
    "GeometryID" character varying(254) DEFAULT ('P_'::text || to_char(nextval('public."restrictionPolygons_seq"'::regclass), '00000000'::text)) NOT NULL,
    "RestrictionID" character varying(254) NOT NULL,
    "NoWaitingTimeID" integer,
    "NoLoadingTimeID" integer,
    "Polygons_Photos_01" character varying(255),
    "Polygons_Photos_02" character varying(255),
    "Polygons_Photos_03" character varying(255),
    "LabelText" character varying(254),
    "TimePeriodID" integer,
    "AreaPermitCode" character varying(254),
    "CPZ" character varying(40),
    "labelX" double precision,
    "labelY" double precision,
    "labelRotation" double precision
);


ALTER TABLE public."RestrictionPolygons" OWNER TO postgres;

--
-- Name: RestrictionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RestrictionStatus" (
    id integer NOT NULL,
    "PK_UID" bigint,
    "RestrictionStatusID" bigint,
    "Description" character varying
);


ALTER TABLE public."RestrictionStatus" OWNER TO postgres;

--
-- Name: RestrictionStatus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."RestrictionStatus_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."RestrictionStatus_id_seq" OWNER TO postgres;

--
-- Name: RestrictionStatus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."RestrictionStatus_id_seq" OWNED BY public."RestrictionStatus".id;


--
-- Name: RestrictionTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."RestrictionTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."RestrictionTypes_id_seq" OWNER TO postgres;

--
-- Name: RestrictionTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."RestrictionTypes_id_seq" OWNED BY public."RestrictionTypes".id;


--
-- Name: RoadCentreLine; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE public."RoadCentreLine" (
    gid integer NOT NULL,
    geom public.geometry(MultiLineString,27700),
    toid character varying(16),
    version double precision,
    verdate date,
    theme character varying(80),
    descgroup character varying(150),
    descterm character varying(150),
    change character varying(80),
    topoarea character varying(20),
    nature character varying(80),
    lnklength double precision,
    node1 character varying(20),
    node1grade character varying(1),
    node1gra_1 double precision,
    node2 character varying(20),
    node2grade character varying(1),
    node2gra_1 double precision,
    loaddate date,
    objectid double precision,
    shape_leng double precision
);


ALTER TABLE public."RoadCentreLine" OWNER TO edi_operator;

--
-- Name: SignAttachmentTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SignAttachmentTypes" (
    id integer NOT NULL,
    "Code" integer,
    "Description" character varying
);


ALTER TABLE public."SignAttachmentTypes" OWNER TO postgres;

--
-- Name: SignFadedTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SignFadedTypes" (
    id integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE public."SignFadedTypes" OWNER TO postgres;

--
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."SignFadedTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SignFadedTypes_id_seq" OWNER TO postgres;

--
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."SignFadedTypes_id_seq" OWNED BY public."SignFadedTypes".id;


--
-- Name: SignMountTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SignMountTypes" (
    id integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE public."SignMountTypes" OWNER TO postgres;

--
-- Name: SignMounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."SignMounts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SignMounts_id_seq" OWNER TO postgres;

--
-- Name: SignMounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."SignMounts_id_seq" OWNED BY public."SignMountTypes".id;


--
-- Name: SignObscurredTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SignObscurredTypes" (
    id integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE public."SignObscurredTypes" OWNER TO postgres;

--
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."SignObscurredTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SignObscurredTypes_id_seq" OWNER TO postgres;

--
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."SignObscurredTypes_id_seq" OWNED BY public."SignObscurredTypes".id;


--
-- Name: SignTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SignTypes" (
    id integer NOT NULL,
    "Description" character varying,
    "Code" integer
);


ALTER TABLE public."SignTypes" OWNER TO postgres;

--
-- Name: SignTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."SignTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SignTypes_id_seq" OWNER TO postgres;

--
-- Name: SignTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."SignTypes_id_seq" OWNED BY public."SignTypes".id;


--
-- Name: Surveyors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Surveyors" (
    "Code" integer NOT NULL,
    "Description" character varying(255) NOT NULL
);


ALTER TABLE public."Surveyors" OWNER TO postgres;

--
-- Name: Surveyors_Code_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Surveyors_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Surveyors_Code_seq" OWNER TO postgres;

--
-- Name: Surveyors_Code_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Surveyors_Code_seq" OWNED BY public."Surveyors"."Code";


--
-- Name: TROStatusTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."TROStatusTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."TROStatusTypes_id_seq" OWNER TO postgres;

--
-- Name: TicketMachineIssueTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TicketMachineIssueTypes" (
    id integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE public."TicketMachineIssueTypes" OWNER TO postgres;

--
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."TicketMachineIssueTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."TicketMachineIssueTypes_id_seq" OWNER TO postgres;

--
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."TicketMachineIssueTypes_id_seq" OWNED BY public."TicketMachineIssueTypes".id;


--
-- Name: TilesInAcceptedProposals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TilesInAcceptedProposals" (
    "ProposalID" integer NOT NULL,
    "TileNr" integer NOT NULL,
    "RevisionNr" integer NOT NULL
);


ALTER TABLE public."TilesInAcceptedProposals" OWNER TO postgres;

--
-- Name: TimePeriods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TimePeriods" (
    id integer DEFAULT nextval('public."TimePeriods_id_seq"'::regclass) NOT NULL,
    "Code" integer,
    "Description" character varying,
    "LabelText" character varying(255)
);


ALTER TABLE public."TimePeriods" OWNER TO postgres;

--
-- Name: baysWordingTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."baysWordingTypes" (
    id integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE public."baysWordingTypes" OWNER TO postgres;

--
-- Name: baysWordingTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."baysWordingTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."baysWordingTypes_id_seq" OWNER TO postgres;

--
-- Name: baysWordingTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."baysWordingTypes_id_seq" OWNED BY public."baysWordingTypes".id;


--
-- Name: baytypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.baytypes (
    gid integer NOT NULL,
    "Description" character varying(254),
    "Code" integer
);


ALTER TABLE public.baytypes OWNER TO postgres;

--
-- Name: baytypes_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.baytypes_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.baytypes_gid_seq OWNER TO postgres;

--
-- Name: baytypes_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.baytypes_gid_seq OWNED BY public.baytypes.gid;


--
-- Name: controlledparkingzones_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.controlledparkingzones_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.controlledparkingzones_gid_seq OWNER TO postgres;

--
-- Name: controlledparkingzones_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.controlledparkingzones_gid_seq OWNED BY public."ControlledParkingZones".gid;


--
-- Name: corners_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.corners_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.corners_seq OWNER TO postgres;

--
-- Name: issueid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.issueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.issueid_seq OWNER TO postgres;

--
-- Name: layer_styles; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE public.layer_styles (
    id integer NOT NULL,
    f_table_catalog character varying,
    f_table_schema character varying,
    f_table_name character varying,
    f_geometry_column character varying,
    stylename character varying(30),
    styleqml xml,
    stylesld xml,
    useasdefault boolean,
    description text,
    owner character varying(30),
    ui xml,
    update_time timestamp without time zone DEFAULT now()
);


ALTER TABLE public.layer_styles OWNER TO edi_operator;

--
-- Name: layer_styles_id_seq; Type: SEQUENCE; Schema: public; Owner: edi_operator
--

CREATE SEQUENCE public.layer_styles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layer_styles_id_seq OWNER TO edi_operator;

--
-- Name: layer_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: edi_operator
--

ALTER SEQUENCE public.layer_styles_id_seq OWNED BY public.layer_styles.id;


--
-- Name: linetypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.linetypes (
    gid integer NOT NULL,
    "Description" character varying(254),
    "Code" integer
);


ALTER TABLE public.linetypes OWNER TO postgres;

--
-- Name: linetypes2_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.linetypes2_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.linetypes2_gid_seq OWNER TO postgres;

--
-- Name: linetypes2_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.linetypes2_gid_seq OWNED BY public.linetypes.gid;


--
-- Name: pta_ref; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pta_ref
    START WITH 101
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pta_ref OWNER TO postgres;

--
-- Name: serial; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serial
    START WITH 101
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.serial OWNER TO postgres;

--
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."signAttachmentTypes2_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."signAttachmentTypes2_id_seq" OWNER TO postgres;

--
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."signAttachmentTypes2_id_seq" OWNED BY public."SignAttachmentTypes".id;


--
-- Name: signs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.signs (
    gid integer NOT NULL,
    objectid numeric(10,0),
    signs_note character varying(254),
    signs_phot character varying(254),
    signtype_1 integer,
    signtype_2 integer,
    signtype_3 integer,
    signs_date date,
    phototaken integer,
    signs_ph_1 character varying(254),
    signs_moun integer,
    surveyor character varying(50),
    ticketmach character varying(10),
    signs_atta integer,
    compl_sign integer,
    compl_si_1 integer,
    compl_si_2 integer,
    compl_si_3 integer,
    compl_si_4 integer,
    compl_si_5 integer,
    geom public.geometry(Point)
);


ALTER TABLE public.signs OWNER TO postgres;

--
-- Name: signs_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.signs_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.signs_gid_seq OWNER TO postgres;

--
-- Name: signs_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.signs_gid_seq OWNED BY public.signs.gid;


--
-- Name: ActionOnProposalAcceptanceTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ActionOnProposalAcceptanceTypes" ALTER COLUMN id SET DEFAULT nextval('public."ActionOnProposalAcceptanceTypes_id_seq"'::regclass);


--
-- Name: BayLineTypesInUse gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BayLineTypesInUse" ALTER COLUMN gid SET DEFAULT nextval('public."BayLineTypesInUse_gid_seq"'::regclass);


--
-- Name: BayLinesFadedTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BayLinesFadedTypes" ALTER COLUMN id SET DEFAULT nextval('public."BayLinesFadedTypes_id_seq"'::regclass);


--
-- Name: BaysLines_SignIssueTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BaysLines_SignIssueTypes" ALTER COLUMN id SET DEFAULT nextval('public."BaysLines_SignIssueTypes_id_seq"'::regclass);


--
-- Name: ControlledParkingZones gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ControlledParkingZones" ALTER COLUMN gid SET DEFAULT nextval('public.controlledparkingzones_gid_seq'::regclass);


--
-- Name: LengthOfTime id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LengthOfTime" ALTER COLUMN id SET DEFAULT nextval('public."LengthOfTime_id_seq"'::regclass);


--
-- Name: ParkingTariffAreas id; Type: DEFAULT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY public."ParkingTariffAreas" ALTER COLUMN id SET DEFAULT nextval('public."PTAs_180725_merged_10_id_seq"'::regclass);


--
-- Name: PaymentTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PaymentTypes" ALTER COLUMN id SET DEFAULT nextval('public."PaymentTypes_id_seq"'::regclass);


--
-- Name: ProposalStatusTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ProposalStatusTypes" ALTER COLUMN id SET DEFAULT nextval('public."ProposalStatusTypes_id_seq"'::regclass);


--
-- Name: RestrictionLayers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionLayers" ALTER COLUMN id SET DEFAULT nextval('public."RestrictionLayers2_id_seq"'::regclass);


--
-- Name: RestrictionShapeTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionShapeTypes" ALTER COLUMN id SET DEFAULT nextval('public."RestrictionGeometryTypes_id_seq"'::regclass);


--
-- Name: RestrictionStatus id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionStatus" ALTER COLUMN id SET DEFAULT nextval('public."RestrictionStatus_id_seq"'::regclass);


--
-- Name: RestrictionTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionTypes" ALTER COLUMN id SET DEFAULT nextval('public."RestrictionTypes_id_seq"'::regclass);


--
-- Name: SignAttachmentTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SignAttachmentTypes" ALTER COLUMN id SET DEFAULT nextval('public."signAttachmentTypes2_id_seq"'::regclass);


--
-- Name: SignFadedTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SignFadedTypes" ALTER COLUMN id SET DEFAULT nextval('public."SignFadedTypes_id_seq"'::regclass);


--
-- Name: SignMountTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SignMountTypes" ALTER COLUMN id SET DEFAULT nextval('public."SignMounts_id_seq"'::regclass);


--
-- Name: SignObscurredTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SignObscurredTypes" ALTER COLUMN id SET DEFAULT nextval('public."SignObscurredTypes_id_seq"'::regclass);


--
-- Name: SignTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SignTypes" ALTER COLUMN id SET DEFAULT nextval('public."SignTypes_id_seq"'::regclass);


--
-- Name: Signs GeometryID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Signs" ALTER COLUMN "GeometryID" SET DEFAULT ('S_'::text || to_char(nextval('public."EDI01_Signs_id_seq"'::regclass), '0000000'::text));


--
-- Name: Surveyors Code; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Surveyors" ALTER COLUMN "Code" SET DEFAULT nextval('public."Surveyors_Code_seq"'::regclass);


--
-- Name: TicketMachineIssueTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TicketMachineIssueTypes" ALTER COLUMN id SET DEFAULT nextval('public."TicketMachineIssueTypes_id_seq"'::regclass);


--
-- Name: baysWordingTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."baysWordingTypes" ALTER COLUMN id SET DEFAULT nextval('public."baysWordingTypes_id_seq"'::regclass);


--
-- Name: baytypes gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.baytypes ALTER COLUMN gid SET DEFAULT nextval('public.baytypes_gid_seq'::regclass);


--
-- Name: layer_styles id; Type: DEFAULT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY public.layer_styles ALTER COLUMN id SET DEFAULT nextval('public.layer_styles_id_seq'::regclass);


--
-- Name: linetypes gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.linetypes ALTER COLUMN gid SET DEFAULT nextval('public.linetypes2_gid_seq'::regclass);


--
-- Name: signs gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.signs ALTER COLUMN gid SET DEFAULT nextval('public.signs_gid_seq'::regclass);


--
-- Name: ActionOnProposalAcceptanceTypes ActionOnProposalAcceptanceTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ActionOnProposalAcceptanceTypes"
    ADD CONSTRAINT "ActionOnProposalAcceptanceTypes_pkey" PRIMARY KEY (id);


--
-- Name: BayLineTypesInUse BayLineTypesInUse_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BayLineTypesInUse"
    ADD CONSTRAINT "BayLineTypesInUse_Code_key" UNIQUE ("Code");


--
-- Name: BayLineTypesInUse BayLineTypesInUse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BayLineTypesInUse"
    ADD CONSTRAINT "BayLineTypesInUse_pkey" PRIMARY KEY (gid);


--
-- Name: BayLinesFadedTypes BayLinesFadedTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BayLinesFadedTypes"
    ADD CONSTRAINT "BayLinesFadedTypes_pkey" PRIMARY KEY (id);


--
-- Name: BaysLines_SignIssueTypes BaysLines_SignIssueTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BaysLines_SignIssueTypes"
    ADD CONSTRAINT "BaysLines_SignIssueTypes_pkey" PRIMARY KEY (id);


--
-- Name: Bays Bays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bays"
    ADD CONSTRAINT "Bays_pkey" PRIMARY KEY ("GeometryID");


--
-- Name: CPZs CPZs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CPZs"
    ADD CONSTRAINT "CPZs_pkey" PRIMARY KEY (gid);


--
-- Name: EDI_RoadCasement_Polyline EDI_RoadCasement_Polyline_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY public."EDI_RoadCasement_Polyline"
    ADD CONSTRAINT "EDI_RoadCasement_Polyline_pkey" PRIMARY KEY (id);


--
-- Name: EDI_Sections EDI_Sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EDI_Sections"
    ADD CONSTRAINT "EDI_Sections_pkey" PRIMARY KEY (id);


--
-- Name: LengthOfTime LengthOfTime_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LengthOfTime"
    ADD CONSTRAINT "LengthOfTime_pkey" PRIMARY KEY (id);


--
-- Name: Lines Lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Lines"
    ADD CONSTRAINT "Lines_pkey" PRIMARY KEY ("GeometryID");


--
-- Name: LookupCodeTransfers_Bays LookupCodeTransfers_Bays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LookupCodeTransfers_Bays"
    ADD CONSTRAINT "LookupCodeTransfers_Bays_pkey" PRIMARY KEY (id);


--
-- Name: LookupCodeTransfers_Lines LookupCodeTransfers_Lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LookupCodeTransfers_Lines"
    ADD CONSTRAINT "LookupCodeTransfers_Lines_pkey" PRIMARY KEY (id);


--
-- Name: MapGrid MapGrid_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY public."MapGrid"
    ADD CONSTRAINT "MapGrid_pkey" PRIMARY KEY (id);


--
-- Name: ParkingTariffAreas PTAs_180725_merged_10_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY public."ParkingTariffAreas"
    ADD CONSTRAINT "PTAs_180725_merged_10_pkey" PRIMARY KEY (id);


--
-- Name: PaymentTypes PaymentTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PaymentTypes"
    ADD CONSTRAINT "PaymentTypes_pkey" PRIMARY KEY (id);


--
-- Name: ProposalStatusTypes ProposalStatusTypes_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ProposalStatusTypes"
    ADD CONSTRAINT "ProposalStatusTypes_Code_key" UNIQUE ("Code");


--
-- Name: ProposalStatusTypes ProposalStatusTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ProposalStatusTypes"
    ADD CONSTRAINT "ProposalStatusTypes_pkey" PRIMARY KEY (id);


--
-- Name: Proposals Proposals_PK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Proposals"
    ADD CONSTRAINT "Proposals_PK" PRIMARY KEY ("ProposalID");


--
-- Name: Proposals Proposals_ProposalTitle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Proposals"
    ADD CONSTRAINT "Proposals_ProposalTitle_key" UNIQUE ("ProposalTitle");


--
-- Name: RestrictionShapeTypes RestrictionGeometryTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionShapeTypes"
    ADD CONSTRAINT "RestrictionGeometryTypes_pkey" PRIMARY KEY (id);


--
-- Name: RestrictionLayers RestrictionLayers2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers2_pkey" PRIMARY KEY (id);


--
-- Name: RestrictionLayers RestrictionLayers_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers_id_key" UNIQUE (id);


--
-- Name: RestrictionPolygonTypes RestrictionPolygonTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionPolygonTypes"
    ADD CONSTRAINT "RestrictionPolygonTypes_pkey" PRIMARY KEY (id);


--
-- Name: RestrictionPolygons RestrictionPolygons_RestrictionID_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionPolygons_RestrictionID_key" UNIQUE ("RestrictionID");


--
-- Name: RestrictionShapeTypes RestrictionShapeTypes_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionShapeTypes"
    ADD CONSTRAINT "RestrictionShapeTypes_Code_key" UNIQUE ("Code");


--
-- Name: RestrictionStatus RestrictionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionStatus"
    ADD CONSTRAINT "RestrictionStatus_pkey" PRIMARY KEY (id);


--
-- Name: RestrictionTypes RestrictionTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionTypes"
    ADD CONSTRAINT "RestrictionTypes_pkey" PRIMARY KEY (id);


--
-- Name: RestrictionsInProposals RestrictionsInProposals_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_pk" PRIMARY KEY ("ProposalID", "RestrictionTableID", "RestrictionID");


--
-- Name: RoadCentreLine RoadCentreLine_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY public."RoadCentreLine"
    ADD CONSTRAINT "RoadCentreLine_pkey" PRIMARY KEY (gid);


--
-- Name: SignFadedTypes SignFadedTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SignFadedTypes"
    ADD CONSTRAINT "SignFadedTypes_pkey" PRIMARY KEY (id);


--
-- Name: SignMountTypes SignMounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SignMountTypes"
    ADD CONSTRAINT "SignMounts_pkey" PRIMARY KEY (id);


--
-- Name: SignObscurredTypes SignObscurredTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SignObscurredTypes"
    ADD CONSTRAINT "SignObscurredTypes_pkey" PRIMARY KEY (id);


--
-- Name: SignTypes SignTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SignTypes"
    ADD CONSTRAINT "SignTypes_pkey" PRIMARY KEY (id);


--
-- Name: Signs Signs_RestrictionID_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Signs"
    ADD CONSTRAINT "Signs_RestrictionID_key" UNIQUE ("RestrictionID");


--
-- Name: Signs Signs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Signs"
    ADD CONSTRAINT "Signs_pkey" PRIMARY KEY ("GeometryID");


--
-- Name: Surveyors Surveyors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Surveyors"
    ADD CONSTRAINT "Surveyors_pkey" PRIMARY KEY ("Code");


--
-- Name: TicketMachineIssueTypes TicketMachineIssueTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TicketMachineIssueTypes"
    ADD CONSTRAINT "TicketMachineIssueTypes_pkey" PRIMARY KEY (id);


--
-- Name: TilesInAcceptedProposals TilesInAcceptedProposals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_pkey" PRIMARY KEY ("ProposalID", "TileNr", "RevisionNr");


--
-- Name: TimePeriods_orig TimePeriods_180124_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TimePeriods_orig"
    ADD CONSTRAINT "TimePeriods_180124_pkey" PRIMARY KEY (id);


--
-- Name: TimePeriods_orig TimePeriods_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TimePeriods_orig"
    ADD CONSTRAINT "TimePeriods_Code_key" UNIQUE ("Code");


--
-- Name: TimePeriods TimePeriods_Code_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TimePeriods"
    ADD CONSTRAINT "TimePeriods_Code_key1" UNIQUE ("Code");


--
-- Name: TimePeriods TimePeriods_Description_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TimePeriods"
    ADD CONSTRAINT "TimePeriods_Description_key" UNIQUE ("Description");


--
-- Name: TimePeriods TimePeriods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TimePeriods"
    ADD CONSTRAINT "TimePeriods_pkey" PRIMARY KEY (id);


--
-- Name: baysWordingTypes baysWordingTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."baysWordingTypes"
    ADD CONSTRAINT "baysWordingTypes_pkey" PRIMARY KEY (id);


--
-- Name: baytypes baytypes_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.baytypes
    ADD CONSTRAINT "baytypes_Code_key" UNIQUE ("Code");


--
-- Name: baytypes baytypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.baytypes
    ADD CONSTRAINT baytypes_pkey PRIMARY KEY (gid);


--
-- Name: ControlledParkingZones controlledparkingzones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ControlledParkingZones"
    ADD CONSTRAINT controlledparkingzones_pkey PRIMARY KEY (gid);


--
-- Name: layer_styles layer_styles_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY public.layer_styles
    ADD CONSTRAINT layer_styles_pkey PRIMARY KEY (id);


--
-- Name: linetypes linetypes2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.linetypes
    ADD CONSTRAINT linetypes2_pkey PRIMARY KEY (gid);


--
-- Name: linetypes linetypes_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.linetypes
    ADD CONSTRAINT "linetypes_Code_key" UNIQUE ("Code");


--
-- Name: RestrictionPolygons restrictionsPolygons_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionPolygons"
    ADD CONSTRAINT "restrictionsPolygons_pk" PRIMARY KEY ("GeometryID");


--
-- Name: SignAttachmentTypes signAttachmentTypes2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SignAttachmentTypes"
    ADD CONSTRAINT "signAttachmentTypes2_pkey" PRIMARY KEY (id);


--
-- Name: signs signs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.signs
    ADD CONSTRAINT signs_pkey PRIMARY KEY (gid);


--
-- Name: BayLineTypes_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "BayLineTypes_key" ON public."BayLineTypes" USING btree ("Code");


--
-- Name: BayTypes_key; Type: INDEX; Schema: public; Owner: postgres
--

--CREATE UNIQUE INDEX "BayTypes_key" ON public."BayTypes" USING btree ("Code");


--
-- Name: LineTypes_key; Type: INDEX; Schema: public; Owner: postgres
--

--CREATE UNIQUE INDEX "LineTypes_key" ON public."LineTypes" USING btree ("Code");


--
-- Name: Lines_EDI_180124_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Lines_EDI_180124_idx" ON public."Lines" USING gist (geom);


--
-- Name: controlledparkingzones_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX controlledparkingzones_geom_idx ON public."ControlledParkingZones" USING gist (geom);


--
-- Name: sidx_Bays_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_Bays_geom" ON public."Bays" USING gist (geom);


--
-- Name: sidx_CPZs_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_CPZs_geom" ON public."CPZs" USING gist (geom);


--
-- Name: sidx_EDI01_Signs_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_EDI01_Signs_geom" ON public."Signs" USING gist (geom);


--
-- Name: sidx_EDI_RoadCasement_Polyline_geom; Type: INDEX; Schema: public; Owner: edi_operator
--

CREATE INDEX "sidx_EDI_RoadCasement_Polyline_geom" ON public."EDI_RoadCasement_Polyline" USING gist (geom);


--
-- Name: sidx_EDI_Sections_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_EDI_Sections_geom" ON public."EDI_Sections" USING gist (geom);


--
-- Name: sidx_Lines_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_Lines_geom" ON public."Lines" USING gist (geom);


--
-- Name: sidx_MapGrid_geom; Type: INDEX; Schema: public; Owner: edi_operator
--

CREATE INDEX "sidx_MapGrid_geom" ON public."MapGrid" USING gist (geom);


--
-- Name: sidx_PTAs_180725_merged_10_geom; Type: INDEX; Schema: public; Owner: edi_operator
--

CREATE INDEX "sidx_PTAs_180725_merged_10_geom" ON public."ParkingTariffAreas" USING gist (geom);


--
-- Name: sidx_RoadCentreLine_geom; Type: INDEX; Schema: public; Owner: edi_operator
--

CREATE INDEX "sidx_RoadCentreLine_geom" ON public."RoadCentreLine" USING gist (geom);


--
-- Name: sidx_restrictionPolygons_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_restrictionPolygons_geom" ON public."RestrictionPolygons" USING gist (geom);


--
-- Name: signs_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX signs_geom_idx ON public.signs USING gist (geom);


--
-- Name: Bays Bays_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bays"
    ADD CONSTRAINT "Bays_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES public."RestrictionShapeTypes"("Code");


--
-- Name: Bays Bays_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bays"
    ADD CONSTRAINT "Bays_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES public."BayLineTypesInUse"("Code");


--
-- Name: Bays Bays_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bays"
    ADD CONSTRAINT "Bays_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES public."TimePeriods"("Code");


--
-- Name: Lines Lines_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Lines"
    ADD CONSTRAINT "Lines_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES public."RestrictionShapeTypes"("Code");


--
-- Name: Lines Lines_NoWaitingTimeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Lines"
    ADD CONSTRAINT "Lines_NoWaitingTimeID_fkey" FOREIGN KEY ("NoWaitingTimeID") REFERENCES public."TimePeriods"("Code");


--
-- Name: Lines Lines_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Lines"
    ADD CONSTRAINT "Lines_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES public."BayLineTypesInUse"("Code");


--
-- Name: Proposals Proposals_ProposalStatusID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Proposals"
    ADD CONSTRAINT "Proposals_ProposalStatusID_fkey" FOREIGN KEY ("ProposalStatusID") REFERENCES public."ProposalStatusTypes"("Code");


--
-- Name: RestrictionsInProposals RestrictionsInProposals_ActionOnProposalAcceptance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ActionOnProposalAcceptance_fkey" FOREIGN KEY ("ActionOnProposalAcceptance") REFERENCES public."ActionOnProposalAcceptanceTypes"(id);


--
-- Name: RestrictionsInProposals RestrictionsInProposals_ProposalID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ProposalID_fkey" FOREIGN KEY ("ProposalID") REFERENCES public."Proposals"("ProposalID");


--
-- Name: RestrictionsInProposals RestrictionsInProposals_RestrictionTableID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_RestrictionTableID_fkey" FOREIGN KEY ("RestrictionTableID") REFERENCES public."RestrictionLayers"(id);


--
-- Name: Proposals; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."Proposals" ENABLE ROW LEVEL SECURITY;

--
-- Name: Proposals insertProposals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "insertProposals" ON public."Proposals" FOR INSERT TO edi_operator WITH CHECK (("ProposalStatusID" <> 2));


--
-- Name: Proposals insertProposals_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "insertProposals_admin" ON public."Proposals" FOR INSERT TO edi_admin WITH CHECK (("ProposalStatusID" <> 2));


--
-- Name: Proposals selectProposals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "selectProposals" ON public."Proposals" FOR SELECT TO PUBLIC USING (true);


--
-- Name: Proposals updateProposals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "updateProposals" ON public."Proposals" FOR UPDATE TO edi_operator USING (true) WITH CHECK (("ProposalStatusID" <> 2));


--
-- Name: Proposals updateProposals_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "updateProposals_admin" ON public."Proposals" FOR UPDATE TO edi_admin USING (true);


--
-- Name: TABLE "ActionOnProposalAcceptanceTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."ActionOnProposalAcceptanceTypes" TO edi_operator;
GRANT SELECT ON TABLE public."ActionOnProposalAcceptanceTypes" TO edi_public;
GRANT SELECT ON TABLE public."ActionOnProposalAcceptanceTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."ActionOnProposalAcceptanceTypes" TO edi_admin;


--
-- Name: SEQUENCE "ActionOnProposalAcceptanceTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."ActionOnProposalAcceptanceTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."ActionOnProposalAcceptanceTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."ActionOnProposalAcceptanceTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."ActionOnProposalAcceptanceTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "BayLineTypesInUse"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."BayLineTypesInUse" TO edi_admin;
GRANT SELECT ON TABLE public."BayLineTypesInUse" TO edi_operator;
GRANT SELECT ON TABLE public."BayLineTypesInUse" TO edi_public;
GRANT SELECT ON TABLE public."BayLineTypesInUse" TO edi_public_nsl;


--
-- Name: TABLE "BayLineTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."BayLineTypes" TO edi_admin;
GRANT SELECT ON TABLE public."BayLineTypes" TO edi_operator;
GRANT SELECT ON TABLE public."BayLineTypes" TO edi_public;
GRANT SELECT ON TABLE public."BayLineTypes" TO edi_public_nsl;


--
-- Name: TABLE "BayLinesFadedTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."BayLinesFadedTypes" TO edi_operator;
GRANT SELECT ON TABLE public."BayLinesFadedTypes" TO edi_public;
GRANT SELECT ON TABLE public."BayLinesFadedTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."BayLinesFadedTypes" TO edi_admin;


--
-- Name: SEQUENCE "BayLinesFadedTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."BayLinesFadedTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."BayLinesFadedTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."BayLinesFadedTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."BayLinesFadedTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "BayTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."BayTypes" TO edi_admin;
GRANT SELECT ON TABLE public."BayTypes" TO edi_operator;
GRANT SELECT ON TABLE public."BayTypes" TO edi_public;
GRANT SELECT ON TABLE public."BayTypes" TO edi_public_nsl;


--
-- Name: SEQUENCE "Bays2_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."Bays2_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."Bays2_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."Bays2_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."Bays2_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "Bays"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Bays" TO edi_operator;
GRANT SELECT ON TABLE public."Bays" TO edi_public;
GRANT SELECT ON TABLE public."Bays" TO edi_public_nsl;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Bays" TO edi_admin;


--
-- Name: TABLE "BaysLines_SignIssueTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."BaysLines_SignIssueTypes" TO edi_operator;
GRANT SELECT ON TABLE public."BaysLines_SignIssueTypes" TO edi_public;
GRANT SELECT ON TABLE public."BaysLines_SignIssueTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."BaysLines_SignIssueTypes" TO edi_admin;


--
-- Name: SEQUENCE "BaysLines_SignIssueTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."BaysLines_SignIssueTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."BaysLines_SignIssueTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."BaysLines_SignIssueTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."BaysLines_SignIssueTypes_id_seq" TO edi_public_nsl;


--
-- Name: SEQUENCE "CECStatusTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."CECStatusTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."CECStatusTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."CECStatusTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."CECStatusTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "CPZs"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."CPZs" TO edi_public;
GRANT SELECT ON TABLE public."CPZs" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."CPZs" TO edi_admin;


--
-- Name: TABLE "ControlledParkingZones"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."ControlledParkingZones" TO edi_operator;
GRANT SELECT ON TABLE public."ControlledParkingZones" TO edi_public;
GRANT SELECT ON TABLE public."ControlledParkingZones" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."ControlledParkingZones" TO edi_admin;


--
-- Name: TABLE "Signs"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Signs" TO edi_operator;
GRANT SELECT ON TABLE public."Signs" TO edi_public;
GRANT SELECT ON TABLE public."Signs" TO edi_public_nsl;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Signs" TO edi_admin;


--
-- Name: SEQUENCE "EDI01_Signs_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."EDI01_Signs_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."EDI01_Signs_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."EDI01_Signs_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."EDI01_Signs_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "EDI_RoadCasement_Polyline"; Type: ACL; Schema: public; Owner: edi_operator
--

REVOKE ALL ON TABLE public."EDI_RoadCasement_Polyline" FROM edi_operator;
GRANT SELECT ON TABLE public."EDI_RoadCasement_Polyline" TO edi_public;
GRANT SELECT ON TABLE public."EDI_RoadCasement_Polyline" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."EDI_RoadCasement_Polyline" TO edi_admin;


--
-- Name: TABLE "EDI_Sections"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."EDI_Sections" TO edi_public;
GRANT SELECT ON TABLE public."EDI_Sections" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."EDI_Sections" TO edi_admin;


--
-- Name: TABLE "LengthOfTime"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."LengthOfTime" TO edi_operator;
GRANT SELECT ON TABLE public."LengthOfTime" TO edi_public;
GRANT SELECT ON TABLE public."LengthOfTime" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."LengthOfTime" TO edi_admin;


--
-- Name: SEQUENCE "LengthOfTime_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."LengthOfTime_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."LengthOfTime_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."LengthOfTime_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."LengthOfTime_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "LineTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."LineTypes" TO edi_admin;
GRANT SELECT ON TABLE public."LineTypes" TO edi_operator;
GRANT SELECT ON TABLE public."LineTypes" TO edi_public;
GRANT SELECT ON TABLE public."LineTypes" TO edi_public_nsl;


--
-- Name: SEQUENCE "Lines2_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."Lines2_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."Lines2_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."Lines2_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."Lines2_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "Lines"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Lines" TO edi_operator;
GRANT SELECT ON TABLE public."Lines" TO edi_public;
GRANT SELECT ON TABLE public."Lines" TO edi_public_nsl;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Lines" TO edi_admin;


--
-- Name: TABLE "MapGrid"; Type: ACL; Schema: public; Owner: edi_operator
--

REVOKE ALL ON TABLE public."MapGrid" FROM edi_operator;
GRANT SELECT ON TABLE public."MapGrid" TO edi_operator;
GRANT SELECT ON TABLE public."MapGrid" TO edi_public;
GRANT SELECT ON TABLE public."MapGrid" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."MapGrid" TO edi_admin;


--
-- Name: TABLE "ParkingTariffAreas"; Type: ACL; Schema: public; Owner: edi_operator
--

REVOKE ALL ON TABLE public."ParkingTariffAreas" FROM edi_operator;
GRANT SELECT ON TABLE public."ParkingTariffAreas" TO edi_operator;
GRANT SELECT ON TABLE public."ParkingTariffAreas" TO edi_public;
GRANT SELECT ON TABLE public."ParkingTariffAreas" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."ParkingTariffAreas" TO edi_admin;


--
-- Name: SEQUENCE "PTAs_180725_merged_10_id_seq"; Type: ACL; Schema: public; Owner: edi_operator
--

GRANT SELECT,USAGE ON SEQUENCE public."PTAs_180725_merged_10_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."PTAs_180725_merged_10_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."PTAs_180725_merged_10_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "PaymentTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."PaymentTypes" TO edi_operator;
GRANT SELECT ON TABLE public."PaymentTypes" TO edi_public;
GRANT SELECT ON TABLE public."PaymentTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."PaymentTypes" TO edi_admin;


--
-- Name: SEQUENCE "PaymentTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."PaymentTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."PaymentTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."PaymentTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."PaymentTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "ProposalStatusTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."ProposalStatusTypes" TO edi_operator;
GRANT SELECT ON TABLE public."ProposalStatusTypes" TO edi_public;
GRANT SELECT ON TABLE public."ProposalStatusTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."ProposalStatusTypes" TO edi_admin;


--
-- Name: SEQUENCE "ProposalStatusTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."ProposalStatusTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."ProposalStatusTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."ProposalStatusTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."ProposalStatusTypes_id_seq" TO edi_public_nsl;


--
-- Name: SEQUENCE "Proposals_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."Proposals_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."Proposals_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."Proposals_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."Proposals_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "Proposals"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Proposals" TO edi_operator;
GRANT SELECT ON TABLE public."Proposals" TO edi_public;
GRANT SELECT ON TABLE public."Proposals" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Proposals" TO edi_admin;


--
-- Name: TABLE "Proposals_withGeom"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."Proposals_withGeom" TO edi_public;
GRANT SELECT ON TABLE public."Proposals_withGeom" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Proposals_withGeom" TO edi_admin;


--
-- Name: TABLE "RestrictionTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."RestrictionTypes" TO edi_operator;
GRANT SELECT ON TABLE public."RestrictionTypes" TO edi_public;
GRANT SELECT ON TABLE public."RestrictionTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."RestrictionTypes" TO edi_admin;


--
-- Name: TABLE "RestrictionsInProposals"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE ON TABLE public."RestrictionsInProposals" TO edi_operator;
GRANT SELECT ON TABLE public."RestrictionsInProposals" TO edi_public;
GRANT SELECT ON TABLE public."RestrictionsInProposals" TO edi_public_nsl;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."RestrictionsInProposals" TO edi_admin;


--
-- Name: SEQUENCE "TimePeriods_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."TimePeriods_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."TimePeriods_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."TimePeriods_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."TimePeriods_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "TimePeriods_orig"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."TimePeriods_orig" TO edi_operator;
GRANT SELECT ON TABLE public."TimePeriods_orig" TO edi_public;
GRANT SELECT ON TABLE public."TimePeriods_orig" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."TimePeriods_orig" TO edi_admin;


--
-- Name: TABLE "Proposed Order Items"; Type: ACL; Schema: public; Owner: edi_admin
--

REVOKE ALL ON TABLE public."Proposed Order Items" FROM edi_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Proposed Order Items" TO edi_admin;


--
-- Name: TABLE "Proposed Order Restrictions List"; Type: ACL; Schema: public; Owner: edi_admin
--

REVOKE ALL ON TABLE public."Proposed Order Restrictions List" FROM edi_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Proposed Order Restrictions List" TO edi_admin;


--
-- Name: TABLE "RestrictionShapeTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."RestrictionShapeTypes" TO edi_operator;
GRANT SELECT ON TABLE public."RestrictionShapeTypes" TO edi_public;
GRANT SELECT ON TABLE public."RestrictionShapeTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."RestrictionShapeTypes" TO edi_admin;


--
-- Name: SEQUENCE "RestrictionGeometryTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."RestrictionGeometryTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionGeometryTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionGeometryTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionGeometryTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "RestrictionLayers"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."RestrictionLayers" TO edi_operator;
GRANT SELECT ON TABLE public."RestrictionLayers" TO edi_public;
GRANT SELECT ON TABLE public."RestrictionLayers" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."RestrictionLayers" TO edi_admin;


--
-- Name: SEQUENCE "RestrictionLayers2_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."RestrictionLayers2_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionLayers2_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionLayers2_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionLayers2_id_seq" TO edi_public_nsl;


--
-- Name: SEQUENCE "RestrictionPolygonTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."RestrictionPolygonTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionPolygonTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionPolygonTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionPolygonTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "RestrictionPolygonTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."RestrictionPolygonTypes" TO edi_operator;
GRANT SELECT ON TABLE public."RestrictionPolygonTypes" TO edi_public;
GRANT SELECT ON TABLE public."RestrictionPolygonTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."RestrictionPolygonTypes" TO edi_admin;


--
-- Name: SEQUENCE "restrictionPolygons_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."restrictionPolygons_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."restrictionPolygons_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."restrictionPolygons_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."restrictionPolygons_seq" TO edi_public_nsl;


--
-- Name: TABLE "RestrictionPolygons"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."RestrictionPolygons" TO edi_operator;
GRANT SELECT ON TABLE public."RestrictionPolygons" TO edi_public;
GRANT SELECT ON TABLE public."RestrictionPolygons" TO edi_public_nsl;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."RestrictionPolygons" TO edi_admin;


--
-- Name: TABLE "RestrictionStatus"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."RestrictionStatus" TO edi_operator;
GRANT SELECT ON TABLE public."RestrictionStatus" TO edi_public;
GRANT SELECT ON TABLE public."RestrictionStatus" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."RestrictionStatus" TO edi_admin;


--
-- Name: SEQUENCE "RestrictionStatus_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."RestrictionStatus_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionStatus_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionStatus_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionStatus_id_seq" TO edi_public_nsl;


--
-- Name: SEQUENCE "RestrictionTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."RestrictionTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."RestrictionTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "RoadCentreLine"; Type: ACL; Schema: public; Owner: edi_operator
--

REVOKE ALL ON TABLE public."RoadCentreLine" FROM edi_operator;
GRANT SELECT ON TABLE public."RoadCentreLine" TO edi_public;
GRANT SELECT ON TABLE public."RoadCentreLine" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."RoadCentreLine" TO edi_admin;


--
-- Name: TABLE "SignAttachmentTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."SignAttachmentTypes" TO edi_operator;
GRANT SELECT ON TABLE public."SignAttachmentTypes" TO edi_public;
GRANT SELECT ON TABLE public."SignAttachmentTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."SignAttachmentTypes" TO edi_admin;


--
-- Name: TABLE "SignFadedTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."SignFadedTypes" TO edi_operator;
GRANT SELECT ON TABLE public."SignFadedTypes" TO edi_public;
GRANT SELECT ON TABLE public."SignFadedTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."SignFadedTypes" TO edi_admin;


--
-- Name: SEQUENCE "SignFadedTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."SignFadedTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."SignFadedTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."SignFadedTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."SignFadedTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "SignMountTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."SignMountTypes" TO edi_operator;
GRANT SELECT ON TABLE public."SignMountTypes" TO edi_public;
GRANT SELECT ON TABLE public."SignMountTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."SignMountTypes" TO edi_admin;


--
-- Name: SEQUENCE "SignMounts_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."SignMounts_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."SignMounts_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."SignMounts_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."SignMounts_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "SignObscurredTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."SignObscurredTypes" TO edi_operator;
GRANT SELECT ON TABLE public."SignObscurredTypes" TO edi_public;
GRANT SELECT ON TABLE public."SignObscurredTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."SignObscurredTypes" TO edi_admin;


--
-- Name: SEQUENCE "SignObscurredTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."SignObscurredTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."SignObscurredTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."SignObscurredTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."SignObscurredTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "SignTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."SignTypes" TO edi_operator;
GRANT SELECT ON TABLE public."SignTypes" TO edi_public;
GRANT SELECT ON TABLE public."SignTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."SignTypes" TO edi_admin;


--
-- Name: SEQUENCE "SignTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."SignTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."SignTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."SignTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."SignTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "Surveyors"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."Surveyors" TO edi_operator;
GRANT SELECT ON TABLE public."Surveyors" TO edi_public;
GRANT SELECT ON TABLE public."Surveyors" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Surveyors" TO edi_admin;


--
-- Name: SEQUENCE "Surveyors_Code_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."Surveyors_Code_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."Surveyors_Code_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."Surveyors_Code_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."Surveyors_Code_seq" TO edi_public_nsl;


--
-- Name: SEQUENCE "TROStatusTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."TROStatusTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."TROStatusTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."TROStatusTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."TROStatusTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "TicketMachineIssueTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."TicketMachineIssueTypes" TO edi_operator;
GRANT SELECT ON TABLE public."TicketMachineIssueTypes" TO edi_public;
GRANT SELECT ON TABLE public."TicketMachineIssueTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."TicketMachineIssueTypes" TO edi_admin;


--
-- Name: SEQUENCE "TicketMachineIssueTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."TicketMachineIssueTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."TicketMachineIssueTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."TicketMachineIssueTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."TicketMachineIssueTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "TilesInAcceptedProposals"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."TilesInAcceptedProposals" TO edi_operator;
GRANT SELECT ON TABLE public."TilesInAcceptedProposals" TO edi_public;
GRANT SELECT ON TABLE public."TilesInAcceptedProposals" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."TilesInAcceptedProposals" TO edi_admin;


--
-- Name: TABLE "TimePeriods"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."TimePeriods" TO edi_operator;
GRANT SELECT ON TABLE public."TimePeriods" TO edi_public;
GRANT SELECT ON TABLE public."TimePeriods" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."TimePeriods" TO edi_admin;


--
-- Name: TABLE "baysWordingTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."baysWordingTypes" TO edi_operator;
GRANT SELECT ON TABLE public."baysWordingTypes" TO edi_public;
GRANT SELECT ON TABLE public."baysWordingTypes" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."baysWordingTypes" TO edi_admin;


--
-- Name: SEQUENCE "baysWordingTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."baysWordingTypes_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."baysWordingTypes_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."baysWordingTypes_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."baysWordingTypes_id_seq" TO edi_public_nsl;


--
-- Name: TABLE baytypes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.baytypes TO edi_operator;
GRANT SELECT ON TABLE public.baytypes TO edi_public;
GRANT SELECT ON TABLE public.baytypes TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public.baytypes TO edi_admin;


--
-- Name: SEQUENCE baytypes_gid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.baytypes_gid_seq TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public.baytypes_gid_seq TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.baytypes_gid_seq TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.baytypes_gid_seq TO edi_public_nsl;


--
-- Name: SEQUENCE controlledparkingzones_gid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.controlledparkingzones_gid_seq TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.controlledparkingzones_gid_seq TO edi_public_nsl;
GRANT SELECT,USAGE ON SEQUENCE public.controlledparkingzones_gid_seq TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public.controlledparkingzones_gid_seq TO edi_public;


--
-- Name: SEQUENCE corners_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.corners_seq TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public.corners_seq TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.corners_seq TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.corners_seq TO edi_public_nsl;


--
-- Name: SEQUENCE issueid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.issueid_seq TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public.issueid_seq TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.issueid_seq TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.issueid_seq TO edi_public_nsl;


--
-- Name: TABLE layer_styles; Type: ACL; Schema: public; Owner: edi_operator
--

REVOKE ALL ON TABLE public.layer_styles FROM edi_operator;
GRANT SELECT ON TABLE public.layer_styles TO edi_public;
GRANT SELECT ON TABLE public.layer_styles TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public.layer_styles TO edi_admin;


--
-- Name: SEQUENCE layer_styles_id_seq; Type: ACL; Schema: public; Owner: edi_operator
--

GRANT SELECT,USAGE ON SEQUENCE public.layer_styles_id_seq TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public.layer_styles_id_seq TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.layer_styles_id_seq TO edi_public_nsl;


--
-- Name: TABLE linetypes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.linetypes TO edi_operator;
GRANT SELECT ON TABLE public.linetypes TO edi_public;
GRANT SELECT ON TABLE public.linetypes TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public.linetypes TO edi_admin;


--
-- Name: SEQUENCE linetypes2_gid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.linetypes2_gid_seq TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public.linetypes2_gid_seq TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.linetypes2_gid_seq TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.linetypes2_gid_seq TO edi_public_nsl;


--
-- Name: SEQUENCE pta_ref; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.pta_ref TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public.pta_ref TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.pta_ref TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.pta_ref TO edi_public_nsl;


--
-- Name: SEQUENCE serial; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.serial TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public.serial TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.serial TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.serial TO edi_public_nsl;


--
-- Name: SEQUENCE "signAttachmentTypes2_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."signAttachmentTypes2_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."signAttachmentTypes2_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."signAttachmentTypes2_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."signAttachmentTypes2_id_seq" TO edi_public_nsl;


--
-- Name: TABLE signs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.signs TO edi_public;
GRANT SELECT ON TABLE public.signs TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public.signs TO edi_admin;


--
-- Name: SEQUENCE signs_gid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.signs_gid_seq TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public.signs_gid_seq TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.signs_gid_seq TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.signs_gid_seq TO edi_public_nsl;


--
-- PostgreSQL database dump complete
--

