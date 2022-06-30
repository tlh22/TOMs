/*
realise that CPZ boundary extents into sheet 1455. This will need to have the same open date/revision number as any other sheets within the initial release
NB: will also need to check this for live systems
*/

UPDATE "toms"."MapGrid"
 SET "CurrRevisionNr"=1, "LastRevisionDate"='2020-05-01'
 WHERE id = 1455;

INSERT INTO "toms"."TilesInAcceptedProposals" ("ProposalID", "TileNr", "RevisionNr") VALUES (4, 1455, 1);

