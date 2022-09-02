/***
 * Restrictions within Proposals and the tiles effected
 ***/

DROP FUNCTION IF EXISTS toms."get_details_of_restrictions_in_proposal" (map_tile INTEGER);

CREATE OR REPLACE FUNCTION toms."get_details_of_restrictions_in_proposal" (proposal_nr INTEGER)
RETURNS TABLE("ProposalID" INTEGER, "ProposalTitle" TEXT, "Table" TEXT, "GeometryID" TEXT, "RestrictionDescription" TEXT, "RoadName" TEXT,
           "Action" TEXT, "TileNr" BIGINT) AS $$

    SELECT RiP."ProposalID", p."ProposalTitle", "RestrictionLayers"."RestrictionLayerName" As "Table", r."GeometryID", "BayLineTypes"."Description" AS "RestrictionDescription", r."RoadName",
           "ActionOnProposalAcceptanceTypes"."Description" AS "Action", m.id AS "TileNr"
    FROM toms."Proposals" p, toms."MapGrid" m,
	((toms."RestrictionsInProposals" AS RiP
	 LEFT JOIN toms."RestrictionLayers" AS "RestrictionLayers" ON RiP."RestrictionTableID" is not distinct from "RestrictionLayers"."Code")
	 LEFT JOIN "toms_lookups"."ActionOnProposalAcceptanceTypes" AS "ActionOnProposalAcceptanceTypes" ON RiP."ActionOnProposalAcceptance" is not distinct from "ActionOnProposalAcceptanceTypes"."Code"),
