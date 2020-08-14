-- Permissions for adhoc ISL tables

GRANT SELECT, USAGE ON SEQUENCE local_authority."ISL_Electrical_Item_Type_Code_seq" TO toms_admin;
GRANT SELECT, USAGE ON SEQUENCE local_authority."ISL_Electrical_Item_Type_Code_seq" TO toms_operator;
GRANT SELECT, USAGE ON SEQUENCE local_authority."ISL_Electrical_Item_Type_Code_seq" TO toms_public;

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE local_authority."ISL_Electrical_Item_Types" TO toms_admin, toms_operator;
GRANT SELECT ON TABLE local_authority."ISL_Electrical_Item_Types" TO toms_public;

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE local_authority."ISL_Electrical_Items" TO toms_operator, toms_admin;
GRANT SELECT, USAGE ON SEQUENCE local_authority."ISL_Electrical_Items" TO toms_public;

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE local_authority."EVCP_Asset_Register" TO toms_operator, toms_admin;
GRANT SELECT, USAGE ON SEQUENCE local_authority."EVCP_Asset_Register" TO toms_public;

