-- Support tables

-- move OS topo details, etc

ALTER TABLE "Background"."TopographicArea" SET SCHEMA topography;
DROP TABLE IF EXISTS topography."os_mastermap_topography_polygons";
ALTER TABLE topography."TopographicArea" RENAME TO "os_mastermap_topography_polygons";

-- Need to change the names of columns DESCRIPT1 -> DescGroup

ALTER TABLE "Background"."CartographicText" SET SCHEMA topography;
DROP TABLE IF EXISTS topography."os_mastermap_topography_text";
ALTER TABLE topography."CartographicText" RENAME TO "os_mastermap_topography_text";

-- SiteArea
ALTER TABLE "Background"."ThreeRiversDistrict" SET SCHEMA local_authority;


-- StreetGazetteerRecords
ALTER TABLE "public"."StreetGazetteer" SET SCHEMA local_authority;
DROP TABLE IF EXISTS local_authority."StreetGazetteerRecords";
ALTER TABLE local_authority."StreetGazetteer" RENAME TO "StreetGazetteerRecords";

--ALTER TABLE "public"."StreetsList" SET SCHEMA local_authority;


-- Add view for gazetteer lookup
DROP MATERIALIZED VIEW IF EXISTS local_authority."StreetGazetteerView";
CREATE MATERIALIZED VIEW local_authority."StreetGazetteerView"
TABLESPACE pg_default
AS
    SELECT row_number() OVER (PARTITION BY true::boolean) AS id,
    "SITE_NAME" AS "RoadName", "TOWN" AS "Locality", geom As geom
	FROM local_authority."StreetGazetteerRecords"
WITH DATA;

ALTER TABLE local_authority."StreetGazetteerView"
    OWNER TO postgres;

CREATE UNIQUE INDEX "idx_StreetGazetteerView_id"
    ON local_authority."StreetGazetteerView" USING btree
    (id)
    TABLESPACE pg_default;

CREATE INDEX idx_street_name
ON local_authority."StreetGazetteerView"("RoadName");

ALTER TABLE "Background"."RoadLink" SET SCHEMA highways_network;
ALTER TABLE highways_network."RoadLink" RENAME TO "roadlink";

-- RoadCasement
ALTER TABLE "public"."RC_Sections" SET SCHEMA mhtc_operations;
ALTER TABLE "public"."RC_Sections_merged" SET SCHEMA mhtc_operations;

-- TODO: need to set up road casement

ALTER TABLE "public"."GNSS_Pts" SET SCHEMA mhtc_operations;

-- MapGrid

INSERT INTO toms."MapGrid"(
	id, geom, x_min, x_max, y_min, y_max)
SELECT id, ST_Multi(geom), x_min, x_max, y_min, y_max
	FROM "Background"."MapGrid_1000";
