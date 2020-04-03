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

