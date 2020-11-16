# Ethereum

* [以太坊文档](http://ethdoc.cn/)
* [白皮书](https://github.com/ethereum/wiki/wiki/White-Paper)
* [开发环境安装](https://github.com/ethereum/homebrew-ethereum)

* 源码构建以太坊

```bash
git clone https://github.com/ethereum/go-ethereum
# 会在build/bin下面生成很多工具
make all
```

* 以太坊智能合约开发语言:[solidity](https://solidity-cn.readthedocs.io/zh/develop/)

* 以太坊智能合约在线编辑器:[remix-ide](https://remix.ethereum.org)：



* 创世纪文件

```json
{
  "config": {
    "chainId": 343,
    "homesteadBlock": 1,
    "eip150Block": 2,
    "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "eip155Block": 3,
    "eip158Block": 3,
    "byzantiumBlock": 4,
    "clique": {
      "period": 1,
      "epoch": 30000
    }
  },
  "nonce": "0x0",
  "timestamp": "0x5b8e956c",
  "extraData": "",
  "gasLimit": "0x47b760",
  "difficulty": "0x1",
  "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "alloc": {}
}
```

mixhash	与nonce配合用于挖矿，由上一个区块的一部分生成的hash。注意他和nonce的设置需要满足以太坊的Yellow paper, 4.3.4. Block Header Validity, (44)章节所描述的条件。
nonce	nonce就是一个64位随机数，用于挖矿，注意他和mixhash的设置需要满足以太坊的Yellow paper, 4.3.4. Block Header Validity, (44)章节所描述的条件。
difficulty	设置当前区块的难度，如果难度过大，cpu挖矿就很难，这里设置较小难度
alloc	用来预置账号以及账号的以太币数量，因为私有链挖矿比较容易，所以我们不需要预置有币的账号，需要的时候自己创建即可以。
coinbase	矿工的账号，随便填
timestamp	设置创世块的时间戳
parentHash	上一个区块的hash值，因为是创世块，所以这个值是0
extraData	附加信息，随便填，可以填你的个性信息
gasLimit	该值设置对GAS的消耗总量限制，用来限制区块能包含的交易信息总和，因为我们是私有链，所以填最大。

* 种子节点 
bootnode P2P发现引导，只是做一个连接节点的基本功能，只是做节点发现不做其他的验证或更高层的应用协议。
每个node被enode唯一标识，enode identifier来源一个Key。
以太坊节点启动时需要告知至少一个节点才可以接入整个以太坊网络。bootNode相当于一个第三方的中介，
node在启动时会将自己的信息注册到BootNode的路由中，并且会从bootNode得到其他节点的路由信息，
一旦有了对等信息后就不需要连接到bootNode。

```bash
# 创建key
bootnode --genkey=boot.key
# 启动 
bootnode --nodekey=boot.key
```

节点间要建立有效连接，当且仅当节点间有着相同版本的协议和网络ID(networkid)。
所以，要想加入已有私链，首先拿到同样的genesis.json创建创世块，然后使用相同的networkid启动节点。

```bash
geth --identity "nodeName"  --datadir chain1 init CustomGenesis.json
geth --identity "nodeName"  --datadir chain1 --port "30303" --nodiscover console

```

* geth console

console进入的控制台是一个交互式的JavaScript执行环境，在这里面可以执行JavaScript代码。
这个环境里也内置了一些用来操作以太坊的JavaScript对象，例如

+ eth：包含一些跟操作区块链相关的方法；
+ net：包含一些查看p2p网络状态的方法；
+ admin：包含一些与管理节点相关的方法；
+ miner：包含启动&停止挖矿的一些方法；
+ personal：主要包含一些管理账户的方法；
+ txpool：包含一些查看交易内存池的方法；
+ web3：包含了以上对象，还包含一些单位换算的方法。

常见命令有：

- personal.newAccount()：创建账户；
- personal.unlockAccount()：解锁账户；
- eth.accounts：枚举系统中的账户；
- eth.getBalance()：查看账户余额，返回值的单位是 Wei（Wei 是以太坊中最小货币面额单位，类似比特币中的`聪`，1 ether = 10^18 Wei）；
- eth.blockNumber：列出区块总数；blockNumber为eth的属性，直接查看即可
- eth.getTransaction()：获取交易；
- eth.getBlock()：获取区块；如eth.getBlock("pending", true).transactions 查看当前待确认交易。或通过区块号查看eth.getBlock(4)
- miner.setEtherbase(eth.accounts[0]) 设置挖矿收益地址 
- miner.start()：开始挖矿；
- miner.stop()：停止挖矿；
- web3.fromWei()：Wei 换算成以太币；
- web3.toWei()：以太币换算成 Wei；如amount = web3.toWei(5,'ether')
- txpool.status：交易池中的状态；
- admin.addPeer()：连接到其他节点；

geth attach 附加额外的geth console实例

```bash
# 启动JSON RPC
geth --rpc --rpcaddr < ip > --rpcport < portnumber >
geth console ==> admin.startRPC(addr, port)
# curl 访问geth
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_coinbase","params":[],"id":64}' localhost:8545
```

### 智能合约

从智能合约的代码到使用智能合约，大概包含以下步骤

+ 编写智能合约的代码(一般是用Solidity)
+ 编译智能合约的代码变成可在EVM上执行的bytecode(binary code)，同时可以通过编译取得智能合约的ABI
+ 部署智能合约，实际上是吧bytecode存储在链上(通过一个transaction)，并取得一个专属于这个合约的地址
+ 要调用合约，需要把信息发送到这个合约的地址，一样也是通过transaction，以太坊节点会根据输入的信息，选择要执行合约中的哪一个function和要输入的参数

##### 智能合约ABI

ABI，application binary interface，顾名思义，同样是接口，但传递的是binary格式的信息。

ABI理解如下

Function:

+ `name`：a string, 方法名
+ `type`:  a string，"function", "constructor", or "fallback"，方法类型
+ `inputs`:  an array，方法参数，每个参数的格式为
  - `name`：a string，参数名
  - `type`：a string，参数的 data type(e.g. uint256)
  - `components`：an array，如果输入的参数是 tuple(struct) type 才会有这个参数。描述 struct 中包含的参数类型
+ `outputs`：an array， 方法返回值，和 `inputs` 使用相同表示方式。如果沒有返回值可忽略，值为 `[]`
+ `payable`：`true`，function 是否可收 Ether，预设为 `false`
+ `constant`：`true`，function 是否会改写区块链状态，反之为 `false`
+ `stateMutability`：a string，其值可能为以下其中之一："pure"（不会读写区块链状态）、"view"（只读不写区块链状态）、"payable" and "nonpayable"（会改区块链状态，且如可收 Ether 为 "payable"，反之为 "nonpayable"）

仔细看会发现 `payable` 和 `constant` 这两个参数所描述的內容，似乎已包含在 `stateMutability` 中。

Event:

+ `name`: a string，event 的名称
+ `type`: a string，always "event"
+ `inputs`: an array，输入参数，包含：
  - `name`: a string，参数名称
  - `type`: a string，参数的 data type(e.g. uint256)
  - `components`: an array，如果输入参数是 tuple(struct) type 才会有这个参数。描述 struct 中包含的信息类型
  - `indexed`: `true`，如果这个参数被定义为 indexed ，反之为 `false`
+ `anonymous`: `true`，如果 event 被定义为 anonymous

更新智能合约状态需要发送 transaction，transaction 需要等待验证，所以更新合约状态是非同步的，无法马上取得返回值。使用 Event 可以在状态更新成功后，将相关信息记录到 Log，并让监听这个 Event 的 DApp 或任何应用这个接口的程序收到通知。每笔 transaction 都有对应的 Log。

所以简单来说，Event 可用來：1. 取得 function 更新合约状态的返回值 2. 也可作为合约另外的存储空间。

Event 的参数分为：有 `indexed`，和其他没有 `indexed` 的。有 `indexed` 的参数可以使用 filter，例如同一个 Event，我可以选择只监听从特定 address 发出来的交易。每笔 Log 的信息同样分为两个部分：Topics（长度最多为 4 的 array） 和 Data。有 `anonymous` 的参数会存储存在 Log 的 Topics，其他的存在 Data。

##### ERC

[更多 ERC](erc-standard.md)
