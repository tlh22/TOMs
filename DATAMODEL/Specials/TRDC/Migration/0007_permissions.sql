-- deal with any "new" permissions

REVOKE ALL ON ALL TABLES IN SCHEMA highways_network FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA highways_network TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA highways_network TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA highways_network TO toms_public, toms_operator, toms_admin;

REVOKE ALL ON ALL TABLES IN SCHEMA local_authority FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA local_authority TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA local_authority TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA local_authority TO toms_public, toms_operator, toms_admin;

REVOKE ALL ON ALL TABLES IN SCHEMA topography FROM toms_public, toms_operator, toms_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA topography TO toms_public, toms_operator, toms_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA topography TO toms_public, toms_operator, toms_admin;
GRANT USAGE ON SCHEMA topography TO toms_public, toms_operator, toms_admin;

-- old permissions

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

GRANT toms_public TO "test.public"