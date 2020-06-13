--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-06-13 22:21:34

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
-- TOC entry 4 (class 3079 OID 285270)
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "dblink" WITH SCHEMA "public";


--
-- TOC entry 4297 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION "dblink"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "dblink" IS 'connect to other PostgreSQL databases from within a database';


--
-- TOC entry 3 (class 3079 OID 285316)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "postgis" WITH SCHEMA "public";


--
-- TOC entry 4298 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "postgis"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "postgis" IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- TOC entry 2 (class 3079 OID 286318)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "public";


--
-- TOC entry 4299 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 211 (class 1259 OID 286329)
-- Name: ActionOnProposalAcceptanceTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."ActionOnProposalAcceptanceTypes" (
    "id" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "public"."ActionOnProposalAcceptanceTypes" OWNER TO "postgres";

--
-- TOC entry 212 (class 1259 OID 286335)
-- Name: ActionOnProposalAcceptanceTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."ActionOnProposalAcceptanceTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."ActionOnProposalAcceptanceTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4301 (class 0 OID 0)
-- Dependencies: 212
-- Name: ActionOnProposalAcceptanceTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."ActionOnProposalAcceptanceTypes_id_seq" OWNED BY "public"."ActionOnProposalAcceptanceTypes"."id";


--
-- TOC entry 213 (class 1259 OID 286337)
-- Name: BayLineTypesInUse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."BayLineTypesInUse" (
    "gid" integer NOT NULL,
    "Code" integer
);


ALTER TABLE "public"."BayLineTypesInUse" OWNER TO "postgres";

--
-- TOC entry 214 (class 1259 OID 286340)
-- Name: BayLineTypes; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW "public"."BayLineTypes" AS
 SELECT "BayLineTypes"."Code",
    "BayLineTypes"."Description"
   FROM ( SELECT "BayLineTypes_1"."Code",
            "BayLineTypes_1"."Description"
           FROM "public"."dblink"('dbname=MasterLookups options=-csearch_path='::"text", 'SELECT "Code", "Description" FROM public."BayLineTypes"'::"text") "BayLineTypes_1"("Code" integer, "Description" "text")) "BayLineTypes",
    "public"."BayLineTypesInUse" "u"
  WHERE ("BayLineTypes"."Code" = "u"."Code")
  WITH NO DATA;


ALTER TABLE "public"."BayLineTypes" OWNER TO "postgres";

--
-- TOC entry 215 (class 1259 OID 286347)
-- Name: BayLineTypesInUse_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."BayLineTypesInUse_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."BayLineTypesInUse_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4305 (class 0 OID 0)
-- Dependencies: 215
-- Name: BayLineTypesInUse_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."BayLineTypesInUse_gid_seq" OWNED BY "public"."BayLineTypesInUse"."gid";


--
-- TOC entry 216 (class 1259 OID 286349)
-- Name: BayLinesFadedTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."BayLinesFadedTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying,
    "Comment" character varying
);


ALTER TABLE "public"."BayLinesFadedTypes" OWNER TO "postgres";

--
-- TOC entry 217 (class 1259 OID 286355)
-- Name: BayLinesFadedTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."BayLinesFadedTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."BayLinesFadedTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4307 (class 0 OID 0)
-- Dependencies: 217
-- Name: BayLinesFadedTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."BayLinesFadedTypes_id_seq" OWNED BY "public"."BayLinesFadedTypes"."id";


--
-- TOC entry 218 (class 1259 OID 286357)
-- Name: BayTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."BayTypes" (
    "Code" integer,
    "Description" "text"
);


ALTER TABLE "public"."BayTypes" OWNER TO "postgres";

--
-- TOC entry 219 (class 1259 OID 286364)
-- Name: Bays2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."Bays2_id_seq"
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."Bays2_id_seq" OWNER TO "postgres";

--
-- TOC entry 220 (class 1259 OID 286366)
-- Name: Bays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."Bays" (
    "id" integer,
    "geom" "public"."geometry"(LineString,27700) NOT NULL,
    "Length" double precision,
    "RestrictionTypeID" integer,
    "NrBays" integer,
    "TimePeriodID" integer,
    "PayTypeID" integer,
    "MaxStayID" integer,
    "NoReturnID" integer,
    "Notes" character varying(254),
    "GeometryID" character varying(10) DEFAULT ('B_'::"text" || "to_char"("nextval"('"public"."Bays2_id_seq"'::"regclass"), '0000000'::"text")) NOT NULL,
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
    "OpenDate" "date",
    "CloseDate" "date",
    "CPZ" character varying(40),
    "ParkingTariffArea" character varying(10),
    "OriginalGeomShapeID" integer,
    "GeometryID_181017" character varying(254),
    "RestrictionID" character varying(254) NOT NULL
);


ALTER TABLE "public"."Bays" OWNER TO "postgres";

--
-- TOC entry 221 (class 1259 OID 286373)
-- Name: BaysLines_SignIssueTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."BaysLines_SignIssueTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying,
    "Comment" character varying
);


ALTER TABLE "public"."BaysLines_SignIssueTypes" OWNER TO "postgres";

--
-- TOC entry 222 (class 1259 OID 286379)
-- Name: BaysLines_SignIssueTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."BaysLines_SignIssueTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."BaysLines_SignIssueTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4313 (class 0 OID 0)
-- Dependencies: 222
-- Name: BaysLines_SignIssueTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."BaysLines_SignIssueTypes_id_seq" OWNED BY "public"."BaysLines_SignIssueTypes"."id";


--
-- TOC entry 223 (class 1259 OID 286381)
-- Name: CECStatusTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."CECStatusTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."CECStatusTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 224 (class 1259 OID 286383)
-- Name: CPZs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."CPZs" (
    "gid" integer NOT NULL,
    "geom" "public"."geometry"(MultiPolygon,27700),
    "cacz_ref_n" character varying(2),
    "date_last_" character varying(10),
    "no_osp_spa" double precision,
    "no_pnr_spa" double precision,
    "no_pub_spa" double precision,
    "no_res_spa" double precision,
    "zone_no" character varying(40),
    "type" character varying(40),
    "WaitingTimeID" integer
);


ALTER TABLE "public"."CPZs" OWNER TO "postgres";

--
-- TOC entry 225 (class 1259 OID 286389)
-- Name: ControlledParkingZones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."ControlledParkingZones" (
    "gid" integer NOT NULL,
    "cacz_ref_n" character varying(6),
    "date_last_" character varying(10),
    "no_osp_spa" numeric(10,0),
    "no_pnr_spa" numeric(10,0),
    "no_pub_spa" numeric(10,0),
    "no_res_spa" numeric(10,0),
    "zone_no" character varying(40),
    "type" character varying(40),
    "geom" "public"."geometry"(Polygon,27700),
    "WaitingTimeID" integer,
    "CPZ" character varying(6),
    "OpenDate" "date",
    "CloseDate" "date",
    "RestrictionID" character varying(254),
    "GeometryID" character varying(15)
);


ALTER TABLE "public"."ControlledParkingZones" OWNER TO "postgres";

--
-- TOC entry 226 (class 1259 OID 286395)
-- Name: Signs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."Signs" (
    "id" integer,
    "geom" "public"."geometry"(Point,27700),
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
    "OpenDate" "date",
    "CloseDate" "date",
    "Signs_Photos_03" character varying(255),
    "GeometryID_181017" character varying(12),
    "RestrictionID" character varying(254) NOT NULL,
    "CPZ" character varying(40),
    "ParkingTariffArea" character varying(10)
);


ALTER TABLE "public"."Signs" OWNER TO "postgres";

--
-- TOC entry 227 (class 1259 OID 286401)
-- Name: EDI01_Signs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."EDI01_Signs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."EDI01_Signs_id_seq" OWNER TO "postgres";

--
-- TOC entry 4319 (class 0 OID 0)
-- Dependencies: 227
-- Name: EDI01_Signs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."EDI01_Signs_id_seq" OWNED BY "public"."Signs"."id";


--
-- TOC entry 228 (class 1259 OID 286403)
-- Name: EDI_RoadCasement_Polyline; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE "public"."EDI_RoadCasement_Polyline" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(LineString,27700),
    "OBJECTID_1" integer,
    "MidPt_ID" integer,
    "ESUID" double precision,
    "USRN" integer,
    "StreetName" character varying(254),
    "Locality" character varying(255),
    "Town" character varying(255),
    "Shape_Length" double precision
);


ALTER TABLE "public"."EDI_RoadCasement_Polyline" OWNER TO "edi_operator";

--
-- TOC entry 229 (class 1259 OID 286409)
-- Name: EDI_Sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."EDI_Sections" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(Polygon,27700),
    "objectid_1" bigint,
    "objectid" bigint,
    "name" character varying(100),
    "shape_leng" double precision,
    "newname" character varying(100),
    "area" integer,
    "comment" character varying(254),
    "shape_le_1" double precision,
    "shape_area" double precision
);


ALTER TABLE "public"."EDI_Sections" OWNER TO "postgres";

--
-- TOC entry 230 (class 1259 OID 286415)
-- Name: LengthOfTime; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."LengthOfTime" (
    "id" integer NOT NULL,
    "Code" bigint,
    "Description" character varying,
    "LabelText" character varying(255)
);


ALTER TABLE "public"."LengthOfTime" OWNER TO "postgres";

--
-- TOC entry 231 (class 1259 OID 286421)
-- Name: LengthOfTime_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."LengthOfTime_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."LengthOfTime_id_seq" OWNER TO "postgres";

--
-- TOC entry 4324 (class 0 OID 0)
-- Dependencies: 231
-- Name: LengthOfTime_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."LengthOfTime_id_seq" OWNED BY "public"."LengthOfTime"."id";


--
-- TOC entry 232 (class 1259 OID 286423)
-- Name: LineTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."LineTypes" (
    "Code" integer,
    "Description" "text"
);


ALTER TABLE "public"."LineTypes" OWNER TO "postgres";

--
-- TOC entry 233 (class 1259 OID 286430)
-- Name: Lines2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."Lines2_id_seq"
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."Lines2_id_seq" OWNER TO "postgres";

--
-- TOC entry 234 (class 1259 OID 286432)
-- Name: Lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."Lines" (
    "id" integer,
    "geom" "public"."geometry"(LineString,27700) NOT NULL,
    "Length" double precision,
    "RestrictionTypeID" integer,
    "NoWaitingTimeID" integer,
    "NoLoadingTimeID" integer,
    "Notes" character varying(254),
    "GeometryID" character varying(20) DEFAULT ('L_'::"text" || "to_char"("nextval"('"public"."Lines2_id_seq"'::"regclass"), '0000000'::"text")) NOT NULL,
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
    "OpenDate" "date",
    "CloseDate" "date",
    "CPZ" character varying(40),
    "ParkingTariffArea" character varying(10),
    "labelLoadingX" double precision,
    "labelLoadingY" double precision,
    "labelLoadingRotation" double precision,
    "TRO_Status_180409" integer,
    "GeometryID_181017" character varying(254),
    "RestrictionID" character varying(254) NOT NULL
);


ALTER TABLE "public"."Lines" OWNER TO "postgres";

--
-- TOC entry 235 (class 1259 OID 286439)
-- Name: LookupCodeTransfers_Bays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."LookupCodeTransfers_Bays" (
    "id" integer NOT NULL,
    "Aug2018_Description" character varying,
    "Aug2018_Code" character varying,
    "CurrCode" character varying
);


ALTER TABLE "public"."LookupCodeTransfers_Bays" OWNER TO "postgres";

--
-- TOC entry 236 (class 1259 OID 286445)
-- Name: LookupCodeTransfers_Lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."LookupCodeTransfers_Lines" (
    "id" integer NOT NULL,
    "Aug2018_Description" character varying,
    "Aug2018_Code" character varying,
    "CurrCode" character varying
);


ALTER TABLE "public"."LookupCodeTransfers_Lines" OWNER TO "postgres";

--
-- TOC entry 237 (class 1259 OID 286451)
-- Name: MapGrid; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE "public"."MapGrid" (
    "id" bigint NOT NULL,
    "geom" "public"."geometry"(MultiPolygon,27700),
    "x_min" double precision,
    "x_max" double precision,
    "y_min" double precision,
    "y_max" double precision,
    "RevisionNr" integer,
    "Edge" character varying(5),
    "CPZ tile" integer,
    "ContainsRes" integer,
    "LastRevisionDate" "date"
);


ALTER TABLE "public"."MapGrid" OWNER TO "edi_operator";

--
-- TOC entry 238 (class 1259 OID 286457)
-- Name: ParkingTariffAreas; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE "public"."ParkingTariffAreas" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(Polygon,27700),
    "gid" integer,
    "fid_parkin" integer,
    "tro_ref" numeric,
    "charge" character varying(255),
    "cost" character varying(255),
    "hours" character varying(255),
    "Name" character varying(255),
    "NoReturnTimeID" integer,
    "MaxStayID" integer,
    "TimePeriodID" integer,
    "OBJECTID" integer,
    "name_orig" character varying(255),
    "Shape_Leng" numeric,
    "Shape_Area" numeric,
    "OpenDate" "date",
    "CloseDate" "date",
    "RestrictionID" character varying(254),
    "GeometryID" character varying(15)
);


ALTER TABLE "public"."ParkingTariffAreas" OWNER TO "edi_operator";

--
-- TOC entry 239 (class 1259 OID 286463)
-- Name: PTAs_180725_merged_10_id_seq; Type: SEQUENCE; Schema: public; Owner: edi_operator
--

CREATE SEQUENCE "public"."PTAs_180725_merged_10_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."PTAs_180725_merged_10_id_seq" OWNER TO "edi_operator";

--
-- TOC entry 4331 (class 0 OID 0)
-- Dependencies: 239
-- Name: PTAs_180725_merged_10_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: edi_operator
--

ALTER SEQUENCE "public"."PTAs_180725_merged_10_id_seq" OWNED BY "public"."ParkingTariffAreas"."id";


--
-- TOC entry 240 (class 1259 OID 286465)
-- Name: PaymentTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."PaymentTypes" (
    "id" integer NOT NULL,
    "Code" bigint,
    "Description" character varying
);


ALTER TABLE "public"."PaymentTypes" OWNER TO "postgres";

--
-- TOC entry 241 (class 1259 OID 286471)
-- Name: PaymentTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."PaymentTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."PaymentTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4334 (class 0 OID 0)
-- Dependencies: 241
-- Name: PaymentTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."PaymentTypes_id_seq" OWNED BY "public"."PaymentTypes"."id";


--
-- TOC entry 242 (class 1259 OID 286473)
-- Name: ProposalStatusTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."ProposalStatusTypes" (
    "id" integer NOT NULL,
    "Description" character varying,
    "Code" integer
);


ALTER TABLE "public"."ProposalStatusTypes" OWNER TO "postgres";

--
-- TOC entry 243 (class 1259 OID 286479)
-- Name: ProposalStatusTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."ProposalStatusTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."ProposalStatusTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4337 (class 0 OID 0)
-- Dependencies: 243
-- Name: ProposalStatusTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."ProposalStatusTypes_id_seq" OWNED BY "public"."ProposalStatusTypes"."id";


--
-- TOC entry 244 (class 1259 OID 286481)
-- Name: Proposals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."Proposals_id_seq"
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."Proposals_id_seq" OWNER TO "postgres";

--
-- TOC entry 245 (class 1259 OID 286483)
-- Name: Proposals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."Proposals" (
    "ProposalID" integer DEFAULT "nextval"('"public"."Proposals_id_seq"'::"regclass") NOT NULL,
    "ProposalStatusID" integer,
    "ProposalCreateDate" "date",
    "ProposalNotes" character varying,
    "ProposalTitle" character varying(255) NOT NULL,
    "ProposalOpenDate" "date"
);


ALTER TABLE "public"."Proposals" OWNER TO "postgres";

--
-- TOC entry 246 (class 1259 OID 286490)
-- Name: Proposals_withGeom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."Proposals_withGeom" (
    "ProposalID" integer,
    "ProposalStatusID" integer,
    "ProposalCreateDate" "date",
    "ProposalNotes" character varying,
    "ProposalTitle" character varying(255) NOT NULL,
    "ProposalOpenDate" "date"
);


ALTER TABLE "public"."Proposals_withGeom" OWNER TO "postgres";

--
-- TOC entry 247 (class 1259 OID 286496)
-- Name: RestrictionTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionTypes" (
    "id" integer NOT NULL,
    "PK_UID" bigint,
    "Description" character varying,
    "OrigOrderCode" double precision
);


ALTER TABLE "public"."RestrictionTypes" OWNER TO "postgres";

--
-- TOC entry 248 (class 1259 OID 286502)
-- Name: RestrictionsInProposals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionsInProposals" (
    "ProposalID" integer NOT NULL,
    "RestrictionTableID" integer NOT NULL,
    "ActionOnProposalAcceptance" integer,
    "RestrictionID" character varying(255) NOT NULL
);


ALTER TABLE "public"."RestrictionsInProposals" OWNER TO "postgres";

--
-- TOC entry 249 (class 1259 OID 286505)
-- Name: TimePeriods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."TimePeriods_id_seq"
    START WITH 300
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."TimePeriods_id_seq" OWNER TO "postgres";

--
-- TOC entry 250 (class 1259 OID 286507)
-- Name: TimePeriods_orig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."TimePeriods_orig" (
    "id" integer DEFAULT "nextval"('"public"."TimePeriods_id_seq"'::"regclass") NOT NULL,
    "Code" integer,
    "Description" character varying,
    "LabelText" character varying(255)
);


ALTER TABLE "public"."TimePeriods_orig" OWNER TO "postgres";

--
-- TOC entry 251 (class 1259 OID 286514)
-- Name: Proposed Order Items; Type: VIEW; Schema: public; Owner: edi_admin
--

CREATE VIEW "public"."Proposed Order Items" AS
 SELECT "Proposals"."ProposalTitle" AS "order",
    "Bays"."GeometryID" AS "id",
    "Bays"."RoadName" AS "road",
    "RestrictionTypes"."Description" AS "restriction",
    "TimePeriods_orig"."Description" AS "times"
   FROM (((("public"."Bays"
     LEFT JOIN "public"."RestrictionsInProposals" ON ((("Bays"."RestrictionID")::"text" = ("RestrictionsInProposals"."RestrictionID")::"text")))
     LEFT JOIN "public"."Proposals" ON (("RestrictionsInProposals"."ProposalID" = "Proposals"."ProposalID")))
     LEFT JOIN "public"."RestrictionTypes" ON (("Bays"."RestrictionTypeID" = "RestrictionTypes"."id")))
     LEFT JOIN "public"."TimePeriods_orig" ON (("Bays"."TimePeriodID" = "TimePeriods_orig"."Code")))
  WHERE (("Bays"."RestrictionTypeID" = ANY (ARRAY[228, 231, 240, 33, 34, 35, 233, 234, 235, 4, 204, 6, 206, 29, 25, 9, 10, 209, 210, 28, 31, 40])) AND ("Bays"."OpenDate" IS NULL) AND (("Proposals"."ProposalTitle")::"text" = 'TRO-18-79'::"text"))
UNION
 SELECT "Proposals"."ProposalTitle" AS "order",
    "Lines"."GeometryID" AS "id",
    "Lines"."RoadName" AS "road",
    "RestrictionTypes"."Description" AS "restriction",
    "TimePeriods_orig"."Description" AS "times"
   FROM (((("public"."Lines"
     LEFT JOIN "public"."RestrictionTypes" ON (("Lines"."RestrictionTypeID" = "RestrictionTypes"."id")))
     LEFT JOIN "public"."RestrictionsInProposals" ON ((("Lines"."RestrictionID")::"text" = ("RestrictionsInProposals"."RestrictionID")::"text")))
     LEFT JOIN "public"."Proposals" ON (("RestrictionsInProposals"."ProposalID" = "Proposals"."ProposalID")))
     LEFT JOIN "public"."TimePeriods_orig" ON (("Lines"."NoWaitingTimeID" = "TimePeriods_orig"."Code")))
  WHERE (("Lines"."RestrictionTypeID" = ANY (ARRAY[228, 231, 240, 33, 34, 35, 233, 234, 235, 4, 204, 6, 206, 29, 25, 9, 10, 209, 210, 28, 31, 40])) AND ("Lines"."OpenDate" IS NULL) AND (("Proposals"."ProposalTitle")::"text" = 'TRO-18-79'::"text"));


ALTER TABLE "public"."Proposed Order Items" OWNER TO "edi_admin";

