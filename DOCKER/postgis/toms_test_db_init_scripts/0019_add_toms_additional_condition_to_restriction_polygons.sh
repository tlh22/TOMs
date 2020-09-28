#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0019_add_toms_additional_condition_to_restriction_polygons.sql"
