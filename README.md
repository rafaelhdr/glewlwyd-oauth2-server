# Docker image for Glewlwyd Oauth 2 authentication server

This Docker image is based on [Glewlwyd Oauth 2 authentication server](https://github.com/babelouest/glewlwyd).

# Quickstart

After creating the Quickstart, use as admin (username: *admin*, password: *password*).

## Quickstart SQLite3

Run `docker run --rm -it -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server:1.0-sqlite3-quickstart` and access http://localhost:4593.

If you want to persist SQLite database, mount volume `/var/cache/glewlwyd`, as below:

`docker run -it -v $PWD/cache:/var/cache/glewlwyd -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server:1.0-sqlite3-quickstart`

## Quickstart MariaDB

[Install Docker Compose](https://docs.docker.com/compose/install/). Run:

```
wget https://raw.githubusercontent.com/rafaelhdr/glewlwyd-oauth2-server/master/mariadb/quickstart/docker-compose.yml
docker-compose up
```

Access http://localhost:4593.

# Prepare for production

## Configuration file

Create a file *glewlwyd.conf* (sample [here](https://github.com/babelouest/glewlwyd/blob/master/glewlwyd.conf.sample)), and mount as `/var/glewlwyd/conf`.

Example:

```
# cd /path/to/project
mkdir conf
wget https://raw.githubusercontent.com/rafaelhdr/glewlwyd-oauth2-server/master/sqlite3/quickstart/glewlwyd.sqlite3.conf
mv glewlwyd.sqlite3.conf conf/glewlwyd.conf
# Edit your conf/glewlwyd.conf
docker run --rm -it -v $PWD/conf:/var/glewlwyd/conf -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server:1.0-sqlite3-quickstart
```

More about configuration at https://github.com/babelouest/glewlwyd#configuration.

More about volume options at [Volumes](#volumes).

## Define admin username and password

By default, the username and password for admin are admin/password.

Access the front-end application, and after log in, edit Admin user.

## Define keys or secrets

By default, it generate RSA key at folder `/var/glewlwyd/keys/`.

### RSA key

Keep default configuration and mount folder `/var/glewlwyd/keys/`.

```
docker run --rm -it -v $PWD/keys:/var/glewlwyd/keys -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server:1.0-sqlite3-quickstart
```

Keep the public key to verify signature. The private key are used to generate the token.

### SHA key

Edit the default configuration (check how at [Configuration file](#configuration-file)) changing `use_rsa = false`, `use_sha = false` and change your secret at `sha_secret = "secret"`. Run your instance mounting the configuration file folder.

```
docker run --rm -it -v $PWD/conf:/var/glewlwyd/conf -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server:1.0-sqlite3-quickstart
```

Use the secret to verify signature.

## SSL/TLS

OAuth 2 specifies that a secured connection is mandatory.

An easy and free option is to use Let's Encrypt. Check the tutorial [Proxy with Caddy Server](https://github.com/rafaelhdr/glewlwyd-oauth2-server/blob/master/tutorials/proxy-with-caddy-server.md).

# Volumes

`/var/glewlwyd/conf` - Store glewdlwyd.conf file (and also, examples of MariaDB and SQLite config files).

`/var/glewlwyd/keys` - Store private and public key. These keys are generated on container creation. You can create by yourself with the following commands:

```
openssl genrsa -out private.key 4096 && \
openssl rsa -in private.key -outform PEM -pubout -out public.pem
# Copy and paste the files private.key and public.pem to your volume
```

# Tutorials

- [Proxy with Caddy Server](https://github.com/rafaelhdr/glewlwyd-oauth2-server/blob/master/tutorials/proxy-with-caddy-server.md)

# TODO

- Quickstart with LDAP
- Different build for mysql/sqlite/ldap
- Images with alpine linux
- Custom build with environment variables
- Check [best practises](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)
- Automate deploy images (if possible)
- Tests on build
