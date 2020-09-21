
CREATE TABLE "local_authority"."PayParkingAreas" (
    "Code" integer NOT NULL,
    "geom" "public"."geometry"(Polygon,27700) NOT NULL,
    "RoadName" character varying NOT NULL,
    "TariffGroup" integer,
    "Postcode" character varying,
    "CostCode" character varying,
    "Spaces" integer,
    "DisabledBays" integer,
    "MotorbikeBays" integer,
    "CoachBays" integer,
    "PremierBays" integer,
    "MaxStayID" integer
);


ALTER TABLE "local_authority"."PayParkingAreas" OWNER TO "postgres";

/***
CREATE SEQUENCE "local_authority"."PayParkingArea_Zone_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "local_authority"."PayParkingArea_Zone_seq" OWNER TO "postgres";

ALTER SEQUENCE "local_authority"."PayParkingArea_Zone_seq" OWNED BY "local_authority"."PayParkingAreas"."id";

ALTER TABLE ONLY "local_authority"."PayParkingAreas" ALTER COLUMN "id" SET DEFAULT "nextval"('"local_authority"."PayParkingArea_Zone_seq"'::"regclass");
***/

ALTER TABLE ONLY "local_authority"."PayParkingAreas"
    ADD CONSTRAINT "PayParkingAreas_pkey" PRIMARY KEY ("Code");

CREATE INDEX "sidx_PayParkingAreas_geom" ON "local_authority"."PayParkingAreas" USING "gist" ("geom");

/***
ALTER TABLE ONLY "local_authority"."PayParkingAreas"
    ADD CONSTRAINT "PayParkingAreas_RoadName_fkey" FOREIGN KEY ("RoadName") REFERENCES "local_authority"."StreetGazetteerRecords"("RoadName");
***/

--- GRANT SELECT,USAGE ON SEQUENCE local_authority."PayParkingArea_id_seq" TO toms_public, toms_operator, toms_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE local_authority."PayParkingAreas" TO toms_admin;
GRANT SELECT ON TABLE local_authority."PayParkingAreas" TO toms_operator, toms_public;

--
ALTER TABLE toms."Bays"
    ADD COLUMN "PayParkingAreaID" integer;  -- need FK on PayParkingAreas

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_PayParkingAreaID_fkey" FOREIGN KEY ("PayParkingAreaID") REFERENCES "local_authority"."PayParkingAreas"("Code");