/**
Adds field to TOMs restrictions to allow turn on/off of label. This avoid multiple labels/leaders being shown for the same restrictions that are in close proximity
**/

ALTER TABLE toms."Bays"
    ADD COLUMN "DisplayLabel" boolean DEFAULT TRUE NOT NULL;

ALTER TABLE toms."Lines"
    ADD COLUMN "DisplayLabel" boolean DEFAULT TRUE NOT NULL;

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "DisplayLabel" boolean DEFAULT TRUE NOT NULL;

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "DisplayLabel" boolean DEFAULT TRUE NOT NULL;

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "DisplayLabel" boolean DEFAULT TRUE NOT NULL;

ALTER TABLE toms."MatchDayEventDayZones"
    ADD COLUMN "DisplayLabel" boolean DEFAULT TRUE NOT NULL;

/**
remedial actions ...

ALTER TABLE toms."Bays" ALTER COLUMN "DisplayLabel" drop not null;
ALTER TABLE toms."Lines" ALTER COLUMN "DisplayLabel" drop not null;
ALTER TABLE toms."RestrictionPolygons" ALTER COLUMN "DisplayLabel" drop not null;
ALTER TABLE toms."ControlledParkingZones" ALTER COLUMN "DisplayLabel" drop not null;
ALTER TABLE toms."ParkingTariffAreas" ALTER COLUMN "DisplayLabel" drop not null;
ALTER TABLE toms."MatchDayEventDayZones" ALTER COLUMN "DisplayLabel" drop not null;


UPDATE toms."Bays"
SET "DisplayLabel" = 'true'
WHERE "DisplayLabel" IS NULL;

ALTER TABLE toms."Bays"
    ALTER COLUMN "DisplayLabel" SET NOT NULL;

ALTER TABLE toms."Bays"
    ALTER COLUMN "DisplayLabel" SET DEFAULT 'true';
***/

/**
For some reason, the DEFAULT value is not being set. Hence trigger ...
**/

CREATE OR REPLACE FUNCTION toms.set_label_display_default()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
    BEGIN

        IF NEW."DisplayLabel" IS NULL THEN
            NEW."DisplayLabel" := true;
        END IF;

        RETURN NEW;
    END;
$BODY$;

CREATE TRIGGER "set_label_display_default_Bays" BEFORE INSERT ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "toms"."set_label_display_default"();
CREATE TRIGGER "set_label_display_default_Lines" BEFORE INSERT ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "toms"."set_label_display_default"();
CREATE TRIGGER "set_label_display_default_RestrictionPolygons" BEFORE INSERT ON "toms"."RestrictionPolygons" FOR EACH ROW EXECUTE FUNCTION "toms"."set_label_display_default"();
CREATE TRIGGER "set_label_display_default_ControlledParkingZones" BEFORE INSERT ON "toms"."ControlledParkingZones" FOR EACH ROW EXECUTE FUNCTION "toms"."set_label_display_default"();
CREATE TRIGGER "set_label_display_default_ParkingTariffAreas" BEFORE INSERT ON "toms"."ParkingTariffAreas" FOR EACH ROW EXECUTE FUNCTION "toms"."set_label_display_default"();
CREATE TRIGGER "set_label_display_default_MatchDayEventDayZones" BEFORE INSERT ON "toms"."MatchDayEventDayZones" FOR EACH ROW EXECUTE FUNCTION "toms"."set_label_display_default"();
