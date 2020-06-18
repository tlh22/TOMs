--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-06-18 18:49:26

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
-- TOC entry 4213 (class 0 OID 292745)
-- Dependencies: 212
-- Data for Name: ActionOnProposalAcceptanceTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."ActionOnProposalAcceptanceTypes" ("id", "Description") VALUES (1, 'Open');
INSERT INTO "public"."ActionOnProposalAcceptanceTypes" ("id", "Description") VALUES (2, 'Close');


--
-- TOC entry 4216 (class 0 OID 292756)
-- Dependencies: 215
-- Data for Name: BayLineTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (102, 'Business Permit Holder Bays');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (106, 'Ambulance Bays');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (107, 'Bus Stop');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (114, 'Loading Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (121, 'Taxi Rank');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (122, 'Bus Stand');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (126, 'Limited Waiting');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (127, 'Free Bays (No Limited Waiting)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (109, 'Buses Only Bays');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (130, 'Private Parking/Residents only Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (132, 'Red Route Doctors only');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (202, 'No Waiting At Any Time (DYL)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (203, 'Zig Zag - School');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (204, 'Zig Zag - Fire');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (205, 'Zig Zag - Police');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (206, 'Zig Zag - Ambulance');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (207, 'Zig Zag - Hospital');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (208, 'Zig Zag - Yellow (other)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (209, 'Crossing - Zebra');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (210, 'Crossing - Pelican');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (211, 'Crossing - Toucan');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (212, 'Crossing - Puffin');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (213, 'Crossing - Equestrian');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (214, 'Crossing - Signalised');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (215, 'Crossing - Unmarked and no signals');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (219, 'Private Road');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (216, 'Unmarked Area (Acceptable)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (220, 'Unmarked Area (Unacceptable)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (231, 'Resident Permit Holders (zone)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (108, 'Car Club bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (115, 'Loading Bay/Disabled Bay (Red Route)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (128, 'Loading Bay (Red Route)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (129, 'Limited Waiting Bay (Red Route)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (110, 'Disabled Blue Badge');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (111, 'Disabled bay - personalised');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (112, 'Diplomatic Only Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (113, 'Doctor bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (116, 'Cycle Hire bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (123, 'Mobile Library bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (124, 'Electric Vehicle Charging Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (101, 'Resident Permit Holder Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (104, 'Resident/Business Permit Holder Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (119, 'On-Carriageway Bicycle Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (120, 'Police bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (103, 'Pay & Display/Pay by Phone Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (105, 'Shared Use Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (125, 'Other Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (117, 'Motorcycle Permit Holders bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (131, 'Permit Holder Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (218, 'No Stopping At Any Time (DRL)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (201, 'No Waiting (Acceptable) (SYL)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (217, 'No Stopping (Acceptable) (SRL)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (221, 'No Waiting (Unacceptable) (SYL)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (222, 'No Stopping (Unacceptable) (SRL)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (118, 'Solo Motorcycle bay (Visitors)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (160, 'Disabled Bay (Red Route)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (161, 'Bus Stop (Red Route)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (162, 'Bus Stand (Red Route)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (163, 'Coach Bay (Red Route)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (164, 'Taxi Rank (Red Route)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (165, 'Private Parking/Visitor Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (166, 'Private Parking/Disabled Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (167, 'Accessible Permit Holder Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (133, 'Shared Use (Business Permit Holders)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (134, 'Shared Use (Permit Holders)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (135, 'Shared Use (Residential Permit Holders)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (140, 'Loading Bay/Disabled Bay');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (141, 'Loading Bay/Disabled Bay/Parking Bay (Red Route)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (142, 'Parking Bay (Red Route)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (143, 'Loading Bay/Parking Bay (Red Route)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (144, 'Rubbish Bin Bays');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (145, 'Disabled Blue Badge within Zone');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (223, 'Other Line');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (224, 'No waiting (SYL)');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (225, 'Unmarked kerb line');
INSERT INTO "public"."BayLineTypes" ("Code", "Description") VALUES (146, 'Keep Clear (Other) area');


--
-- TOC entry 4215 (class 0 OID 292753)
-- Dependencies: 214
-- Data for Name: BayLineTypesInUse; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (61, 101);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (62, 102);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (63, 103);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (64, 106);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (65, 107);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (66, 108);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (67, 109);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (68, 110);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (69, 111);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (70, 112);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (71, 113);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (72, 114);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (73, 115);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (74, 116);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (75, 117);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (76, 118);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (77, 119);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (78, 120);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (79, 121);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (80, 122);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (81, 123);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (82, 124);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (83, 125);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (84, 126);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (85, 127);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (86, 128);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (87, 130);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (88, 131);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (89, 133);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (90, 134);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (91, 135);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (92, 140);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (93, 141);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (94, 142);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (95, 143);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (96, 144);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (97, 168);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (98, 201);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (99, 202);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (100, 203);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (101, 204);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (102, 205);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (103, 206);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (104, 207);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (105, 208);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (106, 209);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (107, 210);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (108, 211);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (109, 212);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (110, 213);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (111, 214);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (112, 215);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (113, 216);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (114, 217);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (115, 218);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (116, 219);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (117, 220);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (118, 221);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (119, 222);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (120, 1103);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (121, 1106);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (122, 1107);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (123, 1108);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (124, 1109);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (125, 1110);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (126, 1113);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (127, 1114);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (128, 1118);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (129, 1119);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (130, 1120);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (131, 1121);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (132, 1122);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (133, 1124);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (134, 1126);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (135, 1131);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (136, 1134);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (137, 1142);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (138, 1144);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (139, 2201);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (140, 2202);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (141, 2203);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (142, 2209);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (143, 2218);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (144, 2410);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (145, 2411);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (147, 105);
INSERT INTO "public"."BayLineTypesInUse" ("gid", "Code") VALUES (148, 224);


--
-- TOC entry 4219 (class 0 OID 292764)
-- Dependencies: 218
-- Data for Name: BayLinesFadedTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."BayLinesFadedTypes" ("id", "Code", "Description", "Comment") VALUES (1, '1', 'No issue', NULL);
INSERT INTO "public"."BayLinesFadedTypes" ("id", "Code", "Description", "Comment") VALUES (6, '6', 'Other (please specify in notes)', NULL);
INSERT INTO "public"."BayLinesFadedTypes" ("id", "Code", "Description", "Comment") VALUES (2, '2', 'Slightly faded marking', NULL);
INSERT INTO "public"."BayLinesFadedTypes" ("id", "Code", "Description", "Comment") VALUES (3, '3', 'Very faded markings', NULL);
INSERT INTO "public"."BayLinesFadedTypes" ("id", "Code", "Description", "Comment") VALUES (4, '4', 'Markings not correctly removed', 'e.g. disabled bays no longer in use, may have not been correctly removed; this is different from faded markings, as the stress is not on repainting them, but rather remove the remaining markings');
INSERT INTO "public"."BayLinesFadedTypes" ("id", "Code", "Description", "Comment") VALUES (5, '5', 'Missing markings', NULL);


--
-- TOC entry 4221 (class 0 OID 292772)
-- Dependencies: 220
-- Data for Name: BayTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (102, 'Business Permit Holder Bays');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (106, 'Ambulance Bays');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (107, 'Bus Stop');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (114, 'Loading Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (121, 'Taxi Rank');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (122, 'Bus Stand');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (126, 'Limited Waiting');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (127, 'Free Bays (No Limited Waiting)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (109, 'Buses Only Bays');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (130, 'Private Parking/Residents only Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (108, 'Car Club bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (115, 'Loading Bay/Disabled Bay (Red Route)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (128, 'Loading Bay (Red Route)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (110, 'Disabled Blue Badge');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (111, 'Disabled bay - personalised');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (112, 'Diplomatic Only Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (113, 'Doctor bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (116, 'Cycle Hire bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (123, 'Mobile Library bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (124, 'Electric Vehicle Charging Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (101, 'Resident Permit Holder Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (119, 'On-Carriageway Bicycle Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (120, 'Police bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (103, 'Pay & Display/Pay by Phone Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (125, 'Other Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (117, 'Motorcycle Permit Holders bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (131, 'Permit Holder Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (118, 'Solo Motorcycle bay (Visitors)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (133, 'Shared Use (Business Permit Holders)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (134, 'Shared Use (Permit Holders)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (135, 'Shared Use (Residential Permit Holders)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (140, 'Loading Bay/Disabled Bay');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (141, 'Loading Bay/Disabled Bay/Parking Bay (Red Route)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (142, 'Parking Bay (Red Route)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (143, 'Loading Bay/Parking Bay (Red Route)');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (144, 'Rubbish Bin Bays');
INSERT INTO "public"."BayTypes" ("Code", "Description") VALUES (168, 'RNLI Permit Holders only');


--
-- TOC entry 4223 (class 0 OID 292783)
-- Dependencies: 222
-- Data for Name: Bays; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000001920E4BC4DB1341759437603B932441E5DF1B92ECDB13416CC742E040932441', 10.44, 101, -1, 15, NULL, NULL, NULL, NULL, 'B_ 0078346', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 24, NULL, NULL, 345, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, NULL, NULL, 0, NULL, 'f0ce05a2-7b0e-410b-8556-05ecb0aa485e');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000002A5328AE00DC134119FE6D144E9324411535FCBE3ADC1341228EE52D56932441', 15.07, 103, 3, 15, 4, 3, 1, NULL, 'B_ 0078347', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 21, NULL, NULL, 344, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, 'f071e490-9f42-4872-a064-a894927c6c4e');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000001535FCBE3ADC1341228EE52D569324410652D4084EDC13412B739DE458932441', 5.01, 110, -1, 1, NULL, NULL, NULL, NULL, 'B_ 0078348', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 21, NULL, NULL, 344, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, 'dc0b1bfb-9532-48ea-8d90-85bddac2f17b');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000049D8D8FE9ADC13413FFA2FD063932441034BB983C1DC13415214783469932441', 10, 105, -1, 39, 4, 3, 1, NULL, 'B_ 0078349', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 22, 'Queen Street', '1001', 344, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, 'e6e923ce-6a61-4e6e-b856-db2f20e395e6');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000034BB983C1DC13415214783469932441FED96C54E0DC1341C8C2B1846D932441', 8, 118, -1, 1, NULL, 9, NULL, NULL, 'B_ 0078350', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 25, 'Queen Street', '1001', 344, NULL, NULL, NULL, NULL, 10, '2020-05-01', NULL, 'A', NULL, 0, NULL, '4c5913dd-0412-439f-8c8b-7eecbcfee7a7');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000001586BD1B1ADD1341E4E91D9B75932441101571EC38DD13415A9857EB79932441', 8, 101, -1, 14, NULL, NULL, NULL, NULL, 'B_ 0078351', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 23, 'Queen Street', '1001', 344, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, 'c31f7cb7-e29d-4117-94b0-307ac280c192');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000101571EC38DD13415A9857EB799324416D4EE12E4CDD134163A57B9D7C932441', 5, 110, -1, 1, NULL, NULL, NULL, NULL, 'B_ 0078352', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 26, 'Queen Street', '1001', 344, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '0e213bb8-28b6-4e6b-a48a-954b40821b6c');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000400000032D69CDAEDDA134164CF70BE2793244119D3F748FFDA13413ADF45D722932441760C688B12DB134144EC69892593244182DEC6591CDB13411EAD97402E932441', 15, 114, -1, 15, NULL, 9, 1, NULL, 'B_ 0078353', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 28, 'Queen Street', '1001', 344, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, 'b81c152e-0d1d-4ba0-bb96-320f02f4a18a');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000050D32ACD0EDE13410F19D16E5F9224412621CC03C2DD1341853FBE3554922441', 20, 107, -1, 1, NULL, NULL, NULL, NULL, 'B_ 0078354', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 1, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '0f493e9b-5e4a-4854-892d-085840a437fc');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000002621CC03C2DD1341853FBE355492244111C81C9F9BDD1341C0D234994E922441', 10, 119, -1, 1, NULL, NULL, NULL, NULL, 'B_ 0078355', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 4, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '474b2ac4-5c10-4764-b25b-e9cda052aba6');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000011C81C9F9BDD1341C0D234994E922441FC6E6D3A75DD1341FB65ABFC48922441', 10, 115, -1, 15, NULL, NULL, NULL, NULL, 'B_ 0078356', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 2, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '12cc30fe-cb33-4570-b228-f2402947bb5e');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000FC6E6D3A75DD1341FB65ABFC48922441E715BED54EDD134136F9216043922441', 10, 116, -1, 1, NULL, NULL, NULL, NULL, 'B_ 0078357', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 5, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, 190, '2020-05-01', NULL, 'A', NULL, 0, NULL, '2a5d0a0b-2c87-4257-9147-0bdeeb8af0d2');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000BD635F0C02DD1341AD1F0F273892244113B66C55E3DC13414262D4A933922441', 8, 115, -1, 15, NULL, NULL, NULL, NULL, 'B_ 0078358', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 6, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '9775d869-1cea-4098-9b2a-ce019afa458e');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000013B66C55E3DC13414262D4A93392244174B065BEA9DC13411B3F063F2B922441', 15, 119, -1, 15, NULL, NULL, NULL, NULL, 'B_ 0078359', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 3, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '014d6fa9-0c7b-49f5-a9d1-5a4dbef9fad4');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000005000000CBFC6A88C7DD1341F817CC58449224419CFD1396EDDD1341CD5A9DE849922441D5A1D4AEF6DD13419D1D51593A922441EE54232BD0DD1341D707ECF234922441CBFC6A88C7DD1341F817CC5844922441', 36.01, 116, -1, 1, NULL, NULL, NULL, NULL, 'B_ 0078360', '2020-05-27 22:39:13.070947', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 8, 'Hanover Street', '1003', 343, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'B', 'C2', 0, NULL, '6500cbc0-5072-4a46-a130-6e79a214d896');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000009B77492FE7DD13418DE8663C3F93244153152B22FDDD1341C451FD2617932441', 20.78, 103, -1, 153, NULL, NULL, NULL, NULL, 'B_ 0078361', '2020-05-27 22:41:28.575475', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 21, 'North St David Street', '1005', 74, 325475.40475398174, 674195.2220350107, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 0, NULL, '62b0bf76-1ad4-4afb-97b4-abf7bc32d05a');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000050D32ACD0EDE13410F19D16E5F9224419849A0382CDE13419D3F99BB63922441', 7.66, 114, -1, 15, NULL, 9, 1, NULL, 'B_ 0078362', '2020-05-29 09:52:22.645068', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 21, 'George Street', '1012', 163, NULL, NULL, NULL, NULL, NULL, '2020-05-15', NULL, 'A', NULL, 0, NULL, '254bdb0f-cc6d-47fc-a4b5-14dc4d244c1d');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000040000003B941B0A64DE13415238B2385B9224416C1A8BF56CDE1341A59F99EE4A9224418A80DA7146DE1341AB4A3388459224410CEAB6713DDE1341626F9B9455922441', 26.78, 103, -1, 16, 4, 10, 10, NULL, 'B_ 0078363', '2020-05-29 14:24:37.835215', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 28, 'Hanover Street', '1003', 164, NULL, NULL, NULL, NULL, NULL, '2020-05-01', '2020-05-20', 'B', 'C2', 0, NULL, '59a25fd9-3b04-44bb-a77b-f5bb383be9ee');
INSERT INTO "public"."Bays" ("id", "geom", "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000F832A280A1DB1341D8E1C700D6912441D7704B61E1DB1341A68088F5DE912441', 16.59, 101, -1, 39, NULL, NULL, NULL, NULL, 'B_ 0078364', '2020-06-04 15:53:21.426686', NULL, 'tim.hancock', 0, 0, NULL, NULL, NULL, NULL, 21, 'Hanover Street', '1004', 344, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'B', NULL, 0, NULL, 'd78254ca-28af-4f68-abc5-bfb4b12759a6');


--
-- TOC entry 4224 (class 0 OID 292790)
-- Dependencies: 223
-- Data for Name: BaysLines_SignIssueTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."BaysLines_SignIssueTypes" ("id", "Code", "Description", "Comment") VALUES (1, '1', 'No issues', NULL);
INSERT INTO "public"."BaysLines_SignIssueTypes" ("id", "Code", "Description", "Comment") VALUES (2, '2', 'Inconsistent sign', NULL);
INSERT INTO "public"."BaysLines_SignIssueTypes" ("id", "Code", "Description", "Comment") VALUES (3, '3', 'Missing sign', 'If there''s not even a pole, we need a place where to store this information');
INSERT INTO "public"."BaysLines_SignIssueTypes" ("id", "Code", "Description", "Comment") VALUES (4, '4', 'Other (please specify in notes)', NULL);


--
-- TOC entry 4227 (class 0 OID 292800)
-- Dependencies: 226
-- Data for Name: CPZs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4228 (class 0 OID 292806)
-- Dependencies: 227
-- Data for Name: ControlledParkingZones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."ControlledParkingZones" ("gid", "cacz_ref_n", "date_last_", "no_osp_spa", "no_pnr_spa", "no_pub_spa", "no_res_spa", "zone_no", "type", "geom", "WaitingTimeID", "CPZ", "OpenDate", "CloseDate", "RestrictionID", "GeometryID") VALUES (39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Controlled Parking Zone', '0103000020346C000001000000060000003EB8E6A0B3DA13411AD3BEE6279324413478C568C7DD1341F259E02B96932441339D5F2C6FDE134179B9FE2E65922441092AB0D088DB1341D771ABAEF8912441A0976E9257DB134150B81E05029224413EB8E6A0B3DA13411AD3BEE627932441', 15, 'A', '2020-05-01', NULL, '{4e5323f1-659a-4758-80c4-8bb00ff1fd91}', 'C_ 000000004');
INSERT INTO "public"."ControlledParkingZones" ("gid", "cacz_ref_n", "date_last_", "no_osp_spa", "no_pnr_spa", "no_pub_spa", "no_res_spa", "zone_no", "type", "geom", "WaitingTimeID", "CPZ", "OpenDate", "CloseDate", "RestrictionID", "GeometryID") VALUES (40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Controlled Parking Zone', '0103000020346C00000100000015000000339D5F2C6FDE134179B9FE2E6592244106FC6D152ADF13414580FDBB1591244115D0EB770CDC134148EA7D19A3902441AF1C773A03DC1341EDD475AAA7902441F344D81C0DDC134173753AA6AF902441DA41335A0CDC13411BAA2F93BC9024414C10E32F00DC1341380DD0E7D49024417AF98668F3DB1341A323DF14ED902441172B30ECC7DB1341DABE0D5A3F91244199ED8982C4DB1341A587E4CF4491244127ED4BB7B8DB1341FA21AEAE57912441A22F13A576DB13416652C974CE9124411DCD590172DB1341D84240B9CD912441A22F13A576DB13416652C974CE912441F707997380DB1341234C2F01D0912441344F6CF091DB1341A8ECF3FCD791244173499F2995DB13414191DC94DC9124412D6EDE8A99DB1341CB58A3D2E29124413DE0F71E96DB1341E60B465EEF912441092AB0D088DB1341D771ABAEF8912441339D5F2C6FDE134179B9FE2E65922441', 39, 'B', '2020-05-01', NULL, '{40eb51f6-f229-48d6-9efb-64900938a5e3}', 'C_ 000000005');


--
-- TOC entry 4231 (class 0 OID 292820)
-- Dependencies: 230
-- Data for Name: EDI_RoadCasement_Polyline; Type: TABLE DATA; Schema: public; Owner: edi_operator
--



--
-- TOC entry 4232 (class 0 OID 292826)
-- Dependencies: 231
-- Data for Name: EDI_Sections; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4233 (class 0 OID 292832)
-- Dependencies: 232
-- Data for Name: LengthOfTime; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (12, 12, 'No restriction', NULL);
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (13, 13, 'Other (please specify in notes)', NULL);
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (3, 3, '2 hours', '2h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (4, 4, '3 hours', '3h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (5, 5, '4 hours', '4h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (6, 6, '5 hours', '5h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (7, 7, '5 minutes', '5m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (8, 8, '10 minutes', '10m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (9, 9, '20 minutes', '20m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (10, 10, '30 minutes', '30m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (11, 11, '40 minutes', '40m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (14, 14, '6 hours', '6h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (15, 15, '9 hours', '9h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (2, 2, '90 minutes', '90m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (16, 16, '45 minutes', '45m');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (1, 1, '60 minutes', '1h');
INSERT INTO "public"."LengthOfTime" ("id", "Code", "Description", "LabelText") VALUES (17, 17, '10 hours', '10h');


--
-- TOC entry 4235 (class 0 OID 292840)
-- Dependencies: 234
-- Data for Name: LineTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (202, 'No Waiting At Any Time (DYL)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (203, 'Zig Zag - School');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (204, 'Zig Zag - Fire');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (205, 'Zig Zag - Police');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (206, 'Zig Zag - Ambulance');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (207, 'Zig Zag - Hospital');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (208, 'Zig Zag - Yellow (other)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (209, 'Crossing - Zebra');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (210, 'Crossing - Pelican');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (211, 'Crossing - Toucan');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (212, 'Crossing - Puffin');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (213, 'Crossing - Equestrian');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (214, 'Crossing - Signalised');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (215, 'Crossing - Unmarked and no signals');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (219, 'Private Road');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (216, 'Unmarked Area (Acceptable)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (220, 'Unmarked Area (Unacceptable)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (218, 'No Stopping At Any Time (DRL)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (201, 'No Waiting (Acceptable) (SYL)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (217, 'No Stopping (Acceptable) (SRL)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (221, 'No Waiting (Unacceptable) (SYL)');
INSERT INTO "public"."LineTypes" ("Code", "Description") VALUES (222, 'No Stopping (Unacceptable) (SRL)');


--
-- TOC entry 4237 (class 0 OID 292849)
-- Dependencies: 236
-- Data for Name: Lines; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000088B9650BCDD13419A8B944F8C9324416AF986965BDE13414B93E3A76A922441', 150.2, 224, 126, 11, NULL, 'L_ 000000009', '2020-05-24 22:42:01.112644', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'North St David Street', '1005', 74, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, '10901e3d-dc68-4dfc-a036-dbb930babcfb');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000542996A5E7DB1341E0E076914A9324412A5328AE00DC134119FE6D144E932441', 6.5, 202, 1, 16, NULL, 'L_ 000000002', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, NULL, NULL, 344, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'ceb9e35c-0372-4cf0-ac38-f150eb200ea0');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000008CED0606BFDB134108FBC40545932441180846FC71DB1341E2C6343D3A932441', 20, 224, 14, 16, NULL, 'L_ 000000003', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'Queen Street', '1001', 344, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'f32e4d66-0d7f-4dbc-a48c-c8c44dc1a191');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000000652D4084EDC13412B739DE45893244149D8D8FE9ADC13413FFA2FD063932441', 20, 224, 15, 1, NULL, 'L_ 000000004', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'Queen Street', '1001', 344, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'c0e47ca6-6148-4a9d-8c33-f576b733ad32');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000180846FC71DB1341E2C6343D3A932441A42285F224DB1341BC92A4742F932441', 20, 209, 1, NULL, NULL, 'L_ 000000005', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'Queen Street', '1001', 344, 12, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'a9d38e70-bc08-4f46-8497-71bdad52dad7');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000FED96C54E0DC1341C8C2B1846D9324411586BD1B1ADD1341E4E91D9B75932441', 15, 202, 1, 1, NULL, 'L_ 000000006', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'Queen Street', '1001', 344, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'a530ddfb-316a-40da-abfd-ba111d1c35b4');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000E715BED54EDD134136F9216043922441BD635F0C02DD1341AD1F0F2738922441', 20, 203, 11, NULL, NULL, 'L_ 000000008', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1012', 163, 12, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, '5dd050cb-8bde-400d-8f03-fccbf492467a');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000074B065BEA9DC13411B3F063F2B922441EA030E8C96DC1341B988C17028922441', 5, 214, 1, NULL, NULL, 'L_ 000000010', '2020-05-27 22:39:13.070947', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1012', 163, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'dca8d05a-e437-473d-b95d-d50c792e1c97');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000003A4E41B6E6DD1341E9F20B353F93244169AB00BAFCDD13411B0CD92B17932441', 20.76, 224, 211, 11, NULL, 'L_ 000000011', '2020-05-28 07:35:44.61791', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'North St David Street', '1005', 74, 10, 325483.2716653942, 674188.8537149023, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 325483.11919353675, 674191.4374914765, NULL, 0, NULL, '1bf6eef1-37f8-42b6-82b2-848f577146b6');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C000002000000088B9650BCDD13419A8B944F8C9324413A4E41B6E6DD1341E9F20B353F932441', 39.98, 224, 126, 11, NULL, 'L_ 000000013', '2020-05-28 07:38:36.157711', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'North St David Street', '1005', 74, 10, 325459.9293151222, 674215.5959957276, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 325460.57209681097, 674210.0364140678, NULL, 0, NULL, '825fc78e-a8c7-4372-8993-462f37605c68');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000069AB00BAFCDD13411B0CD92B179324416AF986965BDE13414B93E3A76A922441', 89.46, 224, 126, 11, NULL, 'L_ 000000012', '2020-05-28 07:38:36.157711', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'North St David Street', '1005', 74, 10, 325531.3759761611, 674158.4891387734, NULL, NULL, NULL, '2020-05-01', NULL, 'A', NULL, 325531.58157050796, 674153.4135325637, NULL, 0, NULL, 'ed8e2e61-3efb-4a89-86ff-4d4200e72803');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000000DCA88965BDE13412F33E5A76A9224419849A0382CDE13419D3F99BB63922441', 12.34, 202, 1, 1, NULL, 'L_ 000000015', '2020-05-28 12:45:04.641037', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1012', 163, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'c7b3d64c-f42f-485d-969c-c52bad2e5fad');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000000DCA88965BDE13412F33E5A76A92244150D32ACD0EDE13410F19D16E5F922441', 20, 202, 1, 1, NULL, 'L_ 000000007', '2020-05-29 09:52:22.645068', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1012', 163, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-01', '2020-05-15', 'A', NULL, NULL, NULL, NULL, 0, NULL, '362db835-a235-49fa-8f90-2c37955fde39');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C00000200000047C7F76A3FDE13412546DE89669224419849A0382CDE13419D3F99BB63922441', 5, 224, 14, 211, NULL, 'L_ 000000016', '2020-05-29 09:52:22.645068', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1012', 163, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-15', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'd4cd82f8-2a72-4232-9a0c-a27392348174');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000000DCA88965BDE13412F33E5A76A92244147C7F76A3FDE13412546DE8966922441', 7.34, 202, 1, 1, NULL, 'L_ 000000017', '2020-05-29 09:52:22.645068', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'George Street', '1012', 163, 10, NULL, NULL, NULL, NULL, NULL, '2020-05-15', NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'af46bcf3-5758-4f84-85bf-7800a562c8ae');
INSERT INTO "public"."Lines" ("id", "geom", "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID") VALUES (NULL, '0102000020346C0000020000005CE7BE55C7DA1341720F295A2293244194729EA664DB13410BDBE75908922441', 146.38, 224, 126, 16, NULL, 'L_ 000000018', '2020-05-29 22:50:34.159914', 'tim.hancock', 0, NULL, NULL, 0, NULL, NULL, 'Hanover Street', '1003', 254, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A', NULL, NULL, NULL, NULL, 0, NULL, 'a1a65fde-2217-434c-aa1d-54814642f447');


--
-- TOC entry 4238 (class 0 OID 292856)
-- Dependencies: 237
-- Data for Name: LookupCodeTransfers_Bays; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (1, 'Ambulance Bays', '1', '106');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (2, 'Bus Stand', '2', '122');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (3, 'Bus Stop', '3', '107');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (4, 'Buses Parking only', '4', '109');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (5, 'Business Permit Holders only', '5', '102');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (6, 'Car Club Bays', '6', '108');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (7, 'Cycle Hire scheme', '7', '116');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (8, 'Diplomat Bays', '8', '112');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (9, 'Disabled Bays (Blue Badge)', '9', '110');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (10, 'Disabled Bays (Personalised)', '10', '111');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (11, 'Doctor Bays', '11', '113');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (12, 'Electric Vehicle Charging Bay', '12', '124');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (13, 'Free Bays (No Limited Waiting)', '13', '127');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (14, 'Greenway Loading Bay', '14', '128');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (15, 'Greenway Loading and Disabled Bays', '15', '115');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (16, 'Greenway Loading, Disabled and Parking Bay', '16', '141');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (17, 'Greenway Loading and Parking Bay', '17', '143');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (18, 'Greenway Parking Bay', '18', '142');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (19, 'Limited Waiting (No Charge)', '19', '126');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (20, 'Loading only', '20', '114');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (21, 'Loading Bays & Disabled Bays', '21', '140');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (22, 'Mobile Library Bays', '22', '123');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (23, 'Motorcycle Bay (Permit Holders only)', '23', '117');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (24, 'Motorcycle Solo only', '24', '118');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (25, 'On-Street Cycle Bays', '25', '119');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (26, 'Other Bays (Please specify in notes)', '26', '125');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (27, 'Pay and Display/Pay by Phone', '27', '103');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (28, 'Permit Holders only', '28', '131');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (29, 'Police Bays', '29', '120');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (30, 'Private/Residents only', '30', '130');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (31, 'Resident Permit Holders only', '31', '101');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (32, 'Rubbish Bins Bays', '32', '144');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (33, 'Shared Use Bays (Business Permit Holders)', '33', '133');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (34, 'Shared Use Bays (Permit Holders)', '34', '134');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (35, 'Shared Use Bays (Resident Permit Holders)', '35', '135');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (36, 'Taxis only', '36', '121');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (37, 'Free Bays (No Limited Waiting) within CPZs', '37', '127');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (57, 'RNLI Permit Holders only', '40', '168');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (38, 'Disabled Bay (Blue Badge) (On street but not in TRO)', '109', '1110');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (39, 'Ambulance Bays (on street not in TRO)', '101', '1106');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (40, 'Rubbish Bin Bays (on street not in TRO)', '132', '1144');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (41, 'Car Club Bays (on street but not in TRO)', '106', '1108');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (42, 'Bus Stop (On street but not in TRO)', '103', '1107');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (43, 'Bus Stand (On street but not in TRO)', '102', '1122');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (44, 'Taxis only (On street but not in TRO)', '136', '1121');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (45, 'Motorcycle Solo only (On street but not in TRO)', '124', '1118');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (46, 'Permit Holders only (On street but not in TRO)', '128', '1131');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (47, 'Pay and Display/Pay by Phone (On street but not in TRO)', '127', '1103');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (48, 'Shared Use Bays (Permit Holders) (On street but not in TRO)', '134', '1134');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (49, 'Buses Parking only (On street but not in TRO)', '104', '1109');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (50, 'Electric Vehicle Charging Bay (On street but not in TRO)', '112', '1124');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (51, 'Greenway Parking Bay (On street but not in TRO)', '118', '1142');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (52, 'Loading only (On street but in not TRO)', '120', '1114');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (53, 'On-Street Cycle Bays (On street but not in TRO)', '125', '1119');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (54, 'Doctor Bays (On street but not in TRO)', '111', '1113');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (55, 'Limited Waiting (No Charge) (On street but not in TRO)', '119', '1126');
INSERT INTO "public"."LookupCodeTransfers_Bays" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (56, 'Police Bays (On-street but not in TRO)', '129', '1120');


--
-- TOC entry 4239 (class 0 OID 292862)
-- Dependencies: 238
-- Data for Name: LookupCodeTransfers_Lines; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (1, 'Crossing - Equestrian', '1', '213');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (2, 'Crossing - Pelican', '2', '210');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (3, 'Crossing - Puffin', '3', '212');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (4, 'Crossing - Signalised', '4', '214');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (5, 'Crossing - Toucan (bicycles)', '5', '211');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (6, 'Crossing - Unmarked and no signals', '6', '215');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (7, 'Crossing - Zebra', '7', '209');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (9, 'No Stopping (SRL)', '8', '217');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (10, 'No Stopping (SRL) - unacceptable', '24', '222');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (11, 'No Stopping At Any Time (DRL)', '9', '218');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (13, 'No Waiting (SYL)', '10', '201');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (14, 'No Waiting (SYL) - unacceptable', '22', '221');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (16, 'No Waiting At Any Time (DYL)', '11', '202');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (18, 'Private Road', '12', '219');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (19, 'Unmarked Area', '13', '216');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (20, 'Unmarked Area (compliance issue)', '14', '220');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (21, 'Unmarked Areas - unacceptable', '23', '220');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (22, 'Zig-Zag Keep Clear Ambulance', '15', '206');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (23, 'Zig-Zag Keep Clear Fire', '16', '204');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (24, 'Zig-Zag Keep Clear Hospital', '17', '207');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (25, 'Zig-Zag Keep Clear Police', '18', '205');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (26, 'Zig-Zag Keep Clear Yellow (Other)', '20', '208');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (27, 'Zig-Zag School Keep Clear', '21', '203');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (8, 'Crossing - Zebra (On-street but not in TRO)', '207', '2209');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (12, 'No Stopping At Any Time (DRL) (On-street but not in TRO)', '209', '2218');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (15, 'No Waiting (SYL) (On-street but not in TRO)', '210', '2201');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (17, 'No Waiting At Any Time (On-street but not in TRO)', '211', '2202');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (28, 'Zig-Zag School Keep Clear (On-street but not in TRO)', '221', '2203');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (29, 'No Waiting (SYL) (in Mews/PPA)', '410', '2410');
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (30, 'No Waiting At Any Time (DYL) (in Mews/PPA)', '411', '2411');


--
-- TOC entry 4240 (class 0 OID 292868)
-- Dependencies: 239
-- Data for Name: MapGrid; Type: TABLE DATA; Schema: public; Owner: edi_operator
--

INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1339, '0106000020346C000001000000010300000001000000050000000000000030E4134100000000C09424410000000070EA134100000000C09424410000000070EA134100000000CC9224410000000030E4134100000000CC9224410000000030E4134100000000C0942441', 325900, 326300, 674150, 674400, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1398, '0106000020346C000001000000010300000001000000050000000000000030E4134100000000CC9224410000000070EA134100000000CC9224410000000070EA134100000000D89024410000000030E4134100000000D89024410000000030E4134100000000CC922441', 325900, 326300, 673900, 674150, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1455, '0106000020346C0000010000000103000000010000000500000000000000B0D7134100000000D890244100000000F0DD134100000000D890244100000000F0DD134100000000E48E244100000000B0D7134100000000E48E244100000000B0D7134100000000D8902441', 325100, 325500, 673650, 673900, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1456, '0106000020346C0000010000000103000000010000000500000000000000F0DD134100000000D89024410000000030E4134100000000D89024410000000030E4134100000000E48E244100000000F0DD134100000000E48E244100000000F0DD134100000000D8902441', 325500, 325900, 673650, 673900, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1337, '0106000020346C0000010000000103000000010000000500000000000000B0D7134100000000C094244100000000F0DD134100000000C094244100000000F0DD134100000000CC92244100000000B0D7134100000000CC92244100000000B0D7134100000000C0942441', 325100, 325500, 674150, 674400, 1, NULL, NULL, NULL, '2020-05-01');
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1396, '0106000020346C0000010000000103000000010000000500000000000000B0D7134100000000CC92244100000000F0DD134100000000CC92244100000000F0DD134100000000D890244100000000B0D7134100000000D890244100000000B0D7134100000000CC922441', 325100, 325500, 673900, 674150, 1, NULL, NULL, NULL, '2020-05-01');
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1338, '0106000020346C0000010000000103000000010000000500000000000000F0DD134100000000C09424410000000030E4134100000000C09424410000000030E4134100000000CC92244100000000F0DD134100000000CC92244100000000F0DD134100000000C0942441', 325500, 325900, 674150, 674400, 1, NULL, NULL, NULL, '2020-05-01');
INSERT INTO "public"."MapGrid" ("id", "geom", "x_min", "x_max", "y_min", "y_max", "RevisionNr", "Edge", "CPZ tile", "ContainsRes", "LastRevisionDate") VALUES (1397, '0106000020346C0000010000000103000000010000000500000000000000F0DD134100000000CC9224410000000030E4134100000000CC9224410000000030E4134100000000D890244100000000F0DD134100000000D890244100000000F0DD134100000000CC922441', 325500, 325900, 673900, 674150, 3, NULL, NULL, NULL, '2020-05-20');


--
-- TOC entry 4241 (class 0 OID 292874)
-- Dependencies: 240
-- Data for Name: ParkingTariffAreas; Type: TABLE DATA; Schema: public; Owner: edi_operator
--

INSERT INTO "public"."ParkingTariffAreas" ("id", "geom", "gid", "fid_parkin", "tro_ref", "charge", "cost", "hours", "Name", "NoReturnTimeID", "MaxStayID", "TimePeriodID", "OBJECTID", "name_orig", "Shape_Leng", "Shape_Area", "OpenDate", "CloseDate", "RestrictionID", "GeometryID") VALUES (110, '0103000020346C000001000000050000008BA3249780DE1341F2DF386045922441BD1D345AC1DD1341BDC421902A922441BFB1BE7AAADD13418D336E6F48922441339D5F2C6FDE134179B9FE2E659224418BA3249780DE1341F2DF386045922441', NULL, NULL, NULL, NULL, NULL, NULL, 'C2', 10, 10, 16, NULL, NULL, NULL, NULL, '2020-05-01', NULL, '{ac017c0b-91f9-48d2-b571-8fae5139ec6a}', 'T_ 000000002');


--
-- TOC entry 4243 (class 0 OID 292882)
-- Dependencies: 242
-- Data for Name: PaymentTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."PaymentTypes" ("id", "Code", "Description") VALUES (1, 1, 'No Charge');
INSERT INTO "public"."PaymentTypes" ("id", "Code", "Description") VALUES (2, 2, 'Pay and Display');
INSERT INTO "public"."PaymentTypes" ("id", "Code", "Description") VALUES (3, 3, 'Pay by Phone (only)');
INSERT INTO "public"."PaymentTypes" ("id", "Code", "Description") VALUES (4, 4, 'Pay and Display/Pay by Phone');


--
-- TOC entry 4245 (class 0 OID 292890)
-- Dependencies: 244
-- Data for Name: ProposalStatusTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."ProposalStatusTypes" ("id", "Description", "Code") VALUES (1, 'In Preparation', 1);
INSERT INTO "public"."ProposalStatusTypes" ("id", "Description", "Code") VALUES (2, 'Accepted', 2);
INSERT INTO "public"."ProposalStatusTypes" ("id", "Description", "Code") VALUES (3, 'Rejected', 3);


--
-- TOC entry 4248 (class 0 OID 292900)
-- Dependencies: 247
-- Data for Name: Proposals; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (0, 2, '2020-05-21', NULL, '0 - No Proposal Shown', '2020-05-01');
INSERT INTO "public"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (4, 2, '2020-05-21', NULL, 'Initial Creation', '2020-05-01');
INSERT INTO "public"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (5, 2, '2020-05-28', NULL, 'Loading Bay / SYL', '2020-05-15');
INSERT INTO "public"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (6, 2, '2020-05-29', NULL, 'Delete Bay', '2020-05-20');
INSERT INTO "public"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (7, 1, '2020-05-29', NULL, 'Add line', '2020-05-27');
INSERT INTO "public"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (8, 1, '2020-05-01', NULL, 'Test2', '2020-05-01');


--
-- TOC entry 4249 (class 0 OID 292907)
-- Dependencies: 248
-- Data for Name: Proposals_withGeom; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4256 (class 0 OID 292949)
-- Dependencies: 257
-- Data for Name: RestrictionLayers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionLayers" ("id", "RestrictionLayerName") VALUES (2, 'Bays');
INSERT INTO "public"."RestrictionLayers" ("id", "RestrictionLayerName") VALUES (3, 'Lines');
INSERT INTO "public"."RestrictionLayers" ("id", "RestrictionLayerName") VALUES (5, 'Signs');
INSERT INTO "public"."RestrictionLayers" ("id", "RestrictionLayerName") VALUES (4, 'RestrictionPolygons');
INSERT INTO "public"."RestrictionLayers" ("id", "RestrictionLayerName") VALUES (6, 'CPZs');
INSERT INTO "public"."RestrictionLayers" ("id", "RestrictionLayerName") VALUES (7, 'ParkingTariffAreas');


--
-- TOC entry 4259 (class 0 OID 292956)
-- Dependencies: 260
-- Data for Name: RestrictionPolygonTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionPolygonTypes" ("id", "Code", "Description") VALUES (1, 1, 'Greenway');
INSERT INTO "public"."RestrictionPolygonTypes" ("id", "Code", "Description") VALUES (3, 3, 'Pedestrian Area');
INSERT INTO "public"."RestrictionPolygonTypes" ("id", "Code", "Description") VALUES (4, 4, 'Residential mews area');
INSERT INTO "public"."RestrictionPolygonTypes" ("id", "Code", "Description") VALUES (2, 2, 'Permit Parking Areas');
INSERT INTO "public"."RestrictionPolygonTypes" ("id", "Code", "Description") VALUES (5, 5, 'Pedestrian Area - occasional');
INSERT INTO "public"."RestrictionPolygonTypes" ("id", "Code", "Description") VALUES (6, 6, 'Area under construction');


--
-- TOC entry 4261 (class 0 OID 292965)
-- Dependencies: 262
-- Data for Name: RestrictionPolygons; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionPolygons" ("id", "geom", "RestrictionTypeID", "GeomShapeID", "OpenDate", "CloseDate", "USRN", "Orientation", "RoadName", "GeometryID", "RestrictionID", "NoWaitingTimeID", "NoLoadingTimeID", "Polygons_Photos_01", "Polygons_Photos_02", "Polygons_Photos_03", "LabelText", "TimePeriodID", "AreaPermitCode", "CPZ", "labelX", "labelY", "labelRotation") VALUES (NULL, '0103000020346C0000010000000F00000063066581C6DE13417446786BA9912441BB5D56FE3BDE1341C5F1FB8F95912441C3135BE73BDE134165C7B98C9591244172E6DE7426DE1341F951E58A9291244167200316F4DD134127F3E27A8B912441D60208618FDD1341870C991F7D9124411339A7D713DD1341A78D24836B912441AFADE9A573DC134180D8DEAC54912441E01E1C715BDC1341023E773951912441770247475BDC134134399F33519124411E61662B37DC1341B199AB424C912441452ACA84D8DB134173D96D433F91244186A5372CCFDB13411CDB8D924E912441CDF03BDABDDE1341103DF1D2B891244163066581C6DE13417446786BA9912441', 3, 50, '2020-05-01', NULL, '1006', NULL, 'Rose Street', 'P_ 000000002', 'b0f73006-62f1-4d63-b1b2-758eba0865bf', 126, 126, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4254 (class 0 OID 292941)
-- Dependencies: 255
-- Data for Name: RestrictionShapeTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (2, 2, 'Half on/Half off');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (3, 3, 'On pavement');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (4, 4, 'Perpendicular');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (5, 5, 'Echelon (Diagonal)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (1, 1, 'Parallel (Bay)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (6, 6, 'Perpendicular on Pavement');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (10, 10, 'Parallel (Line)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (11, 11, 'Parallel (Line) with loading');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (7, 12, 'Zig-Zag');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (8, 7, 'Other (please specify in notes)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (9, 21, 'Parallel Bay (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (13, 24, 'Perpendicular Bay (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (14, 25, 'Echelon Bay (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (15, 28, 'Outline Bay (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (16, 8, 'Central Parking');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (17, 22, 'Half on/Half off (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (18, 23, 'On pavement (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("id", "Code", "Description") VALUES (19, 26, 'Perpendicular on Pavement (Polygon)');


--
-- TOC entry 4262 (class 0 OID 292972)
-- Dependencies: 263
-- Data for Name: RestrictionStatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionStatus" ("id", "PK_UID", "RestrictionStatusID", "Description") VALUES (1, 0, 0, 'Proposed');
INSERT INTO "public"."RestrictionStatus" ("id", "PK_UID", "RestrictionStatusID", "Description") VALUES (2, 1, 1, 'Confirmed');
INSERT INTO "public"."RestrictionStatus" ("id", "PK_UID", "RestrictionStatusID", "Description") VALUES (3, 2, 2, 'Temporary');
INSERT INTO "public"."RestrictionStatus" ("id", "PK_UID", "RestrictionStatusID", "Description") VALUES (4, 3, 3, 'Experimental');


--
-- TOC entry 4250 (class 0 OID 292913)
-- Dependencies: 249
-- Data for Name: RestrictionTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (1, 0, 'No Waiting (SYL) (Unacceptable)', 221);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (2, 1, 'Ambulance Bays', 106);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (3, 2, 'Bus Stand', 123);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (4, 3, 'Bus Stop', 107);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (5, 4, 'Buses Only', 109);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (6, 5, 'Business Permit Holders Bays', 102);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (7, 6, 'Car Club Bays', 108);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (8, 7, 'Diplomat Bays', 112);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (9, 8, 'Disabled Bays (Blue Badge)', 110);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (10, 9, 'Disabled Bays (Personalised)', 111);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (11, 10, 'Doctor Bays', 113);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (12, 11, 'Electric vehicle Charging Bay', 125);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (13, 12, 'Free Bays - No Limited Waiting', 127);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (14, 13, 'Limited Waiting (no charge)', 103);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (15, 14, 'Loading Bays', 114);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (16, 15, 'Loading Bays & Disabled Bays', 115);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (17, 16, 'Mayor of London Cycle Hire Bays', 116);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (18, 17, 'Mobile Library Bays', 124);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (19, 18, 'Motorcycle Bay (Residents)', 117);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (20, 19, 'Motorcycle Bay (Visitors)', 118);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (21, 20, 'On-Street Cycle Bays', 119);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (22, 21, 'Other Bays (Please specify in notes)', 126);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (23, 22, 'Pay and Display/Pay by Phone', 121);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (24, 23, 'Police Bays', 120);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (25, 24, 'Permit Holder Bays', 101);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (26, 25, 'Resident/Business Permit Holders Bays', 104);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (27, 26, 'Shared Bays (Permit/Non-permit Holder bays)', 105);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (28, 27, 'Taxi Bays', 122);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (29, 28, 'No Waiting At Any Time (DYL)', 202);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (30, 29, 'Zig Zag - School', 203);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (31, 30, 'Zig Zag - Fire', 204);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (32, 31, 'Zig Zag - Police', 205);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (33, 32, 'Zig Zag - Ambulance', 206);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (34, 33, 'Zig Zag - Hospital', 207);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (35, 34, 'Zig Zag - Yellow (other)', 208);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (36, 35, 'Crossing - Zebra', 209);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (37, 36, 'Crossing - Pelican', 210);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (38, 37, 'Crossing - Toucan', 211);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (39, 38, 'Crossing - Puffin', 212);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (40, 39, 'Crossing - Equestrian', 213);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (41, 40, 'Crossing - Signalised', 214);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (42, 41, 'Crossing - Unmarked and no signals', 215);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (43, 42, 'No Waiting At Any Time (DRL)', 218);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (44, 43, 'Private Road', 219);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (45, 44, 'No Waiting (SYL) (Acceptable)', 201);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (46, 45, 'Unmarked Area (Acceptable)', 216);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (47, 46, 'No Waiting (SRL) (Acceptable)', 217);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (48, 47, 'No Waiting (SRL) (Unacceptable)', 222);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (49, 48, 'Unmarked Area (Unacceptable)', 220);
INSERT INTO "public"."RestrictionTypes" ("id", "PK_UID", "Description", "OrigOrderCode") VALUES (50, 49, 'No Loading', 223);


--
-- TOC entry 4251 (class 0 OID 292919)
-- Dependencies: 250
-- Data for Name: RestrictionsInProposals; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'f0ce05a2-7b0e-410b-8556-05ecb0aa485e');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'ceb9e35c-0372-4cf0-ac38-f150eb200ea0');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'f071e490-9f42-4872-a064-a894927c6c4e');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'dc0b1bfb-9532-48ea-8d90-85bddac2f17b');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'f32e4d66-0d7f-4dbc-a48c-c8c44dc1a191');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'c0e47ca6-6148-4a9d-8c33-f576b733ad32');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'a9d38e70-bc08-4f46-8497-71bdad52dad7');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'e6e923ce-6a61-4e6e-b856-db2f20e395e6');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '4c5913dd-0412-439f-8c8b-7eecbcfee7a7');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'a530ddfb-316a-40da-abfd-ba111d1c35b4');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'c31f7cb7-e29d-4117-94b0-307ac280c192');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '0e213bb8-28b6-4e6b-a48a-954b40821b6c');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, 'b81c152e-0d1d-4ba0-bb96-320f02f4a18a');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '59a25fd9-3b04-44bb-a77b-f5bb383be9ee');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, '362db835-a235-49fa-8f90-2c37955fde39');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '0f493e9b-5e4a-4854-892d-085840a437fc');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '474b2ac4-5c10-4764-b25b-e9cda052aba6');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '12cc30fe-cb33-4570-b228-f2402947bb5e');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '2a5d0a0b-2c87-4257-9147-0bdeeb8af0d2');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, '5dd050cb-8bde-400d-8f03-fccbf492467a');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '9775d869-1cea-4098-9b2a-ce019afa458e');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '014d6fa9-0c7b-49f5-a9d1-5a4dbef9fad4');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '6500cbc0-5072-4a46-a130-6e79a214d896');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'dca8d05a-e437-473d-b95d-d50c792e1c97');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 2, 1, '62b0bf76-1ad4-4afb-97b4-abf7bc32d05a');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, '1bf6eef1-37f8-42b6-82b2-848f577146b6');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, 'ed8e2e61-3efb-4a89-86ff-4d4200e72803');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 3, 1, '825fc78e-a8c7-4372-8993-462f37605c68');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 4, 1, 'b0f73006-62f1-4d63-b1b2-758eba0865bf');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (4, 5, 1, '194544db-37b3-4603-97e9-b93d372b3d66');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (5, 3, 2, '362db835-a235-49fa-8f90-2c37955fde39');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (5, 2, 1, '254bdb0f-cc6d-47fc-a4b5-14dc4d244c1d');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (5, 3, 1, 'd4cd82f8-2a72-4232-9a0c-a27392348174');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (5, 3, 1, 'af46bcf3-5758-4f84-85bf-7800a562c8ae');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (6, 2, 2, '59a25fd9-3b04-44bb-a77b-f5bb383be9ee');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (7, 3, 1, 'a1a65fde-2217-434c-aa1d-54814642f447');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (8, 2, 1, 'd78254ca-28af-4f68-abc5-bfb4b12759a6');
INSERT INTO "public"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (8, 3, 1, 'f0008143-e680-4097-9f21-2509dce993ae');


--
-- TOC entry 4265 (class 0 OID 292982)
-- Dependencies: 266
-- Data for Name: RoadCentreLine; Type: TABLE DATA; Schema: public; Owner: edi_operator
--



--
-- TOC entry 4266 (class 0 OID 292988)
-- Dependencies: 267
-- Data for Name: SignAttachmentTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (1, 1, 'Short Pole');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (2, 2, 'Normal Pole');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (3, 3, 'Tall Pole');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (4, 4, 'Lamppost');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (5, 5, 'Wall');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (6, 6, 'Fences');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (7, 7, 'Other (Please specify in notes)');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (8, 8, 'Traffic Light');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (9, 9, 'Large Pole');


--
-- TOC entry 4267 (class 0 OID 292994)
-- Dependencies: 268
-- Data for Name: SignFadedTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (1, '1', 'No issues');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (2, '2', 'Sign Faded');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (3, '3', 'Sign Damaged');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (4, '4', 'Sign Damaged and Faded');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (5, '5', 'Pole Present, but Sign Missing');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (6, '6', 'Other (Please specify in notes)');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (7, '7', 'Sign OK, but Pole bent');
INSERT INTO "public"."SignFadedTypes" ("id", "Code", "Description") VALUES (8, '8', 'Defaced (Stickers, graffiti, dirt)');


--
-- TOC entry 4269 (class 0 OID 293002)
-- Dependencies: 270
-- Data for Name: SignMountTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (1, '1', 'U-Channel');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (2, '2', 'Round Post Bracket');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (3, '3', 'Square Post Bracket');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (4, '4', 'Wall Bracket');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (5, '5', 'Other (Please specify in notes)');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (6, '6', 'Screws or Nails');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (7, '7', 'Simple bar');


--
-- TOC entry 4271 (class 0 OID 293010)
-- Dependencies: 272
-- Data for Name: SignObscurredTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."SignObscurredTypes" ("id", "Code", "Description") VALUES (1, '1', 'No issue');
INSERT INTO "public"."SignObscurredTypes" ("id", "Code", "Description") VALUES (2, '2', 'Partially obscured');
INSERT INTO "public"."SignObscurredTypes" ("id", "Code", "Description") VALUES (3, '3', 'Completely obscured');


--
-- TOC entry 4273 (class 0 OID 293018)
-- Dependencies: 274
-- Data for Name: SignTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (1, '5T trucks and buses', 1);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (2, 'Ambulances only bays', 2);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (3, 'Bus only bays', 3);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (4, 'Bus stops/Bus stands', 4);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (5, 'Car club', 5);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (6, 'CPZ entry', 6);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (7, 'CPZ exit', 7);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (8, 'Disabled bays', 8);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (9, 'Doctor bays', 9);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (10, 'Electric vehicles recharging point', 10);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (11, 'Free parking bays (not Limited Waiting)', 11);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (12, 'Greenway Disabled Bays', 12);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (13, 'Greenway Loading Bays', 13);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (14, 'Greenway Loading/Disabled Bays', 14);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (15, 'Greenway Loading/Parking Bays', 15);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (16, 'Greenway Parking Bays', 16);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (17, 'Half on/Half off', 17);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (18, 'Limited waiting (no payment)', 18);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (19, 'Loading bay', 19);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (20, 'Motorcycles only bays', 20);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (21, 'No loading', 21);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (22, 'No waiting', 22);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (23, 'No waiting and no loading', 23);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (24, 'On pavement parking', 24);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (25, 'Other (please specify)', 25);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (26, 'Pay and Display/Pay by Phone bays', 26);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (27, 'Pedestrian Areas', 27);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (28, 'Permit holders only', 28);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (29, 'Police bays', 29);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (30, 'Private/Residents only bays', 30);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (31, 'Residents permit holders only', 31);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (32, 'Shared use bays', 32);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (33, 'Taxi ranks', 33);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (34, 'Ticket machine', 34);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (35, 'To be deleted', 35);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (36, 'Zig-Zag school keep clear', 36);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (37, 'Pole only, no sign', 37);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (38, 'No stopping - Greenway', 38);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (39, 'Greenway exit area', 39);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (40, 'Permit Parking Zone (PPZ)', 40);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (41, 'No Stopping - School', 41);
INSERT INTO "public"."SignTypes" ("id", "Description", "Code") VALUES (42, 'On Street NOT in TRO', 42);


--
-- TOC entry 4229 (class 0 OID 292812)
-- Dependencies: 228
-- Data for Name: Signs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."Signs" ("id", "geom", "Signs_Notes", "Signs_Photos_01", "GeometryID", "SignType_1", "SignType_2", "SignType_3", "Signs_DateTime", "PhotoTaken", "Signs_Photos_02", "Signs_Mount", "Surveyor", "TicketMachine_Nr", "Signs_Attachment", "Compl_Signs_Faded", "Compl_Signs_Obscured", "Compl_Signs_Direction", "Compl_Signs_Obsolete", "Compl_Signs_OtherOptions", "Compl_Signs_TicketMachines", "RoadName", "USRN", "RingoPresent", "OpenDate", "CloseDate", "Signs_Photos_03", "GeometryID_181017", "RestrictionID", "CPZ", "ParkingTariffArea") VALUES (NULL, '0101000020346C0000029BD886F4DD1341E222517214932441', NULL, NULL, 'S_ 000000001', 26, 23, NULL, '2020-05-27 22:39:13.070947', 0, NULL, NULL, 'tim.hancock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'North St David Street', '1005', NULL, '2020-05-01', NULL, NULL, NULL, '194544db-37b3-4603-97e9-b93d372b3d66', NULL, NULL);


--
-- TOC entry 4275 (class 0 OID 293026)
-- Dependencies: 276
-- Data for Name: Surveyors; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4278 (class 0 OID 293033)
-- Dependencies: 279
-- Data for Name: TicketMachineIssueTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (1, '1', 'No issues');
INSERT INTO "public"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (2, '2', 'Defaced (e.g. graffiti)');
INSERT INTO "public"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (3, '3', 'Physically Damaged');
INSERT INTO "public"."TicketMachineIssueTypes" ("id", "Code", "Description") VALUES (4, '4', 'Other (Please specify in notes)');


--
-- TOC entry 4280 (class 0 OID 293041)
-- Dependencies: 281
-- Data for Name: TilesInAcceptedProposals; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1337, 1);
INSERT INTO "public"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1397, 1);
INSERT INTO "public"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1396, 1);
INSERT INTO "public"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1338, 1);
INSERT INTO "public"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (5, 1397, 2);
INSERT INTO "public"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (6, 1397, 3);


--
-- TOC entry 4281 (class 0 OID 293044)
-- Dependencies: 282
-- Data for Name: TimePeriods; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (121, 225, 'Jan-July 8.00pm-10.00am Aug 8.00pm-9.00am Sep-Nov 8.00pm-10.00am Dec 8.00pm-9.00am', 'Jan-July 8.00pm-10.00am;Aug 8.00pm-9.00am;Sep-Nov 8.00pm-10.00am;Dec 8.00pm-9.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (3, 103, '6.30pm-7.00am', '6.30pm-7.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (2, 102, '6.00pm-7.00am', '6.00pm-7.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (122, 226, 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (12, 111, 'At Any Time May-Sept', 'At Any Time May-Sept');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (113, 217, 'Mon-Fri 8.00am-8.00pm', 'Mon-Fri 8.00am-8.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (115, 219, 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm Fri 8.30am-9.15am 11.45am-1.15pm', 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm;Fri 8.30am-9.15am 11.45am-1.15pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (114, 218, 'Mon-Fri 7.30am-9.00am', 'Mon-Fri 7.30am-9.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (118, 222, 'Mon-Fri 8.30am-6.00pm', 'Mon-Fri 8.30am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (85, 162, 'Mon-Sat 9.00am-5.30pm', 'Mon-Sat 9.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (87, 163, 'Mon-Sun 10.30am-4.30pm', 'Mon-Sun 10.30am-4.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (93, 169, 'Sat-Sun 10.00am-4.00pm', 'Sat-Sun 10.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (94, 170, 'Sat-Sun 8.00am-6.00pm May-Sept', 'Sat-Sun 8.00am-6.00pm May-Sept');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (96, 171, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (49, 139, 'Mon-Fri 8.30am-4.30pm', 'Mon-Fri 8.30am-4.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (97, 201, 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (117, 221, 'Mon-Sat 8.00am-4.00pm', 'Mon-Sat 8.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (61, 147, 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (39, 133, 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (47, 141, 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm', 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (52, 12, 'Mon-Fri 8.30am-6.30pm', 'Mon-Fri 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (79, 33, 'Mon-Sat 8.30am-6.30pm', 'Mon-Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (86, 45, 'Mon-Sat 9.30am-6.30pm', 'Mon-Sat 9.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (72, 19, 'Mon-Fri 9.00am-4.00pm', 'Mon-Fri 9.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (77, 26, 'Mon-Sat 7.00am-6.30pm', 'Mon-Sat 7.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (84, 83, 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (22, 124, 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (23, 118, 'Mon-Fri 7.30am-5.00pm', 'Mon-Fri 7.30am-5.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (24, 119, 'Mon-Fri 7.30am-6.30pm Sat-Sun 10.00am-5.30pm', 'Mon-Fri 7.30am-6.30pm;Sat-Sun 10.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (25, 120, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (26, 121, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (53, 75, 'Mon-Fri 8.00am-4.00pm', 'Mon-Fri 8.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (54, 14, 'Mon-Fri 8.00am-6.30pm', 'Mon-Fri 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (55, 15, 'Mon-Fri 8.00am-6.00pm', 'Mon-Fri 8.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (1, 101, '6.00am-10.00pm', '6.00am-10.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (95, 78, 'Unknown - no sign', 'Unknown - no sign');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (45, 10, 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (46, 11, 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (56, 16, 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (80, 34, 'Mon-Sat 8.30am-6.30pm Sun 11.00am-5.00pm', 'Mon-Sat 8.30am-6.30pm;Sun 11.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (83, 43, 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (51, 97, 'Mon-Fri 8.30am-5.30pm', 'Mon-Fri 8.30am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (99, 203, 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (100, 204, 'Mon-Fri 9.30am-4pm Sat All day', 'Mon-Fri 9.30am-4pm;Sat All day');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (101, 205, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (7, 107, '8.00am-6.00pm', '8.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (8, 108, '8.00am-6.00pm 2.15pm-4.00pm', '8.00am-6.00pm 2.15pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (32, 126, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-1.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (33, 127, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-Noon', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-Noon');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (34, 128, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-12.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-12.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (35, 129, 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm', 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (36, 130, 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (37, 131, 'Mon-Fri 8.00am-9.00am Mon-Thurs 2.30pm-3.45pm Fri Noon-1.30pm', 'Mon-Fri 8.00am-9.00am;Mon-Thurs 2.30pm-3.45pm;Fri Noon-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (38, 132, 'Mon-Fri 8.00am-9.15am', 'Mon-Fri 8.00am-9.15am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (40, 134, 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (41, 135, 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (42, 136, 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm', 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (43, 137, 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (44, 138, 'Mon-Fri 8.15am-5.30pm Sat 8.15am-1.30pm', 'Mon-Fri 8.15am-5.30pm;Sat 8.15am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (48, 142, 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm', 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (50, 140, 'Mon-Fri 8.30am-5.00pm', 'Mon-Fri 8.30am-5.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (57, 143, 'Mon-Fri 9.00am-5.00pm', 'Mon-Fri 9.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (58, 144, 'Mon-Fri 9.00am-6.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.00am-6.00pm;Sat 9.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (59, 145, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-1.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-1.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (60, 146, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-5.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (63, 148, 'Mon-Fri 9.15am-4.30pm', 'Mon-Fri 9.15am-4.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (71, 156, 'Mon-Fri 9.30am-4.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 9.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (88, 164, 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (108, 212, 'Mon-Fri 8.00am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 8.00am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (31, 125, 'Mon-Fri 8.00am-5.30pm', 'Mon-Fri 8.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (82, 40, 'Mon-Sat 8.00am-6.00pm', 'Mon-Sat 8.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (21, 123, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm Sat 8.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm;Sat 8.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (9, 109, '8.15am-9.00am 11.30am-1.15pm', '8.15am-9.00am 11.30am-1.15pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (89, 168, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.30am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.30am Noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (81, 39, 'Mon-Sat 8.00am-6.30pm', 'Mon-Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (124, 228, 'Mon-Fri 9.30am-4.00pm', 'Mon-Fri 9.30am-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (65, 99, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (90, 167, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (5, 105, '7.30am-6.30pm', '7.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (6, 106, '8.00am-5.30pm', '8.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (110, 213, 'Mon-Sat 8.30am-5.30pm', 'Mon-Sat 8.30am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (10, 110, '9.00am-5.30pm', '9.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (28, 8, 'Mon-Fri 7.00am-7.00pm', 'Mon-Fri 7.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (64, 149, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-1.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (62, 150, 'Mon-Fri 9.15pm-8.00am', 'Mon-Fri 9.15pm-8.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (66, 151, 'Mon-Fri 9.30am-11.00am', 'Mon-Fri 9.30am-11.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (67, 152, 'Mon-Fri 9.30am-3.30pm', 'Mon-Fri 9.30am-3.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (68, 153, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (69, 154, 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am', 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (70, 155, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (98, 202, 'Mon-Sat 8.15am-6.00pm', 'Mon-Sat 8.15am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (17, 115, 'Mon-Fri 11.30am-1.00pm', 'Mon-Fri 11.30am-1.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (20, 122, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am;4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (73, 157, 'Mon-Sat 7.00am-6.00pm', 'Mon-Sat 7.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (74, 158, 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (75, 160, 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (76, 159, 'Mon-Sat 7.30am-6.30pm', 'Mon-Sat 7.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (78, 161, 'Mon-Sat 8.30am-6.00pm', 'Mon-Sat 8.30am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (102, 206, 'Sat 1.30pm-6.30pm', 'Sat 1.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (120, 224, '7.00am-7.00pm', '7.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (11, 1, 'At Any Time', 'At Any Time');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (106, 210, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (107, 211, 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (116, 220, 'Mon-Sat 9.00am-6.00pm', 'Mon-Sat 9.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (123, 227, 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (111, 215, '8.00am-9.30am 4.00pm-6.00pm', '8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (112, 216, 'Mon-Fri 7.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (92, 166, 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm Fri 11.45am-1.15pm', 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm;Fri 11.45am-1.15pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (4, 104, '7.00am-8.00pm', '7.00am-8.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (91, 165, 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (27, 98, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (13, 112, 'Mon-Fri 1.30pm-3.00pm', 'Mon-Fri 1.30pm-3.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (14, 113, 'Mon-Fri 10.00am-11.30am', 'Mon-Fri 10.00am-11.30am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (15, 2, 'Mon-Fri 10.00am-3.30pm', 'Mon-Fri 10.00am-3.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (16, 114, 'Mon-Fri 11.00am-12.30pm', 'Mon-Fri 11.00am-12.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (18, 116, 'Mon-Fri 12.30pm-2.00pm', 'Mon-Fri 12.30pm-2.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (19, 117, 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (103, 207, '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm', '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (104, 208, 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (105, 209, '7.30am-9.30am 4.00pm-6.30pm', '7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (30, 96, 'Mon-Fri 8.00am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.15am;4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (125, 229, 'Mon-Sun 9.30am-4.00pm', 'Mon-Sun 9.30am-4.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (126, 230, 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ', 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (119, 223, 'Mon-Sat 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.30am-9.30am; 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (127, 231, 'Mon-Sun', 'Mon-Sun');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (128, 232, '10.30am-11.00pm', '10.30am-11.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (130, 234, '10.30am-10.00pm', '10.30am-10pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (131, 235, 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm', 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (132, 236, '7.00am-10.00am 4.00pm-6.30pm', '7.00am-10.00am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (133, 237, 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm', 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (134, 238, 'Mon-Sat 7.00am-8.00am', 'Mon-Sat 7.00am-8.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (135, 239, 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (129, 233, '10.30am-midnight and midnight-6.30am', '10.30am-midnight, midnight-6.30am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (240, 240, '8.30am-6.30pm', '8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (300, 0, NULL, NULL);
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (301, 241, 'Mon-Sun 8.00pm to 8.00am', 'Mon-Sun 8.00pm to 8.00am');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (302, 242, 'Mon-Sun 5:30-7:00 and 09:30-11:00', '5:30-7:00 9:30-11:00');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (303, 243, 'Mon-Sun Midnight-5.30, 7.00-9.30, 11.00-midnight', 'Midnight-5.30, 7.00-9.30, 11.00-midnight');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (306, 306, 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (307, 307, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (308, 308, 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (309, 309, 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (310, 310, 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (311, 311, 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (312, 312, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (313, 313, 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (314, 314, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (315, 315, 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (316, 316, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (317, 317, 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("id", "Code", "Description", "LabelText") VALUES (318, 318, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm');


--
-- TOC entry 4253 (class 0 OID 292924)
-- Dependencies: 252
-- Data for Name: TimePeriods_orig; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (121, 225, 'Jan-July 8.00pm-10.00am Aug 8.00pm-9.00am Sep-Nov 8.00pm-10.00am Dec 8.00pm-9.00am', 'Jan-July 8.00pm-10.00am;Aug 8.00pm-9.00am;Sep-Nov 8.00pm-10.00am;Dec 8.00pm-9.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (3, 103, '6.30pm-7.00am', '6.30pm-7.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (2, 102, '6.00pm-7.00am', '6.00pm-7.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (122, 226, 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (12, 111, 'At Any Time May-Sept', 'At Any Time May-Sept');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (113, 217, 'Mon-Fri 8.00am-8.00pm', 'Mon-Fri 8.00am-8.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (115, 219, 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm Fri 8.30am-9.15am 11.45am-1.15pm', 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm;Fri 8.30am-9.15am 11.45am-1.15pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (114, 218, 'Mon-Fri 7.30am-9.00am', 'Mon-Fri 7.30am-9.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (118, 222, 'Mon-Fri 8.30am-6.00pm', 'Mon-Fri 8.30am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (85, 162, 'Mon-Sat 9.00am-5.30pm', 'Mon-Sat 9.00am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (87, 163, 'Mon-Sun 10.30am-4.30pm', 'Mon-Sun 10.30am-4.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (93, 169, 'Sat-Sun 10.00am-4.00pm', 'Sat-Sun 10.00am-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (94, 170, 'Sat-Sun 8.00am-6.00pm May-Sept', 'Sat-Sun 8.00am-6.00pm May-Sept');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (96, 171, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (49, 139, 'Mon-Fri 8.30am-4.30pm', 'Mon-Fri 8.30am-4.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (97, 201, 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (117, 221, 'Mon-Sat 8.00am-4.00pm', 'Mon-Sat 8.00am-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (61, 147, 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (39, 133, 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (47, 141, 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm', 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (52, 12, 'Mon-Fri 8.30am-6.30pm', 'Mon-Fri 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (79, 33, 'Mon-Sat 8.30am-6.30pm', 'Mon-Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (86, 45, 'Mon-Sat 9.30am-6.30pm', 'Mon-Sat 9.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (72, 19, 'Mon-Fri 9.00am-4.00pm', 'Mon-Fri 9.00am-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (77, 26, 'Mon-Sat 7.00am-6.30pm', 'Mon-Sat 7.00am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (84, 83, 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (22, 124, 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (23, 118, 'Mon-Fri 7.30am-5.00pm', 'Mon-Fri 7.30am-5.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (24, 119, 'Mon-Fri 7.30am-6.30pm Sat-Sun 10.00am-5.30pm', 'Mon-Fri 7.30am-6.30pm;Sat-Sun 10.00am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (25, 120, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (26, 121, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (53, 75, 'Mon-Fri 8.00am-4.00pm', 'Mon-Fri 8.00am-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (54, 14, 'Mon-Fri 8.00am-6.30pm', 'Mon-Fri 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (55, 15, 'Mon-Fri 8.00am-6.00pm', 'Mon-Fri 8.00am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (1, 101, '6.00am-10.00pm', '6.00am-10.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (95, 78, 'Unknown - no sign', 'Unknown - no sign');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (45, 10, 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (46, 11, 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (56, 16, 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (80, 34, 'Mon-Sat 8.30am-6.30pm Sun 11.00am-5.00pm', 'Mon-Sat 8.30am-6.30pm;Sun 11.00am-5.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (83, 43, 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (51, 97, 'Mon-Fri 8.30am-5.30pm', 'Mon-Fri 8.30am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (99, 203, 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (100, 204, 'Mon-Fri 9.30am-4pm Sat All day', 'Mon-Fri 9.30am-4pm;Sat All day');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (101, 205, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (7, 107, '8.00am-6.00pm', '8.00am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (8, 108, '8.00am-6.00pm 2.15pm-4.00pm', '8.00am-6.00pm 2.15pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (32, 126, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-1.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (33, 127, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-Noon', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-Noon');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (34, 128, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-12.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-12.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (35, 129, 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm', 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (36, 130, 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (37, 131, 'Mon-Fri 8.00am-9.00am Mon-Thurs 2.30pm-3.45pm Fri Noon-1.30pm', 'Mon-Fri 8.00am-9.00am;Mon-Thurs 2.30pm-3.45pm;Fri Noon-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (38, 132, 'Mon-Fri 8.00am-9.15am', 'Mon-Fri 8.00am-9.15am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (40, 134, 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (41, 135, 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (42, 136, 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm', 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (43, 137, 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (44, 138, 'Mon-Fri 8.15am-5.30pm Sat 8.15am-1.30pm', 'Mon-Fri 8.15am-5.30pm;Sat 8.15am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (48, 142, 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm', 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (50, 140, 'Mon-Fri 8.30am-5.00pm', 'Mon-Fri 8.30am-5.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (57, 143, 'Mon-Fri 9.00am-5.00pm', 'Mon-Fri 9.00am-5.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (58, 144, 'Mon-Fri 9.00am-6.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.00am-6.00pm;Sat 9.30am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (59, 145, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-1.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-1.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (60, 146, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-5.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-5.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (63, 148, 'Mon-Fri 9.15am-4.30pm', 'Mon-Fri 9.15am-4.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (71, 156, 'Mon-Fri 9.30am-4.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 9.30am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (88, 164, 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (108, 212, 'Mon-Fri 8.00am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 8.00am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (31, 125, 'Mon-Fri 8.00am-5.30pm', 'Mon-Fri 8.00am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (82, 40, 'Mon-Sat 8.00am-6.00pm', 'Mon-Sat 8.00am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (21, 123, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm Sat 8.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm;Sat 8.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (9, 109, '8.15am-9.00am 11.30am-1.15pm', '8.15am-9.00am 11.30am-1.15pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (89, 168, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.30am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.30am Noon-1.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (81, 39, 'Mon-Sat 8.00am-6.30pm', 'Mon-Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (124, 228, 'Mon-Fri 9.30am-4.00pm', 'Mon-Fri 9.30am-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (65, 99, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (90, 167, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (5, 105, '7.30am-6.30pm', '7.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (6, 106, '8.00am-5.30pm', '8.00am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (110, 213, 'Mon-Sat 8.30am-5.30pm', 'Mon-Sat 8.30am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (10, 110, '9.00am-5.30pm', '9.00am-5.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (28, 8, 'Mon-Fri 7.00am-7.00pm', 'Mon-Fri 7.00am-7.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (64, 149, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-1.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (62, 150, 'Mon-Fri 9.15pm-8.00am', 'Mon-Fri 9.15pm-8.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (66, 151, 'Mon-Fri 9.30am-11.00am', 'Mon-Fri 9.30am-11.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (67, 152, 'Mon-Fri 9.30am-3.30pm', 'Mon-Fri 9.30am-3.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (68, 153, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (69, 154, 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am', 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (70, 155, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (98, 202, 'Mon-Sat 8.15am-6.00pm', 'Mon-Sat 8.15am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (17, 115, 'Mon-Fri 11.30am-1.00pm', 'Mon-Fri 11.30am-1.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (20, 122, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am;4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (73, 157, 'Mon-Sat 7.00am-6.00pm', 'Mon-Sat 7.00am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (74, 158, 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (75, 160, 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (76, 159, 'Mon-Sat 7.30am-6.30pm', 'Mon-Sat 7.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (78, 161, 'Mon-Sat 8.30am-6.00pm', 'Mon-Sat 8.30am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (102, 206, 'Sat 1.30pm-6.30pm', 'Sat 1.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (120, 224, '7.00am-7.00pm', '7.00am-7.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (11, 1, 'At Any Time', 'At Any Time');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (106, 210, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (107, 211, 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (116, 220, 'Mon-Sat 9.00am-6.00pm', 'Mon-Sat 9.00am-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (123, 227, 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (111, 215, '8.00am-9.30am 4.00pm-6.00pm', '8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (112, 216, 'Mon-Fri 7.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (92, 166, 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm Fri 11.45am-1.15pm', 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm;Fri 11.45am-1.15pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (4, 104, '7.00am-8.00pm', '7.00am-8.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (91, 165, 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (27, 98, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (13, 112, 'Mon-Fri 1.30pm-3.00pm', 'Mon-Fri 1.30pm-3.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (14, 113, 'Mon-Fri 10.00am-11.30am', 'Mon-Fri 10.00am-11.30am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (15, 2, 'Mon-Fri 10.00am-3.30pm', 'Mon-Fri 10.00am-3.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (16, 114, 'Mon-Fri 11.00am-12.30pm', 'Mon-Fri 11.00am-12.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (18, 116, 'Mon-Fri 12.30pm-2.00pm', 'Mon-Fri 12.30pm-2.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (19, 117, 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (103, 207, '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm', '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (104, 208, 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (105, 209, '7.30am-9.30am 4.00pm-6.30pm', '7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (30, 96, 'Mon-Fri 8.00am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.15am;4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (125, 229, 'Mon-Sun 9.30am-4.00pm', 'Mon-Sun 9.30am-4.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (126, 230, 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ', 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (119, 223, 'Mon-Sat 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.30am-9.30am; 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (127, 231, 'Mon-Sun', 'Mon-Sun');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (128, 232, '10.30am-11.00pm', '10.30am-11.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (130, 234, '10.30am-10.00pm', '10.30am-10pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (131, 235, 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm', 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (132, 236, '7.00am-10.00am 4.00pm-6.30pm', '7.00am-10.00am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (133, 237, 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm', 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (134, 238, 'Mon-Sat 7.00am-8.00am', 'Mon-Sat 7.00am-8.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (135, 239, 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (129, 233, '10.30am-midnight and midnight-6.30am', '10.30am-midnight, midnight-6.30am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (240, 240, '8.30am-6.30pm', '8.30am-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (300, 0, NULL, NULL);
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (301, 241, 'Mon-Sun 8.00pm to 8.00am', 'Mon-Sun 8.00pm to 8.00am');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (302, 242, 'Mon-Sun 5:30-7:00 and 09:30-11:00', '5:30-7:00 9:30-11:00');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (303, 243, 'Mon-Sun Midnight-5.30, 7.00-9.30, 11.00-midnight', 'Midnight-5.30, 7.00-9.30, 11.00-midnight');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (304, 304, 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (305, 305, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (306, 306, 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (307, 307, 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (308, 308, 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (309, 309, 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (310, 310, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (311, 311, 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (312, 312, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (313, 313, 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (314, 314, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (315, 315, 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods_orig" ("id", "Code", "Description", "LabelText") VALUES (316, 316, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm');


--
-- TOC entry 4282 (class 0 OID 293051)
-- Dependencies: 283
-- Data for Name: baysWordingTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."baysWordingTypes" ("id", "Code", "Description") VALUES (1, '1', 'N/A');
INSERT INTO "public"."baysWordingTypes" ("id", "Code", "Description") VALUES (2, '2', 'Dual Use bay');
INSERT INTO "public"."baysWordingTypes" ("id", "Code", "Description") VALUES (3, '3', 'No stopping except');
INSERT INTO "public"."baysWordingTypes" ("id", "Code", "Description") VALUES (4, '4', 'No waiting except');
INSERT INTO "public"."baysWordingTypes" ("id", "Code", "Description") VALUES (5, '5', 'Goods vehicles only');


--
-- TOC entry 4284 (class 0 OID 293059)
-- Dependencies: 285
-- Data for Name: baytypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (1, 'Ambulance Bays', 1);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (4, 'Buses Parking only', 4);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (6, 'Car Club Bays', 6);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (8, 'Diplomat Bays', 8);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (9, 'Disabled Bays (Blue Badge)', 9);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (10, 'Disabled Bays (Personalised)', 10);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (11, 'Doctor Bays', 11);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (12, 'Electric Vehicle Charging Bay', 12);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (19, 'Limited Waiting (No Charge)', 19);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (20, 'Loading only', 20);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (21, 'Loading Bays & Disabled Bays', 21);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (23, 'Motorcycle Bay (Permit Holders only)', 23);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (24, 'Motorcycle Solo only', 24);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (25, 'On-Street Cycle Bays', 25);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (27, 'Pay and Display/Pay by Phone', 27);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (29, 'Police Bays', 29);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (67, 'RNLI Permit Holders only', 40);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (34, 'Shared Use Parking Place', 34);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (35, 'Shared Use Parking Place', 35);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (28, 'Permit Holders Parking Place', 28);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (31, 'Permit Holders Parking Place', 31);
INSERT INTO "public"."baytypes" ("gid", "Description", "Code") VALUES (33, 'Shared Use Parking Place', 33);


--
-- TOC entry 4289 (class 0 OID 293070)
-- Dependencies: 290
-- Data for Name: layer_styles; Type: TABLE DATA; Schema: public; Owner: edi_operator
--



--
-- TOC entry 4291 (class 0 OID 293079)
-- Dependencies: 292
-- Data for Name: linetypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (9, 'No Stopping (SRL)', 8);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (10, 'No Stopping At Any Time (DRL)', 9);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (11, 'No Waiting (SYL)', 10);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (12, 'No Waiting At Any Time (DYL)', 11);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (16, 'Zig-Zag Keep Clear Ambulance', 15);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (17, 'Zig-Zag Keep Clear Fire', 16);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (18, 'Zig-Zag Keep Clear Hospital', 17);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (19, 'Zig-Zag Keep Clear Police', 18);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (20, 'Zig-Zag Keep Clear White', 19);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (21, 'Zig-Zag Keep Clear Yellow (Other)', 20);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (22, 'Zig-Zag School Keep Clear', 21);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (39, 'No Waiting (SYL) (in Mews/PPA)', 410);
INSERT INTO "public"."linetypes" ("gid", "Description", "Code") VALUES (40, 'No Waiting At Any Time (DYL) (in Mews/PPA)', 411);


--
-- TOC entry 4296 (class 0 OID 293090)
-- Dependencies: 297
-- Data for Name: signs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3902 (class 0 OID 292037)
-- Dependencies: 208
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4414 (class 0 OID 0)
-- Dependencies: 213
-- Name: ActionOnProposalAcceptanceTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."ActionOnProposalAcceptanceTypes_id_seq"', 2, true);


--
-- TOC entry 4415 (class 0 OID 0)
-- Dependencies: 217
-- Name: BayLineTypesInUse_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."BayLineTypesInUse_gid_seq"', 148, true);


--
-- TOC entry 4416 (class 0 OID 0)
-- Dependencies: 216
-- Name: BayLineTypes_Code_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."BayLineTypes_Code_seq"', 1, false);


--
-- TOC entry 4417 (class 0 OID 0)
-- Dependencies: 219
-- Name: BayLinesFadedTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."BayLinesFadedTypes_id_seq"', 6, true);


--
-- TOC entry 4418 (class 0 OID 0)
-- Dependencies: 221
-- Name: Bays2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."Bays2_id_seq"', 78364, true);


--
-- TOC entry 4419 (class 0 OID 0)
-- Dependencies: 224
-- Name: BaysLines_SignIssueTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."BaysLines_SignIssueTypes_id_seq"', 4, true);


--
-- TOC entry 4420 (class 0 OID 0)
-- Dependencies: 225
-- Name: CECStatusTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."CECStatusTypes_id_seq"', 5, true);


--
-- TOC entry 4421 (class 0 OID 0)
-- Dependencies: 229
-- Name: EDI01_Signs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."EDI01_Signs_id_seq"', 56903, true);


--
-- TOC entry 4422 (class 0 OID 0)
-- Dependencies: 233
-- Name: LengthOfTime_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."LengthOfTime_id_seq"', 17, true);


--
-- TOC entry 4423 (class 0 OID 0)
-- Dependencies: 235
-- Name: Lines2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."Lines2_id_seq"', 151803, true);


--
-- TOC entry 4424 (class 0 OID 0)
-- Dependencies: 241
-- Name: PTAs_180725_merged_10_id_seq; Type: SEQUENCE SET; Schema: public; Owner: edi_operator
--

SELECT pg_catalog.setval('"public"."PTAs_180725_merged_10_id_seq"', 110, true);


--
-- TOC entry 4425 (class 0 OID 0)
-- Dependencies: 243
-- Name: PaymentTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."PaymentTypes_id_seq"', 4, true);


--
-- TOC entry 4426 (class 0 OID 0)
-- Dependencies: 245
-- Name: ProposalStatusTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."ProposalStatusTypes_id_seq"', 3, true);


--
-- TOC entry 4427 (class 0 OID 0)
-- Dependencies: 246
-- Name: Proposals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."Proposals_id_seq"', 148, true);


--
-- TOC entry 4428 (class 0 OID 0)
-- Dependencies: 256
-- Name: RestrictionGeometryTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RestrictionGeometryTypes_id_seq"', 19, true);


--
-- TOC entry 4429 (class 0 OID 0)
-- Dependencies: 258
-- Name: RestrictionLayers2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RestrictionLayers2_id_seq"', 7, true);


--
-- TOC entry 4430 (class 0 OID 0)
-- Dependencies: 259
-- Name: RestrictionPolygonTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RestrictionPolygonTypes_id_seq"', 6, true);


--
-- TOC entry 4431 (class 0 OID 0)
-- Dependencies: 264
-- Name: RestrictionStatus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RestrictionStatus_id_seq"', 4, true);


--
-- TOC entry 4432 (class 0 OID 0)
-- Dependencies: 265
-- Name: RestrictionTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."RestrictionTypes_id_seq"', 50, true);


--
-- TOC entry 4433 (class 0 OID 0)
-- Dependencies: 269
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."SignFadedTypes_id_seq"', 8, true);


--
-- TOC entry 4434 (class 0 OID 0)
-- Dependencies: 271
-- Name: SignMounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."SignMounts_id_seq"', 7, true);


--
-- TOC entry 4435 (class 0 OID 0)
-- Dependencies: 273
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."SignObscurredTypes_id_seq"', 3, true);


--
-- TOC entry 4436 (class 0 OID 0)
-- Dependencies: 275
-- Name: SignTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."SignTypes_id_seq"', 42, true);


--
-- TOC entry 4437 (class 0 OID 0)
-- Dependencies: 277
-- Name: Surveyors_Code_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."Surveyors_Code_seq"', 14, true);


--
-- TOC entry 4438 (class 0 OID 0)
-- Dependencies: 278
-- Name: TROStatusTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."TROStatusTypes_id_seq"', 3, true);


--
-- TOC entry 4439 (class 0 OID 0)
-- Dependencies: 280
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."TicketMachineIssueTypes_id_seq"', 4, true);


--
-- TOC entry 4440 (class 0 OID 0)
-- Dependencies: 251
-- Name: TimePeriods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."TimePeriods_id_seq"', 329, true);


--
-- TOC entry 4441 (class 0 OID 0)
-- Dependencies: 284
-- Name: baysWordingTypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."baysWordingTypes_id_seq"', 5, true);


--
-- TOC entry 4442 (class 0 OID 0)
-- Dependencies: 286
-- Name: baytypes_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."baytypes_gid_seq"', 70, true);


--
-- TOC entry 4443 (class 0 OID 0)
-- Dependencies: 287
-- Name: controlledparkingzones_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."controlledparkingzones_gid_seq"', 40, true);


--
-- TOC entry 4444 (class 0 OID 0)
-- Dependencies: 288
-- Name: corners_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."corners_seq"', 34569, true);


--
-- TOC entry 4445 (class 0 OID 0)
-- Dependencies: 289
-- Name: issueid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."issueid_seq"', 1809, true);


--
-- TOC entry 4446 (class 0 OID 0)
-- Dependencies: 291
-- Name: layer_styles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: edi_operator
--

SELECT pg_catalog.setval('"public"."layer_styles_id_seq"', 1, true);


--
-- TOC entry 4447 (class 0 OID 0)
-- Dependencies: 293
-- Name: linetypes2_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."linetypes2_gid_seq"', 40, true);


--
-- TOC entry 4448 (class 0 OID 0)
-- Dependencies: 294
-- Name: pta_ref; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."pta_ref"', 153, true);


--
-- TOC entry 4449 (class 0 OID 0)
-- Dependencies: 261
-- Name: restrictionPolygons_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."restrictionPolygons_seq"', 953, true);


--
-- TOC entry 4450 (class 0 OID 0)
-- Dependencies: 295
-- Name: serial; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."serial"', 926, true);


--
-- TOC entry 4451 (class 0 OID 0)
-- Dependencies: 296
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."signAttachmentTypes2_id_seq"', 9, true);


--
-- TOC entry 4452 (class 0 OID 0)
-- Dependencies: 298
-- Name: signs_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."signs_gid_seq"', 1094, true);


-- Completed on 2020-06-18 18:49:27

--
-- PostgreSQL database dump complete
--

