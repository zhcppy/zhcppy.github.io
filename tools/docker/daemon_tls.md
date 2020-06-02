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
Organization Name: Pundix  
Organizational Unit Name: FX  

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

sudo locale-gen zh_CN.UTF-8

sudo apt-get update

sudo apt-get upgrade -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update

sudo apt-get install docker-ce -y

sudo groupadd docker

sudo usermod -aG docker ${USER}

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

curl -k -u nash:${PASSWORD} -o ~/.docker/server/ca.pem  https://git.wokoworks.com:4430/blockchain/cloud-backend/raw/8200f15c2403fe3980326f44f4d94ac19af332d0/aws/docker/server/ca.pem
curl -k -u nash:${PASSWORD} -o ~/.docker/server/cert.pem https://git.wokoworks.com:4430/blockchain/cloud-backend/raw/8200f15c2403fe3980326f44f4d94ac19af332d0/aws/docker/server/cert.pem
curl -k -u nash:${PASSWORD} -o ~/.docker/server/key.pem https://git.wokoworks.com:4430/blockchain/cloud-backend/raw/8200f15c2403fe3980326f44f4d94ac19af332d0/aws/docker/server/key.pem
curl -k -u nash:${PASSWORD} -o ~/.docker/ca.pem https://git.wokoworks.com:4430/blockchain/cloud-backend/raw/8200f15c2403fe3980326f44f4d94ac19af332d0/aws/docker/client/ca.pem
curl -k -u nash:${PASSWORD} -o ~/.docker/cert.pem https://git.wokoworks.com:4430/blockchain/cloud-backend/raw/8200f15c2403fe3980326f44f4d94ac19af332d0/aws/docker/client/cert.pem
curl -k -u nash:${PASSWORD} -o ~/.docker/key.pem https://git.wokoworks.com:4430/blockchain/cloud-backend/raw/8200f15c2403fe3980326f44f4d94ac19af332d0/aws/docker/client/key.pem

sudo systemctl daemon-reload

sudo systemctl restart docker

sudo systemctl status docker

docker --tls -H 127.0.0.1:2376 ps
docker --tls -H 0.0.0.0:2376 ps

#docker --tls -H 0.0.0.0:2376 exec -it fx-mysql mysql -uroot -p12345678

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