(toms."Bays" AS r
     LEFT JOIN "toms_lookups"."BayLineTypes" AS "BayLineTypes" ON r."RestrictionTypeID" is not distinct from "BayLineTypes"."Code")
    WHERE RiP."RestrictionID" = r."RestrictionID"
    AND ST_Intersects(r.geom, m.geom)
    AND RiP."ProposalID" = p."ProposalID"
    AND p."ProposalID" = $1

	UNION

    SELECT RiP."ProposalID", p."ProposalTitle", "RestrictionLayers"."RestrictionLayerName" As "Table", r."GeometryID", "BayLineTypes"."Description" AS "RestrictionDescription", r."RoadName",
           "ActionOnProposalAcceptanceTypes"."Description" AS "Action", m.id AS "TileNr"
    FROM toms."Proposals" p, toms."MapGrid" m,
	((toms."RestrictionsInProposals" AS RiP
	 LEFT JOIN toms."RestrictionLayers" AS "RestrictionLayers" ON RiP."RestrictionTableID" is not distinct from "RestrictionLayers"."Code")
	 LEFT JOIN "toms_lookups"."ActionOnProposalAcceptanceTypes" AS "ActionOnProposalAcceptanceTypes" ON RiP."ActionOnProposalAcceptance" is not distinct from "ActionOnProposalAcceptanceTypes"."Code"),
    (toms."Lines" AS r
     LEFT JOIN "toms_lookups"."BayLineTypes" AS "BayLineTypes" ON r."RestrictionTypeID" is not distinct from "BayLineTypes"."Code")
    WHERE RiP."RestrictionID" = r."RestrictionID"
    AND ST_Intersects(r.geom, m.geom)
    AND RiP."ProposalID" = p."ProposalID"
    AND p."ProposalID" = $1

	UNION

    SELECT RiP."ProposalID", p."ProposalTitle", "RestrictionLayers"."RestrictionLayerName" As "Table", r."GeometryID", "SignTypes"."Description" AS "RestrictionDescription", r."RoadName",
           "ActionOnProposalAcceptanceTypes"."Description" AS "Action", m.id AS "TileNr"
    FROM toms."Proposals" p, toms."MapGrid" m,
	((toms."RestrictionsInProposals" AS RiP
	 LEFT JOIN toms."RestrictionLayers" AS "RestrictionLayers" ON RiP."RestrictionTableID" is not distinct from "RestrictionLayers"."Code")
	 LEFT JOIN "toms_lookups"."ActionOnProposalAcceptanceTypes" AS "ActionOnProposalAcceptanceTypes" ON RiP."ActionOnProposalAcceptance" is not distinct from "ActionOnProposalAcceptanceTypes"."Code"),
    (toms."Signs" AS r
     LEFT JOIN "toms_lookups"."SignTypes" AS "SignTypes" ON r."SignType_1" is not distinct from "SignTypes"."Code")
    WHERE RiP."RestrictionID" = r."RestrictionID"
    AND ST_Intersects(r.geom, m.geom)
    AND RiP."ProposalID" = p."ProposalID"
    AND p."ProposalID" = $1

	UNION

    SELECT RiP."ProposalID", p."ProposalTitle", "RestrictionLayers"."RestrictionLayerName" As "Table", r."GeometryID", "RestrictionPolygonTypes"."Description" AS "RestrictionDescription", r."RoadName",
           "ActionOnProposalAcceptanceTypes"."Description" AS "Action", m.id AS "TileNr"
    FROM toms."Proposals" p, toms."MapGrid" m,
	((toms."RestrictionsInProposals" AS RiP
	 LEFT JOIN toms."RestrictionLayers" AS "RestrictionLayers" ON RiP."RestrictionTableID" is not distinct from "RestrictionLayers"."Code")
	 LEFT JOIN "toms_lookups"."ActionOnProposalAcceptanceTypes" AS "ActionOnProposalAcceptanceTypes" ON RiP."ActionOnProposalAcceptance" is not distinct from "ActionOnProposalAcceptanceTypes"."Code"),
    (toms."RestrictionPolygons" AS r
    LEFT JOIN "toms_lookups"."RestrictionPolygonTypes" AS "RestrictionPolygonTypes" ON r."RestrictionTypeID" is not distinct from "RestrictionPolygonTypes"."Code")
    WHERE RiP."RestrictionID" = r."RestrictionID"
    AND ST_Intersects(r.geom, m.geom)
    AND RiP."ProposalID" = p."ProposalID"
    AND p."ProposalID" = $1

	UNION

    SELECT RiP."ProposalID", p."ProposalTitle", "RestrictionLayers"."RestrictionLayerName" As "Table", r."GeometryID", "RestrictionPolygonTypes"."Description" AS "RestrictionDescription", '' AS "RoadName",
           "ActionOnProposalAcceptanceTypes"."Description" AS "Action", m.id AS "TileNr"
    FROM toms."Proposals" p, toms."MapGrid" m,
	((toms."RestrictionsInProposals" AS RiP
	 LEFT JOIN toms."RestrictionLayers" AS "RestrictionLayers" ON RiP."RestrictionTableID" is not distinct from "RestrictionLayers"."Code")
	 LEFT JOIN "toms_lookups"."ActionOnProposalAcceptanceTypes" AS "ActionOnProposalAcceptanceTypes" ON RiP."ActionOnProposalAcceptance" is not distinct from "ActionOnProposalAcceptanceTypes"."Code"),
    (toms."ControlledParkingZones" AS r
    LEFT JOIN "toms_lookups"."RestrictionPolygonTypes" AS "RestrictionPolygonTypes" ON r."RestrictionTypeID" is not distinct from "RestrictionPolygonTypes"."Code")
    WHERE RiP."RestrictionID" = r."RestrictionID"
    AND ST_Intersects(r.geom, m.geom)
    AND RiP."ProposalID" = p."ProposalID"
    AND p."ProposalID" = $1

	UNION

    SELECT RiP."ProposalID", p."ProposalTitle", "RestrictionLayers"."RestrictionLayerName" As "Table", r."GeometryID", "RestrictionPolygonTypes"."Description" AS "RestrictionDescription", '' AS "RoadName",
           "ActionOnProposalAcceptanceTypes"."Description" AS "Action", m.id AS "TileNr"
    FROM toms."Proposals" p, toms."MapGrid" m,
	((toms."RestrictionsInProposals" AS RiP
	 LEFT JOIN toms."RestrictionLayers" AS "RestrictionLayers" ON RiP."RestrictionTableID" is not distinct from "RestrictionLayers"."Code")
	 LEFT JOIN "toms_lookups"."ActionOnProposalAcceptanceTypes" AS "ActionOnProposalAcceptanceTypes" ON RiP."ActionOnProposalAcceptance" is not distinct from "ActionOnProposalAcceptanceTypes"."Code"),
    (toms."ParkingTariffAreas" AS r
    LEFT JOIN "toms_lookups"."RestrictionPolygonTypes" AS "RestrictionPolygonTypes" ON r."RestrictionTypeID" is not distinct from "RestrictionPolygonTypes"."Code")
    WHERE RiP."RestrictionID" = r."RestrictionID"
    AND ST_Intersects(r.geom, m.geom)
    AND RiP."ProposalID" = p."ProposalID"
    AND p."ProposalID" = $1
	ORDER BY "TileNr", "Table", "GeometryID"

$$ LANGUAGE sql;

-- Example
SELECT * FROM toms."get_details_of_restrictions_in_proposal" (299);