#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0057_audit_trigger.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0058_set_audit_triggers.sql"