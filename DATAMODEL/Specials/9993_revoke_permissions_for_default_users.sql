-- Set up connection privileges

REVOKE connect ON DATABASE "TOMs_Test" FROM PUBLIC;

GRANT connect ON DATABASE "TOMs_Test" TO toms_public, toms_operator, toms_admin;

REVOKE connect ON DATABASE "TOMs_Test" FROM "toms.admin";
