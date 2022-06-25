#!/bin/bash
##### creating a new user within linux and also within postgres
##  sh /home/tim/9985c_copy_user_config_linux.sh -u gavin.graham -c nina.mason

# get arguments from flags

while getopts 't:d:h:p:u:a:g:G:c:' flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        c) template_user=${OPTARG};;
    esac
done

echo "Setting up config files for: $username";

#------------

sudo rm -rf /home/$username/.config/menus
sudo rm -rf /home/$username/.local/share/applications
sudo rm -rf /home/$username/Desktop

sudo mkdir -p /home/$username/.config/menus
sudo mkdir -p /home/$username/.local/share/applications
sudo mkdir -p /home/$username/Desktop

# add files to customise session

sudo cp -r /home/$template_user/.config/ /home/$username/
sudo cp -r /home/$template_user/.local/share/ /home/$username/.local/
sudo cp -r /home/$template_user/Desktop/ /home/$username/
sudo chmod +x /home/$template_user/Desktop/*.desktop

# add files to customise QGIS

sudo mkdir -p /home/$username/.local/share/QGIS/QGIS3
sudo cp -r /home/$template_user/.local/share/QGIS/QGIS3/profiles/ /home/$username/.local/share/QGIS/QGIS3/profiles/

# change ownership/permissions

sudo chown -R $username:$group /home/$username

#####

#!/bin/bash
#./script.sh < input_file.txt
while read -r line; do
  echo "Next line: $line"
  # or something more useful.... :-)
done
