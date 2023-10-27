/***

Add fields and calculate the map sheets around the current sheets

***/

ALTER TABLE IF EXISTS toms."MapGrid"
    ADD COLUMN IF NOT EXISTS "MapSheet_North" integer;
	
ALTER TABLE IF EXISTS toms."MapGrid"
    ADD COLUMN IF NOT EXISTS "MapSheet_East" integer;

ALTER TABLE IF EXISTS toms."MapGrid"
    ADD COLUMN IF NOT EXISTS "MapSheet_South" integer;
	
ALTER TABLE IF EXISTS toms."MapGrid"
    ADD COLUMN IF NOT EXISTS "MapSheet_West" integer;
	
-- North
UPDATE toms."MapGrid" AS m1
SET "MapSheet_North" = m2.id
FROM  toms."MapGrid" m2
WHERE m1.y_max = m2.y_min
AND m1.x_min = m2.x_min
AND m1.x_max = m2.x_max
;

-- East
UPDATE toms."MapGrid" AS m1
SET "MapSheet_East" = m2.id
FROM  toms."MapGrid" m2
WHERE m1.y_max = m2.y_max
AND m1.y_min = m2.y_min
AND m1.x_max = m2.x_min
;

-- South
UPDATE toms."MapGrid" AS m1
SET "MapSheet_South" = m2.id
FROM  toms."MapGrid" m2
WHERE m1.y_min = m2.y_max
AND m1.x_min = m2.x_min
AND m1.x_max = m2.x_max
;

-- West
UPDATE toms."MapGrid" AS m1
SET "MapSheet_West" = m2.id
FROM  toms."MapGrid" m2
WHERE m1.y_max = m2.y_max
AND m1.y_min = m2.y_min
AND m1.x_min = m2.x_max
;