/***
 * Change AdditionalConditionID field to be an array
 ***/

DO
$$DECLARE
    relevant_table record;
    squery TEXT = '';
    fkey_name TEXT = '';
    len_squery INTEGER;
BEGIN

    FOR relevant_table IN (
          select table_schema, table_name, concat(table_schema, '.', quote_ident(table_name))::regclass AS full_table_name
          from information_schema.columns
          where column_name = 'AdditionalConditionID'
          AND table_schema IN ('toms')
        ) LOOP

		    RAISE NOTICE 'table: % ', relevant_table.full_table_name;
			-- Stop triggers
            squery = format('ALTER TABLE %s DISABLE TRIGGER ALL
                     ', relevant_table.full_table_name);
            EXECUTE squery;

            -- change label trigger
            squery = format('DROP TRIGGER IF EXISTS z_insert_mngmt ON %s
                     ', relevant_table.full_table_name);
            RAISE NOTICE 'query: % ', squery;
            EXECUTE squery;

            fkey_name = format('%s_AdditionalConditionID_fkey', relevant_table.table_name);
            -- drop current constraint
            squery = format('ALTER TABLE %s DROP CONSTRAINT IF EXISTS quote_ident(%s)
                     ', relevant_table.full_table_name, fkey_name);
            EXECUTE squery;

            squery = format('ALTER TABLE %s
                             ALTER "AdditionalConditionID" DROP DEFAULT,
                             ALTER "AdditionalConditionID" TYPE INTEGER[] USING array["AdditionalConditionID"]::INTEGER[],
                             ALTER "AdditionalConditionID" SET DEFAULT ''{}''
                            ', relevant_table.full_table_name);
            EXECUTE squery;

            squery = format('
            CREATE TRIGGER z_insert_mngmt
                BEFORE INSERT OR UPDATE OF "NoWaitingTimeID", "NoLoadingTimeID", "MatchDayTimePeriodID", "AdditionalConditionID", "geom", "label_pos", "label_loading_pos"
                ON %s
                FOR EACH ROW
                EXECUTE FUNCTION toms.labelling_for_restrictions()
                ', relevant_table.full_table_name);
            EXECUTE squery;

		    RAISE NOTICE 'query: % ', squery;

            -- restart triggers
            squery = format('ALTER TABLE %s ENABLE TRIGGER ALL
                     ', relevant_table.full_table_name);
            EXECUTE squery;

	END LOOP;

END$$;

