
-- Add view for gazetteer lookup  **NB: Assumes that "street" from OS RAMI has been loaded
CREATE MATERIALIZED VIEW local_authority."StreetGazetteerView"
TABLESPACE pg_default
AS
    SELECT row_number() OVER (PARTITION BY true::boolean) AS id,
    name AS "RoadName", authorityname AS "Locality", geometry As geom
	FROM highways_network.street
WITH DATA;

ALTER TABLE local_authority."StreetGazetteerView"
    OWNER TO postgres;

CREATE UNIQUE INDEX "idx_StreetGazetteerView_id"
    ON local_authority."StreetGazetteerView" USING btree
    (id)
    TABLESPACE pg_default;

CREATE INDEX idx_street_name
ON local_authority."StreetGazetteerView"("RoadName");
