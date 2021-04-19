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
ALTER TABLE public."LookupCodeTransfers_Bays"  SET SCHEMA transfer;
ALTER TABLE public."LookupCodeTransfers_Lines"  SET SCHEMA transfer;

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

ALTER TABLE toms."RestrictionsInProposals" DROP CONSTRAINT "RestrictionsInProposals_ActionOnProposalAcceptance_fkey";
ALTER TABLE toms."RestrictionsInProposals" DROP CONSTRAINT "RestrictionsInProposals_RestrictionTableID_fkey";
ALTER TABLE toms."RestrictionsInProposals" DROP CONSTRAINT "RestrictionsInProposals_pk";

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

INSERT INTO toms_lookups."BayLineTypes"("Code")
SELECT DISTINCT CAST("CurrCode" AS int)
FROM transfer."LookupCodeTransfers_Bays"
UNION
SELECT DISTINCT CAST("CurrCode" AS int)
FROM transfer."LookupCodeTransfers_Lines"
ORDER BY "CurrCode";

---

INSERT INTO "toms_lookups"."BayLineTypes" ("Code", "Description")
SELECT "Master_BayLineTypes"."Code", "Master_BayLineTypes"."Description"
FROM
      (SELECT "Code", "Description"
      FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=MasterLookups user=postgres password=password options=-csearch_path=',
		'SELECT "Code", "Description" FROM public."BayLineTypes"') AS "BayLineTypes"("Code" int, "Description" text)) AS "Master_BayLineTypes"
       WHERE "Code" NOT IN (
       SELECT DISTINCT "Code"
       FROM "toms_lookups"."BayLineTypes");

UPDATE "toms_lookups"."BayLineTypes" AS c
SET "Description" = m."Description"
FROM (SELECT "Code", "Description"
      FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=MasterLookups user=postgres password=password options=-csearch_path=',
		'SELECT "Code", "Description" FROM public."BayLineTypes"') AS "BayLineTypes"("Code" int, "Description" text)) AS "m"
WHERE c."Code" = m."Code"
AND c."Description" IS NULL;

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
ALTER TABLE toms_lookups."TimePeriods" DROP COLUMN id;

ALTER TABLE toms_lookups."TimePeriods"
    ALTER COLUMN "Code" SET DEFAULT nextval('toms_lookups."TimePeriods_Code_seq"'::regclass);

ALTER TABLE toms_lookups."TimePeriods"
    ALTER COLUMN "Code" SET NOT NULL;
ALTER TABLE toms_lookups."TimePeriods"
    ADD CONSTRAINT "TimePeriods_pkey" PRIMARY KEY ("Code");

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

CREATE TABLE compliance_lookups."MHTC_CheckIssueType"
(
    "Code" integer NOT NULL DEFAULT nextval('compliance_lookups."MHTC_CheckIssueTypes_Code_seq"'::regclass),
    "Description" character varying COLLATE pg_catalog."default",
    CONSTRAINT "MHTC_CheckIssueType_pkey" PRIMARY KEY ("Code")
)

TABLESPACE pg_default;

ALTER TABLE compliance_lookups."MHTC_CheckIssueType"
    OWNER to postgres;


