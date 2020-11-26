- add attachment types to relevant tables

ALTER TABLE "highway_assets"."Bins"
    ADD COLUMN "AttachmentTypeID" integer;
ALTER TABLE ONLY "highway_assets"."Bins"
    ADD CONSTRAINT "Bins_AttachmentTypes_fkey" FOREIGN KEY ("AttachmentTypeID") REFERENCES compliance_lookups."SignAttachmentTypes"("Code");

ALTER TABLE "highway_assets"."CycleParking"
    ADD COLUMN "AttachmentTypeID" integer;
ALTER TABLE ONLY "highway_assets"."CycleParking"
    ADD CONSTRAINT "CycleParking_AttachmentTypes_fkey" FOREIGN KEY ("AttachmentTypeID") REFERENCES compliance_lookups."SignAttachmentTypes"("Code");

-- Correct this constraint (if required)
ALTER TABLE ONLY "highway_assets"."StreetNamePlates"
    DROP CONSTRAINT IF EXISTS "StreetNamePlates_SignsAttachmentTypes_fkey";
ALTER TABLE ONLY "highway_assets"."StreetNamePlates"
    ADD CONSTRAINT "StreetNamePlates_SignsAttachmentTypes_fkey" FOREIGN KEY ("StreetNamePlateAttachmentTypeID") REFERENCES compliance_lookups."SignAttachmentTypes"("Code");
