-- Migration to TOMs data structure v2
-- Merges databases EDI_VM_Check, EDI1_VM and MasterLookups

-- revoke old privileges
-- REVOKE ALL PRIVILEGES ON DATABASE ?? FROM edi_admin;

-- set up new schemas

CREATE SCHEMA IF NOT EXISTS addresses AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS compliance AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS compliance_lookups AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS highways_network AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS local_authority AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS toms AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS toms_lookups AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS topography AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS transfer AUTHORIZATION postgres;



-- Move tables to new schemas  --
-- toms
ALTER TABLE public."Bays" SET SCHEMA toms;
ALTER TABLE public."ControlledParkingZones" SET SCHEMA toms;
ALTER TABLE public."Lines" SET SCHEMA toms;
ALTER TABLE public."MapGrid" SET SCHEMA toms;
ALTER TABLE public."ParkingTariffAreas" SET SCHEMA toms;
ALTER TABLE public."Proposals" SET SCHEMA toms;
ALTER TABLE public."RestrictionLayers" SET SCHEMA toms;
ALTER TABLE public."RestrictionPolygons" SET SCHEMA toms;
ALTER TABLE public."RestrictionsInProposals" SET SCHEMA toms;
ALTER TABLE public."Signs" SET SCHEMA toms;
ALTER TABLE public."TilesInAcceptedProposals" SET SCHEMA toms;

-- toms_lookups
ALTER TABLE public."ActionOnProposalAcceptanceTypes" SET SCHEMA toms_lookups;
ALTER TABLE "baysWordingTypes" RENAME TO "AdditionalConditionTypes";
ALTER TABLE public."AdditionalConditionTypes" SET SCHEMA toms_lookups;
-- TODO: rename columns, etc
ALTER TABLE public."LengthOfTime"  SET SCHEMA toms_lookups;
ALTER TABLE public."PaymentTypes"  SET SCHEMA toms_lookups;
ALTER TABLE public."ProposalStatusTypes"  SET SCHEMA toms_lookups;
ALTER TABLE public."RestrictionPolygonTypes" SET SCHEMA toms_lookups;
ALTER TABLE "RestrictionShapeTypes" RENAME TO "RestrictionGeomShapeTypes";
ALTER TABLE public."RestrictionGeomShapeTypes"  SET SCHEMA toms_lookups;
-- TODO: rename columns, etc
ALTER TABLE public."RestrictionStatus" SET SCHEMA toms_lookups;
ALTER TABLE public."SignTypes" SET SCHEMA toms_lookups;
ALTER TABLE public."TimePeriods" SET SCHEMA toms_lookups;

-- compliance lookups
ALTER TABLE public."BayLinesFadedTypes" RENAME TO "BaysLinesFadedTypes";
ALTER TABLE public."BaysLinesFadedTypes"  SET SCHEMA compliance_lookups;
ALTER TABLE public."BaysLines_SignIssueTypes"  SET SCHEMA compliance_lookups;
ALTER TABLE public."SignAttachmentTypes"  SET SCHEMA compliance_lookups;
ALTER TABLE public."SignFadedTypes"  SET SCHEMA compliance_lookups;
ALTER TABLE public."SignMountTypes"  SET SCHEMA compliance_lookups;
ALTER TABLE public."SignObscurredTypes"  SET SCHEMA compliance_lookups;
ALTER TABLE public."TicketMachineIssueTypes"  SET SCHEMA compliance_lookups;

-- transfer
--ALTER TABLE public."LookupCodeTransfers_Bays"  SET SCHEMA transfer;
--ALTER TABLE public."LookupCodeTransfers_Lines"  SET SCHEMA transfer;

-- *** Create sequences
-- BaysLinesFadedTypes_Code_seq
CREATE SEQUENCE compliance_lookups."BaysLinesFadedTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."BaysLinesFadedTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."BaysLinesFadedTypes_Code_seq" TO postgres;

-- BaysLines_SignIssueTypes_Code_seq
CREATE SEQUENCE compliance_lookups."BaysLines_SignIssueTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."BaysLines_SignIssueTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."BaysLines_SignIssueTypes_Code_seq" TO postgres;

-- ConditionTypes_Code_seq
CREATE SEQUENCE compliance_lookups."ConditionTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."ConditionTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."ConditionTypes_Code_seq" TO postgres;

-- MHTC_CheckIssueTypes_Code_seq
CREATE SEQUENCE compliance_lookups."MHTC_CheckIssueTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."MHTC_CheckIssueTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."MHTC_CheckIssueTypes_Code_seq" TO postgres;

-- MHTC_CheckStatus_Code_seq
CREATE SEQUENCE compliance_lookups."MHTC_CheckStatus_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."MHTC_CheckStatus_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."MHTC_CheckStatus_Code_seq" TO postgres;

-- SignConditionTypes_Code_seq
CREATE SEQUENCE compliance_lookups."SignConditionTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."SignConditionTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."SignConditionTypes_Code_seq" TO postgres;

-- SignFadedTypes_id_seq
/*
CREATE SEQUENCE compliance_lookups."SignFadedTypes_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."SignFadedTypes_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."SignFadedTypes_id_seq" TO postgres;
*/
-- SignIlluminationTypes_Code_seq
CREATE SEQUENCE compliance_lookups."SignIlluminationTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."SignIlluminationTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."SignIlluminationTypes_Code_seq" TO postgres;

-- SignMountTypes_id_seq
CREATE SEQUENCE compliance_lookups."SignMountTypes_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."SignMountTypes_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."SignMountTypes_id_seq" TO postgres;

-- SignObscurredTypes_id_seq
/*
CREATE SEQUENCE compliance_lookups."SignObscurredTypes_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."SignObscurredTypes_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."SignObscurredTypes_id_seq" TO postgres;
*/
-- TicketMachineIssueTypes_id_seq
/*
CREATE SEQUENCE compliance_lookups."TicketMachineIssueTypes_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."TicketMachineIssueTypes_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."TicketMachineIssueTypes_id_seq" TO postgres;
*/
-- signAttachmentTypes_id_seq
/*CREATE SEQUENCE compliance_lookups."SignAttachmentTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE compliance_lookups."SignAttachmentTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."SignAttachmentTypes_Code_seq" TO postgres;*/

-- itn_roadcentreline_gid_seq
CREATE SEQUENCE highways_network.itn_roadcentreline_gid_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE highways_network.itn_roadcentreline_gid_seq
    OWNER TO postgres;

GRANT ALL ON SEQUENCE highways_network.itn_roadcentreline_gid_seq TO postgres;

