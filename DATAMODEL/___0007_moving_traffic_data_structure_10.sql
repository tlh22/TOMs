--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-08-06 08:00:37

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
-- TOC entry 22 (class 2615 OID 515904)
-- Name: moving_traffic; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "moving_traffic";


ALTER SCHEMA "moving_traffic" OWNER TO "postgres";

--
-- TOC entry 484 (class 1259 OID 515905)
-- Name: AccessRestrictions_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."AccessRestrictions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."AccessRestrictions_id_seq" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 485 (class 1259 OID 515907)
-- Name: Restrictions; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."Restrictions" (
    "RestrictionID" "uuid" NOT NULL,
    "GeometryID" character varying(12) NOT NULL,
    "Notes" character varying(254),
    "Photos_01" character varying(255),
    "Photos_02" character varying(255),
    "Photos_03" character varying(255),
    "RoadName" character varying(254),
    "USRN" character varying(254),
    "label_X" double precision,
    "label_Y" double precision,
    "label_Rotation" double precision,
    "label_TextChanged" character varying(254),
    "OpenDate" "date",
    "CloseDate" "date",
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) NOT NULL,
    "ComplianceRoadMarkingsFaded" integer,
    "ComplianceRestrictionSignIssue" integer,
    "ComplianceNotes" character varying(254),
    "MHTC_CheckIssueTypeID" integer,
    "MHTC_CheckNotes" character varying(254)
);


ALTER TABLE "moving_traffic"."Restrictions" OWNER TO "postgres";

