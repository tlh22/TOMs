/**
Add constraint so that tile/version is unique
**/

ALTER TABLE ONLY "toms"."TilesInAcceptedProposals"
    ADD CONSTRAINT "TilesInAcceptedProposals_unique_revision_nr_for_tile" UNIQUE ("TileNr", "RevisionNr");
