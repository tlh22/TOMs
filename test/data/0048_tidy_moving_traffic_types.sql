/**
Tidy ...
**/


-- ** SpecialDesignations

-- CycleFacilityValues
ALTER TABLE ONLY moving_traffic_lookups."CycleFacilityValues" ALTER COLUMN "Code" SET DEFAULT nextval('moving_traffic_lookups."CycleFacilityValues_Code_seq"'::regclass);

INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (1, 'ASL - without approach or gate');
INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (2, 'ASL - with gate');
INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (3, 'ASL - with approach');
INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (4, 'Advisory Cycle Lane Along Road');
INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (5, 'Mandatory Cycle Lane Along Road');
INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (6, 'Physically Segregated Cycle Lane Along Road');
INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (7, 'Unknown Type of Cycle Route Along Road');
INSERT INTO "moving_traffic_lookups"."CycleFacilityValues" ("Code", "Description") VALUES (8, 'Signed Cycle Route');

INSERT INTO "moving_traffic_lookups"."SpecialDesignationTypes" ("Code", "Description") VALUES (1, 'Bus Lane');
INSERT INTO "moving_traffic_lookups"."SpecialDesignationTypes" ("Code", "Description") VALUES (2, 'Cycle Lane');
INSERT INTO "moving_traffic_lookups"."SpecialDesignationTypes" ("Code", "Description") VALUES (3, 'Advanced Stop Line');
INSERT INTO "moving_traffic_lookups"."SpecialDesignationTypes" ("Code", "Description") VALUES (4, 'Cycle crossing');

-- migrate to new lookups
ALTER TABLE moving_traffic."SpecialDesignations"
  ADD COLUMN "SpecialDesignationTypeID" INTEGER;

UPDATE moving_traffic."SpecialDesignations" AS s
SET "SpecialDesignationTypeID" = l."Code"
FROM moving_traffic_lookups."SpecialDesignationTypes" l
WHERE l."Description" = designation::text;

ALTER TABLE moving_traffic."SpecialDesignations"
  ADD COLUMN "CycleFacilityTypeID" INTEGER;

UPDATE moving_traffic."SpecialDesignations" AS s
SET "CycleFacilityTypeID" = l."Code"
FROM moving_traffic_lookups."CycleFacilityValues" l
WHERE l."Description" = "cycleFacility"::text;

-- Change description
UPDATE moving_traffic_lookups."SpecialDesignationTypes"
SET "Description" = 'Cycle crossing'
WHERE "Description" = 'Signal controlled cycle crossing';

-- Set up FK

ALTER TABLE moving_traffic."SpecialDesignations"
    ALTER COLUMN designation DROP NOT NULL;

ALTER TABLE ONLY moving_traffic."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_SpecialDesignationTypeID_fkey" FOREIGN KEY ("SpecialDesignationTypeID")
        REFERENCES moving_traffic_lookups."SpecialDesignationTypes"  ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE moving_traffic."SpecialDesignations"
    ALTER COLUMN "SpecialDesignationTypeID" SET NOT NULL;

ALTER TABLE ONLY moving_traffic."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_CycleFacilityTypeID_fkey" FOREIGN KEY ("CycleFacilityTypeID")
        REFERENCES moving_traffic_lookups."CycleFacilityValues"  ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

-- ** TurnRestrictions
ALTER TABLE ONLY moving_traffic_lookups."TurnRestrictionValues" ALTER COLUMN "Code" SET DEFAULT nextval('moving_traffic_lookups."TurnRestrictionValues_Code_seq"'::regclass);

INSERT INTO "moving_traffic_lookups"."TurnRestrictionValues" ("Code", "Description") VALUES (1, 'Mandatory Turn');
INSERT INTO "moving_traffic_lookups"."TurnRestrictionValues" ("Code", "Description") VALUES (2, 'No Turn');
INSERT INTO "moving_traffic_lookups"."TurnRestrictionValues" ("Code", "Description") VALUES (3, 'One Way');
INSERT INTO "moving_traffic_lookups"."TurnRestrictionValues" ("Code", "Description") VALUES (4, 'Priority to on-coming vehicles');

-- migrate to new lookup
ALTER TABLE moving_traffic."TurnRestrictions"
  ADD COLUMN "TurnRestrictionTypeID" INTEGER;

