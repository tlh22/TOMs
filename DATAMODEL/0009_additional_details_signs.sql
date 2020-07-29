
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