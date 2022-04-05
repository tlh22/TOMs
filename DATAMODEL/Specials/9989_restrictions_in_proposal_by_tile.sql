/***
 *
 ***/

DROP FUNCTION IF EXISTS mhtc_operations.getRestrictionsInProposal;
CREATE OR REPLACE FUNCTION mhtc_operations.getRestrictionsInProposal(proposal_title TEXT)
  RETURNS TABLE ("RestrictionID" character varying(254), "RestrictionLayer" TEXT, geom GEOMETRY) AS
$$
DECLARE
    --proposal_title TEXT = 'TRO-20-18';
BEGIN

    RETURN QUERY
        SELECT r."RestrictionID", 'Bays' AS "RestrictionLayer", r.geom
        FROM toms."Bays" r,
        (
        SELECT RiP."RestrictionID"
        FROM toms."RestrictionsInProposals" RiP, toms."Proposals" p
        WHERE p."ProposalID" = RiP."ProposalID"
        AND p."ProposalTitle" = proposal_title
        ) a
        WHERE r."RestrictionID" = a."RestrictionID"

        UNION

        SELECT r."RestrictionID", 'Lines' AS "RestrictionLayer", r.geom
        FROM toms."Lines" r,
        (
        SELECT RiP."RestrictionID"
        FROM toms."RestrictionsInProposals" RiP, toms."Proposals" p
        WHERE p."ProposalID" = RiP."ProposalID"
        AND p."ProposalTitle" = proposal_title
        ) a
        WHERE r."RestrictionID" = a."RestrictionID";

END;
$$ LANGUAGE plpgsql;

-- Test
--SELECT * FROM mhtc_operations.getRestrictionsInProposal('TRO-20-18');

-- Get restriction for Proposal that intersects tile

DROP FUNCTION IF EXISTS mhtc_operations.getRestrictionsInProposalInTile;
CREATE OR REPLACE FUNCTION mhtc_operations.getRestrictionsInProposalInTile(proposal_title TEXT, map_ref INTEGER)
  RETURNS TABLE ("RestrictionID" character varying(254)) AS
$$
DECLARE
    --proposal_title TEXT = 'TRO-20-18';
BEGIN

    RETURN QUERY
        SELECT a."RestrictionID"
        FROM mhtc_operations.getRestrictionsInProposal(proposal_title) a, toms."MapGrid" m
        WHERE ST_Intersects (a.geom, m.geom)
        AND m."id" = map_ref
        ORDER BY m."id";

END;
$$ LANGUAGE plpgsql;

-- Test
--SELECT * FROM mhtc_operations.getRestrictionsInProposalInTile('TRO-20-18', 1128);


-- Move restriction from one Proposal to another

DROP FUNCTION IF EXISTS mhtc_operations.changeProposalForRestriction;
CREATE OR REPLACE FUNCTION mhtc_operations.changeProposalForRestriction(restriction_id character varying(254),
                                                                            curr_proposal_title TEXT,
                                                                            new_proposal_title TEXT)
RETURNS BOOLEAN AS
$$
DECLARE
	curr_proposal_id INTEGER;
	new_proposal_id INTEGER;
BEGIN

    SELECT "ProposalID"
    INTO curr_proposal_id
    FROM toms."Proposals"
    WHERE "ProposalTitle" = curr_proposal_title;

    SELECT "ProposalID"
    INTO new_proposal_id
    FROM toms."Proposals"
    WHERE "ProposalTitle" = new_proposal_title;

        UPDATE toms."RestrictionsInProposals" RiP
        SET "ProposalID" = new_proposal_id
        WHERE "ProposalID" = curr_proposal_id
        AND "RestrictionID" = restriction_id;

        RAISE NOTICE '--- Moving restriction: % from Proposal % to Proposal %', restriction_id, curr_proposal_title, new_proposal_title;

    RETURN true;

    EXCEPTION WHEN others THEN

        raise notice E'Got exception:
            SQLSTATE: %
            SQLERRM: %', SQLSTATE, SQLERRM;

        RETURN false;

END;
$$ LANGUAGE plpgsql;


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



    END LOOP;

END;
$do$;

DO
$do$
DECLARE
    row RECORD;
    curr_proposal_title TEXT = 'TRO-20-18';
    new_proposal_title TEXT = 'TRO/19/66';
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



    END LOOP;

END;
$do$;

DO
$do$
DECLARE
    row RECORD;
    curr_proposal_title TEXT = 'TRO-20-18';
    new_proposal_title TEXT = 'TRO-19-66';
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



    END LOOP;

END;
$do$;