#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0071_add_RBKC_formula_to_project_parameters.sql"
psql -U postgres -d "TOMs_Test" -a -f "/io/DATAMODEL/0072_include_RBKC_capacity_check.sql"