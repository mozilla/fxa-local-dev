#!/bin/bash -ex

# Set ulimit, need it for npm
ulimit -S -n 2048 || echo "Setting ulimit failed"

# Clone all the projects
echo "Clone all repos"

bash _scripts/clone_all.sh

wait

echo "Setup all the projects"

echo " * fxa-content-server"
cd fxa-content-server; npm i --production; npm i; cp server/config/local.json-dist server/config/local.json; cd ..

echo " * fxa-auth-server"
cd fxa-auth-server; npm i; node ./scripts/gen_keys.js; cd ..
# Install a custom http only verifier

echo " * browserid-verifier"
cd browserid-verifier; npm i; npm i vladikoff/browserid-local-verify#http; cd ..

echo " * fxa-oauth-server"
cd fxa-oauth-server; npm i; cd ..

echo " * fxa-oauth-console"
cd fxa-oauth-console; npm i; cd ..

echo " * fxa-profile-server"
cd fxa-profile-server; npm i; mkdir -p var/public/; cd ..

echo " * 123done"
cd 123done; npm i; CONFIG_123DONE=./config-local.json node ./scripts/gen_keys.js; cd ..

echo " * loop-server"
cd loop-server; npm i; cd ..

echo " * syncserver"
cd syncserver; make build; cd ..

ln -sf node_modules/.bin/pm2 pm2
