 ALTER TABLE compliance_lookups."BaysLinesFadedTypes"
    RENAME TO "RestrictionRoadMarkingsFadedTypes";

ALTER TABLE compliance_lookups."BaysLines_SignIssueTypes"
    RENAME TO "Restriction_SignIssueTypes";

ALTER TABLE compliance_lookups."MHTC_CheckIssueType"
    RENAME TO "MHTC_CheckIssueTypes";

-- Add view for gazetteer lookup
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


-- SignTypes - need to include ICON field and update from MASTER

ALTER TABLE toms_lookups."SignTypes"
    ADD COLUMN "Icon" character varying(255);

-- Allow admin to update details in LOOKUPs
REVOKE ALL ON ALL TABLES IN SCHEMA toms_lookups FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA toms_lookups TO toms_public, toms_operator;
GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA toms_lookups TO toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;

REVOKE ALL ON ALL TABLES IN SCHEMA compliance_lookups FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA compliance_lookups TO toms_public, toms_operator;
GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA compliance_lookups TO toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA compliance_lookups TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA compliance_lookups TO toms_public, toms_operator, toms_admin;