--
-- TOC entry 252 (class 1259 OID 286519)
-- Name: Proposed Order Restrictions List; Type: VIEW; Schema: public; Owner: edi_admin
--

CREATE VIEW "public"."Proposed Order Restrictions List" AS
 SELECT "Proposals"."ProposalTitle" AS "order",
    "Bays"."GeometryID" AS "id",
    "Bays"."RoadName" AS "road",
    "RestrictionTypes"."Description" AS "restriction",
    "TimePeriods_orig"."Description" AS "times",
    "Bays"."geom"
   FROM (((("public"."Bays"
     LEFT JOIN "public"."RestrictionsInProposals" ON ((("Bays"."RestrictionID")::"text" = ("RestrictionsInProposals"."RestrictionID")::"text")))
     LEFT JOIN "public"."Proposals" ON (("RestrictionsInProposals"."ProposalID" = "Proposals"."ProposalID")))
     LEFT JOIN "public"."RestrictionTypes" ON (("Bays"."RestrictionTypeID" = "RestrictionTypes"."id")))
     LEFT JOIN "public"."TimePeriods_orig" ON (("Bays"."TimePeriodID" = "TimePeriods_orig"."Code")))
  WHERE (("Bays"."RestrictionTypeID" = ANY (ARRAY[228, 231, 240, 33, 34, 35, 233, 234, 235, 4, 204, 6, 206, 29, 25, 9, 10, 209, 210, 28, 31, 40])) AND ("Bays"."OpenDate" IS NULL))
UNION
 SELECT "Proposals"."ProposalTitle" AS "order",
    "Lines"."GeometryID" AS "id",
    "Lines"."RoadName" AS "road",
    "RestrictionTypes"."Description" AS "restriction",
    "TimePeriods_orig"."Description" AS "times",
    "Lines"."geom"
   FROM (((("public"."Lines"
     LEFT JOIN "public"."RestrictionTypes" ON (("Lines"."RestrictionTypeID" = "RestrictionTypes"."id")))
     LEFT JOIN "public"."RestrictionsInProposals" ON ((("Lines"."RestrictionID")::"text" = ("RestrictionsInProposals"."RestrictionID")::"text")))
     LEFT JOIN "public"."Proposals" ON (("RestrictionsInProposals"."ProposalID" = "Proposals"."ProposalID")))
     LEFT JOIN "public"."TimePeriods_orig" ON (("Lines"."NoWaitingTimeID" = "TimePeriods_orig"."Code")))
  WHERE (("Lines"."RestrictionTypeID" = ANY (ARRAY[228, 231, 240, 33, 34, 35, 233, 234, 235, 4, 204, 6, 206, 29, 25, 9, 10, 209, 210, 28, 31, 40])) AND ("Lines"."OpenDate" IS NULL));


ALTER TABLE "public"."Proposed Order Restrictions List" OWNER TO "edi_admin";

--
-- TOC entry 253 (class 1259 OID 286524)
-- Name: RestrictionShapeTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionShapeTypes" (
    "id" integer NOT NULL,
    "Code" bigint,
    "Description" character varying
);


ALTER TABLE "public"."RestrictionShapeTypes" OWNER TO "postgres";

--
-- TOC entry 254 (class 1259 OID 286530)
-- Name: RestrictionGeometryTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RestrictionGeometryTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RestrictionGeometryTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4349 (class 0 OID 0)
-- Dependencies: 254
-- Name: RestrictionGeometryTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RestrictionGeometryTypes_id_seq" OWNED BY "public"."RestrictionShapeTypes"."id";


--
-- TOC entry 255 (class 1259 OID 286532)
-- Name: RestrictionLayers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionLayers" (
    "id" integer NOT NULL,
    "RestrictionLayerName" character varying(255) NOT NULL
);


ALTER TABLE "public"."RestrictionLayers" OWNER TO "postgres";

--
-- TOC entry 256 (class 1259 OID 286535)
-- Name: RestrictionLayers2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RestrictionLayers2_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RestrictionLayers2_id_seq" OWNER TO "postgres";

--
-- TOC entry 4352 (class 0 OID 0)
-- Dependencies: 256
-- Name: RestrictionLayers2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RestrictionLayers2_id_seq" OWNED BY "public"."RestrictionLayers"."id";


--
-- TOC entry 257 (class 1259 OID 286537)
-- Name: RestrictionPolygonTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RestrictionPolygonTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RestrictionPolygonTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 258 (class 1259 OID 286539)
-- Name: RestrictionPolygonTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionPolygonTypes" (
    "id" integer DEFAULT "nextval"('"public"."RestrictionPolygonTypes_id_seq"'::"regclass") NOT NULL,
    "Code" integer,
    "Description" character varying
);


ALTER TABLE "public"."RestrictionPolygonTypes" OWNER TO "postgres";

--
-- TOC entry 259 (class 1259 OID 286546)
-- Name: restrictionPolygons_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."restrictionPolygons_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."restrictionPolygons_seq" OWNER TO "postgres";

--
-- TOC entry 260 (class 1259 OID 286548)
-- Name: RestrictionPolygons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionPolygons" (
    "id" integer,
    "geom" "public"."geometry"(Polygon,27700) NOT NULL,
    "RestrictionTypeID" integer,
    "GeomShapeID" integer,
    "OpenDate" "date",
    "CloseDate" "date",
    "USRN" character varying(254),
    "Orientation" integer,
    "RoadName" character varying(254),
    "GeometryID" character varying(254) DEFAULT ('P_'::"text" || "to_char"("nextval"('"public"."restrictionPolygons_seq"'::"regclass"), '00000000'::"text")) NOT NULL,
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


ALTER TABLE "public"."RestrictionPolygons" OWNER TO "postgres";

--
-- TOC entry 261 (class 1259 OID 286555)
-- Name: RestrictionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionStatus" (
    "id" integer NOT NULL,
    "PK_UID" bigint,
    "RestrictionStatusID" bigint,
    "Description" character varying
);


ALTER TABLE "public"."RestrictionStatus" OWNER TO "postgres";

--
-- TOC entry 262 (class 1259 OID 286561)
-- Name: RestrictionStatus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RestrictionStatus_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RestrictionStatus_id_seq" OWNER TO "postgres";

--
-- TOC entry 4359 (class 0 OID 0)
-- Dependencies: 262
-- Name: RestrictionStatus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RestrictionStatus_id_seq" OWNED BY "public"."RestrictionStatus"."id";


--
-- TOC entry 263 (class 1259 OID 286563)
-- Name: RestrictionTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RestrictionTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RestrictionTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4361 (class 0 OID 0)
-- Dependencies: 263
-- Name: RestrictionTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RestrictionTypes_id_seq" OWNED BY "public"."RestrictionTypes"."id";


--
-- TOC entry 264 (class 1259 OID 286565)
-- Name: RoadCentreLine; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE "public"."RoadCentreLine" (
    "gid" integer NOT NULL,
    "geom" "public"."geometry"(MultiLineString,27700),
    "toid" character varying(16),
    "version" double precision,
    "verdate" "date",
    "theme" character varying(80),
    "descgroup" character varying(150),
    "descterm" character varying(150),
    "change" character varying(80),
    "topoarea" character varying(20),
    "nature" character varying(80),
    "lnklength" double precision,
    "node1" character varying(20),
    "node1grade" character varying(1),
    "node1gra_1" double precision,
    "node2" character varying(20),
    "node2grade" character varying(1),
    "node2gra_1" double precision,
    "loaddate" "date",
    "objectid" double precision,
    "shape_leng" double precision
);


ALTER TABLE "public"."RoadCentreLine" OWNER TO "edi_operator";

--
-- TOC entry 265 (class 1259 OID 286571)
-- Name: SignAttachmentTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."SignAttachmentTypes" (
    "id" integer NOT NULL,
    "Code" integer,
    "Description" character varying
);


ALTER TABLE "public"."SignAttachmentTypes" OWNER TO "postgres";

--
-- TOC entry 266 (class 1259 OID 286577)
-- Name: SignFadedTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."SignFadedTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE "public"."SignFadedTypes" OWNER TO "postgres";

--
-- TOC entry 267 (class 1259 OID 286583)
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."SignFadedTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."SignFadedTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4366 (class 0 OID 0)
-- Dependencies: 267
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."SignFadedTypes_id_seq" OWNED BY "public"."SignFadedTypes"."id";


--
-- TOC entry 268 (class 1259 OID 286585)
-- Name: SignMountTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."SignMountTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE "public"."SignMountTypes" OWNER TO "postgres";

--
-- TOC entry 269 (class 1259 OID 286591)
-- Name: SignMounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."SignMounts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."SignMounts_id_seq" OWNER TO "postgres";

--
-- TOC entry 4369 (class 0 OID 0)
-- Dependencies: 269
-- Name: SignMounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."SignMounts_id_seq" OWNED BY "public"."SignMountTypes"."id";


--
-- TOC entry 270 (class 1259 OID 286593)
-- Name: SignObscurredTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."SignObscurredTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE "public"."SignObscurredTypes" OWNER TO "postgres";

--
-- TOC entry 271 (class 1259 OID 286599)
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."SignObscurredTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."SignObscurredTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4372 (class 0 OID 0)
-- Dependencies: 271
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."SignObscurredTypes_id_seq" OWNED BY "public"."SignObscurredTypes"."id";


--
-- TOC entry 272 (class 1259 OID 286601)
-- Name: SignTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."SignTypes" (
    "id" integer NOT NULL,
    "Description" character varying,
    "Code" integer
);


ALTER TABLE "public"."SignTypes" OWNER TO "postgres";

--
-- TOC entry 273 (class 1259 OID 286607)
-- Name: SignTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."SignTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."SignTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4375 (class 0 OID 0)
-- Dependencies: 273
-- Name: SignTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."SignTypes_id_seq" OWNED BY "public"."SignTypes"."id";


--
-- TOC entry 274 (class 1259 OID 286609)
-- Name: Surveyors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."Surveyors" (
    "Code" integer NOT NULL,
    "Description" character varying(255) NOT NULL
);


ALTER TABLE "public"."Surveyors" OWNER TO "postgres";

--
-- TOC entry 275 (class 1259 OID 286612)
-- Name: Surveyors_Code_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."Surveyors_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."Surveyors_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4378 (class 0 OID 0)
-- Dependencies: 275
-- Name: Surveyors_Code_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."Surveyors_Code_seq" OWNED BY "public"."Surveyors"."Code";


--
-- TOC entry 276 (class 1259 OID 286614)
-- Name: TROStatusTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."TROStatusTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."TROStatusTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 277 (class 1259 OID 286616)
-- Name: TicketMachineIssueTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."TicketMachineIssueTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE "public"."TicketMachineIssueTypes" OWNER TO "postgres";

--
-- TOC entry 278 (class 1259 OID 286622)
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."TicketMachineIssueTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."TicketMachineIssueTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4382 (class 0 OID 0)
-- Dependencies: 278
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."TicketMachineIssueTypes_id_seq" OWNED BY "public"."TicketMachineIssueTypes"."id";


--
-- TOC entry 279 (class 1259 OID 286624)
-- Name: TilesInAcceptedProposals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."TilesInAcceptedProposals" (
    "ProposalID" integer NOT NULL,
    "TileNr" integer NOT NULL,
    "RevisionNr" integer NOT NULL
);


ALTER TABLE "public"."TilesInAcceptedProposals" OWNER TO "postgres";

--
-- TOC entry 280 (class 1259 OID 286627)
-- Name: TimePeriods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."TimePeriods" (
    "id" integer DEFAULT "nextval"('"public"."TimePeriods_id_seq"'::"regclass") NOT NULL,
    "Code" integer,
    "Description" character varying,
    "LabelText" character varying(255)
);


ALTER TABLE "public"."TimePeriods" OWNER TO "postgres";

--
-- TOC entry 281 (class 1259 OID 286634)
-- Name: baysWordingTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."baysWordingTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE "public"."baysWordingTypes" OWNER TO "postgres";

--
-- TOC entry 282 (class 1259 OID 286640)
-- Name: baysWordingTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."baysWordingTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."baysWordingTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4387 (class 0 OID 0)
-- Dependencies: 282
-- Name: baysWordingTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."baysWordingTypes_id_seq" OWNED BY "public"."baysWordingTypes"."id";


--
-- TOC entry 283 (class 1259 OID 286642)
-- Name: baytypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."baytypes" (
    "gid" integer NOT NULL,
    "Description" character varying(254),
    "Code" integer
);


ALTER TABLE "public"."baytypes" OWNER TO "postgres";

--
-- TOC entry 284 (class 1259 OID 286645)
-- Name: baytypes_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."baytypes_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."baytypes_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4390 (class 0 OID 0)
-- Dependencies: 284
-- Name: baytypes_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."baytypes_gid_seq" OWNED BY "public"."baytypes"."gid";


--
-- TOC entry 285 (class 1259 OID 286647)
-- Name: controlledparkingzones_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."controlledparkingzones_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."controlledparkingzones_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4392 (class 0 OID 0)
-- Dependencies: 285
-- Name: controlledparkingzones_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."controlledparkingzones_gid_seq" OWNED BY "public"."ControlledParkingZones"."gid";


--
-- TOC entry 286 (class 1259 OID 286649)
-- Name: corners_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."corners_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."corners_seq" OWNER TO "postgres";

--
-- TOC entry 287 (class 1259 OID 286651)
-- Name: issueid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."issueid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."issueid_seq" OWNER TO "postgres";

