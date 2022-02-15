/***
 * Get restriction label text
 ****/

CREATE OR REPLACE FUNCTION toms.get_cpz(restriction_geom geometry) RETURNS SETOF toms."ControlledParkingZones" AS $$

        SELECT *
        FROM toms."ControlledParkingZones" c
        WHERE ST_Within(restriction_geom, c.geom)
        AND c."OpenDate" IS NOT NULL
        AND c."CloseDate" IS NULL;

$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION toms.get_pta(restriction_geom geometry) RETURNS SETOF toms."ParkingTariffAreas" AS $$

        SELECT *
        FROM toms."ParkingTariffAreas" c
        WHERE ST_Within(restriction_geom, c.geom)
        AND c."OpenDate" IS NOT NULL
        AND c."CloseDate" IS NULL;

$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION toms.get_mdedz(restriction_geom geometry) RETURNS SETOF toms."MatchDayEventDayZones" AS $$

        SELECT *
        FROM toms."MatchDayEventDayZones" c
        WHERE ST_Within(restriction_geom, c.geom)
        AND c."OpenDate" IS NOT NULL
        AND c."CloseDate" IS NULL;

$$ LANGUAGE sql;

/***
DO
$do$
DECLARE
   row RECORD;
   cpz_rec RECORD;
BEGIN

    FOR row IN
        SELECT *
        FROM toms."Bays" r
        WHERE r."GeometryID" = 'B_ 000000034'
    LOOP

        SELECT * INTO cpz_rec
        FROM toms.get_cpz(row.geom);

        RAISE NOTICE '***** cpz (%) %', cpz_rec."CPZ", cpz_rec."TimePeriodID";

    END LOOP;
END
$do$;
***/

-- Create the main function to manage restrictions label geometries
CREATE OR REPLACE FUNCTION toms."labelling_for_restrictions"() RETURNS trigger AS /*"""*/ $$

import plpy

OLD = TD["old"] # this contains the feature before modifications
NEW = TD["new"] # this contains the feature after modifications

#plpy.info('Trigger {} was run ({} {} on "{}")'.format(TD["name"], TD["when"], TD["event"], TD["table_name"]))
plpy.info('Considering labels for: {}'.format(NEW["GeometryID"]))

# Check to see if considering a current feature
if NEW["OpenDate"] and not NEW["CloseDate"]:
    plpy.info('Current feature. Returning without processing ...')
    return

def getCPZ(feature):
    # get cpz given feature
    plan = plpy.prepare('SELECT * FROM toms.get_cpz($1::geometry)', ['text'])
    cpz_rec = plpy.execute(plan, [feature["geom"]])

    #if cpz_rec.nrows() > 0:
    #    plpy.info('In getCPZ. CPZ record: {}'.format(cpz_rec[0]))

    return cpz_rec

def getPTA(feature):
    # get pta given feature
    plan = plpy.prepare('SELECT * FROM toms.get_pta($1::geometry)', ['text'])
    pta_rec = plpy.execute(plan, [feature["geom"]])

    #if pta_rec.nrows() > 0:
    #    plpy.info('In getPTA. PTA record: {}'.format(pta_rec[0]))

    return pta_rec

def getMDEDZ(feature):
    # get match day/event day zone given feature
    plan = plpy.prepare('SELECT * FROM toms.get_mdedz($1::geometry)', ['text'])
    mdedz_rec = plpy.execute(plan, [feature["geom"]])

    #if mdedz_rec.nrows() > 0:
    #    plpy.info('In getMDEDZ. MDEDZ record: {}'.format(mdedz_rec[0]))

    return mdedz_rec


