  #!/bin/bash

  # https://info.crunchydata.com/blog/ssl-certificate-authentication-postgresql-docker-containers

  cd /home/pg_config

  ### Create a key-pair that will serve both as the root CA and the server key-pair
  # the "root.crt" name is used to match what it expects later

  openssl req -new -x509 -days 365 -nodes -out certs/root.crt \
    -keyout keys/root.key -subj "/CN=root-ca"

  ###  Create the server key and CSR and sign with root key
  openssl req -new -nodes -out server.csr \
    -keyout pgconf/server.key -subj "/CN=<host.ip.address>"

  openssl x509 -req -in server.csr -days 365 \
      -CA certs/root.crt -CAkey keys/root.key -CAcreateserial \
      -out pgconf/server.crt

  # remove the CSR as it is no longer needed
  rm server.csr

  # lock down all the files in the pgconf mount
  # in particular key/cert files must be locked down otherwise PostgreSQL won't
  # enable SSL
  chmod og-rwx pgconf/*

  cp certs/root.crt pgconf/root.crt

  # lock down all the files in the pgconf mount
  # in particular key/cert files must be locked down otherwise PostgreSQL won't
  # enable SSL
  #chmod og-rwx pgconf/*

  chown 999:999 pgconf/*
  chmod 600 pgconf/*


