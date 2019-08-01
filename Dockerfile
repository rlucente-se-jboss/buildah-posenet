FROM registry.access.redhat.com/ubi7/nodejs-8

ENV PATH="/opt/rh/rh-nodejs8/root/usr/bin:/opt/rh/rh-nodejs8/root/usr/lib/node_modules/npm/bin:${PATH}"
ENV TF_MOD=/opt/app-root/src/node_modules/@tensorflow-models/posenet

USER   root
RUN    curl -sL https://github.com/rlucente-se-jboss/buildah-posenet/tarball/master | tar zx \
    && npm install yarn \
    && npm install rollup \
    && npm install @tensorflow/tfjs \
    && find /opt/app-root -type d -name '.git' -prune -exec rm -fr {} \; \
    && npm install @tensorflow-models/posenet \
    && FILES=$(find . -type d -name files) \
    && cp -r $FILES/* $TF_MOD \
    && chmod +x $TF_MOD/yarn.sh \
    && rm -fr $FILES \
    && chgrp -R 0 /opt/app-root /etc/passwd \
    && chmod -R g=u /opt/app-root /etc/passwd

ENTRYPOINT $TF_MOD/yarn.sh
EXPOSE 1234
USER 1000 

