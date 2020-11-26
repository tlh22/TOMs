#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0007_moving_traffic_data_structure.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0007b_moving_traffic_permissions.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0020_add_advanced_stop_line_details.sql"