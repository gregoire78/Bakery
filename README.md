# Bakery 🍪 Cookie clicker

Made with [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui) docker image

Docker image with Firefox and autoclicker.

## xclicker

Image with [xclicker](https://github.com/robiot/xclicker)

```sh
docker pull ghcr.io/gregoire78/bakery:xclicker-latest
```

## autoclic-app

Image with [autoclic-app](https://github.com/gregoire78/autoclic)

```sh
docker pull ghcr.io/gregoire78/bakery:autoclic-latest
```

## Dockerfile

```sh
  bakery:
    image: ghcr.io/gregoire78/bakery:autoclic-latest
    container_name: bakery
    ports:
      - 5800:5800
      - 5900:5900
    volumes:
      - bakery:/config
    environment:
      - WEB_AUTHENTICATION=1
      - WEB_AUTHENTICATION_USERNAME=******
      - WEB_AUTHENTICATION_PASSWORD=******
      - SECURE_CONNECTION=1
    restart: unless-stopped
```
