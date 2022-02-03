/***
 * Set up structures to allow multiple additional conditions for a restriction
 *  - use a "junction box" table
 ***/

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

