ARG ALPINE_VERSION=3.8
FROM alpine:$ALPINE_VERSION as baseimage

MAINTAINER blueapple <blueapple1120@qq.com>

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
RUN set -x \
    && apk update \
    && apk upgrade \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        bash \
        bash-completion \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && chmod +x /usr/local/bin/gosu \
    && ln -s /usr/local/bin/gosu /usr/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps dpkg

# /dev/urandom is used as random source, which is perfectly safe
# according to http://www.2uo.de/myths-about-urandom/
RUN set -x \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
    && echo 'http://mirrors.aliyun.com/alpine/edge/testing' >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache --allow-untrusted --update-cache \
    curl \
    wget \
    ca-certificates \
    libgcc \
    sqlite \
    sqlite-dev \
    openjdk8=8.181.13-r0 \
    tree \
    tzdata \
    mkfontscale \
    mkfontdir \
    fontconfig \
    git \
    dumb-init \
    su-exec \
    ttf-dejavu \
    wqy-zenhei@edge wqy-zenhei \
    apk-tools \
    netcat-openbsd \
    busybox-extras \
    coreutils \
    vim \
    openssh-client \
    perl \
    make \
    less \
    htop \
    iftop \
    && rm /var/cache/apk/* \
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
                                 
    && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-i18n-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-dev-${GLIBC_VERSION}.apk \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/* \
    && apk del .build-deps \
                       tree \
                       tzdata \
    && mkdir -p /usr/share/fonts \
                /root/.local/share/fonts \
                /root/.fonts \
                /root/.cache/fontconfig \
                /root/.fontconfig \
    && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
    && echo "export LANG=$LANG" > /etc/profile.d/locale.sh
# Set environment
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
