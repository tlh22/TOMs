
---- *** Change structure of tables  ***
-- Bays

ALTER TABLE toms."Bays" DROP CONSTRAINT "Bays_pkey1";

ALTER TABLE toms."Bays" DROP COLUMN id;

ALTER TABLE toms."Bays" RENAME COLUMN "Length" TO "RestrictionLength";
--ALTER TABLE toms."Bays" ALTER COLUMN "RestrictionLength" SET NOT NULL;

ALTER TABLE toms."Bays" RENAME COLUMN "Bays_DateTime" TO "LastUpdateDateTime";

--ALTER TABLE toms."Bays" RENAME COLUMN "BaysWordingID" TO "AdditionalConditionID";

ALTER TABLE toms."Bays" RENAME COLUMN "Surveyor" TO "LastUpdatePerson" ;
UPDATE toms."Bays" SET "LastUpdatePerson" = 'MHTC' WHERE "LastUpdatePerson" IS NULL;
ALTER TABLE toms."Bays"
    ALTER COLUMN "LastUpdatePerson" SET NOT NULL;

ALTER TABLE toms."Bays" DROP COLUMN "BaysGeometry";

--ALTER TABLE toms."Bays" DROP COLUMN "Bays_PhotoTaken";

ALTER TABLE toms."Bays"
    ADD COLUMN "ComplianceRoadMarkingsFaded" integer;
--ALTER TABLE toms."Bays" RENAME COLUMN "Compl_Bays_Faded" TO "ComplianceRoadMarkingsFaded";

ALTER TABLE toms."Bays"
    ADD COLUMN "ComplianceRestrictionSignIssue" integer;
--ALTER TABLE toms."Bays" RENAME COLUMN "Compl_Bays_SignIssue" TO "ComplianceRestrictionSignIssue";

ALTER TABLE toms."Bays" DROP COLUMN "Bays_Photos_01";

ALTER TABLE toms."Bays" DROP COLUMN "Bays_Photos_02";

--ALTER TABLE toms."Bays" DROP COLUMN "OriginalGeomShapeID";

--ALTER TABLE toms."Bays" DROP COLUMN "GeometryID_181017";

ALTER TABLE toms."Bays"
   ALTER COLUMN "GeometryID" TYPE character varying(12) COLLATE pg_catalog."default";
ALTER TABLE toms."Bays"
    ALTER COLUMN "GeometryID" SET DEFAULT ('B_'::text || to_char(nextval('toms."Bays_id_seq"'::regclass), 'FM0000000'::text));

ALTER TABLE toms."Bays"
    ALTER COLUMN "RestrictionTypeID" SET NOT NULL;

ALTER TABLE toms."Bays"
    ALTER COLUMN "GeomShapeID" SET NOT NULL;

ALTER TABLE toms."Bays"
    ALTER COLUMN "NrBays" SET NOT NULL;

ALTER TABLE toms."Bays"
    ALTER COLUMN "TimePeriodID" SET NOT NULL;

--ALTER TABLE toms."Bays"
--    ADD COLUMN "Photos_03" character varying(255) COLLATE pg_catalog."default";

ALTER TABLE toms."Bays"
    ADD COLUMN "ComplianceNotes" character varying(254) COLLATE pg_catalog."default";

--ALTER TABLE toms."Bays"
--    ADD COLUMN "MHTC_CheckIssueTypeID" integer;

--ALTER TABLE toms."Bays"
--    ADD COLUMN "MHTC_CheckNotes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."Bays"
    ADD CONSTRAINT "Bays_pkey" PRIMARY KEY ("RestrictionID");

ALTER TABLE toms."Bays"
    ADD CONSTRAINT "Bays_GeometryID_key" UNIQUE ("GeometryID");

CREATE INDEX "idx_Bays_GeomShapeID"
    ON toms."Bays"("GeomShapeID");

CREATE INDEX "idx_Bays_RestrictionTypeID"
    ON toms."Bays"("RestrictionTypeID");

CREATE INDEX "idx_TimePeriodID"
    ON toms."Bays"("TimePeriodID");

ALTER TABLE toms."Bays"
    ADD CONSTRAINT "Bays_AdditionalConditionID_fkey" FOREIGN KEY ("AdditionalConditionID")
    REFERENCES toms_lookups."AdditionalConditionTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_AdditionalConditionID"
    ON toms."Bays"("AdditionalConditionID");

ALTER TABLE toms."Bays"
    ADD CONSTRAINT "Bays_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue")
    REFERENCES compliance_lookups."BaysLines_SignIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Bays_ComplianceRestrictionSignIssue"
    ON toms."Bays"("ComplianceRestrictionSignIssue");

ALTER TABLE toms."Bays"
    ADD CONSTRAINT "Bays_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded")
    REFERENCES compliance_lookups."BaysLinesFadedTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Bays_ComplianceRoadMarkingsFaded"
    ON toms."Bays"("ComplianceRoadMarkingsFaded");