-- StreetGazetteerRecords_id_seq
CREATE SEQUENCE local_authority."StreetGazetteerRecords_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE local_authority."StreetGazetteerRecords_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE local_authority."StreetGazetteerRecords_id_seq" TO postgres;

-- Bays_id_seq
CREATE SEQUENCE toms."Bays_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE toms."Bays_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms."Bays_id_seq" TO postgres;

-- ControlledParkingZones_id_seq
CREATE SEQUENCE toms."ControlledParkingZones_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE toms."ControlledParkingZones_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms."ControlledParkingZones_id_seq" TO postgres;

-- Lines_id_seq
CREATE SEQUENCE toms."Lines_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE toms."Lines_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms."Lines_id_seq" TO postgres;

-- ParkingTariffAreas_id_seq
CREATE SEQUENCE toms."ParkingTariffAreas_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE toms."ParkingTariffAreas_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms."ParkingTariffAreas_id_seq" TO postgres;

--
CREATE SEQUENCE toms."Proposals_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE toms."Proposals_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms."Proposals_id_seq" TO postgres;

-- RestrictionLayers_id_seq
CREATE SEQUENCE toms."RestrictionLayers_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE toms."RestrictionLayers_id_seq"
    OWNER TO postgres;

-- RestrictionPolygons_id_seq
/*
CREATE SEQUENCE toms."RestrictionPolygons_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE toms."RestrictionPolygons_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms."RestrictionPolygons_id_seq" TO postgres;

-- Signs_id_seq
CREATE SEQUENCE toms."Signs_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE toms."Signs_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms."Signs_id_seq" TO postgres;
*/
-- AdditionalConditionTypes_Code_seq
CREATE SEQUENCE toms_lookups."AdditionalConditionTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE toms_lookups."AdditionalConditionTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms_lookups."AdditionalConditionTypes_Code_seq" TO postgres;

-- BayLineTypes_Code_seq
CREATE SEQUENCE toms_lookups."BayLineTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE toms_lookups."BayLineTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms_lookups."BayLineTypes_Code_seq" TO postgres;

-- LengthOfTime_Code_seq
CREATE SEQUENCE toms_lookups."LengthOfTime_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE toms_lookups."LengthOfTime_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms_lookups."LengthOfTime_Code_seq" TO postgres;

-- PaymentTypes_Code_seq
CREATE SEQUENCE toms_lookups."PaymentTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE toms_lookups."PaymentTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms_lookups."PaymentTypes_Code_seq" TO postgres;

-- ProposalStatusTypes_Code_seq
CREATE SEQUENCE toms_lookups."ProposalStatusTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE toms_lookups."ProposalStatusTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms_lookups."ProposalStatusTypes_Code_seq" TO postgres;

-- RestrictionPolygonTypes_Code_seq
CREATE SEQUENCE toms_lookups."RestrictionPolygonTypes_Code_seq"
    INCREMENT 1
    START 21
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE toms_lookups."RestrictionPolygonTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms_lookups."RestrictionPolygonTypes_Code_seq" TO postgres;

-- RestrictionShapeTypes_Code_seq
CREATE SEQUENCE toms_lookups."RestrictionShapeTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE toms_lookups."RestrictionShapeTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms_lookups."RestrictionShapeTypes_Code_seq" TO postgres;

-- SignOrientationTypes_Code_seq
CREATE SEQUENCE toms_lookups."SignOrientationTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE toms_lookups."SignOrientationTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms_lookups."SignOrientationTypes_Code_seq" TO postgres;

-- SignTypes_Code_seq

CREATE SEQUENCE toms_lookups."SignTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE toms_lookups."SignTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms_lookups."SignTypes_Code_seq" TO postgres;


-- TimePeriods_Code_seq
CREATE SEQUENCE toms_lookups."TimePeriods_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE toms_lookups."TimePeriods_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms_lookups."TimePeriods_Code_seq" TO postgres;

-- UnacceptableTypes_Code_seq
CREATE SEQUENCE toms_lookups."UnacceptableTypes_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE toms_lookups."UnacceptableTypes_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE toms_lookups."UnacceptableTypes_Code_seq" TO postgres;

-- Corners_id_seq
CREATE SEQUENCE topography."Corners_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE topography."Corners_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE topography."Corners_id_seq" TO postgres;

-- cartotext_gid_seq
CREATE SEQUENCE topography.os_mastermap_topography_text_gid_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE topography.os_mastermap_topography_text_gid_seq
    OWNER TO postgres;

GRANT ALL ON SEQUENCE topography.os_mastermap_topography_text_gid_seq TO postgres;

-- mm_gid_seq
CREATE SEQUENCE topography.os_mastermap_topography_polygons_gid_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE topography.os_mastermap_topography_polygons_gid_seq
    OWNER TO postgres;

GRANT ALL ON SEQUENCE topography.os_mastermap_topography_polygons_gid_seq TO postgres;

-- *** Drop any fkeys that stop changes
-- RestrictionsInProposals

/*
ALTER TABLE toms."RestrictionsInProposals" DROP CONSTRAINT "RestrictionsInProposals_ActionOnProposalAcceptance_fkey";
ALTER TABLE toms."RestrictionsInProposals" DROP CONSTRAINT "RestrictionsInProposals_RestrictionTableID_fkey";
ALTER TABLE toms."RestrictionsInProposals" DROP CONSTRAINT "RestrictionsInProposals_pk";
*/
-- *** Change any tables

-- BaysLinesFadedTypes
ALTER TABLE compliance_lookups."BaysLinesFadedTypes" DROP CONSTRAINT "BayLinesFadedTypes_pkey";
ALTER TABLE compliance_lookups."BaysLinesFadedTypes" DROP COLUMN id;
ALTER TABLE compliance_lookups."BaysLinesFadedTypes" DROP COLUMN "Comment";

ALTER TABLE compliance_lookups."BaysLinesFadedTypes"
    ALTER COLUMN "Code" TYPE INT USING "Code"::integer;

ALTER TABLE compliance_lookups."BaysLinesFadedTypes"
    ALTER COLUMN "Code" SET DEFAULT nextval('compliance_lookups."BaysLinesFadedTypes_Code_seq"'::regclass);

ALTER TABLE compliance_lookups."BaysLinesFadedTypes"
    ALTER COLUMN "Code" SET NOT NULL;

ALTER TABLE compliance_lookups."BaysLinesFadedTypes"
    ALTER COLUMN "Code" SET STORAGE PLAIN;

ALTER TABLE compliance_lookups."BaysLinesFadedTypes"
    ADD CONSTRAINT "BaysLinesFadedTypes_pkey" PRIMARY KEY ("Code");

