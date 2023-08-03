#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0067_additional_length_of_time.sql"
