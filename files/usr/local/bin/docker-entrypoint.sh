#!/bin/bash
set -ex;

ls -al /srv/certificates
ls -al /usr/local/bin

# Store password in file and adjust permissions
echo $CERTIFICATES_SERVER_PASSPHRASE > /srv/certificates/server/passphrase.txt
chown keymaster:keymaster /srv/certificates/server/passphrase.txt
chmod 600 /srv/certificates/server/passphrase.txt

# If there is no ca key, init server stuff
if [ ! -f "/srv/certificates/server/server.crt" ]; then
  echo "NO SERVER CERTIFICATE FOUND. GOING TO CREATE ONE..."
  echo "Dini mueter!"
  echo "macht gagi"
  # bash /usr/local/bin/init-server.sh
fi

tail -f /dev/null
