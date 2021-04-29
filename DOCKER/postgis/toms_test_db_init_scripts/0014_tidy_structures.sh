#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0014a2_highway_asset_adjustments.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0014c2_update_set_original_geometry.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0014d_update_crossing_points.sql"