-- Drop any tables not required at this point
DROP TABLE public."Proposals_withGeom" CASCADE;
DROP TABLE public."TimePeriods_orig" CASCADE;

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
			SELECT concat('B_', to_char(nextval('toms."Bays_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'Lines' THEN
		   SELECT concat('L_', to_char(nextval('toms."Lines_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'Signs' THEN
		   SELECT concat('S_', to_char(nextval('toms."Signs_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'RestrictionPolygons' THEN
		   SELECT concat('P_', to_char(nextval('toms."RestrictionPolygons_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'ControlledParkingZones' THEN
		   SELECT concat('C_', to_char(nextval('toms."ControlledParkingZones_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'ParkingTariffAreas' THEN
		   SELECT concat('T_', to_char(nextval('toms."ParkingTariffAreas_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
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


---- *** Change structure of tables  ***
-- Bays

ALTER TABLE toms."Bays" DROP CONSTRAINT "Bays_pkey";

ALTER TABLE toms."Bays" DROP COLUMN id;

ALTER TABLE toms."Bays" RENAME COLUMN "Length" TO "RestrictionLength";
--ALTER TABLE toms."Bays" ALTER COLUMN "RestrictionLength" SET NOT NULL;

ALTER TABLE toms."Bays" RENAME COLUMN "Bays_DateTime" TO "LastUpdateDateTime";

ALTER TABLE toms."Bays" RENAME COLUMN "BaysWordingID" TO "AdditionalConditionID";

ALTER TABLE toms."Bays" RENAME COLUMN "Surveyor" TO "LastUpdatePerson" ;
UPDATE toms."Bays" SET "LastUpdatePerson" = 'CEC' WHERE "LastUpdatePerson" IS NULL;
ALTER TABLE toms."Bays"
    ALTER COLUMN "LastUpdatePerson" SET NOT NULL;

ALTER TABLE toms."Bays" DROP COLUMN "BaysGeometry";

ALTER TABLE toms."Bays" DROP COLUMN "Bays_PhotoTaken";

ALTER TABLE toms."Bays" RENAME COLUMN "Compl_Bays_Faded" TO "ComplianceRoadMarkingsFaded";

ALTER TABLE toms."Bays" RENAME COLUMN "Compl_Bays_SignIssue" TO "ComplianceRestrictionSignIssue";

ALTER TABLE toms."Bays" RENAME COLUMN "Bays_Photos_01" TO "Photos_01";

ALTER TABLE toms."Bays" RENAME COLUMN "Bays_Photos_02" TO "Photos_02";

ALTER TABLE toms."Bays" DROP COLUMN "OriginalGeomShapeID";

ALTER TABLE toms."Bays" DROP COLUMN "GeometryID_181017";

ALTER TABLE toms."Bays"
   ALTER COLUMN "GeometryID" TYPE character varying(12) COLLATE pg_catalog."default";
ALTER TABLE toms."Bays"
    ALTER COLUMN "GeometryID" SET DEFAULT ('B_'::text || to_char(nextval('toms."Bays_id_seq"'::regclass), '000000000'::text));

ALTER TABLE toms."Bays"
    ALTER COLUMN "RestrictionTypeID" SET NOT NULL;

ALTER TABLE toms."Bays"
    ALTER COLUMN "GeomShapeID" SET NOT NULL;

ALTER TABLE toms."Bays"
    ALTER COLUMN "NrBays" SET NOT NULL;

ALTER TABLE toms."Bays"
    ALTER COLUMN "TimePeriodID" SET NOT NULL;

ALTER TABLE toms."Bays"
    ADD COLUMN "Photos_03" character varying(255) COLLATE pg_catalog."default";

ALTER TABLE toms."Bays"
    ADD COLUMN "ComplianceNotes" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."Bays"
    ADD COLUMN "MHTC_CheckIssueTypeID" integer;

ALTER TABLE toms."Bays"
    ADD COLUMN "MHTC_CheckNotes" character varying(254) COLLATE pg_catalog."default";
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
    REFERENCES compliance_lookups."MHTC_CheckIssueType" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Bays_MHTC_CheckIssueTypeID"
    ON toms."Bays"("MHTC_CheckIssueTypeID");

ALTER TABLE toms."Bays"
    ADD CONSTRAINT "Bays_MaxStayID_fkey" FOREIGN KEY ("MaxStayID")
    REFERENCES toms_lookups."LengthOfTime" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Bays_MaxStayID"
    ON toms."Bays"("MaxStayID");

ALTER TABLE toms."Bays"
    ADD CONSTRAINT "Bays_NoReturnID_fkey" FOREIGN KEY ("NoReturnID")
    REFERENCES toms_lookups."LengthOfTime" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
CREATE INDEX "idx_Bays_NoReturnID"
    ON toms."Bays"("NoReturnID");

ALTER TABLE toms."Bays"
    ADD CONSTRAINT "Bays_PayTypeID_fkey" FOREIGN KEY ("PayTypeID")
    REFERENCES toms_lookups."PaymentTypes" ("Code") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE INDEX "idx_Bays_PayTypeID"
    ON toms."Bays"("PayTypeID");

ALTER TABLE toms."Bays"
    DROP CONSTRAINT IF EXISTS "Bays_RestrictionTypeID_fkey";

ALTER TABLE ONLY "toms"."Bays"
    ADD CONSTRAINT "Bays_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID")
    REFERENCES "toms_lookups"."BayTypesInUse"("Code");

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
    ALTER COLUMN "RestrictionID" SET NOT NULL;

ALTER TABLE toms."ControlledParkingZones"
    ALTER COLUMN "GeometryID" TYPE character varying(12) COLLATE pg_catalog."default";
ALTER TABLE toms."ControlledParkingZones"
    ALTER COLUMN "GeometryID" SET DEFAULT ('C_'::text || to_char(nextval('toms."ControlledParkingZones_id_seq"'::regclass), '000000000'::text));

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

UPDATE toms."ControlledParkingZones" SET "LastUpdateDateTime" = '2018-01-01'::date
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
    REFERENCES compliance_lookups."MHTC_CheckIssueType" ("Code") MATCH SIMPLE
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

ALTER TABLE toms."Lines" DROP CONSTRAINT "Lines_pkey";
ALTER TABLE toms."Lines" DROP COLUMN id;

ALTER TABLE toms."Lines" RENAME COLUMN "Length" TO "RestrictionLength";
ALTER TABLE toms."Lines" ALTER COLUMN "RestrictionLength" SET NOT NULL;

ALTER TABLE toms."Lines" RENAME COLUMN "Lines_DateTime" TO "LastUpdateDateTime";

ALTER TABLE toms."Lines" RENAME COLUMN "Surveyor" TO "LastUpdatePerson" ;
UPDATE toms."Lines" SET "LastUpdatePerson" = 'CEC' WHERE "LastUpdatePerson" IS NULL;
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
    ALTER COLUMN "GeometryID" SET DEFAULT ('L_'::text || to_char(nextval('toms."Lines_id_seq"'::regclass), '000000000'::text));

ALTER TABLE toms."Lines"
    ALTER COLUMN "RestrictionTypeID" SET NOT NULL;

ALTER TABLE toms."Lines"
    ALTER COLUMN "GeomShapeID" SET NOT NULL;

ALTER TABLE toms."Lines"
    ADD COLUMN "label_TextChanged" character varying(254) COLLATE pg_catalog."default";

ALTER TABLE toms."Lines"
    ADD COLUMN "AdditionalConditionID" integer;

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
    REFERENCES compliance_lookups."MHTC_CheckIssueType" ("Code") MATCH SIMPLE
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

ALTER TABLE toms."Lines"
    DROP CONSTRAINT IF EXISTS "Lines_RestrictionTypeID_fkey";

ALTER TABLE ONLY "toms"."Lines"
    ADD CONSTRAINT "Lines_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID")
    REFERENCES "toms_lookups"."LineTypesInUse"("Code");

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
    ALTER COLUMN "GeometryID" SET DEFAULT ('T_'::text || to_char(nextval('toms."ParkingTariffAreas_id_seq"'::regclass), '000000000'::text));

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
    REFERENCES compliance_lookups."MHTC_CheckIssueType" ("Code") MATCH SIMPLE
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
    ALTER COLUMN "GeometryID" SET DEFAULT ('P_'::text || to_char(nextval('toms."RestrictionPolygons_id_seq"'::regclass), '000000000'::text));

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
    REFERENCES compliance_lookups."MHTC_CheckIssueType" ("Code") MATCH SIMPLE
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

UPDATE toms."Signs" SET "LastUpdatePerson" = 'CEC' WHERE "LastUpdatePerson" IS NULL;

ALTER TABLE toms."Signs"
    ALTER COLUMN "LastUpdatePerson" SET NOT NULL;

ALTER TABLE toms."Signs" RENAME COLUMN "Compl_Signs_Direction" TO "Compl_Sign_Direction";

ALTER TABLE toms."Signs" DROP COLUMN "GeometryID_181017";

ALTER TABLE toms."Signs" DROP COLUMN "CPZ";

ALTER TABLE toms."Signs" DROP COLUMN "ParkingTariffArea";

ALTER TABLE toms."Signs"
    ALTER COLUMN "GeometryID" TYPE character varying(12) COLLATE pg_catalog."default";

ALTER TABLE toms."Signs"
    ALTER COLUMN "GeometryID" SET DEFAULT ('S_'::text || to_char(nextval('toms."Signs_id_seq"'::regclass), '000000000'::text));

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
    REFERENCES compliance_lookups."MHTC_CheckIssueType" ("Code") MATCH SIMPLE
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



