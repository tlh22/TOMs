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

--
-- TOC entry 200 (class 1259 OID 48347)
-- Name: ActionOnProposalAcceptanceTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."ActionOnProposalAcceptanceTypes" (
    "id" integer NOT NULL,
    "Description" character varying
);


ALTER TABLE "public"."ActionOnProposalAcceptanceTypes" OWNER TO "postgres";

--
-- TOC entry 201 (class 1259 OID 48353)
-- Name: ActionOnProposalAcceptanceTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."ActionOnProposalAcceptanceTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."ActionOnProposalAcceptanceTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4013 (class 0 OID 0)
-- Dependencies: 201
-- Name: ActionOnProposalAcceptanceTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."ActionOnProposalAcceptanceTypes_id_seq" OWNED BY "public"."ActionOnProposalAcceptanceTypes"."id";


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
-- TOC entry 204 (class 1259 OID 48363)
-- Name: Bays2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."Bays2_id_seq"
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."Bays2_id_seq" OWNER TO "postgres";

--
-- TOC entry 205 (class 1259 OID 48365)
-- Name: Bays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."Bays" (
    "id" integer,
    "geom" "public"."geometry"(LineString,27700) NOT NULL,
    "Length" double precision,
    "RestrictionTypeID" integer,
    "NrBays" integer,
    "TimePeriodID" integer,
    "PayTypeID" integer,
    "MaxStayID" integer,
    "NoReturnID" integer,
    "Notes" character varying(254),
    "GeometryID" character varying(10) DEFAULT ('B_'::"text" || "to_char"("nextval"('"public"."Bays2_id_seq"'::"regclass"), 'FM0000000'::"text")) NOT NULL,
    "Bays_DateTime" timestamp without time zone,
    "BaysWordingID" integer,
    "Surveyor" character varying(50),
    "BaysGeometry" integer,
    "Bays_PhotoTaken" integer,
    "Compl_Bays_Faded" integer,
    "Compl_Bays_SignIssue" integer,
    "Bays_Photos_01" character varying(255),
    "Bays_Photos_02" character varying(255),
    "GeomShapeID" integer,
    "RoadName" character varying(254),
    "USRN" character varying(254),
    "AzimuthToRoadCentreLine" double precision,
    "label_X" double precision,
    "label_Y" double precision,
    "label_Rotation" double precision,
    "label_TextChanged" character varying(254),
    "BayOrientation" double precision,
    "OpenDate" "date",
    "CloseDate" "date",
    "CPZ" character varying(40),
    "ParkingTariffArea" character varying(10),
    "OriginalGeomShapeID" integer,
    "GeometryID_181017" character varying(254),
    "RestrictionID" character varying(254) NOT NULL
);


ALTER TABLE "public"."Bays" OWNER TO "postgres";

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
-- TOC entry 209 (class 1259 OID 48382)
-- Name: CPZs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."CPZs" (
    "gid" integer NOT NULL,
    "geom" "public"."geometry"(MultiPolygon,27700),
    "cacz_ref_n" character varying(2),
    "date_last_" character varying(10),
    "no_osp_spa" double precision,
    "no_pnr_spa" double precision,
    "no_pub_spa" double precision,
    "no_res_spa" double precision,
    "zone_no" character varying(40),
    "type" character varying(40),
    "WaitingTimeID" integer
);


ALTER TABLE "public"."CPZs" OWNER TO "postgres";

--
-- TOC entry 210 (class 1259 OID 48388)
-- Name: ControlledParkingZones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."ControlledParkingZones" (
    "gid" integer NOT NULL,
    "cacz_ref_n" character varying(6),
    "date_last_" character varying(10),
    "no_osp_spa" numeric(10,0),
    "no_pnr_spa" numeric(10,0),
    "no_pub_spa" numeric(10,0),
    "no_res_spa" numeric(10,0),
    "zone_no" character varying(40),
    "type" character varying(40),
    "geom" "public"."geometry"(Polygon,27700),
    "WaitingTimeID" integer,
    "CPZ" character varying(6),
    "OpenDate" "date",
    "CloseDate" "date",
    "RestrictionID" character varying(254),
    "GeometryID" character varying(15)
);


ALTER TABLE "public"."ControlledParkingZones" OWNER TO "postgres";

