--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-07-28 07:04:14

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
-- TOC entry 14 (class 2615 OID 506632)
-- Name: highway_asset_lookups; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "highway_asset_lookups";


ALTER SCHEMA "highway_asset_lookups" OWNER TO "postgres";

--
-- TOC entry 381 (class 1259 OID 506633)
-- Name: AssetConditionTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."AssetConditionTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."AssetConditionTypes_Code_seq" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 382 (class 1259 OID 506635)
-- Name: AssetConditionTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."AssetConditionTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."AssetConditionTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "highway_asset_lookups"."AssetConditionTypes" OWNER TO "postgres";

--
-- TOC entry 383 (class 1259 OID 506639)
-- Name: BinTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."BinTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."BinTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 384 (class 1259 OID 506641)
-- Name: BinTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."BinTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."BinTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "highway_asset_lookups"."BinTypes" OWNER TO "postgres";

--
-- TOC entry 385 (class 1259 OID 506648)
-- Name: BollardTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."BollardTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."BollardTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 386 (class 1259 OID 506650)
-- Name: BollardTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."BollardTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."BollardTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "highway_asset_lookups"."BollardTypes" OWNER TO "postgres";

--
-- TOC entry 387 (class 1259 OID 506657)
-- Name: CommunicationCabinetTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."CommunicationCabinetTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."CommunicationCabinetTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 388 (class 1259 OID 506659)
-- Name: CommunicationCabinetTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."CommunicationCabinetTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."CommunicationCabinetTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "highway_asset_lookups"."CommunicationCabinetTypes" OWNER TO "postgres";

--
-- TOC entry 389 (class 1259 OID 506666)
-- Name: CrossingPointTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."CrossingPointTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."CrossingPointTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 390 (class 1259 OID 506668)
-- Name: CrossingPointTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."CrossingPointTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."CrossingPointTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "highway_asset_lookups"."CrossingPointTypes" OWNER TO "postgres";

--
-- TOC entry 391 (class 1259 OID 506675)
-- Name: CycleParkingTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."CycleParkingTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."CycleParkingTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 392 (class 1259 OID 506677)
-- Name: CycleParkingTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."CycleParkingTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."CycleParkingTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "highway_asset_lookups"."CycleParkingTypes" OWNER TO "postgres";

--
-- TOC entry 393 (class 1259 OID 506684)
-- Name: DisplayBoardTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."DisplayBoardTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."DisplayBoardTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 394 (class 1259 OID 506686)
-- Name: DisplayBoardTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."DisplayBoardTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."DisplayBoardTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "highway_asset_lookups"."DisplayBoardTypes" OWNER TO "postgres";

--
-- TOC entry 395 (class 1259 OID 506693)
-- Name: EV_ChargingPointTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."EV_ChargingPointTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."EV_ChargingPointTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 396 (class 1259 OID 506695)
-- Name: EV_ChargingPointTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."EV_ChargingPointTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."EV_ChargingPointTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "highway_asset_lookups"."EV_ChargingPointTypes" OWNER TO "postgres";

--
-- TOC entry 397 (class 1259 OID 506702)
-- Name: EndOfStreetMarkingTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."EndOfStreetMarkingTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."EndOfStreetMarkingTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 398 (class 1259 OID 506704)
-- Name: EndOfStreetMarkingTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."EndOfStreetMarkingTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."EndOfStreetMarkingTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "highway_asset_lookups"."EndOfStreetMarkingTypes" OWNER TO "postgres";

--
-- TOC entry 399 (class 1259 OID 506711)
-- Name: PedestrianRailingsTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."PedestrianRailingsTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."PedestrianRailingsTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 400 (class 1259 OID 506713)
-- Name: PedestrianRailingsTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."PedestrianRailingsTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."PedestrianRailingsTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "highway_asset_lookups"."PedestrianRailingsTypes" OWNER TO "postgres";

--
-- TOC entry 401 (class 1259 OID 506720)
-- Name: SubterraneanFeatureTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."SubterraneanFeatureTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."SubterraneanFeatureTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 402 (class 1259 OID 506722)
-- Name: SubterraneanFeatureTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."SubterraneanFeatureTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."SubterraneanFeatureTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "highway_asset_lookups"."SubterraneanFeatureTypes" OWNER TO "postgres";

