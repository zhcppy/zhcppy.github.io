# MongoDB

MongoDB 是一个文档数据库，提供好的性能，领先的非关系型数据库，采用BSON存储文档数据

任何属性都可以建立索引

复杂以及高可扩展性

自动分片

丰富的查询功能

快速的即时更新

mongod 是处理MongoDB系统的主要进程，处理数据请求，管理数据存储，和执行后台管理操作

非关系型数据库是对不同于传统关系型数据库的统称，非关系型数据库的显著特点是不实用SQL作为查询语言，数据存储不需要特定的表格模式。

不需要转化/映射应用对象到数据库对象。

分片是将数据水平切分到不同的物理节点，当应用数据越来越大的时候，数据量也会越来越大，当数据量增长时，单台机器有可能无法存储数据或可接受的读取写入吞吐量，利用分片技术可以添加更多的机器来应对数据量增加以及读写操作的要求。:


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