--
-- TOC entry 211 (class 1259 OID 48394)
-- Name: Signs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."Signs" (
    "id" integer,
    "geom" "public"."geometry"(Point,27700),
    "Signs_Notes" character varying(255),
    "Signs_Photos_01" character varying(255),
    "GeometryID" character varying(100) NOT NULL,
    "SignType_1" integer,
    "SignType_2" integer,
    "SignType_3" integer,
    "Signs_DateTime" timestamp without time zone,
    "PhotoTaken" integer,
    "Signs_Photos_02" character varying(255),
    "Signs_Mount" integer,
    "Surveyor" character varying(50),
    "TicketMachine_Nr" character varying(10),
    "Signs_Attachment" integer,
    "Compl_Signs_Faded" integer,
    "Compl_Signs_Obscured" integer,
    "Compl_Signs_Direction" integer,
    "Compl_Signs_Obsolete" integer,
    "Compl_Signs_OtherOptions" integer,
    "Compl_Signs_TicketMachines" integer,
    "RoadName" character varying(254),
    "USRN" character varying(254),
    "RingoPresent" integer,
    "OpenDate" "date",
    "CloseDate" "date",
    "Signs_Photos_03" character varying(255),
    "GeometryID_181017" character varying(12),
    "RestrictionID" character varying(254) NOT NULL,
    "CPZ" character varying(40),
    "ParkingTariffArea" character varying(10)
);


ALTER TABLE "public"."Signs" OWNER TO "postgres";

--
-- TOC entry 212 (class 1259 OID 48400)
-- Name: EDI01_Signs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."EDI01_Signs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."EDI01_Signs_id_seq" OWNER TO "postgres";

--
-- TOC entry 4027 (class 0 OID 0)
-- Dependencies: 212
-- Name: EDI01_Signs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."EDI01_Signs_id_seq" OWNED BY "public"."Signs"."id";


--
-- TOC entry 213 (class 1259 OID 48402)
-- Name: EDI_RoadCasement_Polyline; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE "public"."EDI_RoadCasement_Polyline" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(LineString,27700),
    "OBJECTID_1" integer,
    "MidPt_ID" integer,
    "ESUID" double precision,
    "USRN" integer,
    "StreetName" character varying(254),
    "Locality" character varying(255),
    "Town" character varying(255),
    "Shape_Length" double precision
);


ALTER TABLE "public"."EDI_RoadCasement_Polyline" OWNER TO "edi_operator";

--
-- TOC entry 214 (class 1259 OID 48408)
-- Name: EDI_Sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."EDI_Sections" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(Polygon,27700),
    "objectid_1" bigint,
    "objectid" bigint,
    "name" character varying(100),
    "shape_leng" double precision,
    "newname" character varying(100),
    "area" integer,
    "comment" character varying(254),
    "shape_le_1" double precision,
    "shape_area" double precision
);


ALTER TABLE "public"."EDI_Sections" OWNER TO "postgres";

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
-- TOC entry 217 (class 1259 OID 48422)
-- Name: Lines2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."Lines2_id_seq"
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."Lines2_id_seq" OWNER TO "postgres";

--
-- TOC entry 218 (class 1259 OID 48424)
-- Name: Lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."Lines" (
    "id" integer,
    "geom" "public"."geometry"(LineString,27700) NOT NULL,
    "Length" double precision,
    "RestrictionTypeID" integer,
    "NoWaitingTimeID" integer,
    "NoLoadingTimeID" integer,
    "Notes" character varying(254),
    "GeometryID" character varying(20) DEFAULT ('L_'::"text" || "to_char"("nextval"('"public"."Lines2_id_seq"'::"regclass"), 'FM0000000'::"text")) NOT NULL,
    "Lines_DateTime" timestamp without time zone,
    "Surveyor" character varying(100),
    "Lines_PhotoTaken" integer,
    "Lines_Photos_01" character varying(255),
    "Compl_Lines_Faded" integer,
    "Compl_NoL_Faded" integer,
    "Lines_Photos_02" character varying(255),
    "Compl_Lines_SignIssue" integer,
    "RoadName" character varying(254),
    "USRN" character varying(254),
    "AzimuthToRoadCentreLine" double precision,
    "GeomShapeID" integer,
    "labelX" double precision,
    "labelY" double precision,
    "labelRotation" double precision,
    "Lines_Photos_03" character varying(255),
    "Unacceptability" integer,
    "OpenDate" "date",
    "CloseDate" "date",
    "CPZ" character varying(40),
    "ParkingTariffArea" character varying(10),
    "labelLoadingX" double precision,
    "labelLoadingY" double precision,
    "labelLoadingRotation" double precision,
    "TRO_Status_180409" integer,
    "GeometryID_181017" character varying(254),
    "RestrictionID" character varying(254) NOT NULL
);


ALTER TABLE "public"."Lines" OWNER TO "postgres";

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
-- TOC entry 220 (class 1259 OID 48437)
-- Name: ParkingTariffAreas; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE "public"."ParkingTariffAreas" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(Polygon,27700),
    "gid" integer,
    "fid_parkin" integer,
    "tro_ref" numeric,
    "charge" character varying(255),
    "cost" character varying(255),
    "hours" character varying(255),
    "Name" character varying(255),
    "NoReturnTimeID" integer,
    "MaxStayID" integer,
    "TimePeriodID" integer,
    "OBJECTID" integer,
    "name_orig" character varying(255),
    "Shape_Leng" numeric,
    "Shape_Area" numeric,
    "OpenDate" "date",
    "CloseDate" "date",
    "RestrictionID" character varying(254),
    "GeometryID" character varying(15)
);


