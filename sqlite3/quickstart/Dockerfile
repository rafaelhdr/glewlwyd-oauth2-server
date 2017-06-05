FROM rafaelhdr/glewlwyd-oauth2-server:base

RUN mkdir -p /var/cache/scriptssql

COPY ["entrypoint.sh", "/"]
COPY ["glewlwyd.sqlite3.sql", "webapp.init.sql", "/var/glewlwyd/scriptssql/"]
COPY ["glewlwyd.sqlite3.conf", "/var/glewlwyd/conf/glewlwyd.conf"]
