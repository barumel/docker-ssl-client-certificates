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
RUN mkdir -p /srv/certificates/client
RUN mkdir -p /srv/certificates/server
# Copy files
COPY files /

# Change owner
RUN chown -R keymaster:keymaster /srv/certificates

# Make bin scrips executable
RUN chmod +x /usr/local/bin/*

USER keymaster

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
