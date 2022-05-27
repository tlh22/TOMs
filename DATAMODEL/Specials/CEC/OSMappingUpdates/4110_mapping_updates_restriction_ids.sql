/***
 *
 ***/

UPDATE "topography_updates"."MappingUpdates"
SET "RestrictionID" = "GeometryID"
WHERE "RestrictionID" IS NULL;

UPDATE "topography_updates"."MappingUpdateMasks"
SET "RestrictionID" = "GeometryID"
WHERE "RestrictionID" IS NULL;


---

DELETE
FROM toms."RestrictionsInProposals"
WHERE "RestrictionID" IN
(SELECT "RestrictionID"
FROM topography_updates."MappingUpdates"
 WHERE ST_Length(geom) = 0
)

DELETE
FROM topography_updates."MappingUpdates"
WHERE ST_Length(geom) = 0




SELECT a."GeometryID", ST_AsText(a.geom)
FROM (
SELECT r."GeometryID", r.geom
FROM toms."Lines" r, toms."Proposals" p, toms."RestrictionsInProposals" RiP
WHERE p."ProposalID" = 301
AND p."ProposalID" = RiP."ProposalID"
AND r."RestrictionID" = RiP."RestrictionID" ) As a, local_authority."SiteArea" s
WHERE NOT ST_Contains(s.geom, a.geom)