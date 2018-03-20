FROM debian:stretch

# Install required packages
RUN apt-get update && apt-get install -y \
    autoconf \
    libmicrohttpd-dev \
    libjansson-dev \
    libcurl4-gnutls-dev \
    uuid-dev \
    libldap2-dev \
    libmariadbclient-dev \
    libsqlite3-dev \
    libconfig-dev \
    libgnutls28-dev \
    libssl-dev \
    libtool \
    make \
    wget \
 && rm -rf /var/lib/apt/lists/*

ARG GLEWLWYD_VERSION
ARG LIBJWT_VERSION=1.9.0

# libtool and autoconf may be required, install them with 'sudo apt-get install libtool autoconf'
RUN cd /opt && \
    wget https://github.com/benmcollins/libjwt/archive/v${LIBJWT_VERSION}.tar.gz && \
    tar -zxvf v${LIBJWT_VERSION}.tar.gz && \
    rm v${LIBJWT_VERSION}.tar.gz && \
    cd libjwt-${LIBJWT_VERSION}/ && \
    autoreconf -i && \
    ./configure --without-openssl && \
    make && \
    make install && \
    # Download and install Glewlwyd package
    cd /opt && \
    wget https://github.com/babelouest/glewlwyd/releases/download/v${GLEWLWYD_VERSION}/glewlwyd-full_${GLEWLWYD_VERSION}_Debian_stretch_x86_64.tar.gz && \
    tar -xf glewlwyd-full_${GLEWLWYD_VERSION}_Debian_stretch_x86_64.tar.gz && \
    rm glewlwyd-full_${GLEWLWYD_VERSION}_Debian_stretch_x86_64.tar.gz && \
    dpkg -i liborcania_*.deb && \
    dpkg -i libyder_*.deb && \
    dpkg -i libulfius_*.deb && \
    dpkg -i libhoel_*.deb && \
    dpkg -i glewlwyd_*.deb && \
    rm -rf * && \
    ldconfig

COPY ["entrypoint.sh", "/"]

EXPOSE 4593

CMD ["/entrypoint.sh"]
