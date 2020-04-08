/* DATAMODEL diff to enable multiple labels per sheet */

-- Fix ownership (needed for foreign key)
ALTER TABLE public."MapGrid" OWNER TO postgres;

-- Create the label positions table
CREATE TABLE public."label_pos" (
    id SERIAL PRIMARY KEY,
    geom_lbl public.geometry(Point,27700) NOT NULL, -- the label position
    --geom_src public.geometry(Point,27700), -- the source position (for the leader)
    geom_src_wkt TEXT, -- the source position (for the leader)
    rotation FLOAT DEFAULT 0,
    sheet_id BIGINT NOT NULL REFERENCES public."MapGrid"("id") ON DELETE CASCADE, -- the map sheet item
    purpose VARCHAR NOT NULL DEFAULT 'generic', -- an identifier to classify labels
    lock BOOLEAN DEFAULT FALSE, -- whether the label position was manually moved (in which case it's locked)
    -- in the absence of a generic restriction table (inheritance), we add multiple nullable foreing keys
    bays_pk VARCHAR REFERENCES public."Bays"("GeometryID") ON DELETE CASCADE,
    lines_pk VARCHAR REFERENCES public."Lines"("GeometryID") ON DELETE CASCADE,
    signs_pk VARCHAR REFERENCES public."Signs"("GeometryID") ON DELETE CASCADE,
    polys_pk VARCHAR REFERENCES public."RestrictionPolygons"("GeometryID") ON DELETE CASCADE,
    cpzs_pk INTEGER REFERENCES public."CPZs"("gid") ON DELETE CASCADE,
    parking_pk INTEGER REFERENCES public."ParkingTariffAreas"("id") ON DELETE CASCADE
    CONSTRAINT exactly_one_reference CHECK (
        (bays_pk IS NOT NULL)::int + (lines_pk IS NOT NULL)::int + (signs_pk IS NOT NULL)::int + (polys_pk IS NOT NULL)::int + (cpzs_pk IS NOT NULL)::int + (parking_pk IS NOT NULL)::int = 1
    ),
    UNIQUE (
        -- FIXME : doesn't work with nullable fields
        sheet_id, purpose, bays_pk, lines_pk, signs_pk, polys_pk, cpzs_pk, parking_pk
    )
);
GRANT SELECT ON TABLE public."label_pos" TO edi_public;
GRANT SELECT ON TABLE public."label_pos" TO edi_public_nsl;
GRANT INSERT, SELECT, UPDATE ON TABLE public."label_pos" TO edi_admin;

GRANT SELECT ON SEQUENCE public."label_pos_id_seq" TO edi_operator;
GRANT SELECT ON SEQUENCE public."label_pos_id_seq" TO edi_public;
GRANT SELECT ON SEQUENCE public."label_pos_id_seq" TO edi_public_nsl;
GRANT SELECT,USAGE ON SEQUENCE public."label_pos_id_seq" TO edi_admin;


-- Migrate manually positionned label (Lines)
INSERT INTO public."label_pos" (geom_lbl, rotation, lines_pk, sheet_id, lock, purpose)
SELECT  ST_SetSRID(ST_MakePoint("labelX", "labelY"), 27700),
        COALESCE("labelRotation",0),
        "GeometryID",
        grd.id,
        TRUE,
        'waiting'
FROM public."Lines" l
JOIN public."MapGrid" grd ON ST_Contains(grd.geom, ST_SetSRID(ST_MakePoint("labelX", "labelY"), 27700))
WHERE "labelX" IS NOT NULL and "labelY" IS NOT NULL;

INSERT INTO public."label_pos" (geom_lbl, rotation, lines_pk, sheet_id, lock, purpose)
SELECT  ST_SetSRID(ST_MakePoint("labelLoadingX", "labelLoadingY"), 27700),
        COALESCE("labelLoadingRotation",0),
        "GeometryID",
        grd.id,
        TRUE,
        'loading'
FROM public."Lines" l
JOIN public."MapGrid" grd ON ST_Contains(grd.geom, ST_SetSRID(ST_MakePoint("labelLoadingX", "labelLoadingY"), 27700))
WHERE "labelLoadingX" IS NOT NULL and "labelLoadingY" IS NOT NULL;


-- Migrate manually positionned label (RestrictionPolygons)
INSERT INTO public."label_pos" (geom_lbl, rotation, polys_pk, sheet_id, lock, purpose)
SELECT  ST_SetSRID(ST_MakePoint("labelX", "labelY"), 27700),
        COALESCE("labelRotation",0),
        "GeometryID",
        grd.id,
        TRUE,
        'generic'
FROM public."RestrictionPolygons" p
JOIN public."MapGrid" grd ON ST_Contains(grd.geom, ST_SetSRID(ST_MakePoint("labelX", "labelY"), 27700))
WHERE "labelX" IS NOT NULL and "labelY" IS NOT NULL;

-- Migrate manually positionned label (Bays)
INSERT INTO public."label_pos" (geom_lbl, rotation, bays_pk, sheet_id, lock, purpose)
SELECT  ST_SetSRID(ST_MakePoint("label_X", "label_Y"), 27700),
        COALESCE("label_Rotation",0),
        "GeometryID",
        grd.id,
        TRUE,
        'generic'
FROM public."Bays" l
JOIN public."MapGrid" grd ON ST_Contains(grd.geom, ST_SetSRID(ST_MakePoint("label_X", "label_Y"), 27700))
WHERE "label_X" IS NOT NULL and "label_Y" IS NOT NULL;


-- Remove obsolete fields
ALTER TABLE public."Lines" DROP COLUMN "labelX";
ALTER TABLE public."Lines" DROP COLUMN "labelY";
ALTER TABLE public."Lines" DROP COLUMN "labelRotation";
ALTER TABLE public."RestrictionPolygons" DROP COLUMN "labelX";
ALTER TABLE public."RestrictionPolygons" DROP COLUMN "labelY";
ALTER TABLE public."RestrictionPolygons" DROP COLUMN "labelRotation";
ALTER TABLE public."Bays" DROP COLUMN "label_X";
ALTER TABLE public."Bays" DROP COLUMN "label_Y";
ALTER TABLE public."Bays" DROP COLUMN "label_Rotation";


-- Create an auto-lock trigger to automatically lock all modified labels
CREATE OR REPLACE FUNCTION auto_lock_labels_fct() RETURNS trigger SECURITY DEFINER AS $emp_stamp$
    BEGIN
        NEW."lock" = TRUE;
        RETURN NEW;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER auto_lock_labels
    BEFORE UPDATE OF "geom_lbl" ON public."label_pos"
    FOR EACH ROW
    EXECUTE PROCEDURE auto_lock_labels_fct();


-- Create a post-insert/update trigger that creates label positions on each sheet if needed
CREATE OR REPLACE FUNCTION ensure_labels_fct() RETURNS trigger SECURITY DEFINER AS $emp_stamp$
    DECLARE
        FK varchar; -- will contain the name of the foreign key field on the label layer
        PK varchar; -- will contain the name of the primary key field on the referenced layer
        NEWPK varchar; -- will contain the primary key of the modified entity
        NEWGEOM public.geometry; -- will contain the geometry of the modified entity
        REQUIRED_LABELS varchar[]; -- will contain the label purposes required

    BEGIN

        RAISE WARNING 'Running ensure_label_fct()';

        IF TG_TABLE_NAME = 'Lines' THEN
            FK := 'lines_pk';
            PK := 'GeometryID';
            NEWPK := NEW."GeometryID";
            NEWGEOM := NEW."geom";
            REQUIRED_LABELS := '{"waiting", "loading"}';
        ELSE
            RAISE WARNING 'Table %s not managed by ensure_labels_fct()', TG_TABLE_NAME;
            RETURN NULL;
        END IF;


        -- remove unlocked positions
        EXECUTE '
            DELETE FROM public."label_pos" p
            WHERE p."' || FK || '" = $1 AND NOT p."lock";
        ' USING NEWPK;

        -- create new positions on each sheet
        EXECUTE '
            INSERT INTO public."label_pos"("' || FK || '", "geom_lbl", "rotation", "sheet_id", "purpose")
            SELECT  $2,
                    CASE
                        -- the intersection can return a point if it ends exactly on the edge of the grid
                        WHEN GeometryType(ST_Intersection(grd.geom, $1)) = ''LINESTRING'' THEN ST_LineInterpolatePoint(ST_Intersection(grd.geom, $1), 0.5)
                        ELSE ST_Centroid(ST_Intersection(grd.geom, $1))
                    END,
                    0.0,
                    grd."id",
                    prp.*
            FROM public."MapGrid" grd
            JOIN (SELECT UNNEST($3)) as prp ON TRUE
            WHERE ST_Intersects(grd.geom, $1)
                -- if it does not already exist
                AND NOT EXISTS(
                    SELECT *
                    FROM public."label_pos" p
                    WHERE p."' || FK || '" = $2 AND p."sheet_id" = grd."id" AND p."purpose" = prp.unnest
                );
        ' USING NEWGEOM, NEWPK, REQUIRED_LABELS;

        -- update geom_src positions on each sheet
        EXECUTE '
            UPDATE public."label_pos"
            SET
                "geom_src_wkt" = ST_AsText(
                    CASE
                        -- the intersection can return a point if it ends exactly on the edge of the grid
                        WHEN GeometryType(ST_Intersection(grd.geom, $1)) = ''LINESTRING'' THEN ST_LineInterpolatePoint(ST_Intersection(grd.geom, $1), 0.5)
                        ELSE ST_Centroid(ST_Intersection(grd.geom, $1))
                    END
                ),
                "sheet_id" = grd.id
            FROM public."MapGrid" grd
            WHERE grd."id" = "sheet_id" AND "' || FK || '" = $2;
        ' USING NEWGEOM, NEWPK;

        RETURN NEW;
    END;
$emp_stamp$ LANGUAGE plpgsql;

-- Create the triggers
CREATE TRIGGER ensure_labels AFTER INSERT OR UPDATE ON public."Bays"
FOR EACH ROW EXECUTE PROCEDURE ensure_labels_fct();
CREATE TRIGGER ensure_labels AFTER INSERT OR UPDATE ON public."Lines"
FOR EACH ROW EXECUTE PROCEDURE ensure_labels_fct();
CREATE TRIGGER ensure_labels AFTER INSERT OR UPDATE ON public."Signs"
FOR EACH ROW EXECUTE PROCEDURE ensure_labels_fct();
CREATE TRIGGER ensure_labels AFTER INSERT OR UPDATE ON public."RestrictionPolygons"
FOR EACH ROW EXECUTE PROCEDURE ensure_labels_fct();
CREATE TRIGGER ensure_labels AFTER INSERT OR UPDATE ON public."CPZs"
FOR EACH ROW EXECUTE PROCEDURE ensure_labels_fct();
CREATE TRIGGER ensure_labels AFTER INSERT OR UPDATE ON public."ParkingTariffAreas"
FOR EACH ROW EXECUTE PROCEDURE ensure_labels_fct();

-- run the trigger on all rows
UPDATE public."Bays" SET geom = geom;
UPDATE public."Lines" SET geom = geom;
UPDATE public."Signs" SET geom = geom;
UPDATE public."RestrictionPolygons" SET geom = geom;
UPDATE public."CPZs" SET geom = geom;
UPDATE public."ParkingTariffAreas" SET geom = geom;
