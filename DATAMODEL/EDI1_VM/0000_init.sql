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
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: EDI_1000_Grid_2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."EDI_1000_Grid_2" (
    id bigint NOT NULL,
    geom public.geometry(MultiPolygon,27700),
    x_min numeric,
    x_max numeric,
    y_min numeric,
    y_max numeric
);


ALTER TABLE public."EDI_1000_Grid_2" OWNER TO postgres;

--
-- Name: EDI_AdoptedRoads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."EDI_AdoptedRoads" (
    id integer NOT NULL,
    geom public.geometry(Polygon,27700),
    "OBJECTID" integer,
    adoption_s character varying(41),
    area_sq_m double precision,
    confirmed character varying(3),
    primary_ns character varying(50),
    reinstatem character varying(26),
    speed_limi character varying(14),
    surface character varying(24),
    type character varying(28),
    width double precision,
    "Shape_Length" double precision,
    "Shape_Area" double precision
);


ALTER TABLE public."EDI_AdoptedRoads" OWNER TO postgres;

--
-- Name: EDI_AdoptedRoads_2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."EDI_AdoptedRoads_2" (
    id integer NOT NULL,
    geom public.geometry(Polygon,27700),
    "OBJECTID" integer,
    adoption_s character varying(41),
    area_sq_m double precision,
    confirmed character varying(3),
    primary_ns character varying(50),
    reinstatem character varying(26),
    speed_limi character varying(14),
    surface character varying(24),
    type character varying(28),
    width double precision,
    "Shape_Length" double precision,
    "Shape_Area" double precision
);


ALTER TABLE public."EDI_AdoptedRoads_2" OWNER TO postgres;

--
-- Name: EDI_AdoptedRoads_2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."EDI_AdoptedRoads_2_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."EDI_AdoptedRoads_2_id_seq" OWNER TO postgres;

--
-- Name: EDI_AdoptedRoads_2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."EDI_AdoptedRoads_2_id_seq" OWNED BY public."EDI_AdoptedRoads_2".id;


--
-- Name: EDI_AdoptedRoads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."EDI_AdoptedRoads_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."EDI_AdoptedRoads_id_seq" OWNER TO postgres;

--
-- Name: EDI_AdoptedRoads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."EDI_AdoptedRoads_id_seq" OWNED BY public."EDI_AdoptedRoads".id;


--
-- Name: EDI_RC_with_USRN_StreetNames; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."EDI_RC_with_USRN_StreetNames" (
    id integer NOT NULL,
    geom public.geometry(LineString,27700),
    "OBJECTID_1" integer,
    "MidPt_ID" integer,
    "ESUID" double precision,
    "USRN" integer,
    "StreetName" character varying(254),
    "Locality" character varying(255),
    "Town" character varying(255),
    "Shape_Length" double precision
);


ALTER TABLE public."EDI_RC_with_USRN_StreetNames" OWNER TO postgres;

--
-- Name: EDI_RC_with_USRN_StreetNames_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."EDI_RC_with_USRN_StreetNames_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."EDI_RC_with_USRN_StreetNames_id_seq" OWNER TO postgres;

--
-- Name: EDI_RC_with_USRN_StreetNames_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."EDI_RC_with_USRN_StreetNames_id_seq" OWNED BY public."EDI_RC_with_USRN_StreetNames".id;


--
-- Name: ParkingTariffAreas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ParkingTariffAreas" (
    id integer NOT NULL,
    geom public.geometry(Polygon,27700),
    tro_ref double precision,
    charge character varying(10),
    cost character varying(50),
    hours character varying(50),
    "Name" character varying(10),
    "NoReturnTimeID" integer,
    "MaxStayID" integer
);


ALTER TABLE public."ParkingTariffAreas" OWNER TO postgres;

--
-- Name: ParkingTariffAreas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ParkingTariffAreas_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ParkingTariffAreas_id_seq" OWNER TO postgres;

--
-- Name: ParkingTariffAreas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ParkingTariffAreas_id_seq" OWNED BY public."ParkingTariffAreas".id;


