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
    mariadb-client \
    wget

ARG GLEWLWYD_VERSION=1.0.1
ARG HOEL_VERSION=1.0.0
ARG LIBJWT_VERSION=1.7.4
ARG ORCANIA_VERSION=1.0.0
ARG ULFIUS_VERSION=1.0.4
ARG YDER_VERSION=1.0.0

# libtool and autoconf may be required, install them with 'sudo apt-get install libtool autoconf'
RUN cd /opt && \
    wget https://github.com/benmcollins/libjwt/archive/v${LIBJWT_VERSION}.tar.gz && \
    tar -zxvf v${LIBJWT_VERSION}.tar.gz && \
    rm v${LIBJWT_VERSION}.tar.gz && \
    cd libjwt-${LIBJWT_VERSION}/ && \
    autoreconf -i && \
    ./configure && \
    make && \
    make install

# Install Orcania
RUN cd /opt && \
    wget https://github.com/babelouest/orcania/archive/${ORCANIA_VERSION}.tar.gz && \
    tar -zxvf ${ORCANIA_VERSION}.tar.gz && \
    rm ${ORCANIA_VERSION}.tar.gz && \
    cd orcania-${ORCANIA_VERSION}/ && \
    make && \
    make install

# Install Yder
RUN cd /opt && \
    wget https://github.com/babelouest/yder/archive/${YDER_VERSION}.tar.gz && \
    tar -zxvf ${YDER_VERSION}.tar.gz && \
    rm ${YDER_VERSION}.tar.gz && \
    cd yder-${YDER_VERSION}/src/ && \
    make && \
    make install

# Install Ulfius
RUN cd /opt && \
    wget https://github.com/babelouest/ulfius/archive/${ULFIUS_VERSION}.tar.gz && \
    tar -zxvf ${ULFIUS_VERSION}.tar.gz && \
    rm ${ULFIUS_VERSION}.tar.gz && \
    cd ulfius-${ULFIUS_VERSION}/src/ && \
    make && \
    make install

# Install Hoel
RUN cd /opt && \
    wget https://github.com/babelouest/hoel/archive/${HOEL_VERSION}.tar.gz && \
    tar -zxvf ${HOEL_VERSION}.tar.gz && \
    rm ${HOEL_VERSION}.tar.gz && \
    cd hoel-${HOEL_VERSION}/src/ && \
    make && \
    make install

# Install Glewlwyd
RUN wget https://github.com/babelouest/glewlwyd/archive/${GLEWLWYD_VERSION}.tar.gz && \
    tar -zxvf ${GLEWLWYD_VERSION}.tar.gz && \
    rm ${GLEWLWYD_VERSION}.tar.gz && \
    mv glewlwyd-${GLEWLWYD_VERSION}/ /glewlwyd && \
    cd /glewlwyd/src && \
    make && \
    make install

WORKDIR /glewlwyd

# Configuration required for shared objects
RUN ldconfig && \
    mkdir -p /var/glewlwyd/conf && \
    mkdir -p /var/glewlwyd/keys && \
    ln -s /glewlwyd/webapp /var/www && \
    mkdir -p /var/cache/glewlwyd/ && \
    mkdir -p /var/cache/glewlwyd

COPY ["glewlwyd.*.conf", "/var/glewlwyd/conf/"]
COPY ["glewlwyd.mariadb.sql", "glewlwyd.sqlite3.sql", "webapp.init.sql", "/var/scriptssql/"]
COPY ["entrypoint.sh", "/"]
COPY ["wait-for-it.sh", "/"]

EXPOSE 4593

CMD ["/entrypoint.sh"]
