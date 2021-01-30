ALTER TABLE toms."Bays" DISABLE TRIGGER all;
ALTER TABLE toms."Lines" DISABLE TRIGGER all;

-- *** AdditionalConditionTypes

--INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (5, 'Suspended on Match Days');
--INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (6, 'Bus parking on Match Days only');
--INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (7, 'except Match Days');

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (8, 'except taxis');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (9, 'vehicles > 3 tonnes');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (10, 'except vehicles over 55ft (17m) long and/or 9''-6" (2.9m) wide');

-- Bays
UPDATE toms."Bays"
SET "AdditionalConditionID" = 8
WHERE "AdditionalConditionID" = 1;

UPDATE toms."Bays"
SET "AdditionalConditionID" = 9
WHERE "AdditionalConditionID" = 2;

UPDATE toms."Bays"
SET "AdditionalConditionID" = 10
WHERE "AdditionalConditionID" = 3;

-- Lines
UPDATE toms."Lines"
SET "AdditionalConditionID" = 8
WHERE "AdditionalConditionID" = 1;

UPDATE toms."Lines"
SET "AdditionalConditionID" = 9
WHERE "AdditionalConditionID" = 2;

UPDATE toms."Lines"
SET "AdditionalConditionID" = 10
WHERE "AdditionalConditionID" = 3;

-- Tidy geomshape details for Bays

UPDATE toms."Bays"
SET "GeomShapeID" = "GeomShapeID" + 20
WHERE "RestrictionTypeID" IN (131, 133, 134, 145)
AND "GeomShapeID" < 20;

ALTER TABLE toms."Bays" ENABLE TRIGGER all;
ALTER TABLE toms."Lines" ENABLE TRIGGER all;