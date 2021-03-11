ALTER TABLE toms."Bays" DISABLE TRIGGER all;
ALTER TABLE toms."Lines" DISABLE TRIGGER all;
ALTER TABLE toms."Signs" DISABLE TRIGGER all;
ALTER TABLE toms."RestrictionPolygons" DISABLE TRIGGER all;

ALTER TABLE highway_assets."CrossingPoints" DISABLE TRIGGER all;
ALTER TABLE highway_assets."PedestrianRailings" DISABLE TRIGGER all;
ALTER TABLE highway_assets."TrafficCalming" DISABLE TRIGGER all;