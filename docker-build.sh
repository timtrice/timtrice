#!/bin/bash
docker-compose build --force-rm

docker run --name andromeda -e MYSQL_ROOT_PASSWORD=qNlr0rZtf5VfGQ9m -d mariadb:10.3.1

docker run --name antila -e POSTGRES_PASSWORD=5aJhjS7g7SAzE56K -d postgres:9.6.5

docker run --name web --link andromeda --link antila -dit -p 8787:8787 web_web

$SHELL
