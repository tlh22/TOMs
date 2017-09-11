-- Table: public."RestrictionLayers"

-- DROP TABLE public."RestrictionLayers";

CREATE TABLE public."RestrictionLayers"
(
  id integer NOT NULL,
  "LayerName" character varying(255),
  CONSTRAINT "RestrictionLayers_pkey" PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public."RestrictionLayers"
  OWNER TO postgres;
