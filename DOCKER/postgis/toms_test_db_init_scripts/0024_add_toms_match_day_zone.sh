#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0023_toms_add_match_day_zone.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0024_toms_match_day_zone_tidy.sql"

