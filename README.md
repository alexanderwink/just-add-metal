# Just add metal 🤘

All in one docker compose, complete with nginx, auto updating certbot (lets encrypt), application of your choice with rolling update.

The existing self signed certificate and key in this repo will be replaced by the init script for let encrypt during the first time setup. They need to be present for the init to work properly. Make sure the path has your domain in it, see below.

Add your own application for the `app` service in the compose file. Your application **must** have a healthcheck for the rolling update to work.

## First time setup

Make sure you replace `example.org` with your own domain in init-letsencrypt.sh and data/nginx/app.conf. Then run the init script.

```
./init-letsencrypt.sh
```

## Rolling update

This script will pull a new application image, scale up to 2 replicas, check for health and then remove the container running the older image. All in a rolling update manner using nothing but docker compose. No downtime.

```
./redeploy.sh
```

## Attribution

This work is somewhat based of previous work made by https://github.com/wmnnd/nginx-certbot
