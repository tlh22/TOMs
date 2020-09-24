--
-- PostgreSQL database dump
--

SET session_replication_role = replica;  -- Disable all triggers

update toms."Signs"
	SET original_geom_wkt= ST_AsText(geom);

SET session_replication_role = DEFAULT;  -- Enable all triggers