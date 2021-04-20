-- Allow highway_assets to be loaded into QGIS

ALTER TABLE highway_assets."HighwayAssets"
    ADD COLUMN id SERIAL;

ALTER TABLE highway_assets."HighwayAssets"
    DROP CONSTRAINT "HighwayAssets_pkey";

ALTER TABLE ONLY "highway_assets"."HighwayAssets"
    ADD CONSTRAINT "HighwayAssets_pkey" PRIMARY KEY ("id");

--  add FKs for AssetConditionTypes

ALTER TABLE ONLY "highway_assets"."Benches"
    ADD CONSTRAINT "Benches_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."Bins"
    ADD CONSTRAINT "Bins_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."Bollards"
    ADD CONSTRAINT "Bollards_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."BusShelters"
    ADD CONSTRAINT "BusShelters_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CCTV_Cameras"
    ADD CONSTRAINT "CCTV_Cameras_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CommunicationCabinets"
    ADD CONSTRAINT "CommunicationCabinets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CrossingPoints"
    ADD CONSTRAINT "CrossingPoints_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CycleParking"
    ADD CONSTRAINT "CycleParking_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."DisplayBoards"
    ADD CONSTRAINT "DisplayBoards_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."EV_ChargingPoints"
    ADD CONSTRAINT "EV_ChargingPoints_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."EndOfStreetMarkings"
    ADD CONSTRAINT "EndOfStreetMarkings_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."PedestrianRailings"
    ADD CONSTRAINT "PedestrianRailings_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."StreetNamePlates"
    ADD CONSTRAINT "StreetNamePlates_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."SubterraneanFeatures"
    ADD CONSTRAINT "SubterraneanFeatures_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."TrafficCalming"
    ADD CONSTRAINT "TrafficCalming_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."TrafficSignals"
    ADD CONSTRAINT "TrafficSignals_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."VehicleBarriers"
    ADD CONSTRAINT "VehicleBarriers_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

--  add FKs for MHTC_CheckIssueTypes

ALTER TABLE ONLY "highway_assets"."Benches"
   ADD CONSTRAINT "Benches_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."Bins"
   ADD CONSTRAINT "Bins_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."Bollards"
   ADD CONSTRAINT "Bollards_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."BusShelters"
   ADD CONSTRAINT "BusShelters_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CCTV_Cameras"
   ADD CONSTRAINT "CCTV_Cameras_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CommunicationCabinets"
   ADD CONSTRAINT "CommunicationCabinets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CrossingPoints"
   ADD CONSTRAINT "CrossingPoints_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CycleParking"
   ADD CONSTRAINT "CycleParking_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."DisplayBoards"
   ADD CONSTRAINT "DisplayBoards_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."EV_ChargingPoints"
   ADD CONSTRAINT "EV_ChargingPoints_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."EndOfStreetMarkings"
   ADD CONSTRAINT "EndOfStreetMarkings_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."PedestrianRailings"
   ADD CONSTRAINT "PedestrianRailings_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."StreetNamePlates"
   ADD CONSTRAINT "StreetNamePlates_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."SubterraneanFeatures"
   ADD CONSTRAINT "SubterraneanFeatures_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."TrafficCalming"
   ADD CONSTRAINT "TrafficCalming_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."TrafficSignals"
   ADD CONSTRAINT "TrafficSignals_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."VehicleBarriers"
   ADD CONSTRAINT "VehicleBarriers_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");



