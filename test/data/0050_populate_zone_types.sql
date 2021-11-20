/**
Use same codes as RestrictionPolygonTypes
**/

INSERT INTO "toms_lookups"."ZoneTypes" ("Code", "Description") VALUES (20, 'Controlled Parking Zone');
INSERT INTO "toms_lookups"."ZoneTypes" ("Code", "Description") VALUES (7, 'Lorry waiting restriction zone');
INSERT INTO "toms_lookups"."ZoneTypes" ("Code", "Description") VALUES (8, 'Half-on/Half-off prohbited zone');
INSERT INTO "toms_lookups"."ZoneTypes" ("Code", "Description") VALUES (22, 'Parking Tariff Area');
INSERT INTO "toms_lookups"."ZoneTypes" ("Code", "Description") VALUES (21, 'Priority Parking Area');

INSERT INTO "toms_lookups"."ZoneTypes" ("Code", "Description") VALUES (23, 'Congestion Charging Zone');
INSERT INTO "toms_lookups"."ZoneTypes" ("Code", "Description") VALUES (24, 'Ultra Low Emissions Zone');
INSERT INTO "toms_lookups"."ZoneTypes" ("Code", "Description") VALUES (10, 'Restricted Zone');

INSERT INTO "toms_lookups"."ZoneTypes" ("Code", "Description") VALUES (32, 'Match Day/Event Day Zone');

-- Set next sequence value for ZoneTypesID
SELECT setval('toms_lookups."ZoneTypes_id_seq"', 33, true);

-- Add to "InUse"

INSERT INTO toms_lookups."ZoneTypesInUse" ("Code","GeomShapeGroupType") VALUES(20, 'Polygon');   -- CPZ
INSERT INTO toms_lookups."ZoneTypesInUse" ("Code","GeomShapeGroupType") VALUES(22, 'Polygon');   -- PTA
INSERT INTO toms_lookups."ZoneTypesInUse" ("Code","GeomShapeGroupType") VALUES(32, 'Polygon');   -- Match Day zone