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

-- Tidy Proposals - remove duplications of deleted restrictions
DELETE FROM toms."RestrictionsInProposals"
WHERE "RestrictionID" IN ('L_15379', 'L_15397', 'L_15398', 'L_15517')
AND "ProposalID" = 39;

-- and deal with within the new restrictions.
DELETE FROM toms."RestrictionsInProposals"
WHERE "RestrictionID" IN ('43d0a206-e525-4ab5-83b1-ddb2302663b0')
AND "ProposalID" = 39;

/***  TODO: at some point in the future
DELETE FROM toms."Lines"
WHERE "RestrictionID" IN ('43d0a206-e525-4ab5-83b1-ddb2302663b0');
***/

-- Move restriction details to single Proposal

DO
$do$
DECLARE
    sunday_parking_proposal_id INTEGER;
    proposal RECORD;
BEGIN

    -- Create a new Proposal
    INSERT INTO toms."Proposals" ("ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate")
    VALUES (2, now(), 'Merge of Sunday Parking Proposals (outer zones)', 'TRO-19-29B - Sunday Parking Proposal (Outer Zones) MERGED', '2021-04-05');

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

