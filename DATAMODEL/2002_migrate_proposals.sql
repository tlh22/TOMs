/***
Migrate all details associated with a Proposal. Assume that details in schema migrate are to be migrated ...
Need to have a list of the proposals to migrate with the table "ProposalsToMigrate"

***/

-- DROP FUNCTION migrate.migrate_proposal(text);

CREATE OR REPLACE FUNCTION migrate.migrate_proposal(
	proposal_title text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE

AS $BODY$
DECLARE
   cornerProtectionLineString geometry;
   new_proposal_id integer;
   existing_proposal_id integer;
   result boolean = 'true';
BEGIN

	RAISE NOTICE '***** IN migrate_proposal: migrating proposal (%) ...', proposal_title;

    -- get the existing proposal number

    SELECT p."ProposalID" INTO existing_proposal_id
	FROM migrate."Proposals" p
	WHERE p."ProposalTitle" = proposal_title;

    IF existing_proposal_id IS NULL THEN
        RAISE NOTICE '***** IN migrate_proposal: proposal (%) not found ...', proposal_title;
        RETURN;
    END IF;

	-- create a new proposal ... and get the new proposal_id
	INSERT INTO toms."Proposals"(
	"ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate")
    SELECT "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", p."ProposalTitle", "ProposalOpenDate"
	FROM migrate."Proposals" p
	WHERE p."ProposalTitle" = proposal_title;

	SELECT p."ProposalID" INTO new_proposal_id
	FROM toms."Proposals" p
	WHERE p."ProposalTitle" = proposal_title;

    RAISE NOTICE '***** IN migrate_proposal: existing_proposal_id(%); new_proposal_id (%)', existing_proposal_id, new_proposal_id;

    /**
    -- add restrictions that are to be "opened"
    **/
    -- Bays
    INSERT INTO toms."Bays"(
           "RestrictionID", geom, "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "PermitCode", "MatchDayTimePeriodID", "PayParkingAreaID", "CreateDateTime", "CreatePerson", "Capacity", label_pos, label_ldr, "MatchDayEventDayZone", "BayWidth")
    SELECT "RestrictionID", geom, "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "PermitCode", "MatchDayTimePeriodID", "PayParkingAreaID", "CreateDateTime", "CreatePerson", "Capacity", label_pos, label_ldr, "MatchDayEventDayZone", "BayWidth"
    FROM migrate."Bays"
    WHERE "RestrictionID" IN
        (SELECT "RestrictionID"
        FROM migrate."RestrictionsInProposals" RiP
        WHERE RiP."ActionOnProposalAcceptance" = 1
        AND RiP."RestrictionTableID" = 2 -- Bays
        AND RiP."ProposalID" = existing_proposal_id);

    -- Lines
    INSERT INTO toms."Lines"(
           "RestrictionID", geom, "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "ComplianceLoadingMarkingsFaded", "MatchDayTimePeriodID", "CreateDateTime", "CreatePerson", "Capacity", label_pos, label_ldr, label_loading_pos, label_loading_ldr, "MatchDayEventDayZone")
    SELECT "RestrictionID", geom, "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "ComplianceLoadingMarkingsFaded", "MatchDayTimePeriodID", "CreateDateTime", "CreatePerson", "Capacity", label_pos, label_ldr, label_loading_pos, label_loading_ldr, "MatchDayEventDayZone"
        FROM migrate."Lines"
    WHERE "RestrictionID" IN
        (SELECT "RestrictionID"
        FROM migrate."RestrictionsInProposals" RiP
        WHERE RiP."ActionOnProposalAcceptance" = 1
        AND RiP."RestrictionTableID" = 3 -- Lines
        AND RiP."ProposalID" = existing_proposal_id);

    -- Signs
    INSERT INTO toms."Signs"(
           "RestrictionID", geom, "Photos_01", "Photos_02", "Photos_03", "Notes", "RoadName", "USRN", "OpenDate", "CloseDate", "LastUpdateDateTime", "LastUpdatePerson", "SignType_1", "SignType_2", "SignType_3", "SignType_4", "Photos_04", "SignOrientationTypeID", "Signs_Mount", "SignsAttachmentTypeID", "Compl_Signs_Faded", "Compl_Signs_Obscured", "Compl_Sign_Direction", "Compl_Signs_Obsolete", "Compl_Signs_OtherOptions", "Compl_Signs_TicketMachines", "TicketMachine_Nr", "RingoPresent", "SignIlluminationTypeID", "SignConditionTypeID", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "SignAddress", original_geom_wkt, "AssetReference", "CreateDateTime", "CreatePerson")
    SELECT "RestrictionID", geom, "Photos_01", "Photos_02", "Photos_03", "Notes", "RoadName", "USRN", "OpenDate", "CloseDate", "LastUpdateDateTime", "LastUpdatePerson", "SignType_1", "SignType_2", "SignType_3", "SignType_4", "Photos_04", "SignOrientationTypeID", "Signs_Mount", "SignsAttachmentTypeID", "Compl_Signs_Faded", "Compl_Signs_Obscured", "Compl_Sign_Direction", "Compl_Signs_Obsolete", "Compl_Signs_OtherOptions", "Compl_Signs_TicketMachines", "TicketMachine_Nr", "RingoPresent", "SignIlluminationTypeID", "SignConditionTypeID", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "SignAddress", original_geom_wkt, "AssetReference", "CreateDateTime", "CreatePerson"
        FROM migrate."Signs"
    WHERE "RestrictionID" IN
        (SELECT "RestrictionID"
        FROM migrate."RestrictionsInProposals" RiP
        WHERE RiP."ActionOnProposalAcceptance" = 1
        AND RiP."RestrictionTableID" = 5 -- Signs
        AND RiP."ProposalID" = existing_proposal_id);

    -- RestrictionPolygons
    INSERT INTO toms."RestrictionPolygons"(
           "RestrictionID", geom, "RestrictionTypeID", "GeomShapeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "LastUpdateDateTime", "LastUpdatePerson", "Orientation", "LabelText", "NoWaitingTimeID", "NoLoadingTimeID", "TimePeriodID", "AreaPermitCode", "CPZ", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "MatchDayTimePeriodID", "CreateDateTime", "CreatePerson", "AdditionalConditionID", label_pos, label_ldr, "MatchDayEventDayZone")
    SELECT "RestrictionID", geom, "RestrictionTypeID", "GeomShapeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "LastUpdateDateTime", "LastUpdatePerson", "Orientation", "LabelText", "NoWaitingTimeID", "NoLoadingTimeID", "TimePeriodID", "AreaPermitCode", "CPZ", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "MatchDayTimePeriodID", "CreateDateTime", "CreatePerson", "AdditionalConditionID", label_pos, label_ldr, "MatchDayEventDayZone"
        FROM migrate."RestrictionPolygons"
    WHERE "RestrictionID" IN
        (SELECT "RestrictionID"
        FROM migrate."RestrictionsInProposals" RiP
        WHERE RiP."ActionOnProposalAcceptance" = 4 -- RestrictionPolygons
        AND RiP."ProposalID" = existing_proposal_id);

    -- CPZs
    INSERT INTO toms."ControlledParkingZones"(
           "RestrictionID", geom, "RestrictionTypeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "LabelText", "TimePeriodID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "CreateDateTime", "CreatePerson", label_pos, label_ldr)
    SELECT "RestrictionID", geom, "RestrictionTypeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "LabelText", "TimePeriodID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "CreateDateTime", "CreatePerson", label_pos, label_ldr
        FROM migrate."ControlledParkingZones"
    WHERE "RestrictionID" IN
        (SELECT "RestrictionID"
        FROM migrate."RestrictionsInProposals" RiP
        WHERE RiP."ActionOnProposalAcceptance" = 6 -- CPZs
        AND RiP."ProposalID" = existing_proposal_id);

    /**
    Now add in RestrictionsInProposals
    **/

    INSERT INTO toms."RestrictionsInProposals"(
        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
    SELECT new_proposal_id, "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID"
        FROM migrate."RestrictionsInProposals" RiP
        WHERE RiP."ProposalID" = existing_proposal_id;

    --RETURN result;

END;
$BODY$;

ALTER FUNCTION migrate.migrate_proposal(text)
    OWNER TO postgres;

---

WITH proposals_to_migrate AS (
SELECT "ProposalTitle"
FROM migrate."ProposalsToMigrate")
    SELECT migrate."migrate_proposal" (proposals_to_migrate."ProposalTitle")
	FROM proposals_to_migrate;