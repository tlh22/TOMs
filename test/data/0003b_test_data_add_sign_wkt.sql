--
-- PostgreSQL database dump
--

update toms."Signs"
	SET original_geom_wkt= ST_AsText(geom);