ALTER TABLE public."Bays" DROP CONSTRAINT "Bays_RestrictionTypeID_fkey";
ALTER TABLE public."Lines" DROP CONSTRAINT "Lines_RestrictionTypeID_fkey";

UPDATE public."Bays" r
SET "RestrictionTypeID" = cast(t."CurrCode" AS int)
FROM "LookupCodeTransfers_Bays" t
WHERE r."RestrictionTypeID" = cast(t."Aug2018_Code" AS int);

UPDATE public."Lines" r
SET "RestrictionTypeID" = cast(t."CurrCode" AS int)
FROM "LookupCodeTransfers_Lines" t
WHERE r."RestrictionTypeID" = cast(t."Aug2018_Code" AS int);

ALTER TABLE public."Bays" ADD CONSTRAINT "Bays_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID")
        REFERENCES public."BayLineTypesInUse" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE public."Lines" ADD CONSTRAINT "Lines_RestrictionTypeID_fkey" FOREIGN KEY ("RestrictionTypeID")
        REFERENCES public."BayLineTypesInUse" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

UPDATE public."Bays"
SET "Length" = ROUND(ST_Length ("geom")::numeric,2);

UPDATE public."Lines"
SET "Length" = ROUND(ST_Length ("geom")::numeric,2);

-- Not sure how these are still here ...

UPDATE "Bays"
SET "NrBays" = -1
WHERE "NrBays" IS NULL;

UPDATE "Bays"
SET "TimePeriodID" = 0
WHERE "TimePeriodID" IS NULL;

UPDATE "Lines"
SET "NoWaitingTimeID" = 0
WHERE "NoWaitingTimeID" IS NULL;

--- !!!! remove duplicate RestrictionIDs
DELETE FROM
    "Bays" a -- , "Lines" b
        USING "Bays" b
WHERE
    a."GeometryID" < b."GeometryID"
    AND a."RestrictionID" = b."RestrictionID";

DELETE FROM
    "Lines" a -- , "Lines" b
        USING "Lines" b
WHERE
    a."GeometryID" < b."GeometryID"
    AND a."RestrictionID" = b."RestrictionID";

---

INSERT INTO "public"."RestrictionPolygonTypes" ("Code", "Description") VALUES (20, 'Controlled Parking Zone');
INSERT INTO "public"."RestrictionPolygonTypes" ("Code", "Description") VALUES (7, 'Lorry waiting restriction zone');
INSERT INTO "public"."RestrictionPolygonTypes" ("Code", "Description") VALUES (8, 'Half-on/Half-off prohbited zone');
INSERT INTO "public"."RestrictionPolygonTypes" ("Code", "Description") VALUES (22, 'Parking Tariff Area');
INSERT INTO "public"."RestrictionPolygonTypes" ("Code", "Description") VALUES (21, 'Priority Parking Area');

--
UPDATE "Lines"
SET "Unacceptability" = NULL;

UPDATE "Lines" SET "GeomShapeID" = 10 WHERE "GeomShapeID" IS NULL;

--

INSERT INTO "public"."RestrictionShapeTypes" ("Code", "Description") VALUES (27, 'Other');
INSERT INTO "public"."RestrictionShapeTypes" ("Code", "Description") VALUES (35, 'Dropped Kerb (Crossover)');
INSERT INTO "public"."RestrictionShapeTypes" ("Code", "Description") VALUES (50, 'Polygon');

UPDATE "RestrictionPolygons"
SET "GeomShapeID" = 50
WHERE "GeomShapeID" IS NULL;

DELETE FROM "Signs"
WHERE "geom" IS NULL;

INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (10, 10, 'Pole on bus shelter');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (11, 11, 'Pole');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (12, 12, 'Drain pipe');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (13, 13, 'Lamp post');

UPDATE "public"."Signs" SET "Signs_Attachment" = NULL WHERE "Signs_Attachment" = 14;

--INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (6, 6, 'Screws or Nails');
--INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (7, 7, 'Simple bar');

UPDATE "public"."Signs" SET "Signs_Attachment" = NULL WHERE "Signs_Attachment" = 14;

INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (9, 9, 'To Be Confirmed 1');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (10, 10, 'To Be Confirmed 2');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (11, 11, 'To Be Confirmed 3');

-- Deal with rows without RestrictionTypeID

CREATE TABLE public."Bays_NoRestrictionID" AS
SELECT id, geom, "Length", "RestrictionTypeID", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "Notes", "GeometryID", "Bays_DateTime", "BaysWordingID", "Surveyor", "BaysGeometry", "Bays_PhotoTaken", "Compl_Bays_Faded", "Compl_Bays_SignIssue", "Bays_Photos_01", "Bays_Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "OriginalGeomShapeID", "GeometryID_181017", "RestrictionID"
	FROM public."Bays"
	WHERE "RestrictionTypeID" IS NULL;

DELETE FROM public."Bays"
	WHERE "RestrictionTypeID" IS NULL;

CREATE TABLE public."Lines_NoRestrictionID" AS
SELECT id, geom, "Length", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "GeometryID", "Lines_DateTime", "Surveyor", "Lines_PhotoTaken", "Lines_Photos_01", "Compl_Lines_Faded", "Compl_NoL_Faded", "Lines_Photos_02", "Compl_Lines_SignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine", "GeomShapeID", "labelX", "labelY", "labelRotation", "Lines_Photos_03", "Unacceptability", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoadingX", "labelLoadingY", "labelLoadingRotation", "TRO_Status_180409", "GeometryID_181017", "RestrictionID"
	FROM public."Lines"
	WHERE "RestrictionTypeID" IS NULL;

DELETE FROM public."Lines"
	WHERE "RestrictionTypeID" IS NULL;