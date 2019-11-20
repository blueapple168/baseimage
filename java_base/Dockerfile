ARG ALPINE_VERSION=3.9
FROM alpine:$ALPINE_VERSION as baseimage
MAINTAINER blueapple <blueapple1120@qq.com>

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8
ENV LANGUAGE zh_CN:zh  
ENV LC_ALL zh_CN.UTF-8
ENV GLIBC_VERSION=2.29-r0

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

ENV JAVA_VERSION 8u212
ENV JAVA_ALPINE_VERSION 8.212.04-r0

RUN set -x \
    && apk add --no-cache \
        openjdk8="$JAVA_ALPINE_VERSION" \
    && [ "$JAVA_HOME" = "$(docker-java-home)" ]
# Install gosu && set time zone
RUN set -x \
    && apk add --no-cache --virtual \
    .gosu-deps \
    dpkg \
    tzdata \
    tree \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && chmod +x /usr/local/bin/gosu \
    && ln -s /usr/local/bin/gosu /usr/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps dpkg
#Install other app
RUN apk add --update && \
    apk upgrade && \
    apk add --no-cache \
    bash \
    bash-completion \
    curl \
    wget \
    vim \
    ca-certificates \
    libgcc \
    ttf-dejavu \
    busybox-extras \
    tree \
    tzdata \
    mkfontscale \
    mkfontdir \
    fontconfig \
    dumb-init \
    su-exec \
    coreutils \
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
# /dev/urandom is used as random source, which is perfectly safe
# according to http://www.2uo.de/myths-about-urandom/
    && sed -i 's/securerandom.source\=file\:\/dev\/random/securerandom.source\=file\:\/dev\/urandom/g' /usr/lib/jvm/default-jvm/jre/lib/security/java.security \
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
                       glibc-i18n \
                       
# Set alias ll、ls、mv、rm                       
    && echo '\
            PS1='\''\[\e[01;33m\][\h \u:\[\e[01;34m\]\w\[\e[01;33m\]]\[\e[00m\]\$ '\'' ; \
            eval `dircolors -b` ; \
            alias ls="ls --color=auto" ; \
            alias l="ls -lah" ; \
            alias ll="ls -lh" ; \
            alias l.="ls -d .* --color=auto" ; \
            alias mv="mv -i" ; \
            alias rm="rm -i" ; \
            export PATH='"${PATH}"' \
    ' >> /etc/profile \
    && echo '. ~/.bashrc' > /root/.bash_profile \
    && echo '. /etc/profile' > /root/.bashrc
