--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-05-24 22:45:58

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
-- TOC entry 14 (class 2615 OID 193240)
-- Name: addresses; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "addresses";


ALTER SCHEMA "addresses" OWNER TO "postgres";

--
-- TOC entry 23 (class 2615 OID 193038)
-- Name: compliance; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "compliance";


ALTER SCHEMA "compliance" OWNER TO "postgres";

--
-- TOC entry 12 (class 2615 OID 193039)
-- Name: compliance_lookups; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "compliance_lookups";


ALTER SCHEMA "compliance_lookups" OWNER TO "postgres";

--
-- TOC entry 20 (class 2615 OID 193032)
-- Name: highways_network; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "highways_network";


ALTER SCHEMA "highways_network" OWNER TO "postgres";

--
-- TOC entry 25 (class 2615 OID 193037)
-- Name: local_authority; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "local_authority";


ALTER SCHEMA "local_authority" OWNER TO "postgres";

--
-- TOC entry 22 (class 2615 OID 193034)
-- Name: toms; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "toms";


ALTER SCHEMA "toms" OWNER TO "postgres";

--
-- TOC entry 15 (class 2615 OID 193033)
-- Name: toms_lookups; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "toms_lookups";


ALTER SCHEMA "toms_lookups" OWNER TO "postgres";

--
-- TOC entry 18 (class 2615 OID 193031)
-- Name: topography; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "topography";


ALTER SCHEMA "topography" OWNER TO "postgres";

--
-- TOC entry 8 (class 2615 OID 193035)
-- Name: transfer; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "transfer";


ALTER SCHEMA "transfer" OWNER TO "postgres";

--
-- TOC entry 1796 (class 2612 OID 195377)
-- Name: plpython3u; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE "plpython3u";


ALTER PROCEDURAL LANGUAGE "plpython3u" OWNER TO "postgres";

--
-- TOC entry 5 (class 3079 OID 191182)
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "dblink" WITH SCHEMA "public";


--
-- TOC entry 4 (class 3079 OID 191228)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "postgis" WITH SCHEMA "public";


--
-- TOC entry 2 (class 3079 OID 193446)
-- Name: postgres_fdw; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "postgres_fdw" WITH SCHEMA "public";


--
-- TOC entry 3 (class 3079 OID 192230)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "public";


--
-- TOC entry 1080 (class 1255 OID 208285)
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
-- TOC entry 1079 (class 1255 OID 193541)
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
-- TOC entry 1078 (class 1255 OID 193540)
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
-- TOC entry 281 (class 1259 OID 193738)
-- Name: BaysLinesFadedTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."BaysLinesFadedTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."BaysLinesFadedTypes" OWNER TO "postgres";

--
-- TOC entry 280 (class 1259 OID 193736)
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
-- TOC entry 4406 (class 0 OID 0)
-- Dependencies: 280
-- Name: BayLinesFadedTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."BayLinesFadedTypes_Code_seq" OWNED BY "compliance_lookups"."BaysLinesFadedTypes"."Code";


--
-- TOC entry 283 (class 1259 OID 193903)
-- Name: BaysLines_SignIssueTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."BaysLines_SignIssueTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."BaysLines_SignIssueTypes" OWNER TO "postgres";

--
-- TOC entry 282 (class 1259 OID 193901)
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
-- TOC entry 4407 (class 0 OID 0)
-- Dependencies: 282
-- Name: BaysLines_SignIssueTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."BaysLines_SignIssueTypes_Code_seq" OWNED BY "compliance_lookups"."BaysLines_SignIssueTypes"."Code";


--
-- TOC entry 268 (class 1259 OID 193144)
-- Name: ConditionTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."ConditionTypes" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "compliance_lookups"."ConditionTypes" OWNER TO "postgres";

--
-- TOC entry 267 (class 1259 OID 193142)
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
-- TOC entry 4408 (class 0 OID 0)
-- Dependencies: 267
-- Name: ConditionTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."ConditionTypes_Code_seq" OWNED BY "compliance_lookups"."ConditionTypes"."Code";


--
-- TOC entry 276 (class 1259 OID 193210)
-- Name: MHTC_CheckIssueType; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."MHTC_CheckIssueType" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."MHTC_CheckIssueType" OWNER TO "postgres";

--
-- TOC entry 275 (class 1259 OID 193208)
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
-- TOC entry 4409 (class 0 OID 0)
-- Dependencies: 275
-- Name: MHTC_CheckIssueType_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."MHTC_CheckIssueType_Code_seq" OWNED BY "compliance_lookups"."MHTC_CheckIssueType"."Code";


--
-- TOC entry 278 (class 1259 OID 193221)
-- Name: MHTC_CheckStatus; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."MHTC_CheckStatus" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."MHTC_CheckStatus" OWNER TO "postgres";

--
-- TOC entry 277 (class 1259 OID 193219)
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
-- TOC entry 4410 (class 0 OID 0)
-- Dependencies: 277
-- Name: MHTC_CheckStatus_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."MHTC_CheckStatus_Code_seq" OWNED BY "compliance_lookups"."MHTC_CheckStatus"."Code";


--
-- TOC entry 236 (class 1259 OID 192483)
-- Name: SignAttachmentTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignAttachmentTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignAttachmentTypes" OWNER TO "postgres";

--
-- TOC entry 274 (class 1259 OID 193199)
-- Name: SignConditionTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignConditionTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignConditionTypes" OWNER TO "postgres";

--
-- TOC entry 273 (class 1259 OID 193197)
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
-- TOC entry 4411 (class 0 OID 0)
-- Dependencies: 273
-- Name: SignConditionTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignConditionTypes_Code_seq" OWNED BY "compliance_lookups"."SignConditionTypes"."Code";


--
-- TOC entry 316 (class 1259 OID 205654)
-- Name: SignFadedTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignFadedTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignFadedTypes" OWNER TO "postgres";

--
-- TOC entry 315 (class 1259 OID 205652)
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
-- TOC entry 4412 (class 0 OID 0)
-- Dependencies: 315
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignFadedTypes_id_seq" OWNED BY "compliance_lookups"."SignFadedTypes"."id";


--
-- TOC entry 272 (class 1259 OID 193179)
-- Name: SignIlluminationTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignIlluminationTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignIlluminationTypes" OWNER TO "postgres";

--
-- TOC entry 271 (class 1259 OID 193177)
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
-- TOC entry 4413 (class 0 OID 0)
-- Dependencies: 271
-- Name: SignIlluminationTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignIlluminationTypes_Code_seq" OWNED BY "compliance_lookups"."SignIlluminationTypes"."Code";


--
-- TOC entry 314 (class 1259 OID 205377)
-- Name: SignMountTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignMountTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignMountTypes" OWNER TO "postgres";

--
-- TOC entry 313 (class 1259 OID 205375)
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
-- TOC entry 4414 (class 0 OID 0)
-- Dependencies: 313
-- Name: SignMountTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignMountTypes_id_seq" OWNED BY "compliance_lookups"."SignMountTypes"."id";


--
-- TOC entry 318 (class 1259 OID 205818)
-- Name: SignObscurredTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignObscurredTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignObscurredTypes" OWNER TO "postgres";

--
-- TOC entry 317 (class 1259 OID 205816)
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
-- TOC entry 4415 (class 0 OID 0)
-- Dependencies: 317
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignObscurredTypes_id_seq" OWNED BY "compliance_lookups"."SignObscurredTypes"."id";


--
-- TOC entry 320 (class 1259 OID 205986)
-- Name: TicketMachineIssueTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."TicketMachineIssueTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."TicketMachineIssueTypes" OWNER TO "postgres";

--
-- TOC entry 319 (class 1259 OID 205984)
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
-- TOC entry 4416 (class 0 OID 0)
-- Dependencies: 319
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."TicketMachineIssueTypes_id_seq" OWNED BY "compliance_lookups"."TicketMachineIssueTypes"."id";


--
-- TOC entry 237 (class 1259 OID 192583)
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
-- TOC entry 4417 (class 0 OID 0)
-- Dependencies: 237
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."signAttachmentTypes2_id_seq" OWNED BY "compliance_lookups"."SignAttachmentTypes"."id";


