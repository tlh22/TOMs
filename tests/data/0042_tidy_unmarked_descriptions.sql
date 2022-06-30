/**
Use the term "Unmarked kerbline"
**/

UPDATE "toms_lookups"."BayLineTypes"
SET "Description" = 'Unmarked Kerbline (Acceptable)'
WHERE "Code" = 216;

UPDATE "toms_lookups"."BayLineTypes"
SET "Description" = 'Unmarked Kerbline (Unacceptable)'
WHERE "Code" = 220;

UPDATE "toms_lookups"."BayLineTypes"
SET "Description" = 'Unmarked Kerbline'
WHERE "Code" = 225;

UPDATE "toms_lookups"."BayLineTypes"
SET "Description" = 'Unmarked Kerbline within PPZ (Acceptable)'
WHERE "Code" = 227;

UPDATE "toms_lookups"."BayLineTypes"
SET "Description" = 'Unmarked Kerbline within PPZ (Unacceptable)'
WHERE "Code" = 228;

UPDATE "toms_lookups"."BayLineTypes"
SET "Description" = 'Unmarked Kerbline within PPZ'
WHERE "Code" = 229;