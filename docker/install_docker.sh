#!/usr/bin/env bash

# shell is funny

# 安装最新版docker
# install docker by ubuntu [https://docs.docker.com/install/linux/docker-ce/ubuntu/]
# export http_proxy=socks5://127.0.0.1:1086;export https_proxy=socks5://127.0.0.1:1086;

if [[ -f $(which docker) ]]; then
    docker version
else
    sudo apt-get update
    sudo apt-get install -y\
          apt-transport-https \
          ca-certificates \
          curl \
          software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
         $(lsb_release -cs) \
         stable"

    sudo apt-get update
    sudo apt-get install -y docker-ce

    # Manage Docker as a non-root user
    sudo groupadd docker
    sudo usermod -aG docker ${USER}
fi

if [[ -f $(which docker-compose) ]]; then
    docker version
else
    # install docker compose https://github.com/docker/compose/releases
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi
