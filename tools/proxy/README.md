# 代理(proxy)

### go-shadowsocks2 

(https://github.com/shadowsocks/go-shadowsocks2)

```bash
# server
go-shadowsocks2 -s 'ss://AEAD_CHACHA20_POLY1305:zhanghang.666@:5488' -verbose
# client
go-shadowsocks2 -c 'ss://AEAD_CHACHA20_POLY1305:zhanghang.666@[IP]:5488' \
    -socks 0.0.0.0:1086 -u -udptun :8053=8.8.8.8:53,:8054=8.8.4.4:53 \
    -tcptun :8053=8.8.8.8:53,:8054=8.8.4.4:53 -verbose
```

### 命令行设置代理

```bash
# Terminal set proxy
export ALL_PROXY=socks5://127.0.0.1:1086
export http_proxy=http://127.0.0.1:1086;https_proxy=https://127.0.0.1:1086
export http_proxy=socks5://127.0.0.1:1086;https_proxy=socks5://127.0.0.1:1086
# Terminal cancel proxy
unset ALL_PROXY http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
```

### SSH 代理

```bash
ssh -o ProxyCommand="nc -X 5 -x 127.0.0.1:1086 %h %p" ubuntu@server.ip
```

### VPN

https://github.com/hwdsl2/setup-ipsec-vpn
https://hub.docker.com/r/hwdsl2/ipsec-vpn-server

```bash
# server
docker-compose up -d
# client
./client.sh
```