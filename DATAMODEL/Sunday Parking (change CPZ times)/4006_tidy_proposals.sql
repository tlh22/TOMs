/***
Tidy up the details related to Sunday Parking - 115, 116, 117, 118
 - Delete any restrictions that have been created, i.e., with AcceptanceType = 1
 - Delete entries in RestrictionsInProposals (for both open and close)
 - Delete Proposals
***/

Do not use for now ...

DO
$do$
DECLARE
    proposal_details RECORD;
    clone_restriction_id uuid;
BEGIN

    -- ** Tidy proposals
    FOR proposal_details IN
        SELECT "ProposalID", "ProposalTitle"
        FROM toms."Proposals"
        WHERE "ProposalID" IN (115, 116, 117, 118)
    LOOP

        RAISE NOTICE '*****--- Tidying proposal (%)', proposal_details."ProposalTitle";

        -- Delete from Bays
        DELETE FROM toms."Bays"
        WHERE "RestrictionID" IN (
            SELECT r."RestrictionID"
            FROM toms."Bays" r, toms."RestrictionsInProposals" RiP
            WHERE r."RestrictionID" = RiP."RestrictionID"
            AND RiP."ProposalID" = proposal_details."ProposalID"
            AND RiP."ActionOnProposalAcceptance" = 1   -- Open
        );

        -- Delete from Lines
        DELETE FROM toms."Lines"
        WHERE "RestrictionID" IN (
            SELECT r."RestrictionID"
            FROM toms."Lines" r, toms."RestrictionsInProposals" RiP
            WHERE r."RestrictionID" = RiP."RestrictionID"
            AND RiP."ProposalID" = proposal_details."ProposalID"
            AND RiP."ActionOnProposalAcceptance" = 1   -- Open
        );

        -- Delete from RestrictionPolygons
        DELETE FROM toms."RestrictionPolygons"
        WHERE "RestrictionID" IN (
            SELECT r."RestrictionID"
            FROM toms."RestrictionPolygons" r, toms."RestrictionsInProposals" RiP
            WHERE r."RestrictionID" = RiP."RestrictionID"
            AND RiP."ProposalID" = proposal_details."ProposalID"
            AND RiP."ActionOnProposalAcceptance" = 1   -- Open
        );

        -- Delete from Signs
        DELETE FROM toms."Signs"
        WHERE "RestrictionID" IN (
            SELECT r."RestrictionID"
            FROM toms."Signs" r, toms."RestrictionsInProposals" RiP
            WHERE r."RestrictionID" = RiP."RestrictionID"
            AND RiP."ProposalID" = proposal_details."ProposalID"
            AND RiP."ActionOnProposalAcceptance" = 1   -- Open
        );

        -- Delete from RestrictionsInProposals
        DELETE FROM toms."RestrictionsInProposals" RiP
        WHERE RiP."ProposalID" = proposal_details."ProposalID";

        -- Delete Proposal
        DELETE FROM toms."Proposals" p
        WHERE p."ProposalID" = proposal_details."ProposalID";

    END LOOP;

END;
$do$;


/***
Tidy other "test" proposals ??
(7,8,9,11,12,14,24,25,40,41,49,60,63)
***/


DO
$do$
DECLARE
    proposal_details RECORD;
    clone_restriction_id uuid;
BEGIN

    -- ** Tidy proposals
    FOR proposal_details IN
        SELECT "ProposalID", "ProposalTitle"
        FROM toms."Proposals"
        WHERE "ProposalID" IN (115, 116, 117, 118)
    LOOP

        RAISE NOTICE '*****--- Tidying proposal (%)', proposal_details."ProposalTitle";

        -- Delete from Bays
        DELETE FROM toms."Bays"
        WHERE "RestrictionID" IN (
            SELECT r."RestrictionID"
            FROM toms."Bays" r, toms."RestrictionsInProposals" RiP
            WHERE r."RestrictionID" = RiP."RestrictionID"
            AND RiP."ProposalID" = proposal_details."ProposalID"
            AND RiP."ActionOnProposalAcceptance" = 1   -- Open
            AND r."OpenDate" IS NULL
        );

        -- Delete from Lines
        DELETE FROM toms."Lines"
        WHERE "RestrictionID" IN (
            SELECT r."RestrictionID"
            FROM toms."Lines" r, toms."RestrictionsInProposals" RiP
            WHERE r."RestrictionID" = RiP."RestrictionID"
            AND RiP."ProposalID" = proposal_details."ProposalID"
            AND RiP."ActionOnProposalAcceptance" = 1   -- Open
            AND r."OpenDate" IS NULL
        );

        -- Delete from RestrictionPolygons
        DELETE FROM toms."RestrictionPolygons"
        WHERE "RestrictionID" IN (
            SELECT r."RestrictionID"
            FROM toms."RestrictionPolygons" r, toms."RestrictionsInProposals" RiP
            WHERE r."RestrictionID" = RiP."RestrictionID"
            AND RiP."ProposalID" = proposal_details."ProposalID"
            AND RiP."ActionOnProposalAcceptance" = 1   -- Open
            AND r."OpenDate" IS NULL
        );

        -- Delete from Signs
        DELETE FROM toms."Signs"
        WHERE "RestrictionID" IN (
            SELECT r."RestrictionID"
            FROM toms."Signs" r, toms."RestrictionsInProposals" RiP
            WHERE r."RestrictionID" = RiP."RestrictionID"
            AND RiP."ProposalID" = proposal_details."ProposalID"
            AND RiP."ActionOnProposalAcceptance" = 1   -- Open
            AND r."OpenDate" IS NULL
        );

        -- Delete from CPZs
        DELETE FROM toms."ControlledParkingZones"
        WHERE "RestrictionID" IN (
            SELECT r."RestrictionID"
            FROM toms."ControlledParkingZones" r, toms."RestrictionsInProposals" RiP
            WHERE r."RestrictionID" = RiP."RestrictionID"
            AND RiP."ProposalID" = proposal_details."ProposalID"
            AND RiP."ActionOnProposalAcceptance" = 1   -- Open
            AND r."OpenDate" IS NULL
        );

        -- Delete from PTAs
        DELETE FROM toms."ParkingTariffAreas"
        WHERE "RestrictionID" IN (
            SELECT r."RestrictionID"
            FROM toms."ParkingTariffAreas" r, toms."RestrictionsInProposals" RiP
            WHERE r."RestrictionID" = RiP."RestrictionID"
            AND RiP."ProposalID" = proposal_details."ProposalID"
            AND RiP."ActionOnProposalAcceptance" = 1   -- Open
            AND r."OpenDate" IS NULL
        );

        -- Delete from RestrictionsInProposals
        DELETE FROM toms."RestrictionsInProposals" RiP
        WHERE RiP."ProposalID" = proposal_details."ProposalID";

        -- Delete Proposal
        DELETE FROM toms."Proposals" p
        WHERE p."ProposalID" = proposal_details."ProposalID";

    END LOOP;

END;
$do$;

