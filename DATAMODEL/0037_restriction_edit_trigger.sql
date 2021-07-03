/***
To avoid changes to restrictions, set policy and use function to check when Proposals are being Accepted.
***/

/*
CREATE OR REPLACE FUNCTION accounts_is_excluded_full_name(text)
RETURNS boolean
AS
$$
*/

-- Bays

-- ALTER TABLE toms."Bays" DISABLE ROW LEVEL SECURITY;
ALTER TABLE toms."Bays" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "selectRestrictions" ON toms."Bays";
CREATE POLICY "selectRestrictions" ON toms."Bays"
    FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "insertRestrictions" ON toms."Bays";
CREATE POLICY "insertRestrictions" ON toms."Bays"
    FOR INSERT
    --USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "deleteRestrictions" ON toms."Bays";
CREATE POLICY "deleteRestrictions" ON toms."Bays"
    FOR DELETE
    USING ("OpenDate" IS NULL);
    --WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_operator" ON toms."Bays";
CREATE POLICY "updateRestrictions" ON toms."Bays"
    FOR UPDATE TO toms_operator
    USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_admin" ON toms."Bays";
CREATE POLICY "updateRestrictions_admin" ON toms."Bays"
    FOR UPDATE TO toms_admin
    USING (true)
    WITH CHECK ("OpenDate" IS NULL OR ("OpenDate" IS NOT NULL AND "CloseDate" IS NOT NULL));
    --WITH CHECK (?? need to check that this is the acceptance process running ??);

-- Lines

-- ALTER TABLE toms."Lines" DISABLE ROW LEVEL SECURITY;
ALTER TABLE toms."Lines" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "selectRestrictions" ON toms."Lines";
CREATE POLICY "selectRestrictions" ON toms."Lines"
    FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "insertRestrictions" ON toms."Lines";
CREATE POLICY "insertRestrictions" ON toms."Lines"
    FOR INSERT
    --USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "deleteRestrictions" ON toms."Lines";
CREATE POLICY "deleteRestrictions" ON toms."Lines"
    FOR DELETE
    USING ("OpenDate" IS NULL);
    --WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_operator" ON toms."Lines";
CREATE POLICY "updateRestrictions" ON toms."Lines"
    FOR UPDATE TO toms_operator
    USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_admin" ON toms."Lines";
CREATE POLICY "updateRestrictions_admin" ON toms."Lines"
    FOR UPDATE TO toms_admin
    USING (true)
    WITH CHECK ("OpenDate" IS NULL OR ("OpenDate" IS NOT NULL AND "CloseDate" IS NOT NULL));
    --WITH CHECK (?? need to check that this is the acceptance process running ??);

-- Signs

-- ALTER TABLE toms."Signs" DISABLE ROW LEVEL SECURITY;
ALTER TABLE toms."Signs" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "selectRestrictions" ON toms."Signs";
CREATE POLICY "selectRestrictions" ON toms."Signs"
    FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "insertRestrictions" ON toms."Signs";
CREATE POLICY "insertRestrictions" ON toms."Signs"
    FOR INSERT
    --USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "deleteRestrictions" ON toms."Signs";
CREATE POLICY "deleteRestrictions" ON toms."Signs"
    FOR DELETE
    USING ("OpenDate" IS NULL);
    --WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_operator" ON toms."Signs";
CREATE POLICY "updateRestrictions" ON toms."Signs"
    FOR UPDATE TO toms_operator
    USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_admin" ON toms."Signs";
CREATE POLICY "updateRestrictions_admin" ON toms."Signs"
    FOR UPDATE TO toms_admin
    USING (true)
    WITH CHECK ("OpenDate" IS NULL OR ("OpenDate" IS NOT NULL AND "CloseDate" IS NOT NULL));
    --WITH CHECK (?? need to check that this is the acceptance process running ??);

-- RestrictionPolygons

-- ALTER TABLE toms."RestrictionPolygons" DISABLE ROW LEVEL SECURITY;
ALTER TABLE toms."RestrictionPolygons" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "selectRestrictions" ON toms."RestrictionPolygons";
CREATE POLICY "selectRestrictions" ON toms."RestrictionPolygons"
    FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "insertRestrictions" ON toms."RestrictionPolygons";
CREATE POLICY "insertRestrictions" ON toms."RestrictionPolygons"
    FOR INSERT
    --USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "deleteRestrictions" ON toms."RestrictionPolygons";
CREATE POLICY "deleteRestrictions" ON toms."RestrictionPolygons"
    FOR DELETE
    USING ("OpenDate" IS NULL);
    --WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_operator" ON toms."RestrictionPolygons";
CREATE POLICY "updateRestrictions" ON toms."RestrictionPolygons"
    FOR UPDATE TO toms_operator
    USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_admin" ON toms."RestrictionPolygons";
