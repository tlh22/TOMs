CREATE TABLE "local_authority"."PayParkingAreas" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(Polygon,27700),
    "Name" character varying,
    "Zone" integer,
    "TariffGroup" integer,
    "Postcode" character varying,
    "CostCode" character varying,
    "Spaces" integer,
    "DisabledBays" integer,
    "MotorbikeBays" integer,
    "CoachBays" integer,
    "PremierBays" integer,
    "MaxStay" integer
);


ALTER TABLE "local_authority"."PayParkingAreas" OWNER TO "postgres";

CREATE SEQUENCE "local_authority"."PayParkingArea_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "local_authority"."PayParkingAreas_id_seq" OWNER TO "postgres";

ALTER SEQUENCE "local_authority"."PayParkingAreas_id_seq" OWNED BY "local_authority"."PayParkingAreas"."id";

ALTER TABLE ONLY "local_authority"."PayParkingAreas" ALTER COLUMN "id" SET DEFAULT "nextval"('"local_authority"."PayParkingArea_id_seq"'::"regclass");

ALTER TABLE ONLY "local_authority"."PayParkingAreas"
    ADD CONSTRAINT "PayParkingAreas_pkey" PRIMARY KEY ("id");

--
ALTER TABLE toms."Bays"
    ADD COLUMN "PayParkingAreaCode" character varying(255);  -- need FK on PayParkingAreas