--
-- TOC entry 243 (class 1259 OID 192964)
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
-- TOC entry 244 (class 1259 OID 192970)
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
-- TOC entry 4418 (class 0 OID 0)
-- Dependencies: 244
-- Name: edi_itn_roadcentreline_gid_seq; Type: SEQUENCE OWNED BY; Schema: highways_network; Owner: postgres
--

ALTER SEQUENCE "highways_network"."edi_itn_roadcentreline_gid_seq" OWNED BY "highways_network"."itn_roadcentreline"."gid";


--
-- TOC entry 239 (class 1259 OID 192948)
-- Name: SiteArea; Type: TABLE; Schema: local_authority; Owner: postgres
--

CREATE TABLE "local_authority"."SiteArea" (
    "id" integer NOT NULL,
    "name" character varying(32),
    "geom" "public"."geometry"(MultiPolygon,27700)
);


ALTER TABLE "local_authority"."SiteArea" OWNER TO "postgres";

--
-- TOC entry 240 (class 1259 OID 192954)
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
-- TOC entry 4419 (class 0 OID 0)
-- Dependencies: 240
-- Name: SiteArea_id_seq; Type: SEQUENCE OWNED BY; Schema: local_authority; Owner: postgres
--

ALTER SEQUENCE "local_authority"."SiteArea_id_seq" OWNED BY "local_authority"."SiteArea"."id";


--
-- TOC entry 238 (class 1259 OID 192942)
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
-- TOC entry 247 (class 1259 OID 192988)
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
-- TOC entry 4420 (class 0 OID 0)
-- Dependencies: 247
-- Name: StreetGazetteerRecords_id_seq; Type: SEQUENCE OWNED BY; Schema: local_authority; Owner: postgres
--

ALTER SEQUENCE "local_authority"."StreetGazetteerRecords_id_seq" OWNED BY "local_authority"."StreetGazetteerRecords"."id";


--
-- TOC entry 302 (class 1259 OID 197281)
-- Name: RC_Polyline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RC_Polyline" (
    "geom" "public"."geometry",
    "id" integer NOT NULL
);


ALTER TABLE "public"."RC_Polyline" OWNER TO "postgres";

--
-- TOC entry 301 (class 1259 OID 197279)
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
-- TOC entry 4421 (class 0 OID 0)
-- Dependencies: 301
-- Name: RC_Polyline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RC_Polyline_id_seq" OWNED BY "public"."RC_Polyline"."id";


--
-- TOC entry 304 (class 1259 OID 204862)
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
-- TOC entry 303 (class 1259 OID 204860)
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
-- TOC entry 4422 (class 0 OID 0)
-- Dependencies: 303
-- Name: RC_Sections_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RC_Sections_gid_seq" OWNED BY "public"."RC_Sections"."gid";


--
-- TOC entry 306 (class 1259 OID 204875)
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
-- TOC entry 305 (class 1259 OID 204873)
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
-- TOC entry 4423 (class 0 OID 0)
-- Dependencies: 305
-- Name: RC_Sections_merged_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RC_Sections_merged_gid_seq" OWNED BY "public"."RC_Sections_merged"."gid";


--
-- TOC entry 229 (class 1259 OID 192276)
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
-- TOC entry 324 (class 1259 OID 208287)
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
-- TOC entry 290 (class 1259 OID 195135)
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
-- TOC entry 293 (class 1259 OID 195263)
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
-- TOC entry 230 (class 1259 OID 192342)
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
-- TOC entry 325 (class 1259 OID 208353)
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
-- TOC entry 296 (class 1259 OID 195350)
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
-- TOC entry 291 (class 1259 OID 195167)
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
-- TOC entry 292 (class 1259 OID 195215)
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
-- TOC entry 233 (class 1259 OID 192393)
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
-- TOC entry 294 (class 1259 OID 195314)
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
-- TOC entry 234 (class 1259 OID 192444)
-- Name: RestrictionLayers; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."RestrictionLayers" (
    "Code" integer NOT NULL,
    "RestrictionLayerName" character varying(255) NOT NULL
);


ALTER TABLE "toms"."RestrictionLayers" OWNER TO "postgres";

--
-- TOC entry 235 (class 1259 OID 192447)
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
-- TOC entry 4424 (class 0 OID 0)
-- Dependencies: 235
-- Name: RestrictionLayers_id_seq; Type: SEQUENCE OWNED BY; Schema: toms; Owner: postgres
--

ALTER SEQUENCE "toms"."RestrictionLayers_id_seq" OWNED BY "toms"."RestrictionLayers"."Code";


--
-- TOC entry 288 (class 1259 OID 195046)
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
-- TOC entry 289 (class 1259 OID 195049)
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
-- TOC entry 295 (class 1259 OID 195330)
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
-- TOC entry 286 (class 1259 OID 194997)
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
-- TOC entry 323 (class 1259 OID 208181)
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
-- TOC entry 297 (class 1259 OID 195359)
-- Name: TilesInAcceptedProposals; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."TilesInAcceptedProposals" (
    "ProposalID" integer NOT NULL,
    "TileNr" integer NOT NULL,
    "RevisionNr" integer NOT NULL
);


ALTER TABLE "toms"."TilesInAcceptedProposals" OWNER TO "postgres";

--
-- TOC entry 227 (class 1259 OID 192241)
-- Name: ActionOnProposalAcceptanceTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."ActionOnProposalAcceptanceTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."ActionOnProposalAcceptanceTypes" OWNER TO "postgres";

--
-- TOC entry 228 (class 1259 OID 192247)
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
-- TOC entry 4425 (class 0 OID 0)
-- Dependencies: 228
-- Name: ActionOnProposalAcceptanceTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq" OWNED BY "toms_lookups"."ActionOnProposalAcceptanceTypes"."Code";


--
-- TOC entry 263 (class 1259 OID 193119)
-- Name: AdditionalConditionTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."AdditionalConditionTypes" (
    "Code" integer NOT NULL,
    "Description" character varying(255) NOT NULL
);


ALTER TABLE "toms_lookups"."AdditionalConditionTypes" OWNER TO "postgres";

--
-- TOC entry 262 (class 1259 OID 193117)
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
-- TOC entry 4426 (class 0 OID 0)
-- Dependencies: 262
-- Name: AdditionalConditionTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."AdditionalConditionTypes_Code_seq" OWNED BY "toms_lookups"."AdditionalConditionTypes"."Code";


--
-- TOC entry 266 (class 1259 OID 193130)
-- Name: BayLineTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."BayLineTypes" (
    "Code" integer NOT NULL,
    "Description" character varying(255) NOT NULL
);


ALTER TABLE "toms_lookups"."BayLineTypes" OWNER TO "postgres";

--
-- TOC entry 265 (class 1259 OID 193128)
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
-- TOC entry 4427 (class 0 OID 0)
-- Dependencies: 265
-- Name: BayLineTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."BayLineTypes_Code_seq" OWNED BY "toms_lookups"."BayLineTypes"."Code";


--
-- TOC entry 309 (class 1259 OID 204932)
-- Name: BayTypesInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."BayTypesInUse" (
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) NOT NULL,
    "StyleDetails" character varying
);


ALTER TABLE "toms_lookups"."BayTypesInUse" OWNER TO "postgres";

--
-- TOC entry 321 (class 1259 OID 206111)
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
-- TOC entry 279 (class 1259 OID 193252)
-- Name: GeomShapeGroupType; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."GeomShapeGroupType" (
    "Code" character varying(255) NOT NULL
);


ALTER TABLE "toms_lookups"."GeomShapeGroupType" OWNER TO "postgres";

--
-- TOC entry 249 (class 1259 OID 193045)
-- Name: LengthOfTime; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."LengthOfTime" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL,
    "LabelText" character varying(255)
);


ALTER TABLE "toms_lookups"."LengthOfTime" OWNER TO "postgres";

--
-- TOC entry 248 (class 1259 OID 193043)
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
-- TOC entry 4428 (class 0 OID 0)
-- Dependencies: 248
-- Name: LengthOfTime_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."LengthOfTime_Code_seq" OWNED BY "toms_lookups"."LengthOfTime"."Code";


