-- create roadlink table

-- SEQUENCE: highways_network.roadlink_id_seq

-- DROP SEQUENCE highways_network.roadlink_id_seq;

CREATE SEQUENCE highways_network.roadlink_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE highways_network.roadlink_id_seq
    OWNER TO postgres;

GRANT ALL ON SEQUENCE highways_network.roadlink_id_seq TO postgres;
GRANT SELECT, USAGE ON SEQUENCE highways_network.roadlink_id_seq TO toms_admin;
GRANT SELECT, USAGE ON SEQUENCE highways_network.roadlink_id_seq TO toms_operator;
GRANT SELECT, USAGE ON SEQUENCE highways_network.roadlink_id_seq TO toms_public;

-- Table: highways_network.roadlink

-- DROP TABLE highways_network.roadlink;

CREATE TABLE highways_network.roadlink
(
    id character varying COLLATE pg_catalog."default" NOT NULL DEFAULT nextval('highways_network.roadlink_id_seq'::regclass),
    geom geometry(LineString,27700),
    fid bigint,
    "endNode" character varying(39) COLLATE pg_catalog."default",
    "startNode" character varying(39) COLLATE pg_catalog."default",
    "roadNumberTOID" character varying(21) COLLATE pg_catalog."default",
    "roadNameTOID" character varying(21) COLLATE pg_catalog."default",
    fictitious integer,
    "roadClassification" character varying(22) COLLATE pg_catalog."default",
    "roadFunction" character varying(30) COLLATE pg_catalog."default",
    "formOfWay" character varying(50) COLLATE pg_catalog."default",
    length integer,
    length_uom character varying(10) COLLATE pg_catalog."default",
    loop integer,
    "primaryRoute" integer,
    "trunkRoad" integer,
    "roadClassificationNumber" character varying(10) COLLATE pg_catalog."default",
    name1 character varying(150) COLLATE pg_catalog."default",
    name1_lang character varying(150) COLLATE pg_catalog."default",
    name2 character varying(150) COLLATE pg_catalog."default",
    name2_lang character varying(150) COLLATE pg_catalog."default",
    "roadStructure" character varying(14) COLLATE pg_catalog."default",
    CONSTRAINT roadlink_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE highways_network.roadlink
    OWNER to postgres;

GRANT ALL ON TABLE highways_network.roadlink TO postgres;
GRANT SELECT ON TABLE highways_network.roadlink TO toms_admin;
GRANT SELECT ON TABLE highways_network.roadlink TO toms_operator;
GRANT SELECT ON TABLE highways_network.roadlink TO toms_public;
-- Index: sidx_roadlink_geom

-- DROP INDEX highways_network.sidx_roadlink_geom;

CREATE INDEX sidx_roadlink_geom
    ON highways_network.roadlink USING gist
    (geom)
    TABLESPACE pg_default;

-- Add view for gazetteer lookup from roadlink
CREATE MATERIALIZED VIEW local_authority."StreetGazetteerView"
TABLESPACE pg_default
AS
    SELECT row_number() OVER (PARTITION BY true::boolean) AS id,
    name1 AS "RoadName", NULL AS "Locality", geom As geom
	FROM highways_network.roadlink
WITH DATA;

ALTER TABLE local_authority."StreetGazetteerView"
    OWNER TO postgres;

CREATE UNIQUE INDEX "idx_StreetGazetteerView_id"
    ON local_authority."StreetGazetteerView" USING btree
    (id)
    TABLESPACE pg_default;

CREATE INDEX idx_street_name
ON local_authority."StreetGazetteerView"("RoadName");
