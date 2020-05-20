#!/bin/sh
docker ps | awk '/edk2/ {print $1}' | xargs docker kill
