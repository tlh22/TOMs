/*
Original data structure

*/

--
-- TOC entry 3 (class 3079 OID 48301)
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "dblink" WITH SCHEMA "public";


--
-- TOC entry 4009 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "dblink"; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION "dblink" IS 'connect to other PostgreSQL databases from within a database';


--
-- TOC entry 4 (class 3079 OID 46802)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "postgis" WITH SCHEMA "public";


--
-- TOC entry 4010 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION "postgis"; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION "postgis" IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- TOC entry 2 (class 3079 OID 101414)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "public";


--
-- TOC entry 4011 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

-- Deal with name changes

ALTER TABLE public."CPZs"
    RENAME TO "ControlledParkingZones";

-- Change geom column name

ALTER TABLE public."Bays" RENAME COLUMN "SHAPE" TO geom;
ALTER TABLE public."Lines" RENAME COLUMN "SHAPE" TO geom;
ALTER TABLE public."Signs" RENAME COLUMN "SHAPE" TO geom;

--
-- TOC entry 202 (class 1259 OID 48355)
-- Name: BayLinesFadedTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."BayLinesFadedTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying,
    "Comment" character varying
);


ALTER TABLE "public"."BayLinesFadedTypes" OWNER TO "postgres";

--
-- TOC entry 203 (class 1259 OID 48361)
-- Name: BayLinesFadedTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."BayLinesFadedTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."BayLinesFadedTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4016 (class 0 OID 0)
-- Dependencies: 203
-- Name: BayLinesFadedTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."BayLinesFadedTypes_id_seq" OWNED BY "public"."BayLinesFadedTypes"."id";


--
-- TOC entry 206 (class 1259 OID 48372)
-- Name: BaysLines_SignIssueTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."BaysLines_SignIssueTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying,
    "Comment" character varying
);


ALTER TABLE "public"."BaysLines_SignIssueTypes" OWNER TO "postgres";

--
-- TOC entry 207 (class 1259 OID 48378)
-- Name: BaysLines_SignIssueTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."BaysLines_SignIssueTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."BaysLines_SignIssueTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4021 (class 0 OID 0)
-- Dependencies: 207
-- Name: BaysLines_SignIssueTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."BaysLines_SignIssueTypes_id_seq" OWNED BY "public"."BaysLines_SignIssueTypes"."id";


--
-- TOC entry 208 (class 1259 OID 48380)
-- Name: CECStatusTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."CECStatusTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."CECStatusTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 215 (class 1259 OID 48414)
-- Name: LengthOfTime; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."LengthOfTime" (
    "id" integer NOT NULL,
    "Code" bigint,
    "Description" character varying,
    "LabelText" character varying(255)
);


ALTER TABLE "public"."LengthOfTime" OWNER TO "postgres";

--
-- TOC entry 216 (class 1259 OID 48420)
-- Name: LengthOfTime_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."LengthOfTime_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."LengthOfTime_id_seq" OWNER TO "postgres";

--
-- TOC entry 4032 (class 0 OID 0)
-- Dependencies: 216
-- Name: LengthOfTime_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."LengthOfTime_id_seq" OWNED BY "public"."LengthOfTime"."id";

--
-- TOC entry 219 (class 1259 OID 48431)
-- Name: MapGrid; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE "public"."MapGrid" (
    "id" bigint NOT NULL,
    "geom" "public"."geometry"(MultiPolygon,27700),
    "x_min" double precision,
    "x_max" double precision,
    "y_min" double precision,
    "y_max" double precision,
    "RevisionNr" integer,
    "Edge" character varying(5),
    "CPZ tile" integer,
    "ContainsRes" integer,
    "LastRevisionDate" "date"
);


ALTER TABLE "public"."MapGrid" OWNER TO "edi_operator";

--
-- TOC entry 222 (class 1259 OID 48445)
-- Name: PaymentTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."PaymentTypes" (
    "id" integer NOT NULL,
    "Code" bigint,
    "Description" character varying
);


ALTER TABLE "public"."PaymentTypes" OWNER TO "postgres";

--
-- TOC entry 223 (class 1259 OID 48451)
-- Name: PaymentTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."PaymentTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."PaymentTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4041 (class 0 OID 0)
-- Dependencies: 223
-- Name: PaymentTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."PaymentTypes_id_seq" OWNED BY "public"."PaymentTypes"."id";

