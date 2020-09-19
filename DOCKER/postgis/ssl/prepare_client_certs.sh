#!/bin/bash
# https://info.crunchydata.com/blog/ssl-certificate-authentication-postgresql-docker-containers
#Client certificate:
export MY_USER_NAME_FOR_CERT='<user.name>'

mkdir -p /home/<user>/pg_keys/${MY_USER_NAME_FOR_CERT}
cd /home/<user>/pg_keys/${MY_USER_NAME_FOR_CERT}
cp /home/pg_config/pgconf/root.crt .

openssl req -new -nodes -out client.csr -keyout client.key -subj "/CN=${MY_USER_NAME_FOR_CERT}" 

openssl x509 -req -in client.csr -days 365 -CA /home/pg_config/certs/root.crt -CAkey /home/pg_config/keys/root.key -CAcreateserial -out client.crt

#openssl pkcs12 -export -inkey client.key -in client.crt -out client.p12

#rm client.csr
cp /home/pg_config/pgconf/root.crt .
chown -R <user:group> /home/<user>/pg_keys