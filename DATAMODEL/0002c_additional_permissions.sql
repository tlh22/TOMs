CREATE TRIGGER "create_geometryid_bays" BEFORE INSERT ON "toms"."ControlledParkingZones" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();
CREATE TRIGGER "create_geometryid_bays" BEFORE INSERT ON "toms"."ParkingTariffAreas" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE toms."ControlledParkingZones" TO toms_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE toms."ParkingTariffAreas" TO toms_admin;