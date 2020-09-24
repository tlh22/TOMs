#!/bin/bash
psql -U postgres -c 'create database "TOMs_Test";'
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0001_initial_data_structure.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0002a_roles_and_users.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0002b_permissions.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0002c_additional_permissions.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0002d_tidy_itn_roadcentreline.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0006a_restructure_compliance_lookups.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0006c_additional_toms_details.sql"

