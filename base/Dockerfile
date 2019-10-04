FROM alerman/docker-compose-base

ARG CDH_VERSION
ARG HADOOP_VERSION

RUN yum -y install epel-release && \
    rm -rf /var/cache/yum/*

COPY cloudera-cdh.repo /etc/yum.repos.d

RUN rpm --import https://archive.cloudera.com/cm6/6.3.0/redhat7/yum/RPM-GPG-KEY-cloudera 
RUN yum -y install supervisor hadoop && \
    rm -rf /var/cache/yum/*

RUN yum -y install net-tools && \
    rm -rf /var/cache/yum/*

ENV CDH_VERSION=${CDH_VERSION}
ENV HADOOP_PREFIX=/opt/hadoop/hadoop-${HADOOP_VERSION}-cdh${CDH_VERSION}
ENV HADOOP_HOME /usr/lib/hadoop
ENV HADOOP_CONF_DIR /etc/hadoop/conf
ENV HADOOP_COMMON_HOME /usr/lib/hadoop
ENV HADOOP_HDFS_HOME /usr/lib/hadoop-hdfs
ENV HADOOP_YARN_HOME /usr/lib/hadoop-yarn
ENV HADOOP_MAPRED_HOME /usr/lib/hadoop-mapreduce

ENV JAVA_HOME=/usr/lib/jvm/jre
ENV MULTIHOMED_NETWORK=1

RUN ln -s ${HADOOP_PREFIX}/etc/hadoop ${HADOOP_CONF_DIR} && \
    ln -s ${HADOOP_HOME} ${HADOOP_PREFIX}

ENV USER=root
ENV PATH $HADOOP_PREFIX/bin/:$PATH

COPY entrypoint.d/* /entrypoint.d/
ONBUILD COPY entrypoint.d/* /entrypoint.d/

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
