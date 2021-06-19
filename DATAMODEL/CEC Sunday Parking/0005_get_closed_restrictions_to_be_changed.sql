/**
These are restrictions that were open at the time the Proposal was accepted but that have been subsequently closed - and for which the time period should be changed

Process is:
a. get Proposal in which the restriction was closed - closing_proposal_id
b. clone the restriction. Keep the open date and set close date to the date of Proposal (??), i.e., the clone was closed on 9/11/20
c. add cloned to RiP as closed restriction to curr Proposal
d. add restriction to RiP as open restrictions
e. amend time period in restriction

(r."OpenDate" > ''2020-11-09'' OR r."CloseDate" > ''2020-11-09'')

**/

-- Bays
DO
$do$
DECLARE
   row RECORD;
   curr_proposal_id int := 44;
   closing_proposal_id int;
   layer_name RECORD;
   curr_uuid uuid;
   restriction_table_id int := 2;  -- Bays
BEGIN

    ALTER TABLE toms."Bays" DISABLE TRIGGER "set_create_details_Bays";
    ALTER TABLE toms."Bays" DISABLE TRIGGER "set_last_update_details_bays";
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
        toms_lookups."TimePeriods" t1, toms_lookups."TimePeriods" t2, toms."Bays" r
        WHERE c."Code" = t1."Code"
        AND c."ChangedTo" = t2."Code"
        AND r."OpenDate" IS NOT NULL
        AND r."CloseDate" IS NOT NULL
        AND r."CPZ" IN ('1', '1A', '2', '3', '4')
        AND r."OpenDate" < '2020-11-09'
        AND r."CloseDate" > '2020-11-09'
        AND r."TimePeriodID" = c."Code"

    LOOP

        RAISE NOTICE '***** CONSIDERING geom RestrictionID: %', row."RestrictionID";

        -- get closing proposal
        SELECT "ProposalID" INTO closing_proposal_id
        FROM toms."RestrictionsInProposals"
        WHERE "RestrictionID" = row."RestrictionID"
        AND "ActionOnProposalAcceptance" = 2;

        -- get uuid value
        SELECT uuid_generate_v4() INTO curr_uuid;

        -- Clone, update time period and open restriction
        INSERT INTO toms."Bays"("RestrictionID", --"GeometryID",
            geom, "RestrictionLength", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "LastUpdateDateTime", "AdditionalConditionID", "LastUpdatePerson", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "Photos_01", "Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "Photos_03", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "PermitCode", "MatchDayTimePeriodID", "PayParkingAreaID", "Last_MHTC_Check_UpdateDateTime", "Last_MHTC_Check_UpdatePerson", "FieldCheckCompleted", "CreateDateTime", "CreatePerson", "Capacity", label_pos, label_ldr, "MatchDayEventDayZone")
        SELECT (curr_uuid,
            geom, "RestrictionLength", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "LastUpdateDateTime", "AdditionalConditionID", "LastUpdatePerson", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "Photos_01", "Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", '2020-11-09', "CPZ", "ParkingTariffArea", "Photos_03", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "PermitCode", "MatchDayTimePeriodID", "PayParkingAreaID", "Last_MHTC_Check_UpdateDateTime", "Last_MHTC_Check_UpdatePerson", "FieldCheckCompleted", now(), 'Sunday Parking Hours - Mk2', "Capacity", label_pos, label_ldr, "MatchDayEventDayZone")
        FROM toms."Bays"
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Cloned and closed ... %', curr_uuid;

        -- Add cloned restriction to Proposal - as Closed
        INSERT INTO toms."RestrictionsInProposals"(
	        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	    VALUES (curr_proposal_id, restriction_table_id, 2, curr_uuid);

        -- Add restriction to Proposal - as Open
        INSERT INTO toms."RestrictionsInProposals"(
	        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	    VALUES (curr_proposal_id, restriction_table_id, 1, row."RestrictionID");

        RAISE NOTICE '***** Added to RiP ...';

        -- Update time period
        UPDATE toms."Bays"
        SET "TimePeriodID" = row."ChangedTo", "LastUpdateDateTime" = now(), "LastUpdatePerson" = 'Sunday Parking Hours - Mk2'
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Control times updated ...';

    END LOOP;

    ALTER TABLE toms."Bays" ENABLE TRIGGER "set_create_details_Bays";
    ALTER TABLE toms."Bays" ENABLE TRIGGER "set_last_update_details_bays";
    ALTER TABLE toms."Bays" ENABLE TRIGGER "insert_mngmt";

END
$do$;

-- Lines
DO
$do$
DECLARE
   row RECORD;
   curr_proposal_id int := 44;
   closing_proposal_id int;
   layer_name RECORD;
   curr_uuid uuid;
   restriction_table_id int := 3;  -- Lines
BEGIN

    ALTER TABLE toms."Lines" DISABLE TRIGGER "set_create_details_Lines";
    ALTER TABLE toms."Lines" DISABLE TRIGGER "set_last_update_details_lines";
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
        AND r."CloseDate" IS NOT NULL
        AND r."CPZ" IN ('1', '1A', '2', '3', '4')
        AND r."OpenDate" < '2020-11-09'
        AND r."CloseDate" > '2020-11-09'
        AND r."NoWaitingTimeID" = c."Code"

    LOOP

        RAISE NOTICE '***** CONSIDERING geom RestrictionID: %', row."RestrictionID";

        -- get closing proposal
        SELECT "ProposalID" INTO closing_proposal_id
        FROM toms."RestrictionsInProposals"
        WHERE "RestrictionID" = row."RestrictionID"
        AND "ActionOnProposalAcceptance" = 2;

        -- get uuid value
        SELECT uuid_generate_v4() INTO curr_uuid;

        -- Clone, update time period and open restriction
        INSERT INTO toms."Lines"("RestrictionID",
            geom, "RestrictionLength", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "LastUpdateDateTime", "LastUpdatePerson", "Lines_PhotoTaken", "Photos_01", "ComplianceRoadMarkingsFaded", "Photos_02", "ComplianceRestrictionSignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "label_Rotation", "Photos_03", "UnacceptableTypeID", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoading_Rotation", "label_TextChanged", "AdditionalConditionID", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "ComplianceLoadingMarkingsFaded", "MatchDayTimePeriodID", "Last_MHTC_Check_UpdateDateTime", "Last_MHTC_Check_UpdatePerson", "FieldCheckCompleted", "CreateDateTime", "CreatePerson", "Capacity", label_pos, label_ldr, label_loading_pos, label_loading_ldr, "MatchDayEventDayZone")
        SELECT curr_uuid,
           geom, "RestrictionLength", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "LastUpdateDateTime", "LastUpdatePerson", "Lines_PhotoTaken", "Photos_01", "ComplianceRoadMarkingsFaded", "Photos_02", "ComplianceRestrictionSignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "label_Rotation", "Photos_03", "UnacceptableTypeID", "OpenDate", '2020-11-09', "CPZ", "ParkingTariffArea", "labelLoading_Rotation", "label_TextChanged", "AdditionalConditionID", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "ComplianceLoadingMarkingsFaded", "MatchDayTimePeriodID", "Last_MHTC_Check_UpdateDateTime", "Last_MHTC_Check_UpdatePerson", "FieldCheckCompleted", now(), 'Sunday Parking Hours - Mk2', "Capacity", label_pos, label_ldr, label_loading_pos, label_loading_ldr, "MatchDayEventDayZone"
        FROM toms."Lines"
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Cloned and closed ... %', curr_uuid;

        -- Add cloned restriction to Proposal - as Closed
        INSERT INTO toms."RestrictionsInProposals"(
	        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	    VALUES (curr_proposal_id, restriction_table_id, 2, curr_uuid);

        -- Add restriction to Proposal - as Open
        INSERT INTO toms."RestrictionsInProposals"(
	        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	    VALUES (curr_proposal_id, restriction_table_id, 1, row."RestrictionID");

        RAISE NOTICE '***** Added to RiP ...';

        -- Update time period
        UPDATE toms."Lines"
        SET "NoWaitingTimeID" = row."ChangedTo", "OpenDate" = '2020-11-09', "LastUpdateDateTime" = now(), "LastUpdatePerson" = 'Sunday Parking Hours - Mk2'
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Control times updated ...';

    END LOOP;

    ALTER TABLE toms."Lines" ENABLE TRIGGER "set_create_details_Lines";
    ALTER TABLE toms."Lines" ENABLE TRIGGER "set_last_update_details_lines";
    ALTER TABLE toms."Lines" ENABLE TRIGGER "insert_mngmt";

END
$do$;

