/***
 * Function to add mapping updates to RestrictionsInProposals
 *
 ***/

CREATE OR REPLACE FUNCTION toms."addMappingUpdatesToProposal"(proposal_id INTEGER)
RETURNS BOOLEAN
LANGUAGE 'plpgsql'
AS  $BODY$
DECLARE
    open_date DATE;
    proposal_status_id INTEGER;
BEGIN

    RAISE NOTICE '***** Adding mapping updates to Proposal %', proposal_id;

    -- add to RestrictionsInProposals


    INSERT INTO toms."RestrictionsInProposals"(
        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
    SELECT proposal_id, 101, 1, "RestrictionID"
    FROM topography_updates."MappingUpdates"
    WHERE "ProposalID" = proposal_id
	AND "RestrictionID" NOT IN (SELECT "RestrictionID"
								FROM toms."RestrictionsInProposals"
								WHERE "RestrictionTableID" = 101
								AND "ProposalID" = proposal_id);

    INSERT INTO toms."RestrictionsInProposals"(
        "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
    SELECT proposal_id, 102, 1, "RestrictionID"
    FROM topography_updates."MappingUpdateMasks"
    WHERE "ProposalID" = proposal_id
	AND "RestrictionID" NOT IN (SELECT "RestrictionID"
								FROM toms."RestrictionsInProposals"
								WHERE "RestrictionTableID" = 102
								AND "ProposalID" = proposal_id);
								
    -- set open dates for mapping updates in proposals already accepted

    SELECT "ProposalOpenDate", "ProposalStatusID"
    INTO open_date, proposal_status_id
    FROM toms."Proposals"
    WHERE "ProposalID" = proposal_id;

    IF proposal_status_id = 2 THEN

        UPDATE topography_updates."MappingUpdates"
        SET "OpenDate" = open_date
        WHERE "ProposalID" = proposal_id;

        UPDATE topography_updates."MappingUpdateMasks"
        SET "OpenDate" = open_date
        WHERE "ProposalID" = proposal_id;

    END IF;

    RETURN True;

END;
$BODY$;
