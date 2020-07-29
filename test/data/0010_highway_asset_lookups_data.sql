--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-07-28 07:01:53

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
-- TOC entry 4451 (class 0 OID 506635)
-- Dependencies: 382
-- Data for Name: AssetConditionTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--

INSERT INTO "highway_asset_lookups"."AssetConditionTypes" ("Code", "Description") VALUES (1, 'Good');
INSERT INTO "highway_asset_lookups"."AssetConditionTypes" ("Code", "Description") VALUES (2, 'Serviceable');
INSERT INTO "highway_asset_lookups"."AssetConditionTypes" ("Code", "Description") VALUES (3, 'Needs replacement');


--
-- TOC entry 4453 (class 0 OID 506641)
-- Dependencies: 384
-- Data for Name: BinTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--

INSERT INTO "highway_asset_lookups"."BinTypes" ("Code", "Description") VALUES (1, 'Litter');
INSERT INTO "highway_asset_lookups"."BinTypes" ("Code", "Description") VALUES (2, 'Litter and Mixed Recycling');
INSERT INTO "highway_asset_lookups"."BinTypes" ("Code", "Description") VALUES (3, 'Recycling Zone');


--
-- TOC entry 4455 (class 0 OID 506650)
-- Dependencies: 386
-- Data for Name: BollardTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--

INSERT INTO "highway_asset_lookups"."BollardTypes" ("Code", "Description") VALUES (1, 'Bell');
INSERT INTO "highway_asset_lookups"."BollardTypes" ("Code", "Description") VALUES (2, 'Other');


--
-- TOC entry 4457 (class 0 OID 506659)
-- Dependencies: 388
-- Data for Name: CommunicationCabinetTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--

INSERT INTO "highway_asset_lookups"."CommunicationCabinetTypes" ("Code", "Description") VALUES (1, 'Islington feeder pillar');


--
-- TOC entry 4459 (class 0 OID 506668)
-- Dependencies: 390
-- Data for Name: CrossingPointTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--

INSERT INTO "highway_asset_lookups"."CrossingPointTypes" ("Code", "Description") VALUES (1, 'Pedestrian (dropped kerb)');
INSERT INTO "highway_asset_lookups"."CrossingPointTypes" ("Code", "Description") VALUES (2, 'Pedestrian (level surface)');
INSERT INTO "highway_asset_lookups"."CrossingPointTypes" ("Code", "Description") VALUES (3, 'Vehicle (dropped kerb)');
INSERT INTO "highway_asset_lookups"."CrossingPointTypes" ("Code", "Description") VALUES (4, 'Vehicle (informal dropped kerb)');
INSERT INTO "highway_asset_lookups"."CrossingPointTypes" ("Code", "Description") VALUES (5, 'Vehicle (raised surface)');


--
-- TOC entry 4461 (class 0 OID 506677)
-- Dependencies: 392
-- Data for Name: CycleParkingTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--

INSERT INTO "highway_asset_lookups"."CycleParkingTypes" ("Code", "Description") VALUES (1, 'Sheffield Stand');
INSERT INTO "highway_asset_lookups"."CycleParkingTypes" ("Code", "Description") VALUES (2, 'Cycle hoop');
INSERT INTO "highway_asset_lookups"."CycleParkingTypes" ("Code", "Description") VALUES (3, 'Cycle planter');
INSERT INTO "highway_asset_lookups"."CycleParkingTypes" ("Code", "Description") VALUES (4, 'Other');


--
-- TOC entry 4463 (class 0 OID 506686)
-- Dependencies: 394
-- Data for Name: DisplayBoardTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--

INSERT INTO "highway_asset_lookups"."DisplayBoardTypes" ("Code", "Description") VALUES (1, 'Digital');
INSERT INTO "highway_asset_lookups"."DisplayBoardTypes" ("Code", "Description") VALUES (2, 'Islington Information');
INSERT INTO "highway_asset_lookups"."DisplayBoardTypes" ("Code", "Description") VALUES (3, 'Other');


--
-- TOC entry 4465 (class 0 OID 506695)
-- Dependencies: 396
-- Data for Name: EV_ChargingPointTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--

INSERT INTO "highway_asset_lookups"."EV_ChargingPointTypes" ("Code", "Description") VALUES (1, 'Standalone');
INSERT INTO "highway_asset_lookups"."EV_ChargingPointTypes" ("Code", "Description") VALUES (2, 'Lighting column');


--
-- TOC entry 4467 (class 0 OID 506704)
-- Dependencies: 398
-- Data for Name: EndOfStreetMarkingTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--

INSERT INTO "highway_asset_lookups"."EndOfStreetMarkingTypes" ("Code", "Description") VALUES (1, 'Give Way');
INSERT INTO "highway_asset_lookups"."EndOfStreetMarkingTypes" ("Code", "Description") VALUES (2, 'Stop');
INSERT INTO "highway_asset_lookups"."EndOfStreetMarkingTypes" ("Code", "Description") VALUES (3, 'Signalised junction');


