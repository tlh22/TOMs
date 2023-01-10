-- missing road names

-- bays within car parks

UPDATE "toms"."Bays" AS r
SET "RoadName" = c."Name"
FROM local_authority."CarParks" c
WHERE ST_Within(r.geom, c.geom)
AND r."RoadName" IS NULL;
