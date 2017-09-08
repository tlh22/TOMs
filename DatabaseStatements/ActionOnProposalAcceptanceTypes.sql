-- Table: public."ActionOnProposalAcceptanceTypes"

-- DROP TABLE public."ActionOnProposalAcceptanceTypes";

CREATE TABLE public."ActionOnProposalAcceptanceTypes"
(
  id integer NOT NULL DEFAULT nextval('"ActionOnProposalAcceptanceTypes_id_seq"'::regclass),
  "Description" character varying,
  CONSTRAINT "ActionOnProposalAcceptanceTypes_pkey" PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public."ActionOnProposalAcceptanceTypes"
  OWNER TO postgres;
