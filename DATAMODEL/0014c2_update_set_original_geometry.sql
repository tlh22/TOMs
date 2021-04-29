-- FUNCTION: public.set_original_geometry()

-- DROP FUNCTION public.set_original_geometry();

CREATE OR REPLACE FUNCTION public.set_original_geometry()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
        -- Copy geometry to originalGeometry
		IF (TG_OP = 'UPDATE') THEN
			-- Check to see whether or not the point has been moved
			RAISE NOTICE 'geom values are: %, %', ST_AsText(ST_QuantizeCoordinates(NEW."geom", 3)), ST_AsText(ST_QuantizeCoordinates(OLD."geom", 3));
			IF ST_AsText(ST_QuantizeCoordinates(NEW."geom", 3)) != ST_AsText(ST_QuantizeCoordinates(OLD."geom", 3)) THEN
				NEW."original_geom_wkt" := ST_AsText(NEW."geom");
			END IF;
		ELSIF (TG_OP = 'INSERT') THEN
        	NEW."original_geom_wkt" := ST_AsText(NEW."geom");
		END IF;

        RETURN NEW;
    END;
$BODY$;

ALTER FUNCTION public.set_original_geometry()
    OWNER TO postgres;


