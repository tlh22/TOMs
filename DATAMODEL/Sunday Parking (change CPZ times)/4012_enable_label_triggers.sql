/***
 * Stop triggers on labels
 ***/

ALTER TABLE toms."Bays" ENABLE TRIGGER z_insert_mngmt;
ALTER TABLE toms."Lines" ENABLE TRIGGER z_insert_mngmt;
ALTER TABLE toms."RestrictionPolygons" ENABLE TRIGGER z_insert_mngmt;
ALTER TABLE toms."ControlledParkingZones" ENABLE TRIGGER z_insert_mngmt;
ALTER TABLE toms."ParkingTariffAreas" ENABLE TRIGGER z_insert_mngmt;
ALTER TABLE toms."MatchDayEventDayZones" ENABLE TRIGGER z_insert_mngmt;


