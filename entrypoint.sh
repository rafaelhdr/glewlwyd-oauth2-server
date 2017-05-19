#!/bin/bash

# Quickstart scripts

# Quickstart for sqlite3

if [ -z "$CONFIGFILE" ] || [ "glewlwyd.sqlite3.conf" == "$CONFIGFILE" ]
then
    # Create database, if necessary
    sqlitefile="/var/cache/glewlwyd/glewlwyd.db"
    if ! [ -f "$sqlitefile" ]
    then
        sqlite3 $sqlitefile < /var/scriptssql/glewlwyd.sqlite3.sql
        sqlite3 $sqlitefile < /var/scriptssql/webapp.init.sql
    fi

# Quickstart for MariaDB

elif [ "glewlwyd.mariadb.conf" == "$CONFIGFILE" ]
then
    # Check if mysql database exist
    /wait-for-it.sh --timeout=60 glewlwyd-oauth2-server-db:3306 -- \
                    mysqlshow -h glewlwyd-oauth2-server-db -u root -ppassword "glewlwyd"

    # If does not exist, raise error. So, we try to create database
    if [ ! "$?" == "0" ]
    then
        cd /var/scriptssql/
        mysql -h glewlwyd-oauth2-server-db -u root -ppassword -e "SOURCE glewlwyd.mariadb.sql";
        mysql -h glewlwyd-oauth2-server-db -u root -ppassword -D glewlwyd -e "SOURCE webapp.init.sql";
        cd
    fi
fi

# Run application

if [ -z "$CONFIGFILE" ]
then
    /glewlwyd/src/glewlwyd --config-file=/var/conf/glewlwyd.sqlite3.conf
else
    /glewlwyd/src/glewlwyd --config-file=/var/conf/$CONFIGFILE
fi
