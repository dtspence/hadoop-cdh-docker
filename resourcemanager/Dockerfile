ARG VERSION
FROM dtspence/hadoop-base:$VERSION

HEALTHCHECK CMD curl -f http://localhost:8088/ || exit 1

EXPOSE 8088

CMD ["yarn","resourcemanager"]
