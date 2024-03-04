#!/bin/bash

echo Installing AdGuard Home in LXC...
echo


cd /tmp
curl -LO https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_amd64.tar.gz
curl -LO https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/checksums.txt

sha256sum -c checksums.txt --ignore-missing || exit 1

mkdir /opt/AdGuardHome
tar -vxf AdGuardHome_linux_amd64.tar.gz -C /opt/

rm AdGuardHome_linux_amd64.tar.gz checksums.txt

chown -R root:root /opt/AdGuardHome
chmod -R o-rwx /opt/AdGuardHome

/opt/AdGuardHome/AdGuardHome -s install

systemctl disable systemd-resolved
systemctl stop systemd-resolved

echo 
echo Continue: http://$(hostname -I | xargs):3000
echo 
echo AdGuard Home in LXC is ready.
