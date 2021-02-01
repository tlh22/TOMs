ALTER TABLE toms."Bays" DISABLE TRIGGER all;
ALTER TABLE toms."Lines" DISABLE TRIGGER all;
ALTER TABLE toms."Signs" DISABLE TRIGGER all;
ALTER TABLE toms."RestrictionPolygons" DISABLE TRIGGER all;
ALTER TABLE toms."ControlledParkingZones" DISABLE TRIGGER all;

UPDATE toms."Bays"
SET "OpenDate" = TO_DATE('2021-01-01','YYYY-MM-DD'), "CloseDate" = NULL;

UPDATE toms."Lines"
SET "OpenDate" = TO_DATE('2021-01-01','YYYY-MM-DD'), "CloseDate" = NULL;

UPDATE toms."RestrictionPolygons"
SET "OpenDate" = TO_DATE('2021-01-01','YYYY-MM-DD'), "CloseDate" = NULL;

UPDATE toms."Signs"
SET "OpenDate" = TO_DATE('2021-01-01','YYYY-MM-DD'), "CloseDate" = NULL;

UPDATE toms."ControlledParkingZones"
SET "OpenDate" = TO_DATE('2021-01-01','YYYY-MM-DD'), "CloseDate" = NULL;

ALTER TABLE toms."Bays" ENABLE TRIGGER all;
ALTER TABLE toms."Lines" ENABLE TRIGGER all;
ALTER TABLE toms."Signs" ENABLE TRIGGER all;
ALTER TABLE toms."RestrictionPolygons" ENABLE TRIGGER all;
ALTER TABLE toms."ControlledParkingZones" ENABLE TRIGGER all;