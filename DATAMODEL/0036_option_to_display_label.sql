/**
Adds field to TOMs restrictions to allow turn on/off of label. This avoid multiple labels/leaders being shown for the same restrictions that are in close proximity
**/

ALTER TABLE toms."Bays"
    ADD COLUMN "DisplayLabel" boolean DEFAULT TRUE NOT NULL;

ALTER TABLE toms."Lines"
    ADD COLUMN "DisplayLabel" boolean DEFAULT TRUE NOT NULL;

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "DisplayLabel" boolean DEFAULT TRUE NOT NULL;

ALTER TABLE toms."ControlledParkingZones"
    ADD COLUMN "DisplayLabel" boolean DEFAULT TRUE NOT NULL;

ALTER TABLE toms."ParkingTariffAreas"
    ADD COLUMN "DisplayLabel" boolean DEFAULT TRUE NOT NULL;

ALTER TABLE toms."MatchDayEventDayZones"
    ADD COLUMN "DisplayLabel" boolean DEFAULT TRUE NOT NULL;