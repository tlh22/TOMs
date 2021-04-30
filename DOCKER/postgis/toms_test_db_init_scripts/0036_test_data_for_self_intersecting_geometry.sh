#!/bin/bash
psql -U postgres -d "TOMs_Test" -a -f "/io/test/data/0036_test_self_intersecting_geometry_issue.sql"


