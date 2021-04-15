-- Allow highway_assets to be loaded into QGIS

ALTER TABLE highway_assets."HighwayAssets"
    ADD COLUMN id SERIAL;

ALTER TABLE highway_assets."HighwayAssets"
    DROP CONSTRAINT "HighwayAssets_pkey";

ALTER TABLE ONLY "highway_assets"."HighwayAssets"
    ADD CONSTRAINT "HighwayAssets_pkey" PRIMARY KEY ("id");

--  add FKs for AssetConditionTypes

ALTER TABLE ONLY "highway_assets"."Benches"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."Bins"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."Bollards"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."BusShelters"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CCTV_Cameras"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CommunicationCabinets"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CrossingPoints"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CycleParking"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."DisplayBoards"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."EV_ChargingPoints"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."EndOfStreetMarkings"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."PedestrianRailings"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."StreetNamePlates"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."SubterraneanFeatures"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."TrafficCalming"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."TrafficSignals"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

ALTER TABLE ONLY "highway_assets"."VehicleBarriers"
    ADD CONSTRAINT "HighwayAssets_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");

--  add FKs for MHTC_CheckIssueTypes

ALTER TABLE ONLY "highway_assets"."Benches"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."Bins"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."Bollards"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."BusShelters"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CCTV_Cameras"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CommunicationCabinets"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CrossingPoints"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."CycleParking"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."DisplayBoards"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."EV_ChargingPoints"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."EndOfStreetMarkings"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."PedestrianRailings"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."StreetNamePlates"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."SubterraneanFeatures"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."TrafficCalming"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."TrafficSignals"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "highway_assets"."VehicleBarriers"
   ADD CONSTRAINT "HighwayAssets_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");



