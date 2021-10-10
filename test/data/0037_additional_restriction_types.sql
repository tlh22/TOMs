-- Add street scene sign type

INSERT INTO toms_lookups."SignTypes"(
	"Code", "Description")
	VALUES (9999, 'Street Scene');

-- Update sign name
UPDATE toms_lookups."SignTypes"
	SET "Description"='Zone - Permit Parking Zone (PPZ) (start)'
	WHERE "Code" = 40;

-- Add generic SRL type
INSERT INTO toms_lookups."BayLineTypes"(
	"Code", "Description")
	VALUES (226, 'No stopping (SRL)');

INSERT INTO toms_lookups."BayLineTypes"(
	"Code", "Description")
	VALUES (227, 'Unmarked Area within PPZ (Acceptable)');

INSERT INTO toms_lookups."BayLineTypes"(
	"Code", "Description")
	VALUES (228, 'Unmarked Area within PPZ (Unacceptable)');

INSERT INTO toms_lookups."BayLineTypes"(
	"Code", "Description")
	VALUES (229, 'Unmarked Area within PPZ');

INSERT INTO toms_lookups."BayLineTypes"("Code", "Description") VALUES (147, 'Cycle Hangar');
INSERT INTO toms_lookups."BayLineTypes"("Code", "Description") VALUES (148, 'EV Charging Point (on carriageway)');
INSERT INTO toms_lookups."BayLineTypes"("Code", "Description") VALUES (149, 'Planter (on carriageway)');
INSERT INTO toms_lookups."BayLineTypes"("Code", "Description") VALUES (150, 'Parklet (on carriageway)');
INSERT INTO toms_lookups."BayLineTypes"("Code", "Description") VALUES (151, 'Market Trading Bay');
INSERT INTO toms_lookups."BayLineTypes"("Code", "Description") VALUES (152, 'Unmarked parking area');

--

INSERT INTO toms_lookups."BayLineTypes"("Code", "Description") VALUES (154, 'Unmarked parking area (within controlled area)');

INSERT INTO toms_lookups."BayTypesInUse"(
	"Code", "GeomShapeGroupType")
	VALUES (154, 'LineString');

INSERT INTO toms_lookups."BayLineTypes"("Code", "Description") VALUES (155, 'Red Route/Greenway - Electric Vehicle Charging Bay');

/**
Change Description on bay types for red routes to be "Red Route/Greenway - ..."
**/