--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.4

-- Started on 2021-01-29 19:25:21

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
-- TOC entry 4837 (class 0 OID 728171)
-- Dependencies: 497
-- Data for Name: RestrictionPolygonTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

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
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (50, 'Box junction');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (30, 'Council Housing Estate');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (23, 'Congestion Charging Zone');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (24, 'Ultra Low Emissions Zone');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (9, 'Pedestrian and cycle zone');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (10, 'Restricted Zone');
INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (1, 'Red Route / Greenway');


--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 500
-- Name: RestrictionPolygonTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."RestrictionPolygonTypes_Code_seq"', 21, true);


-- Completed on 2021-01-29 19:25:22

--
-- PostgreSQL database dump complete
--