--
-- TOC entry 237 (class 1259 OID 48509)
-- Name: RestrictionTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionTypes" (
    "id" integer NOT NULL,
    "PK_UID" bigint,
    "Description" character varying,
    "OrigOrderCode" double precision
);


ALTER TABLE "public"."RestrictionTypes" OWNER TO "postgres";

--
-- TOC entry 231 (class 1259 OID 48483)
-- Name: RestrictionPolygonTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RestrictionPolygonTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RestrictionPolygonTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 232 (class 1259 OID 48485)
-- Name: RestrictionPolygonTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionPolygonTypes" (
    "id" integer DEFAULT "nextval"('"public"."RestrictionPolygonTypes_id_seq"'::"regclass") NOT NULL,
    "Code" integer,
    "Description" character varying
);


ALTER TABLE "public"."RestrictionPolygonTypes" OWNER TO "postgres";

--
-- TOC entry 238 (class 1259 OID 48515)
-- Name: RestrictionTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RestrictionTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RestrictionTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4066 (class 0 OID 0)
-- Dependencies: 238
-- Name: RestrictionTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RestrictionTypes_id_seq" OWNED BY "public"."RestrictionTypes"."id";

--
-- TOC entry 241 (class 1259 OID 48526)
-- Name: SignAttachmentTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."SignAttachmentTypes" (
    "id" integer NOT NULL,
    "Code" integer,
    "Description" character varying
);


ALTER TABLE "public"."SignAttachmentTypes" OWNER TO "postgres";

--
-- TOC entry 242 (class 1259 OID 48532)
-- Name: SignFadedTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."SignFadedTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE "public"."SignFadedTypes" OWNER TO "postgres";

--
-- TOC entry 243 (class 1259 OID 48538)
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."SignFadedTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."SignFadedTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4071 (class 0 OID 0)
-- Dependencies: 243
-- Name: SignFadedTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."SignFadedTypes_id_seq" OWNED BY "public"."SignFadedTypes"."id";


--
-- TOC entry 244 (class 1259 OID 48540)
-- Name: SignMountTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."SignMountTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE "public"."SignMountTypes" OWNER TO "postgres";

--
-- TOC entry 245 (class 1259 OID 48546)
-- Name: SignMounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."SignMounts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."SignMounts_id_seq" OWNER TO "postgres";

--
-- TOC entry 4074 (class 0 OID 0)
-- Dependencies: 245
-- Name: SignMounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."SignMounts_id_seq" OWNED BY "public"."SignMountTypes"."id";


--
-- TOC entry 246 (class 1259 OID 48548)
-- Name: SignObscurredTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."SignObscurredTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE "public"."SignObscurredTypes" OWNER TO "postgres";

--
-- TOC entry 247 (class 1259 OID 48554)
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."SignObscurredTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."SignObscurredTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4077 (class 0 OID 0)
-- Dependencies: 247
-- Name: SignObscurredTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."SignObscurredTypes_id_seq" OWNED BY "public"."SignObscurredTypes"."id";


--
-- TOC entry 248 (class 1259 OID 48556)
-- Name: SignTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."SignTypes2" (
    "id" integer NOT NULL,
    "Description" character varying,
    "Code" integer
);


ALTER TABLE "public"."SignTypes2" OWNER TO "postgres";

--
-- TOC entry 249 (class 1259 OID 48562)
-- Name: SignTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."SignTypes2_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."SignTypes2_id_seq" OWNER TO "postgres";

--
-- TOC entry 4080 (class 0 OID 0)
-- Dependencies: 249
-- Name: SignTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."SignTypes2_id_seq" OWNED BY "public"."SignTypes2"."id";


--
-- TOC entry 250 (class 1259 OID 48564)
-- Name: Surveyors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."Surveyors" (
    "Code" integer NOT NULL,
    "Description" character varying(255) NOT NULL
);


ALTER TABLE "public"."Surveyors" OWNER TO "postgres";

--
-- TOC entry 251 (class 1259 OID 48567)
-- Name: Surveyors_Code_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."Surveyors_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."Surveyors_Code_seq" OWNER TO "postgres";

