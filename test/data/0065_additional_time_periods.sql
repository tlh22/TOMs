-- New RBKC time periods

SELECT setval('toms_lookups."TimePeriods_Code_seq"', 644, true);

INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 8.00am-10.00am 4.00pm-6.30pm and Sat 8.00am-10.00am', 'Mon-Fri 8.00am-10.00am 4.00pm-6.30pm and Sat 8.00am-10.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 8.00am-9.30am 4.00pm-6.30pm and Sat 8.00am-9.30am', 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm and Sat 8.00am-9.30am');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm and Sun 9.00am-5.00pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm and Sun 9.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 8.00am-10.00am 4.30pm-6.30pm and Sat 8.00am-6.30pm', 'Mon-Fri 8.00am-10.00am 4.30pm-6.30pm and Sat 8.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 8.00am-10.00am 4.30pm-6.30pm and Sat 8.00am-10.00am', 'Mon-Fri 8.00am-10.00am 4.30pm-6.30pm and Sat 8.00am-10.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Sat 6.00am-10.00am 2.00pm-midnight', 'Mon-Sat 6.00am-10.00am 2.00pm-midnight');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 11.30am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 11.30am-6.30pm Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Sat 8.30am-9.30am 5.00pm-6.30pm', 'Mon-Sat 8.30am-9.30am 5.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm and 7.30pm-8.00pm and Sat 7.00am-1.30pm and 7.30pm-8.00pm', 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm and 7.30pm-8.00pm and Sat 7.00am-1.30pm and 7.30pm-8.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm and Sat 7.00am-1.30pm', 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm and Sat 7.00am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 8.30am-10.00am 4.30pm-6.30pm', 'Mon-Fri 8.30am-10.00am 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 8.30am-10.00am 4.30pm-6.30pm and Sat 8.30am-10.00am', 'Mon-Fri 8.30am-10.00am 4.30pm-6.30pm and Sat 8.30am-10.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 8.00am-9.30am 4.30pm-6.30pm and Sat 8.00am-9.30am', 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm and Sat 8.00am-9.30am');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm and Sun 1.00pm-5.00pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm and Sun 1.00pm-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 8.30am-10.00am 4.00pm-6.30pm and Sat 8.30am-10.00am', 'Mon-Fri 8.30am-10.00am 4.00pm-6.30pm and Sat 8.30am-10.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Sat 8.30am-6.30pm Sun 8.00am-4.00pm', 'Mon-Sat 8.30am-6.30pm Sun 8.00am-4.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 4.00pm-6.30pm', 'Mon-Fri 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 12.00pm-6.30pm', 'Mon-Fri 12.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Sat 8.30am-1.30pm', 'Sat 8.30am-1.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Fri 8.30am-11.30am', 'Mon-Fri 8.30am-11.30am');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Fri-Sat 7.30pm-8.00pm', 'Fri-Sat 7.30pm-8.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Description", "LabelText") VALUES ('Mon-Sat 1.00pm-6.30pm', 'Mon-Sat 1.00pm-6.30pm');

-- last sequence used is 666

-- More ...

INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (667, 'Mon-Sun 10.00am-1.00pm', 'Mon-Sun 10.00am-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (668, 'Mon-Sun 7.00pm-midnight midnight-6.00am', 'Mon-Sun 7.00pm-midnight, midnight-6.00am');

INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (669, 'Mon-Sat 8.15am-9.15am 5.00pm-6.00pm', 'Mon-Sat 8.15am-9.15am 5.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (670, 'Mon-Fri 10.00am-6.00pm', 'Mon-Fri 10.00am-6.00pm');

INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (671, 'Mon-Sat 11.00am-6.30pm', 'Mon-Sat 11.00am-6.30pm');

-- City of London
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (672, 'Mon-Fri 7.00am-7.00pm Sat 7.00am-11.00am', 'Mon-Fri 7.00am-7.00pm Sat 7.00am-11.00am');

-- Arnos Grove
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (673, 'Mon-Fri 8.15am-9.15am 11.30am-1.30pm 2.45pm-4.00pm', 'Mon-Fri 8.15am-9.15am 11.30am-1.30pm 2.45pm-4.00pm');

-- LBHF
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (674, 'Mon-Fri 8.00am-9.00am 3.00pm-4.30pm', 'Mon-Fri 8.00am-9.00am 3.00pm-4.30pm');

-- Bristol
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (675, 'Mon-Fri 7.00am-10.00am 4.00pm-6.30pm', 'Mon-Fri 7.00am-10.00am 4.00pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (676, 'Mon-Fri 10.00am-4.00pm Sat 9.00am-7.00pm', 'Mon-Fri 10.00am-4.00pm Sat 9.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (677, 'Mon-Sat 9.00am-7.00pm', 'Mon-Sat 9.00am-7.00pm');

-- Brighton
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (678, '9.00am-8.00pm', '9.00am-8.00pm');

-- Harrow
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (679, 'Mon-Fri 7.00am-7.00pm Sat 9.00am-8.00pm', 'Mon-Fri 7.00am-7.00pm Sat 9.00am-8.00pm');

-- Cambridge
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (680, 'Mon-Fri 9.00am-Noon', 'Mon-Fri 9.00am-Noon');

-- Southwark
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (681, 'Mon-Sun 11.00pm-Midnight Midnight-6.00am', 'Mon-Sun 11.00pm-Midnight Midnight-6.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (682, 'Mon-Fri 7.00am-4.00pm Sat 7.00am-6.00pm', 'Mon-Fri 7.00am-4.00pm Sat 7.00am-6.00pm');

-- Gillingham
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (683, 'Mon-Fri 8.00am-9.30am 3.00pm-4.00pm', 'Mon-Fri 8.00am-9.30am 3.00pm-4.00pm');

-- Enfield
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (684, 'Mon-Fri 8.00am-7.00pm Sat 8.00am-1.00pm', 'Mon-Fri 8.00am-7.00pm Sat 8.00am-1.00pm');

-- Southwark
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (685, 'Mon-Fri 8.00am-10.00am 3.00pm-5.00pm', 'Mon-Fri 8.00am-10.00am 3.00pm-5.00pm');

-- Hayes
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (686, 'Mon-Fri 8.00am-10.00am 2.30pm-4.30pm', 'Mon-Fri 8.00am-10.00am 2.30pm-4.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (687, 'Wed and Fri 9.00am-4.00pm', '9.00am-4.00pm;Wednesday and Friday');

INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (688, '10.00am-3.00pm 7.00pm-7.00am', '10.00am-3.00pm 7.00pm-7.00am');

-- Harringey
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (689, 'Mon-Fri 9.30am-8:30pm Sat-Sun 9.30am-8:00pm', 'Mon-Fri 9.30am-8:30pm Sat-Sun 9.30am-8.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (690, '6.00am-6.30pm', '6.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (691, 'Mon-Sat 8.00am-10.00pm Sun 1.00pm-10.00pm', 'Mon-Sat 8.00am-10:00pm Sun 1.00pm-10.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (692, 'Mon-Fri 5.00pm-8.30pm Sat-Sun Noon-8.00pm', 'Mon-Fri 5.00pm-8.30pm Sat-Sun Noon-8.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (693, 'Mon-Sat 8.00am-7.30pm', 'Mon-Sat 8.00am-7.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (694, '8.00am-9.30am 4.30pm-6.30pm', '8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (695, 'Mon-Fri 8.00am-8.30pm Sat-Sun 8.00am-8.00pm', 'Mon-Fri 8.00am-8.30pm Sat-Sun 8.00am-8.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (696, 'Mon-Fri 8.00am-8.30pm', 'Mon-Fri 8.00am-8.30pm');

-- Enfield
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (697, 'Mon-Fri 8.15.00am-9.15am 11.30am-1.30pm 2.45pm-4.00pm', 'Mon-Fri 8.15.00am-9.15am 11.30am-1.30pm 2.45pm-4.00pm');

-- Harringey
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (698, 'Mon-Fri 2.00pm-4.00pm', 'Mon-Fri 2.00pm-4.00pm');

-- Lewisham
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (699, 'Mon-Thu 8.30am-9.15am 3.15pm-4.00pm Fri 8.30am-9.15am 2.15pm-3.00pm', 'Mon-Thu 8.30am-9.15am 3.15pm-4.00pm;Fri 8.30am-9.15am 2.15pm-3.00pm');

-- Barking
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (700, 'Mon-Sun 8.30am-5.30pm', 'Mon-Sun 8.30am-5.30pm');

-- LBHF
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (701, 'Mon-Fri 8.00am-9.15am 3.00pm-5.15pm', 'Mon-Fri 8.00am-9.15am 3.00pm-5.15pm');

-- Havering
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (702, 'Mon-Fri 8.00am-9.30am 2.00pm-4.00pm', 'Mon-Fri 8.00am-9.30am 2.00pm-4.00pm');

-- Southwark
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (703, 'Sat 8.00am-7.00pm Sun 8.00am-6.00pm', 'Sat 8.00am-7.00pm Sun 8.00am-6.00pm');

-- Lewisham
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (704, 'Mon-Fri 9.00am-7.00pm', 'Mon-Fri 9.00am-7.00pm');

-- Bexley
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (705, 'Mon-Fri 1.00pm-3.00pm', 'Mon-Fri 1.00pm-3.00pm');

-- Ealing
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (706, 'Mon-Fri 9.00am-10.00am 2.00pm-3.00pm', 'Mon-Fri;9-10 am;2-3 pm');

-- Cambridge
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (707, 'Mon-Fri 9.30am-3.00pm', 'Mon-Fri 9.30am-3.00pm');

-- Southwark
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (708, '6.30pm-midnight midnight-8.00am', '6.30pm-midnight midnight-8.00am');

-- RBKC
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (709, 'midnight-12.00pm', 'midnight-12.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (710, 'Mon-Fri 8.00am-9.30am 2.30pm-5.00pm', 'Mon-Fri 8.00am-9.30am 2.30pm-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (711, 'Mon-Thu 7.00am-8.30am Fri 7.00am-6.30pm and Sat 7.00am-1.30pm', 'Mon-Thu 7.00am-8.30am Fri 7.00am-6.30pm;Sat 7.00am-1.30pm');

-- Sutton
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (712, 'Mon-Fri 8.20am-9.15am 2.45pm-3.30pm', 'Mon-Fri 8.20am-9.15am 2.45pm-3.30pm');

-- Southwark
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (713, '7.00am-10.00am', '7.00am-10.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (714, '8.00am-9.00am 4.00pm-6.30pm', '8.00am-9.00am 4.00pm-6.30pm');
--INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (715, 'Sat 8.00am-7.00pm Sun 8.00am-6.00pm', 'Sat 8.00am-7.00pm Sun 8.00am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (716, 'midnight-6.00am 8.00am-midnight', 'midnight-6.00am 8.00am-midnight');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (717, 'midnight-7.00am 11.00am-midnight', 'midnight-7.00am 11.00am-midnight');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (718, 'Mon-Sat 8.00am-10.00am 3.00pm-6.00pm', 'Mon-Sat 8.00am-10.00am 3.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (719, 'Mon-Fri 8.30am-6:30pm Sat 8.00am-5.00pm', 'Mon-Fri 8.30am-6:30pm Sat 8.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (720, 'Mon-Fri 10.00am-7.00pm', 'Mon-Fri 10.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (721, '10.00am-4.00pm 7.00pm-midnight-7.00am', '10.00am-4.00pm 7.00pm-midnight-7.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (722, 'Sat 8.00am-5.00pm', 'Sat 8.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (723, 'Sat 8.00am-7.00pm Sat 8.00am-6.00pm', 'Sat 8.00am-7.00pm Sat 8.00am-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (724, 'Mon-Fri midnight-7.00am 9.00pm-midnight Sat midnight-7.00am 1.00pm-midnight', 'Mon-Fri midnight-7.00am 9.00pm-midnight Sat midnight-7.00am 1.00pm-midnight');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (725, 'midnight-7.00am 11.00am-4.00pm 7.00pm-midnight', 'midnight-7.00am 11.00am-4.00pm 7.00pm-midnight');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (726, '6.00am-8.00am', '6.00am-8.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (727, '7.00am-9.00pm', '7.00am-9.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (728, 'midnight-7.00am 10.00am-4.00pm 7.00pm-midnight', 'midnight-7.00am 10.00am-4.00pm 7.00pm-midnight');
--INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (729, 'Mon-Fri 9.00am-7.00pm', 'Mon-Fri 9.00am-7.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (730, 'Mon-Fri 8.30am-6.30pm Sat 8.30am-1.00pm', 'Mon-Fri 8.30am-6.30pm Sat 8.30am-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (731, 'Tue-Sun 6.00am-6.30pm', 'Tue-Sun 6.00am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (732, 'Mon-Fri 10.00am-6.30pm', 'Mon-Fri 10.00am-6.30pm');
--INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (733, 'Mon-Fri 1.00pm-3.00pm', 'Mon-Fri 1.00pm-3.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (734, 'Mon-Sat 7.00am-5.00pm', 'Mon-Sat 7.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (735, 'Fri 7.00am-4.00pm Sat 8.00am-5.00pm', 'Fri 7.00am-4.00pm Sat 8.00am-5.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (736, 'Mon-Fri midnight-7.00am 9.00pm-midnight Sat midnight-7.00am 1.00pm-midnight Sun At Any Time', 'Mon-Fri midnight-7.00am 9.00pm-midnight Sat midnight-7.00am 1.00pm-midnight Sun At Any Time');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (737, 'Mon-Sat 10.00am-11.00am', 'Mon-Sat 10.00am-11.00am');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (738, 'Mon 8.30am-6.30pm', 'Mon 8.30am-6.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (739, 'Mon-Fri 8.30am-9.30am 3.00pm-6.00pm', 'Mon-Fri 8.30am-9.30am 3.00pm-6.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (740, 'Mon-Fri 8.00am-10.00am 3.00pm-6.00pm', 'Mon-Fri 8.00am-10.00am 3.00pm-6.00pm');

-- Change around the midnight times to be "midnight- ..."

UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'midnight-6.30am 10.30am-midnight' WHERE "Code" = 233;
UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'midnight-3.00am 9.00pm-midnight' WHERE "Code" = 265;
UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'midnight-6.00am 6.00pm-midnight' WHERE "Code" = 505;
UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'Mon-Fri midnight-10.30am 11.30am-midnight' WHERE "Code" = 507;
UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'midnight-7.30am 6.00pm-midnight' WHERE "Code" = 511;
UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'midnight-8.30am 6.30pm-midnight' WHERE "Code" = 512;
UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'Mon-Fri midnight-10.30am 11.30am-midnight and Sat & Sun' WHERE "Code" = 513;
UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'midnight-5.00am 9.00pm-midnight' WHERE "Code" = 516;
--UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'midnight-8.00am 6.30pm-midnight' WHERE "Code" = 526;
UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'midnight-6.00pm 10.00pm-midnight' WHERE "Code" = 636;
UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'midnight-6.00am 7.00pm-midnight' WHERE "Code" = 668;
--UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'midnight-8.00am 6.30pm-midnight' WHERE "Code" = 708;
UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'midnight-noon' WHERE "Code" = 709;

DELETE FROM "toms_lookups"."TimePeriods" WHERE "Code" = 529; -- duplicate of 507
DELETE FROM "toms_lookups"."TimePeriods" WHERE "Code" = 736; -- duplicate of 624
DELETE FROM "toms_lookups"."TimePeriods" WHERE "Code" = 723; -- error/duplicate of 715

INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (741, 'Sat 7.00am-1.00pm', 'Sat 7.00am-1.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (742, 'midnight-0.30am 8.00am-midnight', 'midnight-0.30am 8.00am-midnight');

-- Enfield
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (743, 'Mon-Sun 9.00am-8.30pm', 'Mon-Sun 9.00am-8.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (744, 'noon-9.00pm', 'noon-9.00pm');

-- Camden
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (745, 'Mon-Fri 8.30am-6.30pm Sat 8.30am-Noon', 'Mon-Fri 8.30am-6.30pm Sat 8.30am-Noon');

DELETE FROM "toms_lookups"."TimePeriods" WHERE "Code" = 556; -- duplicate of 276
UPDATE "toms_lookups"."TimePeriods" SET "Description" = 'Mon-Fri 8.30am-6.30pm Sat 7.00am-3.00pm' WHERE "Code" = 276;

-- Staithes
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (746, 'Mon-Sun 6.00am-8.00pm', 'Mon-Sun 6.00am-8.00pm');

-- Camden
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (747, 'midnight-9.00am', 'midnight-9.00am');
DELETE FROM "toms_lookups"."TimePeriods" WHERE "Code" = 483; -- duplicate of 0
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (748, 'Mon-Fri 7.30am-5.30pm', 'Mon-Fri 7.30am-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (749, 'Mon-Fri 7.30am-9.00am 3.00pm-5.30pm', 'Mon-Fri 7.30am-9.00am 3.00pm-5.30pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (750, 'Wed-Fri 8.30am-3.00pm', 'Wed-Fri 8.30am-3.00pm');
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (751, 'Mon-Tue 8.30am-6.30pm Wed-Fri 3.00pm-6.30pm Sat 8.30am-1.30pm', 'Mon-Tue 8.30am-6.30pm;Wed-Fri 3.00pm-6.30pm;Sat 8.30am-1.30pm');

-- Croydon
INSERT INTO "toms_lookups"."TimePeriods" ("Code", "Description", "LabelText") VALUES (752, 'Mon-Sat 7.00am-10.00am 3.00pm-7.00pm', 'Mon-Sat 7.00am-10.00am 3.00pm-7.00pm');