-- BaysLines_SignIssueTypes
ALTER TABLE compliance_lookups."BaysLines_SignIssueTypes" DROP CONSTRAINT "BaysLines_SignIssueTypes_pkey";
ALTER TABLE compliance_lookups."BaysLines_SignIssueTypes" DROP COLUMN id;
ALTER TABLE compliance_lookups."BaysLines_SignIssueTypes" DROP COLUMN "Comment";

ALTER TABLE compliance_lookups."BaysLines_SignIssueTypes"
    ALTER COLUMN "Code" TYPE INT USING "Code"::integer;

ALTER TABLE compliance_lookups."BaysLines_SignIssueTypes"
    ALTER COLUMN "Code" SET DEFAULT nextval('compliance_lookups."BaysLines_SignIssueTypes_Code_seq"'::regclass);

ALTER TABLE compliance_lookups."BaysLines_SignIssueTypes"
    ALTER COLUMN "Code" SET NOT NULL;

ALTER TABLE compliance_lookups."BaysLines_SignIssueTypes"
    ALTER COLUMN "Code" SET STORAGE PLAIN;

ALTER TABLE compliance_lookups."BaysLines_SignIssueTypes"
    ADD CONSTRAINT "BaysLines_SignIssueTypes_pkey" PRIMARY KEY ("Code");

-- SignAttachmentTypes
/*ALTER TABLE compliance_lookups."SignAttachmentTypes"
    ALTER COLUMN id SET DEFAULT nextval('compliance_lookups."SignAttachmentTypes_Code_seq"'::regclass);*/

ALTER TABLE compliance_lookups."SignAttachmentTypes"
    ALTER COLUMN "Code" SET NOT NULL;
ALTER TABLE compliance_lookups."SignAttachmentTypes" DROP CONSTRAINT "signAttachmentTypes2_pkey";

ALTER TABLE compliance_lookups."SignAttachmentTypes"
    ADD CONSTRAINT "signAttachmentTypes_pkey" PRIMARY KEY (id);

/*ALTER TABLE compliance_lookups."SignAttachmentTypes"
    ADD CONSTRAINT "SignAttachmentTypes_Code_key" UNIQUE ("Code");*/

-- SignFadedTypes
ALTER TABLE compliance_lookups."SignFadedTypes"
    ALTER COLUMN id SET DEFAULT nextval('compliance_lookups."SignFadedTypes_id_seq"'::regclass);

ALTER TABLE compliance_lookups."SignFadedTypes"
    ALTER COLUMN "Code" SET NOT NULL;

ALTER TABLE compliance_lookups."SignFadedTypes"
    ALTER COLUMN "Code" TYPE INT USING "Code"::integer;

ALTER TABLE compliance_lookups."SignFadedTypes"
    ALTER COLUMN "Code" SET STORAGE PLAIN;
ALTER TABLE compliance_lookups."SignFadedTypes"
    ADD CONSTRAINT "SignFadedTypes_Code_key" UNIQUE ("Code");

-- SignMountTypes
ALTER TABLE compliance_lookups."SignMountTypes"
    ALTER COLUMN id SET DEFAULT nextval('compliance_lookups."SignMountTypes_id_seq"'::regclass);

ALTER TABLE compliance_lookups."SignMountTypes"
    ALTER COLUMN "Code" SET NOT NULL;

ALTER TABLE compliance_lookups."SignMountTypes"
    ALTER COLUMN "Code" TYPE INT USING "Code"::integer;

ALTER TABLE compliance_lookups."SignMountTypes"
    ALTER COLUMN "Code" SET STORAGE PLAIN;
ALTER TABLE compliance_lookups."SignMountTypes"
    ADD CONSTRAINT "SignMountTypes_Code_key" UNIQUE ("Code");

-- SignObscurredTypes
ALTER TABLE compliance_lookups."SignObscurredTypes"
    ALTER COLUMN id SET DEFAULT nextval('compliance_lookups."SignObscurredTypes_id_seq"'::regclass);

ALTER TABLE compliance_lookups."SignObscurredTypes"
    ALTER COLUMN "Code" SET NOT NULL;

ALTER TABLE compliance_lookups."SignObscurredTypes"
    ALTER COLUMN "Code" TYPE INT USING "Code"::integer;

ALTER TABLE compliance_lookups."SignObscurredTypes"
    ALTER COLUMN "Code" SET STORAGE PLAIN;
ALTER TABLE compliance_lookups."SignObscurredTypes"
    ADD CONSTRAINT "SignObscurredTypes_Code_key" UNIQUE ("Code");

-- TicketMachineIssueTypes
ALTER TABLE compliance_lookups."TicketMachineIssueTypes"
    ALTER COLUMN id SET DEFAULT nextval('compliance_lookups."TicketMachineIssueTypes_id_seq"'::regclass);
ALTER TABLE compliance_lookups."TicketMachineIssueTypes"
    ALTER COLUMN "Code" SET NOT NULL;

ALTER TABLE compliance_lookups."TicketMachineIssueTypes"
    ALTER COLUMN "Code" TYPE INT USING "Code"::integer;

ALTER TABLE compliance_lookups."TicketMachineIssueTypes"
    ALTER COLUMN "Code" SET STORAGE PLAIN;
ALTER TABLE compliance_lookups."TicketMachineIssueTypes"
    ADD CONSTRAINT "TicketMachineIssueTypes_Code_key" UNIQUE ("Code");

-- AdditionalConditionTypes
ALTER TABLE toms_lookups."AdditionalConditionTypes" DROP CONSTRAINT "baysWordingTypes_pkey";
ALTER TABLE toms_lookups."AdditionalConditionTypes" DROP COLUMN id;

ALTER TABLE toms_lookups."AdditionalConditionTypes"
    ALTER COLUMN "Code" TYPE INT USING "Code"::integer;

ALTER TABLE toms_lookups."AdditionalConditionTypes"
    ADD CONSTRAINT "AdditionalConditionTypes_pkey" PRIMARY KEY ("Code");

-- ActionOnProposalAcceptanceTypes
ALTER TABLE toms_lookups."ActionOnProposalAcceptanceTypes" DROP CONSTRAINT "ActionOnProposalAcceptanceTypes_pkey";
ALTER TABLE toms_lookups."ActionOnProposalAcceptanceTypes" RENAME COLUMN "id" TO "Code";

ALTER TABLE toms_lookups."ActionOnProposalAcceptanceTypes"
    ALTER COLUMN "Description" SET NOT NULL;

ALTER TABLE toms_lookups."ActionOnProposalAcceptanceTypes"
    ADD CONSTRAINT "ActionOnProposalAcceptanceTypes_pkey" PRIMARY KEY ("Code");

-- LengthOfTime
ALTER TABLE toms_lookups."LengthOfTime" DROP COLUMN id;