--
-- TOC entry 310 (class 1259 OID 204945)
-- Name: LineTypesInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."LineTypesInUse" (
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) NOT NULL,
    "StyleDetails" character varying
);


ALTER TABLE "toms_lookups"."LineTypesInUse" OWNER TO "postgres";

--
-- TOC entry 322 (class 1259 OID 206116)
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
-- TOC entry 251 (class 1259 OID 193056)
-- Name: PaymentTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."PaymentTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."PaymentTypes" OWNER TO "postgres";

--
-- TOC entry 250 (class 1259 OID 193054)
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
-- TOC entry 4429 (class 0 OID 0)
-- Dependencies: 250
-- Name: PaymentTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."PaymentTypes_Code_seq" OWNED BY "toms_lookups"."PaymentTypes"."Code";


--
-- TOC entry 253 (class 1259 OID 193065)
-- Name: ProposalStatusTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."ProposalStatusTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."ProposalStatusTypes" OWNER TO "postgres";

--
-- TOC entry 252 (class 1259 OID 193063)
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
-- TOC entry 4430 (class 0 OID 0)
-- Dependencies: 252
-- Name: ProposalStatusTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."ProposalStatusTypes_Code_seq" OWNED BY "toms_lookups"."ProposalStatusTypes"."Code";


--
-- TOC entry 257 (class 1259 OID 193087)
-- Name: RestrictionGeomShapeTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."RestrictionGeomShapeTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."RestrictionGeomShapeTypes" OWNER TO "postgres";

--
-- TOC entry 255 (class 1259 OID 193076)
-- Name: RestrictionPolygonTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."RestrictionPolygonTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."RestrictionPolygonTypes" OWNER TO "postgres";

--
-- TOC entry 287 (class 1259 OID 195033)
-- Name: RestrictionPolygonTypesInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."RestrictionPolygonTypesInUse" (
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) NOT NULL,
    "StyleDetails" character varying
);


ALTER TABLE "toms_lookups"."RestrictionPolygonTypesInUse" OWNER TO "postgres";

--
-- TOC entry 308 (class 1259 OID 204919)
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
-- TOC entry 254 (class 1259 OID 193074)
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
-- TOC entry 4431 (class 0 OID 0)
-- Dependencies: 254
-- Name: RestrictionPolygonTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."RestrictionPolygonTypes_Code_seq" OWNED BY "toms_lookups"."RestrictionPolygonTypes"."Code";


--
-- TOC entry 256 (class 1259 OID 193085)
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
-- TOC entry 4432 (class 0 OID 0)
-- Dependencies: 256
-- Name: RestrictionShapeTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."RestrictionShapeTypes_Code_seq" OWNED BY "toms_lookups"."RestrictionGeomShapeTypes"."Code";


--
-- TOC entry 312 (class 1259 OID 204960)
-- Name: SignOrientationTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."SignOrientationTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."SignOrientationTypes" OWNER TO "postgres";

--
-- TOC entry 311 (class 1259 OID 204958)
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
-- TOC entry 4433 (class 0 OID 0)
-- Dependencies: 311
-- Name: SignOrientationTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."SignOrientationTypes_Code_seq" OWNED BY "toms_lookups"."SignOrientationTypes"."Code";


--
-- TOC entry 259 (class 1259 OID 193100)
-- Name: SignTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."SignTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."SignTypes" OWNER TO "postgres";

--
-- TOC entry 264 (class 1259 OID 193123)
-- Name: SignTypesInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."SignTypesInUse" (
    "Code" integer NOT NULL
);


ALTER TABLE "toms_lookups"."SignTypesInUse" OWNER TO "postgres";

--
-- TOC entry 307 (class 1259 OID 204911)
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
-- TOC entry 258 (class 1259 OID 193098)
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
-- TOC entry 4434 (class 0 OID 0)
-- Dependencies: 258
-- Name: SignTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."SignTypes_Code_seq" OWNED BY "toms_lookups"."SignTypes"."Code";


--
-- TOC entry 261 (class 1259 OID 193109)
-- Name: TimePeriods; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."TimePeriods" (
    "Code" integer NOT NULL,
    "Description" character varying,
    "LabelText" character varying(255)
);


ALTER TABLE "toms_lookups"."TimePeriods" OWNER TO "postgres";

--
-- TOC entry 298 (class 1259 OID 197260)
-- Name: TimePeriodsInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."TimePeriodsInUse" (
    "Code" integer NOT NULL
);


ALTER TABLE "toms_lookups"."TimePeriodsInUse" OWNER TO "postgres";

--
-- TOC entry 326 (class 1259 OID 208425)
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
-- TOC entry 260 (class 1259 OID 193107)
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
-- TOC entry 4435 (class 0 OID 0)
-- Dependencies: 260
-- Name: TimePeriods_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."TimePeriods_Code_seq" OWNED BY "toms_lookups"."TimePeriods"."Code";


--
-- TOC entry 285 (class 1259 OID 193922)
-- Name: UnacceptableTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."UnacceptableTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."UnacceptableTypes" OWNER TO "postgres";

--
-- TOC entry 284 (class 1259 OID 193920)
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
-- TOC entry 4436 (class 0 OID 0)
-- Dependencies: 284
-- Name: UnacceptableTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."UnacceptableTypes_Code_seq" OWNED BY "toms_lookups"."UnacceptableTypes"."Code";


--
-- TOC entry 270 (class 1259 OID 193168)
-- Name: Corners; Type: TABLE; Schema: topography; Owner: postgres
--

CREATE TABLE "topography"."Corners" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(Point,27700)
);


ALTER TABLE "topography"."Corners" OWNER TO "postgres";

--
-- TOC entry 269 (class 1259 OID 193166)
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
-- TOC entry 4437 (class 0 OID 0)
-- Dependencies: 269
-- Name: Corners_id_seq; Type: SEQUENCE OWNED BY; Schema: topography; Owner: postgres
--

ALTER SEQUENCE "topography"."Corners_id_seq" OWNED BY "topography"."Corners"."id";


--
-- TOC entry 241 (class 1259 OID 192956)
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
-- TOC entry 242 (class 1259 OID 192962)
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
-- TOC entry 4438 (class 0 OID 0)
-- Dependencies: 242
-- Name: edi_cartotext_gid_seq; Type: SEQUENCE OWNED BY; Schema: topography; Owner: postgres
--

ALTER SEQUENCE "topography"."edi_cartotext_gid_seq" OWNED BY "topography"."os_mastermap_topography_text"."gid";


--
-- TOC entry 245 (class 1259 OID 192972)
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
-- TOC entry 246 (class 1259 OID 192978)
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
-- TOC entry 4439 (class 0 OID 0)
-- Dependencies: 246
-- Name: edi_mm_gid_seq; Type: SEQUENCE OWNED BY; Schema: topography; Owner: postgres
--

ALTER SEQUENCE "topography"."edi_mm_gid_seq" OWNED BY "topography"."os_mastermap_topography_polygons"."gid";


--
-- TOC entry 327 (class 1259 OID 208458)
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
-- TOC entry 231 (class 1259 OID 192351)
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
-- TOC entry 232 (class 1259 OID 192357)
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
-- TOC entry 300 (class 1259 OID 197267)
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
-- TOC entry 299 (class 1259 OID 197265)
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
-- TOC entry 4440 (class 0 OID 0)
-- Dependencies: 299
-- Name: RC_Polygon_id_seq; Type: SEQUENCE OWNED BY; Schema: transfer; Owner: postgres
--

ALTER SEQUENCE "transfer"."RC_Polygon_id_seq" OWNED BY "transfer"."RC_Polygon"."id";


--
-- TOC entry 4006 (class 2604 OID 193741)
-- Name: BaysLinesFadedTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."BaysLinesFadedTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."BayLinesFadedTypes_Code_seq"'::"regclass");


--
-- TOC entry 4007 (class 2604 OID 193906)
-- Name: BaysLines_SignIssueTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."BaysLines_SignIssueTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."BaysLines_SignIssueTypes_Code_seq"'::"regclass");


--
-- TOC entry 4000 (class 2604 OID 193147)
-- Name: ConditionTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."ConditionTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."ConditionTypes_Code_seq"'::"regclass");


