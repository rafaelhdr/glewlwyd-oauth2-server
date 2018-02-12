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
