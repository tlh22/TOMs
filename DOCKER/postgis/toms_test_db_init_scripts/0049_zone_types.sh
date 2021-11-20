#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0049_add_zone_lookups.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0050_populate_zone_types.sql"
psql -U postgres -d "TOMs_Test" -a -f "//io/DATAMODEL/0051_organise_zone_types.sql"