ARG ALPINE_VERSION=latest
FROM alpine:$ALPINE_VERSION as baseimage

MAINTAINER blueapple <blueapple1120@qq.com>

ENV GLIBC_VERSION=2.28-r0

USER root

RUN mkdir -p /deployments

# JAVA_APP_DIR is used by run-java.sh for finding the binaries
ENV JAVA_APP_DIR=/deployments \
    JAVA_MAJOR_VERSION=8 \    
    GOSU_VERSION=1.11
    
RUN set -x \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && chmod +x /usr/local/bin/gosu \
    && ln -s /usr/local/bin/gosu /usr/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps dpkg
# /dev/urandom is used as random source, which is perfectly safe
# according to http://www.2uo.de/myths-about-urandom/
RUN apk add --update \
    curl \
    wget \
    ca-certificates \
    libgcc \
    sqlite \
    sqlite-dev \
    openjdk8=8.181.13-r0 \
    bash \
    tree \
    tzdata \
    mkfontscale \
    mkfontdir \
    fontconfig \
    git \
    dumb-init \
    su-exec \
    && rm /var/cache/apk/* \
    && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/default-jvm/jre/lib/security/java.security \
# Install glibc sqlite
    && apk add --no-cache --virtual .build-deps \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-dev-${GLIBC_VERSION}.apk \
    && apk add --allow-untrusted glibc-bin-${GLIBC_VERSION}.apk \
                                 glibc-${GLIBC_VERSION}.apk \
                                 glibc-i18n-${GLIBC_VERSION}.apk \
                                 glibc-dev-${GLIBC_VERSION}.apk \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/* \
    && apk del .build-deps \
    && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-i18n-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-dev-${GLIBC_VERSION}.apk \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && mkdir -p /usr/share/fonts \
                /root/.local/share/fonts \
                /root/.fonts \
                /root/.cache/fontconfig \
                /root/.fontconfig \ 
# Set environment
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
