FROM alpine:latest

ENV PASSPHRASE MwpHtTSDaEcAxkXGQyPtaGm5
ENV COUNTRY CH
ENV STATE Neuchatel
ENV LOCALITY La Sagne
ENV ORGANIZATION Example Org
ENV ORGANIZATIONAL_UNIT Example Unit
ENV COMMON_NAME example.ch
ENV SSL_CLIENT_CERTIFICATES_FOR foo,bar
ENV SSL_SERVER_CERT_DURATION 365
ENV SSL_CLIENT_CERT_DURATION 365
ENV SSL_CLIENT_PASSPHRASE Ku7vLMPdWEpcJsZMGgqHmyKg
ENV SSL_CA_DIR /etc/ssl/ca

RUN mkdir -p /tmp/export
RUN mkdir -p /etc/ssl/ca
RUN mkdir -p /etc/ssl/ca/private
RUN mkdir -p /etc/ssl/ca/certs
RUN mkdir -p /etc/ssl/ca/certs/client
RUN mkdir -p /etc/ssl/ca/crl
RUN mkdir -p /etc/ssl/ca/new-certs
RUN mkdir -p /etc/ssl/ca/export

RUN touch /etc/ssl/ca/index.txt

RUN set -ex; \
  apk update; \
  apk add \
    openssl \
    bash \
    vim

COPY files /

RUN chmod +x /usr/local/bin/*

RUN ls -al /usr/local/bin

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD tail -f /dev/null
