CREATE ROLE toms_admin NOLOGIN;
CREATE ROLE toms_operator NOLOGIN;
CREATE ROLE toms_public NOLOGIN;
CREATE USER "toms.public" WITH PASSWORD 'password';
GRANT toms_public TO "toms.public";
CREATE USER "toms.operator" WITH PASSWORD 'password';
GRANT toms_operator TO "toms.operator";
CREATE USER "toms.admin" WITH PASSWORD 'password';
GRANT toms_admin TO "toms.admin";


/*
-- Show users (https://www.postgresqltutorial.com/postgresql-list-users/)
SELECT usename AS role_name,
  CASE
     WHEN usesuper AND usecreatedb THEN
	   CAST('superuser, create database' AS pg_catalog.text)
     WHEN usesuper THEN
	    CAST('superuser' AS pg_catalog.text)
     WHEN usecreatedb THEN
	    CAST('create database' AS pg_catalog.text)
     ELSE
	    CAST('' AS pg_catalog.text)
  END role_attributes
FROM pg_catalog.pg_user
ORDER BY role_name desc;
*/
