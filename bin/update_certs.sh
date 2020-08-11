#!/bin/bash

CERT_PATH=/etc/letsencrypt/live/www.qwertyshoe.com
UNIFI_PATH=/var/lib/unifi
DELUGE_PATH=/home/david/.config/deluge/ssl

PASS=123

### Handle unifi ###
# Generate p12 suitable for importing based off of latest letsencrypt cert
openssl pkcs12 -export -passout pass:$PASS -in $CERT_PATH/cert.pem -inkey $CERT_PATH/privkey.pem -out $CERT_PATH/unifi.p12 -name unifi -CAfile $CERT_PATH/fullchain.pem -caname root
# backup current keystore
mv $UNIFI_PATH/keystore $UNIFI_PATH/keystore.backup
# import certificate into new keystore
keytool -importkeystore -srcstorepass $PASS -deststorepass aircontrolenterprise -destkeypass aircontrolenterprise -destkeystore $UNIFI_PATH/keystore -srckeystore $CERT_PATH/unifi.p12 -srcstoretype PKCS12 -alias unifi
# restart unifi service to apply new cert
service unifi restart

### Handle deluge ###
# Copy letsencrypt cert and private key to suitable path for deluge
cp $CERT_PATH/cert.pem $DELUGE_PATH/qwert.cert.new
cp $CERT_PATH/privkey.pem $DELUGE_PATH/qwert.pkey.new

# change ownership and permissions
chown david:david $DELUGE_PATH/*.new
chmod 600 $DELUGE_PATH/*.new

# back up existing cert and key and rename new cert and key
mv $DELUGE_PATH/qwert.cert $DELUGE_PATH/qwert.cert.bak
mv $DELUGE_PATH/qwert.pkey $DELUGE_PATH/qwert.pkey.bak

mv $DELUGE_PATH/qwert.cert.new $DELUGE_PATH/qwert.cert
mv $DELUGE_PATH/qwert.pkey.new $DELUGE_PATH/qwert.pkey

# Re-start deluge-web service to pick up changes
service deluge-web restart