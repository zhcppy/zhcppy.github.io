#!/usr/bin/env bash

# shell is funny

if [[ `uname` == "Linux" ]];then
    echo "This script only runs in a Linux.";exit 1
fi

debconf-set-selections <<< "mysql-server mysql-server/root-pass password root1234"
debconf-set-selections <<< "mysql-server mysql-server/re-root-pass password root1234"
DEBIAN_FRONTEND=noninteractive apt-get --yes install mysql-server

## or
#echo "mysql-server-5.5 mysql-server/root_password password root" | debconf-set-selections
#echo "mysql-server-5.5 mysql-server/root_password_again password root" | debconf-set-selections
#apt-get -y install mysql-server-5.5
#
## or
#
#export DEBIAN_FRONTEND=noninteractive
#-E apt-get -q -y install mysql-server
#
#mysqladmin -u root password root1234
#
#apt-get update
#apt-get --yes install mysql-server

mysql --version

if [ -f /etc/mysql/my.cnf ]; then
  echo "skip-grant-tables" >> /etc/mysql/my.cnf
else
  if [ -f /etc/my.cnf ]; then
    echo "skip-grant-tables" >> /etc/my.cnf
  fi
fi

usermod -d /var/lib/mysql/ mysql
ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock
chown -R mysql:mysql /var/lib/mysql

service mysql start