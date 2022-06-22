#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0062_capacity_with_sections.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0063_section_as_restriction_type.sql"