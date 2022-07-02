/***
Update trigger to deal with short bays - and bays in front of crossovers
***/

-- main trigger

CREATE OR REPLACE FUNCTION "public"."update_capacity"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	 vehicleLength real := 0.0;
	 vehicleWidth real := 0.0;
	 motorcycleWidth real := 0.0;
	 cornerProtectionDistance real := 0.0;
	 restrictionLength real := 0.0;
	 fieldCheck boolean := false;
	 NrCorners INTEGER := 0;
	 availableLength real := 0;
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

    select "Value" into cornerProtectionDistance
        from "mhtc_operations"."project_parameters"
        where "Field" = 'CornerProtectionDistance';

    IF vehicleLength IS NULL OR vehicleWidth IS NULL OR motorcycleWidth IS NULL THEN
        RAISE EXCEPTION 'Capacity parameters not available ...';
        RETURN OLD;
    END IF;

    -- Deal with short bays and crossovers in front of bays

    IF NEW."RestrictionTypeID" < 200 THEN

        -- Check that there is a column called "UnacceptableTypeID"

		--RAISE NOTICE '***** In TG_TABLE_SCHEMA (%)', TG_TABLE_SCHEMA;
		--RAISE NOTICE '***** In TG_TABLE_NAME (%)', TG_TABLE_NAME;

        SELECT TRUE INTO fieldCheck
        FROM information_schema.columns
        WHERE table_schema = TG_TABLE_SCHEMA
        AND table_name = TG_TABLE_NAME
        AND column_name = 'UnacceptableTypeID';

        IF fieldCheck THEN
            IF NEW."UnacceptableTypeID" IN (1,4,11) THEN
                    NEW."Capacity" = 0;
                    NEW."NrBays" = 0;
            END IF;
		END IF;

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
            CASE WHEN NEW."NrBays" >= 0 THEN NEW."Capacity" = NEW."NrBays";
                 ELSE
                     CASE WHEN NEW."RestrictionTypeID" IN (107, 116, 122, 146, 147, 150, 151) THEN
                        NEW."Capacity" = 0;
                     ELSE
                         CASE
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
                     -- Consider only short bays, i.e., < 5.0m
                     CASE WHEN public.ST_Length (NEW."geom")::numeric < vehicleLength AND public.ST_Length (NEW."geom")::numeric > (vehicleLength*0.9) THEN
                          NEW."Capacity" = 1;
                          --  /** this considers "just short" lengths **/ CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength*0.9) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                          END CASE;

                 WHEN NEW."RestrictionTypeID" IN (1000) THEN   -- sections

                    IF cornerProtectionDistance IS NULL THEN
                        RAISE EXCEPTION 'Capacity parameters not available ...';
                        RETURN OLD;
                    END IF;

                     SELECT COUNT(c.id) INTO NrCorners
                     FROM mhtc_operations."Corners" AS c
                     WHERE ST_Intersects(ST_Buffer(c.geom, 0.001), NEW.geom);

                     availableLength = public.ST_Length (NEW."geom")::numeric - NrCorners * cornerProtectionDistance;

                     -- TODO: Need to take account of perpendicular/echelon parking
                     
                     CASE WHEN availableLength < vehicleLength AND availableLength > (vehicleLength*0.9) THEN
                          NEW."Capacity" = 1;
                          WHEN NEW."GeomShapeID" IN (4,5, 6, 24, 25, 26) THEN NEW."Capacity" = FLOOR(availableLength/vehicleWidth);
                          --  /** this considers "just short" lengths **/ CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength*0.9) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(availableLength/vehicleLength);
                          END CASE;

                     RAISE NOTICE '***** GeometryID (%); length %; cnrs: %; capacity: %', NEW."GeometryID", public.ST_Length (NEW."geom")::numeric, NrCorners, NEW."Capacity";

                 ELSE NEW."Capacity" = 0;
                 END CASE;

        END CASE;

	RETURN NEW;

END;
$$;
