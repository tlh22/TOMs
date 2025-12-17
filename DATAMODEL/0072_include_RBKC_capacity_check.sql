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
	 cycleWidth real := 0.1;
	 cornerProtectionDistance real := 0.0;
	 busLength real := 0.0;
	 RBKC_formula real := 0.0;
	 restrictionLength real := 0.0;
	 fieldCheck boolean := false;
	 NrCorners INTEGER := 0;
	 availableLength real := 0;
	 narrow_length real := 0;
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

    select "Value" into cycleWidth
        from "mhtc_operations"."project_parameters"
        where "Field" = 'CycleWidth';

    select "Value" into cornerProtectionDistance
        from "mhtc_operations"."project_parameters"
        where "Field" = 'CornerProtectionDistance';

    select "Value" into busLength
        from "mhtc_operations"."project_parameters"
        where "Field" = 'BusLength';

    select "Value" into RBKC_formula
        from "mhtc_operations"."project_parameters"
        where "Field" = 'RBKC_capacity_formula';
		
    IF vehicleLength IS NULL OR vehicleWidth IS NULL OR motorcycleWidth IS NULL 
		OR cycleWidth IS NULL OR busLength IS NULL OR RBKC_formula IS NULL THEN
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
            IF COALESCE(NEW."UnacceptableTypeID", 0) > 0 THEN
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
		168 = E-scooter and Dockless Bicycle Bay
		169 = Shared Use Bicycle and Motorcycle Permit Holders Bay
        **/

        WHEN NEW."RestrictionTypeID" IN (117,118) THEN NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/motorcycleWidth);
        WHEN NEW."RestrictionTypeID" IN (119,168,169) THEN NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/cycleWidth);
		--- WHEN NEW."RestrictionTypeID" IN (109) THEN NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/busLength);  --- treat bus only bays the same as any other bays (mainly because they can be used outside of hours by anyone)
        WHEN NEW."RestrictionTypeID" < 200 THEN  -- May need to specify the bay types to be used
            CASE WHEN NEW."RestrictionTypeID" IN (107, 116, 122, 144, 146, 147, 149, 150, 151) THEN NEW."Capacity" = 0;
                 ELSE
                    CASE WHEN NEW."NrBays" >= 0 THEN NEW."Capacity" = NEW."NrBays";
                     ELSE
                         CASE
                             WHEN RBKC_formula > 0.0 THEN  -- RBKC formula to be used if value set to > 0
							 
                                 CASE
                                     WHEN NEW."GeomShapeID" IN (4,5, 6, 24, 25, 26) THEN 
										CASE WHEN public.ST_Length (NEW."geom") <=(vehicleWidth) THEN NEW."Capacity" = 1;
										     ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleWidth);
										END CASE;
                                     WHEN NEW."RestrictionLength" >=(vehicleLength*4) THEN
                                         CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength-1.0) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                                              ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                                         END CASE;
                                     WHEN public.ST_Length (NEW."geom") <=(vehicleLength) THEN NEW."Capacity" = 1;
                                     ELSE
                                         CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength*0.9) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                                              ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                                         END CASE;
                                 END CASE;
								 
                             ELSE  -- using strict vehicle length/width values
							 						 
                                 CASE
                                     WHEN NEW."GeomShapeID" IN (4,5, 6, 24, 25, 26) THEN 
										CASE WHEN public.ST_Length (NEW."geom") <=(vehicleWidth) THEN NEW."Capacity" = 1;
										     ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleWidth);
										END CASE;
                                     WHEN public.ST_Length (NEW."geom") <=(vehicleLength) THEN NEW."Capacity" = 1;
                                     ELSE
										NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                                 END CASE; 
								 
								 --RAISE NOTICE '***** GeometryID (%); length %; capacity: %', NEW."GeometryID", public.ST_Length (NEW."geom")::numeric, NEW."Capacity";
								 
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

            CASE WHEN NEW."RestrictionTypeID" IN (201, 203, 207, 208, 216, 217, 224, 225, 226, 227, 229) THEN
                     -- Consider only short bays, i.e., < 5.0m
                     CASE WHEN COALESCE(NEW."UnacceptableTypeID", 0) > 0 THEN
                              NEW."Capacity" = 0;
                              --NEW."NrBays" = 0;
                          /** WHEN public.ST_Length (NEW."geom")::numeric < vehicleLength AND public.ST_Length (NEW."geom")::numeric > (vehicleLength*0.9) THEN
                              NEW."Capacity" = 1; **/
                              --  /** this considers "just short" lengths **/ CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength*0.9) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);

							 /***
							 SELECT COUNT(c.id) INTO NrCorners
							 FROM mhtc_operations."Corners" AS c
							 WHERE ST_Intersects(ST_Buffer(c.geom, 0.001), NEW.geom);

							 availableLength = public.ST_Length (NEW."geom")::numeric - NrCorners::numeric * cornerProtectionDistance;

							 -- Consider narrow roads
							 
							SELECT TRUE INTO fieldCheck
							FROM information_schema.columns
							WHERE table_schema = TG_TABLE_SCHEMA
							AND table_name = TG_TABLE_NAME
							AND column_name = 'IntersectionWithin49m';

							IF fieldCheck THEN
							
								narrow_length = COALESCE(NEW."IntersectionWithin49m", 0) + (COALESCE(NEW."IntersectionWithin67m", 0) - COALESCE(NEW."IntersectionWithin49m", 0))/2.0;
								availableLength = availableLength - COALESCE(narrow_length, 0.0);
							
							END IF;

							 CASE WHEN availableLength <= (vehicleLength*0.9) THEN
									NEW."Capacity" = 0;
								  WHEN availableLength < vehicleLength AND availableLength > (vehicleLength*0.9) THEN
									NEW."Capacity" = 1;
								  ELSE NEW."Capacity" = FLOOR(availableLength/vehicleLength);
								  END CASE;

							 RAISE NOTICE '***** GeometryID (%); length %; avail %; cnrs: %; capacity: %', NEW."GeometryID", public.ST_Length (NEW."geom")::numeric, availableLength, NrCorners, NEW."Capacity";
							***/

                     END CASE;

				 /**
				 203 = ZigZag - School
				 207 = ZigZag - Hospital
				 208 = ZigZag - Yellow (Other)
				 **/
				/***
				 WHEN NEW."RestrictionTypeID" IN (203, 207, 208) THEN
                     -- Consider only short bays, i.e., < 5.0m
                     CASE WHEN COALESCE(NEW."UnacceptableTypeID", 0) > 0 THEN
                              NEW."Capacity" = 0;
                              NEW."NrBays" = 0;
                          ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);

                     END CASE;
				***/

                 WHEN NEW."RestrictionTypeID" IN (1000) THEN   -- sections

                    IF NEW."NrBays" >= 0 THEN
                        NEW."Capacity" = NEW."NrBays";
                    ELSE

                        IF cornerProtectionDistance IS NULL THEN
                            RAISE EXCEPTION 'Capacity parameters not available ...';
                            RETURN OLD;
                        END IF;

                         SELECT COUNT(c.id) INTO NrCorners
                         FROM mhtc_operations."Corners" AS c
                         WHERE ST_Intersects(ST_Buffer(c.geom, 0.001), NEW.geom);

                         availableLength = public.ST_Length (NEW."geom")::numeric - NrCorners::numeric * cornerProtectionDistance;

                         -- TODO: Need to take account of perpendicular/echelon parking

						-- Consider narrow roads
						 
						SELECT TRUE INTO fieldCheck
						FROM information_schema.columns
						WHERE table_schema = TG_TABLE_SCHEMA
						AND table_name = TG_TABLE_NAME
						AND column_name = 'IntersectionWithin49m';

						IF fieldCheck THEN
						
							narrow_length = COALESCE(NEW."IntersectionWithin49m", 0) + (COALESCE(NEW."IntersectionWithin67m", 0) - COALESCE(NEW."IntersectionWithin49m", 0))/2.0;
							availableLength = availableLength - COALESCE(narrow_length, 0.0);
						
						END IF;

                         CASE WHEN availableLength <= (vehicleLength*0.9) THEN
                                NEW."Capacity" = 0;
                              WHEN availableLength < vehicleLength AND availableLength > (vehicleLength*0.9) THEN
                                NEW."Capacity" = 1;
                              WHEN NEW."NrBays" > 0 THEN NEW."Capacity" = NEW."NrBays";
                              WHEN NEW."NrBays" = -2 THEN NEW."Capacity" = FLOOR(availableLength/vehicleWidth);
                              --  /** this considers "just short" lengths **/ CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength*0.9) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                              ELSE NEW."Capacity" = FLOOR(availableLength/vehicleLength);
                              END CASE;

                         RAISE NOTICE '***** GeometryID (%); length %; avail %; cnrs: %; capacity: %', NEW."GeometryID", public.ST_Length (NEW."geom")::numeric, availableLength, NrCorners, NEW."Capacity";

                    END IF;

                 ELSE
                    RAISE NOTICE '-- Considering GeometryID (%); RestrictionTypeID: (%)', NEW."GeometryID", NEW."RestrictionTypeID";
                    NEW."Capacity" = 0;
                 END CASE;

        END CASE;

	RETURN NEW;

END;
$$;
