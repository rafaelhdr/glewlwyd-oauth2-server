# Docker image for Glewlwyd Oauth 2 authentication server

This Docker image is based on [Glewlwyd Oauth 2 authentication server](https://github.com/babelouest/glewlwyd).

**This project is not ready for production**

# Quickstart

## Quickstart SQLite3

Run `docker run --rm -it -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server` and access http://localhost:4593.

## Quickstart MariaDB

[Install Docker Compose](https://docs.docker.com/compose/install/). Run:

```
wget https://raw.githubusercontent.com/rafaelhdr/glewlwyd-oauth2-server/master/docker-compose.mysql.yml
mv docker-compose.mysql.yml docker-compose.yml
docker-compose up -d
```

# Persisting sqlite database

Run `docker run --rm -it -v $PWD/cache:/var/cache/glewlwyd -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server`

# Testing your glewlwyd.conf

Run at the terminal:

```
git clone https://github.com/rafaelhdr/glewlwyd-oauth2-server
mkdir conf
cp glewlwyd.conf conf/
docker run --rm -it -v $PWD/conf:/var/conf -p 4593:4593 rafaelhdr/glewlwyd-oauth2-server bash
/entrypoint.sh
```

Your server is running. Edit your file conf/glewlwyd.conf, and reload your application with:

```
# Ctrl + C
/entrypoint.sh
```