ALTER TABLE toms."Bays"
    ADD CONSTRAINT "Bays_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID")
    REFERENCES compliance_lookups."MHTC_CheckIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Bays_MHTC_CheckIssueTypeID"
    ON toms."Bays"("MHTC_CheckIssueTypeID");

UPDATE toms."Bays"  -- deal with nulls
   SET "MaxStayID" = 12
   WHERE "MaxStayID" = 0;

ALTER TABLE toms."Bays"
    ADD CONSTRAINT "Bays_MaxStayID_fkey" FOREIGN KEY ("MaxStayID")
    REFERENCES toms_lookups."LengthOfTime" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Bays_MaxStayID"
    ON toms."Bays"("MaxStayID");

UPDATE toms."Bays"  -- deal with nulls
   SET "NoReturnID" = 12
   WHERE "NoReturnID" = 0;

ALTER TABLE toms."Bays"
    ADD CONSTRAINT "Bays_NoReturnID_fkey" FOREIGN KEY ("NoReturnID")
    REFERENCES toms_lookups."LengthOfTime" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
CREATE INDEX "idx_Bays_NoReturnID"
    ON toms."Bays"("NoReturnID");

UPDATE toms."Bays"  -- deal with nulls
   SET "PayTypeID" = 1
   WHERE "PayTypeID" = 0;

ALTER TABLE toms."Bays"
    ADD CONSTRAINT "Bays_PayTypeID_fkey" FOREIGN KEY ("PayTypeID")
    REFERENCES toms_lookups."PaymentTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Bays_PayTypeID"
    ON toms."Bays"("PayTypeID");

-- *** ControlledParkingZones
ALTER TABLE toms."ControlledParkingZones" DROP COLUMN gid;

ALTER TABLE toms."ControlledParkingZones" DROP COLUMN cacz_ref_n;

ALTER TABLE toms."ControlledParkingZones" DROP COLUMN date_last_;

ALTER TABLE toms."ControlledParkingZones" DROP COLUMN no_osp_spa;

ALTER TABLE toms."ControlledParkingZones" DROP COLUMN no_pnr_spa;

ALTER TABLE toms."ControlledParkingZones" DROP COLUMN no_pub_spa;

ALTER TABLE toms."ControlledParkingZones" DROP COLUMN no_res_spa;

-- ALTER TABLE toms."ControlledParkingZones" RENAME COLUMN zone_no TO "CPZ";

ALTER TABLE toms."ControlledParkingZones" DROP COLUMN type;

ALTER TABLE toms."ControlledParkingZones" RENAME COLUMN "WaitingTimeID" TO "TimePeriodID";

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "RestrictionID" character varying(254);

ALTER TABLE toms."ControlledParkingZones"
    ALTER COLUMN "GeometryID" TYPE character varying(12) COLLATE pg_catalog."default";
ALTER TABLE toms."ControlledParkingZones"
    ALTER COLUMN "GeometryID" SET DEFAULT ('C_'::text || to_char(nextval('toms."ControlledParkingZones_id_seq"'::regclass), 'FM0000000'::text));

ALTER TABLE toms."ControlledParkingZones"
    ALTER COLUMN "GeometryID" SET NOT NULL;

ALTER TABLE toms."ControlledParkingZones"
    ALTER COLUMN geom SET NOT NULL;

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "RestrictionTypeID" integer NOT NULL DEFAULT 20;

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "Notes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "Photos_01" character varying(255) COLLATE pg_catalog."default";

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "Photos_02" character varying(255) COLLATE pg_catalog."default";

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "Photos_03" character varying(255) COLLATE pg_catalog."default";

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "label_X" double precision;

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "label_Y" double precision;

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "label_Rotation" double precision;

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "label_TextChanged" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "LastUpdateDateTime" timestamp without time zone;

UPDATE toms."ControlledParkingZones" SET "LastUpdateDateTime" = "OpenDate";

UPDATE toms."ControlledParkingZones" SET "LastUpdateDateTime" = '2019-01-01'::date
WHERE "LastUpdateDateTime" IS NULL;

ALTER TABLE toms."ControlledParkingZones"
    ALTER COLUMN "LastUpdateDateTime" SET NOT NULL;

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "LastUpdatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL DEFAULT 'CEC';

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "LabelText" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "ComplianceRoadMarkingsFaded" integer;

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "ComplianceRestrictionSignIssue" integer;

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "ComplianceNotes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "MHTC_CheckIssueTypeID" integer;

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "MHTC_CheckNotes" character varying(254) COLLATE pg_catalog."default";
--ALTER TABLE toms."ControlledParkingZones"
--    ADD CONSTRAINT "ControlledParkingZones_pkey" PRIMARY KEY ("RestrictionID");

