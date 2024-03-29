/****
 * Change Effective date for Proposal 29 (TRO-17-98) to 2019
 ***/

SELECT toms."change_proposal_open_date" (29, '01/10/2019');  -- This will change over all the restrictions and try to deal with map tiles

-- There are two tiles (987 and 1222) for which another Proposal is effective on the same day. Manually change these ...

--** 987 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3
WHERE id = 987;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 987
AND "ProposalID" = 162;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 987
AND "ProposalID" = 67;

--** 1222 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3
WHERE id = 1222;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1222
AND "ProposalID" = 139;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 1222
AND "ProposalID" = 67;


/***
 * Other tidying ...  revision numbers out of order
 ***/

-- tile 689

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 689
AND "ProposalID" = 17;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 689
AND "ProposalID" = 67;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 689
AND "ProposalID" = 77;

-- 1927

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 1927
AND "ProposalID" = 62;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1927
AND "ProposalID" = 29;

-- 1928

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 1928
AND "ProposalID" = 62;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1928
AND "ProposalID" = 29;