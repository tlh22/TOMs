/*
-- set up triggers to update labels
-- https://kartoza.com/en/blog/using-pgnotify-to-automatically-refresh-layers-in-qgis/

*/

CREATE FUNCTION public.notify_qgis() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN NOTIFY qgis;
        RETURN NULL;
        END;
    $$;

CREATE TRIGGER notify_qgis_edit
  AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON toms."Bays"
    FOR EACH STATEMENT EXECUTE PROCEDURE public.notify_qgis();

CREATE TRIGGER notify_qgis_edit
  AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON toms."Lines"
    FOR EACH STATEMENT EXECUTE PROCEDURE public.notify_qgis();

CREATE TRIGGER notify_qgis_edit
  AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON toms."RestrictionPolygons"
    FOR EACH STATEMENT EXECUTE PROCEDURE public.notify_qgis();

CREATE TRIGGER notify_qgis_edit
  AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON toms."ControlledParkingZones"
    FOR EACH STATEMENT EXECUTE PROCEDURE public.notify_qgis();

CREATE TRIGGER notify_qgis_edit
  AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON toms."ParkingTariffAreas"
    FOR EACH STATEMENT EXECUTE PROCEDURE public.notify_qgis();

CREATE TRIGGER notify_qgis_edit
  AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON toms."MatchDayEventDayZones"
    FOR EACH STATEMENT EXECUTE PROCEDURE public.notify_qgis();