--
-- TOC entry 487 (class 1259 OID 515932)
-- Name: AccessRestrictions; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."AccessRestrictions" (
    "GeometryID" character varying(12) DEFAULT ('A_'::"text" || "to_char"("nextval"('"moving_traffic"."AccessRestrictions_id_seq"'::"regclass"), '000000000'::"text")),
    "restriction" "moving_traffic_lookups"."accessRestrictionValue" NOT NULL,
    "timeInterval" integer,
    "trafficSigns" character varying(255),
    "exemption" integer,
    "inclusion" integer,
    "mt_capture_geom" "public"."geometry"(Point,27700)
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."AccessRestrictions" OWNER TO "postgres";

--
-- TOC entry 507 (class 1259 OID 516613)
-- Name: CarriagewayMarkings; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."CarriagewayMarkings" (
    "CarriagewayMarkingType_1" integer NOT NULL,
    "CarriagewayMarkingType_2" integer,
    "CarriagewayMarkingType_3" integer,
    "CarriagewayMarkingType_4" integer,
    "geom" "public"."geometry"(Point,27700)
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."CarriagewayMarkings" OWNER TO "postgres";

--
-- TOC entry 505 (class 1259 OID 516456)
-- Name: CarriagewayMarkings_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."CarriagewayMarkings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."CarriagewayMarkings_id_seq" OWNER TO "postgres";

--
-- TOC entry 488 (class 1259 OID 515939)
-- Name: HighwayDedications_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."HighwayDedications_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."HighwayDedications_id_seq" OWNER TO "postgres";

--
-- TOC entry 489 (class 1259 OID 515941)
-- Name: HighwayDedications; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."HighwayDedications" (
    "GeometryID" character varying(12) DEFAULT ('H_'::"text" || "to_char"("nextval"('"moving_traffic"."HighwayDedications_id_seq"'::"regclass"), '000000000'::"text")),
    "dedication" "moving_traffic_lookups"."dedicationValue" NOT NULL,
    "timeInterval" integer,
    "mt_capture_geom" "public"."geometry"(LineString,27700)
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."HighwayDedications" OWNER TO "postgres";

--
-- TOC entry 486 (class 1259 OID 515929)
-- Name: NetworkReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."NetworkReference" (
    "NetworkReferenceID" "uuid" NOT NULL
);


ALTER TABLE "moving_traffic"."NetworkReference" OWNER TO "postgres";

--
-- TOC entry 490 (class 1259 OID 515948)
-- Name: LinkReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."LinkReference" (
    "applicableDirection" "moving_traffic_lookups"."linkDirectionValue" NOT NULL,
    "linkReference" character varying(20) NOT NULL,
    "linkOrder" integer NOT NULL
)
INHERITS ("moving_traffic"."NetworkReference");


ALTER TABLE "moving_traffic"."LinkReference" OWNER TO "postgres";

--
-- TOC entry 491 (class 1259 OID 515951)
-- Name: SimpleLinearReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."SimpleLinearReference" (
    "fromPosition" double precision,
    "toPosition" double precision,
    "offset" double precision
)
INHERITS ("moving_traffic"."LinkReference");


ALTER TABLE "moving_traffic"."SimpleLinearReference" OWNER TO "postgres";

--
-- TOC entry 492 (class 1259 OID 515954)
-- Name: LinearReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."LinearReference" (
    "fromPositionGeometry" "public"."geometry"(Point,27700),
    "toPositionGeometry" "public"."geometry"(Point,27700)
)
INHERITS ("moving_traffic"."SimpleLinearReference");


ALTER TABLE "moving_traffic"."LinearReference" OWNER TO "postgres";

--
-- TOC entry 493 (class 1259 OID 515960)
-- Name: NodeReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."NodeReference" (
    "nodeReference" character varying(20) NOT NULL
)
INHERITS ("moving_traffic"."NetworkReference");


ALTER TABLE "moving_traffic"."NodeReference" OWNER TO "postgres";

--
-- TOC entry 494 (class 1259 OID 515963)
-- Name: SimplePointReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."SimplePointReference" (
    "atPosition" double precision NOT NULL,
    "offset" double precision
)
INHERITS ("moving_traffic"."LinkReference");


ALTER TABLE "moving_traffic"."SimplePointReference" OWNER TO "postgres";

--
-- TOC entry 495 (class 1259 OID 515966)
-- Name: PointReference; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."PointReference" (
    "atPositionGeometry" "public"."geometry"(Point,27700) NOT NULL
)
INHERITS ("moving_traffic"."SimplePointReference");


ALTER TABLE "moving_traffic"."PointReference" OWNER TO "postgres";

--
-- TOC entry 496 (class 1259 OID 515972)
-- Name: RestrictionsForVehicles_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."RestrictionsForVehicles_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."RestrictionsForVehicles_id_seq" OWNER TO "postgres";

--
-- TOC entry 497 (class 1259 OID 515974)
-- Name: RestrictionsForVehicles; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."RestrictionsForVehicles" (
    "GeometryID" character varying(12) DEFAULT ('R_'::"text" || "to_char"("nextval"('"moving_traffic"."RestrictionsForVehicles_id_seq"'::"regclass"), '000000000'::"text")),
    "restrictionType" "moving_traffic_lookups"."restrictionTypeValue" NOT NULL,
    "measure" double precision NOT NULL,
    "measure2" double precision,
    "inclusion" integer,
    "exemption" integer,
    "structure" "moving_traffic_lookups"."structureTypeValue",
    "mt_capture_geom" "public"."geometry"(Point,27700)
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."RestrictionsForVehicles" OWNER TO "postgres";

--
-- TOC entry 498 (class 1259 OID 515981)
-- Name: SpecialDesignations_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."SpecialDesignations_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."SpecialDesignations_id_seq" OWNER TO "postgres";

--
-- TOC entry 499 (class 1259 OID 515983)
-- Name: SpecialDesignations; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."SpecialDesignations" (
    "GeometryID" character varying(12) DEFAULT ('D_'::"text" || "to_char"("nextval"('"moving_traffic"."SpecialDesignations_id_seq"'::"regclass"), '000000000'::"text")),
    "designation" "moving_traffic_lookups"."specialDesignationTypeValue" NOT NULL,
    "timeInterval" integer,
    "lane" integer,
    "mt_capture_geom" "public"."geometry"(LineString,27700)
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."SpecialDesignations" OWNER TO "postgres";

--
-- TOC entry 500 (class 1259 OID 515990)
-- Name: TurnRestrictions_id_seq; Type: SEQUENCE; Schema: moving_traffic; Owner: postgres
--

CREATE SEQUENCE "moving_traffic"."TurnRestrictions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "moving_traffic"."TurnRestrictions_id_seq" OWNER TO "postgres";

--
-- TOC entry 506 (class 1259 OID 516552)
-- Name: TurnRestrictions; Type: TABLE; Schema: moving_traffic; Owner: postgres
--

CREATE TABLE "moving_traffic"."TurnRestrictions" (
    "GeometryID" character varying(12) DEFAULT ('V_'::"text" || "to_char"("nextval"('"moving_traffic"."TurnRestrictions_id_seq"'::"regclass"), '000000000'::"text")),
    "restrictionType" "moving_traffic_lookups"."turnRestrictionValue" NOT NULL,
    "inclusion" integer,
    "exemption" integer,
    "timeInterval" integer,
    "mt_capture_geom" "public"."geometry"(LineString,27700)
)
INHERITS ("moving_traffic"."Restrictions");


ALTER TABLE "moving_traffic"."TurnRestrictions" OWNER TO "postgres";

--
-- TOC entry 4494 (class 2606 OID 516000)
-- Name: AccessRestrictions AccessRestrictions_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4516 (class 2606 OID 516620)
-- Name: CarriagewayMarkings CarriagewayMarkings_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4496 (class 2606 OID 516002)
-- Name: HighwayDedications HighwayDedications_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "HighwayDedications_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4504 (class 2606 OID 516004)
-- Name: LinearReference LinearReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."LinearReference"
    ADD CONSTRAINT "LinearReference_pkey" PRIMARY KEY ("NetworkReferenceID") INCLUDE ("linkReference");


--
-- TOC entry 4498 (class 2606 OID 516006)
-- Name: LinkReference LinkReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."LinkReference"
    ADD CONSTRAINT "LinkReference_pkey" PRIMARY KEY ("NetworkReferenceID", "linkReference", "linkOrder");


--
-- TOC entry 4492 (class 2606 OID 516008)
-- Name: NetworkReference NetworkReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."NetworkReference"
    ADD CONSTRAINT "NetworkReference_pkey" PRIMARY KEY ("NetworkReferenceID");


--
-- TOC entry 4508 (class 2606 OID 516010)
-- Name: PointReference PointReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."PointReference"
    ADD CONSTRAINT "PointReference_pkey" PRIMARY KEY ("NetworkReferenceID") INCLUDE ("linkReference");


--
-- TOC entry 4510 (class 2606 OID 516012)
-- Name: RestrictionsForVehicles RestrictionForVehicles_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4490 (class 2606 OID 516014)
-- Name: Restrictions Restrictions_GeometryID_key; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."Restrictions"
    ADD CONSTRAINT "Restrictions_GeometryID_key" UNIQUE ("GeometryID");


--
-- TOC entry 4500 (class 2606 OID 516016)
-- Name: SimpleLinearReference SimpleLinearReference_NetworkReferenceID_linkReference_key; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SimpleLinearReference"
    ADD CONSTRAINT "SimpleLinearReference_NetworkReferenceID_linkReference_key" UNIQUE ("NetworkReferenceID", "linkReference");


--
-- TOC entry 4502 (class 2606 OID 516018)
-- Name: SimpleLinearReference SimpleLinearReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SimpleLinearReference"
    ADD CONSTRAINT "SimpleLinearReference_pkey" PRIMARY KEY ("NetworkReferenceID") INCLUDE ("linkReference");


--
-- TOC entry 4506 (class 2606 OID 516020)
-- Name: SimplePointReference SimplePointReference_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SimplePointReference"
    ADD CONSTRAINT "SimplePointReference_pkey" PRIMARY KEY ("NetworkReferenceID") INCLUDE ("linkReference");


--
-- TOC entry 4512 (class 2606 OID 516022)
-- Name: SpecialDesignations SpecialDesignations_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4514 (class 2606 OID 516560)
-- Name: TurnRestrictions TurnRestrictions_pkey; Type: CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_pkey" PRIMARY KEY ("RestrictionID");


--
-- TOC entry 4538 (class 2620 OID 516025)
-- Name: AccessRestrictions create_geometryid_access_restrictions; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_access_restrictions" BEFORE INSERT ON "moving_traffic"."AccessRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4548 (class 2620 OID 516646)
-- Name: CarriagewayMarkings create_geometryid_carriageway_markings; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_carriageway_markings" BEFORE INSERT ON "moving_traffic"."CarriagewayMarkings" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4540 (class 2620 OID 516026)
-- Name: HighwayDedications create_geometryid_highway_dedications; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_highway_dedications" BEFORE INSERT ON "moving_traffic"."HighwayDedications" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4542 (class 2620 OID 516027)
-- Name: RestrictionsForVehicles create_geometryid_restrictions_for_vehicles; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_restrictions_for_vehicles" BEFORE INSERT ON "moving_traffic"."RestrictionsForVehicles" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4544 (class 2620 OID 516028)
-- Name: SpecialDesignations create_geometryid_special_designations; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_special_designations" BEFORE INSERT ON "moving_traffic"."SpecialDesignations" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4546 (class 2620 OID 516561)
-- Name: TurnRestrictions create_geometryid_turn_restrictions; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "create_geometryid_turn_restrictions" BEFORE INSERT ON "moving_traffic"."TurnRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();


--
-- TOC entry 4539 (class 2620 OID 516544)
-- Name: AccessRestrictions set_last_update_details_access_restrictions; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_access_restrictions" BEFORE INSERT OR UPDATE ON "moving_traffic"."AccessRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4549 (class 2620 OID 516647)
-- Name: CarriagewayMarkings set_last_update_details_carriageway_markings; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_carriageway_markings" BEFORE INSERT OR UPDATE ON "moving_traffic"."CarriagewayMarkings" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4541 (class 2620 OID 516543)
-- Name: HighwayDedications set_last_update_details_highway_dedications; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_highway_dedications" BEFORE INSERT OR UPDATE ON "moving_traffic"."HighwayDedications" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4543 (class 2620 OID 516542)
-- Name: RestrictionsForVehicles set_last_update_details_restrictions_for_vehicles; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_restrictions_for_vehicles" BEFORE INSERT OR UPDATE ON "moving_traffic"."RestrictionsForVehicles" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4545 (class 2620 OID 516541)
-- Name: SpecialDesignations set_last_update_details_special_designations; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_special_designations" BEFORE INSERT OR UPDATE ON "moving_traffic"."SpecialDesignations" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4547 (class 2620 OID 516562)
-- Name: TurnRestrictions set_last_update_details_turn_restrictions; Type: TRIGGER; Schema: moving_traffic; Owner: postgres
--

CREATE TRIGGER "set_last_update_details_turn_restrictions" BEFORE INSERT OR UPDATE ON "moving_traffic"."TurnRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();


--
-- TOC entry 4520 (class 2606 OID 516030)
-- Name: AccessRestrictions AccessRestrictions_exemption_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_exemption_fkey" FOREIGN KEY ("exemption") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4521 (class 2606 OID 516035)
-- Name: AccessRestrictions AccessRestrictions_inclusion_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_inclusion_fkey" FOREIGN KEY ("inclusion") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4522 (class 2606 OID 516040)
-- Name: AccessRestrictions AccessRestrictions_timeInterval_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_timeInterval_fkey" FOREIGN KEY ("timeInterval") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4533 (class 2606 OID 516621)
-- Name: CarriagewayMarkings CarriagewayMarkings_CarriagewayMarkingTypes2_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_CarriagewayMarkingTypes2_fkey" FOREIGN KEY ("CarriagewayMarkingType_2") REFERENCES "moving_traffic_lookups"."CarriagewayMarkingTypesInUse"("Code");


--
-- TOC entry 4534 (class 2606 OID 516626)
-- Name: CarriagewayMarkings CarriagewayMarkings_CarriagewayMarkingTypes3_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_CarriagewayMarkingTypes3_fkey" FOREIGN KEY ("CarriagewayMarkingType_3") REFERENCES "moving_traffic_lookups"."CarriagewayMarkingTypesInUse"("Code");


--
-- TOC entry 4535 (class 2606 OID 516631)
-- Name: CarriagewayMarkings CarriagewayMarkings_CarriagewayMarkingTypes4_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_CarriagewayMarkingTypes4_fkey" FOREIGN KEY ("CarriagewayMarkingType_4") REFERENCES "moving_traffic_lookups"."CarriagewayMarkingTypesInUse"("Code");


--
-- TOC entry 4536 (class 2606 OID 516636)
-- Name: CarriagewayMarkings CarriagewayMarkings_CarriagewayMarkingsTypes1_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_CarriagewayMarkingsTypes1_fkey" FOREIGN KEY ("CarriagewayMarkingType_1") REFERENCES "moving_traffic_lookups"."CarriagewayMarkingTypesInUse"("Code");


--
-- TOC entry 4537 (class 2606 OID 516641)
-- Name: CarriagewayMarkings CarriagewayMarkings_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4523 (class 2606 OID 516045)
-- Name: HighwayDedications HighwayDedications_timeInterval_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "HighwayDedications_timeInterval_fkey" FOREIGN KEY ("timeInterval") REFERENCES "toms_lookups"."TimePeriods"("Code");


--
-- TOC entry 4526 (class 2606 OID 516050)
-- Name: PointReference PointReference_linkReference_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."PointReference"
    ADD CONSTRAINT "PointReference_linkReference_fkey" FOREIGN KEY ("linkReference") REFERENCES "highways_network"."itn_roadcentreline"("toid");


--
-- TOC entry 4527 (class 2606 OID 516055)
-- Name: RestrictionsForVehicles RestrictionForVehicles_exemption_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_exemption_fkey" FOREIGN KEY ("exemption") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4528 (class 2606 OID 516060)
-- Name: RestrictionsForVehicles RestrictionForVehicles_inclusion_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionForVehicles_inclusion_fkey" FOREIGN KEY ("inclusion") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4517 (class 2606 OID 515914)
-- Name: Restrictions Restrictions_ComplianceRestrictionSignIssue_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."Restrictions"
    ADD CONSTRAINT "Restrictions_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");


--
-- TOC entry 4518 (class 2606 OID 515919)
-- Name: Restrictions Restrictions_ComplianceRoadMarkingsFaded_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."Restrictions"
    ADD CONSTRAINT "Restrictions_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");


--
-- TOC entry 4519 (class 2606 OID 515924)
-- Name: Restrictions Restrictions_MHTC_CheckIssueTypeID_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."Restrictions"
    ADD CONSTRAINT "Restrictions_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");


--
-- TOC entry 4529 (class 2606 OID 516065)
-- Name: SpecialDesignations SpecialDesignations_timeInterval_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_timeInterval_fkey" FOREIGN KEY ("timeInterval") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4530 (class 2606 OID 516563)
-- Name: TurnRestrictions TurnRestrictions_exemption_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_exemption_fkey" FOREIGN KEY ("exemption") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4531 (class 2606 OID 516568)
-- Name: TurnRestrictions TurnRestrictions_inclusion_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_inclusion_fkey" FOREIGN KEY ("inclusion") REFERENCES "moving_traffic_lookups"."vehicleQualifiers"("Code");


--
-- TOC entry 4532 (class 2606 OID 516573)
-- Name: TurnRestrictions TurnRestrictions_timeInterval_fkey; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_timeInterval_fkey" FOREIGN KEY ("timeInterval") REFERENCES "toms_lookups"."TimePeriodsInUse"("Code");


--
-- TOC entry 4524 (class 2606 OID 516085)
-- Name: LinkReference fk_link; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."LinkReference"
    ADD CONSTRAINT "fk_link" FOREIGN KEY ("linkReference") REFERENCES "highways_network"."itn_roadcentreline"("toid");


--
-- TOC entry 4525 (class 2606 OID 516090)
-- Name: NodeReference fk_node; Type: FK CONSTRAINT; Schema: moving_traffic; Owner: postgres
--

ALTER TABLE ONLY "moving_traffic"."NodeReference"
    ADD CONSTRAINT "fk_node" FOREIGN KEY ("nodeReference") REFERENCES "highways_network"."itn_roadcentreline"("toid");

-- Completed on 2020-08-06 08:00:37

--
-- PostgreSQL database dump complete
--

