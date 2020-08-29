-- SignTypes - need to include ICON field and update from MASTER

ALTER TABLE toms_lookups."SignTypes"
    ADD COLUMN "Icon" character varying(255);

-- Signs - need to deal with original geometry

-- FUNCTION: public.set_original_geometry()

CREATE FUNCTION public.set_original_geometry()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
    BEGIN
        -- Copy geometry to originalGeometry
        NEW."original_geom_wkt" := ST_AsText(NEW."geom");

        RETURN NEW;
    END;
$BODY$;

ALTER FUNCTION public.set_original_geometry()
    OWNER TO postgres;

CREATE TRIGGER set_original_geometry_signs
    BEFORE INSERT OR UPDATE
    ON toms."Signs"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_original_geometry();

ALTER TABLE toms."Signs"
    RENAME "Signs_Attachment" TO "SignsAttachmentTypeID";

ALTER TABLE toms."Signs"
    ADD COLUMN "AssetReference" character varying(255);

ALTER TABLE toms."Lines"
    ADD COLUMN "ComplianceLoadingMarkingsFaded" integer;
ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_ComplianceLoadingMarkingsFaded_fkey" FOREIGN KEY ("ComplianceLoadingMarkingsFaded") REFERENCES compliance_lookups."RestrictionRoadMarkingsFadedTypes" ("Code");

-- Deal with bay geometry types

CREATE OR REPLACE FUNCTION public.set_bay_geom_type()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
    DECLARE
        restriction_id          text;
        geom_shape_id			integer;
        geom_shape_group_type	text;
    BEGIN

		restriction_id = NEW."RestrictionID";
		geom_shape_id = NEW."GeomShapeID";
		--RAISE NOTICE '% is restrictionID', NEW."RestrictionID";

		SELECT l."GeomShapeGroupType"
		FROM toms."Bays" b, toms_lookups."BayTypesInUse" l
		WHERE b."RestrictionTypeID" = NEW."RestrictionTypeID"
		AND b."RestrictionTypeID" = l."Code" INTO geom_shape_group_type;

		--RAISE NOTICE  '% is geom_shape_group_type', geom_shape_group_type;
		--RAISE NOTICE  '% is geom_shape_id 1', geom_shape_id;

		IF (NEW."GeomShapeID" > 20 AND geom_shape_group_type = 'LineString') THEN
		    geom_shape_id = geom_shape_id - 20;
		ELSIF (NEW."GeomShapeID" < 20 AND geom_shape_group_type = 'Polygon') THEN
		    geom_shape_id = geom_shape_id + 20;
		END IF;

		--RAISE NOTICE  '% is geom_shape_id 2', geom_shape_id;

		NEW."GeomShapeID" := geom_shape_id;
        RETURN NEW;
    END;
$BODY$;

DROP TRIGGER IF EXISTS "set_bay_geom_type_trigger" ON "toms"."Bays";
CREATE TRIGGER "set_bay_geom_type_trigger" BEFORE INSERT OR UPDATE ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_bay_geom_type"();

-- Allow admin to update details in LOOKUPs
REVOKE ALL ON ALL TABLES IN SCHEMA toms_lookups FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA toms_lookups TO toms_public, toms_operator;
GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA toms_lookups TO toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;

CREATE SCHEMA mhtc_operations
    AUTHORIZATION postgres;

--- gnss pts table
CREATE SEQUENCE mhtc_operations."gnss_pts_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE mhtc_operations."gnss_pts_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE mhtc_operations."gnss_pts_id_seq" TO postgres;

CREATE TABLE mhtc_operations.gnss_pts
(
    id integer NOT NULL DEFAULT nextval('topography.gnss_pts_id_seq'::regclass),
    geom geometry(Point,27700) NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    hacc double precision,
    "satellitesUsed" integer,
    pdop double precision,
    "fixMode" character varying COLLATE pg_catalog."default",
    "fixType" integer,
    quality integer,
    "satPrn" integer[],
    "utcDateTime" timestamp without time zone NOT NULL,
    CONSTRAINT gnss_pts_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE mhtc_operations.gnss_pts
    OWNER to postgres;

GRANT SELECT ON TABLE mhtc_operations."gnss_pts" TO toms_public;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE mhtc_operations."gnss_pts" TO toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA mhtc_operations TO toms_public, toms_operator, toms_admin;

ALTER TABLE topography."Corners"
  SET SCHEMA mhtc_operations;

GRANT USAGE ON SCHEMA mhtc_operations TO toms_public, toms_operator, toms_admin;

-- add index to road_casement
CREATE INDEX road_casement_geom_idx
    ON topography.road_casement USING gist
    (geom)
    TABLESPACE pg_default;
