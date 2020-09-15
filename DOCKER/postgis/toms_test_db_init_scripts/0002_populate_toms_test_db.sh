#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0002a_test_data_lookups.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0002b1_test_data_main.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0002b2_test_data_main.sql"
