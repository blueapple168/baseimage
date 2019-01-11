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
