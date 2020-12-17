ARG IMAGE_VERSION=jdk8u275-b01_openj9-0.23.0-alpine
FROM adoptopenjdk/openjdk8-openj9:$IMAGE_VERSION AS baseimage
MAINTAINER blueapple <blueapple1120@qq.com>

ENV LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh' LC_ALL='zh_CN.UTF-8'
RUN set -eux; \
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
    dumb-init; \
    cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    echo "Asia/Shanghai" > /etc/timezone; \
    apk del .scc-deps tzdata; \
    rm -rf /var/cache/apk/*; \
    echo "SCC generation phase completed"; \
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
