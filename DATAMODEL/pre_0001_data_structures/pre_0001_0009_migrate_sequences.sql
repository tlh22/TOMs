/**
Include sequences ...
**/

-- Bays
SELECT setval('toms."Bays_id_seq"', (SELECT last_value FROM public."Bays2_id_seq"), TRUE); -- 78959

-- Lines
SELECT setval('toms."Lines_id_seq"', (SELECT last_value FROM public."Lines2_id_seq"), TRUE); -- 153218

-- Signs
SELECT setval('toms."Signs_id_seq"', (SELECT last_value FROM public."EDI01_Signs_id_seq"), TRUE);  -- 56899

-- RestrictionPolygons
SELECT setval('toms."RestrictionPolygons_id_seq"', (SELECT last_value FROM public."restrictionPolygons_seq"), TRUE); -- 970

-- CPZs
SELECT setval('toms."ControlledParkingZones_id_seq"', (SELECT last_value FROM public."controlledparkingzones_gid_seq"), TRUE); -- 38

-- PTAs
SELECT setval('toms."ParkingTariffAreas_id_seq"', (SELECT last_value FROM public."PTAs_180725_merged_10_id_seq"), TRUE);  -- 109

-- Proposals
SELECT setval('toms."Proposals_id_seq"', (SELECT last_value FROM public."Proposals_id_seq"), TRUE); -- 200
