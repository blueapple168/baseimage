ARG ALPINE_VERSION=latest
FROM alpine:$ALPINE_VERSION as baseimage

MAINTAINER blueapple <blueapple1120@qq.com>

ENV GLIBC_VERSION=2.28-r0
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=Asia/Shanghai

USER root

RUN mkdir -p /deployments

# JAVA_APP_DIR is used by run-java.sh for finding the binaries
ENV JAVA_APP_DIR=/deployments \
    JAVA_MAJOR_VERSION=8 \
    GOSU_VERSION=1.11

RUN set -x \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
    && echo 'http://mirrors.aliyun.com/alpine/edge/testing' >> /etc/apk/repositories \
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
# Install glibc..
RUN apk add --update \
    curl \
    wget \
    openssh-client \
    iftop \
    perl \
    make \
    less \
    ca-certificates \
    libgcc \
    libtool \
    openjdk8=8.181.13-r0 \
    bash \
    bash-completion \
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
    && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/default-jvm/jre/lib/security/java.security \
    && echo '\
            . /etc/profile ; \
            PS1='\''\[\e[01;33m\][\h \u:\[\e[01;34m\]\w\[\e[01;33m\]]\[\e[00m\]\$ '\'' ; \
            eval `dircolors -b` ; \
            alias ls="ls --color=auto" ; \
            alias l="ls -lah" ; \
            alias ll="ls -lh" ; \
            alias l.="ls -d .* --color=auto" ; \
            alias mv="mv -i" ; \
            alias rm="rm -i" ; \
    ' >> /etc/bash.bashrc \
    && echo '. ~/.bashrc' > /root/.bash_profile \
    && echo '. /etc/bash.bashrc' > /root/.bashrc \
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
    && apk del glibc-i18n \
    && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-i18n-${GLIBC_VERSION}.apk \
    && rm -rf /glibc-dev-${GLIBC_VERSION}.apk \
    && rm -rf /etc/apk/keys/sgerrand.rsa.pub \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && mkdir -p /usr/share/fonts \
                /root/.local/share/fonts \
                /root/.fonts \
                /root/.cache/fontconfig \
                /root/.fontconfig \
    && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
    && echo "export LANG=$LANG" > /etc/profile.d/locale.sh \
# Set environment
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
# Agent bond including Jolokia and jmx_exporter
ADD agent-bond-opts /opt/run-java-options
RUN mkdir -p /opt/agent-bond \
 && curl http://central.maven.org/maven2/io/fabric8/agent-bond-agent/1.2.0/agent-bond-agent-1.2.0.jar \
         -C -o /opt/agent-bond/agent-bond.jar --progress \
 && chmod 444 /opt/agent-bond/agent-bond.jar \
 && chmod 755 /opt/run-java-options
ADD jmx_exporter_config.yml /opt/agent-bond/
EXPOSE 8778 9779 8080

# Add run script as /deployments/run-java.sh and make it executable
COPY run-java.sh /deployments/
RUN chmod 755 /deployments/run-java.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD [ "/bin/bash", "-c", "/deployments/run-java.sh" ]
