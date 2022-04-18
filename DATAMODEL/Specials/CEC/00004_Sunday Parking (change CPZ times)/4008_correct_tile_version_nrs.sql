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
SET "RevisionNr" = 4
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
AND "ProposalID" = 67;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1222
AND "ProposalID" = 139;

--** 1279 --

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1279
AND "ProposalID" = 205;

--** 1280 --

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1280
AND "ProposalID" = 205;

--** 1321 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 2
WHERE id = 1321;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 1321
AND "ProposalID" = 131;

--** 1334 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1334;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1334
AND "ProposalID" = 72;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1334
AND "ProposalID" = 92;

--** 1341 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1341;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1341
AND "ProposalID" = 162;

--** 1395 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3
WHERE id = 1395;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1395
AND "ProposalID" = 44;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1395
AND "ProposalID" = 205;

--** 1688 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1688;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1688
AND "ProposalID" = 69;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1688
AND "ProposalID" = 87;

--** 1720 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 2
WHERE id = 1720;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 1720
AND "ProposalID" = 133;

--** 1746 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1746;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1746
AND "ProposalID" = 164;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1746
AND "ProposalID" = 87;

--** 1747 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1747;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1747
AND "ProposalID" = 139;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1747
AND "ProposalID" = 87;

--** 1805 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 5
WHERE id = 1805;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 5
WHERE "TileNr" = 1805
AND "ProposalID" = 164;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1805
AND "ProposalID" = 139;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1805
AND "ProposalID" = 87;

--** 1862 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2019-10-07'
WHERE id = 1862;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1862
AND "ProposalID" = 77;

--** 1920 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2019-10-07'
WHERE id = 1920;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1920
AND "ProposalID" = 79;

--** 1927 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1927;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1927
AND "ProposalID" = 139;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1927
AND "ProposalID" = 62;

--** 1928 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3
WHERE id = 1928;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1928
AND "ProposalID" = 62;

--** 1974 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2019-10-07'
WHERE id = 1974;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1974
AND "ProposalID" = 77;

--** 1979 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2019-10-01'
WHERE id = 1979;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1979
AND "ProposalID" = 48;

--** 1987 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 2
WHERE id = 1987;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 1987
AND "ProposalID" = 163;

--** 1988 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 2
WHERE id = 1988;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 1988
AND "ProposalID" = 163;

--** 2038 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2019-10-01'
WHERE id = 2038;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 2038
AND "ProposalID" = 48;

--** 2097 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2019-10-01'
WHERE id = 2097;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 2097
AND "ProposalID" = 48;

--** 2148 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2019-10-07'
WHERE id = 2148;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 2148
AND "ProposalID" = 79;

--** 2289 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 2
WHERE id = 2289;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 2289
AND "ProposalID" = 133;

--** 2508 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 2
WHERE id = 2508;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 2508
AND "ProposalID" = 133;

--** 2567 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 2567;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 2567
AND "ProposalID" = 133;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 2567
AND "ProposalID" = 79;

--** 2631 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4, "LastRevisionDate" = '2019-10-07'
WHERE id = 2631;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 2631
AND "ProposalID" = 77;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 2631
AND "ProposalID" = 48;

--** 2742 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2019-10-07'
WHERE id = 2742;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 2742
AND "ProposalID" = 79;

--** 2743 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2019-11-25'
WHERE id = 2743;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 2743
AND "ProposalID" = 42;

--** 2748 --
UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3, "LastRevisionDate" = '2019-10-07'
WHERE id = 2748;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 2748
AND "ProposalID" = 79;

/*** Tiles with different version numbers but the same proposal open date ***/

--** 1159 --

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1159;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1159
AND "ProposalID" = 133;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1159
AND "ProposalID" = 64;

--** 1160 --

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 2
WHERE id = 1160;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "TileNr" = 1160
AND "ProposalID" = 64;

--** 1335 --

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3
WHERE id = 1335;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1335
AND "ProposalID" = 39;

--** 1810 --

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 5
WHERE id = 1810;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 5
WHERE "TileNr" = 1810
AND "ProposalID" = 121;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 4
WHERE "TileNr" = 1810
AND "ProposalID" = 163;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1810
AND "ProposalID" = 69;