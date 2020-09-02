-- ** Tidy

-- remove any entries in RestrictionsInProposals that are not in main tables
DELETE
FROM toms."RestrictionsInProposals" r
WHERE "RestrictionTableID" = 2
AND r."RestrictionID" NOT IN (
SELECT "RestrictionID"
FROM toms."Bays"
);

DELETE
FROM toms."RestrictionsInProposals" r
WHERE "RestrictionTableID" = 3
AND r."RestrictionID" NOT IN (
SELECT "RestrictionID"
FROM toms."Lines"
);

-- remove any entries in main tables that are not in RestrictionsInProposals
DELETE
FROM toms."Bays" r
WHERE "RestrictionID" NOT IN (
SELECT "RestrictionID"
FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 2
)
AND "OpenDate" IS NULL;

DELETE
FROM toms."Lines" r
WHERE "RestrictionID" NOT IN (
SELECT "RestrictionID"
FROM toms."RestrictionsInProposals"
WHERE "RestrictionTableID" = 3
)
AND "OpenDate" IS NULL;

-- ** Add constraint to reduce issues in future - check entry in "RestrictionsInProposals" exists in main tables

CREATE OR REPLACE FUNCTION check_restriction_exists_in_main_tables(restriction_id text) RETURNS bool AS
$func$
SELECT EXISTS (
        SELECT 1 FROM toms."Bays"
        WHERE "RestrictionID" = $1
        UNION
        SELECT 1 FROM toms."Lines"
        WHERE "RestrictionID" = $1
        UNION
        SELECT 1 FROM toms."Signs"
        WHERE "RestrictionID" = $1
        UNION
        SELECT 1 FROM toms."RestrictionPolygons"
        WHERE "RestrictionID" = $1
        UNION
        SELECT 1 FROM toms."ControlledParkingZones"
        WHERE "RestrictionID" = $1
        UNION
        SELECT 1 FROM toms."ParkingTariffAreas"
        WHERE "RestrictionID" = $1
        );
$func$ language sql stable;

ALTER TABLE toms."RestrictionsInProposals" ADD CONSTRAINT "RestrictionsInProposals_restriction_exists_check"
CHECK (check_restriction_exists_in_main_tables("RestrictionID"));

-- check entry in main tables exists within "RestrictionsInProposals"

CREATE OR REPLACE FUNCTION "check_restriction_exists_in_RestrictionsInProposals"()
RETURNS trigger AS
$BODY$
DECLARE
	 restrictionTableCode int;
     restrictionExists int = 0;
BEGIN

    SELECT "Code"
    FROM "toms"."RestrictionLayers"
	WHERE "RestrictionLayerName" = toms.quote_ident(TG_TABLE_NAME::regclass::text)
    INTO restrictionTableCode;

    SELECT 1 FROM "toms"."RestrictionsInProposals"
    WHERE "RestrictionID" = NEW."RestrictionID"
    AND "RestrictionTableID" = restrictionTableCode
    INTO restrictionExists;

    IF restrictionExists = 1 THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Restriction does not exist in RestrictionsInProposals';
        RETURN NULL;
    END IF;

END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER "check_Bay_exists_in_RestrictionsInProposals" BEFORE INSERT OR UPDATE ON toms."Bays"
FOR EACH ROW EXECUTE PROCEDURE "check_restriction_exists_in_RestrictionsInProposals"();

CREATE TRIGGER "check_Line_exists_in_RestrictionsInProposals" BEFORE INSERT OR UPDATE ON toms."Lines"
FOR EACH ROW EXECUTE PROCEDURE "check_restriction_exists_in_RestrictionsInProposals"();

CREATE TRIGGER "check_Sign_exists_in_RestrictionsInProposals" BEFORE INSERT OR UPDATE ON toms."Signs"
FOR EACH ROW EXECUTE PROCEDURE "check_restriction_exists_in_RestrictionsInProposals"();

CREATE TRIGGER "check_RestrictionPolygon_exists_in_RestrictionsInProposals" BEFORE INSERT OR UPDATE ON toms."RestrictionPolygons"
FOR EACH ROW EXECUTE PROCEDURE "check_restriction_exists_in_RestrictionsInProposals"();

CREATE TRIGGER "check_ControlledParkingZone_exists_in_RestrictionsInProposals" BEFORE INSERT OR UPDATE ON toms."ControlledParkingZones"
FOR EACH ROW EXECUTE PROCEDURE "check_restriction_exists_in_RestrictionsInProposals"();

CREATE TRIGGER "check_ParkingTariffArea_exists_in_RestrictionsInProposals" BEFORE INSERT OR UPDATE ON toms."ParkingTariffAreas"
FOR EACH ROW EXECUTE PROCEDURE "check_restriction_exists_in_RestrictionsInProposals"();

-- Remove any 0 length features (ensuring that they are removed from main table and RestrictionsInProposals)
DELETE FROM toms."RestrictionsInProposals" r
WHERE r."RestrictionID" IN (
SELECT l."RestrictionID"
FROM toms."Bays" l
WHERE l."RestrictionLength" = 0
--AND l."OpenDate" IS NULL
);

DELETE
FROM toms."Bays" l
WHERE l."RestrictionLength" = 0
-- AND l."OpenDate" IS NULL
;

DELETE FROM toms."RestrictionsInProposals" r
WHERE r."RestrictionID" IN (
SELECT l."RestrictionID"
FROM toms."Lines" l
WHERE l."RestrictionLength" = 0
--AND l."OpenDate" IS NULL
);

DELETE
FROM toms."Lines" l
WHERE l."RestrictionLength" = 0
-- AND l."OpenDate" IS NULL
;