--
-- TOC entry 4083 (class 0 OID 0)
-- Dependencies: 251
-- Name: Surveyors_Code_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."Surveyors_Code_seq" OWNED BY "public"."Surveyors"."Code";


--
-- TOC entry 252 (class 1259 OID 48569)
-- Name: TROStatusTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."TROStatusTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."TROStatusTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 253 (class 1259 OID 48571)
-- Name: TicketMachineIssueTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."TicketMachineIssueTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE "public"."TicketMachineIssueTypes" OWNER TO "postgres";

--
-- TOC entry 254 (class 1259 OID 48577)
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."TicketMachineIssueTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."TicketMachineIssueTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4087 (class 0 OID 0)
-- Dependencies: 254
-- Name: TicketMachineIssueTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."TicketMachineIssueTypes_id_seq" OWNED BY "public"."TicketMachineIssueTypes"."id";

--
-- TOC entry 257 (class 1259 OID 48588)
-- Name: baysWordingTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."baysWordingTypes" (
    "id" integer NOT NULL,
    "Code" character varying,
    "Description" character varying
);


ALTER TABLE "public"."baysWordingTypes" OWNER TO "postgres";

--
-- TOC entry 258 (class 1259 OID 48594)
-- Name: baysWordingTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."baysWordingTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."baysWordingTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4092 (class 0 OID 0)
-- Dependencies: 258
-- Name: baysWordingTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."baysWordingTypes_id_seq" OWNED BY "public"."baysWordingTypes"."id";


--
-- TOC entry 259 (class 1259 OID 48596)
-- Name: baytypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."baytypes" (
    "gid" integer NOT NULL,
    "Description" character varying(254),
    "Code" integer
);


ALTER TABLE "public"."baytypes" OWNER TO "postgres";

--
-- TOC entry 260 (class 1259 OID 48599)
-- Name: baytypes_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."baytypes_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."baytypes_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4095 (class 0 OID 0)
-- Dependencies: 260
-- Name: baytypes_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."baytypes_gid_seq" OWNED BY "public"."baytypes"."gid";


--
-- TOC entry 261 (class 1259 OID 48601)
-- Name: controlledparkingzones_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."controlledparkingzones_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."controlledparkingzones_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4097 (class 0 OID 0)
-- Dependencies: 261
-- Name: controlledparkingzones_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."controlledparkingzones_gid_seq" OWNED BY "public"."ControlledParkingZones"."gid";


--
-- TOC entry 262 (class 1259 OID 48603)
-- Name: corners_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."corners_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."corners_seq" OWNER TO "postgres";

--
-- TOC entry 263 (class 1259 OID 48605)
-- Name: issueid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."issueid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."issueid_seq" OWNER TO "postgres";