--
-- TOC entry 288 (class 1259 OID 286653)
-- Name: layer_styles; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE "public"."layer_styles" (
    "id" integer NOT NULL,
    "f_table_catalog" character varying,
    "f_table_schema" character varying,
    "f_table_name" character varying,
    "f_geometry_column" character varying,
    "stylename" character varying(30),
    "styleqml" "xml",
    "stylesld" "xml",
    "useasdefault" boolean,
    "description" "text",
    "owner" character varying(30),
    "ui" "xml",
    "update_time" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."layer_styles" OWNER TO "edi_operator";

--
-- TOC entry 289 (class 1259 OID 286660)
-- Name: layer_styles_id_seq; Type: SEQUENCE; Schema: public; Owner: edi_operator
--

CREATE SEQUENCE "public"."layer_styles_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."layer_styles_id_seq" OWNER TO "edi_operator";

--
-- TOC entry 4397 (class 0 OID 0)
-- Dependencies: 289
-- Name: layer_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: edi_operator
--

ALTER SEQUENCE "public"."layer_styles_id_seq" OWNED BY "public"."layer_styles"."id";


--
-- TOC entry 290 (class 1259 OID 286662)
-- Name: linetypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."linetypes" (
    "gid" integer NOT NULL,
    "Description" character varying(254),
    "Code" integer
);


ALTER TABLE "public"."linetypes" OWNER TO "postgres";

--
-- TOC entry 291 (class 1259 OID 286665)
-- Name: linetypes2_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."linetypes2_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."linetypes2_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4400 (class 0 OID 0)
-- Dependencies: 291
-- Name: linetypes2_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."linetypes2_gid_seq" OWNED BY "public"."linetypes"."gid";


--
-- TOC entry 292 (class 1259 OID 286667)
-- Name: pta_ref; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."pta_ref"
    START WITH 101
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."pta_ref" OWNER TO "postgres";

--
-- TOC entry 293 (class 1259 OID 286669)
-- Name: serial; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."serial"
    START WITH 101
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."serial" OWNER TO "postgres";

--
-- TOC entry 294 (class 1259 OID 286671)
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."signAttachmentTypes2_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."signAttachmentTypes2_id_seq" OWNER TO "postgres";

--
-- TOC entry 4404 (class 0 OID 0)
-- Dependencies: 294
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."signAttachmentTypes2_id_seq" OWNED BY "public"."SignAttachmentTypes"."id";


--
-- TOC entry 295 (class 1259 OID 286673)
-- Name: signs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."signs" (
    "gid" integer NOT NULL,
    "objectid" numeric(10,0),
    "signs_note" character varying(254),
    "signs_phot" character varying(254),
    "signtype_1" integer,
    "signtype_2" integer,
    "signtype_3" integer,
    "signs_date" "date",
    "phototaken" integer,
    "signs_ph_1" character varying(254),
    "signs_moun" integer,
    "surveyor" character varying(50),
    "ticketmach" character varying(10),
    "signs_atta" integer,
    "compl_sign" integer,
    "compl_si_1" integer,
    "compl_si_2" integer,
    "compl_si_3" integer,
    "compl_si_4" integer,
    "compl_si_5" integer,
    "geom" "public"."geometry"(Point)
);


ALTER TABLE "public"."signs" OWNER TO "postgres";

--
-- TOC entry 296 (class 1259 OID 286679)
-- Name: signs_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."signs_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."signs_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4407 (class 0 OID 0)
-- Dependencies: 296
-- Name: signs_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."signs_gid_seq" OWNED BY "public"."signs"."gid";


--
-- TOC entry 3898 (class 2604 OID 286681)
-- Name: ActionOnProposalAcceptanceTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ActionOnProposalAcceptanceTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."ActionOnProposalAcceptanceTypes_id_seq"'::"regclass");


--
-- TOC entry 3899 (class 2604 OID 286682)
-- Name: BayLineTypesInUse gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."BayLineTypesInUse" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."BayLineTypesInUse_gid_seq"'::"regclass");


--
-- TOC entry 3900 (class 2604 OID 286683)
-- Name: BayLinesFadedTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."BayLinesFadedTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."BayLinesFadedTypes_id_seq"'::"regclass");


--
-- TOC entry 3902 (class 2604 OID 286684)
-- Name: BaysLines_SignIssueTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."BaysLines_SignIssueTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."BaysLines_SignIssueTypes_id_seq"'::"regclass");


--
-- TOC entry 3903 (class 2604 OID 286685)
-- Name: ControlledParkingZones gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ControlledParkingZones" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."controlledparkingzones_gid_seq"'::"regclass");


--
-- TOC entry 3905 (class 2604 OID 286686)
-- Name: LengthOfTime id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."LengthOfTime" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."LengthOfTime_id_seq"'::"regclass");


--
-- TOC entry 3907 (class 2604 OID 286687)
-- Name: ParkingTariffAreas id; Type: DEFAULT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."ParkingTariffAreas" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."PTAs_180725_merged_10_id_seq"'::"regclass");


--
-- TOC entry 3908 (class 2604 OID 286688)
-- Name: PaymentTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."PaymentTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."PaymentTypes_id_seq"'::"regclass");


--
-- TOC entry 3909 (class 2604 OID 286689)
-- Name: ProposalStatusTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ProposalStatusTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."ProposalStatusTypes_id_seq"'::"regclass");


--
-- TOC entry 3914 (class 2604 OID 286690)
-- Name: RestrictionLayers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionLayers" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."RestrictionLayers2_id_seq"'::"regclass");


--
-- TOC entry 3913 (class 2604 OID 286691)
-- Name: RestrictionShapeTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionShapeTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."RestrictionGeometryTypes_id_seq"'::"regclass");


--
-- TOC entry 3917 (class 2604 OID 286692)
-- Name: RestrictionStatus id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionStatus" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."RestrictionStatus_id_seq"'::"regclass");


--
-- TOC entry 3911 (class 2604 OID 286693)
-- Name: RestrictionTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."RestrictionTypes_id_seq"'::"regclass");


--
-- TOC entry 3918 (class 2604 OID 286694)
-- Name: SignAttachmentTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignAttachmentTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."signAttachmentTypes2_id_seq"'::"regclass");


--
-- TOC entry 3919 (class 2604 OID 286695)
-- Name: SignFadedTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignFadedTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."SignFadedTypes_id_seq"'::"regclass");


--
-- TOC entry 3920 (class 2604 OID 286696)
-- Name: SignMountTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignMountTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."SignMounts_id_seq"'::"regclass");


--
-- TOC entry 3921 (class 2604 OID 286697)
-- Name: SignObscurredTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignObscurredTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."SignObscurredTypes_id_seq"'::"regclass");


--
-- TOC entry 3922 (class 2604 OID 286698)
-- Name: SignTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."SignTypes_id_seq"'::"regclass");


--
-- TOC entry 3904 (class 2604 OID 286699)
-- Name: Signs GeometryID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Signs" ALTER COLUMN "GeometryID" SET DEFAULT ('S_'::"text" || "to_char"("nextval"('"public"."EDI01_Signs_id_seq"'::"regclass"), '0000000'::"text"));


--
-- TOC entry 3923 (class 2604 OID 286700)
-- Name: Surveyors Code; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Surveyors" ALTER COLUMN "Code" SET DEFAULT "nextval"('"public"."Surveyors_Code_seq"'::"regclass");


--
-- TOC entry 3924 (class 2604 OID 286701)
-- Name: TicketMachineIssueTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TicketMachineIssueTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."TicketMachineIssueTypes_id_seq"'::"regclass");


--
-- TOC entry 3926 (class 2604 OID 286702)
-- Name: baysWordingTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."baysWordingTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."baysWordingTypes_id_seq"'::"regclass");


--
-- TOC entry 3927 (class 2604 OID 286703)
-- Name: baytypes gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."baytypes" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."baytypes_gid_seq"'::"regclass");


--
-- TOC entry 3929 (class 2604 OID 286704)
-- Name: layer_styles id; Type: DEFAULT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."layer_styles" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."layer_styles_id_seq"'::"regclass");


--
-- TOC entry 3930 (class 2604 OID 286705)
-- Name: linetypes gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."linetypes" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."linetypes2_gid_seq"'::"regclass");


--
-- TOC entry 3931 (class 2604 OID 286706)
-- Name: signs gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."signs" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."signs_gid_seq"'::"regclass");


--
-- TOC entry 4208 (class 0 OID 286329)
-- Dependencies: 211
-- Data for Name: ActionOnProposalAcceptanceTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."ActionOnProposalAcceptanceTypes" ("id", "Description") VALUES (1, 'Open');
INSERT INTO "public"."ActionOnProposalAcceptanceTypes" ("id", "Description") VALUES (2, 'Close');


--
-- TOC entry 4210 (class 0 OID 286337)
-- Dependencies: 213
-- Data for Name: BayLineTypesInUse; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (61, 101);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (62, 102);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (63, 103);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (64, 106);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (65, 107);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (66, 108);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (67, 109);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (68, 110);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (69, 111);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (70, 112);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (71, 113);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (72, 114);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (73, 115);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (74, 116);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (75, 117);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (76, 118);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (77, 119);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (78, 120);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (79, 121);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (80, 122);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (81, 123);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (82, 124);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (83, 125);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (84, 126);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (85, 127);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (86, 128);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (87, 130);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (88, 131);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (89, 133);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (90, 134);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (91, 135);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (92, 140);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (93, 141);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (94, 142);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (95, 143);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (96, 144);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (97, 168);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (98, 201);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (99, 202);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (100, 203);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (101, 204);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (102, 205);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (103, 206);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (104, 207);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (105, 208);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (106, 209);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (107, 210);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (108, 211);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (109, 212);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (110, 213);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (111, 214);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (112, 215);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (113, 216);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (114, 217);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (115, 218);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (116, 219);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (117, 220);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (118, 221);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (119, 222);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (120, 1103);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (121, 1106);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (122, 1107);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (123, 1108);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (124, 1109);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (125, 1110);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (126, 1113);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (127, 1114);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (128, 1118);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (129, 1119);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (130, 1120);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (131, 1121);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (132, 1122);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (133, 1124);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (134, 1126);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (135, 1131);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (136, 1134);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (137, 1142);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (138, 1144);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (139, 2201);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (140, 2202);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (141, 2203);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (142, 2209);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (143, 2218);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (144, 2410);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (145, 2411);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (147, 105);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (148, 224);


--
-- TOC entry 4213 (class 0 OID 286349)
-- Dependencies: 216
-- Data for Name: BayLinesFadedTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."BayLinesFadedTypes" ("id", "Code", "Description", "Comment") VALUES (1, '1', 'No issue', NULL);
INSERT INTO "public"."BayLinesFadedTypes" ("id", "Code", "Description", "Comment") VALUES (6, '6', 'Other (please specify in notes)', NULL);
INSERT INTO "public"."BayLinesFadedTypes" ("id", "Code", "Description", "Comment") VALUES (2, '2', 'Slightly faded marking', NULL);
INSERT INTO "public"."BayLinesFadedTypes" ("id", "Code", "Description", "Comment") VALUES (3, '3', 'Very faded markings', NULL);
INSERT INTO "public"."BayLinesFadedTypes" ("id", "Code", "Description", "Comment") VALUES (4, '4', 'Markings not correctly removed', 'e.g. disabled bays no longer in use, may have not been correctly removed; this is different from faded markings, as the stress is not on repainting them, but rather remove the remaining markings');
INSERT INTO "public"."BayLinesFadedTypes" ("id", "Code", "Description", "Comment") VALUES (5, '5', 'Missing markings', NULL);


--
-- TOC entry 4215 (class 0 OID 286357)
-- Dependencies: 218
-- Data for Name: BayTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (102, 'Business Permit Holder Bays');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (106, 'Ambulance Bays');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (107, 'Bus Stop');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (114, 'Loading Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (121, 'Taxi Rank');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (122, 'Bus Stand');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (126, 'Limited Waiting');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (127, 'Free Bays (No Limited Waiting)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (109, 'Buses Only Bays');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (130, 'Private Parking/Residents only Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (108, 'Car Club bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (115, 'Loading Bay/Disabled Bay (Red Route)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (128, 'Loading Bay (Red Route)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (110, 'Disabled Blue Badge');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (111, 'Disabled bay - personalised');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (112, 'Diplomatic Only Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (113, 'Doctor bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (116, 'Cycle Hire bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (123, 'Mobile Library bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (124, 'Electric Vehicle Charging Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (101, 'Resident Permit Holder Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (119, 'On-Carriageway Bicycle Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (120, 'Police bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (103, 'Pay & Display/Pay by Phone Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (125, 'Other Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (117, 'Motorcycle Permit Holders bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (131, 'Permit Holder Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (118, 'Solo Motorcycle bay (Visitors)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (133, 'Shared Use (Business Permit Holders)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (134, 'Shared Use (Permit Holders)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (135, 'Shared Use (Residential Permit Holders)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (140, 'Loading Bay/Disabled Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (141, 'Loading Bay/Disabled Bay/Parking Bay (Red Route)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (142, 'Parking Bay (Red Route)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (143, 'Loading Bay/Parking Bay (Red Route)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (144, 'Rubbish Bin Bays');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (168, 'RNLI Permit Holders only');


--
-- TOC entry 4217 (class 0 OID 286366)
-- Dependencies: 220
-- Data for Name: Bays; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000001920E4BC4DB1341759437603B932441E5DF1B92ECDB13416CC742E040932441', 10.44, 101, -1, 15, NULL, NULL, NULL, NULL, 'B_ 0078346', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 24, NULL, NULL, 345, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, NULL, NULL, 0, NULL, 'f0ce05a2-7b0e-410b-8556-05ecb0aa485e');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000002A5328AE00DC134119FE6D144E9324411535FCBE3ADC1341228EE52D56932441', 15.07, 103, 3, 15, 4, 3, 1, NULL, 'B_ 0078347', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 21, NULL, NULL, 344, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, 'f071e490-9f42-4872-a064-a894927c6c4e');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000001535FCBE3ADC1341228EE52D569324410652D4084EDC13412B739DE458932441', 5.01, 110, -1, 1, NULL, NULL, NULL, NULL, 'B_ 0078348', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 21, NULL, NULL, 344, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, 'dc0b1bfb-9532-48ea-8d90-85bddac2f17b');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000049D8D8FE9ADC13413FFA2FD063932441034BB983C1DC13415214783469932441', 10, 105, -1, 39, 4, 3, 1, NULL, 'B_ 0078349', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 22, 'Queen Street', '1001', 344, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, 'e6e923ce-6a61-4e6e-b856-db2f20e395e6');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000034BB983C1DC13415214783469932441FED96C54E0DC1341C8C2B1846D932441', 8, 118, -1, 1, NULL, 9, NULL, NULL, 'B_ 0078350', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 25, 'Queen Street', '1001', 344, NULL, NULL, NULL, NULL, 10, '2020-05-01', NULL, 'A', NULL, 0, NULL, '4c5913dd-0412-439f-8c8b-7eecbcfee7a7');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000001586BD1B1ADD1341E4E91D9B75932441101571EC38DD13415A9857EB79932441', 8, 101, -1, 14, NULL, NULL, NULL, NULL, 'B_ 0078351', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 23, 'Queen Street', '1001', 344, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, 'c31f7cb7-e29d-4117-94b0-307ac280c192');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000101571EC38DD13415A9857EB799324416D4EE12E4CDD134163A57B9D7C932441', 5, 110, -1, 1, NULL, NULL, NULL, NULL, 'B_ 0078352', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 26, 'Queen Street', '1001', 344, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '0e213bb8-28b6-4e6b-a48a-954b40821b6c');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000400000032D69CDAEDDA134164CF70BE2793244119D3F748FFDA13413ADF45D722932441760C688B12DB134144EC69892593244182DEC6591CDB13411EAD97402E932441', 15, 114, -1, 15, NULL, 9, 1, NULL, 'B_ 0078353', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 28, 'Queen Street', '1001', 344, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, 'b81c152e-0d1d-4ba0-bb96-320f02f4a18a');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000050D32ACD0EDE13410F19D16E5F9224412621CC03C2DD1341853FBE3554922441', 20, 107, -1, 1, NULL, NULL, NULL, NULL, 'B_ 0078354', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 1, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '0f493e9b-5e4a-4854-892d-085840a437fc');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000002621CC03C2DD1341853FBE355492244111C81C9F9BDD1341C0D234994E922441', 10, 119, -1, 1, NULL, NULL, NULL, NULL, 'B_ 0078355', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 4, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '474b2ac4-5c10-4764-b25b-e9cda052aba6');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000011C81C9F9BDD1341C0D234994E922441FC6E6D3A75DD1341FB65ABFC48922441', 10, 115, -1, 15, NULL, NULL, NULL, NULL, 'B_ 0078356', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 2, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '12cc30fe-cb33-4570-b228-f2402947bb5e');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000FC6E6D3A75DD1341FB65ABFC48922441E715BED54EDD134136F9216043922441', 10, 116, -1, 1, NULL, NULL, NULL, NULL, 'B_ 0078357', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 5, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, 190, '2020-05-01', NULL, 'A', NULL, 0, NULL, '2a5d0a0b-2c87-4257-9147-0bdeeb8af0d2');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000BD635F0C02DD1341AD1F0F273892244113B66C55E3DC13414262D4A933922441', 8, 115, -1, 15, NULL, NULL, NULL, NULL, 'B_ 0078358', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 6, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '9775d869-1cea-4098-9b2a-ce019afa458e');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000013B66C55E3DC13414262D4A93392244174B065BEA9DC13411B3F063F2B922441', 15, 119, -1, 15, NULL, NULL, NULL, NULL, 'B_ 0078359', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 3, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '014d6fa9-0c7b-49f5-a9d1-5a4dbef9fad4');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000005000000CBFC6A88C7DD1341F817CC58449224419CFD1396EDDD1341CD5A9DE849922441D5A1D4AEF6DD13419D1D51593A922441EE54232BD0DD1341D707ECF234922441CBFC6A88C7DD1341F817CC5844922441', 36.01, 116, -1, 1, NULL, NULL, NULL, NULL, 'B_ 0078360', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 8, 'Hanover Street', '1003', 343, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'B', 'C2', 0, NULL, '6500cbc0-5072-4a46-a130-6e79a214d896');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000009B77492FE7DD13418DE8663C3F93244153152B22FDDD1341C451FD2617932441', 20.78, 103, -1, 153, NULL, NULL, NULL, NULL, 'B_ 0078361', '2020-05-27 22:41:28.575475', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 21, 'North St David Street', '1005', 74, 325475.40475398174, 674195.2220350107, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '62b0bf76-1ad4-4afb-97b4-abf7bc32d05a');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000050D32ACD0EDE13410F19D16E5F9224419849A0382CDE13419D3F99BB63922441', 7.66, 114, -1, 15, NULL, 9, 1, NULL, 'B_ 0078362', '2020-05-29 09:52:22.645068', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 21, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, NULL, '2020-05-15', NULL, 'A', NULL, 0, NULL, '254bdb0f-cc6d-47fc-a4b5-14dc4d244c1d');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000040000003B941B0A64DE13415238B2385B9224416C1A8BF56CDE1341A59F99EE4A9224418A80DA7146DE1341AB4A3388459224410CEAB6713DDE1341626F9B9455922441', 26.78, 103, -1, 16, 4, 10, 10, NULL, 'B_ 0078363', '2020-05-29 14:24:37.835215', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 28, 'Hanover Street', '1003', 164, NULL, NULL, NULL, NULL, NULL, '2020-05-01', '2020-05-20', 'B', 'C2', 0, NULL, '59a25fd9-3b04-44bb-a77b-f5bb383be9ee');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000F832A280A1DB1341D8E1C700D6912441D7704B61E1DB1341A68088F5DE912441', 16.59, 101, -1, 39, NULL, NULL, NULL, NULL, 'B_ 0078364', '2020-06-04 15:53:21.426686', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 21, 'Hanover Street', '1004', 344, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'B', NULL, 0, NULL, 'd78254ca-28af-4f68-abc5-bfb4b12759a6');


--
-- TOC entry 4218 (class 0 OID 286373)
-- Dependencies: 221
-- Data for Name: BaysLines_SignIssueTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."BaysLines_SignIssueTypes" ("id", "Code", "Description", "Comment") VALUES (1, '1', 'No issues', NULL);
INSERT INTO "public"."BaysLines_SignIssueTypes" ("id", "Code", "Description", "Comment") VALUES (2, '2', 'Inconsistent sign', NULL);
INSERT INTO "public"."BaysLines_SignIssueTypes" ("id", "Code", "Description", "Comment") VALUES (3, '3', 'Missing sign', 'If there''s not even a pole, we need a place where to store this information');
INSERT INTO "public"."BaysLines_SignIssueTypes" ("id", "Code", "Description", "Comment") VALUES (4, '4', 'Other (please specify in notes)', NULL);


--
-- TOC entry 4221 (class 0 OID 286383)
-- Dependencies: 224
-- Data for Name: CPZs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4222 (class 0 OID 286389)
-- Dependencies: 225
-- Data for Name: ControlledParkingZones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."ControlledParkingZones" ("gid", "cacz_ref_n", "date_last_", "no_osp_spa", "no_pnr_spa", "no_pub_spa", "no_res_spa", "zone_no", "type", "geom", "WaitingTimeID", "CPZ", "OpenDate", "CloseDate", "RestrictionID", "GeometryID") VALUES (39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Controlled Parking Zone', '0103000020346C000001000000060000003EB8E6A0B3DA13411AD3BEE6279324413478C568C7DD1341F259E02B96932441339D5F2C6FDE134179B9FE2E65922441092AB0D088DB1341D771ABAEF8912441A0976E9257DB134150B81E05029224413EB8E6A0B3DA13411AD3BEE627932441', 15, 'A', '2020-05-01', NULL, '{4e5323f1-659a-4758-80c4-8bb00ff1fd91}', 'C_ 000000004');
INSERT INTO "public"."ControlledParkingZones" ("gid", "cacz_ref_n", "date_last_", "no_osp_spa", "no_pnr_spa", "no_pub_spa", "no_res_spa", "zone_no", "type", "geom", "WaitingTimeID", "CPZ", "OpenDate", "CloseDate", "RestrictionID", "GeometryID") VALUES (40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Controlled Parking Zone', '0103000020346C00000100000015000000339D5F2C6FDE134179B9FE2E6592244106FC6D152ADF13414580FDBB1591244115D0EB770CDC134148EA7D19A3902441AF1C773A03DC1341EDD475AAA7902441F344D81C0DDC134173753AA6AF902441DA41335A0CDC13411BAA2F93BC9024414C10E32F00DC1341380DD0E7D49024417AF98668F3DB1341A323DF14ED902441172B30ECC7DB1341DABE0D5A3F91244199ED8982C4DB1341A587E4CF4491244127ED4BB7B8DB1341FA21AEAE57912441A22F13A576DB13416652C974CE9124411DCD590172DB1341D84240B9CD912441A22F13A576DB13416652C974CE912441F707997380DB1341234C2F01D0912441344F6CF091DB1341A8ECF3FCD791244173499F2995DB13414191DC94DC9124412D6EDE8A99DB1341CB58A3D2E29124413DE0F71E96DB1341E60B465EEF912441092AB0D088DB1341D771ABAEF8912441339D5F2C6FDE134179B9FE2E65922441', 39, 'B', '2020-05-01', NULL, '{40eb51f6-f229-48d6-9efb-64900938a5e3}', 'C_ 000000005');


--
-- TOC entry 4225 (class 0 OID 286403)
-- Dependencies: 228
-- Data for Name: EDI_RoadCasement_Polyline; Type: TABLE DATA; Schema: public; Owner: edi_operator
--



--
-- TOC entry 4226 (class 0 OID 286409)
-- Dependencies: 229
-- Data for Name: EDI_Sections; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4227 (class 0 OID 286415)
-- Dependencies: 230
-- Data for Name: LengthOfTime; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (12, 12, 'No restriction', NULL);
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (13, 13, 'Other (please specify in notes)', NULL);
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (3, 3, '2 hours', '2h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (4, 4, '3 hours', '3h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (5, 5, '4 hours', '4h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (6, 6, '5 hours', '5h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (7, 7, '5 minutes', '5m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (8, 8, '10 minutes', '10m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (9, 9, '20 minutes', '20m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (10, 10, '30 minutes', '30m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (11, 11, '40 minutes', '40m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (14, 14, '6 hours', '6h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (15, 15, '9 hours', '9h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (2, 2, '90 minutes', '90m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (16, 16, '45 minutes', '45m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (1, 1, '60 minutes', '1h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (17, 17, '10 hours', '10h');


--
-- TOC entry 4229 (class 0 OID 286423)
-- Dependencies: 232
-- Data for Name: LineTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (202, 'No Waiting At Any Time (DYL)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (203, 'Zig Zag - School');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (204, 'Zig Zag - Fire');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (205, 'Zig Zag - Police');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (206, 'Zig Zag - Ambulance');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (207, 'Zig Zag - Hospital');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (208, 'Zig Zag - Yellow (other)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (209, 'Crossing - Zebra');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (210, 'Crossing - Pelican');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (211, 'Crossing - Toucan');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (212, 'Crossing - Puffin');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (213, 'Crossing - Equestrian');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (214, 'Crossing - Signalised');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (215, 'Crossing - Unmarked and no signals');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (219, 'Private Road');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (216, 'Unmarked Area (Acceptable)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (220, 'Unmarked Area (Unacceptable)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (218, 'No Stopping At Any Time (DRL)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (201, 'No Waiting (Acceptable) (SYL)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (217, 'No Stopping (Acceptable) (SRL)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (221, 'No Waiting (Unacceptable) (SYL)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (222, 'No Stopping (Unacceptable) (SRL)');


--
-- TOC entry 4231 (class 0 OID 286432)
-- Dependencies: 234
-- Data for Name: Lines; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000088B9650BCDD13419A8B944F8C9324416AF986965BDE13414B93E3A76A922441', 150.2, 224, 126, 11, NULL, 'L_ 000000009', '2020-05-24 22:42:01.112644', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'North St David Street', '1005', 74, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, '10901e3d-dc68-4dfc-a036-dbb930babcfb');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000542996A5E7DB1341E0E076914A9324412A5328AE00DC134119FE6D144E932441', 6.5, 202, 1, 16, NULL, 'L_ 000000002', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, NULL, NULL, 344, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'ceb9e35c-0372-4cf0-ac38-f150eb200ea0');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000008CED0606BFDB134108FBC40545932441180846FC71DB1341E2C6343D3A932441', 20, 224, 14, 16, NULL, 'L_ 000000003', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'Queen Street', '1001', 344, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'f32e4d66-0d7f-4dbc-a48c-c8c44dc1a191');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000000652D4084EDC13412B739DE45893244149D8D8FE9ADC13413FFA2FD063932441', 20, 224, 15, 1, NULL, 'L_ 000000004', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'Queen Street', '1001', 344, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'c0e47ca6-6148-4a9d-8c33-f576b733ad32');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000180846FC71DB1341E2C6343D3A932441A42285F224DB1341BC92A4742F932441', 20, 209, 1, NULL, NULL, 'L_ 000000005', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'Queen Street', '1001', 344, 12, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'a9d38e70-bc08-4f46-8497-71bdad52dad7');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000FED96C54E0DC1341C8C2B1846D9324411586BD1B1ADD1341E4E91D9B75932441', 15, 202, 1, 1, NULL, 'L_ 000000006', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'Queen Street', '1001', 344, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'a530ddfb-316a-40da-abfd-ba111d1c35b4');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000E715BED54EDD134136F9216043922441BD635F0C02DD1341AD1F0F2738922441', 20, 203, 11, NULL, NULL, 'L_ 000000008', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1012', 163, 12, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, '5dd050cb-8bde-400d-8f03-fccbf492467a');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000074B065BEA9DC13411B3F063F2B922441EA030E8C96DC1341B988C17028922441', 5, 214, 1, NULL, NULL, 'L_ 000000010', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1012', 163, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'dca8d05a-e437-473d-b95d-d50c792e1c97');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000003A4E41B6E6DD1341E9F20B353F93244169AB00BAFCDD13411B0CD92B17932441', 20.76, 224, 211, 11, NULL, 'L_ 000000011', '2020-05-28 07:35:44.61791', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'North St David Street', '1005', 74, 10, 325483.2716653942, 674188.8537149023, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 325483.11919353675, 674191.4374914765, NULL, 0, NULL, '1bf6eef1-37f8-42b6-82b2-848f577146b6');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000088B9650BCDD13419A8B944F8C9324413A4E41B6E6DD1341E9F20B353F932441', 39.98, 224, 126, 11, NULL, 'L_ 000000013', '2020-05-28 07:38:36.157711', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'North St David Street', '1005', 74, 10, 325459.9293151222, 674215.5959957276, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 325460.57209681097, 674210.0364140678, NULL, 0, NULL, '825fc78e-a8c7-4372-8993-462f37605c68');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000069AB00BAFCDD13411B0CD92B179324416AF986965BDE13414B93E3A76A922441', 89.46, 224, 126, 11, NULL, 'L_ 000000012', '2020-05-28 07:38:36.157711', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'North St David Street', '1005', 74, 10, 325531.3759761611, 674158.4891387734, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 325531.58157050796, 674153.4135325637, NULL, 0, NULL, 'ed8e2e61-3efb-4a89-86ff-4d4200e72803');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000000DCA88965BDE13412F33E5A76A9224419849A0382CDE13419D3F99BB63922441', 12.34, 202, 1, 1, NULL, 'L_ 000000015', '2020-05-28 12:45:04.641037', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1012', 163, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'c7b3d64c-f42f-485d-969c-c52bad2e5fad');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000000DCA88965BDE13412F33E5A76A92244150D32ACD0EDE13410F19D16E5F922441', 20, 202, 1, 1, NULL, 'L_ 000000007', '2020-05-29 09:52:22.645068', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1012', 163, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-01', '2020-05-15', 'A', NULL, NULL, NULL, NULL, 0, NULL, '362db835-a235-49fa-8f90-2c37955fde39');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000047C7F76A3FDE13412546DE89669224419849A0382CDE13419D3F99BB63922441', 5, 224, 14, 211, NULL, 'L_ 000000016', '2020-05-29 09:52:22.645068', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1012', 163, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-15', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'd4cd82f8-2a72-4232-9a0c-a27392348174');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000000DCA88965BDE13412F33E5A76A92244147C7F76A3FDE13412546DE8966922441', 7.34, 202, 1, 1, NULL, 'L_ 000000017', '2020-05-29 09:52:22.645068', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1012', 163, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-15', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'af46bcf3-5758-4f84-85bf-7800a562c8ae');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000005CE7BE55C7DA1341720F295A2293244194729EA664DB13410BDBE75908922441', 146.38, 224, 126, 16, NULL, 'L_ 000000018', '2020-05-29 22:50:34.159914', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'Hanover Street', '1003', 254, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'a1a65fde-2217-434c-aa1d-54814642f447');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000D7704B61E1DB1341A68088F5DE9124411BBFFCE407DC1341FC93ED5BE4912441', 10, 224, 39, NULL, NULL, 'L_ 000000019', '2020-06-04 15:55:52.894764', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1013', 344, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'B', NULL, NULL, NULL, NULL, 0, NULL, 'f0008143-e680-4097-9f21-2509dce993ae');


--
-- TOC entry 4232 (class 0 OID 286439)
-- Dependencies: 235
-- Data for Name: LookupCodeTransfers_Bays; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (1, 'Ambulance Bays', '1', '106');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (2, 'Bus Stand', '2', '122');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (3, 'Bus Stop', '3', '107');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (4, 'Buses Parking only', '4', '109');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (5, 'Business Permit Holders only', '5', '102');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (6, 'Car Club Bays', '6', '108');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (7, 'Cycle Hire scheme', '7', '116');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (8, 'Diplomat Bays', '8', '112');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (9, 'Disabled Bays (Blue Badge)', '9', '110');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (10, 'Disabled Bays (Personalised)', '10', '111');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (11, 'Doctor Bays', '11', '113');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (12, 'Electric Vehicle Charging Bay', '12', '124');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (13, 'Free Bays (No Limited Waiting)', '13', '127');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (14, 'Greenway Loading Bay', '14', '128');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (15, 'Greenway Loading and Disabled Bays', '15', '115');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (16, 'Greenway Loading, Disabled and Parking Bay', '16', '141');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (17, 'Greenway Loading and Parking Bay', '17', '143');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (18, 'Greenway Parking Bay', '18', '142');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (19, 'Limited Waiting (No Charge)', '19', '126');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (20, 'Loading only', '20', '114');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (21, 'Loading Bays & Disabled Bays', '21', '140');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (22, 'Mobile Library Bays', '22', '123');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (23, 'Motorcycle Bay (Permit Holders only)', '23', '117');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (24, 'Motorcycle Solo only', '24', '118');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (25, 'On-Street Cycle Bays', '25', '119');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (26, 'Other Bays (Please specify in notes)', '26', '125');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (27, 'Pay and Display/Pay by Phone', '27', '103');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (28, 'Permit Holders only', '28', '131');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (29, 'Police Bays', '29', '120');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (30, 'Private/Residents only', '30', '130');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (31, 'Resident Permit Holders only', '31', '101');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (32, 'Rubbish Bins Bays', '32', '144');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (33, 'Shared Use Bays (Business Permit Holders)', '33', '133');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (34, 'Shared Use Bays (Permit Holders)', '34', '134');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (35, 'Shared Use Bays (Resident Permit Holders)', '35', '135');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (36, 'Taxis only', '36', '121');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (37, 'Free Bays (No Limited Waiting) within CPZs', '37', '127');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (57, 'RNLI Permit Holders only', '40', '168');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (38, 'Disabled Bay (Blue Badge) (On street but not in TRO)', '109', '1110');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (39, 'Ambulance Bays (on street not in TRO)', '101', '1106');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (40, 'Rubbish Bin Bays (on street not in TRO)', '132', '1144');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (41, 'Car Club Bays (on street but not in TRO)', '106', '1108');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (42, 'Bus Stop (On street but not in TRO)', '103', '1107');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (43, 'Bus Stand (On street but not in TRO)', '102', '1122');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (44, 'Taxis only (On street but not in TRO)', '136', '1121');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (45, 'Motorcycle Solo only (On street but not in TRO)', '124', '1118');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (46, 'Permit Holders only (On street but not in TRO)', '128', '1131');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (47, 'Pay and Display/Pay by Phone (On street but not in TRO)', '127', '1103');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (48, 'Shared Use Bays (Permit Holders) (On street but not in TRO)', '134', '1134');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (49, 'Buses Parking only (On street but not in TRO)', '104', '1109');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (50, 'Electric Vehicle Charging Bay (On street but not in TRO)', '112', '1124');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (51, 'Greenway Parking Bay (On street but not in TRO)', '118', '1142');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (52, 'Loading only (On street but in not TRO)', '120', '1114');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (53, 'On-Street Cycle Bays (On street but not in TRO)', '125', '1119');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (54, 'Doctor Bays (On street but not in TRO)', '111', '1113');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (55, 'Limited Waiting (No Charge) (On street but not in TRO)', '119', '1126');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (56, 'Police Bays (On-street but not in TRO)', '129', '1120');


--
-- TOC entry 4233 (class 0 OID 286445)
-- Dependencies: 236
-- Data for Name: LookupCodeTransfers_Lines; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (1, 'Crossing - Equestrian', '1', '213');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (2, 'Crossing - Pelican', '2', '210');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (3, 'Crossing - Puffin', '3', '212');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (4, 'Crossing - Signalised', '4', '214');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (5, 'Crossing - Toucan (bicycles)', '5', '211');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (6, 'Crossing - Unmarked and no signals', '6', '215');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (7, 'Crossing - Zebra', '7', '209');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (9, 'No Stopping (SRL)', '8', '217');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (10, 'No Stopping (SRL) - unacceptable', '24', '222');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (11, 'No Stopping At Any Time (DRL)', '9', '218');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (13, 'No Waiting (SYL)', '10', '201');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (14, 'No Waiting (SYL) - unacceptable', '22', '221');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (16, 'No Waiting At Any Time (DYL)', '11', '202');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (18, 'Private Road', '12', '219');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (19, 'Unmarked Area', '13', '216');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (20, 'Unmarked Area (compliance issue)', '14', '220');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (21, 'Unmarked Areas - unacceptable', '23', '220');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (22, 'Zig-Zag Keep Clear Ambulance', '15', '206');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (23, 'Zig-Zag Keep Clear Fire', '16', '204');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (24, 'Zig-Zag Keep Clear Hospital', '17', '207');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (25, 'Zig-Zag Keep Clear Police', '18', '205');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (26, 'Zig-Zag Keep Clear Yellow (Other)', '20', '208');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (27, 'Zig-Zag School Keep Clear', '21', '203');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (8, 'Crossing - Zebra (On-street but not in TRO)', '207', '2209');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (12, 'No Stopping At Any Time (DRL) (On-street but not in TRO)', '209', '2218');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (15, 'No Waiting (SYL) (On-street but not in TRO)', '210', '2201');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (17, 'No Waiting At Any Time (On-street but not in TRO)', '211', '2202');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (28, 'Zig-Zag School Keep Clear (On-street but not in TRO)', '221', '2203');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (29, 'No Waiting (SYL) (in Mews/PPA)', '410', '2410');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (30, 'No Waiting At Any Time (DYL) (in Mews/PPA)', '411', '2411');


--
-- TOC entry 4234 (class 0 OID 286451)
-- Dependencies: 237
-- Data for Name: MapGrid; Type: TABLE DATA; Schema: public; Owner: edi_operator
--

INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1339, '0106000020346C000001000000010300000001000000050000000000000030E4134100000000C09424410000000070EA134100000000C09424410000000070EA134100000000CC9224410000000030E4134100000000CC9224410000000030E4134100000000C0942441', 325900, 326300, 674150, 674400, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1398, '0106000020346C000001000000010300000001000000050000000000000030E4134100000000CC9224410000000070EA134100000000CC9224410000000070EA134100000000D89024410000000030E4134100000000D89024410000000030E4134100000000CC922441', 325900, 326300, 673900, 674150, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1455, '0106000020346C0000010000000103000000010000000500000000000000B0D7134100000000D890244100000000F0DD134100000000D890244100000000F0DD134100000000E48E244100000000B0D7134100000000E48E244100000000B0D7134100000000D8902441', 325100, 325500, 673650, 673900, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1456, '0106000020346C0000010000000103000000010000000500000000000000F0DD134100000000D89024410000000030E4134100000000D89024410000000030E4134100000000E48E244100000000F0DD134100000000E48E244100000000F0DD134100000000D8902441', 325500, 325900, 673650, 673900, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1337, '0106000020346C0000010000000103000000010000000500000000000000B0D7134100000000C094244100000000F0DD134100000000C094244100000000F0DD134100000000CC92244100000000B0D7134100000000CC92244100000000B0D7134100000000C0942441', 325100, 325500, 674150, 674400, 1, NULL, NULL, NULL, '2020-05-01');
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1396, '0106000020346C0000010000000103000000010000000500000000000000B0D7134100000000CC92244100000000F0DD134100000000CC92244100000000F0DD134100000000D890244100000000B0D7134100000000D890244100000000B0D7134100000000CC922441', 325100, 325500, 673900, 674150, 1, NULL, NULL, NULL, '2020-05-01');
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1338, '0106000020346C0000010000000103000000010000000500000000000000F0DD134100000000C09424410000000030E4134100000000C09424410000000030E4134100000000CC92244100000000F0DD134100000000CC92244100000000F0DD134100000000C0942441', 325500, 325900, 674150, 674400, 1, NULL, NULL, NULL, '2020-05-01');
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1397, '0106000020346C0000010000000103000000010000000500000000000000F0DD134100000000CC9224410000000030E4134100000000CC9224410000000030E4134100000000D890244100000000F0DD134100000000D890244100000000F0DD134100000000CC922441', 325500, 325900, 673900, 674150, 3, NULL, NULL, NULL, '2020-05-20');


--
-- TOC entry 4235 (class 0 OID 286457)
-- Dependencies: 238
-- Data for Name: ParkingTariffAreas; Type: TABLE DATA; Schema: public; Owner: edi_operator
--

INSERT INTO "public"."ParkingTariffAreas" ("id", "geom", "gid", "fid_parkin", "tro_ref", "charge", "cost", "hours", "Name", "NoReturnTimeID", "MaxStayID", "TimePeriodID", "OBJECTID", "name_orig", "Shape_Leng", "Shape_Area", "OpenDate", "CloseDate", "RestrictionID", "GeometryID") VALUES (110, '0103000020346C000001000000050000008BA3249780DE1341F2DF386045922441BD1D345AC1DD1341BDC421902A922441BFB1BE7AAADD13418D336E6F48922441339D5F2C6FDE134179B9FE2E659224418BA3249780DE1341F2DF386045922441', NULL, NULL, NULL, NULL, NULL, NULL, 'C2', 10, 10, 16, NULL, NULL, NULL, NULL, '2020-05-01', NULL, '{ac017c0b-91f9-48d2-b571-8fae5139ec6a}', 'T_ 000000002');


--
-- TOC entry 4237 (class 0 OID 286465)
-- Dependencies: 240
-- Data for Name: PaymentTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."PaymentTypes" ("id", "Code", "Description") VALUES (1, 1, 'No Charge');
INSERT INTO "public"."PaymentTypes" ("id", "Code", "Description") VALUES (2, 2, 'Pay and Display');
INSERT INTO "public"."PaymentTypes" ("id", "Code", "Description") VALUES (3, 3, 'Pay by Phone (only)');
INSERT INTO "public"."PaymentTypes" ("id", "Code", "Description") VALUES (4, 4, 'Pay and Display/Pay by Phone');


--
-- TOC entry 4239 (class 0 OID 286473)
-- Dependencies: 242
-- Data for Name: ProposalStatusTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."ProposalStatusTypes" ("id", "Description", "Code") VALUES (1, 'In Preparation', 1);
INSERT INTO "public"."ProposalStatusTypes" ("id", "Description", "Code") VALUES (2, 'Accepted', 2);
INSERT INTO "public"."ProposalStatusTypes" ("id", "Description", "Code") VALUES (3, 'Rejected', 3);


--
-- TOC entry 4242 (class 0 OID 286483)
-- Dependencies: 245
-- Data for Name: Proposals; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (0, 2, '2020-05-21', NULL, '0 - No Proposal Shown', '2020-05-01');
INSERT INTO "public"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (4, 2, '2020-05-21', NULL, 'Initial Creation', '2020-05-01');
INSERT INTO "public"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (5, 2, '2020-05-28', NULL, 'Loading Bay / SYL', '2020-05-15');
INSERT INTO "public"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (6, 2, '2020-05-29', NULL, 'Delete Bay', '2020-05-20');
INSERT INTO "public"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (7, 1, '2020-05-29', NULL, 'Add line', '2020-05-27');
INSERT INTO "public"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (8, 1, '2020-05-01', NULL, 'Test2', '2020-05-01');


--
-- TOC entry 4243 (class 0 OID 286490)
-- Dependencies: 246
-- Data for Name: Proposals_withGeom; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4250 (class 0 OID 286532)
-- Dependencies: 255
-- Data for Name: RestrictionLayers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionLayers" ("id", "RestrictionLayerName") VALUES (2, 'Bays');
INSERT INTO "public"."RestrictionLayers" ("id", "RestrictionLayerName") VALUES (3, 'Lines');
INSERT INTO "public"."RestrictionLayers" ("id", "RestrictionLayerName") VALUES (5, 'Signs');
INSERT INTO "public"."RestrictionLayers" ("id", "RestrictionLayerName") VALUES (4, 'RestrictionPolygons');
INSERT INTO "public"."RestrictionLayers" ("id", "RestrictionLayerName") VALUES (6, 'CPZs');
INSERT INTO "public"."RestrictionLayers" ("id", "RestrictionLayerName") VALUES (7, 'ParkingTariffAreas');


--
-- TOC entry 4253 (class 0 OID 286539)
-- Dependencies: 258
-- Data for Name: RestrictionPolygonTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionPolygonTypes" ("id", "Code", "Description") VALUES (1, 1, 'Greenway');
INSERT INTO "public"."RestrictionPolygonTypes" ("id", "Code", "Description") VALUES (3, 3, 'Pedestrian Area');
INSERT INTO "public"."RestrictionPolygonTypes" ("id", "Code", "Description") VALUES (4, 4, 'Residential mews area');
INSERT INTO "public"."RestrictionPolygonTypes" ("id", "Code", "Description") VALUES (2, 2, 'Permit Parking Areas');
INSERT INTO "public"."RestrictionPolygonTypes" ("id", "Code", "Description") VALUES (5, 5, 'Pedestrian Area - occasional');
INSERT INTO "public"."RestrictionPolygonTypes" ("id", "Code", "Description") VALUES (6, 6, 'Area under construction');


--
-- TOC entry 4255 (class 0 OID 286548)
-- Dependencies: 260
-- Data for Name: RestrictionPolygons; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionPolygons" ("id", "geom", "RestrictionTypeID", "GeomShapeID", "OpenDate", "CloseDate", "USRN", "Orientation", "RoadName", "GeometryID", "RestrictionID", "NoWaitingTimeID", "NoLoadingTimeID", "Polygons_Photos_01", "Polygons_Photos_02", "Polygons_Photos_03", "LabelText", "TimePeriodID", "AreaPermitCode", "CPZ", "labelX", "labelY", "labelRotation") VALUES (NULL, '0103000020346C0000010000000F00000063066581C6DE13417446786BA9912441BB5D56FE3BDE1341C5F1FB8F95912441C3135BE73BDE134165C7B98C9591244172E6DE7426DE1341F951E58A9291244167200316F4DD134127F3E27A8B912441D60208618FDD1341870C991F7D9124411339A7D713DD1341A78D24836B912441AFADE9A573DC134180D8DEAC54912441E01E1C715BDC1341023E773951912441770247475BDC134134399F33519124411E61662B37DC1341B199AB424C912441452ACA84D8DB134173D96D433F91244186A5372CCFDB13411CDB8D924E912441CDF03BDABDDE1341103DF1D2B891244163066581C6DE13417446786BA9912441', 3, 50, '2020-05-01', NULL, '1006', NULL, 'Rose Street', 'P_ 000000002', 'b0f73006-62f1-4d63-b1b2-758eba0865bf', 126, 126, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4248 (class 0 OID 286524)
-- Dependencies: 253
-- Data for Name: RestrictionShapeTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (2, 2, 'Half on/Half off');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (3, 3, 'On pavement');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (4, 4, 'Perpendicular');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (5, 5, 'Echelon (Diagonal)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (1, 1, 'Parallel (Bay)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (6, 6, 'Perpendicular on Pavement');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (10, 10, 'Parallel (Line)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (11, 11, 'Parallel (Line) with loading');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (7, 12, 'Zig-Zag');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (8, 7, 'Other (please specify in notes)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (9, 21, 'Parallel Bay (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (13, 24, 'Perpendicular Bay (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (14, 25, 'Echelon Bay (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (15, 28, 'Outline Bay (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (16, 8, 'Central Parking');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (17, 22, 'Half on/Half off (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (18, 23, 'On pavement (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (19, 26, 'Perpendicular on Pavement (Polygon)');


--
-- TOC entry 4256 (class 0 OID 286555)
-- Dependencies: 261
-- Data for Name: RestrictionStatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionStatus" ("id", "PK_UID", "RestrictionStatusID", "Description") VALUES (1, 0, 0, 'Proposed');
INSERT INTO "public"."RestrictionStatus" ("id", "PK_UID", "RestrictionStatusID", "Description") VALUES (2, 1, 1, 'Confirmed');
INSERT INTO "public"."RestrictionStatus" ("id", "PK_UID", "RestrictionStatusID", "Description") VALUES (3, 2, 2, 'Temporary');
INSERT INTO "public"."RestrictionStatus" ("id", "PK_UID", "RestrictionStatusID", "Description") VALUES (4, 3, 3, 'Experimental');


--
-- TOC entry 4244 (class 0 OID 286496)
-- Dependencies: 247
-- Data for Name: RestrictionTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (1, 0, 'No Waiting (SYL) (Unacceptable)', 221);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (2, 1, 'Ambulance Bays', 106);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (3, 2, 'Bus Stand', 123);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (4, 3, 'Bus Stop', 107);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (5, 4, 'Buses Only', 109);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (6, 5, 'Business Permit Holders Bays', 102);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (7, 6, 'Car Club Bays', 108);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (8, 7, 'Diplomat Bays', 112);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (9, 8, 'Disabled Bays (Blue Badge)', 110);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (10, 9, 'Disabled Bays (Personalised)', 111);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (11, 10, 'Doctor Bays', 113);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (12, 11, 'Electric vehicle Charging Bay', 125);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (13, 12, 'Free Bays - No Limited Waiting', 127);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (14, 13, 'Limited Waiting (no charge)', 103);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (15, 14, 'Loading Bays', 114);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (16, 15, 'Loading Bays & Disabled Bays', 115);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (17, 16, 'Mayor of London Cycle Hire Bays', 116);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (18, 17, 'Mobile Library Bays', 124);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (19, 18, 'Motorcycle Bay (Residents)', 117);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (20, 19, 'Motorcycle Bay (Visitors)', 118);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (21, 20, 'On-Street Cycle Bays', 119);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (22, 21, 'Other Bays (Please specify in notes)', 126);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (23, 22, 'Pay and Display/Pay by Phone', 121);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (24, 23, 'Police Bays', 120);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (25, 24, 'Permit Holder Bays', 101);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (26, 25, 'Resident/Business Permit Holders Bays', 104);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (27, 26, 'Shared Bays (Permit/Non-permit Holder bays)', 105);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (28, 27, 'Taxi Bays', 122);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (29, 28, 'No Waiting At Any Time (DYL)', 202);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (30, 29, 'Zig Zag - School', 203);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (31, 30, 'Zig Zag - Fire', 204);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (32, 31, 'Zig Zag - Police', 205);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (33, 32, 'Zig Zag - Ambulance', 206);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (34, 33, 'Zig Zag - Hospital', 207);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (35, 34, 'Zig Zag - Yellow (other)', 208);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (36, 35, 'Crossing - Zebra', 209);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (37, 36, 'Crossing - Pelican', 210);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (38, 37, 'Crossing - Toucan', 211);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (39, 38, 'Crossing - Puffin', 212);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (40, 39, 'Crossing - Equestrian', 213);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (41, 40, 'Crossing - Signalised', 214);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (42, 41, 'Crossing - Unmarked and no signals', 215);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (43, 42, 'No Waiting At Any Time (DRL)', 218);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (44, 43, 'Private Road', 219);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (45, 44, 'No Waiting (SYL) (Acceptable)', 201);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (46, 45, 'Unmarked Area (Acceptable)', 216);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (47, 46, 'No Waiting (SRL) (Acceptable)', 217);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (48, 47, 'No Waiting (SRL) (Unacceptable)', 222);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (49, 48, 'Unmarked Area (Unacceptable)', 220);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (50, 49, 'No Loading', 223);


--
-- TOC entry 4245 (class 0 OID 286502)
-- Dependencies: 248
-- Data for Name: RestrictionsInProposals; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'f0ce05a2-7b0e-410b-8556-05ecb0aa485e');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'ceb9e35c-0372-4cf0-ac38-f150eb200ea0');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'f071e490-9f42-4872-a064-a894927c6c4e');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'dc0b1bfb-9532-48ea-8d90-85bddac2f17b');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'f32e4d66-0d7f-4dbc-a48c-c8c44dc1a191');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'c0e47ca6-6148-4a9d-8c33-f576b733ad32');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'a9d38e70-bc08-4f46-8497-71bdad52dad7');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'e6e923ce-6a61-4e6e-b856-db2f20e395e6');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '4c5913dd-0412-439f-8c8b-7eecbcfee7a7');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'a530ddfb-316a-40da-abfd-ba111d1c35b4');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'c31f7cb7-e29d-4117-94b0-307ac280c192');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '0e213bb8-28b6-4e6b-a48a-954b40821b6c');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'b81c152e-0d1d-4ba0-bb96-320f02f4a18a');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '59a25fd9-3b04-44bb-a77b-f5bb383be9ee');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, '362db835-a235-49fa-8f90-2c37955fde39');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '0f493e9b-5e4a-4854-892d-085840a437fc');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '474b2ac4-5c10-4764-b25b-e9cda052aba6');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '12cc30fe-cb33-4570-b228-f2402947bb5e');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '2a5d0a0b-2c87-4257-9147-0bdeeb8af0d2');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, '5dd050cb-8bde-400d-8f03-fccbf492467a');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '9775d869-1cea-4098-9b2a-ce019afa458e');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '014d6fa9-0c7b-49f5-a9d1-5a4dbef9fad4');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '6500cbc0-5072-4a46-a130-6e79a214d896');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'dca8d05a-e437-473d-b95d-d50c792e1c97');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '62b0bf76-1ad4-4afb-97b4-abf7bc32d05a');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, '1bf6eef1-37f8-42b6-82b2-848f577146b6');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'ed8e2e61-3efb-4a89-86ff-4d4200e72803');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, '825fc78e-a8c7-4372-8993-462f37605c68');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 4, 1, 'b0f73006-62f1-4d63-b1b2-758eba0865bf');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 5, 1, '194544db-37b3-4603-97e9-b93d372b3d66');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (5, 3, 2, '362db835-a235-49fa-8f90-2c37955fde39');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (5, 2, 1, '254bdb0f-cc6d-47fc-a4b5-14dc4d244c1d');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (5, 3, 1, 'd4cd82f8-2a72-4232-9a0c-a27392348174');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (5, 3, 1, 'af46bcf3-5758-4f84-85bf-7800a562c8ae');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (6, 2, 2, '59a25fd9-3b04-44bb-a77b-f5bb383be9ee');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (7, 3, 1, 'a1a65fde-2217-434c-aa1d-54814642f447');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (8, 2, 1, 'd78254ca-28af-4f68-abc5-bfb4b12759a6');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (8, 3, 1, 'f0008143-e680-4097-9f21-2509dce993ae');


