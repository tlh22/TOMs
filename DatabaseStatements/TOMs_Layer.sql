-- Table: public."TOMs_Layer"

-- DROP TABLE public."TOMs_Layer";

CREATE TABLE public."TOMs_Layer"
(
  id integer NOT NULL DEFAULT nextval('"TOMs_Layer2_id_seq"'::regclass),
  geom geometry(MultiLineString,27700),
  "GeometryID" character varying(254),
  "RestrictionTypeID" bigint,
  "CPZ" character varying(254),
  "TimePeriodID" bigint,
  "MaxStayID" bigint,
  "PayTypeID" bigint,
  "GeomTypeID" bigint,
  "RoadName" character varying(254),
  "Length" numeric,
  "EffectiveDate" character varying(254),
  "RescindDate" character varying(254),
  "RestrictionStatusID" bigint,
  "LengthFeat" numeric,
  shape_leng numeric,
  geometry_l numeric,
  "ChangeNotes" character varying(254),
  "NoReturnID" bigint,
  "Orientation" character varying(254),
  "AzimuthToRoadCentreLine" character varying(254),
  "ChangeDate" character varying(254),
  "USRN" character varying(254),
  CONSTRAINT "TOMs_Layer_pkey" PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public."TOMs_Layer"
  OWNER TO postgres;
