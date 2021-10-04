#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0043_additional_unacceptable_types.sql"
