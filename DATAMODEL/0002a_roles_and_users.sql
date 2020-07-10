CREATE ROLE toms_admin NOLOGIN;
CREATE ROLE toms_operator NOLOGIN;
CREATE ROLE toms_public NOLOGIN;
CREATE USER "toms.public" WITH PASSWORD 'password';
GRANT toms_public TO "toms.public";
CREATE USER "toms.operator" WITH PASSWORD 'password';
GRANT toms_operator TO "toms.operator";
CREATE USER "toms.admin" WITH PASSWORD 'password';
GRANT toms_admin TO "toms.admin";
