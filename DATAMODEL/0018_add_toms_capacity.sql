-- Add capacity to Bays and Lines + add table to hold parameters ??

ALTER TABLE toms."Bays"
    ADD COLUMN "Capacity" integer;

ALTER TABLE toms."Lines"
    ADD COLUMN "Capacity" integer;

CREATE TABLE "mhtc_operations"."project_parameters" (
    "Field" character varying NOT NULL,
    "Value" character varying NOT NULL
);

ALTER TABLE ONLY "mhtc_operations"."project_parameters"
    ADD CONSTRAINT "project_parameters_pkey" PRIMARY KEY ("Field");

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE "mhtc_operations"."project_parameters" TO toms_admin;
GRANT SELECT, USAGE ON SEQUENCE "mhtc_operations"."project_parameters" TO toms_operator, toms_public;

-- main trigger

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

    IF

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

CREATE TRIGGER "update_capacity_bays" BEFORE INSERT OR UPDATE OF "RestrictionLength", "NrBays" ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."update_capacity"();
CREATE TRIGGER "update_capacity_lines" BEFORE INSERT OR UPDATE OF "RestrictionLength" ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."update_capacity"();

-- Do complete revision if change parameters

CREATE OR REPLACE FUNCTION "public"."revise_all_capacities"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	 vehicleLength real := 0.0;
	 vehicleWidth real := 0.0;
	 motorcycleWidth real := 0.0;
BEGIN

    IF NEW."Field" = 'VehicleLength' OR  NEW."Field" = 'VehicleWidth' OR NEW."Field" = 'MotorcycleWidth' THEN
        UPDATE "toms"."Bays" SET "RestrictionLength" = ROUND(public.ST_Length ("geom")::numeric,2);
        UPDATE "toms"."Lines" SET "RestrictionLength" = ROUND(public.ST_Length ("geom")::numeric,2);
    END IF;

	RETURN NEW;

END;
$$;

CREATE TRIGGER "update_capacity_all" BEFORE INSERT OR UPDATE ON "mhtc_operations"."project_parameters" FOR EACH ROW EXECUTE FUNCTION "public"."revise_all_capacities"();

-- modify RestrictionLength triggers to be just on geom

DROP TRIGGER "set_restriction_length_Bays" ON "toms"."Bays";
CREATE TRIGGER "set_restriction_length_Bays" BEFORE INSERT OR UPDATE OF geom ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_restriction_length"();

DROP TRIGGER "set_restriction_length_Lines" ON "toms"."Lines";
CREATE TRIGGER "set_restriction_length_Lines" BEFORE INSERT OR UPDATE OF geom ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_restriction_length"();