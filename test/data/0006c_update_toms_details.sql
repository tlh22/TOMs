-- Deal with errant bay types

SET session_replication_role = replica;  -- Disable all triggers

UPDATE toms."Bays" AS b
SET "GeomShapeID" = "GeomShapeID" - 20
FROM toms_lookups."BayTypesInUse" l
WHERE b."RestrictionTypeID" = l."Code"
AND b."GeomShapeID" > 20
AND l."GeomShapeGroupType" = 'LineString';

UPDATE toms."Bays" AS b
SET "GeomShapeID" = "GeomShapeID" + 20
FROM toms_lookups."BayTypesInUse" l
WHERE b."RestrictionTypeID" = l."Code"
AND b."GeomShapeID" < 20
AND l."GeomShapeGroupType" = 'Polygon';

SET session_replication_role = DEFAULT;  -- Enable all triggers

--
-- TOC entry 308 (class 1259 OID 368640)
-- Name: SignTypes_upd; Type: TABLE; Schema: toms_lookups; Owner: postgres
--

CREATE TABLE "toms_lookups"."SignTypes_upd" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL,
    "Icon" character varying(255)
);


ALTER TABLE "toms_lookups"."SignTypes_upd" OWNER TO "postgres";


--
-- TOC entry 4611 (class 0 OID 368640)
-- Dependencies: 308
-- Data for Name: SignTypes_upd; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--


INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (13, 'Parking - Red Route/Greenway Loading Bay', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (14, 'Parking - Red Route/Greenway Loading/Disabled Bay', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (15, 'Parking - Red Route/Greenway Loading/Parking Bay', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (16, 'Parking - Red Route/Greenway Parking Bay', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (17, 'Parking - Half on/Half off', 'UK_traffic_sign_667.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (20, 'Parking - Motorcycles only bay', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (21, 'Parking - No loading', 'UK_traffic_sign_638.1.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (22, 'Parking - No waiting', 'UK_traffic_sign_639.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (24, 'Parking - On pavement parking', 'UK_traffic_sign_668.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (26, 'Parking - Pay and Display/Pay by Phone bays', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (27, 'Zone - Pedestrian Zone', 'UK_traffic_sign_618.2.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (28, 'Parking - Permit Holders only', 'UK_traffic_sign_660.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (29, 'Parking - Police bay', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (30, 'Parking - Private/Residents only bay', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (31, 'Parking - Permit Holders only (Residents)', 'UK_traffic_sign_660.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (32, 'Parking - Shared use bays', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (33, 'Parking - Taxi ranks', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (34, 'Other - Ticket machine', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (36, 'Parking - Zig-Zag school keep clear', 'UK_traffic_sign_.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (41, 'Parking - No Stopping - School', 'UK_traffic_sign_.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (43, 'Parking - Red Route Limited Waiting Bay', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (44, 'Zone - Restricted Parking Zone - entry', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (45, 'Parking - Permit Holders only (Business)', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (46, 'Zone - Restricted Parking Zone', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (47, 'Parking - Half on/Half off (end)', 'UK_traffic_sign_667.2.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (48, 'Parking - Half on/Half off zone (not allowed) (start)', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (49, 'Zone - Permit Parking Zone (PPZ) (end)', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (50, 'Parking - Half on/Half off zone (not allowed) (end)', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (51, 'Parking - Car Park Tariff Board', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (52, 'Zone - Overnight Coach and Truck ban Zone start', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (53, 'Zone - Overnight Coach and Truck ban Zone end', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (54, 'Other - Private Estate sign', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (55, 'Zone - Truck waiting ban zone start', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (56, 'Zone - Truck waiting ban zone end', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (57, 'Parking - Truck waiting ban', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (521, 'Warning - Two Way Traffic', 'UK_traffic_sign_521.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (522, 'Warning - Two Way Traffic on crossing ahead', 'UK_traffic_sign_522.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (612, 'Banned Turn - No Right Turn', 'UK_traffic_sign_612.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (613, 'Banned Turn - No Left Turn', 'UK_traffic_sign_613.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (614, 'Banned Turn - No U Turn', 'UK_traffic_sign_614.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (616, 'One Way - No entry', 'UK_traffic_sign_616.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (617, 'Access Restriction - All Vehicles Prohibited', 'UK_traffic_sign_617.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (618, 'Zone - Play Street', 'UK_traffic_sign_618.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (619, 'Access Restriction - All Motor Vehicles Prohibited', 'UK_traffic_sign_619.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (675, '20 MPH Zone End - Start 30 MPH Max', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (951, 'Access Restriction - All Cycles prohibited', 'UK_traffic_sign_951.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (952, 'Access Restriction - All Buses Prohibited', 'UK_traffic_sign_952.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (955, 'Cycling - Pedal Cycles Only', 'UK_traffic_sign_955.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (956, 'Cycling - Pedestrians and Cycles only', 'UK_traffic_sign_956.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (957, 'Cycling - Separated track and path for cyclists and pedestrians ', 'UK_traffic_sign_957.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6061, 'Compulsory Turn - Proceed Right', 'UK_traffic_sign_606B.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6062, 'Compulsory Turn - Proceed Left', 'UK_traffic_sign_606.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6063, 'Compulsory Turn - Proceed Straight', 'UK_traffic_sign_606F.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6091, 'Compulsory Turn - Turn Left Ahead', 'UK_traffic_sign_609.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6092, 'Compulsory Turn - Turn Right Ahead', 'UK_traffic_sign_609A.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6111, 'Compulsory Turn - Mini-roundabout', 'UK_traffic_sign_611.1.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6191, 'Access Restriction - All Motor Vehicles except solo motorcycles prohibited', 'UK_traffic_sign_619.1.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6192, 'Access Restriction - All Motorcycles Prohibited', 'UK_traffic_sign_619.2.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6262, 'Physical restriction - Weak Bridge', 'UK_traffic_sign_626.2AV2.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6291, 'Physical restriction - Width Restriction - Imperial', 'UK_traffic_sign_629.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6292, 'Physical restriction - Width Restriction', 'UK_traffic_sign_629A.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6294, 'Zone - Physical - Height Restriction', 'UK_traffic_sign_.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6634, 'Parking - Half on/Half off (not allowed)', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (9541, 'Supplementary plate - Except buses', 'UK_traffic_sign_954.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (9544, 'Supplementary plate -Except cycles', 'UK_traffic_sign_954.4.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (9581, 'Special Lane - With flow bus lane ahead (with cycles and taxis)', 'UK_traffic_sign_958.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (9591, 'Special Lane - With flow bus lane (with cycles and taxis)', 'UK_traffic_sign_959.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (9592, 'Special Lane - With flow cycle lane', 'UK_traffic_sign_959.1.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (9621, 'Special Lane - Cycle lane at junction ahead', 'UK_traffic_sign_9621.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (5041, 'Warning - Crossroads ahead', 'UK_traffic_sign_504.1.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (610, 'Other moves - Keep Left', 'UK_traffic_sign_610.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (69, 'Other - Bus information', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (5131, 'Warning - Double bend ahead - first left', 'UK_traffic_sign_513.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (5132, 'Warning - double bend ahead - first right', 'UK_traffic_sign_513R.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (556, 'Warning - Uneven road surface', 'UK_traffic_sign_556.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (5573, 'Supplementary plate - Humps in direction and for distance', 'UK_traffic_sign_557.3.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (502, 'Supplementary plate - Distance to stop sign', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (503, 'Supplementary plate - Distance to Give way sign', 'UK_traffic_sign_503.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (615, 'Other moves - Priority to on-coming traffic', 'UK_traffic_sign_615.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (1, 'Parking - 5T trucks and buses', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (2, 'Parking - Ambulances only bay', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (3, 'Parking - Bus only bay', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (4, 'Parking - Bus stops/Bus stands', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (5, 'Parking - Car club bay', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (10, 'Parking - Electric vehicles recharging point', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (11, 'Parking - Free parking bays (not Limited Waiting)', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (811, 'Other moves - Priority over oncoming traffic', 'UK_traffic_sign_811.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (25, 'Other (please specify)', 'UK_traffic_sign_.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (670, 'Max speed limit (other)', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (67020, '20 MPH (Max)', 'UK_traffic_sign_670V20.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (67030, '30 MPH  (Max)', 'UK_traffic_sign_670V30.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (67040, '40 MPH (Max)', 'UK_traffic_sign_670V40.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (67010, '10 MPH (Max)', 'UK_traffic_sign_670V10.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (67005, '5 MPH (Max)', 'UK_traffic_sign_670V05.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (642, 'Clearway', 'UK_traffic_sign_642.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (674, '20 MPH Zone', 'UK_traffic_sign_674.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (880, 'Speed zone reminder (with or without camera)', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (67640, '40 MPH Zone', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (652, 'One Way - Arrow Only', 'UK_traffic_sign_652.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (607, 'One Way - Words Only', 'UK_traffic_sign_607.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (9602, 'One-way traffic with contraflow pedal cycles', 'UK_traffic_sign_960.2.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (9601, 'One-way traffic with contraflow cycle lane', 'UK_traffic_sign_960.1.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (35, 'To be deleted', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (37, 'Pole only, no sign', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (953, 'Route used by Buses and Cycles only', 'UK_traffic_sign_953.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (810, 'One Way - Arrow and Words', 'UK_traffic_sign_810.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (401, 'Advisory Sign (see photo)', 'UK_traffic_sign.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (201, 'Route Sign (see photo)', 'UK_traffic_sign.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (12, 'Parking - Red Route/Greenway Disabled Bay', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (0, 'Missing', 'UK_traffic_sign_missing.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (664, 'Zone ends', 'UK_traffic_sign_664.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (42, 'On Street NOT in TRO', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (779, 'Warning - Overhead electric wires', 'UK_traffic_sign_779.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (950, 'Warning - Cycles', 'UK_traffic_sign_950.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (544, 'Warning - Pedestrian Crossing', 'UK_traffic_sign_544.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6, 'Zone - CPZ entry', 'UK_traffic_sign_663.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (7, 'Zone - CPZ exit', 'UK_traffic_sign_664.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (8, 'Parking - Disabled bay', 'UK_traffic_sign_661A.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (9, 'Parking - Doctor bay', 'UK_traffic_sign_660VD.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (18, 'Parking - Limited waiting (no payment)', 'UK_traffic_sign_661.1.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (19, 'Parking - Loading bay', 'UK_traffic_sign_660.4.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (23, 'Parking - No waiting and no loading', 'UK_traffic_sign_640_times_arrows.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (38, 'Parking - No stopping - Red Route/Greenway', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (39, 'Parking - Red Route/Greenway exit area', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (40, 'Parking - Permit Parking Zone (PPZ) (start)', NULL);
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (67, 'Zone - Congestion Zone', 'UK_traffic_sign_symbol_NS67.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (68, 'Other - Speed Camera', 'Earlyswerver_UK_Speed_Camera_Sign.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (546, 'Supplementary plate - School', 'UK_traffic_sign_546.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (602, 'Other - Give Way', 'UK_traffic_sign_602.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (620, 'Supplementary plate -Except for access', 'UK_traffic_sign_620.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (668, 'Parking - Pavement Parking (start)', 'UK_traffic_sign_668.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (816, 'Other - No Through Road', 'UK_traffic_sign_816.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (964, 'Special Lane - End of bus lane', 'UK_traffic_sign_964.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6011, 'Other - Stop', 'UK_traffic_sign_601.1.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6202, 'Supplementary plate -Except for loading', 'UK_traffic_sign_620.2.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6682, 'Parking - Pavement Parking (end)', 'UK_traffic_sign_668.2.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (62211, 'Physical restriction - Weight restriction', 'UK_traffic_sign_622.1A.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (64021, 'Parking - Overnight Coach and Truck ban', 'UK_traffic_sign_640.2A.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (545, 'Warning - Children going to/from school', 'UK_traffic_sign_545.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (5441, 'Warning - Pedestrians in road ahead', 'UK_traffic_sign_544.1.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (5442, 'Warning - Elderly people likely to cross road ahead', 'UK_traffic_sign_544.2.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6101, 'Other moves - Keep Right', 'UK_traffic_sign_610R.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (543, 'Warning - Traffic lights', 'UK_traffic_sign_543.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (5571, 'Warning - Speed hump', 'UK_traffic_sign_557.1.svg');
INSERT INTO "toms_lookups"."SignTypes_upd" ("Code", "Description", "Icon") VALUES (6151, 'Supplementary plate - Give way to oncoming vehicles', 'UK_traffic_sign_615.1.svg');
--
-- TOC entry 4472 (class 2606 OID 368884)
-- Name: SignTypes_upd SignTypes_upd_pkey; Type: CONSTRAINT; Schema: toms_lookups; Owner: postgres
--

ALTER TABLE ONLY "toms_lookups"."SignTypes_upd"
    ADD CONSTRAINT "SignTypes_upd_pkey" PRIMARY KEY ("Code");


-- Now process the changes

UPDATE toms_lookups."SignTypes" AS o
SET "Description" = u."Description", "Icon" = u."Icon"
FROM toms_lookups."SignTypes_upd" u
WHERE o."Code" = u."Code";

INSERT INTO toms_lookups."SignTypes" ("Code", "Description", "Icon")
SELECT "Code", "Description", "Icon"
FROM toms_lookups."SignTypes_upd"
WHERE "Code" NOT IN (SELECT "Code" FROM toms_lookups."SignTypes");

-- need to add details to 'signTypesInUse'
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code")
--WHERE "Code" IN (
    SELECT "Code"
    FROM "toms_lookups"."SignTypes"
	WHERE (
	   "Description" LIKE 'Access Restriction %'
	OR "Description" LIKE 'Banned Turn %'
	OR "Description" LIKE 'Compulsory Turn %'
	OR "Description" LIKE 'Cycling %'
	OR "Description" LIKE 'One Way %'
	OR "Description" LIKE 'Other %'
	OR "Description" LIKE 'Parking %'
	OR "Description" LIKE 'Physical restriction %'
	OR "Description" LIKE 'Special Lane %'
	OR "Description" LIKE 'Supplementary Plate %'
	OR "Description" LIKE 'Warning %'
	OR "Description" LIKE 'Zone %'
		)
	AND "Code" NOT IN (SELECT "Code" FROM "toms_lookups"."SignTypesInUse")
--)
;

REFRESH MATERIALIZED VIEW "toms_lookups"."SignTypesInUse_View";

-- and tidy ...

DROP TABLE toms_lookups."SignTypes_upd" CASCADE;

-- Update MHTC_CheckIssueTypes

CREATE TABLE "compliance_lookups"."MHTC_CheckIssueTypes_upd" (
    "Code" integer NOT NULL,
    "Description" character varying NOT NULL
);

ALTER TABLE "compliance_lookups"."MHTC_CheckIssueTypes_upd" OWNER TO "postgres";

INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes_upd" ("Code", "Description") VALUES (1, 'Item checked - Available for release');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes_upd" ("Code", "Description") VALUES (10, 'Field visit - Item missed - confirm location and details');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes_upd" ("Code", "Description") VALUES (11, 'Field visit - Photo missing or needs to be retaken');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes_upd" ("Code", "Description") VALUES (15, 'Field visit - Check details (see notes)');

DELETE FROM "compliance_lookups"."MHTC_CheckIssueTypes"
WHERE "Code" NOT IN (SELECT "Code" FROM "compliance_lookups"."MHTC_CheckIssueTypes_upd");

UPDATE "compliance_lookups"."MHTC_CheckIssueTypes" AS o
SET "Description" = u."Description"
FROM compliance_lookups."MHTC_CheckIssueTypes_upd" u
WHERE o."Code" = u."Code";

INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description")
SELECT "Code", "Description"
FROM compliance_lookups."MHTC_CheckIssueTypes_upd"
WHERE "Code" NOT IN (SELECT "Code" FROM "compliance_lookups"."MHTC_CheckIssueTypes");

DROP TABLE "compliance_lookups"."MHTC_CheckIssueTypes_upd" CASCADE;

INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (6, 'Oblique in the same direction as road');
INSERT INTO "toms_lookups"."SignOrientationTypes" ("Code", "Description") VALUES (7, 'Oblique in the opposite direction to road');
