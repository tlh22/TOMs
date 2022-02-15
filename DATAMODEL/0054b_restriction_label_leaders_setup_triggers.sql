/****
 * Set up triggers on tables
 ***/

DROP TRIGGER IF EXISTS insert_mngmt ON toms."Bays";
DROP TRIGGER IF EXISTS z_insert_mngmt ON toms."Bays";

CREATE TRIGGER z_insert_mngmt
    BEFORE INSERT OR UPDATE OF "TimePeriodID", "MaxStayID", "NoReturnID", "MatchDayTimePeriodID", "AdditionalConditionID", "PermitCode", "geom", "label_pos", "label_ldr"
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE FUNCTION toms.labelling_for_restrictions();

DROP TRIGGER IF EXISTS insert_mngmt ON toms."Lines";
DROP TRIGGER IF EXISTS z_insert_mngmt ON toms."Lines";

CREATE TRIGGER z_insert_mngmt
    BEFORE INSERT OR UPDATE OF "NoWaitingTimeID", "NoLoadingTimeID", "MatchDayTimePeriodID", "AdditionalConditionID", "geom", "label_pos", "label_ldr", "label_loading_pos", "label_loading_ldr"
    ON toms."Lines"
    FOR EACH ROW
    EXECUTE FUNCTION toms.labelling_for_restrictions();

/*"""*/
-- Run the trigger once to "repair" leaders

--- Bays
ALTER TABLE toms."Bays" DISABLE TRIGGER "set_last_update_details_bays";
ALTER TABLE toms."Bays" DISABLE TRIGGER "set_create_details_Bays";
ALTER TABLE toms."Bays" DISABLE TRIGGER "set_bay_geom_type_trigger";
ALTER TABLE toms."Bays" DISABLE TRIGGER "set_restriction_length_bays";
ALTER TABLE toms."Bays" DISABLE TRIGGER "set_restriction_length_Bays";
ALTER TABLE toms."Bays" DISABLE TRIGGER "update_capacity_bays";
ALTER TABLE toms."Bays" DISABLE TRIGGER "notify_qgis_edit";

UPDATE toms."Bays" SET label_pos = label_pos;

ALTER TABLE toms."Bays" ENABLE TRIGGER "set_last_update_details_bays";
ALTER TABLE toms."Bays" ENABLE TRIGGER "set_create_details_Bays";
ALTER TABLE toms."Bays" ENABLE TRIGGER "set_bay_geom_type_trigger";
ALTER TABLE toms."Bays" ENABLE TRIGGER "set_restriction_length_bays";
ALTER TABLE toms."Bays" ENABLE TRIGGER "set_restriction_length_Bays";
ALTER TABLE toms."Bays" ENABLE TRIGGER "update_capacity_bays";
ALTER TABLE toms."Bays" ENABLE TRIGGER "notify_qgis_edit";

--- Lines
ALTER TABLE toms."Lines" DISABLE TRIGGER "set_last_update_details_lines";
ALTER TABLE toms."Lines" DISABLE TRIGGER "set_create_details_Lines";
ALTER TABLE toms."Lines" DISABLE TRIGGER "set_crossing_geom_type_trigger";
ALTER TABLE toms."Lines" DISABLE TRIGGER "set_restriction_length_lines";
ALTER TABLE toms."Lines" DISABLE TRIGGER "set_restriction_length_Lines";
ALTER TABLE toms."Lines" DISABLE TRIGGER "update_capacity_lines";
ALTER TABLE toms."Lines" DISABLE TRIGGER "notify_qgis_edit";

UPDATE toms."Lines" SET label_pos = label_pos;

ALTER TABLE toms."Lines" ENABLE TRIGGER "set_last_update_details_lines";
ALTER TABLE toms."Lines" ENABLE TRIGGER "set_create_details_Lines";
ALTER TABLE toms."Lines" ENABLE TRIGGER "set_crossing_geom_type_trigger";
ALTER TABLE toms."Lines" ENABLE TRIGGER "set_restriction_length_lines";
ALTER TABLE toms."Lines" ENABLE TRIGGER "set_restriction_length_Lines";
ALTER TABLE toms."Lines" ENABLE TRIGGER "update_capacity_lines";
ALTER TABLE toms."Lines" ENABLE TRIGGER "notify_qgis_edit";

/*"""*/