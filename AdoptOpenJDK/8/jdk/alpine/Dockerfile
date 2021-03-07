ARG IMAGE_VERSION=jdk8u275-b01_openj9-0.23.0-alpine
FROM adoptopenjdk/openjdk8-openj9:$IMAGE_VERSION AS baseimage
MAINTAINER blueapple <blueapple1120@qq.com>

ENV LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh' LC_ALL='zh_CN.UTF-8'
ENV GOSU_VERSION=1.12

RUN apk add --no-cache tzdata --virtual .build-deps curl binutils zstd .gosu-deps; \
    GLIBC_VER="2.31-r0"; \
    ALPINE_GLIBC_REPO="https://github.com/sgerrand/alpine-pkg-glibc/releases/download"; \
    GCC_LIBS_URL="https://archive.archlinux.org/packages/g/gcc-libs/gcc-libs-10.1.0-2-x86_64.pkg.tar.zst"; \
    GCC_LIBS_SHA256="f80320a03ff73e82271064e4f684cd58d7dbdb07aa06a2c4eea8e0f3c507c45c"; \
    ZLIB_URL="https://archive.archlinux.org/packages/z/zlib/zlib-1%3A1.2.11-3-x86_64.pkg.tar.xz"; \
    ZLIB_SHA256=17aede0b9f8baa789c5aa3f358fbf8c68a5f1228c5e6cba1a5dd34102ef4d4e5; \
    curl -LfsS https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub; \
    SGERRAND_RSA_SHA256="823b54589c93b02497f1ba4dc622eaef9c813e6b0f0ebbb2f771e32adf9f4ef2"; \
    echo "${SGERRAND_RSA_SHA256} */etc/apk/keys/sgerrand.rsa.pub" | sha256sum -c -; \
    curl -LfsS ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-${GLIBC_VER}.apk > /tmp/glibc-${GLIBC_VER}.apk; \
    apk add --no-cache /tmp/glibc-${GLIBC_VER}.apk; \
    curl -LfsS ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk > /tmp/glibc-bin-${GLIBC_VER}.apk; \
    apk add --no-cache /tmp/glibc-bin-${GLIBC_VER}.apk; \
    curl -Ls ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk > /tmp/glibc-i18n-${GLIBC_VER}.apk; \
    apk add --no-cache /tmp/glibc-i18n-${GLIBC_VER}.apk; \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true; \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh; \
    curl -LfsS ${GCC_LIBS_URL} -o /tmp/gcc-libs.tar.zst; \
    echo "${GCC_LIBS_SHA256} */tmp/gcc-libs.tar.zst" | sha256sum -c -; \
    mkdir /tmp/gcc; \
    zstd -d /tmp/gcc-libs.tar.zst --output-dir-flat /tmp; \
    tar -xf /tmp/gcc-libs.tar -C /tmp/gcc; \
    mv /tmp/gcc/usr/lib/libgcc* /tmp/gcc/usr/lib/libstdc++* /usr/glibc-compat/lib; \
    strip /usr/glibc-compat/lib/libgcc_s.so.* /usr/glibc-compat/lib/libstdc++.so*; \
    curl -LfsS ${ZLIB_URL} -o /tmp/libz.tar.xz; \
    echo "${ZLIB_SHA256} */tmp/libz.tar.xz" | sha256sum -c -; \
    mkdir /tmp/libz; \
    tar -xf /tmp/libz.tar.xz -C /tmp/libz; \
    mv /tmp/libz/usr/lib/libz.so* /usr/glibc-compat/lib; \
    apk del --purge .build-deps .fetch-deps glibc-i18n; \
    apk add --no-cache \
    curl \
    tzdata \
    bash \
    bash-completion \
    vim \
    ttf-dejavu \
    busybox-extras \
    mkfontscale \
    mkfontdir \
    fontconfig \
    coreutils \
    dpkg \
    dumb-init; \
    cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    echo "Asia/Shanghai" > /etc/timezone; \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    chmod +x /usr/local/bin/gosu; \
    ln -s /usr/local/bin/gosu /usr/bin/gosu; \
    gosu nobody true; \
    apk del tzdata zst .gosu-deps dpkg; \
    rm -rf /tmp/*.apk /tmp/gcc /tmp/gcc-libs.tar* /tmp/libz /tmp/libz.tar.xz /var/cache/apk/*; \
    echo "SCC generation phase completed"; \
    # /dev/urandom is used as random source, which is perfectly safe
    # according to http://www.2uo.de/myths-about-urandom/
    sed -i 's/securerandom.source\=file\:\/dev\/random/securerandom.source\=file\:\/dev\/urandom/g' /opt/java/openjdk/jre/lib/security/java.security; \
    # Set alias ll、ls、mv、rm                       
    echo '\
            PS1='\''\[\e[01;33m\][\h \u:\[\e[01;34m\]\w\[\e[01;33m\]]\[\e[00m\]\$ '\'' ; \
            eval `dircolors -b` ; \
            alias ls="ls --color=auto" ; \
            alias l="ls -lah" ; \
            alias ll="ls -lh" ; \
            alias l.="ls -d .* --color=auto" ; \
            alias mv="mv -i" ; \
            alias rm="rm -i" ; \
            export PATH='"${PATH}"' \
    ' >> /etc/profile; \
    echo '. ~/.bashrc' > /root/.bash_profile; \
    echo '. /etc/profile' > /root/.bashrc
WORKDIR /deployments
# JAVA_APP_DIR is used by run-java.sh for finding the binaries
ENV JAVA_APP_DIR=/deployments
