ARG ALPINE_VERSION=3.8
FROM alpine:$ALPINE_VERSION as baseimage
MAINTAINER blueapple <blueapple1120@qq.com>

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8
ENV GLIBC_VERSION=2.28-r0
ENV LANG C.UTF-8
ENV LANGUAGE zh_CN:zh  
ENV LC_ALL zh_CN.UTF-8
USER root

RUN mkdir -p /deployments

# JAVA_APP_DIR is used by run-java.sh for finding the binaries
ENV JAVA_APP_DIR=/deployments \
    JAVA_MAJOR_VERSION=8

ENV GOSU_VERSION 1.11
# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u191
ENV JAVA_ALPINE_VERSION 8.191.12-r0

RUN set -x \
	&& apk add --no-cache --virtual .gosu-deps \
       dpkg \
	   tzdata \
	   tree \
	   openjdk8="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ] \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
#Install gosu
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && chmod +x /usr/local/bin/gosu \
    && ln -s /usr/local/bin/gosu /usr/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps dpkg
#Install other app
RUN apk add --update && \
    apk upgrade && \
    apk add --no-cache bash \
    bash-completion \
    curl \
    wget \
    ca-certificates \
    libgcc \
    sqlite \
    sqlite-dev \
    busybox-extras \
    tree \
    tzdata \
    mkfontscale \
    mkfontdir \
    fontconfig \
    ttf-dejavu \
    wqy-zenhei@edge wqy-zenhei \
    git \
    dumb-init \
    su-exec \
# /dev/urandom is used as random source, which is perfectly safe
# according to http://www.2uo.de/myths-about-urandom/    
    && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/default-jvm/jre/lib/security/java.security \
# Install glibc
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
    && mkdir -p /usr/share/fonts \
                /root/.local/share/fonts \
                /root/.fonts \
                /root/.cache/fontconfig \
                /root/.fontconfig \
    && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
    && echo "export LANG=$LANG" > /etc/profile.d/locale.sh \
    && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-i18n-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-dev-${GLIBC_VERSION}.apk \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/apk/keys/sgerrand.rsa.pub \
    && apk del .build-deps \
                       tree \
                       tzdata \
                       glibc-i18n
