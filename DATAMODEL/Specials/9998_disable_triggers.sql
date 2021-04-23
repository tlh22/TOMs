ALTER TABLE toms."Bays" DISABLE TRIGGER all;
ALTER TABLE toms."Lines" DISABLE TRIGGER all;
ALTER TABLE toms."Signs" DISABLE TRIGGER all;
ALTER TABLE toms."RestrictionPolygons" DISABLE TRIGGER all;

-- moving traffic
ALTER TABLE moving_traffic."CarriagewayMarkings" DISABLE TRIGGER all;
ALTER TABLE moving_traffic."AccessRestrictions" DISABLE TRIGGER all;
ALTER TABLE moving_traffic."RestrictionsForVehicles" DISABLE TRIGGER all;
ALTER TABLE moving_traffic."TurnRestrictions" DISABLE TRIGGER all;
ALTER TABLE moving_traffic."HighwayDedications" DISABLE TRIGGER all;
ALTER TABLE moving_traffic."SpecialDesignations" DISABLE TRIGGER all;

-- Highway Assets
ALTER TABLE highway_assets."CrossingPoints" DISABLE TRIGGER all;
ALTER TABLE highway_assets."PedestrianRailings" DISABLE TRIGGER all;
ALTER TABLE highway_assets."TrafficCalming" DISABLE TRIGGER all;

-- ISL Assets
ALTER TABLE local_authority."ISL_Electrical_Items" DISABLE TRIGGER all;