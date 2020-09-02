-- ** Tidy

-- remove any entries in RestrictionsInProposals that are not in main tables
DELETE
FROM toms."RestrictionsInProposals" r
WHERE "RestrictionTableID" = 2
AND r."RestrictionID" NOT IN (
SELECT "RestrictionID"
FROM toms."Bays"
);

DELETE
FROM toms."RestrictionsInProposals" r
WHERE "RestrictionTableID" = 3
AND r."RestrictionID" NOT IN (
SELECT "RestrictionID"
FROM toms."Lines"
);

-- remove any entries in main tables that are not in RestrictionsInProposals
DELETE
FROM toms."Bays" r
WHERE "RestrictionID" NOT IN (
SELECT "RestrictionID"
FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 2
)
AND "OpenDate" IS NULL;

DELETE
FROM toms."Lines" r
WHERE "RestrictionID" NOT IN (
SELECT "RestrictionID"
FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 3
)
AND "OpenDate" IS NULL;

-- Remove any 0 length features (ensuring that they are removed from main table and RestrictionsInProposals)
DELETE FROM toms."RestrictionsInProposals" r
WHERE r."RestrictionID" IN (
SELECT l."RestrictionID"
FROM toms."Bays" l
WHERE l."RestrictionLength" = 0
--AND l."OpenDate" IS NULL
);

DELETE
FROM toms."Bays" l
WHERE l."RestrictionLength" = 0
-- AND l."OpenDate" IS NULL
;

DELETE FROM toms."RestrictionsInProposals" r
WHERE r."RestrictionID" IN (
SELECT l."RestrictionID"
FROM toms."Lines" l
WHERE l."RestrictionLength" = 0
--AND l."OpenDate" IS NULL
);

DELETE
FROM toms."Lines" l
WHERE l."RestrictionLength" = 0
-- AND l."OpenDate" IS NULL
;
