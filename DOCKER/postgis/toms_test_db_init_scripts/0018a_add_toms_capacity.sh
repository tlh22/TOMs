#!/bin/bash
#
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0018_add_toms_capacity.sql"