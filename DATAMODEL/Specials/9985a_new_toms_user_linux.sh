#!/bin/bash
##### creating a new user within linux and also within postgres
##  sh ..../9985a_new_toms_user_linux.sh -t CEC -d CEC -h localhost -p 5435 -u toms.user -a password -g toms_user_group -G toms_public -c a.user

## sudo groupadd -g 1010 qgis_users

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
echo "Creating account for: $username in group: $group with password: $new_user_password";

# create user within group
echo "Command: sudo useradd -g $os_group -s /bin/bash -d /home/$username -m $new_user_-p $new_user_password $username";
sudo useradd -g $os_group -s /bin/bash -d /home/$username -m -p $new_user_password $username

echo -e "$new_user_password\n$new_user_password" | sudo passwd $username

#------------

# within home directory, create a .pg_service.conf file
cat > ~/.pg_service_$username.conf << EOF
[TOMs_Test]
host=${hostname}
port=${port}
dbname=TOMs_Test
user=toms.admin
password=password
#
[${connection_name}]
host=${hostname}
port=${port}
dbname=${database}
user=${username}
password=${new_user_password}
EOF

sudo mv ~/.pg_service_$username.conf /home/$username/.pg_service.conf

# change permissions on this file
chmod go-rwx /home/$username/.pg_service.conf

# within home directory, create logs directory
sudo mkdir /home/$username/logs

# add files to customise session

sudo mkdir -p /home/$username/.config
sudo cp -r /home/$template_user/.config/xfce4/ /home/$username/.config/

# add files to customise QGIS

sudo mkdir -p /home/$username/.local/share/QGIS/QGIS3
sudo cp -r /home/$template_user/.local/share/QGIS/QGIS3/profiles/ /home/$username/.local/share/QGIS/QGIS3/profiles/

# change ownership/permissions

sudo chown -R $username:$group /home/$username


