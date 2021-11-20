/**
Add zone types lookup

NB: This is a prelude to introducing a zone type

**/

CREATE SEQUENCE toms_lookups."ZoneTypes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE toms_lookups."ZoneTypes_id_seq" OWNER TO postgres;

CREATE TABLE "toms_lookups"."ZoneTypes" (
    "id" integer DEFAULT "nextval"('"toms_lookups"."ZoneTypes_id_seq"'::"regclass") NOT NULL,
    "Code" integer,
    "Description" character varying
);

ALTER TABLE "toms_lookups"."ZoneTypes" OWNER TO "postgres";

ALTER TABLE ONLY toms_lookups."ZoneTypes"
    ADD CONSTRAINT "ZoneTypes_pkey" PRIMARY KEY (id);

ALTER TABLE ONLY toms_lookups."ZoneTypes"
    ADD CONSTRAINT "ZoneTypes_Code_key" UNIQUE ("Code");

CREATE TABLE "toms_lookups"."ZoneTypesInUse" (
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) NOT NULL,
    "StyleDetails" character varying
);

ALTER TABLE "toms_lookups"."ZoneTypesInUse" OWNER TO "postgres";

ALTER TABLE ONLY "toms_lookups"."ZoneTypesInUse"
    ADD CONSTRAINT "ZoneInUse_pkey" PRIMARY KEY ("Code");

ALTER TABLE toms_lookups."ZoneTypesInUse"
    ADD CONSTRAINT "ZoneTypesInUse_RestrictionPolygonTypes_fkey" FOREIGN KEY ("Code") REFERENCES toms_lookups."ZoneTypes" ("Code") MATCH SIMPLE;

-- Once populated, need to set up FKs to this table from CPZs, PTAs, and MatchDayZones. NB: Need to consider further the zone type restriction ...

