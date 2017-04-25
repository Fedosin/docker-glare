FROM python:2.7
MAINTAINER Mike "mfedosin@gmail.com"

ENV VERSION=master

RUN set -x \
    && apt-get -y update \
    && apt-get install -y libffi-dev python-dev libssl-dev mysql-client python-mysqldb git \
    && apt-get -y clean


RUN mkdir /etc/glare

RUN git clone https://github.com/openstack/glare.git \
    && cd glare \
    && cp etc/glare-paste.ini /etc/glare \
    && echo '{}' > /etc/glare/policy.json \
    && pip install -r requirements.txt \
    && pip install uwsgi MySQL-python \
    && pip install python-glareclient

COPY glare.conf /etc/glare/glare.conf
COPY glare.sql /root/glare.sql

# Add bootstrap script and make it executable
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh && chmod a+x /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]
EXPOSE 9494

HEALTHCHECK --interval=10s --timeout=5s \
  CMD curl -f http://localhost:9494 2> /dev/null || exit 1; \
