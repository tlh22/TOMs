/**
Create master lookup tables within a new database - and then lik into TOMs db via foreign data wrapper
**/

-- add extension
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- create new database on a different server ??
CREATE SERVER app_database_server
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'postgres.example.com', dbname 'my_app');

-- create user mapping

CREATE USER MAPPING FOR CURRENT_USER
  SERVER app_database_server
  OPTIONS (user 'reporting', password 'secret123');

-- create schema/tables on the new db

