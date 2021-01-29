--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4 (Debian 12.4-1.pgdg100+1)
-- Dumped by pg_dump version 12.4

-- Started on 2021-01-29 15:47:54

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
-- TOC entry 22 (class 2615 OID 16385)
-- Name: addresses; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "addresses";


ALTER SCHEMA "addresses" OWNER TO "postgres";

--
-- TOC entry 12 (class 2615 OID 16386)
-- Name: compliance; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "compliance";


ALTER SCHEMA "compliance" OWNER TO "postgres";

--
-- TOC entry 17 (class 2615 OID 16387)
-- Name: compliance_lookups; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "compliance_lookups";


ALTER SCHEMA "compliance_lookups" OWNER TO "postgres";

--
-- TOC entry 16 (class 2615 OID 16388)
-- Name: export; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "export";


ALTER SCHEMA "export" OWNER TO "postgres";

--
-- TOC entry 10 (class 2615 OID 16389)
-- Name: highways_network; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "highways_network";


ALTER SCHEMA "highways_network" OWNER TO "postgres";

--
-- TOC entry 21 (class 2615 OID 16390)
-- Name: local_authority; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "local_authority";


ALTER SCHEMA "local_authority" OWNER TO "postgres";

--
-- TOC entry 9 (class 2615 OID 18455)
-- Name: mhtc_operations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "mhtc_operations";


ALTER SCHEMA "mhtc_operations" OWNER TO "postgres";

--
-- TOC entry 20 (class 2615 OID 16391)
-- Name: toms; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "toms";


ALTER SCHEMA "toms" OWNER TO "postgres";

--
-- TOC entry 14 (class 2615 OID 16392)
-- Name: toms_lookups; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "toms_lookups";


ALTER SCHEMA "toms_lookups" OWNER TO "postgres";

--
-- TOC entry 15 (class 2615 OID 16393)
-- Name: topography; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "topography";


ALTER SCHEMA "topography" OWNER TO "postgres";

--
-- TOC entry 13 (class 2615 OID 16394)
-- Name: transfer; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "transfer";


ALTER SCHEMA "transfer" OWNER TO "postgres";

--
-- TOC entry 1822 (class 2612 OID 16398)
-- Name: plpython3u; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE "plpython3u";


ALTER PROCEDURAL LANGUAGE "plpython3u" OWNER TO "postgres";

--
-- TOC entry 5 (class 3079 OID 16399)
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "dblink" WITH SCHEMA "public";


--
-- TOC entry 4673 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION "dblink"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "dblink" IS 'connect to other PostgreSQL databases from within a database';


--
-- TOC entry 4 (class 3079 OID 16445)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "postgis" WITH SCHEMA "public";


--
-- TOC entry 4674 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION "postgis"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "postgis" IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- TOC entry 3 (class 3079 OID 17447)
-- Name: postgres_fdw; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "postgres_fdw" WITH SCHEMA "public";


--
-- TOC entry 4675 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "postgres_fdw"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "postgres_fdw" IS 'foreign-data wrapper for remote PostgreSQL servers';


--
-- TOC entry 2 (class 3079 OID 17451)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "public";


--
-- TOC entry 4676 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1081 (class 1255 OID 17462)
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
-- TOC entry 1088 (class 1255 OID 18576)
-- Name: revise_all_capacities(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION "public"."revise_all_capacities"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	 vehicleLength real := 0.0;
	 vehicleWidth real := 0.0;
	 motorcycleWidth real := 0.0;
BEGIN

    IF NEW."Field" = 'VehicleLength' OR  NEW."Field" = 'VehicleWidth' OR NEW."Field" = 'MotorcycleWidth' THEN
        UPDATE "toms"."Bays" SET "RestrictionLength" = ROUND(public.ST_Length ("geom")::numeric,2);
        UPDATE "toms"."Lines" SET "RestrictionLength" = ROUND(public.ST_Length ("geom")::numeric,2);
    END IF;

	RETURN NEW;

END;
$$;


ALTER FUNCTION "public"."revise_all_capacities"() OWNER TO "postgres";

--
-- TOC entry 1085 (class 1255 OID 18453)
-- Name: set_bay_geom_type(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION "public"."set_bay_geom_type"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
    DECLARE
        restriction_id          text;
        geom_shape_id			integer;
        geom_shape_group_type	text;
    BEGIN

		restriction_id = NEW."RestrictionID";
		geom_shape_id = NEW."GeomShapeID";
		--RAISE NOTICE '% is restrictionID', NEW."RestrictionID";

		SELECT l."GeomShapeGroupType"
		FROM toms."Bays" b, toms_lookups."BayTypesInUse" l
		WHERE b."RestrictionTypeID" = NEW."RestrictionTypeID"
		AND b."RestrictionTypeID" = l."Code" INTO geom_shape_group_type;

		--RAISE NOTICE  '% is geom_shape_group_type', geom_shape_group_type;
		--RAISE NOTICE  '% is geom_shape_id 1', geom_shape_id;

		IF (NEW."GeomShapeID" > 20 AND geom_shape_group_type = 'LineString') THEN
		    geom_shape_id = geom_shape_id - 20;
		ELSIF (NEW."GeomShapeID" < 20 AND geom_shape_group_type = 'Polygon') THEN
		    geom_shape_id = geom_shape_id + 20;
		END IF;

		--RAISE NOTICE  '% is geom_shape_id 2', geom_shape_id;

		NEW."GeomShapeID" := geom_shape_id;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION "public"."set_bay_geom_type"() OWNER TO "postgres";

--
-- TOC entry 1086 (class 1255 OID 18558)
-- Name: set_create_details(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION "public"."set_create_details"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
    BEGIN
	    -- round to two decimal places
        NEW."CreateDateTime" := now();
        NEW."CreatePerson" := current_user;

        RETURN NEW;
    END;
$$;


ALTER FUNCTION "public"."set_create_details"() OWNER TO "postgres";

--
-- TOC entry 1082 (class 1255 OID 17463)
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
-- TOC entry 1084 (class 1255 OID 18446)
-- Name: set_original_geometry(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION "public"."set_original_geometry"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
    BEGIN
        -- Copy geometry to originalGeometry
        NEW."original_geom_wkt" := ST_AsText(NEW."geom");

        RETURN NEW;
    END;
$$;


ALTER FUNCTION "public"."set_original_geometry"() OWNER TO "postgres";

--
-- TOC entry 1083 (class 1255 OID 17464)
-- Name: set_restriction_length(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION "public"."set_restriction_length"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
    BEGIN
	    -- round to two decimal places
        NEW."RestrictionLength" := ROUND(public.ST_Length (NEW."geom")::numeric,2);

        RETURN NEW;
    END;
$$;


ALTER FUNCTION "public"."set_restriction_length"() OWNER TO "postgres";

--
-- TOC entry 1087 (class 1255 OID 18573)
-- Name: update_capacity(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION "public"."update_capacity"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	 vehicleLength real := 0.0;
	 vehicleWidth real := 0.0;
	 motorcycleWidth real := 0.0;
	 restrictionLength real := 0.0;
BEGIN

    select "Value" into vehicleLength
        from "mhtc_operations"."project_parameters"
        where "Field" = 'VehicleLength';

    select "Value" into vehicleWidth
        from "mhtc_operations"."project_parameters"
        where "Field" = 'VehicleWidth';

    select "Value" into motorcycleWidth
        from "mhtc_operations"."project_parameters"
        where "Field" = 'MotorcycleWidth';

    IF vehicleLength IS NULL OR vehicleWidth IS NULL OR motorcycleWidth IS NULL THEN
        RAISE EXCEPTION 'Capacity parameters not available ...';
        RETURN OLD;
    END IF;

    CASE
        WHEN NEW."RestrictionTypeID" IN (117,118) THEN NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/motorcycleWidth);
        WHEN NEW."RestrictionTypeID" < 200 THEN  -- May need to specify the bay types to be used
            CASE WHEN NEW."NrBays" > 0 THEN NEW."Capacity" = NEW."NrBays";
                 WHEN NEW."GeomShapeID" IN (4,5, 6, 24, 25, 26) THEN NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleWidth);
                 WHEN NEW."RestrictionLength" >=(vehicleLength*4) THEN
                     CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength-1.0) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                          END CASE;
                 WHEN public.ST_Length (NEW."geom") <=(vehicleLength-1.0) THEN NEW."Capacity" = 1;
                 ELSE
                     CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength-1.0) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                          END CASE;
            END CASE;
        ELSE
            CASE WHEN NEW."RestrictionTypeID" IN (201, 216, 217, 224, 225) THEN
                     CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength-1.0) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                          END CASE;
                 ELSE NEW."Capacity" = 0;
                 END CASE;
        END CASE;

	RETURN NEW;

END;
$$;


ALTER FUNCTION "public"."update_capacity"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 223 (class 1259 OID 17465)
-- Name: RestrictionRoadMarkingsFadedTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" OWNER TO "postgres";

--
-- TOC entry 224 (class 1259 OID 17471)
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
-- TOC entry 4678 (class 0 OID 0)
-- Dependencies: 224
-- Name: BayLinesFadedTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."BayLinesFadedTypes_Code_seq" OWNED BY "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"."Code";


--
-- TOC entry 225 (class 1259 OID 17473)
-- Name: Restriction_SignIssueTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."Restriction_SignIssueTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."Restriction_SignIssueTypes" OWNER TO "postgres";

--
-- TOC entry 226 (class 1259 OID 17479)
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
-- TOC entry 4681 (class 0 OID 0)
-- Dependencies: 226
-- Name: BaysLines_SignIssueTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."BaysLines_SignIssueTypes_Code_seq" OWNED BY "compliance_lookups"."Restriction_SignIssueTypes"."Code";


--
-- TOC entry 227 (class 1259 OID 17481)
-- Name: ConditionTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."ConditionTypes" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "compliance_lookups"."ConditionTypes" OWNER TO "postgres";

--
-- TOC entry 228 (class 1259 OID 17484)
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
-- TOC entry 4684 (class 0 OID 0)
-- Dependencies: 228
-- Name: ConditionTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."ConditionTypes_Code_seq" OWNED BY "compliance_lookups"."ConditionTypes"."Code";


--
-- TOC entry 229 (class 1259 OID 17486)
-- Name: MHTC_CheckIssueTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."MHTC_CheckIssueTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."MHTC_CheckIssueTypes" OWNER TO "postgres";

--
-- TOC entry 230 (class 1259 OID 17492)
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
-- TOC entry 4687 (class 0 OID 0)
-- Dependencies: 230
-- Name: MHTC_CheckIssueType_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."MHTC_CheckIssueType_Code_seq" OWNED BY "compliance_lookups"."MHTC_CheckIssueTypes"."Code";


--
-- TOC entry 231 (class 1259 OID 17494)
-- Name: MHTC_CheckStatus; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."MHTC_CheckStatus" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."MHTC_CheckStatus" OWNER TO "postgres";

--
-- TOC entry 232 (class 1259 OID 17500)
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
-- TOC entry 4690 (class 0 OID 0)
-- Dependencies: 232
-- Name: MHTC_CheckStatus_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."MHTC_CheckStatus_Code_seq" OWNED BY "compliance_lookups"."MHTC_CheckStatus"."Code";


--
-- TOC entry 323 (class 1259 OID 18443)
-- Name: SignAttachmentTypes_Code_seq; Type: SEQUENCE; Schema: compliance_lookups; Owner: postgres
--

CREATE SEQUENCE "compliance_lookups"."SignAttachmentTypes_Code_seq"
    START WITH 10
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE "compliance_lookups"."SignAttachmentTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 233 (class 1259 OID 17502)
-- Name: SignAttachmentTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignAttachmentTypes" (
    "Code" integer DEFAULT "nextval"('"compliance_lookups"."SignAttachmentTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignAttachmentTypes" OWNER TO "postgres";

--
-- TOC entry 234 (class 1259 OID 17508)
-- Name: SignConditionTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignConditionTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignConditionTypes" OWNER TO "postgres";

--
-- TOC entry 235 (class 1259 OID 17514)
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
-- TOC entry 4695 (class 0 OID 0)
-- Dependencies: 235
-- Name: SignConditionTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignConditionTypes_Code_seq" OWNED BY "compliance_lookups"."SignConditionTypes"."Code";


--
-- TOC entry 236 (class 1259 OID 17516)
-- Name: SignFadedTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignFadedTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignFadedTypes" OWNER TO "postgres";

--
-- TOC entry 237 (class 1259 OID 17522)
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
-- TOC entry 4698 (class 0 OID 0)
-- Dependencies: 237
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignFadedTypes_id_seq" OWNED BY "compliance_lookups"."SignFadedTypes"."id";


--
-- TOC entry 238 (class 1259 OID 17524)
-- Name: SignIlluminationTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignIlluminationTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignIlluminationTypes" OWNER TO "postgres";

--
-- TOC entry 239 (class 1259 OID 17530)
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
-- TOC entry 4701 (class 0 OID 0)
-- Dependencies: 239
-- Name: SignIlluminationTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignIlluminationTypes_Code_seq" OWNED BY "compliance_lookups"."SignIlluminationTypes"."Code";


--
-- TOC entry 240 (class 1259 OID 17532)
-- Name: SignMountTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignMountTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignMountTypes" OWNER TO "postgres";

--
-- TOC entry 241 (class 1259 OID 17538)
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
-- TOC entry 4704 (class 0 OID 0)
-- Dependencies: 241
-- Name: SignMountTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignMountTypes_id_seq" OWNED BY "compliance_lookups"."SignMountTypes"."id";


--
-- TOC entry 242 (class 1259 OID 17540)
-- Name: SignObscurredTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."SignObscurredTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."SignObscurredTypes" OWNER TO "postgres";

--
-- TOC entry 243 (class 1259 OID 17546)
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
-- TOC entry 4707 (class 0 OID 0)
-- Dependencies: 243
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."SignObscurredTypes_id_seq" OWNED BY "compliance_lookups"."SignObscurredTypes"."id";


--
-- TOC entry 244 (class 1259 OID 17548)
-- Name: TicketMachineIssueTypes; Type: TABLE; Schema: compliance_lookups; Owner: postgres
--

CREATE TABLE "compliance_lookups"."TicketMachineIssueTypes" (
    "id" integer NOT NULL,
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "compliance_lookups"."TicketMachineIssueTypes" OWNER TO "postgres";

--
-- TOC entry 245 (class 1259 OID 17554)
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
-- TOC entry 4710 (class 0 OID 0)
-- Dependencies: 245
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: compliance_lookups; Owner: postgres
--

ALTER SEQUENCE "compliance_lookups"."TicketMachineIssueTypes_id_seq" OWNED BY "compliance_lookups"."TicketMachineIssueTypes"."id";


--
-- TOC entry 246 (class 1259 OID 17558)
-- Name: itn_roadcentreline; Type: TABLE; Schema: highways_network; Owner: postgres
--

CREATE TABLE "highways_network"."itn_roadcentreline" (
    "gid" integer NOT NULL,
    "toid" character varying(16) NOT NULL,
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
-- TOC entry 247 (class 1259 OID 17564)
-- Name: itn_roadcentreline_gid_seq; Type: SEQUENCE; Schema: highways_network; Owner: postgres
--

CREATE SEQUENCE "highways_network"."itn_roadcentreline_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highways_network"."itn_roadcentreline_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4713 (class 0 OID 0)
-- Dependencies: 247
-- Name: itn_roadcentreline_gid_seq; Type: SEQUENCE OWNED BY; Schema: highways_network; Owner: postgres
--

ALTER SEQUENCE "highways_network"."itn_roadcentreline_gid_seq" OWNED BY "highways_network"."itn_roadcentreline"."gid";


--
-- TOC entry 329 (class 1259 OID 18544)
-- Name: PayParkingAreas; Type: TABLE; Schema: local_authority; Owner: postgres
--

CREATE TABLE "local_authority"."PayParkingAreas" (
    "Code" integer NOT NULL,
    "geom" "public"."geometry"(Polygon,27700) NOT NULL,
    "RoadName" character varying NOT NULL,
    "TariffGroup" integer,
    "Postcode" character varying,
    "CostCode" character varying,
    "Spaces" integer,
    "DisabledBays" integer,
    "MotorbikeBays" integer,
    "CoachBays" integer,
    "PremierBays" integer,
    "MaxStayID" integer
);


ALTER TABLE "local_authority"."PayParkingAreas" OWNER TO "postgres";

--
-- TOC entry 248 (class 1259 OID 17566)
-- Name: SiteArea; Type: TABLE; Schema: local_authority; Owner: postgres
--

CREATE TABLE "local_authority"."SiteArea" (
    "id" integer NOT NULL,
    "name" character varying(32),
    "geom" "public"."geometry"(MultiPolygon,27700)
);


ALTER TABLE "local_authority"."SiteArea" OWNER TO "postgres";

--
-- TOC entry 249 (class 1259 OID 17572)
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
-- TOC entry 4717 (class 0 OID 0)
-- Dependencies: 249
-- Name: SiteArea_id_seq; Type: SEQUENCE OWNED BY; Schema: local_authority; Owner: postgres
--

ALTER SEQUENCE "local_authority"."SiteArea_id_seq" OWNED BY "local_authority"."SiteArea"."id";


--
-- TOC entry 250 (class 1259 OID 17574)
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
-- TOC entry 251 (class 1259 OID 17580)
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
-- TOC entry 4720 (class 0 OID 0)
-- Dependencies: 251
-- Name: StreetGazetteerRecords_id_seq; Type: SEQUENCE OWNED BY; Schema: local_authority; Owner: postgres
--

ALTER SEQUENCE "local_authority"."StreetGazetteerRecords_id_seq" OWNED BY "local_authority"."StreetGazetteerRecords"."id";


--
-- TOC entry 326 (class 1259 OID 18468)
-- Name: AreasForReview_id_seq; Type: SEQUENCE; Schema: mhtc_operations; Owner: postgres
--

CREATE SEQUENCE "mhtc_operations"."AreasForReview_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "mhtc_operations"."AreasForReview_id_seq" OWNER TO "postgres";

--
-- TOC entry 327 (class 1259 OID 18470)
-- Name: AreasForReview; Type: TABLE; Schema: mhtc_operations; Owner: postgres
--

CREATE TABLE "mhtc_operations"."AreasForReview" (
    "id" integer DEFAULT "nextval"('"mhtc_operations"."AreasForReview_id_seq"'::"regclass") NOT NULL,
    "geom" "public"."geometry"(Polygon,27700),
    "Notes" character varying(255)
);


ALTER TABLE "mhtc_operations"."AreasForReview" OWNER TO "postgres";

--
-- TOC entry 312 (class 1259 OID 17833)
-- Name: Corners; Type: TABLE; Schema: mhtc_operations; Owner: postgres
--

CREATE TABLE "mhtc_operations"."Corners" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(Point,27700)
);


ALTER TABLE "mhtc_operations"."Corners" OWNER TO "postgres";

--
-- TOC entry 313 (class 1259 OID 17839)
-- Name: Corners_id_seq; Type: SEQUENCE; Schema: mhtc_operations; Owner: postgres
--

CREATE SEQUENCE "mhtc_operations"."Corners_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "mhtc_operations"."Corners_id_seq" OWNER TO "postgres";

--
-- TOC entry 4724 (class 0 OID 0)
-- Dependencies: 313
-- Name: Corners_id_seq; Type: SEQUENCE OWNED BY; Schema: mhtc_operations; Owner: postgres
--

ALTER SEQUENCE "mhtc_operations"."Corners_id_seq" OWNED BY "mhtc_operations"."Corners"."id";


--
-- TOC entry 324 (class 1259 OID 18456)
-- Name: gnss_pts_id_seq; Type: SEQUENCE; Schema: mhtc_operations; Owner: postgres
--

CREATE SEQUENCE "mhtc_operations"."gnss_pts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE "mhtc_operations"."gnss_pts_id_seq" OWNER TO "postgres";

--
-- TOC entry 325 (class 1259 OID 18458)
-- Name: gnss_pts; Type: TABLE; Schema: mhtc_operations; Owner: postgres
--

CREATE TABLE "mhtc_operations"."gnss_pts" (
    "id" integer DEFAULT "nextval"('"mhtc_operations"."gnss_pts_id_seq"'::"regclass") NOT NULL,
    "geom" "public"."geometry"(Point,27700) NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "hacc" double precision,
    "satellitesUsed" integer,
    "pdop" double precision,
    "fixMode" character varying,
    "fixType" integer,
    "quality" integer,
    "satPrn" integer[],
    "utcDateTime" timestamp without time zone NOT NULL
);


ALTER TABLE "mhtc_operations"."gnss_pts" OWNER TO "postgres";

--
-- TOC entry 330 (class 1259 OID 18565)
-- Name: project_parameters; Type: TABLE; Schema: mhtc_operations; Owner: postgres
--

CREATE TABLE "mhtc_operations"."project_parameters" (
    "Field" character varying NOT NULL,
    "Value" character varying NOT NULL
);


ALTER TABLE "mhtc_operations"."project_parameters" OWNER TO "postgres";

--
-- TOC entry 252 (class 1259 OID 17582)
-- Name: RC_Polyline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RC_Polyline" (
    "geom" "public"."geometry",
    "id" integer NOT NULL
);


ALTER TABLE "public"."RC_Polyline" OWNER TO "postgres";

--
-- TOC entry 253 (class 1259 OID 17588)
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
-- TOC entry 4729 (class 0 OID 0)
-- Dependencies: 253
-- Name: RC_Polyline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RC_Polyline_id_seq" OWNED BY "public"."RC_Polyline"."id";


--
-- TOC entry 254 (class 1259 OID 17590)
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
-- TOC entry 255 (class 1259 OID 17596)
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
-- TOC entry 4730 (class 0 OID 0)
-- Dependencies: 255
-- Name: RC_Sections_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RC_Sections_gid_seq" OWNED BY "public"."RC_Sections"."gid";


--
-- TOC entry 256 (class 1259 OID 17598)
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
-- TOC entry 257 (class 1259 OID 17604)
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
-- TOC entry 4731 (class 0 OID 0)
-- Dependencies: 257
-- Name: RC_Sections_merged_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RC_Sections_merged_gid_seq" OWNED BY "public"."RC_Sections_merged"."gid";


--
-- TOC entry 328 (class 1259 OID 18480)
-- Name: SignTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."SignTypes_id_seq"
    START WITH 130
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."SignTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 258 (class 1259 OID 17606)
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
-- TOC entry 259 (class 1259 OID 17608)
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
    "MHTC_CheckNotes" character varying(254),
    "PermitCode" character varying(255),
    "MatchDayTimePeriodID" integer,
    "PayParkingAreaID" integer,
    "CreateDateTime" timestamp without time zone NOT NULL,
    "CreatePerson" character varying(255) NOT NULL,
    "Capacity" integer
);


ALTER TABLE "toms"."Bays" OWNER TO "postgres";

--
-- TOC entry 260 (class 1259 OID 17616)
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
-- TOC entry 261 (class 1259 OID 17618)
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
    "MHTC_CheckNotes" character varying(254),
    "MatchDayTimePeriodID" integer,
    "CreateDateTime" timestamp without time zone NOT NULL,
    "CreatePerson" character varying(255) NOT NULL
);


