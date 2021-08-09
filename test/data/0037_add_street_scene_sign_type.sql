-- Add street scene sign type

INSERT INTO toms_lookups."SignTypes"(
	"Code", "Description")
	VALUES (9999, 'Street Scene');

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

-- Update sign name
UPDATE toms_lookups."SignTypes"
	SET "Description"='Zone - Permit Parking Zone (PPZ) (start)'
	WHERE "Code" = 40;