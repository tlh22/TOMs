/* DATAMODEL diff to enable multiple labels per sheet */

-- ALTER TABLE public."Lines" ADD COLUMN "label_text" text;
-- ALTER TABLE public."Lines" ADD COLUMN "label_loading_text" text;
-- ALTER TABLE public."RestrictionPolygons" ADD COLUMN "label_text" text;
-- ALTER TABLE public."Bays" ADD COLUMN "label_text" text;

-- Add label position and leader fields
ALTER TABLE public."Lines" ADD COLUMN "label_pos" public.geometry(MultiPoint, 27700);
ALTER TABLE public."Lines" ADD COLUMN "label_loading_pos" public.geometry(MultiPoint, 27700);
ALTER TABLE public."RestrictionPolygons" ADD COLUMN "label_pos" public.geometry(MultiPoint, 27700);
ALTER TABLE public."Bays" ADD COLUMN "label_pos" public.geometry(MultiPoint, 27700);
ALTER TABLE public."Lines" ADD COLUMN "label_leader" public.geometry(MultiLinestring, 27700);
ALTER TABLE public."Lines" ADD COLUMN "label_loading_leader" public.geometry(MultiLinestring, 27700);
ALTER TABLE public."RestrictionPolygons" ADD COLUMN "label_leader" public.geometry(MultiLinestring, 27700);
ALTER TABLE public."Bays" ADD COLUMN "label_leader" public.geometry(MultiLinestring, 27700);

-- Migrate manually positionned label (Lines)
UPDATE public."Lines" SET
    "label_pos" = ST_Multi(ST_SetSRID(ST_MakePoint("labelX", "labelY"), 27700)),
    "label_loading_pos" = ST_Multi(ST_SetSRID(ST_MakePoint("labelLoadingX", "labelLoadingY"), 27700));
UPDATE public."RestrictionPolygons" SET
    "label_pos" = ST_Multi(ST_SetSRID(ST_MakePoint("labelX", "labelY"), 27700));
UPDATE public."Bays" SET
    "label_pos" = ST_Multi(ST_SetSRID(ST_MakePoint("label_X", "label_Y"), 27700));

-- Remove obsolete fields
ALTER TABLE public."Lines" DROP COLUMN "labelX";
ALTER TABLE public."Lines" DROP COLUMN "labelY";
ALTER TABLE public."Lines" DROP COLUMN "labelRotation";
ALTER TABLE public."Lines" DROP COLUMN "labelLoadingX";
ALTER TABLE public."Lines" DROP COLUMN "labelLoadingY";
ALTER TABLE public."Lines" DROP COLUMN "labelLoadingRotation";
ALTER TABLE public."RestrictionPolygons" DROP COLUMN "labelX";
ALTER TABLE public."RestrictionPolygons" DROP COLUMN "labelY";
ALTER TABLE public."RestrictionPolygons" DROP COLUMN "labelRotation";
ALTER TABLE public."Bays" DROP COLUMN "label_X";
ALTER TABLE public."Bays" DROP COLUMN "label_Y";
ALTER TABLE public."Bays" DROP COLUMN "label_Rotation";

-- Function to regenerate the leaders based on the label positions
CREATE OR REPLACE FUNCTION update_leader_fct() RETURNS trigger SECURITY DEFINER AS $$
    declare
        i integer := 0;
        pnt public.geometry;
    BEGIN
        NEW."label_leader" := ST_SetSRID(ST_Multi(ST_GeomFromText('LINESTRING EMPTY')), 27700);
        WHILE i < ST_NumGeometries(NEW."label_pos") LOOP
            i := i + 1;
            pnt := ST_GeometryN(NEW."label_pos", i);
            NEW."label_leader" := ST_Multi(
                ST_Union(
                    NEW."label_leader",
                    ST_MakeLine(pnt, ST_ClosestPoint(NEW."geom", pnt))
                )
            );
        END LOOP;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

