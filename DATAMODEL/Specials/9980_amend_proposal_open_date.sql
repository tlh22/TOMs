/***
 * Change proposal open date after it has been accepted. Ensure all changes are within the same transaction
 ***/

CREATE OR REPLACE FUNCTION toms."change_proposal_open_date"(proposal_id integer,
                                                            new_proposal_open_date text) RETURNS boolean
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
   row RECORD;
   restriction_table_name text;
   field_to_update text;
   squery text;
BEGIN

    RAISE NOTICE '***** IN change_proposal_open_date: proposal_id(%); new_proposal_open_date (%)', proposal_id, new_proposal_open_date;

    ALTER TABLE toms."Proposals" DISABLE TRIGGER all;
    ALTER TABLE toms."Bays" DISABLE TRIGGER all;
    ALTER TABLE toms."Lines" DISABLE TRIGGER all;
    ALTER TABLE toms."Signs" DISABLE TRIGGER all;
    ALTER TABLE toms."RestrictionPolygons" DISABLE TRIGGER all;
    ALTER TABLE toms."ControlledParkingZones" DISABLE TRIGGER all;
    ALTER TABLE toms."ParkingTariffAreas" DISABLE TRIGGER all;
    ALTER TABLE toms."MatchDayEventDayZones" DISABLE TRIGGER all;
    ALTER TABLE toms."MapGrid" DISABLE TRIGGER all;

    -- First consider all the restrictions within the Proposal
    FOR row IN SELECT "RestrictionID", "RestrictionTableID", "ActionOnProposalAcceptance"
               FROM toms."RestrictionsInProposals"
               WHERE "ProposalID" = proposal_id
    LOOP

        SELECT "RestrictionLayerName"
        INTO restriction_table_name
	    FROM toms."RestrictionLayers"
	    WHERE "Code" = row."RestrictionTableID";

        IF row."ActionOnProposalAcceptance" = 1 THEN  -- Open
            field_to_update = 'OpenDate';
        ELSE
            field_to_update = 'CloseDate';
        END IF;

        squery = format('
        UPDATE toms."%1$s"
        SET "%2$s" = TO_DATE(''%3$s'', ''dd/mm/yyyy'')
        WHERE "RestrictionID" = ''%4$s''
        ', restriction_table_name, field_to_update, new_proposal_open_date, row."RestrictionID");

        RAISE NOTICE '***** IN change_proposal_open_date: squery (%)', squery;

        EXECUTE squery;

    END LOOP;

    -- Now consider the MapGrid entries
    FOR row IN SELECT "TileNr"
               FROM toms."TilesInAcceptedProposals"
               WHERE "ProposalID" = proposal_id
    LOOP

        RAISE NOTICE '***** IN change_proposal_open_date: considering tile (%)', row."TileNr";
        UPDATE toms."MapGrid"
        SET "LastRevisionDate" = TO_DATE(new_proposal_open_date, 'dd/mm/yyyy')
        WHERE "id" = row."TileNr"
        AND "LastRevisionDate" < TO_DATE(new_proposal_open_date, 'dd/mm/yyyy');

    END LOOP;

    -- Now, update Proposal
    UPDATE toms."Proposals"
    SET "ProposalOpenDate" = TO_DATE(new_proposal_open_date, 'dd/mm/yyyy')
    WHERE "ProposalID" = proposal_id;

    ALTER TABLE toms."Proposals" ENABLE TRIGGER all;
    ALTER TABLE toms."Bays" ENABLE TRIGGER all;
    ALTER TABLE toms."Lines" ENABLE TRIGGER all;
    ALTER TABLE toms."Signs" ENABLE TRIGGER all;
    ALTER TABLE toms."RestrictionPolygons" ENABLE TRIGGER all;
    ALTER TABLE toms."ControlledParkingZones" ENABLE TRIGGER all;
    ALTER TABLE toms."ParkingTariffAreas" ENABLE TRIGGER all;
    ALTER TABLE toms."MatchDayEventDayZones" ENABLE TRIGGER all;
    ALTER TABLE toms."MapGrid" ENABLE TRIGGER all;

    RETURN true;
/**
	exception
	   raise exception 'ERROR OCCURRED in change_proposal_open_date (%)', sqlstate;

	ALTER TABLE toms."Proposals" ENABLE TRIGGER all;
    ALTER TABLE toms."Bays" ENABLE TRIGGER all;
    ALTER TABLE toms."Lines" ENABLE TRIGGER all;
    ALTER TABLE toms."Signs" ENABLE TRIGGER all;
    ALTER TABLE toms."RestrictionPolygons" ENABLE TRIGGER all;
    ALTER TABLE toms."ControlledParkingZones" ENABLE TRIGGER all;
    ALTER TABLE toms."ParkingTariffAreas" ENABLE TRIGGER all;
    ALTER TABLE toms."MatchDayEventDayZones" ENABLE TRIGGER all;
    ALTER TABLE toms."MapGrid" ENABLE TRIGGER all;

    RETURN false;
**/

END;
$BODY$;

-- This is an example ...
--SELECT toms."change_proposal_open_date" (121, '02/02/2022')



