--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5 (Debian 12.5-1.pgdg100+1)
-- Dumped by pg_dump version 12.4

-- Started on 2021-04-27 09:19:45

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

SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 473 (class 1259 OID 28201)
-- Name: CPZ_Test_Import; Type: TABLE; Schema: public; Owner: toms.admin
--

CREATE TABLE "local_authority"."CPZ_Test_Import" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(MultiPolygon,27700),
    "fid" bigint,
    "CPZ" character varying(50),
    "Days" character varying(50),
    "Hours" character varying(50),
    "RestrictionTypeID" integer
);


ALTER TABLE "local_authority"."CPZ_Test_Import" OWNER TO "toms.admin";

--
-- TOC entry 472 (class 1259 OID 28199)
-- Name: CPZ_Test_Import_id_seq; Type: SEQUENCE; Schema: public; Owner: toms.admin
--

CREATE SEQUENCE "local_authority"."CPZ_Test_Import_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "local_authority"."CPZ_Test_Import_id_seq" OWNER TO "toms.admin";

--
-- TOC entry 4613 (class 0 OID 0)
-- Dependencies: 472
-- Name: CPZ_Test_Import_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: toms.admin
--

ALTER SEQUENCE "local_authority"."CPZ_Test_Import_id_seq" OWNED BY "local_authority"."CPZ_Test_Import"."id";


--
-- TOC entry 4465 (class 2604 OID 28204)
-- Name: CPZ_Test_Import id; Type: DEFAULT; Schema: public; Owner: toms.admin
--

ALTER TABLE ONLY "local_authority"."CPZ_Test_Import" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."CPZ_Test_Import_id_seq"'::"regclass");


--
-- TOC entry 4607 (class 0 OID 28201)
-- Dependencies: 473
-- Data for Name: CPZ_Test_Import; Type: TABLE DATA; Schema: public; Owner: toms.admin
--

INSERT INTO "local_authority"."CPZ_Test_Import" ("id", "geom", "fid", "CPZ", "Days", "Hours", "RestrictionTypeID") VALUES (1, '0106000020346C00000100000001030000000100000017000000999EE176A4C01341C08984BD3F81244118422382A6BE134191C31081AA7F2441157C3A5023BD134127F566C3F27D2441686F4513DFBC1341D2967B35B17D24418C19933393BC13414E3799C9717D2441C17228F53FBC1341E2FE9AB8347D2441A085F75540BB1341BB6A0D71957C2441DD2F11DB9FB61341D037EE23367F24418CD77DC3F4B61341A2453144767F2441B85D755F42B71341E99910AAB87F2441876FE47088B713415C847020FD7F24416CDBBFBFC6B71341329C8E7043802441B164311AFDB71341B58C2D628B802441AF240DA7C2B81341EAB23E4ACB812441AF79E4A3F5B91341A6328A804D8224418FE4B21C29BC1341B89979E2238324412B1B98C830BD1341551E950E7782244102C83B3004BF13415E509759C2832441784914B4BFC013413A00938136832441A9C03695A0BF134198C525D759822441FAB97FC95FC0134173C84BBFF6812441F8B37F53E3BF1341B8185458B1812441999EE176A4C01341C08984BD3F812441', 1, 'S5', 'Monday - Friday', '8.30am - 5.30pm', 20);


--
-- TOC entry 4614 (class 0 OID 0)
-- Dependencies: 472
-- Name: CPZ_Test_Import_id_seq; Type: SEQUENCE SET; Schema: public; Owner: toms.admin
--

SELECT pg_catalog.setval('"local_authority"."CPZ_Test_Import_id_seq"', 1, true);


--
-- TOC entry 4467 (class 2606 OID 28206)
-- Name: CPZ_Test_Import CPZ_Test_Import_pkey; Type: CONSTRAINT; Schema: public; Owner: toms.admin
--

ALTER TABLE ONLY "local_authority"."CPZ_Test_Import"
    ADD CONSTRAINT "CPZ_Test_Import_pkey" PRIMARY KEY ("id");


-- Completed on 2021-04-27 09:19:46

--
-- PostgreSQL database dump complete
--

