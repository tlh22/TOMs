#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0062_section_as_restriction_type.sql"
