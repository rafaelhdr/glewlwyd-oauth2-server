#!/bin/bash

mkdir -p /var/cache/glewlwyd/
sqlite3 /var/cache/glewlwyd/glewlwyd.db < /sample.sqlite

mkdir -p /var/glewlwyd/conf/
cp /sample.conf /var/glewlwyd/conf/glewlwyd.conf
