ARG HADOOP_VERSION

FROM dtspence/hadoop-native:${HADOOP_VERSION}-x64 as native
FROM alerman/docker-compose-base

ARG VERSION
ARG HADOOP_VERSION

ARG CDH_VERSION

ENV HADOOP_PREFIX=/opt/hadoop/hadoop-${HADOOP_VERSION}-cdh${CDH_VERSION}

RUN curl http://archive.cloudera.com/cdh5/cdh/5/hadoop-${HADOOP_VERSION}-cdh${CDH_VERSION}.tar.gz -o /tmp/hadoop.tar.gz && \
    tar xzf /tmp/hadoop.tar.gz -C /opt/hadoop && \
    ln -s $HADOOP_PREFIX /opt/hadoop/current && \
    chown -R hdfs:hdfs /opt/hadoop/current && \
    chown -R hdfs:hdfs $HADOOP_PREFIX && \
    rm -f /tmp/hadoop.tar.gz

RUN yum install -y which bzip2-devel snappy-devel openssl-devel && \
    yum clean all

COPY --from=native /opt/hadoop/native /opt/hadoop/current/lib/native

ENV HADOOP_CONF_DIR=/etc/hadoop
ENV JAVA_HOME=/usr/lib/jvm/jre
ENV MULTIHOMED_NETWORK=1

RUN ln -s $HADOOP_PREFIX/etc/hadoop /etc/hadoop && \
    cp /etc/hadoop/mapred-site.xml.template /etc/hadoop/mapred-site.xml && \
    mkdir $HADOOP_PREFIX/logs && \
    mkdir /hadoop-data

ENV USER=root
ENV PATH $HADOOP_PREFIX/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]