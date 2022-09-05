/***
 * Change proposal open date after it has been accepted. Ensure all changes are within the same transaction
 ***/


CREATE OR REPLACE FUNCTION toms."get_restriction_id_from_geometry_id"(geometry_id text) RETURNS TEXT
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
   row RECORD;
   restriction_id TEXT;
BEGIN

    FOR row IN SELECT "RestrictionLayerName", "Code"
               FROM toms."RestrictionLayers"
               WHERE "Code" < 100
               ORDER BY "Code"
    LOOP

        RAISE NOTICE '***** IN remove_restriction_from_proposal: checking (%)', row."RestrictionLayerName";

        EXECUTE FORMAT ('SELECT "RestrictionID"::text FROM toms.%I '
                       'WHERE "GeometryID" = %L', row."RestrictionLayerName", geometry_id)
                       INTO restriction_id ;

        IF LENGTH (restriction_id) > 0 THEN
            RAISE NOTICE '***** IN remove_restriction_from_proposal: restriction_id (%) found for geometry_ID (%) in table %.', restriction_id, geometry_id, row."RestrictionLayerName";
            EXIT;
        END IF;

    END LOOP;

    RETURN restriction_id;

END;
$BODY$;


CREATE OR REPLACE FUNCTION toms."remove_restriction_from_proposal"(proposal_id integer,
                                                                   geometry_id text) RETURNS boolean
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
   row RECORD;
   restriction_id TEXT;
   open_date DATE;
   restriction_table_name TEXT;
   restriction_table_id INTEGER;
   squery TEXT;
BEGIN

    RAISE NOTICE '***** IN remove_restriction_from_proposal: proposal_id(%); geometry_id (%)', proposal_id, geometry_id;

/***
    ALTER TABLE toms."Proposals" DISABLE TRIGGER all;
    ALTER TABLE toms."Bays" DISABLE TRIGGER all;
    ALTER TABLE toms."Lines" DISABLE TRIGGER all;
    ALTER TABLE toms."Signs" DISABLE TRIGGER all;
    ALTER TABLE toms."RestrictionPolygons" DISABLE TRIGGER all;
    ALTER TABLE toms."ControlledParkingZones" DISABLE TRIGGER all;
    ALTER TABLE toms."ParkingTariffAreas" DISABLE TRIGGER all;
    ALTER TABLE toms."MatchDayEventDayZones" DISABLE TRIGGER all;
    ALTER TABLE toms."MapGrid" DISABLE TRIGGER all;
***/

    --- Find the RestrictionID from the GeometryID

    FOR row IN SELECT "RestrictionLayerName", "Code"
               FROM toms."RestrictionLayers"
               WHERE "Code" < 100
               ORDER BY "Code"
    LOOP

        RAISE NOTICE '***** IN remove_restriction_from_proposal: checking (%)', row."RestrictionLayerName";

        EXECUTE FORMAT ('SELECT "RestrictionID"::text, "OpenDate" FROM toms.%I '
                       'WHERE "GeometryID" = %L', row."RestrictionLayerName", geometry_id)
                       INTO restriction_id, open_date;

        IF LENGTH (restriction_id) > 0 THEN
            RAISE NOTICE '***** IN remove_restriction_from_proposal: restriction_id (%) found for geometry_ID (%) in table % with open date (%)',
                restriction_id, geometry_id, row."RestrictionLayerName", open_date;
            restriction_table_name = row."RestrictionLayerName";
            restriction_table_id = row."Code";
            EXIT;
        END IF;

    END LOOP;

    IF LENGTH (restriction_id) = 0 THEN
        RAISE NOTICE '***** IN remove_restriction_from_proposal. Geometry id NOT found ...';
        RETURN false;
    END IF;

    -- Remove restriction from table
    RAISE NOTICE '***** IN remove_restriction_from_proposal. Deleting restriction from RestrictionsInProposals ...';

    squery =  FORMAT('DELETE FROM toms."RestrictionsInProposals" '
                    'WHERE "RestrictionID" = %L '
                    'AND "ProposalID" = %L', restriction_id, proposal_id);
    RAISE NOTICE 'Q: %', squery;

    EXECUTE FORMAT ('DELETE FROM toms."RestrictionsInProposals" '
                    'WHERE "RestrictionID" = %L '
                    'AND "ProposalID" = %L', restriction_id, proposal_id);

    -- If there is no open date, the restriction has been created as part of the Proposal so delete
    IF open_date IS NULL THEN
        RAISE NOTICE '***** IN remove_restriction_from_proposal. Deleting restriction from % ...', restriction_table_name;
        EXECUTE FORMAT ('DELETE FROM toms.%I '
                        'WHERE "RestrictionID" = %L ', restriction_table_name, restriction_id);
    END IF;

/***
    ALTER TABLE toms."Proposals" ENABLE TRIGGER all;
    ALTER TABLE toms."Bays" ENABLE TRIGGER all;
    ALTER TABLE toms."Lines" ENABLE TRIGGER all;
    ALTER TABLE toms."Signs" ENABLE TRIGGER all;
    ALTER TABLE toms."RestrictionPolygons" ENABLE TRIGGER all;
    ALTER TABLE toms."ControlledParkingZones" ENABLE TRIGGER all;
    ALTER TABLE toms."ParkingTariffAreas" ENABLE TRIGGER all;
    ALTER TABLE toms."MatchDayEventDayZones" ENABLE TRIGGER all;
    ALTER TABLE toms."MapGrid" ENABLE TRIGGER all;
***/
    RETURN true;

END;
$BODY$;

-- This is an example ...
--SELECT toms."change_proposal_open_date" (121, '02/02/2022')