--
-- TOC entry 4259 (class 0 OID 286565)
-- Dependencies: 264
-- Data for Name: RoadCentreLine; Type: TABLE DATA; Schema: public; Owner: edi_operator
--



--
-- TOC entry 4260 (class 0 OID 286571)
-- Dependencies: 265
-- Data for Name: SignAttachmentTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (1, 1, 'Short Pole');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (2, 2, 'Normal Pole');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (3, 3, 'Tall Pole');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (4, 4, 'Lamppost');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (5, 5, 'Wall');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (6, 6, 'Fences');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (7, 7, 'Other (Please specify in notes)');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (8, 8, 'Traffic Light');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (9, 9, 'Large Pole');


--
-- TOC entry 4261 (class 0 OID 286577)
-- Dependencies: 266
-- Data for Name: SignFadedTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (1, '1', 'No issues');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (2, '2', 'Sign Faded');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (3, '3', 'Sign Damaged');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (4, '4', 'Sign Damaged and Faded');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (5, '5', 'Pole Present, but Sign Missing');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (6, '6', 'Other (Please specify in notes)');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (7, '7', 'Sign OK, but Pole bent');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (8, '8', 'Defaced (Stickers, graffiti, dirt)');


--
-- TOC entry 4263 (class 0 OID 286585)
-- Dependencies: 268
-- Data for Name: SignMountTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (1, '1', 'U-Channel');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (2, '2', 'Round Post Bracket');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (3, '3', 'Square Post Bracket');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (4, '4', 'Wall Bracket');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (5, '5', 'Other (Please specify in notes)');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (6, '6', 'Screws or Nails');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (7, '7', 'Simple bar');


