FROM registry.access.redhat.com/ubi7/nodejs-8

ENV PATH="/opt/rh/rh-nodejs8/root/usr/bin:/opt/rh/rh-nodejs8/root/usr/lib/node_modules/npm/bin:${PATH}"
ENV TF_MOD=/opt/app-root/src/node_modules/@tensorflow-models/posenet

RUN    curl -sL https://github.com/rlucente-se-jboss/buildah-posenet/tarball/master | tar zx \
    && FILES=$(find . -type d -name files) \
    && npm install yarn \
    && npm install rollup \
    && npm install @tensorflow/tfjs \
    && npm install @tensorflow-models/posenet \
    && cp -r $FILES/* $TF_MOD \
    && chown -R default:root /opt/app-root \
    && chgrp -R root /opt/app-root \
    && chmod -R g+rwX /opt/app-root \
    && chmod +x $TF_MOD/yarn.sh \
    && rm -fr $FILES

ENTRYPOINT $TF_MOD/yarn.sh
EXPOSE 1234

USER 1000 

