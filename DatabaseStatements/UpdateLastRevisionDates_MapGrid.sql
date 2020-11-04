-- Need to make sure the last revision date is the open date from the last proposal ...

CREATE OR REPLACE FUNCTION get_last_update_date(tileNr in int) RETURNS date
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	currLastRevisionDate date;
	thisProposal int;
	thisRevisionNr int;
	thisProposalOpenDate date;
BEGIN

	SELECT "LastRevisionDate" FROM "MapGrid" WHERE "id" = tileNr INTO currLastRevisionDate;

	SELECT "ProposalID", "RevisionNr"
		FROM public."TilesInAcceptedProposals"
    WHERE "TileNr" = tileNr
    ORDER BY "RevisionNr" Desc
    LIMIT 1
    INTO thisProposal, thisRevisionNr;

    SELECT "ProposalOpenDate"
    FROM "Proposals"
    WHERE "ProposalID" = thisProposal
    INTO thisProposalOpenDate;

    IF currLastRevisionDate <> thisProposalOpenDate THEN
        currLastRevisionDate := thisProposalOpenDate;
    END IF;

    RETURN currLastRevisionDate;

END;
$$;

--

UPDATE "MapGrid"
SET "LastRevisionDate" = get_last_update_date(id::int)
WHERE "LastRevisionDate" <> get_last_update_date(id::int);