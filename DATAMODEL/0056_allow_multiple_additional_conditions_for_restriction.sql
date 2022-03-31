/***
 * Set up structures to allow multiple additional conditions for a restriction
 *  - use a "junction box" table  *** preferred solution but not currently implemented
 ***/

/***
DROP TABLE IF EXISTS toms."AdditionalConditionsForRestrictions";

CREATE TABLE IF NOT EXISTS toms."AdditionalConditionsForRestrictions"
(
    id SERIAL NOT NULL,
    "RestrictionID" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "AdditionalConditionID" integer NOT NULL,
    CONSTRAINT "AdditionalConditionsForRestrictions_pk" PRIMARY KEY (id),
    CONSTRAINT "AdditionalConditionsForRestrictions_uk" UNIQUE ("RestrictionID", "AdditionalConditionID"),
    CONSTRAINT "AdditionalConditionsForRestrictions_AdditionalConditionID_fkey" FOREIGN KEY ("AdditionalConditionID")
        REFERENCES toms_lookups."AdditionalConditionTypes" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE toms."AdditionalConditionsForRestrictions"
    OWNER to postgres;

GRANT DELETE, INSERT, SELECT ON TABLE toms."AdditionalConditionsForRestrictions" TO toms_admin;

GRANT ALL ON TABLE toms."AdditionalConditionsForRestrictions" TO postgres;

GRANT SELECT ON TABLE toms."AdditionalConditionsForRestrictions" TO toms_public;

GRANT DELETE, INSERT, SELECT ON TABLE toms."AdditionalConditionsForRestrictions" TO toms_operator;

-- Migrate details from all toms tables

DO
$$DECLARE
    relevant_table record;
    squery TEXT = '';
    len_squery INTEGER;
BEGIN

    FOR relevant_table IN (
          select table_schema, table_name::text, concat(table_schema, '.', quote_ident(table_name))::regclass AS full_table_name
          from information_schema.columns
          where column_name = 'AdditionalConditionID'
          AND table_schema IN ('toms')
          AND table_name != 'AdditionalConditionsForRestrictions'
        ) LOOP

		    --RAISE NOTICE 'table: % ', relevant_table.full_table_name;
			-- Stop triggers

            squery = format('INSERT INTO toms."AdditionalConditionsForRestrictions" ("RestrictionID", "AdditionalConditionID")
                            SELECT "RestrictionID", "AdditionalConditionID"
                            FROM %s
                            WHERE "AdditionalConditionID" IS NOT NULL
                            ', relevant_table.full_table_name);
            EXECUTE squery;

            squery = format('ALTER TABLE %s
                             DROP COLUMN "AdditionalConditionID" CASCADE
                            ', relevant_table.full_table_name);
            EXECUTE squery;

            -- restart triggers

	END LOOP;

END$$;
***/

/***
 * Other possible approach is to use array
 ***/

--ALTER TABLE IF EXISTS mhtc_operations."Supply"
--    ADD COLUMN "AdditionalConditionID_array" integer[];

-- Bays
DROP TRIGGER IF EXISTS z_insert_mngmt ON toms."Bays";
ALTER TABLE toms."Bays" DROP CONSTRAINT "Bays_AdditionalConditionID_fkey";

ALTER TABLE IF EXISTS toms."Bays"
    ALTER "AdditionalConditionID" DROP DEFAULT,
    ALTER "AdditionalConditionID" TYPE integer[] using array["AdditionalConditionID"],
    ALTER "AdditionalConditionID" SET DEFAULT '{}';

CREATE TRIGGER z_insert_mngmt
    BEFORE INSERT OR UPDATE OF "TimePeriodID", "MaxStayID", "NoReturnID", "MatchDayTimePeriodID", "AdditionalConditionID", "PermitCode", "geom", "label_pos"
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE FUNCTION toms.labelling_for_restrictions();

-- Lines
DROP TRIGGER IF EXISTS z_insert_mngmt ON toms."Lines";
ALTER TABLE toms."Lines" DROP CONSTRAINT "Lines_AdditionalConditionID_fkey";

ALTER TABLE IF EXISTS toms."Lines"
    ALTER "AdditionalConditionID" DROP DEFAULT,
    ALTER "AdditionalConditionID" TYPE integer[] using array["AdditionalConditionID"],
    ALTER "AdditionalConditionID" SET DEFAULT '{}';

CREATE TRIGGER z_insert_mngmt
    BEFORE INSERT OR UPDATE OF "NoWaitingTimeID", "NoLoadingTimeID", "MatchDayTimePeriodID", "AdditionalConditionID", "geom", "label_pos", "label_loading_pos"
    ON toms."Lines"
    FOR EACH ROW
    EXECUTE FUNCTION toms.labelling_for_restrictions();


-- simplify additional conditions

INSERT INTO "toms_lookups"."AdditionalConditionTypes"("Code", "Description")
SELECT 100 - 1 + row_number() OVER (PARTITION BY true::boolean) AS "Code", c."Description"
FROM (
SELECT distinct s.token AS "Description"
FROM   toms_lookups."AdditionalConditionTypes" t, regexp_split_to_table(t."Description", ';') s(token)
	) c;


--- set up InUse table

CREATE TABLE "toms_lookups"."AdditionalConditionTypesInUse" (
    "Code" integer NOT NULL
);

ALTER TABLE "toms_lookups"."AdditionalConditionTypesInUse" OWNER TO "postgres";

INSERT INTO  "toms_lookups"."AdditionalConditionTypesInUse" ("Code")
SELECT "Code"
FROM "toms_lookups"."AdditionalConditionTypes"
WHERE "Code" >= 100;

CREATE MATERIALIZED VIEW "toms_lookups"."AdditionalConditionTypesInUse_View" AS
 SELECT "AdditionalConditionTypesInUse"."Code",
    "AdditionalConditionTypes"."Description"
   FROM "toms_lookups"."AdditionalConditionTypesInUse",
    "toms_lookups"."AdditionalConditionTypes"
  WHERE ("AdditionalConditionTypesInUse"."Code" = "AdditionalConditionTypes"."Code")
  WITH NO DATA;

ALTER TABLE "toms_lookups"."AdditionalConditionTypesInUse_View" OWNER TO "postgres";

REFRESH MATERIALIZED VIEW "toms_lookups"."AdditionalConditionTypesInUse_View";



INSERT INTO "toms_lookups"."AdditionalConditionTypes" ("Code", "Description") VALUES (128, 'Except 7.00am-1.00pm');


UPDATE mhtc_operations."Supply"
SET "AdditionalConditionID" = array[122, 118, 104]
WHERE "GeometryID" IN ('S_000339', 'S_000377', 'S_000389', 'S_000387', 'S_000388');

UPDATE mhtc_operations."Supply"
SET "AdditionalConditionID" = array[122, 128, 104]
WHERE "GeometryID" IN ('S_000381');

UPDATE mhtc_operations."Supply"
SET "AdditionalConditionID" = array[122, 104, 119]
WHERE "GeometryID" IN ('S_000382', 'S_000353');

UPDATE mhtc_operations."Supply"
SET "AdditionalConditionID" = array[122, 117]
WHERE "GeometryID" IN ('S_000359');