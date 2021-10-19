#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0046_additional_sign_condition_types.sql"
