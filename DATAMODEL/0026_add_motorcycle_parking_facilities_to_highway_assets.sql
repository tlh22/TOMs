-- add motorcycle parking facilities table

CREATE SEQUENCE "highway_asset_lookups"."MotorcycleParkingFacilityTypes_Code_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "highway_asset_lookups"."MotorcycleParkingFacilityTypes_Code_seq" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 382 (class 1259 OID 506635)
-- Name: AssetConditionTypes; Type: TABLE; Schema: highway_asset_lookups; Owner: postgres
--

CREATE TABLE "highway_asset_lookups"."MotorcycleParkingFacilityTypes" (
    "Code" integer DEFAULT "nextval"('"highway_asset_lookups"."MotorcycleParkingFacilityTypes_Code_seq"'::"regclass") NOT NULL,
    "Description" character varying(255)
);

ALTER TABLE "highway_asset_lookups"."MotorcycleParkingFacilityTypes" OWNER TO "postgres";

ALTER TABLE ONLY "highway_asset_lookups"."MotorcycleParkingFacilityTypes"
    ADD CONSTRAINT "MotorcycleParkingFacilityTypes_pkey" PRIMARY KEY ("Code");

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE highway_asset_lookups."MotorcycleParkingFacilityTypes" TO toms_admin;
GRANT ALL ON TABLE highway_asset_lookups."MotorcycleParkingFacilityTypes" TO postgres;
GRANT SELECT ON TABLE highway_asset_lookups."MotorcycleParkingFacilityTypes" TO toms_operator, toms_public;

--

