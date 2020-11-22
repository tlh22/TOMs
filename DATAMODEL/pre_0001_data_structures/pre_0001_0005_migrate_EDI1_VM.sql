-- road casement

INSERT INTO topography.road_casement (geom, "RoadName", "ESUID", "USRN", "Locality", "Town")
SELECT geom, "StreetName", "ESUID", "USRN", "Locality", "Town"
FROM
      (SELECT geom, "StreetName", "ESUID", "USRN", "Locality", "Town"
       FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=EDI1_VM user=postgres password=OS!2postgreS options=-csearch_path=',
		'SELECT geom, "ESUID", "USRN", "StreetName", "Locality", "Town"
	     FROM public."EDI_RC_with_USRN_StreetNames"') AS "EDI_RC_with_USRN_StreetNames" (geom geometry(LineString,27700),
	     "ESUID" double precision, "USRN" integer, "StreetName" character varying(254), "Locality" character varying(255), "Town" character varying(255))) AS t;

-- gazetteer

INSERT INTO local_authority."StreetGazetteerRecords"(
	geom, "ESUID", "USRN", "Custodian", "RoadName", "Locality", "Town", "Language", "StreetLength")
SELECT geom, "ESUID", "USRN", "Custodian", "StreetName", "Locality", "Town", "Language", "StreetLength"
FROM
      (SELECT geom, "ESUID", "USRN", "Custodian", "StreetName", "Locality", "Town", "Language", "StreetLength"
       FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=EDI1_VM user=postgres password=OS!2postgreS options=-csearch_path=',
		'SELECT geom, "ESUID", "USRN", "Custodian_", "Descriptor_", "Locality", "Town", "Language_", "Shape_Leng"
	     FROM public."StreetGazetteerRecords_171231_USRN"') AS "StreetGazetteerRecords_171231_USRN" (geom geometry(MultiLineString,27700),
	     "ESUID" double precision, "USRN" integer, "Custodian" integer, "StreetName" character varying(254), "Locality" character varying(255), "Town" character varying(255), "Language" character varying(255), "StreetLength" double precision)) AS t;

-- site area

INSERT INTO local_authority."SiteArea"(
	name, geom)
SELECT name, geom
FROM
      (SELECT name, geom
       FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=EDI1_VM user=postgres password=OS!2postgreS options=-csearch_path=',
		'SELECT name, geom
	     FROM public.city_of_edinburgh_area') AS "city_of_edinburgh_area" (
         name character varying(32),
         geom geometry(MultiPolygon,27700)
         ) ) As t;

-- itn_roadcentreline

INSERT INTO highways_network.itn_roadcentreline(
	toid, version, verdate, theme, descgroup, descterm,
	change, topoarea, nature, lnklength, node1, node1grade, node1gra_1, node2, node2grade, node2gra_1, shape_leng, geom)
SELECT toid, version, verdate, theme, descgroup, descterm,
       change, topoarea, nature, lnklength, node1, node1grade, node1gra_1, node2, node2grade, node2gra_1, shape_leng, geom
FROM
      (SELECT toid, version, verdate, theme, descgroup, descterm,
              change, topoarea, nature, lnklength, node1, node1grade, node1gra_1, node2, node2grade, node2gra_1, shape_leng, geom
       FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=EDI1_VM user=postgres password=OS!2postgreS options=-csearch_path=',
		'SELECT toid, version, verdate, theme, descgroup, descterm,
		change, topoarea, nature, lnklength, node1, node1grade, node1gra_1, node2, node2grade, node2gra_1, shape_leng, geom
	     FROM public.edi_itn_roadcentreline') AS "edi_itn_roadcentreline" (
    toid character varying(16),
    version integer,
    verdate date,
    theme character varying(80) ,
    descgroup character varying(150),
    descterm character varying(150),
    change character varying(80),
    topoarea character varying(20),
    nature character varying(80),
    lnklength double precision,
    node1 character varying(20),
    node1grade character varying(1),
    node1gra_1 integer,
    node2 character varying(20),
    node2grade character varying(1),
    node2gra_1 integer,
    shape_leng double precision,
    geom geometry(MultiLineString,27700)
         ) ) As t;

-- adopted roads

CREATE TABLE local_authority."AdoptedRoads" AS
SELECT id, geom, adoption_s, area_sq_m, confirmed, primary_ns, reinstatem, speed_limi, surface, type, width, "Shape_Length", "Shape_Area"

FROM
      (SELECT id, geom, adoption_s, area_sq_m, confirmed, primary_ns, reinstatem, speed_limi, surface, type, width, "Shape_Length", "Shape_Area"
       FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=EDI1_VM user=postgres password=OS!2postgreS options=-csearch_path=',
		'SELECT id, geom, adoption_s, area_sq_m, confirmed, primary_ns, reinstatem, speed_limi, surface, type, width, "Shape_Length", "Shape_Area"
	     FROM public."EDI_AdoptedRoads_2"') AS "EDI_AdoptedRoads_2" (
    id integer,
    geom geometry(Polygon,27700),
    adoption_s character varying(41),
    area_sq_m double precision,
    confirmed character varying(3),
    primary_ns character varying(50),
    reinstatem character varying(26),
    speed_limi character varying(14),
    surface character varying(24),
    type character varying(28),
    width double precision,
    "Shape_Length" double precision,
    "Shape_Area" double precision
    )) AS t;

ALTER TABLE local_authority."AdoptedRoads"
    ADD CONSTRAINT "cec_adoptedRoads_pkey" PRIMARY KEY ("id");

