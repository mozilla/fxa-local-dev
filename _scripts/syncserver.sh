#!/bin/sh -ex

docker run --rm --name syncserver \
  -p 5000:5000 \
  -e SYNCSERVER_PUBLIC_URL=http://localhost:5000 \
  -e SYNCSERVER_IDENTITY_PROVIDER=http://host.docker.internal:3030 \
  -e SYNCSERVER_BROWSERID_VERIFIER=http://host.docker.internal:5050 \
  -e SYNCSERVER_SECRET=5up3rS3kr1t \
  -e SYNCSERVER_SQLURI=sqlite:////tmp/syncserver.db \
  -e SYNCSERVER_BATCH_UPLOAD_ENABLED=true \
  -e SYNCSERVER_FORCE_WSGI_ENVIRON=false \
  mozilla/syncserver:latest \
  /usr/local/bin/gunicorn --bind 0.0.0.0:5000 \
  syncserver.wsgi_app
