-- Details for advanced stop line

ALTER TYPE "moving_traffic_lookups"."specialDesignationTypeValue" ADD VALUE 'Advanced Stop Line' BEFORE 'Signal controlled cycle crossing';

ALTER TYPE "moving_traffic_lookups"."cycleFacilityValue" ADD VALUE 'ASL - without approach or gate' BEFORE 'Advisory Cycle Lane Along Road';
ALTER TYPE "moving_traffic_lookups"."cycleFacilityValue" ADD VALUE 'ASL - with gate' BEFORE 'Advisory Cycle Lane Along Road';
ALTER TYPE "moving_traffic_lookups"."cycleFacilityValue" ADD VALUE 'ASL - with approach' BEFORE 'Advisory Cycle Lane Along Road';
