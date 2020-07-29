--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-07-27 23:06:57

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
-- TOC entry 11 (class 2615 OID 508287)
-- Name: highway_assets; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "highway_assets";


ALTER SCHEMA "highway_assets" OWNER TO "postgres";


CREATE FUNCTION public.create_geometryid_highway_assets()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	 nextSeqVal varchar := '';
BEGIN

	CASE TG_TABLE_NAME
	WHEN 'Benches' THEN
			SELECT concat('BE_', to_char(nextval('highway_assets."Benches_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;
	WHEN 'Benches' THEN
			SELECT concat('BI_', to_char(nextval('highway_assets."Bins_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;
	WHEN 'Bollards' THEN
		   SELECT concat('BO_', to_char(nextval('highway_assets."Bollards_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;
	WHEN 'BusShelters' THEN
		   SELECT concat('BS_', to_char(nextval('highway_assets."BusShelters_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;
	WHEN 'CCTV_Cameras' THEN
		   SELECT concat('CT_', to_char(nextval('highway_assets."CCTV_Cameras_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'CommunicationCabinets' THEN
		   SELECT concat('CC_', to_char(nextval('highway_assets."CommunicationCabinets_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'CrossingPoints' THEN
		   SELECT concat('CR_', to_char(nextval('highway_assets."CrossingPoints_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'CycleParking' THEN
		   SELECT concat('CY_', to_char(nextval('highway_assets."CycleParking_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'DisplayBoards' THEN
		   SELECT concat('DB_', to_char(nextval('highway_assets."DisplayBoards_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'EV_ChargingPoints' THEN
		   SELECT concat('EV_', to_char(nextval('highway_assets."EV_ChargingPoints_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'EndOfStreetMarkings' THEN
		   SELECT concat('ES_', to_char(nextval('highway_assets."EndOfStreetMarkings_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'PedestrianRailings' THEN
		   SELECT concat('PR_', to_char(nextval('highway_assets."PedestrianRailings_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'StreetNamePlates' THEN
		   SELECT concat('SN_', to_char(nextval('highway_assets."StreetNamePlates_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'SubterraneanFeatures' THEN
		   SELECT concat('SF_', to_char(nextval('highway_assets."SubterraneanFeatures_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'TrafficCalming' THEN
		   SELECT concat('TC_', to_char(nextval('highway_assets."TrafficCalming_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;
	WHEN 'TrafficSignals' THEN
		   SELECT concat('TS_', to_char(nextval('highway_assets."TrafficSignals_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'UnidentifiedStaticObjects' THEN
		   SELECT concat('US_', to_char(nextval('highway_assets."UnidentifiedStaticObjects_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'VehicleBarriers' THEN
		   SELECT concat('VB_', to_char(nextval('highway_assets."VehicleBarriers_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	ELSE
	    nextSeqVal = 'U';
	END CASE;

    NEW."GeometryID" := nextSeqVal;
	RETURN NEW;

END;
$BODY$;

ALTER FUNCTION public.create_geometryid_highway_assets()
    OWNER TO postgres;

--
-- TOC entry 407 (class 1259 OID 508289)
-- Name: Benches_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."Benches_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."Benches_id_seq" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 409 (class 1259 OID 508293)
-- Name: HighwayAssets; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."HighwayAssets" (
    "RestrictionID" "uuid" NOT NULL,
    "GeometryID" character varying(12) NOT NULL,
    "Photos_01" character varying(255),
    "Photos_02" character varying(255),
    "Photos_03" character varying(255),
    "Notes" character varying(255),
    "RoadName" character varying(254),
    "USRN" character varying(254),
    "OpenDate" "date",
    "CloseDate" "date",
    "AssetConditionTypeID" integer NOT NULL,
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) NOT NULL,
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254)
);


ALTER TABLE "highway_assets"."HighwayAssets" OWNER TO "postgres";

--
-- TOC entry 410 (class 1259 OID 508299)
-- Name: Benches; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."Benches" (
    "GeometryID" character varying(12) DEFAULT ('BE_'::"text" || "to_char"("nextval"('"highway_assets"."Benches_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(Point,27700)
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."Benches" OWNER TO "postgres";

--
-- TOC entry 408 (class 1259 OID 508291)
-- Name: Bins_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."Bins_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."Bins_id_seq" OWNER TO "postgres";

--
-- TOC entry 411 (class 1259 OID 508306)
-- Name: Bins; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."Bins" (
    "GeometryID" character varying(12) DEFAULT ('BI_'::"text" || "to_char"("nextval"('"highway_assets"."Bins_id_seq"'::"regclass"), '00000000'::"text")),
    "BinTypeID" integer NOT NULL,
    "geom_point" "public"."geometry"(Point,27700),
    "geom_polygon" "public"."geometry"(Polygon,27700)
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."Bins" OWNER TO "postgres";

--
-- TOC entry 412 (class 1259 OID 508313)
-- Name: Bollards_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."Bollards_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."Bollards_id_seq" OWNER TO "postgres";

--
-- TOC entry 413 (class 1259 OID 508315)
-- Name: Bollards; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."Bollards" (
    "GeometryID" character varying(12) DEFAULT ('BO_'::"text" || "to_char"("nextval"('"highway_assets"."Bollards_id_seq"'::"regclass"), '00000000'::"text")),
    "geom_linestring" "public"."geometry"(LineString,27700),
    "geom_point" "public"."geometry"(Point,27700),
    "BollardTypeID" integer NOT NULL
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."Bollards" OWNER TO "postgres";

--
-- TOC entry 414 (class 1259 OID 508322)
-- Name: BusShelters_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."BusShelters_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."BusShelters_id_seq" OWNER TO "postgres";

--
-- TOC entry 415 (class 1259 OID 508324)
-- Name: BusShelters; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."BusShelters" (
    "GeometryID" character varying(12) DEFAULT ('BS_'::"text" || "to_char"("nextval"('"highway_assets"."BusShelters_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(LineString,27700)
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."BusShelters" OWNER TO "postgres";

--
-- TOC entry 416 (class 1259 OID 508331)
-- Name: CCTV_Cameras_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."CCTV_Cameras_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."CCTV_Cameras_id_seq" OWNER TO "postgres";

--
-- TOC entry 417 (class 1259 OID 508333)
-- Name: CCTV_Cameras; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."CCTV_Cameras" (
    "GeometryID" character varying(12) DEFAULT ('CT_'::"text" || "to_char"("nextval"('"highway_assets"."CCTV_Cameras_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(Point,27700)
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."CCTV_Cameras" OWNER TO "postgres";

--
-- TOC entry 418 (class 1259 OID 508340)
-- Name: CommunicationCabinets_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."CommunicationCabinets_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."CommunicationCabinets_id_seq" OWNER TO "postgres";

--
-- TOC entry 419 (class 1259 OID 508342)
-- Name: CommunicationCabinets; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."CommunicationCabinets" (
    "GeometryID" character varying(12) DEFAULT ('CC_'::"text" || "to_char"("nextval"('"highway_assets"."CommunicationCabinets_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(Point,27700),
    "CommunicationCabinetTypeID" integer NOT NULL
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."CommunicationCabinets" OWNER TO "postgres";

--
-- TOC entry 420 (class 1259 OID 508349)
-- Name: CrossingPoints_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."CrossingPoints_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."CrossingPoints_id_seq" OWNER TO "postgres";

--
-- TOC entry 421 (class 1259 OID 508351)
-- Name: CrossingPoints; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."CrossingPoints" (
    "GeometryID" character varying(12) DEFAULT ('CR_'::"text" || "to_char"("nextval"('"highway_assets"."CrossingPoints_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(LineString,27700),
    "CrossingPointTypeID" integer NOT NULL
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."CrossingPoints" OWNER TO "postgres";

--
-- TOC entry 422 (class 1259 OID 508358)
-- Name: CycleParking_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."CycleParking_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."CycleParking_id_seq" OWNER TO "postgres";

--
-- TOC entry 423 (class 1259 OID 508360)
-- Name: CycleParking; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."CycleParking" (
    "GeometryID" character varying(12) DEFAULT ('CY_'::"text" || "to_char"("nextval"('"highway_assets"."CycleParking_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(Point,27700),
    "CycleParkingTypeID" integer NOT NULL,
    "NrStands" integer
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."CycleParking" OWNER TO "postgres";

--
-- TOC entry 424 (class 1259 OID 508367)
-- Name: DisplayBoards_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."DisplayBoards_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."DisplayBoards_id_seq" OWNER TO "postgres";

--
-- TOC entry 425 (class 1259 OID 508369)
-- Name: DisplayBoards; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."DisplayBoards" (
    "GeometryID" character varying(12) DEFAULT ('DB_'::"text" || "to_char"("nextval"('"highway_assets"."DisplayBoards_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(Point,27700),
    "DisplayBoardTypeID" integer NOT NULL
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."DisplayBoards" OWNER TO "postgres";

--
-- TOC entry 426 (class 1259 OID 508376)
-- Name: EV_ChargingPoints_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."EV_ChargingPoints_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."EV_ChargingPoints_id_seq" OWNER TO "postgres";

--
-- TOC entry 427 (class 1259 OID 508378)
-- Name: EV_ChargingPoints; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."EV_ChargingPoints" (
    "GeometryID" character varying(12) DEFAULT ('EV_'::"text" || "to_char"("nextval"('"highway_assets"."EV_ChargingPoints_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(Point,27700),
    "EV_ChargingPointTypeID" integer NOT NULL
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."EV_ChargingPoints" OWNER TO "postgres";

--
-- TOC entry 428 (class 1259 OID 508385)
-- Name: EndOfStreetMarkings_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."EndOfStreetMarkings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."EndOfStreetMarkings_id_seq" OWNER TO "postgres";

--
-- TOC entry 429 (class 1259 OID 508387)
-- Name: EndOfStreetMarkings; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."EndOfStreetMarkings" (
    "GeometryID" character varying(12) DEFAULT ('ES_'::"text" || "to_char"("nextval"('"highway_assets"."EndOfStreetMarkings_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(LineString,27700),
    "EndOfStreetMarkingTypeID" integer NOT NULL
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."EndOfStreetMarkings" OWNER TO "postgres";

--
-- TOC entry 430 (class 1259 OID 508394)
-- Name: PedestrianRailings_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."PedestrianRailings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."PedestrianRailings_id_seq" OWNER TO "postgres";

--
-- TOC entry 431 (class 1259 OID 508396)
-- Name: PedestrianRailings; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."PedestrianRailings" (
    "GeometryID" character varying(12) DEFAULT ('PR_'::"text" || "to_char"("nextval"('"highway_assets"."PedestrianRailings_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(LineString,27700),
    "PedestrianRailingTypeID" integer NOT NULL
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."PedestrianRailings" OWNER TO "postgres";

--
-- TOC entry 432 (class 1259 OID 508403)
-- Name: StreetNamePlates_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."StreetNamePlates_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."StreetNamePlates_id_seq" OWNER TO "postgres";

--
-- TOC entry 433 (class 1259 OID 508405)
-- Name: StreetNamePlates; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."StreetNamePlates" (
    "GeometryID" character varying(12) DEFAULT ('SN_'::"text" || "to_char"("nextval"('"highway_assets"."StreetNamePlates_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(Point,27700)
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."StreetNamePlates" OWNER TO "postgres";

--
-- TOC entry 434 (class 1259 OID 508412)
-- Name: SubterraneanFeatures_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."SubterraneanFeatures_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."SubterraneanFeatures_id_seq" OWNER TO "postgres";

--
-- TOC entry 435 (class 1259 OID 508414)
-- Name: SubterraneanFeatures; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."SubterraneanFeatures" (
    "GeometryID" character varying(12) DEFAULT ('SF_'::"text" || "to_char"("nextval"('"highway_assets"."SubterraneanFeatures_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(Point,27700),
    "SubterraneanFeatureTypeID" integer NOT NULL
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."SubterraneanFeatures" OWNER TO "postgres";

--
-- TOC entry 436 (class 1259 OID 508421)
-- Name: TrafficCalming_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."TrafficCalming_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."TrafficCalming_id_seq" OWNER TO "postgres";

--
-- TOC entry 437 (class 1259 OID 508423)
-- Name: TrafficCalming; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."TrafficCalming" (
    "GeometryID" character varying(12) DEFAULT ('TC_'::"text" || "to_char"("nextval"('"highway_assets"."TrafficCalming_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(LineString,27700),
    "TrafficCalmingTypeID" integer NOT NULL,
    "NrCushions" integer
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."TrafficCalming" OWNER TO "postgres";

--
-- TOC entry 438 (class 1259 OID 508430)
-- Name: TrafficSignals_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."TrafficSignals_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."TrafficSignals_id_seq" OWNER TO "postgres";

--
-- TOC entry 439 (class 1259 OID 508432)
-- Name: TrafficSignals; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."TrafficSignals" (
    "GeometryID" character varying(12) DEFAULT ('TS_'::"text" || "to_char"("nextval"('"highway_assets"."TrafficSignals_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(Point,27700)
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."TrafficSignals" OWNER TO "postgres";

--
-- TOC entry 440 (class 1259 OID 508439)
-- Name: UnidentifiedStaticObjects_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."UnidentifiedStaticObjects_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."UnidentifiedStaticObjects_id_seq" OWNER TO "postgres";

--
-- TOC entry 441 (class 1259 OID 508441)
-- Name: UnidentifiedStaticObjects; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."UnidentifiedStaticObjects" (
    "GeometryID" character varying(12) DEFAULT ('VB_'::"text" || "to_char"("nextval"('"highway_assets"."UnidentifiedStaticObjects_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(Point,27700)
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."UnidentifiedStaticObjects" OWNER TO "postgres";

--
-- TOC entry 442 (class 1259 OID 508448)
-- Name: VehicleBarriers_id_seq; Type: SEQUENCE; Schema: highway_assets; Owner: postgres
--

CREATE SEQUENCE "highway_assets"."VehicleBarriers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_assets"."VehicleBarriers_id_seq" OWNER TO "postgres";

--
-- TOC entry 443 (class 1259 OID 508450)
-- Name: VehicleBarriers; Type: TABLE; Schema: highway_assets; Owner: postgres
--

CREATE TABLE "highway_assets"."VehicleBarriers" (
    "GeometryID" character varying(12) DEFAULT ('VB_'::"text" || "to_char"("nextval"('"highway_assets"."VehicleBarriers_id_seq"'::"regclass"), '00000000'::"text")),
    "geom" "public"."geometry"(Point,27700),
    "VehicleBarrierTypeID" integer NOT NULL
)
INHERITS ("highway_assets"."HighwayAssets");


ALTER TABLE "highway_assets"."VehicleBarriers" OWNER TO "postgres";

--
-- TOC entry 4303 (class 2606 OID 508458)
-- Name: Benches Benches_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."Benches"
    ADD CONSTRAINT "Benches_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4306 (class 2606 OID 508619)
-- Name: Bins Bins_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."Bins"
    ADD CONSTRAINT "Bins_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4310 (class 2606 OID 508460)
-- Name: Bollards Bollards_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."Bollards"
    ADD CONSTRAINT "Bollards_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4314 (class 2606 OID 508462)
-- Name: BusShelters BusShelters_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."BusShelters"
    ADD CONSTRAINT "BusShelters_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4317 (class 2606 OID 508464)
-- Name: CCTV_Cameras CCTV_Cameras_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."CCTV_Cameras"
    ADD CONSTRAINT "CCTV_Cameras_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4320 (class 2606 OID 508466)
-- Name: CommunicationCabinets CommunicationCabinets_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."CommunicationCabinets"
    ADD CONSTRAINT "CommunicationCabinets_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4323 (class 2606 OID 508468)
-- Name: CrossingPoints CrossingPoints_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."CrossingPoints"
    ADD CONSTRAINT "CrossingPoints_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4326 (class 2606 OID 508470)
-- Name: CycleParking CycleParking_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."CycleParking"
    ADD CONSTRAINT "CycleParking_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4329 (class 2606 OID 508472)
-- Name: DisplayBoards DisplayBoards_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."DisplayBoards"
    ADD CONSTRAINT "DisplayBoards_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4332 (class 2606 OID 508474)
-- Name: EV_ChargingPoints EV_ChargingPoints_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."EV_ChargingPoints"
    ADD CONSTRAINT "EV_ChargingPoints_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4335 (class 2606 OID 508476)
-- Name: EndOfStreetMarkings EndOfStreetMarkings_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."EndOfStreetMarkings"
    ADD CONSTRAINT "EndOfStreetMarkings_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4299 (class 2606 OID 508478)
-- Name: HighwayAssets HighwayAssets_GeometryID_key; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."HighwayAssets"
    ADD CONSTRAINT "HighwayAssets_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4301 (class 2606 OID 508480)
-- Name: HighwayAssets HighwayAssets_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."HighwayAssets"
    ADD CONSTRAINT "HighwayAssets_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4338 (class 2606 OID 508482)
-- Name: PedestrianRailings PedestrianRailings_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."PedestrianRailings"
    ADD CONSTRAINT "PedestrianRailings_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4341 (class 2606 OID 508484)
-- Name: StreetNamePlates StreetNamePlates_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."StreetNamePlates"
    ADD CONSTRAINT "StreetNamePlates_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4344 (class 2606 OID 508486)
-- Name: SubterraneanFeatures SubterraneanFeatures_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."SubterraneanFeatures"
    ADD CONSTRAINT "SubterraneanFeatures_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4347 (class 2606 OID 508488)
-- Name: TrafficCalming TrafficCalming_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."TrafficCalming"
    ADD CONSTRAINT "TrafficCalming_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4350 (class 2606 OID 508490)
-- Name: TrafficSignals TrafficSignals_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."TrafficSignals"
    ADD CONSTRAINT "TrafficSignals_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4354 (class 2606 OID 508492)
-- Name: VehicleBarriers VehicleBarriers_pkey; Type: CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."VehicleBarriers"
    ADD CONSTRAINT "VehicleBarriers_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4304 (class 1259 OID 508599)
-- Name: sidx_Benches_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_Benches_geom" ON "highway_assets"."Benches" USING "gist" ("geom");


--
-- TOC entry 4307 (class 1259 OID 508620)
-- Name: sidx_Bins_geom_point; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_Bins_geom_point" ON "highway_assets"."Bins" USING "gist" ("geom_point");


--
-- TOC entry 4308 (class 1259 OID 508600)
-- Name: sidx_Bins_geom_polygon; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_Bins_geom_polygon" ON "highway_assets"."Bins" USING "gist" ("geom_polygon");


--
-- TOC entry 4311 (class 1259 OID 508601)
-- Name: sidx_Bollards_geom_linestring; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_Bollards_geom_linestring" ON "highway_assets"."Bollards" USING "gist" ("geom_linestring");


--
-- TOC entry 4312 (class 1259 OID 508602)
-- Name: sidx_Bollards_geom_point; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_Bollards_geom_point" ON "highway_assets"."Bollards" USING "gist" ("geom_point");


--
-- TOC entry 4315 (class 1259 OID 508603)
-- Name: sidx_BusShelters_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_BusShelters_geom" ON "highway_assets"."BusShelters" USING "gist" ("geom");


--
-- TOC entry 4318 (class 1259 OID 508604)
-- Name: sidx_CCTV_Cameras_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_CCTV_Cameras_geom" ON "highway_assets"."CCTV_Cameras" USING "gist" ("geom");


--
-- TOC entry 4321 (class 1259 OID 508605)
-- Name: sidx_CommunicationCabinets_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_CommunicationCabinets_geom" ON "highway_assets"."CommunicationCabinets" USING "gist" ("geom");


--
-- TOC entry 4324 (class 1259 OID 508606)
-- Name: sidx_CrossingPoints_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_CrossingPoints_geom" ON "highway_assets"."CrossingPoints" USING "gist" ("geom");


--
-- TOC entry 4327 (class 1259 OID 508607)
-- Name: sidx_CycleParking_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_CycleParking_geom" ON "highway_assets"."CycleParking" USING "gist" ("geom");


--
-- TOC entry 4330 (class 1259 OID 508608)
-- Name: sidx_DisplayBoards_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_DisplayBoards_geom" ON "highway_assets"."DisplayBoards" USING "gist" ("geom");


--
-- TOC entry 4333 (class 1259 OID 508609)
-- Name: sidx_EV_ChargingPoints_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_EV_ChargingPoints_geom" ON "highway_assets"."EV_ChargingPoints" USING "gist" ("geom");


--
-- TOC entry 4336 (class 1259 OID 508610)
-- Name: sidx_EndOfStreetMarkings_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_EndOfStreetMarkings_geom" ON "highway_assets"."EndOfStreetMarkings" USING "gist" ("geom");


--
-- TOC entry 4339 (class 1259 OID 508611)
-- Name: sidx_PedestrianRailings_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_PedestrianRailings_geom" ON "highway_assets"."PedestrianRailings" USING "gist" ("geom");


--
-- TOC entry 4342 (class 1259 OID 508612)
-- Name: sidx_StreetNamePlates_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_StreetNamePlates_geom" ON "highway_assets"."StreetNamePlates" USING "gist" ("geom");


--
-- TOC entry 4345 (class 1259 OID 508613)
-- Name: sidx_SubterraneanFeatures_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_SubterraneanFeatures_geom" ON "highway_assets"."SubterraneanFeatures" USING "gist" ("geom");


--
-- TOC entry 4348 (class 1259 OID 508614)
-- Name: sidx_TrafficCalming_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_TrafficCalming_geom" ON "highway_assets"."TrafficCalming" USING "gist" ("geom");


--
-- TOC entry 4351 (class 1259 OID 508615)
-- Name: sidx_TrafficSignals_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_TrafficSignals_geom" ON "highway_assets"."TrafficSignals" USING "gist" ("geom");


--
-- TOC entry 4352 (class 1259 OID 508616)
-- Name: sidx_UnidentifiedStaticObjects_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_UnidentifiedStaticObjects_geom" ON "highway_assets"."UnidentifiedStaticObjects" USING "gist" ("geom");


--
-- TOC entry 4355 (class 1259 OID 508617)
-- Name: sidx_VehicleBarriers_geom; Type: INDEX; Schema: highway_assets; Owner: postgres
--

CREATE INDEX "sidx_VehicleBarriers_geom" ON "highway_assets"."VehicleBarriers" USING "gist" ("geom");


--
-- TOC entry 4370 (class 2620 OID 508493)
-- Name: Benches create_geometryid_benches; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_benches" BEFORE INSERT ON "highway_assets"."Benches" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4373 (class 2620 OID 508494)
-- Name: Bollards create_geometryid_bollards; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_bollards" BEFORE INSERT ON "highway_assets"."Bollards" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4374 (class 2620 OID 508495)
-- Name: BusShelters create_geometryid_bus_shelters; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_bus_shelters" BEFORE INSERT ON "highway_assets"."BusShelters" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4376 (class 2620 OID 508496)
-- Name: CCTV_Cameras create_geometryid_cctv_cameras; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_cctv_cameras" BEFORE INSERT ON "highway_assets"."CCTV_Cameras" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4378 (class 2620 OID 508497)
-- Name: CommunicationCabinets create_geometryid_communication_cabinets; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_communication_cabinets" BEFORE INSERT ON "highway_assets"."CommunicationCabinets" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4380 (class 2620 OID 508498)
-- Name: CrossingPoints create_geometryid_crossing_points; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_crossing_points" BEFORE INSERT ON "highway_assets"."CrossingPoints" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4382 (class 2620 OID 508499)
-- Name: CycleParking create_geometryid_cycle_parking; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_cycle_parking" BEFORE INSERT ON "highway_assets"."CycleParking" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4384 (class 2620 OID 508500)
-- Name: DisplayBoards create_geometryid_display_boards; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_display_boards" BEFORE INSERT ON "highway_assets"."DisplayBoards" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4388 (class 2620 OID 508501)
-- Name: EndOfStreetMarkings create_geometryid_end_of_street_markings; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_end_of_street_markings" BEFORE INSERT ON "highway_assets"."EndOfStreetMarkings" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4386 (class 2620 OID 508502)
-- Name: EV_ChargingPoints create_geometryid_ev_charging_points; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_ev_charging_points" BEFORE INSERT ON "highway_assets"."EV_ChargingPoints" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4390 (class 2620 OID 508503)
-- Name: PedestrianRailings create_geometryid_pedestrian_railings; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_pedestrian_railings" BEFORE INSERT ON "highway_assets"."PedestrianRailings" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4392 (class 2620 OID 508504)
-- Name: StreetNamePlates create_geometryid_street_name_plates; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_street_name_plates" BEFORE INSERT ON "highway_assets"."StreetNamePlates" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4394 (class 2620 OID 508505)
-- Name: SubterraneanFeatures create_geometryid_subterranean_features; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_subterranean_features" BEFORE INSERT ON "highway_assets"."SubterraneanFeatures" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4396 (class 2620 OID 508506)
-- Name: TrafficCalming create_geometryid_traffic_calming; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_traffic_calming" BEFORE INSERT ON "highway_assets"."TrafficCalming" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4398 (class 2620 OID 508507)
-- Name: TrafficSignals create_geometryid_traffic_signals; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_traffic_signals" BEFORE INSERT ON "highway_assets"."TrafficSignals" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4400 (class 2620 OID 508509)
-- Name: UnidentifiedStaticObjects create_geometryid_unidentified_static_objects; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_unidentified_static_objects" BEFORE INSERT ON "highway_assets"."UnidentifiedStaticObjects" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4402 (class 2620 OID 508508)
-- Name: VehicleBarriers create_geometryid_vehicles_barriers; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "create_geometryid_vehicles_barriers" BEFORE INSERT ON "highway_assets"."VehicleBarriers" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_highway_assets"();


--
-- TOC entry 4371 (class 2620 OID 508580)
-- Name: Benches set_last_update_details_Benches; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_Benches" BEFORE INSERT OR UPDATE ON "highway_assets"."Benches" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4372 (class 2620 OID 508581)
-- Name: Bins set_last_update_details_Bins; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_Bins" BEFORE INSERT OR UPDATE ON "highway_assets"."Bins" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();

CREATE TRIGGER "set_last_update_details_Bollards" BEFORE INSERT OR UPDATE ON "highway_assets"."Bollards" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();

--
-- TOC entry 4375 (class 2620 OID 508582)
-- Name: BusShelters set_last_update_details_BusShelters; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_BusShelters" BEFORE INSERT OR UPDATE ON "highway_assets"."BusShelters" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4377 (class 2620 OID 508583)
-- Name: CCTV_Cameras set_last_update_details_CCTV_Cameras; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_CCTV_Cameras" BEFORE INSERT OR UPDATE ON "highway_assets"."CCTV_Cameras" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4379 (class 2620 OID 508584)
-- Name: CommunicationCabinets set_last_update_details_CommunicationCabinets; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_CommunicationCabinets" BEFORE INSERT OR UPDATE ON "highway_assets"."CommunicationCabinets" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4381 (class 2620 OID 508585)
-- Name: CrossingPoints set_last_update_details_CrossingPoints; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_CrossingPoints" BEFORE INSERT OR UPDATE ON "highway_assets"."CrossingPoints" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4383 (class 2620 OID 508586)
-- Name: CycleParking set_last_update_details_CycleParking; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_CycleParking" BEFORE INSERT OR UPDATE ON "highway_assets"."CycleParking" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4385 (class 2620 OID 508587)
-- Name: DisplayBoards set_last_update_details_DisplayBoards; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_DisplayBoards" BEFORE INSERT OR UPDATE ON "highway_assets"."DisplayBoards" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4387 (class 2620 OID 508588)
-- Name: EV_ChargingPoints set_last_update_details_EV_ChargingPoints; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_EV_ChargingPoints" BEFORE INSERT OR UPDATE ON "highway_assets"."EV_ChargingPoints" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4389 (class 2620 OID 508589)
-- Name: EndOfStreetMarkings set_last_update_details_EndOfStreetMarkings; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_EndOfStreetMarkings" BEFORE INSERT OR UPDATE ON "highway_assets"."EndOfStreetMarkings" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4391 (class 2620 OID 508590)
-- Name: PedestrianRailings set_last_update_details_PedestrianRailings; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_PedestrianRailings" BEFORE INSERT OR UPDATE ON "highway_assets"."PedestrianRailings" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4393 (class 2620 OID 508591)
-- Name: StreetNamePlates set_last_update_details_StreetNamePlates; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_StreetNamePlates" BEFORE INSERT OR UPDATE ON "highway_assets"."StreetNamePlates" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4395 (class 2620 OID 508592)
-- Name: SubterraneanFeatures set_last_update_details_SubterraneanFeatures; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_SubterraneanFeatures" BEFORE INSERT OR UPDATE ON "highway_assets"."SubterraneanFeatures" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4397 (class 2620 OID 508593)
-- Name: TrafficCalming set_last_update_details_TrafficCalming; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_TrafficCalming" BEFORE INSERT OR UPDATE ON "highway_assets"."TrafficCalming" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4399 (class 2620 OID 508594)
-- Name: TrafficSignals set_last_update_details_TrafficSignals; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_TrafficSignals" BEFORE INSERT OR UPDATE ON "highway_assets"."TrafficSignals" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4401 (class 2620 OID 508596)
-- Name: UnidentifiedStaticObjects set_last_update_details_UnidentifiedStaticObjects; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_UnidentifiedStaticObjects" BEFORE INSERT OR UPDATE ON "highway_assets"."UnidentifiedStaticObjects" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4403 (class 2620 OID 508595)
-- Name: VehicleBarriers set_last_update_details_VehicleBarriers; Type: TRIGGER; Schema: highway_assets; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_VehicleBarriers" BEFORE INSERT OR UPDATE ON "highway_assets"."VehicleBarriers" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4356 (class 2606 OID 508510)
-- Name: HighwayAssets HighwayAssets_AssetConditionTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."HighwayAssets"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");


--
-- TOC entry 4358 (class 2606 OID 508515)
-- Name: Bins HighwayAssets_BinTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."Bins"
    ADD CONSTRAINT "HighwayAssets_BinTypeID_fkey" FOREIGN KEY ("BinTypeID") REFERENCES "highway_asset_lookups"."BinTypes"("Code");


--
-- TOC entry 4359 (class 2606 OID 508520)
-- Name: Bollards HighwayAssets_BollardTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."Bollards"
    ADD CONSTRAINT "HighwayAssets_BollardTypeID_fkey" FOREIGN KEY ("BollardTypeID") REFERENCES "highway_asset_lookups"."BollardTypes"("Code");


--
-- TOC entry 4364 (class 2606 OID 508525)
-- Name: EV_ChargingPoints HighwayAssets_BollardTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."EV_ChargingPoints"
    ADD CONSTRAINT "HighwayAssets_BollardTypeID_fkey" FOREIGN KEY ("EV_ChargingPointTypeID") REFERENCES "highway_asset_lookups"."EV_ChargingPointTypes"("Code");


--
-- TOC entry 4360 (class 2606 OID 508530)
-- Name: CommunicationCabinets HighwayAssets_CommunicationsCabinetTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."CommunicationCabinets"
    ADD CONSTRAINT "HighwayAssets_CommunicationsCabinetTypeID_fkey" FOREIGN KEY ("CommunicationCabinetTypeID") REFERENCES "highway_asset_lookups"."CommunicationCabinetTypes"("Code");


--
-- TOC entry 4361 (class 2606 OID 508535)
-- Name: CrossingPoints HighwayAssets_CrossingPointTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."CrossingPoints"
    ADD CONSTRAINT "HighwayAssets_CrossingPointTypeID_fkey" FOREIGN KEY ("CrossingPointTypeID") REFERENCES "highway_asset_lookups"."CrossingPointTypes"("Code");


--
-- TOC entry 4363 (class 2606 OID 508540)
-- Name: DisplayBoards HighwayAssets_DisplayBoardTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."DisplayBoards"
    ADD CONSTRAINT "HighwayAssets_DisplayBoardTypeID_fkey" FOREIGN KEY ("DisplayBoardTypeID") REFERENCES "highway_asset_lookups"."DisplayBoardTypes"("Code");


--
-- TOC entry 4365 (class 2606 OID 508545)
-- Name: EndOfStreetMarkings HighwayAssets_EndOfStreetMarkingTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."EndOfStreetMarkings"
    ADD CONSTRAINT "HighwayAssets_EndOfStreetMarkingTypeID_fkey" FOREIGN KEY ("EndOfStreetMarkingTypeID") REFERENCES "highway_asset_lookups"."EndOfStreetMarkingTypes"("Code");


--
-- TOC entry 4357 (class 2606 OID 508550)
-- Name: HighwayAssets HighwayAssets_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."HighwayAssets"
    ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4366 (class 2606 OID 508555)
-- Name: PedestrianRailings HighwayAssets_PedestrianRailingTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."PedestrianRailings"
    ADD CONSTRAINT "HighwayAssets_PedestrianRailingTypeID_fkey" FOREIGN KEY ("PedestrianRailingTypeID") REFERENCES "highway_asset_lookups"."EndOfStreetMarkingTypes"("Code");


--
-- TOC entry 4367 (class 2606 OID 508560)
-- Name: SubterraneanFeatures HighwayAssets_SubterraneanFeatureTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."SubterraneanFeatures"
    ADD CONSTRAINT "HighwayAssets_SubterraneanFeatureTypeID_fkey" FOREIGN KEY ("SubterraneanFeatureTypeID") REFERENCES "highway_asset_lookups"."SubterraneanFeatureTypes"("Code");


--
-- TOC entry 4368 (class 2606 OID 508565)
-- Name: TrafficCalming HighwayAssets_TrafficCalmingTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."TrafficCalming"
    ADD CONSTRAINT "HighwayAssets_TrafficCalmingTypeID_fkey" FOREIGN KEY ("TrafficCalmingTypeID") REFERENCES "highway_asset_lookups"."TrafficCalmingTypes"("Code");


--
-- TOC entry 4369 (class 2606 OID 508570)
-- Name: VehicleBarriers HighwayAssets_VehicleBarrierTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."VehicleBarriers"
    ADD CONSTRAINT "HighwayAssets_VehicleBarrierTypeID_fkey" FOREIGN KEY ("VehicleBarrierTypeID") REFERENCES "highway_asset_lookups"."VehicleBarrierTypes"("Code");


--
-- TOC entry 4362 (class 2606 OID 508575)
-- Name: CycleParking HighwayAssets_VehicleBarrierTypeID_fkey; Type: FK CONSTRAINT; Schema: highway_assets; Owner: postgres
--

ALTER TABLE ONLY "highway_assets"."CycleParking"
    ADD CONSTRAINT "HighwayAssets_VehicleBarrierTypeID_fkey" FOREIGN KEY ("CycleParkingTypeID") REFERENCES "highway_asset_lookups"."CycleParkingTypes"("Code");


-- Completed on 2020-07-27 23:06:58

--
-- PostgreSQL database dump complete
--

