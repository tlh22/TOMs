-- Extra details found ...

UPDATE toms."Lines"
SET "NoLoadingTimeID" = NULL
WHERE "NoLoadingTimeID" = -1;

DELETE
FROM toms_lookups."TimePeriodsInUse"
WHERE "Code" = -1;