ALTER TABLE toms_lookups."LengthOfTime"
    ALTER COLUMN "Code" SET DEFAULT nextval('toms_lookups."LengthOfTime_Code_seq"'::regclass);

ALTER TABLE toms_lookups."LengthOfTime"
    ALTER COLUMN "Code" SET NOT NULL;

ALTER TABLE toms_lookups."LengthOfTime"
    ALTER COLUMN "Description" SET NOT NULL;
ALTER TABLE toms_lookups."LengthOfTime"
    ADD CONSTRAINT "LengthOfTime_pkey" PRIMARY KEY ("Code");

-- PaymentTypes
ALTER TABLE toms_lookups."PaymentTypes" DROP COLUMN id;

ALTER TABLE toms_lookups."PaymentTypes"
    ALTER COLUMN "Code" SET DEFAULT nextval('toms_lookups."PaymentTypes_Code_seq"'::regclass);

ALTER TABLE toms_lookups."PaymentTypes"
    ALTER COLUMN "Code" SET NOT NULL;

ALTER TABLE toms_lookups."PaymentTypes"
    ALTER COLUMN "Description" SET NOT NULL;
ALTER TABLE toms_lookups."PaymentTypes"
    ADD CONSTRAINT "PaymentTypes_pkey" PRIMARY KEY ("Code");

-- ProposalStatusTypes
ALTER TABLE toms_lookups."ProposalStatusTypes" DROP COLUMN id;

ALTER TABLE toms_lookups."ProposalStatusTypes"
    ALTER COLUMN "Code" SET DEFAULT nextval('toms_lookups."ProposalStatusTypes_Code_seq"'::regclass);

ALTER TABLE toms_lookups."ProposalStatusTypes"
    ALTER COLUMN "Code" SET NOT NULL;

ALTER TABLE toms_lookups."ProposalStatusTypes"
    ALTER COLUMN "Description" SET NOT NULL;
ALTER TABLE toms_lookups."ProposalStatusTypes"
    ADD CONSTRAINT "ProposalStatusTypes_pkey" PRIMARY KEY ("Code");

-- RestrictionPolygonTypes
/*ALTER TABLE toms_lookups."RestrictionPolygonTypes" DROP COLUMN id;
ALTER TABLE toms_lookups."RestrictionPolygonTypes" DROP CONSTRAINT "RestrictionPolygonTypes_pkey";

ALTER TABLE toms_lookups."RestrictionPolygonTypes"
    ALTER COLUMN "Code" SET DEFAULT nextval('toms_lookups."RestrictionPolygonTypes_Code_seq"'::regclass);

ALTER TABLE toms_lookups."RestrictionPolygonTypes"
    ALTER COLUMN "Code" SET NOT NULL;

ALTER TABLE toms_lookups."RestrictionPolygonTypes"
    ALTER COLUMN "Description" SET NOT NULL;
ALTER TABLE toms_lookups."RestrictionPolygonTypes"
    ADD CONSTRAINT "RestrictionPolygonTypes_pkey" PRIMARY KEY ("Code"); */

-- RestrictionPolygonTypes
ALTER TABLE toms_lookups."RestrictionPolygonTypes" DROP COLUMN id;

ALTER TABLE toms_lookups."RestrictionPolygonTypes"
    ALTER COLUMN "Code" SET DEFAULT nextval('toms_lookups."RestrictionPolygonTypes_Code_seq"'::regclass);

ALTER TABLE toms_lookups."RestrictionPolygonTypes"
    ALTER COLUMN "Code" SET NOT NULL;

ALTER TABLE toms_lookups."RestrictionPolygonTypes"
    ALTER COLUMN "Description" SET NOT NULL;
ALTER TABLE toms_lookups."RestrictionPolygonTypes"
    ADD CONSTRAINT "RestrictionPolygonTypes_pkey" PRIMARY KEY ("Code");

-- *** create any required tables
-- BayLineTypes
CREATE TABLE toms_lookups."BayLineTypes"
(
    "Code" integer NOT NULL DEFAULT nextval('toms_lookups."BayLineTypes_Code_seq"'::regclass),
    "Description" character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT "BayLineTypes_pkey" PRIMARY KEY ("Code")
)
TABLESPACE pg_default;

ALTER TABLE toms_lookups."BayLineTypes"
    OWNER to postgres;

--

/*
INSERT INTO toms_lookups."BayLineTypes"("Code", "Description")
SELECT DISTINCT CAST("CurrCode" AS int)
FROM transfer."LookupCodeTransfers_Bays"
UNION
SELECT DISTINCT CAST("CurrCode" AS int)
FROM transfer."LookupCodeTransfers_Lines"
ORDER BY "CurrCode";
*/

---

INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description")
SELECT "Master_BayLineTypes"."Code", "Master_BayLineTypes"."Description"
FROM
      (SELECT "Code", "Description"
      FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=MasterLookups user=postgres password=OS!2postgres options=-csearch_path=',
		'SELECT "Code", "Description" FROM public."BayLineTypes"') AS "BayLineTypes"("Code" int, "Description" text)) AS "Master_BayLineTypes"
       WHERE "Code" NOT IN (
       SELECT DISTINCT "Code"
       FROM "toms_lookups"."BayLineTypes");

UPDATE "toms_lookups"."BayLineTypes" AS c
SET "Description" = m."Description"
FROM (SELECT "Code", "Description"
      FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=MasterLookups user=postgres password=OS!2postgres options=-csearch_path=',
		'SELECT "Code", "Description" FROM public."BayLineTypes"') AS "BayLineTypes"("Code" int, "Description" text)) AS "m"
WHERE c."Code" = m."Code"
AND c."Description" IS NULL;

/*
UPDATE "toms_lookups"."BayLineTypes" AS c
SET "Description" = m."Aug2018_Description"
FROM transfer."LookupCodeTransfers_Bays" AS "m"
WHERE c."Code" = CAST(m."CurrCode" AS int)
AND c."Description" IS NULL;


UPDATE "toms_lookups"."BayLineTypes" AS c
SET "Description" = m."Aug2018_Description"
FROM transfer."LookupCodeTransfers_Lines" AS "m"
WHERE c."Code" = CAST(m."CurrCode" AS int)
AND c."Description" IS NULL;
*/

ALTER TABLE "toms_lookups"."BayLineTypes"
    ALTER COLUMN "Description" SET NOT NULL;

/*
INSERT INTO toms_lookups."BayLineTypes"("Code", "Description")
SELECT "BayLineTypes"."Code", "BayLineTypes"."Description"
FROM
      (SELECT "Code", "Description"
      FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=MasterLookups user=postgres password=password options=-csearch_path=',
		'SELECT "Code", "Description" FROM public."BayLineTypes"') AS "BayLineTypes"("Code" int, "Description" text)) AS "BayLineTypes";
*/