--
-- Name: Proposals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Proposals_id_seq"
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Proposals_id_seq" OWNER TO postgres;

--
-- Name: StreetGazetteerRecords_171231_USRN; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."StreetGazetteerRecords_171231_USRN" (
    gid integer NOT NULL,
    id numeric(10,0),
    "OBJECTID" numeric(10,0),
    "ESUID" numeric,
    "Record_Ide" numeric(10,0),
    "Change_Typ" character varying(254),
    "Pro_Order_" numeric(10,0),
    "USRN" numeric(10,0),
    "Record_Typ" numeric(10,0),
    "Custodian_" numeric(10,0),
    "State" character varying(254),
    "State_Date" character varying(24),
    "Street_Cla" character varying(254),
    "Street_Ent" character varying(24),
    "Street_Las" character varying(24),
    "Street_Sta" character varying(24),
    "Street_End" character varying(24),
    "Street_S_1" numeric,
    "Street_S_2" numeric,
    "Street_E_1" numeric,
    "Street_E_2" numeric,
    "Record_I_1" numeric(10,0),
    "Change_T_1" character varying(254),
    "Pro_Orde_1" numeric(10,0),
    "Xref_Type" numeric(10,0),
    "Xref_ID" numeric,
    "Entry_Date" character varying(24),
    "Start_Date" character varying(24),
    "End_Date" character varying(24),
    "Last_Updat" character varying(24),
    "Record_I_2" numeric(10,0),
    "Change_T_2" character varying(254),
    "Pro_Orde_2" numeric(10,0),
    "Descriptor_" character varying(254),
    "Locality" character varying(254),
    "Town" character varying(254),
    "Administra" character varying(254),
    "Language_" character varying(254),
    "Shape_Leng" numeric,
    geom public.geometry(MultiLineString,27700)
);


ALTER TABLE public."StreetGazetteerRecords_171231_USRN" OWNER TO postgres;

--
-- Name: city_of_edinburgh_area; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.city_of_edinburgh_area (
    gid integer NOT NULL,
    name character varying(32),
    geom public.geometry(MultiPolygon,27700)
);


ALTER TABLE public.city_of_edinburgh_area OWNER TO postgres;

--
-- Name: city_of_edinburgh_area_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.city_of_edinburgh_area_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.city_of_edinburgh_area_gid_seq OWNER TO postgres;

--
-- Name: city_of_edinburgh_area_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.city_of_edinburgh_area_gid_seq OWNED BY public.city_of_edinburgh_area.gid;


--
-- Name: edi_cartotext; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edi_cartotext (
    gid integer NOT NULL,
    toid character varying(20),
    featcode numeric(10,0),
    version numeric(10,0),
    verdate character varying(24),
    theme character varying(80),
    change character varying(80),
    descgroup character varying(150),
    descterm character varying(150),
    make character varying(20),
    physlevel numeric(10,0),
    physpres character varying(15),
    text_ character varying(250),
    textfont numeric(10,0),
    textpos numeric(10,0),
    textheight numeric,
    textangle numeric,
    loaddate character varying(24),
    objectid numeric(10,0),
    shape_leng numeric,
    geom public.geometry(MultiLineString,27700)
);


ALTER TABLE public.edi_cartotext OWNER TO postgres;

--
-- Name: edi_cartotext_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edi_cartotext_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.edi_cartotext_gid_seq OWNER TO postgres;

--
-- Name: edi_cartotext_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.edi_cartotext_gid_seq OWNED BY public.edi_cartotext.gid;


--
-- Name: edi_itn_roadcentreline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edi_itn_roadcentreline (
    gid integer NOT NULL,
    toid character varying(16),
    version numeric(10,0),
    verdate date,
    theme character varying(80),
    descgroup character varying(150),
    descterm character varying(150),
    change character varying(80),
    topoarea character varying(20),
    nature character varying(80),
    lnklength numeric,
    node1 character varying(20),
    node1grade character varying(1),
    node1gra_1 numeric(10,0),
    node2 character varying(20),
    node2grade character varying(1),
    node2gra_1 numeric(10,0),
    loaddate date,
    objectid numeric(10,0),
    shape_leng numeric,
    geom public.geometry(MultiLineString,27700)
);


