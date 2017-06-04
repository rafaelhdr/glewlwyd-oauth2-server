# Proxy with Caddy Server

This tutorial is supposed to show how to generate a free proxy using Let's Encrypt. We will use sqlite3 as database and Caddy Server as HTTP Server.

# Requirements

- A domain (Let's Encrypt does not generate certificate for direct IP Address. [More about here](https://community.letsencrypt.org/t/certificate-for-public-ip-without-domain-name/6082))
- A server (the tutorial was tested with AWS EC2 server - Ubuntu t2.small)
- Docker Engine and Docker Compose installed

# Tutorial

Create a docker compose file (`docker-compose.yml`):

```
version: '3'

services:
  glewlwyd-oauth2-server:
    image: rafaelhdr/glewlwyd-oauth2-server:1.0-sqlite3-quickstart
    ports:
      - 4593:4593
    volumes:
      - ./conf:/var/glewlwyd/conf

  http-server:
    image: abiosoft/caddy:0.10.2
    ports:
      - 80:80
      - 443:443
    volumes:
      - ./Caddyfile:/etc/Caddyfile
      - ./.caddy:/root/.caddy
```

Create a Caddyfile (`Caddyfile`):

**Do not forget to use your domain**

```
example.com {
    proxy / glewlwyd-oauth2-server:4593 { 
        transparent
    }
}
```

Create a configuration file (`conf/glewlwyd.conf`):

```
wget https://raw.githubusercontent.com/rafaelhdr/glewlwyd-oauth2-server/master/sqlite3/quickstart/glewlwyd.sqlite3.conf
mv glewlwyd.sqlite3.conf conf/glewlwyd.conf
```

Edit `login_url` and `grant_url` of your configuration file.

**Do not forget to use your domain**

```
login_url="http://example.com/app/login.html?"
grant_url="http://example.com/app/grant.html?"
```

And all your configuration is done. You just need to start your application.

```
docker-compose up -d
```

**Do not forget to enable ports 80 and 443 to Security Groups, if using AWS EC2.**
