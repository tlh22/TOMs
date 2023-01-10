/**
Tidy ...
**/

INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (16, 'Buses, Taxis and Pedal Cycles', '{Buses,Taxis, "Pedal Cycles"}', NULL, NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (17, 'Taxis and Permit Holders', '{Taxis, "Permit Holders"}', NULL, NULL);

INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (18, 'Goods Vehicles Exceeding 18.5t', '{"Goods Vehicles Exceeding 18.5t"}', NULL, NULL);

INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (19, 'Goods Vehicles Exceeding 5t', '{"Goods Vehicles Exceeding 5t"}', NULL, NULL);

-- Modify T to t

ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue"  RENAME VALUE 'Goods Vehicles Exceeding 7.5T' TO 'Goods Vehicles Exceeding 7.5t';
UPDATE "moving_traffic_lookups"."vehicleQualifiers"
SET "Description" = 'Goods Vehicles Exceeding 7.5t'
WHERE "Code" = 1;

ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue"  RENAME VALUE 'Goods Vehicles Exceeding 16.5T' TO 'Goods Vehicles Exceeding 16.5t';
UPDATE "moving_traffic_lookups"."vehicleQualifiers"
SET "Description" = 'Goods Vehicles Exceeding 16.5t'
WHERE "Code" = 5;

ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue"  RENAME VALUE 'Goods Vehicles Exceeding 18T' TO 'Goods Vehicles Exceeding 18t';
UPDATE "moving_traffic_lookups"."vehicleQualifiers"
SET "Description" = 'Goods Vehicles Exceeding 18t'
WHERE "Code" = 6;

ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue"  RENAME VALUE 'Goods Vehicles Exceeding 3T' TO 'Goods Vehicles Exceeding 3t';
UPDATE "moving_traffic_lookups"."vehicleQualifiers"
SET "Description" = 'Goods Vehicles Exceeding 3t'
WHERE "Code" = 11;
