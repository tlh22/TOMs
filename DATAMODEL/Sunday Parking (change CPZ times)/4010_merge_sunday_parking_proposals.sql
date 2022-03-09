/***
 * Merge all Proposals associated with Sunday Parking within inner zones


Proposals are:
 - CPZ 1 (Proposal 71)
 - CPZ 1A (Proposal 44)
 - CPZ 2 (Proposal 203)
 - CPZ 3 (Proposal 47)
 - CPZ 4 (Proposal 59)
 - PTAs (Proposal 205)

Need to include into one new Proposal. Create a new one and mark the others as "Rejected"

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
    VALUES (2, now(), 'Merge of Sunday Parking Proposals (inner zones)', 'TRO-19-29A - Sunday Parking Proposal (Inner Zones) MERGED', '2020-11-09');

    -- Get Proposal ID
    SELECT max("ProposalID")::integer INTO sunday_parking_proposal_id
    FROM toms."Proposals";

    -- Deal with restrictions
    raise notice 'Moving restrictions ...';

    FOR proposal IN
        SELECT p."ProposalID", p."ProposalTitle"
        FROM toms."Proposals" p
        WHERE p."ProposalID" IN (44, 71, 203, 47, 59, 205)
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
	WHERE "ProposalID" IN (44, 71, 203, 47, 59, 205);

    DELETE FROM toms."TilesInAcceptedProposals"
	WHERE "ProposalID" IN (44, 71, 203, 47, 59, 205);

    -- Deal with Proposals
    raise notice 'Setting proposals to rejected ...';

    FOR proposal IN
        SELECT p."ProposalID", p."ProposalTitle"
        FROM toms."Proposals" p
        WHERE p."ProposalID" IN (44, 71, 203, 47, 59, 205)
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

-- Now deal with tile with the same Acceptance date and ensure that there are sequential revision numbers

-- 987

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 987;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 987
AND "ProposalID" = 162;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 987
AND "ProposalID" = 67;

-- 1220

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 5
WHERE id = 1220;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1220
AND "ProposalID" = 62;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1220
AND "ProposalID" = 139;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 5
WHERE "TileNr" = 1220
AND "ProposalID" = 64;

-- 1222

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1222;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1222
AND "ProposalID" = 67;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1222
AND "ProposalID" = 139;

-- 1628

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3
WHERE id = 1628;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1628
AND "ProposalID" = 119;

-- 1863

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 6
WHERE id = 1863;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1863
AND "ProposalID" = 112;

-- 1922

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 5
WHERE id = 1922;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1922
AND "ProposalID" = 119;

-- 2160

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 5
WHERE id = 1922;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 2160
AND "ProposalID" = 62;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 2160
AND "ProposalID" = 139;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 5
WHERE "TileNr" = 2160
AND "ProposalID" = 143;