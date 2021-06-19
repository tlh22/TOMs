/**
Find the current restrictions that have an open date after the original proposal

Using these restrictions, recursively search back to find the any restrictions that were closed by these restrictions, i.e., overlap these restrictions

**/

-- Bays

SELECT DISTINCT r."GeometryID", r."RestrictionID", p."ProposalID"
FROM toms."RestrictionsInProposals" RiS, toms."Proposals" p, toms."Bays" r
WHERE r."RestrictionID" = RiS."RestrictionID"
AND r."OpenDate" IS NOT NULL
AND r."CloseDate" IS NULL
AND r."CPZ" IN ('1', '1A', '2', '3', '4')
AND r."OpenDate" > '2020-11-09'
AND RiS."ProposalID" = p."ProposalID"
AND p."ProposalStatusID" = 2


-- Lines

-- Check for restrictions that are open but not part of an Accepted Proposal

SELECT r."GeometryID", r."OpenDate", p."ProposalID", p."ProposalStatusID"
FROM toms."Bays" r, toms."RestrictionsInProposals" RiS, toms."Proposals" p
WHERE r."OpenDate" IS NOT NULL
AND r."CloseDate" IS NULL
AND "CPZ" IN ('1', '1A', '2', '3', '4')
AND "OpenDate" > '2020-11-09'
--ORDER BY "CPZ";
AND r."RestrictionID" = RiS."RestrictionID"
AND RiS."ProposalID" = p."ProposalID"
AND p."ProposalStatusID" != 2




DO
$do$
DECLARE
   row RECORD;

   --road_markings_status integer;
BEGIN
    FOR row IN
        SELECT DISTINCT r."GeometryID", r."RestrictionID", p."ProposalID"
        FROM toms."RestrictionsInProposals" RiS, toms."Proposals" p, toms."Bays" r
        WHERE r."RestrictionID" = RiS."RestrictionID"
        AND r."OpenDate" IS NOT NULL
        AND r."CloseDate" IS NULL
        AND r."CPZ" IN ('1', '1A', '2', '3', '4')
        AND r."OpenDate" > '2020-11-09'
        AND RiS."ProposalID" = p."ProposalID"
        AND p."ProposalStatusID" = 2
    LOOP

        SELECT *
        FROM
            mhtc_operations."getDeletedRestrictions"(row."RestrictionID", row."ProposalID")
            AS t ("RestrictionID" varchar);

    END LOOP;
END
$do$;



CREATE OR REPLACE FUNCTION mhtc_operations."getDeletedRestrictions"(curr_restriction_id text, curr_proposal_id integer)
    RETURNS SETOF varchar
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
   curr_restriction_geom text;
   restriction_table_name text;
   query text;
   r record;
BEGIN

  -- Work out which table to use
    SELECT l."RestrictionLayerName" INTO restriction_table_name
    FROM toms."RestrictionsInProposals" RiS, toms."RestrictionLayers" l
    WHERE "RestrictionID" = curr_restriction_id
    AND RiS."RestrictionTableID" = l."Code";

  -- get current geometry
    query = format ('SELECT ST_AsText(geom) FROM "toms"."%s" r '
                    ' WHERE r."RestrictionID" = %s', restriction_table_name, quote_literal (curr_restriction_id));
    RAISE NOTICE '***** geom query: (%)', query;

    EXECUTE query INTO curr_restriction_geom;

    -- find closed restrictions that overlap current restriction
    query = format('SELECT r."RestrictionID" FROM toms."RestrictionsInProposals" RiS, "toms"."%s" r'
                  ' WHERE RiS."RestrictionID" = r."RestrictionID" AND RiS."ProposalID" = %s'
                  ' AND RiS."ActionOnProposalAcceptance" = 2'
                  ' AND ST_Intersects(r.geom, ST_Buffer(ST_GeomFromText(%s, 27700), 0.25))', restriction_table_name, curr_proposal_id, quote_literal(curr_restriction_geom));

    RAISE NOTICE '***** geom query: (%)', query;


??? not sure why this is not returning correctly

    RETURN;

END;
$BODY$;