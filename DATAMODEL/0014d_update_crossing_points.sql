
-- change symology for crossing points
ALTER TABLE highway_assets."CrossingPoints"
    ADD COLUMN "AzimuthToRoadCentreLine" double precision;

ALTER TABLE highway_assets."CrossingPoints"
    ADD COLUMN "GeomShapeID" integer;

ALTER TABLE ONLY highway_assets."CrossingPoints"
    ADD CONSTRAINT "CrossingPoints_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "toms_lookups"."RestrictionGeomShapeTypes"("Code");

--- after populating fields
ALTER TABLE highway_assets."CrossingPoints"
    ALTER COLUMN "GeomShapeID" SET NOT NULL;

