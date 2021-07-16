/*
Check proposals involved with Sunday Parking
*/

SELECT DISTINCT id
FROM toms."MapGrid" m, toms."ControlledParkingZones" c
WHERE ST_Intersects(m.geom, c.geom)
AND c."CPZ" IN ('1', '1A', '2', '3', '4')
AND id NOT IN
(
SELECT DISTINCT "TileNr"
	FROM toms."TilesInAcceptedProposals"
WHERE "ProposalID" IN (44, 47, 59, 71)
ORDER BY "TileNr" )

SELECT DISTINCT id
FROM toms."MapGrid" m, toms."ControlledParkingZones" c
WHERE ST_Intersects(m.geom, c.geom)
AND c."CPZ" IN ('1', '1A', '2', '3', '4')
AND id IN
(
SELECT DISTINCT "TileNr"
	FROM toms."TilesInAcceptedProposals"
WHERE "ProposalID" IN (139)
ORDER BY "TileNr"
)



SELECT DISTINCT id
FROM toms."MapGrid" m, toms."ControlledParkingZones" c
WHERE ST_Intersects(m.geom, c.geom)
AND c."CPZ" IN ('1', '1A', '2', '3', '4')
AND id IN
(
SELECT DISTINCT "TileNr"
	FROM toms."TilesInAcceptedProposals" t, toms."Proposals" p
WHERE t."ProposalID" = p."ProposalID"
AND p."ProposalOpenDate" > '2020-11-09'
--ORDER BY "TileNr"
)



-- check contents of Proposal

SELECT "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID"
	FROM toms."RestrictionsInProposals"
WHERE "ProposalID" IN (44, 47, 59, 71)
ORDER BY "RestrictionTableID" DESC




-- Tiles that have new version numbers ...

SELECT DISTINCT "TileNr", "ProposalID"
FROM toms."TilesInAcceptedProposals" t, toms."Proposals" p
WHERE t."ProposalID" = p."ProposalID"
AND p."ProposalOpenDate" > '2020-11-09'
AND  t."TileNr" IN (
SELECT DISTINCT id
FROM toms."MapGrid" m, toms."ControlledParkingZones" c
WHERE ST_Intersects(m.geom, c.geom)
AND c."CPZ" IN ('1', '1A', '2', '3', '4')
AND id NOT IN
(
SELECT DISTINCT "TileNr"
	FROM toms."TilesInAcceptedProposals"
WHERE "ProposalID" IN (44, 47, 59, 71)
ORDER BY "TileNr" )
)

