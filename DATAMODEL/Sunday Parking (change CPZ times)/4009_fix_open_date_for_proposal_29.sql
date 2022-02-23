/****
 * Change Effective date for Proposal 29 (TRO-17-98) to 2019
 ***/

-- Change Proposal
UPDATE toms."Proposals"
SET "ProposalOpenDate" = '2019-10-01'
WHERE "ProposalID" = 29;

-- Change effected tiles
--** 857 --
UPDATE toms."MapGrid"
SET "LastRevisionDate" = '2019-10-01'
WHERE id = 857;

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

--** 988 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 2, "LastRevisionDate" = '2019-10-01'
WHERE id = 988;

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

--** 1927 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1927;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1927
AND "ProposalID" = 29;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 1927
AND "ProposalID" = 62;

--** 1928 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2019-10-01'
WHERE id = 1928;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1928
AND "ProposalID" = 29;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 1928
AND "ProposalID" = 62;
