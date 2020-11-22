-- Add create time to all tables

ALTER TABLE "moving_traffic"."Restrictions"
    ADD COLUMN "CreateDateTime" timestamp without time zone,
    ADD COLUMN "CreatePerson" character varying(255);

-- populate fields

SET session_replication_role = replica;  -- Disable all triggers

UPDATE "moving_traffic"."Restrictions"
SET "CreateDateTime" = "LastUpdateDateTime",
    "CreatePerson" = "LastUpdatePerson";

SET session_replication_role = DEFAULT;  -- Enable all triggers

-- set to NOT NULL and set up trigger

--
ALTER TABLE "moving_traffic"."Restrictions"
    ALTER COLUMN "CreateDateTime" SET NOT NULL;
ALTER TABLE "moving_traffic"."Restrictions"
    ALTER COLUMN "CreatePerson" SET NOT NULL;

CREATE TRIGGER "set_create_details_access_restrictions" BEFORE INSERT ON "moving_traffic"."AccessRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_carriageway_markings" BEFORE INSERT ON "moving_traffic"."CarriagewayMarkings" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_highway_dedications" BEFORE INSERT ON "moving_traffic"."HighwayDedications" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_restrictions_for_vehicles" BEFORE INSERT ON "moving_traffic"."RestrictionsForVehicles" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_special_designations" BEFORE INSERT ON "moving_traffic"."SpecialDesignations" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_turn_restrictions" BEFORE INSERT ON "moving_traffic"."TurnRestrictions" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_mhtc_RoadLinks" BEFORE INSERT ON "highways_network"."MHTC_RoadLinks" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();
