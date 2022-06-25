/***

  Final check to ensure that restrictions are in correct Proposal

 ***/

 -- Check changes to inner CPZs within outer
SELECT m."id"
FROM toms."MapGrid" m, toms."TilesInAcceptedProposals" TiP
WHERE m."id" = TiP."TileNr"
AND TiP."ProposalID" = 308
AND m."id" NOT IN (
SELECT m."id"
FROM toms."MapGrid" m, toms."TilesInAcceptedProposals" TiP, toms."ControlledParkingZones" c
WHERE m."id" = TiP."TileNr"
AND TiP."ProposalID" = 308
AND c."CPZ" IN ('5', '6', '7', '8', '5A')
AND ST_Intersects(c.geom, m.geom) );

-- Check changes to outer CPZs within inner
SELECT m."id"
FROM toms."MapGrid" m, toms."TilesInAcceptedProposals" TiP
WHERE m."id" = TiP."TileNr"
AND TiP."ProposalID" = 306
AND m."id" NOT IN (
SELECT m."id"
FROM toms."MapGrid" m, toms."TilesInAcceptedProposals" TiP, toms."ControlledParkingZones" c
WHERE m."id" = TiP."TileNr"
AND TiP."ProposalID" = 306
AND c."CPZ" IN ('1', '1A', '2', '3', '4')
AND ST_Intersects(c.geom, m.geom) );

/***
 To see which restrictions from a given Proposals are within a specifc tile ...
 ***/

DROP FUNCTION IF EXISTS restrictions_in_proposal_in_tile (int, int);

CREATE OR REPLACE FUNCTION restrictions_in_proposal_in_tile (proposal_id int, tile_nr int)
RETURNS TABLE("Layer" text, "GeometryID" text, "RestrictionID" text) AS $$
    SELECT 'Bays' AS "Layer", r."GeometryID", r."RestrictionID"
    FROM toms."Bays" r, toms."RestrictionsInProposals" RiP, toms."TilesInAcceptedProposals" TiP, toms."MapGrid" m
    WHERE m."id" = tile_nr
    AND TiP."TileNr" = m."id"
    AND TiP."ProposalID" = proposal_id
    AND TiP."ProposalID" = RiP."ProposalID"
    AND RiP."RestrictionID" = r."RestrictionID"
    AND RiP."RestrictionTableID" = 2
    AND ST_Within(r.geom, m.geom)

    UNION

    SELECT 'Lines' AS "Layer", r."GeometryID", r."RestrictionID"
    FROM toms."Lines" r, toms."RestrictionsInProposals" RiP, toms."TilesInAcceptedProposals" TiP, toms."MapGrid" m
    WHERE m."id" = tile_nr
    AND TiP."TileNr" = m."id"
    AND TiP."ProposalID" = proposal_id
    AND TiP."ProposalID" = RiP."ProposalID"
    AND RiP."RestrictionID" = r."RestrictionID"
    AND RiP."RestrictionTableID" = 3
    AND ST_Within(r.geom, m.geom)

    UNION

    SELECT 'RestrictionPolygons' AS "Layer", r."GeometryID", r."RestrictionID"
    FROM toms."RestrictionPolygons" r, toms."RestrictionsInProposals" RiP, toms."TilesInAcceptedProposals" TiP, toms."MapGrid" m
    WHERE m."id" = tile_nr
    AND TiP."TileNr" = m."id"
    AND TiP."ProposalID" = proposal_id
    AND TiP."ProposalID" = RiP."ProposalID"
    AND RiP."RestrictionID" = r."RestrictionID"
    AND RiP."RestrictionTableID" = 4
    AND ST_Within(r.geom, m.geom)

    UNION

    SELECT 'CPZs' AS "Layer", r."GeometryID", r."RestrictionID"
    FROM toms."ControlledParkingZones" r, toms."RestrictionsInProposals" RiP, toms."TilesInAcceptedProposals" TiP, toms."MapGrid" m
    WHERE m."id" = tile_nr
    AND TiP."TileNr" = m."id"
    AND TiP."ProposalID" = proposal_id
    AND TiP."ProposalID" = RiP."ProposalID"
    AND RiP."RestrictionID" = r."RestrictionID"
    AND RiP."RestrictionTableID" = 6
    AND ST_Intersects(r.geom, m.geom)

    UNION

        SELECT 'PTAs' AS "Layer", r."GeometryID", r."RestrictionID"
        FROM toms."ParkingTariffAreas" r, toms."RestrictionsInProposals" RiP, toms."TilesInAcceptedProposals" TiP, toms."MapGrid" m
        WHERE m."id" = tile_nr
        AND TiP."TileNr" = m."id"
        AND TiP."ProposalID" = proposal_id
        AND TiP."ProposalID" = RiP."ProposalID"
        AND RiP."RestrictionID" = r."RestrictionID"
        AND RiP."RestrictionTableID" = 7
        AND ST_Intersects(r.geom, m.geom)
    ;
$$ LANGUAGE SQL;

-- SELECT restrictions_in_proposal_in_tile (proposal_id, map_tile);


-- Move restrictions that should be within the inner zones

DO
$do$
DECLARE
    inner_zones_proposal_id INTEGER;
    inner_zones_open_date DATE;
    outer_zones_proposal_id INTEGER;
    proposal RECORD;
BEGIN

    -- Get relevant Proposals
    SELECT "ProposalID", "ProposalOpenDate" INTO inner_zones_proposal_id, inner_zones_open_date
    FROM toms."Proposals"
    WHERE "ProposalTitle" = 'TRO-19-29A - Sunday Parking Proposal (Inner Zones) MERGED';

    SELECT "ProposalID" INTO outer_zones_proposal_id
    FROM toms."Proposals"
    WHERE "ProposalTitle" = 'TRO-19-29B - Sunday Parking Proposal (Outer Zones) MERGED';

    -- Deal with restrictions
    raise notice 'Moving restrictions from outer to inner ...';

    -- deal with open date/close date
    UPDATE toms."Lines"
    SET "CloseDate" = inner_zones_open_date
    WHERE "RestrictionID" = 'L_112162';

    -- RestrictionsInProposals
    /*** UPDATE toms."RestrictionsInProposals"
    SET "ProposalID" = 306
    WHERE "RestrictionID" = 'L_112162'
    AND "ProposalID" = 308; ***/

    -- DELETE
    DELETE FROM toms."RestrictionsInProposals"
    WHERE "RestrictionID" = 'L_112162'
    AND "ProposalID" = 308;

    -- Reset MapGrid
    DELETE FROM toms."TilesInAcceptedProposals"
    WHERE "TileNr" = 1512
    AND "RevisionNr" = 3;

    UPDATE toms."MapGrid"
    SET "CurrRevisionNr" = 2, "LastRevisionDate" = inner_zones_open_date
    WHERE "id" = 1512;


END;
$do$;

