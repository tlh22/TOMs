/***
Deal with mapgrid version numbers

Find tiles that intersect CPZ but which were not included for Proposal - and add

***/

-- find those for which no changes have subsequently occurred

--- *** CPZ 1A
DO
$do$
DECLARE
    tiles_in_accepted_proposals_details RECORD;
    proposal_id INTEGER = 44;
BEGIN

    -- ** Tidy proposals
    FOR tiles_in_accepted_proposals_details IN
        SELECT DISTINCT id, "CurrRevisionNr", "LastRevisionDate"
        FROM toms."MapGrid" m, toms."ControlledParkingZones" c
        WHERE ST_Intersects(m.geom, c.geom)
        AND c."CPZ" IN ('1A')
        AND id NOT IN
        (
        SELECT DISTINCT "TileNr"
            FROM toms."TilesInAcceptedProposals"
        WHERE "ProposalID" IN (proposal_id)
        ORDER BY "TileNr" )
    LOOP

        IF tiles_in_accepted_proposals_details."LastRevisionDate" < '2020-11-09' THEN

            RAISE NOTICE 'New *****--- Adding map tile (%) to tilesInAcceptedProposals for proposal %', tiles_in_accepted_proposals_details.id, proposal_id;
            RAISE NOTICE 'New *****--- new RevisionNr %; date: %', tiles_in_accepted_proposals_details."CurrRevisionNr"+1, tiles_in_accepted_proposals_details."LastRevisionDate";
            -- We can add without complications
            INSERT INTO toms."TilesInAcceptedProposals"(
                "ProposalID", "TileNr", "RevisionNr")
            VALUES (proposal_id, tiles_in_accepted_proposals_details.id, tiles_in_accepted_proposals_details."CurrRevisionNr"+1);

            -- Update revision nr
            UPDATE toms."MapGrid"
	        SET "CurrRevisionNr"=tiles_in_accepted_proposals_details."CurrRevisionNr"+1,
	            "LastRevisionDate"= '2020-11-09'
	        WHERE id = tiles_in_accepted_proposals_details.id;

        ELSIF tiles_in_accepted_proposals_details."LastRevisionDate" = '2020-11-09' THEN

            RAISE NOTICE '*****--- Adding map tile (%) to tilesInAcceptedProposals for proposal %', tiles_in_accepted_proposals_details.id, proposal_id;
            RAISE NOTICE '*****--- curr RevisionNr %; date: %', tiles_in_accepted_proposals_details."CurrRevisionNr", tiles_in_accepted_proposals_details."LastRevisionDate";
            -- We can add without complications
            INSERT INTO toms."TilesInAcceptedProposals"(
                "ProposalID", "TileNr", "RevisionNr")
            VALUES (proposal_id, tiles_in_accepted_proposals_details.id, tiles_in_accepted_proposals_details."CurrRevisionNr");

        ELSE

            RAISE NOTICE '*****--- Manual intervention required for map tile (%) to add to tilesInAcceptedProposals for proposal %', tiles_in_accepted_proposals_details.id, proposal_id;

        END IF;

    END LOOP;

END;
$do$;
