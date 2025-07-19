/***

New details added during Southwark audit survey

***/

-- SignFadedTypes

INSERT INTO compliance_lookups."SignFadedTypes"("Code", "Description") VALUES (9, 'Misaligned');

-- Restriction_SignIssueTypes

INSERT INTO compliance_lookups."Restriction_SignIssueTypes"("Code", "Description") VALUES (5, 'Corrected in field');
INSERT INTO compliance_lookups."Restriction_SignIssueTypes"("Code", "Description") VALUES (6, 'Redundant sign');

-- remove redundant sign types

UPDATE toms."Signs" 
SET "SignType_1"=41
WHERE "SignType_1" = 36;

UPDATE toms."Signs" 
SET "SignType_2"=41
WHERE "SignType_2" = 36;

UPDATE toms."Signs" 
SET "SignType_3"=41
WHERE "SignType_3" = 36;

UPDATE toms."Signs" 
SET "SignType_4"=41
WHERE "SignType_4" = 36;

UPDATE toms_lookups."SignTypesInUse" 
SET "Code"=41
WHERE "Code" = 36;
	
DELETE FROM toms_lookups."SignTypes" WHERE "Code" = 36;

-- Additional conditions

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (32, 'except local buses');
