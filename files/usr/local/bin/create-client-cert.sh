#!/bin/bash
set -ex

SSL_CERTS_DIR="$SSL_CA_DIR/certs"
SSL_PRIVATE_DIR="$SSL_CA_DIR/private"
SSL_CRL_DIR="$SSL_CA_DIR/crl"
SSL_CLIENT_CERTIFICATES_DIR="$SSL_CERTS_DIR/client"

SSL_CA_CERTIFICATE="$SSL_CERTS_DIR/ca.crt"
SSL_CA_PRIVATE_KEY="$SSL_PRIVATE_DIR/private_ca.key"
SSL_CA_KEY="$SSL_PRIVATE_DIR/ca.key"
SSL_CA_CRL="$SSL_CRL_DIR/ca.crl"

SSL_EXPORTS_DIR="$SSL_CA_DIR/export"


ls -al $SSL_CERTS_DIR
ls -al $SSL_CLIENT_CERTIFICATES_DIR

display_help() {
  echo "Usage: "
  echo "-h / --help:        Show this message"
  echo "-u / --user:        Username"
  echo "-p / --passphrase:  Passph  rase for this certificate"
}

if [ "$1" == "-h" -o "$1" == "--help" ]; then
  display_help
  exit 0
fi

if [ "$#" -ne 4 ]; then
  echo "You did not pass all required arguments!"
  display_help
  exit 1;
fi

if [ "$1" == "-u" -o "$1" == "--user" ]; then
  USER=$2
  PASSPHRASE=$4
else
  USER=$4
  PASSPHRASE=$2
fi

# Create the Client Key and CSR
openssl genrsa \
  -des3 \
  -out $SSL_CLIENT_CERTIFICATES_DIR/${USER}.key \
  -passout pass:${PASSPHRASE} 4096

openssl req \
  -new \
  -key $SSL_CLIENT_CERTIFICATES_DIR/${USER}.key \
  -out $SSL_CLIENT_CERTIFICATES_DIR/${USER}.csr \
  -passin pass:${PASSPHRASE} \
  -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${USER}/OU=${ORGANIZATIONAL_UNIT}/CN=${USER}"


#  -CAserial /etc/ssl/ca/crlnumber \
#  -CAcreateserial \

# Sign the client certificate with our CA cert.
openssl x509 \
  -req \
  -days $SSL_CLIENT_CERT_DURATION \
  -in $SSL_CLIENT_CERTIFICATES_DIR/${USER}.csr \
  -CA $SSL_CA_CERTIFICATE \
  -CAkey $SSL_CA_KEY \
  -set_serial 01 \
  -out $SSL_CLIENT_CERTIFICATES_DIR/${USER}.crt \
  -passin file:/tmp/passphrase.txt

echo "making p12 file"
#browsers need P12s (contain key and cert)
openssl pkcs12 \
  -export \
  -clcerts \
  -in $SSL_CLIENT_CERTIFICATES_DIR/${USER}.crt \
  -inkey $SSL_CLIENT_CERTIFICATES_DIR/${USER}.key \
  -out $SSL_CLIENT_CERTIFICATES_DIR/${USER}.p12 \
  -passin pass:${PASSPHRASE} \
  -passout pass:${PASSPHRASE}

cp $SSL_CLIENT_CERTIFICATES_DIR/${USER}.p12 $SSL_EXPORTS_DIR

echo "Created /etc/ssl/export/${USER}.p12"