ALTER TABLE "public"."ParkingTariffAreas" OWNER TO "edi_operator";

--
-- TOC entry 221 (class 1259 OID 48443)
-- Name: PTAs_180725_merged_10_id_seq; Type: SEQUENCE; Schema: public; Owner: edi_operator
--

CREATE SEQUENCE "public"."PTAs_180725_merged_10_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."PTAs_180725_merged_10_id_seq" OWNER TO "edi_operator";

--
-- TOC entry 4038 (class 0 OID 0)
-- Dependencies: 221
-- Name: PTAs_180725_merged_10_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: edi_operator
--

ALTER SEQUENCE "public"."PTAs_180725_merged_10_id_seq" OWNED BY "public"."ParkingTariffAreas"."id";


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
-- TOC entry 224 (class 1259 OID 48453)
-- Name: ProposalStatusTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."ProposalStatusTypes" (
    "id" integer NOT NULL,
    "Description" character varying,
    "Code" integer
);


ALTER TABLE "public"."ProposalStatusTypes" OWNER TO "postgres";

--
-- TOC entry 225 (class 1259 OID 48459)
-- Name: ProposalStatusTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."ProposalStatusTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."ProposalStatusTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4044 (class 0 OID 0)
-- Dependencies: 225
-- Name: ProposalStatusTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."ProposalStatusTypes_id_seq" OWNED BY "public"."ProposalStatusTypes"."id";


--
-- TOC entry 226 (class 1259 OID 48461)
-- Name: Proposals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."Proposals_id_seq"
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."Proposals_id_seq" OWNER TO "postgres";

--
-- TOC entry 274 (class 1259 OID 52920)
-- Name: Proposals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."Proposals" (
    "ProposalID" integer DEFAULT "nextval"('"public"."Proposals_id_seq"'::"regclass") NOT NULL,
    "ProposalStatusID" integer,
    "ProposalCreateDate" "date",
    "ProposalNotes" character varying,
    "ProposalTitle" character varying(255) NOT NULL,
    "ProposalOpenDate" "date"
);


ALTER TABLE "public"."Proposals" OWNER TO "postgres";

--
-- TOC entry 273 (class 1259 OID 50657)
-- Name: Proposals_withGeom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."Proposals_withGeom" (
    "ProposalID" integer,
    "ProposalStatusID" integer,
    "ProposalCreateDate" "date",
    "ProposalNotes" character varying,
    "ProposalTitle" character varying(255) NOT NULL,
    "ProposalOpenDate" "date"
);


ALTER TABLE "public"."Proposals_withGeom" OWNER TO "postgres";

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
-- TOC entry 239 (class 1259 OID 48517)
-- Name: RestrictionsInProposals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionsInProposals" (
    "ProposalID" integer NOT NULL,
    "RestrictionTableID" integer NOT NULL,
    "ActionOnProposalAcceptance" integer,
    "RestrictionID" character varying(255) NOT NULL
);


ALTER TABLE "public"."RestrictionsInProposals" OWNER TO "postgres";

--
-- TOC entry 255 (class 1259 OID 48579)
-- Name: TimePeriods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."TimePeriods_id_seq"
    START WITH 300
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."TimePeriods_id_seq" OWNER TO "postgres";

--
-- TOC entry 256 (class 1259 OID 48581)
-- Name: TimePeriods_orig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."TimePeriods_orig" (
    "id" integer DEFAULT "nextval"('"public"."TimePeriods_id_seq"'::"regclass") NOT NULL,
    "Code" integer,
    "Description" character varying,
    "LabelText" character varying(255)
);


ALTER TABLE "public"."TimePeriods_orig" OWNER TO "postgres";

--
-- TOC entry 276 (class 1259 OID 63436)
-- Name: Proposed Order Items; Type: VIEW; Schema: public; Owner: edi_admin
--

CREATE VIEW "public"."Proposed Order Items" AS
 SELECT "Proposals"."ProposalTitle" AS "order",
    "Bays"."GeometryID" AS "id",
    "Bays"."RoadName" AS "road",
    "RestrictionTypes"."Description" AS "restriction",
    "TimePeriods_orig"."Description" AS "times"
   FROM (((("public"."Bays"
     LEFT JOIN "public"."RestrictionsInProposals" ON ((("Bays"."RestrictionID")::"text" = ("RestrictionsInProposals"."RestrictionID")::"text")))
     LEFT JOIN "public"."Proposals" ON (("RestrictionsInProposals"."ProposalID" = "Proposals"."ProposalID")))
     LEFT JOIN "public"."RestrictionTypes" ON (("Bays"."RestrictionTypeID" = "RestrictionTypes"."id")))
     LEFT JOIN "public"."TimePeriods_orig" ON (("Bays"."TimePeriodID" = "TimePeriods_orig"."Code")))
  WHERE (("Bays"."RestrictionTypeID" = ANY (ARRAY[228, 231, 240, 33, 34, 35, 233, 234, 235, 4, 204, 6, 206, 29, 25, 9, 10, 209, 210, 28, 31, 40])) AND ("Bays"."OpenDate" IS NULL) AND (("Proposals"."ProposalTitle")::"text" = 'TRO-18-79'::"text"))
