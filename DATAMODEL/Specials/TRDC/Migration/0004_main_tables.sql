
-- Bays

ALTER TABLE toms."Bays" DISABLE TRIGGER "set_last_update_details_Bays";
ALTER TABLE toms."Bays" DISABLE TRIGGER "set_create_details_Bays";

ALTER TABLE ONLY toms."Bays"
    ALTER COLUMN "GeometryID" SET DEFAULT concat('B_', to_char(nextval('toms."Bays_id_seq"'::regclass), 'FM0000000'::text));

-- deal with nulls

UPDATE public."Bays"
SET "MaxStayID" = NULL
WHERE "MaxStayID" = 0;

UPDATE public."Bays"
SET "NoReturnID" = NULL
WHERE "NoReturnID" = 0;

UPDATE public."Bays"
SET "PayTypeID" = NULL
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
"CPZ", COALESCE("LastUpdate_DateTime", '2020-01-01'), COALESCE("LastUpdate_Person", 'MHTC'), "BayOrientation", "NrBays",
COALESCE("TimePeriodID", 1), COALESCE("PayTypeID", 1), COALESCE("MaxStayID", 12), COALESCE("NoReturnID", 12), "ParkingTariffArea", "AdditionalConditionID", "ComplianceIssueID",
CASE WHEN "MHTC_CheckIssueTypeID" = 0 THEN NULL
     ELSE "MHTC_CheckIssueTypeID" END,
"MHTC_CheckNotes", "PermitCode",
COALESCE("SurveyDateTime", '2020-01-01'), COALESCE("Surveyor", 'MHTC')
	FROM public."Bays";

-- Lines

ALTER TABLE toms."Lines" DISABLE TRIGGER "set_last_update_details_Lines";
ALTER TABLE toms."Lines" DISABLE TRIGGER "set_create_details_Lines";

UPDATE public."Lines"
SET "Unacceptability" = NULL
WHERE "Unacceptability" = 0;

INSERT INTO toms."Lines"(
	"RestrictionID", geom, "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine",
	"Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN",
	"CPZ", "LastUpdateDateTime", "LastUpdatePerson",
	"NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ComplianceRoadMarkingsFaded",
	"MHTC_CheckIssueTypeID", "MHTC_CheckNotes",
	"CreateDateTime", "CreatePerson")
SELECT uuid_generate_v4(), "SHAPE", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine",
"LinesNotes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN",
"CPZ", COALESCE("LastUpdate_DateTime", '2020-01-01'), COALESCE("LastUpdate_Person", 'MHTC'),
"NoWaitingTimeID", "NoLoadingTimeID", "Unacceptability", "AdditionalConditionID", "ComplianceIssueID",
CASE WHEN "MHTC_CheckIssueTypeID" = 0 THEN NULL
     ELSE "MHTC_CheckIssueTypeID" END, "MHTC_CheckNotes",
COALESCE("SurveyDateTime", '2020-01-01'), COALESCE("Surveyor", 'MHTC')
	FROM public."Lines"
	WHERE "RestrictionTypeID" IS NOT NULL;

-- Signs
ALTER TABLE toms."Signs" DISABLE TRIGGER "set_last_update_details_Signs";
ALTER TABLE toms."Signs" DISABLE TRIGGER "set_create_details_Signs";

INSERT INTO toms."Signs"(
	"RestrictionID", geom, "Photos_01", "Photos_02", "Photos_03",
	"Notes", "RoadName", "USRN",
	"LastUpdateDateTime", "LastUpdatePerson",
	"SignType_1", "SignType_2", "SignType_3", "SignType_4",
	"MHTC_CheckIssueTypeID", "MHTC_CheckNotes",
	"CreateDateTime", "CreatePerson")
