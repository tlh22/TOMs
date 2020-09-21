#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0009_add_pay_parking_areas.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0009_test_data_pay_parking_areas.sql"

