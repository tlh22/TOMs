#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0015_add_toms_create_date.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0016_add_moving_traffic_create_date.sql"
#psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0017_add_highway_assets_create_date.sql"
