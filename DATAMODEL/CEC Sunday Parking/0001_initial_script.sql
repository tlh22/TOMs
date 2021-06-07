/*
INSERT INTO public."Bays"(
            "Length", "RestrictionTypeID", "NrBays", "TimePeriodID",
            "PayTypeID", "MaxStayID", "NoReturnID", "Notes",
            "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry",
            "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue",
            "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName",
            "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation",
            "label_TextChanged", "BayOrientation",
            "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017",
            "RestrictionID", geom)

SELECT DISTINCT ON (r."RestrictionID") "Length", "RestrictionTypeID", "NrBays",
       CASE
         WHEN "TimePeriodID" = 12 THEN 311
         WHEN "TimePeriodID" = 14 THEN 313
         WHEN "TimePeriodID" = 33 THEN 309
         WHEN "TimePeriodID" = 39 THEN 308
         WHEN "TimePeriodID" = 97 THEN 315
         WHEN "TimePeriodID" = 98 THEN 314
         WHEN "TimePeriodID" = 99 THEN 316
         WHEN "TimePeriodID" = 120 THEN 317
         WHEN "TimePeriodID" = 121 THEN 312
         WHEN "TimePeriodID" = 155 THEN 307
         WHEN "TimePeriodID" = 159 THEN 317
         WHEN "TimePeriodID" = 213 THEN 306
         WHEN "TimePeriodID" = 217 THEN 310
         --ELSE "TimePeriodID"
       END AS "TimePeriodID",
       "PayTypeID", "MaxStayID", "NoReturnID", "Notes",
       now(), "BaysWordingID", 'CPZ Sunday Changes 191011 - 1', "BaysGeometry",
       "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue",
       "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName",
       "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation",
       "label_TextChanged", "BayOrientation",
       r."CPZ", r."ParkingTariffArea", "OriginalGeomShapeID", r."RestrictionID",
       uuid_generate_v4(), r.geom
FROM "Bays" r, "ControlledParkingZones" c
WHERE c.zone_no IN ('1', '1A', '2', '3', '4')
AND ST_Within (r.geom, c.geom)
AND r."TimePeriodID" > 1
AND r."OpenDate" IS NOT NULL
AND r."CloseDate" IS NULL
AND r."TimePeriodID" NOT IN (225, 34, 242)
AND r."RestrictionID" NOT IN
(SELECT "RestrictionID" FROM "RestrictionsInProposals" WHERE "ProposalID" IN (SELECT "ProposalID" FROM "Proposals" WHERE "ProposalTitle" LIKE 'PAP%'));


INSERT INTO public."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance",
            "RestrictionID")
SELECT DISTINCT ON (r."RestrictionID") 118, 2, 2, r."RestrictionID"
FROM "Bays" r, "ControlledParkingZones" c
WHERE c.zone_no IN ('1', '1A', '2', '3', '4')
AND ST_Within (r.geom, c.geom)
AND r."TimePeriodID" > 1
AND r."OpenDate" IS NOT NULL
AND r."CloseDate" IS NULL
AND r."TimePeriodID" NOT IN (225, 34, 242)
AND r."RestrictionID" NOT IN
(SELECT "RestrictionID" FROM "RestrictionsInProposals" WHERE "ProposalID" IN (SELECT "ProposalID" FROM "Proposals" WHERE "ProposalTitle" LIKE 'PAP%'));
*/

INSERT INTO public."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance",
            "RestrictionID")
SELECT 118, 2, 1, r."RestrictionID"
FROM "Bays" r
WHERe "Surveyor" = 'CPZ Sunday Changes 191011 - 1'
AND date_trunc('day', "Bays_DateTime") = CURRENT_DATE;