ALTER TABLE public.edi_itn_roadcentreline OWNER TO postgres;

--
-- Name: edi_itn_roadcentreline_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edi_itn_roadcentreline_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.edi_itn_roadcentreline_gid_seq OWNER TO postgres;

--
-- Name: edi_itn_roadcentreline_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.edi_itn_roadcentreline_gid_seq OWNED BY public.edi_itn_roadcentreline.gid;


--
-- Name: edi_mm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edi_mm (
    gid integer NOT NULL,
    toid character varying(20),
    version numeric(10,0),
    verdate character varying(24),
    featcode numeric(10,0),
    theme character varying(80),
    calcarea numeric,
    change character varying(80),
    descgroup character varying(150),
    descterm character varying(150),
    make character varying(20),
    physlevel numeric(10,0),
    physpres character varying(20),
    broken integer,
    loaddate character varying(24),
    objectid numeric(10,0),
    shape_leng numeric,
    shape_area numeric,
    geom public.geometry(MultiPolygon,27700)
);


ALTER TABLE public.edi_mm OWNER TO postgres;

--
-- Name: edi_mm_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edi_mm_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.edi_mm_gid_seq OWNER TO postgres;

--
-- Name: edi_mm_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.edi_mm_gid_seq OWNED BY public.edi_mm.gid;


--
-- Name: edingburghcpzs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edingburghcpzs (
    gid integer NOT NULL,
    cacz_ref_n character varying(2),
    date_last_ character varying(10),
    no_osp_spa numeric(10,0),
    no_pnr_spa numeric(10,0),
    no_pub_spa numeric(10,0),
    no_res_spa numeric(10,0),
    zone_no character varying(40),
    type character varying(40),
    geom public.geometry(MultiPolygon,27700),
    "Hours" character varying(255),
    "WaitingTimeID" integer
);


ALTER TABLE public.edingburghcpzs OWNER TO postgres;

--
-- Name: edingburghcpzs_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edingburghcpzs_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.edingburghcpzs_gid_seq OWNER TO postgres;

--
-- Name: edingburghcpzs_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.edingburghcpzs_gid_seq OWNED BY public.edingburghcpzs.gid;


--
-- Name: gaz_usrn_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gaz_usrn_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gaz_usrn_gid_seq OWNER TO postgres;

--
-- Name: gaz_usrn_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gaz_usrn_gid_seq OWNED BY public."StreetGazetteerRecords_171231_USRN".gid;


--
-- Name: EDI_AdoptedRoads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EDI_AdoptedRoads" ALTER COLUMN id SET DEFAULT nextval('public."EDI_AdoptedRoads_id_seq"'::regclass);


--
-- Name: EDI_AdoptedRoads_2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EDI_AdoptedRoads_2" ALTER COLUMN id SET DEFAULT nextval('public."EDI_AdoptedRoads_2_id_seq"'::regclass);


--
-- Name: EDI_RC_with_USRN_StreetNames id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EDI_RC_with_USRN_StreetNames" ALTER COLUMN id SET DEFAULT nextval('public."EDI_RC_with_USRN_StreetNames_id_seq"'::regclass);


--
-- Name: ParkingTariffAreas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingTariffAreas" ALTER COLUMN id SET DEFAULT nextval('public."ParkingTariffAreas_id_seq"'::regclass);


--
-- Name: StreetGazetteerRecords_171231_USRN gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."StreetGazetteerRecords_171231_USRN" ALTER COLUMN gid SET DEFAULT nextval('public.gaz_usrn_gid_seq'::regclass);


--
-- Name: city_of_edinburgh_area gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city_of_edinburgh_area ALTER COLUMN gid SET DEFAULT nextval('public.city_of_edinburgh_area_gid_seq'::regclass);


--
-- Name: edi_cartotext gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edi_cartotext ALTER COLUMN gid SET DEFAULT nextval('public.edi_cartotext_gid_seq'::regclass);