--
-- TOC entry 4004 (class 2604 OID 193213)
-- Name: MHTC_CheckIssueType Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."MHTC_CheckIssueType" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."MHTC_CheckIssueType_Code_seq"'::"regclass");


--
-- TOC entry 4005 (class 2604 OID 193224)
-- Name: MHTC_CheckStatus Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."MHTC_CheckStatus" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."MHTC_CheckStatus_Code_seq"'::"regclass");


--
-- TOC entry 3985 (class 2604 OID 192606)
-- Name: SignAttachmentTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignAttachmentTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."signAttachmentTypes2_id_seq"'::"regclass");


--
-- TOC entry 4003 (class 2604 OID 193202)
-- Name: SignConditionTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignConditionTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."SignConditionTypes_Code_seq"'::"regclass");


--
-- TOC entry 4019 (class 2604 OID 205657)
-- Name: SignFadedTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignFadedTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."SignFadedTypes_id_seq"'::"regclass");


--
-- TOC entry 4002 (class 2604 OID 193182)
-- Name: SignIlluminationTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignIlluminationTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."SignIlluminationTypes_Code_seq"'::"regclass");


--
-- TOC entry 4018 (class 2604 OID 205380)
-- Name: SignMountTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignMountTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."SignMountTypes_id_seq"'::"regclass");


--
-- TOC entry 4020 (class 2604 OID 205821)
-- Name: SignObscurredTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignObscurredTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."SignObscurredTypes_id_seq"'::"regclass");


--
-- TOC entry 4021 (class 2604 OID 205989)
-- Name: TicketMachineIssueTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."TicketMachineIssueTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."TicketMachineIssueTypes_id_seq"'::"regclass");


--
-- TOC entry 3989 (class 2604 OID 192997)
-- Name: itn_roadcentreline gid; Type: DEFAULT; Schema: highways_network; Owner: postgres
--

ALTER TABLE ONLY "highways_network"."itn_roadcentreline" ALTER COLUMN "gid" SET DEFAULT "nextval"('"highways_network"."edi_itn_roadcentreline_gid_seq"'::"regclass");


--
-- TOC entry 3987 (class 2604 OID 192995)
-- Name: SiteArea id; Type: DEFAULT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."SiteArea" ALTER COLUMN "id" SET DEFAULT "nextval"('"local_authority"."SiteArea_id_seq"'::"regclass");


--
-- TOC entry 3986 (class 2604 OID 192994)
-- Name: StreetGazetteerRecords id; Type: DEFAULT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."StreetGazetteerRecords" ALTER COLUMN "id" SET DEFAULT "nextval"('"local_authority"."StreetGazetteerRecords_id_seq"'::"regclass");


--
-- TOC entry 4014 (class 2604 OID 197284)
-- Name: RC_Polyline id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Polyline" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."RC_Polyline_id_seq"'::"regclass");


--
-- TOC entry 4015 (class 2604 OID 204865)
-- Name: RC_Sections gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Sections" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."RC_Sections_gid_seq"'::"regclass");


--
-- TOC entry 4016 (class 2604 OID 204878)
-- Name: RC_Sections_merged gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Sections_merged" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."RC_Sections_merged_gid_seq"'::"regclass");


--
-- TOC entry 3984 (class 2604 OID 192602)
-- Name: RestrictionLayers Code; Type: DEFAULT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionLayers" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms"."RestrictionLayers_id_seq"'::"regclass");


--
-- TOC entry 3983 (class 2604 OID 192593)
-- Name: ActionOnProposalAcceptanceTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."ActionOnProposalAcceptanceTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq"'::"regclass");


--
-- TOC entry 3998 (class 2604 OID 193122)
-- Name: AdditionalConditionTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."AdditionalConditionTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."AdditionalConditionTypes_Code_seq"'::"regclass");


--
-- TOC entry 3999 (class 2604 OID 193133)
-- Name: BayLineTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."BayLineTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."BayLineTypes_Code_seq"'::"regclass");


--
-- TOC entry 3991 (class 2604 OID 193048)
-- Name: LengthOfTime Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."LengthOfTime" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."LengthOfTime_Code_seq"'::"regclass");


--
-- TOC entry 3992 (class 2604 OID 193059)
-- Name: PaymentTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."PaymentTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."PaymentTypes_Code_seq"'::"regclass");


--
-- TOC entry 3993 (class 2604 OID 193068)
-- Name: ProposalStatusTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."ProposalStatusTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."ProposalStatusTypes_Code_seq"'::"regclass");


--
-- TOC entry 3995 (class 2604 OID 193090)
-- Name: RestrictionGeomShapeTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionGeomShapeTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."RestrictionShapeTypes_Code_seq"'::"regclass");


--
-- TOC entry 3994 (class 2604 OID 193079)
-- Name: RestrictionPolygonTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionPolygonTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."RestrictionPolygonTypes_Code_seq"'::"regclass");


--
-- TOC entry 4017 (class 2604 OID 204963)
-- Name: SignOrientationTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignOrientationTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."SignOrientationTypes_Code_seq"'::"regclass");


--
-- TOC entry 3996 (class 2604 OID 193103)
-- Name: SignTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."SignTypes_Code_seq"'::"regclass");


--
-- TOC entry 3997 (class 2604 OID 193112)
-- Name: TimePeriods Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."TimePeriods" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."TimePeriods_Code_seq"'::"regclass");


--
-- TOC entry 4008 (class 2604 OID 193925)
-- Name: UnacceptableTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."UnacceptableTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."UnacceptableTypes_Code_seq"'::"regclass");


--
-- TOC entry 4001 (class 2604 OID 193171)
-- Name: Corners id; Type: DEFAULT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."Corners" ALTER COLUMN "id" SET DEFAULT "nextval"('"topography"."Corners_id_seq"'::"regclass");


--
-- TOC entry 3990 (class 2604 OID 192998)
-- Name: os_mastermap_topography_polygons gid; Type: DEFAULT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."os_mastermap_topography_polygons" ALTER COLUMN "gid" SET DEFAULT "nextval"('"topography"."edi_mm_gid_seq"'::"regclass");


--
-- TOC entry 3988 (class 2604 OID 192996)
-- Name: os_mastermap_topography_text gid; Type: DEFAULT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."os_mastermap_topography_text" ALTER COLUMN "gid" SET DEFAULT "nextval"('"topography"."edi_cartotext_gid_seq"'::"regclass");


--
-- TOC entry 4013 (class 2604 OID 197270)
-- Name: RC_Polygon id; Type: DEFAULT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."RC_Polygon" ALTER COLUMN "id" SET DEFAULT "nextval"('"transfer"."RC_Polygon_id_seq"'::"regclass");


--
-- TOC entry 4096 (class 2606 OID 193746)
-- Name: BaysLinesFadedTypes BayLinesFadedTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."BaysLinesFadedTypes"
    ADD CONSTRAINT "BayLinesFadedTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4098 (class 2606 OID 193911)
-- Name: BaysLines_SignIssueTypes BaysLines_SignIssueTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."BaysLines_SignIssueTypes"
    ADD CONSTRAINT "BaysLines_SignIssueTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4082 (class 2606 OID 208180)
-- Name: ConditionTypes ConditionTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."ConditionTypes"
    ADD CONSTRAINT "ConditionTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4090 (class 2606 OID 193218)
-- Name: MHTC_CheckIssueType MHTC_CheckIssueType_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."MHTC_CheckIssueType"
    ADD CONSTRAINT "MHTC_CheckIssueType_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4092 (class 2606 OID 193229)
-- Name: MHTC_CheckStatus MHTC_CheckStatus_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."MHTC_CheckStatus"
    ADD CONSTRAINT "MHTC_CheckStatus_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4039 (class 2606 OID 205511)
-- Name: SignAttachmentTypes SignAttachmentTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignAttachmentTypes"
    ADD CONSTRAINT "SignAttachmentTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4088 (class 2606 OID 193207)
-- Name: SignConditionTypes SignConditionTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignConditionTypes"
    ADD CONSTRAINT "SignConditionTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4154 (class 2606 OID 205664)
-- Name: SignFadedTypes SignFadedTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignFadedTypes"
    ADD CONSTRAINT "SignFadedTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4156 (class 2606 OID 205662)
