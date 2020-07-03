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
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 15 (class 2615 OID 350398)
-- Name: moving_traffic_lookups; Type: SCHEMA; Schema: -; Owner: tim.hancock
--

CREATE SCHEMA "moving_traffic_lookups";


ALTER SCHEMA "moving_traffic_lookups" OWNER TO "postgres";

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
-- TOC entry 4170 (class 0 OID 0)
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
    "Description" character varying
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
-- TOC entry 4171 (class 0 OID 0)
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
    "Description" character varying
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
-- TOC entry 4172 (class 0 OID 0)
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
    "Description" character varying
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
-- TOC entry 4173 (class 0 OID 0)
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
    "Description" character varying
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
-- TOC entry 4174 (class 0 OID 0)
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
-- TOC entry 4175 (class 0 OID 0)
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
-- TOC entry 4176 (class 0 OID 0)
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
    "Description" character varying
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
-- TOC entry 4177 (class 0 OID 0)
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
    "Description" character varying
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
-- TOC entry 4178 (class 0 OID 0)
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
    "Description" character varying
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
-- TOC entry 4179 (class 0 OID 0)
-- Dependencies: 344
-- Name: VehicleQualifiers_Code_seq; Type: SEQUENCE OWNED BY; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER SEQUENCE "moving_traffic_lookups"."VehicleQualifiers_Code_seq" OWNED BY "moving_traffic_lookups"."VehicleQualifiers"."Code";


--
-- TOC entry 3968 (class 2604 OID 350473)
-- Name: SpecialDesignationTypes Code; Type: DEFAULT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpecialDesignationTypes" ALTER COLUMN "Code" SET DEFAULT "nextval"('"moving_traffic_lookups"."SpecialDesignationTypes_Code_seq"'::"regclass");


--
-- TOC entry 3970 (class 2606 OID 350548)
-- Name: AccessRestrictionValues AccessRestrictionValue_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."AccessRestrictionValues"
    ADD CONSTRAINT "AccessRestrictionValue_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 3972 (class 2606 OID 350525)
-- Name: AccessRestrictionValues AccessRestrictionValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."AccessRestrictionValues"
    ADD CONSTRAINT "AccessRestrictionValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 3974 (class 2606 OID 350527)
-- Name: CycleFacilityValues CycleFacilityValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."CycleFacilityValues"
    ADD CONSTRAINT "CycleFacilityValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 3976 (class 2606 OID 350509)
-- Name: CycleFacilityValues CycleFacilityValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."CycleFacilityValues"
    ADD CONSTRAINT "CycleFacilityValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 3978 (class 2606 OID 350529)
-- Name: DedicationValues DedicationValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."DedicationValues"
    ADD CONSTRAINT "DedicationValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 3980 (class 2606 OID 350511)
-- Name: DedicationValues DedicationValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."DedicationValues"
    ADD CONSTRAINT "DedicationValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 3982 (class 2606 OID 350531)
-- Name: LinkDirectionValues LinkDirectionValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."LinkDirectionValues"
    ADD CONSTRAINT "LinkDirectionValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 3984 (class 2606 OID 350513)
-- Name: LinkDirectionValues LinkDirectionValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."LinkDirectionValues"
    ADD CONSTRAINT "LinkDirectionValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 3986 (class 2606 OID 350533)
-- Name: RestrictionTypeValues RestrictionTypeValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."RestrictionTypeValues"
    ADD CONSTRAINT "RestrictionTypeValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 3988 (class 2606 OID 350515)
-- Name: RestrictionTypeValues RestrictionTypeValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."RestrictionTypeValues"
    ADD CONSTRAINT "RestrictionTypeValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 3990 (class 2606 OID 350538)
-- Name: SpecialDesignationTypes SpecialDesignationTypes_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpecialDesignationTypes"
    ADD CONSTRAINT "SpecialDesignationTypes_Description_key" UNIQUE ("Description");


--
-- TOC entry 3992 (class 2606 OID 350475)
-- Name: SpecialDesignationTypes SpecialDesignationTypes_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpecialDesignationTypes"
    ADD CONSTRAINT "SpecialDesignationTypes_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 3994 (class 2606 OID 350540)
-- Name: SpeedLimitValues SpeedLimitValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpeedLimitValues"
    ADD CONSTRAINT "SpeedLimitValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 3996 (class 2606 OID 350559)
-- Name: SpeedLimitValues SpeedLimitValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."SpeedLimitValues"
    ADD CONSTRAINT "SpeedLimitValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 3998 (class 2606 OID 350542)
-- Name: StructureTypeValues StructureTypeValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."StructureTypeValues"
    ADD CONSTRAINT "StructureTypeValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4000 (class 2606 OID 350519)
-- Name: StructureTypeValues StructureTypeValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."StructureTypeValues"
    ADD CONSTRAINT "StructureTypeValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4002 (class 2606 OID 350544)
-- Name: TurnRestrictionValues TurnRestrictionValues_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."TurnRestrictionValues"
    ADD CONSTRAINT "TurnRestrictionValues_Description_key" UNIQUE ("Description");


--
-- TOC entry 4004 (class 2606 OID 350521)
-- Name: TurnRestrictionValues TurnRestrictionValues_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."TurnRestrictionValues"
    ADD CONSTRAINT "TurnRestrictionValues_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 4006 (class 2606 OID 350546)
-- Name: VehicleQualifiers VehicleQualifiers_Description_key; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."VehicleQualifiers"
    ADD CONSTRAINT "VehicleQualifiers_Description_key" UNIQUE ("Description");


--
-- TOC entry 4008 (class 2606 OID 350523)
-- Name: VehicleQualifiers VehicleQualifiers_pkey; Type: CONSTRAINT; Schema: moving_traffic_lookups; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic_lookups"."VehicleQualifiers"
    ADD CONSTRAINT "VehicleQualifiers_pkey" PRIMARY KEY ("Code");


-- Completed on 2020-07-03 20:12:49

--
-- PostgreSQL database dump complete
--

