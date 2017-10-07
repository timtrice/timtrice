#!/bin/bash
docker-compose build --force-rm

docker run --name web -dit -p 8787:8787 web_web

$SHELL
