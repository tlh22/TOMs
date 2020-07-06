/*"""*/
/* DATAMODEL diff to enable multiple labels per sheet */


-- Add label position and leader fields
ALTER TABLE toms."Lines" ADD COLUMN "label_pos" geometry(MultiPoint, 27700);
ALTER TABLE toms."Lines" ADD COLUMN "label_ldr" geometry(MultiLinestring, 27700);
ALTER TABLE toms."Lines" ADD COLUMN "label_loading_pos" geometry(MultiPoint, 27700);
ALTER TABLE toms."Lines" ADD COLUMN "label_loading_ldr" geometry(MultiLinestring, 27700);
ALTER TABLE toms."RestrictionPolygons" ADD COLUMN "label_pos" geometry(MultiPoint, 27700);
ALTER TABLE toms."RestrictionPolygons" ADD COLUMN "label_ldr" geometry(MultiLinestring, 27700);
ALTER TABLE toms."Bays" ADD COLUMN "label_pos" geometry(MultiPoint, 27700);
ALTER TABLE toms."Bays" ADD COLUMN "label_ldr" geometry(MultiLinestring, 27700);
ALTER TABLE toms."ParkingTariffAreas" ADD COLUMN "label_pos" geometry(MultiPoint, 27700);
ALTER TABLE toms."ParkingTariffAreas" ADD COLUMN "label_ldr" geometry(MultiLinestring, 27700);
ALTER TABLE toms."ControlledParkingZones" ADD COLUMN "label_pos" geometry(MultiPoint, 27700);
ALTER TABLE toms."ControlledParkingZones" ADD COLUMN "label_ldr" geometry(MultiLinestring, 27700);


-- Create default label positions

UPDATE toms."Lines" SET
    "label_pos" = ST_Multi(ST_LineInterpolatePoint("geom", 0.5)),
    "label_loading_pos" = ST_Multi(ST_LineInterpolatePoint("geom", 0.5));

UPDATE toms."RestrictionPolygons" SET
    "label_pos" = ST_Multi(ST_PointOnSurface("geom"));

UPDATE toms."Bays" SET
    "label_pos" = ST_Multi(ST_PointOnSurface("geom"));

UPDATE toms."ParkingTariffAreas" SET
    "label_pos" = ST_Multi(ST_PointOnSurface("geom"));

UPDATE toms."ControlledParkingZones" SET
    "label_pos" = ST_Multi(ST_PointOnSurface("geom"));


-- Migrate manually positionned label

UPDATE toms."Lines" SET
    "label_pos" = ST_Multi(ST_SetSRID(ST_MakePoint("label_X", "label_Y"), 27700))
WHERE "label_X" IS NOT NULL AND "label_Y" IS NOT NULL;

UPDATE toms."Lines" SET
    "label_loading_pos" = ST_Multi(ST_SetSRID(ST_MakePoint("labelLoading_X", "labelLoading_Y"), 27700))
WHERE "labelLoading_X" IS NOT NULL AND "labelLoading_Y" IS NOT NULL;

UPDATE toms."RestrictionPolygons" SET
    "label_pos" = ST_Multi(ST_SetSRID(ST_MakePoint("label_X", "label_Y"), 27700))
WHERE "label_X" IS NOT NULL AND "label_Y" IS NOT NULL;

UPDATE toms."Bays" SET
    "label_pos" = ST_Multi(ST_SetSRID(ST_MakePoint("label_X", "label_Y"), 27700))
WHERE "label_X" IS NOT NULL AND "label_Y" IS NOT NULL;


