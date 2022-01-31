#!/bin/bash
##### creating a new user within postgres

# get arguments from flags

while getopts 't:d:h:p:u:a:g:G:c:' flag
do
    case "${flag}" in
        t) connection_name=${OPTARG};;
        d) database=${OPTARG};;
        h) hostname=${OPTARG};;
        p) port=${OPTARG};;
        u) username=${OPTARG};;
        a) new_user_password=${OPTARG};;
        g) os_group=${OPTARG};;
        G) db_group=${OPTARG};;
        c) template_user=${OPTARG};;
    esac
done

echo "Using: $hostname:$port:$database";
echo "Creating account for: $username with password: $new_user_password";

#-----
# add user to db
echo "Adding user to db ..."
psql -U postgres -d $database -h $hostname -p $port <<EOF
CREATE USER "${username}" WITH PASSWORD '${new_user_password}';
GRANT ${db_group} TO "${username}";
EOF

# add user/connection within guac - do this manually ...

