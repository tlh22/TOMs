#!/bin/bash

psql -U postgres -c 'create database "TOMs_Test";'

psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0001_initial_data_structure.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0002a_roles_and_users.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0002b_permissions.sql"
