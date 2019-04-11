FROM centos:7

RUN yum install -y \
    wget \ 
    protobuf-2.5.0 \
    protobuf-compiler-2.5.0 \
    which \
    java-1.8.0-openjdk-devel \
    zlib-devel \
    xz-devel \
    openssl-devel \
    bzip2-devel \
    snappy-devel \
    cmake \
    make \
    gcc \
    gcc-c++ && \
    yum clean all

RUN mkdir /tmp/hadoop-src && \
    wget https://archive.apache.org/dist/hadoop/core/hadoop-2.6.0/hadoop-2.6.0-src.tar.gz -P /tmp/hadoop-src && \
    tar xf /tmp/hadoop-src/hadoop-2.6.0-src.tar.gz -C /tmp/hadoop-src

ARG MAVEN_VERSION=3.5.4

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share && \
    mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV JAVA_HOME=/usr/lib/jvm/java

RUN cd /tmp/hadoop-src/hadoop-2.6.0-src && \
    mvn package -Pdist,native -DskipTests -Dtar -Dmaven.javadoc.skip=true && \
    mkdir -p /opt/hadoop/native && \
    mv /tmp/hadoop-src/hadoop-2.6.0-src/hadoop-dist/target/hadoop-2.6.0/lib/native/libh*.so* /opt/hadoop/native && \
    rm -rf /tmp/hadoop-src