SELECT uuid_generate_v4(), "SHAPE", "Photos_01", "Photos_02", "Photos_03",
"SignNotes", "RoadName", "USRN",
COALESCE("LastUpdate_DateTime", '2020-01-01'), COALESCE("LastUpdate_Person", 'MHTC'),
"SignType_1", "SignType_2", "SignType_3", "SignType_4",
CASE WHEN "MHTC_CheckIssueTypeID" = 0 THEN NULL
     ELSE "MHTC_CheckIssueTypeID" END, "MHTC_CheckNotes",
COALESCE("SignDate", '2020-01-01'), COALESCE("Surveyor", 'MHTC')
	FROM public."Signs";

-- RestrictionPolygons

ALTER TABLE toms."RestrictionPolygons" DISABLE TRIGGER "set_last_update_details_RestrictionPolygons";
ALTER TABLE toms."RestrictionPolygons" DISABLE TRIGGER "set_create_details_RestrictionPolygons";

INSERT INTO toms."RestrictionPolygons"(
	"RestrictionID", geom, "RestrictionTypeID", "GeomShapeID",
	"Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN",
	"LastUpdateDateTime", "LastUpdatePerson",
	"NoWaitingTimeID", "NoLoadingTimeID", "TimePeriodID", "AreaPermitCode",
	"CPZ",
	"MHTC_CheckIssueTypeID", "MHTC_CheckNotes",
	"CreateDateTime", "CreatePerson")
SELECT uuid_generate_v4(), geom, "RestrictionTypeID", 50,
"Polygons_Photos_01", "Polygons_Photos_02", "Polygons_Photos_03", "RoadName", "USRN",
COALESCE("LastUpdate_DateTime", '2020-01-01'), COALESCE("LastUpdate_Person", 'MHTC'),
"NoWaitingTimeID", "NoLoadingTimeID", "TimePeriodID", "AreaPermitCode",
"CPZ",
CASE WHEN "MHTC_CheckIssueTypeID" = 0 THEN NULL
     ELSE "MHTC_CheckIssueTypeID" END, "MHTC_CheckNotes",
'2020-01-01', 'MHTC'
	FROM public."RestrictionPolygons";

-- CPZs

ALTER TABLE toms."ControlledParkingZones" DISABLE TRIGGER "set_last_update_details_ControlledParkingZones";
ALTER TABLE toms."ControlledParkingZones" DISABLE TRIGGER "set_create_details_ControlledParkingZones";

INSERT INTO toms."ControlledParkingZones"(
	"RestrictionID", geom , "RestrictionTypeID",
	"CPZ",
	"LastUpdateDateTime", "LastUpdatePerson",
	"TimePeriodID",
	"CreateDateTime", "CreatePerson")
SELECT uuid_generate_v4(), (ST_Dump(geom)).geom, 20,
"CPZ",
'2020-01-01', 'MHTC',
"WaitingTimeID",
'2020-01-01', 'MHTC'
	FROM public."CPZs";


-- Tidy geomshape details for Bays

UPDATE toms."Bays"
SET "GeomShapeID" = "GeomShapeID" + 20
WHERE "RestrictionTypeID" IN (131, 133, 134, 145)
AND "GeomShapeID" < 20;

-- Tidy CPZ details
UPDATE toms."Bays" AS r
SET "CPZ" = c."CPZ"
FROM toms."ControlledParkingZones" c
WHERE r."CPZ" IS NULL
AND ST_Within(r.geom, c.geom)
AND r."RestrictionTypeID" IN (101, 131);

UPDATE toms."Lines" AS r
SET "CPZ" = c."CPZ"
FROM toms."ControlledParkingZones" c
WHERE r."CPZ" IS NULL
AND ST_Within(r.geom, c.geom)
AND r."RestrictionTypeID" IN (224);

ALTER TABLE toms."Bays" ENABLE TRIGGER all;
ALTER TABLE toms."Lines" ENABLE TRIGGER all;
ALTER TABLE toms."Signs" ENABLE TRIGGER all;
ALTER TABLE toms."RestrictionPolygons" ENABLE TRIGGER all;
ALTER TABLE toms."ControlledParkingZones" ENABLE TRIGGER all;