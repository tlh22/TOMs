-- Deal with crossing geometry types

CREATE OR REPLACE FUNCTION public.set_crossing_geom_type()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
    DECLARE
        restriction_id          text;
		restriction_type_id     integer;
        geom_shape_id			integer;
        geom_shape_group_type	text;
        restrictionLength       real;
    BEGIN

		restriction_type_id = NEW."RestrictionTypeID";
		geom_shape_id = NEW."GeomShapeID";
		-- RAISE NOTICE '% is restriction_type_id', restriction_type_id;

		SELECT ST_Length (NEW."geom") INTO restrictionLength;

		-- RAISE NOTICE  '% is restrictionLength', restrictionLength;
		-- RAISE NOTICE  '% is geom_shape_id 1', geom_shape_id;

		IF (restriction_type_id >= 209 AND restriction_type_id <= 215 AND restrictionLength > 5.0 AND geom_shape_id < 100) THEN
		    geom_shape_id = 12;
		END IF;

		-- RAISE NOTICE  '% is geom_shape_id 2', geom_shape_id;

		NEW."GeomShapeID" := geom_shape_id;
        RETURN NEW;
    END;
$BODY$;

--DROP TRIGGER IF EXISTS "set_crossing_geom_type_trigger" ON "toms"."Lines";
CREATE TRIGGER "set_crossing_geom_type_trigger" BEFORE INSERT ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_crossing_geom_type"();

-- update existing crossings
UPDATE "toms"."Lines"
SET "GeomShapeID" = 12
WHERE "RestrictionTypeID" >= 209 AND "RestrictionTypeID" <= 215
AND  ST_Length("geom") > 5.0;

-- pick up an old issue for bays
UPDATE "toms"."Bays"
SET "GeomShapeID" = 21
WHERE "RestrictionTypeID" IN (101)
AND  "GeomShapeID" = 1;