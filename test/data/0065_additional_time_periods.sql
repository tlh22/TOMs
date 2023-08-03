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
