-- Add unique constaint for GeometryID to moving_traffic tables

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "AccessRestrictions_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "HighwayDedications_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "RestrictionsForVehicles_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "SpecialDesignations_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "TurnRestrictions_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "CarriagewayMarkings_GeometryID_key" UNIQUE ("GeometryID");

ALTER TABLE ONLY "highways_network"."MHTC_RoadLinks"
    ADD CONSTRAINT "MHTC_RoadLinks_GeometryID_key" UNIQUE ("GeometryID");

-- Change default details ...

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ALTER COLUMN "GeometryID" SET DEFAULT ('A_'::"text" || "to_char"("nextval"('"moving_traffic"."AccessRestrictions_id_seq"'::"regclass"), 'FM0000000'::"text"));

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ALTER COLUMN "GeometryID" SET DEFAULT ('H_'::"text" || "to_char"("nextval"('"moving_traffic"."HighwayDedications_id_seq"'::"regclass"), 'FM0000000'::"text"));

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ALTER COLUMN "GeometryID" SET DEFAULT ('R_'::"text" || "to_char"("nextval"('"moving_traffic"."RestrictionsForVehicles_id_seq"'::"regclass"), 'FM0000000'::"text"));

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ALTER COLUMN "GeometryID" SET DEFAULT ('D_'::"text" || "to_char"("nextval"('"moving_traffic"."SpecialDesignations_id_seq"'::"regclass"), 'FM0000000'::"text"));

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ALTER COLUMN "GeometryID" SET DEFAULT ('V_'::"text" || "to_char"("nextval"('"moving_traffic"."TurnRestrictions_id_seq"'::"regclass"), 'FM0000000'::"text"));

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ALTER COLUMN "GeometryID" SET DEFAULT ('M_'::"text" || "to_char"("nextval"('"moving_traffic"."CarriagewayMarkings_id_seq"'::"regclass"), 'FM0000000'::"text"));

ALTER TABLE ONLY "highways_network"."MHTC_RoadLinks"
    ALTER COLUMN "GeometryID" SET DEFAULT ('L_'::"text" || "to_char"("nextval"('"highways_network"."MHTC_RoadLinks_id_seq"'::"regclass"), 'FM0000000'::"text"));
