FROM rafaelhdr/glewlwyd-oauth2-server:base

RUN mkdir -p /var/cache/scriptssql

COPY ["entrypoint.sh", "wait-for-it.sh", "/"]
COPY ["glewlwyd.mariadb.sql", "webapp.init.sql", "glewlwyd.mariadb.migration-01.sql", "/var/glewlwyd/scriptssql/"]
COPY ["glewlwyd.mariadb.conf", "/var/glewlwyd/conf/glewlwyd.conf"]