def getBayRestrictionLabelText(feature):

    maxStayDesc = None
    noReturnDesc = None
    timePeriodDesc = None

    maxStayID = feature["MaxStayID"]
    noReturnID = feature["NoReturnID"]
    timePeriodID = feature["TimePeriodID"]
    matchDayTimePeriodID = feature["MatchDayTimePeriodID"]
    additionalConditionID = feature["AdditionalConditionID"]
    permitCode = feature["PermitCode"]

    #plpy.info('TimePeriodID: {}'.format(timePeriodID))

    restrictionCPZ = feature["CPZ"]
    restrictionEDZ = feature["MatchDayEventDayZone"]
    restrictionPTA = feature["ParkingTariffArea"]

    cpz_rec = getCPZ(feature)
    if cpz_rec:
        CPZWaitingTimeID = cpz_rec[0]["TimePeriodID"]
    else:
        CPZWaitingTimeID = None

    if timePeriodID == 1:  # 'At Any Time'
        timePeriodDesc = None
    elif CPZWaitingTimeID:
        if CPZWaitingTimeID == timePeriodID:
            timePeriodDesc = None
        else:
            timePeriodDesc = timePeriodID
    else:
        timePeriodDesc = timePeriodID

    #plpy.info('In getBayRestrictionLabelText. 2 timePeriodDesc: {} {} {}'.format(timePeriodID, CPZWaitingTimeID, timePeriodDesc))

    pta_rec = getPTA(feature)
    if pta_rec:
        TariffZoneTimePeriodID = pta_rec[0]["TimePeriodID"]
        TariffZoneMaxStayID = pta_rec[0]["MaxStayID"]
        TariffZoneNoReturnID = pta_rec[0]["NoReturnID"]
    else:
        TariffZoneTimePeriodID = None
        TariffZoneMaxStayID = None
        TariffZoneNoReturnID = None

    if TariffZoneTimePeriodID:
        if TariffZoneTimePeriodID == timePeriodID:
            timePeriodDesc = None

        if TariffZoneMaxStayID:
            if TariffZoneMaxStayID == maxStayID:
                maxStayDesc = None

        if TariffZoneNoReturnID:
            if TariffZoneNoReturnID == noReturnID:
                noReturnDesc = None

    #plpy.info('In getBayRestrictionLabelText. 3 TariffZoneTimePeriodID: {}'.format(TariffZoneTimePeriodID))

    if matchDayTimePeriodID:
        mdedz_rec = getMDEDZ(feature)
        if mdedz_rec:
            mdedzTimePeriodID = mdedz_rec[0]["TimePeriodID"]
        else:
            mdedzTimePeriodID = None

        if mdedzTimePeriodID != matchDayTimePeriodID:
            if timePeriodDesc:
                timePeriodDesc = "{};Match Day: {}".format(timePeriodDesc, mdedzTimePeriodID)
            else:
                timePeriodDesc = "Match Day: {}".format(mdedzTimePeriodID)

    if permitCode:
        if timePeriodDesc:
            timePeriodDesc = "{};Permit: {}".format(timePeriodDesc, permitCode)
        else:
            timePeriodDesc = "Permit: {}".format(permitCode)

    if additionalConditionID:
        if timePeriodDesc:
            timePeriodDesc = "{};{}".format(timePeriodDesc, additionalConditionID)
        else:
            timePeriodDesc = "{}".format(additionalConditionID)

    return maxStayID, noReturnID, timePeriodDesc

def getWaitingLoadingRestrictionLabelText(feature):

    waitDesc = None
    loadDesc = None

    try:
        waitingTimeID = feature["NoWaitingTimeID"]
        loadingTimeID = feature["NoLoadingTimeID"]
        matchDayTimePeriodID = feature["MatchDayTimePeriodID"]
        additionalConditionID = feature["AdditionalConditionID"]
        geometryID = feature["GeometryID"]
    except Exception as e:
        return None, None

    cpz_rec = getCPZ(feature)
    if cpz_rec:
        CPZWaitingTimeID = cpz_rec[0]["TimePeriodID"]
    else:
        CPZWaitingTimeID = None

    if waitingTimeID == 1:  # 'At Any Time'
        waitDesc = None
    elif CPZWaitingTimeID:
        if CPZWaitingTimeID == waitingTimeID:
            waitDesc = None
        else:
            waitDesc = waitingTimeID
    else:
        waitDesc = waitingTimeID

    if matchDayTimePeriodID:
        mdedz_rec = getMDEDZ(feature)
        if mdedz_rec:
            mdedzTimePeriodID = mdedz_rec[0]["TimePeriodID"]
        else:
            mdedzTimePeriodID = None

        if mdedzTimePeriodID != matchDayTimePeriodID:
            if waitDesc:
                waitDesc = "{};Match Day: {}".format(waitDesc, mdedzTimePeriodID)
            else:
                waitDesc = "Match Day: {}".format(mdedzTimePeriodID)

    if additionalConditionID:
        if waitDesc:
            waitDesc = "{};{}".format(waitDesc, additionalConditionID)
        else:
            waitDesc = "{}".format(additionalConditionID)

    if loadingTimeID:
        if loadingTimeID == 1:  # 'At Any Time'
            loadDesc = None
        else:
            loadDesc = loadingTimeID

    return waitDesc, loadDesc

