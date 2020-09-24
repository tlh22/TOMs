-- Add pay parking one

INSERT INTO "local_authority"."PayParkingAreas" ("geom", "RoadName", "Code", "TariffGroup", "Postcode", "CostCode", "Spaces", "DisabledBays", "MotorbikeBays", "CoachBays", "PremierBays", "MaxStayID") VALUES ('0103000020346C0000010000000700000087CB921E48DC134118A08B10DF9024417F0C9C0538DC1341B62AEF99BF9024412895B49A1CDC13414ED41BBEAD90244114D0EB770CDC134148EA7D19A3902441511EF22D18DD1341B6855493C9902441AD3D6450FEDC1341FC42A693F790244187CB921E48DC134118A08B10DF902441', 'Princes Street', 90001, 8112, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- Add bay within zone

INSERT INTO "toms"."Proposals" ("ProposalID", "ProposalStatusID", "ProposalCreateDate", "ProposalNotes", "ProposalTitle", "ProposalOpenDate") VALUES (9, 1, '2020-09-21', NULL, 'Bay within pay parking area', '2020-09-21');
SELECT pg_catalog.setval('toms."Proposals_id_seq"', 9, true);

SET session_replication_role = replica;  -- Disable all triggers

INSERT INTO "toms"."Bays" ("RestrictionID", "GeometryID", "geom", "RestrictionLength", "RestrictionTypeID", "GeomShapeID", "AzimuthToRoadCentreLine", "Notes", "Photos_01", "Photos_02", "Photos_03", "RoadName", "USRN", "label_X", "label_Y", "label_Rotation", "label_TextChanged", "OpenDate", "CloseDate", "CPZ", "LastUpdateDateTime", "LastUpdatePerson", "BayOrientation", "NrBays", "TimePeriodID", "PayTypeID", "MaxStayID", "NoReturnID", "ParkingTariffArea", "AdditionalConditionID", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "PermitCode", "MatchDayTimePeriodID", "PayParkingAreaID") VALUES ('df48c0f5-791a-4ef0-8ce7-de279060c2e7', 'B_ 000000039', '0102000020346C00000200000043186169BCDC134157C9DCB5C490244154BD7FD4ECDC1341DEEF4FABCB902441', 12.59, 105, 21, 163, NULL, NULL, NULL, NULL, 'Princes Street', '1007', NULL, NULL, NULL, NULL, NULL, NULL, 'B', '2020-09-21 16:08:00.903341', 'toms.admin', NULL, -1, 39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 224, 90001);

SET session_replication_role = DEFAULT;  -- Enable all triggers

INSERT INTO "toms"."RestrictionsInProposals" ("ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID") VALUES (9, 2, 1, 'df48c0f5-791a-4ef0-8ce7-de279060c2e7');

