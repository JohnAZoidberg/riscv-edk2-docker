#!/bin/sh
docker exec \
  -it $(docker ps | awk '/edk2/ {print $1}') \
  /docker/build-edk2.sh \
  && notify-send "EDK2" "Success!" \
  || notify-send "EDK2" "FAILED to build!"
