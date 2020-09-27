-- Add capacity to Bays and Lines + add table to hold parameters ??

ALTER TABLE toms."Bays"
    ADD COLUMN "Capacity" integer;

ALTER TABLE toms."Lines"
    ADD COLUMN "Capacity" integer;

CREATE TABLE "mhtc_operations"."project_parameters" (
    "Field" character varying NOT NULL,
    "Value" character varying NOT NULL
);


CREATE OR REPLACE FUNCTION "public"."update_capacity"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	 vehicleLength real := 0.0;
	 vehicleWidth real := 0.0;
	 motorcycleWidth real := 0.0;
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

-- TODO: raise error if these fields are not available

    CASE
        WHEN NEW."RestrictionTypeID" IN (117,118) THEN NEW."Capacity" = FLOOR(NEW."RestrictionLength"/motorcycleWidth);
        WHEN NEW."RestrictionTypeID" < 200 THEN
            CASE WHEN NEW."NrBays" > 0 THEN NEW."Capacity" = NEW."NrBays";
                 WHEN NEW."GeomShapeID" IN (4,5, 6, 24, 25, 26) THEN NEW."Capacity" = FLOOR(NEW."RestrictionLength"/vehicleWidth);
                 WHEN NEW."RestrictionLength" >=(vehicleLength*4) THEN
                     CASE WHEN MOD(NEW."RestrictionLength"::numeric, vehicleLength::numeric) > (vehicleLength-1.0) THEN NEW."Capacity" = CEILING(NEW."RestrictionLength"/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(NEW."RestrictionLength"/vehicleLength);
                          END CASE;
                 WHEN NEW."RestrictionLength" <=(vehicleLength-1) THEN NEW."Capacity" = 1;
                 ELSE
                     CASE WHEN MOD(NEW."RestrictionLength"::numeric, vehicleLength::numeric) > (vehicleLength-1.0) THEN NEW."Capacity" = CEILING(NEW."RestrictionLength"/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(NEW."RestrictionLength"/vehicleLength);
                          END CASE;
            END CASE;
        ELSE
            CASE WHEN NEW."RestrictionTypeID" IN (201, 216, 217, 224, 225) THEN
                     CASE WHEN MOD(NEW."RestrictionLength"::numeric, vehicleLength::numeric) > (vehicleLength-1.0) THEN NEW."Capacity" = CEILING(NEW."RestrictionLength"/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(NEW."RestrictionLength"/vehicleLength);
                          END CASE;
                 ELSE NEW."Capacity" = 0;
                 END CASE;
        END CASE;

	RETURN NEW;

END;
$$;

CREATE TRIGGER "update_capacity_bays" BEFORE INSERT ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."update_capacity"();
CREATE TRIGGER "update_capacity_lines" BEFORE INSERT ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."update_capacity"();