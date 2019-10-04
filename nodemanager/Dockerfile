ARG VERSION
FROM dtspence/hadoop-base:$VERSION

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8042