--
-- Name: edi_itn_roadcentreline gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edi_itn_roadcentreline ALTER COLUMN gid SET DEFAULT nextval('public.edi_itn_roadcentreline_gid_seq'::regclass);


--
-- Name: edi_mm gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edi_mm ALTER COLUMN gid SET DEFAULT nextval('public.edi_mm_gid_seq'::regclass);


--
-- Name: edingburghcpzs gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edingburghcpzs ALTER COLUMN gid SET DEFAULT nextval('public.edingburghcpzs_gid_seq'::regclass);


--
-- Name: EDI_1000_Grid_2 EDI_1000_Grid_2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EDI_1000_Grid_2"
    ADD CONSTRAINT "EDI_1000_Grid_2_pkey" PRIMARY KEY (id);


--
-- Name: EDI_AdoptedRoads_2 EDI_AdoptedRoads_2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EDI_AdoptedRoads_2"
    ADD CONSTRAINT "EDI_AdoptedRoads_2_pkey" PRIMARY KEY (id);


--
-- Name: EDI_AdoptedRoads EDI_AdoptedRoads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EDI_AdoptedRoads"
    ADD CONSTRAINT "EDI_AdoptedRoads_pkey" PRIMARY KEY (id);


--
-- Name: EDI_RC_with_USRN_StreetNames EDI_RC_with_USRN_StreetNames_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EDI_RC_with_USRN_StreetNames"
    ADD CONSTRAINT "EDI_RC_with_USRN_StreetNames_pkey" PRIMARY KEY (id);


--
-- Name: ParkingTariffAreas ParkingTariffAreas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_pkey" PRIMARY KEY (id);


--
-- Name: city_of_edinburgh_area city_of_edinburgh_area_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city_of_edinburgh_area
    ADD CONSTRAINT city_of_edinburgh_area_pkey PRIMARY KEY (gid);


--
-- Name: edi_cartotext edi_cartotext_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edi_cartotext
    ADD CONSTRAINT edi_cartotext_pkey PRIMARY KEY (gid);


--
-- Name: edi_itn_roadcentreline edi_itn_roadcentreline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edi_itn_roadcentreline
    ADD CONSTRAINT edi_itn_roadcentreline_pkey PRIMARY KEY (gid);


--
-- Name: edi_mm edi_mm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edi_mm
    ADD CONSTRAINT edi_mm_pkey PRIMARY KEY (gid);


--
-- Name: edingburghcpzs edingburghcpzs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edingburghcpzs
    ADD CONSTRAINT edingburghcpzs_pkey PRIMARY KEY (gid);


--
-- Name: StreetGazetteerRecords_171231_USRN gaz_usrn_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."StreetGazetteerRecords_171231_USRN"
    ADD CONSTRAINT gaz_usrn_pkey PRIMARY KEY (gid);


--
-- Name: city_of_edinburgh_area_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX city_of_edinburgh_area_geom_idx ON public.city_of_edinburgh_area USING gist (geom);


--
-- Name: edi_cartotext_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX edi_cartotext_geom_idx ON public.edi_cartotext USING gist (geom);


--
-- Name: edi_itn_roadcentreline_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX edi_itn_roadcentreline_geom_idx ON public.edi_itn_roadcentreline USING gist (geom);


--
-- Name: edi_mm_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX edi_mm_geom_idx ON public.edi_mm USING gist (geom);


--
-- Name: edingburghcpzs_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX edingburghcpzs_geom_idx ON public.edingburghcpzs USING gist (geom);


--
-- Name: gaz_usrn_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gaz_usrn_geom_idx ON public."StreetGazetteerRecords_171231_USRN" USING gist (geom);


--
-- Name: sidx_EDI_1000_Grid_2_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_EDI_1000_Grid_2_geom" ON public."EDI_1000_Grid_2" USING gist (geom);


--
-- Name: sidx_EDI_RC_with_USRN_StreetNames_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_EDI_RC_with_USRN_StreetNames_geom" ON public."EDI_RC_with_USRN_StreetNames" USING gist (geom);


