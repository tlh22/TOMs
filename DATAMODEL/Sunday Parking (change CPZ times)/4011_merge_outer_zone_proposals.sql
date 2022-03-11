/***
 * Merge all Proposals associated with Sunday Parking within outer zones


Proposals are:
 - CPZ 5 (Proposal 72)
 - CPZ 5A (Proposal 39)
 - CPZ 6 (Proposal 64)
 - CPZ 7 (Proposal 50)
 - CPZ 8 (Proposal 69)

Need to include into one new Proposal. Create a new one and mark the others as "Rejected"

-- Check to see if there are any "duplicates"

SELECT RiP."RestrictionID", RiP."ProposalID", RiP_2."ProposalID"
FROM toms."RestrictionsInProposals" RiP, toms."RestrictionsInProposals" RiP_2
WHERE RiP."ProposalID" IN (72, 39, 64, 50, 69)
AND RiP_2."ProposalID" IN (72, 39, 64, 50, 69)
AND RiP."RestrictionID" = RiP_2."RestrictionID"
AND RiP."ProposalID" < RiP_2."ProposalID"
ORDER BY RiP."RestrictionID", RiP."ProposalID"

 ***/

-- Tidy Proposals
DELETE FROM toms."RestrictionsInProposals"
WHERE "RestrictionID" IN ('L_15379', 'L_15397', 'L_15398', 'L_15517')
AND "ProposalID" = 39;

-- Move restriction details to single Proposal

DO
$do$
DECLARE
    sunday_parking_proposal_id INTEGER;
    proposal RECORD;
BEGIN

    -- Create a new Proposal
    INSERT INTO toms."Proposals" ("ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate")
    VALUES (2, now(), 'Merge of Sunday Parking Proposals (outer zones)', 'TRO-19-29B - Sunday Parking Proposal (Outer Zones) MERGED', '2020-04-05');

    -- Get Proposal ID
    SELECT max("ProposalID")::integer INTO sunday_parking_proposal_id
    FROM toms."Proposals";

    -- Deal with restrictions
    raise notice 'Moving restrictions ...';

    FOR proposal IN
        SELECT p."ProposalID", p."ProposalTitle"
        FROM toms."Proposals" p
        WHERE p."ProposalID" IN (72, 39, 64, 50, 69)
        ORDER BY p."ProposalID"
    LOOP

        raise notice 'Considering % ...', proposal."ProposalTitle";

        UPDATE toms."RestrictionsInProposals"
        SET "ProposalID" = sunday_parking_proposal_id
        WHERE "ProposalID" = proposal."ProposalID";

    END LOOP;

    -- Deal with restrictions
    raise notice 'Changing map tiles ...';

    INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	SELECT DISTINCT sunday_parking_proposal_id, "TileNr", "RevisionNr"
	FROM toms."TilesInAcceptedProposals"
	WHERE "ProposalID" IN (72, 39, 64, 50, 69);

    DELETE FROM toms."TilesInAcceptedProposals"
	WHERE "ProposalID" IN (72, 39, 64, 50, 69);

    -- Deal with Proposals
    raise notice 'Setting proposals to rejected ...';

    FOR proposal IN
        SELECT p."ProposalID", p."ProposalTitle"
        FROM toms."Proposals" p
        WHERE p."ProposalID" IN (72, 39, 64, 50, 69)
        ORDER BY p."ProposalID"
    LOOP

        raise notice 'Considering % ...', proposal."ProposalTitle";

        -- Set Proposal as "Rejected"
        UPDATE toms."Proposals"
        SET "ProposalStatusID" = 3
        WHERE "ProposalID" = proposal."ProposalID";

    END LOOP;

END;
$do$;


/***
 To see which restrictions from a given Proposals are within a specifc tile ...
 ***/

DO
$do$
DECLARE
    proposal_id INTEGER = 308;
    tile_nr INTEGER = 1512;
BEGIN

    SELECT r."GeometryID"
    FROM toms."Bays" r, toms."RestrictionsInProposals" RiP, toms."TilesInAcceptedProposals" TiP
    WHERE TiP."TileNr" = tile_nr
    AND TiP."ProposalID" = proposal_id
    AND TiP."ProposalID" = RiP."ProposalID"
    AND RiP."RestrictionID" = r."RestrictionID";


END;
$do$;


CREATE FUNCTION restrictions_in_proposal_in_tile (proposal_id int, tile_nr int)
RETURNS TABLE("GeoemtryID" text) AS $$
    SELECT r."GeometryID"
    FROM toms."Bays" r, toms."RestrictionsInProposals" RiP, toms."TilesInAcceptedProposals" TiP, toms."MapGrid" m
    WHERE TiP."TileNr" = tile_nr
    AND TiP."ProposalID" = proposal_id
    AND TiP."ProposalID" = RiP."ProposalID"
    AND RiP."RestrictionID" = r."RestrictionID"
    AND ST_Within(r.geom, m.geom);
$$ LANGUAGE SQL;



SELECT r."RestrictionID", r.geom, r."GeometryID"
FROM toms."Bays" r, toms."MapGrid" m
WHERE TiP."TileNr" = 1512
AND TiP."ProposalID" = 308
AND TiP."ProposalID" = RiP."ProposalID"
AND RiP."RestrictionID" = r."RestrictionID"
AND ST_Within(r.geom, m.geom);

, toms."RestrictionsInProposals" RiP, toms."TilesInAcceptedProposals" TiP,