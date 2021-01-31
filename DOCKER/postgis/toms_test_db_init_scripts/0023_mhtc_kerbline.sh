#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0022_toms_mhtc_kerb_line.sql"