/*
INSERT INTO public."Lines"(
            "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID",
            "Notes", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken",
            "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02",
            "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine",
            "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03",
            "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea",
            "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409",
            "GeometryID_181017", "RestrictionID", geom)

SELECT DISTINCT ON (r."RestrictionID") "Length", "RestrictionTypeID",
       CASE
         WHEN "NoWaitingTimeID" = 12 THEN 311
         WHEN "NoWaitingTimeID" = 14 THEN 313
         WHEN "NoWaitingTimeID" = 33 THEN 309
         WHEN "NoWaitingTimeID" = 39 THEN 308
         WHEN "NoWaitingTimeID" = 97 THEN 315
         WHEN "NoWaitingTimeID" = 98 THEN 314
         WHEN "NoWaitingTimeID" = 99 THEN 316
         WHEN "NoWaitingTimeID" = 120 THEN 317
         WHEN "NoWaitingTimeID" = 121 THEN 312
         WHEN "NoWaitingTimeID" = 155 THEN 307
         WHEN "NoWaitingTimeID" = 159 THEN 317
         WHEN "NoWaitingTimeID" = 213 THEN 306
         WHEN "NoWaitingTimeID" = 217 THEN 310
       END AS "NoWaitingTimeID",
       "NoLoadingTimeID",
       "Notes", now(), 'CPZ Sunday Changes 191011 - 1', "Lines_PhotoTaken",
       "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02",
       "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine",
       "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03",
       "Unacceptability", NULL, NULL, r."CPZ", r."ParkingTariffArea",
       "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409",
       r."RestrictionID", uuid_generate_v4(), r.geom

FROM "Lines" r, "ControlledParkingZones" c
WHERE c.zone_no IN ('1', '1A', '2', '3', '4')
AND ST_Within (r.geom, c.geom)
AND r."NoWaitingTimeID" > 1
AND r."NoWaitingTimeID" NOT IN (122, 96, 16)
AND r."RestrictionTypeID" NOT IN (15,16,17,18,19,20,21)
AND r."OpenDate" IS NOT NULL
AND r."CloseDate" IS NULL
AND r."RestrictionID" NOT IN
(SELECT "RestrictionID" FROM "RestrictionsInProposals" WHERE "ProposalID" IN (SELECT "ProposalID" FROM "Proposals" WHERE "ProposalTitle" LIKE 'PAP%'));



INSERT INTO public."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance",
            "RestrictionID")
SELECT DISTINCT ON (r."RestrictionID") 118, 3, 2, r."RestrictionID"

FROM "Lines" r, "ControlledParkingZones" c
WHERE c.zone_no IN ('1', '1A', '2', '3', '4')
AND ST_Within (r.geom, c.geom)
AND r."NoWaitingTimeID" > 1
AND r."NoWaitingTimeID" NOT IN (122, 96, 16)
AND r."RestrictionTypeID" NOT IN (15,16,17,18,19,20,21)
AND r."OpenDate" IS NOT NULL
AND r."CloseDate" IS NULL
AND r."RestrictionID" NOT IN
(SELECT "RestrictionID" FROM "RestrictionsInProposals" WHERE "ProposalID" IN (SELECT "ProposalID" FROM "Proposals" WHERE "ProposalTitle" LIKE 'PAP%'));
*/


INSERT INTO public."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance",
            "RestrictionID")
SELECT 118, 3, 1, r."RestrictionID"
FROM "Lines" r
WHERe "Surveyor" = 'CPZ Sunday Changes 191011 - 1'
AND date_trunc('day', "Lines_DateTime") = CURRENT_DATE;

INSERT INTO public."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance",
            "RestrictionID")
SELECT 118, 6, 2, "RestrictionID"
FROM "ControlledParkingZones" c
WHERE c.zone_no IN ('1', '1A', '2', '3', '4')
AND "OpenDate" IS NOT NULL
AND "CloseDate" IS NULL;

INSERT INTO public."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance",
            "RestrictionID")
SELECT 118, 6, 1, "RestrictionID"
FROM "ControlledParkingZones" c
WHERE "OpenDate" IS NULL
AND "CloseDate" IS NULL;

INSERT INTO public."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance",
            "RestrictionID")
SELECT 118, 7, 2, "RestrictionID"
FROM "ParkingTariffAreas" t
WHERE t.id IN (1,8,33,42,43,56,57,58,94)
AND "OpenDate" IS NOT NULL
AND "CloseDate" IS NULL;

INSERT INTO public."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance",
            "RestrictionID")
SELECT 118, 7, 1, "RestrictionID"
FROM "ParkingTariffAreas" t
WHERE "OpenDate" IS NULL
AND "CloseDate" IS NULL;



