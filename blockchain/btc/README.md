# BTC

[build bitcoin by osx](https://github.com/bitcoin/bitcoin/blob/master/doc/build-osx.md)

* 构建比特币核心

```bash
git clone https://github.com/bitcoin/bitcoin
cd bitcoin

# 安装 Berkeley DB (如果不需要钱包功能可以不安装)
./contrib/install_db4.sh .

# When compiling bitcoind, run `./configure` in the following way:

export BDB_PREFIX='$HOME/.bitcoin/db4'
./configure BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" BDB_CFLAGS="-I${BDB_PREFIX}/include" ...

brew install autoconf automake pkg-config libevent

./autogen.sh
./configure BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" BDB_CFLAGS="-I${BDB_PREFIX}/include" --without-gui
./configure --without-gui

# 这个过程可能需要一个小时左右，C的编译速度，呵呵
make
构建并运行单元测试
make check
```

* 搭建比特币测试网络（私有的）

https://hub.docker.com/r/freewil/bitcoin-testnet-box

```bash
docker pull freewill/bitcoin-testnet-box

docker run -t -i -p 19001:19001 -p 19011:19011 freewil/bitcoin-testnet-box

curl --user admin1 --data-binary '{"jsonrpc":"1.0","id":"curltest","method":"getbestblockhash","params":[]}' -H 'content-type:text/plain;' http://127.0.0.1:19001

# 获取一个新的地址
curl --user admin1 --data-binary '{"jsonrpc":"1.0","id":"curltest","method":"getnewaddress","params":[]}' -H 'content-type:text/plain;' http://127.0.0.1:19001

curl --user admin1 --data-binary '{"jsonrpc":"1.0","id":"curltest","method":"sendtoaddress","params":[]}' -H 'content-type:text/plain;' http://127.0.0.1:19001

curl -O https://bitcoin.org/bin/bitcoin-core-0.17.1/bitcoin-0.17.1-osx64.tar.gz

tar -zxvf bitcoin-0.17.1-osx64.tar.gz

sudo cp bitcoin-0.17.1/bin/bitcoin* /usr/local/bin/.

rm -rf bitcoin-0.17.1*
```
