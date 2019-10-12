#!/usr/bin/env bash
docker build --target nginx-prod -t docker-example/nginx:latest .
docker build --target app-prod -t docker-example/app:latest .
