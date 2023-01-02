/**
Tidy ...
**/

-- Add vehicleQualifiers
ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue" ADD VALUE 'Permit Holders';
ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue" ADD VALUE 'Taxis';

ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue" ADD VALUE 'Goods Vehicles Exceeding 18.5t';

ALTER TYPE "moving_traffic_lookups"."vehicleTypeValue" ADD VALUE 'Goods Vehicles Exceeding 5t';