ALTER TABLE toms."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE toms."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue")
    REFERENCES compliance_lookups."BaysLines_SignIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ControlledParkingZones_ComplianceRestrictionSignIssue"
    ON toms."ControlledParkingZones"("ComplianceRestrictionSignIssue");

ALTER TABLE toms."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded")
    REFERENCES compliance_lookups."BaysLinesFadedTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ControlledParkingZones_ComplianceRoadMarkingsFaded"
    ON toms."ControlledParkingZones"("ComplianceRoadMarkingsFaded");

ALTER TABLE toms."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID")
    REFERENCES compliance_lookups."MHTC_CheckIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ControlledParkingZones_MHTC_CheckIssueTypeID"
    ON toms."ControlledParkingZones"("MHTC_CheckIssueTypeID");

ALTER TABLE toms."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID")
    REFERENCES toms_lookups."RestrictionPolygonTypesInUse" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ControlledParkingZones_RestrictionTypeID"
    ON toms."ControlledParkingZones"("RestrictionTypeID");

ALTER TABLE toms."ControlledParkingZones"
    ADD CONSTRAINT "ControlledParkingZones_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID")
    REFERENCES toms_lookups."TimePeriods" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ControlledParkingZones_TimePeriodID"
    ON toms."ControlledParkingZones"("TimePeriodID");

-- Lines

ALTER TABLE toms."Lines" DROP CONSTRAINT "Lines_pkey1";
ALTER TABLE toms."Lines" DROP COLUMN id;

ALTER TABLE toms."Lines" RENAME COLUMN "Length" TO "RestrictionLength";
ALTER TABLE toms."Lines" ALTER COLUMN "RestrictionLength" SET NOT NULL;

ALTER TABLE toms."Lines" RENAME COLUMN "Lines_DateTime" TO "LastUpdateDateTime";

ALTER TABLE toms."Lines" RENAME COLUMN "Surveyor" TO "LastUpdatePerson" ;
UPDATE toms."Lines" SET "LastUpdatePerson" = 'MHTC' WHERE "LastUpdatePerson" IS NULL;
ALTER TABLE toms."Lines"
    ALTER COLUMN "LastUpdatePerson" SET NOT NULL;

ALTER TABLE toms."Lines" RENAME COLUMN "Compl_Lines_Faded" TO "ComplianceRoadMarkingsFaded";

ALTER TABLE toms."Lines" RENAME COLUMN "Compl_Lines_SignIssue" TO "ComplianceRestrictionSignIssue";

ALTER TABLE toms."Lines" RENAME COLUMN "Lines_Photos_01" TO "Photos_01";

ALTER TABLE toms."Lines" RENAME COLUMN "Lines_Photos_02" TO "Photos_02";

ALTER TABLE toms."Lines" RENAME COLUMN "Lines_Photos_03" TO "Photos_03";

ALTER TABLE toms."Lines" DROP COLUMN "Compl_NoL_Faded";  -- TODO: Check whether or not this is used ...

ALTER TABLE toms."Lines" RENAME COLUMN "labelX" TO "label_X";

ALTER TABLE toms."Lines" RENAME COLUMN "labelY" TO "label_Y";

ALTER TABLE toms."Lines" RENAME COLUMN "labelRotation" TO "label_Rotation";

ALTER TABLE toms."Lines" RENAME COLUMN "Unacceptability" TO "UnacceptableTypeID";

ALTER TABLE toms."Lines" RENAME COLUMN "labelLoadingX" TO "labelLoading_X";

ALTER TABLE toms."Lines" RENAME COLUMN "labelLoadingY" TO "labelLoading_Y";

ALTER TABLE toms."Lines" RENAME COLUMN "labelLoadingRotation" TO "labelLoading_Rotation";

ALTER TABLE toms."Lines" DROP COLUMN "TRO_Status_180409";

ALTER TABLE toms."Lines" DROP COLUMN "GeometryID_181017";

ALTER TABLE toms."Lines"
    ALTER COLUMN "GeometryID" TYPE character varying(12) COLLATE pg_catalog."default";
ALTER TABLE toms."Lines"
    ALTER COLUMN "GeometryID" SET DEFAULT ('L_'::text || to_char(nextval('toms."Lines_id_seq"'::regclass), 'FM0000000'::text));

ALTER TABLE toms."Lines"
    ALTER COLUMN "RestrictionTypeID" SET NOT NULL;

ALTER TABLE toms."Lines"
    ALTER COLUMN "GeomShapeID" SET NOT NULL;

ALTER TABLE toms."Lines"
    ADD COLUMN "label_TextChanged" character varying(254) COLLATE pg_catalog."default";

/*
ALTER TABLE toms."Lines"
    ADD COLUMN "AdditionalConditionID" integer;
*/

ALTER TABLE toms."Lines"
    ADD COLUMN "ComplianceNotes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."Lines"
    ADD COLUMN "MHTC_CheckIssueTypeID" integer;

