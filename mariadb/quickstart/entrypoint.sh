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
                mysqlshow -h glewlwyd-oauth2-server-db -u root -ppassword "glewlwyd" && \
    mysql -h glewlwyd-oauth2-server-db -u root -ppassword -D glewlwyd "SELECT * FROM glewlwyd.g_user"

# If does not exist, raise error. So, we try to create database
if [ ! "$?" == "0" ]
then
    cd /var/glewlwyd/scriptssql/
    mysql -h glewlwyd-oauth2-server-db -u root -ppassword -e "SOURCE glewlwyd.mariadb.sql";
    mysql -h glewlwyd-oauth2-server-db -u root -ppassword -D glewlwyd -e "SOURCE webapp.init.sql";
    cd
fi

# Check database migration
there_is_field=`mysql -h glewlwyd-oauth2-server-db -u root -ppassword --database=glewlwyd -e "DESC g_user" | grep gu_additional_property_value | wc -l`
if [ "$there_is_field" = "0" ];then
    cd /var/glewlwyd/scriptssql/
    mysql -h glewlwyd-oauth2-server-db -u root -ppassword -D glewlwyd -e "SOURCE glewlwyd.mariadb.migration-01.sql";
    cd
fi

# Run application
/usr/bin/glewlwyd --config-file=/var/glewlwyd/conf/glewlwyd.conf
