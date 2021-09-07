/**
Manually deal with issues for map grids - need to enter corrections mannually after applying grid details ...
**/

--- Verify details in MapGrid
SELECT DISTINCT id, "CurrRevisionNr", "LastRevisionDate"
FROM toms."MapGrid" m, toms."ControlledParkingZones" c
WHERE ST_Intersects(m.geom, c.geom)
AND c."CPZ" IN ('1', '1A', '2', '3', '4')
	ORDER BY id;

-- verify details in "TilesInAcceptedProposals"
SELECT DISTINCT TiP."TileNr", TiP."RevisionNr", p."ProposalID", p."ProposalOpenDate"
FROM toms."TilesInAcceptedProposals" TiP, toms."Proposals" p,
(SELECT m.id
 FROM toms."MapGrid" m, toms."ControlledParkingZones" c
 WHERE ST_Intersects(m.geom, c.geom)
 AND c."CPZ" IN ('1', '1A', '2', '3', '4')
) AS x
WHERE x.id = TiP."TileNr"
AND TiP."ProposalID" = p."ProposalID"
ORDER BY TiP."TileNr", TiP."RevisionNr", p."ProposalID";


/***** manually entered details *******/

--1394

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (71, 1394, 2);

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "ProposalID" IN (71, 44, 203, 47, 59)
AND "TileNr" = 1394;

-- 1454

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 2
WHERE id = 1454;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "ProposalID" IN (71, 44, 203, 47, 59)
AND "TileNr" = 1454;

-- 1278

UPDATE toms."TilesInAcceptedProposals"  -- this has same open date as Proposal 64
SET "RevisionNr" = 3
WHERE "ProposalID" = 39
AND "TileNr" = 1278;

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (203, 1278, 2);

-- 1279

UPDATE toms."TilesInAcceptedProposals"  -- Duplicate ??! - version number incremented
SET "RevisionNr" = 3
WHERE "ProposalID" = 92
AND "TileNr" = 1279;

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 5
WHERE "ProposalID" = 64
AND "TileNr" = 1279;

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (203, 1279, 4);

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 5
WHERE id = 1279;

-- 1280

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 4
WHERE "ProposalID" = 64
AND "TileNr" = 1280;

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (203, 1280, 3);

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1280;

-- 1337

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (203, 1337, 2);

UPDATE toms."TilesInAcceptedProposals"  -- Version number decremented as opened on same date as Proposal 39
SET "RevisionNr" = 3
WHERE "ProposalID" = 64
AND "TileNr" = 1337;

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3
WHERE id = 1337;

-- 1338, 1339

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 2
WHERE id IN (1338, 1339);

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 2
WHERE "ProposalID" IN (71, 44, 203, 47, 59)
AND "TileNr" IN (1338, 1339);

-- 1397

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 3
WHERE "ProposalID" = 150
AND "TileNr" = 1397;

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (203, 1397, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (47, 1397, 2);

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3
WHERE id = 1397;

-- 1398 ** something strange here ... somehow version numbers are out of sync with dates ...

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 3
WHERE "ProposalID" = 47
AND "TileNr" = 1398;

-- 1341

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 3
WHERE "ProposalID" = 64
AND "TileNr" = 1341;

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (47, 1341, 2);

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 3
WHERE id = 1341;

-- 1751

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 3
WHERE "ProposalID" = 139
AND "TileNr" = 1751;

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented - same open date as Proposal 69
SET "RevisionNr" = 4
WHERE "ProposalID" = 50
AND "TileNr" = 1751;

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (47, 1751, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (59, 1751, 2);

-- 1752

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 3
WHERE "ProposalID" = 139
AND "TileNr" = 1752;

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented - same open date as Proposal 69
SET "RevisionNr" = 4
WHERE "ProposalID" = 50
AND "TileNr" = 1752;

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (47, 1752, 2);

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1752;

-- 1518

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 2
WHERE "ProposalID" = 47
AND "TileNr" = 1518;

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 2
WHERE id = 1518;

-- 1750

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 3
WHERE "ProposalID" = 139
AND "TileNr" = 1750;

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented - same open date as Proposal 69
SET "RevisionNr" = 4
WHERE "ProposalID" = 69
AND "TileNr" = 1750;

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (59, 1750, 2);

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1750;

/*** PTAs  ***/

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1278, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1279, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1280, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1335, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1336, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1337, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1341, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1393, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1394, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1397, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1512, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1516, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1630, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1635, 2);

-- 1689 ** something strange here ... somehow version numbers are out of sync with dates ...

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 3
WHERE "ProposalID" = 59
AND "TileNr" = 1689;

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 4
WHERE "ProposalID" = 69
AND "TileNr" = 1689;

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1689;

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1689, 3);

-- 1690 ** something strange here ... somehow version numbers are out of sync with dates ...

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 3
WHERE "ProposalID" = 59
AND "TileNr" = 1690;

UPDATE toms."TilesInAcceptedProposals"  -- Version number incremented
SET "RevisionNr" = 4
WHERE "ProposalID" = 69
AND "TileNr" = 1690;

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 4
WHERE id = 1690;

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1690, 3);

--

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1691, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1694, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1749, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1750, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1751, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1752, 2);

INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (205, 1753, 2);