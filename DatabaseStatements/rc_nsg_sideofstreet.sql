-- Table: public.rc_nsg_sideofstreet

-- DROP TABLE public.rc_nsg_sideofstreet;

CREATE TABLE public.rc_nsg_sideofstreet
(
  gid integer NOT NULL DEFAULT nextval('pak_nsg_rc_sideofstreet_gid_seq'::regclass),
  objectid numeric(10,0),
  "ESUID" numeric,
  "SideOfStreet" character varying(254),
  "USRN" numeric,
  "SWA_Org_Reg_Naming" numeric,
  "State" numeric,
  "Street_Surface" numeric,
  "Street_Classification" numeric,
  "Street_Descriptor" character varying(254),
  "Locality_Name" character varying(254),
  "Town_Name" character varying(254),
  "Administrative_Area" character varying(254),
  shape_leng numeric,
  geom geometry(MultiLineString),
  CONSTRAINT pak_nsg_rc_sideofstreet_pkey PRIMARY KEY (gid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.rc_nsg_sideofstreet
  OWNER TO postgres;

-- Index: public.pak_nsg_rc_sideofstreet_geom_idx

-- DROP INDEX public.pak_nsg_rc_sideofstreet_geom_idx;

CREATE INDEX pak_nsg_rc_sideofstreet_geom_idx
  ON public.rc_nsg_sideofstreet
  USING gist
  (geom);