ALTER TABLE "toms"."ControlledParkingZones" OWNER TO "postgres";

--
-- TOC entry 262 (class 1259 OID 17625)
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
-- TOC entry 263 (class 1259 OID 17627)
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
    "MHTC_CheckNotes" character varying(254),
    "ComplianceLoadingMarkingsFaded" integer,
    "MatchDayTimePeriodID" integer,
    "CreateDateTime" timestamp without time zone NOT NULL,
    "CreatePerson" character varying(255) NOT NULL,
    "Capacity" integer
);


ALTER TABLE "toms"."Lines" OWNER TO "postgres";

--
-- TOC entry 264 (class 1259 OID 17634)
-- Name: MapGrid; Type: TABLE; Schema: toms; Owner: postgres
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


ALTER TABLE "toms"."MapGrid" OWNER TO "postgres";

--
-- TOC entry 265 (class 1259 OID 17640)
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
-- TOC entry 266 (class 1259 OID 17642)
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
    "MHTC_CheckNotes" character varying(254),
    "MatchDayTimePeriodID" integer,
    "CreateDateTime" timestamp without time zone NOT NULL,
    "CreatePerson" character varying(255) NOT NULL
);


ALTER TABLE "toms"."ParkingTariffAreas" OWNER TO "postgres";

--
-- TOC entry 267 (class 1259 OID 17649)
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
-- TOC entry 268 (class 1259 OID 17651)
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
-- TOC entry 269 (class 1259 OID 17658)
-- Name: RestrictionLayers; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."RestrictionLayers" (
    "Code" integer NOT NULL,
    "RestrictionLayerName" character varying(255) NOT NULL
);


ALTER TABLE "toms"."RestrictionLayers" OWNER TO "postgres";

--
-- TOC entry 270 (class 1259 OID 17661)
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
-- TOC entry 4744 (class 0 OID 0)
-- Dependencies: 270
-- Name: RestrictionLayers_id_seq; Type: SEQUENCE OWNED BY; Schema: toms; Owner: postgres
--

ALTER SEQUENCE "toms"."RestrictionLayers_id_seq" OWNED BY "toms"."RestrictionLayers"."Code";


--
-- TOC entry 271 (class 1259 OID 17663)
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
-- TOC entry 272 (class 1259 OID 17665)
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
    "MHTC_CheckNotes" character varying(254),
    "MatchDayTimePeriodID" integer,
    "CreateDateTime" timestamp without time zone NOT NULL,
    "CreatePerson" character varying(255) NOT NULL,
    "AdditionalConditionID" integer
);


ALTER TABLE "toms"."RestrictionPolygons" OWNER TO "postgres";

--
-- TOC entry 273 (class 1259 OID 17672)
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
-- TOC entry 274 (class 1259 OID 17675)
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
-- TOC entry 275 (class 1259 OID 17677)
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
    "SignsAttachmentTypeID" integer,
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
    "original_geom_wkt" character varying(255),
    "AssetReference" character varying(255),
    "CreateDateTime" timestamp without time zone NOT NULL,
    "CreatePerson" character varying(255) NOT NULL
);


ALTER TABLE "toms"."Signs" OWNER TO "postgres";

--
-- TOC entry 276 (class 1259 OID 17684)
-- Name: TilesInAcceptedProposals; Type: TABLE; Schema: toms; Owner: postgres
--

CREATE TABLE "toms"."TilesInAcceptedProposals" (
    "ProposalID" integer NOT NULL,
    "TileNr" integer NOT NULL,
    "RevisionNr" integer NOT NULL
);


ALTER TABLE "toms"."TilesInAcceptedProposals" OWNER TO "postgres";

--
-- TOC entry 277 (class 1259 OID 17687)
-- Name: ActionOnProposalAcceptanceTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."ActionOnProposalAcceptanceTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."ActionOnProposalAcceptanceTypes" OWNER TO "postgres";

--
-- TOC entry 278 (class 1259 OID 17693)
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
-- TOC entry 4753 (class 0 OID 0)
-- Dependencies: 278
-- Name: ActionOnProposalAcceptanceTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq" OWNED BY "toms_lookups"."ActionOnProposalAcceptanceTypes"."Code";


--
-- TOC entry 279 (class 1259 OID 17695)
-- Name: AdditionalConditionTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."AdditionalConditionTypes" (
    "Code" integer NOT NULL,
    "Description" character varying(255) NOT NULL
);


ALTER TABLE "toms_lookups"."AdditionalConditionTypes" OWNER TO "postgres";

--
-- TOC entry 280 (class 1259 OID 17698)
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
-- TOC entry 4756 (class 0 OID 0)
-- Dependencies: 280
-- Name: AdditionalConditionTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."AdditionalConditionTypes_Code_seq" OWNED BY "toms_lookups"."AdditionalConditionTypes"."Code";


--
-- TOC entry 281 (class 1259 OID 17700)
-- Name: BayLineTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."BayLineTypes" (
    "Code" integer NOT NULL,
    "Description" character varying(255) NOT NULL
);


ALTER TABLE "toms_lookups"."BayLineTypes" OWNER TO "postgres";

--
-- TOC entry 282 (class 1259 OID 17703)
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
-- TOC entry 4759 (class 0 OID 0)
-- Dependencies: 282
-- Name: BayLineTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."BayLineTypes_Code_seq" OWNED BY "toms_lookups"."BayLineTypes"."Code";


--
-- TOC entry 283 (class 1259 OID 17705)
-- Name: BayTypesInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."BayTypesInUse" (
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) NOT NULL,
    "StyleDetails" character varying
);


ALTER TABLE "toms_lookups"."BayTypesInUse" OWNER TO "postgres";

--
-- TOC entry 284 (class 1259 OID 17711)
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
-- TOC entry 285 (class 1259 OID 17715)
-- Name: GeomShapeGroupType; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."GeomShapeGroupType" (
    "Code" character varying(255) NOT NULL
);


ALTER TABLE "toms_lookups"."GeomShapeGroupType" OWNER TO "postgres";

--
-- TOC entry 286 (class 1259 OID 17718)
-- Name: LengthOfTime; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."LengthOfTime" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL,
    "LabelText" character varying(255)
);


ALTER TABLE "toms_lookups"."LengthOfTime" OWNER TO "postgres";

--
-- TOC entry 287 (class 1259 OID 17724)
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
-- TOC entry 4765 (class 0 OID 0)
-- Dependencies: 287
-- Name: LengthOfTime_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."LengthOfTime_Code_seq" OWNED BY "toms_lookups"."LengthOfTime"."Code";


--
-- TOC entry 288 (class 1259 OID 17726)
-- Name: LineTypesInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."LineTypesInUse" (
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) NOT NULL,
    "StyleDetails" character varying
);


ALTER TABLE "toms_lookups"."LineTypesInUse" OWNER TO "postgres";

--
-- TOC entry 289 (class 1259 OID 17732)
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
-- TOC entry 290 (class 1259 OID 17736)
-- Name: PaymentTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."PaymentTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."PaymentTypes" OWNER TO "postgres";

--
-- TOC entry 291 (class 1259 OID 17742)
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
-- TOC entry 4770 (class 0 OID 0)
-- Dependencies: 291
-- Name: PaymentTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."PaymentTypes_Code_seq" OWNED BY "toms_lookups"."PaymentTypes"."Code";


--
-- TOC entry 292 (class 1259 OID 17744)
-- Name: ProposalStatusTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."ProposalStatusTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."ProposalStatusTypes" OWNER TO "postgres";

--
-- TOC entry 293 (class 1259 OID 17750)
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
-- TOC entry 4773 (class 0 OID 0)
-- Dependencies: 293
-- Name: ProposalStatusTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."ProposalStatusTypes_Code_seq" OWNED BY "toms_lookups"."ProposalStatusTypes"."Code";


--
-- TOC entry 294 (class 1259 OID 17752)
-- Name: RestrictionGeomShapeTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."RestrictionGeomShapeTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."RestrictionGeomShapeTypes" OWNER TO "postgres";

--
-- TOC entry 295 (class 1259 OID 17758)
-- Name: RestrictionPolygonTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."RestrictionPolygonTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."RestrictionPolygonTypes" OWNER TO "postgres";

--
-- TOC entry 296 (class 1259 OID 17764)
-- Name: RestrictionPolygonTypesInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."RestrictionPolygonTypesInUse" (
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) NOT NULL,
    "StyleDetails" character varying
);


ALTER TABLE "toms_lookups"."RestrictionPolygonTypesInUse" OWNER TO "postgres";

--
-- TOC entry 297 (class 1259 OID 17770)
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
-- TOC entry 298 (class 1259 OID 17777)
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
-- TOC entry 4779 (class 0 OID 0)
-- Dependencies: 298
-- Name: RestrictionPolygonTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."RestrictionPolygonTypes_Code_seq" OWNED BY "toms_lookups"."RestrictionPolygonTypes"."Code";


--
-- TOC entry 299 (class 1259 OID 17779)
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
-- TOC entry 4781 (class 0 OID 0)
-- Dependencies: 299
-- Name: RestrictionShapeTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."RestrictionShapeTypes_Code_seq" OWNED BY "toms_lookups"."RestrictionGeomShapeTypes"."Code";


--
-- TOC entry 300 (class 1259 OID 17781)
-- Name: SignOrientationTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."SignOrientationTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."SignOrientationTypes" OWNER TO "postgres";

--
-- TOC entry 301 (class 1259 OID 17787)
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
-- TOC entry 4784 (class 0 OID 0)
-- Dependencies: 301
-- Name: SignOrientationTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."SignOrientationTypes_Code_seq" OWNED BY "toms_lookups"."SignOrientationTypes"."Code";


--
-- TOC entry 302 (class 1259 OID 17789)
-- Name: SignTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."SignTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL,
    "Icon" character varying(255)
);


ALTER TABLE "toms_lookups"."SignTypes" OWNER TO "postgres";

--
-- TOC entry 303 (class 1259 OID 17795)
-- Name: SignTypesInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."SignTypesInUse" (
    "Code" integer NOT NULL
);


ALTER TABLE "toms_lookups"."SignTypesInUse" OWNER TO "postgres";

--
-- TOC entry 304 (class 1259 OID 17798)
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
-- TOC entry 305 (class 1259 OID 17805)
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
-- TOC entry 4789 (class 0 OID 0)
-- Dependencies: 305
-- Name: SignTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."SignTypes_Code_seq" OWNED BY "toms_lookups"."SignTypes"."Code";


--
-- TOC entry 306 (class 1259 OID 17807)
-- Name: TimePeriods; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."TimePeriods" (
    "Code" integer NOT NULL,
    "Description" character varying,
    "LabelText" character varying(255)
);


ALTER TABLE "toms_lookups"."TimePeriods" OWNER TO "postgres";

--
-- TOC entry 307 (class 1259 OID 17813)
-- Name: TimePeriodsInUse; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."TimePeriodsInUse" (
    "Code" integer NOT NULL
);


ALTER TABLE "toms_lookups"."TimePeriodsInUse" OWNER TO "postgres";

--
-- TOC entry 308 (class 1259 OID 17816)
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
-- TOC entry 309 (class 1259 OID 17823)
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
-- TOC entry 4794 (class 0 OID 0)
-- Dependencies: 309
-- Name: TimePeriods_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."TimePeriods_Code_seq" OWNED BY "toms_lookups"."TimePeriods"."Code";


--
-- TOC entry 310 (class 1259 OID 17825)
-- Name: UnacceptableTypes; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."UnacceptableTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "toms_lookups"."UnacceptableTypes" OWNER TO "postgres";

--
-- TOC entry 311 (class 1259 OID 17831)
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
-- TOC entry 4797 (class 0 OID 0)
-- Dependencies: 311
-- Name: UnacceptableTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: toms_lookups; Owner: postgres
--

ALTER SEQUENCE "toms_lookups"."UnacceptableTypes_Code_seq" OWNED BY "toms_lookups"."UnacceptableTypes"."Code";


--
-- TOC entry 316 (class 1259 OID 17849)
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
-- TOC entry 317 (class 1259 OID 17855)
-- Name: os_mastermap_topography_polygons_seq; Type: SEQUENCE; Schema: topography; Owner: postgres
--

CREATE SEQUENCE "topography"."os_mastermap_topography_polygons_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "topography"."os_mastermap_topography_polygons_seq" OWNER TO "postgres";

--
-- TOC entry 4800 (class 0 OID 0)
-- Dependencies: 317
-- Name: os_mastermap_topography_polygons_seq; Type: SEQUENCE OWNED BY; Schema: topography; Owner: postgres
--

ALTER SEQUENCE "topography"."os_mastermap_topography_polygons_seq" OWNED BY "topography"."os_mastermap_topography_polygons"."gid";


--
-- TOC entry 314 (class 1259 OID 17841)
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
-- TOC entry 315 (class 1259 OID 17847)
-- Name: os_mastermap_topography_text_seq; Type: SEQUENCE; Schema: topography; Owner: postgres
--

CREATE SEQUENCE "topography"."os_mastermap_topography_text_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "topography"."os_mastermap_topography_text_seq" OWNER TO "postgres";

--
-- TOC entry 4803 (class 0 OID 0)
-- Dependencies: 315
-- Name: os_mastermap_topography_text_seq; Type: SEQUENCE OWNED BY; Schema: topography; Owner: postgres
--

ALTER SEQUENCE "topography"."os_mastermap_topography_text_seq" OWNED BY "topography"."os_mastermap_topography_text"."gid";


--
-- TOC entry 318 (class 1259 OID 17857)
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
-- TOC entry 319 (class 1259 OID 17863)
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
-- TOC entry 320 (class 1259 OID 17869)
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
-- TOC entry 321 (class 1259 OID 17875)
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
-- TOC entry 322 (class 1259 OID 17881)
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
-- TOC entry 4806 (class 0 OID 0)
-- Dependencies: 322
-- Name: RC_Polygon_id_seq; Type: SEQUENCE OWNED BY; Schema: transfer; Owner: postgres
--

ALTER SEQUENCE "transfer"."RC_Polygon_id_seq" OWNED BY "transfer"."RC_Polygon"."id";


--
-- TOC entry 4101 (class 2604 OID 17885)
-- Name: ConditionTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."ConditionTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."ConditionTypes_Code_seq"'::"regclass");


--
-- TOC entry 4102 (class 2604 OID 17886)
-- Name: MHTC_CheckIssueTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."MHTC_CheckIssueTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."MHTC_CheckIssueType_Code_seq"'::"regclass");


--
-- TOC entry 4103 (class 2604 OID 17887)
-- Name: MHTC_CheckStatus Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."MHTC_CheckStatus" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."MHTC_CheckStatus_Code_seq"'::"regclass");


--
-- TOC entry 4099 (class 2604 OID 17883)
-- Name: RestrictionRoadMarkingsFadedTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."BayLinesFadedTypes_Code_seq"'::"regclass");


--
-- TOC entry 4100 (class 2604 OID 17884)
-- Name: Restriction_SignIssueTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."Restriction_SignIssueTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."BaysLines_SignIssueTypes_Code_seq"'::"regclass");


--
-- TOC entry 4105 (class 2604 OID 17889)
-- Name: SignConditionTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignConditionTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."SignConditionTypes_Code_seq"'::"regclass");


--
-- TOC entry 4106 (class 2604 OID 17890)
-- Name: SignFadedTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignFadedTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."SignFadedTypes_id_seq"'::"regclass");


--
-- TOC entry 4107 (class 2604 OID 17891)
-- Name: SignIlluminationTypes Code; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignIlluminationTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"compliance_lookups"."SignIlluminationTypes_Code_seq"'::"regclass");


--
-- TOC entry 4108 (class 2604 OID 17892)
-- Name: SignMountTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignMountTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."SignMountTypes_id_seq"'::"regclass");


--
-- TOC entry 4109 (class 2604 OID 17893)
-- Name: SignObscurredTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignObscurredTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."SignObscurredTypes_id_seq"'::"regclass");


--
-- TOC entry 4110 (class 2604 OID 17894)
-- Name: TicketMachineIssueTypes id; Type: DEFAULT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."TicketMachineIssueTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"compliance_lookups"."TicketMachineIssueTypes_id_seq"'::"regclass");


--
-- TOC entry 4111 (class 2604 OID 17895)
-- Name: itn_roadcentreline gid; Type: DEFAULT; Schema: highways_network; Owner: postgres
--

ALTER TABLE ONLY "highways_network"."itn_roadcentreline" ALTER COLUMN "gid" SET DEFAULT "nextval"('"highways_network"."itn_roadcentreline_gid_seq"'::"regclass");


--
-- TOC entry 4112 (class 2604 OID 17896)
-- Name: SiteArea id; Type: DEFAULT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."SiteArea" ALTER COLUMN "id" SET DEFAULT "nextval"('"local_authority"."SiteArea_id_seq"'::"regclass");