CREATE TABLE highway_assets."MotorcycleParkingFacilities"
(
    -- Inherited from table highway_assets."HighwayAssets": "RestrictionID" uuid NOT NULL,
    -- Inherited from table highway_assets."HighwayAssets": "GeometryID" character varying(12) COLLATE pg_catalog."default" NOT NULL DEFAULT ('CY_'::text || to_char(nextval('highway_assets."CycleParking_id_seq"'::regclass), '00000000'::text)),
    -- Inherited from table highway_assets."HighwayAssets": "Photos_01" character varying(255) COLLATE pg_catalog."default",
    -- Inherited from table highway_assets."HighwayAssets": "Photos_02" character varying(255) COLLATE pg_catalog."default",
    -- Inherited from table highway_assets."HighwayAssets": "Photos_03" character varying(255) COLLATE pg_catalog."default",
    -- Inherited from table highway_assets."HighwayAssets": "Notes" character varying(255) COLLATE pg_catalog."default",
    -- Inherited from table highway_assets."HighwayAssets": "RoadName" character varying(254) COLLATE pg_catalog."default",
    -- Inherited from table highway_assets."HighwayAssets": "USRN" character varying(254) COLLATE pg_catalog."default",
    -- Inherited from table highway_assets."HighwayAssets": "OpenDate" date,
    -- Inherited from table highway_assets."HighwayAssets": "CloseDate" date,
    -- Inherited from table highway_assets."HighwayAssets": "AssetConditionTypeID" integer NOT NULL,
    -- Inherited from table highway_assets."HighwayAssets": "LastUpdateDateTime" timestamp without time zone NOT NULL,
    -- Inherited from table highway_assets."HighwayAssets": "LastUpdatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    -- Inherited from table highway_assets."HighwayAssets": "MHTC_CheckIssueTypeID" integer,
    -- Inherited from table highway_assets."HighwayAssets": "MHTC_CheckNotes" character varying(254) COLLATE pg_catalog."default",
    -- Inherited from table highway_assets."HighwayAssets": "FieldCheckCompleted" boolean NOT NULL DEFAULT false,
    -- Inherited from table highway_assets."HighwayAssets": "Last_MHTC_Check_UpdateDateTime" timestamp without time zone,
    -- Inherited from table highway_assets."HighwayAssets": "Last_MHTC_Check_UpdatePerson" character varying(255) COLLATE pg_catalog."default",
    -- Inherited from table highway_assets."HighwayAssets": "CreateDateTime" timestamp without time zone NOT NULL,
    -- Inherited from table highway_assets."HighwayAssets": "CreatePerson" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    geom_point geometry(Point,27700),
    "MotorcycleParkingFacilityTypeID" integer NOT NULL,
    CONSTRAINT "MotorcycleParkingFacility_pkey" PRIMARY KEY ("RestrictionID"),
    CONSTRAINT "MotorcycleParkingFacility_MotorcycleParkingFacilityTypeID_fkey" FOREIGN KEY ("MotorcycleParkingFacilityTypeID")
        REFERENCES highway_asset_lookups."MotorcycleParkingFacilityTypes" ("Code") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
    INHERITS (highway_assets."HighwayAssets")
TABLESPACE pg_default;

ALTER TABLE highway_assets."MotorcycleParkingFacilities"
    OWNER to postgres;

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE highway_assets."MotorcycleParkingFacilities" TO toms_admin;
GRANT ALL ON TABLE highway_assets."MotorcycleParkingFacilities" TO postgres;
GRANT SELECT ON TABLE highway_assets."MotorcycleParkingFacilities" TO toms_public;
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE highway_assets."MotorcycleParkingFacilities" TO toms_operator;
-- Index: sidx_CycleParking_geom

-- DROP INDEX highway_assets."sidx_CycleParking_geom";

CREATE INDEX "sidx_MotorcycleParkingFacilities_geom"
    ON highway_assets."MotorcycleParkingFacilities" USING gist
    (geom_point)
    TABLESPACE pg_default;

-- Trigger: create_geometryid_cycle_parking

-- DROP TRIGGER create_geometryid_cycle_parking ON highway_assets."CycleParking";

CREATE TRIGGER create_geometryid_motorcycle_parking_facilities
    BEFORE INSERT
    ON highway_assets."MotorcycleParkingFacilities"
    FOR EACH ROW
    EXECUTE PROCEDURE public.create_geometryid_highway_assets();

-- Trigger: set_create_details_CycleParking

-- DROP TRIGGER "set_create_details_CycleParking" ON highway_assets."CycleParking";

CREATE TRIGGER "set_create_details_motorcycle_parking_facilities"
    BEFORE INSERT
    ON highway_assets."MotorcycleParkingFacilities"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_create_details();

-- Trigger: set_last_update_details_CycleParking

-- DROP TRIGGER "set_last_update_details_CycleParking" ON highway_assets."CycleParking";

CREATE TRIGGER "set_last_update_details_motorcycle_parking_facilities"
    BEFORE INSERT OR UPDATE
    ON highway_assets."MotorcycleParkingFacilities"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_last_update_details();

-- update create_geometryid_highway_assets


CREATE OR REPLACE FUNCTION public.create_geometryid_highway_assets()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	 nextSeqVal varchar := '';
BEGIN

	CASE TG_TABLE_NAME
	WHEN 'Benches' THEN
			SELECT concat('BE_', to_char(nextval('highway_assets."Benches_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;
	WHEN 'Bins' THEN
			SELECT concat('BI_', to_char(nextval('highway_assets."Bins_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;
	WHEN 'Bollards' THEN
		   SELECT concat('BO_', to_char(nextval('highway_assets."Bollards_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;
	WHEN 'Bridges' THEN
		   SELECT concat('BR_', to_char(nextval('highway_assets."Bridges_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;
	WHEN 'BusShelters' THEN
		   SELECT concat('BS_', to_char(nextval('highway_assets."BusShelters_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;
    WHEN 'BusStopSigns' THEN
			SELECT concat('BU_', to_char(nextval('highway_assets."BusStopSigns_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;
	WHEN 'CCTV_Cameras' THEN
		   SELECT concat('CT_', to_char(nextval('highway_assets."CCTV_Cameras_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'CommunicationCabinets' THEN
		   SELECT concat('CC_', to_char(nextval('highway_assets."CommunicationCabinets_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'CrossingPoints' THEN
		   SELECT concat('CR_', to_char(nextval('highway_assets."CrossingPoints_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'CycleParking' THEN
		   SELECT concat('CY_', to_char(nextval('highway_assets."CycleParking_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'DisplayBoards' THEN
		   SELECT concat('DB_', to_char(nextval('highway_assets."DisplayBoards_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'EV_ChargingPoints' THEN
		   SELECT concat('EV_', to_char(nextval('highway_assets."EV_ChargingPoints_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'EndOfStreetMarkings' THEN
		   SELECT concat('ES_', to_char(nextval('highway_assets."EndOfStreetMarkings_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'MotorcycleParkingFacilties' THEN
		   SELECT concat('MC_', to_char(nextval('highway_assets."MotorcycleParkingFacilties_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'PedestrianRailings' THEN
		   SELECT concat('PR_', to_char(nextval('highway_assets."PedestrianRailings_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'Postboxes' THEN
		   SELECT concat('PO_', to_char(nextval('highway_assets."Postboxes_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'StreetNamePlates' THEN
		   SELECT concat('SN_', to_char(nextval('highway_assets."StreetNamePlates_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'TelephoneBoxes' THEN
		   SELECT concat('TE_', to_char(nextval('highway_assets."TelephoneBoxes_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'TelegraphPoles' THEN
		   SELECT concat('TP_', to_char(nextval('highway_assets."TelegraphPoles_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'SubterraneanFeatures' THEN
		   SELECT concat('SF_', to_char(nextval('highway_assets."SubterraneanFeatures_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'TrafficCalming' THEN
		   SELECT concat('TC_', to_char(nextval('highway_assets."TrafficCalming_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;
	WHEN 'TrafficSignals' THEN
		   SELECT concat('TS_', to_char(nextval('highway_assets."TrafficSignals_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'UnidentifiedStaticObjects' THEN
		   SELECT concat('US_', to_char(nextval('highway_assets."UnidentifiedStaticObjects_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	WHEN 'VehicleBarriers' THEN
		   SELECT concat('VB_', to_char(nextval('highway_assets."VehicleBarriers_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	ELSE
	    nextSeqVal = 'U';
	END CASE;

    NEW."GeometryID" := nextSeqVal;
	RETURN NEW;

END;
$BODY$;
