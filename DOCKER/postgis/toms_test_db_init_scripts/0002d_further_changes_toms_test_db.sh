#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0002d_add_additional_condition_types.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0003b_test_data_add_sign_wkt.sql"