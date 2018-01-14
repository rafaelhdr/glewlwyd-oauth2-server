FROM debian:stretch

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    autoconf \
    git \
    libcurl4-gnutls-dev \
    libconfig-dev \
    libjansson-dev \
    libgnutls28-dev \
    libssl-dev \
    libldap2-dev \
    libmicrohttpd-dev \
    libmariadbclient-dev \
    libsqlite3-dev \
    libtool \
    make \
    mariadb-client \
    sqlite3 \
    uuid-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

ARG GLEWLWYD_VERSION=1.3.1
ARG HOEL_VERSION=1.3
ARG LIBJWT_VERSION=1.8.0
ARG ORCANIA_VERSION=1.1.1
ARG ULFIUS_VERSION=2.2.2
ARG YDER_VERSION=1.1

# libtool and autoconf may be required, install them with 'sudo apt-get install libtool autoconf'
RUN cd /opt && \
    wget https://github.com/benmcollins/libjwt/archive/v${LIBJWT_VERSION}.tar.gz && \
    tar -zxvf v${LIBJWT_VERSION}.tar.gz && \
    rm v${LIBJWT_VERSION}.tar.gz && \
    cd libjwt-${LIBJWT_VERSION}/ && \
    autoreconf -i && \
    ./configure && \
    make && \
    make install && \

# Install Orcania
    cd /opt && \
    wget https://github.com/babelouest/orcania/archive/${ORCANIA_VERSION}.tar.gz && \
    tar -zxvf ${ORCANIA_VERSION}.tar.gz && \
    rm ${ORCANIA_VERSION}.tar.gz && \
    cd orcania-${ORCANIA_VERSION}/ && \
    make && \
    make install && \

# Install Yder
    cd /opt && \
    wget https://github.com/babelouest/yder/archive/${YDER_VERSION}.tar.gz && \
    tar -zxvf ${YDER_VERSION}.tar.gz && \
    rm ${YDER_VERSION}.tar.gz && \
    cd yder-${YDER_VERSION}/src/ && \
    make && \
    make install && \

# Install Ulfius
    cd /opt && \
    wget https://github.com/babelouest/ulfius/archive/v${ULFIUS_VERSION}.tar.gz && \
    tar -zxvf v${ULFIUS_VERSION}.tar.gz && \
    rm v${ULFIUS_VERSION}.tar.gz && \
    cd ulfius-${ULFIUS_VERSION}/src/ && \
    make && \
    make install && \

# Install Hoel
    cd /opt && \
    wget https://github.com/babelouest/hoel/archive/v${HOEL_VERSION}.tar.gz && \
    tar -zxvf v${HOEL_VERSION}.tar.gz && \
    rm v${HOEL_VERSION}.tar.gz && \
    cd hoel-${HOEL_VERSION}/src/ && \
    make && \
    make install && \

# Install Glewlwyd
    cd / && \
    wget https://github.com/babelouest/glewlwyd/archive/v${GLEWLWYD_VERSION}.tar.gz && \
    tar -zxvf v${GLEWLWYD_VERSION}.tar.gz && \
    rm v${GLEWLWYD_VERSION}.tar.gz && \
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
    mkdir -p /var/cache/glewlwyd/

COPY ["entrypoint.sh", "/"]

EXPOSE 4593

CMD ["/entrypoint.sh"]
