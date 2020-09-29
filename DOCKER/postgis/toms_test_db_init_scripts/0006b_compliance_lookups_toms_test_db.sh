#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0006a_test_data_add_icon_details_to_sign_types.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0006b_test_data_compliance_lookups.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0006c_update_toms_details.sql"