#!/bin/bash

# Create database, if necessary
sqlitefile="/var/cache/glewlwyd/glewlwyd.db"
if ! [ -f "$sqlitefile" ]
then
    sqlite3 $sqlitefile < /var/scriptssql/glewlwyd.sqlite3.sql
    sqlite3 $sqlitefile < /var/scriptssql/glewlwyd.sqlite3.sql
    sqlite3 $sqlitefile < /var/scriptssql/webapp.init.sql
fi

# Run application
/glewlwyd/src/glewlwyd --config-file=/var/conf/glewlwyd.conf
