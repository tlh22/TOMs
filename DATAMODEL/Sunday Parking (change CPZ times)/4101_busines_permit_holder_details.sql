/***
CEC request - Introduce business permit holder details and change EV bay title
****/

-- add Garage Services Parking Place
INSERT INTO toms_lookups."BayLineTypes"(
	"Code", "Description")
	VALUES (153, 'Garage Services Parking Place');   -- this is a type of business permit so need to think about how to deal with others

INSERT INTO toms_lookups."BayTypesInUse"(
	"Code", "GeomShapeGroupType")
	VALUES (153, 'Polygon');

-- change wording of EV bay to 'Electric Vehicle Charging Place’
UPDATE toms_lookups."BayLineTypes"
SET "Description" = 'Electric Vehicle Charging Place'
WHERE "Code" = 124;   -- is this likley to change for other local authorities. If so, need to think about how to customise ...

-- update view
REFRESH MATERIALIZED VIEW "toms_lookups"."BayTypesInUse_View";
