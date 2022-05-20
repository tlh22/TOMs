#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0052_mapping_updates.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0060_mapping_updates_restriction_types.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0061_test_data_mapping_updates.sql"
