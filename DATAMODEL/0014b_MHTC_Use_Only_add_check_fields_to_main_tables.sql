-- Adding FieldCheckedCompleted  TODO: split between different sections ...
ALTER TABLE highway_assets."HighwayAssets"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE highway_assets."HighwayAssets"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);
ALTER TABLE highway_assets."HighwayAssets"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE moving_traffic."Restrictions"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE moving_traffic."Restrictions"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE moving_traffic."Restrictions"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE toms."Bays"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE toms."Bays"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);
ALTER TABLE toms."Bays"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE toms."Lines"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE toms."Lines"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);
ALTER TABLE toms."Lines"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE toms."Signs"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE toms."Signs"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);
ALTER TABLE toms."Signs"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);
ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;


/**
DROP these columns
---

ALTER TABLE highway_assets."HighwayAssets"
    DROP COLUMN "Last_MHTC_Check_UpdateDateTime";
ALTER TABLE highway_assets."HighwayAssets"
    DROP COLUMN "Last_MHTC_Check_UpdatePerson";
ALTER TABLE highway_assets."HighwayAssets"
    DROP COLUMN "FieldCheckCompleted";

ALTER TABLE moving_traffic."Restrictions"
    DROP COLUMN "FieldCheckCompleted";
ALTER TABLE moving_traffic."Restrictions"
    DROP COLUMN "Last_MHTC_Check_UpdateDateTime";
ALTER TABLE moving_traffic."Restrictions"
    DROP COLUMN "Last_MHTC_Check_UpdatePerson";

ALTER TABLE toms."Bays"
    DROP COLUMN "Last_MHTC_Check_UpdateDateTime";
ALTER TABLE toms."Bays"
    DROP COLUMN "Last_MHTC_Check_UpdatePerson";
ALTER TABLE toms."Bays"
    DROP COLUMN "FieldCheckCompleted";

ALTER TABLE toms."Lines"
    DROP COLUMN "Last_MHTC_Check_UpdateDateTime";
ALTER TABLE toms."Lines"
    DROP COLUMN "Last_MHTC_Check_UpdatePerson";
ALTER TABLE toms."Lines"
    DROP COLUMN "FieldCheckCompleted";

ALTER TABLE toms."Signs"
    DROP COLUMN "Last_MHTC_Check_UpdateDateTime";
ALTER TABLE toms."Signs"
    DROP COLUMN "Last_MHTC_Check_UpdatePerson";
ALTER TABLE toms."Signs"
    DROP COLUMN "FieldCheckCompleted";

ALTER TABLE toms."RestrictionPolygons"
    DROP COLUMN "Last_MHTC_Check_UpdateDateTime";
ALTER TABLE toms."RestrictionPolygons"
    DROP COLUMN "Last_MHTC_Check_UpdatePerson";
ALTER TABLE toms."RestrictionPolygons"
    DROP COLUMN "FieldCheckCompleted";

**/