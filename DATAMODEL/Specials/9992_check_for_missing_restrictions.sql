/****
Check for restrictions within RestrictionsInProposals but not in main tables
***/

SELECT "Table", "RestrictionID", c."ProposalID", "ProposalTitle"
FROM toms."Proposals" p,
(
SELECT 'Bays' As "Table", "RestrictionID", "ProposalID" FROM toms."RestrictionsInProposals"
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
;


SELECT * FROM toms."RestrictionsInProposals"
WHERE "RestrictionID" = '3345128a-d54a-4c1b-9f3b-8ca9f413c362';


DELETE FROM toms."RestrictionsInProposals"
WHERE "RestrictionID" IN
(
SELECT "RestrictionID" FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 2
AND "RestrictionID" NOT IN (SELECT "RestrictionID" FROM toms."Bays")
UNION
SELECT "RestrictionID" FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 3
AND "RestrictionID" NOT IN (SELECT "RestrictionID" FROM toms."Lines")
UNION
SELECT "RestrictionID" FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 4
AND "RestrictionID" NOT IN (SELECT "RestrictionID" FROM toms."RestrictionPolygons")
UNION
SELECT "RestrictionID" FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 5
AND "RestrictionID" NOT IN (SELECT "RestrictionID" FROM toms."Signs")
UNION
SELECT "RestrictionID" FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 6
AND "RestrictionID" NOT IN (SELECT "RestrictionID" FROM toms."ControlledParkingZones")
UNION
SELECT "RestrictionID" FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 7
AND "RestrictionID" NOT IN (SELECT "RestrictionID" FROM toms."ParkingTariffAreas")
)