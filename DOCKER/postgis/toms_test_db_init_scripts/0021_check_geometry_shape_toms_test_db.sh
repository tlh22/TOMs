#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0021_toms_geom_shape_crossings.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0021_geometry_shape_issue.sql"

