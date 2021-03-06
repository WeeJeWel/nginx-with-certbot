# Nginx with Certbot

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
```

Then create a server in `./data/nginx/`, e.g. `plex.conf`:

```
server {
    server_name myserver.com;

    location / {
        return 200 'Hello!';
    }
}
```

To reload nginx, run inside your Docker container:

```bash
$ nginx -s reload
```

> TODO: Make an easier command for this.

To request a new certificate, run inside your Docker container:

```bash
$ certbot --nginx --non-interactive --agree-tos -m webmaster@google.com -d myserver.com
```

> TODO: Make an easier command for this.

## Building


```bash
$ docker buildx build --tag nginx-with-certbot .
```
