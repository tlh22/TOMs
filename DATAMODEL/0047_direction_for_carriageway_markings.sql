/**
Add fields for direction
**/

ALTER TABLE "moving_traffic"."CarriagewayMarkings"
    ADD COLUMN "SignOrientationTypeID" integer DEFAULT 1 NOT NULL;

ALTER TABLE "moving_traffic"."CarriagewayMarkings"
    ADD COLUMN "original_geom_wkt" character varying(255);

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_CarriagewayMarkingOrientationTypeID_fkey" FOREIGN KEY ("SignOrientationTypeID")
        REFERENCES toms_lookups."SignOrientationTypes" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

-- Populate field

UPDATE "moving_traffic"."CarriagewayMarkings"
SET "original_geom_wkt" = ST_AsText("geom");

-- set up trigger to populate

CREATE TRIGGER set_original_geometry_CarriagewayMarkings
    BEFORE INSERT OR UPDATE
    ON "moving_traffic"."CarriagewayMarkings"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_original_geometry();

/**
* TODO: Find way of changing name from SignOrientation to CarriagewayMarkingOrientation and passing it into functions ...
**/

ALTER TABLE moving_traffic."CarriagewayMarkings"
    RENAME "CarriagewayMarkingOrientationTypeID" TO "SignOrientationTypeID";