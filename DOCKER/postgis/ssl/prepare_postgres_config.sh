#!/bin/bash

# https://info.crunchydata.com/blog/ssl-certificate-authentication-postgresql-docker-containers

# we will need to customize the postgresql.conf file to ensure SSL is turned on
cat << EOF > pgconf/postgresql.conf
# here are some sane defaults given we will be unable to use the container
# variables
# general connection
listen_addresses = '*'
port = 5432
max_connections = 20
# memory
shared_buffers = 128MB
temp_buffers = 8MB
work_mem = 4MB
# WAL / replication
wal_level = replica
max_wal_senders = 3
# these shared libraries are available in the Crunchy PostgreSQL container
#shared_preload_libraries = 'pgaudit.so,pg_stat_statements.so'
# this is here because SCRAM is awesome, but it's not needed for this setup
#password_encryption = 'scram-sha-256'
# here are the SSL specific settings
ssl = on # this enables SSL
ssl_cert_file = '/io/pg_config/server.crt' # this specifies the server certificacte
ssl_key_file = '/io/pg_config/server.key' # this specifies the server private key
ssl_ca_file = '/io/pg_config/root.crt' # this specific which CA certificate to trust
EOF

# create a pg_hba.conf file that will only accept certificate authentication
# requests, though allow the "postgres" superuser account to connect with peer
# auth
cat << EOF > pgconf/pg_hba.conf
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             postgres                                peer
# do not let the "postgres" superuser login via a certificate
#hostssl all             postgres        ::/0                    reject
#hostssl all             postgres        0.0.0.0/0               reject
#
hostssl all             all             ::/0                    cert clientcert=1
hostssl all             all             0.0.0.0/0               cert clientcert=1
EOF


