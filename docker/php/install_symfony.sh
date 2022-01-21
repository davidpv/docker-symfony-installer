#!/bin/bash
DIR="/var/www/config"
if [ -d "$DIR" ]; then
  echo "SYMFONY ALREADY INSTALLED!!!."
else
  mkdir /var/www/sftemp
  git config --global user.email "xxx@xxx.com" && git config --global user.name "xxxx" && symfony new /var/www/sftemp --version=${SYMFONY_VERSION}
  mv /var/www/sftemp/* /var/www/sftemp/.[!.]* /var/www/sftemp/..?* /var/www/
  rm -rf /var/www/sftemp
fi
