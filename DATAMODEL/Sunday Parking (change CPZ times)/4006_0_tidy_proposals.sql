/***
 * With the Sunday Parking CPZ changes, any Proposals currently being prepared should reference the new versions of the CPZs:
 ***/

 -- CPZ 1 - formerly 3 now 36

UPDATE toms."RestrictionsInProposals"
SET "RestrictionID" = '36'
WHERE "RestrictionID" = '3'
AND "RestrictionTableID" = 6
AND "ProposalID" = 188;

-- CPZ 1A - formerly 4 now 37
UPDATE toms."RestrictionsInProposals"
SET "RestrictionID" = '37'
WHERE "RestrictionID" = '4'
AND "RestrictionTableID" = 6
AND "ProposalID" = 188;

-- CPZ 3 - formerly 6 now 38
UPDATE toms."RestrictionsInProposals"
SET "RestrictionID" = '38'
WHERE "RestrictionID" = '6'
AND "RestrictionTableID" = 6
AND "ProposalID" = 173;

UPDATE toms."RestrictionsInProposals"
SET "RestrictionID" = '38'
WHERE "RestrictionID" = '6'
AND "RestrictionTableID" = 6
AND "ProposalID" = 174;
