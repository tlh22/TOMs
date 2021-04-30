#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0014c2_update_set_original_geometry.sql"