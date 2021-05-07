/**
schema and tables ...

**/

-- details in "toms" schema of source database should be backed up and restored to "migrate" schema in target database

--CREATE SCHEMA "migrate";
--ALTER SCHEMA "migrate" OWNER TO "postgres";


CREATE TABLE migrate."ProposalsToMigrate"
(
    "ProposalTitle" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "ProposalsToMigrate_pkey" PRIMARY KEY ("ProposalTitle")
);

ALTER TABLE migrate."ProposalsToMigrate"
    OWNER to postgres;

-- Now populate
INSERT INTO migrate."ProposalsToMigrate"("ProposalTitle") VALUES ('Zone N6');
INSERT INTO migrate."ProposalsToMigrate"("ProposalTitle") VALUES ('Zone N7');
INSERT INTO migrate."ProposalsToMigrate"("ProposalTitle") VALUES ('Zone N8');
INSERT INTO migrate."ProposalsToMigrate"("ProposalTitle") VALUES ('Zone S5');
INSERT INTO migrate."ProposalsToMigrate"("ProposalTitle") VALUES ('Zone S6');
INSERT INTO migrate."ProposalsToMigrate"("ProposalTitle") VALUES ('Zone S7');


