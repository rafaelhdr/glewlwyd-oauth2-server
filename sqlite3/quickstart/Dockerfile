FROM rafaelhdr/glewlwyd-oauth2-server:base AS builder

FROM debian:stretch

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include /usr/local/include
COPY --from=builder /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu
COPY --from=builder /lib/x86_64-linux-gnu /lib/x86_64-linux-gnu
COPY --from=builder /var/www /var/www

RUN mkdir -p /var/cache/scriptssql && \
    apt update && \
    apt install -y libjansson-dev sqlite3 openssl && \
    rm -rf /var/lib/apt/lists/* && \
    ldconfig && \
    mkdir -p /var/cache/scriptssql && \
    mkdir -p /var/glewlwyd/conf && \
    mkdir -p /var/glewlwyd/keys && \
    mkdir -p /var/cache/glewlwyd/

COPY ["entrypoint.sh", "/"]
COPY ["glewlwyd.sqlite3.sql", "webapp.init.sql", "glewlwyd.sqlite3.migration-01.sql", "/var/glewlwyd/scriptssql/"]
COPY ["glewlwyd.sqlite3.conf", "/var/glewlwyd/conf/glewlwyd.conf"]
