-- Populate ...

INSERT INTO "highway_asset_lookups"."AssetConditionTypes" ("Code", "Description") VALUES (4, 'Unknown');
INSERT INTO "highway_asset_lookups"."AssetConditionTypes" ("Code", "Description") VALUES (5, 'Not Visited');
INSERT INTO "highway_asset_lookups"."AssetConditionTypes" ("Code", "Description") VALUES (6, 'Removed (not present)');

INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Description") VALUES ('Building');

ALTER TABLE local_authority."ISL_Electrical_Items" DISABLE TRIGGER "set_last_update_details_ISL_Electrical_Items";

UPDATE local_authority."ISL_Electrical_Items"
SET "LastUpdateDateTime" = TIMESTAMP WITH TIME ZONE '2020-07-01',
    "LastUpdatePerson" = 'Islington';

UPDATE local_authority."ISL_Electrical_Items"
SET "RestrictionID" = uuid_generate_v4();

UPDATE local_authority."ISL_Electrical_Items"
SET "GeometryID" = concat('EI_', to_char(nextval('local_authority."ISL_Electrical_Items_id_seq"'::regclass), '00000000'::text));

UPDATE local_authority."ISL_Electrical_Items"
SET "GeometryID" = concat('EI_', to_char("id", 'fm000000000'));

UPDATE local_authority."ISL_Electrical_Items"
SET "AssetConditionTypeID" = 4;

ALTER TABLE local_authority."ISL_Electrical_Items" ENABLE TRIGGER "set_last_update_details_ISL_Electrical_Items";