ALTER TABLE toms."Lines"
    ADD COLUMN "MHTC_CheckNotes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."Lines"
    ADD CONSTRAINT "Lines_pkey" PRIMARY KEY ("RestrictionID");

ALTER TABLE toms."Lines"
    ADD CONSTRAINT "Lines_GeometryID_key" UNIQUE ("GeometryID");

CREATE INDEX "idx_Lines_GeomShapeID"
    ON toms."Lines"("GeomShapeID");

CREATE INDEX "idx_NoWaitingTimeID"
    ON toms."Lines"("NoWaitingTimeID");

CREATE INDEX "idx_Lines_RestrictionTypeID"
    ON toms."Lines"("RestrictionTypeID");

ALTER TABLE toms."Lines"
    ADD CONSTRAINT "Lines_AdditionalConditionID_fkey" FOREIGN KEY ("AdditionalConditionID")
    REFERENCES toms_lookups."AdditionalConditionTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Lines_AdditionalConditionID"
    ON toms."Lines"("AdditionalConditionID");

ALTER TABLE toms."Lines"
    ADD CONSTRAINT "Lines_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue")
    REFERENCES compliance_lookups."BaysLines_SignIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Lines_ComplianceRestrictionSignIssue"
    ON toms."Lines"("ComplianceRestrictionSignIssue");

ALTER TABLE toms."Lines"
    ADD CONSTRAINT "Lines_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded")
    REFERENCES compliance_lookups."BaysLinesFadedTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Lines_ComplianceRoadMarkingsFaded"
    ON toms."Lines"("ComplianceRoadMarkingsFaded");

ALTER TABLE toms."Lines"
    ADD CONSTRAINT "Lines_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID")
    REFERENCES compliance_lookups."MHTC_CheckIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Lines_MHTC_CheckIssueTypeID"
    ON toms."Lines"("MHTC_CheckIssueTypeID");

ALTER TABLE toms."Lines"
    ADD CONSTRAINT "Lines_NoLoadingTimeID_fkey" FOREIGN KEY ("NoLoadingTimeID")
    REFERENCES toms_lookups."TimePeriodsInUse" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Lines_NoLoadingTimeID"
    ON toms."Lines"("NoLoadingTimeID");

ALTER TABLE toms."Lines"
    ADD CONSTRAINT "Lines_UnacceptableTypeID_fkey" FOREIGN KEY ("UnacceptableTypeID")
    REFERENCES toms_lookups."UnacceptableTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Lines_UnacceptableTypeID"
    ON toms."Lines"("UnacceptableTypeID");

DROP INDEX toms."Lines_EDI_180124_idx";

-- MapGrid
ALTER TABLE toms."MapGrid" RENAME COLUMN "RevisionNr" TO "CurrRevisionNr";

ALTER TABLE toms."MapGrid" DROP COLUMN "Edge";

ALTER TABLE toms."MapGrid" DROP COLUMN "CPZ tile";

ALTER TABLE toms."MapGrid" DROP COLUMN "ContainsRes";

ALTER TABLE toms."MapGrid"
    ADD COLUMN mapsheetname character varying(10) COLLATE pg_catalog."default";

-- ParkingTariffAreas

ALTER TABLE toms."ParkingTariffAreas"
    RENAME COLUMN "Name" TO "ParkingTariffArea";

ALTER TABLE toms."ParkingTariffAreas"
    ALTER COLUMN "ParkingTariffArea" TYPE varchar(40);

ALTER TABLE toms."ParkingTariffAreas"
    RENAME COLUMN "NoReturnTimeID" TO "NoReturnID";

ALTER TABLE toms."ParkingTariffAreas" DROP COLUMN id;

ALTER TABLE toms."ParkingTariffAreas" DROP COLUMN gid;

ALTER TABLE toms."ParkingTariffAreas" DROP COLUMN fid_parkin;

ALTER TABLE toms."ParkingTariffAreas" DROP COLUMN tro_ref;

ALTER TABLE toms."ParkingTariffAreas" DROP COLUMN charge;

ALTER TABLE toms."ParkingTariffAreas" DROP COLUMN cost;

ALTER TABLE toms."ParkingTariffAreas" DROP COLUMN hours;

ALTER TABLE toms."ParkingTariffAreas" DROP COLUMN "OBJECTID";

ALTER TABLE toms."ParkingTariffAreas" DROP COLUMN name_orig;

ALTER TABLE toms."ParkingTariffAreas" DROP COLUMN "Shape_Leng";

ALTER TABLE toms."ParkingTariffAreas" DROP COLUMN "Shape_Area";

ALTER TABLE toms."ParkingTariffAreas"
    ALTER COLUMN "RestrictionID" SET NOT NULL;

