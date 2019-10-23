ARG VERSION
FROM dtspence/hadoop-base:$VERSION

HEALTHCHECK CMD curl -f http://$HOSTNAME:19888/ || exit 1   

EXPOSE 10020
EXPOSE 19888

CMD ["mapred","historyserver"]
