## 配置 Docker Daemon TLS 远程访问

### 生成证书

* 生成CA私钥

Password: 123456

```bash
openssl genrsa -aes256 -out ca-key.pem 4096
```

* 生成CA证书

Country Name: CN  
State or Province Name: Guangzhou  
Locality Name: Shenzhen  
Organization Name: China  
Organizational Unit Name: zhcppy  

```bash
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
```

* 生成服务器端私钥

```bash
openssl genrsa -out server-key.pem 4096
```

* 生成服务器请求证书

```bash
openssl req -sha256 -new -key server-key.pem -out server.csr
```

* 生成服务器证书

```bash
echo extendedKeyUsage = serverAuth >> extfile.cnf
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem \
  -CAcreateserial -out server-cert.pem -extfile extfile.cnf
```

* 生成客户端私钥

```bash
openssl genrsa -out key.pem 4096
```

* 生成客户端请求证书

```bash
openssl req -new -key key.pem -out client.csr
```

* 生成客户端证书

```bash
echo extendedKeyUsage = clientAuth > extfile-client.cnf
openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem \
  -CAcreateserial -out cert.pem -extfile extfile-client.cnf
```

### 服务器环境配置

```bash
#!/usr/bin/env bash

# shell is funny

#sudo apt-get install language-pack-zh

# sudo locale-gen zh_CN.UTF-8

# 安装 docker
./install_docker.sh

sudo touch /etc/docker/daemon.json

cat << EOF | sudo tee -a /etc/docker/daemon.json
{
  "debug": true,
  "experimental": false,
  "hosts": ["unix:///var/run/docker.sock", "tcp://0.0.0.0:2376"],
  "tls": true,
  "tlsverify": true,
  "tlscacert": "/home/ubuntu/.docker/server/ca.pem",
  "tlscert": "/home/ubuntu/.docker/server/cert.pem",
  "tlskey": "/home/ubuntu/.docker/server/key.pem",
  "registry-mirrors": [],
  "insecure-registries": []
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d

sudo touch /etc/systemd/system/docker.service.d/docker.conf

cat << EOF | sudo tee -a /etc/systemd/system/docker.service.d/docker.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOF

mkdir -p ~/.docker/server

cp server/ca.pem ~/.docker/server/ca.pem
cp server/cert.pem ~/.docker/server/cert.pem
cp server/key.pem ~/.docker/server/key.pem
cp client/ca.pem ~/.docker/ca.pem
cp client/cert.pem ~/.docker/cert.pem
cp client/key.pem ~/.docker/key.pem

sudo systemctl daemon-reload

sudo systemctl restart docker

sudo systemctl status docker

docker --tls -H 127.0.0.1:2376 ps
docker --tls -H 0.0.0.0:2376 ps

```

### 客户端环境配置

* 首先配置本地证书

```bash
mkdir -p $HOME/.docker
cp docker/client/* $HOME/.docker/
```

* 然后就可以访问了(这样就不需要ssh上服务器了)

```bahs
docker -tls -H <服务器IP>:2376 ps
docker -tls -H <服务器IP>:2376 logs -f mysql
```
