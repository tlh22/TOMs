/**
Recognise that physical restriction may not just be a single point, e.g., across a bridge

**/

ALTER TABLE moving_traffic."RestrictionsForVehicles"
    ADD COLUMN "geom_linestring" "public"."geometry"(LineString,27700);

CREATE INDEX "sidx_RestrictionsForVehicles_geom_linestring" ON "moving_traffic"."RestrictionsForVehicles" USING "gist" ("geom_linestring");
