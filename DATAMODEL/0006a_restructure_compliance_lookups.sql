 ALTER TABLE compliance_lookups."BaysLinesFadedTypes"
    RENAME TO "RestrictionRoadMarkingsFadedTypes";

ALTER TABLE compliance_lookups."BaysLines_SignIssueTypes"
    RENAME TO "Restriction_SignIssueTypes";

ALTER TABLE compliance_lookups."MHTC_CheckIssueType"
    RENAME TO "MHTC_CheckIssueTypes";

-- Restructure compliance_lookups."SignAttachmentTypes" - remove id
ALTER TABLE compliance_lookups."SignAttachmentTypes" DROP COLUMN id;
ALTER TABLE compliance_lookups."SignAttachmentTypes"
    ADD PRIMARY KEY ("Code");

CREATE SEQUENCE compliance_lookups."SignAttachmentTypes_Code_seq"
    INCREMENT 1
    START 10
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE compliance_lookups."SignAttachmentTypes_Code_seq"
    OWNER TO postgres;

ALTER TABLE compliance_lookups."SignAttachmentTypes"
    ALTER COLUMN "Code" SET DEFAULT nextval('compliance_lookups."SignAttachmentTypes_Code_seq"'::regclass);

-- Allow admin to update details in LOOKUPs

REVOKE ALL ON ALL TABLES IN SCHEMA compliance_lookups FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA compliance_lookups TO toms_public, toms_operator;
GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA compliance_lookups TO toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA compliance_lookups TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA compliance_lookups TO toms_public, toms_operator, toms_admin;



