/***
 * Add mapping updates to RestrictionsInProposals and set open dates for mapping updates for proposals already accepted
 *
 * Need to ensure that:
 * a. details are added to RestrictionTables
 * b. RestrictionIDs are set for Mapping Update tables
 *
 ***/

DO
$do$
DECLARE
    proposal_details RECORD;
	result BOOLEAN;
BEGIN

    -- ** Bays
    FOR proposal_details IN
        SELECT DISTINCT p."ProposalID", p."ProposalTitle"
        FROM topography_updates."MappingUpdates" mu, toms."Proposals" p
        WHERE mu."ProposalID" = p."ProposalID"
        --AND p."ProposalStatusID" = 2
        AND mu."ProposalID" IS NOT NULL
        AND mu."ProposalID" > 0
        AND mu."RestrictionID" NOT IN
            (SELECT "RestrictionID"
             FROM toms."RestrictionsInProposals"
             WHERE "RestrictionTableID" = 101)

    LOOP

		RAISE NOTICE '***** Considering mapping updates for Proposal %: %', proposal_details."ProposalID", proposal_details."ProposalTitle";

        SELECT toms."addMappingUpdatesToProposal"(proposal_details."ProposalID")
		INTO result;

    END LOOP;

END;
$do$;


