-- schemas

DROP schema IF EXISTS "Background" CASCADE;
DROP schema IF EXISTS "quarantine" CASCADE;
DROP schema IF EXISTS "transfer" CASCADE;

-- views

DROP MATERIALIZED VIEW IF EXISTS public."BayLineTypes";
DROP MATERIALIZED VIEW IF EXISTS public."BayTypes";
DROP MATERIALIZED VIEW IF EXISTS public."LineTypes";
DROP MATERIALIZED VIEW IF EXISTS public."LookupView";
DROP MATERIALIZED VIEW IF EXISTS public."LookupView_TOMs";
DROP MATERIALIZED VIEW IF EXISTS public."SignTypes";

-- tables

DROP TABLE IF EXISTS public."ActionOnProposalAcceptanceTypes";
DROP TABLE IF EXISTS public."BayLineTypesInUse";
DROP TABLE IF EXISTS public."Bays";
DROP TABLE IF EXISTS public."Bays_orig";
DROP TABLE IF EXISTS public."CPZs";
DROP TABLE IF EXISTS public."Corners_Single";
DROP TABLE IF EXISTS public."GNSS_Pts_200205";
DROP TABLE IF EXISTS public."Grid";
DROP TABLE IF EXISTS public."Lines";
DROP TABLE IF EXISTS public."Lines_orig";
DROP TABLE IF EXISTS public."ParkingTariffAreas";
DROP TABLE IF EXISTS public."RC_Polygons";
DROP TABLE IF EXISTS public."RC_Polyline";
DROP TABLE IF EXISTS public."RestrictionPolygons";
DROP TABLE IF EXISTS public."RestrictionShapeTypes";
DROP TABLE IF EXISTS public."RestrictionStatus";
DROP TABLE IF EXISTS public."RoadCentreLine";
DROP TABLE IF EXISTS public."SignTypesInUse";
DROP TABLE IF EXISTS public."Signs";
DROP TABLE IF EXISTS public."Supply";
DROP TABLE IF EXISTS public."ThreeRiversAreas";
DROP TABLE IF EXISTS public."ThreeRiversDistrict_RoadLinkPossible";
DROP TABLE IF EXISTS public."ThreeRiversPossibleStreets_2";
DROP TABLE IF EXISTS public."ThreeRiversDistrict_RoadLinkPossible";

DROP TABLE IF EXISTS public."ProposalStatusTypes";
DROP TABLE IF EXISTS public."StreetsList";

ALTER TABLE "public"."RC_Sections_merged" SET SCHEMA mhtc_operations;

DROP TABLE IF EXISTS public."Proposals";
DROP TABLE IF EXISTS public."RestrictionLayers";
DROP TABLE IF EXISTS public."RestrictionsInProposals";
DROP TABLE IF EXISTS public."TilesInAcceptedProposals";


