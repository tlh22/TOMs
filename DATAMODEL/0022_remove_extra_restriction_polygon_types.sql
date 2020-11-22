/*
Types that are either are not to be used in future:
(5, 'Pedestrian Area - occasional')
Types that we are not yet sure how to introduce
(20, 'Controlled Parking Zone')
(22, 'Parking Tariff Area')
*/

ALTER TABLE ONLY "toms"."ControlledParkingZones"
    DROP CONSTRAINT "ControlledParkingZones_RestrictionTypeID_fkey";

ALTER TABLE ONLY "toms"."ParkingTariffAreas"
    DROP CONSTRAINT "ParkingTariffAreas_RestrictionTypeID_fkey";