--
-- TOC entry 4265 (class 0 OID 286593)
-- Dependencies: 270
-- Data for Name: SignObscurredTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."SignObscurredTypes" ("id", "Code", "Description") VALUES (1, '1', 'No issue');
INSERT INTO "public"."SignObscurredTypes" ("id", "Code", "Description") VALUES (2, '2', 'Partially obscured');
INSERT INTO "public"."SignObscurredTypes" ("id", "Code", "Description") VALUES (3, '3', 'Completely obscured');


--
-- TOC entry 4267 (class 0 OID 286601)
-- Dependencies: 272
-- Data for Name: SignTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (1, '5T trucks and buses', 1);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (2, 'Ambulances only bays', 2);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (3, 'Bus only bays', 3);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (4, 'Bus stops/Bus stands', 4);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (5, 'Car club', 5);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (6, 'CPZ entry', 6);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (7, 'CPZ exit', 7);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (8, 'Disabled bays', 8);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (9, 'Doctor bays', 9);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (10, 'Electric vehicles recharging point', 10);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (11, 'Free parking bays (not Limited Waiting)', 11);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (12, 'Greenway Disabled Bays', 12);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (13, 'Greenway Loading Bays', 13);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (14, 'Greenway Loading/Disabled Bays', 14);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (15, 'Greenway Loading/Parking Bays', 15);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (16, 'Greenway Parking Bays', 16);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (17, 'Half on/Half off', 17);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (18, 'Limited waiting (no payment)', 18);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (19, 'Loading bay', 19);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (20, 'Motorcycles only bays', 20);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (21, 'No loading', 21);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (22, 'No waiting', 22);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (23, 'No waiting and no loading', 23);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (24, 'On pavement parking', 24);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (25, 'Other (please specify)', 25);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (26, 'Pay and Display/Pay by Phone bays', 26);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (27, 'Pedestrian Areas', 27);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (28, 'Permit holders only', 28);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (29, 'Police bays', 29);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (30, 'Private/Residents only bays', 30);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (31, 'Residents permit holders only', 31);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (32, 'Shared use bays', 32);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (33, 'Taxi ranks', 33);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (34, 'Ticket machine', 34);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (35, 'To be deleted', 35);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (36, 'Zig-Zag school keep clear', 36);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (37, 'Pole only, no sign', 37);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (38, 'No stopping - Greenway', 38);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (39, 'Greenway exit area', 39);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (40, 'Permit Parking Zone (PPZ)', 40);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (41, 'No Stopping - School', 41);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (42, 'On Street NOT in TRO', 42);


--
-- TOC entry 4223 (class 0 OID 286395)
-- Dependencies: 226
-- Data for Name: Signs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."Signs" ("id", "geom", "Signs_Notes", "Signs_Photos_01", "GeometryID", "SignType_1", "SignType_2", "SignType_3", "Signs_DateTime", "PhotoTaken", "Signs_Photos_02", "Signs_Mount", "Surveyor", "TicketMachine_Nr", "Signs_Attachment", "Compl_Signs_Faded", "Compl_Signs_Obscured", "Compl_Signs_Direction", "Compl_Signs_Obsolete", "Compl_Signs_OtherOptions", "Compl_Signs_TicketMachines", "RoadName", "USRN", "RingoPresent", "OpenDate", "CloseDate", "Signs_Photos_03", "GeometryID_181017", "RestrictionID", "CPZ", "ParkingTariffArea") VALUES (NULL, '0101000020346C0000029BD886F4DD1341E222517214932441', NULL, NULL, 'S_ 000000001', 26, 23, NULL, '2020-05-27 22:39:13.070947', 0, NULL, NULL, 'tim.hancock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'North St David Street', '1005', NULL, '2020-05-01', NULL, NULL, NULL, '194544db-37b3-4603-97e9-b93d372b3d66', NULL, NULL);


--
-- TOC entry 4269 (class 0 OID 286609)
-- Dependencies: 274
-- Data for Name: Surveyors; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4272 (class 0 OID 286616)
-- Dependencies: 277
-- Data for Name: TicketMachineIssueTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (1, '1', 'No issues');
INSERT INTO "public"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (2, '2', 'Defaced (e.g. graffiti)');
INSERT INTO "public"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (3, '3', 'Physically Damaged');
INSERT INTO "public"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (4, '4', 'Other (Please specify in notes)');


--
-- TOC entry 4274 (class 0 OID 286624)
-- Dependencies: 279
-- Data for Name: TilesInAcceptedProposals; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1337, 1);
INSERT INTO "public"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1397, 1);
INSERT INTO "public"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1396, 1);
INSERT INTO "public"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1338, 1);
INSERT INTO "public"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (5, 1397, 2);
INSERT INTO "public"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (6, 1397, 3);


