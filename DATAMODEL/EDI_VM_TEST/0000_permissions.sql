CREATE ROLE edi_admin;
CREATE ROLE edi_operator;
CREATE ROLE edi_public;

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM edi_admin;
GRANT SELECT,INSERT,UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO edi_admin;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO edi_admin;

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM edi_operator;

GRANT SELECT ON TABLE "ActionOnProposalAcceptanceTypes" TO edi_operator;
GRANT SELECT ON TABLE "BayLinesFadedTypes" TO edi_operator;
GRANT SELECT ON TABLE "baytypes" TO edi_operator;
GRANT SELECT ON TABLE "BaysLines_SignIssueTypes" TO edi_operator;
GRANT SELECT ON TABLE "LengthOfTime" TO edi_operator;
GRANT SELECT ON TABLE "linetypes" TO edi_operator;
GRANT SELECT ON TABLE "PaymentTypes" TO edi_operator;
GRANT SELECT ON TABLE "ProposalStatusTypes" TO edi_operator;
GRANT SELECT ON TABLE "RestrictionLayers" TO edi_operator;
GRANT SELECT ON TABLE "RestrictionShapeTypes" TO edi_operator;
GRANT SELECT ON TABLE "RestrictionStatus" TO edi_operator;
GRANT SELECT ON TABLE "RestrictionTypes" TO edi_operator;
GRANT SELECT ON TABLE "RestrictionPolygonTypes" TO edi_operator;
GRANT SELECT ON TABLE "SignAttachmentTypes" TO edi_operator;
GRANT SELECT ON TABLE "SignFadedTypes" TO edi_operator;
GRANT SELECT ON TABLE "SignMountTypes" TO edi_operator;
GRANT SELECT ON TABLE "SignObscurredTypes" TO edi_operator;
GRANT SELECT ON TABLE "SignTypes" TO edi_operator;
GRANT SELECT ON TABLE "Surveyors" TO edi_operator;
GRANT SELECT ON TABLE "TicketMachineIssueTypes" TO edi_operator;
GRANT SELECT ON TABLE "TimePeriods" TO edi_operator;
GRANT SELECT ON TABLE "baysWordingTypes" TO edi_operator;
GRANT SELECT ON TABLE baytypes TO edi_operator;
GRANT SELECT ON TABLE linetypes TO edi_operator;

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE "Bays" TO edi_operator;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE "Lines" TO edi_operator;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE "Signs" TO edi_operator;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE "RestrictionPolygons" TO edi_operator;
GRANT SELECT, INSERT, UPDATE ON TABLE "Proposals" TO edi_operator;
GRANT SELECT, INSERT, DELETE ON TABLE "RestrictionsInProposals" TO edi_operator;
GRANT SELECT ON TABLE "MapGrid" TO edi_operator;
GRANT SELECT ON TABLE "ParkingTariffAreas" TO edi_operator;
GRANT SELECT ON TABLE "ControlledParkingZones" TO edi_operator;

GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO edi_operator;


ALTER TABLE "Proposals" ENABLE ROW LEVEL SECURITY;

--- DROP POLICY "updateProposals" ON "Proposals";
--- DROP POLICY "selectProposals" ON "Proposals";
CREATE POLICY "selectProposals" ON "Proposals"
    FOR SELECT
    USING (true);

CREATE POLICY "updateProposals" ON "Proposals"
    FOR UPDATE TO edi_operator
    USING (true)
    WITH CHECK ("ProposalStatusID" <> 2);

--- DROP POLICY "insertProposals" ON "Proposals";
CREATE POLICY "insertProposals" ON "Proposals"
    FOR INSERT TO edi_operator
    WITH CHECK ("ProposalStatusID" <> 2);

DROP POLICY "updateProposals_admin" ON "Proposals";

CREATE POLICY "updateProposals_admin" ON "Proposals"
    FOR UPDATE TO edi_admin
    USING (true);

DROP POLICY "insertProposals_admin" ON "Proposals";

CREATE POLICY "insertProposals_admin" ON "Proposals"
    FOR INSERT TO edi_admin
    WITH CHECK ("ProposalStatusID" <> 2);

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM edi_public;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO edi_public;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO edi_public;

