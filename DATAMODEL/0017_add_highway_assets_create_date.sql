-- Add create time to all tables

ALTER TABLE "highway_assets"."HighwayAssets"
    ADD COLUMN "CreateDateTime" timestamp without time zone,
    ADD COLUMN "CreatePerson" character varying(255);

-- populate fields

SET session_replication_role = replica;  -- Disable all triggers

UPDATE "highway_assets"."HighwayAssets"
SET "CreateDateTime" = "LastUpdateDateTime",
    "CreatePerson" = "LastUpdatePerson";

SET session_replication_role = DEFAULT;  -- Enable all triggers

-- set to NOT NULL and set up trigger

ALTER TABLE "highway_assets"."HighwayAssets"
    ALTER COLUMN "CreateDateTime" SET NOT NULL;
ALTER TABLE "highway_assets"."HighwayAssets"
    ALTER COLUMN "CreatePerson" SET NOT NULL;

CREATE TRIGGER "set_create_details_Postboxes" BEFORE INSERT ON "highway_assets"."Postboxes" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_TelephoneBoxes" BEFORE INSERT ON "highway_assets"."TelephoneBoxes" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_Benches" BEFORE INSERT ON "highway_assets"."Benches" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_Bins" BEFORE INSERT ON "highway_assets"."Bins" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_Bollards" BEFORE INSERT ON "highway_assets"."Bollards" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_BusShelters" BEFORE INSERT ON "highway_assets"."BusShelters" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_CCTV_Cameras" BEFORE INSERT ON "highway_assets"."CCTV_Cameras" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_CommunicationCabinets" BEFORE INSERT ON "highway_assets"."CommunicationCabinets" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_CrossingPoints" BEFORE INSERT ON "highway_assets"."CrossingPoints" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_CycleParking" BEFORE INSERT ON "highway_assets"."CycleParking" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_DisplayBoards" BEFORE INSERT ON "highway_assets"."DisplayBoards" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_EV_ChargingPoints" BEFORE INSERT ON "highway_assets"."EV_ChargingPoints" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_EndOfStreetMarkings" BEFORE INSERT ON "highway_assets"."EndOfStreetMarkings" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_PedestrianRailings" BEFORE INSERT ON "highway_assets"."PedestrianRailings" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_StreetNamePlates" BEFORE INSERT ON "highway_assets"."StreetNamePlates" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_SubterraneanFeatures" BEFORE INSERT ON "highway_assets"."SubterraneanFeatures" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_TrafficCalming" BEFORE INSERT ON "highway_assets"."TrafficCalming" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_TrafficSignals" BEFORE INSERT ON "highway_assets"."TrafficSignals" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_UnidentifiedStaticObjects" BEFORE INSERT ON "highway_assets"."UnidentifiedStaticObjects" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_VehicleBarriers" BEFORE INSERT ON "highway_assets"."VehicleBarriers" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_BusStopSigns" BEFORE INSERT ON "highway_assets"."BusStopSigns" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_telegraph_poles" BEFORE INSERT ON "highway_assets"."TelegraphPoles" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

CREATE TRIGGER "set_create_details_bridges" BEFORE INSERT ON "highway_assets"."Bridges" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();
