-- adhoc local authority assets

ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "LastUpdateDateTime" timestamp without time zone;  -- timestamp
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "LastUpdatePerson" character varying(255);
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "MHTC_CheckIssueTypeID" integer;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "MHTC_CheckNotes" character varying(255);
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "RestrictionID" "uuid";
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "GeometryID" character varying(12);
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "Photos_01" character varying(255);
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "Photos_02" character varying(255);
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "Photos_03" character varying(255);
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "Notes" character varying(255);
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "RoadName" character varying(254);
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "USRN" character varying(254);
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "OpenDate" date;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "CloseDate" date;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "AssetConditionTypeID" integer;

ALTER TABLE ONLY local_authority."ISL_Electrical_Items"
    ADD CONSTRAINT "ISL_Electrical_Items_GeometryID_key" UNIQUE ("GeometryID");
ALTER TABLE ONLY local_authority."ISL_Electrical_Items"
    ADD CONSTRAINT "ISL_Electrical_Items_AssetConditionTypeID_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES "highway_asset_lookups"."AssetConditionTypes"("Code");
ALTER TABLE ONLY local_authority."ISL_Electrical_Items"
    ADD CONSTRAINT "ISL_Electrical_Items_MHTC_CheckIssueTypeID_fkey" FOREIGN KEY ("MHTC_CheckIssueTypeID") REFERENCES "compliance_lookups"."MHTC_CheckIssueTypes"("Code");

CREATE FUNCTION public.create_geometryid_isl_electrical_items()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	 nextSeqVal varchar := '';
BEGIN

	CASE TG_TABLE_NAME
	WHEN 'ISL_Electrical_Items' THEN
			SELECT concat('EI_', to_char(nextval('local_authority."ISL_Electrical_Items_id_seq"'::regclass), '00000000'::text)) INTO nextSeqVal;

	ELSE
	    nextSeqVal = 'U';
	END CASE;

    NEW."GeometryID" := nextSeqVal;
	RETURN NEW;

END;
$BODY$;

ALTER FUNCTION public.create_geometryid_highway_assets()
    OWNER TO postgres;

CREATE TRIGGER "create_geometryid_isl_electrical_items" BEFORE INSERT ON local_authority."ISL_Electrical_Items" FOR EACH ROW EXECUTE FUNCTION "public"."create_geometryid_isl_electrical_items"();

CREATE TRIGGER "set_last_update_details_ISL_Electrical_Items"
    BEFORE INSERT OR UPDATE
    ON local_authority."ISL_Electrical_Items"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_last_update_details();

-- set up Types
CREATE SEQUENCE local_authority."ISL_Electrical_Item_Type_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE local_authority."ISL_Electrical_Item_Type_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE local_authority."ISL_Electrical_Item_Type_Code_seq" TO postgres;

CREATE TABLE local_authority."ISL_Electrical_Item_Types"
(
    "Code" integer NOT NULL DEFAULT nextval('local_authority."ISL_Electrical_Item_Type_Code_seq"'::regclass),
    "Description" character varying COLLATE pg_catalog."default",
    CONSTRAINT "ISL_Electrical_Item_Types_pkey" PRIMARY KEY ("Code")
)

TABLESPACE pg_default;

ALTER TABLE local_authority."ISL_Electrical_Item_Types"
    OWNER to postgres;

GRANT ALL ON TABLE local_authority."ISL_Electrical_Item_Types" TO postgres;


-- *** DATA items *** TODO: need to be moved elsewhere ...

INSERT INTO local_authority."ISL_Electrical_Item_Types"(
	"Description")
SELECT DISTINCT "Type_Description" FROM local_authority."ISL_Electrical_Items";

alter table local_authority."ISL_Electrical_Items"
alter column "LastUpdateDateTime" type timestamp without time zone using date('20200728') + "LastUpdateDateTime";


-- EV charge points

ALTER TABLE local_authority."EVCP_Asset_Register"
    ADD COLUMN "LastUpdateDateTime" timestamp without time zone;  -- timestamp
ALTER TABLE local_authority."EVCP_Asset_Register"
    ADD COLUMN "LastUpdatePerson" character varying(255);
ALTER TABLE local_authority."EVCP_Asset_Register"
    ADD COLUMN "MHTC_CheckIssueTypeID" integer;
ALTER TABLE local_authority."EVCP_Asset_Register"
    ADD COLUMN "MHTC_CheckNotes" character varying(255);


ALTER TABLE local_authority."EVCP_Asset_Register"
    ALTER COLUMN geom SET NOT NULL;
ALTER TABLE local_authority."EVCP_Asset_Register"
    ALTER COLUMN "LastUpdateDateTime" SET NOT NULL;
ALTER TABLE local_authority."EVCP_Asset_Register"
    ALTER COLUMN "LastUpdatePerson" SET NOT NULL;

CREATE TRIGGER "set_last_update_details_EVCP_Asset_Register"
    BEFORE INSERT OR UPDATE
    ON local_authority."EVCP_Asset_Register"
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_last_update_details();

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE local_authority."EVCP_Asset_Register" TO toms_operator, toms_admin;

--
ALTER TABLE "highway_assets"."StreetNamePlates"
    ADD COLUMN "StreetNamePlateAttachmentTypeID" integer;
ALTER TABLE ONLY "highway_assets"."StreetNamePlates"
    ADD CONSTRAINT "StreetNamePlates_SignsAttachmentTypes_fkey" FOREIGN KEY ("AssetConditionTypeID") REFERENCES compliance_lookups."SignAttachmentTypes"("Code");

--
-- TOC entry 516 (class 1259 OID 630951)
-- Name: ISL_HousingEstates; Type: TABLE; Schema: local_authority; Owner: postgres
--

CREATE TABLE "local_authority"."ISL_HousingEstates" (
    "id" integer NOT NULL,
    "geom" "public"."geometry"(MultiPolygon,27700),
    "estate_ref" character varying(254),
    "mi_style" character varying(254),
    "name" character varying(254),
    "easting" numeric,
    "northing" numeric
);


ALTER TABLE "local_authority"."ISL_HousingEstates" OWNER TO "postgres";

--
-- TOC entry 515 (class 1259 OID 630949)
-- Name: ISL_HousingEstates_id_seq; Type: SEQUENCE; Schema: local_authority; Owner: postgres
--

CREATE SEQUENCE "local_authority"."ISL_HousingEstates_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "local_authority"."ISL_HousingEstates_id_seq" OWNER TO "postgres";

--
-- TOC entry 4735 (class 0 OID 0)
-- Dependencies: 515
-- Name: ISL_HousingEstates_id_seq; Type: SEQUENCE OWNED BY; Schema: local_authority; Owner: postgres
--

ALTER SEQUENCE "local_authority"."ISL_HousingEstates_id_seq" OWNED BY "local_authority"."ISL_HousingEstates"."id";

--
-- TOC entry 4525 (class 2604 OID 630954)
-- Name: ISL_HousingEstates id; Type: DEFAULT; Schema: local_authority; Owner: postgres
--

ALTER TABLE ONLY "local_authority"."ISL_HousingEstates" ALTER COLUMN "id" SET DEFAULT "nextval"('"local_authority"."ISL_HousingEstates_id_seq"'::"regclass");

ALTER TABLE local_authority."ISL_HousingEstates"
    ADD PRIMARY KEY (id);