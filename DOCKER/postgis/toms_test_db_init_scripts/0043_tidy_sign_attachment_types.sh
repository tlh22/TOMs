#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0043_tidy_sign_attachment_types.sql"
