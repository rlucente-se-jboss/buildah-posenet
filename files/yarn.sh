#!/bin/bash

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

cd /opt/app-root/src/node_modules/@tensorflow-models/posenet/demos
yarn upgrade caniuse-lite browserslist
yarn
yarn watch

