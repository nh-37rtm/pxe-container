#! /bin/bash
docker-compose down
docker-compose rm
docker-compose up --build --detach
