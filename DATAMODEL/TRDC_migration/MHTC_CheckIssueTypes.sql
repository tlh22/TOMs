--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.4

-- Started on 2021-01-29 14:06:43

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
-- TOC entry 4837 (class 0 OID 727020)
-- Dependencies: 235
-- Data for Name: MHTC_CheckIssueTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (1, 'Item checked - Available for release');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (10, 'Field visit - Item missed - confirm location and details');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (11, 'Field visit - Photo missing or needs to be retaken');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (15, 'Field visit - Check details (see notes)');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (16, 'Further office involvement required');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (17, 'Item checked - Client involvement required');


--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 236
-- Name: MHTC_CheckIssueType_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."MHTC_CheckIssueType_Code_seq"', 1, true);


-- Completed on 2021-01-29 14:06:43

--
-- PostgreSQL database dump complete
--

