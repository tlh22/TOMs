#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0039_additional_sign_types.sql"
