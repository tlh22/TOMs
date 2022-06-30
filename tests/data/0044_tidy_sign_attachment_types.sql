/**
Tidy ...
**/

DELETE FROM "compliance_lookups"."SignAttachmentTypes"
WHERE "Code" = 9; -- Large Pole

INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (10, 'Building');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (11, 'Bollard');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (12, 'Illuminated Traffic Sign');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (13, 'Bus Stop sign');
INSERT INTO "compliance_lookups"."SignAttachmentTypes" ("Code", "Description") VALUES (14, 'Motorcycle stand');

UPDATE "compliance_lookups"."SignAttachmentTypes"
SET "Description" = 'Short Pole(s)'
WHERE "Code" = 1;

UPDATE "compliance_lookups"."SignAttachmentTypes"
SET "Description" = 'Normal Pole(s)'
WHERE "Code" = 2;

UPDATE "compliance_lookups"."SignAttachmentTypes"
SET "Description" = 'Tall Pole(s)'
WHERE "Code" = 3;

UPDATE "compliance_lookups"."SignAttachmentTypes"
SET "Description" = 'Lamp post'
WHERE "Code" = 4;

UPDATE "compliance_lookups"."SignAttachmentTypes"
SET "Description" = 'Fence'
WHERE "Code" = 6;