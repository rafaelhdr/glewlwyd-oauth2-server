FROM debian:stretch

# Install required packages
RUN apt-get update && \
		apt-get upgrade -y && \
    apt-get install -y \
    autoconf \
		automake \
		make \
		pkg-config \
    libjansson-dev \
		libssl-dev \
		libcurl3 \
    libconfig9 \
		libcurl3-gnutls \
    libgnutls30 \
		libgcrypt20 \
    libmicrohttpd12 \
    libsqlite3-0 \
		libmariadbclient18 \
    libtool \
    uuid \
    wget && \
    apt-get clean

ARG GLEWLWYD_VERSION=1.3.2-b.5
ARG LIBJWT_VERSION=1.9.0

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

# Download and install Glewlwyd package
    cd /opt && \
    wget https://github.com/babelouest/glewlwyd/releases/download/v${GLEWLWYD_VERSION}/glewlwyd-full_${GLEWLWYD_VERSION}_Debian-stretch-x86_64.tar.gz && \
    tar -xf glewlwyd-full_${GLEWLWYD_VERSION}_Debian-stretch-x86_64.tar.gz && \
    rm glewlwyd-full_${GLEWLWYD_VERSION}_Debian-stretch-x86_64.tar.gz && \
		dpkg -i liborcania_*.deb && \
		dpkg -i libyder_*.deb && \
		dpkg -i libulfius_*.deb && \
		dpkg -i libhoel_*.deb && \
		dpkg -i glewlwyd_*.deb

COPY ["entrypoint.sh", "/"]

EXPOSE 4593

CMD ["/entrypoint.sh"]