--
-- TOC entry 4469 (class 0 OID 506713)
-- Dependencies: 400
-- Data for Name: PedestrianRailingsTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--

INSERT INTO "highway_asset_lookups"."PedestrianRailingsTypes" ("Code", "Description") VALUES (1, 'Roadside protection');
INSERT INTO "highway_asset_lookups"."PedestrianRailingsTypes" ("Code", "Description") VALUES (2, 'Hazard protection (eg height)');
INSERT INTO "highway_asset_lookups"."PedestrianRailingsTypes" ("Code", "Description") VALUES (3, 'Around bins');
INSERT INTO "highway_asset_lookups"."PedestrianRailingsTypes" ("Code", "Description") VALUES (4, 'Other (specify in notes)');


--
-- TOC entry 4471 (class 0 OID 506722)
-- Dependencies: 402
-- Data for Name: SubterraneanFeatureTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--

INSERT INTO "highway_asset_lookups"."SubterraneanFeatureTypes" ("Code", "Description") VALUES (1, 'Cellar access');
INSERT INTO "highway_asset_lookups"."SubterraneanFeatureTypes" ("Code", "Description") VALUES (2, 'Pavement lights');
INSERT INTO "highway_asset_lookups"."SubterraneanFeatureTypes" ("Code", "Description") VALUES (3, 'Coal hole');
INSERT INTO "highway_asset_lookups"."SubterraneanFeatureTypes" ("Code", "Description") VALUES (4, 'Grate/vent');
INSERT INTO "highway_asset_lookups"."SubterraneanFeatureTypes" ("Code", "Description") VALUES (5, 'Other (specify in notes)');


--
-- TOC entry 4473 (class 0 OID 506731)
-- Dependencies: 404
-- Data for Name: TrafficCalmingTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--

INSERT INTO "highway_asset_lookups"."TrafficCalmingTypes" ("Code", "Description") VALUES (1, 'Speed Hump');
INSERT INTO "highway_asset_lookups"."TrafficCalmingTypes" ("Code", "Description") VALUES (2, 'Speed Cushion (indicate number)');
INSERT INTO "highway_asset_lookups"."TrafficCalmingTypes" ("Code", "Description") VALUES (3, 'Speed Table');


--
-- TOC entry 4475 (class 0 OID 506740)
-- Dependencies: 406
-- Data for Name: VehicleBarrierTypes; Type: TABLE DATA; Schema: highway_asset_lookups; Owner: postgres
--



--
-- TOC entry 4508 (class 0 OID 0)
-- Dependencies: 381
-- Name: AssetConditionTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."AssetConditionTypes_Code_seq"', 3, true);


--
-- TOC entry 4509 (class 0 OID 0)
-- Dependencies: 383
-- Name: BinTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."BinTypes_Code_seq"', 7, true);


--
-- TOC entry 4510 (class 0 OID 0)
-- Dependencies: 385
-- Name: BollardTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."BollardTypes_Code_seq"', 2, true);


--
-- TOC entry 4511 (class 0 OID 0)
-- Dependencies: 387
-- Name: CommunicationCabinetTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."CommunicationCabinetTypes_Code_seq"', 1, true);


--
-- TOC entry 4512 (class 0 OID 0)
-- Dependencies: 389
-- Name: CrossingPointTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."CrossingPointTypes_Code_seq"', 5, true);


--
-- TOC entry 4513 (class 0 OID 0)
-- Dependencies: 391
-- Name: CycleParkingTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."CycleParkingTypes_Code_seq"', 4, true);


--
-- TOC entry 4514 (class 0 OID 0)
-- Dependencies: 393
-- Name: DisplayBoardTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."DisplayBoardTypes_Code_seq"', 3, true);


--
-- TOC entry 4515 (class 0 OID 0)
-- Dependencies: 395
-- Name: EV_ChargingPointTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."EV_ChargingPointTypes_Code_seq"', 2, true);


--
-- TOC entry 4516 (class 0 OID 0)
-- Dependencies: 397
-- Name: EndOfStreetMarkingTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."EndOfStreetMarkingTypes_Code_seq"', 3, true);


--
-- TOC entry 4517 (class 0 OID 0)
-- Dependencies: 399
-- Name: PedestrianRailingsTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."PedestrianRailingsTypes_Code_seq"', 4, true);


--
-- TOC entry 4518 (class 0 OID 0)
-- Dependencies: 401
-- Name: SubterraneanFeatureTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."SubterraneanFeatureTypes_Code_seq"', 5, true);


--
-- TOC entry 4519 (class 0 OID 0)
-- Dependencies: 403
-- Name: TrafficCalmingTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."TrafficCalmingTypes_Code_seq"', 3, true);


--
-- TOC entry 4520 (class 0 OID 0)
-- Dependencies: 405
-- Name: VehicleBarrierTypes_Code_seq; Type: SEQUENCE SET; Schema: highway_asset_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"highway_asset_lookups"."VehicleBarrierTypes_Code_seq"', 1, false);


-- Completed on 2020-07-28 07:01:53

--
-- PostgreSQL database dump complete
--

