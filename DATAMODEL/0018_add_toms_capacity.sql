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
GRANT SELECT ON TABLE "mhtc_operations"."project_parameters" TO toms_operator, toms_public;

--
--DROP FUNCTION IF EXISTS mhtc_operations."getParameter";

CREATE OR REPLACE FUNCTION mhtc_operations."getParameter"(param text) RETURNS text AS
'SELECT "Value"
FROM mhtc_operations."project_parameters"
WHERE "Field" = $1'
LANGUAGE SQL;

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

    CASE
        WHEN NEW."RestrictionTypeID" IN (107, 116, 122, 146, 147, 150, 151) THEN NEW."Capacity" = 0;
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
                     CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength-1.0) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                          END CASE;
                 WHEN public.ST_Length (NEW."geom") <=(vehicleLength-1.0) THEN NEW."Capacity" = 1;
                 ELSE
                     CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength-0.5) THEN NEW."Capacity" = CEILING(public.ST_Length (NEW."geom")/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                          END CASE;
            END CASE;
        ELSE
            CASE WHEN NEW."RestrictionTypeID" IN (201, 216, 217, 224, 225, 226) THEN
                     CASE WHEN MOD(public.ST_Length (NEW."geom")::numeric, vehicleLength::numeric) > (vehicleLength-0.5) THEN NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                          ELSE NEW."Capacity" = FLOOR(public.ST_Length (NEW."geom")/vehicleLength);
                          END CASE;
                 ELSE NEW."Capacity" = 0;
                 END CASE;
             /**
             201 = SYL (Acceptable)
             216 = Unmarked Area (Acceptable)
             217 = SRL (Acceptable)
             224 = SYL
             225 = Unmarked Area
             226 = SRL
             **/
        END CASE;

	RETURN NEW;

END;
$$;

CREATE TRIGGER "update_capacity_bays" BEFORE INSERT OR UPDATE ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."update_capacity"();
CREATE TRIGGER "update_capacity_lines" BEFORE INSERT OR UPDATE ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."update_capacity"();

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

CREATE TRIGGER "update_capacity_all" AFTER UPDATE ON "mhtc_operations"."project_parameters" FOR EACH ROW EXECUTE FUNCTION "public"."revise_all_capacities"();

-- modify RestrictionLength triggers to be just on geom

DROP TRIGGER "set_restriction_length_Bays" ON "toms"."Bays";
CREATE TRIGGER "set_restriction_length_Bays" BEFORE INSERT OR UPDATE OF geom ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_restriction_length"();

DROP TRIGGER "set_restriction_length_Lines" ON "toms"."Lines";
CREATE TRIGGER "set_restriction_length_Lines" BEFORE INSERT OR UPDATE OF geom ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_restriction_length"();