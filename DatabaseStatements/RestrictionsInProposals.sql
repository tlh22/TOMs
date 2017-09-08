-- Table: public."RestrictionsInProposals"

-- DROP TABLE public."RestrictionsInProposals";

CREATE TABLE public."RestrictionsInProposals"
(
  "ProposalID" integer NOT NULL,
  "RestrictionTableID" integer NOT NULL,
  "ActionOnProposalAcceptance" integer,
  "RestrictionID" character varying(255)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public."RestrictionsInProposals"
  OWNER TO postgres;
