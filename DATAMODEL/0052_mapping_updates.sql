/**
Include mapping updates created from CAD. Currently within shape files in two parts:
 - mask
 - mapping update (could be in multiple parts - kerb, buildings, ...)

Want to introduce in two stages:
 - initial fix
 - deal with changes over time, e.g., what happens when underlying OS mapping changes

**/

CREATE SCHEMA "topography_updates";

ALTER SCHEMA "topography_updates" OWNER TO "postgres";

CREATE SEQUENCE "topography_updates"."MappingUpdateMasks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "topography_updates"."MappingUpdateMasks_id_seq" OWNER TO "postgres";

CREATE TABLE "topography_updates"."MappingUpdateMasks" (
    "RestrictionID" character varying(254),
    "GeometryID" character varying(12) DEFAULT ('MA_'::"text" || "to_char"("nextval"('"topography_updates"."MappingUpdateMasks_id_seq"'::"regclass"), 'FM0000000'::"text")) NOT NULL,
    "geom" "public"."geometry"(Polygon,27700) NOT NULL,

    "OpenDate" "date",
    "CloseDate" "date",
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) NOT NULL,
    "CreateDateTime" timestamp without time zone NOT NULL,
    "CreatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL,

     "ProposalID" integer
);

ALTER TABLE "topography_updates"."MappingUpdateMasks" OWNER TO "postgres";

ALTER TABLE topography_updates."MappingUpdateMasks"
    ADD PRIMARY KEY ("GeometryID");

CREATE INDEX "sidx_MappingUpdateMasks_geom"
    ON "topography_updates"."MappingUpdateMasks" USING gist
    (geom)
    TABLESPACE pg_default;

CREATE TRIGGER "set_create_details_MappingUpdateMasks"
    BEFORE INSERT
    ON "topography_updates"."MappingUpdateMasks"
    FOR EACH ROW
    EXECUTE FUNCTION public.set_create_details();

CREATE TRIGGER "set_last_update_details_MappingUpdateMasks"
    BEFORE INSERT
    ON "topography_updates"."MappingUpdateMasks"
    FOR EACH ROW
    EXECUTE FUNCTION public.set_last_update_details();

--

CREATE SEQUENCE "topography_updates"."MappingUpdates_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "topography_updates"."MappingUpdates_id_seq" OWNER TO "postgres";

DROP TABLE IF EXISTS "topography_updates"."MappingUpdates" CASCADE;
CREATE TABLE "topography_updates"."MappingUpdates" (
    "RestrictionID" character varying(254),
    "GeometryID" character varying(12) DEFAULT ('MU_'::"text" || "to_char"("nextval"('"topography_updates"."MappingUpdates_id_seq"'::"regclass"), 'FM0000000'::"text")) NOT NULL,
    "geom" "public"."geometry"(LineString, 27700) NOT NULL,
    "DescGroup" character varying COLLATE pg_catalog."default",

    "OpenDate" "date",
    "CloseDate" "date",
    "LastUpdateDateTime" timestamp without time zone NOT NULL,
    "LastUpdatePerson" character varying(255) NOT NULL,
    "CreateDateTime" timestamp without time zone NOT NULL,
    "CreatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL,

     "ProposalID" integer
);

ALTER TABLE "topography_updates"."MappingUpdates" OWNER TO "postgres";

ALTER TABLE topography_updates."MappingUpdates"
    ADD PRIMARY KEY ("GeometryID");

CREATE INDEX "sidx_MappingUpdates_geom"
    ON "topography_updates"."MappingUpdates" USING gist
    (geom)
    TABLESPACE pg_default;

CREATE TRIGGER "set_create_details_MappingUpdates"
    BEFORE INSERT
    ON "topography_updates"."MappingUpdates"
    FOR EACH ROW
    EXECUTE FUNCTION public.set_create_details();

CREATE TRIGGER "set_last_update_details_MappingUpdates"
    BEFORE INSERT
    ON "topography_updates"."MappingUpdates"
    FOR EACH ROW
    EXECUTE FUNCTION public.set_last_update_details();

-- FUNCTION: public.create_geometryid_mapping_updates()

-- DROP FUNCTION public.create_geometryid_mapping_updates();

CREATE OR REPLACE FUNCTION public.create_geometryid_mapping_updates()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	 nextSeqVal varchar := '';
	 start_uuid varchar := '';
BEGIN

	CASE TG_TABLE_NAME
	WHEN 'MappingUpdates' THEN
			SELECT concat('MU_', to_char(nextval('"topography_updates"."MappingUpdates_id_seq"'::regclass), 'FM0000000'::text)) INTO nextSeqVal;
	WHEN 'MappingUpdateMasks' THEN
			SELECT concat('MA_', to_char(nextval('"topography_updates"."MappingUpdateMasks_id_seq"'::regclass), 'FM0000000'::text)) INTO nextSeqVal;
	ELSE
	    nextSeqVal = 'U';
	END CASE;

    NEW."GeometryID" := nextSeqVal;
	RETURN NEW;

    -- Also sort out RestrictionID (if it is not set)

    SELECT uuid_generate_v4()::text INTO start_uuid;
    NEW."RestrictionID" := start_uuid;
    --IF NEW."RestrictionID" IS NULL THEN
       --NEW."RestrictionID" := uuid_generate_v4();
    --END IF;

END;
$BODY$;

ALTER FUNCTION public.create_geometryid_highway_assets()
    OWNER TO postgres;

CREATE TRIGGER create_geometryid_MappingUpdates
    BEFORE INSERT
    ON "topography_updates"."MappingUpdates"
    FOR EACH ROW
    EXECUTE FUNCTION public.create_geometryid_mapping_updates();

CREATE TRIGGER create_geometryid_MappingUpdateMasks
    BEFORE INSERT
    ON "topography_updates"."MappingUpdateMasks"
    FOR EACH ROW
    EXECUTE FUNCTION public.create_geometryid_mapping_updates();

-- Set permissions

REVOKE ALL ON ALL TABLES IN SCHEMA topography_updates FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA topography_updates TO toms_public, toms_operator, toms_admin;
GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA topography_updates TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA topography_updates TO toms_public, toms_operator, toms_admin;

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE "topography_updates"."MappingUpdates" TO toms_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE "topography_updates"."MappingUpdateMasks" TO toms_admin;
