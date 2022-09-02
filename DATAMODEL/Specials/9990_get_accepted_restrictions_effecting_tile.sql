/***
 * Get all restrictions within a Proposal
 ***/

DROP FUNCTION IF EXISTS toms."get_details_of_restrictions_in_proposal" (map_tile INTEGER);

CREATE OR REPLACE FUNCTION toms."get_details_of_restrictions_in_proposal" (proposal_nr INTEGER)
SELECT "Table", "RestrictionID", c."ProposalID", "ProposalTitle"
FROM toms."Proposals" p,
(
SELECT 'Bays' As "Table", "RestrictionID","GeometryID", ""ProposalID" FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 2
AND "RestrictionID" NOT IN (SELECT "RestrictionID" FROM toms."Bays")
UNION
SELECT 'Lines' As "Table", "RestrictionID", "ProposalID" FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 3
AND "RestrictionID" NOT IN (SELECT "RestrictionID" FROM toms."Lines")
UNION
SELECT 'RestrictionPolygons' As "Table", "RestrictionID", "ProposalID" FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 4
AND "RestrictionID" NOT IN (SELECT "RestrictionID" FROM toms."RestrictionPolygons")
UNION
SELECT 'Signs' As "Table", "RestrictionID", "ProposalID" FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 5
AND "RestrictionID" NOT IN (SELECT "RestrictionID" FROM toms."Signs")
UNION
SELECT 'ControlledParkingZones' As "Table", "RestrictionID", "ProposalID" FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 6
AND "RestrictionID" NOT IN (SELECT "RestrictionID" FROM toms."ControlledParkingZones")
UNION
SELECT 'ParkingTariffAreas' As "Table", "RestrictionID", "ProposalID" FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 7
AND "RestrictionID" NOT IN (SELECT "RestrictionID" FROM toms."ParkingTariffAreas")
) AS c
WHERE c."ProposalID" = p."ProposalID"
--AND p."ProposalStatusID" = 2


SELECT "GeometryID",
"BayLineTypes"."Description" AS "RestrictionDescription", "CPZ", COALESCE("TimePeriods"."Description", '') AS "TimePeriod",
COALESCE("LengthOfTime1"."Description", '') AS "MaxStay", COALESCE("LengthOfTime2"."Description", '') AS "NoReturnTime", '' AS "NoWaitingTime", '' AS "NoLoadingTime",
COALESCE("AdditionalConditionTypes"."Description", '') AS "AdditionalCondition", "OpenDate", "CloseDate", m.id AS "TileNr" --, COUNT("BayLineTypes"."Description")

FROM
     (((((((toms."Bays" AS a
     LEFT JOIN toms."RestrictionsInProposals" AS RiP ON a."RestrictionID" = RiP."RestrictionID")
     LEFT JOIN "toms_lookups"."BayLineTypes" AS "BayLineTypes" ON a."RestrictionTypeID" is not distinct from "BayLineTypes"."Code")
     LEFT JOIN "toms_lookups"."TimePeriods" AS "TimePeriods" ON a."TimePeriodID" is not distinct from "TimePeriods"."Code")
     LEFT JOIN "toms_lookups"."LengthOfTime" AS "LengthOfTime1" ON a."MaxStayID" is not distinct from "LengthOfTime1"."Code")
     LEFT JOIN "toms_lookups"."LengthOfTime" AS "LengthOfTime2" ON a."NoReturnID" is not distinct from "LengthOfTime2"."Code")
     LEFT JOIN "toms_lookups"."AdditionalConditionTypes" AS "AdditionalConditionTypes" ON a."AdditionalConditionID" is not distinct from "AdditionalConditionTypes"."Code")
), toms."MapGrid" m
WHERE RiP."ProposalID" IN (79)
AND ST_Intersects(a.geom, m.geom)
--GROUP BY "RestrictionDescription", "CPZ", "TimePeriod", "MaxStay", "NoReturnTime", "AdditionalCondition"

UNION

SELECT "GeometryID",
"BayLineTypes"."Description" AS "RestrictionDescription", "CPZ", '' AS "TimePeriod", '' AS "MaxStay", '' AS "NoReturnTime",
 COALESCE("TimePeriods1"."Description", '') AS "NoWaitingTime",
 COALESCE("TimePeriods2"."Description", '') AS "NoLoadingTime",
COALESCE("AdditionalConditionTypes"."Description", '') AS "AdditionalCondition", "OpenDate", "CloseDate", m.id AS "TileNr" --, COUNT("BayLineTypes"."Description")

FROM
     ((((((toms."Lines" AS a
     LEFT JOIN toms."RestrictionsInProposals" AS RiP ON a."RestrictionID" = RiP."RestrictionID")
     LEFT JOIN "toms_lookups"."BayLineTypes" AS "BayLineTypes" ON a."RestrictionTypeID" is not distinct from "BayLineTypes"."Code")
     LEFT JOIN "toms_lookups"."TimePeriods" AS "TimePeriods1" ON a."NoWaitingTimeID" is not distinct from "TimePeriods1"."Code")
     LEFT JOIN "toms_lookups"."TimePeriods" AS "TimePeriods2" ON a."NoLoadingTimeID" is not distinct from "TimePeriods2"."Code")
     LEFT JOIN "toms_lookups"."AdditionalConditionTypes" AS "AdditionalConditionTypes" ON a."AdditionalConditionID" is not distinct from "AdditionalConditionTypes"."Code")
), toms."MapGrid" m
WHERE RiP."ProposalID" IN (79)
AND ST_Intersects(a.geom, m.geom)
--GROUP BY "RestrictionDescription", "CPZ", "NoWaitingTime", "NoLoadingTime", "AdditionalCondition"
;

-- Example
SELECT * FROM toms."get_details_of_restrictions_in_proposal" (299);