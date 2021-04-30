#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0010_highway_asset_lookups_structure.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0010_highway_asset_lookups_data.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0011_highway_assets_structure.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0012_highway_assets_permissions.sql"
#psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0013_ISL_tables_structure.sql"
#psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0013b_ISL_tables_permissions.sql"
#psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0013_populate_ISL_items_plus.sql"
#psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0014_ISL_table_structures_after_population.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0014a2_highway_asset_adjustments.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0014d_update_crossing_points.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0017_add_highway_assets_create_date.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0020_highway_assets_additional_details.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0026_add_motorcycle_parking_facilities_to_highway_assets.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0026_motorcycle_parking_facilities_lookup_data.sql"


