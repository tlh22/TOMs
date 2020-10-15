--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-05-29 22:56:33

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

SET default_table_access_method = "heap";

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
-- TOC entry 4414 (class 0 OID 0)
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
-- TOC entry 4415 (class 0 OID 0)
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
-- TOC entry 4416 (class 0 OID 0)
-- Dependencies: 256
-- Name: RC_Sections_merged_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RC_Sections_merged_gid_seq" OWNED BY "public"."RC_Sections_merged"."gid";

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
-- TOC entry 4433 (class 0 OID 0)
-- Dependencies: 321
-- Name: RC_Polygon_id_seq; Type: SEQUENCE OWNED BY; Schema: transfer; Owner: postgres
--

ALTER SEQUENCE "transfer"."RC_Polygon_id_seq" OWNED BY "transfer"."RC_Polygon"."id";


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


ALTER TABLE ONLY "transfer"."RC_Polygon" ALTER COLUMN "id" SET DEFAULT "nextval"('"transfer"."RC_Polygon_id_seq"'::"regclass");

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
-- TOC entry 4177 (class 2606 OID 222567)
-- Name: RC_Polygon RC_Polygon_pkey; Type: CONSTRAINT; Schema: transfer; Owner: postgres
--

ALTER TABLE ONLY "transfer"."RC_Polygon"
    ADD CONSTRAINT "RC_Polygon_pkey" PRIMARY KEY ("id");

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

-- Add view for gazetteer lookup
CREATE MATERIALIZED VIEW local_authority."StreetGazetteerView"
TABLESPACE pg_default
AS
    SELECT row_number() OVER (PARTITION BY true::boolean) AS id,
    name AS "RoadName", "Locality", geometry As geom
	FROM local_authority."StreetGazetteerRecords"
WITH DATA;

ALTER TABLE local_authority."StreetGazetteerView"
    OWNER TO postgres;

CREATE UNIQUE INDEX "idx_StreetGazetteerView_id"
    ON local_authority."StreetGazetteerView" USING btree
    (id)
    TABLESPACE pg_default;

CREATE INDEX idx_street_name
ON local_authority."StreetGazetteerView"("RoadName");


-- refresh views

REFRESH MATERIALIZED VIEW "toms_lookups"."BayTypesInUse_View";
REFRESH MATERIALIZED VIEW "toms_lookups"."LineTypesInUse_View";
REFRESH MATERIALIZED VIEW "toms_lookups"."RestrictionPolygonTypesInUse_View";
REFRESH MATERIALIZED VIEW "toms_lookups"."SignTypesInUse_View";
REFRESH MATERIALIZED VIEW "toms_lookups"."TimePeriodsInUse_View";

-- remove tables no longer required

DROP TABLE "BayLineTypesInUse";
DROP TABLE baytypes;
DROP TABLE linetypes;
DROP TABLE signs;
DROP TABLE "RestrictionTypes";
DROP TABLE "RoadCentreLine";
DROP TABLE "Surveyors";

DROP MATERIALIZED VIEW "BayLineTypes";