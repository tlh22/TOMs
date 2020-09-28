#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0018_add_toms_capacity.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0018_add_toms_capacity_details.sql"