ALTER TABLE toms."ParkingTariffAreas"
    ALTER COLUMN "GeometryID" TYPE character varying(12) COLLATE pg_catalog."default";
ALTER TABLE toms."ParkingTariffAreas"
    ALTER COLUMN "GeometryID" SET DEFAULT ('T_'::text || to_char(nextval('toms."ParkingTariffAreas_id_seq"'::regclass), 'FM0000000'::text));

ALTER TABLE toms."ParkingTariffAreas"
    ALTER COLUMN "GeometryID" SET NOT NULL;

ALTER TABLE toms."ParkingTariffAreas"
    ALTER COLUMN geom SET NOT NULL;

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "RestrictionTypeID" integer NOT NULL DEFAULT 22;

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "Notes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "Photos_01" character varying(255) COLLATE pg_catalog."default";

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "Photos_02" character varying(255) COLLATE pg_catalog."default";

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "Photos_03" character varying(255) COLLATE pg_catalog."default";

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "label_X" double precision;

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "label_Y" double precision;

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "label_Rotation" double precision;

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "label_TextChanged" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "LastUpdateDateTime" timestamp without time zone;

UPDATE toms."ParkingTariffAreas" SET "LastUpdateDateTime" = "OpenDate";

UPDATE toms."ParkingTariffAreas" SET "LastUpdateDateTime" = '2018-01-01'::date
WHERE "LastUpdateDateTime" IS NULL;

ALTER TABLE toms."ParkingTariffAreas"
    ALTER COLUMN "LastUpdateDateTime" SET NOT NULL;

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "LastUpdatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL DEFAULT 'CEC';

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "LabelText" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "ComplianceRoadMarkingsFaded" integer;

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "ComplianceRestrictionSignIssue" integer;

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "ComplianceNotes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "MHTC_CheckIssueTypeID" integer;

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "MHTC_CheckNotes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_pkey" PRIMARY KEY ("RestrictionID");

ALTER TABLE toms."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE toms."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue")
    REFERENCES compliance_lookups."BaysLines_SignIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ParkingTariffAreas_ComplianceRestrictionSignIssue"
    ON toms."ParkingTariffAreas"("ComplianceRestrictionSignIssue");

ALTER TABLE toms."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded")
    REFERENCES compliance_lookups."BaysLinesFadedTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ParkingTariffAreas_ComplianceRoadMarkingsFaded"
    ON toms."ParkingTariffAreas"("ComplianceRoadMarkingsFaded");

ALTER TABLE toms."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID")
    REFERENCES compliance_lookups."MHTC_CheckIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ParkingTariffAreas_MHTC_CheckIssueTypeID"
    ON toms."ParkingTariffAreas"("MHTC_CheckIssueTypeID");

ALTER TABLE toms."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_MaxStayID_fkey" FOREIGN KEY ("MaxStayID")
    REFERENCES toms_lookups."LengthOfTime" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ParkingTariffAreas_MaxStayID"
    ON toms."ParkingTariffAreas"("MaxStayID");

ALTER TABLE toms."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_NoReturnID_fkey" FOREIGN KEY ("NoReturnID")
    REFERENCES toms_lookups."LengthOfTime" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ParkingTariffAreas_NoReturnID"
    ON toms."ParkingTariffAreas"("NoReturnID");

ALTER TABLE toms."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID")
    REFERENCES toms_lookups."RestrictionPolygonTypesInUse" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ParkingTariffAreas_RestrictionTypeID"
    ON toms."ParkingTariffAreas"("RestrictionTypeID");

ALTER TABLE toms."ParkingTariffAreas"
    ADD CONSTRAINT "ParkingTariffAreas_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID")
    REFERENCES toms_lookups."TimePeriods" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ParkingTariffAreas_TimePeriodID"
    ON toms."ParkingTariffAreas"("TimePeriodID");

DROP INDEX toms."sidx_PTAs_180725_merged_10_geom";

CREATE INDEX "sidx_ParkingTariffAreas_geom"
    ON toms."ParkingTariffAreas" USING gist
    (geom)
    TABLESPACE pg_default;

-- Proposals
ALTER TABLE toms."Proposals"
    ALTER COLUMN "ProposalID" SET DEFAULT nextval('toms."Proposals_id_seq"'::regclass);

ALTER TABLE toms."Proposals"
    ALTER COLUMN "ProposalStatusID" SET NOT NULL;

ALTER TABLE toms."Proposals"
    ALTER COLUMN "ProposalCreateDate" SET NOT NULL;

ALTER TABLE toms."Proposals" DROP CONSTRAINT "Proposals_ProposalStatusID_fkey";

ALTER TABLE toms."Proposals"
    ADD CONSTRAINT "Proposals_ProposalStatusTypes_fkey" FOREIGN KEY ("ProposalStatusID")
    REFERENCES toms_lookups."ProposalStatusTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_ProposalStatusID"
    ON toms."Proposals"("ProposalStatusID");