-- Remove obsolete fields
ALTER TABLE toms."Lines" DROP COLUMN "label_X";
ALTER TABLE toms."Lines" DROP COLUMN "label_Y";
ALTER TABLE toms."Lines" DROP COLUMN "label_Rotation";
ALTER TABLE toms."Lines" DROP COLUMN "labelLoading_X";
ALTER TABLE toms."Lines" DROP COLUMN "labelLoading_Y";
ALTER TABLE toms."Lines" DROP COLUMN "labelLoading_Rotation";
ALTER TABLE toms."RestrictionPolygons" DROP COLUMN "label_X";
ALTER TABLE toms."RestrictionPolygons" DROP COLUMN "label_Y";
ALTER TABLE toms."RestrictionPolygons" DROP COLUMN "label_Rotation";
ALTER TABLE toms."Bays" DROP COLUMN "label_X";
ALTER TABLE toms."Bays" DROP COLUMN "label_Y";
ALTER TABLE toms."Bays" DROP COLUMN "label_Rotation";

CREATE OR REPLACE FUNCTION restriction_mngmt() RETURNS trigger AS /*"""*/ $$

import plpy

OLD = TD["old"] # this contains the feature before modifications
NEW = TD["new"] # this contains the feature after modifications

plpy.info('Trigger {} was run ({} {} on "{}")'.format(TD["name"], TD["when"], TD["event"], TD["table_name"]))

def ensure_labels_points(main_geom, label_geom):
    """
    This function ensures that at least one label point exists on every sheet on which the geometry appears
    """

    # Let's just start by making an empty multipoint if label_geom is NULL, so we don't have to deal with NULL afterwards
    if label_geom is None:
        plan = plpy.prepare("SELECT ST_SetSRID(ST_GeomFromEWKT('MULTIPOINT EMPTY'), Find_SRID('"+TD["table_schema"]+"', '"+TD["table_name"]+"', 'geom')) as p", ['text'])
        label_geom = plpy.execute(plan, [label_geom])[0]["p"]

    # TODO : make the position automatically update if it wasn't moved
    # for lines, this could be done by computing ST_DIFFERENCE(label_pos, OLD["geom"])
    # but let's keep it simple for now...

    # We select all sheets that intersect with the feature but not with the label
    # multipoints to obtain all sheets that miss a label point
    plan = plpy.prepare('SELECT geom FROM "toms"."MapGrid" WHERE ST_Intersects(geom, $1::geometry) AND NOT ST_Intersects(geom, $2::geometry)', ['text', 'text'])
    results = plpy.execute(plan, [main_geom, label_geom])
    sheets_geoms = [r['geom'] for r in results]

    plpy.info("{} new label points will be created".format(len(sheets_geoms)))

    # For these sheets, we add points at the center of the intersection
    points = []
    for sheet_geom in sheets_geoms:
        # get the intersection between the sheet and the geometry
        plan = plpy.prepare("SELECT ST_Intersection($1::geometry, $2::geometry) as i", ['text', 'text'])
        intersection = plpy.execute(plan, [main_geom, sheet_geom])[0]["i"]

        # get the center (if a line) or the centroid (if not a line)
        # TODO : manage edge case when a feature exits and re-enterds a sheet (we get a MultiLineString, and should return center point of each instead of centroid)
        plan = plpy.prepare("SELECT CASE WHEN ST_GeometryType($1::geometry) = 'ST_LineString' THEN ST_LineInterpolatePoint($1::geometry, 0.5) WHEN ST_GeometryType($1::geometry) = 'ST_Polygon' THEN ST_PointOnSurface($1::geometry) ELSE ST_Centroid($1::geometry) END as p", ['text'])
        point = plpy.execute(plan, [intersection])[0]["p"]

        # we collect that point into label_pos
        plan = plpy.prepare("SELECT ST_Multi(ST_Union($1::geometry, $2::geometry)) as p", ['text', 'text'])
        label_geom = plpy.execute(plan, [label_geom, point])[0]["p"]

    return label_geom

