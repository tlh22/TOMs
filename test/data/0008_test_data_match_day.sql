-- Add new time period

INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (224);
INSERT INTO "toms_lookups"."TimePeriodsInUse" ("Code") VALUES (101);

REFRESH MATERIALIZED VIEW "toms_lookups"."TimePeriodsInUse_View";

UPDATE "toms"."ControlledParkingZones"
SET "MatchDayTimePeriodID" = 224
WHERE "CPZ" = 'B';

--- Create a new restriction with the matchday time period

INSERT INTO "toms"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (8, 2, '2020-09-21', NULL, 'Match day zone restrictions', '2020-09-21');
SELECT setval('toms."Proposals_id_seq"', 9, true);

INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "PermitCode", "MatchDayTimePeriodID") VALUES ('bbaf1974-e799-4993-a8cb-c344adf025fd', 'B_ 000000038', '0102000020346C0000020000005930A2AA91DE13416351102708912441DAC6C16AC1DE13410909F0030F912441', 12.42, 101, 21, 163, NULL, NULL, NULL, NULL, 'Princes Street', '1007', NULL, NULL, NULL, NULL, '2020-09-21', NULL, 'B', '2020-09-21 09:30:18.093932', 'toms.admin', NULL, -1, 39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 101);
INSERT INTO "toms"."Lines" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "NoWaitingTimeID", "NoLoadingTimeID", "UnacceptableTypeID", "AdditionalConditionID", "ParkingTariffArea", "labelLoading_X", "labelLoading_Y", "labelLoading_Rotation", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "ComplianceLoadingMarkingsFaded", "MatchDayTimePeriodID") VALUES ('f5b06374-5e9a-4143-b0e1-306dba63fe3c', 'L_ 000000019', '0102000020346C000002000000DAC6C16AC1DE13410909F0030F9124414AB72B6116DF13415800F4391B912441', 22.1, 224, 10, 163, NULL, NULL, NULL, NULL, 'Princes Street', '1007', NULL, NULL, NULL, NULL, '2020-09-21', NULL, 'B', '2020-09-21 09:30:18.093932', 'toms.admin', 39, 43, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 101);

INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (8, 2, 1, 'bbaf1974-e799-4993-a8cb-c344adf025fd');
INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (8, 3, 1, 'f5b06374-5e9a-4143-b0e1-306dba63fe3c');

-- Update MapGrid
UPDATE "toms"."MapGrid"
SET "CurrRevisionNr" = 4, "LastRevisionDate" = '2020-09-21'
WHERE id = 1397;

