#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0031_change_moving_restriction_fks.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0034_unique_constraints_highway_assets.sql"