UNION
 SELECT "Proposals"."ProposalTitle" AS "order",
    "Lines"."GeometryID" AS "id",
    "Lines"."RoadName" AS "road",
    "RestrictionTypes"."Description" AS "restriction",
    "TimePeriods_orig"."Description" AS "times"
   FROM (((("public"."Lines"
     LEFT JOIN "public"."RestrictionTypes" ON (("Lines"."RestrictionTypeID" = "RestrictionTypes"."id")))
     LEFT JOIN "public"."RestrictionsInProposals" ON ((("Lines"."RestrictionID")::"text" = ("RestrictionsInProposals"."RestrictionID")::"text")))
     LEFT JOIN "public"."Proposals" ON (("RestrictionsInProposals"."ProposalID" = "Proposals"."ProposalID")))
     LEFT JOIN "public"."TimePeriods_orig" ON (("Lines"."NoWaitingTimeID" = "TimePeriods_orig"."Code")))
  WHERE (("Lines"."RestrictionTypeID" = ANY (ARRAY[228, 231, 240, 33, 34, 35, 233, 234, 235, 4, 204, 6, 206, 29, 25, 9, 10, 209, 210, 28, 31, 40])) AND ("Lines"."OpenDate" IS NULL) AND (("Proposals"."ProposalTitle")::"text" = 'TRO-18-79'::"text"));


ALTER TABLE "public"."Proposed Order Items" OWNER TO "edi_admin";

--
-- TOC entry 277 (class 1259 OID 63446)
-- Name: Proposed Order Restrictions List; Type: VIEW; Schema: public; Owner: edi_admin
--

CREATE VIEW "public"."Proposed Order Restrictions List" AS
 SELECT "Proposals"."ProposalTitle" AS "order",
    "Bays"."GeometryID" AS "id",
    "Bays"."RoadName" AS "road",
    "RestrictionTypes"."Description" AS "restriction",
    "TimePeriods_orig"."Description" AS "times",
    "Bays"."geom"
   FROM (((("public"."Bays"
     LEFT JOIN "public"."RestrictionsInProposals" ON ((("Bays"."RestrictionID")::"text" = ("RestrictionsInProposals"."RestrictionID")::"text")))
     LEFT JOIN "public"."Proposals" ON (("RestrictionsInProposals"."ProposalID" = "Proposals"."ProposalID")))
     LEFT JOIN "public"."RestrictionTypes" ON (("Bays"."RestrictionTypeID" = "RestrictionTypes"."id")))
     LEFT JOIN "public"."TimePeriods_orig" ON (("Bays"."TimePeriodID" = "TimePeriods_orig"."Code")))
  WHERE (("Bays"."RestrictionTypeID" = ANY (ARRAY[228, 231, 240, 33, 34, 35, 233, 234, 235, 4, 204, 6, 206, 29, 25, 9, 10, 209, 210, 28, 31, 40])) AND ("Bays"."OpenDate" IS NULL))
UNION
 SELECT "Proposals"."ProposalTitle" AS "order",
    "Lines"."GeometryID" AS "id",
    "Lines"."RoadName" AS "road",
    "RestrictionTypes"."Description" AS "restriction",
    "TimePeriods_orig"."Description" AS "times",
    "Lines"."geom"
   FROM (((("public"."Lines"
     LEFT JOIN "public"."RestrictionTypes" ON (("Lines"."RestrictionTypeID" = "RestrictionTypes"."id")))
     LEFT JOIN "public"."RestrictionsInProposals" ON ((("Lines"."RestrictionID")::"text" = ("RestrictionsInProposals"."RestrictionID")::"text")))
     LEFT JOIN "public"."Proposals" ON (("RestrictionsInProposals"."ProposalID" = "Proposals"."ProposalID")))
     LEFT JOIN "public"."TimePeriods_orig" ON (("Lines"."NoWaitingTimeID" = "TimePeriods_orig"."Code")))
  WHERE (("Lines"."RestrictionTypeID" = ANY (ARRAY[228, 231, 240, 33, 34, 35, 233, 234, 235, 4, 204, 6, 206, 29, 25, 9, 10, 209, 210, 28, 31, 40])) AND ("Lines"."OpenDate" IS NULL));


