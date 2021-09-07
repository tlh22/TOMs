#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0038_additional_sign_types.sql"
