FROM blueapple/baseimage:base

MAINTAINER blueapple <blueapple1120@qq.com>

RUN set -x \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
    && echo 'http://mirrors.aliyun.com/alpine/edge/testing' >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache --allow-untrusted --update-cache \
               wget vim curl \
               openssh-client git perl make less \
               bash bash-completion \
               htop iftop \
               busybox-extras \
               coreutils \
               ca-certificates \
               libtool \
               gcc \
               ttf-dejavu \
               fontconfig \
               wqy-zenhei@edge wqy-zenhei \
               apk-tools \
               netcat-openbsd \
               bind-tools \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    \
    && sed -i -e 's/\/bin\/ash/\/bin\/bash/' /etc/passwd \
    \
    \
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
    && echo '. /etc/profile' > /root/.bashrc \
    && apk del glibc-i18n \
    && rm -rf /etc/apk/keys/sgerrand.rsa.pub \
    && /bin/rm -rf /tmp/* \
       /var/cache/apk/* \
       /var/lib/apt/lists/* \
    && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
    && echo "export LANG=$LANG" > /etc/profile.d/locale.sh

# Agent bond including Jolokia and jmx_exporter
ADD agent-bond-opts /opt/run-java-options
RUN mkdir -p /opt/agent-bond \
 && curl http://central.maven.org/maven2/io/fabric8/agent-bond-agent/1.2.0/agent-bond-agent-1.2.0.jar \
          -o /opt/agent-bond/agent-bond.jar \
 && chmod 444 /opt/agent-bond/agent-bond.jar \
 && chmod 755 /opt/run-java-options
ADD jmx_exporter_config.yml /opt/agent-bond/
EXPOSE 8778 9779

# Add run script as /deployments/run-java.sh and make it executable
COPY run-java.sh /deployments/
RUN chmod 755 /deployments/run-java.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD [ "/bin/bash", "-c", "/deployments/run-java.sh" ]
