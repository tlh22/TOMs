/***
 * With the Sunday Parking CPZ changes, any Proposals currently being prepared should reference the new versions of the CPZs and PTAs:
 ***/

 -- CPZ 1 - formerly 3 now 36. Swap over and reset TimePeriodID

UPDATE toms."RestrictionsInProposals"   -- Now close the CPZ with Sunday Parking
SET "RestrictionID" = '36'
WHERE "RestrictionID" = '3'
AND "RestrictionTableID" = 6
AND "ActionOnProposalAcceptance" = 2
AND "ProposalID" = 188;

UPDATE toms."ControlledParkingZones"
SET "TimePeriodID" = 309
WHERE "RestrictionID" = 'cf7452b2-b787-4bc6-997c-b09c7b004474';

-- CPZ 1A - formerly 4 now 37
UPDATE toms."RestrictionsInProposals"
SET "RestrictionID" = '37'
WHERE "RestrictionID" = '4'
AND "RestrictionTableID" = 6
AND "ActionOnProposalAcceptance" = 2
AND "ProposalID" = 188;

UPDATE toms."ControlledParkingZones"
SET "TimePeriodID" = 309
WHERE "RestrictionID" = '18398057-91ff-45c4-b02e-ff9f54548b36';

-- CPZ 3 - formerly 6 now 38.
-- there are two boundary changes that need to be sequenced. Original change was included with Sunday Parking. Need to separate this change.

-- Clone current CPZ with new Sunday Parking hours, correct open date and no close date
INSERT INTO toms."ControlledParkingZones"(
	zone_no, geom, "TimePeriodID", "CPZ", "OpenDate", "CloseDate", "RestrictionID", "GeometryID", "RestrictionTypeID",
	"Notes", "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged",
	"LastUpdateDateTime", "LastUpdatePerson", "LabelText", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue",
	"ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "CreateDateTime", "CreatePerson", label_pos, label_ldr, "DisplayLabel")
SELECT zone_no, geom, 309, "CPZ", '09-Nov-2020', NULL, '3_SundayParking', "GeometryID", "RestrictionTypeID",
     "Notes", "Photos_01", "Photos_02", "Photos_03", "label_X", "label_Y", "label_Rotation", "label_TextChanged",
     "LastUpdateDateTime", "LastUpdatePerson", "LabelText", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue",
     "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "CreateDateTime", "CreatePerson", label_pos, label_ldr, "DisplayLabel"
	FROM toms."ControlledParkingZones"
WHERE "GeometryID" = '6';

-- Add to RestrictionsInProposals
INSERT INTO toms."RestrictionsInProposals"(
	"ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
	VALUES (47, 6, 1, '3_SundayParking');

-- reset CPZ picked up in error - 38
UPDATE toms."ControlledParkingZones"
SET "OpenDate" = NULL
WHERE "RestrictionID" = '38';

-- Now sequence the Proposals - first TRO-19-30
UPDATE toms."RestrictionsInProposals"
SET "RestrictionID" = '3_SundayParking'
WHERE "RestrictionID" = '6'
AND "RestrictionTableID" = 6
AND "ActionOnProposalAcceptance" = 2
AND "ProposalID" = 173;

UPDATE toms."ControlledParkingZones"
SET "TimePeriodID" = 309
WHERE "RestrictionID" = '1e5ee2ba-c017-42ec-9474-f3d1557ee498';  -- This is the CPZ that is opened

-- Now make TRO-19-84 (Carnegie Court)
UPDATE toms."RestrictionsInProposals"
SET "RestrictionID" = '1e5ee2ba-c017-42ec-9474-f3d1557ee498'
WHERE "RestrictionID" = '6'
AND "RestrictionTableID" = 6
AND "ActionOnProposalAcceptance" = 2
AND "ProposalID" = 174;

UPDATE toms."ControlledParkingZones"
SET "TimePeriodID" = 309
WHERE "RestrictionID" = '38';  -- This is the CPZ that is opened