/*
 SELECT DISTINCT r."RestrictionID", "RestrictionTypeID", "TimePeriodID"
      *//* CASE
         WHEN "TimePeriodID" = 12 THEN 311
         WHEN "TimePeriodID" = 14 THEN 313
         WHEN "TimePeriodID" = 33 THEN 309
         WHEN "TimePeriodID" = 39 THEN 308
         WHEN "TimePeriodID" = 97 THEN 315
         WHEN "TimePeriodID" = 98 THEN 314
         WHEN "TimePeriodID" = 99 THEN 316
         WHEN "TimePeriodID" = 120 THEN 317
         WHEN "TimePeriodID" = 121 THEN 312
         WHEN "TimePeriodID" = 155 THEN 307
         WHEN "TimePeriodID" = 159 THEN 317
         WHEN "TimePeriodID" = 213 THEN 306
         WHEN "TimePeriodID" = 217 THEN 310
         --ELSE "TimePeriodID"
       END AS "TimePeriodID" *//*
FROM "ControlledParkingZones" c, "Bays" r
WHERE c.zone_no IN ('1', '1A', '2', '3', '4')
AND ST_Within (r.geom, c.geom)
AND r."TimePeriodID" > 1
AND r."TimePeriodID" NOT IN (225, 34, 242)
--AND "OpenDate" IS NOT NULL
--AND "CloseDate" IS NULL
AND r."RestrictionID" IN
(SELECT "RestrictionID" FROM "RestrictionsInProposals" WHERE "ProposalID" IN (SELECT "ProposalID" FROM "Proposals" WHERE "ProposalTitle" LIKE 'PAP%')
AND "ActionOnProposalAcceptance" = 1);
*/

UPDATE "Bays" As r
SET "TimePeriodID" =

 --SELECT DISTINCT r."RestrictionID", "Length", "RestrictionTypeID", "NrBays",
       CASE
         WHEN "TimePeriodID" = 12 THEN 311
         WHEN "TimePeriodID" = 14 THEN 313
         WHEN "TimePeriodID" = 33 THEN 309
         WHEN "TimePeriodID" = 39 THEN 308
         WHEN "TimePeriodID" = 97 THEN 315
         WHEN "TimePeriodID" = 98 THEN 314
         WHEN "TimePeriodID" = 99 THEN 316
         WHEN "TimePeriodID" = 120 THEN 317
         WHEN "TimePeriodID" = 121 THEN 312
         WHEN "TimePeriodID" = 155 THEN 307
         WHEN "TimePeriodID" = 159 THEN 317
         WHEN "TimePeriodID" = 213 THEN 306
         WHEN "TimePeriodID" = 217 THEN 310
       END --AS "TimePeriodID"

FROM "ControlledParkingZones" c--, "Bays" r
WHERE c.zone_no IN ('1', '1A', '2', '3', '4')
AND ST_Within (r.geom, c.geom)
AND r."TimePeriodID" > 1
AND r."TimePeriodID" NOT IN (225, 34, 242)
--AND "OpenDate" IS NOT NULL
--AND "CloseDate" IS NULL
AND "TimePeriodID" < 300
AND r."RestrictionID" IN
(SELECT "RestrictionID" FROM "RestrictionsInProposals" WHERE "ProposalID" IN (SELECT "ProposalID" FROM "Proposals" WHERE "ProposalTitle" LIKE 'PAP%')
AND "ActionOnProposalAcceptance" = 1)
--ORDER BY r."RestrictionID"
UPDATE "Lines" As r
SET "NoWaitingTimeID" =

 --SELECT DISTINCT r."RestrictionID", "RestrictionTypeID", "NoWaitingTimeID",
       CASE
         WHEN "NoWaitingTimeID" = 12 THEN 311
         WHEN "NoWaitingTimeID" = 14 THEN 313
         WHEN "NoWaitingTimeID" = 33 THEN 309
         WHEN "NoWaitingTimeID" = 39 THEN 308
         WHEN "NoWaitingTimeID" = 97 THEN 315
         WHEN "NoWaitingTimeID" = 98 THEN 314
         WHEN "NoWaitingTimeID" = 99 THEN 316
         WHEN "NoWaitingTimeID" = 120 THEN 317
         WHEN "NoWaitingTimeID" = 121 THEN 312
         WHEN "NoWaitingTimeID" = 155 THEN 307
         WHEN "NoWaitingTimeID" = 159 THEN 317
         WHEN "NoWaitingTimeID" = 213 THEN 306
         WHEN "NoWaitingTimeID" = 217 THEN 310
       END --AS "NoWaitingTimeID"

FROM "ControlledParkingZones" c--, "Lines" r
WHERE c.zone_no IN ('1', '1A', '2', '3', '4')
AND ST_Within (r.geom, c.geom)
AND r."NoWaitingTimeID" > 1
AND r."NoWaitingTimeID" NOT IN (122, 96, 16)
AND r."RestrictionTypeID" NOT IN (15,16,17,18,19,20,21)
AND r."OpenDate" IS NULL
AND r."CloseDate" IS NULL
AND "NoWaitingTimeID" < 300
AND r."RestrictionID" IN
(SELECT "RestrictionID" FROM "RestrictionsInProposals" WHERE "ProposalID" IN (SELECT "ProposalID" FROM "Proposals" WHERE "ProposalTitle" LIKE 'PAP%')
AND "ActionOnProposalAcceptance" = 1)
--ORDER BY "RestrictionID"
