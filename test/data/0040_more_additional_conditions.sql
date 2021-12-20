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

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (13, 'Except 7.00am-4.00pm;Loading max 20 min;Disabled max 3 hours');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (14, 'Except 7.00am-4.00pm');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (15, 'Except 10.00am-7.00pm');

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (16, 'Resident Doctor and permit holders only');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (17, 'except Ambulances');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (18, 'except permit holders');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (19, 'except for access');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (20, 'except for loading');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (21, 'except ambulances');

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (22, 'Loading max 20 min');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (23, 'Disabled max 3 hours');

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (24, 'Loading max 20 min;Disabled max 3 hours');

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (25, 'No Stopping Mon-Sat 7.00am-7.00pm;Except 10.00am-4.00pm;Loading max 20 min');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (26, 'No Stopping Mon-Sat 7.00am-7.00pm;Except 1.00pm-4.00pm;Loading max 20 min');

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (27, 'except disabled');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (28, 'except e-taxis');
INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (29, 'No Stopping Mon-Sat 7.00am-7.00pm;Except 10.00am-7.00pm;Loading max 20 min');

INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (30, 'on event days');
