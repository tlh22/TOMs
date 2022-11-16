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


