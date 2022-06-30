#!/bin/bash
#psql -U postgres -c 'create database "EDI_VM_Check";'
#psql -U postgres -d "EDI_VM_Check" -a -f "/io/DATAMODEL/0001_initial_data_structure.sql"
#!/bin/bash
export PGPASSWORD=postgis
#psql -U postgres -h localhost -p 5436 -c 'create database "EDI_VM_Check";'
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/pre_0001_data_structures/pre_0001_0001_migrate_lookups.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/pre_0001_data_structures/pre_0001_0002_tidy_main_tables.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/pre_0001_data_structures/pre_0001_0003_migrate_to_0001.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/pre_0001_data_structures/pre_0001_0004_post_migrate_tidy.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/pre_0001_data_structures/pre_0001_0005_migrate_EDI1_VM.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/pre_0001_data_structures/pre_0001_0006_triggers_and_last_structures.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/0002a_roles_and_users.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/0002b_permissions.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/0002c_additional_permissions.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/0002d_tidy_itn_roadcentreline.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/0006a_restructure_compliance_lookups.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/0006b_Gazetteer_from_RAMI.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/0006c_additional_toms_details.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/0008_add_match_day_control_times.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/0009_add_pay_parking_areas.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/0015_add_toms_create_date.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/0018_add_toms_capacity.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/tests/data/0018_add_toms_capacity_details.sql"
psql -U postgres -d "EDI_VM_Check_2" -h localhost -p 5436 -a -f "/home/QGIS/plugins/TOMs/DATAMODEL/0019_add_toms_additional_condition_to_restriction_polygons.sql"




