--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-07-03 20:17:16

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
-- TOC entry 4144 (class 0 OID 274635)
-- Dependencies: 235
-- Data for Name: SignConditionTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignConditionTypes" ("Code", "Description") VALUES (1, 'Good');
INSERT INTO "compliance_lookups"."SignConditionTypes" ("Code", "Description") VALUES (2, 'Damaged');
INSERT INTO "compliance_lookups"."SignConditionTypes" ("Code", "Description") VALUES (3, 'Graffitti');
INSERT INTO "compliance_lookups"."SignConditionTypes" ("Code", "Description") VALUES (4, 'Lighting to be replaced');
INSERT INTO "compliance_lookups"."SignConditionTypes" ("Code", "Description") VALUES (10, 'Other (see notes)');
INSERT INTO "compliance_lookups"."SignConditionTypes" ("Code", "Description") VALUES (5, 'Obscured');

--
-- TOC entry 4148 (class 0 OID 274651)
-- Dependencies: 239
-- Data for Name: SignIlluminationTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignIlluminationTypes" ("Code", "Description") VALUES (1, 'Yes - Internal');
INSERT INTO "compliance_lookups"."SignIlluminationTypes" ("Code", "Description") VALUES (2, 'Yes - External');
INSERT INTO "compliance_lookups"."SignIlluminationTypes" ("Code", "Description") VALUES (3, 'No');
INSERT INTO "compliance_lookups"."SignIlluminationTypes" ("Code", "Description") VALUES (4, 'Not sure');

INSERT INTO "compliance_lookups"."Restriction_SignIssueTypes" ("Code", "Description") VALUES (1, 'No issues');
INSERT INTO "compliance_lookups"."Restriction_SignIssueTypes" ("Code", "Description") VALUES (2, 'Inconsistent sign');
INSERT INTO "compliance_lookups"."Restriction_SignIssueTypes" ("Code", "Description") VALUES (3, 'Missing sign');
INSERT INTO "compliance_lookups"."Restriction_SignIssueTypes" ("Code", "Description") VALUES (4, 'Other (please specify in notes)');


INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (1, 'No Issue');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (2, 'Compliance');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (3, 'Street furniture');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (4, 'Location / Geometry');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (5, 'Time Period');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (6, 'No Photo');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (7, 'Dual Use query');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (8, 'Missing sign');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (9, 'Photo - orientation');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (10, 'GAP - section missing');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (11, 'Photo - poor photo quality - Retake');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (12, 'Photo - person in photo - Retake');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (13, 'Photo - pole in photo - Retake');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (14, 'Restriction Type');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (15, 'Field visit - Check details (see notes)');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (16, 'Further office involvement required');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (17, 'Item checked - Client involvement required');
