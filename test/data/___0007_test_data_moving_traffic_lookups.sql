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
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4145 (class 0 OID 350401)
-- Dependencies: 325
-- Data for Name: AccessRestrictionValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."AccessRestrictionValues" ("Code", "Description") VALUES (1, 'forbiddenLegally');
INSERT INTO "moving_traffic_lookups"."AccessRestrictionValues" ("Code", "Description") VALUES (2, 'physicallyImpossible');
INSERT INTO "moving_traffic_lookups"."AccessRestrictionValues" ("Code", "Description") VALUES (3, 'private');
INSERT INTO "moving_traffic_lookups"."AccessRestrictionValues" ("Code", "Description") VALUES (4, 'publicAccess');
INSERT INTO "moving_traffic_lookups"."AccessRestrictionValues" ("Code", "Description") VALUES (5, 'seasonal');
INSERT INTO "moving_traffic_lookups"."AccessRestrictionValues" ("Code", "Description") VALUES (6, 'toll');


--
-- TOC entry 4146 (class 0 OID 350414)
-- Dependencies: 326
-- Data for Name: CycleFacilityValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (1, 'Advisory Cycle Lane Along Road');
INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (2, 'Mandatory Cycle Lane Along Road');
INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (3, 'Physically Segregated Cycle Lane Along Road');
INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (4, 'Unknown Type of Cycle Route Along Road');
INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (5, 'Signed Cycle Route');


--
-- TOC entry 4147 (class 0 OID 350422)
-- Dependencies: 327
-- Data for Name: DedicationValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (1, 'All Vehicles');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (2, 'Bridleway');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (3, 'Byway Open To All Traffic');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (4, 'Cycle Track Or Cycle Way');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (5, 'Motorway');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (6, 'No Dedication Or Dedication Unknown');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (7, 'Pedestrian Way Or Footpath');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (8, 'Restricted Byway');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (9, 'Pedestrians and pedal cycles only');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (10, 'Separated track and path for cyclists and pedestrians');


--
-- TOC entry 4148 (class 0 OID 350430)
-- Dependencies: 328
-- Data for Name: LinkDirectionValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."LinkDirectionValues" ("Code", "Description") VALUES (1, 'bothDirections');
INSERT INTO "moving_traffic_lookups"."LinkDirectionValues" ("Code", "Description") VALUES (2, 'inDirection');
INSERT INTO "moving_traffic_lookups"."LinkDirectionValues" ("Code", "Description") VALUES (3, 'inOppositeDirection');


--
-- TOC entry 4149 (class 0 OID 350438)
-- Dependencies: 329
-- Data for Name: RestrictionTypeValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (1, 'maximumDoubleAxleWeight');
INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (2, 'maximumHeight');
INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (3, 'maximumLength');
INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (4, 'maximumSingleAxleWeight');
INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (5, 'maximumTotalWeight');
INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (6, 'maximumTripleAxleWeight');
INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (7, 'maximumWidth');


--
-- TOC entry 4151 (class 0 OID 350470)
-- Dependencies: 331
-- Data for Name: SpecialDesignationTypes; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."SpecialDesignationTypes" ("Code", "Description") VALUES (1, 'Bus Lane');
INSERT INTO "moving_traffic_lookups"."SpecialDesignationTypes" ("Code", "Description") VALUES (2, 'Cycle Lane');
INSERT INTO "moving_traffic_lookups"."SpecialDesignationTypes" ("Code", "Description") VALUES (3, 'Signal controlled cycle crossing (from cycle track)');
INSERT INTO "moving_traffic_lookups"."SpecialDesignationTypes" ("Code", "Description") VALUES (4, 'Signal controlled cycle crossing (from cycle lane)');
INSERT INTO "moving_traffic_lookups"."SpecialDesignationTypes" ("Code", "Description") VALUES (5, 'Test');


--
-- TOC entry 4152 (class 0 OID 350476)
-- Dependencies: 332
-- Data for Name: SpeedLimitValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."SpeedLimitValues" ("Code", "Description") VALUES (1, '5');
INSERT INTO "moving_traffic_lookups"."SpeedLimitValues" ("Code", "Description") VALUES (2, '10');
INSERT INTO "moving_traffic_lookups"."SpeedLimitValues" ("Code", "Description") VALUES (3, '15');
INSERT INTO "moving_traffic_lookups"."SpeedLimitValues" ("Code", "Description") VALUES (4, '20');
INSERT INTO "moving_traffic_lookups"."SpeedLimitValues" ("Code", "Description") VALUES (5, '30');
INSERT INTO "moving_traffic_lookups"."SpeedLimitValues" ("Code", "Description") VALUES (6, '40');
INSERT INTO "moving_traffic_lookups"."SpeedLimitValues" ("Code", "Description") VALUES (7, '50');


