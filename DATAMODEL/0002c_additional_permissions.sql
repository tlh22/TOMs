DROP TRIGGER IF EXISTS "create_geometryid_controlled_parking_zones" ON "toms"."ControlledParkingZones";
CREATE TRIGGER "create_geometryid_controlled_parking_zones" BEFORE INSERT ON "toms"."ControlledParkingZones" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();

DROP TRIGGER IF EXISTS "create_geometryid_parking_tariff_areas" ON "toms"."ParkingTariffAreas";
CREATE TRIGGER "create_geometryid_parking_tariff_areas" BEFORE INSERT ON "toms"."ParkingTariffAreas" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE toms."ControlledParkingZones" TO toms_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE toms."ParkingTariffAreas" TO toms_admin;