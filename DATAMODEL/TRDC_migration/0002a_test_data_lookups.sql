--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

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
-- TOC entry 4395 (class 0 OID 294562)
-- Dependencies: 222
-- Data for Name: BaysLinesFadedTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."BaysLinesFadedTypes" ("Code", "Description") VALUES (1, 'No issue');
INSERT INTO "compliance_lookups"."BaysLinesFadedTypes" ("Code", "Description") VALUES (6, 'Other (please specify in notes)');
INSERT INTO "compliance_lookups"."BaysLinesFadedTypes" ("Code", "Description") VALUES (2, 'Slightly faded marking');
INSERT INTO "compliance_lookups"."BaysLinesFadedTypes" ("Code", "Description") VALUES (3, 'Very faded markings');
INSERT INTO "compliance_lookups"."BaysLinesFadedTypes" ("Code", "Description") VALUES (4, 'Markings not correctly removed');
INSERT INTO "compliance_lookups"."BaysLinesFadedTypes" ("Code", "Description") VALUES (5, 'Missing markings');


--
-- TOC entry 4397 (class 0 OID 294570)
-- Dependencies: 224
-- Data for Name: BaysLines_SignIssueTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4399 (class 0 OID 294578)
-- Dependencies: 226
-- Data for Name: ConditionTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4401 (class 0 OID 294583)
-- Dependencies: 228
-- Data for Name: MHTC_CheckIssueType; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4403 (class 0 OID 294591)
-- Dependencies: 230
-- Data for Name: MHTC_CheckStatus; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4405 (class 0 OID 294599)
-- Dependencies: 232
-- Data for Name: SignAttachmentTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (1, 1, 'Short Pole');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (2, 2, 'Normal Pole');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (3, 3, 'Tall Pole');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (4, 4, 'Lamppost');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (5, 5, 'Wall');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (6, 6, 'Fences');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (7, 7, 'Other (Please specify in notes)');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (8, 8, 'Traffic Light');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (9, 9, 'Large Pole');


--
-- TOC entry 4406 (class 0 OID 294605)
-- Dependencies: 233
-- Data for Name: SignConditionTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4408 (class 0 OID 294613)
-- Dependencies: 235
-- Data for Name: SignFadedTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (1, 1, 'No issues');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (2, 2, 'Sign Faded');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (3, 3, 'Sign Damaged');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (4, 4, 'Sign Damaged and Faded');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (5, 5, 'Pole Present, but Sign Missing');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (6, 6, 'Other (Please specify in notes)');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (7, 7, 'Sign OK, but Pole bent');
INSERT INTO "compliance_lookups"."SignFadedTypes" ("id", "Code", "Description") VALUES (8, 8, 'Defaced (Stickers, graffiti, dirt)');


--
-- TOC entry 4410 (class 0 OID 294621)
-- Dependencies: 237
-- Data for Name: SignIlluminationTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--



--
-- TOC entry 4412 (class 0 OID 294629)
-- Dependencies: 239
-- Data for Name: SignMountTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (1, 1, 'U-Channel');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (2, 2, 'Round Post Bracket');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (3, 3, 'Square Post Bracket');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (4, 4, 'Wall Bracket');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (5, 5, 'Other (Please specify in notes)');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (6, 6, 'Screws or Nails');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (7, 7, 'Simple bar');


--
-- TOC entry 4414 (class 0 OID 294637)
-- Dependencies: 241
-- Data for Name: SignObscurredTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."SignObscurredTypes" ("id", "Code", "Description") VALUES (1, 1, 'No issue');
INSERT INTO "compliance_lookups"."SignObscurredTypes" ("id", "Code", "Description") VALUES (2, 2, 'Partially obscured');
INSERT INTO "compliance_lookups"."SignObscurredTypes" ("id", "Code", "Description") VALUES (3, 3, 'Completely obscured');


--
-- TOC entry 4416 (class 0 OID 294645)
-- Dependencies: 243
-- Data for Name: TicketMachineIssueTypes; Type: TABLE DATA; Schema: compliance_lookups; Owner: postgres
--

