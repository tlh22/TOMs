--
INSERT INTO "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ("Code", "Description") VALUES (1, 'No issue');
INSERT INTO "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ("Code", "Description") VALUES (6, 'Other (please specify in notes)');
INSERT INTO "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ("Code", "Description") VALUES (2, 'Slightly faded marking');
INSERT INTO "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ("Code", "Description") VALUES (3, 'Very faded markings');
INSERT INTO "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ("Code", "Description") VALUES (4, 'Markings not correctly removed');
INSERT INTO "compliance_lookups"."RestrictionRoadMarkingsFadedTypes" ("Code", "Description") VALUES (5, 'Missing markings');

-- Add bay types
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (131, 'Polygon', NULL);  # Permit holder
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (133, 'Polygon', NULL);  # shared use Permit holder
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (134, 'Polygon', NULL);  # shared use Permit holder
INSERT INTO "toms_lookups"."BayTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (135, 'Polygon', NULL);  # shared use Permit holder

-- Add line types
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (224, 'LineString', NULL);  # SYL
INSERT INTO "toms_lookups"."LineTypesInUse" ("Code", "GeomShapeGroupType", "StyleDetails") VALUES (225, 'LineString', NULL);  # Unmarked

-- Add some sign types
INSERT INTO "toms_lookups"."SignTypesInUse" ("Code") VALUES (34);  # Pole, no sign

-- refresh views
REFRESH MATERIALIZED VIEW "toms_lookups"."BayTypesInUse_View";
REFRESH MATERIALIZED VIEW "toms_lookups"."LineTypesInUse_View";
REFRESH MATERIALIZED VIEW "toms_lookups"."RestrictionPolygonTypesInUse_View";
REFRESH MATERIALIZED VIEW "toms_lookups"."SignTypesInUse_View";
REFRESH MATERIALIZED VIEW "toms_lookups"."TimePeriodsInUse_View";

This is a test



