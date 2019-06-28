FROM registry.access.redhat.com/ubi7/nodejs-8

RUN    npm install yarn \
    && npm install rollup \
    && npm install @tensorflow/tfjs \
    && npm install @tensorflow-models/posenet

# make sure to copy all the files to posenet sub
# understand what buildah command is doing
# buildah copy $container '/home/tbrunell/posenet/files/' '/opt/app-root/src/node_modules/@tensorflow-models/posenet'
COPY files/ /opt/app-root/src/node_modules/@tensorflow-models/posenet

# making the file group root enables this to run unprivileged
RUN    chmod +x /opt/app-root/src/node_modules/@tensorflow-models/posenet/yarn.sh \
    && chgrp -R root /opt/app-root

ENTRYPOINT /opt/app-root/src/node_modules/@tensorflow-models/posenet/yarn.sh

USER 1000 

