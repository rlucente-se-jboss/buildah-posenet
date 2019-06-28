FROM registry.access.redhat.com/ubi7/nodejs-8

ENV NPM_BIN=/opt/rh/rh-nodejs8/root/usr/lib/node_modules/npm/bin
ENV TF_MOD=/opt/app-root/src/node_modules/@tensorflow-models/posenet

RUN    $NPM_BIN/npm install yarn \
    && $NPM_BIN/npm install rollup \
    && $NPM_BIN/npm install @tensorflow/tfjs \
    && $NPM_BIN/npm install @tensorflow-models/posenet

# understand what buildah command is doing
# buildah copy $container '/home/tbrunell/posenet/files/' '/opt/app-root/src/node_modules/@tensorflow-models/posenet'
COPY files/ $TF_MOD

# making the file group root enables this to run unprivileged
RUN    chmod +x $TF_MOD/yarn.sh \
    && chgrp -R root /opt/app-root

ENTRYPOINT $TF_MOD/yarn.sh

USER 1000 

