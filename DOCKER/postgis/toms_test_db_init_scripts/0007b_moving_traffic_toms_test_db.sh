#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0007_test_data_moving_traffic_lookups.sql"