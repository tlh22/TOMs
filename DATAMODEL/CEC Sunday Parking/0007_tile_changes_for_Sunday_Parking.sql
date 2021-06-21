/**
Need to ensure that all tiles containing changes are within the table "TilesInAcceptedProposals"

Also need to check that version numbers are correct.

Actually is it the tiles intersecting the current CPZs

**/

select *
from toms."MapGrids"
where

create or replace function mapTilesInProposal(proposal_id int)
  RETURNS TABLE (mapgrid_id bigint)
  LANGUAGE plpgsql
  as $func$
DECLARE
   row RECORD;
begin

    for row IN
        select RiP."ProposalID", RiP."RestrictionTableID", RiP."ActionOnProposalAcceptance", RiP."RestrictionID", l."RestrictionLayerName"
        from toms."RestrictionsInProposals" RiP, toms."RestrictionLayers" l
        where RiP."RestrictionTableID" = l."Code"
        and "ProposalID" = proposal_id
    loop

        raise NOTICE '***** CONSIDERING geom RestrictionID: %', row."RestrictionID";

        return QUERY execute FORMAT
            (
            'SELECT m.id AS mapgrid_id
            FROM toms."MapGrid" m, toms.%I r
            WHERE r."RestrictionID" = quote_literal(%s)
             AND ST_Intersects(r.geom, m.geom)', row."RestrictionLayerName", row."RestrictionID"
            );
    END LOOP;

END
$func$;


SELECT DISTINCT m.id, m."CurrRevisionNr", m."LastRevisionDate"
from toms."MapGrid" m, toms."ControlledParkingZones" c
WHERE c."OpenDate" IS NOT NULL
AND c."CloseDate" IS NULL
AND c."CPZ" IN ('1', '1A', '2', '3', '4')
AND ST_Intersects(m.geom, c.geom)
AND m.id NOT IN (
    SELECT "TileNr"
    FROM toms."TilesInAcceptedProposals" p
    WHERE "ProposalID" IN (44, 47, 59, 71)
)
ORDER BY m."LastRevisionDate" Desc


-- Duplicates !!!

SELECT DISTINCT t1."ProposalID", t1."TileNr", t1."RevisionNr"
FROM toms."TilesInAcceptedProposals" t1, toms."TilesInAcceptedProposals" t2
WHERE t1."TileNr" = t2."TileNr"
AND t1."RevisionNr" = t2."RevisionNr"
AND t1."ProposalID" != t2."ProposalID"
ORDER BY t1."TileNr"
