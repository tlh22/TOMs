CREATE ROLE toms_admin NOLOGIN;
CREATE ROLE toms_operator NOLOGIN;
CREATE ROLE toms_public NOLOGIN;
CREATE USER "toms.test" WITH PASSWORD 'password';
GRANT toms_public TO "toms.test";
