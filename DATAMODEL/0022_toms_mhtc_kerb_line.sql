--

CREATE OR REPLACE FUNCTION public.create_geometryid()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	 nextSeqVal varchar := '';
BEGIN

	CASE TG_TABLE_NAME
	WHEN 'Bays' THEN
			SELECT concat('B_', to_char(nextval('toms."Bays_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'Lines' THEN
		   SELECT concat('L_', to_char(nextval('toms."Lines_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'Signs' THEN
		   SELECT concat('S_', to_char(nextval('toms."Signs_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'RestrictionPolygons' THEN
		   SELECT concat('P_', to_char(nextval('toms."RestrictionPolygons_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'ControlledParkingZones' THEN
		   SELECT concat('C_', to_char(nextval('toms."ControlledParkingZones_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'ParkingTariffAreas' THEN
		   SELECT concat('T_', to_char(nextval('toms."ParkingTariffAreas_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'AccessRestrictions' THEN
		   SELECT concat('A_', to_char(nextval('moving_traffic."AccessRestrictions_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'HighwayDedications' THEN
		   SELECT concat('H_', to_char(nextval('moving_traffic."HighwayDedications_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'RestrictionsForVehicles' THEN
		   SELECT concat('R_', to_char(nextval('moving_traffic."RestrictionsForVehicles_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'SpecialDesignations' THEN
		   SELECT concat('D_', to_char(nextval('moving_traffic."SpecialDesignations_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'TurnRestrictions' THEN
		   SELECT concat('V_', to_char(nextval('moving_traffic."TurnRestrictions_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'CarriagewayMarkings' THEN
		   SELECT concat('M_', to_char(nextval('moving_traffic."CarriagewayMarkings_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'MHTC_RoadLinks' THEN
		   SELECT concat('L_', to_char(nextval('highways_network."MHTC_RoadLinks_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;
	WHEN 'MHTC_Kerblines' THEN
		   SELECT concat('K_', to_char(nextval('mhtc_operations."MHTC_Kerbline_id_seq"'::regclass), '000000000'::text)) INTO nextSeqVal;

	ELSE
	    nextSeqVal = 'U';
	END CASE;

    NEW."GeometryID" := nextSeqVal;
	RETURN NEW;

END;
$BODY$;

ALTER FUNCTION public.create_geometryid()
    OWNER TO postgres;

CREATE SEQUENCE "mhtc_operations"."MHTC_Kerbline_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "mhtc_operations"."MHTC_Kerbline_id_seq" OWNER TO "postgres";

CREATE TABLE "mhtc_operations"."MHTC_Kerblines"
(
    geom geometry(LineString,27700) NOT NULL,
    "GeometryID" character varying(12) DEFAULT ('L_'::"text" || "to_char"("nextval"('"mhtc_operations"."MHTC_Kerbline_id_seq"'::"regclass"), '000000000'::"text"))
	)
INHERITS ("moving_traffic"."Restrictions");

ALTER TABLE ONLY "mhtc_operations"."MHTC_Kerblines"
    ADD CONSTRAINT "MHTC_Kerblines_pkey" PRIMARY KEY ("RestrictionID");

ALTER TABLE "mhtc_operations"."MHTC_Kerblines" OWNER TO "postgres";

CREATE TRIGGER "create_geometryid_mhtc_kerblines" BEFORE INSERT ON "mhtc_operations"."MHTC_Kerblines" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid"();
CREATE TRIGGER "set_last_update_details_mhtc_kerblines" BEFORE INSERT OR UPDATE ON "mhtc_operations"."MHTC_Kerblines" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_update_details"();
CREATE TRIGGER "set_create_details_mhtc_kerblines" BEFORE INSERT ON "mhtc_operations"."MHTC_Kerblines" FOR EACH ROW EXECUTE FUNCTION "public"."set_create_details"();

GRANT SELECT ON TABLE mhtc_operations."MHTC_Kerblines" TO toms_public;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE mhtc_operations."MHTC_Kerblines" TO toms_operator, toms_admin;
GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA mhtc_operations TO toms_public, toms_operator, toms_admin;
