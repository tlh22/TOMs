

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

UPDATE "RestrictionPolygons"
SET "GeomShapeID" = 50
WHERE "GeomShapeID" IS NULL;

--
ALTER TABLE public."Signs"
    ADD COLUMN "Signs_Attachment" integer;
ALTER TABLE public."Signs"
    ADD COLUMN "Signs_Mount" integer;

INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (10, 10, 'Pole on bus shelter');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (11, 11, 'Pole');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (12, 12, 'Drain pipe');
INSERT INTO "public"."SignAttachmentTypes" ("id", "Code", "Description") VALUES (13, 13, 'Lamp post');

UPDATE "public"."Signs" SET "Signs_Attachment" = NULL WHERE "Signs_Attachment" = 14;

--INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (6, 6, 'Screws or Nails');
--INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (7, 7, 'Simple bar');

--UPDATE "public"."Signs" SET "Signs_Attachment" = NULL WHERE "Signs_Mount" = 0;

--INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (9, 9, 'To Be Confirmed 1');
--INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (10, 10, 'To Be Confirmed 2');
--INSERT INTO "public"."SignMountTypes" ("id", "Code", "Description") VALUES (11, 11, 'To Be Confirmed 3');

-- Tidy
DROP MATERIALIZED VIEW IF EXISTS public."SignTypes" CASCADE;

ALTER TABLE public."SignTypes2"
    RENAME TO "SignTypes";

DROP MATERIALIZED VIEW IF EXISTS public."BayTypes" CASCADE;
DROP MATERIALIZED VIEW IF EXISTS public."BayLineTypes" CASCADE;
DROP MATERIALIZED VIEW IF EXISTS public."LineTypes" CASCADE;
DROP MATERIALIZED VIEW IF EXISTS public."LookupView" CASCADE;
DROP MATERIALIZED VIEW IF EXISTS public."LookupView_TOMs" CASCADE;



