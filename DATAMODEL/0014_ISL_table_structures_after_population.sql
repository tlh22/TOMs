-- adhoc local authority assets

ALTER TABLE local_authority."ISL_Electrical_Items" DISABLE TRIGGER "set_last_update_details_ISL_Electrical_Items";

ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN geom SET NOT NULL;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN "LastUpdateDateTime" SET NOT NULL;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN "LastUpdatePerson" SET NOT NULL;

ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN "GeometryID" SET NOT NULL;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN "RestrictionID" SET NOT NULL;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN "AssetConditionTypeID" SET NOT NULL;

ALTER TABLE local_authority."ISL_Electrical_Items" ENABLE TRIGGER "set_last_update_details_ISL_Electrical_Items";