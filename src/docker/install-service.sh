#!/bin/bash

echo Installing Docker in LXC...

apt install -y ca-certificates lsb-release gnupg curl

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update

apt install -y docker-ce docker-ce-cli containerd.io docker-compose docker-compose-plugin

systemctl enable docker

echo 'alias docker-compose="docker compose"' >> /etc/bash.bashrc

echo 
echo Docker in LXC is ready.
