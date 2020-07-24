
CREATE SCHEMA highway_assets
    AUTHORIZATION postgres;

CREATE TABLE highway_assets."HighwayAssets"
(
    "RestrictionID" uuid NOT NULL,
    "GeometryReferenceID" uuid NOT NULL,
    "GeometryID" character varying(12) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "HighwayAssets_GeometryID_key" UNIQUE ("GeometryID")
)

TABLESPACE pg_default;

ALTER TABLE highway_assets."HighwayAssets"
    OWNER to postgres;

CREATE TABLE highway_assets."GeometryReferences"
(
    "GeometryReferenceID" uuid NOT NULL,
    CONSTRAINT "GeometryReference_pkey" PRIMARY KEY ("GeometryReferenceID")
)

TABLESPACE pg_default;

ALTER TABLE highway_assets."GeometryReferences"
    OWNER to postgres;