#-----------------

def ensure_labels_points(main_geom, label_geom, initial_rotation):
    """
    This function ensures that at least one label point exists on every sheet on which the geometry appears
    """

    #plpy.info('ensure_label_points 1: label_geom:{})'.format(label_geom))

    # Let's just start by making an empty multipoint if label_geom is NULL, so we don't have to deal with NULL afterwards
    if label_geom is None:
        plan = plpy.prepare("SELECT ST_SetSRID(ST_GeomFromEWKT('MULTIPOINT EMPTY'), Find_SRID('"+TD["table_schema"]+"', '"+TD["table_name"]+"', 'geom')) as p")
        label_geom = plpy.execute(plan)[0]["p"]

    elif OLD is not None:
        # We remove multipoints that have not been moved from the calculated position
        # so they will still be attached on the geometry
        # To do so, we generate label positions on the OLD geometry (reusing this same function).
        # We substract those old generated positions from the new ones, so they are deleted from
        # the label multipoints, and will be regenerated exactly on the geometry.

        old_label_geom, _ = ensure_labels_points(OLD["geom"], None, None)
        plan = plpy.prepare('SELECT ST_Multi(ST_CollectionExtract(ST_Difference($1::geometry, $2::geometry),1)) as g', ['text', 'text'])
        results = plpy.execute(plan, [label_geom, old_label_geom])
        label_geom = results[0]['g']

    # Need to consider situation where restriction has changed such that it no longer intersects with one of the map tiles

    plan = plpy.prepare('SELECT ST_Multi(ST_CollectionExtract(ST_Difference($1::geometry, m.geom),1)) as g FROM toms."MapGrid" m WHERE ST_Intersects($1::geometry, m.geom) AND NOT ST_Intersects($2::geometry, m.geom)', ['text', 'text'])
    results = plpy.execute(plan, [label_geom, main_geom])

    if results:
        #plpy.info('ensure_label_points 2: results:{})'.format(results[0]['g']))
        label_geom = results[0]['g']

    # We select all sheets that intersect with the feature but not with the label
    # multipoints to obtain all sheets that miss a label point
    plan = plpy.prepare('SELECT geom FROM toms."MapGrid" WHERE ST_Intersects(geom, $1::geometry) AND NOT ST_Intersects(geom, $2::geometry)', ['text', 'text'])
    results = plpy.execute(plan, [main_geom, label_geom])
    sheets_geoms = [r['geom'] for r in results]

    #plpy.info("{} new label points will be created".format(len(sheets_geoms)))

    # For these sheets, we add points at the center of the intersection
    point = None
    for sheet_geom in sheets_geoms:
        # get the intersection between the sheet and the geometry
        plan = plpy.prepare("SELECT ST_Intersection($1::geometry, $2::geometry) as i", ['text', 'text'])
        try:
            intersection = plpy.execute(plan, [main_geom, sheet_geom])[0]["i"]
        except Exception as e:
            plpy.info('ensure_label_points error calculating intersection between map tile and the geometry: {})'.format(e))
            intersection = main_geom

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

        #plpy.info('ensure_label_points 3a: point:{})'.format(point))
        #plpy.info('ensure_label_points 3b: next_point:{})'.format(next_point))

        # We compute the angle

        plan = plpy.prepare('SELECT DEGREES(ATAN((ST_Y($2::geometry)-ST_Y($1::geometry)) / (ST_X($2::geometry)-ST_X($1::geometry)))) as p', ['text', 'text'])
        try:
            azimuth = plpy.execute(plan, [point, next_point])[0]['p']
        except Exception as e:
            plpy.info('ensure_label_points error calculating orientation of label: {})'.format(e))
            azimuth = 0

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

    try:
        result = plpy.execute(plan, [main_geom, label_geom])[0]["p"]
    except Exception as e:
        plpy.info('update_leader_lines. error calculating leader: {})'.format(e))
        result = OLD["label_ldr"]
        return result

    # Now check the length of the leader line
    plan = plpy.prepare('SELECT ST_LENGTH($1::geometry) as p', ['text'])
    ldr_length = plpy.execute(plan, [result])[0]['p']

    #plpy.info('update_leader_lines. leader length: {}'.format(ldr_length))

    """
    if ldr_length < 0.01:
        plpy.info('update_leader_lines. leader length 3: {}'.format(ldr_length))
        result = None
        """

    return result

