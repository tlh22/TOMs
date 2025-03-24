/***

Logic to give AANN references to grid

1. Work out the width/height of each sheet - x_max - x_min = dx;  y_max - y_min = dy
2. Get the top left corner - x_max / y_min of all sheets
3. Assign a row nr (for x) and a column nr (for y) using a series with steps
4. Convert row nr to AA based on series details

***/

DO
$do$
DECLARE
	dx REAL;
	dy REAL;
	x_top_left_site REAL;
	y_top_left_site REAL;
	
    map_tile RECORD;
	
	row_nr REAL;
	col_nr REAL;
	
	ascii_A integer = 65;
	
	ascii_col character varying;
	mapref character varying;
	
BEGIN

	-- find the height/width of a sheet
	SELECT x_max - x_min, y_max - y_min
	INTO dx, dy
	FROM toms."MapGrid"
	LIMIT 1;
	
	RAISE NOTICE '*****--- Width %, Height: %', dx, dy;
	
	-- find top left corner
	
	SELECT MIN(x_min), MAX(y_max)
	INTO x_top_left_site, y_top_left_site
	FROM toms."MapGrid";
	
	RAISE NOTICE '*****--- top x %, top y: %', x_top_left_site, y_top_left_site;
	
	-- assign row number
	
	FOR map_tile IN
        SELECT id, x_min, x_max, y_min, y_max
        FROM toms."MapGrid"
    LOOP

        RAISE NOTICE '*****--- Considering mapsheet %', map_tile.id;
		
		col_nr = (map_tile.x_min - x_top_left_site)/dx;
		row_nr = (y_top_left_site - map_tile.y_min)/dy;
		
		
		SELECT 
		    CASE WHEN col_nr < 26 THEN CHR((ascii_A + col_nr)::integer)
			     ELSE CHR((ascii_A + (col_nr/25)::integer-1)::integer) || CHR((ascii_A + ((col_nr-1)::integer%25)::integer)::integer)
			END
		INTO ascii_col;
		
		mapref = ascii_col || row_nr;
		
		UPDATE toms."MapGrid"
		SET mapsheetname = mapref
		WHERE id = map_tile.id;

        RAISE NOTICE '*****--- Considering mapsheet %: row: %; col % == mapref %', map_tile.id, row_nr, col_nr, mapref;

		
    END LOOP;

END;
$do$;

/***

Output tile details -- TODO: choose only those with restrictions


SELECT id, mapsheetname, "CurrRevisionNr", "LastRevisionDate"
	FROM toms."MapGrid"
	ORDER BY id


***/