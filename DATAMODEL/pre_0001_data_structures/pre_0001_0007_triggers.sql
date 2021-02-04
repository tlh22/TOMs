--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-05-29 22:56:33

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1072 (class 1255 OID 221974)
-- Name: create_geometryid(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION "public"."create_geometryid"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	 nextSeqVal varchar := '';
BEGIN

	CASE TG_TABLE_NAME
	WHEN 'Bays' THEN
			SELECT concat('B_', to_char(nextval('toms."Bays_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'Lines' THEN
		   SELECT concat('L_', to_char(nextval('toms."Lines_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'Signs' THEN
		   SELECT concat('S_', to_char(nextval('toms."Signs_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'RestrictionPolygons' THEN
		   SELECT concat('P_', to_char(nextval('toms."RestrictionPolygons_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'ControlledParkingZones' THEN
		   SELECT concat('C_', to_char(nextval('toms."ControlledParkingZones_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	WHEN 'ParkingTariffAreas' THEN
		   SELECT concat('T_', to_char(nextval('toms."ParkingTariffAreas_id_seq"'::regclass), 'FM0000000'::"text")) INTO nextSeqVal;
	ELSE
	    nextSeqVal = 'U';
	END CASE;

    NEW."GeometryID" := nextSeqVal;
	RETURN NEW;

END;
$$;


ALTER FUNCTION "public"."create_geometryid"() OWNER TO "postgres";

--
-- TOC entry 1073 (class 1255 OID 221975)
-- Name: set_last_update_details(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION public.set_last_update_details()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
    BEGIN
	    -- round to two decimal places
        NEW."LastUpdateDateTime" := now();
        NEW."LastUpdatePerson" := current_user;

        RETURN NEW;
    END;
$BODY$;

ALTER FUNCTION public.set_last_update_details()
    OWNER TO postgres;

--
-- TOC entry 1074 (class 1255 OID 221976)
-- Name: set_restriction_length(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION public.set_restriction_length()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
    BEGIN
	    -- round to two decimal places
        NEW."RestrictionLength" := ROUND(public.ST_Length (NEW."geom")::numeric,2);

        RETURN NEW;
    END;
$BODY$;

ALTER FUNCTION public.set_restriction_length()
    OWNER TO postgres;


-- Bays

CREATE TRIGGER create_geometryid_bays
    BEFORE INSERT
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE PROCEDURE public.create_geometryid();

CREATE TRIGGER "set_restriction_length_bays"
    BEFORE INSERT OR UPDATE
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_restriction_length();

-- trigger trigger  ** need to ensure that updateDate trigger is not running
UPDATE toms."Bays" SET "RestrictionLength" = "RestrictionLength";
ALTER TABLE toms."Bays" ALTER COLUMN "RestrictionLength" SET NOT NULL;

CREATE TRIGGER "set_last_update_details_bays"
    BEFORE INSERT OR UPDATE
    ON toms."Bays"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_last_update_details();

-- Lines

CREATE TRIGGER create_geometryid_lines
    BEFORE INSERT
    ON toms."Lines"
    FOR EACH ROW
    EXECUTE PROCEDURE public.create_geometryid();

CREATE TRIGGER "set_restriction_length_lines"
    BEFORE INSERT OR UPDATE
    ON toms."Lines"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_restriction_length();

-- trigger trigger  ** need to ensure that updateDate trigger is not running
UPDATE toms."Lines" SET "RestrictionLength" = "RestrictionLength";
ALTER TABLE toms."Lines" ALTER COLUMN "RestrictionLength" SET NOT NULL;

CREATE TRIGGER "set_last_update_details_lines"
    BEFORE INSERT OR UPDATE
    ON toms."Lines"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_last_update_details();

-- Signs

CREATE TRIGGER "set_last_update_details_signs"
    BEFORE INSERT OR UPDATE
    ON toms."Signs"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_last_update_details();

CREATE TRIGGER create_geometryid_signs
    BEFORE INSERT
    ON toms."Signs"
    FOR EACH ROW
    EXECUTE PROCEDURE public.create_geometryid();

-- restrictionPolygons

CREATE TRIGGER "set_last_update_details_RestrictionPolygons"
    BEFORE INSERT OR UPDATE
    ON toms."RestrictionPolygons"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_last_update_details();

CREATE TRIGGER create_geometryid_restrictionpolygons
    BEFORE INSERT
    ON toms."RestrictionPolygons"
    FOR EACH ROW
    EXECUTE PROCEDURE toms.create_geometryid();

-- CPZs
CREATE TRIGGER "create_geometryid_bays" BEFORE INSERT ON "toms"."ControlledParkingZones" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();

CREATE TRIGGER "set_last_update_details_ControlledParkingZones"
    BEFORE INSERT OR UPDATE
    ON toms."ControlledParkingZones"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_last_update_details();



-- PTAs
CREATE TRIGGER "create_geometryid_bays" BEFORE INSERT ON "toms"."ParkingTariffAreas" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();

CREATE TRIGGER "set_last_update_details_ParkingTariffAreas"
    BEFORE INSERT OR UPDATE
    ON toms."ParkingTariffAreas"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_last_update_details();

DROP TRIGGER IF EXISTS "set_restriction_length_Bays" ON "toms"."Bays";
CREATE TRIGGER "set_restriction_length_Bays" BEFORE INSERT OR UPDATE OF geom ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "public"."set_restriction_length"();

DROP TRIGGER IF EXISTS "set_restriction_length_Lines" ON "toms"."Lines";
CREATE TRIGGER "set_restriction_length_Lines" BEFORE INSERT OR UPDATE OF geom ON "toms"."Lines" FOR EACH ROW EXECUTE FUNCTION "public"."set_restriction_length"();


