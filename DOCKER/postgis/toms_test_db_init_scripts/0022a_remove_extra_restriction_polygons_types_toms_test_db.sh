#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0022_remove_extra_restriction_polygon_types.sql"

