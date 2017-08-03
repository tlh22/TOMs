-- Table: public."Signs"

-- DROP TABLE public."Signs";

CREATE TABLE public."Signs"
(
  id integer NOT NULL DEFAULT nextval('"Signs_id_seq"'::regclass),
  geometry geometry(Point,27700),
  "GeometryID" character varying,
  "Type_1" character varying,
  "Type_2" character varying,
  "Type_3" character varying,
  "Photos" character varying,
  CONSTRAINT "Signs_pkey" PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public."Signs"
  OWNER TO postgres;
