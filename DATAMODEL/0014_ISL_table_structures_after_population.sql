-- adhoc local authority assets

ALTER TABLE local_authority."ISL_Electrical_Items" DISABLE TRIGGER "set_last_update_details_ISL_Electrical_Items";

ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN geom SET NOT NULL;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN "LastUpdateDateTime" SET NOT NULL;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN "LastUpdatePerson" SET NOT NULL;

ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN "GeometryID" SET NOT NULL;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN "RestrictionID" SET NOT NULL;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ALTER COLUMN "AssetConditionTypeID" SET NOT NULL;

ALTER TABLE local_authority."ISL_Electrical_Items" ENABLE TRIGGER "set_last_update_details_ISL_Electrical_Items";

ALTER TABLE highway_assets."CommunicationCabinets"
    ALTER COLUMN "CommunicationCabinetTypeID" DROP NOT NULL;

ALTER TABLE highway_assets."VehicleBarriers"
    ALTER COLUMN "VehicleBarrierTypeID" DROP NOT NULL;

ALTER TABLE highway_assets."UnidentifiedStaticObjects"
    ADD PRIMARY KEY ("RestrictionID");

-- Adding FieldCheckedCompleted  TODO: split between different sections ...
ALTER TABLE highway_assets."HighwayAssets"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE moving_traffic."Restrictions"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE local_authority."EVCP_Asset_Register"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE toms."Bays"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE toms."Lines"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE toms."Signs"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "FieldCheckCompleted" BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE highway_assets."HighwayAssets"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE highway_assets."HighwayAssets"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE moving_traffic."Restrictions"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE moving_traffic."Restrictions"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE local_authority."ISL_Electrical_Items"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE local_authority."EVCP_Asset_Register"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE local_authority."EVCP_Asset_Register"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE toms."Bays"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE toms."Bays"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE toms."Lines"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE toms."Lines"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE toms."Signs"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE toms."Signs"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "Last_MHTC_Check_UpdateDateTime" timestamp without time zone;
ALTER TABLE toms."RestrictionPolygons"
    ADD COLUMN "Last_MHTC_Check_UpdatePerson" character varying(255);

-- Update function to reflect changes

CREATE OR REPLACE FUNCTION user_is_admin(g NAME)
RETURNS boolean AS
-- https://stackoverflow.com/questions/24354068/how-to-query-user-group-privileges-in-postgresql and
-- https://dba.stackexchange.com/questions/56096/how-to-get-all-roles-that-a-user-is-a-member-of-including-inherited-roles
'SELECT EXISTS (
select a.rolname as user_role_name,
       c.rolname as other_role_name
from pg_roles a
inner join pg_auth_members b on a.oid=b.member
inner join pg_roles c on b.roleid=c.oid
where a.rolname = $1
AND c.rolname = ''toms_admin'');'

LANGUAGE sql;

