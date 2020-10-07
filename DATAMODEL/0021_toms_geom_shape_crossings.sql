-- Deal with bay geometry types

CREATE OR REPLACE FUNCTION public.set_crossing_geom_type()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
    DECLARE
        restriction_id          text;
        geom_shape_id			integer;
        geom_shape_group_type	text;
        restrictionLength       double;
    BEGIN

		restriction_id = NEW."RestrictionID";
		geom_shape_id = NEW."GeomShapeID";
		--RAISE NOTICE '% is restrictionID', NEW."RestrictionID";

		SELECT ST_Length (NEW."geom") INTO restrictionLength;

		--RAISE NOTICE  '% is geom_shape_group_type', geom_shape_group_type;
		--RAISE NOTICE  '% is geom_shape_id 1', geom_shape_id;

		IF (NEW."GeomShapeID" >= 200 AND NEW."GeomShapeID" <= 215 AND restrictionLength > 5.0) THEN
		    geom_shape_id = 12;
		END IF;

		--RAISE NOTICE  '% is geom_shape_id 2', geom_shape_id;

		NEW."GeomShapeID" := geom_shape_id;
        RETURN NEW;
    END;
$BODY$;

DROP TRIGGER IF EXISTS "set_crossing_geom_type" ON "toms"."Lines";
CREATE TRIGGER "set_crossing_geom_type_trigger" BEFORE INSERT ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_crossing_geom_type"();

