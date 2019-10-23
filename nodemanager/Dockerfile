ARG VERSION
FROM dtspence/hadoop-base:$VERSION

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

EXPOSE 8042

CMD ["yarn","nodemanager"]
