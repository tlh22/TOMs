/***
 *
 * move Tile 1128 to TRO/19/73 and Tiles 1677 & 1736 to TRO/19/66, leaving only Tiles 1090 and 1561 against TRO/20/18
 *
 ***/

DO
$do$
DECLARE
    row RECORD;
    curr_proposal_title TEXT = 'TRO-20-18';
    new_proposal_title TEXT = 'TRO-19-73';
    map_ref INTEGER = 1128;
	answer BOOLEAN;
BEGIN

    FOR row IN SELECT "RestrictionID"
               FROM mhtc_operations.getRestrictionsInProposalInTile(curr_proposal_title, map_ref)
    LOOP

        RAISE NOTICE '***** Considering restriction: % in Proposal %', row."RestrictionID", curr_proposal_title;

        SELECT *
		INTO answer
		FROM mhtc_operations.changeProposalForRestriction(row."RestrictionID", curr_proposal_title, new_proposal_title);

        IF NOT answer THEN
            RAISE EXCEPTION '***** ERROR: % in Proposal %', row."RestrictionID", curr_proposal_title;
            EXIT;
        END IF;

    END LOOP;

END;
$do$;

-- tile 1677
-- sort out temporary proposal

UPDATE toms."Proposals"
SET "ProposalTitle" = 'TRO-19-66-A'
WHERE "ProposalID" = 254;

DO
$do$
DECLARE
    row RECORD;
    curr_proposal_title TEXT = 'TRO-20-18';
    new_proposal_title TEXT = 'TRO-19-66-A';
    map_ref INTEGER = 1677;
	answer BOOLEAN;
BEGIN

    FOR row IN SELECT "RestrictionID"
               FROM mhtc_operations.getRestrictionsInProposalInTile(curr_proposal_title, map_ref)
    LOOP

        RAISE NOTICE '***** Considering restriction: % in Proposal %', row."RestrictionID", curr_proposal_title;

        SELECT *
		INTO answer
		FROM mhtc_operations.changeProposalForRestriction(row."RestrictionID", curr_proposal_title, new_proposal_title);

        IF NOT answer THEN
            RAISE EXCEPTION '***** ERROR: % in Proposal %', row."RestrictionID", curr_proposal_title;
            EXIT;
        END IF;

    END LOOP;

END;
$do$;

DO
$do$
DECLARE
    row RECORD;
    curr_proposal_title TEXT = 'TRO-20-18';
    new_proposal_title TEXT = 'TRO-19-66-A';
    map_ref INTEGER = 1736;
	answer BOOLEAN;
BEGIN

    FOR row IN SELECT "RestrictionID"
               FROM mhtc_operations.getRestrictionsInProposalInTile(curr_proposal_title, map_ref)
    LOOP

        RAISE NOTICE '***** Considering restriction: % in Proposal %', row."RestrictionID", curr_proposal_title;

        SELECT *
		INTO answer
		FROM mhtc_operations.changeProposalForRestriction(row."RestrictionID", curr_proposal_title, new_proposal_title);

        IF NOT answer THEN
            RAISE EXCEPTION '***** ERROR: % in Proposal %', row."RestrictionID", curr_proposal_title;
            EXIT;
        END IF;

    END LOOP;

END;
$do$;