#!/bin/bash
#./script.sh < input_file.txt

while read -r line; do

  echo "User: $line"
  if [ "$line" = "" ]; then  # if the line is blank that break loop
       break
  fi
  # or something more useful.... :-)
  sh /home/tim/9985c_copy_user_config_linux.sh -u $line -c gavin.reid  # TODO: change so that model user is an input

done
