--
--INSERT INTO topography.road_casement (geom, "RoadName", "ESUID", "USRN", "Locality", "Town", "Az"))
SELECT geom, "StreetName", "ESUID", "USRN", "Locality", "Town"
FROM
      (SELECT geom, "StreetName", "ESUID", "USRN", "Locality", "Town"
       FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=EDI_VM1 user=postgres password=OS!2postgres options=-csearch_path=',
		'SELECT geom, "StreetName", "ESUID", "USRN", "Locality", "Town"
	     FROM public."EDI_RC_with_USRN_StreetNames"') AS "EDI_RC_with_USRN_StreetNames" (geom geometry(LineString,27700), "ESUID" double precision, "USRN" integer, "StreetName" character varying(254), "Locality" character varying(255), "Town" character varying(255))) AS t

