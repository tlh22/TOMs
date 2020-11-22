/*
Types that are either are not to be used in future:
(5, 'Pedestrian Area - occasional')
Types that we are not yet sure how to introduce
(20, 'Controlled Parking Zone')
(22, 'Parking Tariff Area')
*/

DELETE FROM "toms_lookups"."RestrictionPolygonTypesInUse"
WHERE "Code" IN (5, 20, 22);
