-- Change accept date

DO
$do$
DECLARE
    relevant_restriction RECORD;
    proposal_id INTEGER = 131;
    proposal_open_date DATE = '2021-09-20';
BEGIN

    RAISE NOTICE '*****--- Updating date for Proposal (%) to %', proposal_id, proposal_open_date;

    -- Update Proposals
    UPDATE toms."Proposals"
    SET "ProposalOpenDate" = proposal_open_date
    WHERE "ProposalID" = proposal_id;

    -- Update Mapgrid
    UPDATE toms."MapGrid"
    SET "LastRevisionDate" = proposal_open_date
    WHERE "id" IN (SELECT "TileNr"
                   FROM toms."TilesInAcceptedProposals"
                   WHERE "ProposalID" = proposal_id);

    -- restrictions
    FOR relevant_restriction IN
        SELECT "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID"
        FROM toms."RestrictionsInProposals"
        WHERE "ProposalID" = proposal_id
    LOOP

        RAISE NOTICE '*****--- Considering (%)', relevant_restriction."RestrictionID";

        IF relevant_restriction."RestrictionTableID" = 2 THEN  --Bays
            IF relevant_restriction."ActionOnProposalAcceptance" = 1 THEN  -- Open
                UPDATE toms."Bays" AS r
                SET "OpenDate" = proposal_open_date
                WHERE "RestrictionID" = relevant_restriction."RestrictionID";
            ELSE
                UPDATE toms."Bays" AS r
                SET "CloseDate" = proposal_open_date
                WHERE "RestrictionID" = relevant_restriction."RestrictionID";
            END IF;

        ELSIF relevant_restriction."RestrictionTableID" = 3 THEN -- Lines
            IF relevant_restriction."ActionOnProposalAcceptance" = 1 THEN  -- Open
                UPDATE toms."Lines" AS r
                SET "OpenDate" = proposal_open_date
                WHERE "RestrictionID" = relevant_restriction."RestrictionID";
            ELSE
                UPDATE toms."Lines" AS r
                SET "CloseDate" = proposal_open_date
                WHERE "RestrictionID" = relevant_restriction."RestrictionID";
            END IF;

        ELSIF relevant_restriction."RestrictionTableID" = 4 THEN -- Signs
            IF relevant_restriction."ActionOnProposalAcceptance" = 1 THEN  -- Open
                UPDATE toms."Signs" AS r
                SET "OpenDate" = proposal_open_date
                WHERE "RestrictionID" = relevant_restriction."RestrictionID";
            ELSE
                UPDATE toms."Signs" AS r
                SET "CloseDate" = proposal_open_date
                WHERE "RestrictionID" = relevant_restriction."RestrictionID";
            END IF;

        ELSIF relevant_restriction."RestrictionTableID" = 5 THEN -- RestrictionPolygons
            IF relevant_restriction."ActionOnProposalAcceptance" = 1 THEN  -- Open
                UPDATE toms."RestrictionPolygons" AS r
                SET "OpenDate" = proposal_open_date
                WHERE "RestrictionID" = relevant_restriction."RestrictionID";
            ELSE
                UPDATE toms."RestrictionPolygons" AS r
                SET "CloseDate" = proposal_open_date
                WHERE "RestrictionID" = relevant_restriction."RestrictionID";
            END IF;

        ELSIF relevant_restriction."RestrictionTableID" = 6 THEN -- CPZs
            IF relevant_restriction."ActionOnProposalAcceptance" = 1 THEN  -- Open
                UPDATE toms."ControlledParkingZones" AS r
                SET "OpenDate" = proposal_open_date
                WHERE "RestrictionID" = relevant_restriction."RestrictionID";
            ELSE
                UPDATE toms."ControlledParkingZones" AS r
                SET "CloseDate" = proposal_open_date
                WHERE "RestrictionID" = relevant_restriction."RestrictionID";
            END IF;

        ELSIF relevant_restriction."RestrictionTableID" = 7 THEN -- PTAs
            IF relevant_restriction."ActionOnProposalAcceptance" = 1 THEN  -- Open
                UPDATE toms."ParkingTariffAreas" AS r
                SET "OpenDate" = proposal_open_date
                WHERE "RestrictionID" = relevant_restriction."RestrictionID";
            ELSE
                UPDATE toms."ParkingTariffAreas" AS r
                SET "CloseDate" = proposal_open_date
                WHERE "RestrictionID" = relevant_restriction."RestrictionID";
            END IF;

         END IF;

    END LOOP;

END;
$do$;

-- Deal with any map tiles that should have been added
INSERT INTO toms."TilesInAcceptedProposals"(
	"ProposalID", "TileNr", "RevisionNr")
	VALUES (162, 1341, 3);

UPDATE toms."MapGrid"
    SET "LastRevisionDate" = '2021-09-27', "CurrRevisionNr" = 3
    WHERE "id" = 1341;

