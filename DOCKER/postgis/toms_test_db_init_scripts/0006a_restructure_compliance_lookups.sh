#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0006a_restructure_compliance_lookups.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0006c_additional_toms_details.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0006d_section_break_points.sql"