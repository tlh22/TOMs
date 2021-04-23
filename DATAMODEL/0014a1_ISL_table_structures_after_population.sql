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

-- include description ...
ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN "Type_Description" SET NOT NULL;
    
ALTER TABLE local_authority."ISL_Electrical_Items" ENABLE TRIGGER "set_last_update_details_ISL_Electrical_Items";

-- Adding FieldCheckedCompleted  TODO: split between different sections ...

ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE local_authority."EVCP_Asset_Register"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE local_authority."EVCP_Asset_Register"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

