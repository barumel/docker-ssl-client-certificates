FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive

# Add user
RUN useradd --no-create-home keymaster

# Install dependencies
RUN set -ex; \
  apt-get update; \
  apt-get install -y \
    openssl \
    vim

# Create necessary directories
RUN mkdir -p /srv/certificates/bin
RUN mkdir -p /srv/certificates/client
RUN mkdir -p /srv/certificates/server
# Copy files
COPY files /

# Change owner
RUN chown -R keymaster:keymaster /srv/certificates

# Make bin scrips executable
RUN chmod +x /srv/certificates/bin*

USER keymaster

ENTRYPOINT ["/srv/certificates/bin/docker-entrypoint.sh"]
