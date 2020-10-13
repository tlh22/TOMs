#!/bin/bash
psql -U postgres -c 'create database "TOMs_Test";'
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/pre_0001_data_structures/pre_0001_0001_migrate_lookups.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/pre_0001_data_structures/pre_0001_0002_tidy_main_tables.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/pre_0001_data_structures/pre_0001_0003_migrate_to_0001.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/pre_0001_data_structures/pre_0001_0004_post_migrate_tidy.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/pre_0001_data_structures/pre_0001_0005_migrate_EDI1_VM.sql"

