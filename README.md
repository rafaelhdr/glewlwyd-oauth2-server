# Docker image for Glewlwyd Oauth 2 authentication server

This Docker image is based on [Glewlwyd Oauth 2 authentication server](https://github.com/babelouest/glewlwyd).

## Quickstart

After creating the Quickstart, use as admin (username: *admin*, password: *password*).

### Quickstart SQLite3

Run `docker run --rm -it -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server:1.2-sqlite3-quickstart` and access http://localhost:4593.

If you want to persist SQLite database, mount volume `/var/cache/glewlwyd`, as below:

`docker run -it -v $PWD/cache:/var/cache/glewlwyd -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server:1.2-sqlite3-quickstart`

### Quickstart MariaDB

[Install Docker Compose](https://docs.docker.com/compose/install/). Run:

```sh
wget https://raw.githubusercontent.com/rafaelhdr/glewlwyd-oauth2-server/master/mariadb/quickstart/docker-compose.yml
docker-compose up
```

Access [http://localhost:4593](http://localhost:4593).

## Installation

You will need the following:

1. Set database and/or LDAP
1. JWT configuration
1. Configuration file
1. Start Glewlwyd

### Set database or LDAP

#### Sqlite3

Create and initialise a sqlite database and mount it at the container (recommended `/var/cache/glewlwyd`). For example:

```shell
# Create your sqlite file at /path/to/cache/glewlwyd.db
docker run -it \
    -v /path/to/cache:/var/cache/glewlwyd \
    rafaelhdr/glewlwyd-oauth2-server:2.0-alpine
```

When creating the configuration file, fill with the database information, for example:

```conf
# SQLite database connection
database =
{
   type               = "sqlite3";
   path               = "/var/cache/glewlwyd/glewlwyd.db";
};
```

#### Mariadb/Mysql or LDAP

Create and initialise a Mariadb/Mysql/LDAP and connect in the same network of glewlwyd service (for example, with docker-compose).

For database/ldap initialisation, check [glewlwyd repository](https://github.com/babelouest/glewlwyd/blob/master/INSTALL.md#data-storage-backend-initialisation).

When creating the configuration file, fill with the database information, for example:

```conf
# MariaDB/Mysql database connection
database =
{
  type = "mariadb";
  host = "dbhost";
  user = "glewlwyd";
  password = "glewlwyd";
  dbname = "glewlwyd";
  port = 3306;
};

# Authentication configuration
authentication =
{
    ...
}
```

### JWT configuration

You can choose between SHA, RSA and ECDSA algorithms to sign the tokens.

#### SHA

Edit your [configuration file](#configuration-file) (`glewlwyd.conf`) with the secret and set SHA hash.

#### RSA or ECDSA

Create the keys and mount at the container.

```shell
# Create keys following https://github.com/babelouest/glewlwyd/blob/master/INSTALL.md#rsa-privatepublic-key-creation instructions
docker run \
    -v /path/to/keys:/var/glewlwyd/keys \
    rafaelhdr/glewlwyd-oauth2-server:2.0-alpine
```

And then, fill the information at the configuration file.

### Configuration file

Create a file *glewlwyd.conf* (sample [here](https://github.com/babelouest/glewlwyd/blob/master/glewlwyd.conf.sample)) and mount at your container (recommended `/var/glewlwyd/conf`).

Example:

```sh
# cd /path/to/project
mkdir conf
wget https://raw.githubusercontent.com/rafaelhdr/glewlwyd-oauth2-server/master/sqlite3/quickstart/glewlwyd.sqlite3.conf
mv glewlwyd.sqlite3.conf conf/glewlwyd.conf
# And edit your conf/glewlwyd.conf
```

### Start Glewlwyd

Run your glewlwyd:

```shell
docker run -it \
    -v $PWD/conf:/var/glewlwyd/conf \
    -p 4593:4593 \
    rafaelhdr/glewlwyd-oauth2-server:2.0-alpine
```

> You may also need to mount more volumes for sqlite (`-v $PWD/cache:/var/cache/glewlwyd`) and for private/public keys (`-v $PWD/keys:/var/glewlwyd/keys`).

If the command runned successfully, you can access at [http://localhost:4593](http://localhost:4593). Your *username/password* is *admin/password* (if you used the default initialisation data).

## SSL/TLS

OAuth 2 specifies that a secured connection is mandatory.

An easy and free option is to use Let's Encrypt. Check the tutorial [Proxy with Caddy Server](https://github.com/rafaelhdr/glewlwyd-oauth2-server/blob/master/tutorials/proxy-with-caddy-server.md).

## Volumes

* `/var/cache/glewlwyd` - Store sqlite3 database
* `/var/glewlwyd/conf` - Store glewdlwyd.conf file
* `/var/glewlwyd/keys` - Store private and public key

## Tutorials

* [Proxy with Caddy Server](https://github.com/rafaelhdr/glewlwyd-oauth2-server/blob/master/tutorials/proxy-with-caddy-server.md)
