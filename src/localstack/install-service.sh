#!/bin/bash

set -euo pipefail

log=/var/run/log/localstack.log

# this docker install no longer needed after localstack runtime install is working
echo ----
apt install -y ca-certificates lsb-release gnupg curl

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update

apt install -y docker-ce docker-ce-cli containerd.io docker-compose docker-compose-plugin

systemctl enable docker

echo 'alias docker-compose="docker compose"' >> /etc/bash.bashrc
echo ---



echo Installing Local stack in the LXC...

echo 'export PATH=/usr/local/bin:$PATH' >> /etc/bash.bashrc

mkdir ~/.localstack && \
    echo "GATEWAY_LISTEN=0.0.0.0:4566" > ~/.localstack/network.env

sudo apt install -y python3-pip libsasl2-dev jq

python3 -m pip install localstack==3.4.0

nohup /usr/local/bin/localstack --profile=network start >> ${log} &


#curl localhost:4566/health | jq
#curl http://localhost:4566/_localstack/info | jq
echo logging in lxc: ${log}


echo '
Aws cli configuration tip:
aws configure --profile localstack set aws_access_key_id test
aws configure --profile localstack set aws_secret_access_key test
aws configure --profile localstack set region eu-north-1

alias aws="aws --profile localstack --endpoint-url=http://localstack.local:4566 "
'

echo 
echo Local stack in the LXC is ready.
