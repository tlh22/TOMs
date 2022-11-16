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



-- Move mapping updates to different proposal

DO
$do$
DECLARE
    proposal_details RECORD;
    restriction_details RECORD;
	result BOOLEAN;
	curr_proposal_id INTEGER := 170;
	new_proposal_id INTEGER := 329;
	tile_nr INTEGER := 2209;
BEGIN

    -- ** Bays
    FOR proposal_details IN
        SELECT DISTINCT p."ProposalID", p."ProposalTitle"
        FROM toms."Proposals" p
        WHERE p."ProposalID" = curr_proposal_id

    LOOP

		RAISE NOTICE '***** Moving mapping updates currently in proposal id % (%) to proposal id (%)', proposal_details."ProposalTitle", proposal_details."ProposalID", new_proposal_id;

        FOR restriction_details IN
            SELECT RiS."RestrictionID"
            FROM toms."RestrictionsInProposals" RiS
            WHERE RiS."ProposalID" = curr_proposal_id
            AND RiS."RestrictionID" IN (
                SELECT "RestrictionID"
                FROM topography_updates."MappingUpdateMasks" ma, toms."MapGrid" m
                WHERE m.id = tile_nr
                AND ST_Within(ma.geom, m.geom))

        LOOP

            RAISE NOTICE '***** Moving  % ', restriction_details."RestrictionID";

            UPDATE toms."RestrictionsInProposals"
            SET "ProposalID" = new_proposal_id
            WHERE "RestrictionID" = restriction_details."RestrictionID";

        END LOOP;

        FOR restriction_details IN
            SELECT RiS."RestrictionID"
            FROM toms."RestrictionsInProposals" RiS
            WHERE RiS."ProposalID" = curr_proposal_id
            AND RiS."RestrictionID" IN (
                SELECT "RestrictionID"
                FROM topography_updates."MappingUpdates" mu, toms."MapGrid" m
                WHERE m.id = tile_nr
                AND ST_Within(mu.geom, m.geom))

        LOOP

            RAISE NOTICE '***** Moving  % ', restriction_details."RestrictionID";

            UPDATE toms."RestrictionsInProposals"
            SET "ProposalID" = new_proposal_id
            WHERE "RestrictionID" = restriction_details."RestrictionID";

        END LOOP;

    END LOOP;

END;
$do$;