CREATE OR REPLACE FUNCTION public.set_last_update_details()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
        check_details boolean;
		check_issue_type boolean;
		restriction_details boolean;
        col_name text;
		new_value text;
	    old_value text;
		admin_user boolean;
    BEGIN

		--RAISE NOTICE 'In set_last_update_details for %; operation: %', TG_TABLE_NAME, TG_OP;

        IF (TG_OP = 'UPDATE') THEN

            restriction_details = FALSE;
            check_details = FALSE;

            -- https://gist.github.com/cecilemuller/3081382
			-- https://dba.stackexchange.com/questions/61271/how-to-access-new-or-old-field-given-only-the-fields-name

			--RAISE NOTICE 'In update';

            FOR col_name IN SELECT column_name FROM information_schema.Columns WHERE table_schema = TG_TABLE_SCHEMA AND table_name = TG_TABLE_NAME LOOP
                --RAISE NOTICE 'Column is %', col_name;

				EXECUTE format('SELECT ($1).%s::text', quote_ident(col_name))
   				USING NEW
   				INTO  new_value;

				EXECUTE format('SELECT ($1).%s::text', quote_ident(col_name))
   				USING OLD
   				INTO  old_value;

				--RAISE NOTICE 'Column is %. OLD=%s. NEW=%s', col_name, old_value, new_value;

                IF old_value != new_value OR (old_value IS NULL AND new_value IS NOT NULL) THEN
                    IF col_name = 'MHTC_CheckIssueTypeID' THEN
						check_issue_type = TRUE;
					ELSIF col_name = 'MHTC_CheckNotes' OR col_name = 'FieldCheckCompleted' THEN
                        check_details = TRUE;
						--RAISE NOTICE 'Check details CHANGED';
                    ELSE
						IF col_name != 'original_geom_wkt' THEN  -- rounding issue with AsText ...
                        	restriction_details = TRUE;
							--RAISE NOTICE 'Restriction details CHANGED';
						END IF;
					END IF;
				END IF;
            END LOOP;

			IF check_issue_type = TRUE THEN

				EXECUTE format('SELECT user_is_admin (%s)', quote_literal(current_user))
   				INTO  admin_user;
				--RAISE NOTICE 'user is admin: %s', admin_user;

				IF admin_user = FALSE THEN
					NEW."MHTC_CheckIssueTypeID" = OLD."MHTC_CheckIssueTypeID";
				ELSE
					NEW."Last_MHTC_Check_UpdateDateTime" := now();
					NEW."Last_MHTC_Check_UpdatePerson" := current_user;
				END IF;

			END IF;

            IF check_details = TRUE THEN

				NEW."Last_MHTC_Check_UpdateDateTime" := now();
				NEW."Last_MHTC_Check_UpdatePerson" := current_user;

			END IF;

            IF restriction_details = False THEN
                RETURN NEW;
			END IF;

		END IF;

        -- deal with need to set FieldCheckCompleted
        IF (TG_OP = 'INSERT') THEN
            NEW."FieldCheckCompleted" := False;
        END IF;

        NEW."LastUpdateDateTime" := now();
        NEW."LastUpdatePerson" := current_user;

        RETURN NEW;

    END;
$BODY$;

ALTER FUNCTION public.set_last_update_details()
    OWNER TO postgres;

-- FUNCTION: public.set_original_geometry()

-- DROP FUNCTION public.set_original_geometry();

CREATE OR REPLACE FUNCTION public.set_original_geometry()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
        -- Copy geometry to originalGeometry
		IF (TG_OP = 'UPDATE') THEN
			-- Check to see whether or not the point has been moved
			RAISE NOTICE 'geom values are: %, %', ST_AsText(ST_QuantizeCoordinates(NEW."geom", 3)), ST_AsText(ST_QuantizeCoordinates(OLD."geom", 3));
			IF ST_AsText(ST_QuantizeCoordinates(NEW."geom", 3)) != ST_AsText(ST_QuantizeCoordinates(OLD."geom", 3)) THEN
				NEW."original_geom_wkt" := ST_AsText(NEW."geom");
			END IF;
		ELSIF (TG_OP = 'INSERT') THEN
        	NEW."original_geom_wkt" := ST_AsText(NEW."geom");
		END IF;

        RETURN NEW;
    END;
$BODY$;

ALTER FUNCTION public.set_original_geometry()
    OWNER TO postgres;

-- change symology for crossing points
ALTER TABLE highway_assets."CrossingPoints"
    ADD COLUMN "AzimuthToRoadCentreLine" double precision;

ALTER TABLE highway_assets."CrossingPoints"
    ADD COLUMN "GeomShapeID" integer;

ALTER TABLE ONLY highway_assets."CrossingPoints"
    ADD CONSTRAINT "CrossingPoints_GeomShapeID_fkey" FOREIGN KEY ("GeomShapeID") REFERENCES "toms_lookups"."RestrictionGeomShapeTypes"("Code");

--- after populating fields
ALTER TABLE highway_assets."CrossingPoints"
    ALTER COLUMN "GeomShapeID" SET NOT NULL;

