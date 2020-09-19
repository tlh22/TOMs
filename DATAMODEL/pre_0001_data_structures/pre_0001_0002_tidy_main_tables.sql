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
DELETE FROM "Bays"
WHERE "RestrictionTypeID" IS NULL;

DELETE FROM "Lines"
WHERE "RestrictionTypeID" IS NULL;

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

INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (6, 6, 'Screws or Nails');
INSERT INTO "compliance_lookups"."SignMountTypes" ("id", "Code", "Description") VALUES (7, 7, 'Simple bar');

UPDATE "public"."Signs" SET "Signs_Attachment" = NULL WHERE "Signs_Attachment" = 14;

INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (9, 9, 'To Be Confirmed 1');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (10, 10, 'To Be Confirmed 2');
INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (11, 11, 'To Be Confirmed 3');