--
-- TOC entry 264 (class 1259 OID 48607)
-- Name: layer_styles; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE "public"."layer_styles" (
    "id" integer NOT NULL,
    "f_table_catalog" character varying,
    "f_table_schema" character varying,
    "f_table_name" character varying,
    "f_geometry_column" character varying,
    "stylename" character varying(30),
    "styleqml" "xml",
    "stylesld" "xml",
    "useasdefault" boolean,
    "description" "text",
    "owner" character varying(30),
    "ui" "xml",
    "update_time" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."layer_styles" OWNER TO "edi_operator";

--
-- TOC entry 265 (class 1259 OID 48614)
-- Name: layer_styles_id_seq; Type: SEQUENCE; Schema: public; Owner: edi_operator
--

CREATE SEQUENCE "public"."layer_styles_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."layer_styles_id_seq" OWNER TO "edi_operator";

--
-- TOC entry 4102 (class 0 OID 0)
-- Dependencies: 265
-- Name: layer_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: edi_operator
--

ALTER SEQUENCE "public"."layer_styles_id_seq" OWNED BY "public"."layer_styles"."id";


--
-- TOC entry 266 (class 1259 OID 48616)
-- Name: linetypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."linetypes" (
    "gid" integer NOT NULL,
    "Description" character varying(254),
    "Code" integer
);


ALTER TABLE "public"."linetypes" OWNER TO "postgres";

--
-- TOC entry 267 (class 1259 OID 48619)
-- Name: linetypes2_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."linetypes2_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."linetypes2_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4105 (class 0 OID 0)
-- Dependencies: 267
-- Name: linetypes2_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."linetypes2_gid_seq" OWNED BY "public"."linetypes"."gid";


--
-- TOC entry 268 (class 1259 OID 48621)
-- Name: pta_ref; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."pta_ref"
    START WITH 101
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."pta_ref" OWNER TO "postgres";

--
-- TOC entry 269 (class 1259 OID 48623)
-- Name: serial; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."serial"
    START WITH 101
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."serial" OWNER TO "postgres";

--
-- TOC entry 270 (class 1259 OID 48625)
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."signAttachmentTypes2_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."signAttachmentTypes2_id_seq" OWNER TO "postgres";

--
-- TOC entry 4109 (class 0 OID 0)
-- Dependencies: 270
-- Name: signAttachmentTypes2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."signAttachmentTypes2_id_seq" OWNED BY "public"."SignAttachmentTypes"."id";

--
-- TOC entry 3718 (class 2604 OID 48635)
-- Name: ActionOnProposalAcceptanceTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ActionOnProposalAcceptanceTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."ActionOnProposalAcceptanceTypes_id_seq"'::"regclass");


--
-- TOC entry 3719 (class 2604 OID 48636)
-- Name: BayLinesFadedTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."BayLinesFadedTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."BayLinesFadedTypes_id_seq"'::"regclass");


--
-- TOC entry 3721 (class 2604 OID 48637)
-- Name: BaysLines_SignIssueTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."BaysLines_SignIssueTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."BaysLines_SignIssueTypes_id_seq"'::"regclass");


--
-- TOC entry 3722 (class 2604 OID 48638)
-- Name: ControlledParkingZones gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ControlledParkingZones" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."controlledparkingzones_gid_seq"'::"regclass");


--
-- TOC entry 3724 (class 2604 OID 48639)
-- Name: LengthOfTime id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."LengthOfTime" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."LengthOfTime_id_seq"'::"regclass");


--
-- TOC entry 3727 (class 2604 OID 48641)
-- Name: PaymentTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."PaymentTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."PaymentTypes_id_seq"'::"regclass");


--
-- TOC entry 3728 (class 2604 OID 48642)
-- Name: ProposalStatusTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ProposalStatusTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."ProposalStatusTypes_id_seq"'::"regclass");


--
-- TOC entry 3730 (class 2604 OID 48643)
-- Name: RestrictionLayers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionLayers" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."RestrictionLayers2_id_seq"'::"regclass");


--
-- TOC entry 3729 (class 2604 OID 48644)
-- Name: RestrictionShapeTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionShapeTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."RestrictionGeometryTypes_id_seq"'::"regclass");


--
-- TOC entry 3733 (class 2604 OID 48645)
-- Name: RestrictionStatus id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionStatus" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."RestrictionStatus_id_seq"'::"regclass");


--
-- TOC entry 3734 (class 2604 OID 48646)
-- Name: RestrictionTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."RestrictionTypes_id_seq"'::"regclass");


--
-- TOC entry 3735 (class 2604 OID 48647)
-- Name: SignAttachmentTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignAttachmentTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."signAttachmentTypes2_id_seq"'::"regclass");


--
-- TOC entry 3736 (class 2604 OID 48648)
-- Name: SignFadedTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignFadedTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."SignFadedTypes_id_seq"'::"regclass");


--
-- TOC entry 3737 (class 2604 OID 48649)
-- Name: SignMountTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignMountTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."SignMounts_id_seq"'::"regclass");


--
-- TOC entry 3738 (class 2604 OID 48650)
-- Name: SignObscurredTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignObscurredTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."SignObscurredTypes_id_seq"'::"regclass");


--
-- TOC entry 3739 (class 2604 OID 48651)
-- Name: SignTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignTypes2" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."SignTypes2_id_seq"'::"regclass");


--
-- TOC entry 3723 (class 2604 OID 48652)
-- Name: Signs GeometryID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Signs" ALTER COLUMN "GeometryID" SET DEFAULT ('S_'::"text" || "to_char"("nextval"('"public"."Signs_id_seq"'::"regclass"), 'FM0000000'::"text"));


--
-- TOC entry 3740 (class 2604 OID 48653)
-- Name: Surveyors Code; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Surveyors" ALTER COLUMN "Code" SET DEFAULT "nextval"('"public"."Surveyors_Code_seq"'::"regclass");


--
-- TOC entry 3741 (class 2604 OID 48654)
-- Name: TicketMachineIssueTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TicketMachineIssueTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."TicketMachineIssueTypes_id_seq"'::"regclass");


--
-- TOC entry 3743 (class 2604 OID 48655)
-- Name: baysWordingTypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."baysWordingTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."baysWordingTypes_id_seq"'::"regclass");


--
-- TOC entry 3744 (class 2604 OID 48656)
-- Name: baytypes gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."baytypes" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."baytypes_gid_seq"'::"regclass");


--
-- TOC entry 3746 (class 2604 OID 48657)
-- Name: layer_styles id; Type: DEFAULT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."layer_styles" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."layer_styles_id_seq"'::"regclass");


--
-- TOC entry 3747 (class 2604 OID 48658)
-- Name: linetypes gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."linetypes" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."linetypes2_gid_seq"'::"regclass");

--
-- TOC entry 3754 (class 2606 OID 48895)
-- Name: BayLinesFadedTypes BayLinesFadedTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."BayLinesFadedTypes"
    ADD CONSTRAINT "BayLinesFadedTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3759 (class 2606 OID 48897)
-- Name: BaysLines_SignIssueTypes BaysLines_SignIssueTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."BaysLines_SignIssueTypes"
    ADD CONSTRAINT "BaysLines_SignIssueTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3778 (class 2606 OID 48907)
-- Name: LengthOfTime LengthOfTime_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."LengthOfTime"
    ADD CONSTRAINT "LengthOfTime_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3784 (class 2606 OID 48911)
-- Name: MapGrid MapGrid_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."MapGrid"
    ADD CONSTRAINT "MapGrid_pkey" PRIMARY KEY ("id");

--
-- TOC entry 3790 (class 2606 OID 48915)
-- Name: PaymentTypes PaymentTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."PaymentTypes"
    ADD CONSTRAINT "PaymentTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3804 (class 2606 OID 48931)
-- Name: RestrictionPolygonTypes RestrictionPolygonTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionPolygonTypes"
    ADD CONSTRAINT "RestrictionPolygonTypes_pkey" PRIMARY KEY ("id");

--
-- TOC entry 3813 (class 2606 OID 48937)
-- Name: RestrictionTypes RestrictionTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionTypes"
    ADD CONSTRAINT "RestrictionTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3822 (class 2606 OID 48943)
-- Name: SignFadedTypes SignFadedTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignFadedTypes"
    ADD CONSTRAINT "SignFadedTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3824 (class 2606 OID 48945)
-- Name: SignMountTypes SignMounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignMountTypes"
    ADD CONSTRAINT "SignMounts_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3826 (class 2606 OID 48947)
-- Name: SignObscurredTypes SignObscurredTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignObscurredTypes"
    ADD CONSTRAINT "SignObscurredTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3828 (class 2606 OID 48949)
-- Name: SignTypes SignTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignTypes2"
    ADD CONSTRAINT "SignTypes2_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3832 (class 2606 OID 48955)
-- Name: TicketMachineIssueTypes TicketMachineIssueTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TicketMachineIssueTypes"
    ADD CONSTRAINT "TicketMachineIssueTypes_pkey" PRIMARY KEY ("id");

--
-- TOC entry 3859 (class 2606 OID 101452)
-- Name: TimePeriods TimePeriods_Code_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_Code_key1" UNIQUE ("Code");

--
-- TOC entry 3838 (class 2606 OID 48961)
-- Name: baysWordingTypes baysWordingTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."baysWordingTypes"
    ADD CONSTRAINT "baysWordingTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3840 (class 2606 OID 48963)
-- Name: baytypes baytypes_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."baytypes"
    ADD CONSTRAINT "baytypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 3842 (class 2606 OID 48965)
-- Name: baytypes baytypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."baytypes"
    ADD CONSTRAINT "baytypes_pkey" PRIMARY KEY ("gid");

--
-- TOC entry 3844 (class 2606 OID 48969)
-- Name: layer_styles layer_styles_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."layer_styles"
    ADD CONSTRAINT "layer_styles_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3846 (class 2606 OID 48971)
-- Name: linetypes linetypes2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."linetypes"
    ADD CONSTRAINT "linetypes2_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3848 (class 2606 OID 48973)
-- Name: linetypes linetypes_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."linetypes"
    ADD CONSTRAINT "linetypes_Code_key" UNIQUE ("Code");

--
-- TOC entry 3820 (class 2606 OID 48977)
-- Name: SignAttachmentTypes signAttachmentTypes2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignAttachmentTypes"
    ADD CONSTRAINT "signAttachmentTypes2_pkey" PRIMARY KEY ("id");

--
-- TOC entry 3779 (class 1259 OID 48980)
-- Name: Lines_EDI_180124_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Lines_EDI_180124_idx" ON "public"."Lines" USING "gist" ("geom");


--
-- TOC entry 3763 (class 1259 OID 48981)
-- Name: controlledparkingzones_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "controlledparkingzones_geom_idx" ON "public"."ControlledParkingZones" USING "gist" ("geom");


--
-- TOC entry 3757 (class 1259 OID 48982)
-- Name: sidx_Bays_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_Bays_geom" ON "public"."Bays" USING "gist" ("geom");


--
-- TOC entry 3762 (class 1259 OID 48983)
-- Name: sidx_CPZs_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_ControlledParkingZones_geom" ON "public"."ControlledParkingZones" USING "gist" ("geom");


--
-- TOC entry 3770 (class 1259 OID 48984)
-- Name: sidx_EDI01_Signs_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_EDI01_Signs_geom" ON "public"."Signs" USING "gist" ("geom");

--
-- TOC entry 3782 (class 1259 OID 48987)
-- Name: sidx_Lines_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_Lines_geom" ON "public"."Lines" USING "gist" ("geom");


--
-- TOC entry 3785 (class 1259 OID 48988)
-- Name: sidx_MapGrid_geom; Type: INDEX; Schema: public; Owner: edi_operator
--

CREATE INDEX "sidx_MapGrid_geom" ON "public"."MapGrid" USING "gist" ("geom");


--
-- TOC entry 3788 (class 1259 OID 48989)
-- Name: sidx_PTAs_180725_merged_10_geom; Type: INDEX; Schema: public; Owner: edi_operator
--

CREATE INDEX "sidx_PTAs_180725_merged_10_geom" ON "public"."ParkingTariffAreas" USING "gist" ("geom");

-- Add extra details to RestrictionShapeTypes

INSERT INTO "public"."RestrictionShapeTypes" ("Code", "Description") VALUES (22, 'Half on/Half off Bay (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("Code", "Description") VALUES (23, 'On Pavement Bay (Polygon)');
INSERT INTO "public"."RestrictionShapeTypes" ("Code", "Description") VALUES (35, 'Dropped Kerb (Crossover)');
INSERT INTO "public"."RestrictionShapeTypes" ("Code", "Description") VALUES (50, 'Polygon');

--
-- TOC entry 3864 (class 2606 OID 48993)
-- Name: Bays Bays_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Bays"
    ADD CONSTRAINT "Bays_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "public"."RestrictionShapeTypes"("Code");


--
-- TOC entry 3865 (class 2606 OID 49003)
-- Name: Bays Bays_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Bays"
    ADD CONSTRAINT "Bays_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "public"."BayLineTypesInUse"("Code");


--
-- TOC entry 3866 (class 2606 OID 101453)
-- Name: Bays Bays_TimePeriodID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Bays"
    ADD CONSTRAINT "Bays_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID") REFERENCES "public"."TimePeriods"("Code");


--
-- TOC entry 3867 (class 2606 OID 49013)
-- Name: Lines Lines_GeomShapeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Lines"
    ADD CONSTRAINT "Lines_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "public"."RestrictionShapeTypes"("Code");


--
-- TOC entry 3869 (class 2606 OID 101458)
-- Name: Lines Lines_NoWaitingTimeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Lines"
    ADD CONSTRAINT "Lines_NoWaitingTimeID_fkey" FOREIGN KEY ("NoWaitingTimeID") REFERENCES "public"."TimePeriods"("Code");


--
-- TOC entry 3868 (class 2606 OID 49023)
-- Name: Lines Lines_RestrictionTypeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Lines"
    ADD CONSTRAINT "Lines_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "public"."BayLineTypesInUse"("Code");

