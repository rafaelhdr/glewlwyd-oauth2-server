FROM alpine:3.7

# Install required packages
RUN apk add --no-cache \
		libcurl \
    libconfig \
    jansson \
    gnutls \
		libgcrypt \
    libmicrohttpd \
    sqlite-libs \
    libtool \
		libuuid \
		libldap \
		bash

COPY ["libs.tar.gz", "www.tar.gz", "/tmp/"]
COPY ["glewlwyd", "/usr/local/bin"]

# Configuration required for shared objects
RUN mkdir -p /var/glewlwyd/conf && \
		mkdir -p /var/glewlwyd/keys && \
    mkdir -p /var/cache/glewlwyd/ && \
    mkdir -p /var/www/ && \
		tar xvf /tmp/libs.tar.gz -C /usr/local/lib && \
		tar xvf /tmp/www.tar.gz -C /var/

WORKDIR /var/glewlwyd

COPY ["entrypoint.sh", "/"]

EXPOSE 4593

CMD ["/entrypoint.sh"]
