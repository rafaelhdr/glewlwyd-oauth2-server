FROM rafaelhdr/glewlwyd-oauth2-server:base

RUN apt-get update && \
    apt-get install -y \
		sqlite3

RUN mkdir -p /var/cache/scriptssql

COPY ["entrypoint.sh", "/"]
COPY ["glewlwyd.sqlite3.sql", "webapp.init.sql", "glewlwyd.sqlite3.migration-01.sql", "/var/glewlwyd/scriptssql/"]
COPY ["glewlwyd.sqlite3.conf", "/var/glewlwyd/conf/glewlwyd.conf"]