ALTER TABLE "public"."Proposed Order Restrictions List" OWNER TO "edi_admin";

--
-- TOC entry 227 (class 1259 OID 48470)
-- Name: RestrictionShapeTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionShapeTypes" (
    "id" integer NOT NULL,
    "Code" bigint,
    "Description" character varying
);


ALTER TABLE "public"."RestrictionShapeTypes" OWNER TO "postgres";

--
-- TOC entry 228 (class 1259 OID 48476)
-- Name: RestrictionGeometryTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RestrictionGeometryTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RestrictionGeometryTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4054 (class 0 OID 0)
-- Dependencies: 228
-- Name: RestrictionGeometryTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RestrictionGeometryTypes_id_seq" OWNED BY "public"."RestrictionShapeTypes"."id";


--
-- TOC entry 229 (class 1259 OID 48478)
-- Name: RestrictionLayers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionLayers" (
    "id" integer NOT NULL,
    "RestrictionLayerName" character varying(255) NOT NULL
);


ALTER TABLE "public"."RestrictionLayers" OWNER TO "postgres";

--
-- TOC entry 230 (class 1259 OID 48481)
-- Name: RestrictionLayers2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RestrictionLayers2_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RestrictionLayers2_id_seq" OWNER TO "postgres";

--
-- TOC entry 4057 (class 0 OID 0)
-- Dependencies: 230
-- Name: RestrictionLayers2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RestrictionLayers2_id_seq" OWNED BY "public"."RestrictionLayers"."id";


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
-- TOC entry 233 (class 1259 OID 48492)
-- Name: restrictionPolygons_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."restrictionPolygons_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."restrictionPolygons_seq" OWNER TO "postgres";

--
-- TOC entry 234 (class 1259 OID 48494)
-- Name: RestrictionPolygons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionPolygons" (
    "id" integer,
    "geom" "public"."geometry"(Polygon,27700) NOT NULL,
    "RestrictionTypeID" integer,
    "GeomShapeID" integer,
    "OpenDate" "date",
    "CloseDate" "date",
    "USRN" character varying(254),
    "Orientation" integer,
    "RoadName" character varying(254),
    "GeometryID" character varying(254) DEFAULT ('P_'::"text" || "to_char"("nextval"('"public"."restrictionPolygons_seq"'::"regclass"), 'FM0000000'::"text")) NOT NULL,
    "RestrictionID" character varying(254) NOT NULL,
    "NoWaitingTimeID" integer,
    "NoLoadingTimeID" integer,
    "Polygons_Photos_01" character varying(255),
    "Polygons_Photos_02" character varying(255),
    "Polygons_Photos_03" character varying(255),
    "LabelText" character varying(254),
    "TimePeriodID" integer,
    "AreaPermitCode" character varying(254),
    "CPZ" character varying(40),
    "labelX" double precision,
    "labelY" double precision,
    "labelRotation" double precision
);


ALTER TABLE "public"."RestrictionPolygons" OWNER TO "postgres";

--
-- TOC entry 235 (class 1259 OID 48501)
-- Name: RestrictionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."RestrictionStatus" (
    "id" integer NOT NULL,
    "PK_UID" bigint,
    "RestrictionStatusID" bigint,
    "Description" character varying
);


ALTER TABLE "public"."RestrictionStatus" OWNER TO "postgres";

--
-- TOC entry 236 (class 1259 OID 48507)
-- Name: RestrictionStatus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."RestrictionStatus_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."RestrictionStatus_id_seq" OWNER TO "postgres";

--
-- TOC entry 4064 (class 0 OID 0)
-- Dependencies: 236
-- Name: RestrictionStatus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."RestrictionStatus_id_seq" OWNED BY "public"."RestrictionStatus"."id";


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
-- TOC entry 240 (class 1259 OID 48520)
-- Name: RoadCentreLine; Type: TABLE; Schema: public; Owner: edi_operator
--

CREATE TABLE "public"."RoadCentreLine" (
    "gid" integer NOT NULL,
    "geom" "public"."geometry"(MultiLineString,27700),
    "toid" character varying(16),
    "version" double precision,
    "verdate" "date",
    "theme" character varying(80),
    "descgroup" character varying(150),
    "descterm" character varying(150),
    "change" character varying(80),
    "topoarea" character varying(20),
    "nature" character varying(80),
    "lnklength" double precision,
    "node1" character varying(20),
    "node1grade" character varying(1),
    "node1gra_1" double precision,
    "node2" character varying(20),
    "node2grade" character varying(1),
    "node2gra_1" double precision,
    "loaddate" "date",
    "objectid" double precision,
    "shape_leng" double precision
);


ALTER TABLE "public"."RoadCentreLine" OWNER TO "edi_operator";

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

CREATE TABLE "public"."SignTypes" (
    "id" integer NOT NULL,
    "Description" character varying,
    "Code" integer
);


