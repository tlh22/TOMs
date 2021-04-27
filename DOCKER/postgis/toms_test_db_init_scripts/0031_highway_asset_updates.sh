#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0028_update_highway_assets_structures.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0030_change_highway_assets_pk_fks.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0034_unique_constraints_highway_assets.sql"

