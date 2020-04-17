#!/bin/bash
set -ex;

SSL_CA_DIR="/etc/ssl/ca"
SSL_CERTS_DIR="$SSL_CA_DIR/certs"
SSL_CLIENT_CERTIFICATES_DIR="$SSL_CERTS_DIR/client"
SSL_EXPORTS_DIR="$SSL_CA_DIR/export"

SSL_CA_CERTIFICATE="$SSL_CERTS_DIR/ca.crt"

echo "01" > /etc/ssl/ca/crlnumber
echo $PASSPHRASE > /tmp/passphrase.txt
chown root:root /tmp/passphrase.txt
chmod 600 /tmp/passphrase.txt


# If there is no ca key, init server stuff
if [ ! -f "$SSL_CA_CERTIFICATE" ]; then
  echo "NO CA CRT FOUND. GENERATE...."
  bash /usr/local/bin/create-server-key.sh
fi


# Generate client certificates for all given users
OLD_IFS=$IFS
IFS=',' read -ra clients <<< "$SSL_CLIENT_CERTIFICATES_FOR"
IFS=$OLD_IFS

for client in "${clients[@]}"
do
  if [ ! -f "${SSL_CLIENT_CERTIFICATES_DIR}/${client}.crt" ]; then
    echo "GENERATE CLIENT CERTIFICATE FOR $client"
    bash /usr/local/bin/create-client-cert.sh -u $client -p $SSL_CLIENT_PASSPHRASE
  fi
done

# Make sure all generated certificates are in export folder
cp $SSL_CLIENT_CERTIFICATES_DIR/*.p12 $SSL_EXPORTS_DIR/

exec "$@"
