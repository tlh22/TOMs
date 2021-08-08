-- *** Update current restrictions that have incorrect time period

-- Bays
UPDATE toms."Bays" AS r
SET "TimePeriodID" =
               CASE
                 WHEN "TimePeriodID" = 12 THEN 311
                 WHEN "TimePeriodID" = 14 THEN 313
                 WHEN "TimePeriodID" = 33 THEN 309
                 WHEN "TimePeriodID" = 39 THEN 308
                 WHEN "TimePeriodID" = 97 THEN 315
                 WHEN "TimePeriodID" = 98 THEN 314
                 WHEN "TimePeriodID" = 99 THEN 316
                 WHEN "TimePeriodID" = 120 THEN 317
                 WHEN "TimePeriodID" = 121 THEN 312
                 WHEN "TimePeriodID" = 155 THEN 307
                 WHEN "TimePeriodID" = 159 THEN 317
                 WHEN "TimePeriodID" = 213 THEN 306
                 WHEN "TimePeriodID" = 217 THEN 310
                 --ELSE "TimePeriodID"
               END,
        "Notes" = CONCAT ("Notes", ' Sunday Parking')
WHERE r."RestrictionID" IN (
    SELECT r."RestrictionID"
    FROM toms."Bays" r, toms."ControlledParkingZones" c
    WHERE ST_Intersects(r.geom, c.geom)
    AND c."CPZ" IN ('1', '1A', '2', '3', '4')
    AND r."TimePeriodID" NOT IN (0, 1, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318)
    AND r."OpenDate" IS NOT NULL
    AND r."CloseDate" IS NULL
    AND r."RestrictionID" IN (SELECT "RestrictionID"
                              FROM toms."RestrictionsInProposals" RiP
                              WHERE "ProposalID" IN (71, 44, 203, 47, 59)
                              AND "ActionOnProposalAcceptance" = 1)
);

-- Lines
UPDATE toms."Lines" AS r
SET "NoWaitingTimeID" =
               CASE
                 WHEN "NoWaitingTimeID" = 12 THEN 311
                 WHEN "NoWaitingTimeID" = 14 THEN 313
                 WHEN "NoWaitingTimeID" = 33 THEN 309
                 WHEN "NoWaitingTimeID" = 39 THEN 308
                 WHEN "NoWaitingTimeID" = 97 THEN 315
                 WHEN "NoWaitingTimeID" = 98 THEN 314
                 WHEN "NoWaitingTimeID" = 99 THEN 316
                 WHEN "NoWaitingTimeID" = 120 THEN 317
                 WHEN "NoWaitingTimeID" = 121 THEN 312
                 WHEN "NoWaitingTimeID" = 155 THEN 307
                 WHEN "NoWaitingTimeID" = 159 THEN 317
                 WHEN "NoWaitingTimeID" = 213 THEN 306
                 WHEN "NoWaitingTimeID" = 217 THEN 310
                 --ELSE "TimePeriodID"
               END,
      "Notes" = CONCAT ("Notes", ' Sunday Parking')
WHERE r."RestrictionID" IN (
    SELECT r."RestrictionID"
    FROM toms."Lines" r, toms."ControlledParkingZones" c
    WHERE ST_Intersects(r.geom, c.geom)
    AND c."CPZ" IN ('1', '1A', '2', '3', '4')
    AND r."NoWaitingTimeID" NOT IN (0, 1, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318)
    AND r."OpenDate" IS NOT NULL
    AND r."CloseDate" IS NULL
    AND r."RestrictionID" IN (SELECT "RestrictionID"
                              FROM toms."RestrictionsInProposals" RiP
                              WHERE "ProposalID" IN (71, 44, 203, 47, 59)
                              AND "ActionOnProposalAcceptance" = 1)
);

-- RestrictionPolygons
UPDATE toms."RestrictionPolygons" AS r
SET "TimePeriodID" =
               CASE
                 WHEN "TimePeriodID" = 12 THEN 311
                 WHEN "TimePeriodID" = 14 THEN 313
                 WHEN "TimePeriodID" = 33 THEN 309
                 WHEN "TimePeriodID" = 39 THEN 308
                 WHEN "TimePeriodID" = 97 THEN 315
                 WHEN "TimePeriodID" = 98 THEN 314
                 WHEN "TimePeriodID" = 99 THEN 316
                 WHEN "TimePeriodID" = 120 THEN 317
                 WHEN "TimePeriodID" = 121 THEN 312
                 WHEN "TimePeriodID" = 155 THEN 307
                 WHEN "TimePeriodID" = 159 THEN 317
                 WHEN "TimePeriodID" = 213 THEN 306
                 WHEN "TimePeriodID" = 217 THEN 310
                 --ELSE "TimePeriodID"
               END,
      "Notes" = CONCAT ("Notes", ' Sunday Parking')
WHERE r."RestrictionID" IN (
    SELECT r."RestrictionID"
    FROM toms."RestrictionPolygons" r, toms."ControlledParkingZones" c
    WHERE ST_Intersects(r.geom, c.geom)
    AND c."CPZ" IN ('1', '1A', '2', '3', '4')
    AND r."TimePeriodID" NOT IN (0, 1, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318)
    AND r."OpenDate" IS NOT NULL
    AND r."CloseDate" IS NULL
    AND r."RestrictionID" IN (SELECT "RestrictionID"
                              FROM toms."RestrictionsInProposals" RiP
                              WHERE "ProposalID" IN (71, 44, 203, 47, 59)
                              AND "ActionOnProposalAcceptance" = 1)
);

