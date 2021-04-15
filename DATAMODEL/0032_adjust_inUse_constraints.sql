-- setup FKs on "InUse" tables

ALTER TABLE toms_lookups."BayTypesInUse"
    ADD CONSTRAINT "BayTypesInUse_BayLineTypes_fkey" FOREIGN KEY ("Code") REFERENCES toms_lookups."BayLineTypes" ("Code") MATCH SIMPLE;

ALTER TABLE toms_lookups."LineTypesInUse"
    ADD CONSTRAINT "LineTypesInUse_BayLineTypes_fkey" FOREIGN KEY ("Code") REFERENCES toms_lookups."BayLineTypes" ("Code") MATCH SIMPLE;

ALTER TABLE toms_lookups."SignTypesInUse"
    ADD CONSTRAINT "SignTypesInUse_SignTypes_fkey" FOREIGN KEY ("Code") REFERENCES toms_lookups."SignTypes" ("Code") MATCH SIMPLE;

ALTER TABLE toms_lookups."RestrictionPolygonTypesInUse"
    ADD CONSTRAINT "RestrictionPolygonTypesInUse_RestrictionPolygonTypes_fkey" FOREIGN KEY ("Code") REFERENCES toms_lookups."RestrictionPolygonTypes" ("Code") MATCH SIMPLE;

ALTER TABLE toms_lookups."TimePeriodsInUse"
    ADD CONSTRAINT "TimePeriodsInUse_TimePeriods_fkey" FOREIGN KEY ("Code") REFERENCES toms_lookups."TimePeriods" ("Code") MATCH SIMPLE;