#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0021_geometry_shape_issue.sql"
