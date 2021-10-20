/**
Set tile version numbers to 0 - so they are available for printing (without any restrictions)

NB: the Acceptance process will check for version numbers of NULL or 0 and increment them to 1.

**/

DO
$do$
DECLARE
    tiles_in_current_restrictions_details RECORD;
    proposal_id INTEGER = 0;
BEGIN

    FOR tiles_in_current_restrictions_details IN
        SELECT id
        FROM toms."MapGrid" m
        WHERE id IN (632, 633, 753, 872, 931, 1684)
    LOOP

        RAISE NOTICE 'New *****--- Adding map tile (%) to tilesInAcceptedProposals for proposal %', tiles_in_current_restrictions_details.id, proposal_id;

        INSERT INTO toms."TilesInAcceptedProposals"(
                "ProposalID", "TileNr", "RevisionNr")
        VALUES (proposal_id, tiles_in_current_restrictions_details.id, 1);

        -- Set revision nr
        UPDATE toms."MapGrid"
	    SET "CurrRevisionNr"=0
	    WHERE id = tiles_in_current_restrictions_details.id;

    END LOOP;

END;
$do$;