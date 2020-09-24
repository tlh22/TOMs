#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0015_add_toms_create_date.sql"