INSERT INTO "compliance_lookups"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (1, 1, 'No issues');
INSERT INTO "compliance_lookups"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (2, 2, 'Defaced (e.g. graffiti)');
INSERT INTO "compliance_lookups"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (3, 3, 'Physically Damaged');
INSERT INTO "compliance_lookups"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (4, 4, 'Other (Please specify in notes)');

--
-- TOC entry 4459 (class 0 OID 294815)
-- Dependencies: 286
-- Data for Name: LengthOfTime; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (12, 'No restriction', NULL);
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (13, 'Other (please specify in notes)', NULL);
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (3, '2 hours', '2h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (4, '3 hours', '3h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (5, '4 hours', '4h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (6, '5 hours', '5h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (7, '5 minutes', '5m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (8, '10 minutes', '10m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (9, '20 minutes', '20m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (10, '30 minutes', '30m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (11, '40 minutes', '40m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (14, '6 hours', '6h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (15, '9 hours', '9h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (2, '90 minutes', '90m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (16, '45 minutes', '45m');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (1, '60 minutes', '1h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (17, '10 hours', '10h');
INSERT INTO "toms_lookups"."LengthOfTime" ("Code", "Description", "LabelText") VALUES (18, '75 minutes', '75m');


--
-- TOC entry 4463 (class 0 OID 294833)
-- Dependencies: 290
-- Data for Name: PaymentTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."PaymentTypes" ("Code", "Description") VALUES (1, 'No Charge');
INSERT INTO "toms_lookups"."PaymentTypes" ("Code", "Description") VALUES (2, 'Pay and Display');
INSERT INTO "toms_lookups"."PaymentTypes" ("Code", "Description") VALUES (3, 'Pay by Phone (only)');
INSERT INTO "toms_lookups"."PaymentTypes" ("Code", "Description") VALUES (4, 'Pay and Display/Pay by Phone');


--
-- TOC entry 4473 (class 0 OID 294878)
-- Dependencies: 300
-- Data for Name: SignOrientationTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (1, 'Facing in same direction as road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (2, 'Facing in opposite direction to road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (3, 'Facing road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (4, 'Facing away from road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (5, 'Other (specify azimuth)');


--
-- TOC entry 4475 (class 0 OID 294886)
-- Dependencies: 302
-- Data for Name: SignTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (12, 'Red Route/Greenway Disabled Bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (13, 'Red Route/Greenway Loading Bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (14, 'Red Route/Greenway Loading/Disabled Bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (15, 'Red Route/Greenway Loading/Parking Bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (16, 'Red Route/Greenway Parking Bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (25, 'Other (please specify)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (27, 'Pedestrian Zone');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (45, 'Business Permit Holder only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (46, 'Restricted Parking Zone');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (670, 'Max speed limit (other)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (47, 'Half on/Half off (end)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (49, 'Permit Parking Zone (PPZ) (end)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (17, 'Half on/Half off');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (67020, '20 MPH (Max)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (48, 'Half on/Half off zone (not allowed) (start)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (50, 'Half on/Half off zone (not allowed) (end)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (51, 'Car Park Tariff Board');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (67030, '30 MPH  (Max)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (52, 'Overnight Coach and Truck ban Zone start');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (53, 'Overnight Coach and Truck ban Zone end');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (3, 'Bus only bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (54, 'Private Estate sign');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (67040, '40 MPH (Max)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (67010, '10 MPH (Max)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (67005, '5 MPH (Max)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (675, 'End 20 MPH Zone - Start 30 MPH Max');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (55, 'Truck waiting ban zone start');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (56, 'Truck waiting ban zone end');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6634, 'Half on/Half off (not allowed)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (57, 'Truck waiting ban');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (642, 'Clearway');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (674, '20 MPH Zone');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (811, 'Priority over oncoming traffic');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (880, 'Speed zone reminder (with or without camera)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (67640, '40 MPH Zone');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (957, 'Separated track and path for cyclists and pedestrians ');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (36, 'Zig-Zag school keep clear');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (41, 'No Stopping - School');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6291, 'Width Restriction - Imperial');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6292, 'Width Restriction');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6294, 'Height Restriction');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (1, '5T trucks and buses');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (2, 'Ambulances only bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (4, 'Bus stops/Bus stands');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (5, 'Car club');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6, 'CPZ entry');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (7, 'CPZ exit');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (8, 'Disabled bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9, 'Doctor bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (10, 'Electric vehicles recharging point');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (11, 'Free parking bays (not Limited Waiting)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (618, 'Play Street');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6192, 'All Motorcycles Prohibited');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (19, 'Loading bay');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (610, 'Keep Left');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6061, 'Proceed in direction indicated - Right');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6062, 'Proceed in direction indicated - Left');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6063, 'Proceed in direction indicated - Straight');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (652, 'One Way - Arrow Only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6092, 'Turn Right Ahead');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6091, 'Turn Left Ahead');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (607, 'One Way - Words Only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (616, 'No entry');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (613, 'No Left Turn');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (612, 'No Right Turn');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (614, 'No U Turn');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (615, 'Priority to on-coming traffic');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9602, 'One-way traffic with contraflow pedal cycles');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9601, 'One-way traffic with contraflow cycle lane');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9541, 'Except buses');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9544, 'Except cycles');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (18, 'Limited waiting (no payment)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (20, 'Motorcycles only bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (21, 'No loading');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (22, 'No waiting');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (23, 'No waiting and no loading');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (24, 'On pavement parking');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (26, 'Pay and Display/Pay by Phone bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (28, 'Permit holders only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (29, 'Police bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (30, 'Private/Residents only bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (31, 'Residents permit holders only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (32, 'Shared use bays');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (33, 'Taxi ranks');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (34, 'Ticket machine');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (35, 'To be deleted');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (37, 'Pole only, no sign');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (43, 'Red Route Limited Waiting Bay');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (44, 'Restricted Parking Zone - entry');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (617, 'All Vehicles Prohibited');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (619, 'All Motor Vehicles Prohibited');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6262, 'Weak Bridge');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (955, 'Pedal Cycles Only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (956, 'Pedestrians and Cycles only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (953, 'Route used by Buses and Cycles only');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6191, 'Motor Vehicles except solo motorcycles prohibited');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (521, 'Two Way Traffic');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (522, 'Two Way Traffic on crossing ahead');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9592, 'With flow cycle lane');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (810, 'One Way - Arrow and Words');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (952, 'All Buses Prohibited');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6111, 'Mini-roundabout');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9581, 'With flow bus lane ahead (with cycles and taxis)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9591, 'With flow bus lane (with cycles and taxis)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (951, 'All Cycles prohibited');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (401, 'Advisory Sign (see photo)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (201, 'Route Sign (see photo)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (9621, 'Cycle lane at junction ahead');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (816, 'No Through Road');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (964, 'End of bus lane');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6101, 'Keep Right');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (620, 'Except for access');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (6202, 'Except for loading');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (38, 'No stopping - Red Route/Greenway');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (39, 'Red Route/Greenway exit area');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (0, 'Missing');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (664, 'Zone ends');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (42, 'On Street NOT in TRO');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (40, 'Permit Parking Zone (PPZ) (start)');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (62211, 'Weight restriction');
INSERT INTO "toms_lookups"."SignTypes" ("Code", "Description") VALUES (64021, 'Overnight Coach and Truck ban');


--
-- TOC entry 4541 (class 0 OID 0)
-- Dependencies: 225
-- Name: BaysLines_SignIssueTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."BaysLines_SignIssueTypes_Code_seq"', 1, false);


--
-- TOC entry 4542 (class 0 OID 0)
-- Dependencies: 227
-- Name: ConditionTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."ConditionTypes_Code_seq"', 1, false);


--
-- TOC entry 4543 (class 0 OID 0)
-- Dependencies: 229
-- Name: MHTC_CheckIssueType_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."MHTC_CheckIssueType_Code_seq"', 1, false);


--
-- TOC entry 4544 (class 0 OID 0)
-- Dependencies: 231
-- Name: MHTC_CheckStatus_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."MHTC_CheckStatus_Code_seq"', 1, false);


--
-- TOC entry 4545 (class 0 OID 0)
-- Dependencies: 234
-- Name: SignConditionTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignConditionTypes_Code_seq"', 1, false);


--
-- TOC entry 4546 (class 0 OID 0)
-- Dependencies: 236
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignFadedTypes_id_seq"', 8, true);


--
-- TOC entry 4547 (class 0 OID 0)
-- Dependencies: 238
-- Name: SignIlluminationTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignIlluminationTypes_Code_seq"', 1, false);


--
-- TOC entry 4548 (class 0 OID 0)
-- Dependencies: 240
-- Name: SignMountTypes_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignMountTypes_id_seq"', 7, true);


--
-- TOC entry 4549 (class 0 OID 0)
-- Dependencies: 242
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."SignObscurredTypes_id_seq"', 3, true);


--
-- TOC entry 4550 (class 0 OID 0)
-- Dependencies: 244
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."TicketMachineIssueTypes_id_seq"', 4, true);


--
-- TOC entry 4551 (class 0 OID 0)
-- Dependencies: 245
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."signAttachmentTypes2_id_seq"', 9, true);


--
-- TOC entry 4567 (class 0 OID 0)
-- Dependencies: 280
-- Name: AdditionalConditionTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."AdditionalConditionTypes_Code_seq"', 1, false);


--
-- TOC entry 4568 (class 0 OID 0)
-- Dependencies: 282
-- Name: BayLineTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."BayLineTypes_Code_seq"', 1, false);


--
-- TOC entry 4569 (class 0 OID 0)
-- Dependencies: 287
-- Name: LengthOfTime_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."LengthOfTime_Code_seq"', 1, false);


--
-- TOC entry 4570 (class 0 OID 0)
-- Dependencies: 291
-- Name: PaymentTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."PaymentTypes_Code_seq"', 1, false);


--
-- TOC entry 4571 (class 0 OID 0)
-- Dependencies: 293
-- Name: ProposalStatusTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."ProposalStatusTypes_Code_seq"', 1, false);


--
-- TOC entry 4572 (class 0 OID 0)
-- Dependencies: 298
-- Name: RestrictionPolygonTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."RestrictionPolygonTypes_Code_seq"', 21, true);


--
-- TOC entry 4573 (class 0 OID 0)
-- Dependencies: 299
-- Name: RestrictionShapeTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."RestrictionShapeTypes_Code_seq"', 1, false);


--
-- TOC entry 4574 (class 0 OID 0)
-- Dependencies: 301
-- Name: SignOrientationTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."SignOrientationTypes_Code_seq"', 1, false);


--
-- TOC entry 4575 (class 0 OID 0)
-- Dependencies: 305
-- Name: SignTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."SignTypes_Code_seq"', 1, false);


--
-- TOC entry 4576 (class 0 OID 0)
-- Dependencies: 309
-- Name: TimePeriods_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."TimePeriods_Code_seq"', 1, false);


--
-- TOC entry 4577 (class 0 OID 0)
-- Dependencies: 311
-- Name: UnacceptableTypes_Code_seq; Type: SEQUENCE SET; Schema: toms_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"toms_lookups"."UnacceptableTypes_Code_seq"', 1, false);


--
-- TOC entry 4501 (class 0 OID 206111)
-- Dependencies: 320 4509
-- Name: BayTypesInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."BayTypesInUse_View";


--
-- TOC entry 4502 (class 0 OID 206116)
-- Dependencies: 321 4509
-- Name: LineTypesInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."LineTypesInUse_View";


--
-- TOC entry 4488 (class 0 OID 204919)
-- Dependencies: 307 4509
-- Name: RestrictionPolygonTypesInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."RestrictionPolygonTypesInUse_View";


--
-- TOC entry 4487 (class 0 OID 204911)
-- Dependencies: 306 4509
-- Name: SignTypesInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."SignTypesInUse_View";


--
-- TOC entry 4506 (class 0 OID 208425)
-- Dependencies: 325 4509
-- Name: TimePeriodsInUse_View; Type: MATERIALIZED VIEW DATA; Schema: toms_lookups; Owner: postgres
--

REFRESH MATERIALIZED VIEW "toms_lookups"."TimePeriodsInUse_View";


-- Completed on 2020-06-17 13:06:20

--
-- PostgreSQL database dump complete
--

