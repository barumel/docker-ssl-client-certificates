#!/bin/bash
set -ex;

SSL_CERTS_DIR="$SSL_CA_DIR/certs"
SSL_PRIVATE_DIR="$SSL_CA_DIR/private"
SSL_CRL_DIR="$SSL_CA_DIR/crl"

SSL_CA_CERTIFICATE="$SSL_CERTS_DIR/ca.crt"
SSL_CA_PRIVATE_KEY="$SSL_PRIVATE_DIR/private_ca.key"
SSL_CA_KEY="$SSL_PRIVATE_DIR/ca.key"
SSL_CA_CRL="$SSL_CRL_DIR/ca.crl"

# Create the ca key
openssl genrsa \
  -des3 \
  -out $SSL_CA_PRIVATE_KEY \
  -passout file:/tmp/passphrase.txt 4096

openssl rsa -in $SSL_CA_PRIVATE_KEY -out $SSL_CA_KEY -passin file:/tmp/passphrase.txt

ls -al /etc/ssl/ca
ls -al /etc/ssl/ca/private

# Create the certificate for signing Client Certs
openssl req -new -x509 -days $SSL_SERVER_CERT_DURATION \
  -key $SSL_CA_KEY \
  -out $SSL_CA_CERTIFICATE \
  -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${ORGANIZATIONAL_UNIT}/CN=${COMMON_NAME}" \
  -passin file:/tmp/passphrase.txt

# Create a Certificate Revocation list for removing 'user certificates.'
openssl ca -name CA_default -gencrl \
    -keyfile $SSL_CA_KEY \
    -cert $SSL_CA_CERTIFICATE \
    -out $SSL_CA_CRL \
    -crldays $SSL_SERVER_CERT_DURATION \
    -passin file:/tmp/passphrase.txt
