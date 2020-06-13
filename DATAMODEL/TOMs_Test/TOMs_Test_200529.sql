--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-05-29 22:54:56

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
-- TOC entry 11 (class 2615 OID 220898)
-- Name: addresses; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "addresses";


ALTER SCHEMA "addresses" OWNER TO "postgres";

--
-- TOC entry 20 (class 2615 OID 220899)
-- Name: compliance; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "compliance";


ALTER SCHEMA "compliance" OWNER TO "postgres";

--
-- TOC entry 14 (class 2615 OID 220900)
-- Name: compliance_lookups; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "compliance_lookups";


ALTER SCHEMA "compliance_lookups" OWNER TO "postgres";

CREATE SCHEMA "export";
ALTER SCHEMA "export" OWNER TO "postgres";

--
-- TOC entry 19 (class 2615 OID 220901)
-- Name: highways_network; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "highways_network";


ALTER SCHEMA "highways_network" OWNER TO "postgres";

--
-- TOC entry 15 (class 2615 OID 220902)
-- Name: local_authority; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "local_authority";


ALTER SCHEMA "local_authority" OWNER TO "postgres";

--
-- TOC entry 17 (class 2615 OID 220903)
-- Name: toms; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "toms";


ALTER SCHEMA "toms" OWNER TO "postgres";

--
-- TOC entry 13 (class 2615 OID 220904)
-- Name: toms_lookups; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "toms_lookups";


ALTER SCHEMA "toms_lookups" OWNER TO "postgres";

--
-- TOC entry 12 (class 2615 OID 220905)
-- Name: topography; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "topography";


ALTER SCHEMA "topography" OWNER TO "postgres";

--
-- TOC entry 9 (class 2615 OID 220906)
-- Name: transfer; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "transfer";


ALTER SCHEMA "transfer" OWNER TO "postgres";

--
-- TOC entry 1789 (class 2612 OID 220910)
-- Name: plpython3u; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE "plpython3u";


ALTER PROCEDURAL LANGUAGE "plpython3u" OWNER TO "postgres";

--
-- TOC entry 5 (class 3079 OID 220911)
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "dblink" WITH SCHEMA "public";


--
-- TOC entry 4 (class 3079 OID 220957)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "postgis" WITH SCHEMA "public";


--
-- TOC entry 3 (class 3079 OID 221959)
-- Name: postgres_fdw; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "postgres_fdw" WITH SCHEMA "public";


--
-- TOC entry 2 (class 3079 OID 221963)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "public";


--
-- TOC entry 1072 (class 1255 OID 221974)
-- Name: create_geometryid(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION "public"."create_geometryid"() RETURNS "trigger"
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
	ELSE
	    nextSeqVal = 'U';
	END CASE;

    NEW."GeometryID" := nextSeqVal;
	RETURN NEW;

END;
$$;


ALTER FUNCTION "public"."create_geometryid"() OWNER TO "postgres";

--
-- TOC entry 1073 (class 1255 OID 221975)
-- Name: set_last_update_details(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION "public"."set_last_update_details"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
    BEGIN
	    -- round to two decimal places
        NEW."LastUpdateDateTime" := now();
        NEW."LastUpdatePerson" := current_user;
		
        RETURN NEW;
    END;
$$;


ALTER FUNCTION "public"."set_last_update_details"() OWNER TO "postgres";

--
-- TOC entry 1074 (class 1255 OID 221976)
-- Name: set_restriction_length(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION "public"."set_restriction_length"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
    BEGIN
	    -- round to two decimal places
        NEW."RestrictionLength" := ROUND(ST_Length (NEW."geom")::numeric,2);

        RETURN NEW;
    END;
$$;


ALTER FUNCTION "public"."set_restriction_length"() OWNER TO "postgres";

SET default_table_access_method = "heap";

--
-- TOC entry 221 (class 1259 OID 221977)
-- Name: BaysLinesFadedTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."BaysLinesFadedTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."BaysLinesFadedTypes" OWNER TO "postgres";

--
-- TOC entry 222 (class 1259 OID 221983)
-- Name: BayLinesFadedTypes_Code_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."BayLinesFadedTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "compliance_lookups"."BayLinesFadedTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4500 (class 0 OID 0)
-- Dependencies: 222
-- Name: BayLinesFadedTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."BayLinesFadedTypes_Code_seq" OWNED BY "compliance_lookups"."BaysLinesFadedTypes"."Code";


--
-- TOC entry 223 (class 1259 OID 221985)
-- Name: BaysLines_SignIssueTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."BaysLines_SignIssueTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."BaysLines_SignIssueTypes" OWNER TO "postgres";

--
-- TOC entry 224 (class 1259 OID 221991)
-- Name: BaysLines_SignIssueTypes_Code_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."BaysLines_SignIssueTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "compliance_lookups"."BaysLines_SignIssueTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4501 (class 0 OID 0)
-- Dependencies: 224
-- Name: BaysLines_SignIssueTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."BaysLines_SignIssueTypes_Code_seq" OWNED BY "compliance_lookups"."BaysLines_SignIssueTypes"."Code";


--
-- TOC entry 225 (class 1259 OID 221993)
-- Name: ConditionTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."ConditionTypes" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "compliance_lookups"."ConditionTypes" OWNER TO "postgres";

--
-- TOC entry 226 (class 1259 OID 221996)
-- Name: ConditionTypes_Code_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."ConditionTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "compliance_lookups"."ConditionTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4502 (class 0 OID 0)
-- Dependencies: 226
-- Name: ConditionTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."ConditionTypes_Code_seq" OWNED BY "compliance_lookups"."ConditionTypes"."Code";


--
-- TOC entry 227 (class 1259 OID 221998)
-- Name: MHTC_CheckIssueType; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."MHTC_CheckIssueType" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."MHTC_CheckIssueType" OWNER TO "postgres";

--
-- TOC entry 228 (class 1259 OID 222004)
-- Name: MHTC_CheckIssueType_Code_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."MHTC_CheckIssueType_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "compliance_lookups"."MHTC_CheckIssueType_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4503 (class 0 OID 0)
-- Dependencies: 228
-- Name: MHTC_CheckIssueType_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."MHTC_CheckIssueType_Code_seq" OWNED BY "compliance_lookups"."MHTC_CheckIssueType"."Code";


--
-- TOC entry 229 (class 1259 OID 222006)
-- Name: MHTC_CheckStatus; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."MHTC_CheckStatus" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."MHTC_CheckStatus" OWNER TO "postgres";

--
-- TOC entry 230 (class 1259 OID 222012)
-- Name: MHTC_CheckStatus_Code_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."MHTC_CheckStatus_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "compliance_lookups"."MHTC_CheckStatus_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4504 (class 0 OID 0)
-- Dependencies: 230
-- Name: MHTC_CheckStatus_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."MHTC_CheckStatus_Code_seq" OWNED BY "compliance_lookups"."MHTC_CheckStatus"."Code";


--
-- TOC entry 231 (class 1259 OID 222014)
-- Name: SignAttachmentTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignAttachmentTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignAttachmentTypes" OWNER TO "postgres";

--
-- TOC entry 232 (class 1259 OID 222020)
-- Name: SignConditionTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignConditionTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignConditionTypes" OWNER TO "postgres";

--
-- TOC entry 233 (class 1259 OID 222026)
-- Name: SignConditionTypes_Code_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."SignConditionTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "compliance_lookups"."SignConditionTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4505 (class 0 OID 0)
-- Dependencies: 233
-- Name: SignConditionTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignConditionTypes_Code_seq" OWNED BY "compliance_lookups"."SignConditionTypes"."Code";


--
-- TOC entry 234 (class 1259 OID 222028)
-- Name: SignFadedTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignFadedTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignFadedTypes" OWNER TO "postgres";

--
-- TOC entry 235 (class 1259 OID 222034)
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."SignFadedTypes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "compliance_lookups"."SignFadedTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4506 (class 0 OID 0)
-- Dependencies: 235
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignFadedTypes_id_seq" OWNED BY "compliance_lookups"."SignFadedTypes"."id";


--
-- TOC entry 236 (class 1259 OID 222036)
-- Name: SignIlluminationTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignIlluminationTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignIlluminationTypes" OWNER TO "postgres";

--
-- TOC entry 237 (class 1259 OID 222042)
-- Name: SignIlluminationTypes_Code_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."SignIlluminationTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "compliance_lookups"."SignIlluminationTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4507 (class 0 OID 0)
-- Dependencies: 237
-- Name: SignIlluminationTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignIlluminationTypes_Code_seq" OWNED BY "compliance_lookups"."SignIlluminationTypes"."Code";


--
-- TOC entry 238 (class 1259 OID 222044)
-- Name: SignMountTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignMountTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignMountTypes" OWNER TO "postgres";

--
-- TOC entry 239 (class 1259 OID 222050)
-- Name: SignMountTypes_id_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."SignMountTypes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "compliance_lookups"."SignMountTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4508 (class 0 OID 0)
-- Dependencies: 239
-- Name: SignMountTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignMountTypes_id_seq" OWNED BY "compliance_lookups"."SignMountTypes"."id";


--
-- TOC entry 240 (class 1259 OID 222052)
-- Name: SignObscurredTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignObscurredTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignObscurredTypes" OWNER TO "postgres";

--
-- TOC entry 241 (class 1259 OID 222058)
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."SignObscurredTypes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "compliance_lookups"."SignObscurredTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4509 (class 0 OID 0)
-- Dependencies: 241
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignObscurredTypes_id_seq" OWNED BY "compliance_lookups"."SignObscurredTypes"."id";


--
-- TOC entry 242 (class 1259 OID 222060)
-- Name: TicketMachineIssueTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."TicketMachineIssueTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."TicketMachineIssueTypes" OWNER TO "postgres";

--
-- TOC entry 243 (class 1259 OID 222066)
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."TicketMachineIssueTypes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "compliance_lookups"."TicketMachineIssueTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4510 (class 0 OID 0)
-- Dependencies: 243
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."TicketMachineIssueTypes_id_seq" OWNED BY "compliance_lookups"."TicketMachineIssueTypes"."id";


--
-- TOC entry 244 (class 1259 OID 222068)
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."signAttachmentTypes2_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "compliance_lookups"."signAttachmentTypes2_id_seq" OWNER TO "postgres";

--
-- TOC entry 4511 (class 0 OID 0)
-- Dependencies: 244
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."signAttachmentTypes2_id_seq" OWNED BY "compliance_lookups"."SignAttachmentTypes"."id";


--
-- TOC entry 245 (class 1259 OID 222070)
-- Name: itn_roadcentreline; Type: TABLE; Schema: highways_network; Owner: postgres
--

CREATE TABLE "highways_network"."itn_roadcentreline" (
    "gid" integer NOT NULL,
    "toid" character varying(16),
    "version" numeric(10,0),
    "verdate" "date",
    "theme" character varying(80),
    "descgroup" character varying(150),
    "descterm" character varying(150),
    "change" character varying(80),
    "topoarea" character varying(20),
    "nature" character varying(80),
    "lnklength" numeric,
    "node1" character varying(20),
    "node1grade" character varying(1),
    "node1gra_1" numeric(10,0),
    "node2" character varying(20),
    "node2grade" character varying(1),
    "node2gra_1" numeric(10,0),
    "loaddate" "date",
    "objectid" numeric(10,0),
    "shape_leng" numeric,
    "geom" "public"."geometry"(MultiLineString,27700)
);


ALTER TABLE "highways_network"."itn_roadcentreline" OWNER TO "postgres";

--
-- TOC entry 246 (class 1259 OID 222076)
-- Name: edi_itn_roadcentreline_gid_seq; Type: SEQUENCE; Schema: highways_network; Owner: postgres
--

CREATE SEQUENCE "highways_network"."edi_itn_roadcentreline_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highways_network"."edi_itn_roadcentreline_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4512 (class 0 OID 0)
-- Dependencies: 246
-- Name: edi_itn_roadcentreline_gid_seq; Type: SEQUENCE OWNED BY; Schema: highways_network; Owner: postgres
--

ALTER SEQUENCE "highways_network"."edi_itn_roadcentreline_gid_seq" OWNED BY "highways_network"."itn_roadcentreline"."gid";


--
-- TOC entry 247 (class 1259 OID 222078)
-- Name: SiteArea; Type: TABLE; Schema: local_authority; Owner: postgres
--

CREATE TABLE "local_authority"."SiteArea" (
    "id" integer NOT NULL,
    "name" character varying(32),
    "geom" "public"."geometry"(MultiPolygon,27700)
);


ALTER TABLE "local_authority"."SiteArea" OWNER TO "postgres";

--
-- TOC entry 248 (class 1259 OID 222084)
-- Name: SiteArea_id_seq; Type: SEQUENCE; Schema: local_authority; Owner: postgres
--

CREATE SEQUENCE "local_authority"."SiteArea_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "local_authority"."SiteArea_id_seq" OWNER TO "postgres";

--
-- TOC entry 4513 (class 0 OID 0)
-- Dependencies: 248
-- Name: SiteArea_id_seq; Type: SEQUENCE OWNED BY; Schema: local_authority; Owner: postgres
--

ALTER SEQUENCE "local_authority"."SiteArea_id_seq" OWNED BY "local_authority"."SiteArea"."id";


--
-- TOC entry 249 (class 1259 OID 222086)
-- Name: StreetGazetteerRecords; Type: TABLE; Schema: local_authority; Owner: postgres
--

CREATE TABLE "local_authority"."StreetGazetteerRecords" (
    "id" integer NOT NULL,
    "ESUID" numeric,
    "USRN" numeric(10,0),
    "Custodian" numeric(10,0),
    "RoadName" character varying(254),
    "Locality" character varying(254),
    "Town" character varying(254),
    "Language" character varying(254),
    "StreetLength" numeric,
    "geom" "public"."geometry"(MultiLineString,27700)
);


ALTER TABLE "local_authority"."StreetGazetteerRecords" OWNER TO "postgres";

--
-- TOC entry 250 (class 1259 OID 222092)
-- Name: StreetGazetteerRecords_id_seq; Type: SEQUENCE; Schema: local_authority; Owner: postgres
--

CREATE SEQUENCE "local_authority"."StreetGazetteerRecords_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "local_authority"."StreetGazetteerRecords_id_seq" OWNER TO "postgres";

--
-- TOC entry 4514 (class 0 OID 0)
-- Dependencies: 250
-- Name: StreetGazetteerRecords_id_seq; Type: SEQUENCE OWNED BY; Schema: local_authority; Owner: postgres
--

ALTER SEQUENCE "local_authority"."StreetGazetteerRecords_id_seq" OWNED BY "local_authority"."StreetGazetteerRecords"."id";


--
-- TOC entry 251 (class 1259 OID 222094)
-- Name: RC_Polyline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RC_Polyline" (
    "geom" "public"."geometry",
    "id" integer NOT NULL
);


ALTER TABLE "public"."RC_Polyline" OWNER TO "postgres";

--
-- TOC entry 252 (class 1259 OID 222100)
-- Name: RC_Polyline_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RC_Polyline_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RC_Polyline_id_seq" OWNER TO "postgres";

--
-- TOC entry 4515 (class 0 OID 0)
-- Dependencies: 252
-- Name: RC_Polyline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RC_Polyline_id_seq" OWNED BY "public"."RC_Polyline"."id";


--
-- TOC entry 253 (class 1259 OID 222102)
-- Name: RC_Sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RC_Sections" (
    "gid" integer NOT NULL,
    "geom" "public"."geometry"(LineString,27700),
    "RoadName" character varying(100),
    "Az" double precision,
    "StartStreet" character varying(254),
    "EndStreet" character varying(254),
    "SideOfStreet" character varying(100)
);


ALTER TABLE "public"."RC_Sections" OWNER TO "postgres";

--
-- TOC entry 254 (class 1259 OID 222108)
-- Name: RC_Sections_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RC_Sections_gid_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RC_Sections_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4516 (class 0 OID 0)
-- Dependencies: 254
-- Name: RC_Sections_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RC_Sections_gid_seq" OWNED BY "public"."RC_Sections"."gid";


--
-- TOC entry 255 (class 1259 OID 222110)
-- Name: RC_Sections_merged; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RC_Sections_merged" (
    "gid" integer NOT NULL,
    "geom" "public"."geometry"(LineString,27700),
    "RoadName" character varying(100),
    "Az" double precision,
    "StartStreet" character varying(254),
    "EndStreet" character varying(254),
    "SideOfStreet" character varying(100),
    "ESUID" double precision,
    "USRN" integer,
    "Locality" character varying(255),
    "Town" character varying(255)
);


ALTER TABLE "public"."RC_Sections_merged" OWNER TO "postgres";

--
-- TOC entry 256 (class 1259 OID 222116)
-- Name: RC_Sections_merged_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RC_Sections_merged_gid_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RC_Sections_merged_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4517 (class 0 OID 0)
-- Dependencies: 256
-- Name: RC_Sections_merged_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RC_Sections_merged_gid_seq" OWNED BY "public"."RC_Sections_merged"."gid";


--
-- TOC entry 257 (class 1259 OID 222118)
-- Name: Bays_id_seq; Type: SEQUENCE; Schema: toms; Owner: postgres
--

CREATE SEQUENCE "toms"."Bays_id_seq"
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms"."Bays_id_seq" OWNER TO "postgres";

--
-- TOC entry 258 (class 1259 OID 222120)
-- Name: Bays; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."Bays" (
    "RestrictionID" character varying(254) NOT NULL,
    "GeometryID" character varying(12) DEFAULT ('B_'::"text" || "to_char"("nextval"('"toms"."Bays_id_seq"'::"regclass"), '000000000'::"text")) NOT NULL,
    "geom" "public"."geometry"(LineString,27700) NOT NULL,
    "RestrictionLength" double precision NOT NULL,
    "RestrictionTypeID" integer NOT NULL,
    "GeomShapeID" integer NOT NULL,
    "AzimuthToRoadCentreLine" double precision,
    "Notes" character varying(254),
    "Photos_01" character varying(255),
    "Photos_02" character varying(255),
    "Photos_03" character varying(255),
    "RoadName" character varying(254),
    "USRN" character varying(254),
    "label_X" double precision,
    "label_Y" double precision,
    "label_Rotation" double precision,
    "label_TextChanged" character varying(254),
    "OpenDate" "date",
    "CloseDate" "date",
    "CPZ" character varying(40),
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) NOT NULL,
    "BayOrientation" double precision,
    "NrBays" integer DEFAULT '-1'::integer NOT NULL,
    "TimePeriodID" integer NOT NULL,
    "PayTypeID" integer,
    "MaxStayID" integer,
    "NoReturnID" integer,
    "ParkingTariffArea" character varying(10),
    "AdditionalConditionID" integer,
    "ComplianceRoadMarkingsFaded" integer,
    "ComplianceRestrictionSignIssue" integer,
    "ComplianceNotes" character varying(254),
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254)
);


ALTER TABLE "toms"."Bays" OWNER TO "postgres";

--
-- TOC entry 259 (class 1259 OID 222128)
-- Name: ControlledParkingZones_id_seq; Type: SEQUENCE; Schema: toms; Owner: postgres
--

CREATE SEQUENCE "toms"."ControlledParkingZones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms"."ControlledParkingZones_id_seq" OWNER TO "postgres";

--
-- TOC entry 260 (class 1259 OID 222130)
-- Name: ControlledParkingZones; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."ControlledParkingZones" (
    "RestrictionID" character varying(254) NOT NULL,
    "GeometryID" character varying(12) DEFAULT ('C_'::"text" || "to_char"("nextval"('"toms"."ControlledParkingZones_id_seq"'::"regclass"), '000000000'::"text")) NOT NULL,
    "geom" "public"."geometry"(Polygon,27700) NOT NULL,
    "RestrictionTypeID" integer NOT NULL,
    "Notes" character varying(254),
    "Photos_01" character varying(255),
    "Photos_02" character varying(255),
    "Photos_03" character varying(255),
    "label_X" double precision,
    "label_Y" double precision,
    "label_Rotation" double precision,
    "label_TextChanged" character varying(254),
    "OpenDate" "date",
    "CloseDate" "date",
    "CPZ" character varying(40),
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) NOT NULL,
    "LabelText" character varying(254),
    "TimePeriodID" integer,
    "ComplianceRoadMarkingsFaded" integer,
    "ComplianceRestrictionSignIssue" integer,
    "ComplianceNotes" character varying(254),
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254)
);


ALTER TABLE "toms"."ControlledParkingZones" OWNER TO "postgres";

--
-- TOC entry 261 (class 1259 OID 222137)
-- Name: Lines_id_seq; Type: SEQUENCE; Schema: toms; Owner: postgres
--

CREATE SEQUENCE "toms"."Lines_id_seq"
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms"."Lines_id_seq" OWNER TO "postgres";

--
-- TOC entry 262 (class 1259 OID 222139)
-- Name: Lines; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."Lines" (
    "RestrictionID" character varying(254) NOT NULL,
    "GeometryID" character varying(12) DEFAULT ('L_'::"text" || "to_char"("nextval"('"toms"."Lines_id_seq"'::"regclass"), '000000000'::"text")) NOT NULL,
    "geom" "public"."geometry"(LineString,27700) NOT NULL,
    "RestrictionLength" double precision NOT NULL,
    "RestrictionTypeID" integer NOT NULL,
    "GeomShapeID" integer NOT NULL,
    "AzimuthToRoadCentreLine" double precision,
    "Notes" character varying(254),
    "Photos_01" character varying(255),
    "Photos_02" character varying(255),
    "Photos_03" character varying(255),
    "RoadName" character varying(254),
    "USRN" character varying(254),
    "label_X" double precision,
    "label_Y" double precision,
    "label_Rotation" double precision,
    "label_TextChanged" character varying(254),
    "OpenDate" "date",
    "CloseDate" "date",
    "CPZ" character varying(40),
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) NOT NULL,
    "NoWaitingTimeID" integer,
    "NoLoadingTimeID" integer,
    "UnacceptableTypeID" integer,
    "AdditionalConditionID" integer,
    "ParkingTariffArea" character varying(10),
    "labelLoading_X" double precision,
    "labelLoading_Y" double precision,
    "labelLoading_Rotation" double precision,
    "ComplianceRoadMarkingsFaded" integer,
    "ComplianceRestrictionSignIssue" integer,
    "ComplianceNotes" character varying(254),
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254)
);


ALTER TABLE "toms"."Lines" OWNER TO "postgres";

--
-- TOC entry 263 (class 1259 OID 222146)
-- Name: MapGrid; Type: TABLE; Schema: toms; Owner: toms_operator
--

CREATE TABLE "toms"."MapGrid" (
    "id" bigint NOT NULL,
    "geom" "public"."geometry"(MultiPolygon,27700),
    "mapsheetname" character varying(10),
    "x_min" double precision,
    "x_max" double precision,
    "y_min" double precision,
    "y_max" double precision,
    "CurrRevisionNr" integer,
    "LastRevisionDate" "date"
);


ALTER TABLE "toms"."MapGrid" OWNER TO "toms_operator";

--
-- TOC entry 264 (class 1259 OID 222152)
-- Name: ParkingTariffAreas_id_seq; Type: SEQUENCE; Schema: toms; Owner: postgres
--

CREATE SEQUENCE "toms"."ParkingTariffAreas_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms"."ParkingTariffAreas_id_seq" OWNER TO "postgres";

--
-- TOC entry 265 (class 1259 OID 222154)
-- Name: ParkingTariffAreas; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."ParkingTariffAreas" (
    "RestrictionID" character varying(254) NOT NULL,
    "GeometryID" character varying(12) DEFAULT ('T_'::"text" || "to_char"("nextval"('"toms"."ParkingTariffAreas_id_seq"'::"regclass"), '000000000'::"text")) NOT NULL,
    "geom" "public"."geometry"(Polygon,27700) NOT NULL,
    "RestrictionTypeID" integer NOT NULL,
    "Notes" character varying(254),
    "Photos_01" character varying(255),
    "Photos_02" character varying(255),
    "Photos_03" character varying(255),
    "label_X" double precision,
    "label_Y" double precision,
    "label_Rotation" double precision,
    "label_TextChanged" character varying(254),
    "OpenDate" "date",
    "CloseDate" "date",
    "ParkingTariffArea" character varying(40),
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) NOT NULL,
    "LabelText" character varying(254),
    "TimePeriodID" integer,
    "NoReturnID" integer,
    "MaxStayID" integer,
    "ComplianceRoadMarkingsFaded" integer,
    "ComplianceRestrictionSignIssue" integer,
    "ComplianceNotes" character varying(254),
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254)
);


ALTER TABLE "toms"."ParkingTariffAreas" OWNER TO "postgres";

--
-- TOC entry 266 (class 1259 OID 222161)
-- Name: Proposals_id_seq; Type: SEQUENCE; Schema: toms; Owner: postgres
--

CREATE SEQUENCE "toms"."Proposals_id_seq"
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms"."Proposals_id_seq" OWNER TO "postgres";

--
-- TOC entry 267 (class 1259 OID 222163)
-- Name: Proposals; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."Proposals" (
    "ProposalID" integer DEFAULT "nextval"('"toms"."Proposals_id_seq"'::"regclass") NOT NULL,
    "ProposalStatusID" integer NOT NULL,
    "ProposalCreateDate" "date" NOT NULL,
    "ProposalNotes" character varying,
    "ProposalTitle" character varying(255) NOT NULL,
    "ProposalOpenDate" "date"
);


ALTER TABLE "toms"."Proposals" OWNER TO "postgres";

--
-- TOC entry 268 (class 1259 OID 222170)
-- Name: RestrictionLayers; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."RestrictionLayers" (
    "Code" integer NOT NULL,
    "RestrictionLayerName" character varying(255) NOT NULL
);


ALTER TABLE "toms"."RestrictionLayers" OWNER TO "postgres";

--
-- TOC entry 269 (class 1259 OID 222173)
-- Name: RestrictionLayers_id_seq; Type: SEQUENCE; Schema: toms; Owner: postgres
--

CREATE SEQUENCE "toms"."RestrictionLayers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms"."RestrictionLayers_id_seq" OWNER TO "postgres";

--
-- TOC entry 4518 (class 0 OID 0)
-- Dependencies: 269
-- Name: RestrictionLayers_id_seq; Type: SEQUENCE OWNED BY; Schema: toms; Owner: postgres
--

ALTER SEQUENCE "toms"."RestrictionLayers_id_seq" OWNED BY "toms"."RestrictionLayers"."Code";


--
-- TOC entry 270 (class 1259 OID 222175)
-- Name: RestrictionPolygons_id_seq; Type: SEQUENCE; Schema: toms; Owner: postgres
--

CREATE SEQUENCE "toms"."RestrictionPolygons_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms"."RestrictionPolygons_id_seq" OWNER TO "postgres";

--
-- TOC entry 271 (class 1259 OID 222177)
-- Name: RestrictionPolygons; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."RestrictionPolygons" (
    "RestrictionID" character varying(254) NOT NULL,
    "GeometryID" character varying(12) DEFAULT ('P_'::"text" || "to_char"("nextval"('"toms"."RestrictionPolygons_id_seq"'::"regclass"), '000000000'::"text")) NOT NULL,
    "geom" "public"."geometry"(Polygon,27700) NOT NULL,
    "RestrictionTypeID" integer NOT NULL,
    "GeomShapeID" integer NOT NULL,
    "Notes" character varying(254),
    "Photos_01" character varying(255),
    "Photos_02" character varying(255),
    "Photos_03" character varying(255),
    "RoadName" character varying(254),
    "USRN" character varying(254),
    "label_X" double precision,
    "label_Y" double precision,
    "label_Rotation" double precision,
    "label_TextChanged" character varying(254),
    "OpenDate" "date",
    "CloseDate" "date",
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) NOT NULL,
    "Orientation" integer,
    "LabelText" character varying(254),
    "NoWaitingTimeID" integer,
    "NoLoadingTimeID" integer,
    "TimePeriodID" integer,
    "AreaPermitCode" character varying(254),
    "CPZ" character varying(40),
    "ComplianceRoadMarkingsFaded" integer,
    "ComplianceRestrictionSignIssue" integer,
    "ComplianceNotes" character varying(254),
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254)
);


ALTER TABLE "toms"."RestrictionPolygons" OWNER TO "postgres";

--
-- TOC entry 272 (class 1259 OID 222184)
-- Name: RestrictionsInProposals; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."RestrictionsInProposals" (
    "ProposalID" integer NOT NULL,
    "RestrictionTableID" integer NOT NULL,
    "ActionOnProposalAcceptance" integer,
    "RestrictionID" character varying(255) NOT NULL
);


ALTER TABLE "toms"."RestrictionsInProposals" OWNER TO "postgres";

--
-- TOC entry 273 (class 1259 OID 222187)
-- Name: Signs_id_seq; Type: SEQUENCE; Schema: toms; Owner: postgres
--

CREATE SEQUENCE "toms"."Signs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms"."Signs_id_seq" OWNER TO "postgres";

--
-- TOC entry 274 (class 1259 OID 222189)
-- Name: Signs; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."Signs" (
    "RestrictionID" character varying(254) NOT NULL,
    "GeometryID" character varying(12) DEFAULT ('S_'::"text" || "to_char"("nextval"('"toms"."Signs_id_seq"'::"regclass"), '000000000'::"text")) NOT NULL,
    "geom" "public"."geometry"(Point,27700) NOT NULL,
    "Photos_01" character varying(255),
    "Photos_02" character varying(255),
    "Photos_03" character varying(255),
    "Notes" character varying(255),
    "RoadName" character varying(254),
    "USRN" character varying(254),
    "OpenDate" "date",
    "CloseDate" "date",
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) NOT NULL,
    "SignType_1" integer,
    "SignType_2" integer,
    "SignType_3" integer,
    "SignType_4" integer,
    "Photos_04" character varying(255),
    "SignOrientationTypeID" integer,
    "Signs_Mount" integer,
    "Signs_Attachment" integer,
    "Compl_Signs_Faded" integer,
    "Compl_Signs_Obscured" integer,
    "Compl_Sign_Direction" integer,
    "Compl_Signs_Obsolete" integer,
    "Compl_Signs_OtherOptions" integer,
    "Compl_Signs_TicketMachines" integer,
    "TicketMachine_Nr" character varying(10),
    "RingoPresent" integer,
    "SignIlluminationTypeID" integer,
    "SignConditionTypeID" integer,
    "ComplianceRestrictionSignIssue" integer,
    "ComplianceNotes" character varying(254),
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254),
    "SignAddress" character varying(255),
    "original_geom_wkt" character varying(255)
);