##### Logic for the primary label

# Check if label is required

if TD["table_name"] == 'Bays':
    maxStayDesc, noReturnDesc, timePeriodDesc = getBayRestrictionLabelText(NEW)
    #plpy.info('Bay label text: {} {} {}'.format(maxStayDesc, noReturnDesc, timePeriodDesc))

    if maxStayDesc is None and noReturnDesc is None and timePeriodDesc is None:
        # reset the leader
        plpy.info('resetting label position and leader for {}'.format(NEW["GeometryID"]))

        NEW["label_pos"], NEW["label_Rotation"] = ensure_labels_points(NEW["geom"], None, None)
        NEW["label_ldr"] = update_leader_lines(NEW["geom"], NEW["label_pos"])

        plan = plpy.prepare('SELECT ST_AsText($1::geometry) AS a, ST_AsText($2::geometry) As b', ['text', 'text'])
        results = plpy.execute(plan, [NEW["label_pos"], NEW["label_ldr"]])

        plpy.info('Revised positions: {} {} {}'.format(results[0]['a'], results[0]['b'], NEW["label_Rotation"]))

        return "MODIFY"

if TD["table_name"] == 'Lines':
    waitingDesc, loadingDesc = getWaitingLoadingRestrictionLabelText(NEW)
    #plpy.info('Line label text: {} {}'.format(waitingDesc, loadingDesc))

    if waitingDesc is None:
        # reset the leader
        plpy.info('resetting label position and leader for {}'.format(NEW["GeometryID"]))
        NEW["label_pos"], NEW["label_Rotation"] = ensure_labels_points(NEW["geom"], None, None)
        NEW["label_ldr"] = update_leader_lines(NEW["geom"], NEW["label_pos"])

    if loadingDesc is None:
        # reset the leader
        plpy.info('resetting loading label position and leader for {}'.format(NEW["GeometryID"]))
        NEW["label_loading_pos"], NEW["labelLoading_Rotation"] = ensure_labels_points(NEW["geom"], None, None)
        NEW["label_loading_ldr"] = update_leader_lines(NEW["geom"], NEW["label_loading_pos"])

    if waitingDesc is None and loadingDesc is None:
        return "MODIFY"

plpy.info('Preparing label leaders for {}'.format(NEW["GeometryID"]))
NEW["label_pos"], NEW["label_Rotation"] = ensure_labels_points(NEW["geom"], NEW["label_pos"], NEW["label_Rotation"])
NEW["label_ldr"] = update_leader_lines(NEW["geom"], NEW["label_pos"])

# check to see whether or not the label has moved. If so, set rotation to None

if OLD is not None:
    plan = plpy.prepare('SELECT ST_EQUALS($1::geometry,$2::geometry) as p', ['text', 'text'])

    try:
        leader_not_moved = plpy.execute(plan, [NEW["label_pos"], NEW["label_ldr"]])[0]['p']
    except Exception as e:
        plpy.info('Error checking if leader has moved: {})'.format(e))
        leader_not_moved = False

    if not leader_not_moved:
        NEW["label_Rotation"] = None
        plpy.info('Positions are not the same 1 ...')

# Logic for the loading label (only exists on table Lines)
if TD["table_name"] == 'Lines':
    plpy.info('Preparing loading label leaders for {}'.format(NEW["GeometryID"]))
    NEW["label_loading_pos"], NEW["labelLoading_Rotation"] = ensure_labels_points(NEW["geom"], NEW["label_loading_pos"], NEW["labelLoading_Rotation"])
    NEW["label_loading_ldr"] = update_leader_lines(NEW["geom"], NEW["label_loading_pos"])

    # check to see whether or not the label has moved. If so, set rotation to None
    if OLD is not None:

        plan = plpy.prepare('SELECT ST_EQUALS($1::geometry,$2::geometry) as p', ['text', 'text'])
        try:
            leader_not_moved = plpy.execute(plan, [NEW["label_loading_pos"], NEW["label_loading_ldr"]])[0]['p']
        except Exception as e:
            plpy.info('Error when checking if loading leader has moved: {})'.format(e))
            leader_not_moved = False

        if not leader_not_moved:
            NEW["labelLoading_Rotation"] = None

# this flag is required for the trigger to commit changes in NEW
return "MODIFY"

$$ LANGUAGE plpython3u;
