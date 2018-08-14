ARG ALPINE_VERSION=latest
FROM alpine:$ALPINE_VERSION as baseimage

MAINTAINER blueapple <blueapple1120@qq.com>

ENV GLIBC_VERSION=2.28-r0

# Install glibc
RUN apk add --no-cache --virtual .build-deps ca-certificates wget libgcc \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-dev-${GLIBC_VERSION}.apk \
    && apk add --allow-untrusted glibc-bin-${GLIBC_VERSION}.apk \
                                 glibc-${GLIBC_VERSION}.apk \
                                 glibc-i18n-${GLIBC_VERSION}.apk \
                                 glibc-dev-${GLIBC_VERSION}.apk

# Install openjdk8 fontconfig
RUN apk update \
    && apk add curl bash tree tzdata openjdk8 mkfontscale mkfontdir fontconfig git openssh \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && mkdir -p /usr/share/fonts \
                /root/.local/share/fonts \
                /root/.fonts \
                /root/.cache/fontconfig \
                /root/.fontconfig \ 
    && apk del tree \
               wget \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/* \
    && apk del .build-deps \
    && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-i18n-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-dev-${GLIBC_VERSION}.apk

# Set environment
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
