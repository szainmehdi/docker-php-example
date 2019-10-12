#!/usr/bin/env bash
set -e
network=$(docker network ls | grep example-app || docker network create example-app)
docker run -d --network=example-app --name=example-app docker-example/app
docker run -d -p 80:80 --link=example-app:app \
  --network=example-app \
  --volume "$PWD/docker/nginx/certs:/etc/nginx/certs" \
   docker-example/nginx
