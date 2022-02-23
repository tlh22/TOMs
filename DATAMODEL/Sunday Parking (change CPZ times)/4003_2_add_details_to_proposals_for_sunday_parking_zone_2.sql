/***
Add required details to proposals
***/

-- *** create Proposal for CPZ 2

UPDATE toms."Proposals"
SET "ProposalStatusID" = 2, "ProposalNotes" = 'Sunday parking Zone 2', "ProposalTitle" = 'TRO-19-29A Zone 2', "ProposalOpenDate" = '2020-11-09'
WHERE "ProposalID" = 203;

-- *** CPZ 2 (Proposal 203 - created above)

DO
$do$
DECLARE
    relevant_restriction RECORD;
    clone_restriction_id uuid;
BEGIN

    -- ** Bays
    FOR relevant_restriction IN
        SELECT DISTINCT r."GeometryID", r."RestrictionID"
        FROM toms."Bays" r, toms."ControlledParkingZones" c
        WHERE ST_Intersects(r.geom, c.geom)
        AND c."CPZ" IN ('2')
        AND r."TimePeriodID" NOT IN (0, 1, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318)
        AND r."OpenDate" IS NOT NULL
        AND r."CloseDate" IS NULL
        ORDER BY r."RestrictionID"
    LOOP

        RAISE NOTICE '*****--- Cloning (%)', relevant_restriction."GeometryID";
        SELECT uuid_generate_v4() INTO clone_restriction_id;

        -- Clone restriction
        INSERT INTO toms."Bays"(
            "RestrictionID", "RestrictionLength", "RestrictionTypeID", "NrBays", "TimePeriodID",
            "PayTypeID", "MaxStayID", "NoReturnID", "Notes",
            "LastUpdateDateTime", "AdditionalConditionID", "LastUpdatePerson", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue",
            "Photos_01", "Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_Rotation", "label_TextChanged",
            "BayOrientation", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "Photos_03", "ComplianceNotes",
            "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "PermitCode", "MatchDayTimePeriodID", "PayParkingAreaID", "CreateDateTime", "CreatePerson",
            "Capacity", label_pos, label_ldr, "MatchDayEventDayZone", "BayWidth", geom)
        SELECT clone_restriction_id, "RestrictionLength", "RestrictionTypeID", "NrBays",
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
                 WHEN "TimePeriodID" = 225 THEN 225
                 WHEN "TimePeriodID" = 242 THEN 242
               END AS "TimePeriodID",
            "PayTypeID", "MaxStayID", "NoReturnID", CONCAT ("Notes", ' Sunday Parking'),
            "LastUpdateDateTime", "AdditionalConditionID", "LastUpdatePerson", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue",
            "Photos_01", "Photos_02", "GeomShapeID", "RoadName", "USRN", "AzimuthToRoadCentreLine", "label_Rotation", "label_TextChanged",
            "BayOrientation", '2020-11-09', NULL, "CPZ", "ParkingTariffArea", "Photos_03", "ComplianceNotes",
            "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "PermitCode", "MatchDayTimePeriodID", "PayParkingAreaID", "CreateDateTime", "CreatePerson",
            "Capacity", label_pos, label_ldr, "MatchDayEventDayZone", "BayWidth", geom
        FROM toms."Bays" r
        WHERE r."RestrictionID" = relevant_restriction."RestrictionID";

        -- Add to RestrictionInProposals
        -- Open
        INSERT INTO toms."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
            VALUES (203, 2, 1, clone_restriction_id);

        -- Close
        INSERT INTO toms."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
            VALUES (203, 2, 2, relevant_restriction."RestrictionID");

        -- Set Close Date on original restriction
        UPDATE toms."Bays"
        SET "CloseDate" = '2020-11-09'
        WHERE "RestrictionID" = relevant_restriction."RestrictionID";

    END LOOP;

    -- ** Lines
    FOR relevant_restriction IN
        SELECT DISTINCT r."GeometryID", r."RestrictionID"
        FROM toms."Lines" r, toms."ControlledParkingZones" c
        WHERE ST_Intersects(r.geom, c.geom)
        AND c."CPZ" IN ('2')
        AND --(
             r."NoWaitingTimeID" NOT IN (0, 1, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318)
          --OR r."NoLoadingTimeID" NOT IN (0, 1, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318))
        AND r."OpenDate" IS NOT NULL
        AND r."CloseDate" IS NULL
        ORDER BY r."RestrictionID"
    LOOP

        RAISE NOTICE '*****--- Cloning (%)', relevant_restriction."GeometryID";
        SELECT uuid_generate_v4() INTO clone_restriction_id;

        -- Clone restriction
        INSERT INTO toms."Lines"(
            "RestrictionID", "RestrictionLength", "RestrictionTypeID", "NoWaitingTimeID", "NoLoadingTimeID", "Notes", "LastUpdateDateTime", "LastUpdatePerson",
            "Lines_PhotoTaken", "Photos_01", "ComplianceRoadMarkingsFaded", "Photos_02", "ComplianceRestrictionSignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine",
            "GeomShapeID", "label_Rotation", "Photos_03", "UnacceptableTypeID", "OpenDate", "CloseDate", "CPZ", "ParkingTariffArea", "labelLoading_Rotation",
            "label_TextChanged", "AdditionalConditionID", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes",
            "ComplianceLoadingMarkingsFaded", "MatchDayTimePeriodID", "CreateDateTime", "CreatePerson", "Capacity",
            label_pos, label_ldr, label_loading_pos, label_loading_ldr, "MatchDayEventDayZone", geom)
        SELECT clone_restriction_id, "RestrictionLength", "RestrictionTypeID",
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
                         WHEN "NoWaitingTimeID" = 225 THEN 225
                         WHEN "NoWaitingTimeID" = 242 THEN 242
                       END AS "NoWaitingTimeID",
                "NoLoadingTimeID",
                CONCAT ("Notes", ' Sunday Parking'), "LastUpdateDateTime", "LastUpdatePerson",
                "Lines_PhotoTaken", "Photos_01", "ComplianceRoadMarkingsFaded", "Photos_02", "ComplianceRestrictionSignIssue", "RoadName", "USRN", "AzimuthToRoadCentreLine",
                "GeomShapeID", "label_Rotation", "Photos_03", "UnacceptableTypeID", '2020-11-09', NULL, "CPZ", "ParkingTariffArea", "labelLoading_Rotation",
                "label_TextChanged", "AdditionalConditionID", "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes",
                "ComplianceLoadingMarkingsFaded", "MatchDayTimePeriodID", "CreateDateTime", "CreatePerson", "Capacity",
                label_pos, label_ldr, label_loading_pos, label_loading_ldr, "MatchDayEventDayZone", geom
            FROM toms."Lines" r
            WHERE r."RestrictionID" = relevant_restriction."RestrictionID";

        -- Add to RestrictionInProposals
        -- Open
        INSERT INTO toms."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
            VALUES (203, 3, 1, clone_restriction_id);

        -- Close
        INSERT INTO toms."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
            VALUES (203, 3, 2, relevant_restriction."RestrictionID");

        -- Set Close Date on original restriction
        UPDATE toms."Lines"
        SET "CloseDate" = '2020-11-09'
        WHERE "RestrictionID" = relevant_restriction."RestrictionID";

    END LOOP;

    -- ** RestrictionPolygons
    FOR relevant_restriction IN
        SELECT DISTINCT r."GeometryID", r."RestrictionID"
        FROM toms."RestrictionPolygons" r, toms."ControlledParkingZones" c
        WHERE ST_Intersects(r.geom, c.geom)
        AND c."CPZ" IN ('2')
        AND r."TimePeriodID" NOT IN (0, 1, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318)
        AND r."OpenDate" IS NOT NULL
        AND r."CloseDate" IS NULL
        ORDER BY r."RestrictionID"
    LOOP

        RAISE NOTICE '*****--- Cloning (%)', relevant_restriction."GeometryID";
        SELECT uuid_generate_v4() INTO clone_restriction_id;

        -- Clone restriction
        INSERT INTO toms."RestrictionPolygons"(
            "RestrictionID", "RestrictionTypeID", "GeomShapeID", "OpenDate", "CloseDate", "USRN", "Orientation", "RoadName",
            "NoWaitingTimeID", "NoLoadingTimeID", "Photos_01", "Photos_02", "Photos_03", "LabelText", "TimePeriodID", "AreaPermitCode", "CPZ",
            "label_Rotation", "Notes", "label_TextChanged", "LastUpdateDateTime", "LastUpdatePerson", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue",
            "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "MatchDayTimePeriodID", "CreateDateTime", "CreatePerson", "AdditionalConditionID",
            label_pos, label_ldr, "MatchDayEventDayZone", geom)

        SELECT clone_restriction_id, "RestrictionTypeID", "GeomShapeID", '2020-11-09', NULL, "USRN", "Orientation", "RoadName",
        "NoWaitingTimeID", "NoLoadingTimeID", "Photos_01", "Photos_02", "Photos_03", "LabelText",
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
                         WHEN "TimePeriodID" = 225 THEN 225
                         WHEN "TimePeriodID" = 242 THEN 242
                       END AS "TimePeriodID",
                "AreaPermitCode", "CPZ",
                "label_Rotation", CONCAT ("Notes", ' Sunday Parking'), "label_TextChanged", "LastUpdateDateTime", "LastUpdatePerson", "ComplianceRoadMarkingsFaded", "ComplianceRestrictionSignIssue",
                "ComplianceNotes", "MHTC_CheckIssueTypeID", "MHTC_CheckNotes", "MatchDayTimePeriodID", "CreateDateTime", "CreatePerson", "AdditionalConditionID",
                label_pos, label_ldr, "MatchDayEventDayZone", geom
            FROM toms."RestrictionPolygons" r
            WHERE r."RestrictionID" = relevant_restriction."RestrictionID";

        -- Add to RestrictionInProposals
        -- Open
        INSERT INTO toms."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
            VALUES (203, 4, 1, clone_restriction_id);

        -- Close
        INSERT INTO toms."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
            VALUES (203, 4, 2, relevant_restriction."RestrictionID");

        -- Set Close Date on original restriction
        UPDATE toms."RestrictionPolygons"
        SET "CloseDate" = '2020-11-09'
        WHERE "RestrictionID" = relevant_restriction."RestrictionID";

    END LOOP;

    -- ** CPZ (add existing CPZ details manually)
    -- Open
    INSERT INTO toms."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
    VALUES (203, 6, 1, 34);

    -- Close
    INSERT INTO toms."RestrictionsInProposals"(
            "ProposalID", "RestrictionTableID", "ActionOnProposalAcceptance", "RestrictionID")
     VALUES (203, 6, 2, 5);

     -- Set Close Date on original CPZ
     UPDATE toms."ControlledParkingZones"
     SET "CloseDate" = '2020-11-09'
     WHERE "RestrictionID" = '5';

     -- Set Open Date on new CPZ
     UPDATE toms."ControlledParkingZones"
     SET "OpenDate" = '2020-11-09'
     WHERE "RestrictionID" = '34';

END;
$do$;
