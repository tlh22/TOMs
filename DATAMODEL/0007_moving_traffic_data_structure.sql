--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-07-03 20:12:48

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
-- SELECT pg_catalog.set_config('search_path', '', false);
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

CREATE FUNCTION public.create_geometryid2()
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
	ELSE
	    nextSeqVal = 'U';
	END CASE;

    NEW."GeometryID" := nextSeqVal;
	RETURN NEW;

END;
$BODY$;

ALTER FUNCTION public.create_geometryid2()
    OWNER TO postgres;


--
-- TOC entry 15 (class 2615 OID 350398)
-- Name: moving_traffic_lookups; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "moving_traffic_lookups";


ALTER SCHEMA "moving_traffic_lookups" OWNER TO "postgres";

--
-- TOC entry 1804 (class 1247 OID 352558)
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
-- TOC entry 1810 (class 1247 OID 352572)
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
-- TOC entry 1835 (class 1247 OID 367039)
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
-- TOC entry 1807 (class 1247 OID 352550)
-- Name: linkDirectionValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."linkDirectionValue" AS ENUM (
    'bothDirections',
    'inDirection',
    'inOppositeDirection'
);


ALTER TYPE "moving_traffic_lookups"."linkDirectionValue" OWNER TO "postgres";

--
-- TOC entry 1801 (class 1247 OID 352390)
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
-- TOC entry 1820 (class 1247 OID 366861)
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
-- TOC entry 1844 (class 1247 OID 367162)
-- Name: specialDesignationTypeValue; Type: TYPE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TYPE "moving_traffic_lookups"."specialDesignationTypeValue" AS ENUM (
    'Bus Lane',
    'Cycle Lane',
    'Signal controlled cycle crossing'
);


ALTER TYPE "moving_traffic_lookups"."specialDesignationTypeValue" OWNER TO "postgres";

--
-- TOC entry 1823 (class 1247 OID 366876)
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
-- TOC entry 1829 (class 1247 OID 366986)
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
-- TOC entry 1798 (class 1247 OID 352402)
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
    'Works Traffic'
);


ALTER TYPE "moving_traffic_lookups"."useTypeValue" OWNER TO "postgres";

--
-- TOC entry 1813 (class 1247 OID 352450)
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
-- TOC entry 325 (class 1259 OID 350401)
-- Name: AccessRestrictionValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."AccessRestrictionValues" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);


ALTER TABLE "moving_traffic_lookups"."AccessRestrictionValues" OWNER TO "postgres";

--
-- TOC entry 336 (class 1259 OID 350568)
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
-- TOC entry 4227 (class 0 OID 0)
-- Dependencies: 336
-- Name: AccessRestrictionValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."AccessRestrictionValues_Code_seq" OWNED BY "moving_traffic_lookups"."AccessRestrictionValues"."Code";


--
-- TOC entry 326 (class 1259 OID 350414)
-- Name: CycleFacilityValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."CycleFacilityValues" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."CycleFacilityValues" OWNER TO "postgres";

--
-- TOC entry 337 (class 1259 OID 350570)
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
-- TOC entry 4228 (class 0 OID 0)
-- Dependencies: 337
-- Name: CycleFacilityValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."CycleFacilityValues_Code_seq" OWNED BY "moving_traffic_lookups"."CycleFacilityValues"."Code";


--
-- TOC entry 327 (class 1259 OID 350422)
-- Name: DedicationValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."DedicationValues" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."DedicationValues" OWNER TO "postgres";

--
-- TOC entry 338 (class 1259 OID 350572)
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
-- TOC entry 4229 (class 0 OID 0)
-- Dependencies: 338
-- Name: DedicationValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."DedicationValues_Code_seq" OWNED BY "moving_traffic_lookups"."DedicationValues"."Code";


--
-- TOC entry 328 (class 1259 OID 350430)
-- Name: LinkDirectionValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."LinkDirectionValues" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."LinkDirectionValues" OWNER TO "postgres";

