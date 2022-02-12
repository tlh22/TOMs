#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0054a_restriction_label_leaders_trigger.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0054b_restriction_label_leaders_setup_triggers.sql"