#!/usr/bin/env bash

# shell is funny

# 部署以太坊仪表盘
# 它由三部分构成：
# 1 以太坊节点 -> geth
# 2 仪表盘前端 -> eth-netstats
# 3 连接以太坊客户端(一个以太坊对应一个客户端) -> eth-net-intelligence-api

mkdir -p netstats
work_path=`pwd`/netstats

# install nodejs
if [[ ! -f $(which node 2>/dev/null) ]];then
    curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# install npm
if [[ ! -f $(which npm 2>/dev/null) ]];then sudo apt-get install -y npm; fi

# install pm2
if [[ ! -f $(which pm2 2>/dev/null) ]];then sudo npm install -g pm2; fi

cd ${work_path}
git clone https://github.com/cubedro/eth-net-intelligence-api
cd ./eth-net-intelligence-api
npm install
#vim app.json

cd ${work_path}
git clone https://github.com/cubedro/eth-netstats
cd ./eth-netstats
npm install
sudo npm install -g grunt-cli
grunt

pm2_config='[
  {
    "name": "netstats-app",
    "cwd": "eth-netstats",
    "script": "bin/www",
    "log_date_format": "YYYY-MM-DD HH:mm Z",
    "merge_logs": false,
    "watch": false,
    "exec_interpreter": "node",
    "exec_mode": "fork_mode",
    "env": {
      "PORT": "3000",
      "WS_SECRET": "hello"
    }
  },
  {
    "name": "node001",
    "cwd": "eth-net-intelligence-api",
    "script": "app.js",
    "log_date_format": "YYYY-MM-DD HH:mm Z",
    "merge_logs": false,
    "watch": false,
    "exec_interpreter": "node",
    "exec_mode": "fork_mode",
    "env": {
      "NODE_ENV": "production",
      "RPC_HOST": "172.31.78.182",
      "RPC_PORT": "8510",
      "LISTENING_PORT": "30310",
      "INSTANCE_NAME": "node001",
      "WS_SERVER": "http://localhost:3000",
      "WS_SECRET": "hello"
    }
  },
  {
    "name": "node002",
    "cwd": "eth-net-intelligence-api",
    "script": "app.js",
    "log_date_format": "YYYY-MM-DD HH:mm Z",
    "merge_logs": false,
    "watch": false,
    "exec_interpreter": "node",
    "exec_mode": "fork_mode",
    "env": {
      "NODE_ENV": "production",
      "RPC_HOST": "172.31.79.94",
      "RPC_PORT": "8510",
      "LISTENING_PORT": "30310",
      "INSTANCE_NAME": "node002",
      "WS_SERVER": "http://localhost:3000",
      "WS_SECRET": "hello"
    }
  },
  {
    "name": "node003",
    "cwd": "eth-net-intelligence-api",
    "script": "app.js",
    "log_date_format": "YYYY-MM-DD HH:mm Z",
    "merge_logs": false,
    "watch": false,
    "exec_interpreter": "node",
    "exec_mode": "fork_mode",
    "env": {
      "NODE_ENV": "production",
      "RPC_HOST": "172.31.79.75",
      "RPC_PORT": "8510",
      "LISTENING_PORT": "30310",
      "INSTANCE_NAME": "node003",
      "WS_SERVER": "http://localhost:3000",
      "WS_SECRET": "hello"
    }
  }
]
'

cd ${work_path}
echo -n "${pm2_config}" > processes.json

pm2 start processes.json