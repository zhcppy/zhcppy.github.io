# Parity 

### Ethereum Kovan

* 部署以太坊`Kovan`测试网节点

```shell script
parity daemon -c ~/.local/share/openethereum/config.toml
```

* 关于安全

```shell script
# 给安全组设置白名单
iptables -I INPUT -p tcp --dport 8545 -j DROP
iptables -I INPUT -p tcp --dport 8546 -j DROP
iptables -I INPUT -s 172.31.1.100 -p tcp --dport 8545 -j ACCEPT
iptables -I INPUT -s 172.31.1.100 -p tcp --dport 8546 -j ACCEPT
```

* 关于流量
    
虽然是测试网节点，但如果不加以控制，p2p层会消耗大量的流量，对用按量计费的服务器来说，每个月可能会需要将近千刀的费用
1. 控制 peer 节点数量； 
2. 禁止 light peers 连接； 
3. 禁用节点发现；
    
流量监控工作 `nethogs`

```shell script
sudo nethogs ens5
```

`nethogs` 用法

```
m  切换显示模式(kb/s, kb, b, mb)
r  根据接收流量排序  
s  根据发送流量排序 
q  退出
```

* [配置生成器](https://paritytech.github.io/parity-config-generator)

```config
# This config should be placed in following path:
#   ~/.local/share/openethereum/config.toml

[parity]
# Kovan Test Network
chain = "kovan"
# You will be identified as 'cppy' amongst other nodes..
identity = "cppy"

[rpc]
#  JSON-RPC will be listening for connections on IP 0.0.0.0.
interface = "0.0.0.0"
# Allows Cross-Origin Requests from domain 'all'.
cors = ["all"]
# Allow connections only using specified addresses.
hosts = ["all"]
# Only selected APIs will be exposed over this interface.
apis = ["web3", "eth", "net", "rpc"]

[websockets]
#  JSON-RPC will be listening for connections on IP 0.0.0.0.
interface = "0.0.0.0"
# Allows connecting from Origin 'all'.
origins = ["all"]
# Allow connections only using specified addresses.
hosts = ["all"]
# Only selected APIs will be exposed over this interface.
apis = ["web3", "eth", "pubsub", "net", "rpc"]

[ipc]
# You won't be able to use IPC to interact with Parity.
disable = false
# Only selected APIs will be exposed over this interface.
apis = ["web3", "eth", "pubsub", "net", "parity", "parity_pubsub", "parity_accounts", "traces", "rpc", "shh", "shh_pubsub", "parity_transactions_pool", "parity_set"]

[dapps]
disable = true

[secretstore]
# You won't be able to encrypt and decrypt secrets.
disable = true

[misc]
# Logging pattern (`<module>=<level>`, e.g. `own_tx=trace`).
#logging = "sync=debug,rpc=trace"
# Logs will be stored at parity.log.
log_file = "/home/ubuntu/.local/share/openethereum/parity.log"

[network]
# Parity will try to maintain connection to at least 3 peers.
min_peers = 3
# Parity will maintain at most 5 peers.
max_peers = 5
# Parity will allow up to 10 pending connections.
max_pending_peers = 5
# Enable or disable new peers discovery.
discovery = false
# Disable serving light peers.
no_serve_light = true
```
