#!/bin/bash

# Set some sensible defaults
export CORE_CONF_fs_defaultFS=${CORE_CONF_fs_defaultFS:-hdfs://`hostname -f`:8020}

function addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

function configure() {
    local path=$1
    local module=$2
    local envPrefix=$3

    local var
    local value
    
    echo "Configuring $module"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do 
        name=`echo ${c} | perl -pe 's/___/-/g; s/__/@/g; s/_/./g; s/@/_/g;'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addProperty /etc/hadoop/conf/$module-site.xml $name "$value"
    done
}

configure /etc/hadoop/conf/core-site.xml core CORE_CONF
configure /etc/hadoop/conf/hdfs-site.xml hdfs HDFS_CONF
configure /etc/hadoop/conf/mapred-site.xml mapred MAPRED_CONF
configure /etc/hadoop/conf/yarn-site.xml yarn YARN_CONF
configure /etc/hadoop/conf/httpfs-site.xml httpfs HTTPFS_CONF
configure /etc/hadoop/conf/kms-site.xml kms KMS_CONF

if [ "$MULTIHOMED_NETWORK" = "1" ]; then
    echo "Configuring for multihomed network"

    # HDFS
    addProperty /etc/hadoop/conf/hdfs-site.xml dfs.namenode.rpc-bind-host 0.0.0.0
    addProperty /etc/hadoop/conf/hdfs-site.xml dfs.namenode.servicerpc-bind-host 0.0.0.0
    addProperty /etc/hadoop/conf/hdfs-site.xml dfs.namenode.http-bind-host 0.0.0.0
    addProperty /etc/hadoop/conf/hdfs-site.xml dfs.namenode.https-bind-host 0.0.0.0
    addProperty /etc/hadoop/conf/hdfs-site.xml dfs.client.use.datanode.hostname true
    addProperty /etc/hadoop/conf/hdfs-site.xml dfs.datanode.use.datanode.hostname true

    # YARN
    addProperty /etc/hadoop/conf/yarn-site.xml yarn.resourcemanager.bind-host 0.0.0.0
    addProperty /etc/hadoop/conf/yarn-site.xml yarn.nodemanager.bind-host 0.0.0.0
    addProperty /etc/hadoop/conf/yarn-site.xml yarn.nodemanager.bind-host 0.0.0.0
    addProperty /etc/hadoop/conf/yarn-site.xml yarn.timeline-service.bind-host 0.0.0.0

    # MAPRED
    addProperty /etc/hadoop/conf/mapred-site.xml yarn.nodemanager.bind-host 0.0.0.0
fi

if [ -n "$GANGLIA_HOST" ]; then
    mv /etc/hadoop/conf/hadoop-metrics.properties /etc/hadoop/conf/hadoop-metrics.properties.orig
    mv /etc/hadoop/conf/hadoop-metrics2.properties /etc/hadoop/conf/hadoop-metrics2.properties.orig

    for module in mapred jvm rpc ugi; do
        echo "$module.class=org.apache.hadoop.metrics.ganglia.GangliaContext31"
        echo "$module.period=10"
        echo "$module.servers=$GANGLIA_HOST:8649"
    done > /etc/hadoop/conf/hadoop-metrics.properties
    
    for module in namenode datanode resourcemanager nodemanager mrappmaster jobhistoryserver; do
        echo "$module.sink.ganglia.class=org.apache.hadoop.metrics2.sink.ganglia.GangliaSink31"
        echo "$module.sink.ganglia.period=10"
        echo "$module.sink.ganglia.supportsparse=true"
        echo "$module.sink.ganglia.slope=jvm.metrics.gcCount=zero,jvm.metrics.memHeapUsedM=both"
        echo "$module.sink.ganglia.dmax=jvm.metrics.threadsBlocked=70,jvm.metrics.memHeapUsedM=40"
        echo "$module.sink.ganglia.servers=$GANGLIA_HOST:8649"
    done > /etc/hadoop/conf/hadoop-metrics2.properties
fi

# Execute scripts in the directory on entry

DIR=/entrypoint.d

if [[ -d "${DIR}" ]]
then
  echo "Running run-parts ..."
  /bin/run-parts "${DIR}"
fi

if [ -z "$1" ]; then
  exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
else
  exec $@
fi

exec $@
