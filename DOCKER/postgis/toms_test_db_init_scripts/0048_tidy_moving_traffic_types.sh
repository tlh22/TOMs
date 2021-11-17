#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0048_tidy_moving_traffic_types.sql"