--
-- TOC entry 339 (class 1259 OID 350574)
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
-- TOC entry 4230 (class 0 OID 0)
-- Dependencies: 339
-- Name: LinkDirectionValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."LinkDirectionValues_Code_seq" OWNED BY "moving_traffic_lookups"."LinkDirectionValues"."Code";


--
-- TOC entry 329 (class 1259 OID 350438)
-- Name: RestrictionTypeValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."RestrictionTypeValues" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."RestrictionTypeValues" OWNER TO "postgres";

--
-- TOC entry 340 (class 1259 OID 350576)
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
-- TOC entry 4231 (class 0 OID 0)
-- Dependencies: 340
-- Name: RestrictionTypeValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."RestrictionTypeValues_Code_seq" OWNED BY "moving_traffic_lookups"."RestrictionTypeValues"."Code";


--
-- TOC entry 331 (class 1259 OID 350470)
-- Name: SpecialDesignationTypes; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."SpecialDesignationTypes" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "moving_traffic_lookups"."SpecialDesignationTypes" OWNER TO "postgres";

--
-- TOC entry 330 (class 1259 OID 350468)
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
-- TOC entry 4232 (class 0 OID 0)
-- Dependencies: 330
-- Name: SpecialDesignationTypes_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."SpecialDesignationTypes_Code_seq" OWNED BY "moving_traffic_lookups"."SpecialDesignationTypes"."Code";


