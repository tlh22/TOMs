/***
 * To deal with the revision number incrementing issue, for any tiles that have a revision number of 0 that was set for the initial release, set it to 1
 ***/

SELECT "id"
FROM toms."MapGrid"
WHERE "CurrRevisionNr" = 0
AND "LastRevisionDate" = '2018-10-15';

UPDATE toms."MapGrid"
SET "CurrRevisionNr" = 1
WHERE "CurrRevisionNr" = 0
AND "LastRevisionDate" = '2018-10-15';