UPDATE moving_traffic."TurnRestrictions" AS s
SET "TurnRestrictionTypeID" = l."Code"
FROM moving_traffic_lookups."TurnRestrictionValues" l
WHERE l."Description" = "restrictionType"::text;

-- Set up FK

ALTER TABLE moving_traffic."TurnRestrictions"
    ALTER COLUMN "restrictionType" DROP NOT NULL;

ALTER TABLE ONLY moving_traffic."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_TurnRestrictionTypeID_fkey" FOREIGN KEY ("TurnRestrictionTypeID")
        REFERENCES moving_traffic_lookups."TurnRestrictionValues"  ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE moving_traffic."TurnRestrictions"
    ALTER COLUMN "TurnRestrictionTypeID" SET NOT NULL;

-- ** HighwayDedications
ALTER TABLE ONLY moving_traffic_lookups."DedicationValues" ALTER COLUMN "Code" SET DEFAULT nextval('moving_traffic_lookups."DedicationValues_Code_seq"'::regclass);

INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (1, 'All Vehicles');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (2, 'Bridleway');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (3, 'Byway Open To All Traffic');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (4, 'Cycle Track Or Cycle Way');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (5, 'Motorway');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (6, 'No Dedication Or Dedication Unknown');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (7, 'Pedestrian Way Or Footpath');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (8, 'Restricted Byway');
INSERT INTO "moving_traffic_lookups"."DedicationValues" ("Code", "Description") VALUES (9, 'Separated track and path for cyclists and pedestrians');

-- migrate to new lookup
ALTER TABLE moving_traffic."HighwayDedications"
  ADD COLUMN "HighwayDedicationTypeID" INTEGER;

UPDATE moving_traffic."HighwayDedications" AS s
SET "HighwayDedicationTypeID" = l."Code"
FROM moving_traffic_lookups."DedicationValues" l
WHERE l."Description" = "dedication"::text;

-- Set up FK

ALTER TABLE moving_traffic."HighwayDedications"
    ALTER COLUMN "dedication" DROP NOT NULL;

ALTER TABLE ONLY moving_traffic."HighwayDedications"
    ADD CONSTRAINT "HighwayDedications_HighwayDedicationTypeID_fkey" FOREIGN KEY ("HighwayDedicationTypeID")
        REFERENCES moving_traffic_lookups."DedicationValues"  ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE moving_traffic."HighwayDedications"
    ALTER COLUMN "HighwayDedicationTypeID" SET NOT NULL;

-- ** AccessRestrictions
ALTER TABLE ONLY moving_traffic_lookups."AccessRestrictionValues" ALTER COLUMN "Code" SET DEFAULT nextval('moving_traffic_lookups."AccessRestrictionValues_Code_seq"'::regclass);

INSERT INTO "moving_traffic_lookups"."AccessRestrictionValues" ("Code", "Description") VALUES (1, 'seasonal');
INSERT INTO "moving_traffic_lookups"."AccessRestrictionValues" ("Code", "Description") VALUES (2, 'publicAccess');
INSERT INTO "moving_traffic_lookups"."AccessRestrictionValues" ("Code", "Description") VALUES (3, 'private');
INSERT INTO "moving_traffic_lookups"."AccessRestrictionValues" ("Code", "Description") VALUES (4, 'physicallyImpossible');
INSERT INTO "moving_traffic_lookups"."AccessRestrictionValues" ("Code", "Description") VALUES (5, 'forbiddenLegally');
INSERT INTO "moving_traffic_lookups"."AccessRestrictionValues" ("Code", "Description") VALUES (6, 'toll');

-- migrate to new lookup
ALTER TABLE moving_traffic."AccessRestrictions"
  ADD COLUMN "AccessRestrictionTypeID" INTEGER;

UPDATE moving_traffic."AccessRestrictions" AS s
SET "AccessRestrictionTypeID" = l."Code"
FROM moving_traffic_lookups."AccessRestrictionValues" l
WHERE l."Description" = "restriction"::text;

-- Set up FK

ALTER TABLE moving_traffic."AccessRestrictions"
    ALTER COLUMN "restriction" DROP NOT NULL;

ALTER TABLE ONLY moving_traffic."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_AccessRestrictionTypeID_fkey" FOREIGN KEY ("AccessRestrictionTypeID")
        REFERENCES moving_traffic_lookups."AccessRestrictionValues"  ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE moving_traffic."AccessRestrictions"
    ALTER COLUMN "AccessRestrictionTypeID" SET NOT NULL;

