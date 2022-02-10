/***
 * setup audit trigger on relevant tables
 ***/

--
SELECT audit.audit_table('toms."Bays"');
SELECT audit.audit_table('toms."Lines"');
SELECT audit.audit_table('toms."Signs"');
SELECT audit.audit_table('toms."RestrictionPolygons"');

SELECT audit.audit_table('toms."ControlledParkingZones"');
SELECT audit.audit_table('toms."ParkingTariffAreas"');
SELECT audit.audit_table('toms."MatchDayEventDayZones"');

SELECT audit.audit_table('toms."MapGrid"');

SELECT audit.audit_table('toms."Proposals"');
SELECT audit.audit_table('toms."RestrictionsInProposals"');
SELECT audit.audit_table('toms."TilesInAcceptedProposals"');