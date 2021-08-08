/**
Check that all relevant restrictions have Sunday parking hours
**/


-- **** identify Proposals that relate to Sunday Parking ...
-- Accepted
SELECT p."ProposalID", p."ProposalTitle", y."GeometryID", y."CPZ"
FROM toms."Proposals" p,
(
SELECT "ProposalID", "GeometryID", "CPZ"
FROM toms."RestrictionsInProposals" RiP,
    (
    SELECT r."RestrictionID", r."GeometryID", r."CPZ"
    FROM toms."ControlledParkingZones" c, toms."Bays" r
    WHERE ST_Intersects(r.geom, c.geom)
    AND c."CPZ" IN ('1', '1A', '2', '3', '4')
    ) AS x
WHERE RiP."RestrictionID" = x."RestrictionID"
) As y
WHERE y."ProposalID" = p."ProposalID"
AND "ProposalStatusID" = 2
AND p."ProposalOpenDate" >= '2020-11-09'




WHERE ST_Intersects(m.geom, c.geom)
AND c."CPZ" IN ('1', '1A', '2', '3', '4')

-- In Preparation






SELECT r."GeometryID", r."CPZ", r."TimePeriodID"
FROM toms."Bays" r, toms."ControlledParkingZones" c
WHERE ST_Intersects(r.geom, c.geom)
AND c."CPZ" IN ('1', '1A', '2', '3', '4')
AND r."TimePeriodID" NOT IN (0, 1, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318)
AND r."OpenDate" IS NOT NULL
AND r."CloseDate" IS NULL



-- Check for restrictions already in Proposal that don't have correct time periods

SELECT r."GeometryID", r."CPZ", r."TimePeriodID"
FROM toms."Bays" r, toms."ControlledParkingZones" c
WHERE ST_Intersects(r.geom, c.geom)
AND c."CPZ" IN ('1', '1A', '2', '3', '4')
AND r."TimePeriodID" NOT IN (0, 1, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318)
AND r."OpenDate" IS NOT NULL
AND r."CloseDate" IS NULL
AND r."RestrictionID" IN (SELECT "RestrictionID"
                          FROM toms."RestrictionsInProposals" RiP
                          WHERE "ProposalID" IN (71, 44, 203, 47, 59)
                          AND "ActionOnProposalAcceptance" = 1)

-- check for extra time periods

SELECT DISTINCT r."TimePeriodID", l."Description"
FROM toms."ControlledParkingZones" c, toms."Bays" r, toms_lookups."BayLineTypes" l
WHERE ST_Intersects(r.geom, c.geom)
AND c."CPZ" IN ('1', '1A', '2', '3', '4')
AND r."TimePeriodID" = l."Code"

