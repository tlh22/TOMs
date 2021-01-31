#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0003_refresh_materialized_views.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0004_labels-multipoints.sql"
