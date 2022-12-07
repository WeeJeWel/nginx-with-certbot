# Nginx with Certbot

[![Docker](https://img.shields.io/docker/pulls/weejewel/nginx-with-certbot.svg)](https://hub.docker.com/r/weejewel/nginx-with-certbot)
[![Sponsor](https://img.shields.io/github/sponsors/weejewel)](https://github.com/sponsors/WeeJeWel)
![GitHub Stars](https://img.shields.io/github/stars/weejewel/nginx-with-certbot)

This nginx container comes pre-installed with Certbot (Let's Encrypt) and automatically refreshes any certificates.

It's main purpose is to proxy local-running services to the internet with SSL, e.g. `plex.myserver.com`.

## Usage

```yaml
version: '3.8'
services:

  nginx:
    image: weejewel/nginx-with-certbot
    container_name: nginx-with-certbot
    ports:
      - "80:80/tcp"
      - "443:443/tcp"
    volumes:
      - ./data/nginx/:/etc/nginx/servers/
      - ./data/letsencrypt/:/etc/letsencrypt/

  plex:
   # ...
```

Then create a server in `./data/nginx/`, e.g. `plex.conf`:

```
server {
    server_name plex.myserver.com;

    location / {
        proxy_pass http://plex:32400/; # `plex` refers to a `plex` service in your docker-compose.yml
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
    }
}
```

To reload nginx, run:

```bash
$ docker exec nginx-with-certbot \ # Run inside Docker container
  nginx -s reload # Reload nginx
```

To request a new certificate, run:

```bash
$ docker exec nginx-with-certbot \ # Run inside Docker container
  certbot --nginx --non-interactive --agree-tos -m webmaster@google.com -d plex.myserver.com # Get HTTPS certificate
```

## Building

```bash
$ docker buildx build --tag nginx-with-certbot .
```
