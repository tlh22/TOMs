/**
Tidy ...
**/


-- ** SpecialDesignations

-- CycleFacilityValues
ALTER TABLE ONLY moving_traffic_lookups."CycleFacilityValues" ALTER COLUMN "Code" SET DEFAULT nextval('moving_traffic_lookups."CycleFacilityValues_Code_seq"'::regclass);

INSERT INTO moving_traffic_lookups."CycleFacilityValues" ("Description")
VALUES('ASL - without approach or gate');
INSERT INTO moving_traffic_lookups."CycleFacilityValues" ("Description")
VALUES('ASL - with gate');
INSERT INTO moving_traffic_lookups."CycleFacilityValues" ("Description")
VALUES('ASL - with approach');
INSERT INTO moving_traffic_lookups."CycleFacilityValues" ("Description")
VALUES('Advisory Cycle Lane Along Road');
INSERT INTO moving_traffic_lookups."CycleFacilityValues" ("Description")
VALUES('Mandatory Cycle Lane Along Road');
INSERT INTO moving_traffic_lookups."CycleFacilityValues" ("Description")
VALUES('Physically Segregated Cycle Lane Along Road');
INSERT INTO moving_traffic_lookups."CycleFacilityValues" ("Description")
VALUES('Unknown Type of Cycle Route Along Road');
INSERT INTO moving_traffic_lookups."CycleFacilityValues" ("Description")
VALUES('Signed Cycle Route');

INSERT INTO moving_traffic_lookups."SpecialDesignationTypes" ("Description")
VALUES('Bus Lane');
INSERT INTO moving_traffic_lookups."SpecialDesignationTypes" ("Description")
VALUES('Cycle Lane');
INSERT INTO moving_traffic_lookups."SpecialDesignationTypes" ("Description")
VALUES('Advanced Stop Line');
INSERT INTO moving_traffic_lookups."SpecialDesignationTypes" ("Description")
VALUES('Signal controlled cycle crossing');

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

INSERT INTO moving_traffic_lookups."TurnRestrictionValues" ("Description")
VALUES('Mandatory Turn');
INSERT INTO moving_traffic_lookups."TurnRestrictionValues" ("Description")
VALUES('No Turn');
INSERT INTO moving_traffic_lookups."TurnRestrictionValues" ("Description")
VALUES('One Way');
INSERT INTO moving_traffic_lookups."TurnRestrictionValues" ("Description")
VALUES('Priority to on-coming vehicles');

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

INSERT INTO moving_traffic_lookups."DedicationValues" ("Description")
VALUES('All Vehicles');
INSERT INTO moving_traffic_lookups."DedicationValues" ("Description")
VALUES('Bridleway');
INSERT INTO moving_traffic_lookups."DedicationValues" ("Description")
VALUES('Byway Open To All Traffic');
INSERT INTO moving_traffic_lookups."DedicationValues" ("Description")
VALUES('Cycle Track Or Cycle Way');
INSERT INTO moving_traffic_lookups."DedicationValues" ("Description")
VALUES('Motorway');
INSERT INTO moving_traffic_lookups."DedicationValues" ("Description")
VALUES('No Dedication Or Dedication Unknown');
INSERT INTO moving_traffic_lookups."DedicationValues" ("Description")
VALUES('Pedestrian Way Or Footpath');
INSERT INTO moving_traffic_lookups."DedicationValues" ("Description")
VALUES('Restricted Byway');
INSERT INTO moving_traffic_lookups."DedicationValues" ("Description")
VALUES('Separated track and path for cyclists and pedestrians');

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

INSERT INTO moving_traffic_lookups."AccessRestrictionValues" ("Description")
VALUES('seasonal');
INSERT INTO moving_traffic_lookups."AccessRestrictionValues" ("Description")
VALUES('publicAccess');
INSERT INTO moving_traffic_lookups."AccessRestrictionValues" ("Description")
VALUES('private');
INSERT INTO moving_traffic_lookups."AccessRestrictionValues" ("Description")
VALUES('physicallyImpossible');
INSERT INTO moving_traffic_lookups."AccessRestrictionValues" ("Description")
VALUES('forbiddenLegally');
INSERT INTO moving_traffic_lookups."AccessRestrictionValues" ("Description")
VALUES('toll');

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

ALTER TABLE moving_traffic."RestrictionsForVehicles"
    ALTER COLUMN "AccessRestrictionTypeID" SET NOT NULL;

-- ** RestrictionsForVehicles
ALTER TABLE ONLY moving_traffic_lookups."RestrictionTypeValues" ALTER COLUMN "Code" SET DEFAULT nextval('moving_traffic_lookups."RestrictionTypeValues_Code_seq"'::regclass);

INSERT INTO moving_traffic_lookups."RestrictionTypeValues" ("Description")
VALUES('maximumDoubleAxleWeight');
INSERT INTO moving_traffic_lookups."RestrictionTypeValues" ("Description")
VALUES('maximumHeight');
INSERT INTO moving_traffic_lookups."RestrictionTypeValues" ("Description")
VALUES('maximumLength');
INSERT INTO moving_traffic_lookups."RestrictionTypeValues" ("Description")
VALUES('maximumSingleAxleWeight');
INSERT INTO moving_traffic_lookups."RestrictionTypeValues" ("Description")
VALUES('maximumTotalWeight');
INSERT INTO moving_traffic_lookups."RestrictionTypeValues" ("Description")
VALUES('maximumTripleAxleWeight');
INSERT INTO moving_traffic_lookups."RestrictionTypeValues" ("Description")
VALUES('maximumWidth');

ALTER TABLE ONLY moving_traffic_lookups."StructureTypeValues" ALTER COLUMN "Code" SET DEFAULT nextval('moving_traffic_lookups."StructureTypeValues_Code_seq"'::regclass);

INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Barrier');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Bridge Under Road');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Bridge Over Road');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Gate');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Level Crossing Fully Barriered');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Level Crossing Part Barriered');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Level Crossing Unbarriered');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Moveable barrier');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Pedestrian Crossing');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Rising Bollards');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Street Lighting');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Structure');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Traffic Calming');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Traffic Signal');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Toll Indicator');
INSERT INTO moving_traffic_lookups."StructureTypeValues" ("Description")
VALUES('Tunnel');

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