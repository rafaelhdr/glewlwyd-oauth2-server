# Deprecated

[Check the original project](https://github.com/babelouest/glewlwyd)

# Docker image for Glewlwyd Oauth 2 authentication server

This Docker image is based on [Glewlwyd Oauth 2 authentication server](https://github.com/babelouest/glewlwyd).

## Quickstart

> Quickstart is not supposed to be used in production environments. It is only for testing.
> The JWT configuration uses sha algorithm with the secret `secret` hard coded. So the tokens generated are **_NOT SAFE_**!

```shell
# Run the following
docker run --rm -it -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server:quickstart
```

After creating the Quickstart, use as admin (username: *admin*, password: *password*) at [http://localhost:4593](http://localhost:4593).

## Custom installation

To run your own docker instance, you need to pass the following steps:

1. [Get the configuration file](#get-the-configuration-file)
2. [Database configuration](#database-configuration)
3. [Authentication configuration](#authentication-configuration)
4. [JWT configuration](#jwt-configuration)
5. [Start Glewlwyd](#start-glewlwyd)

If you need more details, the complete documentation is available in the [Glewlwyd project page](https://github.com/babelouest/glewlwyd/blob/master/docs/INSTALL.md).

### Get the configuration file

Create a file *glewlwyd.conf* (sample [here](https://github.com/babelouest/glewlwyd/blob/master/glewlwyd.conf.sample)) and mount at your container (recommended `/var/glewlwyd/conf`).

Example:

```sh
# cd /path/to/project
mkdir conf
wget https://raw.githubusercontent.com/rafaelhdr/glewlwyd-oauth2-server/master/sqlite3/quickstart/glewlwyd.sqlite3.conf
mv glewlwyd.sqlite3.conf conf/glewlwyd.conf
# And edit your conf/glewlwyd.conf
```

### Database configuration

#### Sqlite3

Create and initialise a sqlite database and mount it at the container (recommended `/var/cache/glewlwyd`). For example:

```shell
# Create your sqlite file at /path/to/cache/glewlwyd.db
docker run -it \
    -v /path/to/cache:/var/cache/glewlwyd \
    rafaelhdr/glewlwyd-oauth2-server
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

#### Mariadb/Mysql

Create and initialise a Mariadb/Mysql and connect in the same network of glewlwyd service (for example, with docker-compose).

For database/ldap initialisation, check [glewlwyd repository](https://github.com/babelouest/glewlwyd/blob/master/docs/INSTALL.md#data-storage-backend-initialisation).

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
```

### Authentication configuration

Glewlwyd can use 3 different types of authentication configuration: database, LDAP or remote HTTP Basic Auth.

HTTP Basic Auth is specific because you can't use scopes with it by design.

If using database authentication, users will be stored in the database.

If using LDAP authentication, users will be stored in a LDAP server.

LDAP and Database authentication are possible at the same time. If a user is present in both, the LDAP back end will be checked first.

### JWT configuration

You can choose between SHA, RSA and ECDSA algorithms to sign the tokens. You can also choose between 256, 384 or 512 bits for the key size, as mentioned in the configuration file:

```conf

# jwt parameters
jwt =
{
   # key size for algorithms, values available are 256, 384 or 512, default 512
   key_size = 512
   
   # Use RSA algorithm to sign tokens (asymmetric)
   use_rsa = true
   
   # path to the key (private) certificate file to sign tokens
   rsa_key_file = "/usr/etc/glewlwyd/private-rsa.key"
   
   # path to the public certificate file to validate signatures
   rsa_pub_file = "/usr/etc/glewlwyd/public-rsa.pem"
   
   # Use ECDSA algorithm to sign tokens (asymmetric)
   use_ecdsa = false
   
   # path to the key (private) certificate file to sign tokens
   ecdsa_key_file = "/usr/etc/glewlwyd/private-ecdsa.key"
   
   # path to the public certificate file to validate signatures
   ecdsa_pub_file = "/usr/etc/glewlwyd/public-ecdsa.pem"
   
   # Use SHA algorithm to sign tokens (symmetric)
   use_sha = false
   
   # characters used to generate and validate the token
   sha_secret = "secret"
}
```

#### SHA

Edit your [configuration file](#configuration-file) (`glewlwyd.conf`) with the secret and set SHA hash.

#### RSA or ECDSA

Create the keys and mount at the container.

```shell
# Create keys following https://github.com/babelouest/glewlwyd/blob/master/docs/INSTALL.md#rsa-privatepublic-key-creation instructions
docker run \
    -v /path/to/keys:/var/glewlwyd/keys \
    rafaelhdr/glewlwyd-oauth2-server
```

And then, fill the information at the configuration file.

### Start Glewlwyd

Run Glewlwyd:

```shell
docker run -it \
    -v $PWD/conf:/var/glewlwyd/conf \
    -p 4593:4593 \
    rafaelhdr/glewlwyd-oauth2-server
    # you can choose between alpine and debian tags. Check available tags at:
    # https://hub.docker.com/r/rafaelhdr/glewlwyd-oauth2-server/tags/
```

> You may also need to mount more volumes for sqlite (`-v $PWD/cache:/var/cache/glewlwyd`) and for private/public keys (`-v $PWD/keys:/var/glewlwyd/keys`).

If the command ran successfully, you can access at [http://localhost:4593](http://localhost:4593). Your *username/password* is *admin/password* (if you used the default initialisation data).

## SSL/TLS

OAuth 2 specifies that a secured connection is mandatory.

An easy and free option is to use Glewlwyd behind a HTTPS proxy with a Let's Encrypt certificate. Check the tutorial [Proxy with Caddy Server](https://github.com/rafaelhdr/glewlwyd-oauth2-server/blob/master/tutorials/proxy-with-caddy-server.md).

## Volumes

* `/var/cache/glewlwyd` - Store sqlite3 database
* `/var/glewlwyd/conf` - Store glewdlwyd.conf file
* `/var/glewlwyd/keys` - Store private and public key

## Customize webfront

Copy custom webfront files to `/usr/share/glewlwyd/webapp/`.

```Dockerfile
FROM rafaelhdr/glewlwyd-oauth2-server:quickstart

COPY custom-index.html /usr/share/glewlwyd/webapp/index.html
```

## Tutorials

* [Proxy with Caddy Server](https://github.com/rafaelhdr/glewlwyd-oauth2-server/blob/master/tutorials/proxy-with-caddy-server.md)
