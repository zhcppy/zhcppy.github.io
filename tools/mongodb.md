# MongoDB

* Mac install 

```bash
# 如果有安装旧版本，就先删除tap
brew untap mongodb/brew
# 添加最新的tap
brew tap mongodb/brew
# 安装MongoDB
brew install mongodb-community@4.2
# 要将MongoDB作为macOS服务运行
brew services start mongodb-community@4.2
# 将MongoDB作为后台进程手动运行
mongod --config /usr/local/etc/mongod.conf --fork
```

* Ubuntu install 

```bash
lsb_release -dc

ps --no-headers -o comm 1

https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -

# Ubuntu 16.04 (Xenial)
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
# Ubuntu 18.04 (Bionic)
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

sudo apt-get update

sudo apt-get install -y mongodb-org
```

