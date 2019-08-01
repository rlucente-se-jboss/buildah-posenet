FROM registry.access.redhat.com/ubi7/nodejs-8

ENV PATH="/opt/rh/rh-nodejs8/root/usr/bin:/opt/rh/rh-nodejs8/root/usr/lib/node_modules/npm/bin:${PATH}"
ENV TF_MOD=/opt/app-root/src/node_modules/@tensorflow-models/posenet

RUN    curl -sL https://github.com/rlucente-se-jboss/buildah-posenet/tarball/master | tar zx
RUN    npm install yarn
RUN    npm install rollup
RUN    npm install @tensorflow/tfjs
RUN    npm install @tensorflow-models/posenet
RUN    FILES=$(find . -type d -name files) \
    && cp -r $FILES/* $TF_MOD \
    && chmod +x $TF_MOD/yarn.sh \
    && rm -fr $FILES
RUN    chgrp -R 0 /opt/app-root /etc/passwd
    && chmod -R g=u /opt/app-root /etc/passwd

ENTRYPOINT $TF_MOD/yarn.sh
EXPOSE 1234
USER 1000 