--
-- Name: sidx_ParkingTariffAreas_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_ParkingTariffAreas_geom" ON public."ParkingTariffAreas" USING gist (geom);


--
-- Name: TABLE "EDI_1000_Grid_2"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."EDI_1000_Grid_2" TO edi_operator;
GRANT SELECT ON TABLE public."EDI_1000_Grid_2" TO edi_public;
GRANT SELECT ON TABLE public."EDI_1000_Grid_2" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."EDI_1000_Grid_2" TO edi_admin;


--
-- Name: TABLE "EDI_AdoptedRoads"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."EDI_AdoptedRoads" TO edi_public;
GRANT SELECT ON TABLE public."EDI_AdoptedRoads" TO edi_admin;
GRANT SELECT ON TABLE public."EDI_AdoptedRoads" TO edi_operator;
GRANT SELECT ON TABLE public."EDI_AdoptedRoads" TO edi_public_nsl;


--
-- Name: TABLE "EDI_AdoptedRoads_2"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."EDI_AdoptedRoads_2" TO edi_public;
GRANT SELECT ON TABLE public."EDI_AdoptedRoads_2" TO edi_admin;
GRANT SELECT ON TABLE public."EDI_AdoptedRoads_2" TO edi_operator;
GRANT SELECT ON TABLE public."EDI_AdoptedRoads_2" TO edi_public_nsl;


--
-- Name: SEQUENCE "EDI_AdoptedRoads_2_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."EDI_AdoptedRoads_2_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."EDI_AdoptedRoads_2_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."EDI_AdoptedRoads_2_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."EDI_AdoptedRoads_2_id_seq" TO edi_public_nsl;


--
-- Name: SEQUENCE "EDI_AdoptedRoads_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."EDI_AdoptedRoads_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."EDI_AdoptedRoads_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."EDI_AdoptedRoads_id_seq" TO edi_admin;
GRANT SELECT,USAGE ON SEQUENCE public."EDI_AdoptedRoads_id_seq" TO edi_public_nsl;


--
-- Name: TABLE "EDI_RC_with_USRN_StreetNames"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."EDI_RC_with_USRN_StreetNames" TO edi_operator;
GRANT SELECT ON TABLE public."EDI_RC_with_USRN_StreetNames" TO edi_public;
GRANT SELECT ON TABLE public."EDI_RC_with_USRN_StreetNames" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."EDI_RC_with_USRN_StreetNames" TO edi_admin;


--
-- Name: SEQUENCE "EDI_RC_with_USRN_StreetNames_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."EDI_RC_with_USRN_StreetNames_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."EDI_RC_with_USRN_StreetNames_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."EDI_RC_with_USRN_StreetNames_id_seq" TO edi_public_nsl;
GRANT SELECT,USAGE ON SEQUENCE public."EDI_RC_with_USRN_StreetNames_id_seq" TO edi_admin;


--
-- Name: TABLE "ParkingTariffAreas"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."ParkingTariffAreas" TO edi_operator;
GRANT SELECT ON TABLE public."ParkingTariffAreas" TO edi_public;
GRANT SELECT ON TABLE public."ParkingTariffAreas" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."ParkingTariffAreas" TO edi_admin;


--
-- Name: SEQUENCE "ParkingTariffAreas_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."ParkingTariffAreas_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."ParkingTariffAreas_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."ParkingTariffAreas_id_seq" TO edi_public_nsl;
GRANT SELECT,USAGE ON SEQUENCE public."ParkingTariffAreas_id_seq" TO edi_admin;


--
-- Name: SEQUENCE "Proposals_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public."Proposals_id_seq" TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public."Proposals_id_seq" TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public."Proposals_id_seq" TO edi_public_nsl;
GRANT SELECT,USAGE ON SEQUENCE public."Proposals_id_seq" TO edi_admin;


