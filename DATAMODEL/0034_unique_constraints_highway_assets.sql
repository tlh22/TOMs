-- Add unique constaint for GeometryID to highway_asset tables

/*
ALTER TABLE ONLY "highway_assets"."Benches"
     ADD CONSTRAINT "Benches_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."Bins"
     ADD CONSTRAINT "Bins_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."Bollards"
    ADD CONSTRAINT "Bollards_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."BusShelters"
    ADD CONSTRAINT "BusShelters_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."CCTV_Cameras"
     ADD CONSTRAINT "CCTV_Cameras_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."CommunicationCabinets"
     ADD CONSTRAINT "CommunicationCabinets_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."CrossingPoints"
    ADD CONSTRAINT "CrossingPoints_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."CycleParking"
    ADD CONSTRAINT "CycleParking_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."DisplayBoards"
    ADD CONSTRAINT "DisplayBoards_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."EV_ChargingPoints"
    ADD CONSTRAINT "EV_ChargingPoints_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."EndOfStreetMarkings"
    ADD CONSTRAINT "EndOfStreetMarkings_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."PedestrianRailings"
     ADD CONSTRAINT "PedestrianRailings_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."StreetNamePlates"
     ADD CONSTRAINT "StreetNamePlates_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."SubterraneanFeatures"
     ADD CONSTRAINT "SubterraneanFeatures_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."TrafficCalming"
     ADD CONSTRAINT "TrafficCalming_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."TrafficSignals"
     ADD CONSTRAINT "TrafficSignals_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highway_assets"."VehicleBarriers"
     ADD CONSTRAINT "VehicleBarriers_GeometryID_key" UNIQUE ("GeometryID");
*/

-- Change default details ...

ALTER TABLE ONLY "highway_assets"."Benches"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('BE_', to_char(nextval('highway_assets."Benches_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."Bins"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('BE_', to_char(nextval('highway_assets."Bins_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."Bollards"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('BO_', to_char(nextval('highway_assets."Bollards_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."Bridges"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('BR_', to_char(nextval('highway_assets."Bridges_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."BusShelters"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('BS_', to_char(nextval('highway_assets."BusShelters_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."BusStopSigns"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('BU_', to_char(nextval('highway_assets."BusStopSigns_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."CCTV_Cameras"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('CT_', to_char(nextval('highway_assets."CCTV_Cameras_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."CommunicationCabinets"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('CC_', to_char(nextval('highway_assets."CommunicationCabinets_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."CrossingPoints"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('CR_', to_char(nextval('highway_assets."CrossingPoints_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."CycleParking"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('CY_', to_char(nextval('highway_assets."CycleParking_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."DisplayBoards"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('DB_', to_char(nextval('highway_assets."DisplayBoards_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."EV_ChargingPoints"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('EV_', to_char(nextval('highway_assets."EV_ChargingPoints_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."EndOfStreetMarkings"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('ES_', to_char(nextval('highway_assets."EndOfStreetMarkings_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."PedestrianRailings"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('PR_', to_char(nextval('highway_assets."PedestrianRailings_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."Postboxes"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('PO_', to_char(nextval('highway_assets."Postboxes_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."StreetNamePlates"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('SN_', to_char(nextval('highway_assets."StreetNamePlates_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."TelephoneBoxes"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('TE_', to_char(nextval('highway_assets."TelephoneBoxes_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."TelegraphPoles"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('TP_', to_char(nextval('highway_assets."TelegraphPoles_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."SubterraneanFeatures"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('SF_', to_char(nextval('highway_assets."SubterraneanFeatures_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."TrafficCalming"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('TC_', to_char(nextval('highway_assets."TrafficCalming_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."TrafficSignals"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('TS_', to_char(nextval('highway_assets."TrafficSignals_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."UnidentifiedStaticObjects"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('US_', to_char(nextval('highway_assets."UnidentifiedStaticObjects_id_seq"'::regclass), 'FM0000000'::"text"));

ALTER TABLE ONLY "highway_assets"."VehicleBarriers"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('VB_', to_char(nextval('highway_assets."VehicleBarriers_id_seq"'::regclass), 'FM0000000'::"text"));
