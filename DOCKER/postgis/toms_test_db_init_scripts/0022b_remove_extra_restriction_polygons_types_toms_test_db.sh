#!/bin/bash
#
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0022_remove_extra_restriction_polygon_types.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0023_resolve_cpz_print_issue.sql"
