#!/bin/bash

# https://info.crunchydata.com/blog/ssl-certificate-authentication-postgresql-docker-containers

# This directory is optional, but will use it to keep the CA root key safe
mkdir -p /home/pg_config

cd /home/pg_config

mkdir keys certs
chmod og-rwx keys certs

# Set up a directory that will serve as the pgconf mount
mkdir -p /home/pg_config/pgconf
