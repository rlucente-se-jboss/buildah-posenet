#!/usr/bin/env bash

set -x

pushd $(dirname $0) &> /dev/null

container=$(buildah from registry.access.redhat.com/ubi7/nodejs-8)

buildah run $container bash -c 'npm install yarn'
buildah run $container bash -c 'npm install rollup'
buildah run $container bash -c 'npm install @tensorflow/tfjs'
buildah run $container bash -c 'npm install @tensorflow-models/posenet'

buildah copy $container ./files/ /opt/app-root/src/node_modules/@tensorflow-models/posenet
buildah run $container -- chmod +x /opt/app-root/src/node_modules/@tensorflow-models/posenet/yarn.sh

# these two commands enable this to run unprivileged
buildah run --isolation chroot $container -- chgrp -R 0 /opt/app-root /etc/passwd
buildah run --isolation chroot $container -- chmod -R g=u /opt/app-root /etc/passwd

buildah config --user 1000 --port 1234 \
    --entrypoint '/opt/app-root/src/node_modules/@tensorflow-models/posenet/yarn.sh' $container

buildah commit $container posenet_demo
buildah unmount $container
buildah rm $container

popd &> /dev/null