-- Name: SignFadedTypes SignFadedTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignFadedTypes"
    ADD CONSTRAINT "SignFadedTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4086 (class 2606 OID 193187)
-- Name: SignIlluminationTypes SignIlluminationTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignIlluminationTypes"
    ADD CONSTRAINT "SignIlluminationTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4150 (class 2606 OID 205387)
-- Name: SignMountTypes SignMountTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignMountTypes"
    ADD CONSTRAINT "SignMountTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4152 (class 2606 OID 205385)
-- Name: SignMountTypes SignMounts_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignMountTypes"
    ADD CONSTRAINT "SignMounts_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4158 (class 2606 OID 205899)
-- Name: SignObscurredTypes SignObscurredTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignObscurredTypes"
    ADD CONSTRAINT "SignObscurredTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4160 (class 2606 OID 205826)
-- Name: SignObscurredTypes SignObscurredTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignObscurredTypes"
    ADD CONSTRAINT "SignObscurredTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4162 (class 2606 OID 205996)
-- Name: TicketMachineIssueTypes TicketMachineIssueTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."TicketMachineIssueTypes"
    ADD CONSTRAINT "TicketMachineIssueTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4164 (class 2606 OID 205994)
-- Name: TicketMachineIssueTypes TicketMachineIssueTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."TicketMachineIssueTypes"
    ADD CONSTRAINT "TicketMachineIssueTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4041 (class 2606 OID 192724)
-- Name: SignAttachmentTypes signAttachmentTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignAttachmentTypes"
    ADD CONSTRAINT "signAttachmentTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4053 (class 2606 OID 193015)
-- Name: itn_roadcentreline edi_itn_roadcentreline_pkey; Type: CONSTRAINT; Schema: highways_network; Owner: postgres
--

ALTER TABLE ONLY "highways_network"."itn_roadcentreline"
    ADD CONSTRAINT "edi_itn_roadcentreline_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4044 (class 2606 OID 193021)
-- Name: StreetGazetteerRecords gaz_usrn_pkey; Type: CONSTRAINT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."StreetGazetteerRecords"
    ADD CONSTRAINT "gaz_usrn_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4047 (class 2606 OID 193011)
-- Name: SiteArea test_area_pkey; Type: CONSTRAINT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."SiteArea"
    ADD CONSTRAINT "test_area_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4134 (class 2606 OID 197289)
-- Name: RC_Polyline RC_Polyline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Polyline"
    ADD CONSTRAINT "RC_Polyline_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4139 (class 2606 OID 204883)
-- Name: RC_Sections_merged RC_Sections_merged_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Sections_merged"
    ADD CONSTRAINT "RC_Sections_merged_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4136 (class 2606 OID 204870)
-- Name: RC_Sections RC_Sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Sections"
    ADD CONSTRAINT "RC_Sections_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4173 (class 2606 OID 208298)
-- Name: Bays Bays_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4175 (class 2606 OID 208296)
-- Name: Bays Bays_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4114 (class 2606 OID 195273)
-- Name: ControlledParkingZones ControlledParkingZones_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4116 (class 2606 OID 195271)
-- Name: ControlledParkingZones ControlledParkingZones_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4178 (class 2606 OID 208363)
-- Name: Lines Lines_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4180 (class 2606 OID 208361)
-- Name: Lines Liness_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Liness_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4125 (class 2606 OID 195357)
-- Name: MapGrid MapGrid_pkey; Type: CONSTRAINT; Schema: toms; Owner: toms_operator
--

ALTER TABLE ONLY "toms"."MapGrid"
    ADD CONSTRAINT "MapGrid_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4109 (class 2606 OID 195225)
-- Name: ParkingTariffAreas ParkingTariffAreas_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4111 (class 2606 OID 195223)
-- Name: ParkingTariffAreas ParkingTariffAreas_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4119 (class 2606 OID 195322)
-- Name: Proposals Proposals_PK; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Proposals"
    ADD CONSTRAINT "Proposals_PK" PRIMARY KEY ("ProposalID");


--
-- TOC entry 4121 (class 2606 OID 195324)
-- Name: Proposals Proposals_ProposalTitle_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Proposals"
    ADD CONSTRAINT "Proposals_ProposalTitle_key" UNIQUE ("ProposalTitle");


--
-- TOC entry 4035 (class 2606 OID 192662)
-- Name: RestrictionLayers RestrictionLayers2_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers2_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4037 (class 2606 OID 192664)
-- Name: RestrictionLayers RestrictionLayers_id_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers_id_key" UNIQUE ("Code");


--
-- TOC entry 4104 (class 2606 OID 195059)
-- Name: RestrictionPolygons RestrictionPolygons_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionPolygons_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4123 (class 2606 OID 195334)
-- Name: RestrictionsInProposals RestrictionsInProposals_pk; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_pk" PRIMARY KEY ("ProposalID", "RestrictionTableID", "RestrictionID");


--
-- TOC entry 4106 (class 2606 OID 195057)
-- Name: RestrictionPolygons RestrictionsPolygons_pk; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_pk" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4168 (class 2606 OID 208191)
-- Name: Signs Signs_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4170 (class 2606 OID 208189)
-- Name: Signs Signs_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4128 (class 2606 OID 195363)
-- Name: TilesInAcceptedProposals TilesInAcceptedProposals_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_pkey" PRIMARY KEY ("ProposalID", "TileNr", "RevisionNr");


--
-- TOC entry 4029 (class 2606 OID 192620)
-- Name: ActionOnProposalAcceptanceTypes ActionOnProposalAcceptanceTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."ActionOnProposalAcceptanceTypes"
    ADD CONSTRAINT "ActionOnProposalAcceptanceTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4076 (class 2606 OID 193149)
-- Name: AdditionalConditionTypes AdditionalConditionTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."AdditionalConditionTypes"
    ADD CONSTRAINT "AdditionalConditionTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4080 (class 2606 OID 193151)
-- Name: BayLineTypes BayLineTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."BayLineTypes"
    ADD CONSTRAINT "BayLineTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4144 (class 2606 OID 204939)
-- Name: BayTypesInUse BayTypesInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."BayTypesInUse"
    ADD CONSTRAINT "BayTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4094 (class 2606 OID 193256)
-- Name: GeomShapeGroupType GeomShapeGroupType_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."GeomShapeGroupType"
    ADD CONSTRAINT "GeomShapeGroupType_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4058 (class 2606 OID 193053)
-- Name: LengthOfTime LengthOfTime_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."LengthOfTime"
    ADD CONSTRAINT "LengthOfTime_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4146 (class 2606 OID 204952)
-- Name: LineTypesInUse LineTypesInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."LineTypesInUse"
    ADD CONSTRAINT "LineTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4060 (class 2606 OID 193153)
-- Name: PaymentTypes PaymentTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."PaymentTypes"
    ADD CONSTRAINT "PaymentTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4062 (class 2606 OID 193155)
-- Name: ProposalStatusTypes ProposalStatusTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."ProposalStatusTypes"
    ADD CONSTRAINT "ProposalStatusTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4102 (class 2606 OID 195037)
-- Name: RestrictionPolygonTypesInUse RestrictionPolygonTypesInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionPolygonTypesInUse"
    ADD CONSTRAINT "RestrictionPolygonTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4064 (class 2606 OID 193157)
-- Name: RestrictionPolygonTypes RestrictionPolygonTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionPolygonTypes"
    ADD CONSTRAINT "RestrictionPolygonTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4066 (class 2606 OID 193095)
-- Name: RestrictionGeomShapeTypes RestrictionShapeTypes_Description_key; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionGeomShapeTypes"
    ADD CONSTRAINT "RestrictionShapeTypes_Description_key" UNIQUE ("Description");


--
-- TOC entry 4068 (class 2606 OID 193159)
-- Name: RestrictionGeomShapeTypes RestrictionShapeTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionGeomShapeTypes"
    ADD CONSTRAINT "RestrictionShapeTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4148 (class 2606 OID 204968)
-- Name: SignOrientationTypes SignOrientationTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignOrientationTypes"
    ADD CONSTRAINT "SignOrientationTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4078 (class 2606 OID 193127)
