#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0002a_test_data_lookups.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0002b1_test_data_main.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0002b2_test_data_main.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0002c_update_itn_roadcentreline.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0002d_add_additional_condition_types.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0003b_test_data_add_sign_wkt.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0006a_test_data_add_icon_details_to_sign_types.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0006b_test_data_compliance_lookups.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0006c_update_toms_details.sql"