ALTER TABLE "toms"."Signs" OWNER TO "postgres";

--
-- TOC entry 275 (class 1259 OID 222196)
-- Name: TilesInAcceptedProposals; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."TilesInAcceptedProposals" (
    "ProposalID" integer NOT NULL,
    "TileNr" integer NOT NULL,
    "RevisionNr" integer NOT NULL
);


ALTER TABLE "toms"."TilesInAcceptedProposals" OWNER TO "postgres";

--
-- TOC entry 276 (class 1259 OID 222199)
-- Name: ActionOnProposalAcceptanceTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."ActionOnProposalAcceptanceTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."ActionOnProposalAcceptanceTypes" OWNER TO "postgres";

--
-- TOC entry 277 (class 1259 OID 222205)
-- Name: ActionOnProposalAcceptanceTypes_Code_seq; Type: SEQUENCE; Schema: toms_lookups; Owner: postgres
--

CREATE SEQUENCE "toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4519 (class 0 OID 0)
-- Dependencies: 277
-- Name: ActionOnProposalAcceptanceTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq" OWNED BY "toms_lookups"."ActionOnProposalAcceptanceTypes"."Code";


--
-- TOC entry 278 (class 1259 OID 222207)
-- Name: AdditionalConditionTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."AdditionalConditionTypes" (
    "Code" integer NOT NULL,
    "Description" character varying(255) NOT NULL
);


ALTER TABLE "toms_lookups"."AdditionalConditionTypes" OWNER TO "postgres";

--
-- TOC entry 279 (class 1259 OID 222210)
-- Name: AdditionalConditionTypes_Code_seq; Type: SEQUENCE; Schema: toms_lookups; Owner: postgres
--

CREATE SEQUENCE "toms_lookups"."AdditionalConditionTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms_lookups"."AdditionalConditionTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4520 (class 0 OID 0)
-- Dependencies: 279
-- Name: AdditionalConditionTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."AdditionalConditionTypes_Code_seq" OWNED BY "toms_lookups"."AdditionalConditionTypes"."Code";


--
-- TOC entry 280 (class 1259 OID 222212)
-- Name: BayLineTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."BayLineTypes" (
    "Code" integer NOT NULL,
    "Description" character varying(255) NOT NULL
);


ALTER TABLE "toms_lookups"."BayLineTypes" OWNER TO "postgres";

--
-- TOC entry 281 (class 1259 OID 222215)
-- Name: BayLineTypes_Code_seq; Type: SEQUENCE; Schema: toms_lookups; Owner: postgres
--

CREATE SEQUENCE "toms_lookups"."BayLineTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms_lookups"."BayLineTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4521 (class 0 OID 0)
-- Dependencies: 281
-- Name: BayLineTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."BayLineTypes_Code_seq" OWNED BY "toms_lookups"."BayLineTypes"."Code";


--
-- TOC entry 282 (class 1259 OID 222217)
-- Name: BayTypesInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."BayTypesInUse" (
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) NOT NULL,
    "StyleDetails" character varying
);


ALTER TABLE "toms_lookups"."BayTypesInUse" OWNER TO "postgres";

--
-- TOC entry 283 (class 1259 OID 222223)
-- Name: BayTypesInUse_View; Type: MATERIALIZED VIEW; Schema: toms_lookups; Owner: postgres
--

CREATE MATERIALIZED VIEW "toms_lookups"."BayTypesInUse_View" AS
 SELECT "BayTypesInUse"."Code",
    "BayLineTypes"."Description"
   FROM "toms_lookups"."BayTypesInUse",
    "toms_lookups"."BayLineTypes"
  WHERE (("BayTypesInUse"."Code" = "BayLineTypes"."Code") AND ("BayTypesInUse"."Code" < 200))
  WITH NO DATA;


ALTER TABLE "toms_lookups"."BayTypesInUse_View" OWNER TO "postgres";

--
-- TOC entry 284 (class 1259 OID 222227)
-- Name: GeomShapeGroupType; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."GeomShapeGroupType" (
    "Code" character varying(255) NOT NULL
);


ALTER TABLE "toms_lookups"."GeomShapeGroupType" OWNER TO "postgres";

--
-- TOC entry 285 (class 1259 OID 222230)
-- Name: LengthOfTime; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."LengthOfTime" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL,
    "LabelText" character varying(255)
);


ALTER TABLE "toms_lookups"."LengthOfTime" OWNER TO "postgres";

--
-- TOC entry 286 (class 1259 OID 222236)
-- Name: LengthOfTime_Code_seq; Type: SEQUENCE; Schema: toms_lookups; Owner: postgres
--

CREATE SEQUENCE "toms_lookups"."LengthOfTime_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms_lookups"."LengthOfTime_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4522 (class 0 OID 0)
-- Dependencies: 286
-- Name: LengthOfTime_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."LengthOfTime_Code_seq" OWNED BY "toms_lookups"."LengthOfTime"."Code";


--
-- TOC entry 287 (class 1259 OID 222238)
-- Name: LineTypesInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."LineTypesInUse" (
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) NOT NULL,
    "StyleDetails" character varying
);


ALTER TABLE "toms_lookups"."LineTypesInUse" OWNER TO "postgres";

--
-- TOC entry 288 (class 1259 OID 222244)
-- Name: LineTypesInUse_View; Type: MATERIALIZED VIEW; Schema: toms_lookups; Owner: postgres
--

CREATE MATERIALIZED VIEW "toms_lookups"."LineTypesInUse_View" AS
 SELECT "LineTypesInUse"."Code",
    "BayLineTypes"."Description"
   FROM "toms_lookups"."LineTypesInUse",
    "toms_lookups"."BayLineTypes"
  WHERE (("LineTypesInUse"."Code" = "BayLineTypes"."Code") AND ("LineTypesInUse"."Code" > 200))
  WITH NO DATA;


ALTER TABLE "toms_lookups"."LineTypesInUse_View" OWNER TO "postgres";

--
-- TOC entry 289 (class 1259 OID 222248)
-- Name: PaymentTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."PaymentTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."PaymentTypes" OWNER TO "postgres";

--
-- TOC entry 290 (class 1259 OID 222254)
-- Name: PaymentTypes_Code_seq; Type: SEQUENCE; Schema: toms_lookups; Owner: postgres
--

CREATE SEQUENCE "toms_lookups"."PaymentTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms_lookups"."PaymentTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4523 (class 0 OID 0)
-- Dependencies: 290
-- Name: PaymentTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."PaymentTypes_Code_seq" OWNED BY "toms_lookups"."PaymentTypes"."Code";


--
-- TOC entry 291 (class 1259 OID 222256)
-- Name: ProposalStatusTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."ProposalStatusTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."ProposalStatusTypes" OWNER TO "postgres";

--
-- TOC entry 292 (class 1259 OID 222262)
-- Name: ProposalStatusTypes_Code_seq; Type: SEQUENCE; Schema: toms_lookups; Owner: postgres
--

CREATE SEQUENCE "toms_lookups"."ProposalStatusTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms_lookups"."ProposalStatusTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4524 (class 0 OID 0)
-- Dependencies: 292
-- Name: ProposalStatusTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."ProposalStatusTypes_Code_seq" OWNED BY "toms_lookups"."ProposalStatusTypes"."Code";


--
-- TOC entry 293 (class 1259 OID 222264)
-- Name: RestrictionGeomShapeTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."RestrictionGeomShapeTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."RestrictionGeomShapeTypes" OWNER TO "postgres";

--
-- TOC entry 294 (class 1259 OID 222270)
-- Name: RestrictionPolygonTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."RestrictionPolygonTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."RestrictionPolygonTypes" OWNER TO "postgres";

--
-- TOC entry 295 (class 1259 OID 222276)
-- Name: RestrictionPolygonTypesInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."RestrictionPolygonTypesInUse" (
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) NOT NULL,
    "StyleDetails" character varying
);


ALTER TABLE "toms_lookups"."RestrictionPolygonTypesInUse" OWNER TO "postgres";

--
-- TOC entry 296 (class 1259 OID 222282)
-- Name: RestrictionPolygonTypesInUse_View; Type: MATERIALIZED VIEW; Schema: toms_lookups; Owner: postgres
--

CREATE MATERIALIZED VIEW "toms_lookups"."RestrictionPolygonTypesInUse_View" AS
 SELECT "RestrictionPolygonTypesInUse"."Code",
    "RestrictionPolygonTypes"."Description"
   FROM "toms_lookups"."RestrictionPolygonTypesInUse",
    "toms_lookups"."RestrictionPolygonTypes"
  WHERE ("RestrictionPolygonTypesInUse"."Code" = "RestrictionPolygonTypes"."Code")
  WITH NO DATA;


ALTER TABLE "toms_lookups"."RestrictionPolygonTypesInUse_View" OWNER TO "postgres";

--
-- TOC entry 297 (class 1259 OID 222289)
-- Name: RestrictionPolygonTypes_Code_seq; Type: SEQUENCE; Schema: toms_lookups; Owner: postgres
--

CREATE SEQUENCE "toms_lookups"."RestrictionPolygonTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms_lookups"."RestrictionPolygonTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4525 (class 0 OID 0)
-- Dependencies: 297
-- Name: RestrictionPolygonTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."RestrictionPolygonTypes_Code_seq" OWNED BY "toms_lookups"."RestrictionPolygonTypes"."Code";


--
-- TOC entry 298 (class 1259 OID 222291)
-- Name: RestrictionShapeTypes_Code_seq; Type: SEQUENCE; Schema: toms_lookups; Owner: postgres
--

CREATE SEQUENCE "toms_lookups"."RestrictionShapeTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms_lookups"."RestrictionShapeTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4526 (class 0 OID 0)
-- Dependencies: 298
-- Name: RestrictionShapeTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."RestrictionShapeTypes_Code_seq" OWNED BY "toms_lookups"."RestrictionGeomShapeTypes"."Code";


--
-- TOC entry 299 (class 1259 OID 222293)
-- Name: SignOrientationTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."SignOrientationTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."SignOrientationTypes" OWNER TO "postgres";

--
-- TOC entry 300 (class 1259 OID 222299)
-- Name: SignOrientationTypes_Code_seq; Type: SEQUENCE; Schema: toms_lookups; Owner: postgres
--

CREATE SEQUENCE "toms_lookups"."SignOrientationTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms_lookups"."SignOrientationTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4527 (class 0 OID 0)
-- Dependencies: 300
-- Name: SignOrientationTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."SignOrientationTypes_Code_seq" OWNED BY "toms_lookups"."SignOrientationTypes"."Code";


--
-- TOC entry 301 (class 1259 OID 222301)
-- Name: SignTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."SignTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."SignTypes" OWNER TO "postgres";

--
-- TOC entry 302 (class 1259 OID 222307)
-- Name: SignTypesInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."SignTypesInUse" (
    "Code" integer NOT NULL
);


ALTER TABLE "toms_lookups"."SignTypesInUse" OWNER TO "postgres";

--
-- TOC entry 303 (class 1259 OID 222310)
-- Name: SignTypesInUse_View; Type: MATERIALIZED VIEW; Schema: toms_lookups; Owner: postgres
--

CREATE MATERIALIZED VIEW "toms_lookups"."SignTypesInUse_View" AS
 SELECT "SignTypesInUse"."Code",
    "SignTypes"."Description"
   FROM "toms_lookups"."SignTypesInUse",
    "toms_lookups"."SignTypes"
  WHERE ("SignTypesInUse"."Code" = "SignTypes"."Code")
  WITH NO DATA;


ALTER TABLE "toms_lookups"."SignTypesInUse_View" OWNER TO "postgres";

--
-- TOC entry 304 (class 1259 OID 222317)
-- Name: SignTypes_Code_seq; Type: SEQUENCE; Schema: toms_lookups; Owner: postgres
--

CREATE SEQUENCE "toms_lookups"."SignTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms_lookups"."SignTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4528 (class 0 OID 0)
-- Dependencies: 304
-- Name: SignTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."SignTypes_Code_seq" OWNED BY "toms_lookups"."SignTypes"."Code";


--
-- TOC entry 305 (class 1259 OID 222319)
-- Name: TimePeriods; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."TimePeriods" (
    "Code" integer NOT NULL,
    "Description" character varying,
    "LabelText" character varying(255)
);


ALTER TABLE "toms_lookups"."TimePeriods" OWNER TO "postgres";

--
-- TOC entry 306 (class 1259 OID 222325)
-- Name: TimePeriodsInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."TimePeriodsInUse" (
    "Code" integer NOT NULL
);


ALTER TABLE "toms_lookups"."TimePeriodsInUse" OWNER TO "postgres";

--
-- TOC entry 307 (class 1259 OID 222328)
-- Name: TimePeriodsInUse_View; Type: MATERIALIZED VIEW; Schema: toms_lookups; Owner: postgres
--

CREATE MATERIALIZED VIEW "toms_lookups"."TimePeriodsInUse_View" AS
 SELECT "TimePeriodsInUse"."Code",
    "TimePeriods"."Description",
    "TimePeriods"."LabelText"
   FROM "toms_lookups"."TimePeriodsInUse",
    "toms_lookups"."TimePeriods"
  WHERE ("TimePeriodsInUse"."Code" = "TimePeriods"."Code")
  WITH NO DATA;


ALTER TABLE "toms_lookups"."TimePeriodsInUse_View" OWNER TO "postgres";

--
-- TOC entry 308 (class 1259 OID 222335)
-- Name: TimePeriods_Code_seq; Type: SEQUENCE; Schema: toms_lookups; Owner: postgres
--

CREATE SEQUENCE "toms_lookups"."TimePeriods_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms_lookups"."TimePeriods_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4529 (class 0 OID 0)
-- Dependencies: 308
-- Name: TimePeriods_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."TimePeriods_Code_seq" OWNED BY "toms_lookups"."TimePeriods"."Code";


--
-- TOC entry 309 (class 1259 OID 222337)
-- Name: UnacceptableTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."UnacceptableTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."UnacceptableTypes" OWNER TO "postgres";

--
-- TOC entry 310 (class 1259 OID 222343)
-- Name: UnacceptableTypes_Code_seq; Type: SEQUENCE; Schema: toms_lookups; Owner: postgres
--

CREATE SEQUENCE "toms_lookups"."UnacceptableTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "toms_lookups"."UnacceptableTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4530 (class 0 OID 0)
-- Dependencies: 310
-- Name: UnacceptableTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."UnacceptableTypes_Code_seq" OWNED BY "toms_lookups"."UnacceptableTypes"."Code";


--
-- TOC entry 311 (class 1259 OID 222345)
-- Name: Corners; Type: TABLE; Schema: topography; Owner: postgres
--

CREATE TABLE "topography"."Corners" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(Point,27700)
);


ALTER TABLE "topography"."Corners" OWNER TO "postgres";

--
-- TOC entry 312 (class 1259 OID 222351)
-- Name: Corners_id_seq; Type: SEQUENCE; Schema: topography; Owner: postgres
--

CREATE SEQUENCE "topography"."Corners_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "topography"."Corners_id_seq" OWNER TO "postgres";

--
-- TOC entry 4531 (class 0 OID 0)
-- Dependencies: 312
-- Name: Corners_id_seq; Type: SEQUENCE OWNED BY; Schema: topography; Owner: postgres
--

ALTER SEQUENCE "topography"."Corners_id_seq" OWNED BY "topography"."Corners"."id";


--
-- TOC entry 313 (class 1259 OID 222353)
-- Name: os_mastermap_topography_text; Type: TABLE; Schema: topography; Owner: postgres
--

CREATE TABLE "topography"."os_mastermap_topography_text" (
    "gid" integer NOT NULL,
    "toid" character varying(20),
    "featcode" numeric(10,0),
    "version" numeric(10,0),
    "verdate" character varying(24),
    "theme" character varying(80),
    "change" character varying(80),
    "descgroup" character varying(150),
    "descterm" character varying(150),
    "make" character varying(20),
    "physlevel" numeric(10,0),
    "physpres" character varying(15),
    "text_" character varying(250),
    "textfont" numeric(10,0),
    "textpos" numeric(10,0),
    "textheight" numeric,
    "textangle" numeric,
    "loaddate" character varying(24),
    "objectid" numeric(10,0),
    "shape_leng" numeric,
    "geom" "public"."geometry"(MultiLineString,27700)
);


ALTER TABLE "topography"."os_mastermap_topography_text" OWNER TO "postgres";

--
-- TOC entry 314 (class 1259 OID 222359)
-- Name: edi_cartotext_gid_seq; Type: SEQUENCE; Schema: topography; Owner: postgres
--

CREATE SEQUENCE "topography"."edi_cartotext_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "topography"."edi_cartotext_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4532 (class 0 OID 0)
-- Dependencies: 314
-- Name: edi_cartotext_gid_seq; Type: SEQUENCE OWNED BY; Schema: topography; Owner: postgres
--

ALTER SEQUENCE "topography"."edi_cartotext_gid_seq" OWNED BY "topography"."os_mastermap_topography_text"."gid";


--
-- TOC entry 315 (class 1259 OID 222361)
-- Name: os_mastermap_topography_polygons; Type: TABLE; Schema: topography; Owner: postgres
--

CREATE TABLE "topography"."os_mastermap_topography_polygons" (
    "gid" integer NOT NULL,
    "toid" character varying(20),
    "version" numeric(10,0),
    "verdate" character varying(24),
    "featcode" numeric(10,0),
    "theme" character varying(80),
    "calcarea" numeric,
    "change" character varying(80),
    "descgroup" character varying(150),
    "descterm" character varying(150),
    "make" character varying(20),
    "physlevel" numeric(10,0),
    "physpres" character varying(20),
    "broken" integer,
    "loaddate" character varying(24),
    "objectid" numeric(10,0),
    "shape_leng" numeric,
    "shape_area" numeric,
    "geom" "public"."geometry"(MultiPolygon,27700)
);


ALTER TABLE "topography"."os_mastermap_topography_polygons" OWNER TO "postgres";

--
-- TOC entry 316 (class 1259 OID 222367)
-- Name: edi_mm_gid_seq; Type: SEQUENCE; Schema: topography; Owner: postgres
--

CREATE SEQUENCE "topography"."edi_mm_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "topography"."edi_mm_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4533 (class 0 OID 0)
-- Dependencies: 316
-- Name: edi_mm_gid_seq; Type: SEQUENCE OWNED BY; Schema: topography; Owner: postgres
--

ALTER SEQUENCE "topography"."edi_mm_gid_seq" OWNED BY "topography"."os_mastermap_topography_polygons"."gid";


--
-- TOC entry 317 (class 1259 OID 222369)
-- Name: road_casement; Type: TABLE; Schema: topography; Owner: postgres
--

CREATE TABLE "topography"."road_casement" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(LineString,27700),
    "RoadName" character varying(100),
    "ESUID" double precision,
    "USRN" integer,
    "Locality" character varying(255),
    "Town" character varying(255),
    "Az" double precision,
    "StartStreet" character varying(254),
    "EndStreet" character varying(254),
    "SideOfStreet" character varying(100)
);


ALTER TABLE "topography"."road_casement" OWNER TO "postgres";

--
-- TOC entry 318 (class 1259 OID 222375)
-- Name: LookupCodeTransfers_Bays; Type: TABLE; Schema: transfer; Owner: postgres
--

CREATE TABLE "transfer"."LookupCodeTransfers_Bays" (
    "id" integer NOT NULL,
    "Aug2018_Description" character varying,
    "Aug2018_Code" character varying,
    "CurrCode" character varying
);


ALTER TABLE "transfer"."LookupCodeTransfers_Bays" OWNER TO "postgres";

--
-- TOC entry 319 (class 1259 OID 222381)
-- Name: LookupCodeTransfers_Lines; Type: TABLE; Schema: transfer; Owner: postgres
--

CREATE TABLE "transfer"."LookupCodeTransfers_Lines" (
    "id" integer NOT NULL,
    "Aug2018_Description" character varying,
    "Aug2018_Code" character varying,
    "CurrCode" character varying
);


ALTER TABLE "transfer"."LookupCodeTransfers_Lines" OWNER TO "postgres";

--
-- TOC entry 320 (class 1259 OID 222387)
-- Name: RC_Polygon; Type: TABLE; Schema: transfer; Owner: postgres
--

CREATE TABLE "transfer"."RC_Polygon" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(MultiPolygon,27700),
    "gid" integer,
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


ALTER TABLE "transfer"."RC_Polygon" OWNER TO "postgres";

--
-- TOC entry 321 (class 1259 OID 222393)
-- Name: RC_Polygon_id_seq; Type: SEQUENCE; Schema: transfer; Owner: postgres
--

CREATE SEQUENCE "transfer"."RC_Polygon_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "transfer"."RC_Polygon_id_seq" OWNER TO "postgres";

--
-- TOC entry 4534 (class 0 OID 0)
-- Dependencies: 321
-- Name: RC_Polygon_id_seq; Type: SEQUENCE OWNED BY; Schema: transfer; Owner: postgres
--

ALTER SEQUENCE "transfer"."RC_Polygon_id_seq" OWNED BY "transfer"."RC_Polygon"."id";


--
-- TOC entry 3976 (class 2604 OID 222395)
-- Name: BaysLinesFadedTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."BaysLinesFadedTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."BayLinesFadedTypes_Code_seq"'::"regclass");


--
-- TOC entry 3977 (class 2604 OID 222396)
-- Name: BaysLines_SignIssueTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."BaysLines_SignIssueTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."BaysLines_SignIssueTypes_Code_seq"'::"regclass");


--
-- TOC entry 3978 (class 2604 OID 222397)
-- Name: ConditionTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."ConditionTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."ConditionTypes_Code_seq"'::"regclass");


--
-- TOC entry 3979 (class 2604 OID 222398)
-- Name: MHTC_CheckIssueType Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."MHTC_CheckIssueType" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."MHTC_CheckIssueType_Code_seq"'::"regclass");


--
-- TOC entry 3980 (class 2604 OID 222399)
-- Name: MHTC_CheckStatus Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."MHTC_CheckStatus" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."MHTC_CheckStatus_Code_seq"'::"regclass");


--
-- TOC entry 3981 (class 2604 OID 222400)
-- Name: SignAttachmentTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignAttachmentTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."signAttachmentTypes2_id_seq"'::"regclass");


--
-- TOC entry 3982 (class 2604 OID 222401)
-- Name: SignConditionTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignConditionTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."SignConditionTypes_Code_seq"'::"regclass");


--
-- TOC entry 3983 (class 2604 OID 222402)
-- Name: SignFadedTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignFadedTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."SignFadedTypes_id_seq"'::"regclass");


--
-- TOC entry 3984 (class 2604 OID 222403)
-- Name: SignIlluminationTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignIlluminationTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."SignIlluminationTypes_Code_seq"'::"regclass");


--
-- TOC entry 3985 (class 2604 OID 222404)
-- Name: SignMountTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignMountTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."SignMountTypes_id_seq"'::"regclass");


--
-- TOC entry 3986 (class 2604 OID 222405)
-- Name: SignObscurredTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignObscurredTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."SignObscurredTypes_id_seq"'::"regclass");


--
-- TOC entry 3987 (class 2604 OID 222406)
-- Name: TicketMachineIssueTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."TicketMachineIssueTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."TicketMachineIssueTypes_id_seq"'::"regclass");


--
-- TOC entry 3988 (class 2604 OID 222407)
-- Name: itn_roadcentreline gid; Type: DEFAULT; Schema: highways_network; Owner: postgres
--

ALTER TABLE ONLY "highways_network"."itn_roadcentreline" ALTER COLUMN "gid" SET DEFAULT "nextval"('"highways_network"."edi_itn_roadcentreline_gid_seq"'::"regclass");


--
-- TOC entry 3989 (class 2604 OID 222408)
-- Name: SiteArea id; Type: DEFAULT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."SiteArea" ALTER COLUMN "id" SET DEFAULT "nextval"('"local_authority"."SiteArea_id_seq"'::"regclass");


--
-- TOC entry 3990 (class 2604 OID 222409)
-- Name: StreetGazetteerRecords id; Type: DEFAULT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."StreetGazetteerRecords" ALTER COLUMN "id" SET DEFAULT "nextval"('"local_authority"."StreetGazetteerRecords_id_seq"'::"regclass");


--
-- TOC entry 3991 (class 2604 OID 222410)
-- Name: RC_Polyline id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Polyline" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."RC_Polyline_id_seq"'::"regclass");


--
-- TOC entry 3992 (class 2604 OID 222411)
-- Name: RC_Sections gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Sections" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."RC_Sections_gid_seq"'::"regclass");


--
-- TOC entry 3993 (class 2604 OID 222412)
-- Name: RC_Sections_merged gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Sections_merged" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."RC_Sections_merged_gid_seq"'::"regclass");


--
-- TOC entry 4000 (class 2604 OID 222413)
-- Name: RestrictionLayers Code; Type: DEFAULT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionLayers" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms"."RestrictionLayers_id_seq"'::"regclass");


--
-- TOC entry 4003 (class 2604 OID 222414)
-- Name: ActionOnProposalAcceptanceTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."ActionOnProposalAcceptanceTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq"'::"regclass");


--
-- TOC entry 4004 (class 2604 OID 222415)
-- Name: AdditionalConditionTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."AdditionalConditionTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."AdditionalConditionTypes_Code_seq"'::"regclass");


--
-- TOC entry 4005 (class 2604 OID 222416)
-- Name: BayLineTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."BayLineTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."BayLineTypes_Code_seq"'::"regclass");


--
-- TOC entry 4006 (class 2604 OID 222417)
-- Name: LengthOfTime Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."LengthOfTime" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."LengthOfTime_Code_seq"'::"regclass");


--
-- TOC entry 4007 (class 2604 OID 222418)
-- Name: PaymentTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."PaymentTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."PaymentTypes_Code_seq"'::"regclass");


--
-- TOC entry 4008 (class 2604 OID 222419)
-- Name: ProposalStatusTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."ProposalStatusTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."ProposalStatusTypes_Code_seq"'::"regclass");


--
-- TOC entry 4009 (class 2604 OID 222420)
-- Name: RestrictionGeomShapeTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionGeomShapeTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."RestrictionShapeTypes_Code_seq"'::"regclass");


--
-- TOC entry 4010 (class 2604 OID 222421)
-- Name: RestrictionPolygonTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionPolygonTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."RestrictionPolygonTypes_Code_seq"'::"regclass");


--
-- TOC entry 4011 (class 2604 OID 222422)
-- Name: SignOrientationTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignOrientationTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."SignOrientationTypes_Code_seq"'::"regclass");


--
-- TOC entry 4012 (class 2604 OID 222423)
-- Name: SignTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."SignTypes_Code_seq"'::"regclass");


--
-- TOC entry 4013 (class 2604 OID 222424)
-- Name: TimePeriods Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."TimePeriods" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."TimePeriods_Code_seq"'::"regclass");


--
-- TOC entry 4014 (class 2604 OID 222425)
-- Name: UnacceptableTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."UnacceptableTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."UnacceptableTypes_Code_seq"'::"regclass");


--
-- TOC entry 4015 (class 2604 OID 222426)
-- Name: Corners id; Type: DEFAULT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."Corners" ALTER COLUMN "id" SET DEFAULT "nextval"('"topography"."Corners_id_seq"'::"regclass");


--
-- TOC entry 4017 (class 2604 OID 222427)
-- Name: os_mastermap_topography_polygons gid; Type: DEFAULT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."os_mastermap_topography_polygons" ALTER COLUMN "gid" SET DEFAULT "nextval"('"topography"."edi_mm_gid_seq"'::"regclass");


--
-- TOC entry 4016 (class 2604 OID 222428)
-- Name: os_mastermap_topography_text gid; Type: DEFAULT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."os_mastermap_topography_text" ALTER COLUMN "gid" SET DEFAULT "nextval"('"topography"."edi_cartotext_gid_seq"'::"regclass");


--
-- TOC entry 4018 (class 2604 OID 222429)
-- Name: RC_Polygon id; Type: DEFAULT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."RC_Polygon" ALTER COLUMN "id" SET DEFAULT "nextval"('"transfer"."RC_Polygon_id_seq"'::"regclass");


--
-- TOC entry 4394 (class 0 OID 221977)
-- Dependencies: 221
-- Data for Name: BaysLinesFadedTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."BaysLinesFadedTypes" ("Code", "Description") VALUES (1, 'No issue');
INSERT INTO "compliance_lookups"."BaysLinesFadedTypes" ("Code", "Description") VALUES (6, 'Other (please specify in notes)');
INSERT INTO "compliance_lookups"."BaysLinesFadedTypes" ("Code", "Description") VALUES (2, 'Slightly faded marking');
INSERT INTO "compliance_lookups"."BaysLinesFadedTypes" ("Code", "Description") VALUES (3, 'Very faded markings');
INSERT INTO "compliance_lookups"."BaysLinesFadedTypes" ("Code", "Description") VALUES (4, 'Markings not correctly removed');
INSERT INTO "compliance_lookups"."BaysLinesFadedTypes" ("Code", "Description") VALUES (5, 'Missing markings');


--
-- TOC entry 4396 (class 0 OID 221985)
-- Dependencies: 223
-- Data for Name: BaysLines_SignIssueTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4398 (class 0 OID 221993)
-- Dependencies: 225
-- Data for Name: ConditionTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4400 (class 0 OID 221998)
-- Dependencies: 227
-- Data for Name: MHTC_CheckIssueType; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4402 (class 0 OID 222006)
-- Dependencies: 229
-- Data for Name: MHTC_CheckStatus; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4404 (class 0 OID 222014)
-- Dependencies: 231
-- Data for Name: SignAttachmentTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (1, 1, 'Short Pole');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (2, 2, 'Normal Pole');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (3, 3, 'Tall Pole');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (4, 4, 'Lamppost');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (5, 5, 'Wall');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (6, 6, 'Fences');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (7, 7, 'Other (Please specify in notes)');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (8, 8, 'Traffic Light');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (9, 9, 'Large Pole');