ALTER TABLE "public"."SignTypes" OWNER TO "postgres";

--
-- TOC entry 249 (class 1259 OID 48562)
-- Name: SignTypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."SignTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."SignTypes_id_seq" OWNER TO "postgres";

--
-- TOC entry 4080 (class 0 OID 0)
-- Dependencies: 249
-- Name: SignTypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."SignTypes_id_seq" OWNED BY "public"."SignTypes"."id";


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
-- TOC entry 275 (class 1259 OID 58470)
-- Name: TilesInAcceptedProposals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."TilesInAcceptedProposals" (
    "ProposalID" integer NOT NULL,
    "TileNr" integer NOT NULL,
    "RevisionNr" integer NOT NULL
);


ALTER TABLE "public"."TilesInAcceptedProposals" OWNER TO "postgres";

--
-- TOC entry 278 (class 1259 OID 101432)
-- Name: TimePeriods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."TimePeriods" (
    "id" integer DEFAULT "nextval"('"public"."TimePeriods_id_seq"'::"regclass") NOT NULL,
    "Code" integer,
    "Description" character varying,
    "LabelText" character varying(255)
);


ALTER TABLE "public"."TimePeriods" OWNER TO "postgres";

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
-- TOC entry 271 (class 1259 OID 48627)
-- Name: signs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."signs" (
    "gid" integer NOT NULL,
    "objectid" numeric(10,0),
    "signs_note" character varying(254),
    "signs_phot" character varying(254),
    "signtype_1" integer,
    "signtype_2" integer,
    "signtype_3" integer,
    "signs_date" "date",
    "phototaken" integer,
    "signs_ph_1" character varying(254),
    "signs_moun" integer,
    "surveyor" character varying(50),
    "ticketmach" character varying(10),
    "signs_atta" integer,
    "compl_sign" integer,
    "compl_si_1" integer,
    "compl_si_2" integer,
    "compl_si_3" integer,
    "compl_si_4" integer,
    "compl_si_5" integer,
    "geom" "public"."geometry"(Point)
);


ALTER TABLE "public"."signs" OWNER TO "postgres";

--
-- TOC entry 272 (class 1259 OID 48633)
-- Name: signs_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."signs_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."signs_gid_seq" OWNER TO "postgres";

--
-- TOC entry 4112 (class 0 OID 0)
-- Dependencies: 272
-- Name: signs_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."signs_gid_seq" OWNED BY "public"."signs"."gid";


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
-- TOC entry 3726 (class 2604 OID 48640)
-- Name: ParkingTariffAreas id; Type: DEFAULT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."ParkingTariffAreas" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."PTAs_180725_merged_10_id_seq"'::"regclass");


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

ALTER TABLE ONLY "public"."SignTypes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."SignTypes_id_seq"'::"regclass");


--
-- TOC entry 3723 (class 2604 OID 48652)
-- Name: Signs GeometryID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Signs" ALTER COLUMN "GeometryID" SET DEFAULT ('S_'::"text" || "to_char"("nextval"('"public"."EDI01_Signs_id_seq"'::"regclass"), 'FM0000000'::"text"));


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
-- TOC entry 3748 (class 2604 OID 48659)
-- Name: signs gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."signs" ALTER COLUMN "gid" SET DEFAULT "nextval"('"public"."signs_gid_seq"'::"regclass");


--
-- TOC entry 3752 (class 2606 OID 48893)
-- Name: ActionOnProposalAcceptanceTypes ActionOnProposalAcceptanceTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ActionOnProposalAcceptanceTypes"
    ADD CONSTRAINT "ActionOnProposalAcceptanceTypes_pkey" PRIMARY KEY ("id");


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
-- TOC entry 3756 (class 2606 OID 48899)
-- Name: Bays Bays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Bays"
    ADD CONSTRAINT "Bays_pkey" PRIMARY KEY ("GeometryID");


--
-- TOC entry 3761 (class 2606 OID 48901)
-- Name: CPZs CPZs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."CPZs"
    ADD CONSTRAINT "CPZs_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3772 (class 2606 OID 48903)
-- Name: EDI_RoadCasement_Polyline EDI_RoadCasement_Polyline_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."EDI_RoadCasement_Polyline"
    ADD CONSTRAINT "EDI_RoadCasement_Polyline_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3775 (class 2606 OID 48905)
-- Name: EDI_Sections EDI_Sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."EDI_Sections"
    ADD CONSTRAINT "EDI_Sections_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3778 (class 2606 OID 48907)
-- Name: LengthOfTime LengthOfTime_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."LengthOfTime"
    ADD CONSTRAINT "LengthOfTime_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3781 (class 2606 OID 48909)
-- Name: Lines Lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Lines"
    ADD CONSTRAINT "Lines_pkey" PRIMARY KEY ("GeometryID");