--
-- TOC entry 4113 (class 2604 OID 17897)
-- Name: StreetGazetteerRecords id; Type: DEFAULT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."StreetGazetteerRecords" ALTER COLUMN "id" SET DEFAULT "nextval"('"local_authority"."StreetGazetteerRecords_id_seq"'::"regclass");


--
-- TOC entry 4138 (class 2604 OID 17914)
-- Name: Corners id; Type: DEFAULT; Schema: mhtc_operations; Owner: postgres
--

ALTER TABLE ONLY "mhtc_operations"."Corners" ALTER COLUMN "id" SET DEFAULT "nextval"('"mhtc_operations"."Corners_id_seq"'::"regclass");


--
-- TOC entry 4114 (class 2604 OID 17898)
-- Name: RC_Polyline id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Polyline" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."RC_Polyline_id_seq"'::"regclass");


--
-- TOC entry 4115 (class 2604 OID 17899)
-- Name: RC_Sections gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Sections" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."RC_Sections_gid_seq"'::"regclass");


--
-- TOC entry 4116 (class 2604 OID 17900)
-- Name: RC_Sections_merged gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Sections_merged" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."RC_Sections_merged_gid_seq"'::"regclass");


--
-- TOC entry 4123 (class 2604 OID 17901)
-- Name: RestrictionLayers Code; Type: DEFAULT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionLayers" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms"."RestrictionLayers_id_seq"'::"regclass");


--
-- TOC entry 4126 (class 2604 OID 17902)
-- Name: ActionOnProposalAcceptanceTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."ActionOnProposalAcceptanceTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq"'::"regclass");


--
-- TOC entry 4127 (class 2604 OID 17903)
-- Name: AdditionalConditionTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."AdditionalConditionTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."AdditionalConditionTypes_Code_seq"'::"regclass");


--
-- TOC entry 4128 (class 2604 OID 17904)
-- Name: BayLineTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."BayLineTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."BayLineTypes_Code_seq"'::"regclass");


--
-- TOC entry 4129 (class 2604 OID 17905)
-- Name: LengthOfTime Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."LengthOfTime" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."LengthOfTime_Code_seq"'::"regclass");


--
-- TOC entry 4130 (class 2604 OID 17906)
-- Name: PaymentTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."PaymentTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."PaymentTypes_Code_seq"'::"regclass");


--
-- TOC entry 4131 (class 2604 OID 17907)
-- Name: ProposalStatusTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."ProposalStatusTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."ProposalStatusTypes_Code_seq"'::"regclass");


--
-- TOC entry 4132 (class 2604 OID 17908)
-- Name: RestrictionGeomShapeTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionGeomShapeTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."RestrictionShapeTypes_Code_seq"'::"regclass");


--
-- TOC entry 4133 (class 2604 OID 17909)
-- Name: RestrictionPolygonTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionPolygonTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."RestrictionPolygonTypes_Code_seq"'::"regclass");


--
-- TOC entry 4134 (class 2604 OID 17910)
-- Name: SignOrientationTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignOrientationTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."SignOrientationTypes_Code_seq"'::"regclass");


--
-- TOC entry 4135 (class 2604 OID 17911)
-- Name: SignTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."SignTypes_Code_seq"'::"regclass");


--
-- TOC entry 4136 (class 2604 OID 17912)
-- Name: TimePeriods Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."TimePeriods" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."TimePeriods_Code_seq"'::"regclass");


--
-- TOC entry 4137 (class 2604 OID 17913)
-- Name: UnacceptableTypes Code; Type: DEFAULT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."UnacceptableTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"toms_lookups"."UnacceptableTypes_Code_seq"'::"regclass");


--
-- TOC entry 4140 (class 2604 OID 17915)
-- Name: os_mastermap_topography_polygons gid; Type: DEFAULT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."os_mastermap_topography_polygons" ALTER COLUMN "gid" SET DEFAULT "nextval"('"topography"."os_mastermap_topography_polygons_seq"'::"regclass");


--
-- TOC entry 4139 (class 2604 OID 17916)
-- Name: os_mastermap_topography_text gid; Type: DEFAULT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."os_mastermap_topography_text" ALTER COLUMN "gid" SET DEFAULT "nextval"('"topography"."os_mastermap_topography_text_seq"'::"regclass");


--
-- TOC entry 4141 (class 2604 OID 17917)
-- Name: RC_Polygon id; Type: DEFAULT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."RC_Polygon" ALTER COLUMN "id" SET DEFAULT "nextval"('"transfer"."RC_Polygon_id_seq"'::"regclass");


--
-- TOC entry 4554 (class 0 OID 17481)
-- Dependencies: 227
-- Data for Name: ConditionTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4556 (class 0 OID 17486)
-- Dependencies: 229
-- Data for Name: MHTC_CheckIssueTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (1, 'Item checked - Available for release');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (10, 'Field visit - Item missed - confirm location and details');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (11, 'Field visit - Photo missing or needs to be retaken');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (15, 'Field visit - Check details (see notes)');


--
-- TOC entry 4558 (class 0 OID 17494)
-- Dependencies: 231
-- Data for Name: MHTC_CheckStatus; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4550 (class 0 OID 17465)
-- Dependencies: 223
-- Data for Name: RestrictionRoadMarkingsFadedTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ("Code", "Description") VALUES (1, 'No issue');
INSERT INTO "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ("Code", "Description") VALUES (6, 'Other (please specify in notes)');
INSERT INTO "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ("Code", "Description") VALUES (2, 'Slightly faded marking');
INSERT INTO "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ("Code", "Description") VALUES (3, 'Very faded markings');
INSERT INTO "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ("Code", "Description") VALUES (4, 'Markings not correctly removed');
INSERT INTO "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ("Code", "Description") VALUES (5, 'Missing markings');


--
-- TOC entry 4552 (class 0 OID 17473)
-- Dependencies: 225
-- Data for Name: Restriction_SignIssueTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."Restriction_SignIssueTypes" ("Code", "Description") VALUES (1, 'No issues');
INSERT INTO "compliance_lookups"."Restriction_SignIssueTypes" ("Code", "Description") VALUES (2, 'Inconsistent sign');
INSERT INTO "compliance_lookups"."Restriction_SignIssueTypes" ("Code", "Description") VALUES (3, 'Missing sign');
INSERT INTO "compliance_lookups"."Restriction_SignIssueTypes" ("Code", "Description") VALUES (4, 'Other (please specify in notes)');


--
-- TOC entry 4560 (class 0 OID 17502)
-- Dependencies: 233
-- Data for Name: SignAttachmentTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (1, 'Short Pole');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (2, 'Normal Pole');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (3, 'Tall Pole');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (4, 'Lamppost');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (5, 'Wall');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (6, 'Fences');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (7, 'Other (Please specify in notes)');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (8, 'Traffic Light');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (9, 'Large Pole');


--
-- TOC entry 4561 (class 0 OID 17508)
-- Dependencies: 234
-- Data for Name: SignConditionTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignConditionTypes" ("Code", "Description") VALUES (1, 'Good');
INSERT INTO "compliance_lookups"."SignConditionTypes" ("Code", "Description") VALUES (2, 'Damaged');
INSERT INTO "compliance_lookups"."SignConditionTypes" ("Code", "Description") VALUES (3, 'Graffitti');
INSERT INTO "compliance_lookups"."SignConditionTypes" ("Code", "Description") VALUES (4, 'Lighting to be replaced');
INSERT INTO "compliance_lookups"."SignConditionTypes" ("Code", "Description") VALUES (10, 'Other (see notes)');
INSERT INTO "compliance_lookups"."SignConditionTypes" ("Code", "Description") VALUES (5, 'Obscured');


--
-- TOC entry 4563 (class 0 OID 17516)
-- Dependencies: 236
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
-- TOC entry 4565 (class 0 OID 17524)
-- Dependencies: 238
-- Data for Name: SignIlluminationTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignIlluminationTypes" ("Code", "Description") VALUES (1, 'Yes - Internal');
INSERT INTO "compliance_lookups"."SignIlluminationTypes" ("Code", "Description") VALUES (2, 'Yes - External');
INSERT INTO "compliance_lookups"."SignIlluminationTypes" ("Code", "Description") VALUES (3, 'No');
INSERT INTO "compliance_lookups"."SignIlluminationTypes" ("Code", "Description") VALUES (4, 'Not sure');


--
-- TOC entry 4567 (class 0 OID 17532)
-- Dependencies: 240
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
-- TOC entry 4569 (class 0 OID 17540)
-- Dependencies: 242
-- Data for Name: SignObscurredTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignObscurredTypes" ("id", "Code", "Description") VALUES (1, 1, 'No issue');
INSERT INTO "compliance_lookups"."SignObscurredTypes" ("id", "Code", "Description") VALUES (2, 2, 'Partially obscured');
INSERT INTO "compliance_lookups"."SignObscurredTypes" ("id", "Code", "Description") VALUES (3, 3, 'Completely obscured');


--
-- TOC entry 4571 (class 0 OID 17548)
-- Dependencies: 244
-- Data for Name: TicketMachineIssueTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (1, 1, 'No issues');
INSERT INTO "compliance_lookups"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (2, 2, 'Defaced (e.g. graffiti)');
INSERT INTO "compliance_lookups"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (3, 3, 'Physically Damaged');
INSERT INTO "compliance_lookups"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (4, 4, 'Other (Please specify in notes)');

--
-- TOC entry 4657 (class 0 OID 18565)
-- Dependencies: 330
-- Data for Name: project_parameters; Type: TABLE DATA; Schema: mhtc_operations; Owner: postgres
--

INSERT INTO "mhtc_operations"."project_parameters" ("Field", "Value") VALUES ('VehicleLength', '5.0');
INSERT INTO "mhtc_operations"."project_parameters" ("Field", "Value") VALUES ('VehicleWidth', '2.5');
INSERT INTO "mhtc_operations"."project_parameters" ("Field", "Value") VALUES ('MotorcycleWidth', '1.00');

--
-- TOC entry 4596 (class 0 OID 17658)
-- Dependencies: 269
-- Data for Name: RestrictionLayers; Type: TABLE DATA; Schema: toms; Owner: postgres
--

INSERT INTO "toms"."RestrictionLayers" ("Code", "RestrictionLayerName") VALUES (2, 'Bays');
INSERT INTO "toms"."RestrictionLayers" ("Code", "RestrictionLayerName") VALUES (3, 'Lines');
INSERT INTO "toms"."RestrictionLayers" ("Code", "RestrictionLayerName") VALUES (5, 'Signs');
INSERT INTO "toms"."RestrictionLayers" ("Code", "RestrictionLayerName") VALUES (4, 'RestrictionPolygons');
INSERT INTO "toms"."RestrictionLayers" ("Code", "RestrictionLayerName") VALUES (6, 'CPZs');
INSERT INTO "toms"."RestrictionLayers" ("Code", "RestrictionLayerName") VALUES (7, 'ParkingTariffAreas');

--
-- TOC entry 4604 (class 0 OID 17687)
-- Dependencies: 277
-- Data for Name: ActionOnProposalAcceptanceTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."ActionOnProposalAcceptanceTypes" ("Code", "Description") VALUES (1, 'Open');
INSERT INTO "toms_lookups"."ActionOnProposalAcceptanceTypes" ("Code", "Description") VALUES (2, 'Close');


--
-- TOC entry 4606 (class 0 OID 17695)
-- Dependencies: 279
-- Data for Name: AdditionalConditionTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (1, 'except buses');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (2, 'on school entrance markings');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (3, 'on markings');


--
-- TOC entry 4608 (class 0 OID 17700)
-- Dependencies: 281
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
-- TOC entry 4610 (class 0 OID 17705)
-- Dependencies: 283
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
-- TOC entry 4612 (class 0 OID 17715)
-- Dependencies: 285
-- Data for Name: GeomShapeGroupType; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."GeomShapeGroupType" ("Code") VALUES ('LineString');
INSERT INTO "toms_lookups"."GeomShapeGroupType" ("Code") VALUES ('Polygon');


