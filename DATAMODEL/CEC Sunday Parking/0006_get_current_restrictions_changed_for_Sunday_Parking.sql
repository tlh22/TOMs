/**
These are restrictions that are currently open, i.e., open with the Proposal or after - and for which the time period should be changed

Process is:
a. amend time period in restriction

**/

-- Bays
DO
$do$
DECLARE
   row RECORD;
   curr_proposal_id int := 44;
   closing_proposal_id int;
   layer_name RECORD;
   curr_uuid uuid;
   restriction_table_id int := 2;  -- Bays
BEGIN

    ALTER TABLE toms."Bays" DISABLE TRIGGER "set_create_details_Bays";
    ALTER TABLE toms."Bays" DISABLE TRIGGER "set_last_update_details_bays";
    ALTER TABLE toms."Bays" DISABLE TRIGGER "insert_mngmt";

    FOR row IN
        SELECT r."GeometryID", r."RestrictionID", c."Code", t1."Description", c."ChangedTo", t2."Description"
        FROM
        (
        SELECT "Code",
        CASE
                 WHEN "Code" = 12 THEN 311
                 WHEN "Code" = 14 THEN 313
                 WHEN "Code" = 33 THEN 309
                 WHEN "Code" = 39 THEN 308
                 WHEN "Code" = 97 THEN 315
                 WHEN "Code" = 98 THEN 314
                 WHEN "Code" = 99 THEN 316
                 WHEN "Code" = 120 THEN 317
                 WHEN "Code" = 121 THEN 312
                 WHEN "Code" = 155 THEN 307
                 WHEN "Code" = 159 THEN 317
                 WHEN "Code" = 213 THEN 306
                 WHEN "Code" = 217 THEN 310
        END AS "ChangedTo"
        FROM toms_lookups."TimePeriods" t
        WHERE "Code" IN (33, 39, 98, 99, 120, 121, 155, 159, 213)
        ) As c,
        toms_lookups."TimePeriods" t1, toms_lookups."TimePeriods" t2, toms."Bays" r
        WHERE c."Code" = t1."Code"
        AND c."ChangedTo" = t2."Code"
        AND r."OpenDate" IS NOT NULL
        AND r."CloseDate" IS NULL
        AND r."CPZ" IN ('1', '1A', '2', '3', '4')
        AND r."OpenDate" >= '2020-11-09'  -- really should if within Proposals ...
        AND r."TimePeriodID" = c."Code"

    LOOP

        RAISE NOTICE '***** CONSIDERING geom GeometryID: % RestrictionID: %', row."GeometryID", row."RestrictionID";

        -- Update time period
        UPDATE toms."Bays"
        SET "TimePeriodID" = row."ChangedTo", "LastUpdateDateTime" = now(), "LastUpdatePerson" = 'Sunday Parking Hours - Mk2'
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Control times updated ...';

    END LOOP;

    ALTER TABLE toms."Bays" ENABLE TRIGGER "set_create_details_Bays";
    ALTER TABLE toms."Bays" ENABLE TRIGGER "set_last_update_details_bays";
    ALTER TABLE toms."Bays" ENABLE TRIGGER "insert_mngmt";

END
$do$;

-- Lines
DO
$do$
DECLARE
   row RECORD;
   curr_proposal_id int := 44;
   closing_proposal_id int;
   layer_name RECORD;
   curr_uuid uuid;
   restriction_table_id int := 3;  -- Lines
BEGIN

    ALTER TABLE toms."Lines" DISABLE TRIGGER "set_create_details_Lines";
    ALTER TABLE toms."Lines" DISABLE TRIGGER "set_last_update_details_lines";
    ALTER TABLE toms."Lines" DISABLE TRIGGER "insert_mngmt";

    FOR row IN
        SELECT r."GeometryID", r."RestrictionID", c."Code", t1."Description", c."ChangedTo", t2."Description"
        FROM
        (
        SELECT "Code",
        CASE
                 WHEN "Code" = 12 THEN 311
                 WHEN "Code" = 14 THEN 313
                 WHEN "Code" = 33 THEN 309
                 WHEN "Code" = 39 THEN 308
                 WHEN "Code" = 97 THEN 315
                 WHEN "Code" = 98 THEN 314
                 WHEN "Code" = 99 THEN 316
                 WHEN "Code" = 120 THEN 317
                 WHEN "Code" = 121 THEN 312
                 WHEN "Code" = 155 THEN 307
                 WHEN "Code" = 159 THEN 317
                 WHEN "Code" = 213 THEN 306
                 WHEN "Code" = 217 THEN 310
        END AS "ChangedTo"
        FROM toms_lookups."TimePeriods" t
        WHERE "Code" IN (33, 39, 98, 99, 120, 121, 155, 159, 213)
        ) As c,
        toms_lookups."TimePeriods" t1, toms_lookups."TimePeriods" t2, toms."Lines" r
        WHERE c."Code" = t1."Code"
        AND c."ChangedTo" = t2."Code"
        AND r."OpenDate" IS NOT NULL
        AND r."CloseDate" IS NULL
        AND r."CPZ" IN ('1', '1A', '2', '3', '4')
        AND r."OpenDate" >= '2020-11-09'  -- really should if within Proposals ...
        AND r."NoWaitingTimeID" = c."Code"

    LOOP

        RAISE NOTICE '***** CONSIDERING geom GeometryID: % RestrictionID: %', row."GeometryID", row."RestrictionID";

        -- Update time period
        UPDATE toms."Lines"
        SET "NoWaitingTimeID" = row."ChangedTo", "OpenDate" = '2020-11-09', "LastUpdateDateTime" = now(), "LastUpdatePerson" = 'Sunday Parking Hours - Mk2'
        WHERE "RestrictionID" = row."RestrictionID";

        RAISE NOTICE '***** Control times updated ...';

    END LOOP;

    ALTER TABLE toms."Lines" ENABLE TRIGGER "set_create_details_Lines";
    ALTER TABLE toms."Lines" ENABLE TRIGGER "set_last_update_details_lines";
    ALTER TABLE toms."Lines" ENABLE TRIGGER "insert_mngmt";

END
$do$;

