#!/bin/bash
set -ex;

# Generate the private key
openssl genpkey \
  -algorithm RSA \
  -pkeyopt rsa_keygen_bits:4096 \
  -aes-128-cbc \
  -out /srv/certificates/server/private.key \
  -passout file:/srv/certificates/server/passphrase.txt

# Extract public key
openssl pkey \
  -in /srv/certificates/server/private.key
  -pubout \
  -out /srv/certificates/server/public.key \
  -passin file:/srv/certificates/server/passphrase.txt


# Create the certificate for signing Client Certs
openssl req \
  -new \
  -x509 \
  -config /srv/certificates/config/server-req.cnf \
  -days $CERTIFICATES_SERVER_CERTIFY_DAYS \
  -key /srv/certificates/server/public.key \
  -out /srv/certificates/server/server.crt \
  -passin file:/srv/certificates/server/passphrase.txt
