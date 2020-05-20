#!/bin/sh
docker exec \
  -it $(docker ps | awk '/edk2/ {print $1}') \
  bash
