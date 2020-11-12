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

-- Leaders ??
UPDATE toms."Bays" SET
    "label_pos" = ST_Multi(ST_SetSRID(ST_MakePoint("label_X", "label_Y"), 27700))
WHERE "label_X" IS NOT NULL AND "label_Y" IS NOT NULL;

-- Remove obsolete fields
ALTER TABLE toms."Lines" DROP COLUMN "label_X";
ALTER TABLE toms."Lines" DROP COLUMN "label_Y";
ALTER TABLE toms."Lines" DROP COLUMN "labelLoading_X";
ALTER TABLE toms."Lines" DROP COLUMN "labelLoading_Y";
ALTER TABLE toms."RestrictionPolygons" DROP COLUMN "label_X";
ALTER TABLE toms."RestrictionPolygons" DROP COLUMN "label_Y";
ALTER TABLE toms."Bays" DROP COLUMN "label_X";
ALTER TABLE toms."Bays" DROP COLUMN "label_Y";


-- Create geometry function that returns attachment points of labels
CREATE OR REPLACE FUNCTION toms.midpoint_or_centroid(geom geometry) RETURNS geometry AS $$
    BEGIN
        RETURN CASE
            WHEN ST_GeometryType(geom) = 'ST_LineString' THEN ST_LineInterpolatePoint(geom, 0.5)
            WHEN ST_GeometryType(geom) = 'ST_Polygon' THEN ST_PointOnSurface(geom)
            ELSE ST_Centroid(geom)
        END;
    END;
$$ LANGUAGE plpgsql;


-- Create the main function to manage restrictions label geometries
CREATE OR REPLACE FUNCTION toms."labelling_for_restrictions"() RETURNS trigger AS /*"""*/ $$

import plpy

OLD = TD["old"] # this contains the feature before modifications
NEW = TD["new"] # this contains the feature after modifications

plpy.info('Trigger {} was run ({} {} on "{}")'.format(TD["name"], TD["when"], TD["event"], TD["table_name"]))

def ensure_labels_points(main_geom, label_geom, initial_rotation):
    """
    This function ensures that at least one label point exists on every sheet on which the geometry appears
    """
    plpy.info('ensure_label_points 1: label_geom:{})'.format(label_geom))

    # Let's just start by making an empty multipoint if label_geom is NULL, so we don't have to deal with NULL afterwards
    if OLD is not None or label_geom is None:
        plan = plpy.prepare("SELECT ST_SetSRID(ST_GeomFromEWKT('MULTIPOINT EMPTY'), Find_SRID('"+TD["table_schema"]+"', '"+TD["table_name"]+"', 'geom')) as p")
        label_geom = plpy.execute(plan)[0]["p"]
    else:
        # We remove multipoints that have not been moved from the calculated position
        # so they will still be attached on the geometry
        # To do so, we generate label positions on the OLD geometry (reusing this same function).
        # We substract those old generated positions from the new ones, so they are deleted from
        # the label multipoints, and will be regenerated exactly on the geometry.
        old_label_geom, _ = ensure_labels_points(OLD["geom"], None, None)
        plan = plpy.prepare('SELECT ST_Multi(ST_CollectionExtract(ST_Difference($1::geometry, $2::geometry),1)) as g', ['text', 'text'])
        results = plpy.execute(plan, [label_geom, old_label_geom])
        label_geom = results[0]['g']

    plpy.info('ensure_label_points 2: label_geom:{})'.format(label_geom))

    # We select all sheets that intersect with the feature but not with the label
    # multipoints to obtain all sheets that miss a label point
    plan = plpy.prepare('SELECT geom FROM toms."MapGrid" WHERE ST_Intersects(geom, $1::geometry) AND NOT ST_Intersects(geom, $2::geometry)', ['text', 'text'])
    results = plpy.execute(plan, [main_geom, label_geom])
    sheets_geoms = [r['geom'] for r in results]

    plpy.info("{} new label points will be created".format(len(sheets_geoms)))

    # For these sheets, we add points at the center of the intersection
    point = None
    for sheet_geom in sheets_geoms:
        # get the intersection between the sheet and the geometry
        plan = plpy.prepare("SELECT ST_Intersection($1::geometry, $2::geometry) as i", ['text', 'text'])
        intersection = plpy.execute(plan, [main_geom, sheet_geom])[0]["i"]

        # get the center (if a line) or the centroid (if not a line)
        # TODO : manage edge case when a feature exits and re-enterds a sheet (we get a MultiLineString, and should return center point of each instead of centroid)
        plan = plpy.prepare("SELECT toms.midpoint_or_centroid($1::geometry) as p", ['text'])
        point = plpy.execute(plan, [intersection])[0]["p"]

        # we collect that point into label_pos
        plan = plpy.prepare("SELECT ST_Multi(ST_Union($1::geometry, $2::geometry)) as p", ['text', 'text'])
        label_geom = plpy.execute(plan, [label_geom, point])[0]["p"]

    # We count the number of points to determine label rotation
    plan = plpy.prepare('SELECT ST_NumGeometries($1::geometry) as n', ['text'])
    labels_count = plpy.execute(plan, [label_geom])[0]['n']

    # We get the geometry type
    plan = plpy.prepare('SELECT ST_GeometryType($1::geometry) as n', ['text'])
    geom_type = plpy.execute(plan, [main_geom])[0]['n']

    if geom_type == 'ST_LineString' and labels_count == 1 and len(sheets_geoms) == 1:
        # We have exactly one label, and that label's position as generated, so we determine
        # the rotation automatically according to the line's angle

        # First, we get the position of the point alongside the geometry
        plan = plpy.prepare('SELECT ST_LINELOCATEPOINT($1::geometry, $2::geometry) as p', ['text', 'text'])
        point_location = plpy.execute(plan, [main_geom, point])[0]['p']

        # Then, we get the position of the point just a little bit further
        plan = plpy.prepare('SELECT ST_LINEINTERPOLATEPOINT($1::geometry, $2 + 0.0001) as p', ['text', 'float8'])
        next_point = plpy.execute(plan, [main_geom, point_location])[0]['p']

        # We compute the angle
        plan = plpy.prepare('SELECT DEGREES(ATAN((ST_Y($2::geometry)-ST_Y($1::geometry)) / (ST_X($2::geometry)-ST_X($1::geometry)))) as p', ['text', 'text'])
        azimuth = plpy.execute(plan, [point, next_point])[0]['p']

        label_rot = azimuth
    elif labels_count > 1:
        # With more that one label, rotation is not supported, we set it to NULL
        label_rot = None
    else:
        # With exactly one label whose position was not generated, we keep rotation as is
        label_rot = initial_rotation

    return label_geom, label_rot

