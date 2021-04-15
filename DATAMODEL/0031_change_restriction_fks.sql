-- Add constraints inherited from Restrictions

-- Restriction_SignIssueTypes

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "Restrictions_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "Restrictions_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "Restrictions_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "Restrictions_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "Restrictions_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "Restrictions_ComplianceRestrictionSignIssue_fkey" FOREIGN KEY ("ComplianceRestrictionSignIssue") REFERENCES "compliance_lookups"."Restriction_SignIssueTypes"("Code");

-- RestrictionRoadMarkingsFadedTypes

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "Restrictions_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "Restrictions_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "Restrictions_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "Restrictions_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "Restrictions_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "Restrictions_ComplianceRoadMarkingsFaded_fkey" FOREIGN KEY ("ComplianceRoadMarkingsFaded") REFERENCES "compliance_lookups"."RestrictionRoadMarkingsFadedTypes"("Code");

-- MHTC_CheckIssueTypes

ALTER TABLE ONLY "moving_traffic"."AccessRestrictions"
    ADD CONSTRAINT "Restrictions_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."CarriagewayMarkings"
    ADD CONSTRAINT "Restrictions_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."HighwayDedications"
    ADD CONSTRAINT "Restrictions_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."RestrictionsForVehicles"
    ADD CONSTRAINT "Restrictions_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."SpecialDesignations"
    ADD CONSTRAINT "Restrictions_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

ALTER TABLE ONLY "moving_traffic"."TurnRestrictions"
    ADD CONSTRAINT "Restrictions_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");
