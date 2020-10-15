/*
Migration scripts from 0000 to 0001
One of the aims is to move to a standard set of lookups that can be shared across any project/authority.
The lookups are:
BayLineTypes
TimePeriods
LengthOfTime

*/

/*
CREATE USER "edi_admin" WITH PASSWORD 'password';
CREATE USER "edi_operator" WITH PASSWORD 'password';
CREATE USER "edi_public" WITH PASSWORD 'password';
CREATE USER "edi_public_nsl" WITH PASSWORD 'password';
*/

--
-- TOC entry 238 (class 1259 OID 38231)
-- Name: LookupCodeTransfers_Bays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."LookupCodeTransfers_Bays" (
    "id" integer NOT NULL,
    "Aug2018_Description" character varying,
    "Aug2018_Code" character varying,
    "CurrCode" character varying
);


ALTER TABLE "public"."LookupCodeTransfers_Bays" OWNER TO "postgres";

--
-- TOC entry 239 (class 1259 OID 38237)
-- Name: LookupCodeTransfers_Bays_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."LookupCodeTransfers_Bays_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."LookupCodeTransfers_Bays_id_seq" OWNER TO "postgres";

--
-- TOC entry 3989 (class 0 OID 0)
-- Dependencies: 239
-- Name: LookupCodeTransfers_Bays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."LookupCodeTransfers_Bays_id_seq" OWNED BY "public"."LookupCodeTransfers_Bays"."id";


--
-- TOC entry 3845 (class 2604 OID 38483)
-- Name: LookupCodeTransfers_Bays id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."LookupCodeTransfers_Bays" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."LookupCodeTransfers_Bays_id_seq"'::"regclass");


--
-- TOC entry 3982 (class 0 OID 38231)
-- Dependencies: 238
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
-- TOC entry 3990 (class 0 OID 0)
-- Dependencies: 239
-- Name: LookupCodeTransfers_Bays_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."LookupCodeTransfers_Bays_id_seq"', 57, true);


--
-- TOC entry 3847 (class 2606 OID 38747)
-- Name: LookupCodeTransfers_Bays LookupCodeTransfers_Bays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."LookupCodeTransfers_Bays"
    ADD CONSTRAINT "LookupCodeTransfers_Bays_pkey" PRIMARY KEY ("id");


--
-- TOC entry 240 (class 1259 OID 38239)
-- Name: LookupCodeTransfers_Lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."LookupCodeTransfers_Lines" (
    "id" integer NOT NULL,
    "Aug2018_Description" character varying,
    "Aug2018_Code" character varying,
    "CurrCode" character varying
);


ALTER TABLE "public"."LookupCodeTransfers_Lines" OWNER TO "postgres";

--
-- TOC entry 241 (class 1259 OID 38245)
-- Name: LookupCodeTransfers_Lines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."LookupCodeTransfers_Lines_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."LookupCodeTransfers_Lines_id_seq" OWNER TO "postgres";

--
-- TOC entry 3989 (class 0 OID 0)
-- Dependencies: 241
-- Name: LookupCodeTransfers_Lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."LookupCodeTransfers_Lines_id_seq" OWNED BY "public"."LookupCodeTransfers_Lines"."id";


--
-- TOC entry 3845 (class 2604 OID 38484)
-- Name: LookupCodeTransfers_Lines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."LookupCodeTransfers_Lines" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."LookupCodeTransfers_Lines_id_seq"'::"regclass");


--
-- TOC entry 3982 (class 0 OID 38239)
-- Dependencies: 240
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
INSERT INTO "public"."LookupCodeTransfers_Lines" ("id", "Aug2018_Description", "Aug2018_Code", "CurrCode") VALUES (31, 'Zig-Zag Keep Clear White', '19', '226');


--
-- TOC entry 3990 (class 0 OID 0)
-- Dependencies: 241
-- Name: LookupCodeTransfers_Lines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."LookupCodeTransfers_Lines_id_seq"', 30, true);


--
-- TOC entry 3847 (class 2606 OID 38749)
-- Name: LookupCodeTransfers_Lines LookupCodeTransfers_Lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."LookupCodeTransfers_Lines"
    ADD CONSTRAINT "LookupCodeTransfers_Lines_pkey" PRIMARY KEY ("id");

---

CREATE TABLE public."BayLineTypesInUse"
(
  gid SERIAL,
  "Code" integer,
  CONSTRAINT "BayLineTypesInUse_pkey" PRIMARY KEY (gid),
  CONSTRAINT "BayLineTypesInUse_Code_key" UNIQUE ("Code")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public."BayLineTypesInUse"
  OWNER TO postgres;
GRANT ALL ON TABLE public."BayLineTypesInUse" TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE public."BayLineTypesInUse" TO edi_admin;
GRANT SELECT ON TABLE public."BayLineTypesInUse" TO edi_operator;
GRANT SELECT ON TABLE public."BayLineTypesInUse" TO edi_public;
GRANT SELECT ON TABLE public."BayLineTypesInUse" TO edi_public_nsl;

INSERT INTO public."BayLineTypesInUse"("Code")
SELECT DISTINCT CAST("CurrCode" AS int)
FROM "LookupCodeTransfers_Bays"
UNION
SELECT DISTINCT CAST("CurrCode" AS int)
FROM "LookupCodeTransfers_Lines"
ORDER BY "CurrCode";

-- DROP MATERIALIZED VIEW "BayLineTypes";

CREATE MATERIALIZED VIEW "BayLineTypes" ( "Code", "Description") AS

SELECT "BayLineTypes"."Code", "BayLineTypes"."Description"
FROM
      (SELECT "Code", "Description"
      FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=MasterLookups user=postgres password=password options=-csearch_path=',
		'SELECT "Code", "Description" FROM public."BayLineTypes"') AS "BayLineTypes"("Code" int, "Description" text)) AS "BayLineTypes",
       "BayLineTypesInUse" u
WHERE "BayLineTypes"."Code" = u."Code";

CREATE UNIQUE INDEX "BayLineTypes_key" on "BayLineTypes" ("Code");

