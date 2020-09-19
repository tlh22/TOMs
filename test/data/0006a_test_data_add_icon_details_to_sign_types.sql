

-- SignTypes - need to include ICON field and update from MASTER

CREATE SEQUENCE public."SignTypes_id_seq"
    INCREMENT 1
    START 130
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public."SignTypes_id_seq"
    OWNER TO postgres;

CREATE TABLE "public"."SignTypes" (
    "id" integer DEFAULT "nextval"('"public"."SignTypes_id_seq"'::"regclass") NOT NULL,
    "Code" character varying,
    "Description" character varying,
    "Icon" character varying(255),
    "Category" integer,
    "MovingOrders" boolean,
    "StaticOrders" boolean
);


ALTER TABLE "public"."SignTypes" OWNER TO "postgres";

--
-- TOC entry 3749 (class 0 OID 39032)
-- Dependencies: 214
-- Data for Name: SignTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (12, '12', 'Red Route/Greenway Disabled Bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (13, '13', 'Red Route/Greenway Loading Bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (14, '14', 'Red Route/Greenway Loading/Disabled Bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (15, '15', 'Red Route/Greenway Loading/Parking Bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (16, '16', 'Red Route/Greenway Parking Bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (25, '25', 'Other (please specify)', 'UK_traffic_sign_.svg', NULL, true, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (27, '27', 'Pedestrian Zone', 'UK_traffic_sign_618.2.svg', NULL, true, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (101, '45', 'Business Permit Holder only', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (102, '46', 'Restricted Parking Zone', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (120, '670', 'Max speed limit (other)', NULL, NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (103, '47', 'Half on/Half off (end)', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (105, '49', 'Permit Parking Zone (PPZ) (end)', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (17, '17', 'Half on/Half off', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (117, '67020', '20 MPH (Max)', 'UK_traffic_sign_670V20.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (104, '48', 'Half on/Half off zone (not allowed) (start)', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (106, '50', 'Half on/Half off zone (not allowed) (end)', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (107, '51', 'Car Park Tariff Board', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (118, '67030', '30 MPH  (Max)', 'UK_traffic_sign_670V30.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (108, '52', 'Overnight Coach and Truck ban Zone start', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (109, '53', 'Overnight Coach and Truck ban Zone end', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (3, '3', 'Bus only bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (110, '54', 'Private Estate sign', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (119, '67040', '40 MPH (Max)', 'UK_traffic_sign_670V40.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (125, '67010', '10 MPH (Max)', 'UK_traffic_sign_670V10.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (126, '67005', '5 MPH (Max)', 'UK_traffic_sign_670V05.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (122, '675', 'End 20 MPH Zone - Start 30 MPH Max', NULL, NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (113, '55', 'Truck waiting ban zone start', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (114, '56', 'Truck waiting ban zone end', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (112, '6634', 'Half on/Half off (not allowed)', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (115, '57', 'Truck waiting ban', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (111, '642', 'Clearway', 'UK_traffic_sign_642.svg', NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (116, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (121, '674', '20 MPH Zone', 'UK_traffic_sign_674.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (127, '811', 'Priority over oncoming traffic', 'UK_traffic_sign_811.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (124, '880', 'Speed zone reminder (with or without camera)', NULL, NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (123, '67640', '40 MPH Zone', NULL, NULL, NULL, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (128, '957', 'Separated track and path for cyclists and pedestrians ', 'UK_traffic_sign_957.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (36, '36', 'Zig-Zag school keep clear', 'UK_traffic_sign_.svg', NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (41, '41', 'No Stopping - School', 'UK_traffic_sign_.svg', NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (59, '6291', 'Width Restriction - Imperial', 'UK_traffic_sign_629.svg', NULL, NULL, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (60, '6292', 'Width Restriction', 'UK_traffic_sign_629A.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (69, '6294', 'Height Restriction', 'UK_traffic_sign_.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (1, '1', '5T trucks and buses', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (2, '2', 'Ambulances only bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (4, '4', 'Bus stops/Bus stands', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (5, '5', 'Car club', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (6, '6', 'CPZ entry', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (7, '7', 'CPZ exit', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (8, '8', 'Disabled bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (9, '9', 'Doctor bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (10, '10', 'Electric vehicles recharging point', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (11, '11', 'Free parking bays (not Limited Waiting)', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (129, '618', 'Play Street', 'UK_traffic_sign_618.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (130, '6192', 'All Motorcycles Prohibited', 'UK_traffic_sign_619.2.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (19, '19', 'Loading bay', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (50, '610', 'Keep Left', 'UK_traffic_sign_610.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (51, '6061', 'Proceed in direction indicated - Right', 'UK_traffic_sign_606B.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (52, '6062', 'Proceed in direction indicated - Left', 'UK_traffic_sign_606.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (53, '6063', 'Proceed in direction indicated - Straight', 'UK_traffic_sign_606F.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (54, '652', 'One Way - Arrow Only', 'UK_traffic_sign_652.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (55, '6092', 'Turn Right Ahead', 'UK_traffic_sign_609A.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (56, '6091', 'Turn Left Ahead', 'UK_traffic_sign_609.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (57, '607', 'One Way - Words Only', 'UK_traffic_sign_607.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (58, '616', 'No entry', 'UK_traffic_sign_616.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (61, '613', 'No Left Turn', 'UK_traffic_sign_613.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (62, '612', 'No Right Turn', 'UK_traffic_sign_612.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (63, '614', 'No U Turn', 'UK_traffic_sign_614.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (64, '615', 'Priority to on-coming traffic', 'UK_traffic_sign_615.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (65, '9602', 'One-way traffic with contraflow pedal cycles', 'UK_traffic_sign_960.2.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (66, '9601', 'One-way traffic with contraflow cycle lane', 'UK_traffic_sign_960.1.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (67, '9541', 'Except buses', 'UK_traffic_sign_954.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (68, '9544', 'Except cycles', 'UK_traffic_sign_954.4.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (18, '18', 'Limited waiting (no payment)', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (20, '20', 'Motorcycles only bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (21, '21', 'No loading', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (22, '22', 'No waiting', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (23, '23', 'No waiting and no loading', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (24, '24', 'On pavement parking', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (26, '26', 'Pay and Display/Pay by Phone bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (28, '28', 'Permit holders only', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (29, '29', 'Police bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (30, '30', 'Private/Residents only bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (31, '31', 'Residents permit holders only', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (32, '32', 'Shared use bays', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (33, '33', 'Taxi ranks', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (34, '34', 'Ticket machine', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (35, '35', 'To be deleted', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (37, '37', 'Pole only, no sign', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (96, '43', 'Red Route Limited Waiting Bay', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (99, '44', 'Restricted Parking Zone - entry', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (70, '617', 'All Vehicles Prohibited', 'UK_traffic_sign_617.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (71, '619', 'All Motor Vehicles Prohibited', 'UK_traffic_sign_619.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (72, '6262', 'Weak Bridge', 'UK_traffic_sign_626.2AV2.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (73, '955', 'Pedal Cycles Only', 'UK_traffic_sign_955.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (75, '956', 'Pedestrians and Cycles only', 'UK_traffic_sign_956.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (76, '953', 'Route used by Buses and Cycles only', 'UK_traffic_sign_953.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (77, '6191', 'Motor Vehicles except solo motorcycles prohibited', 'UK_traffic_sign_619.1.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (79, '521', 'Two Way Traffic', 'UK_traffic_sign_521.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (80, '522', 'Two Way Traffic on crossing ahead', 'UK_traffic_sign_522.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (81, '9592', 'With flow cycle lane', 'UK_traffic_sign_959.1.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (82, '810', 'One Way - Arrow and Words', 'UK_traffic_sign_810.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (83, '952', 'All Buses Prohibited', 'UK_traffic_sign_952.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (84, '6111', 'Mini-roundabout', 'UK_traffic_sign_611.1.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (85, '9581', 'With flow bus lane ahead (with cycles and taxis)', 'UK_traffic_sign_958.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (86, '9591', 'With flow bus lane (with cycles and taxis)', 'UK_traffic_sign_959.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (87, '951', 'All Cycles prohibited', 'UK_traffic_sign_951.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (88, '401', 'Advisory Sign (see photo)', 'UK_traffic_sign.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (89, '201', 'Route Sign (see photo)', 'UK_traffic_sign.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (90, '9621', 'Cycle lane at junction ahead', 'UK_traffic_sign_9621.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (91, '816', 'No Through Road', 'UK_traffic_sign_816.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (92, '964', 'End of bus lane', 'UK_traffic_sign_964.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (94, '6101', 'Keep Right', 'UK_traffic_sign_610R.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (97, '620', 'Except for access', 'UK_traffic_sign_620.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (98, '6202', 'Except for loading', 'UK_traffic_sign_620.2.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (38, '38', 'No stopping - Red Route/Greenway', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (39, '39', 'Red Route/Greenway exit area', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (93, '0', 'Missing', 'UK_traffic_sign_missing.svg', NULL, true, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (95, '664', 'Zone ends', 'UK_traffic_sign_664.svg', NULL, true, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (42, '42', 'On Street NOT in TRO', NULL, NULL, NULL, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (40, '40', 'Permit Parking Zone (PPZ) (start)', NULL, NULL, NULL, true);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (74, '62211', 'Weight restriction', 'UK_traffic_sign_622.1A.svg', NULL, true, NULL);
INSERT INTO "public"."SignTypes" ("id", "Code", "Description", "Icon", "Category", "MovingOrders", "StaticOrders") VALUES (78, '64021', 'Overnight Coach and Truck ban', 'UK_traffic_sign_640.2A.svg', NULL, NULL, true);

--
-- TOC entry 3617 (class 2606 OID 39075)
-- Name: SignTypes SignTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignTypes"
    ADD CONSTRAINT "SignTypes_pkey" PRIMARY KEY ("id");

-- Now update Icon field

UPDATE toms_lookups."SignTypes" t
SET "Icon" = m."Icon"
FROM public."SignTypes" m
WHERE t."Code" = CAST (m."Code" AS integer);

-- Drop master table
DROP TABLE public."SignTypes" CASCADE;


