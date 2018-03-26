#!/bin/bash

container_id=$(docker ps -a | grep pafortin/goaws | cut -d' ' -f1)
if [ -z "$container_id" ]; then
  docker run -d --name goaws -p 4100:4100 pafortin/goaws
else
  is_up=$(docker ps -a | grep pafortin/goaws | grep Up | cut -d' ' -f1)
  if [ -z "$is_up" ]; then
    docker start $container_id
  else
    echo $container_id
  fi
fi