-- RestrictionLayers
ALTER TABLE toms."RestrictionLayers"
    DROP CONSTRAINT "RestrictionLayers2_pkey";
ALTER TABLE toms."RestrictionLayers"
    DROP CONSTRAINT "RestrictionLayers_id_key";

ALTER TABLE "toms"."RestrictionLayers" RENAME COLUMN "id" TO "Code";

ALTER TABLE toms."RestrictionLayers"
    ALTER COLUMN "Code" SET NOT NULL;
ALTER TABLE toms."RestrictionLayers"
    ALTER COLUMN "Code" SET DEFAULT nextval('toms."RestrictionLayers_id_seq"'::regclass);

ALTER TABLE toms."RestrictionLayers"
    ADD CONSTRAINT "RestrictionLayers_pkey" PRIMARY KEY ("Code");

-- RestrictionPolygons
ALTER TABLE toms."RestrictionPolygons"
    DROP CONSTRAINT "restrictionsPolygons_pk";

ALTER TABLE toms."RestrictionPolygons" DROP COLUMN id;

ALTER TABLE toms."RestrictionPolygons" RENAME COLUMN "Polygons_Photos_01" TO "Photos_01";

ALTER TABLE toms."RestrictionPolygons" RENAME COLUMN "Polygons_Photos_02" TO "Photos_02";

ALTER TABLE toms."RestrictionPolygons" RENAME COLUMN "Polygons_Photos_03" TO "Photos_03";

ALTER TABLE toms."RestrictionPolygons" RENAME COLUMN "labelX" TO "label_X";

ALTER TABLE toms."RestrictionPolygons" RENAME COLUMN "labelY" TO "label_Y";

ALTER TABLE toms."RestrictionPolygons" RENAME COLUMN "labelRotation" TO "label_Rotation";

ALTER TABLE toms."RestrictionPolygons"
    ALTER COLUMN "GeometryID" SET DEFAULT ('P_'::text || to_char(nextval('toms."RestrictionPolygons_id_seq"'::regclass), 'FM0000000'::text));

ALTER TABLE toms."RestrictionPolygons"
    ALTER COLUMN "RestrictionTypeID" SET NOT NULL;

ALTER TABLE toms."RestrictionPolygons"
    ALTER COLUMN "GeomShapeID" SET NOT NULL;

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "Notes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "label_TextChanged" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "LastUpdateDateTime" timestamp without time zone;

UPDATE toms."RestrictionPolygons" SET "LastUpdateDateTime" = "OpenDate";

UPDATE toms."RestrictionPolygons" SET "LastUpdateDateTime" = '2018-01-01'::date
WHERE "LastUpdateDateTime" IS NULL;

ALTER TABLE toms."RestrictionPolygons"
    ALTER COLUMN "LastUpdateDateTime" SET NOT NULL;

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "LastUpdatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL DEFAULT 'CEC';

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "ComplianceRoadMarkingsFaded" integer;

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "ComplianceRestrictionSignIssue" integer;

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "ComplianceNotes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "MHTC_CheckIssueTypeID" integer;

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "MHTC_CheckNotes" character varying(254) COLLATE pg_catalog."default";
ALTER TABLE toms."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_pk" PRIMARY KEY ("RestrictionID");

ALTER TABLE toms."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionPolygons_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE toms."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue")
    REFERENCES compliance_lookups."BaysLines_SignIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_RestrictionPolygons_ComplianceRestrictionSignIssue"
    ON toms."RestrictionPolygons"("ComplianceRestrictionSignIssue");

ALTER TABLE toms."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded")
    REFERENCES compliance_lookups."BaysLinesFadedTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_RestrictionPolygons_ComplianceRoadMarkingsFaded"
    ON toms."RestrictionPolygons"("ComplianceRoadMarkingsFaded");

ALTER TABLE toms."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID")
    REFERENCES toms_lookups."RestrictionGeomShapeTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_RestrictionPolygons_GeomShapeID"
    ON toms."RestrictionPolygons"("GeomShapeID");

ALTER TABLE toms."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID")
    REFERENCES compliance_lookups."MHTC_CheckIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_RestrictionPolygons_MHTC_CheckIssueTypeID"
    ON toms."RestrictionPolygons"("MHTC_CheckIssueTypeID");

ALTER TABLE toms."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_NoLoadingTimeID_fkey" FOREIGN KEY ("NoLoadingTimeID")
    REFERENCES toms_lookups."TimePeriods" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_RestrictionPolygons_NoLoadingTimeID"
    ON toms."RestrictionPolygons"("NoLoadingTimeID");

ALTER TABLE toms."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_NoWaitingTimeID_fkey" FOREIGN KEY ("NoWaitingTimeID")
    REFERENCES toms_lookups."TimePeriods" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_RestrictionPolygons_NoWaitingTimeID"
    ON toms."RestrictionPolygons"("NoWaitingTimeID");