-- Name: SignTypesInUse SignTypesInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignTypesInUse"
    ADD CONSTRAINT "SignTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4070 (class 2606 OID 193161)
-- Name: SignTypes SignTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignTypes"
    ADD CONSTRAINT "SignTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4130 (class 2606 OID 197264)
-- Name: TimePeriodsInUse TimePeriodsInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."TimePeriodsInUse"
    ADD CONSTRAINT "TimePeriodsInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4072 (class 2606 OID 193165)
-- Name: TimePeriods TimePeriods_Description_key; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_Description_key" UNIQUE ("Description");


--
-- TOC entry 4074 (class 2606 OID 193163)
-- Name: TimePeriods TimePeriods_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4100 (class 2606 OID 193930)
-- Name: UnacceptableTypes UnacceptableTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."UnacceptableTypes"
    ADD CONSTRAINT "UnacceptableTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4084 (class 2606 OID 193176)
-- Name: Corners Corners_pkey; Type: CONSTRAINT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."Corners"
    ADD CONSTRAINT "Corners_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4050 (class 2606 OID 193013)
-- Name: os_mastermap_topography_text edi_cartotext_pkey; Type: CONSTRAINT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."os_mastermap_topography_text"
    ADD CONSTRAINT "edi_cartotext_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4056 (class 2606 OID 193017)
-- Name: os_mastermap_topography_polygons edi_mm_pkey; Type: CONSTRAINT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."os_mastermap_topography_polygons"
    ADD CONSTRAINT "edi_mm_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4184 (class 2606 OID 208465)
-- Name: road_casement road_casement_pkey; Type: CONSTRAINT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."road_casement"
    ADD CONSTRAINT "road_casement_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4031 (class 2606 OID 192642)
-- Name: LookupCodeTransfers_Bays LookupCodeTransfers_Bays_pkey; Type: CONSTRAINT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."LookupCodeTransfers_Bays"
    ADD CONSTRAINT "LookupCodeTransfers_Bays_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4033 (class 2606 OID 192644)
-- Name: LookupCodeTransfers_Lines LookupCodeTransfers_Lines_pkey; Type: CONSTRAINT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."LookupCodeTransfers_Lines"
    ADD CONSTRAINT "LookupCodeTransfers_Lines_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4132 (class 2606 OID 197272)
-- Name: RC_Polygon RC_Polygon_pkey; Type: CONSTRAINT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."RC_Polygon"
    ADD CONSTRAINT "RC_Polygon_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4051 (class 1259 OID 193024)
-- Name: edi_itn_roadcentreline_geom_idx; Type: INDEX; Schema: highways_network; Owner: postgres
--

CREATE INDEX "edi_itn_roadcentreline_geom_idx" ON "highways_network"."itn_roadcentreline" USING "gist" ("geom");


--
-- TOC entry 4042 (class 1259 OID 193027)
-- Name: gaz_usrn_geom_idx; Type: INDEX; Schema: local_authority; Owner: postgres
--

CREATE INDEX "gaz_usrn_geom_idx" ON "local_authority"."StreetGazetteerRecords" USING "gist" ("geom");


--
-- TOC entry 4045 (class 1259 OID 193022)
-- Name: test_area_geom_idx; Type: INDEX; Schema: local_authority; Owner: postgres
--

CREATE INDEX "test_area_geom_idx" ON "local_authority"."SiteArea" USING "gist" ("geom");


--
-- TOC entry 4137 (class 1259 OID 204871)
-- Name: sidx_RC_Sections_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_RC_Sections_geom" ON "public"."RC_Sections" USING "gist" ("geom");


--
-- TOC entry 4140 (class 1259 OID 204884)
-- Name: sidx_RC_Sections_merged_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_RC_Sections_merged_geom" ON "public"."RC_Sections_merged" USING "gist" ("geom");


--
-- TOC entry 4117 (class 1259 OID 195299)
-- Name: controlledparkingzones_geom_idx; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "controlledparkingzones_geom_idx" ON "toms"."ControlledParkingZones" USING "gist" ("geom");


--
-- TOC entry 4176 (class 1259 OID 208349)
-- Name: sidx_Bays_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_Bays_geom" ON "toms"."Bays" USING "gist" ("geom");


--
-- TOC entry 4181 (class 1259 OID 208409)
-- Name: sidx_Lines_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_Lines_geom" ON "toms"."Lines" USING "gist" ("geom");


--
-- TOC entry 4126 (class 1259 OID 195358)
-- Name: sidx_MapGrid_geom; Type: INDEX; Schema: toms; Owner: toms_operator
--

CREATE INDEX "sidx_MapGrid_geom" ON "toms"."MapGrid" USING "gist" ("geom");


--
-- TOC entry 4112 (class 1259 OID 195261)
-- Name: sidx_ParkingTariffAreas_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_ParkingTariffAreas_geom" ON "toms"."ParkingTariffAreas" USING "gist" ("geom");


--
-- TOC entry 4171 (class 1259 OID 208262)
-- Name: sidx_Signs_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_Signs_geom" ON "toms"."Signs" USING "gist" ("geom");


--
-- TOC entry 4107 (class 1259 OID 195100)
-- Name: sidx_restrictionPolygons_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_restrictionPolygons_geom" ON "toms"."RestrictionPolygons" USING "gist" ("geom");


--
-- TOC entry 4165 (class 1259 OID 206115)
-- Name: BayTypesInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "BayTypesInUse_View_key" ON "toms_lookups"."BayTypesInUse_View" USING "btree" ("Code");


--
-- TOC entry 4166 (class 1259 OID 206120)
-- Name: LineTypesInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "LineTypesInUse_View_key" ON "toms_lookups"."LineTypesInUse_View" USING "btree" ("Code");


--
-- TOC entry 4142 (class 1259 OID 204926)
-- Name: RestrictionPolygonTypesInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "RestrictionPolygonTypesInUse_View_key" ON "toms_lookups"."RestrictionPolygonTypesInUse_View" USING "btree" ("Code");


--
-- TOC entry 4141 (class 1259 OID 204918)
-- Name: SignTypesInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "SignTypesInUse_View_key" ON "toms_lookups"."SignTypesInUse_View" USING "btree" ("Code");


--
-- TOC entry 4182 (class 1259 OID 208432)
-- Name: TimePeriodsInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "TimePeriodsInUse_View_key" ON "toms_lookups"."TimePeriodsInUse_View" USING "btree" ("Code");


--
-- TOC entry 4048 (class 1259 OID 193023)
-- Name: edi_cartotext_geom_idx; Type: INDEX; Schema: topography; Owner: postgres
--

CREATE INDEX "edi_cartotext_geom_idx" ON "topography"."os_mastermap_topography_text" USING "gist" ("geom");


--
-- TOC entry 4054 (class 1259 OID 193025)
-- Name: edi_mm_geom_idx; Type: INDEX; Schema: topography; Owner: postgres
--

CREATE INDEX "edi_mm_geom_idx" ON "topography"."os_mastermap_topography_polygons" USING "gist" ("geom");


--
-- TOC entry 4253 (class 2620 OID 208350)
-- Name: Bays create_geometryid_bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_bays" BEFORE INSERT ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4258 (class 2620 OID 208412)
-- Name: Lines create_geometryid_lines; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_lines" BEFORE INSERT ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4247 (class 2620 OID 208414)
-- Name: RestrictionPolygons create_geometryid_restrictionpolygons; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_restrictionpolygons" BEFORE INSERT ON "toms"."RestrictionPolygons" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4251 (class 2620 OID 208413)
-- Name: Signs create_geometryid_signs; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_signs" BEFORE INSERT ON "toms"."Signs" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4254 (class 2620 OID 208351)
-- Name: Bays set_last_update_details_Bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_Bays" BEFORE INSERT OR UPDATE ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4250 (class 2620 OID 208424)
-- Name: ControlledParkingZones set_last_update_details_ControlledParkingZones; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_ControlledParkingZones" BEFORE INSERT OR UPDATE ON "toms"."ControlledParkingZones" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4256 (class 2620 OID 208410)
-- Name: Lines set_last_update_details_Lines; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_Lines" BEFORE INSERT OR UPDATE ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4249 (class 2620 OID 195385)
-- Name: ParkingTariffAreas set_last_update_details_ParkingTariffAreas; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_ParkingTariffAreas" BEFORE INSERT OR UPDATE ON "toms"."ParkingTariffAreas" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4248 (class 2620 OID 195383)
-- Name: RestrictionPolygons set_last_update_details_RestrictionPolygons; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_RestrictionPolygons" BEFORE INSERT OR UPDATE ON "toms"."RestrictionPolygons" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4252 (class 2620 OID 208263)
-- Name: Signs set_last_update_details_Signs; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_Signs" BEFORE INSERT OR UPDATE ON "toms"."Signs" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4255 (class 2620 OID 208352)
-- Name: Bays set_restriction_length_Bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_restriction_length_Bays" BEFORE INSERT OR UPDATE ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_restriction_length"();


