/***
 * Applying from 0032 ...
 ***/

-- To allow using 0032_adjust_inUse_constraints.sql, change over time period 5. (Not sure how it is present ...)

UPDATE toms."Lines"
SET "NoWaitingTimeID" = 12
WHERE "GeometryID" = 'L_0003956';

DELETE FROM toms_lookups."TimePeriodsInUse"
WHERE "Code" = 5;

-- TODO: Need to move crossovers to separate layer