--
-- TOC entry 3784 (class 2606 OID 48911)
-- Name: MapGrid MapGrid_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."MapGrid"
    ADD CONSTRAINT "MapGrid_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3787 (class 2606 OID 48913)
-- Name: ParkingTariffAreas PTAs_180725_merged_10_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."ParkingTariffAreas"
    ADD CONSTRAINT "PTAs_180725_merged_10_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3790 (class 2606 OID 48915)
-- Name: PaymentTypes PaymentTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."PaymentTypes"
    ADD CONSTRAINT "PaymentTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3792 (class 2606 OID 48917)
-- Name: ProposalStatusTypes ProposalStatusTypes_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ProposalStatusTypes"
    ADD CONSTRAINT "ProposalStatusTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 3794 (class 2606 OID 48919)
-- Name: ProposalStatusTypes ProposalStatusTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ProposalStatusTypes"
    ADD CONSTRAINT "ProposalStatusTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3853 (class 2606 OID 52928)
-- Name: Proposals Proposals_PK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Proposals"
    ADD CONSTRAINT "Proposals_PK" PRIMARY KEY ("ProposalID");


--
-- TOC entry 3855 (class 2606 OID 52930)
-- Name: Proposals Proposals_ProposalTitle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Proposals"
    ADD CONSTRAINT "Proposals_ProposalTitle_key" UNIQUE ("ProposalTitle");


--
-- TOC entry 3796 (class 2606 OID 48925)
-- Name: RestrictionShapeTypes RestrictionGeometryTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionShapeTypes"
    ADD CONSTRAINT "RestrictionGeometryTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3800 (class 2606 OID 48927)
-- Name: RestrictionLayers RestrictionLayers2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers2_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3802 (class 2606 OID 48929)
-- Name: RestrictionLayers RestrictionLayers_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers_id_key" UNIQUE ("id");


--
-- TOC entry 3804 (class 2606 OID 48931)
-- Name: RestrictionPolygonTypes RestrictionPolygonTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionPolygonTypes"
    ADD CONSTRAINT "RestrictionPolygonTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3806 (class 2606 OID 101524)
-- Name: RestrictionPolygons RestrictionPolygons_RestrictionID_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionPolygons_RestrictionID_key" UNIQUE ("RestrictionID");


--
-- TOC entry 3798 (class 2606 OID 48933)
-- Name: RestrictionShapeTypes RestrictionShapeTypes_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionShapeTypes"
    ADD CONSTRAINT "RestrictionShapeTypes_Code_key" UNIQUE ("Code");


--
-- TOC entry 3811 (class 2606 OID 48935)
-- Name: RestrictionStatus RestrictionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionStatus"
    ADD CONSTRAINT "RestrictionStatus_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3813 (class 2606 OID 48937)
-- Name: RestrictionTypes RestrictionTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionTypes"
    ADD CONSTRAINT "RestrictionTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3815 (class 2606 OID 48939)
-- Name: RestrictionsInProposals RestrictionsInProposals_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_pk" PRIMARY KEY ("ProposalID", "RestrictionTableID", "RestrictionID");


--
-- TOC entry 3817 (class 2606 OID 48941)
-- Name: RoadCentreLine RoadCentreLine_pkey; Type: CONSTRAINT; Schema: public; Owner: edi_operator
--

ALTER TABLE ONLY "public"."RoadCentreLine"
    ADD CONSTRAINT "RoadCentreLine_pkey" PRIMARY KEY ("gid");


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

ALTER TABLE ONLY "public"."SignTypes"
    ADD CONSTRAINT "SignTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3767 (class 2606 OID 101528)
-- Name: Signs Signs_RestrictionID_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Signs"
    ADD CONSTRAINT "Signs_RestrictionID_key" UNIQUE ("RestrictionID");


--
-- TOC entry 3769 (class 2606 OID 48951)
-- Name: Signs Signs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Signs"
    ADD CONSTRAINT "Signs_pkey" PRIMARY KEY ("GeometryID");


--
-- TOC entry 3830 (class 2606 OID 48953)
-- Name: Surveyors Surveyors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Surveyors"
    ADD CONSTRAINT "Surveyors_pkey" PRIMARY KEY ("Code");


--
-- TOC entry 3832 (class 2606 OID 48955)
-- Name: TicketMachineIssueTypes TicketMachineIssueTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TicketMachineIssueTypes"
    ADD CONSTRAINT "TicketMachineIssueTypes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3857 (class 2606 OID 58474)
-- Name: TilesInAcceptedProposals TilesInAcceptedProposals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_pkey" PRIMARY KEY ("ProposalID", "TileNr", "RevisionNr");


--
-- TOC entry 3834 (class 2606 OID 48957)
-- Name: TimePeriods_orig TimePeriods_180124_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TimePeriods_orig"
    ADD CONSTRAINT "TimePeriods_180124_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3836 (class 2606 OID 48959)