--
-- TOC entry 4257 (class 2620 OID 208411)
-- Name: Lines set_restriction_length_Lines; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_restriction_length_Lines" BEFORE INSERT OR UPDATE ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_restriction_length"();


--
-- TOC entry 4228 (class 2606 OID 208299)
-- Name: Bays Bays_AdditionalConditionID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_AdditionalConditionID_fkey" FOREIGN KEY ("AdditionalConditionID") REFERENCES "toms_lookups"."AdditionalConditionTypes"("Code");


--
-- TOC entry 4229 (class 2606 OID 208304)
-- Name: Bays Bays_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."BaysLines_SignIssueTypes"("Code");


--
-- TOC entry 4230 (class 2606 OID 208309)
-- Name: Bays Bays_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."BaysLinesFadedTypes"("Code");


--
-- TOC entry 4231 (class 2606 OID 208314)
-- Name: Bays Bays_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "toms_lookups"."RestrictionGeomShapeTypes"("Code");


--
-- TOC entry 4232 (class 2606 OID 208319)
-- Name: Bays Bays_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueType"("Code");


--
-- TOC entry 4233 (class 2606 OID 208324)
-- Name: Bays Bays_MaxStayID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_MaxStayID_fkey" FOREIGN KEY ("MaxStayID") REFERENCES "toms_lookups"."LengthOfTime"("Code");


--
-- TOC entry 4234 (class 2606 OID 208329)
-- Name: Bays Bays_NoReturnID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_NoReturnID_fkey" FOREIGN KEY ("NoReturnID") REFERENCES "toms_lookups"."LengthOfTime"("Code");


--
-- TOC entry 4235 (class 2606 OID 208334)
-- Name: Bays Bays_PayTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_PayTypeID_fkey" FOREIGN KEY ("PayTypeID") REFERENCES "toms_lookups"."PaymentTypes"("Code");


--
-- TOC entry 4236 (class 2606 OID 208339)
-- Name: Bays Bays_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."BayTypesInUse"("Code");


--
-- TOC entry 4237 (class 2606 OID 208344)
-- Name: Bays Bays_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4202 (class 2606 OID 195274)
-- Name: ControlledParkingZones ControlledParkingZones_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."BaysLines_SignIssueTypes"("Code");


--
-- TOC entry 4203 (class 2606 OID 195279)
-- Name: ControlledParkingZones ControlledParkingZones_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."BaysLinesFadedTypes"("Code");


--
-- TOC entry 4204 (class 2606 OID 195284)
-- Name: ControlledParkingZones ControlledParkingZones_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueType"("Code");


--
-- TOC entry 4201 (class 2606 OID 204885)
-- Name: ControlledParkingZones ControlledParkingZones_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."RestrictionPolygonTypesInUse"("Code");


--
-- TOC entry 4205 (class 2606 OID 195294)
-- Name: ControlledParkingZones ControlledParkingZones_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4238 (class 2606 OID 208364)
-- Name: Lines Lines_AdditionalConditionID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_AdditionalConditionID_fkey" FOREIGN KEY ("AdditionalConditionID") REFERENCES "toms_lookups"."AdditionalConditionTypes"("Code");


--
-- TOC entry 4239 (class 2606 OID 208369)
-- Name: Lines Lines_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."BaysLines_SignIssueTypes"("Code");


--
-- TOC entry 4240 (class 2606 OID 208374)
-- Name: Lines Lines_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."BaysLinesFadedTypes"("Code");


--
-- TOC entry 4241 (class 2606 OID 208379)
-- Name: Lines Lines_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "toms_lookups"."RestrictionGeomShapeTypes"("Code");


--
-- TOC entry 4242 (class 2606 OID 208384)
-- Name: Lines Lines_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueType"("Code");


--
-- TOC entry 4243 (class 2606 OID 208389)
-- Name: Lines Lines_NoLoadingTimeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_NoLoadingTimeID_fkey" FOREIGN KEY ("NoLoadingTimeID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4244 (class 2606 OID 208394)
-- Name: Lines Lines_NoWaitingTimeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_NoWaitingTimeID_fkey" FOREIGN KEY ("NoWaitingTimeID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4245 (class 2606 OID 208399)
-- Name: Lines Lines_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."LineTypesInUse"("Code");


--
-- TOC entry 4246 (class 2606 OID 208404)
-- Name: Lines Lines_UnacceptableTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_UnacceptableTypeID_fkey" FOREIGN KEY ("UnacceptableTypeID") REFERENCES "toms_lookups"."UnacceptableTypes"("Code");


--
-- TOC entry 4196 (class 2606 OID 195226)
-- Name: ParkingTariffAreas ParkingTariffAreas_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."BaysLines_SignIssueTypes"("Code");


--
-- TOC entry 4197 (class 2606 OID 195231)
-- Name: ParkingTariffAreas ParkingTariffAreas_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."BaysLinesFadedTypes"("Code");


--
-- TOC entry 4198 (class 2606 OID 195236)
-- Name: ParkingTariffAreas ParkingTariffAreas_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueType"("Code");


--
-- TOC entry 4199 (class 2606 OID 195241)
-- Name: ParkingTariffAreas ParkingTariffAreas_MaxStayID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_MaxStayID_fkey" FOREIGN KEY ("MaxStayID") REFERENCES "toms_lookups"."LengthOfTime"("Code");


--
-- TOC entry 4200 (class 2606 OID 195246)
-- Name: ParkingTariffAreas ParkingTariffAreas_NoReturnID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_NoReturnID_fkey" FOREIGN KEY ("NoReturnID") REFERENCES "toms_lookups"."LengthOfTime"("Code");


--
-- TOC entry 4194 (class 2606 OID 204927)
-- Name: ParkingTariffAreas ParkingTariffAreas_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."RestrictionPolygonTypesInUse"("Code");


--
-- TOC entry 4195 (class 2606 OID 195256)
-- Name: ParkingTariffAreas ParkingTariffAreas_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4206 (class 2606 OID 195325)
-- Name: Proposals Proposals_ProposalStatusTypes_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Proposals"
    ADD CONSTRAINT "Proposals_ProposalStatusTypes_fkey" FOREIGN KEY ("ProposalStatusID") REFERENCES "toms_lookups"."ProposalStatusTypes"("Code");


--
-- TOC entry 4207 (class 2606 OID 195335)
-- Name: RestrictionsInProposals RestrictionsInProposals_ActionOnProposalAcceptance_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ActionOnProposalAcceptance_fkey" FOREIGN KEY ("ActionOnProposalAcceptance") REFERENCES "toms_lookups"."ActionOnProposalAcceptanceTypes"("Code");


--
-- TOC entry 4208 (class 2606 OID 195340)
-- Name: RestrictionsInProposals RestrictionsInProposals_ProposalID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ProposalID_fkey" FOREIGN KEY ("ProposalID") REFERENCES "toms"."Proposals"("ProposalID");


--
-- TOC entry 4209 (class 2606 OID 195345)
-- Name: RestrictionsInProposals RestrictionsInProposals_RestrictionTableID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_RestrictionTableID_fkey" FOREIGN KEY ("RestrictionTableID") REFERENCES "toms"."RestrictionLayers"("Code");


--
-- TOC entry 4186 (class 2606 OID 195060)
-- Name: RestrictionPolygons RestrictionsPolygons_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."BaysLines_SignIssueTypes"("Code");