--
-- Name: TABLE "StreetGazetteerRecords_171231_USRN"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."StreetGazetteerRecords_171231_USRN" TO edi_operator;
GRANT SELECT ON TABLE public."StreetGazetteerRecords_171231_USRN" TO edi_public;
GRANT SELECT ON TABLE public."StreetGazetteerRecords_171231_USRN" TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public."StreetGazetteerRecords_171231_USRN" TO edi_admin;


--
-- Name: TABLE city_of_edinburgh_area; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.city_of_edinburgh_area TO edi_operator;
GRANT SELECT ON TABLE public.city_of_edinburgh_area TO edi_public;
GRANT SELECT ON TABLE public.city_of_edinburgh_area TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public.city_of_edinburgh_area TO edi_admin;


--
-- Name: SEQUENCE city_of_edinburgh_area_gid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.city_of_edinburgh_area_gid_seq TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.city_of_edinburgh_area_gid_seq TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.city_of_edinburgh_area_gid_seq TO edi_public_nsl;
GRANT SELECT,USAGE ON SEQUENCE public.city_of_edinburgh_area_gid_seq TO edi_admin;


--
-- Name: TABLE edi_cartotext; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.edi_cartotext TO edi_operator;
GRANT SELECT ON TABLE public.edi_cartotext TO edi_public;
GRANT SELECT ON TABLE public.edi_cartotext TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public.edi_cartotext TO edi_admin;


--
-- Name: SEQUENCE edi_cartotext_gid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.edi_cartotext_gid_seq TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.edi_cartotext_gid_seq TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.edi_cartotext_gid_seq TO edi_public_nsl;
GRANT SELECT,USAGE ON SEQUENCE public.edi_cartotext_gid_seq TO edi_admin;


--
-- Name: TABLE edi_itn_roadcentreline; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.edi_itn_roadcentreline TO edi_operator;
GRANT SELECT ON TABLE public.edi_itn_roadcentreline TO edi_public;
GRANT SELECT ON TABLE public.edi_itn_roadcentreline TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public.edi_itn_roadcentreline TO edi_admin;


--
-- Name: SEQUENCE edi_itn_roadcentreline_gid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.edi_itn_roadcentreline_gid_seq TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.edi_itn_roadcentreline_gid_seq TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.edi_itn_roadcentreline_gid_seq TO edi_public_nsl;
GRANT SELECT,USAGE ON SEQUENCE public.edi_itn_roadcentreline_gid_seq TO edi_admin;


--
-- Name: TABLE edi_mm; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.edi_mm TO edi_operator;
GRANT SELECT ON TABLE public.edi_mm TO edi_public;
GRANT SELECT ON TABLE public.edi_mm TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public.edi_mm TO edi_admin;


--
-- Name: SEQUENCE edi_mm_gid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.edi_mm_gid_seq TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.edi_mm_gid_seq TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.edi_mm_gid_seq TO edi_public_nsl;
GRANT SELECT,USAGE ON SEQUENCE public.edi_mm_gid_seq TO edi_admin;


--
-- Name: TABLE edingburghcpzs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.edingburghcpzs TO edi_operator;
GRANT SELECT ON TABLE public.edingburghcpzs TO edi_public;
GRANT SELECT ON TABLE public.edingburghcpzs TO edi_public_nsl;
GRANT SELECT,INSERT,UPDATE ON TABLE public.edingburghcpzs TO edi_admin;


--
-- Name: SEQUENCE edingburghcpzs_gid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.edingburghcpzs_gid_seq TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.edingburghcpzs_gid_seq TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.edingburghcpzs_gid_seq TO edi_public_nsl;
GRANT SELECT,USAGE ON SEQUENCE public.edingburghcpzs_gid_seq TO edi_admin;


--
-- Name: SEQUENCE gaz_usrn_gid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.gaz_usrn_gid_seq TO edi_operator;
GRANT SELECT,USAGE ON SEQUENCE public.gaz_usrn_gid_seq TO edi_public;
GRANT SELECT,USAGE ON SEQUENCE public.gaz_usrn_gid_seq TO edi_public_nsl;
GRANT SELECT,USAGE ON SEQUENCE public.gaz_usrn_gid_seq TO edi_admin;


--
-- PostgreSQL database dump complete
--

