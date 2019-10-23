ARG VERSION
FROM dtspence/hadoop-base:$VERSION

HEALTHCHECK CMD netstat -an | grep 9864 > /dev/null; if [ 0 != $? ]; then exit 1; fi;

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

EXPOSE 9864-9867

CMD ["hdfs","datanode"]
