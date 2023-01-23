#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0067_side_of_street_for_moving_traffic.sql"