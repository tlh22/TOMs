/***
List of all tiles and their version numbers
***/

SELECT m.id, m."CurrRevisionNr", m."LastRevisionDate", p."ProposalTitle",  p."ProposalID",  p."ProposalOpenDate", TiP."RevisionNr"
FROM toms."MapGrid" m, toms."TilesInAcceptedProposals" TiP, toms."Proposals" p
WHERE m.id = TiP."TileNr"
AND TiP."ProposalID" = p."ProposalID"
AND TiP."TileNr" = m."id"
ORDER BY m.id, TiP."RevisionNr", p."ProposalTitle"


-- Find any changes on the same date that are using different version numbers

SELECT TiP_1."TileNr", TiP_1."ProposalID", TiP_1."RevisionNr", TiP_1."ProposalOpenDate", TiP_2."ProposalID", TiP_2."RevisionNr", TiP_2."ProposalOpenDate"
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
AND TiP_1."RevisionNr" < TiP_2."RevisionNr"
ORDER BY TiP_1."TileNr", TiP_1."RevisionNr", TiP_1."ProposalID"


-- Find any changes for different proposals that are using the same version number on different dates

SELECT TiP_1."TileNr", TiP_1."RevisionNr", TiP_1."ProposalOpenDate", TiP_1."ProposalID", TiP_1."ProposalTitle", TiP_2."ProposalOpenDate", TiP_2."ProposalID", TiP_2."ProposalTitle"
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
AND TiP_1."ProposalOpenDate" < TiP_2."ProposalOpenDate"
AND TiP_1."ProposalID" <> TiP_2."ProposalID"
AND TiP_1."RevisionNr" = TiP_2."RevisionNr"
ORDER BY TiP_1."TileNr"


-- Check that the latest version nr within MapGrid matches the last version in TilesWithinAcceptedProposals

DO
$do$
DECLARE
    tiles RECORD;
    proposalID INTEGER = 0;
	revisionNr INTEGER;
	proposalOpenDate DATE;
	proposalTitle TEXT;
BEGIN

    FOR tiles IN
        SELECT m.id, m."CurrRevisionNr", m."LastRevisionDate"
        FROM toms."MapGrid" m
        ORDER BY m.id
    LOOP

        SELECT p."ProposalID", p."ProposalTitle", p."ProposalOpenDate", TiP."RevisionNr"
		INTO proposalID, proposalTitle, proposalOpenDate, revisionNr
        FROM toms."Proposals" p, toms."TilesInAcceptedProposals" TiP
        WHERE tiles.id = TiP."TileNr"
        AND TiP."ProposalID" = p."ProposalID"
        ORDER BY TiP."RevisionNr" desc
        LIMIT 1;

		IF tiles."CurrRevisionNr" <> revisionNr THEN

			raise notice 'Tile % -  has different revision nrs - % vs %. Last update from Proposal % (%)', tiles.id, tiles."CurrRevisionNr", revisionNr, proposalID, proposalTitle;

		END IF;

    END LOOP;

END;
$do$;


-- Check that version numbers are sequential in date order for a given tile
-- https://stackoverflow.com/questions/12444142/postgresql-how-to-figure-out-missing-numbers-in-a-column-using-generate-series

DO
$do$
DECLARE
    tiles RECORD;
    revision_nrs RECORD;
    max_revision_nr INTEGER;
    missing_evisionNr INTEGER;
BEGIN

    FOR tiles IN
        SELECT m.id, m."CurrRevisionNr", m."LastRevisionDate"
        FROM toms."MapGrid" m
        ORDER BY m.id
    LOOP

        SELECT TiP."RevisionNr"
		INTO max_revision_nr
        FROM toms."Proposals" p, toms."TilesInAcceptedProposals" TiP
        WHERE tiles.id = TiP."TileNr"
        AND TiP."ProposalID" = p."ProposalID"
        ORDER BY TiP."RevisionNr" desc
        LIMIT 1;

        FOR revision_nrs IN
            SELECT s.i AS missing_revision_nr
            FROM generate_series(1, max_revision_nr) s(i)
            WHERE NOT EXISTS (SELECT 1
                              FROM (SELECT TiP."RevisionNr" AS revision_nr
                                    FROM toms."Proposals" p, toms."TilesInAcceptedProposals" TiP
                                    WHERE tiles.id = TiP."TileNr"
                                    AND TiP."ProposalID" = p."ProposalID"
                                    --ORDER BY TiP."RevisionNr" desc
                                    ) a
                              WHERE revision_nr = s.i)
        LOOP

			raise notice 'Tile % -  is missing revision nr %', tiles.id, revision_nrs.missing_revision_nr;

        END LOOP;

    END LOOP;

END;
$do$;
