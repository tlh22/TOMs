/***
 * Tidy triggers - consistent naming and use of relevant fields
 ***/

-- Bays

DROP TRIGGER IF EXISTS "set_create_details_Bays" ON toms."Bays";
DROP TRIGGER IF EXISTS "set_create_details_bays" ON toms."Bays";
CREATE TRIGGER "set_create_details_bays"
    BEFORE INSERT
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_create_details();

DROP TRIGGER IF EXISTS "set_last_update_details_Bays" ON toms."Bays";
DROP TRIGGER IF EXISTS "set_last_update_details_bays" ON toms."Bays";
CREATE TRIGGER "set_last_update_details_bays"
    BEFORE INSERT OR UPDATE
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE FUNCTION public.set_last_update_details();

DROP TRIGGER IF EXISTS "set_label_display_default_Bays" ON toms."Bays";
DROP TRIGGER IF EXISTS "set_label_display_default_bays" ON toms."Bays";
CREATE TRIGGER "set_label_display_default_bays"
    BEFORE INSERT
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE FUNCTION toms.set_label_display_default();

DROP TRIGGER IF EXISTS "set_bay_geom_type_trigger" ON toms."Bays";
DROP TRIGGER IF EXISTS "set_geom_type_bays" ON toms."Bays";
CREATE TRIGGER "set_geom_type_bays"
    BEFORE INSERT OR UPDATE OF geom, "GeomShapeID"
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_bay_geom_type();

DROP TRIGGER IF EXISTS "set_restriction_length_Bays" ON toms."Bays";
DROP TRIGGER IF EXISTS "set_restriction_length_bays" ON toms."Bays";
CREATE TRIGGER "set_restriction_length_bays"
    BEFORE INSERT OR UPDATE OF geom
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_restriction_length();

DROP TRIGGER IF EXISTS "update_capacity_bays" ON toms."Bays";
CREATE TRIGGER "update_capacity_bays"
    BEFORE INSERT OR UPDATE OF geom, "NrBays", "GeomShapeID", "RestrictionTypeID"
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE PROCEDURE public.update_capacity();

--Lines

DROP TRIGGER IF EXISTS "set_create_details_Lines" ON toms."Lines";
DROP TRIGGER IF EXISTS "set_create_details_lines" ON toms."Lines";
CREATE TRIGGER "set_create_details_lines"
    BEFORE INSERT
    ON toms."Lines"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_create_details();

DROP TRIGGER IF EXISTS "set_last_update_details_Lines" ON toms."Lines";
DROP TRIGGER IF EXISTS "set_last_update_details_lines" ON toms."Lines";
CREATE TRIGGER "set_last_update_details_lines"
    BEFORE INSERT OR UPDATE
    ON toms."Lines"
    FOR EACH ROW
    EXECUTE FUNCTION public.set_last_update_details();

DROP TRIGGER IF EXISTS "set_label_display_default_Lines" ON toms."Lines";
DROP TRIGGER IF EXISTS "set_label_display_default_lines" ON toms."Lines";
CREATE TRIGGER "set_label_display_default_lines"
    BEFORE INSERT
    ON toms."Lines"
    FOR EACH ROW
    EXECUTE FUNCTION toms.set_label_display_default();

DROP TRIGGER IF EXISTS "set_restriction_length_Lines" ON toms."Lines";
DROP TRIGGER IF EXISTS "set_restriction_length_lines" ON toms."Lines";
CREATE TRIGGER "set_restriction_length_lines"
    BEFORE INSERT OR UPDATE OF geom
    ON toms."Lines"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_restriction_length();

DROP TRIGGER IF EXISTS "update_capacity_lines" ON toms."Lines";
CREATE TRIGGER "update_capacity_lines"
    BEFORE INSERT OR UPDATE OF geom, "GeomShapeID", "RestrictionTypeID"
    ON toms."Lines"
    FOR EACH ROW
    EXECUTE PROCEDURE public.update_capacity();

DROP TRIGGER IF EXISTS "set_crossing_geom_type_trigger" ON toms."Lines";
DROP TRIGGER IF EXISTS "set_geom_type_crossings" ON toms."Lines";
CREATE TRIGGER "set_geom_type_crossings"
    BEFORE INSERT OR UPDATE OF geom, "GeomShapeID"
    ON toms."Lines"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_crossing_geom_type();