CREATE POLICY "updateRestrictions_admin" ON toms."RestrictionPolygons"
    FOR UPDATE TO toms_admin
    USING (true)
    WITH CHECK ("OpenDate" IS NULL OR ("OpenDate" IS NOT NULL AND "CloseDate" IS NOT NULL));
    --WITH CHECK (?? need to check that this is the acceptance process running ??);

-- ControlledParkingZones

-- ALTER TABLE toms."ControlledParkingZones" DISABLE ROW LEVEL SECURITY;
ALTER TABLE toms."ControlledParkingZones" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "selectRestrictions" ON toms."ControlledParkingZones";
CREATE POLICY "selectRestrictions" ON toms."ControlledParkingZones"
    FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "insertRestrictions" ON toms."ControlledParkingZones";
CREATE POLICY "insertRestrictions" ON toms."ControlledParkingZones"
    FOR INSERT
    --USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "deleteRestrictions" ON toms."ControlledParkingZones";
CREATE POLICY "deleteRestrictions" ON toms."ControlledParkingZones"
    FOR DELETE
    USING ("OpenDate" IS NULL);
    --WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_operator" ON toms."ControlledParkingZones";
CREATE POLICY "updateRestrictions" ON toms."ControlledParkingZones"
    FOR UPDATE TO toms_operator
    USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_admin" ON toms."ControlledParkingZones";
CREATE POLICY "updateRestrictions_admin" ON toms."ControlledParkingZones"
    FOR UPDATE TO toms_admin
    USING (true)
    WITH CHECK ("OpenDate" IS NULL OR ("OpenDate" IS NOT NULL AND "CloseDate" IS NOT NULL));
    --WITH CHECK (?? need to check that this is the acceptance process running ??);


-- ParkingTariffAreas

-- ALTER TABLE toms."ParkingTariffAreas" DISABLE ROW LEVEL SECURITY;
ALTER TABLE toms."ParkingTariffAreas" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "selectRestrictions" ON toms."ParkingTariffAreas";
CREATE POLICY "selectRestrictions" ON toms."ParkingTariffAreas"
    FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "insertRestrictions" ON toms."ParkingTariffAreas";
CREATE POLICY "insertRestrictions" ON toms."ParkingTariffAreas"
    FOR INSERT
    --USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "deleteRestrictions" ON toms."ParkingTariffAreas";
CREATE POLICY "deleteRestrictions" ON toms."ParkingTariffAreas"
    FOR DELETE
    USING ("OpenDate" IS NULL);
    --WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_operator" ON toms."ParkingTariffAreas";
CREATE POLICY "updateRestrictions" ON toms."ParkingTariffAreas"
    FOR UPDATE TO toms_operator
    USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_admin" ON toms."ParkingTariffAreas";
CREATE POLICY "updateRestrictions_admin" ON toms."ParkingTariffAreas"
    FOR UPDATE TO toms_admin
    USING (true)
    WITH CHECK ("OpenDate" IS NULL OR ("OpenDate" IS NOT NULL AND "CloseDate" IS NOT NULL));
    --WITH CHECK (?? need to check that this is the acceptance process running ??);


-- MatchDayEventDayZones

-- ALTER TABLE toms."MatchDayEventDayZones" DISABLE ROW LEVEL SECURITY;
ALTER TABLE toms."MatchDayEventDayZones" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "selectRestrictions" ON toms."MatchDayEventDayZones";
CREATE POLICY "selectRestrictions" ON toms."MatchDayEventDayZones"
    FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "insertRestrictions" ON toms."MatchDayEventDayZones";
CREATE POLICY "insertRestrictions" ON toms."MatchDayEventDayZones"
    FOR INSERT
    --USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "deleteRestrictions" ON toms."MatchDayEventDayZones";
CREATE POLICY "deleteRestrictions" ON toms."MatchDayEventDayZones"
    FOR DELETE
    USING ("OpenDate" IS NULL);
    --WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_operator" ON toms."MatchDayEventDayZones";
CREATE POLICY "updateRestrictions" ON toms."MatchDayEventDayZones"
    FOR UPDATE TO toms_operator
    USING (true)
    WITH CHECK ("OpenDate" IS NULL);

DROP POLICY IF EXISTS "updateRestrictions_admin" ON toms."MatchDayEventDayZones";
CREATE POLICY "updateRestrictions_admin" ON toms."MatchDayEventDayZones"
    FOR UPDATE TO toms_admin
    USING (true)
    WITH CHECK ("OpenDate" IS NULL OR ("OpenDate" IS NOT NULL AND "CloseDate" IS NOT NULL));
    --WITH CHECK (?? need to check that this is the acceptance process running ??);


/**
What we really want is to have a trigger on Proposals that updates all relevant tables:
 - Restrictions
  - TilesInAcceptedProposals
   - Proposals
**/
