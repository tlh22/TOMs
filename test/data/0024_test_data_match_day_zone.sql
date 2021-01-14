-- add match day zone

INSERT INTO "toms"."MatchDayEventDayZones" ("RestrictionID", "geom", "RestrictionTypeID", "Notes", "Photos_01", "Photos_02", "Photos_03",
"label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "LabelText",
"TimePeriodID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes",
"MatchDayTimePeriodID", "CreateDateTime", "CreatePerson", "label_pos", "label_ldr") VALUES (uuid_generate_v4(), '0103000020346C000001000000050000004B09E86C45DC13410392EA13499224418153B80B99DC134159B1A053D391244117A7897490DF1341A122ED6C3B922441CD0A998A3EDF13414B03372DB19224414B09E86C45DC13410392EA1349922441',
20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-01-14', NULL,
'ED', '2021-01-14 15:48:36.057505', 'toms.admin', NULL, 101, NULL, NULL, NULL, NULL, NULL, NULL, '2021-01-14 15:48:36.057505', 'toms.admin', '0104000020346C00000200000001010000000542824527DD1341301445B5259224410101000000D0D0E7B4B3DE13417A8A586C5F922441', '0105000020346C0000020000000102000000020000000542824527DD1341301445B5259224410542824527DD1341301445B525922441010200000002000000D0D0E7B4B3DE13417A8A586C5F922441D0D0E7B4B3DE13417A8A586C5F922441');

-- Update restrictions
UPDATE toms."Bays" AS r
SET "MatchDayEventDayZone" = c."CPZ", "MatchDayTimePeriodID" = c."TimePeriodID"
FROM "toms"."ControlledParkingZones" c
WHERE ST_WITHIN (r.geom, c.geom)
AND c."CPZ" = 'ED';

UPDATE toms."Lines" AS r
SET "MatchDayEventDayZone" = c."CPZ", "MatchDayTimePeriodID" = c."TimePeriodID"
FROM "toms"."ControlledParkingZones" c
WHERE ST_WITHIN (r.geom, c.geom)
AND c."CPZ" = 'ED';

UPDATE toms."RestrictionPolygons" AS r
SET "MatchDayEventDayZone" = c."CPZ", "MatchDayTimePeriodID" = c."TimePeriodID"
FROM "toms"."ControlledParkingZones" c
WHERE ST_WITHIN (r.geom, c.geom)
AND c."CPZ" = 'ED';