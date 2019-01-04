#!/bin/sh

source $PWD/_scripts/helpers.sh

git pull https://github.com/mozilla/fxa-local-dev.git master

update_node_repo 123done oauth
update_node_repo browserid-verifier
update_node_repo fxa-auth-db-mysql
update_node_repo fxa-auth-server
update_node_repo fxa-basket-proxy
update_node_repo fxa-content-server
update_node_repo fxa-profile-server

update_rust_repo fxa-email-service master fxa_email_send

# Migration
docker network create fxa-net 2> /dev/null || true # Don't error out in case the network already exists

update_docker_image mozilla/syncserver
update_docker_image mozilla/channelserver