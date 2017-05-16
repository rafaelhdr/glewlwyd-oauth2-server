FROM debian:8.8

# Install required packages
RUN apt-get update && \
    apt-get install -y libmicrohttpd-dev \
    libjansson-dev \
    libcurl4-gnutls-dev \
    uuid-dev \
    libldap2-dev \
    libmysqlclient-dev \
    sqlite3 \
    libsqlite3-dev \
    libconfig-dev \
    libssl-dev \
    git \
    libtool \
    autoconf \
    make \
    mariadb-client

# Install libjwt
# libtool and autoconf may be required, install them with 'sudo apt-get install libtool autoconf'
RUN git clone https://github.com/benmcollins/libjwt.git && \
    cd libjwt/ && \
    autoreconf -i && \
    ./configure && \
    make && \
    make install

# Install Orcania
RUN git clone https://github.com/babelouest/orcania.git && \
    cd orcania/ && \
    make && \
    make install

# Install Yder
RUN git clone https://github.com/babelouest/yder.git && \
    cd yder/src/ && \
    make && \
    make install

# Install Ulfius
RUN git clone https://github.com/babelouest/ulfius.git && \
    cd ulfius/src/ && \
    make && \
    make install

# Install Hoel
RUN git clone https://github.com/babelouest/hoel.git && \
    cd hoel/src/ && \
    make && \
    make install

# Install Glewlwyd
RUN git clone https://github.com/babelouest/glewlwyd.git && \
    cd glewlwyd/src/ && \
    make  && \
    make install

WORKDIR /glewlwyd

# Configuration required for shared objects
RUN ldconfig && \
    mkdir -p /var/conf && \
    ln -s /glewlwyd/webapp /var/www && \
    openssl genrsa -out private.key 4096 && \
    openssl rsa -in private.key -outform PEM -pubout -out public.pem && \
    mkdir -p /var/cache/glewlwyd/ && \
    mkdir -p /var/cache/glewlwyd

COPY ["glewlwyd.*.conf", "/var/conf/"]
COPY ["glewlwyd.mariadb.sql", "glewlwyd.sqlite3.sql", "webapp.init.sql", "/var/scriptssql/"]
COPY ["entrypoint.sh", "/"]

EXPOSE 4593

CMD ["/entrypoint.sh"]