-- same as above, but for both label_leader and label_loading_leader
CREATE OR REPLACE FUNCTION update_leader_lines_fct() RETURNS trigger SECURITY DEFINER AS $$
    declare
        i integer := 0;
        pnt public.geometry;
    BEGIN
        NEW."label_leader" := ST_SetSRID(ST_Multi(ST_GeomFromText('LINESTRING EMPTY')), 27700);
        WHILE i < ST_NumGeometries(NEW."label_pos") LOOP
            i := i + 1;
            pnt := ST_GeometryN(NEW."label_pos", i);
            NEW."label_leader" := ST_Multi(
                ST_Union(
                    NEW."label_leader",
                    ST_MakeLine(pnt, ST_ClosestPoint(NEW."geom", pnt))
                )
            );
        END LOOP;

        i := 0;
        NEW."label_loading_leader" := ST_SetSRID(ST_Multi(ST_GeomFromText('LINESTRING EMPTY')), 27700);
        WHILE i < ST_NumGeometries(NEW."label_loading_pos") LOOP
            i := i + 1;
            pnt := ST_GeometryN(NEW."label_loading_pos", i);
            NEW."label_loading_leader" := ST_Multi(
                ST_Union(
                    NEW."label_loading_leader",
                    ST_MakeLine(pnt, ST_ClosestPoint(NEW."geom", pnt))
                )
            );
        END LOOP;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

-- Create the triggers
CREATE TRIGGER update_leader BEFORE INSERT OR UPDATE ON public."Bays" FOR EACH ROW -- disabled as we want to update all using geom=geom WHEN (OLD.geom <> NEW.geom OR OLD."label_pos" <> NEW."label_pos")
EXECUTE PROCEDURE update_leader_fct();
CREATE TRIGGER update_leader BEFORE INSERT OR UPDATE ON public."Lines" FOR EACH ROW -- disabled as we want to update all using geom=geom WHEN (OLD.geom <> NEW.geom OR OLD."label_pos" <> NEW."label_pos" OR OLD."label_loading_pos" <> NEW."label_loading_pos")
EXECUTE PROCEDURE update_leader_lines_fct();
CREATE TRIGGER update_leader BEFORE INSERT OR UPDATE ON public."Signs" FOR EACH ROW -- disabled as we want to update all using geom=geom WHEN (OLD.geom <> NEW.geom OR OLD."label_pos" <> NEW."label_pos")
EXECUTE PROCEDURE update_leader_fct();
CREATE TRIGGER update_leader BEFORE INSERT OR UPDATE ON public."RestrictionPolygons" FOR EACH ROW -- disabled as we want to update all using geom=geom WHEN (OLD.geom <> NEW.geom OR OLD."label_pos" <> NEW."label_pos")
EXECUTE PROCEDURE update_leader_fct();
CREATE TRIGGER update_leader BEFORE INSERT OR UPDATE ON public."CPZs" FOR EACH ROW -- disabled as we want to update all using geom=geom WHEN (OLD.geom <> NEW.geom OR OLD."label_pos" <> NEW."label_pos")
EXECUTE PROCEDURE update_leader_fct();
CREATE TRIGGER update_leader BEFORE INSERT OR UPDATE ON public."ParkingTariffAreas" FOR EACH ROW -- disabled as we want to update all using geom=geom WHEN (OLD.geom <> NEW.geom OR OLD."label_pos" <> NEW."label_pos")
EXECUTE PROCEDURE update_leader_fct();

-- run the trigger on all rows
--UPDATE public."Bays" SET geom = geom;
UPDATE public."Lines" SET geom = geom;
--UPDATE public."Signs" SET geom = geom;
--UPDATE public."RestrictionPolygons" SET geom = geom;
--UPDATE public."CPZs" SET geom = geom;
--UPDATE public."ParkingTariffAreas" SET geom = geom;
