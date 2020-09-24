-- Add create time to all tables
ALTER TABLE toms."Bays"
    ADD COLUMN "CreateDateTime" timestamp without time zone,
    ADD COLUMN "CreatePerson" character varying(255);

ALTER TABLE toms."Lines"
    ADD COLUMN "CreateDateTime" timestamp without time zone,
    ADD COLUMN "CreatePerson" character varying(255);

ALTER TABLE toms."Signs"
    ADD COLUMN "CreateDateTime" timestamp without time zone,
    ADD COLUMN "CreatePerson" character varying(255);

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "CreateDateTime" timestamp without time zone,
    ADD COLUMN "CreatePerson" character varying(255);

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "CreateDateTime" timestamp without time zone,
    ADD COLUMN "CreatePerson" character varying(255);

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "CreateDateTime" timestamp without time zone,
    ADD COLUMN "CreatePerson" character varying(255);

-- populate fields

SET session_replication_role = replica;  -- Disable all triggers

UPDATE toms."Bays"
SET "CreateDateTime" = "LastUpdateDateTime",
    "CreatePerson" = "LastUpdatePerson";

UPDATE toms."Lines"
SET "CreateDateTime" = "LastUpdateDateTime",
    "CreatePerson" = "LastUpdatePerson";

UPDATE toms."Signs"
SET "CreateDateTime" = "LastUpdateDateTime",
    "CreatePerson" = "LastUpdatePerson";

UPDATE toms."RestrictionPolygons"
SET "CreateDateTime" = "LastUpdateDateTime",
    "CreatePerson" = "LastUpdatePerson";

UPDATE toms."ControlledParkingZones"
SET "CreateDateTime" = "LastUpdateDateTime",
    "CreatePerson" = "LastUpdatePerson";

UPDATE toms."ParkingTariffAreas"
SET "CreateDateTime" = "LastUpdateDateTime",
    "CreatePerson" = "LastUpdatePerson";

SET session_replication_role = DEFAULT;  -- Enable all triggers

-- set to NOT NULL and set up trigger

CREATE FUNCTION public.set_create_details()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
    BEGIN
	    -- round to two decimal places
        NEW."CreateDateTime" := now();
        NEW."CreatePerson" := current_user;

        RETURN NEW;
    END;
$BODY$;

ALTER FUNCTION public.set_create_details()
    OWNER TO postgres;

ALTER TABLE toms."Bays"
    ALTER COLUMN "CreateDateTime" SET NOT NULL;
ALTER TABLE toms."Bays"
    ALTER COLUMN "CreatePerson" SET NOT NULL;

CREATE TRIGGER "set_create_details_Bays" BEFORE INSERT OR UPDATE ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

ALTER TABLE toms."Lines"
    ALTER COLUMN "CreateDateTime" SET NOT NULL;
ALTER TABLE toms."Lines"
    ALTER COLUMN "CreatePerson" SET NOT NULL;

CREATE TRIGGER "set_create_details_Lines" BEFORE INSERT OR UPDATE ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

ALTER TABLE toms."Signs"
    ALTER COLUMN "CreateDateTime" SET NOT NULL;
ALTER TABLE toms."Signs"
    ALTER COLUMN "CreatePerson" SET NOT NULL;

CREATE TRIGGER "set_create_details_Signs" BEFORE INSERT OR UPDATE ON "toms"."Signs" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

ALTER TABLE toms."RestrictionPolygons"
    ALTER COLUMN "CreateDateTime" SET NOT NULL;
ALTER TABLE toms."RestrictionPolygons"
    ALTER COLUMN "CreatePerson" SET NOT NULL;

CREATE TRIGGER "set_create_details_RestrictionPolygons" BEFORE INSERT OR UPDATE ON "toms"."RestrictionPolygons" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

ALTER TABLE toms."ControlledParkingZones"
    ALTER COLUMN "CreateDateTime" SET NOT NULL;
ALTER TABLE toms."ControlledParkingZones"
    ALTER COLUMN "CreatePerson" SET NOT NULL;

CREATE TRIGGER "set_create_details_ControlledParkingZones" BEFORE INSERT OR UPDATE ON "toms"."ControlledParkingZones" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

ALTER TABLE toms."ParkingTariffAreas"
    ALTER COLUMN "CreateDateTime" SET NOT NULL;
ALTER TABLE toms."ParkingTariffAreas"
    ALTER COLUMN "CreatePerson" SET NOT NULL;

CREATE TRIGGER "set_create_details_ParkingTariffAreas" BEFORE INSERT OR UPDATE ON "toms"."ParkingTariffAreas" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();
