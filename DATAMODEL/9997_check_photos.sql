/***
To work out files missing (or that can be deleted), the steps are:
1. generate a list of the photos within the tables. See script below
2. generate list of files within the photos directory use $ ls > photos_in_directory.txt
3a. grep -v -f  photos_in_database.csv photos_in_directory.txt (this will show the photos that are not required)
3b. grep -v -f  photos_in_directory.txt photos_in_database.csv (this will show the photos not yet uploaded)

grep -v -f fileA fileB (finds lines in fileB that are not present in fileA)

***/--
--DROP FUNCTION mhtc_operations.getPhotosFromTable(schemaname text, tablename text);
CREATE OR REPLACE FUNCTION mhtc_operations.getPhotosFromTable(tablename regclass)
  RETURNS TABLE (photo_name character varying(255)) AS
$func$
DECLARE
	 squery text;
BEGIN
   RAISE NOTICE 'checking: %', tablename;
   squery = format('SELECT "Photos_01"
                    FROM   %s
                    WHERE "Photos_01" IS NOT NULL
                    UNION
                    SELECT "Photos_02"
                    FROM   %s
                    WHERE "Photos_02" IS NOT NULL
                    UNION
                    SELECT "Photos_03"
                    FROM   %s
                    WHERE "Photos_03" IS NOT NULL
                    ', tablename, tablename, tablename);
   --RAISE NOTICE '2: %', squery;
   RETURN QUERY EXECUTE squery;
END;
$func$ LANGUAGE plpgsql;

-- query

WITH relevant_tables AS (
      select concat(table_schema, '.', quote_ident(table_name)) AS full_table_name
      from information_schema.columns
      where column_name = 'Photos_01'
      AND table_schema NOT IN ('quarantine')
    )

    SELECT mhtc_operations.getPhotosFromTable(full_table_name)
    FROM relevant_tables;


