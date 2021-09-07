/***
Add these as well

**/

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (5, 'Suspended on Match Days');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (6, 'Bus parking on Match Days only');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (7, 'except Match Days');

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (8, 'except taxis');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (9, 'vehicles > 3 tonnes');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (10, 'except vehicles over 55ft (17m) long and/or 9''-6" (2.9m) wide');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (11, 'school term time only');

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (12, 'Community Hall vehicles only');

SELECT pg_catalog.setval('"toms_lookups"."AdditionalConditionTypes_Code_seq"', 1, false);