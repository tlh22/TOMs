#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0006b2_Gazetteer_from_os_roadlink.sql"
