#!/bin/bash
set -ex;

echo "01" > /etc/ssl/ca/crlnumber
# Store password in file and adjust permissions
echo $CERTIFICATES_SERVER_PASSPHRASE > /srv/certificates/server/passphrase.txt
chown keymaster:keymaster /srv/certificates/server/passphrase.txt
chmod 600 /srv/certificates/server/passphrase.txt

# If there is no ca key, init server stuff
if [ ! -f "/srv/certificates/server/server.crt" ]; then
  echo "NO SERVER CERTIFICATE FOUND. GOING TO CREATE ONE..."
  bash /srv/certificates/bin/init-server.sh
fi
