#!/bin/bash

set -euo pipefail

# Authors:
# (C) 2021 Idea an concept by Christian Zengel <christian@sysops.de>
# (C) 2021 Script design and prototype by Markus Helmke <m.helmke@nettwarker.de>
# (C) 2021 Script rework and documentation by Thorsten Spille <thorsten@spille-edv.de>

source /root/functions.sh
source /root/zamba.conf
source /root/constants-service.conf

apt update && sudo apt-get install ca-certificates apt-transport-https

wget -qO - https://www.mongodb.org/static/pgp/server-3.6.asc | sudo apt-key add -
wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg

echo "deb [trusted=yes] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
echo 'deb [ arch=amd64,arm64 ] https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/unifi.list 

apt update

# fix java certs
mkdir -p /etc/ssl/certs/java/
sudo apt install --reinstall -o Dpkg::Options::="--force-confask,confnew,confmiss" --reinstall ca-certificates-java ssl-cert openssl ca-certificates

DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt install -y -qq unifi

echo 
echo Continue: http://$(hostname -I | xargs):8443
echo 
echo UniFi Network Server in LXC is ready.
