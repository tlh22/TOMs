-- Add street scene sign type

INSERT INTO toms_lookups."SignTypes"(
	"Code", "Description")
	VALUES (9999, 'Street Scene');

-- Add generic SRL type
INSERT INTO toms_lookups."BayLineTypes"(
	"Code", "Description")
	VALUES (226, 'No stopping (SRL)');