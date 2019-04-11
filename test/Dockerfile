ARG VERSION
FROM dtspence/hadoop-base:$VERSION

RUN yum install -y git

RUN cd /tmp && \
    git clone https://github.com/bats-core/bats-core.git && \
    bats-core/install.sh /usr/local && \
    rm -rf bats-core

RUN mkdir -p /var/lib/bats-tests

ADD run.sh /run.sh
RUN chmod a+x /run.sh

ADD *.bats /var/lib/bats-tests/

CMD ["/run.sh"]