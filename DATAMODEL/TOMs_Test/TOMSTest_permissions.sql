-- CREATE ROLE toms_admin NOLOGIN;
-- CREATE ROLE toms_operator NOLOGIN;
-- CREATE ROLE toms_public NOLOGIN;

--CREATE USER "joe.bloggs" WITH PASSWORD 'password';  -- change user_name / password
-- GRANT toms_operator TO "joe.bloggs"  -- can be one of the roles

REVOKE ALL ON ALL TABLES IN SCHEMA addresses FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA addresses TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA addresses TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA addresses TO toms_public, toms_operator, toms_admin;

REVOKE ALL ON ALL TABLES IN SCHEMA compliance FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA compliance TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA compliance TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA compliance TO toms_public, toms_operator, toms_admin;

REVOKE ALL ON ALL TABLES IN SCHEMA compliance_lookups FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA compliance_lookups TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA compliance_lookups TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA compliance_lookups TO toms_public, toms_operator, toms_admin;

REVOKE ALL ON ALL TABLES IN SCHEMA highways_network FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA highways_network TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA highways_network TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA highways_network TO toms_public, toms_operator, toms_admin;

REVOKE ALL ON ALL TABLES IN SCHEMA local_authority FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA local_authority TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA local_authority TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA local_authority TO toms_public, toms_operator, toms_admin;

REVOKE ALL ON ALL TABLES IN SCHEMA toms_lookups FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA toms_lookups TO toms_public, toms_operator, toms_admin;

REVOKE ALL ON ALL TABLES IN SCHEMA topography FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA topography TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA topography TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA topography TO toms_public, toms_operator, toms_admin;

--- TOMs main tables

REVOKE ALL ON ALL TABLES IN SCHEMA toms FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA toms TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA toms TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA toms TO toms_public, toms_operator, toms_admin;

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE toms."Bays" TO toms_operator, toms_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE toms."Lines" TO toms_operator, toms_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE toms."Signs" TO toms_operator, toms_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE toms."RestrictionPolygons" TO toms_operator, toms_admin;
GRANT SELECT, INSERT, DELETE ON TABLE toms."RestrictionsInProposals" TO toms_operator, toms_admin;
GRANT SELECT, UPDATE ON TABLE toms."MapGrid" TO toms_operator, toms_admin;
GRANT SELECT, INSERT ON TABLE toms."TilesInAcceptedProposals" TO toms_operator, toms_admin;
GRANT SELECT, INSERT, UPDATE ON TABLE toms."Proposals" TO toms_operator, toms_admin;

-- ALTER TABLE toms."Proposals" DISABLE ROW LEVEL SECURITY;
ALTER TABLE toms."Proposals" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "updateProposals" ON toms."Proposals";
DROP POLICY IF EXISTS "selectProposals" ON toms."Proposals";

CREATE POLICY "selectProposals" ON toms."Proposals"
    FOR SELECT
    USING (true);

CREATE POLICY "updateProposals" ON toms."Proposals"
    FOR UPDATE TO toms_operator
    USING (true)
    WITH CHECK ("ProposalStatusID" <> 2);

DROP POLICY IF EXISTS "insertProposals" ON toms."Proposals";
CREATE POLICY "insertProposals" ON toms."Proposals"
    FOR INSERT TO toms_operator
    WITH CHECK ("ProposalStatusID" <> 2);

DROP POLICY IF EXISTS "updateProposals_admin" ON toms."Proposals";

CREATE POLICY "updateProposals_admin" ON toms."Proposals"
    FOR UPDATE TO toms_admin
    USING (true);

DROP POLICY IF EXISTS "insertProposals_admin" ON toms."Proposals";

CREATE POLICY "insertProposals_admin" ON toms."Proposals"
    FOR INSERT TO toms_admin
    WITH CHECK ("ProposalStatusID" <> 2);
