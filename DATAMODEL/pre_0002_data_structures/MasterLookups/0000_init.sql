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
-- Name: postgres_fdw; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgres_fdw WITH SCHEMA public;


--
-- Name: EXTENSION postgres_fdw; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgres_fdw IS 'foreign-data wrapper for remote PostgreSQL servers';


--
-- Name: BayLineTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."BayLineTypes_id_seq"
    START WITH 75
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."BayLineTypes_id_seq" OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: BayLineTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BayLineTypes" (
    id integer DEFAULT nextval('public."BayLineTypes_id_seq"'::regclass) NOT NULL,
    "OrigCode" integer,
    "Description" character varying,
    "Code" integer
);


ALTER TABLE public."BayLineTypes" OWNER TO postgres;

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
-- Name: ParkingTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ParkingTypes" (
    id integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE public."ParkingTypes" OWNER TO postgres;

--
-- Name: ParkingTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ParkingTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ParkingTypes_id_seq" OWNER TO postgres;

--
-- Name: ParkingTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ParkingTypes_id_seq" OWNED BY public."ParkingTypes".id;


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
-- Name: RestrictionShapeTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RestrictionShapeTypes" (
    id integer NOT NULL,
    "Code" bigint,
    "Description" character varying
);


ALTER TABLE public."RestrictionShapeTypes" OWNER TO postgres;

--
-- Name: SignTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."SignTypes_id_seq"
    START WITH 50
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SignTypes_id_seq" OWNER TO postgres;

--
-- Name: SignTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SignTypes" (
    id integer DEFAULT nextval('public."SignTypes_id_seq"'::regclass) NOT NULL,
    "Code" character varying,
    "Description" character varying,
    "Icon" character varying(255),
    "Category" integer,
    "MovingOrders" boolean,
    "StaticOrders" boolean
);


ALTER TABLE public."SignTypes" OWNER TO postgres;

--
-- Name: TimePeriods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."TimePeriods_id_seq"
    START WITH 295
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."TimePeriods_id_seq" OWNER TO postgres;

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
-- Name: UnacceptabilityTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UnacceptabilityTypes" (
    id integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE public."UnacceptabilityTypes" OWNER TO postgres;

--
-- Name: VehicleTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."VehicleTypes" (
    id integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE public."VehicleTypes" OWNER TO postgres;

--
-- Name: VehicleTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."VehicleTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."VehicleTypes_id_seq" OWNER TO postgres;

--
-- Name: VehicleTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."VehicleTypes_id_seq" OWNED BY public."VehicleTypes".id;


--
-- Name: ParkingTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingTypes" ALTER COLUMN id SET DEFAULT nextval('public."ParkingTypes_id_seq"'::regclass);


--
-- Name: VehicleTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VehicleTypes" ALTER COLUMN id SET DEFAULT nextval('public."VehicleTypes_id_seq"'::regclass);


--
-- Name: BayLineTypes BayLineTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BayLineTypes"
    ADD CONSTRAINT "BayLineTypes_pkey" PRIMARY KEY (id);


--
-- Name: LengthOfTime LengthOfTime_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LengthOfTime"
    ADD CONSTRAINT "LengthOfTime_pkey" PRIMARY KEY (id);


--
-- Name: ParkingTypes ParkingTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingTypes"
    ADD CONSTRAINT "ParkingTypes_pkey" PRIMARY KEY (id);


--
-- Name: PaymentTypes PaymentTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PaymentTypes"
    ADD CONSTRAINT "PaymentTypes_pkey" PRIMARY KEY (id);


--
-- Name: RestrictionShapeTypes RestrictionShapeTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RestrictionShapeTypes"
    ADD CONSTRAINT "RestrictionShapeTypes_pkey" PRIMARY KEY (id);


--
-- Name: SignTypes SignTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SignTypes"
    ADD CONSTRAINT "SignTypes_pkey" PRIMARY KEY (id);


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
-- Name: UnacceptabilityTypes UnacceptabilityTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UnacceptabilityTypes"
    ADD CONSTRAINT "UnacceptabilityTypes_pkey" PRIMARY KEY (id);


--
-- Name: VehicleTypes VehicleTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VehicleTypes"
    ADD CONSTRAINT "VehicleTypes_pkey" PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

