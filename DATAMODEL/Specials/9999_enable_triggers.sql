ALTER TABLE toms."Bays" ENABLE TRIGGER all;
ALTER TABLE toms."Lines" ENABLE TRIGGER all;
ALTER TABLE toms."Signs" ENABLE TRIGGER all;
ALTER TABLE toms."RestrictionPolygons" ENABLE TRIGGER all;

-- moving traffic
ALTER TABLE moving_traffic."CarriagewayMarkings" ENABLE TRIGGER all;
ALTER TABLE moving_traffic."AccessRestrictions" ENABLE TRIGGER all;
ALTER TABLE moving_traffic."RestrictionsForVehicles" ENABLE TRIGGER all;
ALTER TABLE moving_traffic."TurnRestrictions" ENABLE TRIGGER all;
ALTER TABLE moving_traffic."HighwayDedications" ENABLE TRIGGER all;
ALTER TABLE moving_traffic."SpecialDesignations" ENABLE TRIGGER all;

-- Highway Assets
ALTER TABLE highway_assets."CrossingPoints" ENABLE TRIGGER all;
ALTER TABLE highway_assets."PedestrianRailings" ENABLE TRIGGER all;
ALTER TABLE highway_assets."TrafficCalming" ENABLE TRIGGER all;

-- ISL Assets
ALTER TABLE local_authority."ISL_Electrical_Items" ENABLE TRIGGER all;