-- SignTypes

ALTER TABLE toms_lookups."SignTypes" DROP COLUMN id;

ALTER TABLE toms_lookups."SignTypes"
    ALTER COLUMN "Code" SET DEFAULT nextval('toms_lookups."SignTypes_Code_seq"'::regclass);

ALTER TABLE toms_lookups."SignTypes"
    ALTER COLUMN "Code" SET NOT NULL;

ALTER TABLE toms_lookups."SignTypes"
    ALTER COLUMN "Description" SET NOT NULL;
ALTER TABLE toms_lookups."SignTypes"
    ADD CONSTRAINT "SignTypes_pkey" PRIMARY KEY ("Code");

-- TimePeriods
--ALTER TABLE toms_lookups."TimePeriods" DROP COLUMN id;

ALTER TABLE toms_lookups."TimePeriods"
    ALTER COLUMN "Code" SET DEFAULT nextval('toms_lookups."TimePeriods_Code_seq"'::regclass);

/*
ALTER TABLE toms_lookups."TimePeriods"
    ALTER COLUMN "Code" SET NOT NULL;
ALTER TABLE toms_lookups."TimePeriods"
    ADD CONSTRAINT "TimePeriods_pkey" PRIMARY KEY ("Code");
*/

-- *** Create tables ...

-- GeomShapeGroupType
CREATE TABLE toms_lookups."GeomShapeGroupType"
(
    "Code" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "GeomShapeGroupType_pkey" PRIMARY KEY ("Code")
)
TABLESPACE pg_default;

ALTER TABLE toms_lookups."GeomShapeGroupType"
    OWNER to postgres;

--
-- TOC entry 4458 (class 0 OID 294812)
-- Dependencies: 285
-- Data for Name: GeomShapeGroupType; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."GeomShapeGroupType" ("Code") VALUES ('LineString');
INSERT INTO "toms_lookups"."GeomShapeGroupType" ("Code") VALUES ('Polygon');

