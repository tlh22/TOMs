/***
 * Stop triggers on labels
 ***/

ALTER TABLE toms."Bays" ENABLE TRIGGER z_insert_mngmt;
ALTER TABLE toms."Lines" ENABLE TRIGGER z_insert_mngmt;
ALTER TABLE toms."RestrictionPolygons" ENABLE TRIGGER insert_mngmt;
ALTER TABLE toms."ControlledParkingZones" ENABLE TRIGGER insert_mngmt;
ALTER TABLE toms."ParkingTariffAreas" ENABLE TRIGGER insert_mngmt;
ALTER TABLE toms."MatchDayEventDayZones" ENABLE TRIGGER insert_mngmt;


