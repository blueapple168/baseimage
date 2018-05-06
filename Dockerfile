FROM  alpine:3.7

MAINTAINER blueapple <blueapple1120@qq.com>

ENV GLIBC_VERSION=2.26-r0

# Install glibc
RUN apk add --no-cache --virtual .build-deps ca-certificates wget libgcc \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk \
    && apk add --allow-untrusted glibc-bin-${GLIBC_VERSION}.apk glibc-${GLIBC_VERSION}.apk glibc-i18n-${GLIBC_VERSION}.apk

# Install openjdk8
RUN apk update \
    && apk add curl bash tree tzdata openjdk8 \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tree \
               wget \
    && rm -rf /var/cache/apk/* \
    && apk del .build-deps \
    && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-i18n-${GLIBC_VERSION}.apk

# Set environment
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