ALTER TABLE toms."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID")
    REFERENCES toms_lookups."RestrictionPolygonTypesInUse" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_RestrictionPolygons_RestrictionTypeID"
    ON toms."RestrictionPolygons"("RestrictionTypeID");

ALTER TABLE toms."RestrictionPolygons"
    ADD CONSTRAINT "RestrictionsPolygons_TimePeriodID_fkey" FOREIGN KEY ("TimePeriodID")
    REFERENCES toms_lookups."TimePeriods" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_RestrictionPolygons_TimePeriodID"
    ON toms."RestrictionPolygons"("TimePeriodID");

-- RestrictionsInProposals
/*
ALTER TABLE toms."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_ActionOnProposalAcceptance_fkey" FOREIGN KEY ("ActionOnProposalAcceptance")
    REFERENCES toms_lookups."ActionOnProposalAcceptanceTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

ALTER TABLE toms."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_RestrictionTableID_fkey" FOREIGN KEY ("RestrictionTableID")
    REFERENCES toms."RestrictionLayers" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

ALTER TABLE toms."RestrictionsInProposals"
    ADD CONSTRAINT "RestrictionsInProposals_pk" PRIMARY KEY ("ProposalID", "RestrictionTableID", "RestrictionID");

CREATE INDEX "idx_RestrictionsInProposals_ActionOnProposalAcceptance"
    ON toms."RestrictionsInProposals"("ActionOnProposalAcceptance");

CREATE INDEX "idx_RestrictionsInProposals_ProposalID"
    ON toms."RestrictionsInProposals"("ProposalID");

CREATE INDEX "idx_RestrictionsInProposals_RestrictionTableID"
    ON toms."RestrictionsInProposals"("RestrictionTableID");
*/

-- Signs
ALTER TABLE toms."Signs" ALTER COLUMN "GeometryID" DROP DEFAULT;

ALTER TABLE toms."Signs" DROP CONSTRAINT "Signs_pkey";

ALTER TABLE toms."Signs" DROP COLUMN id;

ALTER TABLE toms."Signs" DROP COLUMN "Signs_Notes";

ALTER TABLE toms."Signs" RENAME COLUMN "Signs_Photos_01" TO "Photos_01";

ALTER TABLE toms."Signs" RENAME COLUMN "Signs_Photos_02" TO "Photos_02";

ALTER TABLE toms."Signs" RENAME COLUMN "Signs_Photos_03" TO "Photos_03";

ALTER TABLE toms."Signs" RENAME COLUMN "Signs_DateTime" TO "LastUpdateDateTime";

ALTER TABLE toms."Signs" DROP COLUMN "PhotoTaken";

ALTER TABLE toms."Signs" RENAME COLUMN "Surveyor" TO "LastUpdatePerson";

UPDATE toms."Signs" SET "LastUpdatePerson" = 'MHTC' WHERE "LastUpdatePerson" IS NULL;

ALTER TABLE toms."Signs"
    ALTER COLUMN "LastUpdatePerson" SET NOT NULL;

ALTER TABLE toms."Signs" RENAME COLUMN "Compl_Signs_Direction" TO "Compl_Sign_Direction";

ALTER TABLE toms."Signs" DROP COLUMN "GeometryID_181017";

ALTER TABLE toms."Signs" DROP COLUMN "CPZ";

ALTER TABLE toms."Signs" DROP COLUMN "ParkingTariffArea";

ALTER TABLE toms."Signs"
    ALTER COLUMN "GeometryID" TYPE character varying(12) COLLATE pg_catalog."default";

ALTER TABLE toms."Signs"
    ALTER COLUMN "GeometryID" SET DEFAULT ('S_'::text || to_char(nextval('toms."Signs_id_seq"'::regclass), 'FM0000000'::text));

ALTER TABLE toms."Signs"
    ALTER COLUMN geom SET NOT NULL;

ALTER TABLE toms."Signs"
    ADD COLUMN "Notes" character varying(255) COLLATE pg_catalog."default";

ALTER TABLE toms."Signs"
    ADD COLUMN "SignType_4" integer;

ALTER TABLE toms."Signs"
    ADD COLUMN "Photos_04" character varying(255) COLLATE pg_catalog."default";

ALTER TABLE toms."Signs"
    ADD COLUMN "SignOrientationTypeID" integer;

ALTER TABLE toms."Signs"
    ADD COLUMN "SignIlluminationTypeID" integer;

ALTER TABLE toms."Signs"
    ADD COLUMN "SignConditionTypeID" integer;

ALTER TABLE toms."Signs"
    ADD COLUMN "ComplianceRestrictionSignIssue" integer;

ALTER TABLE toms."Signs"
    ADD COLUMN "ComplianceNotes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."Signs"
    ADD COLUMN "MHTC_CheckIssueTypeID" integer;

