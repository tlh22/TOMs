/***

Create materialised view of the zones for the legend

***/

DROP MATERIALIZED VIEW IF EXISTS toms_lookups."PolygonZoneDetails_View";

CREATE MATERIALIZED VIEW toms_lookups."PolygonZoneDetails_View"
TABLESPACE pg_default
AS
SELECT "RestrictionPolygonTypes"."Description" AS "Zone Type", "CPZ" AS "Name", COALESCE("TimePeriods1"."Description", '') AS "Hours of Control"
FROM
((  toms."ControlledParkingZones" AS a
 LEFT JOIN "toms_lookups"."RestrictionPolygonTypes" AS "RestrictionPolygonTypes" ON a."RestrictionTypeID" is not distinct from "RestrictionPolygonTypes"."Code")
 LEFT JOIN "toms_lookups"."TimePeriods" AS "TimePeriods1" ON a."TimePeriodID" is not distinct from "TimePeriods1"."Code")
 WHERE a."OpenDate" IS NOT NULL
 AND a."CloseDate" IS NULL
ORDER BY 2
WITH DATA;

ALTER TABLE toms_lookups."PolygonZoneDetails_View"
    OWNER TO postgres;

CREATE UNIQUE INDEX "PolygonZoneDetails_View_key"
    ON toms_lookups."PolygonZoneDetails_View" USING btree
    ("Name")
    TABLESPACE pg_default;
	
REVOKE ALL ON ALL TABLES IN SCHEMA toms_lookups FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;