-- ** RestrictionsForVehicles
ALTER TABLE ONLY moving_traffic_lookups."RestrictionTypeValues" ALTER COLUMN "Code" SET DEFAULT nextval('moving_traffic_lookups."RestrictionTypeValues_Code_seq"'::regclass);

INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (1, 'maximumDoubleAxleWeight');
INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (2, 'maximumHeight');
INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (3, 'maximumLength');
INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (4, 'maximumSingleAxleWeight');
INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (5, 'maximumTotalWeight');
INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (6, 'maximumTripleAxleWeight');
INSERT INTO "moving_traffic_lookups"."RestrictionTypeValues" ("Code", "Description") VALUES (7, 'maximumWidth');

ALTER TABLE ONLY moving_traffic_lookups."StructureTypeValues" ALTER COLUMN "Code" SET DEFAULT nextval('moving_traffic_lookups."StructureTypeValues_Code_seq"'::regclass);

INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (1, 'Barrier');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (2, 'Bridge Under Road');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (3, 'Bridge Over Road');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (4, 'Gate');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (5, 'Level Crossing Fully Barriered');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (6, 'Level Crossing Part Barriered');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (7, 'Level Crossing Unbarriered');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (8, 'Moveable barrier');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (9, 'Pedestrian Crossing');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (10, 'Rising Bollards');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (11, 'Street Lighting');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (12, 'Structure');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (13, 'Traffic Calming');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (14, 'Traffic Signal');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (15, 'Toll Indicator');
INSERT INTO "moving_traffic_lookups"."StructureTypeValues" ("Code", "Description") VALUES (16, 'Tunnel');

-- migrate to new lookup
ALTER TABLE moving_traffic."RestrictionsForVehicles"
  ADD COLUMN "RestrictionsForVehiclesTypeID" INTEGER;

UPDATE moving_traffic."RestrictionsForVehicles" AS s
SET "RestrictionsForVehiclesTypeID" = l."Code"
FROM moving_traffic_lookups."RestrictionTypeValues" l
WHERE l."Description" = "restrictionType"::text;

ALTER TABLE moving_traffic."RestrictionsForVehicles"
  ADD COLUMN "StructureTypeID" INTEGER;

UPDATE moving_traffic."RestrictionsForVehicles" AS s
SET "StructureTypeID" = l."Code"
FROM moving_traffic_lookups."StructureTypeValues" l
WHERE l."Description" = "structure"::text;

-- Set up FK

ALTER TABLE moving_traffic."RestrictionsForVehicles"
    ALTER COLUMN "restrictionType" DROP NOT NULL;

ALTER TABLE ONLY moving_traffic."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionsForVehicles_RestrictionsForVehiclesTypeID_fkey" FOREIGN KEY ("RestrictionsForVehiclesTypeID")
        REFERENCES moving_traffic_lookups."RestrictionTypeValues"  ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE moving_traffic."RestrictionsForVehicles"
    ALTER COLUMN "RestrictionsForVehiclesTypeID" SET NOT NULL;

ALTER TABLE ONLY moving_traffic."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionsForVehicles_StructureTypeID_fkey" FOREIGN KEY ("StructureTypeID")
        REFERENCES moving_traffic_lookups."StructureTypeValues"  ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;


** Need to ensure that Codes are explicitly set !
Need to add VehicleTypeValues

-- Add vehicleQualifiers
ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue" ADD VALUE 'Permit Holders';
ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue" ADD VALUE 'Taxis';

INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (16, 'Buses, Taxis and Pedal Cycles', '{Buses,Taxis, "Pedal Cycles"}', NULL, NULL);
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (17, 'Taxis and Permit Holders', '{Taxis, "Permit Holders"}', NULL, NULL);

ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue" ADD VALUE 'Goods Vehicles Exceeding 18.5t';
INSERT INTO "moving_traffic_lookups"."vehicleQualifiers" ("Code", "Description", "vehicle", "use", "load") VALUES (18, 'Goods Vehicles Exceeding 18.5t', '{"Goods Vehicles Exceeding 18.5t"}', NULL, NULL);

ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue" ADD VALUE 'Goods Vehicles Exceeding 5t';
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