def update_leader_lines(main_geom, label_geom):
    """
    This function updates the label leaders by creating a multilinestring.
    """

    # We select all sheets that intersect with the feature but not with the label
    # multipoints to obtain all sheets that miss a label point
    plan = plpy.prepare('''
        SELECT ST_Collect(ST_MakeLine(p1, p2)) as p
        FROM ( 
            SELECT toms.midpoint_or_centroid(ST_Intersection(geom, $1::geometry)) as p1, mg.id
            FROM toms."MapGrid" mg
            WHERE ST_Intersects(mg.geom, $1::geometry)
        ) as sub1
        JOIN (
            SELECT mg.id, lblpos.geom as p2
            FROM ST_Dump($2::geometry) lblpos
            JOIN toms."MapGrid" mg
            ON ST_Intersects(mg.geom, lblpos.geom)
        ) as sub2 ON sub2.id = sub1.id
    ''', ['text', 'text'])
    return plpy.execute(plan, [main_geom, label_geom])[0]["p"]

# Logic for the primary label
NEW["label_pos"], NEW["label_Rotation"] = ensure_labels_points(NEW["geom"], NEW["label_pos"], NEW["label_Rotation"])
NEW["label_ldr"] = update_leader_lines(NEW["geom"], NEW["label_pos"])

# Logic for the loading label (only exists on table Lines)
if TD["table_name"] == 'Lines':
    NEW["label_loading_pos"], NEW["labelLoading_Rotation"] = ensure_labels_points(NEW["geom"], NEW["label_loading_pos"], NEW["labelLoading_Rotation"])
    NEW["label_loading_ldr"] = update_leader_lines(NEW["geom"], NEW["label_loading_pos"])

# this flag is required for the trigger to commit changes in NEW
return "MODIFY"

$$ LANGUAGE plpython3u;

/*"""*/

-- Create the triggers
CREATE TRIGGER insert_mngmt BEFORE INSERT OR UPDATE ON toms."Bays" FOR EACH ROW EXECUTE PROCEDURE toms."labelling_for_restrictions"();
CREATE TRIGGER insert_mngmt BEFORE INSERT OR UPDATE ON toms."Lines" FOR EACH ROW EXECUTE PROCEDURE toms."labelling_for_restrictions"();
CREATE TRIGGER insert_mngmt BEFORE INSERT OR UPDATE ON toms."RestrictionPolygons" FOR EACH ROW EXECUTE PROCEDURE toms."labelling_for_restrictions"();
CREATE TRIGGER insert_mngmt BEFORE INSERT OR UPDATE ON toms."ControlledParkingZones" FOR EACH ROW EXECUTE PROCEDURE toms."labelling_for_restrictions"();
CREATE TRIGGER insert_mngmt BEFORE INSERT OR UPDATE ON toms."ParkingTariffAreas" FOR EACH ROW EXECUTE PROCEDURE toms."labelling_for_restrictions"();

-- Run the trigger once to populate leaders
UPDATE toms."Bays" SET label_pos = label_pos;
UPDATE toms."Lines" SET label_pos = label_pos;
UPDATE toms."RestrictionPolygons" SET label_pos = label_pos;
UPDATE toms."ControlledParkingZones" SET label_pos = label_pos;
UPDATE toms."ParkingTariffAreas" SET label_pos = label_pos;
/*"""*/