--
-- TOC entry 4405 (class 0 OID 222020)
-- Dependencies: 232
-- Data for Name: SignConditionTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4407 (class 0 OID 222028)
-- Dependencies: 234
-- Data for Name: SignFadedTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (1, 1, 'No issues');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (2, 2, 'Sign Faded');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (3, 3, 'Sign Damaged');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (4, 4, 'Sign Damaged and Faded');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (5, 5, 'Pole Present, but Sign Missing');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (6, 6, 'Other (Please specify in notes)');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (7, 7, 'Sign OK, but Pole bent');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (8, 8, 'Defaced (Stickers, graffiti, dirt)');


--
-- TOC entry 4409 (class 0 OID 222036)
-- Dependencies: 236
-- Data for Name: SignIlluminationTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4411 (class 0 OID 222044)
-- Dependencies: 238
-- Data for Name: SignMountTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (1, 1, 'U-Channel');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (2, 2, 'Round Post Bracket');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (3, 3, 'Square Post Bracket');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (4, 4, 'Wall Bracket');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (5, 5, 'Other (Please specify in notes)');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (6, 6, 'Screws or Nails');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (7, 7, 'Simple bar');


--
-- TOC entry 4413 (class 0 OID 222052)
-- Dependencies: 240
-- Data for Name: SignObscurredTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignObscurredTypes" ("id", "Code", "Description") VALUES (1, 1, 'No issue');
INSERT INTO "compliance_lookups"."SignObscurredTypes" ("id", "Code", "Description") VALUES (2, 2, 'Partially obscured');
INSERT INTO "compliance_lookups"."SignObscurredTypes" ("id", "Code", "Description") VALUES (3, 3, 'Completely obscured');


--
-- TOC entry 4415 (class 0 OID 222060)
-- Dependencies: 242
-- Data for Name: TicketMachineIssueTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (1, 1, 'No issues');
INSERT INTO "compliance_lookups"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (2, 2, 'Defaced (e.g. graffiti)');
INSERT INTO "compliance_lookups"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (3, 3, 'Physically Damaged');
INSERT INTO "compliance_lookups"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (4, 4, 'Other (Please specify in notes)');


--
-- TOC entry 4418 (class 0 OID 222070)
-- Dependencies: 245
-- Data for Name: itn_roadcentreline; Type: TABLE DATA; Schema: highways_network; Owner: postgres
--

INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C000001000000010200000004000000B8E26A865DDF1341EE2FFAECCE93244176D2853C80DF1341D9E85FCECD932441597DB99BC9DF134145867F07D5932441AD33DC7993E013417333B8D4EF932441');
INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C000001000000010200000009000000360170A127D913410CBBA878F09224413EB8E6A0B3DA13411AD3BEE6279324413478C568C7DD1341F259E02B969324419B4139F6CCDD1341EC4DD8F296932441B8E26A865DDF1341EE2FFAECCE93244183C76621A9DF1341396C76EAE69324418427555FF4DF13413277FE74F1932441F3F06C9C47E013415895BC73FD932441003B4BC57DE0134130F5CAB804942441');
INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C00000100000001020000000F000000A22F13A576DB13416652C974CE91244127ED4BB7B8DB1341FA21AEAE5791244199ED8982C4DB1341A587E4CF44912441172B30ECC7DB1341DABE0D5A3F9124414C10E32F00DC1341380DD0E7D4902441DA41335A0CDC13411BAA2F93BC902441F344D81C0DDC134173753AA6AF902441AF1C773A03DC1341EDD475AAA79024419A1E826EF8DB134125754838A0902441DCC2C52DEDDB1341FB96917598902441236CB9E3D7DB134111EA386F8D902441016DFAF1D4DB1341FF375A9B89902441312ED5AEC8DB13418B9976AA7990244186784DEEDADB134130EF02D94F90244108E8814DF6DB1341D5448F0726902441');
INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C00000100000001020000000A00000099ED8982C4DB1341A587E4CF449124410A9F69F032DC1341DAB2C9F9539124412AB2070E57DC1341FC46FAEA58912441F940D5426FDC13417AE1615E5C9124415DCC92740FDD1341A196A734739124412096F3FD8ADD134181151CD184912441FFB27DBBEFDD134152549E2D93912441612AEB2222DE1341F147D43E9A912441B257679537DE13415DBDA8409D9124418F673B8FD1DE1341D7C0AE53B3912441');
INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C0000010000000102000000020000009A1E826EF8DB134125754838A090244106FC6D152ADF13414580FDBB15912441');
INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C000001000000010200000002000000016DFAF1D4DB1341FF375A9B8990244190DDB96434DF13418B6A766103912441');
INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C000001000000010200000004000000F940D5426FDC13417AE1615E5C9124413B038A608ADC134128F98C3E2E912441A0E54D013BDE13410AF4C2D46B912441612AEB2222DE1341F147D43E9A912441');
INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C000001000000010200000004000000F940D5426FDC13417AE1615E5C912441E739A4F458DC1341FFE1A4D28691244127BEB61AF7DC134145BA037E9C9124415DCC92740FDD1341A196A73473912441');
INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C0000010000000102000000040000002096F3FD8ADD134181151CD184912441D4B07D8471DD13419B047CBDAE912441641F0D580ADE1341E0DCDA68C4912441612AEB2222DE1341F147D43E9A912441');
INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C0000010000000102000000110000003EB8E6A0B3DA13411AD3BEE627932441A0976E9257DB134150B81E050292244117ECCB9B79DB134119C28DACFC912441092AB0D088DB1341D771ABAEF89124413DE0F71E96DB1341E60B465EEF9124412D6EDE8A99DB1341CB58A3D2E291244173499F2995DB13414191DC94DC912441344F6CF091DB1341A8ECF3FCD7912441F707997380DB1341234C2F01D0912441A22F13A576DB13416652C974CE9124411DCD590172DB1341D84240B9CD912441E86614EA58DB134165C4921ACE912441DD258BF248DB13418658C30BD3912441EBE7A6BD39DB1341E383C9B0DD912441B9E15C3838DB134172B519DBE99124412E1008A043DB134100E76905F6912441A0976E9257DB134150B81E0502922441');
INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C0000010000000102000000080000003478C568C7DD1341F259E02B96932441C41BA807EADD13415B8AC95558932441339D5F2C6FDE134179B9FE2E659224418BA3249780DE1341F2DF386045922441D9A96903AADE134115564EBAF99124418F673B8FD1DE1341D7C0AE53B391244106FC6D152ADF13414580FDBB1591244190DDB96434DF13418B6A766103912441');
INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C000001000000010200000002000000092AB0D088DB1341D771ABAEF8912441339D5F2C6FDE134179B9FE2E65922441');
INSERT INTO "highways_network"."itn_roadcentreline" ("gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng", "geom") VALUES (13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0105000020346C00000100000001020000000200000073499F2995DB13414191DC94DC9124418BA3249780DE1341F2DF386045922441');


--
-- TOC entry 4420 (class 0 OID 222078)
-- Dependencies: 247
-- Data for Name: SiteArea; Type: TABLE DATA; Schema: local_authority; Owner: postgres
--

INSERT INTO "local_authority"."SiteArea" ("id", "name", "geom") VALUES (1, 'TOMs Test - Edinburgh New Town', '0106000020346C0000010000000103000000010000000500000046E6C948D5D813414E9E1FE0669324418D9DCAFB28E513418AAD8FB2FB9424419DC7A6EE03E71341071C57AD98912441F0FFFFFF88DA1341A0999999D58F244146E6C948D5D813414E9E1FE066932441');


--
-- TOC entry 4422 (class 0 OID 222086)
-- Dependencies: 249
-- Data for Name: StreetGazetteerRecords; Type: TABLE DATA; Schema: local_authority; Owner: postgres
--

INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (8, NULL, 1008, NULL, 'Princes Street', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C000001000000010200000002000000016DFAF1D4DB1341FF375A9B8990244190DDB96434DF13418B6A766103912441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (9, NULL, 1009, NULL, 'Rose Street South Lane', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C000001000000010200000004000000F940D5426FDC13417AE1615E5C9124413B038A608ADC134128F98C3E2E912441A0E54D013BDE13410AF4C2D46B912441612AEB2222DE1341F147D43E9A912441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (10, NULL, 1010, NULL, 'Rose Street North Lane', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C000001000000010200000004000000F940D5426FDC13417AE1615E5C912441E739A4F458DC1341FFE1A4D28691244127BEB61AF7DC134145BA037E9C9124415DCC92740FDD1341A196A73473912441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (11, NULL, 1011, NULL, 'Rose Street North Lane', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C0000010000000102000000040000002096F3FD8ADD134181151CD184912441D4B07D8471DD13419B047CBDAE912441641F0D580ADE1341E0DCDA68C4912441612AEB2222DE1341F147D43E9A912441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (12, NULL, 1012, NULL, 'George Street', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C000001000000010200000002000000092AB0D088DB1341D771ABAEF8912441339D5F2C6FDE134179B9FE2E65922441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (13, NULL, 1013, NULL, 'George Street', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C00000100000001020000000200000073499F2995DB13414191DC94DC9124418BA3249780DE1341F2DF386045922441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (14, NULL, 1014, NULL, 'York Place', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C000001000000010200000005000000B8E26A865DDF1341EE2FFAECCE93244183C76621A9DF1341396C76EAE69324418427555FF4DF13413277FE74F1932441F3F06C9C47E013415895BC73FD932441003B4BC57DE0134130F5CAB804942441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (1, NULL, 1001, NULL, 'Queen Street', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C000001000000010200000005000000360170A127D913410CBBA878F09224413EB8E6A0B3DA13411AD3BEE6279324413478C568C7DD1341F259E02B969324419B4139F6CCDD1341EC4DD8F296932441B8E26A865DDF1341EE2FFAECCE932441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (2, NULL, 1002, NULL, 'York Place', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C000001000000010200000004000000B8E26A865DDF1341EE2FFAECCE93244176D2853C80DF1341D9E85FCECD932441597DB99BC9DF134145867F07D5932441AD33DC7993E013417333B8D4EF932441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (3, NULL, 1003, NULL, 'Hanover Street', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C0000010000000102000000110000003EB8E6A0B3DA13411AD3BEE627932441A0976E9257DB134150B81E050292244117ECCB9B79DB134119C28DACFC912441092AB0D088DB1341D771ABAEF89124413DE0F71E96DB1341E60B465EEF9124412D6EDE8A99DB1341CB58A3D2E291244173499F2995DB13414191DC94DC912441344F6CF091DB1341A8ECF3FCD7912441F707997380DB1341234C2F01D0912441A22F13A576DB13416652C974CE9124411DCD590172DB1341D84240B9CD912441E86614EA58DB134165C4921ACE912441DD258BF248DB13418658C30BD3912441EBE7A6BD39DB1341E383C9B0DD912441B9E15C3838DB134172B519DBE99124412E1008A043DB134100E76905F6912441A0976E9257DB134150B81E0502922441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (4, NULL, 1004, NULL, 'Hanover Street', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C00000100000001020000000F000000A22F13A576DB13416652C974CE91244127ED4BB7B8DB1341FA21AEAE5791244199ED8982C4DB1341A587E4CF44912441172B30ECC7DB1341DABE0D5A3F9124414C10E32F00DC1341380DD0E7D4902441DA41335A0CDC13411BAA2F93BC902441F344D81C0DDC134173753AA6AF902441AF1C773A03DC1341EDD475AAA79024419A1E826EF8DB134125754838A0902441DCC2C52DEDDB1341FB96917598902441236CB9E3D7DB134111EA386F8D902441016DFAF1D4DB1341FF375A9B89902441312ED5AEC8DB13418B9976AA7990244186784DEEDADB134130EF02D94F90244108E8814DF6DB1341D5448F0726902441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (5, NULL, 1005, NULL, 'North St David Street', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C0000010000000102000000080000003478C568C7DD1341F259E02B96932441C41BA807EADD13415B8AC95558932441339D5F2C6FDE134179B9FE2E659224418BA3249780DE1341F2DF386045922441D9A96903AADE134115564EBAF99124418F673B8FD1DE1341D7C0AE53B391244106FC6D152ADF13414580FDBB1591244190DDB96434DF13418B6A766103912441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (6, NULL, 1006, NULL, 'Rose Street', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C00000100000001020000000A00000099ED8982C4DB1341A587E4CF449124410A9F69F032DC1341DAB2C9F9539124412AB2070E57DC1341FC46FAEA58912441F940D5426FDC13417AE1615E5C9124415DCC92740FDD1341A196A734739124412096F3FD8ADD134181151CD184912441FFB27DBBEFDD134152549E2D93912441612AEB2222DE1341F147D43E9A912441B257679537DE13415DBDA8409D9124418F673B8FD1DE1341D7C0AE53B3912441');
INSERT INTO "local_authority"."StreetGazetteerRecords" ("id", "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength", "geom") VALUES (7, NULL, 1007, NULL, 'Princes Street', 'NewTown', 'Edinburgh', NULL, NULL, '0105000020346C0000010000000102000000020000009A1E826EF8DB134125754838A090244106FC6D152ADF13414580FDBB15912441');


--
-- TOC entry 4424 (class 0 OID 222094)
-- Dependencies: 251
-- Data for Name: RC_Polyline; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RC_Polyline" ("geom", "id") VALUES ('0102000020346C0000810000002124811644DF134183EF294E0491244145C8926144DF1341F7E81F110391244190AC1F6144DF13415C84FE0F039124411B67646144DF1341DF76D90E039124419C5926E443DF13413245CCD50191244185859A6743DF1341454EAD9C0091244143317A6643DF1341A2DCAB9B00912441D670066643DF134174888A9A00912441EEA26F2D42DF1341D9962984FF902441EC5877F540DF134162349C6DFE9024415E05C6F340DF134105E9D36CFE9024419A1EA5F240DF134174A0D26BFE90244126C14E1D3FDF13417CD75D93FD90244136AD73483DDF1341174CA6BAFC9024411CC55B463DDF134130C22ABAFC9024419CFFA9443DDF134186B462B9FC902441343C85003BDF1341EE440A34FC9024419372ACBC38DF1341CE495FAEFB9024411B037B00E1DB13417AD0BCFE82902441376F3056D9DB13416B43C20779902441AA8BD263EADB134136C22EF351902441BF86558205DC1341D750918428902441E4887F4D06DC1341475BEA0B26902441BCD9B78705DC1341A93ED69223902441DFA75A4403DC13411F564D572190244155451EBCFFDB134124C241911F9024410C008647FBDB13417975256D1E902441EC143856F6DB1341677490071E902441B0DB0F64F1DB1341FB4B746A1E9024419C0AFEECECDB1341E9E4228C1F902441A7E2E660E9DB13412F164150219024415149AE18E7DB1341D3388D8A23902441CFD979B9CBDB13412EE3005C4D9024411731724CCBDB1341ABFE71244E902441C2E6F90CB9DB134106A9E5F577902441B54BB6BAB8DB134171D453467A902441C960D9BFB9DB1341F805A7897C902441999FFE02C6DB13416CA48A7A8C902441BB9EBDF4C8DB13417E56694E9090244102510E61CCDB1341937BC0FD929024412C3ED7E2E0DB134165F6639C9D9024410C0A587AEBDB1341FF8264EAA4902441CACF81EEF5DB1341ECBB0520AC9024417BF96FFAFCDB1341FB040BD1B1902441C8360069FCDB1341E1F27679BB902441D1CFD6B0F0DB1341CEC0C9E9D2902441E92D728BB8DB134102A7B1223D9124417321FD3CB5DB1341C087066D429124410121BF71A9DB13411522D04B559124412638184DA9DB1341377DE289559124415C3739D66ADB134178AA1DD4C591244162F3036E58DB13414A52831BC6912441D3E7CA4D54DB13419F3E7171C6912441EB95217E50DB134135F43A4DC7912441E054988640DB134156886B3ECC91244175C27DED3BDB1341BC226365CE912441838499B82CDB1341194E690AD99124412E67F4A92ADB134159F43A03DB912441E7ECA0C529DB13410B540931DD912441B5E6564028DB13419A85595BE991244185BE808028DB13417D13C759EB9124415C5F9ABB29DB1341004C5740ED912441D18D452335DB13418E7DA76AF99124415000185237DB1341C9D98622FB912441B41C44E845DB13411948C8E8039224414EEC0785A8DA13415CE6EE091E932441ABAFA9F12BD913414DD77BC4E8922441982EBFF826D91341958D657AE8922441BEE8571022D9134165AF9CF8E8922441202970B31DD913410766C632EA92244164895C4F1AD913416810220AEC922441B839163918D91341D1E38B50EE92244148A6E9A417D913415B2401CDF0922441E9E957A118D9134148C73441F39224412C57AB151BD9134117A7A86FF5922441EEAB62C41ED91341F576B221F7922441C152365123D91341CB9ED52CF8922441C909AD50AFDA1341D9B6EB9A2F932441BEC98B18C3DD1341B13D0DE09D9324412593FFA5C8DD1341AB3105A79E9324418FCCE4F156DF1341AAF90E50D6932441B221AA8EA0DF1341AF34A6ABED932441EF634AD0A4DF1341AD90839EEE932441962F98FFEFDF13414D01FF26F9932441A247172E43E01341BFA5A22305942441404E6E7643E013415FA4B32D059424414D984C9F79E013413704C2720C942441EFFFB9997EE013410B5D09B60C942441490A5C7F83E013410AD11C310C9424410DD97BD587E01341B953FFF00A942441A0BF6E2F8BE0134192AE0615099424410E5939398DE013418946CACB06942441B60AC8BF8DE01341B992934E04942441B4F2EEB58CE013418B8DC2DB0194244112F8B3358AE0134129A6B2B0FF932441C4ADC27D86E01341E032B903FE932441B3DD49EB81E0134129E6D3FEFC9324411CB6AEE64BE013414095A3BEF5932441D5D0AACDF8DF1341CB6618C5E9932441188B71B0F8DF1341BE52F1C0E9932441AE0F13B7AFDF134133FCBE87DF93244117B5C45799DF1341EA816D6ED893244147238101C6DF13415C5A07D4DC932441079AA65E8FE0134137DA1F90F7932441B4AC705994E01341468EAAD1F7932441F70A583E99E0134143CF084BF7932441541CB8929DE01341825C6809F6932441240812EAA0E013414FE0442CF49324413481ABF0A2E01341460053E2F193244152E9C073A3E01341F0F6ED64EF9324414D6B7D66A2E01341CE477AF2EC932441CB853CE39FE01341203F4AC8EA932441668DF5289CE0134138499D1CE993244153CD119597E01341AF8C5019E8932441FF16EFB6CDDF134181DF174CCD9324419BD7FFB2CCDF1341539A132ECD932441B82CCC5383DF1341E7FCF3F4C5932441BAE0DA347FDF1341414C9FD2C5932441C2A1FD355FDF13417226CDDAC693244147A69921DBDD134157FC449F90932441E1550570F9DD13412A39E07D5A9324417FC24376F9DD1341A18599725A932441EE43FB9A7EDE1341BFB4CE4B67922441464AC00590DE134138DB087D479224410B75776EB9DE134114EF9BDDFB9124419E85A5F6E0DE134185F0767DB5912441151AD87C39DF1341F3AFC5E5179124419FFB23CC43DF1341399A3E8B059124412124811644DF134183EF294E04912441', 1);
INSERT INTO "public"."RC_Polyline" ("geom", "id") VALUES ('0102000020346C0000160000004EC9A6E489DB1341B02766B5C9912441B44A2710C8DB13410706A8F259912441BC6C382CCFDB13415E9C8C924E9124419B91AFB32EDC1341ABA6AAB05B912441C7E4D5BF52DC13415384779F6091244143D4C0DF6ADC134174EAE40F64912441A75F7E110BDD13419B9F2AE67A9124416A29DF9A86DD13417B1E9F828C91244149466958EBDD13414C5D21DF9A912441EDF68969EBDD13414A4A8DE19A9124414F6EF7D01DDE1341E93DC3F2A19124413688F33733DE134125E8FAF2A4912441DD723EDABDDE13411C99F1D2B8912441CA8BFF9B9ADE134167268690F79124411E03CE949ADE1341CF5A7E9DF79124417334D66875DE13412D90E97F3B922441F832A280A1DB1341D8E1C700D6912441B09A6809A1DB13410B9CE256D59124413C2641499FDB1341ECF98493D391244166FB3ABA9CDB134180D78814D291244129B4673D8BDB1341FB36C418CA9124414EC9A6E489DB1341B02766B5C9912441', 2);
INSERT INTO "public"."RC_Polyline" ("geom", "id") VALUES ('0102000020346C00001400000073886781C6DE134180A2786BA9912441BB5D56FE3BDE1341C5F1FB8F95912441C3135BE73BDE134165C7B98C9591244172E6DE7426DE1341F951E58A9291244167200316F4DD134127F3E27A8B912441D60208618FDD1341870C991F7D9124411339A7D713DD1341A78D24836B912441AFADE9A573DC134180D8DEAC54912441E01E1C715BDC1341023E773951912441770247475BDC134134399F33519124411E61662B37DC1341B199AB424C91244108A6C784D8DB1341FC806D433F9124417941ECA70FDC1341BF681AF3D6902441B53497B50FDC1341C59186D8D69024414366E7DF1BDC1341A82EE683BE902441D3036E581CDC1341043C65CFBC902441EC06131B1DDC13415C0770E2AF9024417F47B49A1CDC134196881ABEAD902441EB6B2C6116DF1341C9BEF2391B91244173886781C6DE134180A2786BA9912441', 3);
INSERT INTO "public"."RC_Polyline" ("geom", "id") VALUES ('0102000020346C000005000000EDAC57081FDF134169EB75D20B912441BDB2572602DC1341864CE94A999024419A007F5400DC1341414DA309989024413070FAAA20DF1341696832E908912441EDAC57081FDF134169EB75D20B912441', 4);
INSERT INTO "public"."RC_Polyline" ("geom", "id") VALUES ('0102000020346C00000800000020773664A8DB1341ED790996E7912441D9CA8BF56CDE1341735D98EE4A922441CEE31A0A64DE1341847AB3385B922441C43476EEA2DB13414DFF232AF4912441A5430524A3DB1341B041A604F4912441A75BFAFDA4DB134106C0E651F2912441379C68F9A5DB13414347FC72F091244120773664A8DB1341ED790996E7912441', 5);
INSERT INTO "public"."RC_Polyline" ("geom", "id") VALUES ('0102000020346C0000090000009869A2878ADB1341B4D68744019224417A7A89965BDE1341FDF0E3A76A922441836C239CDADD1341D610553356932441500E9950BCDD1341A5E5944F8C9324411464BC55C7DA134167B5285A2293244194729EA664DB13410BDBE75908922441B57755677EDB13415A6F6B4E04922441BA97C10B81DB1341FE40D9C1039224419869A2878ADB1341B4D6874401922441', 6);
INSERT INTO "public"."RC_Polyline" ("geom", "id") VALUES ('0102000020346C000010000000776C1E045DDB13410A0F8DC7F8912441162ACD3D51DB13415B3651B2F1912441D7ADBA7148DB13417E5C1B50E8912441CB36816C49DB1341D914E779E09124418801A71954DB1341EE06B300D9912441301E12B05DDB13417196FF08D691244112C3B1C66FDB13418561D6C2D5912441920FA4D371DB13412D45B915D69124416240D54478DB13415B5A1F1AD79124416A80ED2C84DB1341C2DBA489DC912441F7FDA21086DB1341DEE1ED3ADF912441206E0D2B89DB1341B3C1F8A6E3912441097558CD86DB13415EA8E553EC91244144CCFE017EDB1341819ED77BF2912441A6846D7173DB13411A8ECA41F5912441776C1E045DDB13410A0F8DC7F8912441', 7);


--
-- TOC entry 4426 (class 0 OID 222102)
-- Dependencies: 253
-- Data for Name: RC_Sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (1, '0102000020346C0000140000002124811644DF134183EF294E0491244145C8926144DF1341F7E81F110391244190AC1F6144DF13415C84FE0F039124411B67646144DF1341DF76D90E039124419C5926E443DF13413245CCD50191244185859A6743DF1341454EAD9C0091244143317A6643DF1341A2DCAB9B00912441D670066643DF134174888A9A00912441EEA26F2D42DF1341D9962984FF902441EC5877F540DF134162349C6DFE9024415E05C6F340DF134105E9D36CFE9024419A1EA5F240DF134174A0D26BFE90244126C14E1D3FDF13417CD75D93FD90244136AD73483DDF1341174CA6BAFC9024411CC55B463DDF134130C22ABAFC9024419CFFA9443DDF134186B462B9FC902441343C85003BDF1341EE440A34FC9024419372ACBC38DF1341CE495FAEFB9024411B037B00E1DB13417AD0BCFE829024413B2B497CDDDB1341A3047C6C7E902441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (3, '0102000020346C000019000000774A477CDDDB1341A593796C7E902441376F3056D9DB13416B43C20779902441AA8BD263EADB134136C22EF351902441BF86558205DC1341D750918428902441E4887F4D06DC1341475BEA0B26902441BCD9B78705DC1341A93ED69223902441DFA75A4403DC13411F564D572190244155451EBCFFDB134124C241911F9024410C008647FBDB13417975256D1E902441EC143856F6DB1341677490071E902441B0DB0F64F1DB1341FB4B746A1E9024419C0AFEECECDB1341E9E4228C1F902441A7E2E660E9DB13412F164150219024415149AE18E7DB1341D3388D8A23902441CFD979B9CBDB13412EE3005C4D9024411731724CCBDB1341ABFE71244E902441C2E6F90CB9DB134106A9E5F577902441B54BB6BAB8DB134171D453467A902441C960D9BFB9DB1341F805A7897C902441999FFE02C6DB13416CA48A7A8C902441BB9EBDF4C8DB13417E56694E9090244102510E61CCDB1341937BC0FD929024412C3ED7E2E0DB134165F6639C9D9024410C0A587AEBDB1341FF8264EAA4902441134780EEF5DB134115AD0420AC902441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (5, '0102000020346C000018000000073083EEF5DB13416CD80620AC9024417BF96FFAFCDB1341FB040BD1B1902441C8360069FCDB1341E1F27679BB902441D1CFD6B0F0DB1341CEC0C9E9D2902441E92D728BB8DB134102A7B1223D9124417321FD3CB5DB1341C087066D429124410121BF71A9DB13411522D04B559124412638184DA9DB1341377DE289559124415C3739D66ADB134178AA1DD4C591244162F3036E58DB13414A52831BC6912441D3E7CA4D54DB13419F3E7171C6912441EB95217E50DB134135F43A4DC7912441E054988640DB134156886B3ECC91244175C27DED3BDB1341BC226365CE912441838499B82CDB1341194E690AD99124412E67F4A92ADB134159F43A03DB912441E7ECA0C529DB13410B540931DD912441B5E6564028DB13419A85595BE991244185BE808028DB13417D13C759EB9124415C5F9ABB29DB1341004C5740ED912441D18D452335DB13418E7DA76AF99124415000185237DB1341C9D98622FB912441B41C44E845DB13411948C8E803922441C99F0885A8DA1341A0A4ED091E932441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (7, '0102000020346C00001000000006690585A8DA1341518CEE091E932441ABAFA9F12BD913414DD77BC4E8922441982EBFF826D91341958D657AE8922441BEE8571022D9134165AF9CF8E8922441202970B31DD913410766C632EA92244164895C4F1AD913416810220AEC922441B839163918D91341D1E38B50EE92244148A6E9A417D913415B2401CDF0922441E9E957A118D9134148C73441F39224412C57AB151BD9134117A7A86FF5922441EEAB62C41ED91341F576B221F7922441C152365123D91341CB9ED52CF8922441C909AD50AFDA1341D9B6EB9A2F932441BEC98B18C3DD1341B13D0DE09D9324412593FFA5C8DD1341AB3105A79E9324413249E2F156DF1341C29F0E50D6932441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (9, '0102000020346C0000160000000602E7F156DF134117AD0F50D6932441B221AA8EA0DF1341AF34A6ABED932441EF634AD0A4DF1341AD90839EEE932441962F98FFEFDF13414D01FF26F9932441A247172E43E01341BFA5A22305942441404E6E7643E013415FA4B32D059424414D984C9F79E013413704C2720C942441EFFFB9997EE013410B5D09B60C942441490A5C7F83E013410AD11C310C9424410DD97BD587E01341B953FFF00A942441A0BF6E2F8BE0134192AE0615099424410E5939398DE013418946CACB06942441B60AC8BF8DE01341B992934E04942441B4F2EEB58CE013418B8DC2DB0194244112F8B3358AE0134129A6B2B0FF932441C4ADC27D86E01341E032B903FE932441B3DD49EB81E0134129E6D3FEFC9324411CB6AEE64BE013414095A3BEF5932441D5D0AACDF8DF1341CB6618C5E9932441188B71B0F8DF1341BE52F1C0E9932441AE0F13B7AFDF134133FCBE87DF9324418EEAC65799DF134157356E6ED8932441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (11, '0102000020346C0000120000006A47C75799DF1341B9C26D6ED893244147238101C6DF13415C5A07D4DC932441079AA65E8FE0134137DA1F90F7932441B4AC705994E01341468EAAD1F7932441F70A583E99E0134143CF084BF7932441541CB8929DE01341825C6809F6932441240812EAA0E013414FE0442CF49324413481ABF0A2E01341460053E2F193244152E9C073A3E01341F0F6ED64EF9324414D6B7D66A2E01341CE477AF2EC932441CB853CE39FE01341203F4AC8EA932441668DF5289CE0134138499D1CE993244153CD119597E01341AF8C5019E8932441FF16EFB6CDDF134181DF174CCD9324419BD7FFB2CCDF1341539A132ECD932441B82CCC5383DF1341E7FCF3F4C5932441BAE0DA347FDF1341414C9FD2C59324419C3C00365FDF1341F010CDDAC6932441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (13, '0102000020346C000002000000651EFB355FDF13418ACCCCDAC6932441A4299C21DBDD13413F56459F90932441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (15, '0102000020346C00000A0000005B5A9A21DBDD1341B3BA439F90932441E1550570F9DD13412A39E07D5A9324417FC24376F9DD1341A18599725A932441EE43FB9A7EDE1341BFB4CE4B67922441464AC00590DE134138DB087D479224410B75776EB9DE134114EF9BDDFB9124419E85A5F6E0DE134185F0767DB5912441151AD87C39DF1341F3AFC5E5179124419FFB23CC43DF1341399A3E8B059124412124811644DF134183EF294E04912441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (16, '0102000020346C0000030000004EC9A6E489DB1341B02766B5C9912441B44A2710C8DB13410706A8F25991244186A5372CCFDB13411CDB8D924E912441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (18, '0102000020346C00000B000000F9F03A2CCFDB1341D5F48C924E9124419B91AFB32EDC1341ABA6AAB05B912441C7E4D5BF52DC13415384779F6091244143D4C0DF6ADC134174EAE40F64912441A75F7E110BDD13419B9F2AE67A9124416A29DF9A86DD13417B1E9F828C91244149466958EBDD13414C5D21DF9A912441EDF68969EBDD13414A4A8DE19A9124414F6EF7D01DDE1341E93DC3F2A19124413688F33733DE134125E8FAF2A4912441CDF03BDABDDE1341103DF1D2B8912441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (20, '0102000020346C0000040000003CBE3DDABDDE1341ABDAF2D2B8912441CA8BFF9B9ADE134167268690F79124411E03CE949ADE1341CF5A7E9DF7912441E0E4D66875DE1341FB4DE87F3B922441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (22, '0102000020346C00000500000041B1D36875DE1341FF35E97F3B922441F832A280A1DB1341D8E1C700D6912441B09A6809A1DB13410B9CE256D59124413C2641499FDB1341ECF98493D39124418BAD3CBA9CDB134157D58914D2912441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (24, '0102000020346C000003000000820D39BA9CDB134107F68714D291244129B4673D8BDB1341FB36C418CA9124414EC9A6E489DB1341B02766B5C9912441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (26, '0102000020346C00000C00000063066581C6DE13417446786BA9912441BB5D56FE3BDE1341C5F1FB8F95912441C3135BE73BDE134165C7B98C9591244172E6DE7426DE1341F951E58A9291244167200316F4DD134127F3E27A8B912441D60208618FDD1341870C991F7D9124411339A7D713DD1341A78D24836B912441AFADE9A573DC134180D8DEAC54912441E01E1C715BDC1341023E773951912441770247475BDC134134399F33519124411E61662B37DC1341B199AB424C912441452ACA84D8DB134173D96D433F912441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (28, '0102000020346C000007000000CA50C884D8DB1341EE3D6C433F9124417941ECA70FDC1341BF681AF3D6902441B53497B50FDC1341C59186D8D69024414366E7DF1BDC1341A82EE683BE902441D3036E581CDC1341043C65CFBC902441EC06131B1DDC13415C0770E2AF9024412895B49A1CDC13414ED41BBEAD902441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (30, '0102000020346C0000020000006EC9B69A1CDC1341D9E41ABEAD902441FCE9296116DF13418662F2391B912441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (32, '0102000020346C0000020000004AB72B6116DF13415800F4391B912441143D6881C6DE1341F160776BA9912441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (35, '0102000020346C000003000000FE2A55081FDF1341268F75D20B912441BDB2572602DC1341864CE94A999024415189805400DC1341185CA40998902441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (37, '0102000020346C0000020000008083815400DC1341ECA7A309989024414AEDF7AA20DF1341BE0D32E908912441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (39, '0102000020346C0000020000008FBBF9AA20DF1341F8A933E9089124418E6158081FDF1341DAA974D20B912441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (41, '0102000020346C00000200000020773664A8DB1341ED790996E7912441A74789F56CDE1341450398EE4A922441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (43, '0102000020346C0000020000006C1A8BF56CDE1341A59F99EE4A9224413B941B0A64DE13415238B2385B922441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (45, '0102000020346C000006000000BE62180A64DE1341D21CB3385B922441C43476EEA2DB13414DFF232AF4912441A5430524A3DB1341B041A604F4912441A75BFAFDA4DB134106C0E651F2912441379C68F9A5DB13414347FC72F091244120773664A8DB1341ED790996E7912441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (46, '0102000020346C0000020000009869A2878ADB1341B4D68744019224416AF986965BDE13414B93E3A76A922441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (48, '0102000020346C0000030000000DCA88965BDE13412F33E5A76A922441836C239CDADD1341D61055335693244164C29950BCDD134101A4934F8C932441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (50, '0102000020346C000002000000088B9650BCDD13419A8B944F8C9324415CE7BE55C7DA1341720F295A22932441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (52, '0102000020346C0000030000008F17BD55C7DA1341AB73275A2293244194729EA664DB13410BDBE75908922441061DC7C076DB1341EC670A8205922441', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."RC_Sections" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (54, '0102000020346C0000040000006817CCC076DB1341C39F098205922441B57755677EDB13415A6F6B4E04922441BA97C10B81DB1341FE40D9C1039224419869A2878ADB1341B4D6874401922441', NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4428 (class 0 OID 222110)
-- Dependencies: 255
-- Data for Name: RC_Sections_merged; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (1, '0102000020346C0000050000006817CCC076DB1341C39F098205922441B57755677EDB13415A6F6B4E04922441BA97C10B81DB1341FE40D9C1039224419869A2878ADB1341B4D68744019224416AF986965BDE13414B93E3A76A922441', 'George Street', 2.8572009955502793, NULL, NULL, NULL, NULL, 1012, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (2, '0102000020346C000005000000820D39BA9CDB134107F68714D291244129B4673D8BDB1341FB36C418CA9124414EC9A6E489DB1341B02766B5C9912441B44A2710C8DB13410706A8F25991244186A5372CCFDB13411CDB8D924E912441', 'Hanover Street', 4.441107216115787, NULL, NULL, NULL, NULL, 1004, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (3, '0102000020346C00001D0000005B5A9A21DBDD1341B3BA439F90932441E1550570F9DD13412A39E07D5A9324417FC24376F9DD1341A18599725A932441EE43FB9A7EDE1341BFB4CE4B67922441464AC00590DE134138DB087D479224410B75776EB9DE134114EF9BDDFB9124419E85A5F6E0DE134185F0767DB5912441151AD87C39DF1341F3AFC5E5179124419FFB23CC43DF1341399A3E8B059124412124811644DF134183EF294E0491244145C8926144DF1341F7E81F110391244190AC1F6144DF13415C84FE0F039124411B67646144DF1341DF76D90E039124419C5926E443DF13413245CCD50191244185859A6743DF1341454EAD9C0091244143317A6643DF1341A2DCAB9B00912441D670066643DF134174888A9A00912441EEA26F2D42DF1341D9962984FF902441EC5877F540DF134162349C6DFE9024415E05C6F340DF134105E9D36CFE9024419A1EA5F240DF134174A0D26BFE90244126C14E1D3FDF13417CD75D93FD90244136AD73483DDF1341174CA6BAFC9024411CC55B463DDF134130C22ABAFC9024419CFFA9443DDF134186B462B9FC902441343C85003BDF1341EE440A34FC9024419372ACBC38DF1341CE495FAEFB9024411B037B00E1DB13417AD0BCFE829024413B2B497CDDDB1341A3047C6C7E902441', 'North St David Street', 4.438579087117239, NULL, NULL, NULL, NULL, 1005, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (4, '0102000020346C000007000000BE62180A64DE1341D21CB3385B922441C43476EEA2DB13414DFF232AF4912441A5430524A3DB1341B041A604F4912441A75BFAFDA4DB134106C0E651F2912441379C68F9A5DB13414347FC72F091244120773664A8DB1341ED790996E7912441A74789F56CDE1341450398EE4A922441', 'Hanover Street', 4.576861266390013, NULL, NULL, NULL, NULL, 1003, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (5, '0102000020346C00001000000006690585A8DA1341518CEE091E932441ABAFA9F12BD913414DD77BC4E8922441982EBFF826D91341958D657AE8922441BEE8571022D9134165AF9CF8E8922441202970B31DD913410766C632EA92244164895C4F1AD913416810220AEC922441B839163918D91341D1E38B50EE92244148A6E9A417D913415B2401CDF0922441E9E957A118D9134148C73441F39224412C57AB151BD9134117A7A86FF5922441EEAB62C41ED91341F576B221F7922441C152365123D91341CB9ED52CF8922441C909AD50AFDA1341D9B6EB9A2F932441BEC98B18C3DD1341B13D0DE09D9324412593FFA5C8DD1341AB3105A79E9324413249E2F156DF1341C29F0E50D6932441', 'Queen Street', 2.8686292958156994, NULL, NULL, NULL, NULL, 1001, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (6, '0102000020346C000018000000073083EEF5DB13416CD80620AC9024417BF96FFAFCDB1341FB040BD1B1902441C8360069FCDB1341E1F27679BB902441D1CFD6B0F0DB1341CEC0C9E9D2902441E92D728BB8DB134102A7B1223D9124417321FD3CB5DB1341C087066D429124410121BF71A9DB13411522D04B559124412638184DA9DB1341377DE289559124415C3739D66ADB134178AA1DD4C591244162F3036E58DB13414A52831BC6912441D3E7CA4D54DB13419F3E7171C6912441EB95217E50DB134135F43A4DC7912441E054988640DB134156886B3ECC91244175C27DED3BDB1341BC226365CE912441838499B82CDB1341194E690AD99124412E67F4A92ADB134159F43A03DB912441E7ECA0C529DB13410B540931DD912441B5E6564028DB13419A85595BE991244185BE808028DB13417D13C759EB9124415C5F9ABB29DB1341004C5740ED912441D18D452335DB13418E7DA76AF99124415000185237DB1341C9D98622FB912441B41C44E845DB13411948C8E803922441C99F0885A8DA1341A0A4ED091E932441', 'Hanover Street', 1.50837751680257, NULL, NULL, NULL, NULL, 1003, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (7, '0102000020346C0000030000008F17BD55C7DA1341AB73275A2293244194729EA664DB13410BDBE75908922441061DC7C076DB1341EC670A8205922441', 'Hanover Street', 4.440374610290515, NULL, NULL, NULL, NULL, 1003, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (8, '0102000020346C000002000000088B9650BCDD13419A8B944F8C9324415CE7BE55C7DA1341720F295A22932441', 'Queen Street', 6.01022194939148, NULL, NULL, NULL, NULL, 1001, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (9, '0102000020346C00000500000041B1D36875DE1341FF35E97F3B922441F832A280A1DB1341D8E1C700D6912441B09A6809A1DB13410B9CE256D59124413C2641499FDB1341ECF98493D39124418BAD3CBA9CDB134157D58914D2912441', 'George Street', 6.0097933251798175, NULL, NULL, NULL, NULL, 1013, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (10, '0102000020346C00000B000000F9F03A2CCFDB1341D5F48C924E9124419B91AFB32EDC1341ABA6AAB05B912441C7E4D5BF52DC13415384779F6091244143D4C0DF6ADC134174EAE40F64912441A75F7E110BDD13419B9F2AE67A9124416A29DF9A86DD13417B1E9F828C91244149466958EBDD13414C5D21DF9A912441EDF68969EBDD13414A4A8DE19A9124414F6EF7D01DDE1341E93DC3F2A19124413688F33733DE134125E8FAF2A4912441CDF03BDABDDE1341103DF1D2B8912441', 'Rose Street', 2.863845955938489, NULL, NULL, NULL, NULL, 1006, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (11, '0102000020346C000007000000CA50C884D8DB1341EE3D6C433F9124417941ECA70FDC1341BF681AF3D6902441B53497B50FDC1341C59186D8D69024414366E7DF1BDC1341A82EE683BE902441D3036E581CDC1341043C65CFBC902441EC06131B1DDC13415C0770E2AF9024412895B49A1CDC13414ED41BBEAD902441', 'Hanover Street', 4.454010784253946, NULL, NULL, NULL, NULL, 1004, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (12, '0102000020346C00000C00000063066581C6DE13417446786BA9912441BB5D56FE3BDE1341C5F1FB8F95912441C3135BE73BDE134165C7B98C9591244172E6DE7426DE1341F951E58A9291244167200316F4DD134127F3E27A8B912441D60208618FDD1341870C991F7D9124411339A7D713DD1341A78D24836B912441AFADE9A573DC134180D8DEAC54912441E01E1C715BDC1341023E773951912441770247475BDC134134399F33519124411E61662B37DC1341B199AB424C912441452ACA84D8DB134173D96D433F912441', 'Rose Street', 6.005438609528282, NULL, NULL, NULL, NULL, 1006, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (14, '0102000020346C000003000000FE2A55081FDF1341268F75D20B912441BDB2572602DC1341864CE94A999024415189805400DC1341185CA40998902441', 'Princes Street', 6.0032874466982875, NULL, NULL, NULL, NULL, 1007, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (13, '0102000020346C000019000000774A477CDDDB1341A593796C7E902441376F3056D9DB13416B43C20779902441AA8BD263EADB134136C22EF351902441BF86558205DC1341D750918428902441E4887F4D06DC1341475BEA0B26902441BCD9B78705DC1341A93ED69223902441DFA75A4403DC13411F564D572190244155451EBCFFDB134124C241911F9024410C008647FBDB13417975256D1E902441EC143856F6DB1341677490071E902441B0DB0F64F1DB1341FB4B746A1E9024419C0AFEECECDB1341E9E4228C1F902441A7E2E660E9DB13412F164150219024415149AE18E7DB1341D3388D8A23902441CFD979B9CBDB13412EE3005C4D9024411731724CCBDB1341ABFE71244E902441C2E6F90CB9DB134106A9E5F577902441B54BB6BAB8DB134171D453467A902441C960D9BFB9DB1341F805A7897C902441999FFE02C6DB13416CA48A7A8C902441BB9EBDF4C8DB13417E56694E9090244102510E61CCDB1341937BC0FD929024412C3ED7E2E0DB134165F6639C9D9024410C0A587AEBDB1341FF8264EAA4902441134780EEF5DB134115AD0420AC902441', 'Hanover Street', 1.2545101988832448, NULL, NULL, NULL, NULL, 1004, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (15, '0102000020346C0000020000008083815400DC1341ECA7A309989024414AEDF7AA20DF1341BE0D32E908912441', 'Princes Street', 2.8666709531343475, NULL, NULL, NULL, NULL, 1008, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (16, '0102000020346C0000020000006EC9B69A1CDC1341D9E41ABEAD902441FCE9296116DF13418662F2391B912441', 'Princes Street', 2.8616947931084944, NULL, NULL, NULL, NULL, 1007, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (17, '0102000020346C0000030000000DCA88965BDE13412F33E5A76A922441836C239CDADD1341D61055335693244164C29950BCDD134101A4934F8C932441', 'North St David Street', 1.3035582429769432, NULL, NULL, NULL, NULL, 1005, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (18, '0102000020346C000002000000651EFB355FDF13418ACCCCDAC6932441A4299C21DBDD13413F56459F90932441', 'Queen Street', 6.01064788933131, NULL, NULL, NULL, NULL, 1001, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (19, '0102000020346C0000020000006C1A8BF56CDE1341A59F99EE4A9224413B941B0A64DE13415238B2385B922441', 'North St David Street', 1.3035582429731, NULL, NULL, NULL, NULL, 1005, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (20, '0102000020346C0000040000003CBE3DDABDDE1341ABDAF2D2B8912441CA8BFF9B9ADE134167268690F79124411E03CE949ADE1341CF5A7E9DF7912441E0E4D66875DE1341FB4DE87F3B922441', 'North St David Street', 1.3035582429769432, NULL, NULL, NULL, NULL, 1005, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (21, '0102000020346C0000020000004AB72B6116DF13415800F4391B912441143D6881C6DE1341F160776BA9912441', 'North St David Street', 1.29698643353138, NULL, NULL, NULL, NULL, 1005, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (22, '0102000020346C0000020000008FBBF9AA20DF1341F8A933E9089124418E6158081FDF1341DAA974D20B912441', 'North St David Street', 1.29698643353138, NULL, NULL, NULL, NULL, 1005, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (23, '0102000020346C0000160000000602E7F156DF134117AD0F50D6932441B221AA8EA0DF1341AF34A6ABED932441EF634AD0A4DF1341AD90839EEE932441962F98FFEFDF13414D01FF26F9932441A247172E43E01341BFA5A22305942441404E6E7643E013415FA4B32D059424414D984C9F79E013413704C2720C942441EFFFB9997EE013410B5D09B60C942441490A5C7F83E013410AD11C310C9424410DD97BD587E01341B953FFF00A942441A0BF6E2F8BE0134192AE0615099424410E5939398DE013418946CACB06942441B60AC8BF8DE01341B992934E04942441B4F2EEB58CE013418B8DC2DB0194244112F8B3358AE0134129A6B2B0FF932441C4ADC27D86E01341E032B903FE932441B3DD49EB81E0134129E6D3FEFC9324411CB6AEE64BE013414095A3BEF5932441D5D0AACDF8DF1341CB6618C5E9932441188B71B0F8DF1341BE52F1C0E9932441AE0F13B7AFDF134133FCBE87DF9324418EEAC65799DF134157356E6ED8932441', 'York Place', 2.8793201172576524, NULL, NULL, NULL, NULL, 1014, 'NewTown', 'Edinburgh');
INSERT INTO "public"."RC_Sections_merged" ("gid", "geom", "RoadName", "Az", "StartStreet", "EndStreet", "SideOfStreet", "ESUID", "USRN", "Locality", "Town") VALUES (24, '0102000020346C0000120000006A47C75799DF1341B9C26D6ED893244147238101C6DF13415C5A07D4DC932441079AA65E8FE0134137DA1F90F7932441B4AC705994E01341468EAAD1F7932441F70A583E99E0134143CF084BF7932441541CB8929DE01341825C6809F6932441240812EAA0E013414FE0442CF49324413481ABF0A2E01341460053E2F193244152E9C073A3E01341F0F6ED64EF9324414D6B7D66A2E01341CE477AF2EC932441CB853CE39FE01341203F4AC8EA932441668DF5289CE0134138499D1CE993244153CD119597E01341AF8C5019E8932441FF16EFB6CDDF134181DF174CCD9324419BD7FFB2CCDF1341539A132ECD932441B82CCC5383DF1341E7FCF3F4C5932441BAE0DA347FDF1341414C9FD2C59324419C3C00365FDF1341F010CDDAC6932441', 'York Place', 6.023638138400166, NULL, NULL, NULL, NULL, 1002, 'NewTown', 'Edinburgh');


--
-- TOC entry 3974 (class 0 OID 221262)
-- Dependencies: 217
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4431 (class 0 OID 222120)
-- Dependencies: 258
-- Data for Name: Bays; Type: TABLE DATA; Schema: toms; Owner: postgres
--

INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('f0ce05a2-7b0e-410b-8556-05ecb0aa485e', 'B_ 000000020', '0102000020346C00000200000001920E4BC4DB1341759437603B932441E5DF1B92ECDB13416CC742E040932441', 10.44, 101, 24, 345, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, NULL, '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, -1, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('f071e490-9f42-4872-a064-a894927c6c4e', 'B_ 000000021', '0102000020346C0000020000002A5328AE00DC134119FE6D144E9324411535FCBE3ADC1341228EE52D56932441', 15.07, 103, 21, 344, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, 3, 15, 4, 3, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('dc0b1bfb-9532-48ea-8d90-85bddac2f17b', 'B_ 000000022', '0102000020346C0000020000001535FCBE3ADC1341228EE52D569324410652D4084EDC13412B739DE458932441', 5.01, 110, 21, 344, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, -1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('e6e923ce-6a61-4e6e-b856-db2f20e395e6', 'B_ 000000023', '0102000020346C00000200000049D8D8FE9ADC13413FFA2FD063932441034BB983C1DC13415214783469932441', 10, 105, 22, 344, NULL, NULL, NULL, NULL, 'Queen Street', '1001', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, -1, 39, 4, 3, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('4c5913dd-0412-439f-8c8b-7eecbcfee7a7', 'B_ 000000024', '0102000020346C000002000000034BB983C1DC13415214783469932441FED96C54E0DC1341C8C2B1846D932441', 8, 118, 25, 344, NULL, NULL, NULL, NULL, 'Queen Street', '1001', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', 10, -1, 1, NULL, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('c31f7cb7-e29d-4117-94b0-307ac280c192', 'B_ 000000025', '0102000020346C0000020000001586BD1B1ADD1341E4E91D9B75932441101571EC38DD13415A9857EB79932441', 8, 101, 23, 344, NULL, NULL, NULL, NULL, 'Queen Street', '1001', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, -1, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('0e213bb8-28b6-4e6b-a48a-954b40821b6c', 'B_ 000000026', '0102000020346C000002000000101571EC38DD13415A9857EB799324416D4EE12E4CDD134163A57B9D7C932441', 5, 110, 26, 344, NULL, NULL, NULL, NULL, 'Queen Street', '1001', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, -1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('b81c152e-0d1d-4ba0-bb96-320f02f4a18a', 'B_ 000000027', '0102000020346C00000400000032D69CDAEDDA134164CF70BE2793244119D3F748FFDA13413ADF45D722932441760C688B12DB134144EC69892593244182DEC6591CDB13411EAD97402E932441', 15, 114, 28, 344, NULL, NULL, NULL, NULL, 'Queen Street', '1001', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, -1, 15, NULL, 9, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('0f493e9b-5e4a-4854-892d-085840a437fc', 'B_ 000000029', '0102000020346C00000200000050D32ACD0EDE13410F19D16E5F9224412621CC03C2DD1341853FBE3554922441', 20, 107, 1, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, -1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('474b2ac4-5c10-4764-b25b-e9cda052aba6', 'B_ 000000030', '0102000020346C0000020000002621CC03C2DD1341853FBE355492244111C81C9F9BDD1341C0D234994E922441', 10, 119, 4, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, -1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('12cc30fe-cb33-4570-b228-f2402947bb5e', 'B_ 000000031', '0102000020346C00000200000011C81C9F9BDD1341C0D234994E922441FC6E6D3A75DD1341FB65ABFC48922441', 10, 115, 2, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, -1, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('2a5d0a0b-2c87-4257-9147-0bdeeb8af0d2', 'B_ 000000032', '0102000020346C000002000000FC6E6D3A75DD1341FB65ABFC48922441E715BED54EDD134136F9216043922441', 10, 116, 5, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', 190, -1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('9775d869-1cea-4098-9b2a-ce019afa458e', 'B_ 000000033', '0102000020346C000002000000BD635F0C02DD1341AD1F0F273892244113B66C55E3DC13414262D4A933922441', 8, 115, 6, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, -1, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('014d6fa9-0c7b-49f5-a9d1-5a4dbef9fad4', 'B_ 000000034', '0102000020346C00000200000013B66C55E3DC13414262D4A93392244174B065BEA9DC13411B3F063F2B922441', 15, 119, 3, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, -1, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('6500cbc0-5072-4a46-a130-6e79a214d896', 'B_ 000000035', '0102000020346C000005000000CBFC6A88C7DD1341F817CC58449224419CFD1396EDDD1341CD5A9DE849922441D5A1D4AEF6DD13419D1D51593A922441EE54232BD0DD1341D707ECF234922441CBFC6A88C7DD1341F817CC5844922441', 36.01, 116, 8, 343, NULL, NULL, NULL, NULL, 'Hanover Street', '1003', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'B', '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, -1, 1, NULL, NULL, NULL, 'C2', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('62b0bf76-1ad4-4afb-97b4-abf7bc32d05a', 'B_ 000000036', '0102000020346C0000020000009B77492FE7DD13418DE8663C3F93244153152B22FDDD1341C451FD2617932441', 20.78, 103, 21, 74, NULL, NULL, NULL, NULL, 'North St David Street', '1005', 325475.40475398174, 674195.2220350107, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:41:28.575475', 'tim.hancock', NULL, -1, 153, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('254bdb0f-cc6d-47fc-a4b5-14dc4d244c1d', 'B_ 000000037', '0102000020346C00000200000050D32ACD0EDE13410F19D16E5F9224419849A0382CDE13419D3F99BB63922441', 7.66, 114, 21, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, '2020-05-15', NULL, 'A', '2020-05-29 09:52:22.645068', 'tim.hancock', NULL, -1, 15, NULL, 9, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('59a25fd9-3b04-44bb-a77b-f5bb383be9ee', 'B_ 000000028', '0102000020346C0000040000003B941B0A64DE13415238B2385B9224416C1A8BF56CDE1341A59F99EE4A9224418A80DA7146DE1341AB4A3388459224410CEAB6713DDE1341626F9B9455922441', 26.78, 103, 28, 164, NULL, NULL, NULL, NULL, 'Hanover Street', '1003', NULL, NULL, NULL, NULL, '2020-05-01', '2020-05-20', 'B', '2020-05-29 14:24:37.835215', 'tim.hancock', NULL, -1, 16, 4, 10, 10, 'C2', NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4433 (class 0 OID 222130)
-- Dependencies: 260
-- Data for Name: ControlledParkingZones; Type: TABLE DATA; Schema: toms; Owner: postgres
--

INSERT INTO "toms"."ControlledParkingZones" ("RestrictionID", "GeometryID", "geom", "RestrictionTypeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "LabelText", "TimePeriodID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('{4e5323f1-659a-4758-80c4-8bb00ff1fd91}', 'C_ 000000004', '0103000020346C000001000000060000003EB8E6A0B3DA13411AD3BEE6279324413478C568C7DD1341F259E02B96932441339D5F2C6FDE134179B9FE2E65922441092AB0D088DB1341D771ABAEF8912441A0976E9257DB134150B81E05029224413EB8E6A0B3DA13411AD3BEE627932441', 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-23 15:20:40.146803', 'postgres', NULL, 15, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."ControlledParkingZones" ("RestrictionID", "GeometryID", "geom", "RestrictionTypeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "LabelText", "TimePeriodID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('{40eb51f6-f229-48d6-9efb-64900938a5e3}', 'C_ 000000005', '0103000020346C00000100000015000000339D5F2C6FDE134179B9FE2E6592244106FC6D152ADF13414580FDBB1591244115D0EB770CDC134148EA7D19A3902441AF1C773A03DC1341EDD475AAA7902441F344D81C0DDC134173753AA6AF902441DA41335A0CDC13411BAA2F93BC9024414C10E32F00DC1341380DD0E7D49024417AF98668F3DB1341A323DF14ED902441172B30ECC7DB1341DABE0D5A3F91244199ED8982C4DB1341A587E4CF4491244127ED4BB7B8DB1341FA21AEAE57912441A22F13A576DB13416652C974CE9124411DCD590172DB1341D84240B9CD912441A22F13A576DB13416652C974CE912441F707997380DB1341234C2F01D0912441344F6CF091DB1341A8ECF3FCD791244173499F2995DB13414191DC94DC9124412D6EDE8A99DB1341CB58A3D2E29124413DE0F71E96DB1341E60B465EEF912441092AB0D088DB1341D771ABAEF8912441339D5F2C6FDE134179B9FE2E65922441', 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'B', '2020-05-23 15:20:40.146803', 'postgres', NULL, 39, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4435 (class 0 OID 222139)
-- Dependencies: 262
-- Data for Name: Lines; Type: TABLE DATA; Schema: toms; Owner: postgres
--

INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('10901e3d-dc68-4dfc-a036-dbb930babcfb', 'L_ 000000009', '0102000020346C000002000000088B9650BCDD13419A8B944F8C9324416AF986965BDE13414B93E3A76A922441', 150.2, 224, 10, 74, NULL, NULL, NULL, NULL, 'North St David Street', '1005', NULL, NULL, NULL, NULL, NULL, NULL, 'A', '2020-05-24 22:42:01.112644', 'tim.hancock', 126, 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('ceb9e35c-0372-4cf0-ac38-f150eb200ea0', 'L_ 000000002', '0102000020346C000002000000542996A5E7DB1341E0E076914A9324412A5328AE00DC134119FE6D144E932441', 6.5, 202, 10, 344, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', 1, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('f32e4d66-0d7f-4dbc-a48c-c8c44dc1a191', 'L_ 000000003', '0102000020346C0000020000008CED0606BFDB134108FBC40545932441180846FC71DB1341E2C6343D3A932441', 20, 224, 10, 344, NULL, NULL, NULL, NULL, 'Queen Street', '1001', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', 14, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('c0e47ca6-6148-4a9d-8c33-f576b733ad32', 'L_ 000000004', '0102000020346C0000020000000652D4084EDC13412B739DE45893244149D8D8FE9ADC13413FFA2FD063932441', 20, 224, 10, 344, NULL, NULL, NULL, NULL, 'Queen Street', '1001', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', 15, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('a9d38e70-bc08-4f46-8497-71bdad52dad7', 'L_ 000000005', '0102000020346C000002000000180846FC71DB1341E2C6343D3A932441A42285F224DB1341BC92A4742F932441', 20, 209, 12, 344, NULL, NULL, NULL, NULL, 'Queen Street', '1001', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('a530ddfb-316a-40da-abfd-ba111d1c35b4', 'L_ 000000006', '0102000020346C000002000000FED96C54E0DC1341C8C2B1846D9324411586BD1B1ADD1341E4E91D9B75932441', 15, 202, 10, 344, NULL, NULL, NULL, NULL, 'Queen Street', '1001', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('5dd050cb-8bde-400d-8f03-fccbf492467a', 'L_ 000000008', '0102000020346C000002000000E715BED54EDD134136F9216043922441BD635F0C02DD1341AD1F0F2738922441', 20, 203, 12, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('dca8d05a-e437-473d-b95d-d50c792e1c97', 'L_ 000000010', '0102000020346C00000200000074B065BEA9DC13411B3F063F2B922441EA030E8C96DC1341B988C17028922441', 5, 214, 10, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-27 22:39:13.070947', 'tim.hancock', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('1bf6eef1-37f8-42b6-82b2-848f577146b6', 'L_ 000000011', '0102000020346C0000020000003A4E41B6E6DD1341E9F20B353F93244169AB00BAFCDD13411B0CD92B17932441', 20.76, 224, 10, 74, NULL, NULL, NULL, NULL, 'North St David Street', '1005', 325483.2716653942, 674188.8537149023, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-28 07:35:44.61791', 'tim.hancock', 211, 11, NULL, NULL, NULL, 325483.11919353675, 674191.4374914765, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('825fc78e-a8c7-4372-8993-462f37605c68', 'L_ 000000013', '0102000020346C000002000000088B9650BCDD13419A8B944F8C9324413A4E41B6E6DD1341E9F20B353F932441', 39.98, 224, 10, 74, NULL, NULL, NULL, NULL, 'North St David Street', '1005', 325459.9293151222, 674215.5959957276, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-28 07:38:36.157711', 'tim.hancock', 126, 11, NULL, NULL, NULL, 325460.57209681097, 674210.0364140678, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('ed8e2e61-3efb-4a89-86ff-4d4200e72803', 'L_ 000000012', '0102000020346C00000200000069AB00BAFCDD13411B0CD92B179324416AF986965BDE13414B93E3A76A922441', 89.46, 224, 10, 74, NULL, NULL, NULL, NULL, 'North St David Street', '1005', 325531.3759761611, 674158.4891387734, NULL, NULL, '2020-05-01', NULL, 'A', '2020-05-28 07:38:36.157711', 'tim.hancock', 126, 11, NULL, NULL, NULL, 325531.58157050796, 674153.4135325637, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('c7b3d64c-f42f-485d-969c-c52bad2e5fad', 'L_ 000000015', '0102000020346C0000020000000DCA88965BDE13412F33E5A76A9224419849A0382CDE13419D3F99BB63922441', 12.34, 202, 10, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, NULL, NULL, 'A', '2020-05-28 12:45:04.641037', 'tim.hancock', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('362db835-a235-49fa-8f90-2c37955fde39', 'L_ 000000007', '0102000020346C0000020000000DCA88965BDE13412F33E5A76A92244150D32ACD0EDE13410F19D16E5F922441', 20, 202, 10, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, '2020-05-01', '2020-05-15', 'A', '2020-05-29 09:52:22.645068', 'tim.hancock', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('d4cd82f8-2a72-4232-9a0c-a27392348174', 'L_ 000000016', '0102000020346C00000200000047C7F76A3FDE13412546DE89669224419849A0382CDE13419D3F99BB63922441', 5, 224, 10, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, '2020-05-15', NULL, 'A', '2020-05-29 09:52:22.645068', 'tim.hancock', 14, 211, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('af46bcf3-5758-4f84-85bf-7800a562c8ae', 'L_ 000000017', '0102000020346C0000020000000DCA88965BDE13412F33E5A76A92244147C7F76A3FDE13412546DE8966922441', 7.34, 202, 10, 163, NULL, NULL, NULL, NULL, 'George Street', '1012', NULL, NULL, NULL, NULL, '2020-05-15', NULL, 'A', '2020-05-29 09:52:22.645068', 'tim.hancock', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('a1a65fde-2217-434c-aa1d-54814642f447', 'L_ 000000018', '0102000020346C0000020000005CE7BE55C7DA1341720F295A2293244194729EA664DB13410BDBE75908922441', 146.38, 224, 10, 254, NULL, NULL, NULL, NULL, 'Hanover Street', '1003', NULL, NULL, NULL, NULL, NULL, NULL, 'A', '2020-05-29 22:50:34.159914', 'tim.hancock', 126, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4436 (class 0 OID 222146)
-- Dependencies: 263
-- Data for Name: MapGrid; Type: TABLE DATA; Schema: toms; Owner: toms_operator
--

INSERT INTO "toms"."MapGrid" ("id", "geom", "mapsheetname", "x_min", "x_max", "y_min", "y_max", "CurrRevisionNr", "LastRevisionDate") VALUES (1339, '0106000020346C000001000000010300000001000000050000000000000030E4134100000000C09424410000000070EA134100000000C09424410000000070EA134100000000CC9224410000000030E4134100000000CC9224410000000030E4134100000000C0942441', NULL, 325900, 326300, 674150, 674400, NULL, NULL);
INSERT INTO "toms"."MapGrid" ("id", "geom", "mapsheetname", "x_min", "x_max", "y_min", "y_max", "CurrRevisionNr", "LastRevisionDate") VALUES (1398, '0106000020346C000001000000010300000001000000050000000000000030E4134100000000CC9224410000000070EA134100000000CC9224410000000070EA134100000000D89024410000000030E4134100000000D89024410000000030E4134100000000CC922441', NULL, 325900, 326300, 673900, 674150, NULL, NULL);
INSERT INTO "toms"."MapGrid" ("id", "geom", "mapsheetname", "x_min", "x_max", "y_min", "y_max", "CurrRevisionNr", "LastRevisionDate") VALUES (1455, '0106000020346C0000010000000103000000010000000500000000000000B0D7134100000000D890244100000000F0DD134100000000D890244100000000F0DD134100000000E48E244100000000B0D7134100000000E48E244100000000B0D7134100000000D8902441', NULL, 325100, 325500, 673650, 673900, NULL, NULL);
INSERT INTO "toms"."MapGrid" ("id", "geom", "mapsheetname", "x_min", "x_max", "y_min", "y_max", "CurrRevisionNr", "LastRevisionDate") VALUES (1456, '0106000020346C0000010000000103000000010000000500000000000000F0DD134100000000D89024410000000030E4134100000000D89024410000000030E4134100000000E48E244100000000F0DD134100000000E48E244100000000F0DD134100000000D8902441', NULL, 325500, 325900, 673650, 673900, NULL, NULL);
INSERT INTO "toms"."MapGrid" ("id", "geom", "mapsheetname", "x_min", "x_max", "y_min", "y_max", "CurrRevisionNr", "LastRevisionDate") VALUES (1337, '0106000020346C0000010000000103000000010000000500000000000000B0D7134100000000C094244100000000F0DD134100000000C094244100000000F0DD134100000000CC92244100000000B0D7134100000000CC92244100000000B0D7134100000000C0942441', NULL, 325100, 325500, 674150, 674400, 1, '2020-05-01');
INSERT INTO "toms"."MapGrid" ("id", "geom", "mapsheetname", "x_min", "x_max", "y_min", "y_max", "CurrRevisionNr", "LastRevisionDate") VALUES (1396, '0106000020346C0000010000000103000000010000000500000000000000B0D7134100000000CC92244100000000F0DD134100000000CC92244100000000F0DD134100000000D890244100000000B0D7134100000000D890244100000000B0D7134100000000CC922441', NULL, 325100, 325500, 673900, 674150, 1, '2020-05-01');
INSERT INTO "toms"."MapGrid" ("id", "geom", "mapsheetname", "x_min", "x_max", "y_min", "y_max", "CurrRevisionNr", "LastRevisionDate") VALUES (1338, '0106000020346C0000010000000103000000010000000500000000000000F0DD134100000000C09424410000000030E4134100000000C09424410000000030E4134100000000CC92244100000000F0DD134100000000CC92244100000000F0DD134100000000C0942441', NULL, 325500, 325900, 674150, 674400, 1, '2020-05-01');
INSERT INTO "toms"."MapGrid" ("id", "geom", "mapsheetname", "x_min", "x_max", "y_min", "y_max", "CurrRevisionNr", "LastRevisionDate") VALUES (1397, '0106000020346C0000010000000103000000010000000500000000000000F0DD134100000000CC9224410000000030E4134100000000CC9224410000000030E4134100000000D890244100000000F0DD134100000000D890244100000000F0DD134100000000CC922441', NULL, 325500, 325900, 673900, 674150, 3, '2020-05-20');


--
-- TOC entry 4438 (class 0 OID 222154)
-- Dependencies: 265
-- Data for Name: ParkingTariffAreas; Type: TABLE DATA; Schema: toms; Owner: postgres
--

INSERT INTO "toms"."ParkingTariffAreas" ("RestrictionID", "GeometryID", "geom", "RestrictionTypeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "ParkingTariffArea", "LastUpdateDateTime", "LastUpdatePerson", "LabelText", "TimePeriodID", "NoReturnID", "MaxStayID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('{ac017c0b-91f9-48d2-b571-8fae5139ec6a}', 'T_ 000000002', '0103000020346C000001000000050000008BA3249780DE1341F2DF386045922441BD1D345AC1DD1341BDC421902A922441BFB1BE7AAADD13418D336E6F48922441339D5F2C6FDE134179B9FE2E659224418BA3249780DE1341F2DF386045922441', 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'C2', '2020-05-23 17:55:42.89465', 'postgres', NULL, 16, 10, 10, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4440 (class 0 OID 222163)
-- Dependencies: 267
-- Data for Name: Proposals; Type: TABLE DATA; Schema: toms; Owner: postgres
--

INSERT INTO "toms"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (0, 2, '2020-05-21', NULL, '0 - No Proposal Shown', '2020-05-01');
INSERT INTO "toms"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (4, 2, '2020-05-21', NULL, 'Initial Creation', '2020-05-01');
INSERT INTO "toms"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (5, 2, '2020-05-28', NULL, 'Loading Bay / SYL', '2020-05-15');
INSERT INTO "toms"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (6, 2, '2020-05-29', NULL, 'Delete Bay', '2020-05-20');
INSERT INTO "toms"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (7, 1, '2020-05-29', NULL, 'Add line', '2020-05-27');


--
-- TOC entry 4441 (class 0 OID 222170)
-- Dependencies: 268
-- Data for Name: RestrictionLayers; Type: TABLE DATA; Schema: toms; Owner: postgres
--

INSERT INTO "toms"."RestrictionLayers" ("Code", "RestrictionLayerName") VALUES (2, 'Bays');
INSERT INTO "toms"."RestrictionLayers" ("Code", "RestrictionLayerName") VALUES (3, 'Lines');
INSERT INTO "toms"."RestrictionLayers" ("Code", "RestrictionLayerName") VALUES (5, 'Signs');
INSERT INTO "toms"."RestrictionLayers" ("Code", "RestrictionLayerName") VALUES (4, 'RestrictionPolygons');
INSERT INTO "toms"."RestrictionLayers" ("Code", "RestrictionLayerName") VALUES (6, 'CPZs');
INSERT INTO "toms"."RestrictionLayers" ("Code", "RestrictionLayerName") VALUES (7, 'ParkingTariffAreas');


--
-- TOC entry 4444 (class 0 OID 222177)
-- Dependencies: 271
-- Data for Name: RestrictionPolygons; Type: TABLE DATA; Schema: toms; Owner: postgres
--

INSERT INTO "toms"."RestrictionPolygons" ("RestrictionID", "GeometryID", "geom", "RestrictionTypeID", "GeomShapeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "LastUpdateDateTime", "LastUpdatePerson", "Orientation", "LabelText", "NoWaitingTimeID", "NoLoadingTimeID", "TimePeriodID", "AreaPermitCode", "CPZ", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes") VALUES ('b0f73006-62f1-4d63-b1b2-758eba0865bf', 'P_ 000000002', '0103000020346C0000010000000F00000063066581C6DE13417446786BA9912441BB5D56FE3BDE1341C5F1FB8F95912441C3135BE73BDE134165C7B98C9591244172E6DE7426DE1341F951E58A9291244167200316F4DD134127F3E27A8B912441D60208618FDD1341870C991F7D9124411339A7D713DD1341A78D24836B912441AFADE9A573DC134180D8DEAC54912441E01E1C715BDC1341023E773951912441770247475BDC134134399F33519124411E61662B37DC1341B199AB424C912441452ACA84D8DB134173D96D433F91244186A5372CCFDB13411CDB8D924E912441CDF03BDABDDE1341103DF1D2B891244163066581C6DE13417446786BA9912441', 3, 50, NULL, NULL, NULL, NULL, 'Rose Street', '1006', NULL, NULL, NULL, NULL, '2020-05-01', NULL, '2020-05-27 22:39:13.070947', 'tim.hancock', NULL, NULL, 126, 126, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4445 (class 0 OID 222184)
-- Dependencies: 272
-- Data for Name: RestrictionsInProposals; Type: TABLE DATA; Schema: toms; Owner: postgres
--

INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'f0ce05a2-7b0e-410b-8556-05ecb0aa485e');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'ceb9e35c-0372-4cf0-ac38-f150eb200ea0');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'f071e490-9f42-4872-a064-a894927c6c4e');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'dc0b1bfb-9532-48ea-8d90-85bddac2f17b');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'f32e4d66-0d7f-4dbc-a48c-c8c44dc1a191');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'c0e47ca6-6148-4a9d-8c33-f576b733ad32');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'a9d38e70-bc08-4f46-8497-71bdad52dad7');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'e6e923ce-6a61-4e6e-b856-db2f20e395e6');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '4c5913dd-0412-439f-8c8b-7eecbcfee7a7');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'a530ddfb-316a-40da-abfd-ba111d1c35b4');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'c31f7cb7-e29d-4117-94b0-307ac280c192');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '0e213bb8-28b6-4e6b-a48a-954b40821b6c');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'b81c152e-0d1d-4ba0-bb96-320f02f4a18a');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '59a25fd9-3b04-44bb-a77b-f5bb383be9ee');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, '362db835-a235-49fa-8f90-2c37955fde39');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '0f493e9b-5e4a-4854-892d-085840a437fc');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '474b2ac4-5c10-4764-b25b-e9cda052aba6');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '12cc30fe-cb33-4570-b228-f2402947bb5e');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '2a5d0a0b-2c87-4257-9147-0bdeeb8af0d2');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, '5dd050cb-8bde-400d-8f03-fccbf492467a');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '9775d869-1cea-4098-9b2a-ce019afa458e');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '014d6fa9-0c7b-49f5-a9d1-5a4dbef9fad4');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '6500cbc0-5072-4a46-a130-6e79a214d896');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'dca8d05a-e437-473d-b95d-d50c792e1c97');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '62b0bf76-1ad4-4afb-97b4-abf7bc32d05a');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, '1bf6eef1-37f8-42b6-82b2-848f577146b6');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'ed8e2e61-3efb-4a89-86ff-4d4200e72803');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, '825fc78e-a8c7-4372-8993-462f37605c68');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 4, 1, 'b0f73006-62f1-4d63-b1b2-758eba0865bf');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 5, 1, '194544db-37b3-4603-97e9-b93d372b3d66');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (5, 3, 2, '362db835-a235-49fa-8f90-2c37955fde39');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (5, 2, 1, '254bdb0f-cc6d-47fc-a4b5-14dc4d244c1d');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (5, 3, 1, 'd4cd82f8-2a72-4232-9a0c-a27392348174');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (5, 3, 1, 'af46bcf3-5758-4f84-85bf-7800a562c8ae');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (6, 2, 2, '59a25fd9-3b04-44bb-a77b-f5bb383be9ee');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (7, 3, 1, 'a1a65fde-2217-434c-aa1d-54814642f447');


--
-- TOC entry 4447 (class 0 OID 222189)
-- Dependencies: 274
-- Data for Name: Signs; Type: TABLE DATA; Schema: toms; Owner: postgres
--

INSERT INTO "toms"."Signs" ("RestrictionID", "GeometryID", "geom", "Photos_01", "Photos_02", "Photos_03", "Notes", "RoadName", "USRN", "OpenDate", "CloseDate", "LastUpdateDateTime", "LastUpdatePerson", "SignType_1", "SignType_2", "SignType_3", "SignType_4", "Photos_04", "SignOrientationTypeID", "Signs_Mount", "Signs_Attachment", "Compl_Signs_Faded", "Compl_Signs_Obscured", "Compl_Sign_Direction", "Compl_Signs_Obsolete", "Compl_Signs_OtherOptions", "Compl_Signs_TicketMachines", "TicketMachine_Nr", "RingoPresent", "SignIlluminationTypeID", "SignConditionTypeID", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "SignAddress", "original_geom_wkt") VALUES ('194544db-37b3-4603-97e9-b93d372b3d66', 'S_ 000000001', '0101000020346C0000029BD886F4DD1341E222517214932441', NULL, NULL, NULL, NULL, 'North St David Street', '1005', '2020-05-01', NULL, '2020-05-27 22:39:13.070947', 'tim.hancock', 26, 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4448 (class 0 OID 222196)
-- Dependencies: 275
-- Data for Name: TilesInAcceptedProposals; Type: TABLE DATA; Schema: toms; Owner: postgres
--

INSERT INTO "toms"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1337, 1);
INSERT INTO "toms"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1397, 1);
INSERT INTO "toms"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1396, 1);
INSERT INTO "toms"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1338, 1);
INSERT INTO "toms"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (5, 1397, 2);
INSERT INTO "toms"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (6, 1397, 3);


--
-- TOC entry 4449 (class 0 OID 222199)
-- Dependencies: 276
-- Data for Name: ActionOnProposalAcceptanceTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."ActionOnProposalAcceptanceTypes" ("Code", "Description") VALUES (1, 'Open');
INSERT INTO "toms_lookups"."ActionOnProposalAcceptanceTypes" ("Code", "Description") VALUES (2, 'Close');


--
-- TOC entry 4451 (class 0 OID 222207)
-- Dependencies: 278
-- Data for Name: AdditionalConditionTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--



--
-- TOC entry 4453 (class 0 OID 222212)
-- Dependencies: 280
-- Data for Name: BayLineTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (102, 'Business Permit Holder Bays');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (106, 'Ambulance Bays');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (107, 'Bus Stop');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (114, 'Loading Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (121, 'Taxi Rank');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (122, 'Bus Stand');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (126, 'Limited Waiting');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (127, 'Free Bays (No Limited Waiting)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (109, 'Buses Only Bays');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (130, 'Private Parking/Residents only Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (132, 'Red Route Doctors only');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (202, 'No Waiting At Any Time (DYL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (203, 'Zig Zag - School');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (204, 'Zig Zag - Fire');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (205, 'Zig Zag - Police');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (206, 'Zig Zag - Ambulance');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (207, 'Zig Zag - Hospital');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (208, 'Zig Zag - Yellow (other)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (209, 'Crossing - Zebra');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (210, 'Crossing - Pelican');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (211, 'Crossing - Toucan');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (212, 'Crossing - Puffin');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (213, 'Crossing - Equestrian');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (214, 'Crossing - Signalised');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (215, 'Crossing - Unmarked and no signals');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (219, 'Private Road');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (216, 'Unmarked Area (Acceptable)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (220, 'Unmarked Area (Unacceptable)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (231, 'Resident Permit Holders (zone)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (108, 'Car Club bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (115, 'Loading Bay/Disabled Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (128, 'Loading Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (129, 'Limited Waiting Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (110, 'Disabled Blue Badge');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (111, 'Disabled bay - personalised');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (112, 'Diplomatic Only Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (113, 'Doctor bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (116, 'Cycle Hire bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (123, 'Mobile Library bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (124, 'Electric Vehicle Charging Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (101, 'Resident Permit Holder Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (104, 'Resident/Business Permit Holder Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (119, 'On-Carriageway Bicycle Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (120, 'Police bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (103, 'Pay & Display/Pay by Phone Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (105, 'Shared Use Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (125, 'Other Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (117, 'Motorcycle Permit Holders bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (131, 'Permit Holder Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (218, 'No Stopping At Any Time (DRL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (201, 'No Waiting (Acceptable) (SYL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (217, 'No Stopping (Acceptable) (SRL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (221, 'No Waiting (Unacceptable) (SYL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (222, 'No Stopping (Unacceptable) (SRL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (118, 'Solo Motorcycle bay (Visitors)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (160, 'Disabled Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (161, 'Bus Stop (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (162, 'Bus Stand (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (163, 'Coach Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (164, 'Taxi Rank (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (165, 'Private Parking/Visitor Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (166, 'Private Parking/Disabled Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (167, 'Accessible Permit Holder Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (133, 'Shared Use (Business Permit Holders)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (134, 'Shared Use (Permit Holders)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (135, 'Shared Use (Residential Permit Holders)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (140, 'Loading Bay/Disabled Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (141, 'Loading Bay/Disabled Bay/Parking Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (142, 'Parking Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (143, 'Loading Bay/Parking Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (144, 'Rubbish Bin Bays');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (145, 'Disabled Blue Badge within Zone');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (223, 'Other Line');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (224, 'No waiting (SYL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (225, 'Unmarked kerb line');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (146, 'Keep Clear (Other) area');


--
-- TOC entry 4455 (class 0 OID 222217)
-- Dependencies: 282
-- Data for Name: BayTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (101, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (103, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (105, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (107, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (108, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (110, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (111, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (115, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (116, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (117, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (118, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (119, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (124, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (114, 'Polygon', NULL);


--
-- TOC entry 4457 (class 0 OID 222227)
-- Dependencies: 284
-- Data for Name: GeomShapeGroupType; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."GeomShapeGroupType" ("Code") VALUES ('LineString');
INSERT INTO "toms_lookups"."GeomShapeGroupType" ("Code") VALUES ('Polygon');


--
-- TOC entry 4458 (class 0 OID 222230)
-- Dependencies: 285
-- Data for Name: LengthOfTime; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (12, 'No restriction', NULL);
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (13, 'Other (please specify in notes)', NULL);
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (3, '2 hours', '2h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (4, '3 hours', '3h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (5, '4 hours', '4h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (6, '5 hours', '5h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (7, '5 minutes', '5m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (8, '10 minutes', '10m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (9, '20 minutes', '20m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (10, '30 minutes', '30m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (11, '40 minutes', '40m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (14, '6 hours', '6h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (15, '9 hours', '9h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (2, '90 minutes', '90m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (16, '45 minutes', '45m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (1, '60 minutes', '1h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (17, '10 hours', '10h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (18, '75 minutes', '75m');


--
-- TOC entry 4460 (class 0 OID 222238)
-- Dependencies: 287
-- Data for Name: LineTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (224, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (202, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (203, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (209, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (214, 'LineString', NULL);


--
-- TOC entry 4462 (class 0 OID 222248)
-- Dependencies: 289
-- Data for Name: PaymentTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."PaymentTypes" ("Code", "Description") VALUES (1, 'No Charge');
INSERT INTO "toms_lookups"."PaymentTypes" ("Code", "Description") VALUES (2, 'Pay and Display');
INSERT INTO "toms_lookups"."PaymentTypes" ("Code", "Description") VALUES (3, 'Pay by Phone (only)');
INSERT INTO "toms_lookups"."PaymentTypes" ("Code", "Description") VALUES (4, 'Pay and Display/Pay by Phone');


--
-- TOC entry 4464 (class 0 OID 222256)
-- Dependencies: 291
-- Data for Name: ProposalStatusTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."ProposalStatusTypes" ("Code", "Description") VALUES (1, 'In Preparation');
INSERT INTO "toms_lookups"."ProposalStatusTypes" ("Code", "Description") VALUES (2, 'Accepted');
INSERT INTO "toms_lookups"."ProposalStatusTypes" ("Code", "Description") VALUES (3, 'Rejected');


--
-- TOC entry 4466 (class 0 OID 222264)
-- Dependencies: 293
-- Data for Name: RestrictionGeomShapeTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (7, 'Other (please specify in notes)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (21, 'Parallel Bay (Polygon)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (24, 'Perpendicular Bay (Polygon)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (25, 'Echelon Bay (Polygon)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (28, 'Outline Bay (Polygon)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (35, 'Dropped Kerb (Crossover)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (50, 'Polygon');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (2, 'Half on/Half off Bay (LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (3, 'On Pavement Bay ((LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (4, 'Perpendicular Bay (LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (5, 'Echelon Bay (LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (1, 'Parallel Bay (LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (6, 'Perpendicular on Pavement Bay (LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (10, 'Parallel Line');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (11, 'Parallel Line with loading');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (12, 'Zig-Zag Line');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (8, 'Outline Bay (LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (22, 'Half on/Half off Bay (Polygon)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (23, 'On Pavement Bay (Polygon)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (26, 'Perpendicular on Pavement Bay (Polygon)');


--
-- TOC entry 4467 (class 0 OID 222270)
-- Dependencies: 294
-- Data for Name: RestrictionPolygonTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (1, 'Greenway');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (3, 'Pedestrian Area');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (4, 'Residential mews area');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (2, 'Permit Parking Areas');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (5, 'Pedestrian Area - occasional');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (6, 'Area under construction');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (20, 'Controlled Parking Zone');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (7, 'Lorry waiting restriction zone');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (8, 'Half-on/Half-off prohbited zone');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (22, 'Parking Tariff Area');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (21, 'Priority Parking Area');


--
-- TOC entry 4468 (class 0 OID 222276)
-- Dependencies: 295
-- Data for Name: RestrictionPolygonTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (1, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (3, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (4, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (2, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (5, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (6, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (20, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (7, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (8, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (21, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (22, 'Polygon', NULL);


--
-- TOC entry 4472 (class 0 OID 222293)
-- Dependencies: 299
-- Data for Name: SignOrientationTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (1, 'Facing in same direction as road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (2, 'Facing in opposite direction to road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (3, 'Facing road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (4, 'Facing away from road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (5, 'Other (specify azimuth)');


--
-- TOC entry 4474 (class 0 OID 222301)
-- Dependencies: 301
-- Data for Name: SignTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (12, 'Red Route/Greenway Disabled Bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (13, 'Red Route/Greenway Loading Bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (14, 'Red Route/Greenway Loading/Disabled Bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (15, 'Red Route/Greenway Loading/Parking Bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (16, 'Red Route/Greenway Parking Bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (25, 'Other (please specify)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (27, 'Pedestrian Zone');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (45, 'Business Permit Holder only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (46, 'Restricted Parking Zone');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (670, 'Max speed limit (other)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (47, 'Half on/Half off (end)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (49, 'Permit Parking Zone (PPZ) (end)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (17, 'Half on/Half off');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (67020, '20 MPH (Max)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (48, 'Half on/Half off zone (not allowed) (start)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (50, 'Half on/Half off zone (not allowed) (end)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (51, 'Car Park Tariff Board');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (67030, '30 MPH  (Max)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (52, 'Overnight Coach and Truck ban Zone start');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (53, 'Overnight Coach and Truck ban Zone end');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (3, 'Bus only bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (54, 'Private Estate sign');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (67040, '40 MPH (Max)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (67010, '10 MPH (Max)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (67005, '5 MPH (Max)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (675, 'End 20 MPH Zone - Start 30 MPH Max');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (55, 'Truck waiting ban zone start');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (56, 'Truck waiting ban zone end');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6634, 'Half on/Half off (not allowed)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (57, 'Truck waiting ban');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (642, 'Clearway');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (674, '20 MPH Zone');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (811, 'Priority over oncoming traffic');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (880, 'Speed zone reminder (with or without camera)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (67640, '40 MPH Zone');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (957, 'Separated track and path for cyclists and pedestrians ');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (36, 'Zig-Zag school keep clear');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (41, 'No Stopping - School');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6291, 'Width Restriction - Imperial');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6292, 'Width Restriction');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6294, 'Height Restriction');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (1, '5T trucks and buses');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (2, 'Ambulances only bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (4, 'Bus stops/Bus stands');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (5, 'Car club');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6, 'CPZ entry');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (7, 'CPZ exit');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (8, 'Disabled bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9, 'Doctor bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (10, 'Electric vehicles recharging point');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (11, 'Free parking bays (not Limited Waiting)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (618, 'Play Street');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6192, 'All Motorcycles Prohibited');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (19, 'Loading bay');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (610, 'Keep Left');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6061, 'Proceed in direction indicated - Right');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6062, 'Proceed in direction indicated - Left');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6063, 'Proceed in direction indicated - Straight');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (652, 'One Way - Arrow Only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6092, 'Turn Right Ahead');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6091, 'Turn Left Ahead');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (607, 'One Way - Words Only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (616, 'No entry');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (613, 'No Left Turn');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (612, 'No Right Turn');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (614, 'No U Turn');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (615, 'Priority to on-coming traffic');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9602, 'One-way traffic with contraflow pedal cycles');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9601, 'One-way traffic with contraflow cycle lane');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9541, 'Except buses');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9544, 'Except cycles');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (18, 'Limited waiting (no payment)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (20, 'Motorcycles only bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (21, 'No loading');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (22, 'No waiting');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (23, 'No waiting and no loading');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (24, 'On pavement parking');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (26, 'Pay and Display/Pay by Phone bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (28, 'Permit holders only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (29, 'Police bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (30, 'Private/Residents only bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (31, 'Residents permit holders only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (32, 'Shared use bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (33, 'Taxi ranks');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (34, 'Ticket machine');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (35, 'To be deleted');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (37, 'Pole only, no sign');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (43, 'Red Route Limited Waiting Bay');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (44, 'Restricted Parking Zone - entry');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (617, 'All Vehicles Prohibited');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (619, 'All Motor Vehicles Prohibited');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6262, 'Weak Bridge');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (955, 'Pedal Cycles Only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (956, 'Pedestrians and Cycles only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (953, 'Route used by Buses and Cycles only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6191, 'Motor Vehicles except solo motorcycles prohibited');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (521, 'Two Way Traffic');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (522, 'Two Way Traffic on crossing ahead');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9592, 'With flow cycle lane');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (810, 'One Way - Arrow and Words');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (952, 'All Buses Prohibited');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6111, 'Mini-roundabout');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9581, 'With flow bus lane ahead (with cycles and taxis)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9591, 'With flow bus lane (with cycles and taxis)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (951, 'All Cycles prohibited');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (401, 'Advisory Sign (see photo)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (201, 'Route Sign (see photo)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9621, 'Cycle lane at junction ahead');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (816, 'No Through Road');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (964, 'End of bus lane');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6101, 'Keep Right');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (620, 'Except for access');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6202, 'Except for loading');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (38, 'No stopping - Red Route/Greenway');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (39, 'Red Route/Greenway exit area');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (0, 'Missing');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (664, 'Zone ends');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (42, 'On Street NOT in TRO');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (40, 'Permit Parking Zone (PPZ) (start)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (62211, 'Weight restriction');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (64021, 'Overnight Coach and Truck ban');


--
-- TOC entry 4475 (class 0 OID 222307)
-- Dependencies: 302
-- Data for Name: SignTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (7);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (8);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (10);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (11);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (14);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (17);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (19);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (20);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (21);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (22);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (23);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (24);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (26);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (28);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (31);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (32);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (33);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (34);


--
-- TOC entry 4478 (class 0 OID 222319)
-- Dependencies: 305
-- Data for Name: TimePeriods; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (225, 'Jan-July 8.00pm-10.00am Aug 8.00pm-9.00am Sep-Nov 8.00pm-10.00am Dec 8.00pm-9.00am', 'Jan-July 8.00pm-10.00am;Aug 8.00pm-9.00am;Sep-Nov 8.00pm-10.00am;Dec 8.00pm-9.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (103, '6.30pm-7.00am', '6.30pm-7.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (102, '6.00pm-7.00am', '6.00pm-7.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (226, 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (111, 'At Any Time May-Sept', 'At Any Time May-Sept');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (217, 'Mon-Fri 8.00am-8.00pm', 'Mon-Fri 8.00am-8.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (219, 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm Fri 8.30am-9.15am 11.45am-1.15pm', 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm;Fri 8.30am-9.15am 11.45am-1.15pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (218, 'Mon-Fri 7.30am-9.00am', 'Mon-Fri 7.30am-9.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (222, 'Mon-Fri 8.30am-6.00pm', 'Mon-Fri 8.30am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (162, 'Mon-Sat 9.00am-5.30pm', 'Mon-Sat 9.00am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (163, 'Mon-Sun 10.30am-4.30pm', 'Mon-Sun 10.30am-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (169, 'Sat-Sun 10.00am-4.00pm', 'Sat-Sun 10.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (170, 'Sat-Sun 8.00am-6.00pm May-Sept', 'Sat-Sun 8.00am-6.00pm May-Sept');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (171, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (139, 'Mon-Fri 8.30am-4.30pm', 'Mon-Fri 8.30am-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (201, 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (221, 'Mon-Sat 8.00am-4.00pm', 'Mon-Sat 8.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (147, 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (133, 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (141, 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm', 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (12, 'Mon-Fri 8.30am-6.30pm', 'Mon-Fri 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (33, 'Mon-Sat 8.30am-6.30pm', 'Mon-Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (45, 'Mon-Sat 9.30am-6.30pm', 'Mon-Sat 9.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (19, 'Mon-Fri 9.00am-4.00pm', 'Mon-Fri 9.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (26, 'Mon-Sat 7.00am-6.30pm', 'Mon-Sat 7.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (83, 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (124, 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (118, 'Mon-Fri 7.30am-5.00pm', 'Mon-Fri 7.30am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (119, 'Mon-Fri 7.30am-6.30pm Sat-Sun 10.00am-5.30pm', 'Mon-Fri 7.30am-6.30pm;Sat-Sun 10.00am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (120, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (121, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (75, 'Mon-Fri 8.00am-4.00pm', 'Mon-Fri 8.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (14, 'Mon-Fri 8.00am-6.30pm', 'Mon-Fri 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (15, 'Mon-Fri 8.00am-6.00pm', 'Mon-Fri 8.00am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (101, '6.00am-10.00pm', '6.00am-10.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (78, 'Unknown - no sign', 'Unknown - no sign');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (10, 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (11, 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (16, 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (34, 'Mon-Sat 8.30am-6.30pm Sun 11.00am-5.00pm', 'Mon-Sat 8.30am-6.30pm;Sun 11.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (43, 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (97, 'Mon-Fri 8.30am-5.30pm', 'Mon-Fri 8.30am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (203, 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (204, 'Mon-Fri 9.30am-4pm Sat All day', 'Mon-Fri 9.30am-4pm;Sat All day');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (205, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (107, '8.00am-6.00pm', '8.00am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (108, '8.00am-6.00pm 2.15pm-4.00pm', '8.00am-6.00pm 2.15pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (126, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-1.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (127, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-Noon', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-Noon');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (128, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-12.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-12.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (129, 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm', 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (130, 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (131, 'Mon-Fri 8.00am-9.00am Mon-Thurs 2.30pm-3.45pm Fri Noon-1.30pm', 'Mon-Fri 8.00am-9.00am;Mon-Thurs 2.30pm-3.45pm;Fri Noon-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (132, 'Mon-Fri 8.00am-9.15am', 'Mon-Fri 8.00am-9.15am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (134, 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (135, 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (136, 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm', 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (137, 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (138, 'Mon-Fri 8.15am-5.30pm Sat 8.15am-1.30pm', 'Mon-Fri 8.15am-5.30pm;Sat 8.15am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (142, 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm', 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (140, 'Mon-Fri 8.30am-5.00pm', 'Mon-Fri 8.30am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (143, 'Mon-Fri 9.00am-5.00pm', 'Mon-Fri 9.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (144, 'Mon-Fri 9.00am-6.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.00am-6.00pm;Sat 9.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (145, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-1.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (146, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-5.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (148, 'Mon-Fri 9.15am-4.30pm', 'Mon-Fri 9.15am-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (156, 'Mon-Fri 9.30am-4.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 9.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (164, 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (212, 'Mon-Fri 8.00am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 8.00am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (125, 'Mon-Fri 8.00am-5.30pm', 'Mon-Fri 8.00am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (40, 'Mon-Sat 8.00am-6.00pm', 'Mon-Sat 8.00am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (123, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm Sat 8.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm;Sat 8.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (109, '8.15am-9.00am 11.30am-1.15pm', '8.15am-9.00am 11.30am-1.15pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (168, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.30am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.30am Noon-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (39, 'Mon-Sat 8.00am-6.30pm', 'Mon-Sat 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (228, 'Mon-Fri 9.30am-4.00pm', 'Mon-Fri 9.30am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (99, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (167, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (105, '7.30am-6.30pm', '7.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (106, '8.00am-5.30pm', '8.00am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (213, 'Mon-Sat 8.30am-5.30pm', 'Mon-Sat 8.30am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (110, '9.00am-5.30pm', '9.00am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (8, 'Mon-Fri 7.00am-7.00pm', 'Mon-Fri 7.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (149, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-1.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (150, 'Mon-Fri 9.15pm-8.00am', 'Mon-Fri 9.15pm-8.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (151, 'Mon-Fri 9.30am-11.00am', 'Mon-Fri 9.30am-11.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (152, 'Mon-Fri 9.30am-3.30pm', 'Mon-Fri 9.30am-3.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (153, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (154, 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am', 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (155, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (202, 'Mon-Sat 8.15am-6.00pm', 'Mon-Sat 8.15am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (115, 'Mon-Fri 11.30am-1.00pm', 'Mon-Fri 11.30am-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (122, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am;4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (157, 'Mon-Sat 7.00am-6.00pm', 'Mon-Sat 7.00am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (158, 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (160, 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (159, 'Mon-Sat 7.30am-6.30pm', 'Mon-Sat 7.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (161, 'Mon-Sat 8.30am-6.00pm', 'Mon-Sat 8.30am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (206, 'Sat 1.30pm-6.30pm', 'Sat 1.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (224, '7.00am-7.00pm', '7.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (1, 'At Any Time', 'At Any Time');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (210, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (211, 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (220, 'Mon-Sat 9.00am-6.00pm', 'Mon-Sat 9.00am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (227, 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (215, '8.00am-9.30am 4.00pm-6.00pm', '8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (216, 'Mon-Fri 7.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (166, 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm Fri 11.45am-1.15pm', 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm;Fri 11.45am-1.15pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (104, '7.00am-8.00pm', '7.00am-8.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (165, 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (98, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (112, 'Mon-Fri 1.30pm-3.00pm', 'Mon-Fri 1.30pm-3.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (113, 'Mon-Fri 10.00am-11.30am', 'Mon-Fri 10.00am-11.30am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (2, 'Mon-Fri 10.00am-3.30pm', 'Mon-Fri 10.00am-3.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (114, 'Mon-Fri 11.00am-12.30pm', 'Mon-Fri 11.00am-12.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (116, 'Mon-Fri 12.30pm-2.00pm', 'Mon-Fri 12.30pm-2.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (117, 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (207, '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm', '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (208, 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (209, '7.30am-9.30am 4.00pm-6.30pm', '7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (96, 'Mon-Fri 8.00am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.15am;4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (229, 'Mon-Sun 9.30am-4.00pm', 'Mon-Sun 9.30am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (230, 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ', 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (223, 'Mon-Sat 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.30am-9.30am; 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (231, 'Mon-Sun', 'Mon-Sun');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (232, '10.30am-11.00pm', '10.30am-11.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (234, '10.30am-10.00pm', '10.30am-10pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (235, 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm', 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (236, '7.00am-10.00am 4.00pm-6.30pm', '7.00am-10.00am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (237, 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm', 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (238, 'Mon-Sat 7.00am-8.00am', 'Mon-Sat 7.00am-8.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (239, 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (240, '8.30am-6.30pm', '8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (241, 'Mon-Fri 12 Noon-2.00pm', 'Mon-Fri 12 Noon-2.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (242, 'Mon-Fri 9.00am-10.00am', 'Mon-Fri 9.00am-10.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (243, 'Mon-Fri 11.00am-12 noon', 'Mon-Fri 11.00am-12 noon');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (244, 'Mon-Sat 9.00am-6.30pm', 'Mon-Sat 9.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (245, 'Mon-Fri 8.00am-5.00pm', 'Mon-Fri 8.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (246, '7.00am-midnight', '7.00am-midnight');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (247, 'Mon-Sun 7.00am-5.00pm', 'Mon-Sun 7.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (248, 'Mon-Fri 9.00am-11.00am', 'Mon-Fri 9.00am-11.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (249, 'Mon-Sat 9.00am-5.00pm', 'Mon-Sat 9.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (250, 'Mon-Fri 8.30am-1.30pm', 'Mon-Fri 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (251, 'Mon-Fri 7.00am-2.00pm', 'Mon-Fri 7.00am-2.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (252, 'Mon-Fri 9.00am-8.00pm Sat 9.00-5.00pm Sun 1.00pm-5.00pm', 'Mon-Fri 9.00am-8.00pm Sat 9.00-5.00pm Sun 1.00pm-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (253, 'Mon-Sat 7.00am-7.00pm', 'Mon-Sat 7.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (254, 'Mon-Fri 8.15am-9.15am 2.45pm-4.00pm', 'Mon-Fri 8.15am-9.15am 2.45pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (255, 'Mon-Sat 8.00am-midnight', 'Mon-Sat 8.00am-midnight');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (256, 'Mon-Fri 8.30am-7.00pm Sat 8.30am-6.30pm', 'Mon-Fri 8.30am-7.00pm Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (257, 'Mon-Fri 8.00am-7.00pm', 'Mon-Fri 8.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (258, 'Mon-Fri 8.30am-9.30am 3.30pm-4.30pm', 'Mon-Fri 8.30am-9.30am 3.30pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (259, 'Mon-Fri 7.30am-4.30pm', 'Mon-Fri 7.30am-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (260, 'Fri 7.00am-6.30pm Sat 7.00am-1.30pm', 'Fri 7.00am-6.30pm Sat 7.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (261, 'Mon-Fri 8.00am-10.00am', 'Mon-Fri 8.00am-10.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (262, 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm Sun 1.00pm-5.00pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm Sun 1.00pm-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (233, '10.30am-midnight midnight-6.30am', '10.30am-midnight, midnight-6.30am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (263, '10.00pm-5.00am', '10.00pm-5.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (264, 'Mon-Sat 8.00am-7.00pm', 'Mon-Sat 8.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (265, '9.00pm-midnight midnight-3.00am', '9.00pm-midnight midnight-3.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (266, 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (267, 'Mon-Fri 8.30am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 8.30am-6.30pm Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (268, 'Mon-Fri 8.30am-10.00pm Sat 8.30am-1.30pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (269, 'Mon-Fri 8.00am-7.00pm Sat 8.00am-1.30pm', 'Mon-Fri 8.00am-7.00pm Sat 8.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (270, 'Mon-Fri 7.00am-6.30pm Sat 8.30am-6.30pm', 'Mon-Fri 7.00am-6.30pm Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (271, 'Mon-Fri 8.30am-9.30am 2.30pm-4.30pm', 'Mon-Fri 8.30am-9.30am 2.30pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (272, 'Mon-Fri 7.00am-6.30pm Sat 7.00am-1.30pm', 'Mon-Fri 7.00am-6.30pm Sat 7.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (273, 'Mon-Fri 8.00am-9.00am 3.00pm-5.00pm', 'Mon-Fri 8.00am-9.00am 3.00pm-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (274, 'Mon-Fri 8.30am-10.00pm', 'Mon-Fri 8.30am-10.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (275, 'Mon-Fri 10.00am-4.00pm Sat 10.00am-1.30pm', 'Mon-Fri 10.00am-4.00pm Sat 10.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (276, 'Mon-Fri 8.30am-6.30pm and Sat 7.00am-3.00pm', 'Mon-Fri 8.30am-6.30pm and Sat 7.00am-3.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (278, 'Mon-Fri 8.00am-10.00am 4.00pm-6.30pm Sat 8.00am-10.00am', 'Mon-Fri 8.00am-10.00am 4.00pm-6.30pm Sat 8.00am-10.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (279, 'Sat 8.30am-6.30pm', 'Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (280, 'Mon-Fri 8.00am-9.00am 2.00pm-4.00pm', 'Mon-Fri 8.00am-9.00am 2.00pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (281, 'Mon-Fri 8.30am-9.30am 2.30pm-4.00pm', 'Mon-Fri 8.30am-9.30am 2.30pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (282, 'Mon-Thu 8.30am-6.30pm', 'Mon-Thu 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (283, 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm Sat 7.00am-1.30pm', 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm Sat 7.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (284, 'Fri 8.30am-6.30pm Sat 8.30am-1.30pm', 'Fri 8.30am-6.30pm Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (285, 'Mon-Fri 10.00am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 10.00am-6.30pm Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (286, 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm 7.30pm-8.00pm Sat 7.00am-1.30pm 7.30pm-8.00pm', 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm 7.30pm-8.00pm Sat 7.00am-1.30pm 7.30pm-8.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (287, 'Mon-Fri 7.30am-9.30am 3.00pm-6.00pm', 'Mon-Fri 7.30am-9.30am 3.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (290, 'Mon-Thu 8.30am-7.30pm Fri-Sat 8.30am-11.00pm Sun 10.00am-4.00pm', 'Mon-Thu 8.30am-7.30pm Fri-Sat 8.30am-11.00pm Sun 10.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (291, '8.00am-11.00pm', '8.00am-11.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (292, 'Mon-Fri 8.00am-9.30am 3.00pm-4.30pm', 'Mon-Fri 8.00am-9.30am 3.00pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (293, 'Mon-Fri 9.00am-5.30pm', 'Mon-Fri 9.00am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (294, 'Mon-Fri 10.00am-11.00am 2.00pm-3.00pm', 'Mon-Fri 10.00am-11.00am 2.00pm-3.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (296, 'Mon-Fri 1.00pm-2.00pm', 'Mon-Fri 1.00pm-2.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (297, 'Mon-Fri 12 noon-1.00pm', 'Mon-Fri 12 noon-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (298, 'Mon-Fri 10.00am-4.30pm', 'Mon-Fri 10.00am-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (0, NULL, NULL);
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (300, 'Mon-Sat 7.00am-10.00pm', 'Mon-Sat 7.00am-10.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (301, '6.30am-6.00pm', '6.30am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (302, 'Mon-Sat 6.00am-6.30pm', 'Mon-Sat 6.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (303, 'Mon-Fri 7.30am-9.30am 2.30pm-4.30pm', 'Mon-Fri 7.30am-9.30am 2.30pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (304, 'Mon-Fri 8.00am-9.00am 2.30pm-4.30pm term time only', 'Mon-Fri 8.00am-9.00am 2.30pm-4.30pm term time only');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (295, 'Mon-Fri 8.30am-4.00pm', 'Mon-Fri 8.30am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (306, 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (307, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (308, 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (309, 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (310, 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (311, 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (312, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (313, 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (314, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (315, 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (316, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (317, 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (318, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (328, '8.00am-7.00pm', '8.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (319, 'Sat-Sun & Bank Holidays 12 noon-6.00pm April-September', 'Sat-Sun & Bank Holidays 12 noon-6.00pm April-September');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (320, '8.00am-9.00pm', '8.00am-9.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (321, 'Mon-Fri 10.00am-12 noon 2.30pm-4.30pm', 'Mon-Fri 10.00am-12 noon 2.30pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (322, 'Mon-Sat 1.00pm-2.00pm', 'Mon-Sat 1.00pm-2.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (323, 'Mon-Fri 6.00am-5.00pm', 'Mon-Fri 6.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (324, 'Mon-Sun 8.00am-6.30pm', 'Mon-Sun 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (325, 'Mon-Fri 2.00pm-3.00pm', 'Mon-Fri 2.00pm-3.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (326, 'Mon-Fri 3.00pm-4.00pm', 'Mon-Fri 3.00pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (327, 'Mon-Sat 12 noon-1.00pm', 'Mon-Sat 12 noon-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (332, 'Mon-Sat 8.00am-9.30am 4.00pm-6.30pm', 'Mon-Sat 8.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (333, 'Mon-Fri 8.15am-9.15am 2.45pm-3.45pm', 'Mon-Fri 8.15am-9.15am 2.45pm-3.45pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (334, 'Mon-Fri 8.30am-9.15am 2.45pm-3.30pm', 'Mon-Fri 8.30am-9.15am 2.45pm-3.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (335, 'Mon-Sat 2.00pm-3.00pm', 'Mon-Sat 2.00pm-3.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (336, 'Mon-Fri 8.30am-9.30am 2.30pm-3.30pm', 'Mon-Fri 8.30am-9.30am 2.30pm-3.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (337, 'Mon-Fri 8.30am-9.30am 3.00pm-4.00pm', 'Mon-Fri 8.30am-9.30am 3.00pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (338, 'Mon-Fri 2.45pm-3.45pm', 'Mon-Fri 2.45pm-3.45pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (339, '8.30am-9.30am 2.30pm-3.30pm', '8.30am-9.30am 2.30pm-3.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (340, 'Mon-Fri 8.00am-9.30am 3.00pm-5.00pm', 'Mon-Fri 8.00am-9.30am 3.00pm-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (341, 'Mon-Fri 8.00am-6.30pm Sat 9.30am-12.30pm', 'Mon-Fri 8.00am-6.30pm Sat 9.30am-12.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (342, 'Mon-Fri Midnight-7.00am 8.00pm-Midnight Sat & Sun At Any Time', 'Mon-Fri Midnight-7.00am 8.00pm-Midnight Sat & Sun At Any Time');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (343, 'Mon-Fri 9.30am-4.30pm', 'Mon-Fri 9.30am-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (344, 'Mon-Sat 9.30am-5.30pm', 'Mon-Sat 9.30am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (345, 'Mon-Fri 10.30am-11.30am', 'Mon-Fri 10.30am-11.30am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (346, 'Mon-Fri 10.00am-4.00pm', 'Mon-Fri 10.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (347, 'Mon-Fri 7.00am-10.00am 4.00pm-7.00pm', 'Mon-Fri 7.00am-10.00am 4.00pm-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (348, 'Mon-Fri 8.15am-9.45am 3.00pm-4.30pm', 'Mon-Fri 8.15am-9.45am 3.00pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (349, 'Mon-Fri 6.30am-7.30am 9.30am-4.30pm 6.30pm-7.30pm', 'Mon-Fri 6.30am-7.30am 9.30am-4.30pm 6.30pm-7.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (288, 'Mon-Fri 10.00am-11.00am', 'Mon-Fri 10.00am-11.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (350, 'Mon-Fri 7.30am-9.30am 4.30pm-8.30pm', 'Mon-Fri 7.30am-9.30am 4.30pm-8.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (351, 'Mon-Fri 8.00am-9.30am 2.30pm-4.30pm', 'Mon-Fri 8.00am-9.30am 2.30pm-4.30pm');


--
-- TOC entry 4479 (class 0 OID 222325)
-- Dependencies: 306
-- Data for Name: TimePeriodsInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (10);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (11);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (14);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (15);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (16);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (33);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (39);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (40);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (43);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (1);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (153);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (126);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (212);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (211);


--
-- TOC entry 4482 (class 0 OID 222337)
-- Dependencies: 309
-- Data for Name: UnacceptableTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (2, 'Narrow Road');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (3, 'Obstruction');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (1, 'Crossover (vehicles)');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (4, 'Crossover (pedestrians/other)');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (5, 'Other');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (6, 'Corner');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (7, 'Garage frontage');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (8, 'Traffic flow');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (9, 'Edge of bay');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (10, 'Short section');


--
-- TOC entry 4484 (class 0 OID 222345)
-- Dependencies: 311
-- Data for Name: Corners; Type: TABLE DATA; Schema: topography; Owner: postgres
--

INSERT INTO "topography"."Corners" ("id", "geom") VALUES (1, '0101000020346C0000D93A487CDDDB134124CC7A6C7E902441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (2, '0101000020346C00007F47B49A1CDC134196881ABEAD902441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (3, '0101000020346C0000CACF81EEF5DB1341ECBB0520AC902441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (4, '0101000020346C0000EB6B2C6116DF1341C9BEF2391B912441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (5, '0101000020346C000073886781C6DE134180A2786BA9912441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (6, '0101000020346C000008A6C784D8DB1341FC806D433F912441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (7, '0101000020346C0000BC6C382CCFDB13415E9C8C924E912441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (8, '0101000020346C0000DD723EDABDDE13411C99F1D2B8912441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (9, '0101000020346C000066FB3ABA9CDB134180D78814D2912441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (10, '0101000020346C0000379AC9C076DB1341D7030A8205922441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (11, '0101000020346C0000CEE31A0A64DE1341847AB3385B922441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (12, '0101000020346C00007334D66875DE13412D90E97F3B922441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (13, '0101000020346C0000D9CA8BF56CDE1341735D98EE4A922441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (14, '0101000020346C00007A7A89965BDE1341FDF0E3A76A922441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (15, '0101000020346C0000EDAC57081FDF134169EB75D20B912441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (16, '0101000020346C00003070FAAA20DF1341696832E908912441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (17, '0101000020346C00009A007F5400DC1341414DA30998902441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (18, '0101000020346C00004EEC0785A8DA13415CE6EE091E932441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (19, '0101000020346C00001464BC55C7DA134167B5285A22932441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (20, '0101000020346C0000500E9950BCDD1341A5E5944F8C932441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (21, '0101000020346C000047A69921DBDD134157FC449F90932441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (22, '0101000020346C00008FCCE4F156DF1341AAF90E50D6932441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (23, '0101000020346C0000C2A1FD355FDF13417226CDDAC6932441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (24, '0101000020346C000017B5C45799DF1341EA816D6ED8932441');
INSERT INTO "topography"."Corners" ("id", "geom") VALUES (25, '0101000020346C0000D670066643DF134174888A9A00912441');


--
-- TOC entry 4488 (class 0 OID 222361)
-- Dependencies: 315
-- Data for Name: os_mastermap_topography_polygons; Type: TABLE DATA; Schema: topography; Owner: postgres
--



--
-- TOC entry 4486 (class 0 OID 222353)
-- Dependencies: 313
-- Data for Name: os_mastermap_topography_text; Type: TABLE DATA; Schema: topography; Owner: postgres
--



--
-- TOC entry 4490 (class 0 OID 222369)
-- Dependencies: 317
-- Data for Name: road_casement; Type: TABLE DATA; Schema: topography; Owner: postgres
--

INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (1, '0102000020346C0000050000006817CCC076DB1341C39F098205922441B57755677EDB13415A6F6B4E04922441BA97C10B81DB1341FE40D9C1039224419869A2878ADB1341B4D68744019224416AF986965BDE13414B93E3A76A922441', 'George Street', NULL, 1012, 'NewTown', 'Edinburgh', 2.8572009955502793, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (2, '0102000020346C000005000000820D39BA9CDB134107F68714D291244129B4673D8BDB1341FB36C418CA9124414EC9A6E489DB1341B02766B5C9912441B44A2710C8DB13410706A8F25991244186A5372CCFDB13411CDB8D924E912441', 'Hanover Street', NULL, 1004, 'NewTown', 'Edinburgh', 4.441107216115787, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (3, '0102000020346C00001D0000005B5A9A21DBDD1341B3BA439F90932441E1550570F9DD13412A39E07D5A9324417FC24376F9DD1341A18599725A932441EE43FB9A7EDE1341BFB4CE4B67922441464AC00590DE134138DB087D479224410B75776EB9DE134114EF9BDDFB9124419E85A5F6E0DE134185F0767DB5912441151AD87C39DF1341F3AFC5E5179124419FFB23CC43DF1341399A3E8B059124412124811644DF134183EF294E0491244145C8926144DF1341F7E81F110391244190AC1F6144DF13415C84FE0F039124411B67646144DF1341DF76D90E039124419C5926E443DF13413245CCD50191244185859A6743DF1341454EAD9C0091244143317A6643DF1341A2DCAB9B00912441D670066643DF134174888A9A00912441EEA26F2D42DF1341D9962984FF902441EC5877F540DF134162349C6DFE9024415E05C6F340DF134105E9D36CFE9024419A1EA5F240DF134174A0D26BFE90244126C14E1D3FDF13417CD75D93FD90244136AD73483DDF1341174CA6BAFC9024411CC55B463DDF134130C22ABAFC9024419CFFA9443DDF134186B462B9FC902441343C85003BDF1341EE440A34FC9024419372ACBC38DF1341CE495FAEFB9024411B037B00E1DB13417AD0BCFE829024413B2B497CDDDB1341A3047C6C7E902441', 'North St David Street', NULL, 1005, 'NewTown', 'Edinburgh', 4.438579087117239, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (4, '0102000020346C000007000000BE62180A64DE1341D21CB3385B922441C43476EEA2DB13414DFF232AF4912441A5430524A3DB1341B041A604F4912441A75BFAFDA4DB134106C0E651F2912441379C68F9A5DB13414347FC72F091244120773664A8DB1341ED790996E7912441A74789F56CDE1341450398EE4A922441', 'Hanover Street', NULL, 1003, 'NewTown', 'Edinburgh', 4.576861266390013, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (5, '0102000020346C00001000000006690585A8DA1341518CEE091E932441ABAFA9F12BD913414DD77BC4E8922441982EBFF826D91341958D657AE8922441BEE8571022D9134165AF9CF8E8922441202970B31DD913410766C632EA92244164895C4F1AD913416810220AEC922441B839163918D91341D1E38B50EE92244148A6E9A417D913415B2401CDF0922441E9E957A118D9134148C73441F39224412C57AB151BD9134117A7A86FF5922441EEAB62C41ED91341F576B221F7922441C152365123D91341CB9ED52CF8922441C909AD50AFDA1341D9B6EB9A2F932441BEC98B18C3DD1341B13D0DE09D9324412593FFA5C8DD1341AB3105A79E9324413249E2F156DF1341C29F0E50D6932441', 'Queen Street', NULL, 1001, 'NewTown', 'Edinburgh', 2.8686292958156994, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (6, '0102000020346C000018000000073083EEF5DB13416CD80620AC9024417BF96FFAFCDB1341FB040BD1B1902441C8360069FCDB1341E1F27679BB902441D1CFD6B0F0DB1341CEC0C9E9D2902441E92D728BB8DB134102A7B1223D9124417321FD3CB5DB1341C087066D429124410121BF71A9DB13411522D04B559124412638184DA9DB1341377DE289559124415C3739D66ADB134178AA1DD4C591244162F3036E58DB13414A52831BC6912441D3E7CA4D54DB13419F3E7171C6912441EB95217E50DB134135F43A4DC7912441E054988640DB134156886B3ECC91244175C27DED3BDB1341BC226365CE912441838499B82CDB1341194E690AD99124412E67F4A92ADB134159F43A03DB912441E7ECA0C529DB13410B540931DD912441B5E6564028DB13419A85595BE991244185BE808028DB13417D13C759EB9124415C5F9ABB29DB1341004C5740ED912441D18D452335DB13418E7DA76AF99124415000185237DB1341C9D98622FB912441B41C44E845DB13411948C8E803922441C99F0885A8DA1341A0A4ED091E932441', 'Hanover Street', NULL, 1003, 'NewTown', 'Edinburgh', 1.50837751680257, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (7, '0102000020346C0000030000008F17BD55C7DA1341AB73275A2293244194729EA664DB13410BDBE75908922441061DC7C076DB1341EC670A8205922441', 'Hanover Street', NULL, 1003, 'NewTown', 'Edinburgh', 4.440374610290515, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (9, '0102000020346C00000500000041B1D36875DE1341FF35E97F3B922441F832A280A1DB1341D8E1C700D6912441B09A6809A1DB13410B9CE256D59124413C2641499FDB1341ECF98493D39124418BAD3CBA9CDB134157D58914D2912441', 'George Street', NULL, 1013, 'NewTown', 'Edinburgh', 6.0097933251798175, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (10, '0102000020346C00000B000000F9F03A2CCFDB1341D5F48C924E9124419B91AFB32EDC1341ABA6AAB05B912441C7E4D5BF52DC13415384779F6091244143D4C0DF6ADC134174EAE40F64912441A75F7E110BDD13419B9F2AE67A9124416A29DF9A86DD13417B1E9F828C91244149466958EBDD13414C5D21DF9A912441EDF68969EBDD13414A4A8DE19A9124414F6EF7D01DDE1341E93DC3F2A19124413688F33733DE134125E8FAF2A4912441CDF03BDABDDE1341103DF1D2B8912441', 'Rose Street', NULL, 1006, 'NewTown', 'Edinburgh', 2.863845955938489, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (11, '0102000020346C000007000000CA50C884D8DB1341EE3D6C433F9124417941ECA70FDC1341BF681AF3D6902441B53497B50FDC1341C59186D8D69024414366E7DF1BDC1341A82EE683BE902441D3036E581CDC1341043C65CFBC902441EC06131B1DDC13415C0770E2AF9024412895B49A1CDC13414ED41BBEAD902441', 'Hanover Street', NULL, 1004, 'NewTown', 'Edinburgh', 4.454010784253946, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (12, '0102000020346C00000C00000063066581C6DE13417446786BA9912441BB5D56FE3BDE1341C5F1FB8F95912441C3135BE73BDE134165C7B98C9591244172E6DE7426DE1341F951E58A9291244167200316F4DD134127F3E27A8B912441D60208618FDD1341870C991F7D9124411339A7D713DD1341A78D24836B912441AFADE9A573DC134180D8DEAC54912441E01E1C715BDC1341023E773951912441770247475BDC134134399F33519124411E61662B37DC1341B199AB424C912441452ACA84D8DB134173D96D433F912441', 'Rose Street', NULL, 1006, 'NewTown', 'Edinburgh', 6.005438609528282, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (14, '0102000020346C000003000000FE2A55081FDF1341268F75D20B912441BDB2572602DC1341864CE94A999024415189805400DC1341185CA40998902441', 'Princes Street', NULL, 1007, 'NewTown', 'Edinburgh', 6.0032874466982875, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (13, '0102000020346C000019000000774A477CDDDB1341A593796C7E902441376F3056D9DB13416B43C20779902441AA8BD263EADB134136C22EF351902441BF86558205DC1341D750918428902441E4887F4D06DC1341475BEA0B26902441BCD9B78705DC1341A93ED69223902441DFA75A4403DC13411F564D572190244155451EBCFFDB134124C241911F9024410C008647FBDB13417975256D1E902441EC143856F6DB1341677490071E902441B0DB0F64F1DB1341FB4B746A1E9024419C0AFEECECDB1341E9E4228C1F902441A7E2E660E9DB13412F164150219024415149AE18E7DB1341D3388D8A23902441CFD979B9CBDB13412EE3005C4D9024411731724CCBDB1341ABFE71244E902441C2E6F90CB9DB134106A9E5F577902441B54BB6BAB8DB134171D453467A902441C960D9BFB9DB1341F805A7897C902441999FFE02C6DB13416CA48A7A8C902441BB9EBDF4C8DB13417E56694E9090244102510E61CCDB1341937BC0FD929024412C3ED7E2E0DB134165F6639C9D9024410C0A587AEBDB1341FF8264EAA4902441134780EEF5DB134115AD0420AC902441', 'Hanover Street', NULL, 1004, 'NewTown', 'Edinburgh', 1.2545101988832448, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (15, '0102000020346C0000020000008083815400DC1341ECA7A309989024414AEDF7AA20DF1341BE0D32E908912441', 'Princes Street', NULL, 1008, 'NewTown', 'Edinburgh', 2.8666709531343475, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (16, '0102000020346C0000020000006EC9B69A1CDC1341D9E41ABEAD902441FCE9296116DF13418662F2391B912441', 'Princes Street', NULL, 1007, 'NewTown', 'Edinburgh', 2.8616947931084944, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (17, '0102000020346C0000030000000DCA88965BDE13412F33E5A76A922441836C239CDADD1341D61055335693244164C29950BCDD134101A4934F8C932441', 'North St David Street', NULL, 1005, 'NewTown', 'Edinburgh', 1.3035582429769432, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (18, '0102000020346C000002000000651EFB355FDF13418ACCCCDAC6932441A4299C21DBDD13413F56459F90932441', 'Queen Street', NULL, 1001, 'NewTown', 'Edinburgh', 6.01064788933131, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (19, '0102000020346C0000020000006C1A8BF56CDE1341A59F99EE4A9224413B941B0A64DE13415238B2385B922441', 'North St David Street', NULL, 1005, 'NewTown', 'Edinburgh', 1.3035582429731, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (20, '0102000020346C0000040000003CBE3DDABDDE1341ABDAF2D2B8912441CA8BFF9B9ADE134167268690F79124411E03CE949ADE1341CF5A7E9DF7912441E0E4D66875DE1341FB4DE87F3B922441', 'North St David Street', NULL, 1005, 'NewTown', 'Edinburgh', 1.3035582429769432, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (21, '0102000020346C0000020000004AB72B6116DF13415800F4391B912441143D6881C6DE1341F160776BA9912441', 'North St David Street', NULL, 1005, 'NewTown', 'Edinburgh', 1.29698643353138, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (22, '0102000020346C0000020000008FBBF9AA20DF1341F8A933E9089124418E6158081FDF1341DAA974D20B912441', 'North St David Street', NULL, 1005, 'NewTown', 'Edinburgh', 1.29698643353138, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (23, '0102000020346C0000160000000602E7F156DF134117AD0F50D6932441B221AA8EA0DF1341AF34A6ABED932441EF634AD0A4DF1341AD90839EEE932441962F98FFEFDF13414D01FF26F9932441A247172E43E01341BFA5A22305942441404E6E7643E013415FA4B32D059424414D984C9F79E013413704C2720C942441EFFFB9997EE013410B5D09B60C942441490A5C7F83E013410AD11C310C9424410DD97BD587E01341B953FFF00A942441A0BF6E2F8BE0134192AE0615099424410E5939398DE013418946CACB06942441B60AC8BF8DE01341B992934E04942441B4F2EEB58CE013418B8DC2DB0194244112F8B3358AE0134129A6B2B0FF932441C4ADC27D86E01341E032B903FE932441B3DD49EB81E0134129E6D3FEFC9324411CB6AEE64BE013414095A3BEF5932441D5D0AACDF8DF1341CB6618C5E9932441188B71B0F8DF1341BE52F1C0E9932441AE0F13B7AFDF134133FCBE87DF9324418EEAC65799DF134157356E6ED8932441', 'York Place', NULL, 1014, 'NewTown', 'Edinburgh', 2.8793201172576524, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (24, '0102000020346C0000120000006A47C75799DF1341B9C26D6ED893244147238101C6DF13415C5A07D4DC932441079AA65E8FE0134137DA1F90F7932441B4AC705994E01341468EAAD1F7932441F70A583E99E0134143CF084BF7932441541CB8929DE01341825C6809F6932441240812EAA0E013414FE0442CF49324413481ABF0A2E01341460053E2F193244152E9C073A3E01341F0F6ED64EF9324414D6B7D66A2E01341CE477AF2EC932441CB853CE39FE01341203F4AC8EA932441668DF5289CE0134138499D1CE993244153CD119597E01341AF8C5019E8932441FF16EFB6CDDF134181DF174CCD9324419BD7FFB2CCDF1341539A132ECD932441B82CCC5383DF1341E7FCF3F4C5932441BAE0DA347FDF1341414C9FD2C59324419C3C00365FDF1341F010CDDAC6932441', 'York Place', NULL, 1002, 'NewTown', 'Edinburgh', 6.023638138400166, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (8, '0102000020346C00000A000000088B9650BCDD13419A8B944F8C932441542996A5E7DB1341E0E076914A93244158A5214AECDB134184BCB35A41932441E70ED0FAC3DB1341AC5BEEDE3B9324418CED0606BFDB134108FBC4054593244182DEC6591CDB13411EAD97402E932441760C688B12DB134144EC69892593244119D3F748FFDA13413ADF45D72293244132D69CDAEDDA134164CF70BE279324415CE7BE55C7DA1341720F295A22932441', 'Queen Street', NULL, 1001, 'NewTown', 'Edinburgh', 6.01022194939148, NULL, NULL, NULL);


--
-- TOC entry 4491 (class 0 OID 222375)
-- Dependencies: 318
-- Data for Name: LookupCodeTransfers_Bays; Type: TABLE DATA; Schema: transfer; Owner: postgres
--



--
-- TOC entry 4492 (class 0 OID 222381)
-- Dependencies: 319
-- Data for Name: LookupCodeTransfers_Lines; Type: TABLE DATA; Schema: transfer; Owner: postgres
--



--
-- TOC entry 4493 (class 0 OID 222387)
-- Dependencies: 320
-- Data for Name: RC_Polygon; Type: TABLE DATA; Schema: transfer; Owner: postgres
--

INSERT INTO "transfer"."RC_Polygon" ("id", "geom", "gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng") VALUES (1, '0106000020346C000001000000010300000007000000810000002124811644DF134183EF294E0491244145C8926144DF1341F7E81F110391244190AC1F6144DF13415C84FE0F039124411B67646144DF1341DF76D90E039124419C5926E443DF13413245CCD50191244185859A6743DF1341454EAD9C0091244143317A6643DF1341A2DCAB9B00912441D670066643DF134174888A9A00912441EEA26F2D42DF1341D9962984FF902441EC5877F540DF134162349C6DFE9024415E05C6F340DF134105E9D36CFE9024419A1EA5F240DF134174A0D26BFE90244126C14E1D3FDF13417CD75D93FD90244136AD73483DDF1341174CA6BAFC9024411CC55B463DDF134130C22ABAFC9024419CFFA9443DDF134186B462B9FC902441343C85003BDF1341EE440A34FC9024419372ACBC38DF1341CE495FAEFB9024411B037B00E1DB13417AD0BCFE82902441376F3056D9DB13416B43C20779902441AA8BD263EADB134136C22EF351902441BF86558205DC1341D750918428902441E4887F4D06DC1341475BEA0B26902441BCD9B78705DC1341A93ED69223902441DFA75A4403DC13411F564D572190244155451EBCFFDB134124C241911F9024410C008647FBDB13417975256D1E902441EC143856F6DB1341677490071E902441B0DB0F64F1DB1341FB4B746A1E9024419C0AFEECECDB1341E9E4228C1F902441A7E2E660E9DB13412F164150219024415149AE18E7DB1341D3388D8A23902441CFD979B9CBDB13412EE3005C4D9024411731724CCBDB1341ABFE71244E902441C2E6F90CB9DB134106A9E5F577902441B54BB6BAB8DB134171D453467A902441C960D9BFB9DB1341F805A7897C902441999FFE02C6DB13416CA48A7A8C902441BB9EBDF4C8DB13417E56694E9090244102510E61CCDB1341937BC0FD929024412C3ED7E2E0DB134165F6639C9D9024410C0A587AEBDB1341FF8264EAA4902441CACF81EEF5DB1341ECBB0520AC9024417BF96FFAFCDB1341FB040BD1B1902441C8360069FCDB1341E1F27679BB902441D1CFD6B0F0DB1341CEC0C9E9D2902441E92D728BB8DB134102A7B1223D9124417321FD3CB5DB1341C087066D429124410121BF71A9DB13411522D04B559124412638184DA9DB1341377DE289559124415C3739D66ADB134178AA1DD4C591244162F3036E58DB13414A52831BC6912441D3E7CA4D54DB13419F3E7171C6912441EB95217E50DB134135F43A4DC7912441E054988640DB134156886B3ECC91244175C27DED3BDB1341BC226365CE912441838499B82CDB1341194E690AD99124412E67F4A92ADB134159F43A03DB912441E7ECA0C529DB13410B540931DD912441B5E6564028DB13419A85595BE991244185BE808028DB13417D13C759EB9124415C5F9ABB29DB1341004C5740ED912441D18D452335DB13418E7DA76AF99124415000185237DB1341C9D98622FB912441B41C44E845DB13411948C8E8039224414EEC0785A8DA13415CE6EE091E932441ABAFA9F12BD913414DD77BC4E8922441982EBFF826D91341958D657AE8922441BEE8571022D9134165AF9CF8E8922441202970B31DD913410766C632EA92244164895C4F1AD913416810220AEC922441B839163918D91341D1E38B50EE92244148A6E9A417D913415B2401CDF0922441E9E957A118D9134148C73441F39224412C57AB151BD9134117A7A86FF5922441EEAB62C41ED91341F576B221F7922441C152365123D91341CB9ED52CF8922441C909AD50AFDA1341D9B6EB9A2F932441BEC98B18C3DD1341B13D0DE09D9324412593FFA5C8DD1341AB3105A79E9324418FCCE4F156DF1341AAF90E50D6932441B221AA8EA0DF1341AF34A6ABED932441EF634AD0A4DF1341AD90839EEE932441962F98FFEFDF13414D01FF26F9932441A247172E43E01341BFA5A22305942441404E6E7643E013415FA4B32D059424414D984C9F79E013413704C2720C942441EFFFB9997EE013410B5D09B60C942441490A5C7F83E013410AD11C310C9424410DD97BD587E01341B953FFF00A942441A0BF6E2F8BE0134192AE0615099424410E5939398DE013418946CACB06942441B60AC8BF8DE01341B992934E04942441B4F2EEB58CE013418B8DC2DB0194244112F8B3358AE0134129A6B2B0FF932441C4ADC27D86E01341E032B903FE932441B3DD49EB81E0134129E6D3FEFC9324411CB6AEE64BE013414095A3BEF5932441D5D0AACDF8DF1341CB6618C5E9932441188B71B0F8DF1341BE52F1C0E9932441AE0F13B7AFDF134133FCBE87DF93244117B5C45799DF1341EA816D6ED893244147238101C6DF13415C5A07D4DC932441079AA65E8FE0134137DA1F90F7932441B4AC705994E01341468EAAD1F7932441F70A583E99E0134143CF084BF7932441541CB8929DE01341825C6809F6932441240812EAA0E013414FE0442CF49324413481ABF0A2E01341460053E2F193244152E9C073A3E01341F0F6ED64EF9324414D6B7D66A2E01341CE477AF2EC932441CB853CE39FE01341203F4AC8EA932441668DF5289CE0134138499D1CE993244153CD119597E01341AF8C5019E8932441FF16EFB6CDDF134181DF174CCD9324419BD7FFB2CCDF1341539A132ECD932441B82CCC5383DF1341E7FCF3F4C5932441BAE0DA347FDF1341414C9FD2C5932441C2A1FD355FDF13417226CDDAC693244147A69921DBDD134157FC449F90932441E1550570F9DD13412A39E07D5A9324417FC24376F9DD1341A18599725A932441EE43FB9A7EDE1341BFB4CE4B67922441464AC00590DE134138DB087D479224410B75776EB9DE134114EF9BDDFB9124419E85A5F6E0DE134185F0767DB5912441151AD87C39DF1341F3AFC5E5179124419FFB23CC43DF1341399A3E8B059124412124811644DF134183EF294E04912441160000004EC9A6E489DB1341B02766B5C9912441B44A2710C8DB13410706A8F259912441BC6C382CCFDB13415E9C8C924E9124419B91AFB32EDC1341ABA6AAB05B912441C7E4D5BF52DC13415384779F6091244143D4C0DF6ADC134174EAE40F64912441A75F7E110BDD13419B9F2AE67A9124416A29DF9A86DD13417B1E9F828C91244149466958EBDD13414C5D21DF9A912441EDF68969EBDD13414A4A8DE19A9124414F6EF7D01DDE1341E93DC3F2A19124413688F33733DE134125E8FAF2A4912441DD723EDABDDE13411C99F1D2B8912441CA8BFF9B9ADE134167268690F79124411E03CE949ADE1341CF5A7E9DF79124417334D66875DE13412D90E97F3B922441F832A280A1DB1341D8E1C700D6912441B09A6809A1DB13410B9CE256D59124413C2641499FDB1341ECF98493D391244166FB3ABA9CDB134180D78814D291244129B4673D8BDB1341FB36C418CA9124414EC9A6E489DB1341B02766B5C99124411400000073886781C6DE134180A2786BA9912441BB5D56FE3BDE1341C5F1FB8F95912441C3135BE73BDE134165C7B98C9591244172E6DE7426DE1341F951E58A9291244167200316F4DD134127F3E27A8B912441D60208618FDD1341870C991F7D9124411339A7D713DD1341A78D24836B912441AFADE9A573DC134180D8DEAC54912441E01E1C715BDC1341023E773951912441770247475BDC134134399F33519124411E61662B37DC1341B199AB424C91244108A6C784D8DB1341FC806D433F9124417941ECA70FDC1341BF681AF3D6902441B53497B50FDC1341C59186D8D69024414366E7DF1BDC1341A82EE683BE902441D3036E581CDC1341043C65CFBC902441EC06131B1DDC13415C0770E2AF9024417F47B49A1CDC134196881ABEAD902441EB6B2C6116DF1341C9BEF2391B91244173886781C6DE134180A2786BA991244105000000EDAC57081FDF134169EB75D20B912441BDB2572602DC1341864CE94A999024419A007F5400DC1341414DA309989024413070FAAA20DF1341696832E908912441EDAC57081FDF134169EB75D20B9124410800000020773664A8DB1341ED790996E7912441D9CA8BF56CDE1341735D98EE4A922441CEE31A0A64DE1341847AB3385B922441C43476EEA2DB13414DFF232AF4912441A5430524A3DB1341B041A604F4912441A75BFAFDA4DB134106C0E651F2912441379C68F9A5DB13414347FC72F091244120773664A8DB1341ED790996E7912441090000009869A2878ADB1341B4D68744019224417A7A89965BDE1341FDF0E3A76A922441836C239CDADD1341D610553356932441500E9950BCDD1341A5E5944F8C9324411464BC55C7DA134167B5285A2293244194729EA664DB13410BDBE75908922441B57755677EDB13415A6F6B4E04922441BA97C10B81DB1341FE40D9C1039224419869A2878ADB1341B4D687440192244110000000776C1E045DDB13410A0F8DC7F8912441162ACD3D51DB13415B3651B2F1912441D7ADBA7148DB13417E5C1B50E8912441CB36816C49DB1341D914E779E09124418801A71954DB1341EE06B300D9912441301E12B05DDB13417196FF08D691244112C3B1C66FDB13418561D6C2D5912441920FA4D371DB13412D45B915D69124416240D54478DB13415B5A1F1AD79124416A80ED2C84DB1341C2DBA489DC912441F7FDA21086DB1341DEE1ED3ADF912441206E0D2B89DB1341B3C1F8A6E3912441097558CD86DB13415EA8E553EC91244144CCFE017EDB1341819ED77BF2912441A6846D7173DB13411A8ECA41F5912441776C1E045DDB13410A0F8DC7F8912441', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4535 (class 0 OID 0)
-- Dependencies: 222
-- Name: BayLinesFadedTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."BayLinesFadedTypes_Code_seq"', 1, false);


--
-- TOC entry 4536 (class 0 OID 0)
-- Dependencies: 224
-- Name: BaysLines_SignIssueTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."BaysLines_SignIssueTypes_Code_seq"', 1, false);


--
-- TOC entry 4537 (class 0 OID 0)
-- Dependencies: 226
-- Name: ConditionTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."ConditionTypes_Code_seq"', 1, false);


--
-- TOC entry 4538 (class 0 OID 0)
-- Dependencies: 228
-- Name: MHTC_CheckIssueType_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."MHTC_CheckIssueType_Code_seq"', 1, false);


--
-- TOC entry 4539 (class 0 OID 0)
-- Dependencies: 230
-- Name: MHTC_CheckStatus_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."MHTC_CheckStatus_Code_seq"', 1, false);


--
-- TOC entry 4540 (class 0 OID 0)
-- Dependencies: 233
-- Name: SignConditionTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignConditionTypes_Code_seq"', 1, false);


--
-- TOC entry 4541 (class 0 OID 0)
-- Dependencies: 235
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignFadedTypes_id_seq"', 8, true);


--
-- TOC entry 4542 (class 0 OID 0)
-- Dependencies: 237
-- Name: SignIlluminationTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignIlluminationTypes_Code_seq"', 1, false);


--
-- TOC entry 4543 (class 0 OID 0)
-- Dependencies: 239
-- Name: SignMountTypes_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignMountTypes_id_seq"', 7, true);


--
-- TOC entry 4544 (class 0 OID 0)
-- Dependencies: 241
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignObscurredTypes_id_seq"', 3, true);


--
-- TOC entry 4545 (class 0 OID 0)
-- Dependencies: 243
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."TicketMachineIssueTypes_id_seq"', 4, true);


--
-- TOC entry 4546 (class 0 OID 0)
-- Dependencies: 244
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."signAttachmentTypes2_id_seq"', 9, true);


--
-- TOC entry 4547 (class 0 OID 0)
-- Dependencies: 246
-- Name: edi_itn_roadcentreline_gid_seq; Type: SEQUENCE SET; Schema: highways_network; Owner: postgres
--

SELECT pg_catalog.setval('"highways_network"."edi_itn_roadcentreline_gid_seq"', 13, true);


--
-- TOC entry 4548 (class 0 OID 0)
-- Dependencies: 248
-- Name: SiteArea_id_seq; Type: SEQUENCE SET; Schema: local_authority; Owner: postgres
--

SELECT pg_catalog.setval('"local_authority"."SiteArea_id_seq"', 1, true);


--
-- TOC entry 4549 (class 0 OID 0)
-- Dependencies: 250
-- Name: StreetGazetteerRecords_id_seq; Type: SEQUENCE SET; Schema: local_authority; Owner: postgres
--

SELECT pg_catalog.setval('"local_authority"."StreetGazetteerRecords_id_seq"', 14, true);


--
-- TOC entry 4550 (class 0 OID 0)
-- Dependencies: 252
-- Name: RC_Polyline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RC_Polyline_id_seq"', 7, true);


--
-- TOC entry 4551 (class 0 OID 0)
-- Dependencies: 254
-- Name: RC_Sections_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RC_Sections_gid_seq"', 54, true);


--
-- TOC entry 4552 (class 0 OID 0)
-- Dependencies: 256
-- Name: RC_Sections_merged_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RC_Sections_merged_gid_seq"', 24, true);


--
-- TOC entry 4553 (class 0 OID 0)
-- Dependencies: 257
-- Name: Bays_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."Bays_id_seq"', 37, true);


--
-- TOC entry 4554 (class 0 OID 0)
-- Dependencies: 259
-- Name: ControlledParkingZones_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."ControlledParkingZones_id_seq"', 8, true);


--
-- TOC entry 4555 (class 0 OID 0)
-- Dependencies: 261
-- Name: Lines_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."Lines_id_seq"', 18, true);


--
-- TOC entry 4556 (class 0 OID 0)
-- Dependencies: 264
-- Name: ParkingTariffAreas_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."ParkingTariffAreas_id_seq"', 2, true);


--
-- TOC entry 4557 (class 0 OID 0)
-- Dependencies: 266
-- Name: Proposals_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."Proposals_id_seq"', 7, true);


--
-- TOC entry 4558 (class 0 OID 0)
-- Dependencies: 269
-- Name: RestrictionLayers_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."RestrictionLayers_id_seq"', 1, false);


--
-- TOC entry 4559 (class 0 OID 0)
-- Dependencies: 270
-- Name: RestrictionPolygons_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."RestrictionPolygons_id_seq"', 2, true);


--
-- TOC entry 4560 (class 0 OID 0)
-- Dependencies: 273
-- Name: Signs_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."Signs_id_seq"', 1, true);


--
-- TOC entry 4561 (class 0 OID 0)
-- Dependencies: 277
-- Name: ActionOnProposalAcceptanceTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq"', 1, true);


--
-- TOC entry 4562 (class 0 OID 0)
-- Dependencies: 279
-- Name: AdditionalConditionTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."AdditionalConditionTypes_Code_seq"', 1, false);


--
-- TOC entry 4563 (class 0 OID 0)
-- Dependencies: 281
-- Name: BayLineTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."BayLineTypes_Code_seq"', 1, false);


--
-- TOC entry 4564 (class 0 OID 0)
-- Dependencies: 286
-- Name: LengthOfTime_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."LengthOfTime_Code_seq"', 1, false);


--
-- TOC entry 4565 (class 0 OID 0)
-- Dependencies: 290
-- Name: PaymentTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."PaymentTypes_Code_seq"', 1, false);


--
-- TOC entry 4566 (class 0 OID 0)
-- Dependencies: 292
-- Name: ProposalStatusTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."ProposalStatusTypes_Code_seq"', 1, false);


--
-- TOC entry 4567 (class 0 OID 0)
-- Dependencies: 297
-- Name: RestrictionPolygonTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."RestrictionPolygonTypes_Code_seq"', 21, true);


--
-- TOC entry 4568 (class 0 OID 0)
-- Dependencies: 298
-- Name: RestrictionShapeTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."RestrictionShapeTypes_Code_seq"', 1, false);


--
-- TOC entry 4569 (class 0 OID 0)
-- Dependencies: 300
-- Name: SignOrientationTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."SignOrientationTypes_Code_seq"', 1, false);


--
-- TOC entry 4570 (class 0 OID 0)
-- Dependencies: 304
-- Name: SignTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."SignTypes_Code_seq"', 1, false);


--
-- TOC entry 4571 (class 0 OID 0)
-- Dependencies: 308
-- Name: TimePeriods_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."TimePeriods_Code_seq"', 1, false);


--
-- TOC entry 4572 (class 0 OID 0)
-- Dependencies: 310
-- Name: UnacceptableTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."UnacceptableTypes_Code_seq"', 1, false);


--
-- TOC entry 4573 (class 0 OID 0)
-- Dependencies: 312
-- Name: Corners_id_seq; Type: SEQUENCE SET; Schema: topography; Owner: postgres
--

SELECT pg_catalog.setval('"topography"."Corners_id_seq"', 25, true);


--
-- TOC entry 4574 (class 0 OID 0)
-- Dependencies: 314
-- Name: edi_cartotext_gid_seq; Type: SEQUENCE SET; Schema: topography; Owner: postgres
--

SELECT pg_catalog.setval('"topography"."edi_cartotext_gid_seq"', 1, false);


--
-- TOC entry 4575 (class 0 OID 0)
-- Dependencies: 316
-- Name: edi_mm_gid_seq; Type: SEQUENCE SET; Schema: topography; Owner: postgres
--

SELECT pg_catalog.setval('"topography"."edi_mm_gid_seq"', 1, false);


--
-- TOC entry 4576 (class 0 OID 0)
-- Dependencies: 321
-- Name: RC_Polygon_id_seq; Type: SEQUENCE SET; Schema: transfer; Owner: postgres
--

SELECT pg_catalog.setval('"transfer"."RC_Polygon_id_seq"', 1, true);


--
-- TOC entry 4022 (class 2606 OID 222431)
-- Name: BaysLinesFadedTypes BayLinesFadedTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."BaysLinesFadedTypes"
    ADD CONSTRAINT "BayLinesFadedTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4024 (class 2606 OID 222433)
-- Name: BaysLines_SignIssueTypes BaysLines_SignIssueTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."BaysLines_SignIssueTypes"
    ADD CONSTRAINT "BaysLines_SignIssueTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4026 (class 2606 OID 222435)
-- Name: ConditionTypes ConditionTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."ConditionTypes"
    ADD CONSTRAINT "ConditionTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4028 (class 2606 OID 222437)
-- Name: MHTC_CheckIssueType MHTC_CheckIssueType_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."MHTC_CheckIssueType"
    ADD CONSTRAINT "MHTC_CheckIssueType_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4030 (class 2606 OID 222439)
-- Name: MHTC_CheckStatus MHTC_CheckStatus_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."MHTC_CheckStatus"
    ADD CONSTRAINT "MHTC_CheckStatus_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4032 (class 2606 OID 222441)
-- Name: SignAttachmentTypes SignAttachmentTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignAttachmentTypes"
    ADD CONSTRAINT "SignAttachmentTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4036 (class 2606 OID 222443)
-- Name: SignConditionTypes SignConditionTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignConditionTypes"
    ADD CONSTRAINT "SignConditionTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4038 (class 2606 OID 222445)
-- Name: SignFadedTypes SignFadedTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignFadedTypes"
    ADD CONSTRAINT "SignFadedTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4040 (class 2606 OID 222447)
-- Name: SignFadedTypes SignFadedTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignFadedTypes"
    ADD CONSTRAINT "SignFadedTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4042 (class 2606 OID 222449)
-- Name: SignIlluminationTypes SignIlluminationTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignIlluminationTypes"
    ADD CONSTRAINT "SignIlluminationTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4044 (class 2606 OID 222451)
-- Name: SignMountTypes SignMountTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignMountTypes"
    ADD CONSTRAINT "SignMountTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4046 (class 2606 OID 222453)
-- Name: SignMountTypes SignMounts_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignMountTypes"
    ADD CONSTRAINT "SignMounts_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4048 (class 2606 OID 222455)
-- Name: SignObscurredTypes SignObscurredTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignObscurredTypes"
    ADD CONSTRAINT "SignObscurredTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4050 (class 2606 OID 222457)
-- Name: SignObscurredTypes SignObscurredTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignObscurredTypes"
    ADD CONSTRAINT "SignObscurredTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4052 (class 2606 OID 222459)
-- Name: TicketMachineIssueTypes TicketMachineIssueTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."TicketMachineIssueTypes"
    ADD CONSTRAINT "TicketMachineIssueTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4054 (class 2606 OID 222461)
-- Name: TicketMachineIssueTypes TicketMachineIssueTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."TicketMachineIssueTypes"
    ADD CONSTRAINT "TicketMachineIssueTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4034 (class 2606 OID 222463)
-- Name: SignAttachmentTypes signAttachmentTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignAttachmentTypes"
    ADD CONSTRAINT "signAttachmentTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4057 (class 2606 OID 222465)
-- Name: itn_roadcentreline edi_itn_roadcentreline_pkey; Type: CONSTRAINT; Schema: highways_network; Owner: postgres
--

ALTER TABLE ONLY "highways_network"."itn_roadcentreline"
    ADD CONSTRAINT "edi_itn_roadcentreline_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4063 (class 2606 OID 222467)
-- Name: StreetGazetteerRecords gaz_usrn_pkey; Type: CONSTRAINT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."StreetGazetteerRecords"
    ADD CONSTRAINT "gaz_usrn_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4060 (class 2606 OID 222469)
-- Name: SiteArea test_area_pkey; Type: CONSTRAINT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."SiteArea"
    ADD CONSTRAINT "test_area_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4065 (class 2606 OID 222471)
-- Name: RC_Polyline RC_Polyline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Polyline"
    ADD CONSTRAINT "RC_Polyline_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4070 (class 2606 OID 222473)
-- Name: RC_Sections_merged RC_Sections_merged_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Sections_merged"
    ADD CONSTRAINT "RC_Sections_merged_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4067 (class 2606 OID 222475)
-- Name: RC_Sections RC_Sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Sections"
    ADD CONSTRAINT "RC_Sections_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4073 (class 2606 OID 222477)
-- Name: Bays Bays_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4075 (class 2606 OID 222479)
-- Name: Bays Bays_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4078 (class 2606 OID 222481)
-- Name: ControlledParkingZones ControlledParkingZones_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4080 (class 2606 OID 222483)
-- Name: ControlledParkingZones ControlledParkingZones_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4083 (class 2606 OID 222485)
-- Name: Lines Lines_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4085 (class 2606 OID 222487)
-- Name: Lines Lines_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4088 (class 2606 OID 222489)
-- Name: MapGrid MapGrid_pkey; Type: CONSTRAINT; Schema: toms; Owner: toms_operator
--

ALTER TABLE ONLY "toms"."MapGrid"
    ADD CONSTRAINT "MapGrid_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4091 (class 2606 OID 222491)
-- Name: ParkingTariffAreas ParkingTariffAreas_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4093 (class 2606 OID 222493)
-- Name: ParkingTariffAreas ParkingTariffAreas_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4096 (class 2606 OID 222495)
-- Name: Proposals Proposals_PK; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Proposals"
    ADD CONSTRAINT "Proposals_PK" PRIMARY KEY ("ProposalID");


--
-- TOC entry 4098 (class 2606 OID 222497)
-- Name: Proposals Proposals_ProposalTitle_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Proposals"
    ADD CONSTRAINT "Proposals_ProposalTitle_key" UNIQUE ("ProposalTitle");


--
-- TOC entry 4100 (class 2606 OID 222499)
-- Name: RestrictionLayers RestrictionLayers2_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers2_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4102 (class 2606 OID 222501)
-- Name: RestrictionLayers RestrictionLayers_id_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers_id_key" UNIQUE ("Code");


--
-- TOC entry 4104 (class 2606 OID 222503)
-- Name: RestrictionPolygons RestrictionPolygons_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionPolygons_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4109 (class 2606 OID 222505)
-- Name: RestrictionsInProposals RestrictionsInProposals_pk; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_pk" PRIMARY KEY ("ProposalID", "RestrictionTableID", "RestrictionID");


--
-- TOC entry 4106 (class 2606 OID 222507)
-- Name: RestrictionPolygons RestrictionsPolygons_pk; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_pk" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4111 (class 2606 OID 222509)
-- Name: Signs Signs_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4113 (class 2606 OID 222511)
-- Name: Signs Signs_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4116 (class 2606 OID 222513)
-- Name: TilesInAcceptedProposals TilesInAcceptedProposals_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_pkey" PRIMARY KEY ("ProposalID", "TileNr", "RevisionNr");


--
-- TOC entry 4118 (class 2606 OID 222515)
-- Name: ActionOnProposalAcceptanceTypes ActionOnProposalAcceptanceTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."ActionOnProposalAcceptanceTypes"
    ADD CONSTRAINT "ActionOnProposalAcceptanceTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4120 (class 2606 OID 222517)
-- Name: AdditionalConditionTypes AdditionalConditionTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."AdditionalConditionTypes"
    ADD CONSTRAINT "AdditionalConditionTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4122 (class 2606 OID 222519)
-- Name: BayLineTypes BayLineTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."BayLineTypes"
    ADD CONSTRAINT "BayLineTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4124 (class 2606 OID 222521)
-- Name: BayTypesInUse BayTypesInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."BayTypesInUse"
    ADD CONSTRAINT "BayTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4127 (class 2606 OID 222523)
-- Name: GeomShapeGroupType GeomShapeGroupType_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."GeomShapeGroupType"
    ADD CONSTRAINT "GeomShapeGroupType_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4129 (class 2606 OID 222525)
-- Name: LengthOfTime LengthOfTime_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."LengthOfTime"
    ADD CONSTRAINT "LengthOfTime_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4131 (class 2606 OID 222527)
-- Name: LineTypesInUse LineTypesInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."LineTypesInUse"
    ADD CONSTRAINT "LineTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4134 (class 2606 OID 222529)
-- Name: PaymentTypes PaymentTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."PaymentTypes"
    ADD CONSTRAINT "PaymentTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4136 (class 2606 OID 222531)
-- Name: ProposalStatusTypes ProposalStatusTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."ProposalStatusTypes"
    ADD CONSTRAINT "ProposalStatusTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4144 (class 2606 OID 222533)
-- Name: RestrictionPolygonTypesInUse RestrictionPolygonTypesInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionPolygonTypesInUse"
    ADD CONSTRAINT "RestrictionPolygonTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4142 (class 2606 OID 222535)
-- Name: RestrictionPolygonTypes RestrictionPolygonTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionPolygonTypes"
    ADD CONSTRAINT "RestrictionPolygonTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4138 (class 2606 OID 222537)
-- Name: RestrictionGeomShapeTypes RestrictionShapeTypes_Description_key; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionGeomShapeTypes"
    ADD CONSTRAINT "RestrictionShapeTypes_Description_key" UNIQUE ("Description");


--
-- TOC entry 4140 (class 2606 OID 222539)
-- Name: RestrictionGeomShapeTypes RestrictionShapeTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionGeomShapeTypes"
    ADD CONSTRAINT "RestrictionShapeTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4147 (class 2606 OID 222541)
-- Name: SignOrientationTypes SignOrientationTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignOrientationTypes"
    ADD CONSTRAINT "SignOrientationTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4151 (class 2606 OID 222543)
-- Name: SignTypesInUse SignTypesInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignTypesInUse"
    ADD CONSTRAINT "SignTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4149 (class 2606 OID 222545)
-- Name: SignTypes SignTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignTypes"
    ADD CONSTRAINT "SignTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4158 (class 2606 OID 222547)
-- Name: TimePeriodsInUse TimePeriodsInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."TimePeriodsInUse"
    ADD CONSTRAINT "TimePeriodsInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4154 (class 2606 OID 222549)
-- Name: TimePeriods TimePeriods_Description_key; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_Description_key" UNIQUE ("Description");


--
-- TOC entry 4156 (class 2606 OID 222551)
-- Name: TimePeriods TimePeriods_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4161 (class 2606 OID 222553)
-- Name: UnacceptableTypes UnacceptableTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."UnacceptableTypes"
    ADD CONSTRAINT "UnacceptableTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4163 (class 2606 OID 222555)
-- Name: Corners Corners_pkey; Type: CONSTRAINT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."Corners"
    ADD CONSTRAINT "Corners_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4166 (class 2606 OID 222557)
-- Name: os_mastermap_topography_text edi_cartotext_pkey; Type: CONSTRAINT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."os_mastermap_topography_text"
    ADD CONSTRAINT "edi_cartotext_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4169 (class 2606 OID 222559)
-- Name: os_mastermap_topography_polygons edi_mm_pkey; Type: CONSTRAINT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."os_mastermap_topography_polygons"
    ADD CONSTRAINT "edi_mm_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4171 (class 2606 OID 222561)
-- Name: road_casement road_casement_pkey; Type: CONSTRAINT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."road_casement"
    ADD CONSTRAINT "road_casement_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4173 (class 2606 OID 222563)
-- Name: LookupCodeTransfers_Bays LookupCodeTransfers_Bays_pkey; Type: CONSTRAINT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."LookupCodeTransfers_Bays"
    ADD CONSTRAINT "LookupCodeTransfers_Bays_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4175 (class 2606 OID 222565)
-- Name: LookupCodeTransfers_Lines LookupCodeTransfers_Lines_pkey; Type: CONSTRAINT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."LookupCodeTransfers_Lines"
    ADD CONSTRAINT "LookupCodeTransfers_Lines_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4177 (class 2606 OID 222567)
-- Name: RC_Polygon RC_Polygon_pkey; Type: CONSTRAINT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."RC_Polygon"
    ADD CONSTRAINT "RC_Polygon_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4055 (class 1259 OID 222568)
-- Name: edi_itn_roadcentreline_geom_idx; Type: INDEX; Schema: highways_network; Owner: postgres
--

CREATE INDEX "edi_itn_roadcentreline_geom_idx" ON "highways_network"."itn_roadcentreline" USING "gist" ("geom");


--
-- TOC entry 4061 (class 1259 OID 222569)
-- Name: gaz_usrn_geom_idx; Type: INDEX; Schema: local_authority; Owner: postgres
--

CREATE INDEX "gaz_usrn_geom_idx" ON "local_authority"."StreetGazetteerRecords" USING "gist" ("geom");


--
-- TOC entry 4058 (class 1259 OID 222570)
-- Name: test_area_geom_idx; Type: INDEX; Schema: local_authority; Owner: postgres
--

CREATE INDEX "test_area_geom_idx" ON "local_authority"."SiteArea" USING "gist" ("geom");


--
-- TOC entry 4068 (class 1259 OID 222571)
-- Name: sidx_RC_Sections_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_RC_Sections_geom" ON "public"."RC_Sections" USING "gist" ("geom");


--
-- TOC entry 4071 (class 1259 OID 222572)
-- Name: sidx_RC_Sections_merged_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_RC_Sections_merged_geom" ON "public"."RC_Sections_merged" USING "gist" ("geom");


--
-- TOC entry 4081 (class 1259 OID 222573)
-- Name: controlledparkingzones_geom_idx; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "controlledparkingzones_geom_idx" ON "toms"."ControlledParkingZones" USING "gist" ("geom");


--
-- TOC entry 4076 (class 1259 OID 222574)
-- Name: sidx_Bays_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_Bays_geom" ON "toms"."Bays" USING "gist" ("geom");


--
-- TOC entry 4086 (class 1259 OID 222575)
-- Name: sidx_Lines_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_Lines_geom" ON "toms"."Lines" USING "gist" ("geom");


--
-- TOC entry 4089 (class 1259 OID 222576)
-- Name: sidx_MapGrid_geom; Type: INDEX; Schema: toms; Owner: toms_operator
--

CREATE INDEX "sidx_MapGrid_geom" ON "toms"."MapGrid" USING "gist" ("geom");


--
-- TOC entry 4094 (class 1259 OID 222577)
-- Name: sidx_ParkingTariffAreas_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_ParkingTariffAreas_geom" ON "toms"."ParkingTariffAreas" USING "gist" ("geom");


--
-- TOC entry 4114 (class 1259 OID 222578)
-- Name: sidx_Signs_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_Signs_geom" ON "toms"."Signs" USING "gist" ("geom");


--
-- TOC entry 4107 (class 1259 OID 222579)
-- Name: sidx_restrictionPolygons_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_restrictionPolygons_geom" ON "toms"."RestrictionPolygons" USING "gist" ("geom");


--
-- TOC entry 4125 (class 1259 OID 222580)
-- Name: BayTypesInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "BayTypesInUse_View_key" ON "toms_lookups"."BayTypesInUse_View" USING "btree" ("Code");


--
-- TOC entry 4132 (class 1259 OID 222581)
-- Name: LineTypesInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "LineTypesInUse_View_key" ON "toms_lookups"."LineTypesInUse_View" USING "btree" ("Code");


--
-- TOC entry 4145 (class 1259 OID 222582)
-- Name: RestrictionPolygonTypesInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "RestrictionPolygonTypesInUse_View_key" ON "toms_lookups"."RestrictionPolygonTypesInUse_View" USING "btree" ("Code");


--
-- TOC entry 4152 (class 1259 OID 222583)
-- Name: SignTypesInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "SignTypesInUse_View_key" ON "toms_lookups"."SignTypesInUse_View" USING "btree" ("Code");


--
-- TOC entry 4159 (class 1259 OID 222584)
-- Name: TimePeriodsInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "TimePeriodsInUse_View_key" ON "toms_lookups"."TimePeriodsInUse_View" USING "btree" ("Code");


--
-- TOC entry 4164 (class 1259 OID 222585)
-- Name: edi_cartotext_geom_idx; Type: INDEX; Schema: topography; Owner: postgres
--

CREATE INDEX "edi_cartotext_geom_idx" ON "topography"."os_mastermap_topography_text" USING "gist" ("geom");


--
-- TOC entry 4167 (class 1259 OID 222586)
-- Name: edi_mm_geom_idx; Type: INDEX; Schema: topography; Owner: postgres
--

CREATE INDEX "edi_mm_geom_idx" ON "topography"."os_mastermap_topography_polygons" USING "gist" ("geom");


--
-- TOC entry 4240 (class 2620 OID 222587)
-- Name: Bays create_geometryid_bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_bays" BEFORE INSERT ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4244 (class 2620 OID 222588)
-- Name: Lines create_geometryid_lines; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_lines" BEFORE INSERT ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4248 (class 2620 OID 222589)
-- Name: RestrictionPolygons create_geometryid_restrictionpolygons; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_restrictionpolygons" BEFORE INSERT ON "toms"."RestrictionPolygons" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4250 (class 2620 OID 222590)
-- Name: Signs create_geometryid_signs; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_signs" BEFORE INSERT ON "toms"."Signs" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4241 (class 2620 OID 222591)
-- Name: Bays set_last_update_details_Bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_Bays" BEFORE INSERT OR UPDATE ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4243 (class 2620 OID 222592)
-- Name: ControlledParkingZones set_last_update_details_ControlledParkingZones; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_ControlledParkingZones" BEFORE INSERT OR UPDATE ON "toms"."ControlledParkingZones" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4245 (class 2620 OID 222593)
-- Name: Lines set_last_update_details_Lines; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_Lines" BEFORE INSERT OR UPDATE ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4247 (class 2620 OID 222594)
-- Name: ParkingTariffAreas set_last_update_details_ParkingTariffAreas; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_ParkingTariffAreas" BEFORE INSERT OR UPDATE ON "toms"."ParkingTariffAreas" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4249 (class 2620 OID 222595)
-- Name: RestrictionPolygons set_last_update_details_RestrictionPolygons; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_RestrictionPolygons" BEFORE INSERT OR UPDATE ON "toms"."RestrictionPolygons" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4251 (class 2620 OID 222596)
-- Name: Signs set_last_update_details_Signs; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_Signs" BEFORE INSERT OR UPDATE ON "toms"."Signs" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4242 (class 2620 OID 222597)
-- Name: Bays set_restriction_length_Bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_restriction_length_Bays" BEFORE INSERT OR UPDATE ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_restriction_length"();


--
-- TOC entry 4246 (class 2620 OID 222598)
-- Name: Lines set_restriction_length_Lines; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_restriction_length_Lines" BEFORE INSERT OR UPDATE ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_restriction_length"();


--
-- TOC entry 4178 (class 2606 OID 222599)
-- Name: Bays Bays_AdditionalConditionID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_AdditionalConditionID_fkey" FOREIGN KEY ("AdditionalConditionID") REFERENCES "toms_lookups"."AdditionalConditionTypes"("Code");


--
-- TOC entry 4179 (class 2606 OID 222604)
-- Name: Bays Bays_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."BaysLines_SignIssueTypes"("Code");


--
-- TOC entry 4180 (class 2606 OID 222609)
-- Name: Bays Bays_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."BaysLinesFadedTypes"("Code");


--
-- TOC entry 4181 (class 2606 OID 222614)
-- Name: Bays Bays_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "toms_lookups"."RestrictionGeomShapeTypes"("Code");


--
-- TOC entry 4182 (class 2606 OID 222619)
-- Name: Bays Bays_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueType"("Code");


--
-- TOC entry 4183 (class 2606 OID 222624)
-- Name: Bays Bays_MaxStayID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_MaxStayID_fkey" FOREIGN KEY ("MaxStayID") REFERENCES "toms_lookups"."LengthOfTime"("Code");


--
-- TOC entry 4184 (class 2606 OID 222629)
-- Name: Bays Bays_NoReturnID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_NoReturnID_fkey" FOREIGN KEY ("NoReturnID") REFERENCES "toms_lookups"."LengthOfTime"("Code");


--
-- TOC entry 4185 (class 2606 OID 222634)
-- Name: Bays Bays_PayTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_PayTypeID_fkey" FOREIGN KEY ("PayTypeID") REFERENCES "toms_lookups"."PaymentTypes"("Code");


--
-- TOC entry 4186 (class 2606 OID 222639)
-- Name: Bays Bays_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."BayTypesInUse"("Code");


--
-- TOC entry 4187 (class 2606 OID 222644)
-- Name: Bays Bays_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4188 (class 2606 OID 222649)
-- Name: ControlledParkingZones ControlledParkingZones_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."BaysLines_SignIssueTypes"("Code");


--
-- TOC entry 4189 (class 2606 OID 222654)
-- Name: ControlledParkingZones ControlledParkingZones_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."BaysLinesFadedTypes"("Code");


--
-- TOC entry 4190 (class 2606 OID 222659)
-- Name: ControlledParkingZones ControlledParkingZones_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueType"("Code");


--
-- TOC entry 4191 (class 2606 OID 222664)
-- Name: ControlledParkingZones ControlledParkingZones_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."RestrictionPolygonTypesInUse"("Code");


--
-- TOC entry 4192 (class 2606 OID 222669)
-- Name: ControlledParkingZones ControlledParkingZones_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4193 (class 2606 OID 222674)
-- Name: Lines Lines_AdditionalConditionID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_AdditionalConditionID_fkey" FOREIGN KEY ("AdditionalConditionID") REFERENCES "toms_lookups"."AdditionalConditionTypes"("Code");


--
-- TOC entry 4194 (class 2606 OID 222679)
-- Name: Lines Lines_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."BaysLines_SignIssueTypes"("Code");


--
-- TOC entry 4195 (class 2606 OID 222684)
-- Name: Lines Lines_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."BaysLinesFadedTypes"("Code");


--
-- TOC entry 4196 (class 2606 OID 222689)
-- Name: Lines Lines_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "toms_lookups"."RestrictionGeomShapeTypes"("Code");


--
-- TOC entry 4197 (class 2606 OID 222694)
-- Name: Lines Lines_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueType"("Code");


--
-- TOC entry 4198 (class 2606 OID 222699)
-- Name: Lines Lines_NoLoadingTimeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_NoLoadingTimeID_fkey" FOREIGN KEY ("NoLoadingTimeID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4199 (class 2606 OID 222704)
-- Name: Lines Lines_NoWaitingTimeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_NoWaitingTimeID_fkey" FOREIGN KEY ("NoWaitingTimeID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4200 (class 2606 OID 222709)
-- Name: Lines Lines_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."LineTypesInUse"("Code");


--
-- TOC entry 4201 (class 2606 OID 222714)
-- Name: Lines Lines_UnacceptableTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_UnacceptableTypeID_fkey" FOREIGN KEY ("UnacceptableTypeID") REFERENCES "toms_lookups"."UnacceptableTypes"("Code");


--
-- TOC entry 4202 (class 2606 OID 222719)
-- Name: ParkingTariffAreas ParkingTariffAreas_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."BaysLines_SignIssueTypes"("Code");


--
-- TOC entry 4203 (class 2606 OID 222724)
-- Name: ParkingTariffAreas ParkingTariffAreas_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."BaysLinesFadedTypes"("Code");


--
-- TOC entry 4204 (class 2606 OID 222729)
-- Name: ParkingTariffAreas ParkingTariffAreas_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueType"("Code");


--
-- TOC entry 4205 (class 2606 OID 222734)
-- Name: ParkingTariffAreas ParkingTariffAreas_MaxStayID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_MaxStayID_fkey" FOREIGN KEY ("MaxStayID") REFERENCES "toms_lookups"."LengthOfTime"("Code");


--
-- TOC entry 4206 (class 2606 OID 222739)
-- Name: ParkingTariffAreas ParkingTariffAreas_NoReturnID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_NoReturnID_fkey" FOREIGN KEY ("NoReturnID") REFERENCES "toms_lookups"."LengthOfTime"("Code");


--
-- TOC entry 4207 (class 2606 OID 222744)
-- Name: ParkingTariffAreas ParkingTariffAreas_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."RestrictionPolygonTypesInUse"("Code");


--
-- TOC entry 4208 (class 2606 OID 222749)
-- Name: ParkingTariffAreas ParkingTariffAreas_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4209 (class 2606 OID 222754)
-- Name: Proposals Proposals_ProposalStatusTypes_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Proposals"
    ADD CONSTRAINT "Proposals_ProposalStatusTypes_fkey" FOREIGN KEY ("ProposalStatusID") REFERENCES "toms_lookups"."ProposalStatusTypes"("Code");


--
-- TOC entry 4218 (class 2606 OID 222759)
-- Name: RestrictionsInProposals RestrictionsInProposals_ActionOnProposalAcceptance_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ActionOnProposalAcceptance_fkey" FOREIGN KEY ("ActionOnProposalAcceptance") REFERENCES "toms_lookups"."ActionOnProposalAcceptanceTypes"("Code");


--
-- TOC entry 4219 (class 2606 OID 222764)
-- Name: RestrictionsInProposals RestrictionsInProposals_ProposalID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ProposalID_fkey" FOREIGN KEY ("ProposalID") REFERENCES "toms"."Proposals"("ProposalID");


--
-- TOC entry 4220 (class 2606 OID 222769)
-- Name: RestrictionsInProposals RestrictionsInProposals_RestrictionTableID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_RestrictionTableID_fkey" FOREIGN KEY ("RestrictionTableID") REFERENCES "toms"."RestrictionLayers"("Code");


--
-- TOC entry 4210 (class 2606 OID 222774)
-- Name: RestrictionPolygons RestrictionsPolygons_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."BaysLines_SignIssueTypes"("Code");


--
-- TOC entry 4211 (class 2606 OID 222779)
-- Name: RestrictionPolygons RestrictionsPolygons_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."BaysLinesFadedTypes"("Code");


--
-- TOC entry 4212 (class 2606 OID 222784)
-- Name: RestrictionPolygons RestrictionsPolygons_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "toms_lookups"."RestrictionGeomShapeTypes"("Code");


--
-- TOC entry 4213 (class 2606 OID 222789)
-- Name: RestrictionPolygons RestrictionsPolygons_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueType"("Code");


--
-- TOC entry 4214 (class 2606 OID 222794)
-- Name: RestrictionPolygons RestrictionsPolygons_NoLoadingTimeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_NoLoadingTimeID_fkey" FOREIGN KEY ("NoLoadingTimeID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4215 (class 2606 OID 222799)
-- Name: RestrictionPolygons RestrictionsPolygons_NoWaitingTimeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_NoWaitingTimeID_fkey" FOREIGN KEY ("NoWaitingTimeID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4216 (class 2606 OID 222804)
-- Name: RestrictionPolygons RestrictionsPolygons_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."RestrictionPolygonTypesInUse"("Code");


--
-- TOC entry 4217 (class 2606 OID 222809)
-- Name: RestrictionPolygons RestrictionsPolygons_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4221 (class 2606 OID 222814)
-- Name: Signs Signs_Compl_Signs_Faded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Compl_Signs_Faded_fkey" FOREIGN KEY ("Compl_Signs_Faded") REFERENCES "compliance_lookups"."SignFadedTypes"("Code");


--
-- TOC entry 4222 (class 2606 OID 222819)
-- Name: Signs Signs_Compl_Signs_Obscured_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Compl_Signs_Obscured_fkey" FOREIGN KEY ("Compl_Signs_Obscured") REFERENCES "compliance_lookups"."SignObscurredTypes"("Code");


--
-- TOC entry 4223 (class 2606 OID 222824)
-- Name: Signs Signs_Compl_Signs_TicketMachines_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Compl_Signs_TicketMachines_fkey" FOREIGN KEY ("Compl_Signs_TicketMachines") REFERENCES "compliance_lookups"."TicketMachineIssueTypes"("Code");


--
-- TOC entry 4224 (class 2606 OID 222829)
-- Name: Signs Signs_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."BaysLines_SignIssueTypes"("Code");


--
-- TOC entry 4225 (class 2606 OID 222834)
-- Name: Signs Signs_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueType"("Code");


--
-- TOC entry 4226 (class 2606 OID 222839)
-- Name: Signs Signs_MHTC_SignIlluminationTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_MHTC_SignIlluminationTypeID_fkey" FOREIGN KEY ("SignIlluminationTypeID") REFERENCES "compliance_lookups"."SignIlluminationTypes"("Code");


--
-- TOC entry 4227 (class 2606 OID 222844)
-- Name: Signs Signs_SignConditionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignConditionTypeID_fkey" FOREIGN KEY ("SignConditionTypeID") REFERENCES "compliance_lookups"."SignConditionTypes"("Code");


--
-- TOC entry 4228 (class 2606 OID 222849)
-- Name: Signs Signs_SignOrientationTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignOrientationTypeID_fkey" FOREIGN KEY ("SignOrientationTypeID") REFERENCES "toms_lookups"."SignOrientationTypes"("Code");


--
-- TOC entry 4229 (class 2606 OID 222854)
-- Name: Signs Signs_SignTypes1_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignTypes1_fkey" FOREIGN KEY ("SignType_1") REFERENCES "toms_lookups"."SignTypesInUse"("Code");


--
-- TOC entry 4230 (class 2606 OID 222859)
-- Name: Signs Signs_SignTypes2_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignTypes2_fkey" FOREIGN KEY ("SignType_2") REFERENCES "toms_lookups"."SignTypesInUse"("Code");


--
-- TOC entry 4231 (class 2606 OID 222864)
-- Name: Signs Signs_SignTypes3_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignTypes3_fkey" FOREIGN KEY ("SignType_3") REFERENCES "toms_lookups"."SignTypesInUse"("Code");


--
-- TOC entry 4232 (class 2606 OID 222869)
-- Name: Signs Signs_SignTypes4_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignTypes4_fkey" FOREIGN KEY ("SignType_4") REFERENCES "toms_lookups"."SignTypesInUse"("Code");


--
-- TOC entry 4233 (class 2606 OID 222874)
-- Name: Signs Signs_Signs_Attachment_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Signs_Attachment_fkey" FOREIGN KEY ("Signs_Attachment") REFERENCES "compliance_lookups"."SignAttachmentTypes"("Code");


--
-- TOC entry 4234 (class 2606 OID 222879)
-- Name: Signs Signs_Signs_Mount_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Signs_Mount_fkey" FOREIGN KEY ("Signs_Mount") REFERENCES "compliance_lookups"."SignMountTypes"("Code");


--
-- TOC entry 4235 (class 2606 OID 222884)
-- Name: TilesInAcceptedProposals TilesInAcceptedProposals_ProposalID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_ProposalID_fkey" FOREIGN KEY ("ProposalID") REFERENCES "toms"."Proposals"("ProposalID");


--
-- TOC entry 4236 (class 2606 OID 222889)
-- Name: TilesInAcceptedProposals TilesInAcceptedProposals_TileNr_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_TileNr_fkey" FOREIGN KEY ("TileNr") REFERENCES "toms"."MapGrid"("id");


--
-- TOC entry 4237 (class 2606 OID 222894)
-- Name: BayTypesInUse BayTypesInUse_GeomShapeGroupType_fkey; Type: FK CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."BayTypesInUse"
    ADD CONSTRAINT "BayTypesInUse_GeomShapeGroupType_fkey" FOREIGN KEY ("GeomShapeGroupType") REFERENCES "toms_lookups"."GeomShapeGroupType"("Code");


--
-- TOC entry 4238 (class 2606 OID 222899)
-- Name: LineTypesInUse LineTypesInUse_GeomShapeGroupType_fkey; Type: FK CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."LineTypesInUse"
    ADD CONSTRAINT "LineTypesInUse_GeomShapeGroupType_fkey" FOREIGN KEY ("GeomShapeGroupType") REFERENCES "toms_lookups"."GeomShapeGroupType"("Code");


--
-- TOC entry 4239 (class 2606 OID 222904)
-- Name: RestrictionPolygonTypesInUse RestrictionPolygonTypesInUse_GeomShapeGroupType_fkey; Type: FK CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionPolygonTypesInUse"
    ADD CONSTRAINT "RestrictionPolygonTypesInUse_GeomShapeGroupType_fkey" FOREIGN KEY ("GeomShapeGroupType") REFERENCES "toms_lookups"."GeomShapeGroupType"("Code");


--
-- TOC entry 4388 (class 0 OID 222163)
-- Dependencies: 267
-- Name: Proposals; Type: ROW SECURITY; Schema: toms; Owner: postgres
--

ALTER TABLE "toms"."Proposals" ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4391 (class 3256 OID 222953)
-- Name: Proposals insertProposals; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "insertProposals" ON "toms"."Proposals" FOR INSERT TO "toms_operator" WITH CHECK (("ProposalStatusID" <> 2));


--
-- TOC entry 4393 (class 3256 OID 222955)
-- Name: Proposals insertProposals_admin; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "insertProposals_admin" ON "toms"."Proposals" FOR INSERT TO "toms_admin" WITH CHECK (("ProposalStatusID" <> 2));


--
-- TOC entry 4389 (class 3256 OID 222951)
-- Name: Proposals selectProposals; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "selectProposals" ON "toms"."Proposals" FOR SELECT USING (true);


--
-- TOC entry 4390 (class 3256 OID 222952)
-- Name: Proposals updateProposals; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "updateProposals" ON "toms"."Proposals" FOR UPDATE TO "toms_operator" USING (true) WITH CHECK (("ProposalStatusID" <> 2));


--
-- TOC entry 4392 (class 3256 OID 222954)
-- Name: Proposals updateProposals_admin; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "updateProposals_admin" ON "toms"."Proposals" FOR UPDATE TO "toms_admin" USING (true);


--
-- TOC entry 4456 (class 0 OID 222223)
-- Dependencies: 283 4496
-- Name: BayTypesInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."BayTypesInUse_View";


--
-- TOC entry 4461 (class 0 OID 222244)
-- Dependencies: 288 4496
-- Name: LineTypesInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."LineTypesInUse_View";


--
-- TOC entry 4469 (class 0 OID 222282)
-- Dependencies: 296 4496
-- Name: RestrictionPolygonTypesInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."RestrictionPolygonTypesInUse_View";


--
-- TOC entry 4476 (class 0 OID 222310)
-- Dependencies: 303 4496
-- Name: SignTypesInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."SignTypesInUse_View";


--
-- TOC entry 4480 (class 0 OID 222328)
-- Dependencies: 307 4496
-- Name: TimePeriodsInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."TimePeriodsInUse_View";


-- Completed on 2020-05-29 22:54:57

--
-- PostgreSQL database dump complete
--

