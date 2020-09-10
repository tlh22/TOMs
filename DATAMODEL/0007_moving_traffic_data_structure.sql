--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-08-06 08:01:13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
--SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 351590)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "public";


--
-- TOC entry 3962 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';

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
	WHEN 'AccessRestrictions' THEN
		   SELECT concat('A_', to_char(nextval('moving_traffic."AccessRestrictions_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'HighwayDedications' THEN
		   SELECT concat('H_', to_char(nextval('moving_traffic."HighwayDedications_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'RestrictionsForVehicles' THEN
		   SELECT concat('R_', to_char(nextval('moving_traffic."RestrictionsForVehicles_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'SpecialDesignations' THEN
		   SELECT concat('D_', to_char(nextval('moving_traffic."SpecialDesignations_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'TurnRestrictions' THEN
		   SELECT concat('V_', to_char(nextval('moving_traffic."TurnRestrictions_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'CarriagewayMarkings' THEN
		   SELECT concat('M_', to_char(nextval('moving_traffic."CarriagewayMarkings_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'MHTC_RoadLinks' THEN
		   SELECT concat('L_', to_char(nextval('highways_network."MHTC_RoadLinks_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;

	ELSE
	    nextSeqVal = 'U';
	END CASE;

    NEW."GeometryID" := nextSeqVal;
	RETURN NEW;

END;
$BODY$;

ALTER FUNCTION public.create_geometryid()
    OWNER TO postgres;

--
-- TOC entry 26 (class 2615 OID 515531)
-- Name: moving_traffic_lookups; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "moving_traffic_lookups";


ALTER SCHEMA "moving_traffic_lookups" OWNER TO "postgres";

--
-- TOC entry 2063 (class 1247 OID 515533)
-- Name: accessRestrictionValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."accessRestrictionValue" AS ENUM (
    'seasonal',
    'publicAccess',
    'private',
    'physicallyImpossible',
    'forbiddenLegally',
    'toll'
);


ALTER TYPE "moving_traffic_lookups"."accessRestrictionValue" OWNER TO "postgres";

--
-- TOC entry 2066 (class 1247 OID 515546)
-- Name: cycleFacilityValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."cycleFacilityValue" AS ENUM (
    'Advisory Cycle Lane Along Road',
    'Mandatory Cycle Lane Along Road',
    'Physically Segregated Cycle Lane Along Road',
    'Unknown Type of Cycle Route Along Road',
    'Signed Cycle Route'
);


ALTER TYPE "moving_traffic_lookups"."cycleFacilityValue" OWNER TO "postgres";

--
-- TOC entry 2069 (class 1247 OID 515558)
-- Name: dedicationValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."dedicationValue" AS ENUM (
    'All Vehicles',
    'Bridleway',
    'Byway Open To All Traffic',
    'Cycle Track Or Cycle Way',
    'Motorway',
    'No Dedication Or Dedication Unknown',
    'Pedestrian Way Or Footpath',
    'Restricted Byway',
    'Separated track and path for cyclists and pedestrians'
);


ALTER TYPE "moving_traffic_lookups"."dedicationValue" OWNER TO "postgres";

--
-- TOC entry 2072 (class 1247 OID 515578)
-- Name: linkDirectionValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."linkDirectionValue" AS ENUM (
    'bothDirections',
    'inDirection',
    'inOppositeDirection'
);


ALTER TYPE "moving_traffic_lookups"."linkDirectionValue" OWNER TO "postgres";

--
-- TOC entry 2075 (class 1247 OID 515586)
-- Name: loadTypeValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."loadTypeValue" AS ENUM (
    'Abnormal Loads',
    'Animal Loads',
    'Dangerous Goods',
    'Explosives',
    'Wide Loads'
);


ALTER TYPE "moving_traffic_lookups"."loadTypeValue" OWNER TO "postgres";

--
-- TOC entry 2078 (class 1247 OID 515598)
-- Name: restrictionTypeValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."restrictionTypeValue" AS ENUM (
    'maximumDoubleAxleWeight',
    'maximumHeight',
    'maximumLength',
    'maximumSingleAxleWeight',
    'maximumTotalWeight',
    'maximumTripleAxleWeight',
    'maximumWidth'
);


ALTER TYPE "moving_traffic_lookups"."restrictionTypeValue" OWNER TO "postgres";

--
-- TOC entry 2081 (class 1247 OID 515614)
-- Name: specialDesignationTypeValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."specialDesignationTypeValue" AS ENUM (
    'Bus Lane',
    'Cycle Lane',
    'Signal controlled cycle crossing'
);


ALTER TYPE "moving_traffic_lookups"."specialDesignationTypeValue" OWNER TO "postgres";

--
-- TOC entry 2084 (class 1247 OID 515622)
-- Name: structureTypeValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."structureTypeValue" AS ENUM (
    'Barrier',
    'Bridge Under Road',
    'Bridge Over Road',
    'Gate',
    'Level Crossing Fully Barriered',
    'Level Crossing Part Barriered',
    'Level Crossing Unbarriered',
    'Moveable barrier',
    'Pedestrian Crossing',
    'Rising Bollards',
    'Street Lighting',
    'Structure',
    'Traffic Calming',
    'Traffic Signal',
    'Toll Indicator',
    'Tunnel'
);


ALTER TYPE "moving_traffic_lookups"."structureTypeValue" OWNER TO "postgres";

--
-- TOC entry 2087 (class 1247 OID 515656)
-- Name: turnRestrictionValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."turnRestrictionValue" AS ENUM (
    'Mandatory Turn',
    'No Turn',
    'One Way',
    'Priority to on-coming vehicles'
);


ALTER TYPE "moving_traffic_lookups"."turnRestrictionValue" OWNER TO "postgres";

--
-- TOC entry 2090 (class 1247 OID 515666)
-- Name: useTypeValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."useTypeValue" AS ENUM (
    'Access',
    'Access To Off Street Premises',
    'Authorised Vehicles',
    'Customers',
    'Disabled',
    'Emergency Access',
    'Escorted Traffic',
    'Fuel Tankers',
    'Guests',
    'Guided Buses',
    'Loading and Unloading',
    'Local Buses',
    'Official Business',
    'Paying',
    'Pedestrians',
    'peermit Hodlers',
    'Public Transport',
    'Residents',
    'School Buses',
    'Service Vehicles',
    'Taxis',
    'Through Traffic',
    'Works Traffic',
    'Permit Holders'
);


ALTER TYPE "moving_traffic_lookups"."useTypeValue" OWNER TO "postgres";

--
-- TOC entry 2093 (class 1247 OID 515714)
-- Name: vehicleTypeValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."vehicleTypeValue" AS ENUM (
    'All Vehicles',
    'Articulated Vehicles',
    'Buses',
    'Coaches',
    'Emergency Vehicles',
    'Goods Vehicles',
    'Goods Vehicles Exceeding 3T',
    'Goods Vehicles Exceeding 3.5T',
    'Goods Vehicles Exceeding 5T',
    'Goods Vehicles Exceeding 7.5T',
    'Goods Vehicles Exceeding 17T',
    'Goods Vehicles Exceeding 16.5T',
    'Goods Vehicles Exceeding 17.5T',
    'Goods Vehicles Exceeding 18T',
    'Goods Vehicles Exceeding 26T',
    'Goods Vehicles Exceeding 33T',
    'Heavy Goods Vehicles',
    'Horse Drawn vehicles',
    'Large Vehicles',
    'Long Vehicles',
    'Light Goods Vehicles',
    'Mopeds',
    'Motor Cycles',
    'Motor Vehicles',
    'Motor Vehicles including Pedal Cycles',
    'Pedal Cycles',
    'Pedestrians',
    'Ridden Or Accompanied Horses',
    'Towed Caravans',
    'Tracked Vehicles',
    'Trailers',
    'Tramcars',
    'Wide Vehicles',
    'Empty Vehicles'
);


ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 460 (class 1259 OID 515783)
-- Name: AccessRestrictionValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."AccessRestrictionValues" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "moving_traffic_lookups"."AccessRestrictionValues" OWNER TO "postgres";

--
-- TOC entry 461 (class 1259 OID 515789)
-- Name: AccessRestrictionValues_Code_seq; Type: SEQUENCE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE SEQUENCE "moving_traffic_lookups"."AccessRestrictionValues_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic_lookups"."AccessRestrictionValues_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4692 (class 0 OID 0)
-- Dependencies: 461
-- Name: AccessRestrictionValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."AccessRestrictionValues_Code_seq" OWNED BY "moving_traffic_lookups"."AccessRestrictionValues"."Code";


--
-- TOC entry 501 (class 1259 OID 516435)
-- Name: CarriagewayMarkingTypes; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."CarriagewayMarkingTypes" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL,
    "Icon" character varying
);


ALTER TABLE "moving_traffic_lookups"."CarriagewayMarkingTypes" OWNER TO "postgres";

--
-- TOC entry 502 (class 1259 OID 516441)
-- Name: CarriagewayMarkingTypesInUse; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" (
    "Code" integer NOT NULL
);


ALTER TABLE "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" OWNER TO "postgres";

--
-- TOC entry 503 (class 1259 OID 516446)
-- Name: CarriagewayMarkingTypesInUse_View; Type: MATERIALIZED VIEW; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE MATERIALIZED VIEW "moving_traffic_lookups"."CarriagewayMarkingTypesInUse_View" AS
 SELECT "CarriagewayMarkingTypesInUse"."Code",
    "CarriagewayMarkingTypes"."Description"
   FROM "moving_traffic_lookups"."CarriagewayMarkingTypesInUse",
    "moving_traffic_lookups"."CarriagewayMarkingTypes"
  WHERE ("CarriagewayMarkingTypesInUse"."Code" = "CarriagewayMarkingTypes"."Code")
  WITH NO DATA;


ALTER TABLE "moving_traffic_lookups"."CarriagewayMarkingTypesInUse_View" OWNER TO "postgres";

--
-- TOC entry 504 (class 1259 OID 516454)
-- Name: CarriagewayMarkingTypes_Code_seq; Type: SEQUENCE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE SEQUENCE "moving_traffic_lookups"."CarriagewayMarkingTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic_lookups"."CarriagewayMarkingTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4697 (class 0 OID 0)
-- Dependencies: 504
-- Name: CarriagewayMarkingTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."CarriagewayMarkingTypes_Code_seq" OWNED BY "moving_traffic_lookups"."CarriagewayMarkingTypes"."Code";


--
-- TOC entry 462 (class 1259 OID 515791)
-- Name: CycleFacilityValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."CycleFacilityValues" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."CycleFacilityValues" OWNER TO "postgres";

--
-- TOC entry 463 (class 1259 OID 515794)
-- Name: CycleFacilityValues_Code_seq; Type: SEQUENCE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE SEQUENCE "moving_traffic_lookups"."CycleFacilityValues_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic_lookups"."CycleFacilityValues_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4700 (class 0 OID 0)
-- Dependencies: 463
-- Name: CycleFacilityValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."CycleFacilityValues_Code_seq" OWNED BY "moving_traffic_lookups"."CycleFacilityValues"."Code";


--
-- TOC entry 464 (class 1259 OID 515796)
-- Name: DedicationValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."DedicationValues" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."DedicationValues" OWNER TO "postgres";

--
-- TOC entry 465 (class 1259 OID 515799)
-- Name: DedicationValues_Code_seq; Type: SEQUENCE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE SEQUENCE "moving_traffic_lookups"."DedicationValues_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic_lookups"."DedicationValues_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4703 (class 0 OID 0)
-- Dependencies: 465
-- Name: DedicationValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."DedicationValues_Code_seq" OWNED BY "moving_traffic_lookups"."DedicationValues"."Code";


--
-- TOC entry 466 (class 1259 OID 515801)
-- Name: LinkDirectionValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."LinkDirectionValues" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."LinkDirectionValues" OWNER TO "postgres";

--
-- TOC entry 467 (class 1259 OID 515804)
-- Name: LinkDirectionValues_Code_seq; Type: SEQUENCE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE SEQUENCE "moving_traffic_lookups"."LinkDirectionValues_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic_lookups"."LinkDirectionValues_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4706 (class 0 OID 0)
-- Dependencies: 467
-- Name: LinkDirectionValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."LinkDirectionValues_Code_seq" OWNED BY "moving_traffic_lookups"."LinkDirectionValues"."Code";


--
-- TOC entry 468 (class 1259 OID 515806)
-- Name: RestrictionTypeValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."RestrictionTypeValues" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."RestrictionTypeValues" OWNER TO "postgres";

--
-- TOC entry 469 (class 1259 OID 515809)
-- Name: RestrictionTypeValues_Code_seq; Type: SEQUENCE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE SEQUENCE "moving_traffic_lookups"."RestrictionTypeValues_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic_lookups"."RestrictionTypeValues_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4709 (class 0 OID 0)
-- Dependencies: 469
-- Name: RestrictionTypeValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."RestrictionTypeValues_Code_seq" OWNED BY "moving_traffic_lookups"."RestrictionTypeValues"."Code";


--
-- TOC entry 470 (class 1259 OID 515811)
-- Name: SpecialDesignationTypes; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."SpecialDesignationTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "moving_traffic_lookups"."SpecialDesignationTypes" OWNER TO "postgres";

--
-- TOC entry 471 (class 1259 OID 515817)
-- Name: SpecialDesignationTypes_Code_seq; Type: SEQUENCE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE SEQUENCE "moving_traffic_lookups"."SpecialDesignationTypes_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic_lookups"."SpecialDesignationTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4712 (class 0 OID 0)
-- Dependencies: 471
-- Name: SpecialDesignationTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."SpecialDesignationTypes_Code_seq" OWNED BY "moving_traffic_lookups"."SpecialDesignationTypes"."Code";


--
-- TOC entry 472 (class 1259 OID 515819)
-- Name: SpeedLimitValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."SpeedLimitValues" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "moving_traffic_lookups"."SpeedLimitValues" OWNER TO "postgres";

--
-- TOC entry 473 (class 1259 OID 515825)
-- Name: SpeedLimitValues_Code_seq; Type: SEQUENCE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE SEQUENCE "moving_traffic_lookups"."SpeedLimitValues_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic_lookups"."SpeedLimitValues_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4715 (class 0 OID 0)
-- Dependencies: 473
-- Name: SpeedLimitValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."SpeedLimitValues_Code_seq" OWNED BY "moving_traffic_lookups"."SpeedLimitValues"."Code";


--
-- TOC entry 474 (class 1259 OID 515827)
-- Name: StructureTypeValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."StructureTypeValues" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."StructureTypeValues" OWNER TO "postgres";

--
-- TOC entry 475 (class 1259 OID 515830)
-- Name: StructureTypeValues_Code_seq; Type: SEQUENCE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE SEQUENCE "moving_traffic_lookups"."StructureTypeValues_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic_lookups"."StructureTypeValues_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4718 (class 0 OID 0)
-- Dependencies: 475
-- Name: StructureTypeValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."StructureTypeValues_Code_seq" OWNED BY "moving_traffic_lookups"."StructureTypeValues"."Code";


--
-- TOC entry 476 (class 1259 OID 515832)
-- Name: TurnRestrictionValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."TurnRestrictionValues" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."TurnRestrictionValues" OWNER TO "postgres";

--
-- TOC entry 477 (class 1259 OID 515835)
-- Name: TurnRestrictionValues_Code_seq; Type: SEQUENCE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE SEQUENCE "moving_traffic_lookups"."TurnRestrictionValues_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic_lookups"."TurnRestrictionValues_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4721 (class 0 OID 0)
-- Dependencies: 477
-- Name: TurnRestrictionValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."TurnRestrictionValues_Code_seq" OWNED BY "moving_traffic_lookups"."TurnRestrictionValues"."Code";


--
-- TOC entry 478 (class 1259 OID 515837)
-- Name: VehicleQualifiers; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."VehicleQualifiers" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."VehicleQualifiers" OWNER TO "postgres";

--
-- TOC entry 479 (class 1259 OID 515840)
-- Name: VehicleQualifiers_Code_seq; Type: SEQUENCE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE SEQUENCE "moving_traffic_lookups"."VehicleQualifiers_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic_lookups"."VehicleQualifiers_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4724 (class 0 OID 0)
-- Dependencies: 479
-- Name: VehicleQualifiers_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."VehicleQualifiers_Code_seq" OWNED BY "moving_traffic_lookups"."VehicleQualifiers"."Code";


--
-- TOC entry 480 (class 1259 OID 515842)
-- Name: vehicleQualifiers; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."vehicleQualifiers" (
    "Code" integer NOT NULL,
    "Description" character varying(255) NOT NULL,
    "vehicle" "moving_traffic_lookups"."vehicleTypeValue"[],
    "use" "moving_traffic_lookups"."useTypeValue"[],
    "load" "moving_traffic_lookups"."loadTypeValue"[]
);


ALTER TABLE "moving_traffic_lookups"."vehicleQualifiers" OWNER TO "postgres";

--
-- TOC entry 481 (class 1259 OID 515848)
-- Name: vehicleQualifiers_Code_seq; Type: SEQUENCE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE SEQUENCE "moving_traffic_lookups"."vehicleQualifiers_Code_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic_lookups"."vehicleQualifiers_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4727 (class 0 OID 0)
-- Dependencies: 481
-- Name: vehicleQualifiers_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."vehicleQualifiers_Code_seq" OWNED BY "moving_traffic_lookups"."vehicleQualifiers"."Code";


--
-- TOC entry 4497 (class 2604 OID 516524)
-- Name: CarriagewayMarkingTypes Code; Type: DEFAULT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."CarriagewayMarkingTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"moving_traffic_lookups"."CarriagewayMarkingTypes_Code_seq"'::"regclass");


--
-- TOC entry 4495 (class 2604 OID 515850)
-- Name: SpecialDesignationTypes Code; Type: DEFAULT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpecialDesignationTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"moving_traffic_lookups"."SpecialDesignationTypes_Code_seq"'::"regclass");


--
-- TOC entry 4496 (class 2604 OID 515851)
-- Name: vehicleQualifiers Code; Type: DEFAULT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."vehicleQualifiers" ALTER COLUMN "Code" SET DEFAULT "nextval"('"moving_traffic_lookups"."vehicleQualifiers_Code_seq"'::"regclass");


--
-- TOC entry 4499 (class 2606 OID 515853)
-- Name: AccessRestrictionValues AccessRestrictionValue_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."AccessRestrictionValues"
    ADD CONSTRAINT "AccessRestrictionValue_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4501 (class 2606 OID 515855)
-- Name: AccessRestrictionValues AccessRestrictionValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."AccessRestrictionValues"
    ADD CONSTRAINT "AccessRestrictionValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4543 (class 2606 OID 516523)
-- Name: CarriagewayMarkingTypes CarriagewayMarkingTypes_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."CarriagewayMarkingTypes"
    ADD CONSTRAINT "CarriagewayMarkingTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4503 (class 2606 OID 515857)
-- Name: CycleFacilityValues CycleFacilityValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."CycleFacilityValues"
    ADD CONSTRAINT "CycleFacilityValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4505 (class 2606 OID 515859)
-- Name: CycleFacilityValues CycleFacilityValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."CycleFacilityValues"
    ADD CONSTRAINT "CycleFacilityValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4507 (class 2606 OID 515861)
-- Name: DedicationValues DedicationValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."DedicationValues"
    ADD CONSTRAINT "DedicationValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4509 (class 2606 OID 515863)
-- Name: DedicationValues DedicationValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."DedicationValues"
    ADD CONSTRAINT "DedicationValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4511 (class 2606 OID 515865)
-- Name: LinkDirectionValues LinkDirectionValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."LinkDirectionValues"
    ADD CONSTRAINT "LinkDirectionValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4513 (class 2606 OID 515867)
-- Name: LinkDirectionValues LinkDirectionValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."LinkDirectionValues"
    ADD CONSTRAINT "LinkDirectionValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4515 (class 2606 OID 515869)
-- Name: RestrictionTypeValues RestrictionTypeValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."RestrictionTypeValues"
    ADD CONSTRAINT "RestrictionTypeValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4517 (class 2606 OID 515871)
-- Name: RestrictionTypeValues RestrictionTypeValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."RestrictionTypeValues"
    ADD CONSTRAINT "RestrictionTypeValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4545 (class 2606 OID 516445)
-- Name: CarriagewayMarkingTypesInUse SignTypesInUse_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."CarriagewayMarkingTypesInUse"
    ADD CONSTRAINT "SignTypesInUse_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4519 (class 2606 OID 515873)
-- Name: SpecialDesignationTypes SpecialDesignationTypes_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpecialDesignationTypes"
    ADD CONSTRAINT "SpecialDesignationTypes_Description_key" UNIQUE ("Description");


--
-- TOC entry 4521 (class 2606 OID 515875)
-- Name: SpecialDesignationTypes SpecialDesignationTypes_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpecialDesignationTypes"
    ADD CONSTRAINT "SpecialDesignationTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4523 (class 2606 OID 515877)
-- Name: SpeedLimitValues SpeedLimitValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpeedLimitValues"
    ADD CONSTRAINT "SpeedLimitValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4525 (class 2606 OID 515879)
-- Name: SpeedLimitValues SpeedLimitValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpeedLimitValues"
    ADD CONSTRAINT "SpeedLimitValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4527 (class 2606 OID 515881)
-- Name: StructureTypeValues StructureTypeValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."StructureTypeValues"
    ADD CONSTRAINT "StructureTypeValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4529 (class 2606 OID 515883)
-- Name: StructureTypeValues StructureTypeValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."StructureTypeValues"
    ADD CONSTRAINT "StructureTypeValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4531 (class 2606 OID 515885)
-- Name: TurnRestrictionValues TurnRestrictionValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."TurnRestrictionValues"
    ADD CONSTRAINT "TurnRestrictionValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4533 (class 2606 OID 515887)
-- Name: TurnRestrictionValues TurnRestrictionValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."TurnRestrictionValues"
    ADD CONSTRAINT "TurnRestrictionValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4535 (class 2606 OID 515889)
-- Name: VehicleQualifiers VehicleQualifiers_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."VehicleQualifiers"
    ADD CONSTRAINT "VehicleQualifiers_Description_key" UNIQUE ("Description");


--
-- TOC entry 4537 (class 2606 OID 515891)
-- Name: VehicleQualifiers VehicleQualifiers_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."VehicleQualifiers"
    ADD CONSTRAINT "VehicleQualifiers_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4539 (class 2606 OID 515893)
-- Name: vehicleQualifiers vehicleQualifiers_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."vehicleQualifiers"
    ADD CONSTRAINT "vehicleQualifiers_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4541 (class 2606 OID 515895)
-- Name: vehicleQualifiers vehicleQualifiers_vehicle_use_load_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."vehicleQualifiers"
    ADD CONSTRAINT "vehicleQualifiers_vehicle_use_load_key" UNIQUE ("vehicle", "use", "load");


--
-- TOC entry 4546 (class 1259 OID 516453)
-- Name: CarriagewayMarkingTypesInUse_View_View_key; Type: INDEX; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE UNIQUE INDEX "CarriagewayMarkingTypesInUse_View_View_key" ON "moving_traffic_lookups"."CarriagewayMarkingTypesInUse_View" USING "btree" ("Code");

--
-- TOC entry 22 (class 2615 OID 515904)
-- Name: moving_traffic; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "moving_traffic";


ALTER SCHEMA "moving_traffic" OWNER TO "postgres";

--
-- TOC entry 484 (class 1259 OID 515905)
-- Name: AccessRestrictions_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."AccessRestrictions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."AccessRestrictions_id_seq" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 485 (class 1259 OID 515907)
-- Name: Restrictions; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."Restrictions" (
    "RestrictionID" "uuid" NOT NULL,
    "GeometryID" character varying(12) NOT NULL,
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
    "ComplianceRoadMarkingsFaded" integer,
    "ComplianceRestrictionSignIssue" integer,
    "ComplianceNotes" character varying(254),
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254)
);


ALTER TABLE "moving_traffic"."Restrictions" OWNER TO "postgres";

--
-- TOC entry 487 (class 1259 OID 515932)
-- Name: AccessRestrictions; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."AccessRestrictions" (
    "GeometryID" character varying(12) DEFAULT ('A_'::"text" || "to_char"("nextval"('"moving_traffic"."AccessRestrictions_id_seq"'::"regclass"), '000000000'::"text")),
    "restriction" "moving_traffic_lookups"."accessRestrictionValue" NOT NULL,
    "timeInterval" integer,
    "trafficSigns" character varying(255),
    "exemption" integer,
    "inclusion" integer,
    "mt_capture_geom" "public"."geometry"(Point,27700)
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."AccessRestrictions" OWNER TO "postgres";

--
-- TOC entry 507 (class 1259 OID 516613)
-- Name: CarriagewayMarkings; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."CarriagewayMarkings" (
    "CarriagewayMarkingType_1" integer NOT NULL,
    "CarriagewayMarkingType_2" integer,
    "CarriagewayMarkingType_3" integer,
    "CarriagewayMarkingType_4" integer,
    "geom" "public"."geometry"(Point,27700)
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."CarriagewayMarkings" OWNER TO "postgres";

--
-- TOC entry 505 (class 1259 OID 516456)
-- Name: CarriagewayMarkings_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."CarriagewayMarkings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."CarriagewayMarkings_id_seq" OWNER TO "postgres";

--
-- TOC entry 488 (class 1259 OID 515939)
-- Name: HighwayDedications_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."HighwayDedications_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."HighwayDedications_id_seq" OWNER TO "postgres";

--
-- TOC entry 489 (class 1259 OID 515941)
-- Name: HighwayDedications; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."HighwayDedications" (
    "GeometryID" character varying(12) DEFAULT ('H_'::"text" || "to_char"("nextval"('"moving_traffic"."HighwayDedications_id_seq"'::"regclass"), '000000000'::"text")),
    "dedication" "moving_traffic_lookups"."dedicationValue" NOT NULL,
    "timeInterval" integer,
    "mt_capture_geom" "public"."geometry"(LineString,27700)
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."HighwayDedications" OWNER TO "postgres";

--
-- TOC entry 486 (class 1259 OID 515929)
-- Name: NetworkReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."NetworkReference" (
    "NetworkReferenceID" "uuid" NOT NULL
);


ALTER TABLE "moving_traffic"."NetworkReference" OWNER TO "postgres";

--
-- TOC entry 490 (class 1259 OID 515948)
-- Name: LinkReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."LinkReference" (
    "applicableDirection" "moving_traffic_lookups"."linkDirectionValue" NOT NULL,
    "linkReference" character varying(20) NOT NULL,
    "linkOrder" integer NOT NULL
)
INHERITS ("moving_traffic"."NetworkReference");


ALTER TABLE "moving_traffic"."LinkReference" OWNER TO "postgres";

--
-- TOC entry 491 (class 1259 OID 515951)
-- Name: SimpleLinearReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."SimpleLinearReference" (
    "fromPosition" double precision,
    "toPosition" double precision,
    "offset" double precision
)
INHERITS ("moving_traffic"."LinkReference");


ALTER TABLE "moving_traffic"."SimpleLinearReference" OWNER TO "postgres";

--
-- TOC entry 492 (class 1259 OID 515954)
-- Name: LinearReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."LinearReference" (
    "fromPositionGeometry" "public"."geometry"(Point,27700),
    "toPositionGeometry" "public"."geometry"(Point,27700)
)
INHERITS ("moving_traffic"."SimpleLinearReference");


ALTER TABLE "moving_traffic"."LinearReference" OWNER TO "postgres";

--
-- TOC entry 493 (class 1259 OID 515960)
-- Name: NodeReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."NodeReference" (
    "nodeReference" character varying(20) NOT NULL
)
INHERITS ("moving_traffic"."NetworkReference");


ALTER TABLE "moving_traffic"."NodeReference" OWNER TO "postgres";

--
-- TOC entry 494 (class 1259 OID 515963)
-- Name: SimplePointReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."SimplePointReference" (
    "atPosition" double precision NOT NULL,
    "offset" double precision
)
INHERITS ("moving_traffic"."LinkReference");


ALTER TABLE "moving_traffic"."SimplePointReference" OWNER TO "postgres";

--
-- TOC entry 495 (class 1259 OID 515966)
-- Name: PointReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."PointReference" (
    "atPositionGeometry" "public"."geometry"(Point,27700) NOT NULL
)
INHERITS ("moving_traffic"."SimplePointReference");


ALTER TABLE "moving_traffic"."PointReference" OWNER TO "postgres";

--
-- TOC entry 496 (class 1259 OID 515972)
-- Name: RestrictionsForVehicles_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."RestrictionsForVehicles_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."RestrictionsForVehicles_id_seq" OWNER TO "postgres";

--
-- TOC entry 497 (class 1259 OID 515974)
-- Name: RestrictionsForVehicles; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."RestrictionsForVehicles" (
    "GeometryID" character varying(12) DEFAULT ('R_'::"text" || "to_char"("nextval"('"moving_traffic"."RestrictionsForVehicles_id_seq"'::"regclass"), '000000000'::"text")),
    "restrictionType" "moving_traffic_lookups"."restrictionTypeValue" NOT NULL,
    "measure" double precision NOT NULL,
    "measure2" double precision,
    "inclusion" integer,
    "exemption" integer,
    "structure" "moving_traffic_lookups"."structureTypeValue",
    "mt_capture_geom" "public"."geometry"(Point,27700)
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."RestrictionsForVehicles" OWNER TO "postgres";

--
-- TOC entry 498 (class 1259 OID 515981)
-- Name: SpecialDesignations_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."SpecialDesignations_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."SpecialDesignations_id_seq" OWNER TO "postgres";

--
-- TOC entry 499 (class 1259 OID 515983)
-- Name: SpecialDesignations; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."SpecialDesignations" (
    "GeometryID" character varying(12) DEFAULT ('D_'::"text" || "to_char"("nextval"('"moving_traffic"."SpecialDesignations_id_seq"'::"regclass"), '000000000'::"text")),
    "designation" "moving_traffic_lookups"."specialDesignationTypeValue" NOT NULL,
    "timeInterval" integer,
    "lane" integer,
    "cycleFacility" "moving_traffic_lookups"."cycleFacilityValue",
    "mt_capture_geom" "public"."geometry"(LineString,27700)
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."SpecialDesignations" OWNER TO "postgres";

--
-- TOC entry 500 (class 1259 OID 515990)
-- Name: TurnRestrictions_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."TurnRestrictions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."TurnRestrictions_id_seq" OWNER TO "postgres";

--
-- TOC entry 506 (class 1259 OID 516552)
-- Name: TurnRestrictions; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."TurnRestrictions" (
    "GeometryID" character varying(12) DEFAULT ('V_'::"text" || "to_char"("nextval"('"moving_traffic"."TurnRestrictions_id_seq"'::"regclass"), '000000000'::"text")),
    "restrictionType" "moving_traffic_lookups"."turnRestrictionValue" NOT NULL,
    "inclusion" integer,
    "exemption" integer,
    "timeInterval" integer,
    "mt_capture_geom" "public"."geometry"(LineString,27700)
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."TurnRestrictions" OWNER TO "postgres";

--
-- TOC entry 4494 (class 2606 OID 516000)
-- Name: AccessRestrictions AccessRestrictions_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4516 (class 2606 OID 516620)
-- Name: CarriagewayMarkings CarriagewayMarkings_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4496 (class 2606 OID 516002)
-- Name: HighwayDedications HighwayDedications_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "HighwayDedications_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4504 (class 2606 OID 516004)
-- Name: LinearReference LinearReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."LinearReference"
    ADD CONSTRAINT "LinearReference_pkey" PRIMARY KEY ("NetworkReferenceID") INCLUDE ("linkReference");


--
-- TOC entry 4498 (class 2606 OID 516006)
-- Name: LinkReference LinkReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."LinkReference"
    ADD CONSTRAINT "LinkReference_pkey" PRIMARY KEY ("NetworkReferenceID", "linkReference", "linkOrder");


--
-- TOC entry 4492 (class 2606 OID 516008)
-- Name: NetworkReference NetworkReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."NetworkReference"
    ADD CONSTRAINT "NetworkReference_pkey" PRIMARY KEY ("NetworkReferenceID");


--
-- TOC entry 4508 (class 2606 OID 516010)
-- Name: PointReference PointReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."PointReference"
    ADD CONSTRAINT "PointReference_pkey" PRIMARY KEY ("NetworkReferenceID") INCLUDE ("linkReference");


--
-- TOC entry 4510 (class 2606 OID 516012)
-- Name: RestrictionsForVehicles RestrictionForVehicles_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4490 (class 2606 OID 516014)
-- Name: Restrictions Restrictions_GeometryID_key; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."Restrictions"
    ADD CONSTRAINT "Restrictions_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4500 (class 2606 OID 516016)
-- Name: SimpleLinearReference SimpleLinearReference_NetworkReferenceID_linkReference_key; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SimpleLinearReference"
    ADD CONSTRAINT "SimpleLinearReference_NetworkReferenceID_linkReference_key" UNIQUE ("NetworkReferenceID", "linkReference");


--
-- TOC entry 4502 (class 2606 OID 516018)
-- Name: SimpleLinearReference SimpleLinearReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SimpleLinearReference"
    ADD CONSTRAINT "SimpleLinearReference_pkey" PRIMARY KEY ("NetworkReferenceID") INCLUDE ("linkReference");


--
-- TOC entry 4506 (class 2606 OID 516020)
-- Name: SimplePointReference SimplePointReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SimplePointReference"
    ADD CONSTRAINT "SimplePointReference_pkey" PRIMARY KEY ("NetworkReferenceID") INCLUDE ("linkReference");


--
-- TOC entry 4512 (class 2606 OID 516022)
-- Name: SpecialDesignations SpecialDesignations_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4514 (class 2606 OID 516560)
-- Name: TurnRestrictions TurnRestrictions_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4538 (class 2620 OID 516025)
-- Name: AccessRestrictions create_geometryid_access_restrictions; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_access_restrictions" BEFORE INSERT ON "moving_traffic"."AccessRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4548 (class 2620 OID 516646)
-- Name: CarriagewayMarkings create_geometryid_carriageway_markings; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_carriageway_markings" BEFORE INSERT ON "moving_traffic"."CarriagewayMarkings" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4540 (class 2620 OID 516026)
-- Name: HighwayDedications create_geometryid_highway_dedications; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_highway_dedications" BEFORE INSERT ON "moving_traffic"."HighwayDedications" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4542 (class 2620 OID 516027)
-- Name: RestrictionsForVehicles create_geometryid_restrictions_for_vehicles; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_restrictions_for_vehicles" BEFORE INSERT ON "moving_traffic"."RestrictionsForVehicles" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4544 (class 2620 OID 516028)
-- Name: SpecialDesignations create_geometryid_special_designations; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_special_designations" BEFORE INSERT ON "moving_traffic"."SpecialDesignations" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4546 (class 2620 OID 516561)
-- Name: TurnRestrictions create_geometryid_turn_restrictions; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_turn_restrictions" BEFORE INSERT ON "moving_traffic"."TurnRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4539 (class 2620 OID 516544)
-- Name: AccessRestrictions set_last_update_details_access_restrictions; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_access_restrictions" BEFORE INSERT OR UPDATE ON "moving_traffic"."AccessRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4549 (class 2620 OID 516647)
-- Name: CarriagewayMarkings set_last_update_details_carriageway_markings; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_carriageway_markings" BEFORE INSERT OR UPDATE ON "moving_traffic"."CarriagewayMarkings" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4541 (class 2620 OID 516543)
-- Name: HighwayDedications set_last_update_details_highway_dedications; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_highway_dedications" BEFORE INSERT OR UPDATE ON "moving_traffic"."HighwayDedications" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4543 (class 2620 OID 516542)
-- Name: RestrictionsForVehicles set_last_update_details_restrictions_for_vehicles; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_restrictions_for_vehicles" BEFORE INSERT OR UPDATE ON "moving_traffic"."RestrictionsForVehicles" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4545 (class 2620 OID 516541)
-- Name: SpecialDesignations set_last_update_details_special_designations; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_special_designations" BEFORE INSERT OR UPDATE ON "moving_traffic"."SpecialDesignations" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4547 (class 2620 OID 516562)
-- Name: TurnRestrictions set_last_update_details_turn_restrictions; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_turn_restrictions" BEFORE INSERT OR UPDATE ON "moving_traffic"."TurnRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4520 (class 2606 OID 516030)
-- Name: AccessRestrictions AccessRestrictions_exemption_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_exemption_fkey" FOREIGN KEY ("exemption") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4521 (class 2606 OID 516035)
-- Name: AccessRestrictions AccessRestrictions_inclusion_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_inclusion_fkey" FOREIGN KEY ("inclusion") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4522 (class 2606 OID 516040)
-- Name: AccessRestrictions AccessRestrictions_timeInterval_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_timeInterval_fkey" FOREIGN KEY ("timeInterval") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4533 (class 2606 OID 516621)
-- Name: CarriagewayMarkings CarriagewayMarkings_CarriagewayMarkingTypes2_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_CarriagewayMarkingTypes2_fkey" FOREIGN KEY ("CarriagewayMarkingType_2") REFERENCES "moving_traffic_lookups"."CarriagewayMarkingTypesInUse"("Code");


--
-- TOC entry 4534 (class 2606 OID 516626)
-- Name: CarriagewayMarkings CarriagewayMarkings_CarriagewayMarkingTypes3_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_CarriagewayMarkingTypes3_fkey" FOREIGN KEY ("CarriagewayMarkingType_3") REFERENCES "moving_traffic_lookups"."CarriagewayMarkingTypesInUse"("Code");


--
-- TOC entry 4535 (class 2606 OID 516631)
-- Name: CarriagewayMarkings CarriagewayMarkings_CarriagewayMarkingTypes4_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_CarriagewayMarkingTypes4_fkey" FOREIGN KEY ("CarriagewayMarkingType_4") REFERENCES "moving_traffic_lookups"."CarriagewayMarkingTypesInUse"("Code");


--
-- TOC entry 4536 (class 2606 OID 516636)
-- Name: CarriagewayMarkings CarriagewayMarkings_CarriagewayMarkingsTypes1_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_CarriagewayMarkingsTypes1_fkey" FOREIGN KEY ("CarriagewayMarkingType_1") REFERENCES "moving_traffic_lookups"."CarriagewayMarkingTypesInUse"("Code");


--
-- TOC entry 4537 (class 2606 OID 516641)
-- Name: CarriagewayMarkings CarriagewayMarkings_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4523 (class 2606 OID 516045)
-- Name: HighwayDedications HighwayDedications_timeInterval_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "HighwayDedications_timeInterval_fkey" FOREIGN KEY ("timeInterval") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4526 (class 2606 OID 516050)
-- Name: PointReference PointReference_linkReference_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."PointReference"
    ADD CONSTRAINT "PointReference_linkReference_fkey" FOREIGN KEY ("linkReference") REFERENCES "highways_network"."itn_roadcentreline"("toid");


--
-- TOC entry 4527 (class 2606 OID 516055)
-- Name: RestrictionsForVehicles RestrictionForVehicles_exemption_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_exemption_fkey" FOREIGN KEY ("exemption") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4528 (class 2606 OID 516060)
-- Name: RestrictionsForVehicles RestrictionForVehicles_inclusion_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_inclusion_fkey" FOREIGN KEY ("inclusion") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4517 (class 2606 OID 515914)
-- Name: Restrictions Restrictions_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."Restrictions"
    ADD CONSTRAINT "Restrictions_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4518 (class 2606 OID 515919)
-- Name: Restrictions Restrictions_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."Restrictions"
    ADD CONSTRAINT "Restrictions_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4519 (class 2606 OID 515924)
-- Name: Restrictions Restrictions_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."Restrictions"
    ADD CONSTRAINT "Restrictions_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4529 (class 2606 OID 516065)
-- Name: SpecialDesignations SpecialDesignations_timeInterval_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_timeInterval_fkey" FOREIGN KEY ("timeInterval") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4530 (class 2606 OID 516563)
-- Name: TurnRestrictions TurnRestrictions_exemption_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_exemption_fkey" FOREIGN KEY ("exemption") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4531 (class 2606 OID 516568)
-- Name: TurnRestrictions TurnRestrictions_inclusion_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_inclusion_fkey" FOREIGN KEY ("inclusion") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4532 (class 2606 OID 516573)
-- Name: TurnRestrictions TurnRestrictions_timeInterval_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_timeInterval_fkey" FOREIGN KEY ("timeInterval") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4524 (class 2606 OID 516085)
-- Name: LinkReference fk_link; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."LinkReference"
    ADD CONSTRAINT "fk_link" FOREIGN KEY ("linkReference") REFERENCES "highways_network"."itn_roadcentreline"("toid");


--
-- TOC entry 4525 (class 2606 OID 516090)
-- Name: NodeReference fk_node; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."NodeReference"
    ADD CONSTRAINT "fk_node" FOREIGN KEY ("nodeReference") REFERENCES "highways_network"."itn_roadcentreline"("toid");

-- Completed on 2020-08-06 08:00:37

--
-- PostgreSQL database dump complete
--

--
-- TOC entry 4169 (class 0 OID 0)
-- Dependencies: 354
-- Name: MHTC_RoadLinks_id_seq; Type: SEQUENCE OWNED BY; Schema: highways_network; Owner: postgres
--

CREATE SEQUENCE "highways_network"."MHTC_RoadLinks_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highways_network"."MHTC_RoadLinks_id_seq" OWNER TO "postgres";

--
-- TOC entry 355 (class 1259 OID 371810)
-- Name: MHTC_RoadLinks; Type: TABLE; Schema: highways_network; Owner: postgres
--

CREATE TABLE "highways_network"."MHTC_RoadLinks"
(
    notes character varying(255) COLLATE pg_catalog."default",
    geom geometry(LineString,27700) NOT NULL,
    "GeometryID" character varying(12) DEFAULT ('L_'::"text" || "to_char"("nextval"('"highways_network"."MHTC_RoadLinks_id_seq"'::"regclass"), '000000000'::"text"))
	)
INHERITS ("moving_traffic"."Restrictions");

ALTER TABLE ONLY "highways_network"."MHTC_RoadLinks"
    ADD CONSTRAINT "MHTC_RoadLinks_pkey" PRIMARY KEY ("RestrictionID");

ALTER TABLE "highways_network"."MHTC_RoadLinks" OWNER TO "postgres";

--ALTER SEQUENCE "highways_network"."MHTC_RoadLinks_id_seq" OWNED BY "highways_network"."MHTC_RoadLinks"."id";
--
-- TOC entry 354 (class 1259 OID 371808)
-- Name: MHTC_RoadLinks_id_seq; Type: SEQUENCE; Schema: highways_network; Owner: postgres
--

CREATE TRIGGER "create_geometryid_mhtc_RoadLinks" BEFORE INSERT ON "highways_network"."MHTC_RoadLinks" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();

CREATE TRIGGER "set_last_update_details_mhtc_RoadLinks" BEFORE INSERT OR UPDATE ON "highways_network"."MHTC_RoadLinks" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();