--
-- TOC entry 4275 (class 0 OID 286627)
-- Dependencies: 280
-- Data for Name: TimePeriods; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (121, 225, 'Jan-July 8.00pm-10.00am Aug 8.00pm-9.00am Sep-Nov 8.00pm-10.00am Dec 8.00pm-9.00am', 'Jan-July 8.00pm-10.00am;Aug 8.00pm-9.00am;Sep-Nov 8.00pm-10.00am;Dec 8.00pm-9.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (3, 103, '6.30pm-7.00am', '6.30pm-7.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (2, 102, '6.00pm-7.00am', '6.00pm-7.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (122, 226, 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (12, 111, 'At Any Time May-Sept', 'At Any Time May-Sept');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (113, 217, 'Mon-Fri 8.00am-8.00pm', 'Mon-Fri 8.00am-8.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (115, 219, 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm Fri 8.30am-9.15am 11.45am-1.15pm', 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm;Fri 8.30am-9.15am 11.45am-1.15pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (114, 218, 'Mon-Fri 7.30am-9.00am', 'Mon-Fri 7.30am-9.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (118, 222, 'Mon-Fri 8.30am-6.00pm', 'Mon-Fri 8.30am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (85, 162, 'Mon-Sat 9.00am-5.30pm', 'Mon-Sat 9.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (87, 163, 'Mon-Sun 10.30am-4.30pm', 'Mon-Sun 10.30am-4.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (93, 169, 'Sat-Sun 10.00am-4.00pm', 'Sat-Sun 10.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (94, 170, 'Sat-Sun 8.00am-6.00pm May-Sept', 'Sat-Sun 8.00am-6.00pm May-Sept');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (96, 171, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (49, 139, 'Mon-Fri 8.30am-4.30pm', 'Mon-Fri 8.30am-4.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (97, 201, 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (117, 221, 'Mon-Sat 8.00am-4.00pm', 'Mon-Sat 8.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (61, 147, 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (39, 133, 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (47, 141, 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm', 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (52, 12, 'Mon-Fri 8.30am-6.30pm', 'Mon-Fri 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (79, 33, 'Mon-Sat 8.30am-6.30pm', 'Mon-Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (86, 45, 'Mon-Sat 9.30am-6.30pm', 'Mon-Sat 9.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (72, 19, 'Mon-Fri 9.00am-4.00pm', 'Mon-Fri 9.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (77, 26, 'Mon-Sat 7.00am-6.30pm', 'Mon-Sat 7.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (84, 83, 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (22, 124, 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (23, 118, 'Mon-Fri 7.30am-5.00pm', 'Mon-Fri 7.30am-5.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (24, 119, 'Mon-Fri 7.30am-6.30pm Sat-Sun 10.00am-5.30pm', 'Mon-Fri 7.30am-6.30pm;Sat-Sun 10.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (25, 120, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (26, 121, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (53, 75, 'Mon-Fri 8.00am-4.00pm', 'Mon-Fri 8.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (54, 14, 'Mon-Fri 8.00am-6.30pm', 'Mon-Fri 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (55, 15, 'Mon-Fri 8.00am-6.00pm', 'Mon-Fri 8.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (1, 101, '6.00am-10.00pm', '6.00am-10.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (95, 78, 'Unknown - no sign', 'Unknown - no sign');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (45, 10, 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (46, 11, 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (56, 16, 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (80, 34, 'Mon-Sat 8.30am-6.30pm Sun 11.00am-5.00pm', 'Mon-Sat 8.30am-6.30pm;Sun 11.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (83, 43, 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (51, 97, 'Mon-Fri 8.30am-5.30pm', 'Mon-Fri 8.30am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (99, 203, 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (100, 204, 'Mon-Fri 9.30am-4pm Sat All day', 'Mon-Fri 9.30am-4pm;Sat All day');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (101, 205, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (7, 107, '8.00am-6.00pm', '8.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (8, 108, '8.00am-6.00pm 2.15pm-4.00pm', '8.00am-6.00pm 2.15pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (32, 126, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-1.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (33, 127, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-Noon', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-Noon');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (34, 128, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-12.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-12.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (35, 129, 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm', 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (36, 130, 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (37, 131, 'Mon-Fri 8.00am-9.00am Mon-Thurs 2.30pm-3.45pm Fri Noon-1.30pm', 'Mon-Fri 8.00am-9.00am;Mon-Thurs 2.30pm-3.45pm;Fri Noon-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (38, 132, 'Mon-Fri 8.00am-9.15am', 'Mon-Fri 8.00am-9.15am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (40, 134, 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (41, 135, 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (42, 136, 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm', 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (43, 137, 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (44, 138, 'Mon-Fri 8.15am-5.30pm Sat 8.15am-1.30pm', 'Mon-Fri 8.15am-5.30pm;Sat 8.15am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (48, 142, 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm', 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (50, 140, 'Mon-Fri 8.30am-5.00pm', 'Mon-Fri 8.30am-5.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (57, 143, 'Mon-Fri 9.00am-5.00pm', 'Mon-Fri 9.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (58, 144, 'Mon-Fri 9.00am-6.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.00am-6.00pm;Sat 9.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (59, 145, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-1.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-1.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (60, 146, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-5.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (63, 148, 'Mon-Fri 9.15am-4.30pm', 'Mon-Fri 9.15am-4.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (71, 156, 'Mon-Fri 9.30am-4.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 9.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (88, 164, 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (108, 212, 'Mon-Fri 8.00am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 8.00am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (31, 125, 'Mon-Fri 8.00am-5.30pm', 'Mon-Fri 8.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (82, 40, 'Mon-Sat 8.00am-6.00pm', 'Mon-Sat 8.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (21, 123, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm Sat 8.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm;Sat 8.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (9, 109, '8.15am-9.00am 11.30am-1.15pm', '8.15am-9.00am 11.30am-1.15pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (89, 168, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.30am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.30am Noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (81, 39, 'Mon-Sat 8.00am-6.30pm', 'Mon-Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (124, 228, 'Mon-Fri 9.30am-4.00pm', 'Mon-Fri 9.30am-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (65, 99, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (90, 167, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (5, 105, '7.30am-6.30pm', '7.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (6, 106, '8.00am-5.30pm', '8.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (110, 213, 'Mon-Sat 8.30am-5.30pm', 'Mon-Sat 8.30am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (10, 110, '9.00am-5.30pm', '9.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (28, 8, 'Mon-Fri 7.00am-7.00pm', 'Mon-Fri 7.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (64, 149, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-1.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (62, 150, 'Mon-Fri 9.15pm-8.00am', 'Mon-Fri 9.15pm-8.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (66, 151, 'Mon-Fri 9.30am-11.00am', 'Mon-Fri 9.30am-11.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (67, 152, 'Mon-Fri 9.30am-3.30pm', 'Mon-Fri 9.30am-3.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (68, 153, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (69, 154, 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am', 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (70, 155, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (98, 202, 'Mon-Sat 8.15am-6.00pm', 'Mon-Sat 8.15am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (17, 115, 'Mon-Fri 11.30am-1.00pm', 'Mon-Fri 11.30am-1.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (20, 122, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am;4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (73, 157, 'Mon-Sat 7.00am-6.00pm', 'Mon-Sat 7.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (74, 158, 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (75, 160, 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (76, 159, 'Mon-Sat 7.30am-6.30pm', 'Mon-Sat 7.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (78, 161, 'Mon-Sat 8.30am-6.00pm', 'Mon-Sat 8.30am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (102, 206, 'Sat 1.30pm-6.30pm', 'Sat 1.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (120, 224, '7.00am-7.00pm', '7.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (11, 1, 'At Any Time', 'At Any Time');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (106, 210, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (107, 211, 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (116, 220, 'Mon-Sat 9.00am-6.00pm', 'Mon-Sat 9.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (123, 227, 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (111, 215, '8.00am-9.30am 4.00pm-6.00pm', '8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (112, 216, 'Mon-Fri 7.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (92, 166, 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm Fri 11.45am-1.15pm', 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm;Fri 11.45am-1.15pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (4, 104, '7.00am-8.00pm', '7.00am-8.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (91, 165, 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (27, 98, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (13, 112, 'Mon-Fri 1.30pm-3.00pm', 'Mon-Fri 1.30pm-3.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (14, 113, 'Mon-Fri 10.00am-11.30am', 'Mon-Fri 10.00am-11.30am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (15, 2, 'Mon-Fri 10.00am-3.30pm', 'Mon-Fri 10.00am-3.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (16, 114, 'Mon-Fri 11.00am-12.30pm', 'Mon-Fri 11.00am-12.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (18, 116, 'Mon-Fri 12.30pm-2.00pm', 'Mon-Fri 12.30pm-2.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (19, 117, 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (103, 207, '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm', '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (104, 208, 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (105, 209, '7.30am-9.30am 4.00pm-6.30pm', '7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (30, 96, 'Mon-Fri 8.00am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.15am;4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (125, 229, 'Mon-Sun 9.30am-4.00pm', 'Mon-Sun 9.30am-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (126, 230, 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ', 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (119, 223, 'Mon-Sat 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.30am-9.30am; 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (127, 231, 'Mon-Sun', 'Mon-Sun');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (128, 232, '10.30am-11.00pm', '10.30am-11.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (130, 234, '10.30am-10.00pm', '10.30am-10pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (131, 235, 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm', 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (132, 236, '7.00am-10.00am 4.00pm-6.30pm', '7.00am-10.00am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (133, 237, 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm', 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (134, 238, 'Mon-Sat 7.00am-8.00am', 'Mon-Sat 7.00am-8.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (135, 239, 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (129, 233, '10.30am-midnight and midnight-6.30am', '10.30am-midnight, midnight-6.30am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (240, 240, '8.30am-6.30pm', '8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (300, 0, NULL, NULL);
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (301, 241, 'Mon-Sun 8.00pm to 8.00am', 'Mon-Sun 8.00pm to 8.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (302, 242, 'Mon-Sun 5:30-7:00 and 09:30-11:00', '5:30-7:00 9:30-11:00');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (303, 243, 'Mon-Sun Midnight-5.30, 7.00-9.30, 11.00-midnight', 'Midnight-5.30, 7.00-9.30, 11.00-midnight');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (306, 306, 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (307, 307, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (308, 308, 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (309, 309, 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (310, 310, 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (311, 311, 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (312, 312, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (313, 313, 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (314, 314, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (315, 315, 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (316, 316, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (317, 317, 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (318, 318, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm');


--
-- TOC entry 4247 (class 0 OID 286507)
-- Dependencies: 250
-- Data for Name: TimePeriods_orig; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (121, 225, 'Jan-July 8.00pm-10.00am Aug 8.00pm-9.00am Sep-Nov 8.00pm-10.00am Dec 8.00pm-9.00am', 'Jan-July 8.00pm-10.00am;Aug 8.00pm-9.00am;Sep-Nov 8.00pm-10.00am;Dec 8.00pm-9.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (3, 103, '6.30pm-7.00am', '6.30pm-7.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (2, 102, '6.00pm-7.00am', '6.00pm-7.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (122, 226, 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (12, 111, 'At Any Time May-Sept', 'At Any Time May-Sept');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (113, 217, 'Mon-Fri 8.00am-8.00pm', 'Mon-Fri 8.00am-8.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (115, 219, 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm Fri 8.30am-9.15am 11.45am-1.15pm', 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm;Fri 8.30am-9.15am 11.45am-1.15pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (114, 218, 'Mon-Fri 7.30am-9.00am', 'Mon-Fri 7.30am-9.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (118, 222, 'Mon-Fri 8.30am-6.00pm', 'Mon-Fri 8.30am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (85, 162, 'Mon-Sat 9.00am-5.30pm', 'Mon-Sat 9.00am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (87, 163, 'Mon-Sun 10.30am-4.30pm', 'Mon-Sun 10.30am-4.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (93, 169, 'Sat-Sun 10.00am-4.00pm', 'Sat-Sun 10.00am-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (94, 170, 'Sat-Sun 8.00am-6.00pm May-Sept', 'Sat-Sun 8.00am-6.00pm May-Sept');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (96, 171, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (49, 139, 'Mon-Fri 8.30am-4.30pm', 'Mon-Fri 8.30am-4.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (97, 201, 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (117, 221, 'Mon-Sat 8.00am-4.00pm', 'Mon-Sat 8.00am-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (61, 147, 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (39, 133, 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (47, 141, 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm', 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (52, 12, 'Mon-Fri 8.30am-6.30pm', 'Mon-Fri 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (79, 33, 'Mon-Sat 8.30am-6.30pm', 'Mon-Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (86, 45, 'Mon-Sat 9.30am-6.30pm', 'Mon-Sat 9.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (72, 19, 'Mon-Fri 9.00am-4.00pm', 'Mon-Fri 9.00am-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (77, 26, 'Mon-Sat 7.00am-6.30pm', 'Mon-Sat 7.00am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (84, 83, 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (22, 124, 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (23, 118, 'Mon-Fri 7.30am-5.00pm', 'Mon-Fri 7.30am-5.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (24, 119, 'Mon-Fri 7.30am-6.30pm Sat-Sun 10.00am-5.30pm', 'Mon-Fri 7.30am-6.30pm;Sat-Sun 10.00am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (25, 120, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (26, 121, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (53, 75, 'Mon-Fri 8.00am-4.00pm', 'Mon-Fri 8.00am-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (54, 14, 'Mon-Fri 8.00am-6.30pm', 'Mon-Fri 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (55, 15, 'Mon-Fri 8.00am-6.00pm', 'Mon-Fri 8.00am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (1, 101, '6.00am-10.00pm', '6.00am-10.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (95, 78, 'Unknown - no sign', 'Unknown - no sign');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (45, 10, 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (46, 11, 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (56, 16, 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (80, 34, 'Mon-Sat 8.30am-6.30pm Sun 11.00am-5.00pm', 'Mon-Sat 8.30am-6.30pm;Sun 11.00am-5.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (83, 43, 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (51, 97, 'Mon-Fri 8.30am-5.30pm', 'Mon-Fri 8.30am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (99, 203, 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (100, 204, 'Mon-Fri 9.30am-4pm Sat All day', 'Mon-Fri 9.30am-4pm;Sat All day');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (101, 205, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (7, 107, '8.00am-6.00pm', '8.00am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (8, 108, '8.00am-6.00pm 2.15pm-4.00pm', '8.00am-6.00pm 2.15pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (32, 126, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-1.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (33, 127, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-Noon', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-Noon');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (34, 128, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-12.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-12.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (35, 129, 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm', 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (36, 130, 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (37, 131, 'Mon-Fri 8.00am-9.00am Mon-Thurs 2.30pm-3.45pm Fri Noon-1.30pm', 'Mon-Fri 8.00am-9.00am;Mon-Thurs 2.30pm-3.45pm;Fri Noon-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (38, 132, 'Mon-Fri 8.00am-9.15am', 'Mon-Fri 8.00am-9.15am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (40, 134, 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (41, 135, 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (42, 136, 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm', 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (43, 137, 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (44, 138, 'Mon-Fri 8.15am-5.30pm Sat 8.15am-1.30pm', 'Mon-Fri 8.15am-5.30pm;Sat 8.15am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (48, 142, 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm', 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (50, 140, 'Mon-Fri 8.30am-5.00pm', 'Mon-Fri 8.30am-5.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (57, 143, 'Mon-Fri 9.00am-5.00pm', 'Mon-Fri 9.00am-5.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (58, 144, 'Mon-Fri 9.00am-6.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.00am-6.00pm;Sat 9.30am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (59, 145, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-1.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-1.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (60, 146, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-5.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-5.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (63, 148, 'Mon-Fri 9.15am-4.30pm', 'Mon-Fri 9.15am-4.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (71, 156, 'Mon-Fri 9.30am-4.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 9.30am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (88, 164, 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (108, 212, 'Mon-Fri 8.00am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 8.00am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (31, 125, 'Mon-Fri 8.00am-5.30pm', 'Mon-Fri 8.00am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (82, 40, 'Mon-Sat 8.00am-6.00pm', 'Mon-Sat 8.00am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (21, 123, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm Sat 8.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm;Sat 8.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (9, 109, '8.15am-9.00am 11.30am-1.15pm', '8.15am-9.00am 11.30am-1.15pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (89, 168, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.30am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.30am Noon-1.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (81, 39, 'Mon-Sat 8.00am-6.30pm', 'Mon-Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (124, 228, 'Mon-Fri 9.30am-4.00pm', 'Mon-Fri 9.30am-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (65, 99, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (90, 167, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (5, 105, '7.30am-6.30pm', '7.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (6, 106, '8.00am-5.30pm', '8.00am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (110, 213, 'Mon-Sat 8.30am-5.30pm', 'Mon-Sat 8.30am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (10, 110, '9.00am-5.30pm', '9.00am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (28, 8, 'Mon-Fri 7.00am-7.00pm', 'Mon-Fri 7.00am-7.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (64, 149, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-1.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (62, 150, 'Mon-Fri 9.15pm-8.00am', 'Mon-Fri 9.15pm-8.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (66, 151, 'Mon-Fri 9.30am-11.00am', 'Mon-Fri 9.30am-11.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (67, 152, 'Mon-Fri 9.30am-3.30pm', 'Mon-Fri 9.30am-3.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (68, 153, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (69, 154, 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am', 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (70, 155, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (98, 202, 'Mon-Sat 8.15am-6.00pm', 'Mon-Sat 8.15am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (17, 115, 'Mon-Fri 11.30am-1.00pm', 'Mon-Fri 11.30am-1.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (20, 122, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am;4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (73, 157, 'Mon-Sat 7.00am-6.00pm', 'Mon-Sat 7.00am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (74, 158, 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (75, 160, 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (76, 159, 'Mon-Sat 7.30am-6.30pm', 'Mon-Sat 7.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (78, 161, 'Mon-Sat 8.30am-6.00pm', 'Mon-Sat 8.30am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (102, 206, 'Sat 1.30pm-6.30pm', 'Sat 1.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (120, 224, '7.00am-7.00pm', '7.00am-7.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (11, 1, 'At Any Time', 'At Any Time');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (106, 210, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (107, 211, 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (116, 220, 'Mon-Sat 9.00am-6.00pm', 'Mon-Sat 9.00am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (123, 227, 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (111, 215, '8.00am-9.30am 4.00pm-6.00pm', '8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (112, 216, 'Mon-Fri 7.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (92, 166, 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm Fri 11.45am-1.15pm', 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm;Fri 11.45am-1.15pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (4, 104, '7.00am-8.00pm', '7.00am-8.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (91, 165, 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (27, 98, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (13, 112, 'Mon-Fri 1.30pm-3.00pm', 'Mon-Fri 1.30pm-3.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (14, 113, 'Mon-Fri 10.00am-11.30am', 'Mon-Fri 10.00am-11.30am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (15, 2, 'Mon-Fri 10.00am-3.30pm', 'Mon-Fri 10.00am-3.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (16, 114, 'Mon-Fri 11.00am-12.30pm', 'Mon-Fri 11.00am-12.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (18, 116, 'Mon-Fri 12.30pm-2.00pm', 'Mon-Fri 12.30pm-2.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (19, 117, 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (103, 207, '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm', '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (104, 208, 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (105, 209, '7.30am-9.30am 4.00pm-6.30pm', '7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (30, 96, 'Mon-Fri 8.00am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.15am;4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (125, 229, 'Mon-Sun 9.30am-4.00pm', 'Mon-Sun 9.30am-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (126, 230, 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ', 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (119, 223, 'Mon-Sat 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.30am-9.30am; 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (127, 231, 'Mon-Sun', 'Mon-Sun');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (128, 232, '10.30am-11.00pm', '10.30am-11.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (130, 234, '10.30am-10.00pm', '10.30am-10pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (131, 235, 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm', 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (132, 236, '7.00am-10.00am 4.00pm-6.30pm', '7.00am-10.00am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (133, 237, 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm', 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (134, 238, 'Mon-Sat 7.00am-8.00am', 'Mon-Sat 7.00am-8.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (135, 239, 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (129, 233, '10.30am-midnight and midnight-6.30am', '10.30am-midnight, midnight-6.30am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (240, 240, '8.30am-6.30pm', '8.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (300, 0, NULL, NULL);
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (301, 241, 'Mon-Sun 8.00pm to 8.00am', 'Mon-Sun 8.00pm to 8.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (302, 242, 'Mon-Sun 5:30-7:00 and 09:30-11:00', '5:30-7:00 9:30-11:00');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (303, 243, 'Mon-Sun Midnight-5.30, 7.00-9.30, 11.00-midnight', 'Midnight-5.30, 7.00-9.30, 11.00-midnight');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (304, 304, 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (305, 305, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (306, 306, 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (307, 307, 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (308, 308, 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (309, 309, 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (310, 310, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (311, 311, 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (312, 312, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (313, 313, 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (314, 314, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (315, 315, 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (316, 316, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm');


--
-- TOC entry 4276 (class 0 OID 286634)
-- Dependencies: 281
-- Data for Name: baysWordingTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."baysWordingTypes" ("id", "Code", "Description") VALUES (1, '1', 'N/A');
INSERT INTO "public"."baysWordingTypes" ("id", "Code", "Description") VALUES (2, '2', 'Dual Use bay');
INSERT INTO "public"."baysWordingTypes" ("id", "Code", "Description") VALUES (3, '3', 'No stopping except');
INSERT INTO "public"."baysWordingTypes" ("id", "Code", "Description") VALUES (4, '4', 'No waiting except');
INSERT INTO "public"."baysWordingTypes" ("id", "Code", "Description") VALUES (5, '5', 'Goods vehicles only');


--
-- TOC entry 4278 (class 0 OID 286642)
-- Dependencies: 283
-- Data for Name: baytypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (1, 'Ambulance Bays', 1);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (4, 'Buses Parking only', 4);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (6, 'Car Club Bays', 6);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (8, 'Diplomat Bays', 8);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (9, 'Disabled Bays (Blue Badge)', 9);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (10, 'Disabled Bays (Personalised)', 10);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (11, 'Doctor Bays', 11);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (12, 'Electric Vehicle Charging Bay', 12);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (19, 'Limited Waiting (No Charge)', 19);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (20, 'Loading only', 20);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (21, 'Loading Bays & Disabled Bays', 21);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (23, 'Motorcycle Bay (Permit Holders only)', 23);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (24, 'Motorcycle Solo only', 24);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (25, 'On-Street Cycle Bays', 25);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (27, 'Pay and Display/Pay by Phone', 27);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (29, 'Police Bays', 29);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (67, 'RNLI Permit Holders only', 40);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (34, 'Shared Use Parking Place', 34);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (35, 'Shared Use Parking Place', 35);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (28, 'Permit Holders Parking Place', 28);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (31, 'Permit Holders Parking Place', 31);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (33, 'Shared Use Parking Place', 33);


--
-- TOC entry 4283 (class 0 OID 286653)
-- Dependencies: 288
-- Data for Name: layer_styles; Type: TABLE DATA; Schema: public; Owner: edi_operator
--



--
-- TOC entry 4285 (class 0 OID 286662)
-- Dependencies: 290
-- Data for Name: linetypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (9, 'No Stopping (SRL)', 8);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (10, 'No Stopping At Any Time (DRL)', 9);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (11, 'No Waiting (SYL)', 10);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (12, 'No Waiting At Any Time (DYL)', 11);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (16, 'Zig-Zag Keep Clear Ambulance', 15);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (17, 'Zig-Zag Keep Clear Fire', 16);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (18, 'Zig-Zag Keep Clear Hospital', 17);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (19, 'Zig-Zag Keep Clear Police', 18);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (20, 'Zig-Zag Keep Clear White', 19);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (21, 'Zig-Zag Keep Clear Yellow (Other)', 20);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (22, 'Zig-Zag School Keep Clear', 21);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (39, 'No Waiting (SYL) (in Mews/PPA)', 410);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (40, 'No Waiting At Any Time (DYL) (in Mews/PPA)', 411);


--
-- TOC entry 4290 (class 0 OID 286673)
-- Dependencies: 295
-- Data for Name: signs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3896 (class 0 OID 285621)
-- Dependencies: 207
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4409 (class 0 OID 0)
-- Dependencies: 212
-- Name: ActionOnProposalAcceptanceTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."ActionOnProposalAcceptanceTypes_id_seq"', 2, true);


--
-- TOC entry 4410 (class 0 OID 0)
-- Dependencies: 215
-- Name: BayLineTypesInUse_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."BayLineTypesInUse_gid_seq"', 148, true);


--
-- TOC entry 4411 (class 0 OID 0)
-- Dependencies: 217
-- Name: BayLinesFadedTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."BayLinesFadedTypes_id_seq"', 6, true);


--
-- TOC entry 4412 (class 0 OID 0)
-- Dependencies: 219
-- Name: Bays2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."Bays2_id_seq"', 78364, true);


--
-- TOC entry 4413 (class 0 OID 0)
-- Dependencies: 222
-- Name: BaysLines_SignIssueTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."BaysLines_SignIssueTypes_id_seq"', 4, true);


--
-- TOC entry 4414 (class 0 OID 0)
-- Dependencies: 223
-- Name: CECStatusTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."CECStatusTypes_id_seq"', 5, true);


--
-- TOC entry 4415 (class 0 OID 0)
-- Dependencies: 227
-- Name: EDI01_Signs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."EDI01_Signs_id_seq"', 56903, true);


--
-- TOC entry 4416 (class 0 OID 0)
-- Dependencies: 231
-- Name: LengthOfTime_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."LengthOfTime_id_seq"', 17, true);


--
-- TOC entry 4417 (class 0 OID 0)
-- Dependencies: 233
-- Name: Lines2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."Lines2_id_seq"', 151803, true);


--
-- TOC entry 4418 (class 0 OID 0)
-- Dependencies: 239
-- Name: PTAs_180725_merged_10_id_seq; Type: SEQUENCE SET; Schema: public; Owner: edi_operator
--

SELECT pg_catalog.setval('"public"."PTAs_180725_merged_10_id_seq"', 110, true);


--
-- TOC entry 4419 (class 0 OID 0)
-- Dependencies: 241
-- Name: PaymentTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."PaymentTypes_id_seq"', 4, true);


--
-- TOC entry 4420 (class 0 OID 0)
-- Dependencies: 243
-- Name: ProposalStatusTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."ProposalStatusTypes_id_seq"', 3, true);


--
-- TOC entry 4421 (class 0 OID 0)
-- Dependencies: 244
-- Name: Proposals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."Proposals_id_seq"', 148, true);


--
-- TOC entry 4422 (class 0 OID 0)
-- Dependencies: 254
-- Name: RestrictionGeometryTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RestrictionGeometryTypes_id_seq"', 19, true);


--
-- TOC entry 4423 (class 0 OID 0)
-- Dependencies: 256
-- Name: RestrictionLayers2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RestrictionLayers2_id_seq"', 7, true);


--
-- TOC entry 4424 (class 0 OID 0)
-- Dependencies: 257
-- Name: RestrictionPolygonTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RestrictionPolygonTypes_id_seq"', 6, true);


--
-- TOC entry 4425 (class 0 OID 0)
-- Dependencies: 262
-- Name: RestrictionStatus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RestrictionStatus_id_seq"', 4, true);


--
-- TOC entry 4426 (class 0 OID 0)
-- Dependencies: 263
-- Name: RestrictionTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RestrictionTypes_id_seq"', 50, true);


--
-- TOC entry 4427 (class 0 OID 0)
-- Dependencies: 267
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."SignFadedTypes_id_seq"', 8, true);


--
-- TOC entry 4428 (class 0 OID 0)
-- Dependencies: 269
-- Name: SignMounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."SignMounts_id_seq"', 7, true);


--
-- TOC entry 4429 (class 0 OID 0)
-- Dependencies: 271
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."SignObscurredTypes_id_seq"', 3, true);


--
-- TOC entry 4430 (class 0 OID 0)
-- Dependencies: 273
-- Name: SignTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."SignTypes_id_seq"', 42, true);


--
-- TOC entry 4431 (class 0 OID 0)
-- Dependencies: 275
-- Name: Surveyors_Code_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."Surveyors_Code_seq"', 14, true);


--
-- TOC entry 4432 (class 0 OID 0)
-- Dependencies: 276
-- Name: TROStatusTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."TROStatusTypes_id_seq"', 3, true);


--
-- TOC entry 4433 (class 0 OID 0)
-- Dependencies: 278
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."TicketMachineIssueTypes_id_seq"', 4, true);


--
-- TOC entry 4434 (class 0 OID 0)
-- Dependencies: 249
-- Name: TimePeriods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."TimePeriods_id_seq"', 329, true);


--
-- TOC entry 4435 (class 0 OID 0)
-- Dependencies: 282
-- Name: baysWordingTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."baysWordingTypes_id_seq"', 5, true);


--
-- TOC entry 4436 (class 0 OID 0)
-- Dependencies: 284
-- Name: baytypes_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."baytypes_gid_seq"', 70, true);


--
-- TOC entry 4437 (class 0 OID 0)
-- Dependencies: 285
-- Name: controlledparkingzones_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."controlledparkingzones_gid_seq"', 40, true);


--
-- TOC entry 4438 (class 0 OID 0)
-- Dependencies: 286
-- Name: corners_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."corners_seq"', 34569, true);


--
-- TOC entry 4439 (class 0 OID 0)
-- Dependencies: 287
-- Name: issueid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."issueid_seq"', 1809, true);


--
-- TOC entry 4440 (class 0 OID 0)
-- Dependencies: 289
-- Name: layer_styles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: edi_operator
--

SELECT pg_catalog.setval('"public"."layer_styles_id_seq"', 1, true);


--
-- TOC entry 4441 (class 0 OID 0)
-- Dependencies: 291
-- Name: linetypes2_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."linetypes2_gid_seq"', 40, true);


--
-- TOC entry 4442 (class 0 OID 0)
-- Dependencies: 292
-- Name: pta_ref; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."pta_ref"', 153, true);


--
-- TOC entry 4443 (class 0 OID 0)
-- Dependencies: 259
-- Name: restrictionPolygons_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."restrictionPolygons_seq"', 953, true);


--
-- TOC entry 4444 (class 0 OID 0)
-- Dependencies: 293
-- Name: serial; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."serial"', 926, true);


--
-- TOC entry 4445 (class 0 OID 0)
-- Dependencies: 294
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."signAttachmentTypes2_id_seq"', 9, true);


--
-- TOC entry 4446 (class 0 OID 0)
-- Dependencies: 296
-- Name: signs_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."signs_gid_seq"', 1094, true);


--
-- TOC entry 3935 (class 2606 OID 286708)
-- Name: ActionOnProposalAcceptanceTypes ActionOnProposalAcceptanceTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ActionOnProposalAcceptanceTypes"
    ADD CONSTRAINT "ActionOnProposalAcceptanceTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3937 (class 2606 OID 286710)
-- Name: BayLineTypesInUse BayLineTypesInUse_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."BayLineTypesInUse"
    ADD CONSTRAINT "BayLineTypesInUse_Code_key" UNIQUE ("Code");


--
-- TOC entry 3939 (class 2606 OID 286712)
-- Name: BayLineTypesInUse BayLineTypesInUse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."BayLineTypesInUse"
    ADD CONSTRAINT "BayLineTypesInUse_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3942 (class 2606 OID 286714)
-- Name: BayLinesFadedTypes BayLinesFadedTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."BayLinesFadedTypes"
    ADD CONSTRAINT "BayLinesFadedTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3948 (class 2606 OID 286716)
-- Name: BaysLines_SignIssueTypes BaysLines_SignIssueTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."BaysLines_SignIssueTypes"
    ADD CONSTRAINT "BaysLines_SignIssueTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3945 (class 2606 OID 286718)
-- Name: Bays Bays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Bays"
    ADD CONSTRAINT "Bays_pkey" PRIMARY KEY ("GeometryID");


--
-- TOC entry 3950 (class 2606 OID 286720)
-- Name: CPZs CPZs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."CPZs"
    ADD CONSTRAINT "CPZs_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3961 (class 2606 OID 286722)
-- Name: EDI_RoadCasement_Polyline EDI_RoadCasement_Polyline_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."EDI_RoadCasement_Polyline"
    ADD CONSTRAINT "EDI_RoadCasement_Polyline_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3964 (class 2606 OID 286724)
-- Name: EDI_Sections EDI_Sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."EDI_Sections"
    ADD CONSTRAINT "EDI_Sections_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3967 (class 2606 OID 286726)
-- Name: LengthOfTime LengthOfTime_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."LengthOfTime"
    ADD CONSTRAINT "LengthOfTime_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3971 (class 2606 OID 286728)
-- Name: Lines Lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Lines"
    ADD CONSTRAINT "Lines_pkey" PRIMARY KEY ("GeometryID");


--
-- TOC entry 3974 (class 2606 OID 286730)
-- Name: LookupCodeTransfers_Bays LookupCodeTransfers_Bays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."LookupCodeTransfers_Bays"
    ADD CONSTRAINT "LookupCodeTransfers_Bays_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3976 (class 2606 OID 286732)
-- Name: LookupCodeTransfers_Lines LookupCodeTransfers_Lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."LookupCodeTransfers_Lines"
    ADD CONSTRAINT "LookupCodeTransfers_Lines_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3978 (class 2606 OID 286734)
-- Name: MapGrid MapGrid_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."MapGrid"
    ADD CONSTRAINT "MapGrid_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3981 (class 2606 OID 286736)
-- Name: ParkingTariffAreas PTAs_180725_merged_10_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."ParkingTariffAreas"
    ADD CONSTRAINT "PTAs_180725_merged_10_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3984 (class 2606 OID 286738)
-- Name: PaymentTypes PaymentTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."PaymentTypes"
    ADD CONSTRAINT "PaymentTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3986 (class 2606 OID 286740)
-- Name: ProposalStatusTypes ProposalStatusTypes_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ProposalStatusTypes"
    ADD CONSTRAINT "ProposalStatusTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 3988 (class 2606 OID 286742)
-- Name: ProposalStatusTypes ProposalStatusTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ProposalStatusTypes"
    ADD CONSTRAINT "ProposalStatusTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3990 (class 2606 OID 286744)
-- Name: Proposals Proposals_PK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Proposals"
    ADD CONSTRAINT "Proposals_PK" PRIMARY KEY ("ProposalID");


--
-- TOC entry 3992 (class 2606 OID 286746)
-- Name: Proposals Proposals_ProposalTitle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Proposals"
    ADD CONSTRAINT "Proposals_ProposalTitle_key" UNIQUE ("ProposalTitle");


--
-- TOC entry 4002 (class 2606 OID 286748)
-- Name: RestrictionShapeTypes RestrictionGeometryTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionShapeTypes"
    ADD CONSTRAINT "RestrictionGeometryTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4006 (class 2606 OID 286750)
-- Name: RestrictionLayers RestrictionLayers2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers2_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4008 (class 2606 OID 286752)
-- Name: RestrictionLayers RestrictionLayers_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers_id_key" UNIQUE ("id");


--
-- TOC entry 4010 (class 2606 OID 286754)
-- Name: RestrictionPolygonTypes RestrictionPolygonTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionPolygonTypes"
    ADD CONSTRAINT "RestrictionPolygonTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4012 (class 2606 OID 286756)
-- Name: RestrictionPolygons RestrictionPolygons_RestrictionID_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionPolygons_RestrictionID_key" UNIQUE ("RestrictionID");


--
-- TOC entry 4004 (class 2606 OID 286758)
-- Name: RestrictionShapeTypes RestrictionShapeTypes_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionShapeTypes"
    ADD CONSTRAINT "RestrictionShapeTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4017 (class 2606 OID 286760)
-- Name: RestrictionStatus RestrictionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionStatus"
    ADD CONSTRAINT "RestrictionStatus_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3994 (class 2606 OID 286762)
-- Name: RestrictionTypes RestrictionTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionTypes"
    ADD CONSTRAINT "RestrictionTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3996 (class 2606 OID 286764)
-- Name: RestrictionsInProposals RestrictionsInProposals_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_pk" PRIMARY KEY ("ProposalID", "RestrictionTableID", "RestrictionID");


--
-- TOC entry 4019 (class 2606 OID 286766)
-- Name: RoadCentreLine RoadCentreLine_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."RoadCentreLine"
    ADD CONSTRAINT "RoadCentreLine_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4024 (class 2606 OID 286768)
-- Name: SignFadedTypes SignFadedTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignFadedTypes"
    ADD CONSTRAINT "SignFadedTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4026 (class 2606 OID 286770)
-- Name: SignMountTypes SignMounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignMountTypes"
    ADD CONSTRAINT "SignMounts_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4028 (class 2606 OID 286772)
-- Name: SignObscurredTypes SignObscurredTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignObscurredTypes"
    ADD CONSTRAINT "SignObscurredTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4030 (class 2606 OID 286774)
-- Name: SignTypes SignTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignTypes"
    ADD CONSTRAINT "SignTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3956 (class 2606 OID 286776)
-- Name: Signs Signs_RestrictionID_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Signs"
    ADD CONSTRAINT "Signs_RestrictionID_key" UNIQUE ("RestrictionID");


--
-- TOC entry 3958 (class 2606 OID 286778)
-- Name: Signs Signs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Signs"
    ADD CONSTRAINT "Signs_pkey" PRIMARY KEY ("GeometryID");


--
-- TOC entry 4032 (class 2606 OID 286780)
-- Name: Surveyors Surveyors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Surveyors"
    ADD CONSTRAINT "Surveyors_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4034 (class 2606 OID 286782)
-- Name: TicketMachineIssueTypes TicketMachineIssueTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TicketMachineIssueTypes"
    ADD CONSTRAINT "TicketMachineIssueTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4036 (class 2606 OID 286784)
-- Name: TilesInAcceptedProposals TilesInAcceptedProposals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_pkey" PRIMARY KEY ("ProposalID", "TileNr", "RevisionNr");


--
-- TOC entry 3998 (class 2606 OID 286786)
-- Name: TimePeriods_orig TimePeriods_180124_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TimePeriods_orig"
    ADD CONSTRAINT "TimePeriods_180124_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4000 (class 2606 OID 286788)
-- Name: TimePeriods_orig TimePeriods_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TimePeriods_orig"
    ADD CONSTRAINT "TimePeriods_Code_key" UNIQUE ("Code");


--
-- TOC entry 4038 (class 2606 OID 286790)
-- Name: TimePeriods TimePeriods_Code_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_Code_key1" UNIQUE ("Code");


--
-- TOC entry 4040 (class 2606 OID 286792)
-- Name: TimePeriods TimePeriods_Description_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_Description_key" UNIQUE ("Description");


--
-- TOC entry 4042 (class 2606 OID 286794)
-- Name: TimePeriods TimePeriods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4044 (class 2606 OID 286796)
-- Name: baysWordingTypes baysWordingTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."baysWordingTypes"
    ADD CONSTRAINT "baysWordingTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4046 (class 2606 OID 286798)
-- Name: baytypes baytypes_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."baytypes"
    ADD CONSTRAINT "baytypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4048 (class 2606 OID 286800)
-- Name: baytypes baytypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."baytypes"
    ADD CONSTRAINT "baytypes_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3954 (class 2606 OID 286802)
-- Name: ControlledParkingZones controlledparkingzones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ControlledParkingZones"
    ADD CONSTRAINT "controlledparkingzones_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4050 (class 2606 OID 286804)
-- Name: layer_styles layer_styles_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."layer_styles"
    ADD CONSTRAINT "layer_styles_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4052 (class 2606 OID 286806)
-- Name: linetypes linetypes2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."linetypes"
    ADD CONSTRAINT "linetypes2_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4054 (class 2606 OID 286808)
-- Name: linetypes linetypes_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."linetypes"
    ADD CONSTRAINT "linetypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4014 (class 2606 OID 286810)
-- Name: RestrictionPolygons restrictionsPolygons_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionPolygons"
    ADD CONSTRAINT "restrictionsPolygons_pk" PRIMARY KEY ("GeometryID");


--
-- TOC entry 4022 (class 2606 OID 286812)
-- Name: SignAttachmentTypes signAttachmentTypes2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignAttachmentTypes"
    ADD CONSTRAINT "signAttachmentTypes2_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4057 (class 2606 OID 286814)
-- Name: signs signs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."signs"
    ADD CONSTRAINT "signs_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3940 (class 1259 OID 286815)
-- Name: BayLineTypes_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "BayLineTypes_key" ON "public"."BayLineTypes" USING "btree" ("Code");


--
-- TOC entry 3943 (class 1259 OID 286363)
-- Name: BayTypes_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "BayTypes_key" ON "public"."BayTypes" USING "btree" ("Code");


--
-- TOC entry 3968 (class 1259 OID 286429)
-- Name: LineTypes_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "LineTypes_key" ON "public"."LineTypes" USING "btree" ("Code");


--
-- TOC entry 3969 (class 1259 OID 286816)
-- Name: Lines_EDI_180124_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Lines_EDI_180124_idx" ON "public"."Lines" USING "gist" ("geom");


--
-- TOC entry 3952 (class 1259 OID 286817)
-- Name: controlledparkingzones_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "controlledparkingzones_geom_idx" ON "public"."ControlledParkingZones" USING "gist" ("geom");


--
-- TOC entry 3946 (class 1259 OID 286818)
-- Name: sidx_Bays_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_Bays_geom" ON "public"."Bays" USING "gist" ("geom");


--
-- TOC entry 3951 (class 1259 OID 286819)
-- Name: sidx_CPZs_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_CPZs_geom" ON "public"."CPZs" USING "gist" ("geom");


--
-- TOC entry 3959 (class 1259 OID 286820)
-- Name: sidx_EDI01_Signs_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_EDI01_Signs_geom" ON "public"."Signs" USING "gist" ("geom");


--
-- TOC entry 3962 (class 1259 OID 286821)
-- Name: sidx_EDI_RoadCasement_Polyline_geom; Type: INDEX; Schema: public; Owner: edi_operator
--

CREATE INDEX "sidx_EDI_RoadCasement_Polyline_geom" ON "public"."EDI_RoadCasement_Polyline" USING "gist" ("geom");


--
-- TOC entry 3965 (class 1259 OID 286822)
-- Name: sidx_EDI_Sections_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_EDI_Sections_geom" ON "public"."EDI_Sections" USING "gist" ("geom");


--
-- TOC entry 3972 (class 1259 OID 286823)
-- Name: sidx_Lines_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_Lines_geom" ON "public"."Lines" USING "gist" ("geom");


--
-- TOC entry 3979 (class 1259 OID 286824)
-- Name: sidx_MapGrid_geom; Type: INDEX; Schema: public; Owner: edi_operator
--

CREATE INDEX "sidx_MapGrid_geom" ON "public"."MapGrid" USING "gist" ("geom");


--
-- TOC entry 3982 (class 1259 OID 286825)
-- Name: sidx_PTAs_180725_merged_10_geom; Type: INDEX; Schema: public; Owner: edi_operator
--

CREATE INDEX "sidx_PTAs_180725_merged_10_geom" ON "public"."ParkingTariffAreas" USING "gist" ("geom");


--
-- TOC entry 4020 (class 1259 OID 286826)
-- Name: sidx_RoadCentreLine_geom; Type: INDEX; Schema: public; Owner: edi_operator
--

CREATE INDEX "sidx_RoadCentreLine_geom" ON "public"."RoadCentreLine" USING "gist" ("geom");


--
-- TOC entry 4015 (class 1259 OID 286827)
-- Name: sidx_restrictionPolygons_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_restrictionPolygons_geom" ON "public"."RestrictionPolygons" USING "gist" ("geom");


--
-- TOC entry 4055 (class 1259 OID 286828)
-- Name: signs_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "signs_geom_idx" ON "public"."signs" USING "gist" ("geom");


--
-- TOC entry 4058 (class 2606 OID 286829)
-- Name: Bays Bays_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Bays"
    ADD CONSTRAINT "Bays_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "public"."RestrictionShapeTypes"("Code");


--
-- TOC entry 4059 (class 2606 OID 286834)
-- Name: Bays Bays_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Bays"
    ADD CONSTRAINT "Bays_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "public"."BayLineTypesInUse"("Code");


--
-- TOC entry 4060 (class 2606 OID 286839)
-- Name: Bays Bays_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Bays"
    ADD CONSTRAINT "Bays_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "public"."TimePeriods"("Code");


--
-- TOC entry 4061 (class 2606 OID 286844)
-- Name: Lines Lines_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Lines"
    ADD CONSTRAINT "Lines_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "public"."RestrictionShapeTypes"("Code");


--
-- TOC entry 4062 (class 2606 OID 286849)
-- Name: Lines Lines_NoWaitingTimeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Lines"
    ADD CONSTRAINT "Lines_NoWaitingTimeID_fkey" FOREIGN KEY ("NoWaitingTimeID") REFERENCES "public"."TimePeriods"("Code");


--
-- TOC entry 4063 (class 2606 OID 286854)
-- Name: Lines Lines_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Lines"
    ADD CONSTRAINT "Lines_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "public"."BayLineTypesInUse"("Code");


--
-- TOC entry 4064 (class 2606 OID 286859)
-- Name: Proposals Proposals_ProposalStatusID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Proposals"
    ADD CONSTRAINT "Proposals_ProposalStatusID_fkey" FOREIGN KEY ("ProposalStatusID") REFERENCES "public"."ProposalStatusTypes"("Code");


--
-- TOC entry 4065 (class 2606 OID 286864)
-- Name: RestrictionsInProposals RestrictionsInProposals_ActionOnProposalAcceptance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ActionOnProposalAcceptance_fkey" FOREIGN KEY ("ActionOnProposalAcceptance") REFERENCES "public"."ActionOnProposalAcceptanceTypes"("id");


--
-- TOC entry 4066 (class 2606 OID 286869)
-- Name: RestrictionsInProposals RestrictionsInProposals_ProposalID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ProposalID_fkey" FOREIGN KEY ("ProposalID") REFERENCES "public"."Proposals"("ProposalID");


--
-- TOC entry 4067 (class 2606 OID 286874)
-- Name: RestrictionsInProposals RestrictionsInProposals_RestrictionTableID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_RestrictionTableID_fkey" FOREIGN KEY ("RestrictionTableID") REFERENCES "public"."RestrictionLayers"("id");


--
-- TOC entry 4202 (class 0 OID 286483)
-- Dependencies: 245
-- Name: Proposals; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE "public"."Proposals" ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4203 (class 3256 OID 286879)
-- Name: Proposals insertProposals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "insertProposals" ON "public"."Proposals" FOR INSERT TO "edi_operator" WITH CHECK (("ProposalStatusID" <> 2));


--
-- TOC entry 4204 (class 3256 OID 286880)
-- Name: Proposals insertProposals_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "insertProposals_admin" ON "public"."Proposals" FOR INSERT TO "edi_admin" WITH CHECK (("ProposalStatusID" <> 2));


--
-- TOC entry 4205 (class 3256 OID 286881)
-- Name: Proposals selectProposals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "selectProposals" ON "public"."Proposals" FOR SELECT USING (true);


--
-- TOC entry 4206 (class 3256 OID 286882)
-- Name: Proposals updateProposals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "updateProposals" ON "public"."Proposals" FOR UPDATE TO "edi_operator" USING (true) WITH CHECK (("ProposalStatusID" <> 2));


--
-- TOC entry 4207 (class 3256 OID 286883)
-- Name: Proposals updateProposals_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "updateProposals_admin" ON "public"."Proposals" FOR UPDATE TO "edi_admin" USING (true);


--
-- TOC entry 4300 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE "ActionOnProposalAcceptanceTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."ActionOnProposalAcceptanceTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."ActionOnProposalAcceptanceTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."ActionOnProposalAcceptanceTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."ActionOnProposalAcceptanceTypes" TO "edi_admin";


--
-- TOC entry 4302 (class 0 OID 0)
-- Dependencies: 212
-- Name: SEQUENCE "ActionOnProposalAcceptanceTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."ActionOnProposalAcceptanceTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."ActionOnProposalAcceptanceTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."ActionOnProposalAcceptanceTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."ActionOnProposalAcceptanceTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4303 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE "BayLineTypesInUse"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."BayLineTypesInUse" TO "edi_admin";
GRANT SELECT ON TABLE "public"."BayLineTypesInUse" TO "edi_operator";
GRANT SELECT ON TABLE "public"."BayLineTypesInUse" TO "edi_public";
GRANT SELECT ON TABLE "public"."BayLineTypesInUse" TO "edi_public_nsl";


--
-- TOC entry 4304 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE "BayLineTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."BayLineTypes" TO "edi_admin";
GRANT SELECT ON TABLE "public"."BayLineTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."BayLineTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."BayLineTypes" TO "edi_public_nsl";


--
-- TOC entry 4306 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE "BayLinesFadedTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."BayLinesFadedTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."BayLinesFadedTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."BayLinesFadedTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."BayLinesFadedTypes" TO "edi_admin";


--
-- TOC entry 4308 (class 0 OID 0)
-- Dependencies: 217
-- Name: SEQUENCE "BayLinesFadedTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."BayLinesFadedTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."BayLinesFadedTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."BayLinesFadedTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."BayLinesFadedTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4309 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE "BayTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."BayTypes" TO "edi_admin";
GRANT SELECT ON TABLE "public"."BayTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."BayTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."BayTypes" TO "edi_public_nsl";


--
-- TOC entry 4310 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE "Bays2_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."Bays2_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."Bays2_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."Bays2_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."Bays2_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4311 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE "Bays"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."Bays" TO "edi_operator";
GRANT SELECT ON TABLE "public"."Bays" TO "edi_public";
GRANT SELECT ON TABLE "public"."Bays" TO "edi_public_nsl";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."Bays" TO "edi_admin";


--
-- TOC entry 4312 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE "BaysLines_SignIssueTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."BaysLines_SignIssueTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."BaysLines_SignIssueTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."BaysLines_SignIssueTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."BaysLines_SignIssueTypes" TO "edi_admin";


--
-- TOC entry 4314 (class 0 OID 0)
-- Dependencies: 222
-- Name: SEQUENCE "BaysLines_SignIssueTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."BaysLines_SignIssueTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."BaysLines_SignIssueTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."BaysLines_SignIssueTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."BaysLines_SignIssueTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4315 (class 0 OID 0)
-- Dependencies: 223
-- Name: SEQUENCE "CECStatusTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."CECStatusTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."CECStatusTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."CECStatusTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."CECStatusTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4316 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE "CPZs"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."CPZs" TO "edi_public";
GRANT SELECT ON TABLE "public"."CPZs" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."CPZs" TO "edi_admin";


--
-- TOC entry 4317 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE "ControlledParkingZones"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."ControlledParkingZones" TO "edi_operator";
GRANT SELECT ON TABLE "public"."ControlledParkingZones" TO "edi_public";
GRANT SELECT ON TABLE "public"."ControlledParkingZones" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."ControlledParkingZones" TO "edi_admin";


--
-- TOC entry 4318 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE "Signs"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."Signs" TO "edi_operator";
GRANT SELECT ON TABLE "public"."Signs" TO "edi_public";
GRANT SELECT ON TABLE "public"."Signs" TO "edi_public_nsl";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."Signs" TO "edi_admin";


--
-- TOC entry 4320 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE "EDI01_Signs_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."EDI01_Signs_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."EDI01_Signs_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."EDI01_Signs_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."EDI01_Signs_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4321 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE "EDI_RoadCasement_Polyline"; Type: ACL; Schema: public; Owner: edi_operator
--

REVOKE ALL ON TABLE "public"."EDI_RoadCasement_Polyline" FROM "edi_operator";
GRANT SELECT ON TABLE "public"."EDI_RoadCasement_Polyline" TO "edi_public";
GRANT SELECT ON TABLE "public"."EDI_RoadCasement_Polyline" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."EDI_RoadCasement_Polyline" TO "edi_admin";


--
-- TOC entry 4322 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE "EDI_Sections"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."EDI_Sections" TO "edi_public";
GRANT SELECT ON TABLE "public"."EDI_Sections" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."EDI_Sections" TO "edi_admin";


--
-- TOC entry 4323 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE "LengthOfTime"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."LengthOfTime" TO "edi_operator";
GRANT SELECT ON TABLE "public"."LengthOfTime" TO "edi_public";
GRANT SELECT ON TABLE "public"."LengthOfTime" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."LengthOfTime" TO "edi_admin";


--
-- TOC entry 4325 (class 0 OID 0)
-- Dependencies: 231
-- Name: SEQUENCE "LengthOfTime_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."LengthOfTime_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."LengthOfTime_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."LengthOfTime_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."LengthOfTime_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4326 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE "LineTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."LineTypes" TO "edi_admin";
GRANT SELECT ON TABLE "public"."LineTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."LineTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."LineTypes" TO "edi_public_nsl";


--
-- TOC entry 4327 (class 0 OID 0)
-- Dependencies: 233
-- Name: SEQUENCE "Lines2_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."Lines2_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."Lines2_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."Lines2_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."Lines2_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4328 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE "Lines"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."Lines" TO "edi_operator";
GRANT SELECT ON TABLE "public"."Lines" TO "edi_public";
GRANT SELECT ON TABLE "public"."Lines" TO "edi_public_nsl";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."Lines" TO "edi_admin";


--
-- TOC entry 4329 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE "MapGrid"; Type: ACL; Schema: public; Owner: edi_operator
--

REVOKE ALL ON TABLE "public"."MapGrid" FROM "edi_operator";
GRANT SELECT ON TABLE "public"."MapGrid" TO "edi_operator";
GRANT SELECT ON TABLE "public"."MapGrid" TO "edi_public";
GRANT SELECT ON TABLE "public"."MapGrid" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."MapGrid" TO "edi_admin";


--
-- TOC entry 4330 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE "ParkingTariffAreas"; Type: ACL; Schema: public; Owner: edi_operator
--

REVOKE ALL ON TABLE "public"."ParkingTariffAreas" FROM "edi_operator";
GRANT SELECT ON TABLE "public"."ParkingTariffAreas" TO "edi_operator";
GRANT SELECT ON TABLE "public"."ParkingTariffAreas" TO "edi_public";
GRANT SELECT ON TABLE "public"."ParkingTariffAreas" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."ParkingTariffAreas" TO "edi_admin";


--
-- TOC entry 4332 (class 0 OID 0)
-- Dependencies: 239
-- Name: SEQUENCE "PTAs_180725_merged_10_id_seq"; Type: ACL; Schema: public; Owner: edi_operator
--

GRANT SELECT,USAGE ON SEQUENCE "public"."PTAs_180725_merged_10_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."PTAs_180725_merged_10_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."PTAs_180725_merged_10_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4333 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE "PaymentTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."PaymentTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."PaymentTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."PaymentTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."PaymentTypes" TO "edi_admin";


--
-- TOC entry 4335 (class 0 OID 0)
-- Dependencies: 241
-- Name: SEQUENCE "PaymentTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."PaymentTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."PaymentTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."PaymentTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."PaymentTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4336 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE "ProposalStatusTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."ProposalStatusTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."ProposalStatusTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."ProposalStatusTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."ProposalStatusTypes" TO "edi_admin";


--
-- TOC entry 4338 (class 0 OID 0)
-- Dependencies: 243
-- Name: SEQUENCE "ProposalStatusTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."ProposalStatusTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."ProposalStatusTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."ProposalStatusTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."ProposalStatusTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4339 (class 0 OID 0)
-- Dependencies: 244
-- Name: SEQUENCE "Proposals_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."Proposals_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."Proposals_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."Proposals_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."Proposals_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4340 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE "Proposals"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE "public"."Proposals" TO "edi_operator";
GRANT SELECT ON TABLE "public"."Proposals" TO "edi_public";
GRANT SELECT ON TABLE "public"."Proposals" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."Proposals" TO "edi_admin";


--
-- TOC entry 4341 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE "Proposals_withGeom"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."Proposals_withGeom" TO "edi_public";
GRANT SELECT ON TABLE "public"."Proposals_withGeom" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."Proposals_withGeom" TO "edi_admin";


--
-- TOC entry 4342 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE "RestrictionTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."RestrictionTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."RestrictionTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."RestrictionTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."RestrictionTypes" TO "edi_admin";


--
-- TOC entry 4343 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE "RestrictionsInProposals"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE ON TABLE "public"."RestrictionsInProposals" TO "edi_operator";
GRANT SELECT ON TABLE "public"."RestrictionsInProposals" TO "edi_public";
GRANT SELECT ON TABLE "public"."RestrictionsInProposals" TO "edi_public_nsl";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."RestrictionsInProposals" TO "edi_admin";


--
-- TOC entry 4344 (class 0 OID 0)
-- Dependencies: 249
-- Name: SEQUENCE "TimePeriods_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."TimePeriods_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."TimePeriods_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."TimePeriods_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."TimePeriods_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4345 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE "TimePeriods_orig"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."TimePeriods_orig" TO "edi_operator";
GRANT SELECT ON TABLE "public"."TimePeriods_orig" TO "edi_public";
GRANT SELECT ON TABLE "public"."TimePeriods_orig" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."TimePeriods_orig" TO "edi_admin";


--
-- TOC entry 4346 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE "Proposed Order Items"; Type: ACL; Schema: public; Owner: edi_admin
--

REVOKE ALL ON TABLE "public"."Proposed Order Items" FROM "edi_admin";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."Proposed Order Items" TO "edi_admin";


--
-- TOC entry 4347 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE "Proposed Order Restrictions List"; Type: ACL; Schema: public; Owner: edi_admin
--

REVOKE ALL ON TABLE "public"."Proposed Order Restrictions List" FROM "edi_admin";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."Proposed Order Restrictions List" TO "edi_admin";


--
-- TOC entry 4348 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE "RestrictionShapeTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."RestrictionShapeTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."RestrictionShapeTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."RestrictionShapeTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."RestrictionShapeTypes" TO "edi_admin";


--
-- TOC entry 4350 (class 0 OID 0)
-- Dependencies: 254
-- Name: SEQUENCE "RestrictionGeometryTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionGeometryTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionGeometryTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionGeometryTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionGeometryTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4351 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE "RestrictionLayers"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."RestrictionLayers" TO "edi_operator";
GRANT SELECT ON TABLE "public"."RestrictionLayers" TO "edi_public";
GRANT SELECT ON TABLE "public"."RestrictionLayers" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."RestrictionLayers" TO "edi_admin";


--
-- TOC entry 4353 (class 0 OID 0)
-- Dependencies: 256
-- Name: SEQUENCE "RestrictionLayers2_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionLayers2_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionLayers2_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionLayers2_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionLayers2_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4354 (class 0 OID 0)
-- Dependencies: 257
-- Name: SEQUENCE "RestrictionPolygonTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionPolygonTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionPolygonTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionPolygonTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionPolygonTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4355 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE "RestrictionPolygonTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."RestrictionPolygonTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."RestrictionPolygonTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."RestrictionPolygonTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."RestrictionPolygonTypes" TO "edi_admin";


--
-- TOC entry 4356 (class 0 OID 0)
-- Dependencies: 259
-- Name: SEQUENCE "restrictionPolygons_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."restrictionPolygons_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."restrictionPolygons_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."restrictionPolygons_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."restrictionPolygons_seq" TO "edi_public_nsl";


--
-- TOC entry 4357 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE "RestrictionPolygons"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."RestrictionPolygons" TO "edi_operator";
GRANT SELECT ON TABLE "public"."RestrictionPolygons" TO "edi_public";
GRANT SELECT ON TABLE "public"."RestrictionPolygons" TO "edi_public_nsl";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."RestrictionPolygons" TO "edi_admin";


--
-- TOC entry 4358 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE "RestrictionStatus"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."RestrictionStatus" TO "edi_operator";
GRANT SELECT ON TABLE "public"."RestrictionStatus" TO "edi_public";
GRANT SELECT ON TABLE "public"."RestrictionStatus" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."RestrictionStatus" TO "edi_admin";


--
-- TOC entry 4360 (class 0 OID 0)
-- Dependencies: 262
-- Name: SEQUENCE "RestrictionStatus_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionStatus_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionStatus_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionStatus_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionStatus_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4362 (class 0 OID 0)
-- Dependencies: 263
-- Name: SEQUENCE "RestrictionTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."RestrictionTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4363 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE "RoadCentreLine"; Type: ACL; Schema: public; Owner: edi_operator
--

REVOKE ALL ON TABLE "public"."RoadCentreLine" FROM "edi_operator";
GRANT SELECT ON TABLE "public"."RoadCentreLine" TO "edi_public";
GRANT SELECT ON TABLE "public"."RoadCentreLine" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."RoadCentreLine" TO "edi_admin";


--
-- TOC entry 4364 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE "SignAttachmentTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."SignAttachmentTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."SignAttachmentTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."SignAttachmentTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."SignAttachmentTypes" TO "edi_admin";


--
-- TOC entry 4365 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE "SignFadedTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."SignFadedTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."SignFadedTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."SignFadedTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."SignFadedTypes" TO "edi_admin";


--
-- TOC entry 4367 (class 0 OID 0)
-- Dependencies: 267
-- Name: SEQUENCE "SignFadedTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."SignFadedTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."SignFadedTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."SignFadedTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."SignFadedTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4368 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE "SignMountTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."SignMountTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."SignMountTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."SignMountTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."SignMountTypes" TO "edi_admin";


--
-- TOC entry 4370 (class 0 OID 0)
-- Dependencies: 269
-- Name: SEQUENCE "SignMounts_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."SignMounts_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."SignMounts_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."SignMounts_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."SignMounts_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4371 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE "SignObscurredTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."SignObscurredTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."SignObscurredTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."SignObscurredTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."SignObscurredTypes" TO "edi_admin";


--
-- TOC entry 4373 (class 0 OID 0)
-- Dependencies: 271
-- Name: SEQUENCE "SignObscurredTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."SignObscurredTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."SignObscurredTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."SignObscurredTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."SignObscurredTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4374 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE "SignTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."SignTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."SignTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."SignTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."SignTypes" TO "edi_admin";


--
-- TOC entry 4376 (class 0 OID 0)
-- Dependencies: 273
-- Name: SEQUENCE "SignTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."SignTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."SignTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."SignTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."SignTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4377 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE "Surveyors"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."Surveyors" TO "edi_operator";
GRANT SELECT ON TABLE "public"."Surveyors" TO "edi_public";
GRANT SELECT ON TABLE "public"."Surveyors" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."Surveyors" TO "edi_admin";


--
-- TOC entry 4379 (class 0 OID 0)
-- Dependencies: 275
-- Name: SEQUENCE "Surveyors_Code_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."Surveyors_Code_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."Surveyors_Code_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."Surveyors_Code_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."Surveyors_Code_seq" TO "edi_public_nsl";


--
-- TOC entry 4380 (class 0 OID 0)
-- Dependencies: 276
-- Name: SEQUENCE "TROStatusTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."TROStatusTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."TROStatusTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."TROStatusTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."TROStatusTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4381 (class 0 OID 0)
-- Dependencies: 277
-- Name: TABLE "TicketMachineIssueTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."TicketMachineIssueTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."TicketMachineIssueTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."TicketMachineIssueTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."TicketMachineIssueTypes" TO "edi_admin";


--
-- TOC entry 4383 (class 0 OID 0)
-- Dependencies: 278
-- Name: SEQUENCE "TicketMachineIssueTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."TicketMachineIssueTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."TicketMachineIssueTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."TicketMachineIssueTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."TicketMachineIssueTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4384 (class 0 OID 0)
-- Dependencies: 279
-- Name: TABLE "TilesInAcceptedProposals"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE "public"."TilesInAcceptedProposals" TO "edi_operator";
GRANT SELECT ON TABLE "public"."TilesInAcceptedProposals" TO "edi_public";
GRANT SELECT ON TABLE "public"."TilesInAcceptedProposals" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."TilesInAcceptedProposals" TO "edi_admin";


--
-- TOC entry 4385 (class 0 OID 0)
-- Dependencies: 280
-- Name: TABLE "TimePeriods"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."TimePeriods" TO "edi_operator";
GRANT SELECT ON TABLE "public"."TimePeriods" TO "edi_public";
GRANT SELECT ON TABLE "public"."TimePeriods" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."TimePeriods" TO "edi_admin";


--
-- TOC entry 4386 (class 0 OID 0)
-- Dependencies: 281
-- Name: TABLE "baysWordingTypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."baysWordingTypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."baysWordingTypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."baysWordingTypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."baysWordingTypes" TO "edi_admin";


--
-- TOC entry 4388 (class 0 OID 0)
-- Dependencies: 282
-- Name: SEQUENCE "baysWordingTypes_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."baysWordingTypes_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."baysWordingTypes_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."baysWordingTypes_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."baysWordingTypes_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4389 (class 0 OID 0)
-- Dependencies: 283
-- Name: TABLE "baytypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."baytypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."baytypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."baytypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."baytypes" TO "edi_admin";


--
-- TOC entry 4391 (class 0 OID 0)
-- Dependencies: 284
-- Name: SEQUENCE "baytypes_gid_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."baytypes_gid_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."baytypes_gid_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."baytypes_gid_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."baytypes_gid_seq" TO "edi_public_nsl";


--
-- TOC entry 4393 (class 0 OID 0)
-- Dependencies: 285
-- Name: SEQUENCE "controlledparkingzones_gid_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."controlledparkingzones_gid_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."controlledparkingzones_gid_seq" TO "edi_public_nsl";
GRANT SELECT,USAGE ON SEQUENCE "public"."controlledparkingzones_gid_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."controlledparkingzones_gid_seq" TO "edi_public";


--
-- TOC entry 4394 (class 0 OID 0)
-- Dependencies: 286
-- Name: SEQUENCE "corners_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."corners_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."corners_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."corners_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."corners_seq" TO "edi_public_nsl";


--
-- TOC entry 4395 (class 0 OID 0)
-- Dependencies: 287
-- Name: SEQUENCE "issueid_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."issueid_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."issueid_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."issueid_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."issueid_seq" TO "edi_public_nsl";


--
-- TOC entry 4396 (class 0 OID 0)
-- Dependencies: 288
-- Name: TABLE "layer_styles"; Type: ACL; Schema: public; Owner: edi_operator
--

REVOKE ALL ON TABLE "public"."layer_styles" FROM "edi_operator";
GRANT SELECT ON TABLE "public"."layer_styles" TO "edi_public";
GRANT SELECT ON TABLE "public"."layer_styles" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."layer_styles" TO "edi_admin";


--
-- TOC entry 4398 (class 0 OID 0)
-- Dependencies: 289
-- Name: SEQUENCE "layer_styles_id_seq"; Type: ACL; Schema: public; Owner: edi_operator
--

GRANT SELECT,USAGE ON SEQUENCE "public"."layer_styles_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."layer_styles_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."layer_styles_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4399 (class 0 OID 0)
-- Dependencies: 290
-- Name: TABLE "linetypes"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."linetypes" TO "edi_operator";
GRANT SELECT ON TABLE "public"."linetypes" TO "edi_public";
GRANT SELECT ON TABLE "public"."linetypes" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."linetypes" TO "edi_admin";


--
-- TOC entry 4401 (class 0 OID 0)
-- Dependencies: 291
-- Name: SEQUENCE "linetypes2_gid_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."linetypes2_gid_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."linetypes2_gid_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."linetypes2_gid_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."linetypes2_gid_seq" TO "edi_public_nsl";


--
-- TOC entry 4402 (class 0 OID 0)
-- Dependencies: 292
-- Name: SEQUENCE "pta_ref"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."pta_ref" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."pta_ref" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."pta_ref" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."pta_ref" TO "edi_public_nsl";


--
-- TOC entry 4403 (class 0 OID 0)
-- Dependencies: 293
-- Name: SEQUENCE "serial"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."serial" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."serial" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."serial" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."serial" TO "edi_public_nsl";


--
-- TOC entry 4405 (class 0 OID 0)
-- Dependencies: 294
-- Name: SEQUENCE "signAttachmentTypes2_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."signAttachmentTypes2_id_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."signAttachmentTypes2_id_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."signAttachmentTypes2_id_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."signAttachmentTypes2_id_seq" TO "edi_public_nsl";


--
-- TOC entry 4406 (class 0 OID 0)
-- Dependencies: 295
-- Name: TABLE "signs"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE "public"."signs" TO "edi_public";
GRANT SELECT ON TABLE "public"."signs" TO "edi_public_nsl";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."signs" TO "edi_admin";


--
-- TOC entry 4408 (class 0 OID 0)
-- Dependencies: 296
-- Name: SEQUENCE "signs_gid_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "public"."signs_gid_seq" TO "edi_admin";
GRANT SELECT,USAGE ON SEQUENCE "public"."signs_gid_seq" TO "edi_operator";
GRANT SELECT,USAGE ON SEQUENCE "public"."signs_gid_seq" TO "edi_public";
GRANT SELECT,USAGE ON SEQUENCE "public"."signs_gid_seq" TO "edi_public_nsl";


-- Completed on 2020-06-13 22:21:35

--
-- PostgreSQL database dump complete
--