--
-- TOC entry 4613 (class 0 OID 17718)
-- Dependencies: 286
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
-- TOC entry 4615 (class 0 OID 17726)
-- Dependencies: 288
-- Data for Name: LineTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (224, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (202, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (203, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (209, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (214, 'LineString', NULL);


--
-- TOC entry 4617 (class 0 OID 17736)
-- Dependencies: 290
-- Data for Name: PaymentTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."PaymentTypes" ("Code", "Description") VALUES (1, 'No Charge');
INSERT INTO "toms_lookups"."PaymentTypes" ("Code", "Description") VALUES (2, 'Pay and Display');
INSERT INTO "toms_lookups"."PaymentTypes" ("Code", "Description") VALUES (3, 'Pay by Phone (only)');
INSERT INTO "toms_lookups"."PaymentTypes" ("Code", "Description") VALUES (4, 'Pay and Display/Pay by Phone');


--
-- TOC entry 4619 (class 0 OID 17744)
-- Dependencies: 292
-- Data for Name: ProposalStatusTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."ProposalStatusTypes" ("Code", "Description") VALUES (1, 'In Preparation');
INSERT INTO "toms_lookups"."ProposalStatusTypes" ("Code", "Description") VALUES (2, 'Accepted');
INSERT INTO "toms_lookups"."ProposalStatusTypes" ("Code", "Description") VALUES (3, 'Rejected');


--
-- TOC entry 4621 (class 0 OID 17752)
-- Dependencies: 294
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
-- TOC entry 4622 (class 0 OID 17758)
-- Dependencies: 295
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
-- TOC entry 4623 (class 0 OID 17764)
-- Dependencies: 296
-- Data for Name: RestrictionPolygonTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (1, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (3, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (4, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (2, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (6, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (7, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (8, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (21, 'Polygon', NULL);


--
-- TOC entry 4627 (class 0 OID 17781)
-- Dependencies: 300
-- Data for Name: SignOrientationTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (1, 'Facing in same direction as road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (2, 'Facing in opposite direction to road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (3, 'Facing road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (4, 'Facing away from road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (5, 'Other (specify azimuth)');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (6, 'Oblique in the same direction as road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (7, 'Oblique in the opposite direction to road');


--
-- TOC entry 4629 (class 0 OID 17789)
-- Dependencies: 302
-- Data for Name: SignTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (12, 'Parking - Red Route/Greenway Disabled Bay', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (13, 'Parking - Red Route/Greenway Loading Bay', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (14, 'Parking - Red Route/Greenway Loading/Disabled Bay', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (15, 'Parking - Red Route/Greenway Loading/Parking Bay', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (16, 'Parking - Red Route/Greenway Parking Bay', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (25, 'Other (please specify)', 'UK_traffic_sign_.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (27, 'Zone - Pedestrian Zone', 'UK_traffic_sign_618.2.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (45, 'Parking - Permit Holders only (Business)', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (46, 'Zone - Restricted Parking Zone', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (670, 'Max speed limit (other)', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (47, 'Parking - Half on/Half off (end)', 'UK_traffic_sign_667.2.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (49, 'Zone - Permit Parking Zone (PPZ) (end)', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (17, 'Parking - Half on/Half off', 'UK_traffic_sign_667.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (67020, '20 MPH (Max)', 'UK_traffic_sign_670V20.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (3, 'Parking - Bus only bay', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (48, 'Parking - Half on/Half off zone (not allowed) (start)', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (50, 'Parking - Half on/Half off zone (not allowed) (end)', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (51, 'Parking - Car Park Tariff Board', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (67030, '30 MPH  (Max)', 'UK_traffic_sign_670V30.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (52, 'Zone - Overnight Coach and Truck ban Zone start', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (67640, '40 MPH Zone', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (53, 'Zone - Overnight Coach and Truck ban Zone end', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (54, 'Other - Private Estate sign', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (67040, '40 MPH (Max)', 'UK_traffic_sign_670V40.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (67010, '10 MPH (Max)', 'UK_traffic_sign_670V10.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (67005, '5 MPH (Max)', 'UK_traffic_sign_670V05.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (675, '20 MPH Zone End - Start 30 MPH Max', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (55, 'Zone - Truck waiting ban zone start', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (56, 'Zone - Truck waiting ban zone end', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6634, 'Parking - Half on/Half off (not allowed)', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (57, 'Parking - Truck waiting ban', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (642, 'Clearway', 'UK_traffic_sign_642.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (674, '20 MPH Zone', 'UK_traffic_sign_674.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (811, 'Other moves - Priority over oncoming traffic', 'UK_traffic_sign_811.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (880, 'Speed zone reminder (with or without camera)', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (957, 'Cycling - Separated track and path for cyclists and pedestrians ', 'UK_traffic_sign_957.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (36, 'Parking - Zig-Zag school keep clear', 'UK_traffic_sign_.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (41, 'Parking - No Stopping - School', 'UK_traffic_sign_.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6291, 'Physical restriction - Width Restriction - Imperial', 'UK_traffic_sign_629.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6292, 'Physical restriction - Width Restriction', 'UK_traffic_sign_629A.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6294, 'Zone - Physical - Height Restriction', 'UK_traffic_sign_.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (1, 'Parking - 5T trucks and buses', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (2, 'Parking - Ambulances only bay', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (4, 'Parking - Bus stops/Bus stands', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (5, 'Parking - Car club bay', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6, 'Zone - CPZ entry', 'UK_traffic_sign_663.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (7, 'Zone - CPZ exit', 'UK_traffic_sign_664.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (8, 'Parking - Disabled bay', 'UK_traffic_sign_661A.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (9, 'Parking - Doctor bay', 'UK_traffic_sign_660VD.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (10, 'Parking - Electric vehicles recharging point', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (11, 'Parking - Free parking bays (not Limited Waiting)', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (618, 'Zone - Play Street', 'UK_traffic_sign_618.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6192, 'Access Restriction - All Motorcycles Prohibited', 'UK_traffic_sign_619.2.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (19, 'Parking - Loading bay', 'UK_traffic_sign_660.4.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (610, 'Other moves - Keep Left', 'UK_traffic_sign_610.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6061, 'Compulsory Turn - Proceed Right', 'UK_traffic_sign_606B.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6062, 'Compulsory Turn - Proceed Left', 'UK_traffic_sign_606.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6063, 'Compulsory Turn - Proceed Straight', 'UK_traffic_sign_606F.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (652, 'One Way - Arrow Only', 'UK_traffic_sign_652.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6092, 'Compulsory Turn - Turn Right Ahead', 'UK_traffic_sign_609A.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6091, 'Compulsory Turn - Turn Left Ahead', 'UK_traffic_sign_609.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (607, 'One Way - Words Only', 'UK_traffic_sign_607.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (616, 'One Way - No entry', 'UK_traffic_sign_616.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (613, 'Banned Turn - No Left Turn', 'UK_traffic_sign_613.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (612, 'Banned Turn - No Right Turn', 'UK_traffic_sign_612.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (614, 'Banned Turn - No U Turn', 'UK_traffic_sign_614.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (615, 'Other moves - Priority to on-coming traffic', 'UK_traffic_sign_615.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (9602, 'One-way traffic with contraflow pedal cycles', 'UK_traffic_sign_960.2.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (9601, 'One-way traffic with contraflow cycle lane', 'UK_traffic_sign_960.1.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (9541, 'Supplementary plate - Except buses', 'UK_traffic_sign_954.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (9544, 'Supplementary plate -Except cycles', 'UK_traffic_sign_954.4.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (18, 'Parking - Limited waiting (no payment)', 'UK_traffic_sign_661.1.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (20, 'Parking - Motorcycles only bay', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (21, 'Parking - No loading', 'UK_traffic_sign_638.1.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (22, 'Parking - No waiting', 'UK_traffic_sign_639.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (23, 'Parking - No waiting and no loading', 'UK_traffic_sign_640_times_arrows.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (24, 'Parking - On pavement parking', 'UK_traffic_sign_668.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (26, 'Parking - Pay and Display/Pay by Phone bays', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (28, 'Parking - Permit Holders only', 'UK_traffic_sign_660.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (29, 'Parking - Police bay', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (30, 'Parking - Private/Residents only bay', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (31, 'Parking - Permit Holders only (Residents)', 'UK_traffic_sign_660.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (32, 'Parking - Shared use bays', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (33, 'Parking - Taxi ranks', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (34, 'Other - Ticket machine', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (35, 'To be deleted', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (37, 'Pole only, no sign', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (43, 'Parking - Red Route Limited Waiting Bay', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (44, 'Zone - Restricted Parking Zone - entry', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (617, 'Access Restriction - All Vehicles Prohibited', 'UK_traffic_sign_617.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (619, 'Access Restriction - All Motor Vehicles Prohibited', 'UK_traffic_sign_619.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6262, 'Physical restriction - Weak Bridge', 'UK_traffic_sign_626.2AV2.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (955, 'Cycling - Pedal Cycles Only', 'UK_traffic_sign_955.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (956, 'Cycling - Pedestrians and Cycles only', 'UK_traffic_sign_956.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (953, 'Route used by Buses and Cycles only', 'UK_traffic_sign_953.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6191, 'Access Restriction - All Motor Vehicles except solo motorcycles prohibited', 'UK_traffic_sign_619.1.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (521, 'Warning - Two Way Traffic', 'UK_traffic_sign_521.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (522, 'Warning - Two Way Traffic on crossing ahead', 'UK_traffic_sign_522.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (9592, 'Special Lane - With flow cycle lane', 'UK_traffic_sign_959.1.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (810, 'One Way - Arrow and Words', 'UK_traffic_sign_810.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (952, 'Access Restriction - All Buses Prohibited', 'UK_traffic_sign_952.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6111, 'Compulsory Turn - Mini-roundabout', 'UK_traffic_sign_611.1.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (9581, 'Special Lane - With flow bus lane ahead (with cycles and taxis)', 'UK_traffic_sign_958.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (9591, 'Special Lane - With flow bus lane (with cycles and taxis)', 'UK_traffic_sign_959.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (951, 'Access Restriction - All Cycles prohibited', 'UK_traffic_sign_951.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (401, 'Advisory Sign (see photo)', 'UK_traffic_sign.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (201, 'Route Sign (see photo)', 'UK_traffic_sign.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (9621, 'Special Lane - Cycle lane at junction ahead', 'UK_traffic_sign_9621.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (816, 'Other - No Through Road', 'UK_traffic_sign_816.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (964, 'Special Lane - End of bus lane', 'UK_traffic_sign_964.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6101, 'Other moves - Keep Right', 'UK_traffic_sign_610R.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (620, 'Supplementary plate -Except for access', 'UK_traffic_sign_620.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6202, 'Supplementary plate -Except for loading', 'UK_traffic_sign_620.2.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (38, 'Parking - No stopping - Red Route/Greenway', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (39, 'Parking - Red Route/Greenway exit area', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (0, 'Missing', 'UK_traffic_sign_missing.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (664, 'Zone ends', 'UK_traffic_sign_664.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (42, 'On Street NOT in TRO', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (40, 'Parking - Permit Parking Zone (PPZ) (start)', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (62211, 'Physical restriction - Weight restriction', 'UK_traffic_sign_622.1A.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (64021, 'Parking - Overnight Coach and Truck ban', 'UK_traffic_sign_640.2A.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (5041, 'Warning - Crossroads ahead', 'UK_traffic_sign_504.1.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (69, 'Other - Bus information', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (5131, 'Warning - Double bend ahead - first left', 'UK_traffic_sign_513.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (5132, 'Warning - double bend ahead - first right', 'UK_traffic_sign_513R.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (556, 'Warning - Uneven road surface', 'UK_traffic_sign_556.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (5573, 'Supplementary plate - Humps in direction and for distance', 'UK_traffic_sign_557.3.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (502, 'Supplementary plate - Distance to stop sign', NULL);
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (503, 'Supplementary plate - Distance to Give way sign', 'UK_traffic_sign_503.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (779, 'Warning - Overhead electric wires', 'UK_traffic_sign_779.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (950, 'Warning - Cycles', 'UK_traffic_sign_950.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (544, 'Warning - Pedestrian Crossing', 'UK_traffic_sign_544.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (67, 'Zone - Congestion Zone', 'UK_traffic_sign_symbol_NS67.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (68, 'Other - Speed Camera', 'Earlyswerver_UK_Speed_Camera_Sign.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (546, 'Supplementary plate - School', 'UK_traffic_sign_546.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (602, 'Other - Give Way', 'UK_traffic_sign_602.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (668, 'Parking - Pavement Parking (start)', 'UK_traffic_sign_668.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6011, 'Other - Stop', 'UK_traffic_sign_601.1.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6682, 'Parking - Pavement Parking (end)', 'UK_traffic_sign_668.2.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (545, 'Warning - Children going to/from school', 'UK_traffic_sign_545.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (5441, 'Warning - Pedestrians in road ahead', 'UK_traffic_sign_544.1.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (5442, 'Warning - Elderly people likely to cross road ahead', 'UK_traffic_sign_544.2.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (543, 'Warning - Traffic lights', 'UK_traffic_sign_543.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (5571, 'Warning - Speed hump', 'UK_traffic_sign_557.1.svg');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description", "Icon") VALUES (6151, 'Supplementary plate - Give way to oncoming vehicles', 'UK_traffic_sign_615.1.svg');


--
-- TOC entry 4630 (class 0 OID 17795)
-- Dependencies: 303
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
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (12);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (13);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (15);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (16);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (25);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (27);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (45);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (46);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (47);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (49);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (3);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (48);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (50);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (51);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (52);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (53);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (54);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (55);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (56);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6634);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (57);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (811);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (957);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (36);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (41);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6291);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6292);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6294);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (1);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (2);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (4);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (5);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (9);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (618);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6192);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (610);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6061);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6062);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6063);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (652);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6092);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6091);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (607);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (616);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (613);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (612);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (614);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (615);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (18);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (29);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (30);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (43);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (44);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (617);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (619);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6262);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (955);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (956);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6191);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (521);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (522);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (9592);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (810);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (952);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6111);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (9581);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (9591);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (951);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (9621);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (816);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (964);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6101);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (38);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (39);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (664);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (40);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (62211);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (64021);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (5041);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (69);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (5131);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (5132);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (556);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (779);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (950);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (544);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (67);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (68);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (602);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (668);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6011);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6682);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (545);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (5441);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (5442);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (543);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (5571);


--
-- TOC entry 4633 (class 0 OID 17807)
-- Dependencies: 306
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
-- TOC entry 4634 (class 0 OID 17813)
-- Dependencies: 307
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
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (224);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (101);


--
-- TOC entry 4637 (class 0 OID 17825)
-- Dependencies: 310
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
-- TOC entry 4643 (class 0 OID 17849)
-- Dependencies: 316
-- Data for Name: os_mastermap_topography_polygons; Type: TABLE DATA; Schema: topography; Owner: postgres
--



--
-- TOC entry 4641 (class 0 OID 17841)
-- Dependencies: 314
-- Data for Name: os_mastermap_topography_text; Type: TABLE DATA; Schema: topography; Owner: postgres
--



--
-- TOC entry 4645 (class 0 OID 17857)
-- Dependencies: 318
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
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (25, '0102000020346C00000600000095354D5041DC1341E7C4956D8290244146F18107B1DC134100562F0B96902441276C96B5B0DC13419ED90CD998902441AE1313CBC3DC13410EE07AAF9C902441BE250208DEDC13410EE07AAF9C9024412356C0163BDF134194426DE9EF902441', 'Princes Street', NULL, 1007, 'NewTown', 'Edinburgh', 2.8616947931084944, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (27, '0102000020346C00000E000000D21BFA13E8DC13415F4C69884F902441A3F2F913E8DC1341000004D27C9024414840FD13E8DC13410000C0E07E9024411827FA13E8DC1341000050CE7F902441EA25D8DEEBDC134177AE07C180902441FD2FB6A9EFDC134177AE07C18090244109651A54F7DC134177AE07C18090244100E1724B84DD134177AE07C180902441696A4DE98ADD134177AE07C1809024417B03B12B8DDD134177AE07C180902441C41629F28EDD134100003CC3819024412AD723F28EDD134188476B03839024412CD723F28EDD134199E0CE458590244129D723F28EDD13416800FF7199902441', 'Hill Climb', NULL, 1015, 'Old Town', 'Edinburgh', 344, NULL, NULL, NULL);
INSERT INTO "topography"."road_casement" ("id", "geom", "RoadName", "ESUID", "USRN", "Locality", "Town", "Az", "StartStreet", "EndStreet", "SideOfStreet") VALUES (28, '0102000020346C000004000000FA37E0C5CDDC13414B3E76AF5C902441FA37E0C5CDDC134163A014E88D90244151F309A474DD134163A014E88D90244151F309A474DD134154F20B99A6902441', 'Hill Climb', NULL, 1015, 'Old Town', 'Edinburgh', 344, NULL, NULL, NULL);


--
-- TOC entry 4646 (class 0 OID 17863)
-- Dependencies: 319
-- Data for Name: LookupCodeTransfers_Bays; Type: TABLE DATA; Schema: transfer; Owner: postgres
--



--
-- TOC entry 4647 (class 0 OID 17869)
-- Dependencies: 320
-- Data for Name: LookupCodeTransfers_Lines; Type: TABLE DATA; Schema: transfer; Owner: postgres
--



--
-- TOC entry 4648 (class 0 OID 17875)
-- Dependencies: 321
-- Data for Name: RC_Polygon; Type: TABLE DATA; Schema: transfer; Owner: postgres
--

INSERT INTO "transfer"."RC_Polygon" ("id", "geom", "gid", "toid", "version", "verdate", "theme", "descgroup", "descterm", "change", "topoarea", "nature", "lnklength", "node1", "node1grade", "node1gra_1", "node2", "node2grade", "node2gra_1", "loaddate", "objectid", "shape_leng") VALUES (1, '0106000020346C000001000000010300000007000000810000002124811644DF134183EF294E0491244145C8926144DF1341F7E81F110391244190AC1F6144DF13415C84FE0F039124411B67646144DF1341DF76D90E039124419C5926E443DF13413245CCD50191244185859A6743DF1341454EAD9C0091244143317A6643DF1341A2DCAB9B00912441D670066643DF134174888A9A00912441EEA26F2D42DF1341D9962984FF902441EC5877F540DF134162349C6DFE9024415E05C6F340DF134105E9D36CFE9024419A1EA5F240DF134174A0D26BFE90244126C14E1D3FDF13417CD75D93FD90244136AD73483DDF1341174CA6BAFC9024411CC55B463DDF134130C22ABAFC9024419CFFA9443DDF134186B462B9FC902441343C85003BDF1341EE440A34FC9024419372ACBC38DF1341CE495FAEFB9024411B037B00E1DB13417AD0BCFE82902441376F3056D9DB13416B43C20779902441AA8BD263EADB134136C22EF351902441BF86558205DC1341D750918428902441E4887F4D06DC1341475BEA0B26902441BCD9B78705DC1341A93ED69223902441DFA75A4403DC13411F564D572190244155451EBCFFDB134124C241911F9024410C008647FBDB13417975256D1E902441EC143856F6DB1341677490071E902441B0DB0F64F1DB1341FB4B746A1E9024419C0AFEECECDB1341E9E4228C1F902441A7E2E660E9DB13412F164150219024415149AE18E7DB1341D3388D8A23902441CFD979B9CBDB13412EE3005C4D9024411731724CCBDB1341ABFE71244E902441C2E6F90CB9DB134106A9E5F577902441B54BB6BAB8DB134171D453467A902441C960D9BFB9DB1341F805A7897C902441999FFE02C6DB13416CA48A7A8C902441BB9EBDF4C8DB13417E56694E9090244102510E61CCDB1341937BC0FD929024412C3ED7E2E0DB134165F6639C9D9024410C0A587AEBDB1341FF8264EAA4902441CACF81EEF5DB1341ECBB0520AC9024417BF96FFAFCDB1341FB040BD1B1902441C8360069FCDB1341E1F27679BB902441D1CFD6B0F0DB1341CEC0C9E9D2902441E92D728BB8DB134102A7B1223D9124417321FD3CB5DB1341C087066D429124410121BF71A9DB13411522D04B559124412638184DA9DB1341377DE289559124415C3739D66ADB134178AA1DD4C591244162F3036E58DB13414A52831BC6912441D3E7CA4D54DB13419F3E7171C6912441EB95217E50DB134135F43A4DC7912441E054988640DB134156886B3ECC91244175C27DED3BDB1341BC226365CE912441838499B82CDB1341194E690AD99124412E67F4A92ADB134159F43A03DB912441E7ECA0C529DB13410B540931DD912441B5E6564028DB13419A85595BE991244185BE808028DB13417D13C759EB9124415C5F9ABB29DB1341004C5740ED912441D18D452335DB13418E7DA76AF99124415000185237DB1341C9D98622FB912441B41C44E845DB13411948C8E8039224414EEC0785A8DA13415CE6EE091E932441ABAFA9F12BD913414DD77BC4E8922441982EBFF826D91341958D657AE8922441BEE8571022D9134165AF9CF8E8922441202970B31DD913410766C632EA92244164895C4F1AD913416810220AEC922441B839163918D91341D1E38B50EE92244148A6E9A417D913415B2401CDF0922441E9E957A118D9134148C73441F39224412C57AB151BD9134117A7A86FF5922441EEAB62C41ED91341F576B221F7922441C152365123D91341CB9ED52CF8922441C909AD50AFDA1341D9B6EB9A2F932441BEC98B18C3DD1341B13D0DE09D9324412593FFA5C8DD1341AB3105A79E9324418FCCE4F156DF1341AAF90E50D6932441B221AA8EA0DF1341AF34A6ABED932441EF634AD0A4DF1341AD90839EEE932441962F98FFEFDF13414D01FF26F9932441A247172E43E01341BFA5A22305942441404E6E7643E013415FA4B32D059424414D984C9F79E013413704C2720C942441EFFFB9997EE013410B5D09B60C942441490A5C7F83E013410AD11C310C9424410DD97BD587E01341B953FFF00A942441A0BF6E2F8BE0134192AE0615099424410E5939398DE013418946CACB06942441B60AC8BF8DE01341B992934E04942441B4F2EEB58CE013418B8DC2DB0194244112F8B3358AE0134129A6B2B0FF932441C4ADC27D86E01341E032B903FE932441B3DD49EB81E0134129E6D3FEFC9324411CB6AEE64BE013414095A3BEF5932441D5D0AACDF8DF1341CB6618C5E9932441188B71B0F8DF1341BE52F1C0E9932441AE0F13B7AFDF134133FCBE87DF93244117B5C45799DF1341EA816D6ED893244147238101C6DF13415C5A07D4DC932441079AA65E8FE0134137DA1F90F7932441B4AC705994E01341468EAAD1F7932441F70A583E99E0134143CF084BF7932441541CB8929DE01341825C6809F6932441240812EAA0E013414FE0442CF49324413481ABF0A2E01341460053E2F193244152E9C073A3E01341F0F6ED64EF9324414D6B7D66A2E01341CE477AF2EC932441CB853CE39FE01341203F4AC8EA932441668DF5289CE0134138499D1CE993244153CD119597E01341AF8C5019E8932441FF16EFB6CDDF134181DF174CCD9324419BD7FFB2CCDF1341539A132ECD932441B82CCC5383DF1341E7FCF3F4C5932441BAE0DA347FDF1341414C9FD2C5932441C2A1FD355FDF13417226CDDAC693244147A69921DBDD134157FC449F90932441E1550570F9DD13412A39E07D5A9324417FC24376F9DD1341A18599725A932441EE43FB9A7EDE1341BFB4CE4B67922441464AC00590DE134138DB087D479224410B75776EB9DE134114EF9BDDFB9124419E85A5F6E0DE134185F0767DB5912441151AD87C39DF1341F3AFC5E5179124419FFB23CC43DF1341399A3E8B059124412124811644DF134183EF294E04912441160000004EC9A6E489DB1341B02766B5C9912441B44A2710C8DB13410706A8F259912441BC6C382CCFDB13415E9C8C924E9124419B91AFB32EDC1341ABA6AAB05B912441C7E4D5BF52DC13415384779F6091244143D4C0DF6ADC134174EAE40F64912441A75F7E110BDD13419B9F2AE67A9124416A29DF9A86DD13417B1E9F828C91244149466958EBDD13414C5D21DF9A912441EDF68969EBDD13414A4A8DE19A9124414F6EF7D01DDE1341E93DC3F2A19124413688F33733DE134125E8FAF2A4912441DD723EDABDDE13411C99F1D2B8912441CA8BFF9B9ADE134167268690F79124411E03CE949ADE1341CF5A7E9DF79124417334D66875DE13412D90E97F3B922441F832A280A1DB1341D8E1C700D6912441B09A6809A1DB13410B9CE256D59124413C2641499FDB1341ECF98493D391244166FB3ABA9CDB134180D78814D291244129B4673D8BDB1341FB36C418CA9124414EC9A6E489DB1341B02766B5C99124411400000073886781C6DE134180A2786BA9912441BB5D56FE3BDE1341C5F1FB8F95912441C3135BE73BDE134165C7B98C9591244172E6DE7426DE1341F951E58A9291244167200316F4DD134127F3E27A8B912441D60208618FDD1341870C991F7D9124411339A7D713DD1341A78D24836B912441AFADE9A573DC134180D8DEAC54912441E01E1C715BDC1341023E773951912441770247475BDC134134399F33519124411E61662B37DC1341B199AB424C91244108A6C784D8DB1341FC806D433F9124417941ECA70FDC1341BF681AF3D6902441B53497B50FDC1341C59186D8D69024414366E7DF1BDC1341A82EE683BE902441D3036E581CDC1341043C65CFBC902441EC06131B1DDC13415C0770E2AF9024417F47B49A1CDC134196881ABEAD902441EB6B2C6116DF1341C9BEF2391B91244173886781C6DE134180A2786BA991244105000000EDAC57081FDF134169EB75D20B912441BDB2572602DC1341864CE94A999024419A007F5400DC1341414DA309989024413070FAAA20DF1341696832E908912441EDAC57081FDF134169EB75D20B9124410800000020773664A8DB1341ED790996E7912441D9CA8BF56CDE1341735D98EE4A922441CEE31A0A64DE1341847AB3385B922441C43476EEA2DB13414DFF232AF4912441A5430524A3DB1341B041A604F4912441A75BFAFDA4DB134106C0E651F2912441379C68F9A5DB13414347FC72F091244120773664A8DB1341ED790996E7912441090000009869A2878ADB1341B4D68744019224417A7A89965BDE1341FDF0E3A76A922441836C239CDADD1341D610553356932441500E9950BCDD1341A5E5944F8C9324411464BC55C7DA134167B5285A2293244194729EA664DB13410BDBE75908922441B57755677EDB13415A6F6B4E04922441BA97C10B81DB1341FE40D9C1039224419869A2878ADB1341B4D687440192244110000000776C1E045DDB13410A0F8DC7F8912441162ACD3D51DB13415B3651B2F1912441D7ADBA7148DB13417E5C1B50E8912441CB36816C49DB1341D914E779E09124418801A71954DB1341EE06B300D9912441301E12B05DDB13417196FF08D691244112C3B1C66FDB13418561D6C2D5912441920FA4D371DB13412D45B915D69124416240D54478DB13415B5A1F1AD79124416A80ED2C84DB1341C2DBA489DC912441F7FDA21086DB1341DEE1ED3ADF912441206E0D2B89DB1341B3C1F8A6E3912441097558CD86DB13415EA8E553EC91244144CCFE017EDB1341819ED77BF2912441A6846D7173DB13411A8ECA41F5912441776C1E045DDB13410A0F8DC7F8912441', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4807 (class 0 OID 0)
-- Dependencies: 224
-- Name: BayLinesFadedTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."BayLinesFadedTypes_Code_seq"', 1, false);


--
-- TOC entry 4808 (class 0 OID 0)
-- Dependencies: 226
-- Name: BaysLines_SignIssueTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."BaysLines_SignIssueTypes_Code_seq"', 1, false);


--
-- TOC entry 4809 (class 0 OID 0)
-- Dependencies: 228
-- Name: ConditionTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."ConditionTypes_Code_seq"', 1, false);


--
-- TOC entry 4810 (class 0 OID 0)
-- Dependencies: 230
-- Name: MHTC_CheckIssueType_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."MHTC_CheckIssueType_Code_seq"', 1, false);


--
-- TOC entry 4811 (class 0 OID 0)
-- Dependencies: 232
-- Name: MHTC_CheckStatus_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."MHTC_CheckStatus_Code_seq"', 1, false);


--
-- TOC entry 4812 (class 0 OID 0)
-- Dependencies: 323
-- Name: SignAttachmentTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignAttachmentTypes_Code_seq"', 10, false);


--
-- TOC entry 4813 (class 0 OID 0)
-- Dependencies: 235
-- Name: SignConditionTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignConditionTypes_Code_seq"', 1, false);


--
-- TOC entry 4814 (class 0 OID 0)
-- Dependencies: 237
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignFadedTypes_id_seq"', 8, true);


--
-- TOC entry 4815 (class 0 OID 0)
-- Dependencies: 239
-- Name: SignIlluminationTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignIlluminationTypes_Code_seq"', 1, false);


--
-- TOC entry 4816 (class 0 OID 0)
-- Dependencies: 241
-- Name: SignMountTypes_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignMountTypes_id_seq"', 7, true);


--
-- TOC entry 4817 (class 0 OID 0)
-- Dependencies: 243
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignObscurredTypes_id_seq"', 3, true);


--
-- TOC entry 4818 (class 0 OID 0)
-- Dependencies: 245
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."TicketMachineIssueTypes_id_seq"', 4, true);


--
-- TOC entry 4819 (class 0 OID 0)
-- Dependencies: 247
-- Name: itn_roadcentreline_gid_seq; Type: SEQUENCE SET; Schema: highways_network; Owner: postgres
--

SELECT pg_catalog.setval('"highways_network"."itn_roadcentreline_gid_seq"', 13, true);


--
-- TOC entry 4820 (class 0 OID 0)
-- Dependencies: 249
-- Name: SiteArea_id_seq; Type: SEQUENCE SET; Schema: local_authority; Owner: postgres
--

SELECT pg_catalog.setval('"local_authority"."SiteArea_id_seq"', 1, true);


--
-- TOC entry 4821 (class 0 OID 0)
-- Dependencies: 251
-- Name: StreetGazetteerRecords_id_seq; Type: SEQUENCE SET; Schema: local_authority; Owner: postgres
--

SELECT pg_catalog.setval('"local_authority"."StreetGazetteerRecords_id_seq"', 14, true);


--
-- TOC entry 4822 (class 0 OID 0)
-- Dependencies: 326
-- Name: AreasForReview_id_seq; Type: SEQUENCE SET; Schema: mhtc_operations; Owner: postgres
--

SELECT pg_catalog.setval('"mhtc_operations"."AreasForReview_id_seq"', 1, false);


--
-- TOC entry 4823 (class 0 OID 0)
-- Dependencies: 313
-- Name: Corners_id_seq; Type: SEQUENCE SET; Schema: mhtc_operations; Owner: postgres
--

SELECT pg_catalog.setval('"mhtc_operations"."Corners_id_seq"', 25, true);


--
-- TOC entry 4824 (class 0 OID 0)
-- Dependencies: 324
-- Name: gnss_pts_id_seq; Type: SEQUENCE SET; Schema: mhtc_operations; Owner: postgres
--

SELECT pg_catalog.setval('"mhtc_operations"."gnss_pts_id_seq"', 1, false);


--
-- TOC entry 4825 (class 0 OID 0)
-- Dependencies: 253
-- Name: RC_Polyline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RC_Polyline_id_seq"', 7, true);


--
-- TOC entry 4826 (class 0 OID 0)
-- Dependencies: 255
-- Name: RC_Sections_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RC_Sections_gid_seq"', 54, true);


--
-- TOC entry 4827 (class 0 OID 0)
-- Dependencies: 257
-- Name: RC_Sections_merged_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RC_Sections_merged_gid_seq"', 24, true);


--
-- TOC entry 4828 (class 0 OID 0)
-- Dependencies: 328
-- Name: SignTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."SignTypes_id_seq"', 130, false);


--
-- TOC entry 4829 (class 0 OID 0)
-- Dependencies: 258
-- Name: Bays_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."Bays_id_seq"', 43, true);


--
-- TOC entry 4830 (class 0 OID 0)
-- Dependencies: 260
-- Name: ControlledParkingZones_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."ControlledParkingZones_id_seq"', 8, true);


--
-- TOC entry 4831 (class 0 OID 0)
-- Dependencies: 262
-- Name: Lines_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."Lines_id_seq"', 22, true);


--
-- TOC entry 4832 (class 0 OID 0)
-- Dependencies: 265
-- Name: ParkingTariffAreas_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."ParkingTariffAreas_id_seq"', 2, true);


--
-- TOC entry 4833 (class 0 OID 0)
-- Dependencies: 267
-- Name: Proposals_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."Proposals_id_seq"', 9, true);


--
-- TOC entry 4834 (class 0 OID 0)
-- Dependencies: 270
-- Name: RestrictionLayers_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."RestrictionLayers_id_seq"', 1, false);


--
-- TOC entry 4835 (class 0 OID 0)
-- Dependencies: 271
-- Name: RestrictionPolygons_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."RestrictionPolygons_id_seq"', 2, true);


--
-- TOC entry 4836 (class 0 OID 0)
-- Dependencies: 274
-- Name: Signs_id_seq; Type: SEQUENCE SET; Schema: toms; Owner: postgres
--

SELECT pg_catalog.setval('"toms"."Signs_id_seq"', 1, true);


--
-- TOC entry 4837 (class 0 OID 0)
-- Dependencies: 278
-- Name: ActionOnProposalAcceptanceTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq"', 1, true);


--
-- TOC entry 4838 (class 0 OID 0)
-- Dependencies: 280
-- Name: AdditionalConditionTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."AdditionalConditionTypes_Code_seq"', 3, true);


--
-- TOC entry 4839 (class 0 OID 0)
-- Dependencies: 282
-- Name: BayLineTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."BayLineTypes_Code_seq"', 1, false);


--
-- TOC entry 4840 (class 0 OID 0)
-- Dependencies: 287
-- Name: LengthOfTime_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."LengthOfTime_Code_seq"', 1, false);


--
-- TOC entry 4841 (class 0 OID 0)
-- Dependencies: 291
-- Name: PaymentTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."PaymentTypes_Code_seq"', 1, false);


--
-- TOC entry 4842 (class 0 OID 0)
-- Dependencies: 293
-- Name: ProposalStatusTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."ProposalStatusTypes_Code_seq"', 1, false);


--
-- TOC entry 4843 (class 0 OID 0)
-- Dependencies: 298
-- Name: RestrictionPolygonTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."RestrictionPolygonTypes_Code_seq"', 21, true);


--
-- TOC entry 4844 (class 0 OID 0)
-- Dependencies: 299
-- Name: RestrictionShapeTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."RestrictionShapeTypes_Code_seq"', 1, false);


--
-- TOC entry 4845 (class 0 OID 0)
-- Dependencies: 301
-- Name: SignOrientationTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."SignOrientationTypes_Code_seq"', 1, false);


--
-- TOC entry 4846 (class 0 OID 0)
-- Dependencies: 305
-- Name: SignTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."SignTypes_Code_seq"', 1, false);


--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 309
-- Name: TimePeriods_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."TimePeriods_Code_seq"', 1, false);


--
-- TOC entry 4848 (class 0 OID 0)
-- Dependencies: 311
-- Name: UnacceptableTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."UnacceptableTypes_Code_seq"', 1, false);


--
-- TOC entry 4849 (class 0 OID 0)
-- Dependencies: 317
-- Name: os_mastermap_topography_polygons_seq; Type: SEQUENCE SET; Schema: topography; Owner: postgres
--

SELECT pg_catalog.setval('"topography"."os_mastermap_topography_polygons_seq"', 1, false);


--
-- TOC entry 4850 (class 0 OID 0)
-- Dependencies: 315
-- Name: os_mastermap_topography_text_seq; Type: SEQUENCE SET; Schema: topography; Owner: postgres
--

SELECT pg_catalog.setval('"topography"."os_mastermap_topography_text_seq"', 1, false);


--
-- TOC entry 4851 (class 0 OID 0)
-- Dependencies: 322
-- Name: RC_Polygon_id_seq; Type: SEQUENCE SET; Schema: transfer; Owner: postgres
--

SELECT pg_catalog.setval('"transfer"."RC_Polygon_id_seq"', 1, true);


--
-- TOC entry 4147 (class 2606 OID 17919)
-- Name: RestrictionRoadMarkingsFadedTypes BayLinesFadedTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"
    ADD CONSTRAINT "BayLinesFadedTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4149 (class 2606 OID 17921)
-- Name: Restriction_SignIssueTypes BaysLines_SignIssueTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."Restriction_SignIssueTypes"
    ADD CONSTRAINT "BaysLines_SignIssueTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4151 (class 2606 OID 17923)
-- Name: ConditionTypes ConditionTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."ConditionTypes"
    ADD CONSTRAINT "ConditionTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4153 (class 2606 OID 17925)
-- Name: MHTC_CheckIssueTypes MHTC_CheckIssueType_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."MHTC_CheckIssueTypes"
    ADD CONSTRAINT "MHTC_CheckIssueType_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4155 (class 2606 OID 17927)
-- Name: MHTC_CheckStatus MHTC_CheckStatus_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."MHTC_CheckStatus"
    ADD CONSTRAINT "MHTC_CheckStatus_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4157 (class 2606 OID 17929)
-- Name: SignAttachmentTypes SignAttachmentTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignAttachmentTypes"
    ADD CONSTRAINT "SignAttachmentTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4159 (class 2606 OID 18442)
-- Name: SignAttachmentTypes SignAttachmentTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignAttachmentTypes"
    ADD CONSTRAINT "SignAttachmentTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4161 (class 2606 OID 17931)
-- Name: SignConditionTypes SignConditionTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignConditionTypes"
    ADD CONSTRAINT "SignConditionTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4163 (class 2606 OID 17933)
-- Name: SignFadedTypes SignFadedTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignFadedTypes"
    ADD CONSTRAINT "SignFadedTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4165 (class 2606 OID 17935)
-- Name: SignFadedTypes SignFadedTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignFadedTypes"
    ADD CONSTRAINT "SignFadedTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4167 (class 2606 OID 17937)
-- Name: SignIlluminationTypes SignIlluminationTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignIlluminationTypes"
    ADD CONSTRAINT "SignIlluminationTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4169 (class 2606 OID 17939)
-- Name: SignMountTypes SignMountTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignMountTypes"
    ADD CONSTRAINT "SignMountTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4171 (class 2606 OID 17941)
-- Name: SignMountTypes SignMounts_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignMountTypes"
    ADD CONSTRAINT "SignMounts_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4173 (class 2606 OID 17943)
-- Name: SignObscurredTypes SignObscurredTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignObscurredTypes"
    ADD CONSTRAINT "SignObscurredTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4175 (class 2606 OID 17945)
-- Name: SignObscurredTypes SignObscurredTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."SignObscurredTypes"
    ADD CONSTRAINT "SignObscurredTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4177 (class 2606 OID 17947)
-- Name: TicketMachineIssueTypes TicketMachineIssueTypes_Code_key; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."TicketMachineIssueTypes"
    ADD CONSTRAINT "TicketMachineIssueTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 4179 (class 2606 OID 17949)
-- Name: TicketMachineIssueTypes TicketMachineIssueTypes_pkey; Type: CONSTRAINT; Schema: compliance_lookups; Owner: postgres
--

ALTER TABLE ONLY "compliance_lookups"."TicketMachineIssueTypes"
    ADD CONSTRAINT "TicketMachineIssueTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4182 (class 2606 OID 17953)
-- Name: itn_roadcentreline edi_itn_roadcentreline_pkey; Type: CONSTRAINT; Schema: highways_network; Owner: postgres
--

ALTER TABLE ONLY "highways_network"."itn_roadcentreline"
    ADD CONSTRAINT "edi_itn_roadcentreline_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4184 (class 2606 OID 18440)
-- Name: itn_roadcentreline itn_roadcentreline_toid_key; Type: CONSTRAINT; Schema: highways_network; Owner: postgres
--

ALTER TABLE ONLY "highways_network"."itn_roadcentreline"
    ADD CONSTRAINT "itn_roadcentreline_toid_key" UNIQUE ("toid");


--
-- TOC entry 4312 (class 2606 OID 18551)
-- Name: PayParkingAreas PayParkingAreas_pkey; Type: CONSTRAINT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."PayParkingAreas"
    ADD CONSTRAINT "PayParkingAreas_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4190 (class 2606 OID 17955)
-- Name: StreetGazetteerRecords gaz_usrn_pkey; Type: CONSTRAINT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."StreetGazetteerRecords"
    ADD CONSTRAINT "gaz_usrn_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4187 (class 2606 OID 17957)
-- Name: SiteArea test_area_pkey; Type: CONSTRAINT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."SiteArea"
    ADD CONSTRAINT "test_area_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4309 (class 2606 OID 18478)
-- Name: AreasForReview AreasForReview_pkey; Type: CONSTRAINT; Schema: mhtc_operations; Owner: postgres
--

ALTER TABLE ONLY "mhtc_operations"."AreasForReview"
    ADD CONSTRAINT "AreasForReview_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4290 (class 2606 OID 18043)
-- Name: Corners Corners_pkey; Type: CONSTRAINT; Schema: mhtc_operations; Owner: postgres
--

ALTER TABLE ONLY "mhtc_operations"."Corners"
    ADD CONSTRAINT "Corners_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4307 (class 2606 OID 18466)
-- Name: gnss_pts gnss_pts_pkey; Type: CONSTRAINT; Schema: mhtc_operations; Owner: postgres
--

ALTER TABLE ONLY "mhtc_operations"."gnss_pts"
    ADD CONSTRAINT "gnss_pts_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4315 (class 2606 OID 18572)
-- Name: project_parameters project_parameters_pkey; Type: CONSTRAINT; Schema: mhtc_operations; Owner: postgres
--

ALTER TABLE ONLY "mhtc_operations"."project_parameters"
    ADD CONSTRAINT "project_parameters_pkey" PRIMARY KEY ("Field");


--
-- TOC entry 4192 (class 2606 OID 17959)
-- Name: RC_Polyline RC_Polyline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Polyline"
    ADD CONSTRAINT "RC_Polyline_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4197 (class 2606 OID 17961)
-- Name: RC_Sections_merged RC_Sections_merged_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Sections_merged"
    ADD CONSTRAINT "RC_Sections_merged_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4194 (class 2606 OID 17963)
-- Name: RC_Sections RC_Sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RC_Sections"
    ADD CONSTRAINT "RC_Sections_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4200 (class 2606 OID 17965)
-- Name: Bays Bays_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4202 (class 2606 OID 17967)
-- Name: Bays Bays_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4205 (class 2606 OID 17969)
-- Name: ControlledParkingZones ControlledParkingZones_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4207 (class 2606 OID 17971)
-- Name: ControlledParkingZones ControlledParkingZones_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4210 (class 2606 OID 17973)
-- Name: Lines Lines_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4212 (class 2606 OID 17975)
-- Name: Lines Lines_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4215 (class 2606 OID 17977)
-- Name: MapGrid MapGrid_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."MapGrid"
    ADD CONSTRAINT "MapGrid_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4218 (class 2606 OID 17979)
-- Name: ParkingTariffAreas ParkingTariffAreas_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4220 (class 2606 OID 17981)
-- Name: ParkingTariffAreas ParkingTariffAreas_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4223 (class 2606 OID 17983)
-- Name: Proposals Proposals_PK; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Proposals"
    ADD CONSTRAINT "Proposals_PK" PRIMARY KEY ("ProposalID");


--
-- TOC entry 4225 (class 2606 OID 17985)
-- Name: Proposals Proposals_ProposalTitle_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Proposals"
    ADD CONSTRAINT "Proposals_ProposalTitle_key" UNIQUE ("ProposalTitle");


--
-- TOC entry 4227 (class 2606 OID 17987)
-- Name: RestrictionLayers RestrictionLayers2_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers2_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4229 (class 2606 OID 17989)
-- Name: RestrictionLayers RestrictionLayers_id_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers_id_key" UNIQUE ("Code");


--
-- TOC entry 4231 (class 2606 OID 17991)
-- Name: RestrictionPolygons RestrictionPolygons_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionPolygons_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4236 (class 2606 OID 17993)
-- Name: RestrictionsInProposals RestrictionsInProposals_pk; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_pk" PRIMARY KEY ("ProposalID", "RestrictionTableID", "RestrictionID");


--
-- TOC entry 4233 (class 2606 OID 17995)
-- Name: RestrictionPolygons RestrictionsPolygons_pk; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_pk" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4238 (class 2606 OID 17997)
-- Name: Signs Signs_GeometryID_key; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4240 (class 2606 OID 17999)
-- Name: Signs Signs_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4243 (class 2606 OID 18001)
-- Name: TilesInAcceptedProposals TilesInAcceptedProposals_pkey; Type: CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_pkey" PRIMARY KEY ("ProposalID", "TileNr", "RevisionNr");


--
-- TOC entry 4245 (class 2606 OID 18003)
-- Name: ActionOnProposalAcceptanceTypes ActionOnProposalAcceptanceTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."ActionOnProposalAcceptanceTypes"
    ADD CONSTRAINT "ActionOnProposalAcceptanceTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4247 (class 2606 OID 18005)
-- Name: AdditionalConditionTypes AdditionalConditionTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."AdditionalConditionTypes"
    ADD CONSTRAINT "AdditionalConditionTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4249 (class 2606 OID 18007)
-- Name: BayLineTypes BayLineTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."BayLineTypes"
    ADD CONSTRAINT "BayLineTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4251 (class 2606 OID 18009)
-- Name: BayTypesInUse BayTypesInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."BayTypesInUse"
    ADD CONSTRAINT "BayTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4254 (class 2606 OID 18011)
-- Name: GeomShapeGroupType GeomShapeGroupType_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."GeomShapeGroupType"
    ADD CONSTRAINT "GeomShapeGroupType_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4256 (class 2606 OID 18013)
-- Name: LengthOfTime LengthOfTime_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."LengthOfTime"
    ADD CONSTRAINT "LengthOfTime_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4258 (class 2606 OID 18015)
-- Name: LineTypesInUse LineTypesInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."LineTypesInUse"
    ADD CONSTRAINT "LineTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4261 (class 2606 OID 18017)
-- Name: PaymentTypes PaymentTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."PaymentTypes"
    ADD CONSTRAINT "PaymentTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4263 (class 2606 OID 18019)
-- Name: ProposalStatusTypes ProposalStatusTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."ProposalStatusTypes"
    ADD CONSTRAINT "ProposalStatusTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4271 (class 2606 OID 18021)
-- Name: RestrictionPolygonTypesInUse RestrictionPolygonTypesInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionPolygonTypesInUse"
    ADD CONSTRAINT "RestrictionPolygonTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4269 (class 2606 OID 18023)
-- Name: RestrictionPolygonTypes RestrictionPolygonTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionPolygonTypes"
    ADD CONSTRAINT "RestrictionPolygonTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4265 (class 2606 OID 18025)
-- Name: RestrictionGeomShapeTypes RestrictionShapeTypes_Description_key; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionGeomShapeTypes"
    ADD CONSTRAINT "RestrictionShapeTypes_Description_key" UNIQUE ("Description");


--
-- TOC entry 4267 (class 2606 OID 18027)
-- Name: RestrictionGeomShapeTypes RestrictionShapeTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionGeomShapeTypes"
    ADD CONSTRAINT "RestrictionShapeTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4274 (class 2606 OID 18029)
-- Name: SignOrientationTypes SignOrientationTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignOrientationTypes"
    ADD CONSTRAINT "SignOrientationTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4278 (class 2606 OID 18031)
-- Name: SignTypesInUse SignTypesInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignTypesInUse"
    ADD CONSTRAINT "SignTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4276 (class 2606 OID 18033)
-- Name: SignTypes SignTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignTypes"
    ADD CONSTRAINT "SignTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4285 (class 2606 OID 18035)
-- Name: TimePeriodsInUse TimePeriodsInUse_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."TimePeriodsInUse"
    ADD CONSTRAINT "TimePeriodsInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4281 (class 2606 OID 18037)
-- Name: TimePeriods TimePeriods_Description_key; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_Description_key" UNIQUE ("Description");


--
-- TOC entry 4283 (class 2606 OID 18039)
-- Name: TimePeriods TimePeriods_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4288 (class 2606 OID 18041)
-- Name: UnacceptableTypes UnacceptableTypes_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."UnacceptableTypes"
    ADD CONSTRAINT "UnacceptableTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4293 (class 2606 OID 18045)
-- Name: os_mastermap_topography_text edi_cartotext_pkey; Type: CONSTRAINT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."os_mastermap_topography_text"
    ADD CONSTRAINT "edi_cartotext_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4296 (class 2606 OID 18047)
-- Name: os_mastermap_topography_polygons edi_mm_pkey; Type: CONSTRAINT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."os_mastermap_topography_polygons"
    ADD CONSTRAINT "edi_mm_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 4299 (class 2606 OID 18049)
-- Name: road_casement road_casement_pkey; Type: CONSTRAINT; Schema: topography; Owner: postgres
--

ALTER TABLE ONLY "topography"."road_casement"
    ADD CONSTRAINT "road_casement_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4301 (class 2606 OID 18051)
-- Name: LookupCodeTransfers_Bays LookupCodeTransfers_Bays_pkey; Type: CONSTRAINT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."LookupCodeTransfers_Bays"
    ADD CONSTRAINT "LookupCodeTransfers_Bays_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4303 (class 2606 OID 18053)
-- Name: LookupCodeTransfers_Lines LookupCodeTransfers_Lines_pkey; Type: CONSTRAINT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."LookupCodeTransfers_Lines"
    ADD CONSTRAINT "LookupCodeTransfers_Lines_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4305 (class 2606 OID 18055)
-- Name: RC_Polygon RC_Polygon_pkey; Type: CONSTRAINT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."RC_Polygon"
    ADD CONSTRAINT "RC_Polygon_pkey" PRIMARY KEY ("id");


--
-- TOC entry 4180 (class 1259 OID 18056)
-- Name: edi_itn_roadcentreline_geom_idx; Type: INDEX; Schema: highways_network; Owner: postgres
--

CREATE INDEX "edi_itn_roadcentreline_geom_idx" ON "highways_network"."itn_roadcentreline" USING "gist" ("geom");


--
-- TOC entry 4188 (class 1259 OID 18057)
-- Name: gaz_usrn_geom_idx; Type: INDEX; Schema: local_authority; Owner: postgres
--

CREATE INDEX "gaz_usrn_geom_idx" ON "local_authority"."StreetGazetteerRecords" USING "gist" ("geom");


--
-- TOC entry 4313 (class 1259 OID 18552)
-- Name: sidx_PayParkingAreas_geom; Type: INDEX; Schema: local_authority; Owner: postgres
--

CREATE INDEX "sidx_PayParkingAreas_geom" ON "local_authority"."PayParkingAreas" USING "gist" ("geom");


--
-- TOC entry 4185 (class 1259 OID 18058)
-- Name: test_area_geom_idx; Type: INDEX; Schema: local_authority; Owner: postgres
--

CREATE INDEX "test_area_geom_idx" ON "local_authority"."SiteArea" USING "gist" ("geom");


--
-- TOC entry 4310 (class 1259 OID 18479)
-- Name: sidx_AreasForReview_geom; Type: INDEX; Schema: mhtc_operations; Owner: postgres
--

CREATE INDEX "sidx_AreasForReview_geom" ON "mhtc_operations"."AreasForReview" USING "gist" ("geom");


--
-- TOC entry 4195 (class 1259 OID 18059)
-- Name: sidx_RC_Sections_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_RC_Sections_geom" ON "public"."RC_Sections" USING "gist" ("geom");


--
-- TOC entry 4198 (class 1259 OID 18060)
-- Name: sidx_RC_Sections_merged_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_RC_Sections_merged_geom" ON "public"."RC_Sections_merged" USING "gist" ("geom");


--
-- TOC entry 4208 (class 1259 OID 18061)
-- Name: controlledparkingzones_geom_idx; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "controlledparkingzones_geom_idx" ON "toms"."ControlledParkingZones" USING "gist" ("geom");


--
-- TOC entry 4203 (class 1259 OID 18062)
-- Name: sidx_Bays_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_Bays_geom" ON "toms"."Bays" USING "gist" ("geom");


--
-- TOC entry 4213 (class 1259 OID 18063)
-- Name: sidx_Lines_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_Lines_geom" ON "toms"."Lines" USING "gist" ("geom");


--
-- TOC entry 4216 (class 1259 OID 18064)
-- Name: sidx_MapGrid_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_MapGrid_geom" ON "toms"."MapGrid" USING "gist" ("geom");


--
-- TOC entry 4221 (class 1259 OID 18065)
-- Name: sidx_ParkingTariffAreas_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_ParkingTariffAreas_geom" ON "toms"."ParkingTariffAreas" USING "gist" ("geom");


--
-- TOC entry 4241 (class 1259 OID 18066)
-- Name: sidx_Signs_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_Signs_geom" ON "toms"."Signs" USING "gist" ("geom");


--
-- TOC entry 4234 (class 1259 OID 18067)
-- Name: sidx_restrictionPolygons_geom; Type: INDEX; Schema: toms; Owner: postgres
--

CREATE INDEX "sidx_restrictionPolygons_geom" ON "toms"."RestrictionPolygons" USING "gist" ("geom");


--
-- TOC entry 4252 (class 1259 OID 18068)
-- Name: BayTypesInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "BayTypesInUse_View_key" ON "toms_lookups"."BayTypesInUse_View" USING "btree" ("Code");


--
-- TOC entry 4259 (class 1259 OID 18069)
-- Name: LineTypesInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "LineTypesInUse_View_key" ON "toms_lookups"."LineTypesInUse_View" USING "btree" ("Code");


--
-- TOC entry 4272 (class 1259 OID 18070)
-- Name: RestrictionPolygonTypesInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "RestrictionPolygonTypesInUse_View_key" ON "toms_lookups"."RestrictionPolygonTypesInUse_View" USING "btree" ("Code");


--
-- TOC entry 4279 (class 1259 OID 18071)
-- Name: SignTypesInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "SignTypesInUse_View_key" ON "toms_lookups"."SignTypesInUse_View" USING "btree" ("Code");


--
-- TOC entry 4286 (class 1259 OID 18072)
-- Name: TimePeriodsInUse_View_key; Type: INDEX; Schema: toms_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "TimePeriodsInUse_View_key" ON "toms_lookups"."TimePeriodsInUse_View" USING "btree" ("Code");


--
-- TOC entry 4291 (class 1259 OID 18073)
-- Name: edi_cartotext_geom_idx; Type: INDEX; Schema: topography; Owner: postgres
--

CREATE INDEX "edi_cartotext_geom_idx" ON "topography"."os_mastermap_topography_text" USING "gist" ("geom");


--
-- TOC entry 4294 (class 1259 OID 18074)
-- Name: edi_mm_geom_idx; Type: INDEX; Schema: topography; Owner: postgres
--

CREATE INDEX "edi_mm_geom_idx" ON "topography"."os_mastermap_topography_polygons" USING "gist" ("geom");


--
-- TOC entry 4297 (class 1259 OID 18467)
-- Name: road_casement_geom_idx; Type: INDEX; Schema: topography; Owner: postgres
--

CREATE INDEX "road_casement_geom_idx" ON "topography"."road_casement" USING "gist" ("geom");


--
-- TOC entry 4407 (class 2620 OID 18577)
-- Name: project_parameters update_capacity_all; Type: TRIGGER; Schema: mhtc_operations; Owner: postgres
--

CREATE TRIGGER "update_capacity_all" AFTER UPDATE ON "mhtc_operations"."project_parameters" FOR EACH ROW EXECUTE FUNCTION "public"."revise_all_capacities"();


--
-- TOC entry 4383 (class 2620 OID 18075)
-- Name: Bays create_geometryid_bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_bays" BEFORE INSERT ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4390 (class 2620 OID 18408)
-- Name: ControlledParkingZones create_geometryid_bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_bays" BEFORE INSERT ON "toms"."ControlledParkingZones" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4398 (class 2620 OID 18409)
-- Name: ParkingTariffAreas create_geometryid_bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_bays" BEFORE INSERT ON "toms"."ParkingTariffAreas" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4392 (class 2620 OID 18076)
-- Name: Lines create_geometryid_lines; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_lines" BEFORE INSERT ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4400 (class 2620 OID 18077)
-- Name: RestrictionPolygons create_geometryid_restrictionpolygons; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_restrictionpolygons" BEFORE INSERT ON "toms"."RestrictionPolygons" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4403 (class 2620 OID 18078)
-- Name: Signs create_geometryid_signs; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "create_geometryid_signs" BEFORE INSERT ON "toms"."Signs" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4385 (class 2620 OID 18454)
-- Name: Bays set_bay_geom_type_trigger; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_bay_geom_type_trigger" BEFORE INSERT OR UPDATE ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_bay_geom_type"();


--
-- TOC entry 4386 (class 2620 OID 18559)
-- Name: Bays set_create_details_Bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_create_details_Bays" BEFORE INSERT ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();


--
-- TOC entry 4391 (class 2620 OID 18563)
-- Name: ControlledParkingZones set_create_details_ControlledParkingZones; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_create_details_ControlledParkingZones" BEFORE INSERT ON "toms"."ControlledParkingZones" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();


--
-- TOC entry 4394 (class 2620 OID 18560)
-- Name: Lines set_create_details_Lines; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_create_details_Lines" BEFORE INSERT ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();


--
-- TOC entry 4399 (class 2620 OID 18564)
-- Name: ParkingTariffAreas set_create_details_ParkingTariffAreas; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_create_details_ParkingTariffAreas" BEFORE INSERT ON "toms"."ParkingTariffAreas" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();


--
-- TOC entry 4402 (class 2620 OID 18562)
-- Name: RestrictionPolygons set_create_details_RestrictionPolygons; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_create_details_RestrictionPolygons" BEFORE INSERT ON "toms"."RestrictionPolygons" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();


--
-- TOC entry 4406 (class 2620 OID 18561)
-- Name: Signs set_create_details_Signs; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_create_details_Signs" BEFORE INSERT ON "toms"."Signs" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();


--
-- TOC entry 4384 (class 2620 OID 18079)
-- Name: Bays set_last_update_details_Bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_Bays" BEFORE INSERT OR UPDATE ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4389 (class 2620 OID 18080)
-- Name: ControlledParkingZones set_last_update_details_ControlledParkingZones; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_ControlledParkingZones" BEFORE INSERT OR UPDATE ON "toms"."ControlledParkingZones" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4393 (class 2620 OID 18081)
-- Name: Lines set_last_update_details_Lines; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_Lines" BEFORE INSERT OR UPDATE ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4397 (class 2620 OID 18082)
-- Name: ParkingTariffAreas set_last_update_details_ParkingTariffAreas; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_ParkingTariffAreas" BEFORE INSERT OR UPDATE ON "toms"."ParkingTariffAreas" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4401 (class 2620 OID 18083)
-- Name: RestrictionPolygons set_last_update_details_RestrictionPolygons; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_RestrictionPolygons" BEFORE INSERT OR UPDATE ON "toms"."RestrictionPolygons" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4404 (class 2620 OID 18084)
-- Name: Signs set_last_update_details_Signs; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_Signs" BEFORE INSERT OR UPDATE ON "toms"."Signs" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4405 (class 2620 OID 18447)
-- Name: Signs set_original_geometry_signs; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_original_geometry_signs" BEFORE INSERT OR UPDATE ON "toms"."Signs" FOR EACH ROW EXECUTE FUNCTION "public"."set_original_geometry"();


--
-- TOC entry 4388 (class 2620 OID 18578)
-- Name: Bays set_restriction_length_Bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_restriction_length_Bays" BEFORE INSERT OR UPDATE OF "geom" ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_restriction_length"();


--
-- TOC entry 4396 (class 2620 OID 18579)
-- Name: Lines set_restriction_length_Lines; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "set_restriction_length_Lines" BEFORE INSERT OR UPDATE OF "geom" ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_restriction_length"();


--
-- TOC entry 4387 (class 2620 OID 18574)
-- Name: Bays update_capacity_bays; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "update_capacity_bays" BEFORE INSERT OR UPDATE ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."update_capacity"();


--
-- TOC entry 4395 (class 2620 OID 18575)
-- Name: Lines update_capacity_lines; Type: TRIGGER; Schema: toms; Owner: postgres
--

CREATE TRIGGER "update_capacity_lines" BEFORE INSERT OR UPDATE ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."update_capacity"();


--
-- TOC entry 4316 (class 2606 OID 18087)
-- Name: Bays Bays_AdditionalConditionID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_AdditionalConditionID_fkey" FOREIGN KEY ("AdditionalConditionID") REFERENCES "toms_lookups"."AdditionalConditionTypes"("Code");


--
-- TOC entry 4317 (class 2606 OID 18092)
-- Name: Bays Bays_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4318 (class 2606 OID 18097)
-- Name: Bays Bays_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4319 (class 2606 OID 18102)
-- Name: Bays Bays_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "toms_lookups"."RestrictionGeomShapeTypes"("Code");


--
-- TOC entry 4320 (class 2606 OID 18107)
-- Name: Bays Bays_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4326 (class 2606 OID 18512)
-- Name: Bays Bays_MatchDayTimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4321 (class 2606 OID 18112)
-- Name: Bays Bays_MaxStayID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_MaxStayID_fkey" FOREIGN KEY ("MaxStayID") REFERENCES "toms_lookups"."LengthOfTime"("Code");


--
-- TOC entry 4322 (class 2606 OID 18117)
-- Name: Bays Bays_NoReturnID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_NoReturnID_fkey" FOREIGN KEY ("NoReturnID") REFERENCES "toms_lookups"."LengthOfTime"("Code");


--
-- TOC entry 4327 (class 2606 OID 18553)
-- Name: Bays Bays_PayParkingAreaID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_PayParkingAreaID_fkey" FOREIGN KEY ("PayParkingAreaID") REFERENCES "local_authority"."PayParkingAreas"("Code");


--
-- TOC entry 4323 (class 2606 OID 18122)
-- Name: Bays Bays_PayTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_PayTypeID_fkey" FOREIGN KEY ("PayTypeID") REFERENCES "toms_lookups"."PaymentTypes"("Code");


--
-- TOC entry 4324 (class 2606 OID 18127)
-- Name: Bays Bays_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."BayTypesInUse"("Code");


--
-- TOC entry 4325 (class 2606 OID 18132)
-- Name: Bays Bays_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4328 (class 2606 OID 18137)
-- Name: ControlledParkingZones ControlledParkingZones_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4329 (class 2606 OID 18142)
-- Name: ControlledParkingZones ControlledParkingZones_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4330 (class 2606 OID 18147)
-- Name: ControlledParkingZones ControlledParkingZones_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4332 (class 2606 OID 18527)
-- Name: ControlledParkingZones ControlledParkingZones_MatchDayTimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4331 (class 2606 OID 18157)
-- Name: ControlledParkingZones ControlledParkingZones_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4333 (class 2606 OID 18162)
-- Name: Lines Lines_AdditionalConditionID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_AdditionalConditionID_fkey" FOREIGN KEY ("AdditionalConditionID") REFERENCES "toms_lookups"."AdditionalConditionTypes"("Code");


--
-- TOC entry 4342 (class 2606 OID 18448)
-- Name: Lines Lines_ComplianceLoadingMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_ComplianceLoadingMarkingsFaded_fkey" FOREIGN KEY ("ComplianceLoadingMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4334 (class 2606 OID 18167)
-- Name: Lines Lines_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4335 (class 2606 OID 18172)
-- Name: Lines Lines_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4336 (class 2606 OID 18177)
-- Name: Lines Lines_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "toms_lookups"."RestrictionGeomShapeTypes"("Code");


--
-- TOC entry 4337 (class 2606 OID 18182)
-- Name: Lines Lines_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4343 (class 2606 OID 18517)
-- Name: Lines Lines_MatchDayTimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4338 (class 2606 OID 18187)
-- Name: Lines Lines_NoLoadingTimeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_NoLoadingTimeID_fkey" FOREIGN KEY ("NoLoadingTimeID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4339 (class 2606 OID 18192)
-- Name: Lines Lines_NoWaitingTimeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_NoWaitingTimeID_fkey" FOREIGN KEY ("NoWaitingTimeID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4340 (class 2606 OID 18197)
-- Name: Lines Lines_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."LineTypesInUse"("Code");


--
-- TOC entry 4341 (class 2606 OID 18202)
-- Name: Lines Lines_UnacceptableTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_UnacceptableTypeID_fkey" FOREIGN KEY ("UnacceptableTypeID") REFERENCES "toms_lookups"."UnacceptableTypes"("Code");


--
-- TOC entry 4344 (class 2606 OID 18207)
-- Name: ParkingTariffAreas ParkingTariffAreas_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4345 (class 2606 OID 18212)
-- Name: ParkingTariffAreas ParkingTariffAreas_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4346 (class 2606 OID 18217)
-- Name: ParkingTariffAreas ParkingTariffAreas_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4350 (class 2606 OID 18532)
-- Name: ParkingTariffAreas ParkingTariffAreas_MatchDayTimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4347 (class 2606 OID 18222)
-- Name: ParkingTariffAreas ParkingTariffAreas_MaxStayID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_MaxStayID_fkey" FOREIGN KEY ("MaxStayID") REFERENCES "toms_lookups"."LengthOfTime"("Code");


--
-- TOC entry 4348 (class 2606 OID 18227)
-- Name: ParkingTariffAreas ParkingTariffAreas_NoReturnID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_NoReturnID_fkey" FOREIGN KEY ("NoReturnID") REFERENCES "toms_lookups"."LengthOfTime"("Code");


--
-- TOC entry 4349 (class 2606 OID 18237)
-- Name: ParkingTariffAreas ParkingTariffAreas_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4351 (class 2606 OID 18242)
-- Name: Proposals Proposals_ProposalStatusTypes_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Proposals"
    ADD CONSTRAINT "Proposals_ProposalStatusTypes_fkey" FOREIGN KEY ("ProposalStatusID") REFERENCES "toms_lookups"."ProposalStatusTypes"("Code");


--
-- TOC entry 4360 (class 2606 OID 18522)
-- Name: RestrictionPolygons RestrictionPolygons_MatchDayTimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionPolygons_MatchDayTimePeriodID_fkey" FOREIGN KEY ("MatchDayTimePeriodID") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4361 (class 2606 OID 18247)
-- Name: RestrictionsInProposals RestrictionsInProposals_ActionOnProposalAcceptance_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ActionOnProposalAcceptance_fkey" FOREIGN KEY ("ActionOnProposalAcceptance") REFERENCES "toms_lookups"."ActionOnProposalAcceptanceTypes"("Code");


--
-- TOC entry 4362 (class 2606 OID 18252)
-- Name: RestrictionsInProposals RestrictionsInProposals_ProposalID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ProposalID_fkey" FOREIGN KEY ("ProposalID") REFERENCES "toms"."Proposals"("ProposalID");


--
-- TOC entry 4363 (class 2606 OID 18257)
-- Name: RestrictionsInProposals RestrictionsInProposals_RestrictionTableID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_RestrictionTableID_fkey" FOREIGN KEY ("RestrictionTableID") REFERENCES "toms"."RestrictionLayers"("Code");


--
-- TOC entry 4352 (class 2606 OID 18262)
-- Name: RestrictionPolygons RestrictionsPolygons_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4353 (class 2606 OID 18267)
-- Name: RestrictionPolygons RestrictionsPolygons_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4354 (class 2606 OID 18272)
-- Name: RestrictionPolygons RestrictionsPolygons_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "toms_lookups"."RestrictionGeomShapeTypes"("Code");


--
-- TOC entry 4355 (class 2606 OID 18277)
-- Name: RestrictionPolygons RestrictionsPolygons_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4356 (class 2606 OID 18282)
-- Name: RestrictionPolygons RestrictionsPolygons_NoLoadingTimeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_NoLoadingTimeID_fkey" FOREIGN KEY ("NoLoadingTimeID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4357 (class 2606 OID 18287)
-- Name: RestrictionPolygons RestrictionsPolygons_NoWaitingTimeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_NoWaitingTimeID_fkey" FOREIGN KEY ("NoWaitingTimeID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4358 (class 2606 OID 18292)
-- Name: RestrictionPolygons RestrictionsPolygons_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "toms_lookups"."RestrictionPolygonTypesInUse"("Code");


--
-- TOC entry 4359 (class 2606 OID 18297)
-- Name: RestrictionPolygons RestrictionsPolygons_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4364 (class 2606 OID 18302)
-- Name: Signs Signs_Compl_Signs_Faded_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Compl_Signs_Faded_fkey" FOREIGN KEY ("Compl_Signs_Faded") REFERENCES "compliance_lookups"."SignFadedTypes"("Code");


--
-- TOC entry 4365 (class 2606 OID 18307)
-- Name: Signs Signs_Compl_Signs_Obscured_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Compl_Signs_Obscured_fkey" FOREIGN KEY ("Compl_Signs_Obscured") REFERENCES "compliance_lookups"."SignObscurredTypes"("Code");


--
-- TOC entry 4366 (class 2606 OID 18312)
-- Name: Signs Signs_Compl_Signs_TicketMachines_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Compl_Signs_TicketMachines_fkey" FOREIGN KEY ("Compl_Signs_TicketMachines") REFERENCES "compliance_lookups"."TicketMachineIssueTypes"("Code");


--
-- TOC entry 4367 (class 2606 OID 18317)
-- Name: Signs Signs_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4368 (class 2606 OID 18322)
-- Name: Signs Signs_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4369 (class 2606 OID 18327)
-- Name: Signs Signs_MHTC_SignIlluminationTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_MHTC_SignIlluminationTypeID_fkey" FOREIGN KEY ("SignIlluminationTypeID") REFERENCES "compliance_lookups"."SignIlluminationTypes"("Code");


--
-- TOC entry 4370 (class 2606 OID 18332)
-- Name: Signs Signs_SignConditionTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignConditionTypeID_fkey" FOREIGN KEY ("SignConditionTypeID") REFERENCES "compliance_lookups"."SignConditionTypes"("Code");


--
-- TOC entry 4371 (class 2606 OID 18337)
-- Name: Signs Signs_SignOrientationTypeID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignOrientationTypeID_fkey" FOREIGN KEY ("SignOrientationTypeID") REFERENCES "toms_lookups"."SignOrientationTypes"("Code");


--
-- TOC entry 4372 (class 2606 OID 18342)
-- Name: Signs Signs_SignTypes1_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignTypes1_fkey" FOREIGN KEY ("SignType_1") REFERENCES "toms_lookups"."SignTypesInUse"("Code");


--
-- TOC entry 4373 (class 2606 OID 18347)
-- Name: Signs Signs_SignTypes2_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignTypes2_fkey" FOREIGN KEY ("SignType_2") REFERENCES "toms_lookups"."SignTypesInUse"("Code");


--
-- TOC entry 4374 (class 2606 OID 18352)
-- Name: Signs Signs_SignTypes3_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignTypes3_fkey" FOREIGN KEY ("SignType_3") REFERENCES "toms_lookups"."SignTypesInUse"("Code");


--
-- TOC entry 4375 (class 2606 OID 18357)
-- Name: Signs Signs_SignTypes4_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_SignTypes4_fkey" FOREIGN KEY ("SignType_4") REFERENCES "toms_lookups"."SignTypesInUse"("Code");


--
-- TOC entry 4376 (class 2606 OID 18362)
-- Name: Signs Signs_Signs_Attachment_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Signs_Attachment_fkey" FOREIGN KEY ("SignsAttachmentTypeID") REFERENCES "compliance_lookups"."SignAttachmentTypes"("Code");


--
-- TOC entry 4377 (class 2606 OID 18367)
-- Name: Signs Signs_Signs_Mount_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."Signs"
    ADD CONSTRAINT "Signs_Signs_Mount_fkey" FOREIGN KEY ("Signs_Mount") REFERENCES "compliance_lookups"."SignMountTypes"("Code");


--
-- TOC entry 4378 (class 2606 OID 18372)
-- Name: TilesInAcceptedProposals TilesInAcceptedProposals_ProposalID_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_ProposalID_fkey" FOREIGN KEY ("ProposalID") REFERENCES "toms"."Proposals"("ProposalID");


--
-- TOC entry 4379 (class 2606 OID 18377)
-- Name: TilesInAcceptedProposals TilesInAcceptedProposals_TileNr_fkey; Type: FK CONSTRAINT; Schema: toms; Owner: postgres
--

ALTER TABLE ONLY "toms"."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_TileNr_fkey" FOREIGN KEY ("TileNr") REFERENCES "toms"."MapGrid"("id");


--
-- TOC entry 4380 (class 2606 OID 18382)
-- Name: BayTypesInUse BayTypesInUse_GeomShapeGroupType_fkey; Type: FK CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."BayTypesInUse"
    ADD CONSTRAINT "BayTypesInUse_GeomShapeGroupType_fkey" FOREIGN KEY ("GeomShapeGroupType") REFERENCES "toms_lookups"."GeomShapeGroupType"("Code");


--
-- TOC entry 4381 (class 2606 OID 18387)
-- Name: LineTypesInUse LineTypesInUse_GeomShapeGroupType_fkey; Type: FK CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."LineTypesInUse"
    ADD CONSTRAINT "LineTypesInUse_GeomShapeGroupType_fkey" FOREIGN KEY ("GeomShapeGroupType") REFERENCES "toms_lookups"."GeomShapeGroupType"("Code");


--
-- TOC entry 4382 (class 2606 OID 18392)
-- Name: RestrictionPolygonTypesInUse RestrictionPolygonTypesInUse_GeomShapeGroupType_fkey; Type: FK CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."RestrictionPolygonTypesInUse"
    ADD CONSTRAINT "RestrictionPolygonTypesInUse_GeomShapeGroupType_fkey" FOREIGN KEY ("GeomShapeGroupType") REFERENCES "toms_lookups"."GeomShapeGroupType"("Code");


--
-- TOC entry 4544 (class 0 OID 17651)
-- Dependencies: 268
-- Name: Proposals; Type: ROW SECURITY; Schema: toms; Owner: postgres
--

ALTER TABLE "toms"."Proposals" ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4547 (class 3256 OID 18405)
-- Name: Proposals insertProposals; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "insertProposals" ON "toms"."Proposals" FOR INSERT TO "toms_operator" WITH CHECK (("ProposalStatusID" <> 2));


--
-- TOC entry 4549 (class 3256 OID 18407)
-- Name: Proposals insertProposals_admin; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "insertProposals_admin" ON "toms"."Proposals" FOR INSERT TO "toms_admin" WITH CHECK (("ProposalStatusID" <> 2));


--
-- TOC entry 4545 (class 3256 OID 18403)
-- Name: Proposals selectProposals; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "selectProposals" ON "toms"."Proposals" FOR SELECT USING (true);


--
-- TOC entry 4546 (class 3256 OID 18404)
-- Name: Proposals updateProposals; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "updateProposals" ON "toms"."Proposals" FOR UPDATE TO "toms_operator" USING (true) WITH CHECK (("ProposalStatusID" <> 2));


--
-- TOC entry 4548 (class 3256 OID 18406)
-- Name: Proposals updateProposals_admin; Type: POLICY; Schema: toms; Owner: postgres
--

CREATE POLICY "updateProposals_admin" ON "toms"."Proposals" FOR UPDATE TO "toms_admin" USING (true);


--
-- TOC entry 4663 (class 0 OID 0)
-- Dependencies: 22
-- Name: SCHEMA "addresses"; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA "addresses" TO "toms_public";
GRANT USAGE ON SCHEMA "addresses" TO "toms_operator";
GRANT USAGE ON SCHEMA "addresses" TO "toms_admin";


--
-- TOC entry 4664 (class 0 OID 0)
-- Dependencies: 12
-- Name: SCHEMA "compliance"; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA "compliance" TO "toms_public";
GRANT USAGE ON SCHEMA "compliance" TO "toms_operator";
GRANT USAGE ON SCHEMA "compliance" TO "toms_admin";


--
-- TOC entry 4665 (class 0 OID 0)
-- Dependencies: 17
-- Name: SCHEMA "compliance_lookups"; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA "compliance_lookups" TO "toms_public";
GRANT USAGE ON SCHEMA "compliance_lookups" TO "toms_operator";
GRANT USAGE ON SCHEMA "compliance_lookups" TO "toms_admin";


--
-- TOC entry 4666 (class 0 OID 0)
-- Dependencies: 16
-- Name: SCHEMA "export"; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA "export" TO "toms_public";
GRANT USAGE ON SCHEMA "export" TO "toms_operator";
GRANT USAGE ON SCHEMA "export" TO "toms_admin";


--
-- TOC entry 4667 (class 0 OID 0)
-- Dependencies: 10
-- Name: SCHEMA "highways_network"; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA "highways_network" TO "toms_public";
GRANT USAGE ON SCHEMA "highways_network" TO "toms_operator";
GRANT USAGE ON SCHEMA "highways_network" TO "toms_admin";


--
-- TOC entry 4668 (class 0 OID 0)
-- Dependencies: 21
-- Name: SCHEMA "local_authority"; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA "local_authority" TO "toms_public";
GRANT USAGE ON SCHEMA "local_authority" TO "toms_operator";
GRANT USAGE ON SCHEMA "local_authority" TO "toms_admin";


--
-- TOC entry 4669 (class 0 OID 0)
-- Dependencies: 9
-- Name: SCHEMA "mhtc_operations"; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA "mhtc_operations" TO "toms_public";
GRANT USAGE ON SCHEMA "mhtc_operations" TO "toms_operator";
GRANT USAGE ON SCHEMA "mhtc_operations" TO "toms_admin";


--
-- TOC entry 4670 (class 0 OID 0)
-- Dependencies: 20
-- Name: SCHEMA "toms"; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA "toms" TO "toms_public";
GRANT USAGE ON SCHEMA "toms" TO "toms_operator";
GRANT USAGE ON SCHEMA "toms" TO "toms_admin";


--
-- TOC entry 4671 (class 0 OID 0)
-- Dependencies: 14
-- Name: SCHEMA "toms_lookups"; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA "toms_lookups" TO "toms_public";
GRANT USAGE ON SCHEMA "toms_lookups" TO "toms_operator";
GRANT USAGE ON SCHEMA "toms_lookups" TO "toms_admin";


--
-- TOC entry 4672 (class 0 OID 0)
-- Dependencies: 15
-- Name: SCHEMA "topography"; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA "topography" TO "toms_public";
GRANT USAGE ON SCHEMA "topography" TO "toms_operator";
GRANT USAGE ON SCHEMA "topography" TO "toms_admin";


--
-- TOC entry 4677 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE "RestrictionRoadMarkingsFadedTypes"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" TO "toms_public";
GRANT SELECT ON TABLE "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" TO "toms_admin";


--
-- TOC entry 4679 (class 0 OID 0)
-- Dependencies: 224
-- Name: SEQUENCE "BayLinesFadedTypes_Code_seq"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."BayLinesFadedTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."BayLinesFadedTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."BayLinesFadedTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4680 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE "Restriction_SignIssueTypes"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "compliance_lookups"."Restriction_SignIssueTypes" TO "toms_public";
GRANT SELECT ON TABLE "compliance_lookups"."Restriction_SignIssueTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "compliance_lookups"."Restriction_SignIssueTypes" TO "toms_admin";


--
-- TOC entry 4682 (class 0 OID 0)
-- Dependencies: 226
-- Name: SEQUENCE "BaysLines_SignIssueTypes_Code_seq"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."BaysLines_SignIssueTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."BaysLines_SignIssueTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."BaysLines_SignIssueTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4683 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE "ConditionTypes"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "compliance_lookups"."ConditionTypes" TO "toms_public";
GRANT SELECT ON TABLE "compliance_lookups"."ConditionTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "compliance_lookups"."ConditionTypes" TO "toms_admin";


--
-- TOC entry 4685 (class 0 OID 0)
-- Dependencies: 228
-- Name: SEQUENCE "ConditionTypes_Code_seq"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."ConditionTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."ConditionTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."ConditionTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4686 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE "MHTC_CheckIssueTypes"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "compliance_lookups"."MHTC_CheckIssueTypes" TO "toms_public";
GRANT SELECT ON TABLE "compliance_lookups"."MHTC_CheckIssueTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "compliance_lookups"."MHTC_CheckIssueTypes" TO "toms_admin";


--
-- TOC entry 4688 (class 0 OID 0)
-- Dependencies: 230
-- Name: SEQUENCE "MHTC_CheckIssueType_Code_seq"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."MHTC_CheckIssueType_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."MHTC_CheckIssueType_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."MHTC_CheckIssueType_Code_seq" TO "toms_admin";


--
-- TOC entry 4689 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE "MHTC_CheckStatus"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "compliance_lookups"."MHTC_CheckStatus" TO "toms_public";
GRANT SELECT ON TABLE "compliance_lookups"."MHTC_CheckStatus" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "compliance_lookups"."MHTC_CheckStatus" TO "toms_admin";


--
-- TOC entry 4691 (class 0 OID 0)
-- Dependencies: 232
-- Name: SEQUENCE "MHTC_CheckStatus_Code_seq"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."MHTC_CheckStatus_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."MHTC_CheckStatus_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."MHTC_CheckStatus_Code_seq" TO "toms_admin";


--
-- TOC entry 4692 (class 0 OID 0)
-- Dependencies: 323
-- Name: SEQUENCE "SignAttachmentTypes_Code_seq"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignAttachmentTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignAttachmentTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignAttachmentTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4693 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE "SignAttachmentTypes"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "compliance_lookups"."SignAttachmentTypes" TO "toms_public";
GRANT SELECT ON TABLE "compliance_lookups"."SignAttachmentTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "compliance_lookups"."SignAttachmentTypes" TO "toms_admin";


--
-- TOC entry 4694 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE "SignConditionTypes"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "compliance_lookups"."SignConditionTypes" TO "toms_public";
GRANT SELECT ON TABLE "compliance_lookups"."SignConditionTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "compliance_lookups"."SignConditionTypes" TO "toms_admin";


--
-- TOC entry 4696 (class 0 OID 0)
-- Dependencies: 235
-- Name: SEQUENCE "SignConditionTypes_Code_seq"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignConditionTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignConditionTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignConditionTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4697 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE "SignFadedTypes"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "compliance_lookups"."SignFadedTypes" TO "toms_public";
GRANT SELECT ON TABLE "compliance_lookups"."SignFadedTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "compliance_lookups"."SignFadedTypes" TO "toms_admin";


--
-- TOC entry 4699 (class 0 OID 0)
-- Dependencies: 237
-- Name: SEQUENCE "SignFadedTypes_id_seq"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignFadedTypes_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignFadedTypes_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignFadedTypes_id_seq" TO "toms_admin";


--
-- TOC entry 4700 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE "SignIlluminationTypes"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "compliance_lookups"."SignIlluminationTypes" TO "toms_public";
GRANT SELECT ON TABLE "compliance_lookups"."SignIlluminationTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "compliance_lookups"."SignIlluminationTypes" TO "toms_admin";


--
-- TOC entry 4702 (class 0 OID 0)
-- Dependencies: 239
-- Name: SEQUENCE "SignIlluminationTypes_Code_seq"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignIlluminationTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignIlluminationTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignIlluminationTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4703 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE "SignMountTypes"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "compliance_lookups"."SignMountTypes" TO "toms_public";
GRANT SELECT ON TABLE "compliance_lookups"."SignMountTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "compliance_lookups"."SignMountTypes" TO "toms_admin";


--
-- TOC entry 4705 (class 0 OID 0)
-- Dependencies: 241
-- Name: SEQUENCE "SignMountTypes_id_seq"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignMountTypes_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignMountTypes_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignMountTypes_id_seq" TO "toms_admin";


--
-- TOC entry 4706 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE "SignObscurredTypes"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "compliance_lookups"."SignObscurredTypes" TO "toms_public";
GRANT SELECT ON TABLE "compliance_lookups"."SignObscurredTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "compliance_lookups"."SignObscurredTypes" TO "toms_admin";


--
-- TOC entry 4708 (class 0 OID 0)
-- Dependencies: 243
-- Name: SEQUENCE "SignObscurredTypes_id_seq"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignObscurredTypes_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignObscurredTypes_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."SignObscurredTypes_id_seq" TO "toms_admin";


--
-- TOC entry 4709 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE "TicketMachineIssueTypes"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "compliance_lookups"."TicketMachineIssueTypes" TO "toms_public";
GRANT SELECT ON TABLE "compliance_lookups"."TicketMachineIssueTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "compliance_lookups"."TicketMachineIssueTypes" TO "toms_admin";


--
-- TOC entry 4711 (class 0 OID 0)
-- Dependencies: 245
-- Name: SEQUENCE "TicketMachineIssueTypes_id_seq"; Type: ACL; Schema: compliance_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."TicketMachineIssueTypes_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."TicketMachineIssueTypes_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "compliance_lookups"."TicketMachineIssueTypes_id_seq" TO "toms_admin";


--
-- TOC entry 4712 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE "itn_roadcentreline"; Type: ACL; Schema: highways_network; Owner: postgres
--

GRANT SELECT ON TABLE "highways_network"."itn_roadcentreline" TO "toms_public";
GRANT SELECT ON TABLE "highways_network"."itn_roadcentreline" TO "toms_operator";
GRANT SELECT ON TABLE "highways_network"."itn_roadcentreline" TO "toms_admin";


--
-- TOC entry 4714 (class 0 OID 0)
-- Dependencies: 247
-- Name: SEQUENCE "itn_roadcentreline_gid_seq"; Type: ACL; Schema: highways_network; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "highways_network"."itn_roadcentreline_gid_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "highways_network"."itn_roadcentreline_gid_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "highways_network"."itn_roadcentreline_gid_seq" TO "toms_admin";


--
-- TOC entry 4715 (class 0 OID 0)
-- Dependencies: 329
-- Name: TABLE "PayParkingAreas"; Type: ACL; Schema: local_authority; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "local_authority"."PayParkingAreas" TO "toms_admin";
GRANT SELECT ON TABLE "local_authority"."PayParkingAreas" TO "toms_operator";
GRANT SELECT ON TABLE "local_authority"."PayParkingAreas" TO "toms_public";


--
-- TOC entry 4716 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE "SiteArea"; Type: ACL; Schema: local_authority; Owner: postgres
--

GRANT SELECT ON TABLE "local_authority"."SiteArea" TO "toms_public";
GRANT SELECT ON TABLE "local_authority"."SiteArea" TO "toms_operator";
GRANT SELECT ON TABLE "local_authority"."SiteArea" TO "toms_admin";


--
-- TOC entry 4718 (class 0 OID 0)
-- Dependencies: 249
-- Name: SEQUENCE "SiteArea_id_seq"; Type: ACL; Schema: local_authority; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "local_authority"."SiteArea_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "local_authority"."SiteArea_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "local_authority"."SiteArea_id_seq" TO "toms_admin";


--
-- TOC entry 4719 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE "StreetGazetteerRecords"; Type: ACL; Schema: local_authority; Owner: postgres
--

GRANT SELECT ON TABLE "local_authority"."StreetGazetteerRecords" TO "toms_public";
GRANT SELECT ON TABLE "local_authority"."StreetGazetteerRecords" TO "toms_operator";
GRANT SELECT ON TABLE "local_authority"."StreetGazetteerRecords" TO "toms_admin";


--
-- TOC entry 4721 (class 0 OID 0)
-- Dependencies: 251
-- Name: SEQUENCE "StreetGazetteerRecords_id_seq"; Type: ACL; Schema: local_authority; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "local_authority"."StreetGazetteerRecords_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "local_authority"."StreetGazetteerRecords_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "local_authority"."StreetGazetteerRecords_id_seq" TO "toms_admin";


--
-- TOC entry 4722 (class 0 OID 0)
-- Dependencies: 327
-- Name: TABLE "AreasForReview"; Type: ACL; Schema: mhtc_operations; Owner: postgres
--

GRANT SELECT ON TABLE "mhtc_operations"."AreasForReview" TO "toms_public";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "mhtc_operations"."AreasForReview" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "mhtc_operations"."AreasForReview" TO "toms_admin";


--
-- TOC entry 4723 (class 0 OID 0)
-- Dependencies: 312
-- Name: TABLE "Corners"; Type: ACL; Schema: mhtc_operations; Owner: postgres
--

GRANT SELECT ON TABLE "mhtc_operations"."Corners" TO "toms_public";
GRANT SELECT ON TABLE "mhtc_operations"."Corners" TO "toms_operator";
GRANT SELECT ON TABLE "mhtc_operations"."Corners" TO "toms_admin";


--
-- TOC entry 4725 (class 0 OID 0)
-- Dependencies: 313
-- Name: SEQUENCE "Corners_id_seq"; Type: ACL; Schema: mhtc_operations; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "mhtc_operations"."Corners_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "mhtc_operations"."Corners_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "mhtc_operations"."Corners_id_seq" TO "toms_admin";


--
-- TOC entry 4726 (class 0 OID 0)
-- Dependencies: 324
-- Name: SEQUENCE "gnss_pts_id_seq"; Type: ACL; Schema: mhtc_operations; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "mhtc_operations"."gnss_pts_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "mhtc_operations"."gnss_pts_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "mhtc_operations"."gnss_pts_id_seq" TO "toms_admin";


--
-- TOC entry 4727 (class 0 OID 0)
-- Dependencies: 325
-- Name: TABLE "gnss_pts"; Type: ACL; Schema: mhtc_operations; Owner: postgres
--

GRANT SELECT ON TABLE "mhtc_operations"."gnss_pts" TO "toms_public";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "mhtc_operations"."gnss_pts" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "mhtc_operations"."gnss_pts" TO "toms_admin";


--
-- TOC entry 4728 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE "project_parameters"; Type: ACL; Schema: mhtc_operations; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "mhtc_operations"."project_parameters" TO "toms_admin";
GRANT SELECT ON TABLE "mhtc_operations"."project_parameters" TO "toms_operator";
GRANT SELECT ON TABLE "mhtc_operations"."project_parameters" TO "toms_public";


--
-- TOC entry 4732 (class 0 OID 0)
-- Dependencies: 258
-- Name: SEQUENCE "Bays_id_seq"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms"."Bays_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms"."Bays_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms"."Bays_id_seq" TO "toms_admin";


--
-- TOC entry 4733 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE "Bays"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT ON TABLE "toms"."Bays" TO "toms_public";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms"."Bays" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms"."Bays" TO "toms_admin";


--
-- TOC entry 4734 (class 0 OID 0)
-- Dependencies: 260
-- Name: SEQUENCE "ControlledParkingZones_id_seq"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms"."ControlledParkingZones_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms"."ControlledParkingZones_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms"."ControlledParkingZones_id_seq" TO "toms_admin";


--
-- TOC entry 4735 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE "ControlledParkingZones"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT ON TABLE "toms"."ControlledParkingZones" TO "toms_public";
GRANT SELECT ON TABLE "toms"."ControlledParkingZones" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms"."ControlledParkingZones" TO "toms_admin";


--
-- TOC entry 4736 (class 0 OID 0)
-- Dependencies: 262
-- Name: SEQUENCE "Lines_id_seq"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms"."Lines_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms"."Lines_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms"."Lines_id_seq" TO "toms_admin";


--
-- TOC entry 4737 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE "Lines"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT ON TABLE "toms"."Lines" TO "toms_public";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms"."Lines" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms"."Lines" TO "toms_admin";


--
-- TOC entry 4738 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE "MapGrid"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT ON TABLE "toms"."MapGrid" TO "toms_public";
GRANT SELECT,UPDATE ON TABLE "toms"."MapGrid" TO "toms_operator";
GRANT SELECT,UPDATE ON TABLE "toms"."MapGrid" TO "toms_admin";


--
-- TOC entry 4739 (class 0 OID 0)
-- Dependencies: 265
-- Name: SEQUENCE "ParkingTariffAreas_id_seq"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms"."ParkingTariffAreas_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms"."ParkingTariffAreas_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms"."ParkingTariffAreas_id_seq" TO "toms_admin";


--
-- TOC entry 4740 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE "ParkingTariffAreas"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT ON TABLE "toms"."ParkingTariffAreas" TO "toms_public";
GRANT SELECT ON TABLE "toms"."ParkingTariffAreas" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms"."ParkingTariffAreas" TO "toms_admin";


--
-- TOC entry 4741 (class 0 OID 0)
-- Dependencies: 267
-- Name: SEQUENCE "Proposals_id_seq"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms"."Proposals_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms"."Proposals_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms"."Proposals_id_seq" TO "toms_admin";


--
-- TOC entry 4742 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE "Proposals"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT ON TABLE "toms"."Proposals" TO "toms_public";
GRANT SELECT,INSERT,UPDATE ON TABLE "toms"."Proposals" TO "toms_operator";
GRANT SELECT,INSERT,UPDATE ON TABLE "toms"."Proposals" TO "toms_admin";


--
-- TOC entry 4743 (class 0 OID 0)
-- Dependencies: 269
-- Name: TABLE "RestrictionLayers"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT ON TABLE "toms"."RestrictionLayers" TO "toms_public";
GRANT SELECT ON TABLE "toms"."RestrictionLayers" TO "toms_operator";
GRANT SELECT ON TABLE "toms"."RestrictionLayers" TO "toms_admin";


--
-- TOC entry 4745 (class 0 OID 0)
-- Dependencies: 270
-- Name: SEQUENCE "RestrictionLayers_id_seq"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms"."RestrictionLayers_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms"."RestrictionLayers_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms"."RestrictionLayers_id_seq" TO "toms_admin";


--
-- TOC entry 4746 (class 0 OID 0)
-- Dependencies: 271
-- Name: SEQUENCE "RestrictionPolygons_id_seq"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms"."RestrictionPolygons_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms"."RestrictionPolygons_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms"."RestrictionPolygons_id_seq" TO "toms_admin";


--
-- TOC entry 4747 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE "RestrictionPolygons"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT ON TABLE "toms"."RestrictionPolygons" TO "toms_public";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms"."RestrictionPolygons" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms"."RestrictionPolygons" TO "toms_admin";


--
-- TOC entry 4748 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE "RestrictionsInProposals"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT ON TABLE "toms"."RestrictionsInProposals" TO "toms_public";
GRANT SELECT,INSERT,DELETE ON TABLE "toms"."RestrictionsInProposals" TO "toms_operator";
GRANT SELECT,INSERT,DELETE ON TABLE "toms"."RestrictionsInProposals" TO "toms_admin";


--
-- TOC entry 4749 (class 0 OID 0)
-- Dependencies: 274
-- Name: SEQUENCE "Signs_id_seq"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms"."Signs_id_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms"."Signs_id_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms"."Signs_id_seq" TO "toms_admin";


--
-- TOC entry 4750 (class 0 OID 0)
-- Dependencies: 275
-- Name: TABLE "Signs"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT ON TABLE "toms"."Signs" TO "toms_public";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms"."Signs" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms"."Signs" TO "toms_admin";


--
-- TOC entry 4751 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE "TilesInAcceptedProposals"; Type: ACL; Schema: toms; Owner: postgres
--

GRANT SELECT ON TABLE "toms"."TilesInAcceptedProposals" TO "toms_public";
GRANT SELECT,INSERT ON TABLE "toms"."TilesInAcceptedProposals" TO "toms_operator";
GRANT SELECT,INSERT ON TABLE "toms"."TilesInAcceptedProposals" TO "toms_admin";


--
-- TOC entry 4752 (class 0 OID 0)
-- Dependencies: 277
-- Name: TABLE "ActionOnProposalAcceptanceTypes"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."ActionOnProposalAcceptanceTypes" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."ActionOnProposalAcceptanceTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."ActionOnProposalAcceptanceTypes" TO "toms_admin";


--
-- TOC entry 4754 (class 0 OID 0)
-- Dependencies: 278
-- Name: SEQUENCE "ActionOnProposalAcceptanceTypes_Code_seq"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4755 (class 0 OID 0)
-- Dependencies: 279
-- Name: TABLE "AdditionalConditionTypes"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."AdditionalConditionTypes" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."AdditionalConditionTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."AdditionalConditionTypes" TO "toms_admin";


--
-- TOC entry 4757 (class 0 OID 0)
-- Dependencies: 280
-- Name: SEQUENCE "AdditionalConditionTypes_Code_seq"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."AdditionalConditionTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."AdditionalConditionTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."AdditionalConditionTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4758 (class 0 OID 0)
-- Dependencies: 281
-- Name: TABLE "BayLineTypes"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."BayLineTypes" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."BayLineTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."BayLineTypes" TO "toms_admin";


--
-- TOC entry 4760 (class 0 OID 0)
-- Dependencies: 282
-- Name: SEQUENCE "BayLineTypes_Code_seq"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."BayLineTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."BayLineTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."BayLineTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4761 (class 0 OID 0)
-- Dependencies: 283
-- Name: TABLE "BayTypesInUse"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."BayTypesInUse" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."BayTypesInUse" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."BayTypesInUse" TO "toms_admin";


--
-- TOC entry 4762 (class 0 OID 0)
-- Dependencies: 284
-- Name: TABLE "BayTypesInUse_View"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."BayTypesInUse_View" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."BayTypesInUse_View" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."BayTypesInUse_View" TO "toms_admin";


--
-- TOC entry 4763 (class 0 OID 0)
-- Dependencies: 285
-- Name: TABLE "GeomShapeGroupType"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."GeomShapeGroupType" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."GeomShapeGroupType" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."GeomShapeGroupType" TO "toms_admin";


--
-- TOC entry 4764 (class 0 OID 0)
-- Dependencies: 286
-- Name: TABLE "LengthOfTime"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."LengthOfTime" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."LengthOfTime" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."LengthOfTime" TO "toms_admin";


--
-- TOC entry 4766 (class 0 OID 0)
-- Dependencies: 287
-- Name: SEQUENCE "LengthOfTime_Code_seq"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."LengthOfTime_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."LengthOfTime_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."LengthOfTime_Code_seq" TO "toms_admin";


--
-- TOC entry 4767 (class 0 OID 0)
-- Dependencies: 288
-- Name: TABLE "LineTypesInUse"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."LineTypesInUse" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."LineTypesInUse" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."LineTypesInUse" TO "toms_admin";


--
-- TOC entry 4768 (class 0 OID 0)
-- Dependencies: 289
-- Name: TABLE "LineTypesInUse_View"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."LineTypesInUse_View" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."LineTypesInUse_View" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."LineTypesInUse_View" TO "toms_admin";


--
-- TOC entry 4769 (class 0 OID 0)
-- Dependencies: 290
-- Name: TABLE "PaymentTypes"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."PaymentTypes" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."PaymentTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."PaymentTypes" TO "toms_admin";


--
-- TOC entry 4771 (class 0 OID 0)
-- Dependencies: 291
-- Name: SEQUENCE "PaymentTypes_Code_seq"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."PaymentTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."PaymentTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."PaymentTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4772 (class 0 OID 0)
-- Dependencies: 292
-- Name: TABLE "ProposalStatusTypes"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."ProposalStatusTypes" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."ProposalStatusTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."ProposalStatusTypes" TO "toms_admin";


--
-- TOC entry 4774 (class 0 OID 0)
-- Dependencies: 293
-- Name: SEQUENCE "ProposalStatusTypes_Code_seq"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."ProposalStatusTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."ProposalStatusTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."ProposalStatusTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4775 (class 0 OID 0)
-- Dependencies: 294
-- Name: TABLE "RestrictionGeomShapeTypes"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."RestrictionGeomShapeTypes" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."RestrictionGeomShapeTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."RestrictionGeomShapeTypes" TO "toms_admin";


--
-- TOC entry 4776 (class 0 OID 0)
-- Dependencies: 295
-- Name: TABLE "RestrictionPolygonTypes"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."RestrictionPolygonTypes" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."RestrictionPolygonTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."RestrictionPolygonTypes" TO "toms_admin";


--
-- TOC entry 4777 (class 0 OID 0)
-- Dependencies: 296
-- Name: TABLE "RestrictionPolygonTypesInUse"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."RestrictionPolygonTypesInUse" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."RestrictionPolygonTypesInUse" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."RestrictionPolygonTypesInUse" TO "toms_admin";


--
-- TOC entry 4778 (class 0 OID 0)
-- Dependencies: 297
-- Name: TABLE "RestrictionPolygonTypesInUse_View"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."RestrictionPolygonTypesInUse_View" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."RestrictionPolygonTypesInUse_View" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."RestrictionPolygonTypesInUse_View" TO "toms_admin";


--
-- TOC entry 4780 (class 0 OID 0)
-- Dependencies: 298
-- Name: SEQUENCE "RestrictionPolygonTypes_Code_seq"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."RestrictionPolygonTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."RestrictionPolygonTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."RestrictionPolygonTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4782 (class 0 OID 0)
-- Dependencies: 299
-- Name: SEQUENCE "RestrictionShapeTypes_Code_seq"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."RestrictionShapeTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."RestrictionShapeTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."RestrictionShapeTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4783 (class 0 OID 0)
-- Dependencies: 300
-- Name: TABLE "SignOrientationTypes"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."SignOrientationTypes" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."SignOrientationTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."SignOrientationTypes" TO "toms_admin";


--
-- TOC entry 4785 (class 0 OID 0)
-- Dependencies: 301
-- Name: SEQUENCE "SignOrientationTypes_Code_seq"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."SignOrientationTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."SignOrientationTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."SignOrientationTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4786 (class 0 OID 0)
-- Dependencies: 302
-- Name: TABLE "SignTypes"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."SignTypes" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."SignTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."SignTypes" TO "toms_admin";


--
-- TOC entry 4787 (class 0 OID 0)
-- Dependencies: 303
-- Name: TABLE "SignTypesInUse"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."SignTypesInUse" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."SignTypesInUse" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."SignTypesInUse" TO "toms_admin";


--
-- TOC entry 4788 (class 0 OID 0)
-- Dependencies: 304
-- Name: TABLE "SignTypesInUse_View"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."SignTypesInUse_View" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."SignTypesInUse_View" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."SignTypesInUse_View" TO "toms_admin";


--
-- TOC entry 4790 (class 0 OID 0)
-- Dependencies: 305
-- Name: SEQUENCE "SignTypes_Code_seq"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."SignTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."SignTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."SignTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4791 (class 0 OID 0)
-- Dependencies: 306
-- Name: TABLE "TimePeriods"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."TimePeriods" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."TimePeriods" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."TimePeriods" TO "toms_admin";


--
-- TOC entry 4792 (class 0 OID 0)
-- Dependencies: 307
-- Name: TABLE "TimePeriodsInUse"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."TimePeriodsInUse" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."TimePeriodsInUse" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."TimePeriodsInUse" TO "toms_admin";


--
-- TOC entry 4793 (class 0 OID 0)
-- Dependencies: 308
-- Name: TABLE "TimePeriodsInUse_View"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."TimePeriodsInUse_View" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."TimePeriodsInUse_View" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."TimePeriodsInUse_View" TO "toms_admin";


--
-- TOC entry 4795 (class 0 OID 0)
-- Dependencies: 309
-- Name: SEQUENCE "TimePeriods_Code_seq"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."TimePeriods_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."TimePeriods_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."TimePeriods_Code_seq" TO "toms_admin";


--
-- TOC entry 4796 (class 0 OID 0)
-- Dependencies: 310
-- Name: TABLE "UnacceptableTypes"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT ON TABLE "toms_lookups"."UnacceptableTypes" TO "toms_public";
GRANT SELECT ON TABLE "toms_lookups"."UnacceptableTypes" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "toms_lookups"."UnacceptableTypes" TO "toms_admin";


--
-- TOC entry 4798 (class 0 OID 0)
-- Dependencies: 311
-- Name: SEQUENCE "UnacceptableTypes_Code_seq"; Type: ACL; Schema: toms_lookups; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."UnacceptableTypes_Code_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."UnacceptableTypes_Code_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "toms_lookups"."UnacceptableTypes_Code_seq" TO "toms_admin";


--
-- TOC entry 4799 (class 0 OID 0)
-- Dependencies: 316
-- Name: TABLE "os_mastermap_topography_polygons"; Type: ACL; Schema: topography; Owner: postgres
--

GRANT SELECT ON TABLE "topography"."os_mastermap_topography_polygons" TO "toms_public";
GRANT SELECT ON TABLE "topography"."os_mastermap_topography_polygons" TO "toms_operator";
GRANT SELECT ON TABLE "topography"."os_mastermap_topography_polygons" TO "toms_admin";


--
-- TOC entry 4801 (class 0 OID 0)
-- Dependencies: 317
-- Name: SEQUENCE "os_mastermap_topography_polygons_seq"; Type: ACL; Schema: topography; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "topography"."os_mastermap_topography_polygons_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "topography"."os_mastermap_topography_polygons_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "topography"."os_mastermap_topography_polygons_seq" TO "toms_admin";


--
-- TOC entry 4802 (class 0 OID 0)
-- Dependencies: 314
-- Name: TABLE "os_mastermap_topography_text"; Type: ACL; Schema: topography; Owner: postgres
--

GRANT SELECT ON TABLE "topography"."os_mastermap_topography_text" TO "toms_public";
GRANT SELECT ON TABLE "topography"."os_mastermap_topography_text" TO "toms_operator";
GRANT SELECT ON TABLE "topography"."os_mastermap_topography_text" TO "toms_admin";


--
-- TOC entry 4804 (class 0 OID 0)
-- Dependencies: 315
-- Name: SEQUENCE "os_mastermap_topography_text_seq"; Type: ACL; Schema: topography; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "topography"."os_mastermap_topography_text_seq" TO "toms_public";
GRANT SELECT,USAGE ON SEQUENCE "topography"."os_mastermap_topography_text_seq" TO "toms_operator";
GRANT SELECT,USAGE ON SEQUENCE "topography"."os_mastermap_topography_text_seq" TO "toms_admin";


--
-- TOC entry 4805 (class 0 OID 0)
-- Dependencies: 318
-- Name: TABLE "road_casement"; Type: ACL; Schema: topography; Owner: postgres
--

GRANT SELECT ON TABLE "topography"."road_casement" TO "toms_public";
GRANT SELECT ON TABLE "topography"."road_casement" TO "toms_operator";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "topography"."road_casement" TO "toms_admin";


--
-- TOC entry 4611 (class 0 OID 17711)
-- Dependencies: 284 4659
-- Name: BayTypesInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."BayTypesInUse_View";


--
-- TOC entry 4616 (class 0 OID 17732)
-- Dependencies: 289 4659
-- Name: LineTypesInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."LineTypesInUse_View";


--
-- TOC entry 4624 (class 0 OID 17770)
-- Dependencies: 297 4659
-- Name: RestrictionPolygonTypesInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."RestrictionPolygonTypesInUse_View";


--
-- TOC entry 4631 (class 0 OID 17798)
-- Dependencies: 304 4659
-- Name: SignTypesInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."SignTypesInUse_View";


--
-- TOC entry 4635 (class 0 OID 17816)
-- Dependencies: 308 4659
-- Name: TimePeriodsInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."TimePeriodsInUse_View";


-- Completed on 2021-01-29 15:47:58

--
-- PostgreSQL database dump complete
--

