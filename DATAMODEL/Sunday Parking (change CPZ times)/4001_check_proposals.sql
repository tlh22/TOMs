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





SELECT "ProposalID", "ProposalTitle", "ProposalStatusTypes"."Description" AS "ProposalStatus", "ProposalOpenDate"
FROM toms."Proposals" As p
LEFT JOIN "toms_lookups"."ProposalStatusTypes" AS "ProposalStatusTypes" ON p."ProposalStatusID" is not distinct from "ProposalStatusTypes"."Code"
WHERE "ProposalTitle" LIKE '%TRO-19-29%'





SELECT DISTINCT id, "CurrRevisionNr", "LastRevisionDate", "ProposalID", "TileNr", "RevisionNr"
FROM toms."MapGrid" m, toms."ControlledParkingZones" c, toms."TilesInAcceptedProposals" TiP
WHERE ST_Intersects(m.geom, c.geom)
AND c."CPZ" IN ('1', '1A', '2', '3', '4')
AND m.id = TiP."TileNr"
ORDER BY "TileNr", "RevisionNr", "ProposalID"


SELECT DISTINCT TiP."TileNr", TiP."RevisionNr", p."ProposalID", p."ProposalOpenDate"
FROM toms."TilesInAcceptedProposals" TiP, toms."Proposals" p,
(SELECT m.id
 FROM toms."MapGrid" m, toms."ControlledParkingZones" c
 WHERE ST_Intersects(m.geom, c.geom)
 AND c."CPZ" IN ('1', '1A', '2', '3', '4')
) AS x
WHERE x.id = TiP."TileNr"
AND TiP."ProposalID" = p."ProposalID"
ORDER BY TiP."TileNr", TiP."RevisionNr", p."ProposalID"