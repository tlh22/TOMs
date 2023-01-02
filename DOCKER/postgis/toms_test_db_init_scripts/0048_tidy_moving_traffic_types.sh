#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0048a_tidy_moving_traffic_types.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0048b_tidy_moving_traffic_types.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0048c_tidy_moving_traffic_types.sql"