--
-- TOC entry 4153 (class 0 OID 350486)
-- Dependencies: 333
-- Data for Name: StructureTypeValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (1, 'Barrier');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (2, 'Bridge Under Road');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (3, 'Bridge Over Road');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (4, 'Gate');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (5, 'Level Crossing Fully Barriered');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (6, 'Level Crossing Part Barriered');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (7, 'Level Crossing Unbarriered');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (8, 'Moveable barrier');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (9, 'Pedestrian Crossing');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (10, 'Rising Bollards');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (11, 'Street Lighting');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (12, 'Structure');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (13, 'Traffic Calming');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (14, 'Traffic Signal');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (15, 'Toll Indicator');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (16, 'Tunnel');


--
-- TOC entry 4154 (class 0 OID 350494)
-- Dependencies: 334
-- Data for Name: TurnRestrictionValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."TurnRestrictionValues" ("Code", "Description") VALUES (1, 'Mandatory Turn');
INSERT INTO "moving_traffic_lookups"."TurnRestrictionValues" ("Code", "Description") VALUES (2, 'No Turn');
INSERT INTO "moving_traffic_lookups"."TurnRestrictionValues" ("Code", "Description") VALUES (3, 'One Way');
INSERT INTO "moving_traffic_lookups"."TurnRestrictionValues" ("Code", "Description") VALUES (4, 'Priority to on-coming vehicles');


--
-- TOC entry 4155 (class 0 OID 350502)
-- Dependencies: 335
-- Data for Name: VehicleQualifiers; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (1, 'Goods Vehicles Exceeding 7.5T');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (2, 'Pedal Cycles');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (3, 'Loading and Unloading');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (4, 'Local Buses');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (5, 'Goods Vehicles Exceeding 16.5T');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (6, 'Goods Vehicles Exceeding 18T');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (7, 'Permit Holders');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (8, 'All Vehicles');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (9, 'Buses and Pedal Cycles');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (10, 'Motor Vehicles');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (11, 'Goods Vehicles Exceeding 3T');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (12, 'Emergency Vehicles');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (13, 'Access');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (14, 'Buses');
INSERT INTO "moving_traffic_lookups"."VehicleQualifiers" ("Code", "Description") VALUES (15, 'Motor Cycles');


REFRESH MATERIALIZED VIEW "moving_traffic_lookups"."CarriagewayMarkingInUse_View";

--
-- TOC entry 4180 (class 0 OID 0)
-- Dependencies: 336
-- Name: AccessRestrictionValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."AccessRestrictionValues_Code_seq"', 1, false);


--
-- TOC entry 4181 (class 0 OID 0)
-- Dependencies: 337
-- Name: CycleFacilityValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."CycleFacilityValues_Code_seq"', 1, false);


--
-- TOC entry 4182 (class 0 OID 0)
-- Dependencies: 338
-- Name: DedicationValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."DedicationValues_Code_seq"', 1, false);


--
-- TOC entry 4183 (class 0 OID 0)
-- Dependencies: 339
-- Name: LinkDirectionValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."LinkDirectionValues_Code_seq"', 1, false);


--
-- TOC entry 4184 (class 0 OID 0)
-- Dependencies: 340
-- Name: RestrictionTypeValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."RestrictionTypeValues_Code_seq"', 1, false);


--
-- TOC entry 4185 (class 0 OID 0)
-- Dependencies: 330
-- Name: SpecialDesignationTypes_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."SpecialDesignationTypes_Code_seq"', 5, true);


--
-- TOC entry 4186 (class 0 OID 0)
-- Dependencies: 341
-- Name: SpeedLimitValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."SpeedLimitValues_Code_seq"', 1, false);


--
-- TOC entry 4187 (class 0 OID 0)
-- Dependencies: 342
-- Name: StructureTypeValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."StructureTypeValues_Code_seq"', 1, false);


--
-- TOC entry 4188 (class 0 OID 0)
-- Dependencies: 343
-- Name: TurnRestrictionValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."TurnRestrictionValues_Code_seq"', 1, false);


--
-- TOC entry 4189 (class 0 OID 0)
-- Dependencies: 344
-- Name: VehicleQualifiers_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."VehicleQualifiers_Code_seq"', 1, false);


-- Completed on 2020-07-03 20:17:16

--
-- PostgreSQL database dump complete
--

