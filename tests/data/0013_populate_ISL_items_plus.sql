-- Populate ...

INSERT INTO "highway_asset_lookups"."AssetConditionTypes" ("Code", "Description") VALUES (4, 'Unknown');
INSERT INTO "highway_asset_lookups"."AssetConditionTypes" ("Code", "Description") VALUES (5, 'Not Visited');
INSERT INTO "highway_asset_lookups"."AssetConditionTypes" ("Code", "Description") VALUES (6, 'Removed (not present)');

--
INSERT INTO "highway_asset_lookups"."BridgeTypes" ("Code", "Description") VALUES (1, 'Road');
INSERT INTO "highway_asset_lookups"."BridgeTypes" ("Code", "Description") VALUES (2, 'Rail');
INSERT INTO "highway_asset_lookups"."BridgeTypes" ("Code", "Description") VALUES (3, 'Pedestrian');

-- *** DATA items ***

UPDATE local_authority."EVCP_Asset_Register"
SET "LastUpdateDateTime" = TIMESTAMP WITH TIME ZONE '2020-07-01',
    "LastUpdatePerson" = 'Islington';