--
-- TOC entry 4187 (class 2606 OID 195065)
-- Name: RestrictionPolygons RestrictionsPolygons_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."BaysLinesFadedTypes"("Code");


--
-- TOC entry 4188 (class 2606 OID 195070)
-- Name: RestrictionPolygons RestrictionsPolygons_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "toms_lookups"."RestrictionGeomShapeTypes"("Code");


--
-- TOC entry 4189 (class 2606 OID 195075)
-- Name: RestrictionPolygons RestrictionsPolygons_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueType"("Code");


--
-- TOC entry 4192 (class 2606 OID 195090)
-- Name: RestrictionPolygons RestrictionsPolygons_NoLoadingTimeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_NoLoadingTimeID_fkey" FOREIGN KEY ("NoLoadingTimeID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4193 (class 2606 OID 195095)
-- Name: RestrictionPolygons RestrictionsPolygons_NoWaitingTimeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_NoWaitingTimeID_fkey" FOREIGN KEY ("NoWaitingTimeID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4190 (class 2606 OID 195080)
-- Name: RestrictionPolygons RestrictionsPolygons_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."RestrictionPolygonTypesInUse"("Code");


--
-- TOC entry 4191 (class 2606 OID 195085)
-- Name: RestrictionPolygons RestrictionsPolygons_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4214 (class 2606 OID 208192)
-- Name: Signs Signs_Compl_Signs_Faded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Compl_Signs_Faded_fkey" FOREIGN KEY ("Compl_Signs_Faded") REFERENCES "compliance_lookups"."SignFadedTypes"("Code");


--
-- TOC entry 4215 (class 2606 OID 208197)
-- Name: Signs Signs_Compl_Signs_Obscured_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Compl_Signs_Obscured_fkey" FOREIGN KEY ("Compl_Signs_Obscured") REFERENCES "compliance_lookups"."SignObscurredTypes"("Code");


--
-- TOC entry 4216 (class 2606 OID 208202)
-- Name: Signs Signs_Compl_Signs_TicketMachines_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Compl_Signs_TicketMachines_fkey" FOREIGN KEY ("Compl_Signs_TicketMachines") REFERENCES "compliance_lookups"."TicketMachineIssueTypes"("Code");


--
-- TOC entry 4217 (class 2606 OID 208207)
-- Name: Signs Signs_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."BaysLines_SignIssueTypes"("Code");


--
-- TOC entry 4218 (class 2606 OID 208212)
-- Name: Signs Signs_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueType"("Code");


--
-- TOC entry 4219 (class 2606 OID 208217)
-- Name: Signs Signs_MHTC_SignIlluminationTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_MHTC_SignIlluminationTypeID_fkey" FOREIGN KEY ("SignIlluminationTypeID") REFERENCES "compliance_lookups"."SignIlluminationTypes"("Code");


--
-- TOC entry 4220 (class 2606 OID 208222)
-- Name: Signs Signs_SignConditionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignConditionTypeID_fkey" FOREIGN KEY ("SignConditionTypeID") REFERENCES "compliance_lookups"."SignConditionTypes"("Code");


--
-- TOC entry 4221 (class 2606 OID 208227)
-- Name: Signs Signs_SignOrientationTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignOrientationTypeID_fkey" FOREIGN KEY ("SignOrientationTypeID") REFERENCES "toms_lookups"."SignOrientationTypes"("Code");


--
-- TOC entry 4222 (class 2606 OID 208232)
-- Name: Signs Signs_SignTypes1_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignTypes1_fkey" FOREIGN KEY ("SignType_1") REFERENCES "toms_lookups"."SignTypesInUse"("Code");


--
-- TOC entry 4223 (class 2606 OID 208237)
-- Name: Signs Signs_SignTypes2_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignTypes2_fkey" FOREIGN KEY ("SignType_2") REFERENCES "toms_lookups"."SignTypesInUse"("Code");


--
-- TOC entry 4224 (class 2606 OID 208242)
-- Name: Signs Signs_SignTypes3_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignTypes3_fkey" FOREIGN KEY ("SignType_3") REFERENCES "toms_lookups"."SignTypesInUse"("Code");


--
-- TOC entry 4225 (class 2606 OID 208247)
-- Name: Signs Signs_SignTypes4_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignTypes4_fkey" FOREIGN KEY ("SignType_4") REFERENCES "toms_lookups"."SignTypesInUse"("Code");


--
-- TOC entry 4226 (class 2606 OID 208252)
-- Name: Signs Signs_Signs_Attachment_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Signs_Attachment_fkey" FOREIGN KEY ("Signs_Attachment") REFERENCES "compliance_lookups"."SignAttachmentTypes"("Code");


--
-- TOC entry 4227 (class 2606 OID 208257)
-- Name: Signs Signs_Signs_Mount_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Signs_Mount_fkey" FOREIGN KEY ("Signs_Mount") REFERENCES "compliance_lookups"."SignMountTypes"("Code");


--
-- TOC entry 4210 (class 2606 OID 195364)
-- Name: TilesInAcceptedProposals TilesInAcceptedProposals_ProposalID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_ProposalID_fkey" FOREIGN KEY ("ProposalID") REFERENCES "toms"."Proposals"("ProposalID");


--
-- TOC entry 4211 (class 2606 OID 195369)
-- Name: TilesInAcceptedProposals TilesInAcceptedProposals_TileNr_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_TileNr_fkey" FOREIGN KEY ("TileNr") REFERENCES "toms"."MapGrid"("id");


--
-- TOC entry 4212 (class 2606 OID 204940)
-- Name: BayTypesInUse BayTypesInUse_GeomShapeGroupType_fkey; Type: FK CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."BayTypesInUse"
    ADD CONSTRAINT "BayTypesInUse_GeomShapeGroupType_fkey" FOREIGN KEY ("GeomShapeGroupType") REFERENCES "toms_lookups"."GeomShapeGroupType"("Code");


--
-- TOC entry 4213 (class 2606 OID 204953)
-- Name: LineTypesInUse LineTypesInUse_GeomShapeGroupType_fkey; Type: FK CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."LineTypesInUse"
    ADD CONSTRAINT "LineTypesInUse_GeomShapeGroupType_fkey" FOREIGN KEY ("GeomShapeGroupType") REFERENCES "toms_lookups"."GeomShapeGroupType"("Code");


--
-- TOC entry 4185 (class 2606 OID 195038)
-- Name: RestrictionPolygonTypesInUse RestrictionPolygonTypesInUse_GeomShapeGroupType_fkey; Type: FK CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionPolygonTypesInUse"
    ADD CONSTRAINT "RestrictionPolygonTypesInUse_GeomShapeGroupType_fkey" FOREIGN KEY ("GeomShapeGroupType") REFERENCES "toms_lookups"."GeomShapeGroupType"("Code");


--
-- TOC entry 4395 (class 0 OID 195314)
-- Dependencies: 294
-- Name: Proposals; Type: ROW SECURITY; Schema: toms; Owner: postgres
--

ALTER TABLE "toms"."Proposals" ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4398 (class 3256 OID 208468)
-- Name: Proposals insertProposals; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "insertProposals" ON "toms"."Proposals" FOR INSERT TO "toms_operator" WITH CHECK (("ProposalStatusID" <> 2));


--
-- TOC entry 4400 (class 3256 OID 208470)
-- Name: Proposals insertProposals_admin; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "insertProposals_admin" ON "toms"."Proposals" FOR INSERT TO "toms_admin" WITH CHECK (("ProposalStatusID" <> 2));


--
-- TOC entry 4396 (class 3256 OID 208466)
-- Name: Proposals selectProposals; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "selectProposals" ON "toms"."Proposals" FOR SELECT USING (true);


--
-- TOC entry 4397 (class 3256 OID 208467)
-- Name: Proposals updateProposals; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "updateProposals" ON "toms"."Proposals" FOR UPDATE TO "toms_operator" USING (true) WITH CHECK (("ProposalStatusID" <> 2));


--
-- TOC entry 4399 (class 3256 OID 208469)
-- Name: Proposals updateProposals_admin; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "updateProposals_admin" ON "toms"."Proposals" FOR UPDATE TO "toms_admin" USING (true);


-- Completed on 2020-05-24 22:45:59

--
-- PostgreSQL database dump complete
--