-- Name: TimePeriods_orig TimePeriods_Code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TimePeriods_orig"
    ADD CONSTRAINT "TimePeriods_Code_key" UNIQUE ("Code");


--
-- TOC entry 3859 (class 2606 OID 101452)
-- Name: TimePeriods TimePeriods_Code_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_Code_key1" UNIQUE ("Code");


--
-- TOC entry 3861 (class 2606 OID 101442)
-- Name: TimePeriods TimePeriods_Description_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_Description_key" UNIQUE ("Description");


--
-- TOC entry 3863 (class 2606 OID 101440)
-- Name: TimePeriods TimePeriods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."TimePeriods"
    ADD CONSTRAINT "TimePeriods_pkey" PRIMARY KEY ("id");


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
-- TOC entry 3765 (class 2606 OID 48967)
-- Name: ControlledParkingZones controlledparkingzones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."ControlledParkingZones"
    ADD CONSTRAINT "controlledparkingzones_pkey" PRIMARY KEY ("gid");


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
-- TOC entry 3808 (class 2606 OID 48975)
-- Name: RestrictionPolygons restrictionsPolygons_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionPolygons"
    ADD CONSTRAINT "restrictionsPolygons_pk" PRIMARY KEY ("GeometryID");


--
-- TOC entry 3820 (class 2606 OID 48977)
-- Name: SignAttachmentTypes signAttachmentTypes2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."SignAttachmentTypes"
    ADD CONSTRAINT "signAttachmentTypes2_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3851 (class 2606 OID 48979)
-- Name: signs signs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."signs"
    ADD CONSTRAINT "signs_pkey" PRIMARY KEY ("gid");


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

CREATE INDEX "sidx_CPZs_geom" ON "public"."CPZs" USING "gist" ("geom");


--
-- TOC entry 3770 (class 1259 OID 48984)
-- Name: sidx_EDI01_Signs_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_EDI01_Signs_geom" ON "public"."Signs" USING "gist" ("geom");


--
-- TOC entry 3773 (class 1259 OID 48985)
-- Name: sidx_EDI_RoadCasement_Polyline_geom; Type: INDEX; Schema: public; Owner: edi_operator
--

CREATE INDEX "sidx_EDI_RoadCasement_Polyline_geom" ON "public"."EDI_RoadCasement_Polyline" USING "gist" ("geom");


--
-- TOC entry 3776 (class 1259 OID 48986)
-- Name: sidx_EDI_Sections_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_EDI_Sections_geom" ON "public"."EDI_Sections" USING "gist" ("geom");


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


--
-- TOC entry 3818 (class 1259 OID 48990)
-- Name: sidx_RoadCentreLine_geom; Type: INDEX; Schema: public; Owner: edi_operator
--

CREATE INDEX "sidx_RoadCentreLine_geom" ON "public"."RoadCentreLine" USING "gist" ("geom");


--
-- TOC entry 3809 (class 1259 OID 48991)
-- Name: sidx_restrictionPolygons_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sidx_restrictionPolygons_geom" ON "public"."RestrictionPolygons" USING "gist" ("geom");


--
-- TOC entry 3849 (class 1259 OID 48992)
-- Name: signs_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "signs_geom_idx" ON "public"."signs" USING "gist" ("geom");


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
    ADD CONSTRAINT "Bays_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "public"."baytypes"("Code");


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
    ADD CONSTRAINT "Lines_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID") REFERENCES "public"."linetypes"("Code");


--
-- TOC entry 3873 (class 2606 OID 52931)
-- Name: Proposals Proposals_ProposalStatusID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."Proposals"
    ADD CONSTRAINT "Proposals_ProposalStatusID_fkey" FOREIGN KEY ("ProposalStatusID") REFERENCES "public"."ProposalStatusTypes"("Code");


--
-- TOC entry 3870 (class 2606 OID 49033)
-- Name: RestrictionsInProposals RestrictionsInProposals_ActionOnProposalAcceptance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ActionOnProposalAcceptance_fkey" FOREIGN KEY ("ActionOnProposalAcceptance") REFERENCES "public"."ActionOnProposalAcceptanceTypes"("id");


--
-- TOC entry 3872 (class 2606 OID 52936)
-- Name: RestrictionsInProposals RestrictionsInProposals_ProposalID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ProposalID_fkey" FOREIGN KEY ("ProposalID") REFERENCES "public"."Proposals"("ProposalID");


--
-- TOC entry 3871 (class 2606 OID 49043)
-- Name: RestrictionsInProposals RestrictionsInProposals_RestrictionTableID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_RestrictionTableID_fkey" FOREIGN KEY ("RestrictionTableID") REFERENCES "public"."RestrictionLayers"("id");


