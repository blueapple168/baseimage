## Docker for alpine_openjdk_glibc
# Supported tags and respective `Dockerfile` links
-	[`base`, `latest` (*Alpine/openjdk8/glibc/Dockerfile*)](https://github.com/blueapple188/baseimage/blob/master/java_base/Dockerfile)
-	[`auto_heap` (*Alpine/openjdk8/glibc/agent-bond/jmx_exporter/run-java.sh/Dockerfile*)](https://github.com/blueapple188/baseimage/blob/master/java_auto_heap/Dockerfile)
# Alpine Openjdk Base Images

This is a repository for Java Docker base images used in other projects.

The Java base images come in different flavors:

* Based on [Alpine Linux](https://www.alpinelinux.org/) (experimental)
* [OpenJDK 8](http://openjdk.java.net/projects/jdk8/)
* As JDK (Java Developer Toolkit) or as JRE (Java Runtime Environment)
* [Glibc](https://github.com/sgerrand/alpine-pkg-glibc) is the GNU C library as a Alpine Linux package to run binaries linked against glibc. This package utilizes a custom built glibc binary based on the vanilla glibc source. Built binary artifacts come from https://github.com/sgerrand/docker-glibc-builder.
* Other component.Etc.. curl bash tree tzdata openjdk8 mkfontscale mkfontdir fontconfig git openssh wget libgcc sqlite sqlite-dev

All images add the following features:

* [agent-bond](https://github.com/fabric8io/agent-bond) is included
  which combines [Jolokia](http://www.jolokia.org) and
  [jmx_exporter](https://github.com/prometheus/jmx_exporter)
* A startup script [run-java.sh](https://github.com/fabric8io/run-java-sh) is
  included which transparently starts Java application provided as FAT-jar or
  traditionally with a bunch of jar dependencies.

How to use these images and what environment variables can be used are
described in the associated [README](java_auto_heap/README.md) files.

Imags instructions
* The blueapple/alpine_glibc_basicimage/java_base is base alpine.
* The blueapple/alpine_glibc_basicimage/java_auto_heap's shell base [fabric8/java-jboss-openjdk8-jdk](https://hub.docker.com/r/fabric8/java-jboss-openjdk8-jdk/)
