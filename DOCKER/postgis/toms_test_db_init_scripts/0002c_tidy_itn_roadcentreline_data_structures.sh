#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0002d_tidy_itn_roadcentreline.sql"