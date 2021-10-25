--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-08-06 09:07:33

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
-- TOC entry 4685 (class 0 OID 515783)
-- Dependencies: 460
-- Data for Name: AccessRestrictionValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--



--
-- TOC entry 4707 (class 0 OID 516435)
-- Dependencies: 501
-- Data for Name: CarriagewayMarkingTypes; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (1, '20 MPH (Max)', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (2, '30 MPH (Max)', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (4, '40 MPH (Max)', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (5, '10 MPH (Max)', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (6, '5 MPH (Max)', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (7, '15 MPH (Max)', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (8, 'Turn Right', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (9, 'Turn Left', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (10, 'Ahead Only', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (11, 'No Entry', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (12, 'Cycle symbol', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (13, 'Bus Lane', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (14, 'Bus Gate', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (15, 'Bus Only', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (16, 'Other', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (17, 'Roundabout', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (18, 'One Way', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (19, 'No Left Turn', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (20, 'No Right Turn', NULL);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypes" ("Code", "Description", "Icon") VALUES (21, 'Pedestrian symbol', NULL);
--
-- TOC entry 4708 (class 0 OID 516441)
-- Dependencies: 502
-- Data for Name: CarriagewayMarkingTypesInUse; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (1);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (2);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (3);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (4);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (5);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (6);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (7);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (8);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (9);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (10);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (11);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (12);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (13);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (14);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (15);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (16);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (17);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (18);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (19);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (20);
INSERT INTO "moving_traffic_lookups"."CarriagewayMarkingTypesInUse" ("Code") VALUES (21);

REFRESH MATERIALIZED VIEW "moving_traffic_lookups"."CarriagewayMarkingTypesInUse_View";

--
-- TOC entry 4687 (class 0 OID 515791)
-- Dependencies: 462
-- Data for Name: CycleFacilityValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--



--
-- TOC entry 4689 (class 0 OID 515796)
-- Dependencies: 464
-- Data for Name: DedicationValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--



--
-- TOC entry 4691 (class 0 OID 515801)
-- Dependencies: 466
-- Data for Name: LinkDirectionValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--



--
-- TOC entry 4693 (class 0 OID 515806)
-- Dependencies: 468
-- Data for Name: RestrictionTypeValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--



--
-- TOC entry 4695 (class 0 OID 515811)
-- Dependencies: 470
-- Data for Name: SpecialDesignationTypes; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--



--
-- TOC entry 4697 (class 0 OID 515819)
-- Dependencies: 472
-- Data for Name: SpeedLimitValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--



--
-- TOC entry 4699 (class 0 OID 515827)
-- Dependencies: 474
-- Data for Name: StructureTypeValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--



--
-- TOC entry 4701 (class 0 OID 515832)
-- Dependencies: 476
-- Data for Name: TurnRestrictionValues; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--



--
-- TOC entry 4703 (class 0 OID 515837)
-- Dependencies: 478
-- Data for Name: VehicleQualifiers; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--



--
-- TOC entry 4705 (class 0 OID 515842)
-- Dependencies: 480
-- Data for Name: vehicleQualifiers; Type: TABLE DATA; Schema: moving_traffic_lookups; Owner: postgres
--

INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (1, 'Goods Vehicles Exceeding 7.5T', '{"Goods Vehicles Exceeding 7.5T"}', NULL, NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (2, 'Pedal Cycles', '{"Pedal Cycles"}', NULL, NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (3, 'Loading and Unloading', NULL, '{"Loading and Unloading"}', NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (4, 'Local Buses', NULL, '{"Local Buses"}', NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (5, 'Goods Vehicles Exceeding 16.5T', '{"Goods Vehicles Exceeding 16.5T"}', NULL, NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (6, 'Goods Vehicles Exceeding 18T', '{"Goods Vehicles Exceeding 18T"}', NULL, NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (7, 'Permit Holders', NULL, '{"Permit Holders"}', NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (8, 'All Vehicles', '{"All Vehicles"}', NULL, NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (9, 'Buses and Pedal Cycles', '{Buses,"Pedal Cycles"}', NULL, NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (10, 'Motor Vehicles', '{"Motor Vehicles"}', NULL, NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (11, 'Goods Vehicles Exceeding 3T', '{"Goods Vehicles Exceeding 3T"}', NULL, NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (12, 'Emergency Vehicles', '{"Emergency Vehicles"}', NULL, NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (13, 'Access', NULL, '{Access}', NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (14, 'Buses', '{Buses}', NULL, NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (15, 'Motor Cycles', '{"Motor Cycles"}', NULL, NULL);


--
-- TOC entry 4755 (class 0 OID 0)
-- Dependencies: 461
-- Name: AccessRestrictionValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."AccessRestrictionValues_Code_seq"', 1, false);


--
-- TOC entry 4756 (class 0 OID 0)
-- Dependencies: 504
-- Name: CarriagewayMarkingTypes_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."CarriagewayMarkingTypes_Code_seq"', 11, true);


--
-- TOC entry 4757 (class 0 OID 0)
-- Dependencies: 463
-- Name: CycleFacilityValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."CycleFacilityValues_Code_seq"', 1, false);


--
-- TOC entry 4758 (class 0 OID 0)
-- Dependencies: 465
-- Name: DedicationValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."DedicationValues_Code_seq"', 1, false);


--
-- TOC entry 4759 (class 0 OID 0)
-- Dependencies: 467
-- Name: LinkDirectionValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."LinkDirectionValues_Code_seq"', 1, false);


--
-- TOC entry 4760 (class 0 OID 0)
-- Dependencies: 469
-- Name: RestrictionTypeValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."RestrictionTypeValues_Code_seq"', 1, false);


--
-- TOC entry 4761 (class 0 OID 0)
-- Dependencies: 471
-- Name: SpecialDesignationTypes_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."SpecialDesignationTypes_Code_seq"', 1, false);


--
-- TOC entry 4762 (class 0 OID 0)
-- Dependencies: 473
-- Name: SpeedLimitValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."SpeedLimitValues_Code_seq"', 1, false);


--
-- TOC entry 4763 (class 0 OID 0)
-- Dependencies: 475
-- Name: StructureTypeValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."StructureTypeValues_Code_seq"', 1, false);


--
-- TOC entry 4764 (class 0 OID 0)
-- Dependencies: 477
-- Name: TurnRestrictionValues_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."TurnRestrictionValues_Code_seq"', 1, false);


--
-- TOC entry 4765 (class 0 OID 0)
-- Dependencies: 479
-- Name: VehicleQualifiers_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."VehicleQualifiers_Code_seq"', 1, false);


--
-- TOC entry 4766 (class 0 OID 0)
-- Dependencies: 481
-- Name: vehicleQualifiers_Code_seq; Type: SEQUENCE SET; Schema: moving_traffic_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"moving_traffic_lookups"."vehicleQualifiers_Code_seq"', 15, true);


-- Completed on 2020-08-06 09:07:34

--
-- PostgreSQL database dump complete
--