ALTER TABLE toms."Signs"
    ADD COLUMN "MHTC_CheckNotes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."Signs"
    ADD COLUMN "SignAddress" character varying(255) COLLATE pg_catalog."default";

ALTER TABLE toms."Signs"
    ADD COLUMN original_geom_wkt character varying(255) COLLATE pg_catalog."default";

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_pkey" PRIMARY KEY ("RestrictionID");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_Compl_Signs_Faded_fkey" FOREIGN KEY ("Compl_Signs_Faded")
    REFERENCES compliance_lookups."SignFadedTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Compl_Signs_Faded"
    ON toms."Signs"("Compl_Signs_Faded");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_Compl_Signs_Obscured_fkey" FOREIGN KEY ("Compl_Signs_Obscured")
    REFERENCES compliance_lookups."SignObscurredTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Compl_Signs_Obscured"
    ON toms."Signs"("Compl_Signs_Obscured");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_Compl_Signs_TicketMachines_fkey" FOREIGN KEY ("Compl_Signs_TicketMachines")
    REFERENCES compliance_lookups."TicketMachineIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Compl_Signs_TicketMachines"
    ON toms."Signs"("Compl_Signs_TicketMachines");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue")
    REFERENCES compliance_lookups."BaysLines_SignIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Signs_ComplianceRestrictionSignIssue"
    ON toms."Signs"("ComplianceRestrictionSignIssue");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID")
    REFERENCES compliance_lookups."MHTC_CheckIssueTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Signs_MHTC_CheckIssueTypeID"
    ON toms."Signs"("MHTC_CheckIssueTypeID");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_MHTC_SignIlluminationTypeID_fkey" FOREIGN KEY ("SignIlluminationTypeID")
    REFERENCES compliance_lookups."SignIlluminationTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_SignIlluminationTypeID"
    ON toms."Signs"("SignIlluminationTypeID");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_SignConditionTypeID_fkey" FOREIGN KEY ("SignConditionTypeID")
    REFERENCES compliance_lookups."SignConditionTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_SignConditionTypeID"
    ON toms."Signs"("SignConditionTypeID");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_SignOrientationTypeID_fkey" FOREIGN KEY ("SignOrientationTypeID")
    REFERENCES toms_lookups."SignOrientationTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_SignOrientationTypeID"
    ON toms."Signs"("SignOrientationTypeID");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_SignTypes1_fkey" FOREIGN KEY ("SignType_1")
    REFERENCES toms_lookups."SignTypesInUse" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_SignType_1"
    ON toms."Signs"("SignType_1");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_SignTypes2_fkey" FOREIGN KEY ("SignType_2")
    REFERENCES toms_lookups."SignTypesInUse" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_SignType_2"
    ON toms."Signs"("SignType_2");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_SignTypes3_fkey" FOREIGN KEY ("SignType_3")
    REFERENCES toms_lookups."SignTypesInUse" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_SignType_3"
    ON toms."Signs"("SignType_3");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_SignTypes4_fkey" FOREIGN KEY ("SignType_4")
    REFERENCES toms_lookups."SignTypesInUse" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_SignType_4"
    ON toms."Signs"("SignType_4");

/* -- not able to create due to integrity issue - not sure what it is ...
ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_Signs_Attachment_fkey" FOREIGN KEY ("Signs_Attachment")
    REFERENCES compliance_lookups."SignAttachmentTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
*/
CREATE INDEX "idx_Signs_Attachment"
    ON toms."Signs"("Signs_Attachment");

ALTER TABLE toms."Signs"
    ADD CONSTRAINT "Signs_Signs_Mount_fkey" FOREIGN KEY ("Signs_Mount")
    REFERENCES compliance_lookups."SignMountTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Signs_Mount"
    ON toms."Signs"("Signs_Mount");

CREATE INDEX "sidx_Signs_geom"
    ON toms."Signs" USING gist
    (geom)
    TABLESPACE pg_default;

DROP INDEX toms."sidx_Signs_geom";

-- TilesInAcceptedProposals
ALTER TABLE toms."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_ProposalID_fkey" FOREIGN KEY ("ProposalID")
    REFERENCES toms."Proposals" ("ProposalID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
CREATE INDEX "idx_ProposalID"
    ON toms."TilesInAcceptedProposals"("ProposalID");

ALTER TABLE toms."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_TileNr_fkey" FOREIGN KEY ("TileNr")
    REFERENCES toms."MapGrid" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
CREATE INDEX "idx_TileNr"
    ON toms."TilesInAcceptedProposals"("TileNr");

-- ***
-- Drop tables/views not required

DROP TABLE public."CPZs" CASCADE;
-- DROP MATERIALIZED VIEW public."BayLineTypes";

CREATE SCHEMA "export";
ALTER SCHEMA "export" OWNER TO "postgres";



