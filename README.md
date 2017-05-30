# Docker image for Glewlwyd Oauth 2 authentication server

This Docker image is based on [Glewlwyd Oauth 2 authentication server](https://github.com/babelouest/glewlwyd).

**This project is not ready for production**

# Quickstart

After creating the Quickstart, use as admin (username: *admin*, password: *password*).

## Quickstart SQLite3

Run `docker run --rm -it -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server:sqlite3-quickstart` and access http://localhost:4593.

If you want to persist SQLite database, mount volume `/var/cache/glewlwyd`, as below:

`docker run -it -v $PWD/cache:/var/cache/glewlwyd -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server:sqlite3-quickstart`

## Quickstart MariaDB

[Install Docker Compose](https://docs.docker.com/compose/install/). Run:

```
wget https://raw.githubusercontent.com/rafaelhdr/glewlwyd-oauth2-server/master/mariadb/quickstart/docker-compose.yml
docker-compose up
```

Access http://localhost:4593.

# Custom configuration

## Configuration file

Create a file *glewlwyd.conf*, and mount as `/var/glewlwyd/conf`. Example:

```
mkdir conf
wget https://raw.githubusercontent.com/rafaelhdr/glewlwyd-oauth2-server/master/sqlite3/quickstart/glewlwyd.sqlite3.conf
mv glewlwyd.sqlite3.conf conf/glewlwyd.conf
# Edit your conf/glewlwyd.conf
docker run --rm -it -v $PWD/conf:/var/glewlwyd/conf -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server:sqlite3-quickstart
```

# Volumes

`/var/glewlwyd/conf` - Store glewdlwyd.conf file (and also, examples of MariaDB and SQLite config files).

`/var/glewlwyd/keys` - Store private and public key. These keys are generated on container creation. You can create by yourself with the following commands:

```
openssl genrsa -out private.key 4096 && \
openssl rsa -in private.key -outform PEM -pubout -out public.pem
# Copy and paste the files private.key and public.pem to your volume
```

# TODO

- Quickstart with LDAP
- Different build for mysql/sqlite/ldap
- Images with alpine linux
- Custom build with environment variables
- Check [best practises](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)
- Automate deploy images (if possible)
- Tests on build
- Documentation for SSH keys and password