--
-- TOC entry 403 (class 1259 OID 506729)
-- Name: TrafficCalmingTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."TrafficCalmingTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."TrafficCalmingTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 404 (class 1259 OID 506731)
-- Name: TrafficCalmingTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."TrafficCalmingTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."TrafficCalmingTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "highway_asset_lookups"."TrafficCalmingTypes" OWNER TO "postgres";

--
-- TOC entry 405 (class 1259 OID 506738)
-- Name: VehicleBarrierTypes_Code_seq; Type: SEQUENCE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE SEQUENCE "highway_asset_lookups"."VehicleBarrierTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."VehicleBarrierTypes_Code_seq" OWNER TO "postgres";

--
-- TOC entry 406 (class 1259 OID 506740)
-- Name: VehicleBarrierTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."VehicleBarrierTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."VehicleBarrierTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying
);


ALTER TABLE "highway_asset_lookups"."VehicleBarrierTypes" OWNER TO "postgres";

--
-- TOC entry 4300 (class 2606 OID 506748)
-- Name: DisplayBoardTypes AdvertisingBoardTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."DisplayBoardTypes"
    ADD CONSTRAINT "AdvertisingBoardTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4288 (class 2606 OID 506750)
-- Name: AssetConditionTypes AssetConditionTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."AssetConditionTypes"
    ADD CONSTRAINT "AssetConditionTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4290 (class 2606 OID 506752)
-- Name: BinTypes BinTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."BinTypes"
    ADD CONSTRAINT "BinTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4292 (class 2606 OID 506754)
-- Name: BollardTypes BollardTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."BollardTypes"
    ADD CONSTRAINT "BollardTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4294 (class 2606 OID 506756)
-- Name: CommunicationCabinetTypes CommunicationCabinetTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."CommunicationCabinetTypes"
    ADD CONSTRAINT "CommunicationCabinetTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4296 (class 2606 OID 506758)
-- Name: CrossingPointTypes CrossingPointTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."CrossingPointTypes"
    ADD CONSTRAINT "CrossingPointTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4298 (class 2606 OID 506760)
-- Name: CycleParkingTypes CycleParkingTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."CycleParkingTypes"
    ADD CONSTRAINT "CycleParkingTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4302 (class 2606 OID 506762)
-- Name: EV_ChargingPointTypes EV_ChargingPointTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."EV_ChargingPointTypes"
    ADD CONSTRAINT "EV_ChargingPointTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4304 (class 2606 OID 506764)
-- Name: EndOfStreetMarkingTypes EndOfStreetMarkingTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."EndOfStreetMarkingTypes"
    ADD CONSTRAINT "EndOfStreetMarkingTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4306 (class 2606 OID 506766)
-- Name: PedestrianRailingsTypes PedestrianRailingsTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."PedestrianRailingsTypes"
    ADD CONSTRAINT "PedestrianRailingsTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4308 (class 2606 OID 506768)
-- Name: SubterraneanFeatureTypes SubterraneanFeatureTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."SubterraneanFeatureTypes"
    ADD CONSTRAINT "SubterraneanFeatureTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4310 (class 2606 OID 506770)
-- Name: TrafficCalmingTypes TrafficCalmingTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."TrafficCalmingTypes"
    ADD CONSTRAINT "TrafficCalmingTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4312 (class 2606 OID 506772)
-- Name: VehicleBarrierTypes VehicleBarriersTypes_pkey; Type: CONSTRAINT; Schema: highway_asset_lookups; Owner: postgres
--

ALTER TABLE ONLY "highway_asset_lookups"."VehicleBarrierTypes"
    ADD CONSTRAINT "VehicleBarriersTypes_pkey" PRIMARY KEY ("Code");


-- Completed on 2020-07-28 07:04:14

--
-- PostgreSQL database dump complete
--

CREATE SEQUENCE "highway_asset_lookups"."UnidentifiedStaticObjectTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."UnidentifiedStaticObjectTypes_Code_seq" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 382 (class 1259 OID 506635)
-- Name: AssetConditionTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."UnidentifiedStaticObjectTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."UnidentifiedStaticObjectTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying(255)
);


ALTER TABLE "highway_asset_lookups"."UnidentifiedStaticObjectTypes" OWNER TO "postgres";

ALTER TABLE highway_asset_lookups."UnidentifiedStaticObjectTypes"
    ADD PRIMARY KEY ("Code");