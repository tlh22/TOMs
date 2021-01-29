-- Bays

ALTER TABLE ONLY toms."Bays"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('B_', to_char(nextval('toms."Bays_id_seq"'::regclass), 'FM0000000'::text));

-- deal with nulls

UPDATE public."Bays"
SET "MaxStayID" = 12
WHERE "MaxStayID" = 0;

UPDATE public."Bays"
SET "NoReturnID" = 12
WHERE "NoReturnID" = 0;

UPDATE public."Bays"
SET "PayTypeID" = 1
WHERE "PayTypeID" = 0;

INSERT INTO toms."Bays"(
	"RestrictionID", geom, "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine",
	"Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN",
	"CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays",
	"TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded",
	"MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "PermitCode",
	"CreateDateTime", "CreatePerson")
SELECT uuid_generate_v4(), "SHAPE", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine",
"BaysNotes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN",
"CPZ", "LastUpdate_DateTime", "LastUpdate_Person", "BayOrientation", "NrBays",
COALESCE("TimePeriodID", 1), COALESCE("PayTypeID", 1), COALESCE("MaxStayID", 12), COALESCE("NoReturnID", 12), "ParkingTariffArea", "AdditionalConditionID", "ComplianceIssueID",
"MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "PermitCode",
"SurveyDateTime", "Surveyor"
	FROM public."Bays";

-- Lines

INSERT INTO toms."Lines"(
	"RestrictionID", geom, "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine",
	"Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN",
	"CPZ", "LastUpdateDateTime", "LastUpdatePerson",
	"NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ComplianceRoadMarkingsFaded",
	"MHTC_CheckIssueTypeID", "MHTC_CheckNotes",
	"CreateDateTime", "CreatePerson")
SELECT uuid_generate_v4(), "SHAPE", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine",
"LinesNotes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN",
"CPZ", "LastUpdate_DateTime", "LastUpdate_Person",
"NoWaitingTimeID", "NoLoadingTimeID", "Unacceptability", "AdditionalConditionID", "ComplianceIssueID",
"MHTC_CheckIssueTypeID", "MHTC_CheckNotes",
"SurveyDateTime", "Surveyor"
	FROM public."Lines";

-- Signs


-- RestrictionPolygons


-- CPZs

