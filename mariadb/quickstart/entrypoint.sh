#!/bin/bash

# Generate private/public keys, if necessary

if ! [ -f "/var/glewlwyd/keys/private.key" ]
then
    openssl genrsa -out /var/glewlwyd/keys/private.key 4096 && \
    openssl rsa -in /var/glewlwyd/keys/private.key -outform PEM -pubout -out /var/glewlwyd/keys/public.pem
fi

# Quickstart

# Check if mysql database exist
/wait-for-it.sh --timeout=60 glewlwyd-oauth2-server-db:3306 -- \
                mysqlshow -h glewlwyd-oauth2-server-db -u root -ppassword "glewlwyd"

# If does not exist, raise error. So, we try to create database
if [ ! "$?" == "0" ]
then
    cd /var/glewlwyd/scriptssql/
    mysql -h glewlwyd-oauth2-server-db -u root -ppassword -e "SOURCE glewlwyd.mariadb.sql";
    mysql -h glewlwyd-oauth2-server-db -u root -ppassword -D glewlwyd -e "SOURCE webapp.init.sql";
    cd
fi

# Run application
/glewlwyd/src/glewlwyd --config-file=/var/glewlwyd/conf/glewlwyd.conf
