#!/bin/bash

# Generate private/public keys, if necessary

if ! [ -f "/var/glewlwyd/keys/private.key" ]
then
    openssl genrsa -out /var/glewlwyd/keys/private.key 4096 && \
    openssl rsa -in /var/glewlwyd/keys/private.key -outform PEM -pubout -out /var/glewlwyd/keys/public.pem
fi

# Quickstart

# Create database, if necessary
sqlitefile="/var/cache/glewlwyd/glewlwyd.db"
if ! [ -f "$sqlitefile" ]
then
    sqlite3 $sqlitefile < /var/glewlwyd/scriptssql/glewlwyd.sqlite3.sql
    sqlite3 $sqlitefile < /var/glewlwyd/scriptssql/webapp.init.sql
fi

# Check database migration
there_is_field=`sqlite3 glewlwyd.db "PRAGMA table_info(g_user);" | grep gu_additional_property_value | wc -l`
if [ "$there_is_field" = "0" ];then
    sqlite3 $sqlitefile < /var/glewlwyd/scriptssql/glewlwyd.sqlite3.migration-01.sql
fi

# Run application
/glewlwyd/src/glewlwyd --config-file=/var/glewlwyd/conf/glewlwyd.conf
