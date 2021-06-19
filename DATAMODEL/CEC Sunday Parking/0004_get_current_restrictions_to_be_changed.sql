/**
These are restrictions that are currently open (and were open prior to the Acceptance of the Proposal) for which the TimePeriod should be changed.

Process is:
a. add these to Proposal (??) as closed restrictions
b. set the close date to the date of Proposal (??)
c. clone these with the new time period and set open date to the date of Proposal (??)
d. add cloned details to RiP as open restrictions

** Also need CPZs/PTAs

Proposals are:
71 - Zone 1
44 - Zone 1A
47 - Zone 3
59 - Zone 4
Zone 2 ??

(r."OpenDate" > ''2020-11-09'' OR r."CloseDate" > ''2020-11-09'')

**/

-- Bays
DO
$do$
DECLARE
   row RECORD;
   curr_proposal_id int := 44;
   layer_name RECORD;
   curr_uuid uuid;
   restriction_table_id int := 2;  -- Bays
BEGIN

    ALTER TABLE toms."Bays" DISABLE TRIGGER "set_create_details_Bays";
    ALTER TABLE toms."Bays" DISABLE TRIGGER "insert_mngmt";

    FOR row IN
        SELECT r."GeometryID", r."RestrictionID", c."Code", t1."Description", c."ChangedTo", t2."Description"
        FROM
        (
        SELECT "Code",
        CASE
                 WHEN "Code" = 12 THEN 311
                 WHEN "Code" = 14 THEN 313
                 WHEN "Code" = 33 THEN 309
                 WHEN "Code" = 39 THEN 308
                 WHEN "Code" = 97 THEN 315
                 WHEN "Code" = 98 THEN 314
                 WHEN "Code" = 99 THEN 316
                 WHEN "Code" = 120 THEN 317
                 WHEN "Code" = 121 THEN 312
                 WHEN "Code" = 155 THEN 307
                 WHEN "Code" = 159 THEN 317
                 WHEN "Code" = 213 THEN 306
                 WHEN "Code" = 217 THEN 310
        END AS "ChangedTo"
        FROM toms_lookups."TimePeriods" t
        WHERE "Code" IN (33, 39, 98, 99, 120, 121, 155, 159, 213)
        ) As c,
        toms_lookups."TimePeriods" t1, toms_lookups."TimePeriods" t2, toms."Bays"r
        WHERE c."Code" = t1."Code"
        AND c."ChangedTo" = t2."Code"
        AND r."OpenDate" IS NOT NULL
        AND r."CloseDate" IS NULL
        AND r."CPZ" IN ('1', '1A', '2', '3', '4')
        AND r."OpenDate" < '2020-11-09'
        AND r."TimePeriodID" = c."Code"

    LOOP

        RAISE NOTICE '***** CONSIDERING geom GeomID: %', row."GeometryID";
        -- add these to Proposal (??) as closed restrictions

        -- Add restriction to Proposal - as Closed
        INSERT INTO toms."RestrictionsInProposals"(
	        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	    VALUES (curr_proposal_id, restriction_table_id, 2, row."RestrictionID");

        RAISE NOTICE '***** Added to RiP ...';

        -- Close restriction
        UPDATE toms."Bays"
        SET "CloseDate" = '2020-11-09'
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Closed in Bays ...';

        -- get uuid value
        SELECT uuid_generate_v4() INTO curr_uuid;

        -- Clone, update time period and open restriction
        INSERT INTO toms."Bays"("RestrictionID", --"GeometryID",
            geom, "RestrictionLength", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "LastUpdateDateTime", "AdditionalConditionID", "LastUpdatePerson", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "Photos_01", "Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "Photos_03", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "PermitCode", "MatchDayTimePeriodID", "PayParkingAreaID", "Last_MHTC_Check_UpdateDateTime", "Last_MHTC_Check_UpdatePerson", "FieldCheckCompleted", "CreateDateTime", "CreatePerson", "Capacity", label_pos, label_ldr, "MatchDayEventDayZone")
        SELECT curr_uuid,
            geom, "RestrictionLength", "RestrictionTypeID", "NrBays", row."ChangedTo", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "LastUpdateDateTime", "AdditionalConditionID", "LastUpdatePerson", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "Photos_01", "Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_Rotation", "label_TextChanged", "BayOrientation", '2020-11-09', NULL, "CPZ", "ParkingTariffArea", "Photos_03", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "PermitCode", "MatchDayTimePeriodID", "PayParkingAreaID", "Last_MHTC_Check_UpdateDateTime", "Last_MHTC_Check_UpdatePerson", "FieldCheckCompleted", now(), 'Sunday Parking Hours - Mk2', "Capacity", label_pos, label_ldr, "MatchDayEventDayZone"
        FROM toms."Bays"
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Cloned and opened ... %', curr_uuid;

        -- add cloned details to RiP

        INSERT INTO toms."RestrictionsInProposals"(
	        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	    VALUES (curr_proposal_id, restriction_table_id, 1, curr_uuid);

        RAISE NOTICE '***** clone added to RiP ...';

    END LOOP;

    ALTER TABLE toms."Bays" ENABLE TRIGGER "set_create_details_Bays";
    ALTER TABLE toms."Bays" ENABLE TRIGGER "insert_mngmt";

END
$do$;

-- Lines
DO
$do$
DECLARE
   row RECORD;
   curr_proposal_id int := 44;
   layer_name RECORD;
   curr_uuid uuid;
   restriction_table_id int := 3;  -- Lines
BEGIN

    ALTER TABLE toms."Lines" DISABLE TRIGGER "set_create_details_Lines";
    ALTER TABLE toms."Lines" DISABLE TRIGGER "insert_mngmt";

    FOR row IN
        SELECT r."GeometryID", r."RestrictionID", c."Code", t1."Description", c."ChangedTo", t2."Description"
        FROM
        (
        SELECT "Code",
        CASE
                 WHEN "Code" = 12 THEN 311
                 WHEN "Code" = 14 THEN 313
                 WHEN "Code" = 33 THEN 309
                 WHEN "Code" = 39 THEN 308
                 WHEN "Code" = 97 THEN 315
                 WHEN "Code" = 98 THEN 314
                 WHEN "Code" = 99 THEN 316
                 WHEN "Code" = 120 THEN 317
                 WHEN "Code" = 121 THEN 312
                 WHEN "Code" = 155 THEN 307
                 WHEN "Code" = 159 THEN 317
                 WHEN "Code" = 213 THEN 306
                 WHEN "Code" = 217 THEN 310
        END AS "ChangedTo"
        FROM toms_lookups."TimePeriods" t
        WHERE "Code" IN (33, 39, 98, 99, 120, 121, 155, 159, 213)
        ) As c,
        toms_lookups."TimePeriods" t1, toms_lookups."TimePeriods" t2, toms."Lines" r
        WHERE c."Code" = t1."Code"
        AND c."ChangedTo" = t2."Code"
        AND r."OpenDate" IS NOT NULL
        AND r."CloseDate" IS NULL
        AND r."CPZ" IN ('1', '1A', '2', '3', '4')
        AND r."OpenDate" < '2020-11-09'
        AND r."NoWaitingTimeID" = c."Code"

    LOOP

        RAISE NOTICE '***** CONSIDERING geom GeomID: %', row."GeometryID";
        -- add these to Proposal (??) as closed restrictions

        -- Add restriction to Proposal - as Closed
        INSERT INTO toms."RestrictionsInProposals"(
	        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	    VALUES (curr_proposal_id, restriction_table_id, 2, row."RestrictionID");

        RAISE NOTICE '***** Added to RiP ...';

        -- Close restriction
        UPDATE toms."Lines"
        SET "CloseDate" = '2020-11-09'
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Closed in Lines ...';

        -- get uuid value
        SELECT uuid_generate_v4() INTO curr_uuid;

        -- Clone, update time period and open restriction
        INSERT INTO toms."Lines"("RestrictionID",
            geom, "RestrictionLength", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "LastUpdateDateTime", "LastUpdatePerson", "Lines_PhotoTaken", "Photos_01", "ComplianceRoadMarkingsFaded", "Photos_02", "ComplianceRestrictionSignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "label_Rotation", "Photos_03", "UnacceptableTypeID", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoading_Rotation", "label_TextChanged", "AdditionalConditionID", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "ComplianceLoadingMarkingsFaded", "MatchDayTimePeriodID", "Last_MHTC_Check_UpdateDateTime", "Last_MHTC_Check_UpdatePerson", "FieldCheckCompleted", "CreateDateTime", "CreatePerson", "Capacity", label_pos, label_ldr, label_loading_pos, label_loading_ldr, "MatchDayEventDayZone")
        SELECT curr_uuid,
           geom, "RestrictionLength", "RestrictionTypeID", row."ChangedTo", "NoLoadingTimeID", "Notes", "LastUpdateDateTime", "LastUpdatePerson", "Lines_PhotoTaken", "Photos_01", "ComplianceRoadMarkingsFaded", "Photos_02", "ComplianceRestrictionSignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "label_Rotation", "Photos_03", "UnacceptableTypeID", '2020-11-09', NULL, "CPZ", "ParkingTariffArea", "labelLoading_Rotation", "label_TextChanged", "AdditionalConditionID", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "ComplianceLoadingMarkingsFaded", "MatchDayTimePeriodID", "Last_MHTC_Check_UpdateDateTime", "Last_MHTC_Check_UpdatePerson", "FieldCheckCompleted", now(), 'Sunday Parking Hours - Mk2', "Capacity", label_pos, label_ldr, label_loading_pos, label_loading_ldr, "MatchDayEventDayZone"
        FROM toms."Lines"
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Cloned and opened ... %', curr_uuid;

        -- add cloned details to RiP

        INSERT INTO toms."RestrictionsInProposals"(
	        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	    VALUES (curr_proposal_id, restriction_table_id, 1, curr_uuid);

        RAISE NOTICE '***** clone added to RiP ...';

    END LOOP;

    ALTER TABLE toms."Lines" ENABLE TRIGGER "set_create_details_Lines";
    ALTER TABLE toms."Lines" ENABLE TRIGGER "insert_mngmt";

END
$do$;

-- CPZs
DO
$do$
DECLARE
   row RECORD;
   curr_proposal_id int := 44;
   layer_name RECORD;
   curr_uuid uuid;
   restriction_table_id int := 6;  -- CPZs
BEGIN

    ALTER TABLE toms."ControlledParkingZones" DISABLE TRIGGER "set_create_details_ControlledParkingZones";
    ALTER TABLE toms."ControlledParkingZones" DISABLE TRIGGER "insert_mngmt";

    FOR row IN
        SELECT r."GeometryID", r."RestrictionID", c."Code", t1."Description", c."ChangedTo", t2."Description"
        FROM
        (
        SELECT "Code",
        CASE
                 WHEN "Code" = 12 THEN 311
                 WHEN "Code" = 14 THEN 313
                 WHEN "Code" = 33 THEN 309
                 WHEN "Code" = 39 THEN 308
                 WHEN "Code" = 97 THEN 315
                 WHEN "Code" = 98 THEN 314
                 WHEN "Code" = 99 THEN 316
                 WHEN "Code" = 120 THEN 317
                 WHEN "Code" = 121 THEN 312
                 WHEN "Code" = 155 THEN 307
                 WHEN "Code" = 159 THEN 317
                 WHEN "Code" = 213 THEN 306
                 WHEN "Code" = 217 THEN 310
        END AS "ChangedTo"
        FROM toms_lookups."TimePeriods" t
        WHERE "Code" IN (33, 39, 98, 99, 120, 121, 155, 159, 213)
        ) As c,
        toms_lookups."TimePeriods" t1, toms_lookups."TimePeriods" t2, toms."ControlledParkingZones" r
        WHERE c."Code" = t1."Code"
        AND c."ChangedTo" = t2."Code"
        AND r."OpenDate" IS NOT NULL
        AND r."CloseDate" IS NULL
        AND r."CPZ" IN ('1', '1A', '2', '3', '4')
        AND r."OpenDate" < '2020-11-09'
        AND r."TimePeriodID" = c."Code"

    LOOP

        RAISE NOTICE '***** CONSIDERING geom GeomID: %', row."GeometryID";
        -- add these to Proposal (??) as closed restrictions

        -- Add restriction to Proposal - as Closed
        INSERT INTO toms."RestrictionsInProposals"(
	        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	    VALUES (curr_proposal_id, restriction_table_id, 2, row."RestrictionID");

        RAISE NOTICE '***** Added to RiP ...';

        -- Close restriction
        UPDATE toms."ControlledParkingZones"
        SET "CloseDate" = '2020-11-09'
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Closed in CPZs ...';

        -- get uuid value
        SELECT uuid_generate_v4() INTO curr_uuid;

        -- Clone, update time period and open restriction
        INSERT INTO toms."ControlledParkingZones"("RestrictionID",
            zone_no, geom, "TimePeriodID", "CPZ", "OpenDate", "CloseDate", "RestrictionTypeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "LastUpdateDateTime", "LastUpdatePerson", "LabelText", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "CreateDateTime", "CreatePerson", label_pos, label_ldr)
        SELECT curr_uuid,
        	zone_no, geom, row."ChangedTo", "CPZ", '2020-11-09', NULL, "RestrictionTypeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "LastUpdateDateTime", "LastUpdatePerson", "LabelText", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", now(), 'Sunday Parking Hours - Mk2', label_pos, label_ldr
        FROM toms."ControlledParkingZones"
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Cloned and opened ... %', curr_uuid;

        -- add cloned details to RiP

        INSERT INTO toms."RestrictionsInProposals"(
	        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	    VALUES (curr_proposal_id, restriction_table_id, 1, curr_uuid);

        RAISE NOTICE '***** clone added to RiP ...';

    END LOOP;

    ALTER TABLE toms."ControlledParkingZones" ENABLE TRIGGER "set_create_details_ControlledParkingZones";
    ALTER TABLE toms."ControlledParkingZones" ENABLE TRIGGER "insert_mngmt";

END
$do$;

-- PTAs
DO
$do$
DECLARE
   row RECORD;
   curr_proposal_id int := 44;
   layer_name RECORD;
   curr_uuid uuid;
   restriction_table_id int := 7;  -- PTAs
BEGIN

    ALTER TABLE toms."ParkingTariffAreas" DISABLE TRIGGER "set_create_details_ParkingTariffAreas";
    ALTER TABLE toms."ParkingTariffAreas" DISABLE TRIGGER "insert_mngmt";

    FOR row IN
        SELECT r."GeometryID", r."RestrictionID", c."Code", t1."Description", c."ChangedTo", t2."Description"
        FROM
        (
        SELECT "Code",
        CASE
                 WHEN "Code" = 12 THEN 311
                 WHEN "Code" = 14 THEN 313
                 WHEN "Code" = 33 THEN 309
                 WHEN "Code" = 39 THEN 308
                 WHEN "Code" = 97 THEN 315
                 WHEN "Code" = 98 THEN 314
                 WHEN "Code" = 99 THEN 316
                 WHEN "Code" = 120 THEN 317
                 WHEN "Code" = 121 THEN 312
                 WHEN "Code" = 155 THEN 307
                 WHEN "Code" = 159 THEN 317
                 WHEN "Code" = 213 THEN 306
                 WHEN "Code" = 217 THEN 310
        END AS "ChangedTo"
        FROM toms_lookups."TimePeriods" t
        WHERE "Code" IN (33, 39, 98, 99, 120, 121, 155, 159, 213)
        ) As c,
        toms_lookups."TimePeriods" t1, toms_lookups."TimePeriods" t2, toms."ControlledParkingZones" cpz, toms."ParkingTariffAreas" r
        WHERE c."Code" = t1."Code"
        AND c."ChangedTo" = t2."Code"
        AND r."OpenDate" IS NOT NULL
        AND r."CloseDate" IS NULL
        AND ST_Within(r.geom, cpz.geom)
        AND cpz."CPZ" IN ('1', '1A', '2', '3', '4')
        AND r."OpenDate" < '2020-11-09'
        AND r."TimePeriodID" = c."Code"

    LOOP

        RAISE NOTICE '***** CONSIDERING geom GeomID: %', row."GeometryID";
        -- add these to Proposal (??) as closed restrictions

        -- Add restriction to Proposal - as Closed
        INSERT INTO toms."RestrictionsInProposals"(
	        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	    VALUES (curr_proposal_id, restriction_table_id, 2, row."RestrictionID");

        RAISE NOTICE '***** Added to RiP ...';

        -- Close restriction
        UPDATE toms."ParkingTariffAreas"
        SET "CloseDate" = '2020-11-09'
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Closed in PTAs ...';

        -- get uuid value
        SELECT uuid_generate_v4() INTO curr_uuid;

        -- Clone, update time period and open restriction

        INSERT INTO toms."ParkingTariffAreas"("RestrictionID",
            geom, "ParkingTariffArea", "NoReturnID", "MaxStayID", "TimePeriodID", "OpenDate", "CloseDate", "RestrictionTypeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "LastUpdateDateTime", "LastUpdatePerson", "LabelText", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "CreateDateTime", "CreatePerson", label_pos, label_ldr)
        SELECT curr_uuid,
        	geom, "ParkingTariffArea", "NoReturnID", "MaxStayID", row."ChangedTo", '2020-11-09', NULL, "RestrictionTypeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "LastUpdateDateTime", "LastUpdatePerson", "LabelText", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", now(), 'Sunday Parking Hours - Mk2', label_pos, label_ldr
        FROM toms."ParkingTariffAreas"
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Cloned and opened ... %', curr_uuid;

        -- add cloned details to RiP

        INSERT INTO toms."RestrictionsInProposals"(
	        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	    VALUES (curr_proposal_id, restriction_table_id, 1, curr_uuid);

        RAISE NOTICE '***** clone added to RiP ...';

    END LOOP;

    ALTER TABLE toms."ParkingTariffAreas" ENABLE TRIGGER "set_create_details_ParkingTariffAreas";
    ALTER TABLE toms."ParkingTariffAreas" ENABLE TRIGGER "insert_mngmt";

END
$do$;