--
-- TOC entry 332 (class 1259 OID 350476)
-- Name: SpeedLimitValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."SpeedLimitValues" (
    "Code" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "moving_traffic_lookups"."SpeedLimitValues" OWNER TO "postgres";

--
-- TOC entry 341 (class 1259 OID 350578)
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
-- TOC entry 4233 (class 0 OID 0)
-- Dependencies: 341
-- Name: SpeedLimitValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."SpeedLimitValues_Code_seq" OWNED BY "moving_traffic_lookups"."SpeedLimitValues"."Code";


--
-- TOC entry 333 (class 1259 OID 350486)
-- Name: StructureTypeValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."StructureTypeValues" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."StructureTypeValues" OWNER TO "postgres";

--
-- TOC entry 342 (class 1259 OID 350580)
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
-- TOC entry 4234 (class 0 OID 0)
-- Dependencies: 342
-- Name: StructureTypeValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."StructureTypeValues_Code_seq" OWNED BY "moving_traffic_lookups"."StructureTypeValues"."Code";


--
-- TOC entry 334 (class 1259 OID 350494)
-- Name: TurnRestrictionValues; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."TurnRestrictionValues" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."TurnRestrictionValues" OWNER TO "postgres";

--
-- TOC entry 343 (class 1259 OID 350582)
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
-- TOC entry 4235 (class 0 OID 0)
-- Dependencies: 343
-- Name: TurnRestrictionValues_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."TurnRestrictionValues_Code_seq" OWNED BY "moving_traffic_lookups"."TurnRestrictionValues"."Code";


--
-- TOC entry 335 (class 1259 OID 350502)
-- Name: VehicleQualifiers; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."VehicleQualifiers" (
    "Code" integer NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "moving_traffic_lookups"."VehicleQualifiers" OWNER TO "postgres";

--
-- TOC entry 344 (class 1259 OID 350584)
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
-- TOC entry 4236 (class 0 OID 0)
-- Dependencies: 344
-- Name: VehicleQualifiers_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."VehicleQualifiers_Code_seq" OWNED BY "moving_traffic_lookups"."VehicleQualifiers"."Code";


--
-- TOC entry 345 (class 1259 OID 352519)
-- Name: vehicleQualifiers; Type: TABLE; Schema: moving_traffic_lookups; Owner: postgres
--

CREATE TABLE "moving_traffic_lookups"."vehicleQualifiers" (
    "Code" integer NOT NULL,
    "Description" character varying(255),
    "vehicle" "moving_traffic_lookups"."vehicleTypeValue"[],
    "use" "moving_traffic_lookups"."useTypeValue"[],
    "load" "moving_traffic_lookups"."loadTypeValue"[]
);


ALTER TABLE "moving_traffic_lookups"."vehicleQualifiers" OWNER TO "postgres";

--
-- TOC entry 346 (class 1259 OID 352525)
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
-- TOC entry 4237 (class 0 OID 0)
-- Dependencies: 346
-- Name: vehicleQualifiers_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."vehicleQualifiers_Code_seq" OWNED BY "moving_traffic_lookups"."vehicleQualifiers"."Code";


--
-- TOC entry 4040 (class 2604 OID 350473)
-- Name: SpecialDesignationTypes Code; Type: DEFAULT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpecialDesignationTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"moving_traffic_lookups"."SpecialDesignationTypes_Code_seq"'::"regclass");


--
-- TOC entry 4041 (class 2604 OID 352527)
-- Name: vehicleQualifiers Code; Type: DEFAULT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."vehicleQualifiers" ALTER COLUMN "Code" SET DEFAULT "nextval"('"moving_traffic_lookups"."vehicleQualifiers_Code_seq"'::"regclass");


--
-- TOC entry 4043 (class 2606 OID 350548)
-- Name: AccessRestrictionValues AccessRestrictionValue_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."AccessRestrictionValues"
    ADD CONSTRAINT "AccessRestrictionValue_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4045 (class 2606 OID 350525)
-- Name: AccessRestrictionValues AccessRestrictionValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."AccessRestrictionValues"
    ADD CONSTRAINT "AccessRestrictionValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4047 (class 2606 OID 350527)
-- Name: CycleFacilityValues CycleFacilityValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."CycleFacilityValues"
    ADD CONSTRAINT "CycleFacilityValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4049 (class 2606 OID 350509)
-- Name: CycleFacilityValues CycleFacilityValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."CycleFacilityValues"
    ADD CONSTRAINT "CycleFacilityValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4051 (class 2606 OID 350529)
-- Name: DedicationValues DedicationValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."DedicationValues"
    ADD CONSTRAINT "DedicationValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4053 (class 2606 OID 350511)
-- Name: DedicationValues DedicationValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."DedicationValues"
    ADD CONSTRAINT "DedicationValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4055 (class 2606 OID 350531)
-- Name: LinkDirectionValues LinkDirectionValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."LinkDirectionValues"
    ADD CONSTRAINT "LinkDirectionValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4057 (class 2606 OID 350513)
-- Name: LinkDirectionValues LinkDirectionValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."LinkDirectionValues"
    ADD CONSTRAINT "LinkDirectionValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4059 (class 2606 OID 350533)
-- Name: RestrictionTypeValues RestrictionTypeValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."RestrictionTypeValues"
    ADD CONSTRAINT "RestrictionTypeValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4061 (class 2606 OID 350515)
-- Name: RestrictionTypeValues RestrictionTypeValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."RestrictionTypeValues"
    ADD CONSTRAINT "RestrictionTypeValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4063 (class 2606 OID 350538)
-- Name: SpecialDesignationTypes SpecialDesignationTypes_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpecialDesignationTypes"
    ADD CONSTRAINT "SpecialDesignationTypes_Description_key" UNIQUE ("Description");


--
-- TOC entry 4065 (class 2606 OID 350475)
-- Name: SpecialDesignationTypes SpecialDesignationTypes_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpecialDesignationTypes"
    ADD CONSTRAINT "SpecialDesignationTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4067 (class 2606 OID 350540)
-- Name: SpeedLimitValues SpeedLimitValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpeedLimitValues"
    ADD CONSTRAINT "SpeedLimitValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4069 (class 2606 OID 350559)
-- Name: SpeedLimitValues SpeedLimitValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpeedLimitValues"
    ADD CONSTRAINT "SpeedLimitValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4071 (class 2606 OID 350542)
-- Name: StructureTypeValues StructureTypeValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."StructureTypeValues"
    ADD CONSTRAINT "StructureTypeValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4073 (class 2606 OID 350519)
-- Name: StructureTypeValues StructureTypeValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."StructureTypeValues"
    ADD CONSTRAINT "StructureTypeValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4075 (class 2606 OID 350544)
-- Name: TurnRestrictionValues TurnRestrictionValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."TurnRestrictionValues"
    ADD CONSTRAINT "TurnRestrictionValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4077 (class 2606 OID 350521)
-- Name: TurnRestrictionValues TurnRestrictionValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."TurnRestrictionValues"
    ADD CONSTRAINT "TurnRestrictionValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4079 (class 2606 OID 350546)
-- Name: VehicleQualifiers VehicleQualifiers_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."VehicleQualifiers"
    ADD CONSTRAINT "VehicleQualifiers_Description_key" UNIQUE ("Description");


--
-- TOC entry 4081 (class 2606 OID 350523)
-- Name: VehicleQualifiers VehicleQualifiers_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."VehicleQualifiers"
    ADD CONSTRAINT "VehicleQualifiers_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4083 (class 2606 OID 352529)
-- Name: vehicleQualifiers vehicleQualifiers_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."vehicleQualifiers"
    ADD CONSTRAINT "vehicleQualifiers_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4085 (class 2606 OID 352531)
-- Name: vehicleQualifiers vehicleQualifiers_vehicle_use_load_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."vehicleQualifiers"
    ADD CONSTRAINT "vehicleQualifiers_vehicle_use_load_key" UNIQUE ("vehicle", "use", "load");


--
-- TOC entry 355 (class 1259 OID 371810)
-- Name: MHTC_RoadLinks; Type: TABLE; Schema: highways_network; Owner: postgres
--

CREATE TABLE "highways_network"."MHTC_RoadLinks" (
    "id" integer NOT NULL,
    "notes" character varying(255),
    "geom" "public"."geometry"(LineString,27700)
);


ALTER TABLE "highways_network"."MHTC_RoadLinks" OWNER TO "postgres";

--
-- TOC entry 354 (class 1259 OID 371808)
-- Name: MHTC_RoadLinks_id_seq; Type: SEQUENCE; Schema: highways_network; Owner: postgres
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
-- TOC entry 4169 (class 0 OID 0)
-- Dependencies: 354
-- Name: MHTC_RoadLinks_id_seq; Type: SEQUENCE OWNED BY; Schema: highways_network; Owner: postgres
--

ALTER SEQUENCE "highways_network"."MHTC_RoadLinks_id_seq" OWNED BY "highways_network"."MHTC_RoadLinks"."id";


--
-- TOC entry 8 (class 2615 OID 350397)
-- Name: moving_traffic; Type: SCHEMA; Schema: -; Owner: tim.hancock
--

CREATE SCHEMA "moving_traffic";


ALTER SCHEMA "moving_traffic" OWNER TO "tim.hancock";

--
-- TOC entry 356 (class 1259 OID 371820)
-- Name: AccessRestriction_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."AccessRestriction_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."AccessRestriction_id_seq" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 347 (class 1259 OID 352593)
-- Name: Restrictions; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."Restrictions" (
    "RestrictionID" "uuid" NOT NULL,
    "NetworkReferenceID" "uuid" NOT NULL,
    "GeometryID" character varying(12) NOT NULL
);


ALTER TABLE "moving_traffic"."Restrictions" OWNER TO "postgres";

--
-- TOC entry 351 (class 1259 OID 367090)
-- Name: AccessRestrictions; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."AccessRestrictions" (
    "restriction" "moving_traffic_lookups"."accessRestrictionValue" NOT NULL,
    "timeInterval" integer,
    "trafficSigns" character varying(255),
    "exemption" integer,
    "inclusion" integer,
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
    "MHTC_CheckNotes" character varying(254),
    "GeometryID" character varying(12) DEFAULT ('A_'::"text" || "to_char"("nextval"('"moving_traffic"."AccessRestriction_id_seq"'::"regclass"), '000000000'::"text"))
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."AccessRestrictions" OWNER TO "postgres";

--
-- TOC entry 357 (class 1259 OID 371832)
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
-- TOC entry 352 (class 1259 OID 367128)
-- Name: HighwayDedications; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."HighwayDedications" (
    "dedication" "moving_traffic_lookups"."dedicationValue" NOT NULL,
    "timeInterval" integer,
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
    "MHTC_CheckNotes" character varying(254),
    "GeometryID" character varying(12) DEFAULT ('A_'::"text" || "to_char"("nextval"('"moving_traffic"."HighwayDedications_id_seq"'::"regclass"), '000000000'::"text"))
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."HighwayDedications" OWNER TO "postgres";

--
-- TOC entry 348 (class 1259 OID 366789)
-- Name: NetworkReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."NetworkReference" (
    "NetworkReferenceID" "uuid" NOT NULL
);


ALTER TABLE "moving_traffic"."NetworkReference" OWNER TO "postgres";

--
-- TOC entry 361 (class 1259 OID 371967)
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
-- TOC entry 362 (class 1259 OID 371977)
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
-- TOC entry 363 (class 1259 OID 371984)
-- Name: LinearReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."LinearReference" (
    "fromPositionGeometry" "public"."geometry"(Point,27700),
    "toPositionGeometry" "public"."geometry"(Point,27700)
)
INHERITS ("moving_traffic"."SimpleLinearReference");


ALTER TABLE "moving_traffic"."LinearReference" OWNER TO "postgres";

--
-- TOC entry 364 (class 1259 OID 371992)
-- Name: NodeReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."NodeReference" (
    "nodeReference" character varying(20) NOT NULL
)
INHERITS ("moving_traffic"."NetworkReference");


ALTER TABLE "moving_traffic"."NodeReference" OWNER TO "postgres";

--
-- TOC entry 365 (class 1259 OID 372000)
-- Name: SimplePointReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."SimplePointReference" (
    "atPosition" double precision NOT NULL,
    "offset" double precision
)
INHERITS ("moving_traffic"."LinkReference");


ALTER TABLE "moving_traffic"."SimplePointReference" OWNER TO "postgres";

--
-- TOC entry 366 (class 1259 OID 372005)
-- Name: PointReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."PointReference" (
    "atPositionGeometry" "public"."geometry"(Point,27700) NOT NULL
)
INHERITS ("moving_traffic"."SimplePointReference");


ALTER TABLE "moving_traffic"."PointReference" OWNER TO "postgres";

--
-- TOC entry 358 (class 1259 OID 371844)
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
-- TOC entry 349 (class 1259 OID 366947)
-- Name: RestrictionsForVehicles; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."RestrictionsForVehicles" (
    "restrictionType" "moving_traffic_lookups"."restrictionTypeValue" NOT NULL,
    "measure" double precision NOT NULL,
    "measure2" double precision,
    "inclusion" integer,
    "exemption" integer,
    "structure" "moving_traffic_lookups"."structureTypeValue",
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
    "MHTC_CheckNotes" character varying(254),
    "GeometryID" character varying(12) DEFAULT ('A_'::"text" || "to_char"("nextval"('"moving_traffic"."RestrictionsForVehicles_id_seq"'::"regclass"), '000000000'::"text"))
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."RestrictionsForVehicles" OWNER TO "postgres";

--
-- TOC entry 359 (class 1259 OID 371856)
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
-- TOC entry 353 (class 1259 OID 367202)
-- Name: SpecialDesignations; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."SpecialDesignations" (
    "designation" "moving_traffic_lookups"."specialDesignationTypeValue" NOT NULL,
    "timeInterval" integer,
    "applicableDirection" integer NOT NULL,
    "lane" integer,
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
    "MHTC_CheckNotes" character varying(254),
    "GeometryID" character varying(12) DEFAULT ('A_'::"text" || "to_char"("nextval"('"moving_traffic"."SpecialDesignations_id_seq"'::"regclass"), '000000000'::"text"))
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."SpecialDesignations" OWNER TO "postgres";

--
-- TOC entry 360 (class 1259 OID 371868)
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
-- TOC entry 350 (class 1259 OID 366995)
-- Name: TurnRestrictions; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."TurnRestrictions" (
    "restriction" "moving_traffic_lookups"."turnRestrictionValue" NOT NULL,
    "inclusion" integer,
    "exemption" integer,
    "timeInterval" integer,
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
    "MHTC_CheckNotes" character varying(254),
    "GeometryID" character varying(12) DEFAULT ('A_'::"text" || "to_char"("nextval"('"moving_traffic"."TurnRestrictions_id_seq"'::"regclass"), '000000000'::"text"))
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."TurnRestrictions" OWNER TO "postgres";

--
-- TOC entry 4076 (class 2606 OID 367097)
-- Name: AccessRestrictions AccessRestrictions_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_pkey" PRIMARY KEY ("RestrictionID") INCLUDE ("NetworkReferenceID");


--
-- TOC entry 4078 (class 2606 OID 367135)
-- Name: HighwayDedications HighwayDedications_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "HighwayDedications_pkey" PRIMARY KEY ("RestrictionID") INCLUDE ("NetworkReferenceID");


--
-- TOC entry 4088 (class 2606 OID 371991)
-- Name: LinearReference LinearReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."LinearReference"
    ADD CONSTRAINT "LinearReference_pkey" PRIMARY KEY ("NetworkReferenceID") INCLUDE ("linkReference");


--
-- TOC entry 4082 (class 2606 OID 371971)
-- Name: LinkReference LinkReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."LinkReference"
    ADD CONSTRAINT "LinkReference_pkey" PRIMARY KEY ("NetworkReferenceID", "linkReference", "linkOrder");


--
-- TOC entry 4070 (class 2606 OID 366793)
-- Name: NetworkReference NetworkReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."NetworkReference"
    ADD CONSTRAINT "NetworkReference_pkey" PRIMARY KEY ("NetworkReferenceID");


--
-- TOC entry 4092 (class 2606 OID 372012)
-- Name: PointReference PointReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."PointReference"
    ADD CONSTRAINT "PointReference_pkey" PRIMARY KEY ("NetworkReferenceID") INCLUDE ("linkReference");


--
-- TOC entry 4072 (class 2606 OID 366954)
-- Name: RestrictionsForVehicles RestrictionForVehicles_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_pkey" PRIMARY KEY ("RestrictionID") INCLUDE ("NetworkReferenceID");


--
-- TOC entry 4068 (class 2606 OID 371882)
-- Name: Restrictions Restrictions_GeometryID_key; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."Restrictions"
    ADD CONSTRAINT "Restrictions_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4084 (class 2606 OID 371983)
-- Name: SimpleLinearReference SimpleLinearReference_NetworkReferenceID_linkReference_key; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SimpleLinearReference"
    ADD CONSTRAINT "SimpleLinearReference_NetworkReferenceID_linkReference_key" UNIQUE ("NetworkReferenceID", "linkReference");


--
-- TOC entry 4086 (class 2606 OID 371981)
-- Name: SimpleLinearReference SimpleLinearReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SimpleLinearReference"
    ADD CONSTRAINT "SimpleLinearReference_pkey" PRIMARY KEY ("NetworkReferenceID") INCLUDE ("linkReference");


--
-- TOC entry 4090 (class 2606 OID 372004)
-- Name: SimplePointReference SimplePointReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SimplePointReference"
    ADD CONSTRAINT "SimplePointReference_pkey" PRIMARY KEY ("NetworkReferenceID") INCLUDE ("linkReference");


--
-- TOC entry 4080 (class 2606 OID 367209)
-- Name: SpecialDesignations SpecialDesignations_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_pkey" PRIMARY KEY ("RestrictionID") INCLUDE ("NetworkReferenceID");


--
-- TOC entry 4074 (class 2606 OID 367002)
-- Name: TurnRestrictions TurnRestrictions_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_pkey" PRIMARY KEY ("RestrictionID") INCLUDE ("NetworkReferenceID");


--
-- TOC entry 4130 (class 2620 OID 371883)
-- Name: AccessRestrictions create_geometryid_access_restrictions; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_access_restrictions" BEFORE INSERT ON "moving_traffic"."AccessRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid2"();


--
-- TOC entry 4132 (class 2620 OID 371888)
-- Name: HighwayDedications create_geometryid_highway_dedications; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_highway_dedications" BEFORE INSERT ON "moving_traffic"."HighwayDedications" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid2"();


--
-- TOC entry 4126 (class 2620 OID 371885)
-- Name: RestrictionsForVehicles create_geometryid_restrictions_for_vehicles; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_restrictions_for_vehicles" BEFORE INSERT ON "moving_traffic"."RestrictionsForVehicles" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid2"();


--
-- TOC entry 4133 (class 2620 OID 371886)
-- Name: SpecialDesignations create_geometryid_special_designations; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_special_designations" BEFORE INSERT ON "moving_traffic"."SpecialDesignations" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid2"();


--
-- TOC entry 4128 (class 2620 OID 371887)
-- Name: TurnRestrictions create_geometryid_turn_restrictions; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_turn_restrictions" BEFORE INSERT ON "moving_traffic"."TurnRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid2"();


--
-- TOC entry 4129 (class 2620 OID 371819)
-- Name: AccessRestrictions set_last_update_details_AccessRestriction; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_AccessRestriction" BEFORE INSERT OR UPDATE ON "moving_traffic"."AccessRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4131 (class 2620 OID 371831)
-- Name: HighwayDedications set_last_update_details_HighwayDedications; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_HighwayDedications" BEFORE INSERT OR UPDATE ON "moving_traffic"."HighwayDedications" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4125 (class 2620 OID 371843)
-- Name: RestrictionsForVehicles set_last_update_details_RestrictionsForVehicles; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_RestrictionsForVehicles" BEFORE INSERT OR UPDATE ON "moving_traffic"."RestrictionsForVehicles" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4134 (class 2620 OID 371855)
-- Name: SpecialDesignations set_last_update_details_SpecialDesignations; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_SpecialDesignations" BEFORE INSERT OR UPDATE ON "moving_traffic"."SpecialDesignations" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4127 (class 2620 OID 371867)
-- Name: TurnRestrictions set_last_update_details_TurnRestrictions; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_TurnRestrictions" BEFORE INSERT OR UPDATE ON "moving_traffic"."TurnRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4106 (class 2606 OID 367098)
-- Name: AccessRestrictions AccessRestrictions_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4107 (class 2606 OID 367103)
-- Name: AccessRestrictions AccessRestrictions_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4108 (class 2606 OID 367108)
-- Name: AccessRestrictions AccessRestrictions_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4109 (class 2606 OID 367113)
-- Name: AccessRestrictions AccessRestrictions_exemption_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_exemption_fkey" FOREIGN KEY ("exemption") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4110 (class 2606 OID 367118)
-- Name: AccessRestrictions AccessRestrictions_inclusion_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_inclusion_fkey" FOREIGN KEY ("inclusion") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4111 (class 2606 OID 367123)
-- Name: AccessRestrictions AccessRestrictions_timeInterval_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_timeInterval_fkey" FOREIGN KEY ("timeInterval") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4114 (class 2606 OID 367146)
-- Name: HighwayDedications HighwayDedications_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "HighwayDedications_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4115 (class 2606 OID 367151)
-- Name: HighwayDedications HighwayDedications_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "HighwayDedications_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4116 (class 2606 OID 367156)
-- Name: HighwayDedications HighwayDedications_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "HighwayDedications_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4112 (class 2606 OID 367136)
-- Name: HighwayDedications HighwayDedications_NetworkRestrictionID_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "HighwayDedications_NetworkRestrictionID_fkey" FOREIGN KEY ("NetworkReferenceID") REFERENCES "moving_traffic"."NetworkReference"("NetworkReferenceID");


--
-- TOC entry 4113 (class 2606 OID 367141)
-- Name: HighwayDedications HighwayDedications_timeInterval_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "HighwayDedications_timeInterval_fkey" FOREIGN KEY ("timeInterval") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4124 (class 2606 OID 372013)
-- Name: PointReference PointReference_linkReference_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."PointReference"
    ADD CONSTRAINT "PointReference_linkReference_fkey" FOREIGN KEY ("linkReference") REFERENCES "highways_network"."itn_roadcentreline"("toid");


--
-- TOC entry 4093 (class 2606 OID 366955)
-- Name: RestrictionsForVehicles RestrictionForVehicles_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4094 (class 2606 OID 366960)
-- Name: RestrictionsForVehicles RestrictionForVehicles_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4095 (class 2606 OID 366965)
-- Name: RestrictionsForVehicles RestrictionForVehicles_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4096 (class 2606 OID 366970)
-- Name: RestrictionsForVehicles RestrictionForVehicles_NetworkReferenceID_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_NetworkReferenceID_fkey" FOREIGN KEY ("NetworkReferenceID") REFERENCES "moving_traffic"."NetworkReference"("NetworkReferenceID");


--
-- TOC entry 4097 (class 2606 OID 366975)
-- Name: RestrictionsForVehicles RestrictionForVehicles_exemption_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_exemption_fkey" FOREIGN KEY ("exemption") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4098 (class 2606 OID 366980)
-- Name: RestrictionsForVehicles RestrictionForVehicles_inclusion_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_inclusion_fkey" FOREIGN KEY ("inclusion") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4117 (class 2606 OID 367210)
-- Name: SpecialDesignations SpecialDesignations_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4118 (class 2606 OID 367215)
-- Name: SpecialDesignations SpecialDesignations_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4119 (class 2606 OID 367220)
-- Name: SpecialDesignations SpecialDesignations_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4120 (class 2606 OID 367225)
-- Name: SpecialDesignations SpecialDesignations_NetworkReferenceID_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_NetworkReferenceID_fkey" FOREIGN KEY ("NetworkReferenceID") REFERENCES "moving_traffic"."NetworkReference"("NetworkReferenceID");


--
-- TOC entry 4121 (class 2606 OID 367230)
-- Name: SpecialDesignations SpecialDesignations_timeInterval_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_timeInterval_fkey" FOREIGN KEY ("timeInterval") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4099 (class 2606 OID 367003)
-- Name: TurnRestrictions TurnRestrictions_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4100 (class 2606 OID 367008)
-- Name: TurnRestrictions TurnRestrictions_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4101 (class 2606 OID 367013)
-- Name: TurnRestrictions TurnRestrictions_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4102 (class 2606 OID 367018)
-- Name: TurnRestrictions TurnRestrictions_NetworkReferenceID_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_NetworkReferenceID_fkey" FOREIGN KEY ("NetworkReferenceID") REFERENCES "moving_traffic"."NetworkReference"("NetworkReferenceID");


--
-- TOC entry 4103 (class 2606 OID 367023)
-- Name: TurnRestrictions TurnRestrictions_exemption_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_exemption_fkey" FOREIGN KEY ("exemption") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4104 (class 2606 OID 367028)
-- Name: TurnRestrictions TurnRestrictions_inclusion_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_inclusion_fkey" FOREIGN KEY ("inclusion") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4105 (class 2606 OID 367033)
-- Name: TurnRestrictions TurnRestrictions_timeInterval_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_timeInterval_fkey" FOREIGN KEY ("timeInterval") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4122 (class 2606 OID 371972)
-- Name: LinkReference fk_link; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."LinkReference"
    ADD CONSTRAINT "fk_link" FOREIGN KEY ("linkReference") REFERENCES "highways_network"."itn_roadcentreline"("toid");


--
-- TOC entry 4123 (class 2606 OID 371995)
-- Name: NodeReference fk_node; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."NodeReference"
    ADD CONSTRAINT "fk_node" FOREIGN KEY ("nodeReference") REFERENCES "highways_network"."itn_roadcentreline"("toid");

