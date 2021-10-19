/***
Update trigger to deal with short bays
***/

-- main trigger

CREATE OR REPLACE FUNCTION "public"."update_capacity"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	 vehicleLength real := 0.0;
	 vehicleWidth real := 0.0;
	 motorcycleWidth real := 0.0;
	 restrictionLength real := 0.0;
BEGIN

    select "Value" into vehicleLength
        from "mhtc_operations"."project_parameters"
        where "Field" = 'VehicleLength';

    select "Value" into vehicleWidth
        from "mhtc_operations"."project_parameters"
        where "Field" = 'VehicleWidth';

    select "Value" into motorcycleWidth
        from "mhtc_operations"."project_parameters"
        where "Field" = 'MotorcycleWidth';

    IF vehicleLength IS NULL OR vehicleWidth IS NULL OR motorcycleWidth IS NULL THEN
        RAISE EXCEPTION 'Capacity parameters not available ...';
        RETURN OLD;
    END IF;

    -- Deal with short bays

    IF NEW."RestrictionTypeID" < 200 THEN
	    IF NEW."NrBays" < 0 AND
             NEW."GeomShapeID" IN (1, 2, 3, 21, 22, 23) AND
             public.ST_Length (NEW."geom") <= vehicleLength THEN   -- all the parallel bay types
                NEW."Capacity" = 1;
                NEW."NrBays" = 1;
		END IF;
    END IF;

    CASE
        /**
        107 = Bus Stop
        116 = Cycle Hire Bay
        122 = Bus Stand
        146 = Keep Clear area
        147 = Cycle Hangar
        150 = Parklet
        151 = Market trading Bay
        **/
        WHEN NEW."RestrictionTypeID" IN (117,118) THEN NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/motorcycleWidth);
        WHEN NEW."RestrictionTypeID" < 200 THEN  -- May need to specify the bay types to be used
            CASE WHEN NEW."NrBays" > 0 THEN NEW."Capacity" = NEW."NrBays";
                 WHEN NEW."GeomShapeID" IN (4,5, 6, 24, 25, 26) THEN NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleWidth);
                 WHEN NEW."RestrictionLength" >=(vehicleLength*4) THEN
                     CASE WHEN NEW."GeomShapeID" IN (4,5, 6, 24, 25, 26) THEN NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleWidth);
					      WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength-1.0) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                          END CASE;
                 WHEN public.ST_Length (NEW."geom") <=(vehicleLength-1.0) THEN NEW."Capacity" = 1;
                 ELSE
                     CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength*0.9) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                          END CASE;
            END CASE;
        ELSE

             /**
             201 = SYL (Acceptable)
             216 = Unmarked Area (Acceptable)
             217 = SRL (Acceptable)
             224 = SYL
             225 = Unmarked Area
             226 = SRL
             227 = Unmarked Kerbline within PPZ (Acceptable)
             229 = Unmarked Kerbline within PPZ
             **/

            CASE WHEN NEW."RestrictionTypeID" IN (201, 216, 217, 224, 225, 226, 227, 229) THEN
                     CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength*0.9) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                          END CASE;
                 ELSE NEW."Capacity" = 0;
                 END CASE;

        END CASE;

	RETURN NEW;

END;
$$;
