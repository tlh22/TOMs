/***
 * Stop triggers on labels
 ***/

ALTER TABLE toms."Bays" DISABLE TRIGGER z_insert_mngmt;
ALTER TABLE toms."Lines" DISABLE TRIGGER z_insert_mngmt;
ALTER TABLE toms."RestrictionPolygons" DISABLE TRIGGER z_insert_mngmt;
ALTER TABLE toms."ControlledParkingZones" DISABLE TRIGGER z_insert_mngmt;
ALTER TABLE toms."ParkingTariffAreas" DISABLE TRIGGER z_insert_mngmt;
ALTER TABLE toms."MatchDayEventDayZones" DISABLE TRIGGER z_insert_mngmt;


