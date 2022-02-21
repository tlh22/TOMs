/***
Add required details to proposals
***/

-- *** create Proposal for PTAs within Zones 1-4

/*
INSERT INTO toms."Proposals"(
	"ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate")
	VALUES (2, now(), 'Sunday parking Zone 2', 'TRO-19-29A PTAs', '2020-11-09');
*/

UPDATE toms."Proposals"
SET "ProposalTitle" = 'TRO-19-29A PTAs', "ProposalNotes" = 'Dealing with PTAs for Sunday Parking (TH)'
WHERE "ProposalID" = 205;

-- Accept Proposal
UPDATE toms."Proposals"
SET "ProposalStatusID" = 2, "ProposalOpenDate" = '2020-11-09'
WHERE "ProposalID" = 205;

-- *** PTAs (Proposal 205)

DO
$do$
DECLARE
    relevant_restriction RECORD;
    clone_restriction_id uuid;
    proposal_id INTEGER = 205;
BEGIN

    -- ** ParkingTariffAreas
    FOR relevant_restriction IN
        SELECT DISTINCT r."GeometryID", r."RestrictionID"
        FROM toms."ParkingTariffAreas" r, toms."ControlledParkingZones" c
        WHERE ST_Intersects(r.geom, c.geom)
        AND c."CPZ" IN ('1', '1A', '2', '3', '4')
        AND r."TimePeriodID" IN (33, 39, 98, 99, 120, 121, 155, 159, 213)
        AND r."OpenDate" IS NOT NULL
        AND r."CloseDate" IS NULL
        ORDER BY r."RestrictionID"
    LOOP

        RAISE NOTICE '*****--- Cloning (%)', relevant_restriction."GeometryID";
        SELECT uuid_generate_v4() INTO clone_restriction_id;

        -- Clone restriction

        INSERT INTO toms."ParkingTariffAreas"(
	        "RestrictionID", "ParkingTariffArea", "NoReturnID", "MaxStayID", "TimePeriodID", "OpenDate", "CloseDate",
	        "RestrictionTypeID", "Notes", "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged",
	        "LastUpdateDateTime", "LastUpdatePerson", "LabelText", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes",
	        "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "CreateDateTime", "CreatePerson", label_pos, label_ldr, geom)
        SELECT clone_restriction_id, "ParkingTariffArea", "NoReturnID", "MaxStayID",
               CASE
                 --WHEN "TimePeriodID" = 12 THEN 311
                 --WHEN "TimePeriodID" = 14 THEN 313
                 WHEN "TimePeriodID" = 33 THEN 309
                 WHEN "TimePeriodID" = 39 THEN 308
                 --WHEN "TimePeriodID" = 97 THEN 315
                 WHEN "TimePeriodID" = 98 THEN 314
                 WHEN "TimePeriodID" = 99 THEN 316
                 WHEN "TimePeriodID" = 120 THEN 317
                 WHEN "TimePeriodID" = 121 THEN 312
                 WHEN "TimePeriodID" = 155 THEN 307
                 WHEN "TimePeriodID" = 159 THEN 317
                 WHEN "TimePeriodID" = 213 THEN 306
                 --WHEN "TimePeriodID" = 217 THEN 310
                 --WHEN "TimePeriodID" = 225 THEN 225
                 --WHEN "TimePeriodID" = 242 THEN 242
               END AS "TimePeriodID",
        '2020-11-09', NULL,
        "RestrictionTypeID", CONCAT ("Notes", ' Sunday Parking'), "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged",
        "LastUpdateDateTime", "LastUpdatePerson", "LabelText", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes",
        "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "CreateDateTime", "CreatePerson", label_pos, label_ldr, geom
        FROM toms."ParkingTariffAreas" r
        WHERE r."RestrictionID" = relevant_restriction."RestrictionID";

        -- Add to RestrictionInProposals
        -- Open
        INSERT INTO toms."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
            VALUES (proposal_id, 7, 1, clone_restriction_id);

        -- Close
        INSERT INTO toms."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
            VALUES (proposal_id, 7, 2, relevant_restriction."RestrictionID");

        -- Set Close Date on original restriction
        UPDATE toms."ParkingTariffAreas"
        SET "CloseDate" = '2020-11-09'
        WHERE "RestrictionID" = relevant_restriction."RestrictionID";

    END LOOP;

END;
$do$;
