ARG VERSION
FROM dtspence/hadoop-base:$VERSION

HEALTHCHECK CMD curl -f http://$HOSTNAME:19888/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 10020
EXPOSE 19888

CMD ["/run.sh"]
