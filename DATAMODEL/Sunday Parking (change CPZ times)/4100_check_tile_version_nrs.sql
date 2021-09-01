/***
List of all tiles and their latest version numbers
***/

SELECT m.id, m."CurrRevisionNr", m."LastRevisionDate", p."ProposalID", TiP."TileNr", TiP."RevisionNr"
FROM toms."MapGrid" m, toms."TilesInAcceptedProposals" TiP, toms."Proposals" p
WHERE m.id = TiP."TileNr"
AND TiP."ProposalID" = p."ProposalID"
AND TiP."TileNr" = m."id"
ORDER BY m.id, m."CurrRevisionNr", p."ProposalID"

-- Find any changes on the same date that are using different revision numbers

SELECT TiP_1."TileNr", TiP_1."RevisionNr", TiP_1."ProposalOpenDate", TiP_2."TileNr", TiP_2."RevisionNr", TiP_2."ProposalOpenDate"
FROM (
SELECT TiP."TileNr", TiP."RevisionNr", p."ProposalID", p."ProposalTitle", p."ProposalOpenDate"
FROM toms."TilesInAcceptedProposals" TiP, toms."Proposals" p
WHERE TiP."ProposalID" = p."ProposalID"
ORDER BY TiP."TileNr", TiP."RevisionNr", p."ProposalID"
) AS TiP_1,
(
SELECT TiP."TileNr", TiP."RevisionNr", p."ProposalID", p."ProposalTitle", p."ProposalOpenDate"
FROM toms."TilesInAcceptedProposals" TiP, toms."Proposals" p
WHERE TiP."ProposalID" = p."ProposalID"
ORDER BY TiP."TileNr", TiP."RevisionNr", p."ProposalID"
) AS TiP_2
WHERE TiP_1."TileNr" = TiP_2."TileNr"
AND TiP_1."ProposalOpenDate" = TiP_2."ProposalOpenDate"
AND TiP_1."RevisionNr" <> TiP_2."RevisionNr"

-- deal with incorrect changes ...
UPDATE toms."MapGrid"
SET m."CurrRevisionNr" = 3
WHERE id = 1276;

UPDATE toms."TilesInAcceptedProposals"
SET "RevisionNr" = 3
WHERE "TileNr" = 1276
AND "RevisionNr" = 4;