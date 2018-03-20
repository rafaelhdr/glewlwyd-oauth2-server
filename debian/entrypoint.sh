#!/bin/bash

# Check config file

if ! [ -f "/var/glewlwyd/conf/glewlwyd.conf" ]
then
    echo "You need to generate your own configuration file!"
    echo "Mount a volume with file at /var/glewlwyd/conf/glewlwyd.conf"
    echo "More information at https://github.com/rafaelhdr/glewlwyd-oauth2-server#volumes"
fi

# Run application
/usr/bin/glewlwyd --config-file=/var/glewlwyd/conf/glewlwyd.conf

# Error code
status_code=$?
if [ "$status_code" != "0" ]
then
    if [ "$status_code" = "2" ]
    then
        echo "Error on database connection!"
    else
        echo "Error on glewlwyd!"
    fi
fi
