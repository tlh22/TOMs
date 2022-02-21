-- deal with incorrect currRevisionNr in MapGrid

--** 630 -- TRO-19-25 (103)
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3
WHERE id = 630;

-- correct within "TilesInAcceptedProposals"

--** 865 -- TRO-19-14 (91)
UPDATE toms."MapGrid" m
SET "CurrRevisionNr" = 4, "LastRevisionDate" = '2020-05-04'
WHERE id = 865;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 865
AND "ProposalID" = 91;

--** 1628 --

-- correct within "MapGrid"

UPDATE toms."TilesInAcceptedProposals" -- additional increment on same day
SET "RevisionNr" = 2
WHERE "TileNr" = 1628
AND "ProposalID" = 112;

--** 1802 --
UPDATE toms."MapGrid" m
SET "CurrRevisionNr" = 5
WHERE id = 1802;

-- correct within "TilesInAcceptedProposals"

--** 1863 --

-- correct within "MapGrid"

UPDATE toms."TilesInAcceptedProposals"  -- additional increment on same day
SET "RevisionNr" = 5
WHERE "TileNr" = 1863
AND "ProposalID" = 112;

--** 1921 --
UPDATE toms."MapGrid" m
SET "CurrRevisionNr" = 4
WHERE id = 1921;

-- correct within "TilesInAcceptedProposals"

--** 1922 --
UPDATE toms."MapGrid" m
SET "CurrRevisionNr" = 4
WHERE id = 1922;

UPDATE toms."TilesInAcceptedProposals"  -- additional increment on same day
SET "RevisionNr" = 4
WHERE "TileNr" = 1922
AND "ProposalID" = 106;

--** 2134 --
UPDATE toms."MapGrid" m
SET "CurrRevisionNr" = 4
WHERE id = 2134;

-- correct within "TilesInAcceptedProposals"

--** 2452 --
UPDATE toms."MapGrid" m
SET "CurrRevisionNr" = 3
WHERE id = 2452;

-- correct within "TilesInAcceptedProposals"

--** 2453 --
UPDATE toms."MapGrid" m
SET "CurrRevisionNr" = 3
WHERE id = 2453;

-- correct within "TilesInAcceptedProposals"

--*********************
-- different proposals that are using the same version number (on a different open date)

--** 742 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 2
WHERE id = 742;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 742
AND "ProposalID" = 131;

--** 749 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 749;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 749
AND "ProposalID" = 77;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 749
AND "ProposalID" = 121;

--** 806 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 806;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 5
WHERE "TileNr" = 806
AND "ProposalID" = 91;

--** 924 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 924;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 924
AND "ProposalID" = 81;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 924
AND "ProposalID" = 30;

--** 987 --
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

--** 1083 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3
WHERE id = 1083;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1083
AND "ProposalID" = 80;

--** 1103 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2020-04-25'
WHERE id = 1103;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1103
AND "ProposalID" = 88;

--** 1104 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2019-11-25'
WHERE id = 1104;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1104
AND "ProposalID" = 105;

--** 1146 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3
WHERE id = 1146;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1146
AND "ProposalID" = 131;

--** 1161 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1161;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1161
AND "ProposalID" = 78;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1161
AND "ProposalID" = 139;

--** 1222 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1222;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1222
AND "ProposalID" = 78;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1222
AND "ProposalID" = 139;



--** 1280 --

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1280
AND "ProposalID" = 205;