def update_leader_lines(main_geom, label_geom):
    """
    This function updates the label leaders by creating a multilinestring.
    """

    # We select all sheets that intersect with the feature but not with the label
    # multipoints to obtain all sheets that miss a label point
    plan = plpy.prepare('''
        SELECT ST_Collect(ST_MakeLine(p1, p2)) as p
        FROM ( 
            SELECT ST_Centroid(ST_Intersection(geom, $1::geometry)) as p1, mg.id
            FROM "toms"."MapGrid" mg
            WHERE ST_Intersects(mg.geom, $1::geometry)
        ) as sub1
        JOIN (
            SELECT mg.id, lblpos.geom as p2
            FROM ST_Dump($2::geometry) lblpos
            JOIN "toms"."MapGrid" mg
            ON ST_Intersects(mg.geom, lblpos.geom)
        ) as sub2 ON sub2.id = sub1.id
    ''', ['text', 'text'])
    return plpy.execute(plan, [main_geom, label_geom])[0]["p"]

NEW["label_pos"] = ensure_labels_points(NEW["geom"], NEW["label_pos"])
NEW["label_ldr"] = update_leader_lines(NEW["geom"], NEW["label_pos"])

if TD["table_name"] == 'Lines':
    # the Lines layer has an additionnal label pos
    NEW["label_loading_pos"] = ensure_labels_points(NEW["geom"], NEW["label_loading_pos"])
    NEW["label_loading_ldr"] = update_leader_lines(NEW["geom"], NEW["label_loading_pos"])

# this flag is required for the trigger to commit changes in NEW
return "MODIFY"

$$ LANGUAGE plpython3u;

/*"""*/

-- Create the triggers
-- insert
CREATE TRIGGER insert_mngmt BEFORE INSERT ON toms."Bays" FOR EACH ROW EXECUTE PROCEDURE restriction_mngmt();
CREATE TRIGGER insert_mngmt BEFORE INSERT ON toms."Lines" FOR EACH ROW EXECUTE PROCEDURE restriction_mngmt();
CREATE TRIGGER insert_mngmt BEFORE INSERT ON toms."RestrictionPolygons" FOR EACH ROW EXECUTE PROCEDURE restriction_mngmt();
CREATE TRIGGER insert_mngmt BEFORE INSERT ON toms."ControlledParkingZones" FOR EACH ROW EXECUTE PROCEDURE restriction_mngmt();
CREATE TRIGGER insert_mngmt BEFORE INSERT ON toms."ParkingTariffAreas" FOR EACH ROW EXECUTE PROCEDURE restriction_mngmt();
-- update
CREATE TRIGGER update_mngmt BEFORE UPDATE ON toms."Bays" FOR EACH ROW WHEN ( NOT ST_Equals(OLD.geom, NEW.geom) OR NOT ST_Equals(OLD.label_pos, NEW.label_pos) ) EXECUTE PROCEDURE restriction_mngmt();
CREATE TRIGGER update_mngmt BEFORE UPDATE ON toms."Lines" FOR EACH ROW WHEN ( NOT ST_Equals(OLD.geom, NEW.geom) OR NOT ST_Equals(OLD.label_pos, NEW.label_pos) OR NOT ST_Equals(OLD.label_loading_pos, NEW.label_loading_pos) ) EXECUTE PROCEDURE restriction_mngmt();
CREATE TRIGGER update_mngmt BEFORE UPDATE ON toms."RestrictionPolygons" FOR EACH ROW WHEN ( NOT ST_Equals(OLD.geom, NEW.geom) OR NOT ST_Equals(OLD.label_pos, NEW.label_pos) ) EXECUTE PROCEDURE restriction_mngmt();
CREATE TRIGGER update_mngmt BEFORE UPDATE ON toms."ControlledParkingZones" FOR EACH ROW WHEN ( NOT ST_Equals(OLD.geom, NEW.geom) OR NOT ST_Equals(OLD.label_pos, NEW.label_pos) ) EXECUTE PROCEDURE restriction_mngmt();
CREATE TRIGGER update_mngmt BEFORE UPDATE ON toms."ParkingTariffAreas" FOR EACH ROW WHEN ( NOT ST_Equals(OLD.geom, NEW.geom) OR NOT ST_Equals(OLD.label_pos, NEW.label_pos) ) EXECUTE PROCEDURE restriction_mngmt();

/*"""*/