-- BayTypesInUse
CREATE TABLE toms_lookups."BayTypesInUse"
(
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "StyleDetails" character varying COLLATE pg_catalog."default",
    CONSTRAINT "BayTypesInUse_pkey" PRIMARY KEY ("Code"),
    CONSTRAINT "BayTypesInUse_GeomShapeGroupType_fkey" FOREIGN KEY ("GeomShapeGroupType")
        REFERENCES toms_lookups."GeomShapeGroupType" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

ALTER TABLE toms_lookups."BayTypesInUse"
    OWNER to postgres;

--
-- TOC entry 4456 (class 0 OID 294802)
-- Dependencies: 283
-- Data for Name: BayTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (101, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (103, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (105, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (107, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (108, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (110, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (111, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (112, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (113, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (114, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (115, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (116, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (117, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (118, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (119, 'LineString', NULL);

INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (124, 'LineString', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (126, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (127, 'LineString', NULL);

INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (131, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (133, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (134, 'Polygon', NULL);
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (135, 'Polygon', NULL);

INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (140, 'Polygon', NULL);

INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (168, 'Polygon', NULL);


INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType")
SELECT DISTINCT "RestrictionTypeID", 'LineString'
FROM "toms"."Bays"
WHERE "RestrictionTypeID" NOT IN (
SELECT DISTINCT "Code"
FROM "toms_lookups"."BayTypesInUse");

-- LineTypesInUse
CREATE TABLE toms_lookups."LineTypesInUse"
(
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "StyleDetails" character varying COLLATE pg_catalog."default",
    CONSTRAINT "LineTypesInUse_pkey" PRIMARY KEY ("Code"),
    CONSTRAINT "LineTypesInUse_GeomShapeGroupType_fkey" FOREIGN KEY ("GeomShapeGroupType")
        REFERENCES toms_lookups."GeomShapeGroupType" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

ALTER TABLE toms_lookups."LineTypesInUse"
    OWNER to postgres;

--
-- TOC entry 4461 (class 0 OID 294823)
-- Dependencies: 288
-- Data for Name: LineTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (224, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (202, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (203, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (209, 'LineString', NULL);
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (214, 'LineString', NULL);

INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType")
SELECT DISTINCT "RestrictionTypeID", 'LineString'
FROM "toms"."Lines"
WHERE "RestrictionTypeID" NOT IN (
SELECT DISTINCT "Code"
FROM "toms_lookups"."LineTypesInUse");

-- RestrictionPolygonTypesInUse
CREATE TABLE toms_lookups."RestrictionPolygonTypesInUse"
(
    "Code" integer NOT NULL,
    "GeomShapeGroupType" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "StyleDetails" character varying COLLATE pg_catalog."default",
    CONSTRAINT "RestrictionPolygonTypesInUse_pkey" PRIMARY KEY ("Code"),
    CONSTRAINT "RestrictionPolygonTypesInUse_GeomShapeGroupType_fkey" FOREIGN KEY ("GeomShapeGroupType")
        REFERENCES toms_lookups."GeomShapeGroupType" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

ALTER TABLE toms_lookups."RestrictionPolygonTypesInUse"
    OWNER to postgres;

--
-- TOC entry 4469 (class 0 OID 294861)
-- Dependencies: 296
-- Data for Name: RestrictionPolygonTypesInUse; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (1, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (3, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (4, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (2, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (5, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (6, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (20, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (7, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (8, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (21, 'Polygon', NULL);
INSERT INTO "toms_lookups"."RestrictionPolygonTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (22, 'Polygon', NULL);

-- SignTypesInUse
CREATE TABLE toms_lookups."SignTypesInUse"
(
    "Code" integer NOT NULL,
    CONSTRAINT "SignTypesInUse_pkey" PRIMARY KEY ("Code")
)
TABLESPACE pg_default;

ALTER TABLE toms_lookups."SignTypesInUse"
    OWNER to postgres;

INSERT INTO "toms_lookups"."SignTypesInUse" ("Code")
SELECT DISTINCT "SignType_1"
FROM "toms"."Signs"
WHERE "SignType_1" IS NOT NULL
UNION
SELECT DISTINCT "SignType_2"
FROM "toms"."Signs"
WHERE "SignType_2" IS NOT NULL
UNION
SELECT DISTINCT "SignType_3"
FROM "toms"."Signs"
WHERE "SignType_3" IS NOT NULL
;

-- TimePeriodsInUse
CREATE TABLE toms_lookups."TimePeriodsInUse"
(
    "Code" integer NOT NULL,
    CONSTRAINT "TimePeriodsInUse_pkey" PRIMARY KEY ("Code")
)
TABLESPACE pg_default;

ALTER TABLE toms_lookups."TimePeriodsInUse"
    OWNER to postgres;

INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code")
SELECT DISTINCT "TimePeriodID"
FROM "toms"."Bays"
WHERE "TimePeriodID" IS NOT NULL
UNION
SELECT DISTINCT "NoWaitingTimeID"
FROM "toms"."Lines"
WHERE "NoWaitingTimeID" IS NOT NULL
UNION
SELECT DISTINCT "NoLoadingTimeID"
FROM "toms"."Lines"
WHERE "NoLoadingTimeID" IS NOT NULL;

-- SignOrientationTypes
CREATE TABLE toms_lookups."SignOrientationTypes"
(
    "Code" integer NOT NULL DEFAULT nextval('toms_lookups."SignOrientationTypes_Code_seq"'::regclass),
    "Description" character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "SignOrientationTypes_pkey" PRIMARY KEY ("Code")
)
TABLESPACE pg_default;

ALTER TABLE toms_lookups."SignOrientationTypes"
    OWNER to postgres;

-- UnacceptableTypes
CREATE TABLE toms_lookups."UnacceptableTypes"
(
    "Code" integer NOT NULL DEFAULT nextval('toms_lookups."UnacceptableTypes_Code_seq"'::regclass),
    "Description" character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "UnacceptableTypes_pkey" PRIMARY KEY ("Code")
)
TABLESPACE pg_default;

ALTER TABLE toms_lookups."UnacceptableTypes"
    OWNER to postgres;

--
-- TOC entry 4483 (class 0 OID 294922)
-- Dependencies: 310
-- Data for Name: UnacceptableTypes; Type: TABLE DATA; Schema: toms_lookups; Owner: postgres
--

INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (2, 'Narrow Road');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (3, 'Obstruction');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (1, 'Crossover (vehicles)');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (4, 'Crossover (pedestrians/other)');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (5, 'Other');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (6, 'Corner');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (7, 'Garage frontage');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (8, 'Traffic flow');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (9, 'Edge of bay');
INSERT INTO "toms_lookups"."UnacceptableTypes" ("Code", "Description") VALUES (10, 'Short section');

-- ConditionTypes
CREATE TABLE compliance_lookups."ConditionTypes"
(
    "Code" integer NOT NULL DEFAULT nextval('compliance_lookups."ConditionTypes_Code_seq"'::regclass),
    "Description" character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT "ConditionTypes_pkey" PRIMARY KEY ("Code")
)
TABLESPACE pg_default;

ALTER TABLE compliance_lookups."ConditionTypes"
    OWNER to postgres;

-- MHTC_CheckIssueTypes

CREATE SEQUENCE compliance_lookups."MHTC_CheckIssueType_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."MHTC_CheckIssueType_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE compliance_lookups."MHTC_CheckIssueType_Code_seq" TO postgres;

CREATE TABLE compliance_lookups."MHTC_CheckIssueTypes"
(
    "Code" integer NOT NULL DEFAULT nextval('compliance_lookups."MHTC_CheckIssueTypes_Code_seq"'::regclass),
    "Description" character varying COLLATE pg_catalog."default",
    CONSTRAINT "MHTC_CheckIssueType_pkey" PRIMARY KEY ("Code")
)

TABLESPACE pg_default;

ALTER TABLE compliance_lookups."MHTC_CheckIssueTypes"
    OWNER to postgres;

INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (0, 'Not sure');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (1, 'Item checked - Available for release');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (2, 'Not sure');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (4, 'Not sure');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (8, 'Not sure');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (9, 'Not sure');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (10, 'Field visit - Item missed - confirm location and details');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (11, 'Field visit - Photo missing or needs to be retaken');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (14, 'Not sure');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (15, 'Field visit - Check details (see notes)');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (16, 'Further office involvement required');
INSERT INTO "compliance_lookups"."MHTC_CheckIssueTypes" ("Code", "Description") VALUES (17, 'Item checked - Client involvement required');


--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 236
-- Name: MHTC_CheckIssueType_Code_seq; Type: SEQUENCE SET; Schema: compliance_lookups; Owner: postgres
--

SELECT pg_catalog.setval('"compliance_lookups"."MHTC_CheckIssueType_Code_seq"', 1, true);

-- Drop any tables not required at this point
--DROP TABLE public."Proposals_withGeom" CASCADE;
--DROP TABLE public."TimePeriods_orig" CASCADE;

-- Create materialised views ...
-- BayTypesInUse_View
CREATE MATERIALIZED VIEW toms_lookups."BayTypesInUse_View"
TABLESPACE pg_default
AS
 SELECT "BayTypesInUse"."Code",
    "BayLineTypes"."Description"
   FROM toms_lookups."BayTypesInUse",
    toms_lookups."BayLineTypes"
  WHERE "BayTypesInUse"."Code" = "BayLineTypes"."Code" AND "BayTypesInUse"."Code" < 200
WITH DATA;

ALTER TABLE toms_lookups."BayTypesInUse_View"
    OWNER TO postgres;

CREATE UNIQUE INDEX "BayTypesInUse_View_key"
    ON toms_lookups."BayTypesInUse_View" USING btree
    ("Code")
    TABLESPACE pg_default;

-- LineTypesInUse_View
CREATE MATERIALIZED VIEW toms_lookups."LineTypesInUse_View"
TABLESPACE pg_default
AS
 SELECT "LineTypesInUse"."Code",
    "BayLineTypes"."Description"
   FROM toms_lookups."LineTypesInUse",
    toms_lookups."BayLineTypes"
  WHERE "LineTypesInUse"."Code" = "BayLineTypes"."Code" AND "LineTypesInUse"."Code" > 200
WITH DATA;

ALTER TABLE toms_lookups."LineTypesInUse_View"
    OWNER TO postgres;

CREATE UNIQUE INDEX "LineTypesInUse_View_key"
    ON toms_lookups."LineTypesInUse_View" USING btree
    ("Code")
    TABLESPACE pg_default;

-- RestrictionPolygonTypesInUse_View
CREATE MATERIALIZED VIEW toms_lookups."RestrictionPolygonTypesInUse_View"
TABLESPACE pg_default
AS
 SELECT "RestrictionPolygonTypesInUse"."Code",
    "RestrictionPolygonTypes"."Description"
   FROM toms_lookups."RestrictionPolygonTypesInUse",
    toms_lookups."RestrictionPolygonTypes"
  WHERE "RestrictionPolygonTypesInUse"."Code" = "RestrictionPolygonTypes"."Code"
WITH DATA;

ALTER TABLE toms_lookups."RestrictionPolygonTypesInUse_View"
    OWNER TO postgres;

CREATE UNIQUE INDEX "RestrictionPolygonTypesInUse_View_key"
    ON toms_lookups."RestrictionPolygonTypesInUse_View" USING btree
    ("Code")
    TABLESPACE pg_default;

-- SignTypesInUse_View
CREATE MATERIALIZED VIEW toms_lookups."SignTypesInUse_View"
TABLESPACE pg_default
AS
 SELECT "SignTypesInUse"."Code",
    "SignTypes"."Description"
   FROM toms_lookups."SignTypesInUse",
    toms_lookups."SignTypes"
  WHERE "SignTypesInUse"."Code" = "SignTypes"."Code"
WITH DATA;

ALTER TABLE toms_lookups."SignTypesInUse_View"
    OWNER TO postgres;

CREATE UNIQUE INDEX "SignTypesInUse_View_key"
    ON toms_lookups."SignTypesInUse_View" USING btree
    ("Code")
    TABLESPACE pg_default;

-- TimePeriodsInUse_View
CREATE MATERIALIZED VIEW toms_lookups."TimePeriodsInUse_View"
TABLESPACE pg_default
AS
 SELECT "TimePeriodsInUse"."Code",
    "TimePeriods"."Description",
    "TimePeriods"."LabelText"
   FROM toms_lookups."TimePeriodsInUse",
    toms_lookups."TimePeriods"
  WHERE "TimePeriodsInUse"."Code" = "TimePeriods"."Code"
WITH DATA;

ALTER TABLE toms_lookups."TimePeriodsInUse_View"
    OWNER TO postgres;

CREATE UNIQUE INDEX "TimePeriodsInUse_View_key"
    ON toms_lookups."TimePeriodsInUse_View" USING btree
    ("Code")
    TABLESPACE pg_default;

-- SignConditionTypes
CREATE TABLE compliance_lookups."SignConditionTypes"
(
    "Code" integer NOT NULL DEFAULT nextval('compliance_lookups."SignConditionTypes_Code_seq"'::regclass),
    "Description" character varying COLLATE pg_catalog."default",
    CONSTRAINT "SignConditionTypes_pkey" PRIMARY KEY ("Code")
)
TABLESPACE pg_default;

ALTER TABLE compliance_lookups."SignConditionTypes"
    OWNER to postgres;

-- SignIlluminationTypes
CREATE TABLE compliance_lookups."SignIlluminationTypes"
(
    "Code" integer NOT NULL DEFAULT nextval('compliance_lookups."SignIlluminationTypes_Code_seq"'::regclass),
    "Description" character varying COLLATE pg_catalog."default",
    CONSTRAINT "SignIlluminationTypes_pkey" PRIMARY KEY ("Code")
)
TABLESPACE pg_default;

ALTER TABLE compliance_lookups."SignIlluminationTypes"
    OWNER to postgres;

-- itn_roadcentreline
CREATE TABLE highways_network.itn_roadcentreline
(
    gid integer NOT NULL DEFAULT nextval('highways_network.itn_roadcentreline_gid_seq'::regclass),
    toid character varying(16) COLLATE pg_catalog."default",
    version numeric(10,0),
    verdate date,
    theme character varying(80) COLLATE pg_catalog."default",
    descgroup character varying(150) COLLATE pg_catalog."default",
    descterm character varying(150) COLLATE pg_catalog."default",
    change character varying(80) COLLATE pg_catalog."default",
    topoarea character varying(20) COLLATE pg_catalog."default",
    nature character varying(80) COLLATE pg_catalog."default",
    lnklength numeric,
    node1 character varying(20) COLLATE pg_catalog."default",
    node1grade character varying(1) COLLATE pg_catalog."default",
    node1gra_1 numeric(10,0),
    node2 character varying(20) COLLATE pg_catalog."default",
    node2grade character varying(1) COLLATE pg_catalog."default",
    node2gra_1 numeric(10,0),
    loaddate date,
    objectid numeric(10,0),
    shape_leng numeric,
    geom geometry(MultiLineString,27700),
    CONSTRAINT itn_roadcentreline_pkey PRIMARY KEY (gid)
)
TABLESPACE pg_default;

ALTER TABLE highways_network.itn_roadcentreline
    OWNER to postgres;

CREATE INDEX edi_itn_roadcentreline_geom_idx
    ON highways_network.itn_roadcentreline USING gist
    (geom)
    TABLESPACE pg_default;

-- SiteArea
CREATE TABLE local_authority."SiteArea"
(
    "id" integer NOT NULL,
    name character varying(32) COLLATE pg_catalog."default",
    geom geometry(MultiPolygon,27700)
)
TABLESPACE pg_default;

CREATE SEQUENCE "local_authority"."SiteArea_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "local_authority"."SiteArea_id_seq" OWNER TO "postgres";

ALTER TABLE ONLY "local_authority"."SiteArea" ALTER COLUMN "id" SET DEFAULT "nextval"('"local_authority"."SiteArea_id_seq"'::"regclass");

ALTER TABLE ONLY "local_authority"."SiteArea"
    ADD CONSTRAINT "test_area_pkey" PRIMARY KEY ("id");

ALTER SEQUENCE "local_authority"."SiteArea_id_seq" OWNED BY "local_authority"."SiteArea"."id";

ALTER TABLE local_authority."SiteArea"
    OWNER to postgres;

CREATE INDEX site_area_geom_idx
    ON local_authority."SiteArea" USING gist
    (geom)
    TABLESPACE pg_default;

-- StreetGazetteerRecords
CREATE TABLE local_authority."StreetGazetteerRecords"
(
    id integer NOT NULL DEFAULT nextval('local_authority."StreetGazetteerRecords_id_seq"'::regclass),
    "ESUID" numeric,
    "USRN" numeric(10,0),
    "Custodian" numeric(10,0),
    "RoadName" character varying(254) COLLATE pg_catalog."default",
    "Locality" character varying(254) COLLATE pg_catalog."default",
    "Town" character varying(254) COLLATE pg_catalog."default",
    "Language" character varying(254) COLLATE pg_catalog."default",
    "StreetLength" numeric,
    geom geometry(MultiLineString,27700),
    CONSTRAINT gaz_usrn_pkey PRIMARY KEY (id)
)
TABLESPACE pg_default;

ALTER TABLE local_authority."StreetGazetteerRecords"
    OWNER to postgres;

CREATE INDEX gaz_usrn_geom_idx
    ON local_authority."StreetGazetteerRecords" USING gist
    (geom)
    TABLESPACE pg_default;

-- Corners
CREATE TABLE topography."Corners"
(
    id integer NOT NULL DEFAULT nextval('topography."Corners_id_seq"'::regclass),
    geom geometry(Point,27700),
    CONSTRAINT "Corners_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

ALTER TABLE topography."Corners"
    OWNER to postgres;

-- os_mastermap_topography_polygons
CREATE TABLE topography.os_mastermap_topography_polygons
(
    gid integer NOT NULL DEFAULT nextval('topography.os_mastermap_topography_polygons_gid_seq'::regclass),
    toid character varying(20) COLLATE pg_catalog."default",
    version numeric(10,0),
    verdate character varying(24) COLLATE pg_catalog."default",
    featcode numeric(10,0),
    theme character varying(80) COLLATE pg_catalog."default",
    calcarea numeric,
    change character varying(80) COLLATE pg_catalog."default",
    descgroup character varying(150) COLLATE pg_catalog."default",
    descterm character varying(150) COLLATE pg_catalog."default",
    make character varying(20) COLLATE pg_catalog."default",
    physlevel numeric(10,0),
    physpres character varying(20) COLLATE pg_catalog."default",
    broken integer,
    loaddate character varying(24) COLLATE pg_catalog."default",
    objectid numeric(10,0),
    shape_leng numeric,
    shape_area numeric,
    geom geometry(MultiPolygon,27700),
    CONSTRAINT os_mastermap_topography_polygons_pkey PRIMARY KEY (gid)
)

TABLESPACE pg_default;

ALTER TABLE topography.os_mastermap_topography_polygons
    OWNER to postgres;
CREATE INDEX os_mastermap_topography_polygons_geom_idx
    ON topography.os_mastermap_topography_polygons USING gist
    (geom)
    TABLESPACE pg_default;

-- os_mastermap_topography_text  ** TODO: May need to have two tables here - one for lines and one for points ...
CREATE TABLE topography.os_mastermap_topography_text
(
    gid integer NOT NULL DEFAULT nextval('topography.os_mastermap_topography_text_gid_seq'::regclass),
    toid character varying(20) COLLATE pg_catalog."default",
    featcode numeric(10,0),
    version numeric(10,0),
    verdate character varying(24) COLLATE pg_catalog."default",
    theme character varying(80) COLLATE pg_catalog."default",
    change character varying(80) COLLATE pg_catalog."default",
    descgroup character varying(150) COLLATE pg_catalog."default",
    descterm character varying(150) COLLATE pg_catalog."default",
    make character varying(20) COLLATE pg_catalog."default",
    physlevel numeric(10,0),
    physpres character varying(15) COLLATE pg_catalog."default",
    text_ character varying(250) COLLATE pg_catalog."default",
    textfont numeric(10,0),
    textpos numeric(10,0),
    textheight numeric,
    textangle numeric,
    loaddate character varying(24) COLLATE pg_catalog."default",
    objectid numeric(10,0),
    shape_leng numeric,
    geom geometry(MultiLineString,27700),
    CONSTRAINT os_mastermap_topography_text_pkey PRIMARY KEY (gid)
)

TABLESPACE pg_default;

ALTER TABLE topography.os_mastermap_topography_text
    OWNER to postgres;

CREATE INDEX os_mastermap_topography_text_geom_idx
    ON topography.os_mastermap_topography_text USING gist
    (geom)
    TABLESPACE pg_default;

-- road_casement

CREATE SEQUENCE topography."road_casement_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE topography."road_casement_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE topography."road_casement_id_seq" TO postgres;

CREATE TABLE topography.road_casement
(
    id integer NOT NULL DEFAULT nextval('topography."road_casement_id_seq"'::regclass),
    geom geometry(LineString,27700),
    "RoadName" character varying(100) COLLATE pg_catalog."default",
    "ESUID" double precision,
    "USRN" integer,
    "Locality" character varying(255) COLLATE pg_catalog."default",
    "Town" character varying(255) COLLATE pg_catalog."default",
    "Az" double precision,
    "StartStreet" character varying(254) COLLATE pg_catalog."default",
    "EndStreet" character varying(254) COLLATE pg_catalog."default",
    "SideOfStreet" character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT road_casement_pkey PRIMARY KEY (id)
)
TABLESPACE pg_default;

ALTER TABLE topography.road_casement
    OWNER to postgres;

-- **** Create new trigger functions
-- create_geometryid
CREATE FUNCTION toms.create_geometryid()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	 nextSeqVal varchar := '';
BEGIN

	CASE TG_TABLE_NAME
	WHEN 'Bays' THEN
			SELECT concat('B_', to_char(nextval('toms."Bays_id_seq"'::regclass), 'FM0000000'::text)) INTO nextSeqVal;
	WHEN 'Lines' THEN
		   SELECT concat('L_', to_char(nextval('toms."Lines_id_seq"'::regclass), 'FM0000000'::text)) INTO nextSeqVal;
	WHEN 'Signs' THEN
		   SELECT concat('S_', to_char(nextval('toms."Signs_id_seq"'::regclass), 'FM0000000'::text)) INTO nextSeqVal;
	WHEN 'RestrictionPolygons' THEN
		   SELECT concat('P_', to_char(nextval('toms."RestrictionPolygons_id_seq"'::regclass), 'FM0000000'::text)) INTO nextSeqVal;
	WHEN 'ControlledParkingZones' THEN
		   SELECT concat('C_', to_char(nextval('toms."ControlledParkingZones_id_seq"'::regclass), 'FM0000000'::text)) INTO nextSeqVal;
	WHEN 'ParkingTariffAreas' THEN
		   SELECT concat('T_', to_char(nextval('toms."ParkingTariffAreas_id_seq"'::regclass), 'FM0000000'::text)) INTO nextSeqVal;
	ELSE
	    nextSeqVal = 'U';
	END CASE;

    NEW."GeometryID" := nextSeqVal;
	RETURN NEW;

END;
$BODY$;

ALTER FUNCTION toms.create_geometryid()
    OWNER TO postgres;

-- set_last_update_details
CREATE FUNCTION toms.set_last_update_details()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
    BEGIN
	    -- round to two decimal places
        NEW."LastUpdateDateTime" := now();
        NEW."LastUpdatePerson" := current_user;

        RETURN NEW;
    END;
$BODY$;

ALTER FUNCTION toms.set_last_update_details()
    OWNER TO postgres;

-- set_restriction_length
CREATE FUNCTION toms.set_restriction_length()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
    BEGIN
	    -- round to two decimal places
        NEW."RestrictionLength" := ROUND(ST_Length (NEW."geom")::numeric,2);

        RETURN NEW;
    END;
$BODY$;

ALTER FUNCTION toms.set_restriction_length()
    OWNER TO postgres;



