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
-- TOC entry 4450 (class 0 OID 294784)
-- Dependencies: 277
-- Data for Name: ActionOnProposalAcceptanceTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."ActionOnProposalAcceptanceTypes" ("Code", "Description") VALUES (1, 'Open');
INSERT INTO "toms_lookups"."ActionOnProposalAcceptanceTypes" ("Code", "Description") VALUES (2, 'Close');


--
-- TOC entry 4452 (class 0 OID 294792)
-- Dependencies: 279
-- Data for Name: AdditionalConditionTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--



--
-- TOC entry 4454 (class 0 OID 294797)
-- Dependencies: 281
-- Data for Name: BayLineTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (102, 'Business Permit Holder Bays');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (106, 'Ambulance Bays');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (107, 'Bus Stop');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (114, 'Loading Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (121, 'Taxi Rank');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (122, 'Bus Stand');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (126, 'Limited Waiting');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (127, 'Free Bays (No Limited Waiting)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (109, 'Buses Only Bays');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (130, 'Private Parking/Residents only Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (132, 'Red Route Doctors only');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (202, 'No Waiting At Any Time (DYL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (203, 'Zig Zag - School');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (204, 'Zig Zag - Fire');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (205, 'Zig Zag - Police');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (206, 'Zig Zag - Ambulance');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (207, 'Zig Zag - Hospital');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (208, 'Zig Zag - Yellow (other)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (209, 'Crossing - Zebra');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (210, 'Crossing - Pelican');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (211, 'Crossing - Toucan');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (212, 'Crossing - Puffin');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (213, 'Crossing - Equestrian');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (214, 'Crossing - Signalised');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (215, 'Crossing - Unmarked and no signals');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (219, 'Private Road');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (216, 'Unmarked Area (Acceptable)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (220, 'Unmarked Area (Unacceptable)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (231, 'Resident Permit Holders (zone)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (108, 'Car Club bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (115, 'Loading Bay/Disabled Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (128, 'Loading Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (129, 'Limited Waiting Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (110, 'Disabled Blue Badge');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (111, 'Disabled bay - personalised');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (112, 'Diplomatic Only Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (113, 'Doctor bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (116, 'Cycle Hire bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (123, 'Mobile Library bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (124, 'Electric Vehicle Charging Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (101, 'Resident Permit Holder Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (104, 'Resident/Business Permit Holder Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (119, 'On-Carriageway Bicycle Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (120, 'Police bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (103, 'Pay & Display/Pay by Phone Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (105, 'Shared Use Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (125, 'Other Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (117, 'Motorcycle Permit Holders bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (131, 'Permit Holder Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (218, 'No Stopping At Any Time (DRL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (201, 'No Waiting (Acceptable) (SYL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (217, 'No Stopping (Acceptable) (SRL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (221, 'No Waiting (Unacceptable) (SYL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (222, 'No Stopping (Unacceptable) (SRL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (118, 'Solo Motorcycle bay (Visitors)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (160, 'Disabled Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (161, 'Bus Stop (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (162, 'Bus Stand (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (163, 'Coach Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (164, 'Taxi Rank (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (165, 'Private Parking/Visitor Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (166, 'Private Parking/Disabled Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (167, 'Accessible Permit Holder Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (133, 'Shared Use (Business Permit Holders)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (134, 'Shared Use (Permit Holders)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (135, 'Shared Use (Residential Permit Holders)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (140, 'Loading Bay/Disabled Bay');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (141, 'Loading Bay/Disabled Bay/Parking Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (142, 'Parking Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (143, 'Loading Bay/Parking Bay (Red Route)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (144, 'Rubbish Bin Bays');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (145, 'Disabled Blue Badge within Zone');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (223, 'Other Line');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (224, 'No waiting (SYL)');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (225, 'Unmarked kerb line');
INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description") VALUES (146, 'Keep Clear (Other) area');

--
-- TOC entry 4458 (class 0 OID 294812)
-- Dependencies: 285
-- Data for Name: GeomShapeGroupType; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."GeomShapeGroupType" ("Code") VALUES ('LineString');
INSERT INTO "toms_lookups"."GeomShapeGroupType" ("Code") VALUES ('Polygon');

--
-- TOC entry 4456 (class 0 OID 294802)
-- Dependencies: 283
-- Data for Name: BayTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (101, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (103, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (105, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (107, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (108, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (110, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (111, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (115, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (116, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (117, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (118, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (119, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (124, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (114, 'Polygon', NULL);

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
-- TOC entry 4461 (class 0 OID 294823)
-- Dependencies: 288
-- Data for Name: LineTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (224, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (202, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (203, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (209, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (214, 'LineString', NULL);


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
-- TOC entry 4465 (class 0 OID 294841)
-- Dependencies: 292
-- Data for Name: ProposalStatusTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."ProposalStatusTypes" ("Code", "Description") VALUES (1, 'In Preparation');
INSERT INTO "toms_lookups"."ProposalStatusTypes" ("Code", "Description") VALUES (2, 'Accepted');
INSERT INTO "toms_lookups"."ProposalStatusTypes" ("Code", "Description") VALUES (3, 'Rejected');


--
-- TOC entry 4467 (class 0 OID 294849)
-- Dependencies: 294
-- Data for Name: RestrictionGeomShapeTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (7, 'Other (please specify in notes)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (21, 'Parallel Bay (Polygon)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (24, 'Perpendicular Bay (Polygon)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (25, 'Echelon Bay (Polygon)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (28, 'Outline Bay (Polygon)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (35, 'Dropped Kerb (Crossover)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (50, 'Polygon');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (2, 'Half on/Half off Bay (LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (3, 'On Pavement Bay ((LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (4, 'Perpendicular Bay (LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (5, 'Echelon Bay (LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (1, 'Parallel Bay (LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (6, 'Perpendicular on Pavement Bay (LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (10, 'Parallel Line');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (11, 'Parallel Line with loading');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (12, 'Zig-Zag Line');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (8, 'Outline Bay (LineString)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (22, 'Half on/Half off Bay (Polygon)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (23, 'On Pavement Bay (Polygon)');
INSERT INTO "toms_lookups"."RestrictionGeomShapeTypes" ("Code", "Description") VALUES (26, 'Perpendicular on Pavement Bay (Polygon)');


--
-- TOC entry 4468 (class 0 OID 294855)
-- Dependencies: 295
-- Data for Name: RestrictionPolygonTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."RestrictionPolygonTypes" ("Code", "Description") VALUES (1, 'Greenway');
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


--
-- TOC entry 4469 (class 0 OID 294861)
-- Dependencies: 296
-- Data for Name: RestrictionPolygonTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (1, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (3, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (4, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (2, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (5, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (6, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (20, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (7, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (8, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (21, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (22, 'Polygon', NULL);


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
-- TOC entry 4476 (class 0 OID 294892)
-- Dependencies: 303
-- Data for Name: SignTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (6);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (7);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (8);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (10);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (11);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (14);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (17);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (19);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (20);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (21);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (22);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (23);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (24);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (26);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (28);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (31);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (32);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (33);
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (34);


--
-- TOC entry 4479 (class 0 OID 294904)
-- Dependencies: 306
-- Data for Name: TimePeriods; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (225, 'Jan-July 8.00pm-10.00am Aug 8.00pm-9.00am Sep-Nov 8.00pm-10.00am Dec 8.00pm-9.00am', 'Jan-July 8.00pm-10.00am;Aug 8.00pm-9.00am;Sep-Nov 8.00pm-10.00am;Dec 8.00pm-9.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (103, '6.30pm-7.00am', '6.30pm-7.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (102, '6.00pm-7.00am', '6.00pm-7.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (226, 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (111, 'At Any Time May-Sept', 'At Any Time May-Sept');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (217, 'Mon-Fri 8.00am-8.00pm', 'Mon-Fri 8.00am-8.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (219, 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm Fri 8.30am-9.15am 11.45am-1.15pm', 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm;Fri 8.30am-9.15am 11.45am-1.15pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (218, 'Mon-Fri 7.30am-9.00am', 'Mon-Fri 7.30am-9.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (222, 'Mon-Fri 8.30am-6.00pm', 'Mon-Fri 8.30am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (162, 'Mon-Sat 9.00am-5.30pm', 'Mon-Sat 9.00am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (163, 'Mon-Sun 10.30am-4.30pm', 'Mon-Sun 10.30am-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (169, 'Sat-Sun 10.00am-4.00pm', 'Sat-Sun 10.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (170, 'Sat-Sun 8.00am-6.00pm May-Sept', 'Sat-Sun 8.00am-6.00pm May-Sept');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (171, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (139, 'Mon-Fri 8.30am-4.30pm', 'Mon-Fri 8.30am-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (201, 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (221, 'Mon-Sat 8.00am-4.00pm', 'Mon-Sat 8.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (147, 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (133, 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (141, 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm', 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (12, 'Mon-Fri 8.30am-6.30pm', 'Mon-Fri 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (33, 'Mon-Sat 8.30am-6.30pm', 'Mon-Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (45, 'Mon-Sat 9.30am-6.30pm', 'Mon-Sat 9.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (19, 'Mon-Fri 9.00am-4.00pm', 'Mon-Fri 9.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (26, 'Mon-Sat 7.00am-6.30pm', 'Mon-Sat 7.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (83, 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (124, 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (118, 'Mon-Fri 7.30am-5.00pm', 'Mon-Fri 7.30am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (119, 'Mon-Fri 7.30am-6.30pm Sat-Sun 10.00am-5.30pm', 'Mon-Fri 7.30am-6.30pm;Sat-Sun 10.00am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (120, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (121, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (75, 'Mon-Fri 8.00am-4.00pm', 'Mon-Fri 8.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (14, 'Mon-Fri 8.00am-6.30pm', 'Mon-Fri 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (15, 'Mon-Fri 8.00am-6.00pm', 'Mon-Fri 8.00am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (101, '6.00am-10.00pm', '6.00am-10.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (78, 'Unknown - no sign', 'Unknown - no sign');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (10, 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (11, 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (16, 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (34, 'Mon-Sat 8.30am-6.30pm Sun 11.00am-5.00pm', 'Mon-Sat 8.30am-6.30pm;Sun 11.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (43, 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (97, 'Mon-Fri 8.30am-5.30pm', 'Mon-Fri 8.30am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (203, 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (204, 'Mon-Fri 9.30am-4pm Sat All day', 'Mon-Fri 9.30am-4pm;Sat All day');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (205, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (107, '8.00am-6.00pm', '8.00am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (108, '8.00am-6.00pm 2.15pm-4.00pm', '8.00am-6.00pm 2.15pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (126, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-1.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (127, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-Noon', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-Noon');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (128, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-12.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-12.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (129, 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm', 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (130, 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (131, 'Mon-Fri 8.00am-9.00am Mon-Thurs 2.30pm-3.45pm Fri Noon-1.30pm', 'Mon-Fri 8.00am-9.00am;Mon-Thurs 2.30pm-3.45pm;Fri Noon-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (132, 'Mon-Fri 8.00am-9.15am', 'Mon-Fri 8.00am-9.15am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (134, 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (135, 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (136, 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm', 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (137, 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (138, 'Mon-Fri 8.15am-5.30pm Sat 8.15am-1.30pm', 'Mon-Fri 8.15am-5.30pm;Sat 8.15am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (142, 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm', 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (140, 'Mon-Fri 8.30am-5.00pm', 'Mon-Fri 8.30am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (143, 'Mon-Fri 9.00am-5.00pm', 'Mon-Fri 9.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (144, 'Mon-Fri 9.00am-6.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.00am-6.00pm;Sat 9.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (145, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-1.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (146, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-5.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (148, 'Mon-Fri 9.15am-4.30pm', 'Mon-Fri 9.15am-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (156, 'Mon-Fri 9.30am-4.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 9.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (164, 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (212, 'Mon-Fri 8.00am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 8.00am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (125, 'Mon-Fri 8.00am-5.30pm', 'Mon-Fri 8.00am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (40, 'Mon-Sat 8.00am-6.00pm', 'Mon-Sat 8.00am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (123, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm Sat 8.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm;Sat 8.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (109, '8.15am-9.00am 11.30am-1.15pm', '8.15am-9.00am 11.30am-1.15pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (168, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.30am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.30am Noon-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (39, 'Mon-Sat 8.00am-6.30pm', 'Mon-Sat 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (228, 'Mon-Fri 9.30am-4.00pm', 'Mon-Fri 9.30am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (99, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (167, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (105, '7.30am-6.30pm', '7.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (106, '8.00am-5.30pm', '8.00am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (213, 'Mon-Sat 8.30am-5.30pm', 'Mon-Sat 8.30am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (110, '9.00am-5.30pm', '9.00am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (8, 'Mon-Fri 7.00am-7.00pm', 'Mon-Fri 7.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (149, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-1.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (150, 'Mon-Fri 9.15pm-8.00am', 'Mon-Fri 9.15pm-8.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (151, 'Mon-Fri 9.30am-11.00am', 'Mon-Fri 9.30am-11.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (152, 'Mon-Fri 9.30am-3.30pm', 'Mon-Fri 9.30am-3.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (153, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (154, 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am', 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (155, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (202, 'Mon-Sat 8.15am-6.00pm', 'Mon-Sat 8.15am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (115, 'Mon-Fri 11.30am-1.00pm', 'Mon-Fri 11.30am-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (122, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am;4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (157, 'Mon-Sat 7.00am-6.00pm', 'Mon-Sat 7.00am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (158, 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (160, 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (159, 'Mon-Sat 7.30am-6.30pm', 'Mon-Sat 7.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (161, 'Mon-Sat 8.30am-6.00pm', 'Mon-Sat 8.30am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (206, 'Sat 1.30pm-6.30pm', 'Sat 1.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (224, '7.00am-7.00pm', '7.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (1, 'At Any Time', 'At Any Time');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (210, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (211, 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (220, 'Mon-Sat 9.00am-6.00pm', 'Mon-Sat 9.00am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (227, 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (215, '8.00am-9.30am 4.00pm-6.00pm', '8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (216, 'Mon-Fri 7.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (166, 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm Fri 11.45am-1.15pm', 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm;Fri 11.45am-1.15pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (104, '7.00am-8.00pm', '7.00am-8.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (165, 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (98, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (112, 'Mon-Fri 1.30pm-3.00pm', 'Mon-Fri 1.30pm-3.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (113, 'Mon-Fri 10.00am-11.30am', 'Mon-Fri 10.00am-11.30am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (2, 'Mon-Fri 10.00am-3.30pm', 'Mon-Fri 10.00am-3.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (114, 'Mon-Fri 11.00am-12.30pm', 'Mon-Fri 11.00am-12.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (116, 'Mon-Fri 12.30pm-2.00pm', 'Mon-Fri 12.30pm-2.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (117, 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (207, '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm', '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (208, 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (209, '7.30am-9.30am 4.00pm-6.30pm', '7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (96, 'Mon-Fri 8.00am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.15am;4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (229, 'Mon-Sun 9.30am-4.00pm', 'Mon-Sun 9.30am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (230, 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ', 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (223, 'Mon-Sat 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.30am-9.30am; 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (231, 'Mon-Sun', 'Mon-Sun');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (232, '10.30am-11.00pm', '10.30am-11.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (234, '10.30am-10.00pm', '10.30am-10pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (235, 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm', 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (236, '7.00am-10.00am 4.00pm-6.30pm', '7.00am-10.00am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (237, 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm', 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (238, 'Mon-Sat 7.00am-8.00am', 'Mon-Sat 7.00am-8.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (239, 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (240, '8.30am-6.30pm', '8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (241, 'Mon-Fri 12 Noon-2.00pm', 'Mon-Fri 12 Noon-2.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (242, 'Mon-Fri 9.00am-10.00am', 'Mon-Fri 9.00am-10.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (243, 'Mon-Fri 11.00am-12 noon', 'Mon-Fri 11.00am-12 noon');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (244, 'Mon-Sat 9.00am-6.30pm', 'Mon-Sat 9.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (245, 'Mon-Fri 8.00am-5.00pm', 'Mon-Fri 8.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (246, '7.00am-midnight', '7.00am-midnight');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (247, 'Mon-Sun 7.00am-5.00pm', 'Mon-Sun 7.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (248, 'Mon-Fri 9.00am-11.00am', 'Mon-Fri 9.00am-11.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (249, 'Mon-Sat 9.00am-5.00pm', 'Mon-Sat 9.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (250, 'Mon-Fri 8.30am-1.30pm', 'Mon-Fri 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (251, 'Mon-Fri 7.00am-2.00pm', 'Mon-Fri 7.00am-2.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (252, 'Mon-Fri 9.00am-8.00pm Sat 9.00-5.00pm Sun 1.00pm-5.00pm', 'Mon-Fri 9.00am-8.00pm Sat 9.00-5.00pm Sun 1.00pm-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (253, 'Mon-Sat 7.00am-7.00pm', 'Mon-Sat 7.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (254, 'Mon-Fri 8.15am-9.15am 2.45pm-4.00pm', 'Mon-Fri 8.15am-9.15am 2.45pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (255, 'Mon-Sat 8.00am-midnight', 'Mon-Sat 8.00am-midnight');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (256, 'Mon-Fri 8.30am-7.00pm Sat 8.30am-6.30pm', 'Mon-Fri 8.30am-7.00pm Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (257, 'Mon-Fri 8.00am-7.00pm', 'Mon-Fri 8.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (258, 'Mon-Fri 8.30am-9.30am 3.30pm-4.30pm', 'Mon-Fri 8.30am-9.30am 3.30pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (259, 'Mon-Fri 7.30am-4.30pm', 'Mon-Fri 7.30am-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (260, 'Fri 7.00am-6.30pm Sat 7.00am-1.30pm', 'Fri 7.00am-6.30pm Sat 7.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (261, 'Mon-Fri 8.00am-10.00am', 'Mon-Fri 8.00am-10.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (262, 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm Sun 1.00pm-5.00pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm Sun 1.00pm-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (233, '10.30am-midnight midnight-6.30am', '10.30am-midnight, midnight-6.30am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (263, '10.00pm-5.00am', '10.00pm-5.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (264, 'Mon-Sat 8.00am-7.00pm', 'Mon-Sat 8.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (265, '9.00pm-midnight midnight-3.00am', '9.00pm-midnight midnight-3.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (266, 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (267, 'Mon-Fri 8.30am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 8.30am-6.30pm Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (268, 'Mon-Fri 8.30am-10.00pm Sat 8.30am-1.30pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (269, 'Mon-Fri 8.00am-7.00pm Sat 8.00am-1.30pm', 'Mon-Fri 8.00am-7.00pm Sat 8.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (270, 'Mon-Fri 7.00am-6.30pm Sat 8.30am-6.30pm', 'Mon-Fri 7.00am-6.30pm Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (271, 'Mon-Fri 8.30am-9.30am 2.30pm-4.30pm', 'Mon-Fri 8.30am-9.30am 2.30pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (272, 'Mon-Fri 7.00am-6.30pm Sat 7.00am-1.30pm', 'Mon-Fri 7.00am-6.30pm Sat 7.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (273, 'Mon-Fri 8.00am-9.00am 3.00pm-5.00pm', 'Mon-Fri 8.00am-9.00am 3.00pm-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (274, 'Mon-Fri 8.30am-10.00pm', 'Mon-Fri 8.30am-10.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (275, 'Mon-Fri 10.00am-4.00pm Sat 10.00am-1.30pm', 'Mon-Fri 10.00am-4.00pm Sat 10.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (276, 'Mon-Fri 8.30am-6.30pm and Sat 7.00am-3.00pm', 'Mon-Fri 8.30am-6.30pm and Sat 7.00am-3.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (278, 'Mon-Fri 8.00am-10.00am 4.00pm-6.30pm Sat 8.00am-10.00am', 'Mon-Fri 8.00am-10.00am 4.00pm-6.30pm Sat 8.00am-10.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (279, 'Sat 8.30am-6.30pm', 'Sat 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (280, 'Mon-Fri 8.00am-9.00am 2.00pm-4.00pm', 'Mon-Fri 8.00am-9.00am 2.00pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (281, 'Mon-Fri 8.30am-9.30am 2.30pm-4.00pm', 'Mon-Fri 8.30am-9.30am 2.30pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (282, 'Mon-Thu 8.30am-6.30pm', 'Mon-Thu 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (283, 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm Sat 7.00am-1.30pm', 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm Sat 7.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (284, 'Fri 8.30am-6.30pm Sat 8.30am-1.30pm', 'Fri 8.30am-6.30pm Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (285, 'Mon-Fri 10.00am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 10.00am-6.30pm Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (286, 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm 7.30pm-8.00pm Sat 7.00am-1.30pm 7.30pm-8.00pm', 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm 7.30pm-8.00pm Sat 7.00am-1.30pm 7.30pm-8.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (287, 'Mon-Fri 7.30am-9.30am 3.00pm-6.00pm', 'Mon-Fri 7.30am-9.30am 3.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (290, 'Mon-Thu 8.30am-7.30pm Fri-Sat 8.30am-11.00pm Sun 10.00am-4.00pm', 'Mon-Thu 8.30am-7.30pm Fri-Sat 8.30am-11.00pm Sun 10.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (291, '8.00am-11.00pm', '8.00am-11.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (292, 'Mon-Fri 8.00am-9.30am 3.00pm-4.30pm', 'Mon-Fri 8.00am-9.30am 3.00pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (293, 'Mon-Fri 9.00am-5.30pm', 'Mon-Fri 9.00am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (294, 'Mon-Fri 10.00am-11.00am 2.00pm-3.00pm', 'Mon-Fri 10.00am-11.00am 2.00pm-3.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (296, 'Mon-Fri 1.00pm-2.00pm', 'Mon-Fri 1.00pm-2.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (297, 'Mon-Fri 12 noon-1.00pm', 'Mon-Fri 12 noon-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (298, 'Mon-Fri 10.00am-4.30pm', 'Mon-Fri 10.00am-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (0, NULL, NULL);
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (300, 'Mon-Sat 7.00am-10.00pm', 'Mon-Sat 7.00am-10.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (301, '6.30am-6.00pm', '6.30am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (302, 'Mon-Sat 6.00am-6.30pm', 'Mon-Sat 6.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (303, 'Mon-Fri 7.30am-9.30am 2.30pm-4.30pm', 'Mon-Fri 7.30am-9.30am 2.30pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (304, 'Mon-Fri 8.00am-9.00am 2.30pm-4.30pm term time only', 'Mon-Fri 8.00am-9.00am 2.30pm-4.30pm term time only');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (295, 'Mon-Fri 8.30am-4.00pm', 'Mon-Fri 8.30am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (306, 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (307, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (308, 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (309, 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (310, 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (311, 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (312, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (313, 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (314, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (315, 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (316, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (317, 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (318, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (328, '8.00am-7.00pm', '8.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (319, 'Sat-Sun & Bank Holidays 12 noon-6.00pm April-September', 'Sat-Sun & Bank Holidays 12 noon-6.00pm April-September');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (320, '8.00am-9.00pm', '8.00am-9.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (321, 'Mon-Fri 10.00am-12 noon 2.30pm-4.30pm', 'Mon-Fri 10.00am-12 noon 2.30pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (322, 'Mon-Sat 1.00pm-2.00pm', 'Mon-Sat 1.00pm-2.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (323, 'Mon-Fri 6.00am-5.00pm', 'Mon-Fri 6.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (324, 'Mon-Sun 8.00am-6.30pm', 'Mon-Sun 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (325, 'Mon-Fri 2.00pm-3.00pm', 'Mon-Fri 2.00pm-3.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (326, 'Mon-Fri 3.00pm-4.00pm', 'Mon-Fri 3.00pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (327, 'Mon-Sat 12 noon-1.00pm', 'Mon-Sat 12 noon-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (332, 'Mon-Sat 8.00am-9.30am 4.00pm-6.30pm', 'Mon-Sat 8.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (333, 'Mon-Fri 8.15am-9.15am 2.45pm-3.45pm', 'Mon-Fri 8.15am-9.15am 2.45pm-3.45pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (334, 'Mon-Fri 8.30am-9.15am 2.45pm-3.30pm', 'Mon-Fri 8.30am-9.15am 2.45pm-3.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (335, 'Mon-Sat 2.00pm-3.00pm', 'Mon-Sat 2.00pm-3.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (336, 'Mon-Fri 8.30am-9.30am 2.30pm-3.30pm', 'Mon-Fri 8.30am-9.30am 2.30pm-3.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (337, 'Mon-Fri 8.30am-9.30am 3.00pm-4.00pm', 'Mon-Fri 8.30am-9.30am 3.00pm-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (338, 'Mon-Fri 2.45pm-3.45pm', 'Mon-Fri 2.45pm-3.45pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (339, '8.30am-9.30am 2.30pm-3.30pm', '8.30am-9.30am 2.30pm-3.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (340, 'Mon-Fri 8.00am-9.30am 3.00pm-5.00pm', 'Mon-Fri 8.00am-9.30am 3.00pm-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (341, 'Mon-Fri 8.00am-6.30pm Sat 9.30am-12.30pm', 'Mon-Fri 8.00am-6.30pm Sat 9.30am-12.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (342, 'Mon-Fri Midnight-7.00am 8.00pm-Midnight Sat & Sun At Any Time', 'Mon-Fri Midnight-7.00am 8.00pm-Midnight Sat & Sun At Any Time');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (343, 'Mon-Fri 9.30am-4.30pm', 'Mon-Fri 9.30am-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (344, 'Mon-Sat 9.30am-5.30pm', 'Mon-Sat 9.30am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (345, 'Mon-Fri 10.30am-11.30am', 'Mon-Fri 10.30am-11.30am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (346, 'Mon-Fri 10.00am-4.00pm', 'Mon-Fri 10.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (347, 'Mon-Fri 7.00am-10.00am 4.00pm-7.00pm', 'Mon-Fri 7.00am-10.00am 4.00pm-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (348, 'Mon-Fri 8.15am-9.45am 3.00pm-4.30pm', 'Mon-Fri 8.15am-9.45am 3.00pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (349, 'Mon-Fri 6.30am-7.30am 9.30am-4.30pm 6.30pm-7.30pm', 'Mon-Fri 6.30am-7.30am 9.30am-4.30pm 6.30pm-7.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (288, 'Mon-Fri 10.00am-11.00am', 'Mon-Fri 10.00am-11.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (350, 'Mon-Fri 7.30am-9.30am 4.30pm-8.30pm', 'Mon-Fri 7.30am-9.30am 4.30pm-8.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (351, 'Mon-Fri 8.00am-9.30am 2.30pm-4.30pm', 'Mon-Fri 8.00am-9.30am 2.30pm-4.30pm');


--
-- TOC entry 4480 (class 0 OID 294910)
-- Dependencies: 307
-- Data for Name: TimePeriodsInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (10);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (11);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (14);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (15);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (16);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (33);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (39);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (40);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (43);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (1);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (153);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (126);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (212);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (211);


--
-- TOC entry 4483 (class 0 OID 294922)
-- Dependencies: 310
-- Data for Name: UnacceptableTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (2, 'Narrow Road');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (3, 'Obstruction');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (1, 'Crossover (vehicles)');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (4, 'Crossover (pedestrians/other)');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (5, 'Other');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (6, 'Corner');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (7, 'Garage frontage');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (8, 'Traffic flow');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (9, 'Edge of bay');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (10, 'Short section');

--
-- TOC entry 4540 (class 0 OID 0)
-- Dependencies: 223
-- Name: BayLinesFadedTypes_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."BayLinesFadedTypes_Code_seq"', 1, false);


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



SELECT pg_catalog.setval('"toms_lookups"."ActionOnProposalAcceptanceTypes_Code_seq"', 1, true);


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

