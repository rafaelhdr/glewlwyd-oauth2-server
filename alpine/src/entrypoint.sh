#!/bin/bash

# Generate private/public keys, if necessary

if ! [ -f "/var/glewlwyd/keys/private.key" ]
then
    echo "You must hae a pair of key/certificate an place it in '/var/glewlwyd/keys/private.key' and /var/glewlwyd/keys/public.pem'"
fi

# If required, generate config file

if ! [ -f "/var/glewlwyd/conf/glewlwyd.conf" ]
then
    echo "You need to generate your own configuration file!"
    echo "Mount a volume with file at /var/glewlwyd/conf/glewlwyd.conf"
    echo "More information at https://github.com/rafaelhdr/glewlwyd-oauth2-server#volumes"
fi

# Run application
/glewlwyd/src/glewlwyd --config-file=/var/glewlwyd/conf/glewlwyd.conf
