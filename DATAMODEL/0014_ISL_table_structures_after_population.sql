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

ALTER TABLE highway_assets."CommunicationCabinets"
    ALTER COLUMN "CommunicationCabinetTypeID" DROP NOT NULL;

ALTER TABLE highway_assets."VehicleBarriers"
    ALTER COLUMN "VehicleBarrierTypeID" DROP NOT NULL;

ALTER TABLE highway_assets."UnidentifiedStaticObjects"
    ADD PRIMARY KEY ("RestrictionID");

-- Adding FieldCheckedCompleted  TODO: split between different sections ...
ALTER TABLE highway_assets."HighwayAssets"
    ADD COLUMN "FieldCheckCompleted" boolean;
ALTER TABLE moving_traffic."Restrictions"
    ADD COLUMN "FieldCheckCompleted" boolean;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "FieldCheckCompleted" boolean;
ALTER TABLE local_authority."EVCP_Asset_Register"
    ADD COLUMN "FieldCheckCompleted" boolean;
ALTER TABLE toms."Bays"
    ADD COLUMN "FieldCheckCompleted" boolean;
ALTER TABLE toms."Lines"
    ADD COLUMN "FieldCheckCompleted" boolean;
ALTER TABLE toms."Signs"
    ADD COLUMN "FieldCheckCompleted" boolean;
ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "FieldCheckCompleted" boolean;

ALTER TABLE highway_assets."HighwayAssets"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE highway_assets."HighwayAssets"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE moving_traffic."Restrictions"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE moving_traffic."Restrictions"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE local_authority."EVCP_Asset_Register"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE local_authority."EVCP_Asset_Register"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE toms."Bays"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE toms."Bays"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE toms."Lines"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE toms."Lines"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE toms."Signs"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE toms."Signs"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);