CREATE INDEX "sidx_cec_adoptedRoads_geom"
    ON local_authority."AdoptedRoads" USING gist
    (geom)
    TABLESPACE pg_default;

-- os mm text

CREATE TABLE topography.os_mastermap_topography_text_cec AS
SELECT toid, featcode, version, verdate, theme, change, descgroup, descterm, make, physlevel, physpres, text_, textfont, textpos, textheight, textangle, shape_leng, geom
FROM
    (SELECT toid, featcode, version, verdate, theme, change, descgroup, descterm, make, physlevel, physpres, text_, textfont, textpos, textheight, textangle, shape_leng, geom
	FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=EDI1_VM user=postgres password=OS!2postgreS options=-csearch_path=',
	'SELECT toid, featcode, version, verdate, theme, change, descgroup, descterm, make, physlevel, physpres, text_, textfont, textpos, textheight, textangle, shape_leng, geom
	FROM public.edi_cartotext') AS edi_cartotext (
    toid character varying(20),
    featcode integer,
    version integer,
    verdate character varying(24),
    theme character varying(80),
    change character varying(80),
    descgroup character varying(150),
    descterm character varying(150),
    make character varying(20),
    physlevel integer,
    physpres character varying(15),
    text_ character varying(250),
    textfont integer,
    textpos integer,
    textheight double precision,
    textangle double precision,
    shape_leng double precision,
    geom geometry(MultiLineString,27700)
    ) ) AS t;

ALTER TABLE topography.os_mastermap_topography_text_cec
    ADD CONSTRAINT "cec_cartoText_pkey" PRIMARY KEY ("toid");

CREATE INDEX "sidx_cec_cartoText_geom"
    ON topography.os_mastermap_topography_text_cec USING gist
    (geom)
    TABLESPACE pg_default;

-- rename table and delete previous

ALTER TABLE topography.os_mastermap_topography_text RENAME TO os_mastermap_topography_text_no_longer_required;
ALTER TABLE topography.os_mastermap_topography_text_cec RENAME TO os_mastermap_topography_text;

-- os mm

CREATE TABLE topography.os_mastermap_topography_polygons_cec_no_toid AS
SELECT gid, version, verdate, featcode, theme, calcarea, change, descgroup, descterm, make, physlevel, physpres, broken, shape_leng, shape_area, geom
FROM
    (SELECT gid, version, verdate, featcode, theme, calcarea, change, descgroup, descterm, make, physlevel, physpres, broken, shape_leng, shape_area, geom
	FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=EDI1_VM user=postgres password=OS!2postgreS options=-csearch_path=',
	'SELECT gid, version, verdate, featcode, theme, calcarea, change, descgroup, descterm, make, physlevel, physpres, broken, shape_leng, shape_area, geom
	FROM public.edi_mm WHERE toid IS NULL') AS edi_mm (
    gid integer,
    version integer,
    verdate character varying(24),
    featcode integer,
    theme character varying(80),
    calcarea double precision,
    change character varying(80),
    descgroup character varying(150),
    descterm character varying(150),
    make character varying(20),
    physlevel integer,
    physpres character varying(20),
    broken integer,
    shape_leng double precision,
    shape_area double precision,
    geom geometry(MultiPolygon,27700)
) ) AS t;

ALTER TABLE topography.os_mastermap_topography_polygons_cec_no_toid
    OWNER to postgres;

ALTER TABLE topography.os_mastermap_topography_polygons_cec_no_toid
    ADD CONSTRAINT "cec_mm_polys_no_toid_pkey" PRIMARY KEY ("gid");


CREATE TABLE topography.os_mastermap_topography_polygons_cec AS
SELECT toid, version, verdate, featcode, theme, calcarea, change, descgroup, descterm, make, physlevel, physpres, broken, shape_leng, shape_area, geom
FROM
    (SELECT toid, version, verdate, featcode, theme, calcarea, change, descgroup, descterm, make, physlevel, physpres, broken, shape_leng, shape_area, geom
	FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=EDI1_VM user=postgres password=OS!2postgreS options=-csearch_path=',
	'SELECT toid, version, verdate, featcode, theme, calcarea, change, descgroup, descterm, make, physlevel, physpres, broken, shape_leng, shape_area, geom
	FROM public.edi_mm WHERE toid IS NOT NULL') AS edi_mm (
    toid character varying(20),
    version integer,
    verdate character varying(24),
    featcode integer,
    theme character varying(80),
    calcarea double precision,
    change character varying(80),
    descgroup character varying(150),
    descterm character varying(150),
    make character varying(20),
    physlevel integer,
    physpres character varying(20),
    broken integer,
    shape_leng double precision,
    shape_area double precision,
    geom geometry(MultiPolygon,27700)
) ) AS t;

ALTER TABLE topography.os_mastermap_topography_polygons_cec
    OWNER to postgres;

ALTER TABLE topography.os_mastermap_topography_polygons_cec
    ADD CONSTRAINT "cec_mm_polys_pkey" PRIMARY KEY ("toid");

CREATE INDEX cec_mm_polys_geom_idx
    ON topography.os_mastermap_topography_polygons_cec USING gist
    (geom)
    TABLESPACE pg_default;

-- rename table and delete previous

ALTER TABLE topography.os_mastermap_topography_polygons RENAME TO os_mastermap_topography_polygons_no_longer_required;
ALTER TABLE topography.os_mastermap_topography_polygons_cec RENAME TO os_mastermap_topography_polygons;