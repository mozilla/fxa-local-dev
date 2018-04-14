#!/bin/bash -ex
node ../fxa-auth-db-mysql/bin/db_patcher.js && node ../fxa-auth-db-mysql/bin/server.js
